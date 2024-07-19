import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> setupFirebaseMessaging() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the local notifications plugin
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request and get the FCM token
  final fcmToken = await messaging.getToken();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  log("FCMToken $fcmToken");

  // Request permission to receive notifications
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

  // Configure the app to handle incoming messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('Received message while in the foreground: ${message.notification?.title}');
    if (message.notification != null) {
      showNotification(message);
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
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> showNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '1234',
      'droppy',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformChannelSpecifics,
    );
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  showNotification(message);
}
