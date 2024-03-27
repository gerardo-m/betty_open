import 'package:betty/models/event.dart';
import 'package:betty/models/participant.dart';
import 'package:betty/repositories/participants_repository.dart';
import 'package:betty/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParticipantsRepositoryFirebase extends ParticipantsRepository {
  late final FirebaseFirestore firestore;

  final String _participantsCollectionName = 'participants';

  factory ParticipantsRepositoryFirebase() {
    return ParticipantsRepositoryFirebase._();
  }

  ParticipantsRepositoryFirebase._() {
    firestore = FirebaseFirestore.instance;
  }

  @override
  Future<List<Event>> getEventsForParticipant(String userId, {bool? accepted}) async {
    List<Event> events = [];
    Query<Map<String, dynamic>> query = firestore
        .collection(_participantsCollectionName)
        .where('userId', isEqualTo: userId);
    if (accepted != null) {
      query = query.where('accepted', isEqualTo: accepted);
    }
    QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docs) {
      Map<String, dynamic> eventData = doc.data();
      Event event = Event(
        id: eventData['eventId'],
        name: eventData['eventName'],
        items: [],
        status: EventStatus.values[eventData['eventStatus']],
      );
      events.add(event);
    }
    return events;
  }

  @override
  Future<List<Participant>> getParticipantsForEvent(Event event,
      {bool? accepted}) async {
    List<Participant> participants = [];
    Query<Map<String, dynamic>> query = firestore
        .collection(_participantsCollectionName)
        .where('eventId', isEqualTo: event.id);
    if (accepted != null) {
      query = query.where('accepted', isEqualTo: accepted);
    }
    QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docs) {
      Map<String, dynamic> participantData = doc.data();
      Participant participant = Participant(
        id: doc.id,
        event: event,
        userId: participantData['userId'],
        userIdentifier: participantData['userIdentifier'],
        userName: participantData['userName'],
        accepted: participantData['accepted'],
        points: participantData['points'] ?? 0,
        eventOwnerId: participantData['eventOwnerId'] ?? '',
      );
      participants.add(participant);
    }
    return participants;
  }

  @override
  Future<void> saveParticipant(Participant participant) async {
    final newParticipant = <String, dynamic>{
      'userId': participant.userId,
      'userIdentifier': participant.userIdentifier,
      'userName': participant.userName,
      'accepted': participant.accepted,
      'eventId': participant.event.id,
      'eventName': participant.event.name,
      'eventStatus': participant.event.status.index,
      'eventOwnerId': participant.event.userId,
    };
    await firestore.collection(_participantsCollectionName).add(newParticipant);
  }
  
  @override
  Future<void> acceptEventInvitation(String userId, String eventId) async{
    QuerySnapshot<Map<String,dynamic>> query = await firestore.collection(_participantsCollectionName).where('userId', isEqualTo: userId).where('eventId', isEqualTo: eventId).get();
    String resId = query.docs.first.id;
    final data = {
      'accepted': true,
    };
    await firestore.collection(_participantsCollectionName).doc(resId).update(data);
  }
  
  @override
  Future<void> updateParticipantsPoints(Participant participant) async{
    DocumentReference doc = firestore.collection(_participantsCollectionName).doc(participant.id);
    final data = {
      'points': participant.points,
    };
    await doc.update(data);
  }
}
