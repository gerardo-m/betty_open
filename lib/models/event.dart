import 'dart:convert';

import 'package:betty/models/event_item/positions_table_item.dart';
import 'package:betty/models/event_item/single_match_item.dart';
import 'package:betty/models/participant.dart';
import 'package:betty/models/prediction.dart';
import 'package:betty/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:betty/models/event_item.dart';
import 'package:betty/utils/enums.dart';

class Event {
  String id;
  String name;
  bool published;
  EventStatus status;
  List<EventItem> items;
  int itemCountLimit;

  String userId;
  String userName;
  bool hasResults;
  DateTime? createdAt;
  DateTime? updatedAt;

  // Not saved in the same collection
  List<Participant>? invitedParticipants;
  List<Participant>? acceptedParticipants;

  Prediction? eventResult;

  Event({
    required this.id,
    required this.name,
    this.published = false,
    this.status = EventStatus.open,
    required this.items,
    this.itemCountLimit = Constants.eventItemLimit,
    this.userId = '',
    this.userName = '',
    this.hasResults = false,
    this.createdAt,
    this.updatedAt,
  });

  factory Event.fromEEvent(EEvent eEvent) {
    return Event(
        id: eEvent.id,
        name: eEvent.name,
        published: eEvent.published,
        status: eEvent.status,
        items: [],
        userId: eEvent.userId,
        userName: eEvent.userName);
  }

  factory Event.createEmptyEvent() {
    return Event(id: '', name: 'Nuevo evento', items: []);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'published': published,
      'status': status.index,
      'items': items.map((x) => x.toMap()).toList(),
      'itemCountLimit': itemCountLimit,
      'userId': userId,
      'userName': userName,
      'hasResults': hasResults,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    Event event = Event(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      published: map['published'] ?? false,
      status: EventStatus.values[map['status']?? 0],
      items: [], //List<EventItem>.from(map['items']?.map((x) => EventItem.fromMap(x))),
      itemCountLimit: map['itemCountLimit'] ?? Constants.eventItemLimit,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      hasResults: map['hasResults'] ?? false,
      createdAt: map['createdAt'] != null ? (map['createdAt'] as Timestamp).toDate() : null,
      updatedAt: map['updatedAt'] != null ? (map['updatedAt'] as Timestamp).toDate() : null,
    );
    List<EventItem> items = List<EventItem>.from(map['items']?.map((x) {
      int typeIndex = x['type'];
      if (typeIndex == EventItemType.singleMatch.index) {
        return SingleMatchItem.fromMap(x, event);
      }
      if (typeIndex == EventItemType.positionsTable.index){
        return PositionsTableItem.fromMap(x, event);
      }
    }) ?? []);
    event.items = items;
    return event;
  }

  EEvent toEEvent(){
    return EEvent.fromEvent(this);
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) => Event.fromMap(json.decode(source));
}

class EEvent extends Equatable {
  final String id;
  final String name;
  final bool published;
  final EventStatus status;
  final List<EEventItem> items;
  final int itemCountLimit;

  final String userId;
  final String userName;
  final bool hasResults;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final List<EParticipant>? invitedParticipants;
  final List<EParticipant>? acceptedParticipants;

  const EEvent({
    required this.id,
    required this.name,
    this.published = false,
    this.status = EventStatus.open,
    this.items = const [],
    required this.itemCountLimit,
    required this.userId,
    required this.userName,
    required this.hasResults,
    required this.createdAt,
    required this.updatedAt,
    this.acceptedParticipants,
    this.invitedParticipants,
  });

  @override
  List<Object?> get props =>
      [id, name, published, status, items, itemCountLimit, userId, userName, hasResults, createdAt, updatedAt, invitedParticipants, acceptedParticipants];

  factory EEvent.fromEvent(Event event) {
    List<EEventItem> newItems = [];
    List<EParticipant>? invitedParticipants;
    List<EParticipant>? acceptedParticipants;
    for (EventItem item in event.items) {
      newItems.add(item.toEEventItem());
    }
    List<Participant>? eventInvitedParticipants = event.invitedParticipants;
    if (eventInvitedParticipants != null){
      invitedParticipants = [];
      for (Participant participant in eventInvitedParticipants){
        invitedParticipants.add(participant.toEParticipant());
      }
    }
    List<Participant>? eventAcceptedParticipants = event.acceptedParticipants;
    if (eventAcceptedParticipants != null){
      acceptedParticipants = [];
      for (Participant participant in eventAcceptedParticipants){
        acceptedParticipants.add(participant.toEParticipant());
      }
    }
    return EEvent(
        id: event.id,
        name: event.name,
        published: event.published,
        status: event.status,
        items: newItems,
        itemCountLimit: event.itemCountLimit,
        userId: event.userId,
        userName: event.userName,
        hasResults: event.hasResults,
        createdAt: event.createdAt,
        updatedAt: event.updatedAt,
        invitedParticipants: invitedParticipants,
        acceptedParticipants: acceptedParticipants);
  }
}
