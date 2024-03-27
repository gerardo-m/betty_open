part of 'edit_prediction_single_match_cubit.dart';

abstract class EditPredictionSingleMatchState extends Equatable {
  const EditPredictionSingleMatchState();

  @override
  List<Object> get props => [];
}

class EditPredictionSingleMatchInitial extends EditPredictionSingleMatchState {}

class EditPredictionSingleMatchValidState extends EditPredictionSingleMatchState {

  final EPredictionSingleMatchItem predictionItem;
  const EditPredictionSingleMatchValidState({
    required this.predictionItem,
  });

  @override
  List<Object> get props => [predictionItem];
}

class EditPredictionSingleMatchLoading extends EditPredictionSingleMatchValidState{
  const EditPredictionSingleMatchLoading({required super.predictionItem});
}
