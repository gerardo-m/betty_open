import 'package:betty/models/event.dart';
import 'package:betty/models/prediction.dart';
import 'package:betty/services/predictions_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'show_prediction_state.dart';

class ShowPredictionCubit extends Cubit<ShowPredictionState> {

  final PredictionsService _predictionsService =
      GetIt.instance.get<PredictionsService>();

  ShowPredictionCubit() : super(ShowPredictionInitial());

  void loadPrediction(String eventId) async {
    _loading();
    await _predictionsService.loadPredictionForEvent(eventId);
    emit(
      ShowPredictionValidState(
        prediction:
            _predictionsService.currentEditingPrediction.toEPrediction(),
        event: _predictionsService.currentEditingEvent.toEEvent(),
      ),
    );
  }

  void reloadPrediction() {
    emit(
      ShowPredictionValidState(
        prediction:
            _predictionsService.currentEditingPrediction.toEPrediction(),
        event: _predictionsService.currentEditingEvent.toEEvent(),
      ),
    );
  }

  void _loading(){
    ShowPredictionState currentState = state;
    if (currentState is ShowPredictionValidState){
      emit(ShowPredictionLoading(prediction: currentState.prediction, event: currentState.event)); 
    }
  }
}
