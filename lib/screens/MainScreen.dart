import 'package:daily_verse/services/DatabaseHelper.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String verseOfTheDay = "";

  @override
  void initState() {
    super.initState();
    _loadVerse();
  }

  void _loadVerse() async {
    TimeOfDay notificationTime = TimeOfDay(hour: 8, minute: 0); // Example notification time
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime notificationDateTime = DateTime(today.year, today.month, today.day, notificationTime.hour, notificationTime.minute);

    String dateToQuery = today.toString().substring(0, 10); // Format as "YYYY-MM-DD"

    if (now.isBefore(notificationDateTime)) {
      // If current time is before today's notification time, show yesterday's verse
      DateTime yesterday = today.subtract(Duration(days: 1));
      dateToQuery = yesterday.toString().substring(0, 10);
    }

    String? fetchedVerse = await DatabaseHelper().getRandomVerse();
    setState(() {
      verseOfTheDay = fetchedVerse!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Verse'),
      ),
      body: Center(
        // child: Text(verseOfTheDay),
      ),    );
  }
}
