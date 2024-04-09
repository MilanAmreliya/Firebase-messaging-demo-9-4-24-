# firebase_messaging_demo

A new Flutter project.

[//]: # (in android)
1. connect with firebase
2. edit android/app/src/main/AndroidManifest.xml file with internet permission like : <uses-permission android:name="android.permission.INTERNET"/>
3. add also : <meta-data
   android:name="com.google.firebase.messaging.default_notification_channel_id"
   android:value="high_importance_channel" />
4. add common notifications services and handlers
5. copy fcm token and visit firebase service and send test notifications 
6. done.

[//]: # (in ios)
1. connect with firebase
2. set APNs Authentication Key and APNs Certificates
3. edit ios/Runner/Info.plist :
   <key>UIBackgroundModes</key>
   <array>
   <string>fetch</string>
   <string>remote-notification</string>
   </array>
4. add common notifications services and handlers
5. done.


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
