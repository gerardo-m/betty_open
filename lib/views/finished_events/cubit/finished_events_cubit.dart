import 'package:betty/models/event.dart';
import 'package:betty/services/events_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'finished_events_state.dart';

class FinishedEventsCubit extends Cubit<FinishedEventsState> {

  List<Event> finishedEvents = [];
  final EventsService _eventsService = GetIt.instance.get<EventsService>();

  FinishedEventsCubit() : super(FinishedEventsInitial());

  void loadEvents()async{
    _loading();
    finishedEvents = await _eventsService.getFinishedEvents();
    List<EEvent> eFinishedEvents = finishedEvents.map((e) => e.toEEvent()).toList();
    emit(FinishedEventsValidState(finishedEvents: eFinishedEvents));
  }

  void _loading(){
    FinishedEventsState currentState = state;
    if (currentState is FinishedEventsValidState){
      emit(FinishedEventsLoading(finishedEvents: currentState.finishedEvents));
    }
  }
}
