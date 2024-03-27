import 'package:betty/models/prediction.dart';
import 'package:betty/services/event_results_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'event_results_state.dart';

class EventResultsCubit extends Cubit<EventResultsState> {

  final EventResultsService _eventResultsService = GetIt.instance.get<EventResultsService>();

  EventResultsCubit() : super(EventResultsInitial());

  void loadCurrentEventResult()async{
    _loading();
    await _eventResultsService.loadResultsForCurrentEvent();
    emit(EventResultsValidState(eventResult: _eventResultsService.currentEventResult!.toEPrediction()));
  }

  void reloadCurrentEventResult(){
    emit(EventResultsValidState(eventResult: _eventResultsService.currentEventResult!.toEPrediction()));
  }

  void save()async{
    _loading();
    EventResultsState currentState = state;
    if (currentState is EventResultsValidState){
      await _eventResultsService.saveCurrentEventResults();
      emit(EventResultsSaved(eventResult: _eventResultsService.currentEventResult!.toEPrediction()));
    }
  }

  void _loading(){
    EventResultsState currentState = state;
    if (currentState is EventResultsValidState){
      emit(EventResultsLoading(eventResult: currentState.eventResult)); 
    }
  }
}
