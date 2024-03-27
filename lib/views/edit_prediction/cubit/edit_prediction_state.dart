part of 'edit_prediction_cubit.dart';

abstract class EditPredictionState extends Equatable {
  const EditPredictionState();

  @override
  List<Object> get props => [];
}

class EditPredictionInitial extends EditPredictionState {}

class EditPredictionValidState extends EditPredictionState {

  final EPrediction prediction;
  final EEvent event;
  const EditPredictionValidState({
    required this.prediction,
    required this.event,
  });

  @override
  List<Object> get props => [prediction, event];
}

class EditPredictionSaved extends EditPredictionValidState{

  final String errorMessage;

  const EditPredictionSaved({required super.prediction, required super.event, required this.errorMessage});

  @override
  List<Object> get props => [prediction, errorMessage];
}

class EditPredictionSent extends EditPredictionValidState{

  final String errorMessage;

  const EditPredictionSent({required super.prediction, required super.event, required this.errorMessage});

  @override
  List<Object> get props => [prediction, errorMessage];
}

class EditPredictionLoading extends EditPredictionValidState{
  const EditPredictionLoading({required super.prediction, required super.event});
}