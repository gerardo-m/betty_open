import 'package:betty/models/prediction_item.dart';
import 'package:betty/views/prediction_items/widgets/prediction_item_widget.dart';
import 'package:betty/views/show_prediction/cubit/show_prediction_cubit.dart';
import 'package:betty/views/widgets/event_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:betty/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowPredictionScreen extends StatelessWidget {
  const ShowPredictionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShowPredictionCubit, ShowPredictionState>(
      builder: (context, state) {
        if (state is ShowPredictionValidState) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: Text(state.prediction.eventName),
                ),
                body: ListView(
                  children: [
                    EventInfoWidget(
                      eventStatus: state.prediction.eventStatus.label,
                      participantsCount: state.event.acceptedParticipants?.length ?? 0,
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                    if (state.event.hasResults)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            BettyRoutes.showEventResults,
                          );
                        },
                        child: const Text('Resultados Evento'),
                      ),
                    if (!state.event.hasResults)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: Text('Resultados pendientes')),
                      ),
                    if (state.event.status == EventStatus.finished)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              BettyRoutes.showParticipantsRanking,
                              arguments: state.event.id);
                        },
                        child: const Text('Puntajes de los participantes'),
                      ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                    const ListTile(
                      title: Center(child: Text('Mi prediccion')),
                    ),
                    for (EPredictionItem item in state.prediction.items)
                      PredictionItemWidget(
                        predictionItem: item,
                        redirectToEdit: false,
                      ),
                  ],
                ),
              ),
              if (state is ShowPredictionLoading)
                Stack(
                  children: const [
                    Opacity(
                      opacity: 0.5,
                      child:
                          ModalBarrier(dismissible: false, color: Colors.black),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
