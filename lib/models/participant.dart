import 'package:equatable/equatable.dart';

import 'package:betty/models/event.dart';

class Participant {

  String id;
  Event event;
  String userId;
  String userIdentifier;
  String userName;
  bool accepted;
  String eventOwnerId;

  int points;

  Participant({
    this.id = '',
    required this.event,
    required this.userId,
    required this.userIdentifier,
    required this.userName,
    this.accepted = false,
    this.points = 0,
    this.eventOwnerId = '',
  });

  EParticipant toEParticipant(){
    return EParticipant.fromParticipant(this);
  }

}


class EParticipant extends Equatable {

  final String id;
  final String eventId;
  final String userId;
  final String userIdentifier;
  final String userName;
  final bool accepted;
  final String eventOwnerId;
  final int points;
  const EParticipant({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.userIdentifier,
    required this.userName,
    required this.accepted,
    required this.eventOwnerId,
    required this.points,
  });

  factory EParticipant.fromParticipant(Participant participant){
    return EParticipant(id: participant.id, eventId: participant.event.id, userId: participant.userId, userIdentifier: participant.userIdentifier, userName: participant.userName, accepted: participant.accepted, eventOwnerId: participant.eventOwnerId, points: participant.points);
  }
  
  @override
  List<Object?> get props => [id, eventId, userId, userIdentifier, userName, accepted, eventOwnerId, points];
}
