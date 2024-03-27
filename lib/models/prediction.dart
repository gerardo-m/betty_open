import 'dart:convert';

import 'package:betty/models/prediction_item/prediction_positions_table_item.dart';
import 'package:betty/models/prediction_item/prediction_single_match_item.dart';
import 'package:betty/utils/enums.dart';
import 'package:equatable/equatable.dart';

import 'package:betty/models/event.dart';
import 'package:betty/models/prediction_item.dart';

class Prediction {
  String id;
  String userId;
  bool sent;

  String eventId;
  String eventName;
  EventStatus eventStatus;

  List<PredictionItem> items;
  Prediction({
    this.id = '',
    required this.userId,
    required this.items,
    required this.eventId,
    required this.eventName,
    required this.eventStatus,
    this.sent = false,
  });

  factory Prediction.createEmptyPrediction(Event event) {
    return Prediction(
        userId: '',
        eventId: event.id,
        eventName: event.name,
        eventStatus: event.status,
        items: []);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'sent': sent,
      'eventId': eventId,
      'eventName': eventName,
      'eventStatus': eventStatus.index,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory Prediction.fromMap(Map<String, dynamic> map) {
    Prediction newPrediction = Prediction(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      sent: map['sent'] ?? false,
      eventId: map['eventId'] ?? '',
      eventName: map['eventName'] ?? '',
      eventStatus: EventStatus.values[map['eventStatus'] ?? 0],
      items: [],
    );
    List<PredictionItem> items =
        List<PredictionItem>.from(map['items']?.map((x) {
              int typeIndex = x['type'];
              if (typeIndex == EventItemType.singleMatch.index) {
                return PredictionSingleMatchItem.fromMap(x, newPrediction);
              }
              if (typeIndex == EventItemType.positionsTable.index){
                return PredictionPositionsTableItem.fromMap(x, newPrediction);
              }
            }) ??
            []);
    newPrediction.items = items;
    return newPrediction;
  }

  String toJson() => json.encode(toMap());

  factory Prediction.fromJson(String source) =>
      Prediction.fromMap(json.decode(source));

  EPrediction toEPrediction() {
    return EPrediction.fromPrediction(this);
  }
}

class EPrediction extends Equatable {
  final String id;
  final String userId;
  final bool sent;

  final String eventId;
  final String eventName;
  final EventStatus eventStatus;

  final List<EPredictionItem> items;
  const EPrediction({
    required this.id,
    required this.userId,
    required this.sent,
    required this.eventId,
    required this.eventName,
    required this.eventStatus,
    this.items = const [],
  });

  @override
  List<Object?> get props =>
      [id, userId, eventId, eventName, eventStatus, items];

  factory EPrediction.fromPrediction(Prediction prediction) {
    List<EPredictionItem> newItems = [];
    for (PredictionItem item in prediction.items) {
      newItems.add(item.toEPredictionItem());
    }
    return EPrediction(
      id: prediction.id,
      userId: prediction.userId,
      sent: prediction.sent,
      eventId: prediction.eventId,
      eventName: prediction.eventName,
      eventStatus: prediction.eventStatus,
      items: newItems,
    );
  }
}
