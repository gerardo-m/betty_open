import 'package:betty/models/event.dart';
import 'package:betty/models/event_item.dart';
import 'package:betty/models/prediction.dart';
import 'package:betty/models/prediction_item.dart';
import 'package:betty/models/profile.dart';
import 'package:betty/repositories/event_results_repository.dart';
import 'package:betty/repositories/events_repository.dart';
import 'package:betty/services/predictions_service/prediction_item_factory.dart';
import 'package:betty/services/profile_service.dart';
import 'package:betty/services/published_events_service.dart';
import 'package:get_it/get_it.dart';

class EventResultsService {

  final EventResultsRepository repository;
  final EventsRepository eventsRepository;

  final PublishedEventsService _publishedEventsService =  GetIt.instance.get<PublishedEventsService>();
  final ProfileService _profileService =  GetIt.instance.get<ProfileService>();

  Prediction? _currentEventResult;

  EventResultsService._({required this.repository, required this.eventsRepository});

  Prediction? get currentEventResult => _currentEventResult;

  factory EventResultsService(EventResultsRepository repository, EventsRepository eventsRepository){
    return EventResultsService._(repository: repository, eventsRepository: eventsRepository,);
  }

  Future<void> loadResultsForCurrentEvent()async{
    await _lookForExistingResultsForCurrentEvent();
    if (_currentEventResult == null){
      await _createResultsForCurrentEvent();
    }
  }

  Future<void> saveCurrentEventResults()async{
    await repository.saveEventResults(_currentEventResult!);
    _publishedEventsService.currentEditingEvent.hasResults = true;
    await eventsRepository.updateEventHasResult(_currentEventResult!.eventId, true);
  }

  Future<void> _lookForExistingResultsForCurrentEvent()async{
    String eventId = _publishedEventsService.currentEditingEvent.id;
    _currentEventResult = await repository.getEventResults(eventId);
  }

  Future<void> _createResultsForCurrentEvent()async{
    Event currentEvent = _publishedEventsService.currentEditingEvent;
    Profile? profile = await _profileService.getCurrentUserProfile();
    if (profile == null){
      throw Exception('Usuario no autenticado');
    }
    Prediction prediction = Prediction(id: currentEvent.id, userId: profile.id, eventId: currentEvent.id, eventName: currentEvent.name, eventStatus: currentEvent.status, items: []);
    for (EventItem item in currentEvent.items){
      PredictionItem newItem = PredictionItemFactory.buildPredictionItem(item, prediction);
      prediction.items.add(newItem);
    }
    _currentEventResult = prediction;
  }

}