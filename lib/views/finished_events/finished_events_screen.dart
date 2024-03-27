import 'package:betty/models/event.dart';
import 'package:betty/views/finished_events/cubit/finished_events_cubit.dart';
import 'package:flutter/material.dart';
import 'package:betty/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FinishedEventsScreen extends StatelessWidget {
  const FinishedEventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinishedEventsCubit, FinishedEventsState>(
      builder: (context, state) {
        if (state is FinishedEventsValidState){
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: const Text('Eventos finalizados'),
                ),
                body: ListView(
                  children: [
                    for (EEvent event in state.finishedEvents)
                      ListTile(
                        title: Text(event.name),
                        subtitle: Text('Estado: ${event.status.label}'),
                        onTap: () async {
                          Navigator.pushNamed(
                              context, BettyRoutes.publishedEvent,
                              arguments: event.id);
                          //context.read<FinishedEventsCubit>().loadEvents();
                        },
                      ),
                      // ListTile(
                      //   title: Text('Evento $i'),
                      // ),
                  ],
                ),
              ),
              if (state is FinishedEventsLoading)
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
        return const Center(child: CircularProgressIndicator(),);
      },
    );
  }
}
