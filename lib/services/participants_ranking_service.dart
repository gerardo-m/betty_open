import 'package:betty/models/event.dart';
import 'package:betty/models/participant.dart';
import 'package:betty/models/prediction.dart';
import 'package:betty/repositories/participants_repository.dart';
import 'package:betty/repositories/predictions_repository.dart';
import 'package:betty/services/event_results_service.dart';
import 'package:betty/services/participants_ranking_service/ranking_calculator.dart';
import 'package:betty/services/published_events_service.dart';
import 'package:get_it/get_it.dart';

class ParticipantsRankingService{

  final ParticipantsRepository participantsRepository;
  final PredictionsRepository predictionsRepository;

  final PublishedEventsService _publishedEventsService = GetIt.instance.get<PublishedEventsService>();
  final EventResultsService _eventResultsService = GetIt.instance.get<EventResultsService>();

  ParticipantsRankingService._({required this.participantsRepository, required this.predictionsRepository});

  factory ParticipantsRankingService(ParticipantsRepository participantsRepository, PredictionsRepository predictionsRepository){
    return ParticipantsRankingService._(participantsRepository: participantsRepository, predictionsRepository: predictionsRepository);
  }

  Future<List<Participant>> getSavedRankingForEvent(String eventId)async{
    Event event = _publishedEventsService.currentEditingEvent;
    List<Participant> participants = await participantsRepository.getParticipantsForEvent(event, accepted: true);
    participants.sort((a, b) => b.points - a.points,);
    return participants;
  }

  Future<void> calculateParticipantsPoints(String eventId)async{
    Event event = _publishedEventsService.currentEditingEvent;
    await _eventResultsService.loadResultsForCurrentEvent();
    Prediction? eventResults = _eventResultsService.currentEventResult;
    if (eventResults == null) return;
    List<Participant> participants = await participantsRepository.getParticipantsForEvent(event, accepted: true);
    List<Prediction> predictions = await predictionsRepository.getPredictionsForEvent(eventId);
    
    for (Participant participant in participants){
      Iterable<Prediction> filteredPredictions = predictions.where((element) => element.userId == participant.userId);
      if (filteredPredictions.isNotEmpty){
        Prediction prediction = filteredPredictions.first;
        RankingCalculator.calculatePoints(participant, prediction, eventResults);
        await participantsRepository.updateParticipantsPoints(participant);
      }
    }
  }
}