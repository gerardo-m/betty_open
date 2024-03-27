
import 'package:betty/models/event_item/single_match_item.dart';
import 'package:betty/utils/utils.dart';
import 'package:betty/views/edit_event/cubit/edit_event_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleMatchWidget extends StatelessWidget {
  final ESingleMatchItem item;
  final double defaultTextSize = 20;
  late final TextStyle team1TextStyle;
  late final TextStyle team2TextStyle;

  SingleMatchWidget({super.key, required this.item}){
    if (item.team1.length > 15){
      team1TextStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    }else{
      team1TextStyle = TextStyle(fontSize: defaultTextSize, fontWeight: FontWeight.bold);
    }
    if (item.team2.length > 20){
      team2TextStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    }else{
      team2TextStyle = TextStyle(fontSize: defaultTextSize, fontWeight: FontWeight.bold);
    }

  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      child: Card(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(item.team1, style: team1TextStyle,)),
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(item.team2, style: team2TextStyle,)),
                    ],
                  ),
                ),
                SizedBox(
                  width: 70,
                  height: 40,
                  child: item.includeScore
                      ? const Center(
                          child: Text(
                          'Incluye marcador',
                          textAlign: TextAlign.center,
                        ))
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () async {
        var result = await Navigator.pushNamed(
            context, BettyRoutes.editEventItem,
            arguments: {'eventItemType': EventItemType.singleMatch, 'id': item.id});
        if (result != null) {
          context.read<EditEventCubit>().reloadCurrentEvent();
        }
      },
    );
  }
}
