import 'package:betty/models/event.dart';
import 'package:betty/repositories/events_repository.dart';
import 'package:json_store/json_store.dart';

class EventsRepositoryJsonstore extends EventsRepository{

  final JsonStore jsonStore = JsonStore();

  static const _eventsPreffix = 'events_';
  @override
  Future<List<Event>> getMyActiveEvents(String profileId) async{
    List<Map<String, dynamic>>? json = await jsonStore.getListLike('$_eventsPreffix%');
    if (json == null){
      return [];
    }else{
      return json.map((e) => Event.fromMap(e)).toList();
    }
  }

  @override
  Future<Event?> saveEvent(Event event) async{
    String id = '$_eventsPreffix${event.id}';
    await jsonStore.setItem(id, event.toMap());
    return event;
  }
  
  @override
  Future<Event?> getEvent(String id, {bool onlyCache = true}) async{
    Map<String, dynamic>? json = await jsonStore.getItem('$_eventsPreffix$id');
    if (json != null){
      return Event.fromMap(json);
    }else{
      return null;
    }
  }
  
  @override
  Future<void> deleteEvent(String id) {
    return jsonStore.deleteItem('$_eventsPreffix$id');
  }
  
  @override
  Future<void> updateEventHasResult(String eventId, bool hasResults) {
    // TODO: implement updateEventHasResult
    throw UnimplementedError();
  }
  
  @override
  Future<List<Event>> getMyFinishedEvents(String profileId) {
    // TODO: implement getMyFinishedEvents
    throw UnimplementedError();
  }

}