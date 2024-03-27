part of 'finished_events_cubit.dart';

abstract class FinishedEventsState extends Equatable {
  const FinishedEventsState();

  @override
  List<Object> get props => [];
}

class FinishedEventsInitial extends FinishedEventsState {}

class FinishedEventsValidState extends FinishedEventsState {

  final List<EEvent> finishedEvents;
  const FinishedEventsValidState({
    required this.finishedEvents,
  });

  @override
  List<Object> get props => [finishedEvents];
}

class FinishedEventsLoading extends FinishedEventsValidState{
  const FinishedEventsLoading({required super.finishedEvents});

}
