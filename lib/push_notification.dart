import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> setupFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Demander et obtenir le token FCM
  final fcmToken = await messaging.getToken();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  log("FCMToken $fcmToken");

  // Demande de permission pour recevoir des notifications
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  log('User granted permission: ${settings.authorizationStatus}');

  // Configurer l'application pour gérer les messages entrants
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('Received message while in the foreground: ${message.notification?.title}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    log('Opened app from notification: ${message.notification?.title}');
  });

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  messaging.onTokenRefresh.listen((newToken) {
    log('New FCMToken: $newToken');
  });

  // Configuration des options de présentation des notifications au premier plan
  messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}
