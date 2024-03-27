
import 'package:betty/models/profile.dart';
import 'package:betty/services/profile_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileService profileService = GetIt.instance.get<ProfileService>();

  ProfileCubit() : super(ProfileInitial());

  void loadProfile()async{
    _loading();
    Profile? profile = await profileService.getCurrentUserProfile();
    if (profile == null){
      emit(ProfileNotCreated(profile: EProfile.fromProfile(Profile.createEmptyProfile())));
    }else{
      emit(ProfileCreated(profile: EProfile.fromProfile(profile)));
    }
  }

  void createProfile(Profile profile)async{
    ProfileState currentState = state;
    if (currentState is ProfileValidState){
      //_resetErrorMessage(currentState);
      _loading();
      bool? userIdentifierExists = await profileService.userIdentifireExists(profile.identifier);
      if (userIdentifierExists == null){
        emit(currentState.copyWith(errorMessage: 'No se pudo validar tu identificador. Por favor revisa tu conexión a internet'));
        return;
      }else{
        if (userIdentifierExists){
          emit(currentState.copyWith(errorMessage: 'El identificador ya existe. Por favor intenta con uno diferente'));
          return;
        }
      }
      Profile? newProfile = await profileService.createAnonymousUserProfile(profile);
      if (newProfile == null){
        emit(currentState.copyWith(errorMessage: 'Un error desconocido ocurrió. Por favor intenta de nuevo más tarde'));
        return;
      }
      emit(ProfileCreated(profile: EProfile.fromProfile(newProfile)));
    }
  }

  void signInWithGoogle()async{
    ProfileState currentState = state;
    if (currentState is ProfileValidState){
      _loading();
      Profile? newProfile = await profileService.signInWithGoogle();
      if (newProfile == null){
        emit(currentState.copyWith(errorMessage: 'Inicio de sesión cancelado'));
        return;
      }
      emit(ProfileCreated(profile: EProfile.fromProfile(newProfile)));
    }
  }

  void linkWithGoogle()async{
    ProfileState currentState = state;
    if (currentState is ProfileValidState){
      _loading();
      Profile? newProfile = await profileService.linkToGoogle();
      if (newProfile == null){
        emit(currentState.copyWith(errorMessage: 'Vinculación cancelada'));
        return;
      }
      emit(ProfileLinked(profile: EProfile.fromProfile(newProfile)));
    }
  }

  // void _resetErrorMessage(ProfileValidState validState){
  //   emit(validState.copyWith(errorMessage: ''));
  // }

  void _loading(){
    ProfileState currentState = state;
    if (currentState is ProfileValidState){
      emit(ProfileLoading(profile: currentState.profile)); 
    }
  }
}
