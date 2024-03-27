import 'package:betty/models/event.dart';
import 'package:betty/services/events_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {

  final EventsService eventsService = GetIt.instance.get<EventsService>();

  EventsCubit() : super(EventsInitial());

  void loadEvents()async{
    _loading();
    List<Event> publishedEvents = await eventsService.getPublishedEvents();
    List<Event> unpublishedEvents = await eventsService.getUnPublishedEvents();
    List<EEvent> ePublishedEvents = publishedEvents.map((e) => EEvent.fromEvent(e)).toList();
    List<EEvent> eUnpublishedEvents = unpublishedEvents.map((e) => EEvent.fromEvent(e)).toList();
    emit(EventsValidState(publishedEvents: ePublishedEvents, unpublishedEvents: eUnpublishedEvents));
  }

  void _loading(){
    EventsState currentState = state;
    if (currentState is EventsValidState){
      emit(EventsLoading(publishedEvents: currentState.publishedEvents, unpublishedEvents: currentState.unpublishedEvents)); 
    }
  }
}
