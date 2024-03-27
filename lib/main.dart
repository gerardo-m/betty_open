import 'package:betty/utils/enums.dart';
import 'package:betty/utils/routes.dart';
import 'package:betty/utils/theme.dart';
import 'package:betty/views/add_participant/add_participant_screen.dart';
import 'package:betty/views/add_participant/cubit/add_participant_cubit.dart';
import 'package:betty/views/coming_soon/coming_soon_screen.dart';
import 'package:betty/views/edit_event/cubit/edit_event_cubit.dart';
import 'package:betty/views/edit_event/edit_event_screen.dart';
import 'package:betty/views/event_items/edit_event_item/edit_event_item_screen.dart';
import 'package:betty/views/edit_group/edit_group_screen.dart';
import 'package:betty/views/edit_prediction/cubit/edit_prediction_cubit.dart';
import 'package:betty/views/edit_prediction/edit_prediction_screen.dart';
import 'package:betty/views/finished_events/cubit/finished_events_cubit.dart';
import 'package:betty/views/finished_events/finished_events_screen.dart';
import 'package:betty/views/prediction_items/edit_prediction_item/edit_prediction_item_screen.dart';
import 'package:betty/views/event_items/edit_single_match/edit_single_match_screen.dart';
import 'package:betty/views/event_results/cubit/event_results_cubit.dart';
import 'package:betty/views/event_results/event_results_screen.dart';
import 'package:betty/views/events/cubit/events_cubit.dart';
import 'package:betty/views/events/events_screen.dart';
import 'package:betty/views/home/cubit/home_cubit.dart';
import 'package:betty/views/home/home_screen.dart';
import 'package:betty/views/participants_ranking/cubit/participants_ranking_cubit.dart';
import 'package:betty/views/participants_ranking/participants_ranking_screen.dart';
import 'package:betty/views/predictions/cubit/predictions_cubit.dart';
import 'package:betty/views/predictions/predictions_screen.dart';
import 'package:betty/views/profile/cubit/profile_cubit.dart';
import 'package:betty/views/profile/profile_screen.dart';
import 'package:betty/views/published_event/cubit/published_event_cubit.dart';
import 'package:betty/views/published_event/published_event_screen.dart';
import 'package:betty/views/search_groups/search_groups_screen.dart';
import 'package:betty/views/settings/settings_screen.dart';
import 'package:betty/views/show_group/show_group_screen.dart';
import 'package:betty/views/show_prediction/cubit/show_prediction_cubit.dart';
import 'package:betty/views/show_prediction/show_prediction_screen.dart';
import 'package:betty/views/single_match/single_match_screen.dart';
import 'package:betty/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dependency_injection.dart' as di;

