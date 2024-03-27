import 'package:betty/models/event.dart';
import 'package:betty/models/event_item.dart';
import 'package:betty/models/event_item/single_match_item.dart';
import 'package:betty/services/event_items_service.dart';
import 'package:betty/services/events_service.dart';
import 'package:betty/utils/enums.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'edit_single_match_state.dart';

class EditSingleMatchCubit extends Cubit<EditSingleMatchState> {

  final EventsService eventsService = GetIt.instance.get<EventsService>();
  final EventItemsService eventItemsService = GetIt.instance.get<EventItemsService>();

  EditSingleMatchCubit() : super(EditSingleMatchInitial());

  void createNewEventItem(){
    Event currentEditingEvent = eventsService.currentEditingEvent;
    eventItemsService.createNewEventItem(EventItemType.singleMatch, currentEditingEvent);
    EventItem? item = eventItemsService.currentEditingEventItem;
    if (item != null){
      emit(EditSingleMatchValidState(eventItem: item.toEEventItem() as ESingleMatchItem));
    }
  }

  void editEventItem(String eventItemId)async{
    _loading();
    Event currentEditingEvent = eventsService.currentEditingEvent;
    await eventItemsService.editEventItem(eventItemId, currentEditingEvent);
    EventItem? item = eventItemsService.currentEditingEventItem;
    if (item != null){
      emit(EditSingleMatchValidState(eventItem: item.toEEventItem() as ESingleMatchItem));
    }
  }

  void save(SingleMatchItem item){
    SingleMatchItem? currentItem = eventItemsService.currentEditingEventItem as SingleMatchItem?;
    if (currentItem != null) {
      currentItem.team1 = item.team1;
      currentItem.team2 = item.team2;
      currentItem.includeScore = item.includeScore;
      currentItem.includeTieBreaker = item.includeTieBreaker;
      currentItem.includeTieBreakerScore = item.includeTieBreakerScore;
      eventItemsService.saveCurrentEventItem();
    }
  }

  void _loading(){
    EditSingleMatchState currentState = state;
    if (currentState is EditSingleMatchValidState){
      emit(EditSingleMatchLoading(eventItem: currentState.eventItem)); 
    }
  }

}
