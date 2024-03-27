import 'package:equatable/equatable.dart';

import 'package:betty/models/prediction.dart';
import 'package:betty/models/prediction_item.dart';
import 'package:betty/utils/enums.dart';

class PredictionPositionsTableItem extends PredictionItem{

  List<TeamWithPoints> teams;
  bool includePoints;
  String name;
  PredictionPositionsTableItem({
    super.id = '',
    required super.prediction,
    required super.eventItemId,
    required this.teams,
    required this.includePoints,
    required this.name,
  });

  EPredictionPositionsTableItem toEPredictionPositionsTableItem(){
    return EPredictionPositionsTableItem(id: id, predictionId: prediction.id, eventItemId: eventItemId, name: name, teams: teams.toList(), includePoints: includePoints, );
  }
  
  @override
  EPredictionItem toEPredictionItem() {
    return toEPredictionPositionsTableItem();
  }
  
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'predictionId': prediction.id,
      'eventItemId': eventItemId,
      'teams': teams.map((e) => e.toMap()).toList(),
      'includePoints': includePoints,
      'name': name,
      'type': EventItemType.positionsTable.index,
    };
  }

  factory PredictionPositionsTableItem.fromMap(Map<String, dynamic> map, Prediction prediction) {
    PredictionPositionsTableItem item = PredictionPositionsTableItem(
      id: map['id'],
      prediction: prediction,
      eventItemId: map['eventItemId'],
      name: map['name'] ?? '',
      teams: List<TeamWithPoints>.from(map['teams'].map((x) => TeamWithPoints.fromMap(x))),
      includePoints: map['includePoints'],
    );
    return item;
  }

  factory PredictionPositionsTableItem.copyFrom(PredictionPositionsTableItem item) {
    return PredictionPositionsTableItem(
      eventItemId: item.eventItemId,
      prediction: item.prediction,
      name: item.name,
      includePoints: item.includePoints,
      teams: item.teams.toList(),
    );
  }
}

class EPredictionPositionsTableItem extends EPredictionItem {

  final List<TeamWithPoints> teams;
  final bool includePoints;
  final String name;
  const EPredictionPositionsTableItem({
    required super.id,
    required super.predictionId,
    required super.eventItemId,
    required this.name,
    required this.teams,
    required this.includePoints,
  });
  
  @override
  List<Object?> get props => [id, predictionId, eventItemId, teams, includePoints, name];
}



class TeamWithPoints extends Equatable implements Comparable {
  final String team;
  final int points;
  const TeamWithPoints({
    required this.team,
    this.points = 0,
  });
  
  @override
  List<Object?> get props => [team, points];

  TeamWithPoints copyWith({
    String? team,
    int? points,
  }) {
    return TeamWithPoints(
      team: team ?? this.team,
      points: points ?? this.points,
    );
  }
  
  @override
  int compareTo(other) {
    if (other is TeamWithPoints){
      return other.points - points;
    }
    throw ArgumentError('Is not a TeamWithPoints', 'other');
    
  }

  Map<String, dynamic> toMap() {
    return {
      'team': team,
      'points': points,
    };
  }

  factory TeamWithPoints.fromMap(Map<String, dynamic> map) {
    return TeamWithPoints(
      team: map['team'] ?? '',
      points: map['points']?.toInt() ?? 0,
    );
  }
}
