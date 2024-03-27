import 'package:betty/models/event_item/positions_table_item.dart';
import 'package:betty/views/edit_event/cubit/edit_event_cubit.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:betty/utils/utils.dart';

class PositionsTableWidget extends StatelessWidget {

  final EPositionsTableItem item;
  final double defaultTextSize = 20;
  final int maxShowingTeams = 4;
  late final TextStyle teamTextStyle;
  late final int showingTeams;
  late final int notShowingTeams;
  final TextStyle titleTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

  PositionsTableWidget({Key? key, required this.item}) : super(key: key){
    teamTextStyle = TextStyle(fontSize: defaultTextSize, fontWeight: FontWeight.bold);
    int length = item.teams.length;
    if (length > maxShowingTeams){
      showingTeams = maxShowingTeams;
      notShowingTeams = length - maxShowingTeams;
    }else{
      showingTeams = length;
      notShowingTeams = 0;
    }
    // if (item.team1.length > 15){
    //   team1TextStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    // }else{
    //   team1TextStyle = TextStyle(fontSize: defaultTextSize, fontWeight: FontWeight.bold);
    // }
    // if (item.team2.length > 20){
    //   team2TextStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    // }else{
    //   team2TextStyle = TextStyle(fontSize: defaultTextSize, fontWeight: FontWeight.bold);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        var result = await Navigator.pushNamed(
            context, BettyRoutes.editEventItem,
            arguments: {'eventItemType': EventItemType.positionsTable, 'id': item.id});
        if (result != null) {
          context.read<EditEventCubit>().reloadCurrentEvent();
        }
      },
      child: Card(
        child: Column(
          children: [
            Text(item.name.isEmpty ? 'Tabla de posiciones' : item.name, style: titleTextStyle,),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < showingTeams; i++)
                        Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: Text(item.teams[i], style: teamTextStyle,)),
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
                  height: 40,
                  child: item.includePoints
                      ? const Center(
                          child: Text(
                          'Incluye puntajes',
                          textAlign: TextAlign.center,
                        ))
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