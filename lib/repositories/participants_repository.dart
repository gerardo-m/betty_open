import 'package:betty/models/event.dart';
import 'package:betty/models/participant.dart';

abstract class ParticipantsRepository{

  // Future<void> saveParticipants(List<Participant> invitedParticipants, List<Participant> acceptedParticipants, String eventId);
  // /// Load the participants in to the event
  // Future<void> getParticipants(Event event);


  Future<void> saveParticipant(Participant participant);
  Future<List<Participant>> getParticipantsForEvent(Event event, {bool? accepted});
  Future<List<Event>> getEventsForParticipant(String userId, {bool? accepted});

  Future<void> acceptEventInvitation(String userId, String eventId);

  Future<void> updateParticipantsPoints(Participant participant);

}