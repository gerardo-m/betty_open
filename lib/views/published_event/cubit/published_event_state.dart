part of 'published_event_cubit.dart';

abstract class PublishedEventState extends Equatable {
  const PublishedEventState();

  @override
  List<Object> get props => [];
}

class PublishedEventInitial extends PublishedEventState {}

class PublishedEventValidState extends PublishedEventState {

  final EEvent publishedEvent;
  const PublishedEventValidState({
    required this.publishedEvent,
  });

  @override
  List<Object> get props => [publishedEvent];
}

class PublishedEventLoading extends PublishedEventValidState{
  const PublishedEventLoading({required super.publishedEvent});
}