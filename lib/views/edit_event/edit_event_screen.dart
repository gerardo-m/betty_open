import 'package:betty/utils/utils.dart';
import 'package:betty/views/edit_event/cubit/edit_event_cubit.dart';
import 'package:betty/views/edit_event/widgets/edit_event_details_widget.dart';
import 'package:betty/views/edit_event/widgets/edit_event_items_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class EditEventScreen extends StatelessWidget {
  const EditEventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditEventCubit, EditEventState>(
      listener: (context, state) async {
        if (state is EditEventSaved) {
          if (state.errorMessage.isEmpty) {
            showSuccessMessage(context, 'Evento guardado');
            return;
          } else {
            showErrorMessage(context, state.errorMessage);
            return;
          }
        }
        if (state is EditEventPublished) {
          if (state.errorMessage.isEmpty) {
            await showSuccessMessage(context, 'Evento publicado');
            InterstitialAd? ad = context.read<EditEventCubit>().interstitialAd;
            if (ad != null) {
              await ad.show();
            }
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(BettyRoutes.publishedEvent, arguments: state.currentEditingEvent.id);
            return;
          } else {
            showErrorMessage(context, state.errorMessage);
            return;
          }
        }
        if (state is EditEventNotSaved) {
          if (state.errorMessage.isNotEmpty) {
            showErrorMessage(context, state.errorMessage);
            return;
          }
        }
      },
      builder: (context, state) {
        if (state is EditEventValidState) {
          return Stack(
            children: [
              DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text('Evento'),
                    actions: [
                      IconButton(
                        onPressed: () async{
                          bool? confirm = await showConfirmationMessage(context, 'Eliminar', '¿Está seguro que desea eliminar este evento?');
                          if (confirm ?? false){
                            await context.read<EditEventCubit>().delete();
                            Navigator.of(context).pop(state.currentEditingEvent);
                          }
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                    bottom: const TabBar(
                      tabs: [
                        Tab(
                          child: Text('Detalle'),
                        ),
                        Tab(
                          child: Text('Predicciones'),
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      EditEventDetailsWidget(
                        event: state.currentEditingEvent,
                        enablePublishing: state.saved,
                      ),
                      EditEventItemsWidget(event: state.currentEditingEvent),
                    ],
                  ),
                ),
              ),
              if (state is EditEventLoading)
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