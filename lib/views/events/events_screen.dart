import 'package:betty/models/event.dart';
import 'package:betty/utils/utils.dart';
import 'package:betty/views/events/cubit/events_cubit.dart';
import 'package:betty/views/widgets/list_divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsCubit, EventsState>(
      builder: (context, state) {
        if (state is EventsValidState) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: const Text('Eventos activos'),
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView(
                    children: [
                      const ListDividerWidget(label: 'Eventos publicados'),
                      Column(
                        children: [
                          for (EEvent event in state.publishedEvents)
                            ListTile(
                              title: Text(event.name),
                              subtitle: Text('Estado: ${event.status.label}'),
                              onTap: () async {
                                await Navigator.pushNamed(
                                    context, BettyRoutes.publishedEvent,
                                    arguments: event.id);
                                context.read<EventsCubit>().loadEvents();
                              },
                            ),
                        ],
                      ),
                      const ListDividerWidget(label: 'Eventos no publicados'),
                      Column(
                        children: [
                          for (EEvent event in state.unpublishedEvents)
                            ListTile(
                              title: Text(event.name),
                              onTap: () async {
                                await Navigator.pushNamed(
                                    context, BettyRoutes.editEvent,
                                    arguments: event.id);
                                context.read<EventsCubit>().loadEvents();
                              },
                            ),
                        ],
                      ),
                      const ListDividerWidget(label: ''),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, BettyRoutes.finishedEvents);
                        },
                        child: const Text('Ver eventos finalizados'),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () async {
                    await Navigator.pushNamed(context, BettyRoutes.editEvent);
                    context.read<EventsCubit>().loadEvents();
                  },
                ),
              ),
              if (state is EventsLoading)
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
