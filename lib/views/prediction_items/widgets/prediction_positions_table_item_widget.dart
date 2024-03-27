import 'package:betty/models/prediction_item/prediction_positions_table_item.dart';
import 'package:flutter/material.dart';

class PredictionPositionsTableItemWidget extends StatelessWidget {

  final double defaultTextSize = 20;
  final int maxShowingTeams = 4;
  final TextStyle titleTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  late final TextStyle teamTextStyle;
  late final int showingTeams;
  late final int notShowingTeams;

  final EPredictionPositionsTableItem predictionItem;
  final void Function()? onTap;

  PredictionPositionsTableItemWidget({super.key, required this.predictionItem, this.onTap}){
    teamTextStyle = TextStyle(fontSize: defaultTextSize, fontWeight: FontWeight.bold);
    int length = predictionItem.teams.length;
    if (length > maxShowingTeams){
      showingTeams = maxShowingTeams;
      notShowingTeams = length - maxShowingTeams;
    }else{
      showingTeams = length;
      notShowingTeams = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle scoreTextStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary,);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          children: [
            Text(predictionItem.name.isEmpty ? 'Tabla de posiciones' : predictionItem.name, style: titleTextStyle,),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < showingTeams; i++)
                        Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                  child: Text('${i + 1}', style: scoreTextStyle, textAlign: TextAlign.right,)
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(predictionItem.teams[i].team, style: teamTextStyle,),
                                ),
                              ],
                            )),
                      if (notShowingTeams > 0)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Text('... $notShowingTeams más'),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: predictionItem.includePoints
                      ? Column(
                        children: [
                          for(int i = 0; i < showingTeams; i++)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: SizedBox(
                                width: 30,
                                child: Text('${predictionItem.teams[i].points}', style: scoreTextStyle, textAlign: TextAlign.right,)
                              ),
                            ),
                        ],
                      )
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}