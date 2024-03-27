import 'package:betty/models/event.dart';
import 'package:betty/services/events_service.dart';
import 'package:betty/utils/admob_helper.dart';
import 'package:betty/utils/constants.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

part 'edit_event_state.dart';

class EditEventCubit extends Cubit<EditEventState> {

  final EventsService eventsService = GetIt.instance.get<EventsService>();
  InterstitialAd? interstitialAd;

  EditEventCubit() : super(EditEventInitial());

  void newEvent()async{
    _loading();
    _loadInterstitialAd();
    await eventsService.loadEventToEdit();
    Event currentEvent = eventsService.currentEditingEvent;
    emit(EditEventValidState(currentEditingEvent: EEvent.fromEvent(currentEvent), saved: false));
  }

  void loadEvent(String id)async{
    _loading();
    _loadInterstitialAd();
    await eventsService.loadEventToEdit(id: id);
    Event currentEvent = eventsService.currentEditingEvent;
    emit(EditEventValidState(currentEditingEvent: EEvent.fromEvent(currentEvent)));
  }

  void reloadCurrentEvent(){
    EditEventState currentState = state;
    if (currentState is EditEventValidState){
      Event currentEvent = eventsService.currentEditingEvent;
      emit(EditEventValidState(currentEditingEvent: EEvent.fromEvent(currentEvent), saved: currentState.saved));
    }
  }

  void changeName(String name){
    eventsService.currentEditingEvent.name = name;
  }

  void increaseItemCountLimit(){
    eventsService.currentEditingEvent.itemCountLimit += Constants.eventItemLimit;
    _loadInterstitialAd();
  }

  void save()async{
    EditEventState currentState = state;
    if (currentState is EditEventValidState){
      _loading();
      String errorMessage = _validate();
      if (errorMessage.isEmpty){
        await eventsService.saveEvent();
        emit(EditEventSaved(currentEditingEvent: eventsService.currentEditingEvent.toEEvent(), errorMessage: errorMessage));
      }else{
        emit(EditEventNotSaved(currentEditingEvent: currentState.currentEditingEvent, saved: currentState.saved, errorMessage: errorMessage));
      }
    }
    reloadCurrentEvent();
  }

  void publish()async{
    EditEventState currentState = state;
    if (currentState is EditEventValidState){
      _loading();
      await eventsService.publishEvent();
      emit(EditEventPublished(currentEditingEvent: currentState.currentEditingEvent, errorMessage: ''));
    }
  }

  Future<void> delete()async{
    EditEventState currentState = state;
    if (currentState is EditEventValidState){
      _loading();
      await eventsService.deleteSavedEvent();
    }
  }

  void deleteItem(String id) async{
    EditEventState currentState = state;
    if (currentState is EditEventValidState){
      eventsService.deleteItemFromEditingEvent(id);
    }
    reloadCurrentEvent();
  }

  String _validate(){
    Event event = eventsService.currentEditingEvent;
    if (event.name.isEmpty){
      return 'El nombre no puede estar en blanco';
    }
    return '';
  }

  void _loadInterstitialAd()async{
    try {
      await InterstitialAd.load(
        adUnitId: AdmobHelper.interstitialAdUnitId, 
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            interstitialAd = ad;
            interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
              },
            );
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
    EditEventState currentState = state;
    if (currentState is EditEventValidState){
      emit(EditEventLoading(currentEditingEvent: currentState.currentEditingEvent)); 
    }
  }
}
