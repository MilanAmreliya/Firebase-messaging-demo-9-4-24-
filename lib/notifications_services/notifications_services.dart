import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppNotificationHandler {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    // 'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
  }

  ///call when app in fore ground
  static void showMsgHandler() {
    const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
        iOS: initializationSettingsDarwin);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) async {
        print('-----APP FOREGROUND EVENT-----');

        try {
          // print('------PAYLOAD------${message.data}');
        } catch (e) {
          // TODO
        }
      },
    );

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage? message) async {
        RemoteNotification? notification = message!.notification;

        if (Platform.isAndroid) {
          showMsg(notification!, message);
        }
      },
    );
  }

  /// handle notification when app closed
  static void getInitialMsg() {
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('------APP CLOSED EVENT------');

        try {
          print('------PAYLOAD------${message.data}');
        } catch (e) {
          // TODO
        }
      }
    });
  }

  ///show notification msg
  static Future<void> showMsg(RemoteNotification notification, RemoteMessage messagessss) async {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          importance: Importance.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    /// Navigate to detail

    log('IOS:::NAVIGATION');
    if (message.data.isNotEmpty) {
      if (message.data['type'] == "CAMPAIGN_OFFER_NEW" ||
          message.data['type'] == "CAMPAIGN_OFFER_UPDATE" ||
          message.data['type'] == "CAMPAIGN_CONTENT_APPROVED" ||
          message.data['type'] == "CAMPAIGN_CONTENT_REJECTED" ||
          message.data['type'] == "CAMPAIGN_PAYMENT_COMPLETE") {
        /// Navigat to Campiagn Detail Screen
      }
      if (message.data['type'] == "CHAT_MESSAGE") {}
    }
  }
}
