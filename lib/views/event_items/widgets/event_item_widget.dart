import 'package:betty/models/event_item.dart';
import 'package:betty/models/event_item/positions_table_item.dart';
import 'package:betty/models/event_item/single_match_item.dart';
import 'package:betty/utils/dialog_listener.dart';
import 'package:betty/views/edit_event/cubit/edit_event_cubit.dart';
import 'package:betty/views/event_items/widgets/positions_table_widget.dart';
import 'package:betty/views/event_items/widgets/single_match_widget.dart';
import 'package:betty/views/widgets/delete_tile_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class EventItemWidget extends StatelessWidget {
  final EEventItem eventItem;

  const EventItemWidget({Key? key, required this.eventItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(eventItem.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => showConfirmationMessage(context, 'Eliminar', '¿Está seguro que desea eliminar este item?'),
      background: const Placeholder(),
      secondaryBackground: const DeleteTileWidget(),
      onDismissed:(direction) => context.read<EditEventCubit>().deleteItem(eventItem.id),
      child: Builder(
        builder: (context) {
          if (eventItem is ESingleMatchItem) {
            return SingleMatchWidget(
              item: eventItem as ESingleMatchItem,
            );
          }
          if (eventItem is EPositionsTableItem){
            return PositionsTableWidget(
              item: eventItem as EPositionsTableItem,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}