import 'package:betty/services/messaging_service.dart';
import 'package:betty/utils/utils.dart';
import 'package:betty/views/home/cubit/home_cubit.dart';
import 'package:betty/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MessagingService service = GetIt.instance.get<MessagingService>();

    service.setupInteractedMessage(context);
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeSignUpFailed){
          showErrorMessage(context, 'Ocurrió un error. Por favor revisa tu conexión a internet e intenta mas tarde.');
          return;
        }
        if (state is HomeSignUpCancelled){
          showSuccessMessage(context, 'Inicio de sesión cancelado');
        }
      },
      builder: (context, state) {
        Widget? screen;
        if (state is HomeValidState) {
          screen = Stack(
            children: [
              AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: state is HomeWithProfile
                    ? _HomeDefaultScreen(state: state)
                    : _FirstTimeHomePage(),
              ),
              if (state is HomeLoading)
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
        if (state is HomeInitial){
          screen = const SplashScreen();
        }
        if (screen != null){
          return AnimatedSwitcher(
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            duration: const Duration(seconds: 2),
            child: screen,
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class _HomeDefaultScreen extends StatelessWidget {
  final HomeValidState state;
  const _HomeDefaultScreen({required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('¡Predecime Ésta!'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 1) {
                showAboutDialog(
                  context: context,
                  applicationIcon: const Image(
                      image: AssetImage('assets/icons/about_icon.png')),
                  applicationVersion: '1.0.0',
                  applicationLegalese:
                      'Desarrollado en Santa Cruz, Bolivia por: \nGerardo Miranda\nLogo hecho por "DesignEvo free logo creator"',
                );
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 1,
                  child: Text('Acerca de'),
                ),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const Image(image: AssetImage('assets/images/home.png')),
            _HomeScreenButton(
              buttonText: 'Administrar eventos',
              disabled: state is HomeWithoutProfile,
              onTap: () => Navigator.pushNamed(context, BettyRoutes.events),
            ),
            _HomeScreenButton(
              buttonText: 'Mis predicciones',
              disabled: state is HomeWithoutProfile,
              onTap: () =>
                  Navigator.pushNamed(context, BettyRoutes.predictions),
            ),
            _HomeScreenButton(
              buttonText: 'Mis grupos',
              disabled: state is HomeWithoutProfile,
              onTap: () => Navigator.pushNamed(context, BettyRoutes.groups),
            ),
            _HomeScreenButton(
              buttonText: 'Perfil',
              onTap: () async {
                await Navigator.pushNamed(context, BettyRoutes.profile);
                context.read<HomeCubit>().initiate();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeScreenButton extends StatelessWidget {
  final String buttonText;
  final bool disabled;
  final void Function()? onTap;

  const _HomeScreenButton({
    required this.buttonText,
    this.disabled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: disabled
              ? Theme.of(context).disabledColor
              : Theme.of(context).colorScheme.primary,
        ),
        child: ListTile(
          title: Text(
            buttonText,
            textAlign: TextAlign.center,
          ),
          textColor: Theme.of(context).colorScheme.onSecondary,
          //tileColor:
          onTap: disabled ? null : onTap,
        ),
      ),
    );
  }
}

class _FirstTimeHomePage extends StatelessWidget {
  _FirstTimeHomePage();

  final formKey = GlobalKey<FormState>();
  final profileNameValidator = MultiValidator([
    RequiredValidator(errorText: 'Tu nombre es requerido'),
    MinLengthValidator(3, errorText: 'Tu nombre debe tener al menos 3 caracteres'),
    PatternValidator(r'^[a-zA-Z0-9_]+$', errorText: 'Solo se aceptan letras, números y guión bajo'),
  ]);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 50,
      fontFamily: 'Satisfy',
      color: Theme.of(context).colorScheme.primary,
    );
    return Form(
      key: formKey,
      child: Scaffold(
        body: SafeArea(
          child: SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/icons/launcher_icon.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Bienvenido',
                      style: textStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        const Text('Dinos tu nombre:', style: TextStyle(fontSize: 16),),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: TextFormField(
                            validator: profileNameValidator,
                            onSaved: (newValue) {
                              if (newValue != null){
                                context.read<HomeCubit>().name = newValue;
                              }
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()){
                              formKey.currentState!.save();
                              context.read<HomeCubit>().enterWithName();
                            }
                          }, 
                          child: const Text('Entrar'),
                        ),
                        const Text('O'),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 60.0),
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<HomeCubit>().signInWithGoogle();
                            }, 
                            child: const Text('Iniciar sesion con google')
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
