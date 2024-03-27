part of 'show_prediction_cubit.dart';

abstract class ShowPredictionState extends Equatable {
  const ShowPredictionState();

  @override
  List<Object> get props => [];
}

class ShowPredictionInitial extends ShowPredictionState {}

class ShowPredictionValidState extends ShowPredictionState {

  final EPrediction prediction;
  final EEvent event;
  const ShowPredictionValidState({
    required this.prediction,
    required this.event,
  });

  @override
  List<Object> get props => [prediction, event];
}

class ShowPredictionLoading extends ShowPredictionValidState{
  const ShowPredictionLoading({required super.prediction, required super.event});
}