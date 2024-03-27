import 'package:betty/models/event.dart';
import 'package:betty/models/event_item.dart';
import 'package:betty/models/prediction.dart';
import 'package:betty/models/prediction_item.dart';
import 'package:betty/models/profile.dart';
import 'package:betty/repositories/events_repository.dart';
import 'package:betty/repositories/participants_repository.dart';
import 'package:betty/repositories/predictions_repository.dart';
import 'package:betty/services/predictions_service/prediction_item_factory.dart';
import 'package:betty/services/profile_service.dart';
import 'package:betty/services/published_events_service.dart';
import 'package:betty/utils/enums.dart';
import 'package:get_it/get_it.dart';

class PredictionsService{

  final ProfileService _profileService =  GetIt.instance.get<ProfileService>();
  final PublishedEventsService _publishedEventsService = GetIt.instance.get<PublishedEventsService>();
  final PredictionsRepository localRepository;
  final PredictionsRepository remoteRepository;
  final ParticipantsRepository participantsRepository;
  final EventsRepository eventsRepository;

  Event _currentEditingEvent = Event.createEmptyEvent();
  Prediction _currentEditingPrediction = Prediction.createEmptyPrediction(Event.createEmptyEvent());

  PredictionsService._({required this.localRepository, required this.remoteRepository, required this.participantsRepository, required this.eventsRepository,});

  Event get currentEditingEvent => _currentEditingEvent;
  Prediction get currentEditingPrediction => _currentEditingPrediction;

  factory PredictionsService(PredictionsRepository localRepository, PredictionsRepository remoteRepository, ParticipantsRepository participantsRepository, EventsRepository eventsRepository, ){
    return PredictionsService._(localRepository: localRepository, remoteRepository: remoteRepository, participantsRepository: participantsRepository, eventsRepository: eventsRepository,);
  }

  Future<List<Prediction>> getEventsAcceptedForCurrentUser()async{
    String userId = (await _profileService.getCurrentUserProfile())!.id;
    List<Prediction> localPredictions = await localRepository.getMyPredictions(userId);
    List<Prediction> remotePredictions = await remoteRepository.getMyPredictions(userId);
    localPredictions.addAll(remotePredictions);
    await _updateEventStatus(localPredictions);
    return localPredictions;
  }

  Future<List<Event>> getEventsInvitedForCurrentUser()async{
    String userId = (await _profileService.getCurrentUserProfile())!.id;
    List<Event> events = await participantsRepository.getEventsForParticipant(userId, accepted: false);
    return events;
  }

  Future<void> acceptEventInvitation(String eventId)async{
    String userId = (await _profileService.getCurrentUserProfile())!.id;
    await participantsRepository.acceptEventInvitation(userId, eventId);
    await _publishedEventsService.loadPublishedEventToEdit(eventId);
    Event event = _publishedEventsService.currentEditingEvent;
    Prediction prediction = await buildPredictionFromEvent(event);
    await localRepository.savePrediction(prediction);
  }

  Future<void> loadPredictionForEvent(String eventId)async{
    Prediction? prediction = await _lookForExistingPrediction(eventId);
    await _publishedEventsService.loadPublishedEventToEdit(eventId);
    _currentEditingEvent = _publishedEventsService.currentEditingEvent;
    prediction ??= await buildPredictionFromEvent(_currentEditingEvent);
    _currentEditingPrediction = prediction;
  }

  Future<Prediction> buildPredictionFromEvent(Event event) async{
    Profile? profile = await _profileService.getCurrentUserProfile();
    if (profile == null){
      throw Exception('Usuario no autenticado');
    }
    Prediction prediction = Prediction(id:event.id, userId: profile.id, eventId: event.id, eventName: event.name, eventStatus: event.status, items: []);
    for (EventItem item in event.items){
      PredictionItem newItem = PredictionItemFactory.buildPredictionItem(item, prediction);
      prediction.items.add(newItem);
    }
    return prediction;
  }

  Future<void> saveCurrentPrediction()async{
    await localRepository.savePrediction(_currentEditingPrediction);
  }

  Future<void> sendCurrentPrediction()async{
    String id = _currentEditingPrediction.id;
    _currentEditingPrediction.sent = true;
    await remoteRepository.savePrediction(_currentEditingPrediction); 
    await localRepository.deletePrediction(id);
  }

  Future<Prediction?> _lookForExistingPrediction(String eventId)async{
    Prediction? existingPrediction = await localRepository.getPrediction(eventId);
    if (existingPrediction == null){
      String userId = (await _profileService.getCurrentUserProfile())!.id;
      existingPrediction = await remoteRepository.getMyPrediction(userId, eventId);
    }
    return existingPrediction;
  }

  Future<void> _updateEventStatus(List<Prediction> predictions)async{
    for (Prediction prediction in predictions){
      Event? event = await eventsRepository.getEvent(prediction.eventId);
      prediction.eventStatus = event?.status ?? EventStatus.open;
    }
  }
}