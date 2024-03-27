import 'package:betty/models/event.dart';
import 'package:equatable/equatable.dart';

abstract class EventItem {

  String id;
  Event event;
  EventItem? parent;

  EventItem({
    this.id = '',
    required this.event,
    this.parent,
  });

  EEventItem toEEventItem();

  Map<String, dynamic> toMap();
  factory EventItem.fromMap(Map<String, dynamic> map){
    throw UnimplementedError();
  }

}

abstract class EEventItem extends Equatable{
  final String id;
  final String eventId;

  const EEventItem({
    required this.id,
    required this.eventId,
  });

  @override
  List<Object?> get props => [id, eventId];
}
