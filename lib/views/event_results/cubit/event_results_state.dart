part of 'event_results_cubit.dart';

abstract class EventResultsState extends Equatable {
  const EventResultsState();

  @override
  List<Object> get props => [];
}

class EventResultsInitial extends EventResultsState {}

class EventResultsValidState extends EventResultsState {

  final EPrediction eventResult;
  const EventResultsValidState({
    required this.eventResult,
  });

  @override
  List<Object> get props => [eventResult];
}

class EventResultsSaved extends EventResultsValidState{
  const EventResultsSaved({required super.eventResult});
}

class EventResultsLoading extends EventResultsValidState{
  const EventResultsLoading({required super.eventResult});
}