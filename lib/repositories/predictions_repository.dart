import 'package:betty/models/prediction.dart';

abstract class PredictionsRepository{

  Future<Prediction?> savePrediction(Prediction prediction);
  Future<void> deletePrediction(String id);
  Future<Prediction?> getPrediction(String id);
  Future<List<Prediction>> getMyPredictions(String profileId);
  Future<Prediction?> getMyPrediction(String profileId, String eventId);
  Future<List<Prediction>> getPredictionsForEvent(String eventId);

}