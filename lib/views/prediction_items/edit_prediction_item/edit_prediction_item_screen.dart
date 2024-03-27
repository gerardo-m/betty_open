import 'package:betty/utils/enums.dart';
import 'package:betty/views/prediction_items/edit_prediction_positions_table/cubit/edit_prediction_positions_table_cubit.dart';
import 'package:betty/views/prediction_items/edit_prediction_positions_table/edit_prediction_positions_table_screen.dart';
import 'package:betty/views/prediction_items/edit_prediction_single_match/cubit/edit_prediction_single_match_cubit.dart';
import 'package:betty/views/prediction_items/edit_prediction_single_match/edit_prediction_single_match_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditPredictionItemScreen extends StatelessWidget {
  const EditPredictionItemScreen({
    super.key,
    required this.eventItemType,
    required this.id,
    required this.source,
  });

  final EventItemType eventItemType;
  final String id;
  final PredictionItemSource source;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        switch (eventItemType) {
          case EventItemType.singleMatch:
            return BlocProvider(
              create: (context) =>
                  EditPredictionSingleMatchCubit()..loadPredictionItem(id, source),
              child: const EditPredictionSingleMatchScreen(),
            );
          case EventItemType.positionsTable:
            return BlocProvider( 
              create: (context) => EditPredictionPositionsTableCubit()..loadPredictionItem(id, source),
              child: const EditPredictionPositionsTableScreen(),
            );
          default:
            return const Scaffold();
        }
      },
    );
  }
}
