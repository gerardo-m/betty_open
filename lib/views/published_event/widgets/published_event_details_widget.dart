import 'package:betty/models/event.dart';
import 'package:betty/views/published_event/cubit/published_event_cubit.dart';
import 'package:flutter/material.dart';
import 'package:betty/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class PublishedEventDetailsWidget extends StatelessWidget {
  final EEvent event;

  const PublishedEventDetailsWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Estado: ${event.status.label}'),
              ),
              if (event.status == EventStatus.open)
                ElevatedButton(
                  onPressed: () async {
                    bool? confirm = await showConfirmationMessage(
                        context,
                        'Cerrar evento',
                        '¿Está seguro de cerrar el evento? Los participantes ya no podrán subir mas predicciones');
                    if (confirm ?? false) {
                      context
                          .read<PublishedEventCubit>()
                          .changeEventStatus(EventStatus.closed);
                    }
                  },
                  child: const Text('Cerrar predicciones'),
                ),
              if (event.status == EventStatus.closed)
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(BettyRoutes.editEventResults);
                      },
                      child: const Text('Registrar resultados'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        bool? confirm = await showConfirmationMessage(
                            context,
                            'Calcular y finalizar',
                            '¿Está seguro que desea calcular las puntuaciones? Después de esta acción el evento no podrá ser editado de ninguna forma');
                        if (confirm ?? false) {
                          InterstitialAd? ad = context.read<PublishedEventCubit>().interstitialAd;
                          if (ad != null){
                            await ad.show();
                          }
                          await Navigator.of(context).pushNamed(
                              BettyRoutes.calculateParticipantsRanking,
                              arguments: event.id);
                          context
                              .read<PublishedEventCubit>()
                              .changeEventStatus(EventStatus.finished);
                        }
                      },
                      child: const Text('Calcular puntuaciones'),
                    ),
                  ],
                ),
              if (event.status == EventStatus.finished)
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(BettyRoutes.showEventResults);
                      },
                      child: const Text('Ver resultados'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            BettyRoutes.showParticipantsRanking,
                            arguments: event.id);
                      },
                      child: const Text('Ver puntuaciones'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}