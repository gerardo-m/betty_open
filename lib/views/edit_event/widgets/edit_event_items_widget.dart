import 'package:betty/models/event.dart';
import 'package:betty/models/event_item.dart';
import 'package:betty/views/edit_event/cubit/edit_event_cubit.dart';
import 'package:betty/views/event_items/widgets/event_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:betty/utils/utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


class EditEventItemsWidget extends StatelessWidget {
  final EEvent event;

  const EditEventItemsWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            for (EEventItem item in event.items)
              EventItemWidget(eventItem: item),
          ],
        ),
        Positioned(
          bottom: 25,
          right: 15,
          child: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              if (event.items.length >= event.itemCountLimit){
                InterstitialAd? ad = context.read<EditEventCubit>().interstitialAd;
                if (ad != null) {
                  await ad.show();
                }
                context.read<EditEventCubit>().increaseItemCountLimit();
              }
              EventItemType? selectedType = await _selectItemType(context);
              if (selectedType != null) {
                var result = await Navigator.pushNamed(
                    context, BettyRoutes.editEventItem,
                    arguments: {'eventItemType': selectedType});
                if (result != null) {
                  context.read<EditEventCubit>().reloadCurrentEvent();
                }
              }
            },
          ),
        ),
      ],
    );
  }

  Future<EventItemType?> _selectItemType(BuildContext context) async {
    return showDialog<EventItemType>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            for (EventItemType type in EventItemType.values)
              SimpleDialogOption(
                child: Text(type.label),
                onPressed: () {
                  Navigator.pop(context, type);
                },
              ),
          ],
        );
      },
    );
  }
}
