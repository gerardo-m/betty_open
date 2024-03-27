import 'package:betty/utils/enums.dart';
import 'package:betty/views/coming_soon/coming_soon_screen.dart';
import 'package:betty/views/event_items/edit_positions_table/cubit/edit_positions_table_cubit.dart';
import 'package:betty/views/event_items/edit_positions_table/edit_positions_table_screen.dart';
import 'package:betty/views/event_items/edit_single_match/cubit/edit_single_match_cubit.dart';
import 'package:betty/views/event_items/edit_single_match/edit_single_match_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditEventItemScreen extends StatelessWidget {
  const EditEventItemScreen(
      {super.key, required this.eventItemType, this.eventItemId});

  final EventItemType eventItemType;
  final String? eventItemId;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        switch (eventItemType) {
          case EventItemType.singleMatch:
            return BlocProvider(
              create: (context) {
                if (eventItemId == null) {
                  return EditSingleMatchCubit()..createNewEventItem();
                }
                return EditSingleMatchCubit()..editEventItem(eventItemId!);
              },
              child: EditSingleMatchScreen(),
            );
          case EventItemType.positionsTable:
            return BlocProvider(
              create: (context) {//=> EditPositionsTableCubit()..createNewEventItem(),
                if (eventItemId == null) {
                  return EditPositionsTableCubit()..createNewEventItem();
                }
                return EditPositionsTableCubit()..editEventItem(eventItemId!);
              },
              child: const EditPositionsTableScreen(),
            );
          default:
            return const ComingSoonScreen();
        }
      },
    );
  }
}
