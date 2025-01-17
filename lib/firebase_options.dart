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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD9zO_4GvqbfoLTdmyHo19vg-XN2zAxkmA',
    appId: '1:936762017349:web:ae11540c82e1eff671052c',
    messagingSenderId: '936762017349',
    projectId: 'instagram-flutter-16d93',
    authDomain: 'instagram-flutter-16d93.firebaseapp.com',
    storageBucket: 'instagram-flutter-16d93.appspot.com',
    measurementId: 'G-TKCP9D065Q',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDQrQUW0gtOyxqyI8_2xvgYuAaKSTdvqVs',
    appId: '1:936762017349:android:77ff8501c10edb1571052c',
    messagingSenderId: '936762017349',
    projectId: 'instagram-flutter-16d93',
    storageBucket: 'instagram-flutter-16d93.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBjnZo6DI_jT7DC__Av5BCkqAcPtfUHOlQ',
    appId: '1:936762017349:ios:0013464351b5224a71052c',
    messagingSenderId: '936762017349',
    projectId: 'instagram-flutter-16d93',
    storageBucket: 'instagram-flutter-16d93.appspot.com',
    iosBundleId: 'com.example.instagramFlutter',
  );

}