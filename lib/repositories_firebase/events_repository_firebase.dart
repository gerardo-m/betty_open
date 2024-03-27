import 'package:betty/models/event.dart';
import 'package:betty/repositories/events_repository.dart';
import 'package:betty/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventsRepositoryFirebase extends EventsRepository{

  late final FirebaseFirestore firestore;

  final String _eventsCollectionName = 'events';

  factory EventsRepositoryFirebase() {
    return EventsRepositoryFirebase._();
  }

  EventsRepositoryFirebase._() {
    firestore = FirebaseFirestore.instance;
  }

  @override
  Future<Event?> getEvent(String id, {bool onlyCache = false}) async{
    Source source = onlyCache ? Source.cache : Source.serverAndCache;
    DocumentSnapshot<Map<String, dynamic>> doc = await firestore.collection(_eventsCollectionName).doc(id).get(GetOptions(source: source));
    Map<String, dynamic>? data = doc.data();
    if (data == null){
      return null;
    }
    return Event.fromMap(data);
  }

  @override
  Future<List<Event>> getMyActiveEvents(String profileId) async{
    // TODO add an option to only load the event without the items
    //List<Event> events = [];
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore.collection(_eventsCollectionName).where('userId', isEqualTo: profileId).where('status', isNotEqualTo: EventStatus.finished.index).get();
    return _getEventsFromQuerySnapshot(snapshot);
    // List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot.docs;
    // for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docs){
    //   Map<String, dynamic> eventData = doc.data();
    //   Event event = Event.fromMap(eventData);
    //   events.add(event);
    // }
    // return events;
  }

  @override
  Future<Event?> saveEvent(Event event) async{
    Map<String, dynamic> eventData = event.toMap();
    eventData['updatedAt'] = Timestamp.now();
    if (eventData['createdAt'] == null){
      eventData['createdAt'] = Timestamp.now();
    }
    await firestore.collection(_eventsCollectionName).doc(event.id).set(eventData);
    return event;
  }
  
  @override
  Future<void> deleteEvent(String id) {
    // TODO: implement deleteEvent
    throw UnimplementedError();
  }
  
  @override
  Future<void> updateEventHasResult(String eventId, bool hasResults) async{
    DocumentReference doc = firestore.collection(_eventsCollectionName).doc(eventId);
    final data = {
      'hasResults': hasResults,
      'updatedAt': Timestamp.now(),
    };
    await doc.update(data);
  }
  
  @override
  Future<List<Event>> getMyFinishedEvents(String profileId) async{
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore.collection(_eventsCollectionName).where('userId', isEqualTo: profileId).where('status', isEqualTo: EventStatus.finished.index).get();
    return _getEventsFromQuerySnapshot(snapshot);
  }

  List<Event> _getEventsFromQuerySnapshot(QuerySnapshot<Map<String, dynamic>> snapshot){
    List<Event> events = [];
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docs){
      Map<String, dynamic> eventData = doc.data();
      Event event = Event.fromMap(eventData);
      events.add(event);
    }
    return events;
  }

}