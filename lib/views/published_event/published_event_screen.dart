import 'package:betty/views/published_event/cubit/published_event_cubit.dart';
import 'package:betty/views/published_event/widgets/published_event_details_widget.dart';
import 'package:betty/views/published_event/widgets/published_event_participants_widget.dart';
import 'package:flutter/material.dart';
import 'package:betty/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PublishedEventScreen extends StatelessWidget {
  const PublishedEventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublishedEventCubit, PublishedEventState>(
      builder: (context, state) {
        if (state is PublishedEventValidState) {
          return Stack(
            children: [
              DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(state.publishedEvent.name),
                    bottom: const TabBar(
                      tabs: [
                        Tab(
                          child: Text('Detalles'),
                        ),
                        Tab(
                          child: Text('Participantes'),
                        )
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      PublishedEventDetailsWidget(
                        event: state.publishedEvent,
                      ),
                      PublishedEventParticipantsWidget(
                        invitedParticipants:
                            state.publishedEvent.invitedParticipants ?? [],
                        acceptedParticipants:
                            state.publishedEvent.acceptedParticipants ?? [],
                        enableEditing: state.publishedEvent.status == EventStatus.open,
                      ),
                    ],
                  ),
                ),
              ),
              if (state is PublishedEventLoading)
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
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}