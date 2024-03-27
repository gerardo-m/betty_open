import 'package:betty/models/prediction.dart';
import 'package:betty/repositories/predictions_repository.dart';
import 'package:json_store/json_store.dart';

class PredictionsRepositoryJsonstore extends PredictionsRepository{

  final JsonStore jsonStore = JsonStore();

  static const _predictionsPreffix = 'predictions_';

  @override
  Future<Prediction?> savePrediction(Prediction prediction) async{
    String id = '$_predictionsPreffix${prediction.id}';
    await jsonStore.setItem(id, prediction.toMap());
    return prediction;
  }
  
  @override
  Future<void> deletePrediction(String id) {
    return jsonStore.deleteItem('$_predictionsPreffix$id');
  }
  
  @override
  Future<List<Prediction>> getMyPredictions(String profileId) async{
    List<Map<String, dynamic>>? json = await jsonStore.getListLike('$_predictionsPreffix%');
    if (json == null){
      return [];
    }else{
      return json.map((e) => Prediction.fromMap(e)).toList();
    }
  }
  
  @override
  Future<Prediction?> getPrediction(String id) async{
    Map<String, dynamic>? json = await jsonStore.getItem('$_predictionsPreffix$id');
    if (json != null){
      return Prediction.fromMap(json);
    }else{
      return null;
    }
  }
  
  @override
  Future<List<Prediction>> getPredictionsForEvent(String eventId) {
    // TODO: implement getPredictionsForEvent
    throw UnimplementedError();
  }
  
  @override
  Future<Prediction?> getMyPrediction(String profileId, String eventId) {
    // TODO: implement getMyPrediction
    throw UnimplementedError();
  }
}