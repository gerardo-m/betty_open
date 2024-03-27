import 'package:betty/models/event.dart';
import 'package:betty/models/prediction.dart';
import 'package:betty/services/predictions_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'predictions_state.dart';

class PredictionsCubit extends Cubit<PredictionsState> {

  //final EventsService _eventsService = GetIt.instance.get<EventsService>();
  final PredictionsService _predictionsService = GetIt.instance.get<PredictionsService>();

  PredictionsCubit() : super(PredictionsInitial());

  Future<void> loadEvents() async{
    _loading();
    _showEvents();
  }

  Future<void> acceptEvent(String eventId)async{
    _loading();
    await _predictionsService.acceptEventInvitation(eventId);
    _showEvents();
  }

  Future<void> _showEvents()async{
    List<Prediction> acceptedEvents = await  _predictionsService.getEventsAcceptedForCurrentUser();
    List<Event> invitedEvents = await _predictionsService.getEventsInvitedForCurrentUser();
    List<EPrediction> eAcceptedEvents = acceptedEvents.map((e) => e.toEPrediction()).toList();
    List<EEvent> eEventInvitations = invitedEvents.map((e) => EEvent.fromEvent(e)).toList();
    emit(PredictionsValidState(eventsAccepted: eAcceptedEvents, eventsInvited: eEventInvitations));
  }

  void _loading(){
    PredictionsState currentState = state;
    if (currentState is PredictionsValidState){
      emit(PredictionsLoading(eventsAccepted: currentState.eventsAccepted, eventsInvited: currentState.eventsInvited)); 
    }
  }
}
