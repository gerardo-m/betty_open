import 'package:betty/models/event.dart';
import 'package:betty/models/event_item.dart';
import 'package:betty/models/event_item/positions_table_item.dart';
import 'package:betty/models/event_item/single_match_item.dart';
import 'package:betty/utils/enums.dart';
import 'package:uuid/uuid.dart';

class EventItemsService{

  EventItem? _currentEditingEventItem;
  bool newRecord = true;

  EventItemsService._();

  EventItem? get currentEditingEventItem => _currentEditingEventItem;

  factory EventItemsService(){
    return EventItemsService._();
  }

  void createNewEventItem(EventItemType type, Event event){
    String id = const Uuid().v4();
    switch (type) {
      case EventItemType.singleMatch:
        _currentEditingEventItem = SingleMatchItem(id: id, event: event, team1: '', team2: '', includeScore: false);
        break;
      case EventItemType.positionsTable:
        _currentEditingEventItem = PositionsTableItem(id: id, event: event, includePoints: false, teams: []);
        break;
      default:
        throw TypeError();
    }
    newRecord = true;
  }

  Future<void> editEventItem(String eventItemId, Event event)async{
    _currentEditingEventItem = event.items.firstWhere((element) => element.id == eventItemId);
    newRecord = false;
  }

  void saveCurrentEventItem(){
    if (_currentEditingEventItem != null && newRecord){
      _currentEditingEventItem!.event.items.add(_currentEditingEventItem!);
    }
  }
}