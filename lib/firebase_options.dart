// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyB3dpGGkHCbprK607jfrJCE9yU_aMDs7Ac',
    appId: '1:500038653606:web:91dcc773282a981f3ac667',
    messagingSenderId: '500038653606',
    projectId: 'happy-hour-9d53e',
    authDomain: 'happy-hour-9d53e.firebaseapp.com',
    storageBucket: 'happy-hour-9d53e.appspot.com',
    measurementId: 'G-TKLB8XQ7DP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAUoiSwqQ86Rj8gA3ZsKnGRFwXxeeJJHNE',
    appId: '1:500038653606:android:9d342b3d13bf38003ac667',
    messagingSenderId: '500038653606',
    projectId: 'happy-hour-9d53e',
    storageBucket: 'happy-hour-9d53e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDWbuH2JhZ9j01w-p09L1DtXCcSfTi990s',
    appId: '1:500038653606:ios:467e6fbf5a9f0a673ac667',
    messagingSenderId: '500038653606',
    projectId: 'happy-hour-9d53e',
    storageBucket: 'happy-hour-9d53e.appspot.com',
    iosBundleId: 'com.example.happyHour',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDWbuH2JhZ9j01w-p09L1DtXCcSfTi990s',
    appId: '1:500038653606:ios:467e6fbf5a9f0a673ac667',
    messagingSenderId: '500038653606',
    projectId: 'happy-hour-9d53e',
    storageBucket: 'happy-hour-9d53e.appspot.com',
    iosBundleId: 'com.example.happyHour',
  );
}
