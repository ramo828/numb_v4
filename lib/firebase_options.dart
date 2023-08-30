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
    apiKey: 'AIzaSyBnMcjBgm8IK0ibSSlGlh_iHJ9ADFSfOWs',
    appId: '1:756817341318:web:876c0da870b7c610105a07',
    messagingSenderId: '756817341318',
    projectId: 'mekan-4c393',
    authDomain: 'mekan-4c393.firebaseapp.com',
    storageBucket: 'mekan-4c393.appspot.com',
    measurementId: 'G-0JNPSWJGE4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAVHFW__CA-W9ztsQttFu3WNVE2gRidrPw',
    appId: '1:756817341318:android:bb725127fe884181105a07',
    messagingSenderId: '756817341318',
    projectId: 'mekan-4c393',
    storageBucket: 'mekan-4c393.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAsWY5LU0oOYvzh5tCOyNMqaLrfrB_Z9Rw',
    appId: '1:756817341318:ios:ec3be19643086685105a07',
    messagingSenderId: '756817341318',
    projectId: 'mekan-4c393',
    storageBucket: 'mekan-4c393.appspot.com',
    iosClientId:
        '756817341318-cjupnrteg5nathqdnqf2au8b4uuptpqu.apps.googleusercontent.com',
    iosBundleId: 'com.example.eCom',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAsWY5LU0oOYvzh5tCOyNMqaLrfrB_Z9Rw',
    appId: '1:756817341318:ios:71ee3237de34b1eb105a07',
    messagingSenderId: '756817341318',
    projectId: 'mekan-4c393',
    storageBucket: 'mekan-4c393.appspot.com',
    iosClientId:
        '756817341318-or4a2316e80qlatouek6hiitej0170e2.apps.googleusercontent.com',
    iosBundleId: 'com.example.eCom.RunnerTests',
  );
}
