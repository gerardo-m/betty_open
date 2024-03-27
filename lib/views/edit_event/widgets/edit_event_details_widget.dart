import 'package:betty/models/event.dart';
import 'package:betty/views/edit_event/cubit/edit_event_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:betty/utils/utils.dart';

class EditEventDetailsWidget extends StatelessWidget {
  final EEvent event;
  final bool enablePublishing;

  const EditEventDetailsWidget(
      {super.key, required this.event, required this.enablePublishing});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nombre'),
              TextFormField(
                initialValue: event.name,
                onChanged: (value) {
                  context.read<EditEventCubit>().changeName(value);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 64.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.read<EditEventCubit>().save();
                      },
                      child: const Text('Guardar'),
                    ),
                    ElevatedButton(
                      onPressed: enablePublishing
                          ? () async {
                              bool? confirmed = await showConfirmationMessage(
                                  context,
                                  'Publicar evento',
                                  '¿Estás seguro que deseas publicar este evento? No podrás modificar el evento después de esta acción');
                              if (confirmed ?? false) {
                                context.read<EditEventCubit>().publish();
                              }
                            }
                          : null,
                      child: const Text('Publicar'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}