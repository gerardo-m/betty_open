import 'package:betty/models/prediction.dart';
import 'package:betty/repositories/event_results_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventResultsRepositoryFirebase extends EventResultsRepository{

  late final FirebaseFirestore firestore;

  final String _eventResultsCollectionName = 'eventResults';

  factory EventResultsRepositoryFirebase() {
    return EventResultsRepositoryFirebase._();
  }

  EventResultsRepositoryFirebase._() {
    firestore = FirebaseFirestore.instance;
  }

  @override
  Future<void> saveEventResults(Prediction eventResult) async{
    Map<String, dynamic> eventResultsData = eventResult.toMap();
    await firestore.collection(_eventResultsCollectionName).doc(eventResult.id).set(eventResultsData);
  }
  
  @override
  Future<Prediction?> getEventResults(String eventId) async{
    DocumentSnapshot<Map<String, dynamic>> doc = await firestore.collection(_eventResultsCollectionName).doc(eventId).get();
    Map<String, dynamic>? data = doc.data();
    if (data == null){
      return null;
    }
    return Prediction.fromMap(data);
  }

}