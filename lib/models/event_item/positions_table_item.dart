import 'package:betty/models/event.dart';
import 'package:betty/models/event_item.dart';
import 'package:betty/utils/enums.dart';

class PositionsTableItem extends EventItem{

  bool includePoints;
  List<String> teams;
  String name;

  PositionsTableItem({
    super.id,
    required super.event,
    super.parent,
    required this.includePoints,
    required this.teams,
    this.name = '',
  });

  factory PositionsTableItem.createEmptyPositionsTableItem(){
    return PositionsTableItem(event: Event.createEmptyEvent(), includePoints: false, teams: []);
  }

  EPositionsTableItem toEPositionsTableItem(){
    return EPositionsTableItem(id: id, eventId: event.id, name: name, includePoints: includePoints, teams: teams.toList());
  }
  
  @override
  EEventItem toEEventItem() {
    return toEPositionsTableItem();
  }
  
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event': event.id,
      'parent': parent,
      'name': name,
      'teams': teams,
      'includePoints': includePoints,
      'type': EventItemType.positionsTable.index,
    };
  }

  factory PositionsTableItem.fromMap(Map<String, dynamic> map, Event event, {EventItem? parent}) {
    return PositionsTableItem(
      id: map['id'] ?? '',
      event: event,
      parent: parent,
      name: map['name'] ?? '',
      teams: (map['teams'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      includePoints: map['includePoints'] ?? false,
    );
  }
}

class EPositionsTableItem extends EEventItem{

  final bool includePoints;
  final List<String> teams;
  final String name;

  const EPositionsTableItem({
    required super.id,
    required super.eventId,
    required this.includePoints,
    required this.teams,
    required this.name,
  });
  
  @override
  List<Object?> get props => [id, eventId, includePoints, teams, name];
}
