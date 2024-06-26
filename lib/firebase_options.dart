// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBebbLAFDcN94tSbusNc6Hs9mt1iUEUhbg',
    appId: '1:409718254006:web:105d20d30736251e003917',
    messagingSenderId: '409718254006',
    projectId: 'aya-on-time',
    authDomain: 'aya-on-time.firebaseapp.com',
    storageBucket: 'aya-on-time.appspot.com',
    measurementId: 'G-JF1K2V8115',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBMnCCP2MBnm5plCuHscj1ozizWO1vKBnU',
    appId: '1:409718254006:android:e3a76b71329ee1db003917',
    messagingSenderId: '409718254006',
    projectId: 'aya-on-time',
    storageBucket: 'aya-on-time.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDcYUVXYKDeyqSQvzMPWOM1s-BrTonuZoU',
    appId: '1:409718254006:ios:ff85a4afefb10819003917',
    messagingSenderId: '409718254006',
    projectId: 'aya-on-time',
    storageBucket: 'aya-on-time.appspot.com',
    iosBundleId: 'com.example.dailyVerse',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDcYUVXYKDeyqSQvzMPWOM1s-BrTonuZoU',
    appId: '1:409718254006:ios:ff85a4afefb10819003917',
    messagingSenderId: '409718254006',
    projectId: 'aya-on-time',
    storageBucket: 'aya-on-time.appspot.com',
    iosBundleId: 'com.example.dailyVerse',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBebbLAFDcN94tSbusNc6Hs9mt1iUEUhbg',
    appId: '1:409718254006:web:0b6cb91035934ede003917',
    messagingSenderId: '409718254006',
    projectId: 'aya-on-time',
    authDomain: 'aya-on-time.firebaseapp.com',
    storageBucket: 'aya-on-time.appspot.com',
    measurementId: 'G-5EPC72YKZ8',
  );
}
