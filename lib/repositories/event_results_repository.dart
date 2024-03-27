import 'package:betty/models/prediction.dart';

abstract class EventResultsRepository{

  Future<void> saveEventResults(Prediction eventResult);
  Future<Prediction?> getEventResults(String eventId);
}