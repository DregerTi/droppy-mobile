import 'dart:developer'; // TODO: Remove this import

import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> setupFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final fcmToken = await messaging.getToken();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  log("FCMToken $fcmToken");

  // Request permission for receiving notifications
  messaging.requestPermission();

  // Configure the app to handle incoming messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('Received message: ${message.notification?.title}');
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    log('Opened app from notification: ${message.notification?.title}');
  });

  FirebaseMessaging.onBackgroundMessage((message) async {
    log('Handling a background message: ${message.messageId}');
  });

  messaging.onTokenRefresh.listen((newToken) {
    log('FCMToken $newToken');
  });

  messaging.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
}
