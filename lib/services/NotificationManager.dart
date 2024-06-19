import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';

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
    debugPrint('Notifications initialized');
  }

  Future<void> showDailyVerseNotification(String title, String body) async {
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

  Future<void> scheduleDailyNotification(TimeOfDay notificationTime, String title, String body) async {
    final now = tz.TZDateTime.now(tz.local);
    debugPrint('Current date and time: $now');

    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      notificationTime.hour,
      notificationTime.minute,
    );

    if (scheduledDate.isBefore(now)) {
      // If the scheduled time is before now, schedule for the next day
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    debugPrint('Scheduling notification: $title at $scheduledDate');
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      scheduledDate,
      NotificationDetails(android: AndroidNotificationDetails(
        'daily_verse_channel',
        'Daily Verse',
        channelDescription: 'Channel for daily verse notifications',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      )),
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
    );
    debugPrint('Notification scheduled for $scheduledDate');
  }

  Future<void> testImmediateNotification() async {
    await showDailyVerseNotification('Test Title', 'Test Body');
  }
}