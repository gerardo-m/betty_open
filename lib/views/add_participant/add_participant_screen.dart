import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:betty/models/participant.dart';
import 'package:betty/views/add_participant/cubit/add_participant_cubit.dart';
import 'package:flutter/material.dart';
import 'package:betty/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';

class AddParticipantScreen extends StatelessWidget {
  AddParticipantScreen({Key? key}) : super(key: key);

  final profileIdentifierValidator = MultiValidator([
      RequiredValidator(errorText: 'identificador es requerido'),
      MinLengthValidator(4, errorText: 'El identificador debe tener al menos 4 caracteres'),
      PatternValidator(r'^[a-zA-Z0-9]+$', errorText: 'Solo se aceptan letras y números'),
    ]);

  @override
  Widget build(BuildContext context) {
    
    final TextEditingController textController = TextEditingController();
    return BlocBuilder<AddParticipantCubit, AddParticipantState>(
      builder: (context, state) {
        if (state is AddParticipantValidState){
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: const Text('Invitar participante'),
                  actions: [
                    AnimSearchBar(
                      width: 300,
                      textController: textController,
                      rtl: true,
                      suffixIcon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      onSuffixTap: () {
                        String identifier = textController.text;
                        _search(context, identifier);
                      },
                      onSubmitted: (value){
                        _search(context, value);
                      },
                    )
                  ],
                ),
                body: ListView(
                  children: [
                    for (EParticipant participant in state.participants)
                      ListTile(
                        title: Text(participant.userName),
                        subtitle: Text(participant.userIdentifier),
                        onTap: () async {
                          bool? confirm = await showConfirmationMessage(context,
                              'Invitar', 'Enviar invitación a ${participant.userName}');
                          if (confirm ?? false) {
                            await context.read<AddParticipantCubit>().inviteParticipant(participant.userId);
                            Navigator.of(context).pop(participant);
                          }
                        },
                      )
                  ],
                ),
              ),
              if (state is AddParticipantLoading)
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

  Future<void> _search(BuildContext context, String identifier)async{
    String? errorMessage = profileIdentifierValidator.call(identifier);
    if (errorMessage != null){
      await showErrorMessage(context, errorMessage);
      return;
    }
    context.read<AddParticipantCubit>().search(identifier);
  }
}
