import 'package:betty/models/prediction_item/prediction_single_match_item.dart';
import 'package:flutter/material.dart';

class PredictionSingleMatchItemWidget extends StatelessWidget {
  final EPredictionSingleMatchItem predictionItem;
  final void Function()? onTap;

  final double defaultTextSize = 20;
  late final TextStyle team1TextStyle;
  late final TextStyle team2TextStyle;

  PredictionSingleMatchItemWidget({
    super.key,
    required this.predictionItem,
    this.onTap,
  }){
    if (predictionItem.team1.length > 15){
      team1TextStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    }else{
      team1TextStyle = TextStyle(fontSize: defaultTextSize, fontWeight: FontWeight.bold);
    }
    if (predictionItem.team2.length > 20){
      team2TextStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    }else{
      team2TextStyle = TextStyle(fontSize: defaultTextSize, fontWeight: FontWeight.bold);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle scoreTextStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(predictionItem.team1, style: team1TextStyle,)),
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(predictionItem.team2, style: team2TextStyle,)),
                ],
              ),
            ),
            if (predictionItem.includeScore)
              SizedBox(
                width: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(predictionItem.team1Score.toString(), style: scoreTextStyle,)),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(predictionItem.team2Score.toString(), style: scoreTextStyle,)),
                  ],
                ),
              ),
            if (!predictionItem.includeScore)
              SizedBox(
                width: 80,
                child: Column(
                  children: [
                    if (predictionItem.winner == SingleMatchWinner.draw)
                      Center(
                        child: Text('Empate', style: scoreTextStyle,),
                      ),
                    if (predictionItem.winner != SingleMatchWinner.draw)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(predictionItem.winner == SingleMatchWinner.team1 ? 'Ganador' : '', style: scoreTextStyle,)),
                    if (predictionItem.winner != SingleMatchWinner.draw)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(predictionItem.winner == SingleMatchWinner.team2 ? 'Ganador' : '', style: scoreTextStyle,)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
