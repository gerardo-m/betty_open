import 'package:betty/models/profile.dart';
import 'package:betty/services/messaging_service.dart';
import 'package:betty/services/profile_service.dart';
import 'package:betty/utils/enums.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:username_generator/username_generator.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {

  final ProfileService _profileService = GetIt.instance.get<ProfileService>();
  final MessagingService _messagingService = GetIt.instance.get<MessagingService>();

  String name = '';

  HomeCubit() : super(HomeInitial());

  void initiate()async{
    //_loading();
    Profile? profile = await _profileService.getCurrentUserProfile();
    if (profile == null){
      emit(HomeWithoutProfile());
    }else{
      _messagingService.setupToken();
      emit(HomeWithProfile());
    }
  }

  void enterWithName()async{
    _loading();
    String? identifier = await _generateIdentifier();
    if (identifier == null){
      emit(HomeSignUpFailed());
      return;
    }
    Profile profile = Profile(name: name, identifier: identifier, authenticationMethod: AuthenticationMethod.anonymous);
    Profile? newProfile = await _profileService.createAnonymousUserProfile(profile);
    if (newProfile == null){
      emit(HomeSignUpFailed());
      return;
    }
    emit(HomeWithProfile());
  }

  void signInWithGoogle()async{
    _loading();
    Profile? newProfile = await _profileService.signInWithGoogle();
    if (newProfile == null){
      emit(HomeSignUpCancelled());
      return;
    }
    emit(HomeWithProfile());
  }

  Future<String?> _generateIdentifier()async{
    String identifier = UsernameGenerator().generate(name);
    bool? exists = await _profileService.userIdentifireExists(identifier);
    if (exists == null){
      return null;
    }else{
      if (exists){
        return _generateIdentifier();
      }
      return identifier;
    }
  }

  void _loading(){
    HomeState currentState = state;
    if (currentState is HomeValidState){
      emit(HomeLoading()); 
    }
  }
}
