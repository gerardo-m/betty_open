import 'package:flutter/material.dart';

class EventInfoWidget extends StatelessWidget {

  final String eventStatus;
  final int participantsCount;

  const EventInfoWidget({super.key, required this.eventStatus, required this.participantsCount});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 20,
      isThreeLine: true,
      title: const Text('Info del evento'),
      subtitle: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 16),
            child: Row(
              children: [
                const Expanded(child: Text('Estado')),
                Align(
                    alignment: Alignment.centerRight,
                    child: Text(eventStatus)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const Expanded(child: Text('Participantes')),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(participantsCount.toString()),
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}