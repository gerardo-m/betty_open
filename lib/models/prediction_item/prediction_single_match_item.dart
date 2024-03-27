
import 'dart:convert';

import 'package:betty/models/event_item.dart';
import 'package:betty/models/prediction.dart';
import 'package:betty/models/prediction_item.dart';
import 'package:betty/utils/enums.dart';

enum SingleMatchWinner { team1, team2, draw }

class PredictionSingleMatchItem extends PredictionItem {
  SingleMatchWinner winner;
  int? team1Score;
  int? team2Score;
  SingleMatchWinner? tieBreakerWinner;
  int? team1TieBreakerScore;
  int? team2TieBreakerScore;

  String team1;
  String team2;
  bool includeScore;
  bool includeTieBreaker;
  bool includeTieBreakerScore;

  PredictionSingleMatchItem({
    super.id = '',
    required super.prediction,
    //required super.eventItem,
    required super.eventItemId,
    required this.team1,
    required this.team2,
    required this.includeScore,
    required this.includeTieBreaker,
    required this.includeTieBreakerScore,
    this.winner = SingleMatchWinner.draw,
    this.team1Score = 0,
    this.team2Score = 0,
    this.tieBreakerWinner,
    this.team1TieBreakerScore = 0,
    this.team2TieBreakerScore = 0,
  }){
    adjustWinners();
  }

