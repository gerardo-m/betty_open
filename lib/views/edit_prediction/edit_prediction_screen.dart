import 'package:betty/models/prediction_item.dart';
import 'package:betty/views/edit_prediction/cubit/edit_prediction_cubit.dart';
import 'package:betty/views/prediction_items/widgets/prediction_item_widget.dart';
import 'package:betty/views/widgets/event_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:betty/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class EditPredictionScreen extends StatelessWidget {
  const EditPredictionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditPredictionCubit, EditPredictionState>(
      listener: (context, state) async{
        if (state is EditPredictionSaved) {
          if (state.errorMessage.isEmpty) {
            showSuccessMessage(context, 'Predicción guardada');
            return;
          } else {
            showErrorMessage(context, state.errorMessage);
            return;
          }
        }
        if (state is EditPredictionSent){
          if (state.errorMessage.isEmpty) {
            await showSuccessMessage(context, 'Predicción enviada');
            InterstitialAd? ad = context.read<EditPredictionCubit>().interstitialAd;
            if (ad != null){
              await ad.show();
            }
            Navigator.of(context).pop(state.prediction);
            return;
          } else {
            showErrorMessage(context, state.errorMessage);
            return;
          }
        }
      },
      builder: (context, state) {
        if (state is EditPredictionValidState) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: Text(state.prediction.eventName),
                ),
                body: ListView(
                  children: [
                    EventInfoWidget(
                      eventStatus: state.prediction.eventStatus.label,
                      participantsCount: state.event.acceptedParticipants?.length ?? 0,
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                    const _PredictionActions(),
                    const Divider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                    const ListTile(
                      title: Center(child: Text('Mi predicción')),
                    ),
                    for (EPredictionItem item in state.prediction.items)
                      PredictionItemWidget(predictionItem: item),
                    //PredictionPositionsTableItemWidget(),
                  ],
                ),
              ),
              if (state is EditPredictionLoading)
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

class _PredictionActions extends StatelessWidget {
  const _PredictionActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            context.read<EditPredictionCubit>().save();
          },
          child: const Text('Guardar'),
        ),
        ElevatedButton(
          onPressed: () async{
            bool? confirm = await showConfirmationMessage(context, 'Confirmar envío', '¿Está seguro que desea enviar su predicción? Esta acción no se puede deshacer y no podrá modificar su predicción');
            if (confirm ?? false){
              context.read<EditPredictionCubit>().send();
            }
          },
          child: const Text('Enviar'),
        ),
      ],
    );
  }
}