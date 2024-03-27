import 'package:betty/models/participant.dart';
import 'package:betty/utils/constants.dart';
import 'package:betty/views/published_event/cubit/published_event_cubit.dart';
import 'package:betty/views/widgets/list_divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:betty/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PublishedEventParticipantsWidget extends StatelessWidget {
  final List<EParticipant> invitedParticipants;
  final List<EParticipant> acceptedParticipants;
  final bool enableEditing;

  const PublishedEventParticipantsWidget({
    super.key,
    required this.invitedParticipants,
    required this.acceptedParticipants,
    required this.enableEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            if (acceptedParticipants.isNotEmpty)
              const ListDividerWidget(label: 'Aceptados'),
            Column(
              children: [
                for (EParticipant participant in acceptedParticipants)
                  ListTile(
                    title: Text(participant.userName),
                    subtitle: Text(participant.userIdentifier),
                  )
              ],
            ),
            if (invitedParticipants.isNotEmpty)
              const ListDividerWidget(label: 'Invitados'),
            Column(
              children: [
                for (EParticipant participant in invitedParticipants)
                  ListTile(
                    title: Text(participant.userName),
                    subtitle: Text(participant.userIdentifier),
                  )
              ],
            ),
          ],
        ),
        if (enableEditing)
          Positioned(
            bottom: 25,
            right: 15,
            child: FloatingActionButton(
              onPressed: () async {
                if (!canAddParticipants()) {
                  showErrorMessage(context, 'Se alcanzó el límite de participantes para este evento: ${Constants.participantsLimit}');
                  return;
                }
                final result = await Navigator.of(context)
                    .pushNamed(BettyRoutes.addParticipant);
                if (result != null) {
                  context
                      .read<PublishedEventCubit>()
                      .reloadPublishedEventToEdit();
                }
              },
              child: const Icon(Icons.add),
            ),
          ),
      ],
    );
  }

  bool canAddParticipants(){
    int totalParticipants = invitedParticipants.length + acceptedParticipants.length;
    return totalParticipants < Constants.participantsLimit;
  }
}
