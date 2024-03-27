import 'package:betty/models/prediction_item.dart';
import 'package:betty/models/prediction_item/prediction_positions_table_item.dart';
import 'package:betty/models/prediction_item/prediction_single_match_item.dart';
import 'package:betty/views/edit_prediction/cubit/edit_prediction_cubit.dart';
import 'package:betty/views/event_results/cubit/event_results_cubit.dart';
import 'package:betty/views/prediction_items/widgets/prediction_positions_table_item_widget.dart';
import 'package:betty/views/prediction_items/widgets/prediction_single_match_item_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:betty/utils/utils.dart';

class PredictionItemWidget extends StatelessWidget {
  final EPredictionItem predictionItem;
  final PredictionItemSource source;
  final bool redirectToEdit;

  const PredictionItemWidget({
    super.key,
    required this.predictionItem,
    this.source = PredictionItemSource.prediction,
    this.redirectToEdit = true,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (predictionItem is EPredictionSingleMatchItem) {
        return PredictionSingleMatchItemWidget(
          predictionItem: predictionItem as EPredictionSingleMatchItem,
          onTap: () async {
            await _onTap(
                context, EventItemType.singleMatch, predictionItem.id, source, redirectToEdit);
          },
        );
      }
      //if (predictionItem is EPredictionP)
      if (predictionItem is EPredictionPositionsTableItem){
        return PredictionPositionsTableItemWidget(
          predictionItem: predictionItem as EPredictionPositionsTableItem,
          onTap: () async {
            await _onTap(
                context, EventItemType.positionsTable, predictionItem.id, source, redirectToEdit);
          },
        );
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}

Future<void> _onTap(BuildContext context, EventItemType type,
    String predictionItemId, PredictionItemSource source, bool redirectToEdit) async {
  if (!redirectToEdit) return;
  final result = await Navigator.of(context)
      .pushNamed(BettyRoutes.editPredictionItem, arguments: {
    'eventItemType': type,
    'id': predictionItemId,
    'source': source,
  });
  if (result != null) {
    if (source == PredictionItemSource.prediction) {
      context.read<EditPredictionCubit>().reloadPrediction();
    }
    if (source == PredictionItemSource.eventResult) {
      context.read<EventResultsCubit>().reloadCurrentEventResult();
    }
    //
  }
}
