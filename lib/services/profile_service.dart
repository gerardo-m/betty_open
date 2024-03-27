import 'package:betty/models/profile.dart';
import 'package:betty/repositories/profile_repository.dart';
import 'package:betty/utils/enums.dart';

class ProfileService{

  final ProfileRepository repository;

  Profile? _currentUserProfile;

  ProfileService._({required this.repository});

  factory ProfileService(ProfileRepository repository){
    return ProfileService._(repository: repository);
  }

  Future<Profile?> getCurrentUserProfile()async{
    return _currentUserProfile ??= await repository.getCurrentUserProfile();
  }

  Future<Profile?> createAnonymousUserProfile(Profile profile)async{
    profile.identifier = profile.identifier.trim();
    profile.name = profile.name.trim();
    await repository.signInAnonymously();
    return repository.createUserProfile(profile);
  }

  Future<Profile?> signInWithGoogle()async{
    bool accepted = await repository.signInWithGoogle();
    if (!accepted) return null;
    Profile? existingProfile = await repository.getCurrentUserProfile();
    if (existingProfile == null){
      return repository.createUserProfile(Profile(authenticationMethod: AuthenticationMethod.google, name: '', identifier: ''));
    }
    _currentUserProfile = existingProfile;
    return _currentUserProfile;
  }

  Future<Profile?> linkToGoogle()async{
    bool accepted = await repository.anonymousToGoogle();
    if (!accepted) return null;
    _currentUserProfile = null;
    return await getCurrentUserProfile();
  }

  Future<bool?> userIdentifireExists(String identifier)async{
    return await repository.userIdentifierExists(identifier.trim());
  }

  Future<List<Profile>> searchProfileByIdentifier(String identifier){
    return repository.searchProfilesByIdentifier(identifier.trim());
  }
}