import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daily_verse/services/NotificationManager.dart'; // Import the NotificationManager

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TimeOfDay selectedTime = TimeOfDay(hour: 8, minute: 0); // Default time
  late NotificationManager _notificationManager;

  @override
  void initState() {
    super.initState();
    _notificationManager = NotificationManager();
    _loadSavedTime();
  }

  Future<void> _loadSavedTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt('notification_hour') ?? 8;
    final minute = prefs.getInt('notification_minute') ?? 0;
    setState(() {
      selectedTime = TimeOfDay(hour: hour, minute: minute);
    });
    debugPrint('Loaded saved time: $selectedTime');
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('notification_hour', picked.hour);
      prefs.setInt('notification_minute', picked.minute);
      debugPrint('Selected time: $picked');

      // Schedule notification with the new time
      await _notificationManager.scheduleNotification(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text('Select Time for Notifications'),
            ),
            SizedBox(height: 20),
            Text('Selected Time: ${selectedTime.format(context)}'),
          ],
        ),
      ),
    );
  }
}
