// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAQy7mTFTXCA_r4V1S-epZECNp2qwBWezA',
    appId: '1:150395265274:web:9db860ca7a6498a76a6943',
    messagingSenderId: '150395265274',
    projectId: 'quys-flutter-app',
    authDomain: 'quys-flutter-app.firebaseapp.com',
    storageBucket: 'quys-flutter-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBYl5OmYNRgTtsPSBQoHbx3mcwZXiK8K2g',
    appId: '1:150395265274:android:c5cc0183b5f3d6f66a6943',
    messagingSenderId: '150395265274',
    projectId: 'quys-flutter-app',
    storageBucket: 'quys-flutter-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB3PFa7HiEC5FGg_ja3qu9kH8dYJb6lSsc',
    appId: '1:150395265274:ios:e834d99a37146c886a6943',
    messagingSenderId: '150395265274',
    projectId: 'quys-flutter-app',
    storageBucket: 'quys-flutter-app.appspot.com',
    iosClientId: '150395265274-m2kl9a3knfqpspago1ls9p63jfcqaojv.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterapp',
  );
}
