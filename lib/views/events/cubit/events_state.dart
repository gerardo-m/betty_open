part of 'events_cubit.dart';

abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object> get props => [];
}

class EventsInitial extends EventsState {}

class EventsValidState extends EventsState {
  final List<EEvent> publishedEvents;
  final List<EEvent> unpublishedEvents;
  const EventsValidState({
    required this.publishedEvents,
    required this.unpublishedEvents,
  });

  @override
  List<Object> get props => [publishedEvents, unpublishedEvents];
}

class EventsLoading extends EventsValidState{
  const EventsLoading({required super.publishedEvents, required super.unpublishedEvents});
}

