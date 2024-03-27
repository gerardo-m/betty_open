import 'package:betty/models/prediction_item.dart';
import 'package:betty/services/event_results_service.dart';
import 'package:betty/services/predictions_service.dart';
import 'package:betty/utils/enums.dart';
import 'package:get_it/get_it.dart';

class PredictionItemsService{

  final PredictionsService _predictionsService = GetIt.instance.get<PredictionsService>();
final EventResultsService _eventResultsService = GetIt.instance.get<EventResultsService>();

  PredictionItem? _currentEditingPredictionItem;

  PredictionItemsService._();

  PredictionItem? get currentEditingPredictionItem => _currentEditingPredictionItem;

  factory PredictionItemsService(){
    return PredictionItemsService._();
  }

  Future<void> loadPredictionItem(String predictionItemId, PredictionItemSource source)async{
    if (source == PredictionItemSource.prediction){
      _currentEditingPredictionItem = _predictionsService.currentEditingPrediction.items.firstWhere((element) => element.id == predictionItemId);
    }
    if (source == PredictionItemSource.eventResult){
      _currentEditingPredictionItem = _eventResultsService.currentEventResult!.items.firstWhere((element) => element.id == predictionItemId);
    }
  }

}