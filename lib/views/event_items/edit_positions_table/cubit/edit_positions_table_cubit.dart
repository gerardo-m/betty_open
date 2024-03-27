import 'package:betty/models/event.dart';
import 'package:betty/models/event_item/positions_table_item.dart';
import 'package:betty/services/event_items_service.dart';
import 'package:betty/services/events_service.dart';
import 'package:betty/utils/enums.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'edit_positions_table_state.dart';

class EditPositionsTableCubit extends Cubit<EditPositionsTableState> {

  final EventItemsService _service = GetIt.instance.get<EventItemsService>();
  final EventsService eventsService = GetIt.instance.get<EventsService>();
  PositionsTableItem _item = PositionsTableItem.createEmptyPositionsTableItem();

  EditPositionsTableCubit() : super(EditPositionsTableInitial());

  void createNewEventItem(){
    Event event = eventsService.currentEditingEvent;
    _service.createNewEventItem(EventItemType.positionsTable, event);
    _item = _service.currentEditingEventItem as PositionsTableItem;
    _emitCurrentItem();
  }

  void editEventItem(String eventItemId)async{
    _loading();
    Event currentEditingEvent = eventsService.currentEditingEvent;
    await _service.editEventItem(eventItemId, currentEditingEvent);
    _item = _service.currentEditingEventItem as PositionsTableItem;
    _emitCurrentItem();
  }

  void changeName(String value){
    _item.name = value;
  }

  void changeIncludePoints(bool newValue){
    _item.includePoints = newValue;
    _emitCurrentItem();
  }

  void addTeam(String teamName){
    _item.teams.add(teamName);
    _emitCurrentItem();
  }

  void changeTeam(int index, String newName){
    _item.teams[index] = newName;
    _emitCurrentItem();
  }

  void save(){
    _service.saveCurrentEventItem();
  }

  void _emitCurrentItem(){
    EPositionsTableItem item = _item.toEPositionsTableItem();
    emit(EditPositionsTableValidState(item: item));
  }

  void _loading(){
    EditPositionsTableState currentState = state;
    if (currentState is EditPositionsTableValidState){
      emit(EditPositionsTableLoading(item: currentState.item));
    }
  }
}
