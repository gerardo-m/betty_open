import 'package:betty/models/prediction.dart';
import 'package:equatable/equatable.dart';

abstract class PredictionItem {

  String id;
  Prediction prediction;
  //EventItem eventItem;
  String eventItemId;
  PredictionItem({
    this.id = '',
    required this.prediction,
//    required this.eventItem,
    required this.eventItemId,
  });

  EPredictionItem toEPredictionItem();

  Map<String, dynamic> toMap();
  factory PredictionItem.fromMap(Map<String, dynamic> map){
    throw UnimplementedError();
  }
}

abstract class EPredictionItem extends Equatable{

  final String id;
  final String predictionId;
  final String eventItemId;
  //final EEventItem eventItem;
  const EPredictionItem({
    required this.id,
    required this.predictionId,
    required this.eventItemId,
    //required this.eventItem,
  });

  @override
  List<Object?> get props => [id, predictionId, eventItemId,];
}
