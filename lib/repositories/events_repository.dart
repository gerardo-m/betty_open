import 'package:betty/models/event.dart';

abstract class EventsRepository{

  Future<Event?> saveEvent(Event event);
  Future<void> deleteEvent(String id);
  Future<Event?> getEvent(String id, {bool onlyCache = true});
  Future<List<Event>> getMyActiveEvents(String profileId);
  Future<List<Event>> getMyFinishedEvents(String profileId);
  Future<void> updateEventHasResult(String eventId, bool hasResults);
}