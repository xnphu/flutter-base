import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationPayload {
  String? sendNotifyCd;
  String? title;
  String? body;

  PushNotificationPayload({this.sendNotifyCd});

  PushNotificationPayload.fromJson(dynamic data,
      {RemoteNotification? notification}) {
    sendNotifyCd = data['sendNotifyCd'];
    title = notification?.title;
    body = notification?.body;
  }
}