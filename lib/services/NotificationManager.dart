import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings settings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        debugPrint('Notification clicked with payload: ${response.payload}');
      },
    );

    // Set up FCM listeners
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        debugPrint('Received foreground message: ${notification.title} - ${notification.body}');
        showNotification(notification.title, notification.body);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Message clicked with data: ${message.data}');
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        debugPrint('Message clicked with title: ${notification.title}');
      }
    });

    debugPrint('Notifications initialized');
  }

  Future<void> showNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'verse_channel', // Channel ID
      'Daily Verse', // Channel Name
      channelDescription: 'Daily notification with a verse',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
    NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title, // Notification Title
      body, // Notification Body
      platformDetails,
    );
    debugPrint('Notification shown: $title - $body');
  }

  Future<void> scheduleNotification(TimeOfDay notificationTime) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, notificationTime.hour, notificationTime.minute);

    if (scheduledDate.isBefore(now)) {
      debugPrint('Scheduled time is before current time, adding one day to schedule time.');
      scheduledDate.add(Duration(days: 1));
    }

    debugPrint('Current time: $now');
    debugPrint('Scheduled notification time: $scheduledDate');

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Scheduled Notification',
      '',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'verse_channel', // Channel ID
          'Daily Verse', // Channel Name
          channelDescription: 'Daily notification with a verse',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    debugPrint('Notification scheduled for: $scheduledDate');
  }
}
