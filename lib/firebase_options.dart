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
    apiKey: 'AIzaSyAkk8jZZCrqyVD9TU8JmDg5rUDk54_yvMQ',
    appId: '1:456690197118:web:005ea36a218a53a6ceee2f',
    messagingSenderId: '456690197118',
    projectId: 'myapptor',
    databaseURL:
        "https://myapptor-default-rtdb.asia-southeast1.firebasedatabase.app/",
    authDomain: 'myapptor.firebaseapp.com',
    storageBucket: 'myapptor.appspot.com',
    measurementId: 'G-1JGHBSGMEG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBJQcMaLDQwRmILRczDLT_2SnLBA4WA8N4',
    appId: '1:456690197118:android:ce0a5f15026dd0e3ceee2f',
    databaseURL:
        "https://myapptor-default-rtdb.asia-southeast1.firebasedatabase.app/",
    messagingSenderId: '456690197118',
    projectId: 'myapptor',
    storageBucket: 'myapptor.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBjuwjIlaaBR-dmKPvN6ryyRYR70wfgWLI',
    appId: '1:456690197118:ios:8a1dbb0ac0f35018ceee2f',
    databaseURL:
        "https://myapptor-default-rtdb.asia-southeast1.firebasedatabase.app/",
    messagingSenderId: '456690197118',
    projectId: 'myapptor',
    storageBucket: 'myapptor.appspot.com',
    iosClientId:
        '456690197118-5deaa0mulj437rnjti5i7dulegoic5tg.apps.googleusercontent.com',
    iosBundleId: 'com.example.myTor',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBjuwjIlaaBR-dmKPvN6ryyRYR70wfgWLI',
    appId: '1:456690197118:ios:8a1dbb0ac0f35018ceee2f',
    databaseURL:
        "https://myapptor-default-rtdb.asia-southeast1.firebasedatabase.app/",
    messagingSenderId: '456690197118',
    projectId: 'myapptor',
    storageBucket: 'myapptor.appspot.com',
    iosClientId:
        '456690197118-5deaa0mulj437rnjti5i7dulegoic5tg.apps.googleusercontent.com',
    iosBundleId: 'com.example.myTor',
  );
}
