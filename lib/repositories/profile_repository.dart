import 'package:betty/models/profile.dart';

abstract class ProfileRepository{
  
  Future<Profile?> getCurrentUserProfile();
  Future<List<Profile>> searchProfilesByIdentifier(String identifier);

  Future<Profile?> createUserProfile(Profile newProfile);
  Future<bool> userIdentifierExists(String identifier);

  Future<void> signInAnonymously();
  Future<bool> signInWithGoogle();
  Future<bool> anonymousToGoogle();

  Future<void> saveMessagingToken(String token);
}