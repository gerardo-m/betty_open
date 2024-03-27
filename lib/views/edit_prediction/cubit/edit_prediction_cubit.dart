import 'package:betty/models/event.dart';
import 'package:betty/models/prediction.dart';
import 'package:betty/services/predictions_service.dart';
import 'package:betty/utils/admob_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

part 'edit_prediction_state.dart';

class EditPredictionCubit extends Cubit<EditPredictionState> {
  final PredictionsService _predictionsService =
      GetIt.instance.get<PredictionsService>();

  InterstitialAd? interstitialAd;

  EditPredictionCubit() : super(EditPredictionInitial());

  void loadPrediction(String eventId) async {
    _loading();
    _loadInterstitialAd();
    await _predictionsService.loadPredictionForEvent(eventId);
    emit(
      EditPredictionValidState(
        prediction:
            _predictionsService.currentEditingPrediction.toEPrediction(),
        event: _predictionsService.currentEditingEvent.toEEvent(),
      ),
    );
  }

  void reloadPrediction() {
    emit(
      EditPredictionValidState(
        prediction:
            _predictionsService.currentEditingPrediction.toEPrediction(),
        event: _predictionsService.currentEditingEvent.toEEvent(),
      ),
    );
  }

  void save() async {
    EditPredictionState currentState = state;
    if (currentState is EditPredictionValidState) {
      _loading();
      await _predictionsService.saveCurrentPrediction();
      emit(EditPredictionSaved(
        prediction: currentState.prediction,
        event: currentState.event,
        errorMessage: '',
      ));
    }
    reloadPrediction();
  }

  void send() async {
    EditPredictionState currentState = state;
    if (currentState is EditPredictionValidState) {
      _loading();
      await _predictionsService.sendCurrentPrediction();
      emit(EditPredictionSent(
        prediction: currentState.prediction,
        event: currentState.event,
        errorMessage: '',
      ));
    }
    reloadPrediction();
  }

  void _loadInterstitialAd()async{
    try {
      await InterstitialAd.load(
        adUnitId: AdmobHelper.interstitialAdUnitId, 
        request: const AdRequest(), 
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            interstitialAd = ad;
          }, 
          onAdFailedToLoad: (error) {
            // TODO
          },
        ),
      );
    } catch (e) {
      addError(e);
    }
  }

  void _loading(){
    EditPredictionState currentState = state;
    if (currentState is EditPredictionValidState){
      emit(EditPredictionLoading(prediction: currentState.prediction, event: currentState.event)); 
    }
  }
}
