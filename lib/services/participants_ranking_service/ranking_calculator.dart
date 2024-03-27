import 'package:betty/models/participant.dart';
import 'package:betty/models/prediction.dart';
import 'package:betty/models/prediction_item.dart';
import 'package:betty/models/prediction_item/prediction_positions_table_item.dart';
import 'package:betty/models/prediction_item/prediction_single_match_item.dart';

abstract class RankingCalculator{

  static void calculatePoints(Participant participant, Prediction prediction, Prediction eventResults) {
    int points = 0;
    for (PredictionItem item in prediction.items){
      PredictionItem eventResultsItem = eventResults.items.firstWhere((element) => element.eventItemId == item.eventItemId);
      points += _calculatePointsForItem(item, eventResultsItem);
    }
    participant.points = points;
  }

  static int _calculatePointsForItem(PredictionItem predictionItem, PredictionItem eventResultsItem){
    if (predictionItem is PredictionSingleMatchItem){
      return _calculatePointsForSingleMatch(predictionItem, eventResultsItem as PredictionSingleMatchItem);
    }
    if (predictionItem is PredictionPositionsTableItem){
      return _calculatePointsForPositionsTable(predictionItem, eventResultsItem as PredictionPositionsTableItem);
    }
    return 0;
  }

  static int _calculatePointsForSingleMatch(PredictionSingleMatchItem predictionItem, PredictionSingleMatchItem eventResultsItem){
    int points = 0;
    if (predictionItem.winner == eventResultsItem.winner){
      points++;
    }
    if (eventResultsItem.includeScore){
      if (predictionItem.team1Score == eventResultsItem.team1Score && predictionItem.team2Score == eventResultsItem.team2Score){
        points++;
      }
    }
    if (eventResultsItem.winner == SingleMatchWinner.draw && eventResultsItem.includeTieBreaker){
      if (predictionItem.tieBreakerWinner == eventResultsItem.tieBreakerWinner){
        points++;
      }
      if (eventResultsItem.includeTieBreakerScore){
        if (predictionItem.team1TieBreakerScore == eventResultsItem.team1TieBreakerScore && predictionItem.team2TieBreakerScore == eventResultsItem.team2TieBreakerScore){
          points++;
        }
      }
    }
    return points;
  }

  static int _calculatePointsForPositionsTable(PredictionPositionsTableItem predictionItem, PredictionPositionsTableItem eventResultsItem){
    int points = 0;
    int positionPoints = 0;
    int maxPositionPoints = predictionItem.teams.length - 1;
    for (int i = 0; i < predictionItem.teams.length; i++){
      bool addPositionPoints = predictionItem.teams[i].team == eventResultsItem.teams[i].team && positionPoints < maxPositionPoints;
      if (predictionItem.includePoints){
        String teamName = predictionItem.teams[i].team;
        int pointsOfTheTeamInResults = eventResultsItem.teams.firstWhere((element) => element.team == teamName).points;
        if (!addPositionPoints && positionPoints < maxPositionPoints){
          addPositionPoints = eventResultsItem.teams[i].points == pointsOfTheTeamInResults;
        }
        if (predictionItem.teams[i].points == pointsOfTheTeamInResults){
          points++;
        }
      }
      if (addPositionPoints){
        positionPoints++;
      }
    }
    return positionPoints + points;
  }
}