import 'package:betty/utils/enums.dart';
import 'package:equatable/equatable.dart';

class Profile {

  String id;
  String name;
  String identifier;
  AuthenticationMethod authenticationMethod;
  Profile({
    this.id = '',
    required this.name,
    required this.identifier,
    required this.authenticationMethod,
  });

  factory Profile.fromEProfile(EProfile eProfile){
    return Profile(id: eProfile.id, name: eProfile.name, identifier: eProfile.identifier, authenticationMethod: eProfile.authenticationMethod,);
  }

  factory Profile.createEmptyProfile(){
    return Profile(name: '', identifier: '', authenticationMethod: AuthenticationMethod.anonymous);
  }

}

class EProfile extends Equatable {

  final String id;
  final String name;
  final String identifier;
  final AuthenticationMethod authenticationMethod;

  const EProfile({
    required this.id,
    required this.name,
    required this.identifier,
    required this.authenticationMethod,
  });

  @override
  List<Object?> get props => [id, name, identifier, authenticationMethod];

  factory EProfile.fromProfile(Profile profile){
    return EProfile(id: profile.id, name: profile.name, identifier: profile.identifier, authenticationMethod: profile.authenticationMethod, );
  }

}
