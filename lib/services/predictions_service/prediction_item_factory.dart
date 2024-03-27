import 'package:betty/models/event_item.dart';
import 'package:betty/models/event_item/positions_table_item.dart';
import 'package:betty/models/event_item/single_match_item.dart';
import 'package:betty/models/prediction.dart';
import 'package:betty/models/prediction_item.dart';
import 'package:betty/models/prediction_item/prediction_positions_table_item.dart';
import 'package:betty/models/prediction_item/prediction_single_match_item.dart';
import 'package:uuid/uuid.dart';

abstract class PredictionItemFactory {
  static PredictionItem buildPredictionItem(
      EventItem eventItem, Prediction prediction) {
    String id = const Uuid().v4();
    if (eventItem is SingleMatchItem) {
      return PredictionSingleMatchItem(
        id: id,
        prediction: prediction,
        eventItemId: eventItem.id,
        team1: eventItem.team1,
        team2: eventItem.team2,
        includeScore: eventItem.includeScore,
        includeTieBreaker: eventItem.includeTieBreaker,
        includeTieBreakerScore: eventItem.includeTieBreakerScore,
      );
    }
    if (eventItem is PositionsTableItem) {
      return PredictionPositionsTableItem(
        id: id,
        prediction: prediction,
        eventItemId: eventItem.id,
        teams: eventItem.teams.map((e) => TeamWithPoints(team: e, points: 0)).toList(),
        includePoints: eventItem.includePoints,
        name: eventItem.name,
      );
    }
    throw UnimplementedError();
  }
}
