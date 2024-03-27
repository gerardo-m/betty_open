import 'package:betty/firebase_options.dart';
import 'package:betty/repositories/event_results_repository.dart';
import 'package:betty/repositories/events_repository.dart';
import 'package:betty/repositories/participants_repository.dart';
import 'package:betty/repositories/predictions_repository.dart';
import 'package:betty/repositories/profile_repository.dart';
import 'package:betty/repositories_firebase/event_results_repository_firebase.dart';
import 'package:betty/repositories_firebase/events_repository_firebase.dart';
import 'package:betty/repositories_firebase/participants_repository_firebase.dart';
import 'package:betty/repositories_firebase/predictions_repository_firebase.dart';
import 'package:betty/repositories_firebase/profile_repository_firebase.dart';
import 'package:betty/repositories_jsonstore/events_repository_jsonstore.dart';
import 'package:betty/repositories_jsonstore/predictions_repository_jsonstore.dart';
import 'package:betty/services/event_items_service.dart';
import 'package:betty/services/event_results_service.dart';
import 'package:betty/services/events_service.dart';
import 'package:betty/services/messaging_service.dart';
import 'package:betty/services/participants_ranking_service.dart';
import 'package:betty/services/participants_service.dart';
import 'package:betty/services/prediction_items_service.dart';
import 'package:betty/services/predictions_service.dart';
import 'package:betty/services/profile_service.dart';
import 'package:betty/services/published_events_service.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:json_store/json_store.dart';

final di = GetIt.instance;

const String eventsLocal = 'eventsLocal';
const String eventsRemote = 'eventsRemote';
const String predictionsLocal = 'predictionsLocal';
const String predictionsRemote = 'predictionsRemote';

Future<bool?> setup() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. debug provider
    // 2. safety net provider
    // 3. play integrity provider
    androidProvider: AndroidProvider.playIntegrity,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  MobileAds.instance.initialize();

  //FirebaseAuth.instance.signOut();
  // JsonStore jsonStore = JsonStore();
  // await jsonStore.clearDataBase();

  // Repositories
  di.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryFirebase());
  di.registerLazySingleton<PredictionsRepository>(() => PredictionsRepositoryFirebase());
  di.registerLazySingleton<ParticipantsRepository>(() => ParticipantsRepositoryFirebase(),);
  di.registerLazySingleton<EventResultsRepository>(() => EventResultsRepositoryFirebase());

  di.registerSingleton<EventsRepository>(EventsRepositoryJsonstore(), instanceName: eventsLocal);
  di.registerSingleton<EventsRepository>(EventsRepositoryFirebase(), instanceName: eventsRemote);
  di.registerSingleton<PredictionsRepository>(PredictionsRepositoryJsonstore(), instanceName: predictionsLocal);
  di.registerSingleton<PredictionsRepository>(PredictionsRepositoryFirebase(), instanceName: predictionsRemote);

  // Services
  di.registerLazySingleton<MessagingService>(() => MessagingService(di()));
  di.registerLazySingleton<ProfileService>(() => ProfileService(di()));
  di.registerLazySingleton<EventsService>(() => EventsService(di(instanceName: eventsLocal), di(instanceName: eventsRemote), di()));
  di.registerLazySingleton<EventItemsService>(() => EventItemsService());
  di.registerLazySingleton<PredictionsService>(() => PredictionsService(di(instanceName: predictionsLocal), di(instanceName: predictionsRemote), di(), di(instanceName: eventsRemote)));
  di.registerLazySingleton<PublishedEventsService>(() => PublishedEventsService(di(instanceName: eventsRemote), di()));
  di.registerLazySingleton<ParticipantsService>(() => ParticipantsService(di()));
  di.registerLazySingleton<PredictionItemsService>(() => PredictionItemsService());
  di.registerLazySingleton<EventResultsService>(() => EventResultsService(di(), di(instanceName: eventsRemote)));
  di.registerLazySingleton<ParticipantsRankingService>(() => ParticipantsRankingService(di(), di()));
  return true;

}