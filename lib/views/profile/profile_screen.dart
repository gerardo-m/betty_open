import 'package:betty/models/profile.dart';
import 'package:betty/utils/enums.dart';
import 'package:betty/views/profile/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _profile = Profile.createEmptyProfile();

  @override
  Widget build(BuildContext context) {
    final profileIdentifierValidator = MultiValidator([
      RequiredValidator(errorText: 'identificador es requerido'),
      MinLengthValidator(4, errorText: 'El identificador debe tener al menos 4 caracteres'),
      PatternValidator(r'^[a-zA-Z0-9]+$', errorText: 'Solo se aceptan letras y números'),
    ]);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (previous, current) {
          if (current is ProfileCreated){
            return (previous is ProfileNotCreated || previous is ProfileLoading);
          }
          if (current is ProfileLinked ){
            return (previous is ProfileCreated || previous is ProfileLoading);
          }
          return true;
        },
        listener: (context, state) {
          if (state is ProfileValidState){
            if (state.errorMessage.isNotEmpty){
              _showErrorMessage(context, state.errorMessage);
              return;
            }
            if (state is ProfileLinked){
              _showSuccessMessage(context, 'Usuario vinculado con google correctamente');
              return;
            }
            if (state is ProfileCreated){
              if (state.profile.authenticationMethod == AuthenticationMethod.google){
                _showSuccessMessage(context, 'Sesión iniciada correctamente');
              }else{
                _showSuccessMessage(context, 'Usuario creado correctamente');
              }   
              return;
            }
          }
        },
        builder: (context, state) {
          if (state is ProfileValidState) {
            if (state is! ProfileLoading){
              _loadProfileValuesFromState(_profile, state);
            }
            return Stack(
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('Tu nombre'),
                        ),
                        TextFormField(
                          controller: TextEditingController.fromValue(TextEditingValue(text: state.profile.name)),
                          readOnly: (state is ProfileCreated),
                          onSaved: (newValue) {
                            if (newValue != null) {
                              _profile.name = newValue;
                            }
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('Tu usuario (debe ser único)'),
                        ),
                        TextFormField(
                          validator: profileIdentifierValidator,
                          controller: TextEditingController.fromValue(TextEditingValue(text: state.profile.identifier)),
                          readOnly: (state is ProfileCreated),
                          decoration: (state is ProfileCreated) ? InputDecoration(
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () {
                                final data = ClipboardData(text: state.profile.identifier);
                                Clipboard.setData(data);
                              },
                            ),
                          ) : null,
                          onSaved: (newValue) {
                            if (newValue != null) {
                              _profile.identifier = newValue;
                            }
                          },
                        ),
                        if (state is ProfileNotCreated)
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    context
                                        .read<ProfileCubit>()
                                        .createProfile(_profile);
                                  }
                                },
                                child: const Text('Guardar'),
                              ),
                              const Center(child: Text('O')),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<ProfileCubit>().signInWithGoogle();
                                },
                                child: const Text('Iniciar sesión con google'),
                              ),
                            ],
                          ),
                        if (state is ProfileCreated)
                          if (state.profile.authenticationMethod == AuthenticationMethod.anonymous)
                            ElevatedButton(
                              onPressed: () {
                                context.read<ProfileCubit>().linkWithGoogle();
                              },
                              child: const Text('Vincular con google'),
                            ),
                      ],
                    ),
                  ),
                ),
                if (state is ProfileLoading)
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
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void _loadProfileValuesFromState(Profile profile, ProfileValidState state) {
    EProfile stateProfile = state.profile;
    profile.name = stateProfile.name;
    profile.identifier = stateProfile.identifier;
    profile.authenticationMethod = stateProfile.authenticationMethod;
  }

  Future<void> _showErrorMessage(BuildContext context, String errorMessage) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.error),
          content: Text(errorMessage),
        );
      },
    );
  }

  Future<void> _showSuccessMessage(BuildContext context, String errorMessage) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.check),
          content: Text(errorMessage),
        );
      },
    );
  }
}
