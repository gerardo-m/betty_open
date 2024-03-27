import 'package:betty/models/profile.dart';
import 'package:betty/repositories/profile_repository.dart';
import 'package:betty/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileRepositoryFirebase extends ProfileRepository {
  late final FirebaseFirestore firestore;
  late final FirebaseAuth firebaseAuth;

  static const String _usersCollectionName = 'users';

  factory ProfileRepositoryFirebase() {
    return ProfileRepositoryFirebase._();
  }

  ProfileRepositoryFirebase._() {
    firestore = FirebaseFirestore.instance;
    firebaseAuth = FirebaseAuth.instance;
  }

  @override
  Future<Profile?> getCurrentUserProfile() async {
    User? user = firebaseAuth.currentUser;
    if (user != null) {
      //QueryDocumentSnapshot? doc = await _getUserByUid(user.uid);
      DocumentSnapshot doc = await firestore.collection(_usersCollectionName).doc(user.uid).get();
      if (!doc.exists) return null;
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Profile(
        id: doc.id,
        name: data['name'],
        identifier: data['identifier'],
        authenticationMethod: user.isAnonymous ? AuthenticationMethod.anonymous : AuthenticationMethod.google,
      );
    }
    return null;
  }

  @override
  Future<Profile?> createUserProfile(Profile newProfile) async {
    User? user = firebaseAuth.currentUser;
    if (user == null) return null;
    String uid = user.uid;
    if (newProfile.authenticationMethod == AuthenticationMethod.google){
      newProfile.name = user.displayName ?? '';
      newProfile.identifier = user.email ?? '';
    }
    final userData = <String, dynamic>{
      "name": newProfile.name,
      "identifier": newProfile.identifier,
    };
    await firestore.collection(_usersCollectionName).doc(uid).set(userData);
    //DocumentReference doc = await firestore.collection(_usersCollectionName).add(userData);
    newProfile.id = uid;
    return newProfile;
  }

  @override
  Future<List<Profile>> searchProfilesByIdentifier(String identifier) async {
    List<Profile> list = [];
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection(_usersCollectionName)
        .where('identifier', isGreaterThanOrEqualTo: identifier)
        .where('identifier', isLessThan: '$identifier\uf8ff')
        .limit(20)
        .get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docs) {
      Map<String, dynamic> data = doc.data();
      list.add(Profile(
          id: doc.id,
          name: doc['name'],
          identifier: data['identifier'],
          authenticationMethod: AuthenticationMethod.anonymous));
    }
    return list;
  }
  
  @override
  Future<bool> userIdentifierExists(String identifier) async{
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore.collection(_usersCollectionName).where('identifier', isEqualTo: identifier).get();
    return snapshot.docs.isNotEmpty;
  }
  
  @override
  Future<void> signInAnonymously() async{
     await firebaseAuth.signInAnonymously();
  }
  
  @override
  Future<bool> signInWithGoogle() async{
    final credential = await _getGoogleCredentials();
    if (credential == null) return false;
    await FirebaseAuth.instance.signInWithCredential(credential);
    return true;
  }

  @override
  Future<bool> anonymousToGoogle()async{
    final credential = await _getGoogleCredentials();
    if (credential == null) return false;
    User? user = firebaseAuth.currentUser;
    String oldUid = user!.uid;
    DocumentSnapshot doc = await firestore.collection(_usersCollectionName).doc(oldUid).get();
    UserCredential uc = await user.linkWithCredential(credential);
    user = uc.user;
    final userData = <String, dynamic>{
      "name": user!.providerData[0].displayName,
      "identifier": user.email,
    };
    await firestore.collection(_usersCollectionName).doc(doc.id).set(userData);
    return true;
  }

  // Future<QueryDocumentSnapshot?> _getUserByUid(String uid)async{
  //   QuerySnapshot<Map<String, dynamic>> snapshot = await firestore.collection(_usersCollectionName).where('uid', isEqualTo: uid).get();
  //   if (snapshot.docs.isNotEmpty){
  //     return snapshot.docs.first;
  //   }
  //   return null;
  // }

  Future<AuthCredential?> _getGoogleCredentials()async{
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: ['profile', 'email']).signIn();

    if (googleUser == null)return null;

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return credential;
  }
  
  @override
  Future<void> saveMessagingToken(String token) async{
    // Assume user is logged in for this example
    String userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .update({
        'tokens': FieldValue.arrayUnion([token]),
      });
  }
}