void main() {
  Future<bool?> loaded = di.setup();
  runApp(MyApp(
    loaded: loaded,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.loaded});

  final Future<bool?> loaded;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loaded,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: '¡Predecime ésta!',
            theme: BettyTheme.lightTheme,
            themeMode: ThemeMode.light,
            //routes: getRoutes(context),
            onGenerateRoute: _onGenerateRoute,
          );
        }
        return const SplashScreen();
        // return AnimatedSwitcher(
        //   duration: const Duration(seconds: 1),
        //   child: app,
        // );
      },
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case BettyRoutes.home:
        return goHome(settings);
      case BettyRoutes.events:
        return goEvents(settings);
      case BettyRoutes.finishedEvents:
        return goFinishedEvents(settings);
      case BettyRoutes.predictions:
        return goPredictions(settings);
      // case BettyRoutes.groups:
      //   return MaterialPageRoute(
      //     builder: (context) {
      //       return const GroupsScreen();
      //     },
      //   );
      case BettyRoutes.editEvent:
        return goEditEvent(settings);
      case BettyRoutes.editPrediction:
        return goEditPrediction(settings);
      case BettyRoutes.editPredictionItem:
        return goEditPredictionItem(settings);
      case BettyRoutes.showPrediction:
        return goShowPrediction(settings);
      case BettyRoutes.publishedEvent:
        return goPublishedEvent(settings);
      case BettyRoutes.addParticipant:
        return goAddParticipant(settings);
      case BettyRoutes.editEventResults:
        return goEditEventResults(settings);
      case BettyRoutes.showEventResults:
        return goShowEventResults(settings);
      case BettyRoutes.calculateParticipantsRanking:
        return goCalculateParticipantsRanking(settings);
      case BettyRoutes.showParticipantsRanking:
        return goShowParticipantsRanking(settings);
      case BettyRoutes.editEventItem:
        return goEditEventItem(settings);
      case BettyRoutes.singleMatch:
        return MaterialPageRoute(
          builder: (context) {
            return const SingleMatchScreen();
          },
        );
      case BettyRoutes.editSingleMatch:
        return MaterialPageRoute(
          builder: (context) {
            return EditSingleMatchScreen();
          },
        );
      // case BettyRoutes.searchEvents:
      //   return MaterialPageRoute(
      //     builder: (context) {
      //       return SearchEventsScreen();
      //     },
      //   );
      case BettyRoutes.editGroup:
        return MaterialPageRoute(
          builder: (context) {
            return const EditGroupScreen();
          },
        );
      case BettyRoutes.showGroup:
        return MaterialPageRoute(
          builder: (context) {
            return const ShowGroupScreen();
          },
        );
      case BettyRoutes.searchGroups:
        return MaterialPageRoute(
          builder: (context) {
            return const SearchGroupsScreen();
          },
        );
      case BettyRoutes.profile:
        return MaterialPageRoute(
          builder: (context) {
            return BlocProvider(
              create: (context) => ProfileCubit()..loadProfile(),
              child: ProfileScreen(),
            );
          },
        );
      case BettyRoutes.settings:
        return goSettings(settings);
      case BettyRoutes.comingSoon:
        return goComingSoon(settings);
      default:
        return goComingSoon(settings);
    }
  }

  MaterialPageRoute goHome(RouteSettings settings) {
    return MaterialPageRoute(
      builder: ((context) => BlocProvider(
            create: ((context) => HomeCubit()..initiate()),
            child: const HomeScreen(),
          )),
    );
  }

  MaterialPageRoute goEvents(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) => EventsCubit()..loadEvents(),
          child: const EventsScreen(),
        );
      },
    );
  }

  MaterialPageRoute goFinishedEvents(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) => FinishedEventsCubit()..loadEvents(),
          child: const FinishedEventsScreen(),
        );
      },
    );
  }

  MaterialPageRoute goEditEvent(RouteSettings settings) {
    String? eventId = settings.arguments as String?;
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) {
            if (eventId == null) {
              return EditEventCubit()..newEvent();
            }
            return EditEventCubit()..loadEvent(eventId);
          },
          child: const EditEventScreen(),
        );
      },
    );
  }

  MaterialPageRoute goEditEventItem(RouteSettings settings) {
    Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
    String? id = args['id'];
    EventItemType eventItemType =
        args['eventItemType'] ?? EventItemType.singleMatch;
    return MaterialPageRoute(
      builder: (context) {
        return EditEventItemScreen(
          eventItemType: eventItemType,
          eventItemId: id,
        );
      },
    );
  }

  MaterialPageRoute goPredictions(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) => PredictionsCubit()..loadEvents(),
          child: const PredictionsScreen(),
        );
      },
    );
  }

  MaterialPageRoute goEditPrediction(RouteSettings settings) {
    String eventId = settings.arguments as String;
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) => EditPredictionCubit()..loadPrediction(eventId),
          child: const EditPredictionScreen(),
        );
      },
    );
  }

  MaterialPageRoute goEditPredictionItem(RouteSettings settings) {
    Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
    String id = args['id'];
    EventItemType eventItemType =
        args['eventItemType'] ?? EventItemType.singleMatch;
    PredictionItemSource source = args['source'];
    return MaterialPageRoute(
      builder: (context) {
        return EditPredictionItemScreen(
          eventItemType: eventItemType,
          id: id,
          source: source,
        );
      },
    );
  }

  MaterialPageRoute goShowPrediction(RouteSettings settings) {
    String eventId = settings.arguments as String;
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) => ShowPredictionCubit()..loadPrediction(eventId),
          child: const ShowPredictionScreen(),
        );
      },
    );
  }

  MaterialPageRoute goPublishedEvent(RouteSettings settings) {
    String eventId = settings.arguments as String;
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) =>
              PublishedEventCubit()..loadPublishedEventToEdit(eventId),
          child: const PublishedEventScreen(),
        );
      },
    );
  }

  MaterialPageRoute goAddParticipant(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) => AddParticipantCubit()..start(),
          child: AddParticipantScreen(),
        );
      },
    );
  }

  MaterialPageRoute goEditEventResults(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) => EventResultsCubit()..loadCurrentEventResult(),
          child: const EventResultsScreen(allowEdition: true),
        );
      },
    );
  }

  MaterialPageRoute goShowEventResults(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) => EventResultsCubit()..loadCurrentEventResult(),
          child: const EventResultsScreen(
            allowEdition: false,
          ),
        );
      },
    );
  }

  MaterialPageRoute goCalculateParticipantsRanking(RouteSettings settings) {
    String eventId = settings.arguments as String;
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) =>
              ParticipantsRankingCubit()..calculateRanking(eventId),
          child: const ParticipantsRankingScreen(),
        );
      },
    );
  }

  MaterialPageRoute goShowParticipantsRanking(RouteSettings settings) {
    String eventId = settings.arguments as String;
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) => ParticipantsRankingCubit()
            ..loadParticipantsRankingForEvent(eventId),
          child: const ParticipantsRankingScreen(),
        );
      },
    );
  }

  MaterialPageRoute goSettings(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        return const SettingsScreen();
      },
    );
  }

  MaterialPageRoute goComingSoon(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        return const ComingSoonScreen();
      },
    );
  }
}
