import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;

import 'package:rxdart/rxdart.dart';

import 'push_notification_payload.dart';

abstract class NotificationEvent {}

// user tap into notification banner
class NotificationTapEvent extends NotificationEvent {
  String sendNotifyCd;
  NotificationTapEvent({required this.sendNotifyCd});
}

// notification comes
class DidReceiveNotificationEvent extends NotificationEvent {
  bool appInBackground;
  DidReceiveNotificationEvent({this.appInBackground = false});
}

class PushNotificationHandler {
  static PushNotificationHandler shared = PushNotificationHandler._();

  // tracking user tapped int notification event
  PublishSubject<NotificationEvent> _notificationEventManager =
      PublishSubject<NotificationEvent>(sync: true);
  Stream<NotificationEvent> get notificationEventStream =>
      _notificationEventManager.stream.asBroadcastStream();

  NotificationTapEvent? _initialEvent;

  PushNotificationHandler._();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> setupPushNotification() async {
    // iOS request firebase message request permission
    await FirebaseMessaging.instance.requestPermission();

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // check app open from remote notification
    //_checkAppOnPenFromRemoteNotification();

    //Android only: check if app open from local-notification
    //_checkAppOpenFromLocalNotification();

    // force-ground notification comes
    FirebaseMessaging.onMessage.listen((event) {
      _notificationEventManager
          .add(DidReceiveNotificationEvent(appInBackground: false));
      if (Platform.isAndroid) {
        _showLocalNotification(PushNotificationPayload.fromJson(
          event.data,
          notification: event.notification,
        ));
      }
    });

    // app in background, tapped remote notification
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      _notificationTappedHandler(PushNotificationPayload.fromJson(
        event.data,
        notification: event.notification,
      ).sendNotifyCd!);
    });
    // background notification comes
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<String> getNotifyToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    return token ?? 'undefine';
  }

  Future<NotificationTapEvent?> getInitialEvent() async {
    // check app open from remote notification
    await _checkAppOnPenFromRemoteNotification();

    //Android only: check if app open from local-notification
    await _checkAppOpenFromLocalNotification();

    String notiCd = _initialEvent?.sendNotifyCd ?? '';
    // _initialEvent = null; // remove
    return (notiCd.isNotEmpty)
        ? NotificationTapEvent(sendNotifyCd: notiCd)
        : null;
  }

  /* In Android when application in background or killed, incoming notification will be shown by system
    * but when application in fore-ground, the application have to show the banner by using local notification
    * In iOS: all incoming notification will be shown by system
    */
  Future<void> _showLocalNotification(PushNotificationPayload data) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('id', 'channel',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    // only for Android
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _notificationTappedHandler);

    await _flutterLocalNotificationsPlugin.show(
        1, data.title, data.body, platformChannelSpecifics,
        payload: data.sendNotifyCd);
  }

  _checkAppOpenFromLocalNotification() async {
    //Android only: check if app open from local-notification
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();
    final sendNotifyCd = notificationAppLaunchDetails?.payload ?? '';
    if (sendNotifyCd.isNotEmpty) {
      // notify event
      _initialEvent = NotificationTapEvent(sendNotifyCd: sendNotifyCd);
    }
  }

  _checkAppOnPenFromRemoteNotification() async {
    // Check if app open from push - notification
    final noti = await FirebaseMessaging.instance.getInitialMessage();
    if (noti != null) {
      // open from push notification
      String sendNotifyCd = PushNotificationPayload.fromJson(
            noti.data,
            notification: noti.notification,
          ).sendNotifyCd ??
          '';
      if (sendNotifyCd.isNotEmpty) {
        // notify event
        _initialEvent = NotificationTapEvent(sendNotifyCd: sendNotifyCd);
      }
    }
  }

  /**
   * Call when notification come  
   */
  Future _notificationTappedHandler(String? sendNotifyCd) async {
    if (sendNotifyCd?.isNotEmpty ?? false) {
      _notificationEventManager.add(NotificationTapEvent(
        sendNotifyCd: sendNotifyCd!,
      ));
    }
  }

// firebase messaging android
  final AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
  );
}

// must be outside of class
//a top-level named handler which background/terminated messages will
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final port = IsolateNameServer.lookupPortByName(backgroundMessageIsolateName);
  port?.send(message.data);
}

final ReceivePort backgroundMessagePort = ReceivePort();
const String backgroundMessageIsolateName = 'fcm_background_msg_isolate';

Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) async {}

void backgroundMessagePortHandler(message) {
  PushNotificationHandler.shared._notificationEventManager
      .add(DidReceiveNotificationEvent(
    appInBackground: true,
  ));
  // Here I can access and update my top-level variables.
}
