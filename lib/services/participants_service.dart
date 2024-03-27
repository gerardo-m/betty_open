import 'package:betty/models/event.dart';
import 'package:betty/models/participant.dart';
import 'package:betty/models/profile.dart';
import 'package:betty/repositories/participants_repository.dart';
import 'package:betty/services/profile_service.dart';
import 'package:betty/services/published_events_service.dart';
import 'package:get_it/get_it.dart';

class ParticipantsService{

  final ProfileService _profileService =  GetIt.instance.get<ProfileService>();
  final PublishedEventsService _publishedEventsService = GetIt.instance.get<PublishedEventsService>();

  final ParticipantsRepository repository;

  List<Participant> _lastSearchResults = [];

  ParticipantsService._({required this.repository});

  List<Participant> get lastSearchResults => _lastSearchResults;

  factory ParticipantsService(ParticipantsRepository repository){
    return ParticipantsService._(repository: repository);
  }

  Future<void> searchUsersByIdentifier(String identifier)async{
    List<Profile> profiles = await _profileService.searchProfileByIdentifier(identifier);
    Event currentEditingEvent = _publishedEventsService.currentEditingEvent;
    profiles.removeWhere((profile){
      bool exist1 = currentEditingEvent.acceptedParticipants?.where((participant) => participant.userId == profile.id).isNotEmpty ?? false;
      bool exist2 = currentEditingEvent.invitedParticipants?.where((participant) => participant.userId == profile.id).isNotEmpty ?? false;
      return exist1 || exist2;
    });
    _lastSearchResults = [
      for (Profile profile in profiles)
        Participant(event: _publishedEventsService.currentEditingEvent, userId: profile.id, userIdentifier: profile.identifier, userName: profile.name),
    ];
  }

  Future<void> inviteParticipant(String userId)async{
    Participant participantToInvite = _lastSearchResults.firstWhere((element) => element.userId == userId);
    Event currentEditingEvent = _publishedEventsService.currentEditingEvent;
    List<Participant>? invitedParticipants = currentEditingEvent.invitedParticipants;
    if (invitedParticipants == null){
      invitedParticipants = [];
      currentEditingEvent.invitedParticipants = invitedParticipants;
    }
    await repository.saveParticipant(participantToInvite);
    invitedParticipants.add(participantToInvite);
    //repository.saveParticipants(invitedParticipants, currentEditingEvent.acceptedParticipants ?? [], currentEditingEvent.id);

  }

}