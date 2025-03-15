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
    apiKey: 'AIzaSyCuiZrku3sABwAO3_wSCglRF6KWr8W-46M',
    appId: '1:337148413854:web:128e8d20f5b4b2bee5b88f',
    messagingSenderId: '337148413854',
    projectId: 'cache-money-e032d',
    authDomain: 'cache-money-e032d.firebaseapp.com',
    databaseURL: 'https://cache-money-e032d-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'cache-money-e032d.firebasestorage.app',
    measurementId: 'G-0RJGS4161W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCL6JTePdoKfwU5z5FcEdRYxN7CLL1o1HU',
    appId: '1:337148413854:android:d2acc8ad0cbfe7e3e5b88f',
    messagingSenderId: '337148413854',
    projectId: 'cache-money-e032d',
    databaseURL: 'https://cache-money-e032d-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'cache-money-e032d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD1q1kcTpTjbUhW5K4gfULjxfmq43nacJ8',
    appId: '1:337148413854:ios:94136ad15d408e5de5b88f',
    messagingSenderId: '337148413854',
    projectId: 'cache-money-e032d',
    databaseURL: 'https://cache-money-e032d-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'cache-money-e032d.firebasestorage.app',
    iosBundleId: 'com.example.hivemindBeta',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD1q1kcTpTjbUhW5K4gfULjxfmq43nacJ8',
    appId: '1:337148413854:ios:94136ad15d408e5de5b88f',
    messagingSenderId: '337148413854',
    projectId: 'cache-money-e032d',
    databaseURL: 'https://cache-money-e032d-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'cache-money-e032d.firebasestorage.app',
    iosBundleId: 'com.example.hivemindBeta',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCuiZrku3sABwAO3_wSCglRF6KWr8W-46M',
    appId: '1:337148413854:web:78e7ed73fef38a92e5b88f',
    messagingSenderId: '337148413854',
    projectId: 'cache-money-e032d',
    authDomain: 'cache-money-e032d.firebaseapp.com',
    databaseURL: 'https://cache-money-e032d-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'cache-money-e032d.firebasestorage.app',
    measurementId: 'G-NNWJRGVHN3',
  );

}