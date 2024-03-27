import 'package:betty/models/event.dart';
import 'package:betty/models/prediction.dart';
import 'package:betty/utils/utils.dart';
import 'package:betty/views/predictions/cubit/predictions_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PredictionsScreen extends StatelessWidget {
  const PredictionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PredictionsCubit, PredictionsState>(
      builder: (context, state) {
        if (state is PredictionsValidState){
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: const Text('Mis predicciones'),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, BettyRoutes.searchEvents);
                  },
                  child: const Icon(Icons.add),
                ),
                body: ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Eventos aceptados'),
                    ),
                    Column(
                      children: [
                        for(EPrediction prediction in state.eventsAccepted)
                          ListTile(
                            title: Text(prediction.eventName),
                            subtitle: Text('Predicción enviada: ${prediction.sent ? 'Si' : 'No'}'),
                            onTap: () async{
                              if (prediction.sent || prediction.eventStatus != EventStatus.open){
                                Navigator.of(context).pushNamed(BettyRoutes.showPrediction, arguments: prediction.eventId);
                              }else{
                                final result = await Navigator.of(context).pushNamed(BettyRoutes.editPrediction, arguments: prediction.eventId);
                                if (result != null){
                                  context.read<PredictionsCubit>().loadEvents();
                                }
                              }
                              
                            },
                          )
                      ],
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 2,
                      indent: 5,
                      endIndent: 5,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Invitaciones pendientes'),
                    ),
                    Column(
                      children: [
                        for(EEvent event in state.eventsInvited)
                          ListTile(
                            title: Text(event.name),
                            subtitle: Text(event.status.label),
                            onTap: () async{
                              bool? confirm = await showConfirmationMessage(context, 'Confirmar invitación', '¿Confirmas que quieres participar en el evento ${event.name}?');
                              if (confirm ?? false){
                                await context.read<PredictionsCubit>().acceptEvent(event.id);
                                final result = await Navigator.of(context).pushNamed(BettyRoutes.editPrediction, arguments: event.id);
                                if (result != null){
                                  context.read<PredictionsCubit>().loadEvents();
                                }
                              }
                            },
                          )
                      ],
                    ), 
                    const Divider(
                      color: Colors.grey,
                      thickness: 2,
                      indent: 5,
                      endIndent: 5,
                    ),
                  ],
                ),
              ),
              if (state is PredictionsLoading)
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
