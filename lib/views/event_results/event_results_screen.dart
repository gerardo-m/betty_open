import 'package:betty/models/prediction_item.dart';
import 'package:betty/views/event_results/cubit/event_results_cubit.dart';
import 'package:betty/views/prediction_items/widgets/prediction_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:betty/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventResultsScreen extends StatelessWidget {
  const EventResultsScreen({Key? key, required this.allowEdition}) : super(key: key);

  final bool allowEdition;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventResultsCubit, EventResultsState>(
      listener: (context, state) {
        if (state is EventResultsSaved){
          Navigator.of(context).pop(state.eventResult);
        }
      },
      builder: (context, state) {
        if (state is EventResultsValidState){
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: const Text('Resultados Evento'),
                  actions: [
                    if (allowEdition)
                      IconButton(
                        onPressed: () async{
                          bool? confirm = await showConfirmationMessage(context, 'Guardar resultados', '¿Seguro que desea guardar? esta acción no puede deshacerse');
                          if (confirm ?? false){
                            context.read<EventResultsCubit>().save();
                          }
                        },
                        icon: const Icon(Icons.check),
                      ),
                  ],
                ),
                body: ListView(
                  children: [
                    for (EPredictionItem item in state.eventResult.items) 
                      PredictionItemWidget(predictionItem: item, source: PredictionItemSource.eventResult, redirectToEdit: allowEdition),
                  ],
                ),
              ),
              if (state is EventResultsLoading)
                Stack(
                  children: const [
                    Opacity(
                      opacity: 0.5,
                      child: ModalBarrier(dismissible: false, color: Colors.black),
                    ),
                    Center(child: CircularProgressIndicator(),),
                  ],
                ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator(),);
        
      },
    );
  }
}
