import 'package:betty/models/participant.dart';
import 'package:betty/services/participants_ranking_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'participants_ranking_state.dart';

class ParticipantsRankingCubit extends Cubit<ParticipantsRankingState> {

  final ParticipantsRankingService _participantsRankingService = GetIt.instance.get<ParticipantsRankingService>();

  ParticipantsRankingCubit() : super(ParticipantsRankingInitial());

  void loadParticipantsRankingForEvent(String eventId)async{
    _loading();
    _showParticipantsRankingForevent(eventId);
  }

  void calculateRanking(String eventId)async{
    _loading();
    await _participantsRankingService.calculateParticipantsPoints(eventId);
    _showParticipantsRankingForevent(eventId);
  }

  void _showParticipantsRankingForevent(String eventId)async{
    List<Participant> participants = await _participantsRankingService.getSavedRankingForEvent(eventId);
    List<EParticipant> eParticipants = participants.map((e) => e.toEParticipant()).toList();
    emit(ParticipantsRankingValidState(participants: eParticipants));
  }

  void _loading(){
    ParticipantsRankingState currentState = state;
    if (currentState is ParticipantsRankingValidState){
      emit(ParticipantsRankingLoading(participants: currentState.participants));
    }
  }
}
