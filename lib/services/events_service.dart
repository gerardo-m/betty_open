import 'package:betty/models/event.dart';
import 'package:betty/models/event_item.dart';
import 'package:betty/models/participant.dart';
import 'package:betty/models/profile.dart';
import 'package:betty/repositories/events_repository.dart';
import 'package:betty/repositories/participants_repository.dart';
import 'package:betty/services/profile_service.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

class EventsService{

  final ProfileService profileService =  GetIt.instance.get<ProfileService>();
  final EventsRepository localRepository;
  final EventsRepository remoteRepository;
  final ParticipantsRepository participantsRepository;

  Event _currentEditingEvent = Event.createEmptyEvent();

  EventsService._({required this.localRepository, required this.remoteRepository, required this.participantsRepository});

  Event get currentEditingEvent => _currentEditingEvent;

  factory EventsService(EventsRepository localRepository, EventsRepository remoteRepository, ParticipantsRepository participantsRepository){
    return EventsService._(localRepository: localRepository, remoteRepository: remoteRepository, participantsRepository: participantsRepository);
  }

  Future<List<Event>> getPublishedEvents()async{
    Profile? profile = await profileService.getCurrentUserProfile();
    if (profile == null){
      throw Exception('No se puede obtener los eventos si no estas autenticado');
    }
    List<Event> events = await remoteRepository.getMyActiveEvents(profile.id);
    events.sort((a, b) {
      return a.name.compareTo(b.name);
    },);
    return events;
  }

  Future<List<Event>> getUnPublishedEvents()async{
    List<Event> events = await localRepository.getMyActiveEvents('');
    events.sort((a, b) {
      return a.name.compareTo(b.name);
    },);
    return events;
  }

  Future<List<Event>> getFinishedEvents()async{
    Profile? profile = await profileService.getCurrentUserProfile();
    if (profile == null){
      throw Exception('No se puede obtener los eventos si no estas autenticado');
    }
    List<Event> events = await remoteRepository.getMyFinishedEvents(profile.id);
    events.sort((a, b) {
      if (a.updatedAt == null) return 1;
      if (b.updatedAt == null) return -1;
      return a.updatedAt!.compareTo(b.updatedAt!);
    },);
    return events;
  }

  /// If the id is null this will create a new empty event object
  /// If the id is not null it will load the saved event from the
  /// local storage.
  /// Either way it will set the currentEditingEvent
  Future<void> loadEventToEdit({String? id})async{
    if (id == null){
      _currentEditingEvent = Event.createEmptyEvent();
      return;
    }else{
      Event? event = await localRepository.getEvent(id);
      if (event == null){
        throw Exception('No se encontró el evento con id $id');
      }
      _currentEditingEvent = event;
    }
  }

  void addItemToEditingEvent(EventItem item){
    _currentEditingEvent.items.add(item);
  }

  void deleteItemFromEditingEvent(String itemId){
    _currentEditingEvent.items.removeWhere((element) => element.id == itemId);
  }

  Future<void> saveEvent()async{
    Profile? profile = await profileService.getCurrentUserProfile(); 
    if (profile == null){
      throw Exception('No autenticado');
    }
    if (_currentEditingEvent.id.isEmpty){
      String id = const Uuid().v4();
      _currentEditingEvent.id = id;
    }
    _currentEditingEvent.userId = profile.id;
    _currentEditingEvent.userName = profile.name;
    localRepository.saveEvent(_currentEditingEvent);
  }

  Future<void> publishEvent()async{
    _currentEditingEvent.published = true;
    await remoteRepository.saveEvent(_currentEditingEvent);
    await localRepository.deleteEvent(_currentEditingEvent.id);
    await _createParticipantForAuthor();
  }

  Future<void> deleteSavedEvent()async{
    await localRepository.deleteEvent(_currentEditingEvent.id);
  }

  Future<void> _createParticipantForAuthor()async{
    Profile? profile = await profileService.getCurrentUserProfile(); 
    if (profile == null){
      throw Exception('No autenticado');
    }
    Participant participant = Participant(event: _currentEditingEvent, userId: profile.id, userIdentifier: profile.identifier, userName: profile.name);
    await participantsRepository.saveParticipant(participant);
  }

  // Future<Event?> getPublishedEvent(String id)async{
  //   return remoteRepository.getEvent(id);
  // }
}