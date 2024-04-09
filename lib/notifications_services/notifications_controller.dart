import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging_demo/notifications_services/notifications_services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationController {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
  }

  initializeNotifications() async {
    // Request permissions
    final notificationSettings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    // Check if permissions are granted
    if (notificationSettings.authorizationStatus == AuthorizationStatus.authorized ||
        notificationSettings.authorizationStatus == AuthorizationStatus.provisional) {
      print('Notifications Authorized');

      // Set up background message handler
      FirebaseMessaging.onBackgroundMessage(
          AppNotificationHandler.firebaseMessagingBackgroundHandler);
      // Initialize local notifications
      await initializeLocalNotifications();

      // Other setup specific to having a token
      AppNotificationHandler.showMsgHandler();
    } else {
      // Handle the case where permissions are not granted
      print('Notification permission denied');
    }
  }

  Future<void> initializeLocalNotifications() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(AppNotificationHandler.channel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    AppNotificationHandler.getInitialMsg();

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    String? fcmToken = await FirebaseMessaging.instance.getToken();
    log("fcmToken ==>>  $fcmToken");
  }
}