  @override
  EPredictionItem toEPredictionItem() {
    return EPredictionSingleMatchItem(
      id: id,
      predictionId: prediction.id,
      //eventItem: ESingleMatchItem.fromSingleMatchItem(eventItem as SingleMatchItem),
      eventItemId: eventItemId,
      team1: team1,
      team2: team2,
      includeScore: includeScore,
      includeTieBreaker: includeTieBreaker,
      includeTieBreakerScore: includeTieBreakerScore,
      winner: winner,
      team1Score: team1Score,
      team2Score: team2Score,
      tieBreakerWinner: tieBreakerWinner,
      team1TieBreakerScore: team1TieBreakerScore,
      team2TieBreakerScore: team2TieBreakerScore,
    );
  }

  
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'predictionId': prediction.id,
      //'eventItemId': eventItem.id,
      'eventItemId': eventItemId,
      'team1': team1,
      'team2': team2,
      'includeScore': includeScore,
      'includeTieBreaker': includeTieBreaker,
      'includeTieBreakerScore': includeTieBreakerScore,
      'winner': winner.index,
      'team1Score': team1Score,
      'team2Score': team2Score,
      'tieBreakerWinner': tieBreakerWinner?.index,
      'team1TieBreakerScore': team1TieBreakerScore,
      'team2TieBreakerScore': team2TieBreakerScore,
      'type': EventItemType.singleMatch.index,
    };
  }

  factory PredictionSingleMatchItem.fromMap(Map<String, dynamic> map, Prediction prediction) {
    return PredictionSingleMatchItem(
      id: map['id'],
      prediction: prediction,
      //eventItem: eventItem,
      eventItemId: map['eventItemId'],
      team1: map['team1'],
      team2: map['team2'],
      includeScore: map['includeScore'],
      includeTieBreaker: map['includeTieBreaker'] ?? false,
      includeTieBreakerScore: map['includeTieBreakerScore'] ?? false,
      winner: SingleMatchWinner.values[map['winner']],
      team1Score: map['team1Score']?.toInt(),
      team2Score: map['team2Score']?.toInt(),
      tieBreakerWinner: SingleMatchWinner.values[map['tieBreakerWinner'] ?? 2],
      team1TieBreakerScore: map['team1TieBreakerScore'],
      team2TieBreakerScore: map['team2TieBreakerScore'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PredictionSingleMatchItem.fromJson(String source, Prediction prediction, EventItem eventItem) => PredictionSingleMatchItem.fromMap(json.decode(source), prediction,);

  PredictionSingleMatchItem copyWith({
    SingleMatchWinner? winner,
    int? team1Score,
    int? team2Score,
    String? team1,
    String? team2,
    bool? includeScore,
    bool? includeTieBreaker,
    bool? includeTieBreakerScore,
    SingleMatchWinner? tieBreakerWinner,
    int? team1TieBreakerScore,
    int? team2TieBreakerScore,
  }) {
    return PredictionSingleMatchItem(
      eventItemId: eventItemId,
      prediction: prediction,
      winner: winner ?? this.winner,
      team1Score: team1Score ?? this.team1Score,
      team2Score: team2Score ?? this.team2Score,
      team1: team1 ?? this.team1,
      team2: team2 ?? this.team2,
      includeScore: includeScore ?? this.includeScore,
      includeTieBreaker: includeTieBreaker ?? this.includeTieBreaker,
      includeTieBreakerScore: includeTieBreakerScore ?? this.includeTieBreakerScore,
      tieBreakerWinner: tieBreakerWinner ?? this.tieBreakerWinner,
      team1TieBreakerScore: team1TieBreakerScore ?? this.team1TieBreakerScore,
      team2TieBreakerScore: team2TieBreakerScore ?? this.team2TieBreakerScore,
    );
  }

  factory PredictionSingleMatchItem.copyFrom(PredictionSingleMatchItem item) {
    return PredictionSingleMatchItem(
      eventItemId: item.eventItemId,
      prediction: item.prediction,
      winner: item.winner,
      team1Score: item.team1Score,
      team2Score: item.team2Score,
      team1: item.team1,
      team2: item.team2,
      includeScore: item.includeScore,
      includeTieBreaker: item.includeTieBreaker,
      includeTieBreakerScore: item.includeTieBreakerScore,
      tieBreakerWinner: item.tieBreakerWinner,
      team1TieBreakerScore: item.team1TieBreakerScore,
      team2TieBreakerScore: item.team2TieBreakerScore,
    );
  }

  void adjustWinners(){
    if (includeScore){
      if ((team1Score ?? 0) > (team2Score ?? 0)){
        winner = SingleMatchWinner.team1;
        return;
      }
      if ((team2Score ?? 0) > (team1Score ?? 0)){
        winner = SingleMatchWinner.team2;
        return;
      }
      winner = SingleMatchWinner.draw;
    }
    if (includeTieBreakerScore){
      if ((team1TieBreakerScore ?? 0) > (team2TieBreakerScore ?? 0)){
        tieBreakerWinner = SingleMatchWinner.team1;
        return;
      }
      if ((team2TieBreakerScore ?? 0) > (team1TieBreakerScore ?? 0)){
        tieBreakerWinner = SingleMatchWinner.team2;
        return;
      }
      tieBreakerWinner = SingleMatchWinner.draw;
    }
  }
}

class EPredictionSingleMatchItem extends EPredictionItem {
  final SingleMatchWinner winner;
  final int? team1Score;
  final int? team2Score;
  final SingleMatchWinner? tieBreakerWinner;
  final int? team1TieBreakerScore;
  final int? team2TieBreakerScore;

  final String team1;
  final String team2;
  final bool includeScore;
  final bool includeTieBreaker;
  final bool includeTieBreakerScore;

  const EPredictionSingleMatchItem({
    required super.id,
    required super.predictionId,
    required super.eventItemId,
    //required super.eventItem,
    required this.team1,
    required this.team2,
    required this.includeScore,
    required this.includeTieBreaker,
    required this.includeTieBreakerScore,
    required this.winner,
    required this.team1Score,
    required this.team2Score,
    required this.tieBreakerWinner,
    required this.team1TieBreakerScore,
    required this.team2TieBreakerScore,
  });

  @override
  List<Object?> get props => [
        id,
        predictionId,
        eventItemId,
        //eventItem,
        team1,
        team2,
        includeScore,
        includeTieBreaker,
        includeTieBreakerScore,
        winner,
        team1Score,
        team2Score,
        tieBreakerWinner,
        team1TieBreakerScore,
        team2TieBreakerScore,
      ];

  factory EPredictionSingleMatchItem.fromPredictionSingleMatchItem(
      PredictionSingleMatchItem item) {
    return EPredictionSingleMatchItem(
      id: item.id,
      predictionId: item.prediction.id,
      eventItemId: item.eventItemId,
      // eventItem: ESingleMatchItem.fromSingleMatchItem(
      //     item.eventItem as SingleMatchItem),
      team1: item.team1,
      team2: item.team2,
      includeScore: item.includeScore,
      includeTieBreaker: item.includeTieBreaker,
      includeTieBreakerScore: item.includeTieBreakerScore,
      winner: item.winner,
      team1Score: item.team1Score,
      team2Score: item.team2Score,
      tieBreakerWinner: item.tieBreakerWinner,
      team1TieBreakerScore: item.team1TieBreakerScore,
      team2TieBreakerScore: item.team2TieBreakerScore,
    );
  }

  //ESingleMatchItem get singleMatchItem => eventItem as ESingleMatchItem;
}
