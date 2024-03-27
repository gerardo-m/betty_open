part of 'predictions_cubit.dart';

abstract class PredictionsState extends Equatable {
  const PredictionsState();

  @override
  List<Object> get props => [];
}

class PredictionsInitial extends PredictionsState {}

class PredictionsValidState extends PredictionsState {

  final List<EPrediction> eventsAccepted;
  final List<EEvent> eventsInvited;
  const PredictionsValidState({
    required this.eventsAccepted,
    required this.eventsInvited,
  });

  @override
  List<Object> get props => [eventsAccepted, eventsInvited];
}

class PredictionsLoading extends PredictionsValidState{
  const PredictionsLoading({required super.eventsAccepted, required super.eventsInvited});
}