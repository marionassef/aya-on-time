import 'package:flutter/material.dart';
import 'package:daily_verse/services/DatabaseHelper.dart';
import 'package:daily_verse/services/NotificationManager.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'screens/SettingsScreen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.initDB();
  await NotificationManager().initNotifications();
  tz.initializeTimeZones();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      if (response.payload != null) {
        debugPrint('notification payload: ${response.payload}');
      }
    },
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Verse App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            fontFamily: 'Andalus',
            color: Colors.white,
          ),
        ),
      ),
      home: const MyHomePage(title: 'Verse of the Day'),
      routes: {
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _backgroundImages = [
    'assets/backgrounds/background-001.png',
    'assets/backgrounds/background-002.png',
    'assets/backgrounds/background-003.png',
    'assets/backgrounds/background-004.png',
    'assets/backgrounds/background-005.png',
    'assets/backgrounds/background-006.png',
    'assets/backgrounds/background-007.png',
    'assets/backgrounds/background-008.png',
    'assets/backgrounds/background-009.png',
    'assets/backgrounds/background-010.png',
    'assets/backgrounds/background-011.png',
    'assets/backgrounds/background-012.png',
    'assets/backgrounds/background-013.png',
    'assets/backgrounds/background-014.png',
    'assets/backgrounds/background-015.png',
    'assets/backgrounds/background-016.png',
    'assets/backgrounds/background-017.png',
    'assets/backgrounds/background-019.png',
    'assets/backgrounds/background-020.png',
    'assets/backgrounds/background-021.png',
    'assets/backgrounds/background-022.png',
    'assets/backgrounds/background-023.png',
    'assets/backgrounds/background-024.png',
    'assets/backgrounds/background-025.png',
    'assets/backgrounds/background-026.png',
    'assets/backgrounds/background-027.png',
    'assets/backgrounds/background-028.png',
    'assets/backgrounds/background-029.png',
    'assets/backgrounds/background-030.png',
    'assets/backgrounds/background-031.png',
    'assets/backgrounds/background-032.png',
    'assets/backgrounds/background-033.png',
    'assets/backgrounds/background-034.png',
    'assets/backgrounds/background-035.png',
    'assets/backgrounds/background-036.png',
    'assets/backgrounds/background-037.png',
    'assets/backgrounds/background-038.png',
    'assets/backgrounds/background-039.png',
    'assets/backgrounds/background-040.png',
    'assets/backgrounds/background-041.png',
    'assets/backgrounds/background-042.png',
    'assets/backgrounds/background-043.png',
    'assets/backgrounds/background-044.png',
    'assets/backgrounds/background-045.png',
    'assets/backgrounds/background-046.png',
    'assets/backgrounds/background-047.png',
    'assets/backgrounds/background-048.png',
    'assets/backgrounds/background-049.png',
    'assets/backgrounds/background-050.png',
  ];

  late String _backgroundImage;
  TimeOfDay notificationTime = TimeOfDay(hour: 8, minute: 0); // Default time
  late NotificationManager _notificationManager;

  @override
  void initState() {
    super.initState();
    _backgroundImage = _getRandomBackgroundImage();
    _notificationManager = NotificationManager();
    _loadNotificationTime();
    loadVerse();
  }

  Future<void> _loadNotificationTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt('notification_hour') ?? 8;
    final minute = prefs.getInt('notification_minute') ?? 0;
    setState(() {
      notificationTime = TimeOfDay(hour: hour, minute: minute);
    });
    debugPrint('Notification time loaded: $notificationTime');
    _scheduleDailyNotification();
  }

  String _getRandomBackgroundImage() {
    final random = Random();
    return _backgroundImages[random.nextInt(_backgroundImages.length)];
  }

  String verseOfTheDay = "";

  void loadVerse() async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime notificationDateTime = DateTime(today.year, today.month, today.day, notificationTime.hour, notificationTime.minute);

    String dateToQuery = DateFormat('yyyy-MM-dd').format(today);

    if (now.isBefore(notificationDateTime)) {
      DateTime yesterday = today.subtract(Duration(days: 1));
      dateToQuery = DateFormat('yyyy-MM-dd').format(yesterday);
    }

    String? fetchedVerse = (await DatabaseHelper().getRandomVerse()) as String?;
    if (fetchedVerse != null) {
      setState(() {
        verseOfTheDay = fetchedVerse;
      });
    } else {
      setState(() {
        verseOfTheDay = "No verse available for today.";
      });
    }
    debugPrint('Verse of the day loaded: $verseOfTheDay');
  }

  Future<void> _scheduleDailyNotification() async {
    await _notificationManager.scheduleDailyNotification(
      notificationTime,
      'Verse of the Day',
      verseOfTheDay,
    );
  }

  Future<void> _shareVerse() async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    await Share.share(
      verseOfTheDay,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    print(verseOfTheDay);
    return Scaffold(
      appBar: AppBar(
        title: Text('Verse of the Day'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareVerse,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                verseOfTheDay,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}