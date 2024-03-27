import 'package:betty/models/prediction.dart';
import 'package:betty/repositories/predictions_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class PredictionsRepositoryFirebase extends PredictionsRepository{

  late final FirebaseFirestore firestore;

  final String _predictionsCollectionName = 'predictions';

  factory PredictionsRepositoryFirebase() {
    return PredictionsRepositoryFirebase._();
  }

  PredictionsRepositoryFirebase._() {
    firestore = FirebaseFirestore.instance;
  }

  @override
  Future<Prediction?> savePrediction(Prediction prediction) async{
    String id = const Uuid().v4();
    prediction.id = id;
    Map<String, dynamic> predictionData = prediction.toMap();
    await firestore.collection(_predictionsCollectionName).doc(id).set(predictionData);
    return prediction;
  }
  
  @override
  Future<void> deletePrediction(String id) {
    // TODO: implement deletePrediction
    throw UnimplementedError();
  }
  
  @override
  Future<List<Prediction>> getMyPredictions(String profileId) async{
    List<Prediction> predictions = [];
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore.collection(_predictionsCollectionName).where('userId', isEqualTo: profileId).get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docs){
      Map<String, dynamic> predictionData = doc.data();
      Prediction prediction = Prediction.fromMap(predictionData);
      predictions.add(prediction);
    }
    return predictions;
  }
  
  @override
  Future<Prediction?> getPrediction(String id) {
    // TODO: implement getPrediction
    throw UnimplementedError();
  }
  
  @override
  Future<List<Prediction>> getPredictionsForEvent(String eventId) async{
    List<Prediction> predictions = [];
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore.collection(_predictionsCollectionName).where('eventId', isEqualTo: eventId).get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docs){
      Map<String, dynamic> predictionData = doc.data();
      Prediction prediction = Prediction.fromMap(predictionData);
      predictions.add(prediction);
    }
    return predictions;
  }
  
  @override
  Future<Prediction?> getMyPrediction(String profileId, String eventId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore.collection(_predictionsCollectionName).where('eventId', isEqualTo: eventId).where('userId', isEqualTo: profileId).get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot.docs;
    if (docs.isNotEmpty){
      Map<String, dynamic> predictionData = docs.first.data();
      Prediction prediction = Prediction.fromMap(predictionData);
      return prediction;
    }
    return null;
  }
  
}