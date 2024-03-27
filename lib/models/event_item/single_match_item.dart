import 'dart:convert';

import 'package:betty/models/event.dart';
import 'package:betty/models/event_item.dart';
import 'package:betty/utils/enums.dart';

class SingleMatchItem extends EventItem {
  String team1;
  String team2;
  bool includeScore;
  bool includeTieBreaker;
  bool includeTieBreakerScore;
  SingleMatchItem({
    super.id,
    required super.event,
    super.parent,
    required this.team1,
    required this.team2,
    required this.includeScore,
    this.includeTieBreaker = false,
    this.includeTieBreakerScore = false,
  });

  factory SingleMatchItem.createEmptySingleMatchItem() {
    return SingleMatchItem(
      event: Event.createEmptyEvent(),
      team1: '',
      team2: '',
      includeScore: false,
    );
  }

  @override
  EEventItem toEEventItem() {
    return ESingleMatchItem(
      id: id,
      eventId: event.id,
      team1: team1,
      team2: team2,
      includeScore: includeScore,
      includeTieBreaker: includeTieBreaker,
      includeTieBreakerScore: includeTieBreakerScore,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event': event.id,
      'parent': parent,
      'team1': team1,
      'team2': team2,
      'includeScore': includeScore,
      'includeTieBreaker': includeTieBreaker,
      'includeTieBreakerScore': includeTieBreakerScore,
      'type': EventItemType.singleMatch.index,
    };
  }

  factory SingleMatchItem.fromMap(Map<String, dynamic> map, Event event,
      {EventItem? parent}) {
    return SingleMatchItem(
      id: map['id'] ?? '',
      event: event,
      parent: parent,
      team1: map['team1'] ?? '',
      team2: map['team2'] ?? '',
      includeScore: map['includeScore'] ?? false,
      includeTieBreaker: map['includeTieBreaker'] ?? false,
      includeTieBreakerScore: map['includeTieBreakerScore'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory SingleMatchItem.fromJson(String source, Event event) =>
      SingleMatchItem.fromMap(json.decode(source), event);
}

class ESingleMatchItem extends EEventItem {
  final String team1;
  final String team2;
  final bool includeScore;
  final bool includeTieBreaker;
  final bool includeTieBreakerScore;
  const ESingleMatchItem({
    required super.id,
    required super.eventId,
    required this.team1,
    required this.team2,
    required this.includeScore,
    required this.includeTieBreaker,
    required this.includeTieBreakerScore,
  });

  @override
  List<Object?> get props => [
        id,
        eventId,
        team1,
        team2,
        includeScore,
        includeTieBreaker,
        includeTieBreakerScore
      ];

  factory ESingleMatchItem.fromSingleMatchItem(
      SingleMatchItem singleMatchItem) {
    return ESingleMatchItem(
      id: singleMatchItem.id,
      eventId: singleMatchItem.event.id,
      team1: singleMatchItem.team1,
      team2: singleMatchItem.team2,
      includeScore: singleMatchItem.includeScore,
      includeTieBreaker: singleMatchItem.includeTieBreaker,
      includeTieBreakerScore: singleMatchItem.includeTieBreakerScore,
    );
  }
}
