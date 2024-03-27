import 'package:betty/models/event.dart';
import 'package:betty/services/published_events_service.dart';
import 'package:betty/utils/admob_helper.dart';
import 'package:betty/utils/enums.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

part 'published_event_state.dart';

class PublishedEventCubit extends Cubit<PublishedEventState> {

  final PublishedEventsService _publishedEventsService = GetIt.instance.get<PublishedEventsService>();
  InterstitialAd? interstitialAd;

  PublishedEventCubit() : super(PublishedEventInitial());

  void loadPublishedEventToEdit(String id)async{
    _loading();
    _loadInterstitialAd();
    await _publishedEventsService.loadPublishedEventToEdit(id);
    EEvent event = _publishedEventsService.currentEditingEvent.toEEvent();
    emit(PublishedEventValidState(publishedEvent: event));
  }

  void reloadPublishedEventToEdit(){
    EEvent event = _publishedEventsService.currentEditingEvent.toEEvent();
    emit(PublishedEventValidState(publishedEvent: event));
  }

  void changeEventStatus(EventStatus status){
    _publishedEventsService.changeCurrentEventStatus(status);
    reloadPublishedEventToEdit();
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
    PublishedEventState currentState = state;
    if (currentState is PublishedEventValidState){
      emit(PublishedEventLoading(publishedEvent: currentState.publishedEvent)); 
    }
  }
}
