import 'package:betty/models/participant.dart';
import 'package:betty/services/participants_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'add_participant_state.dart';

class AddParticipantCubit extends Cubit<AddParticipantState> {

  final ParticipantsService _participantsService = GetIt.instance.get<ParticipantsService>();

  AddParticipantCubit() : super(AddParticipantInitial());

  void start(){
    emit(const AddParticipantValidState(participants: []));
  }

  void search(String identifier)async{
    _loading();
    await _participantsService.searchUsersByIdentifier(identifier);
    List<EParticipant> participants = _participantsService.lastSearchResults.map((e) => e.toEParticipant()).toList();
    emit(AddParticipantValidState(participants: participants));
  }

  Future<void> inviteParticipant(String userId)async{
    await _participantsService.inviteParticipant(userId);
  }

  void _loading(){
    AddParticipantState currentState = state;
    if (currentState is AddParticipantValidState){
      emit(AddParticipantLoading(participants: currentState.participants)); 
    }
  }
  
}
