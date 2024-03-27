import 'package:betty/models/event.dart';
import 'package:betty/models/participant.dart';
import 'package:betty/repositories/events_repository.dart';
import 'package:betty/repositories/participants_repository.dart';
import 'package:betty/utils/enums.dart';

class PublishedEventsService{

  //final ProfileService _profileService =  GetIt.instance.get<ProfileService>();

  final EventsRepository remoteRepository;
  final ParticipantsRepository participantsRepository;

  Event _currentEditingEvent = Event.createEmptyEvent();

  PublishedEventsService._({required this.remoteRepository, required this.participantsRepository});

  Event get currentEditingEvent => _currentEditingEvent;

  factory PublishedEventsService(EventsRepository repository, ParticipantsRepository participantsRepository){
    return PublishedEventsService._(remoteRepository: repository, participantsRepository: participantsRepository);
  }

  Future<void> loadPublishedEventToEdit(String id)async{
    if (_currentEditingEvent.id != id){
      Event? event = await remoteRepository.getEvent(id, onlyCache: false);
      if (event == null){
        throw Exception('No se encontró el evento con id $id');
      }
      _currentEditingEvent = event;
    }
    await _loadParticipants();
  }

  Future<void> _loadParticipants()async{
    List<Participant> participants = await participantsRepository.getParticipantsForEvent(_currentEditingEvent);
    _currentEditingEvent.invitedParticipants = participants.where((element) => element.accepted == false).toList();
    _currentEditingEvent.acceptedParticipants = participants.where((element) => element.accepted).toList();
  }

  Future<void> changeCurrentEventStatus(EventStatus status)async{
    _currentEditingEvent.status = status;
    await remoteRepository.saveEvent(_currentEditingEvent);
  }
}