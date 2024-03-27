import 'package:betty/repositories/profile_repository.dart';
import 'package:betty/utils/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class MessagingService{

    final ProfileRepository profileRepository;

    MessagingService._({required this.profileRepository});

    factory MessagingService(ProfileRepository repository){
      return MessagingService._(profileRepository: repository);
    }

    Future<void> setupToken() async {
      // Get the token each time the application loads
      String? token = await FirebaseMessaging.instance.getToken();

      // Save the initial token to the database
      await profileRepository.saveMessagingToken(token!);

      // Any time the token refreshes, store this in the database too.
      FirebaseMessaging.instance.onTokenRefresh.listen(profileRepository.saveMessagingToken);
    }

    Future<void> setupInteractedMessage(BuildContext context) async {
      // Get any messages which caused the application to open from
      // a terminated state.
      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();

      // If the message also contains a data property with a "type" of "chat",
      // navigate to a chat screen
      if (initialMessage != null) {
        _handleMessage(initialMessage, context);
      }

      // Also handle any interaction when the app is in the background via a
      // Stream listener
      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        Navigator.of(context).popUntil((route) => route.isFirst && route.isCurrent);
        _handleMessage(event, context);
      },);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
        String msg = 'message received';
        if (message.notification != null) {
          print('Message also contained a notification: ${message.notification}');
          msg = '$msg. Also with a notification';
        }
      });
    }
    
    void _handleMessage(RemoteMessage message, BuildContext context) {
      Navigator.of(context).pushNamed(BettyRoutes.predictions);
    }
}