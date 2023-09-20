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
    apiKey: 'AIzaSyC-v5nsEAZB0v4AWalSAFtnr9lWD0ELLSc',
    appId: '1:1098086294215:web:d445a2f0a62e539a03d4e2',
    messagingSenderId: '1098086294215',
    projectId: 'lf07-cyber-physical-system',
    authDomain: 'lf07-cyber-physical-system.firebaseapp.com',
    storageBucket: 'lf07-cyber-physical-system.appspot.com',
    measurementId: 'G-TK45PTPPDR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDvyqUk9O4xwAAy0Cx2QUEVaIc_qrefPzg',
    appId: '1:1098086294215:android:3800861d081d7bd903d4e2',
    messagingSenderId: '1098086294215',
    projectId: 'lf07-cyber-physical-system',
    storageBucket: 'lf07-cyber-physical-system.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBHtMSkV8Dcb2A85DuHPLKIp_W_bP9I0E0',
    appId: '1:1098086294215:ios:2450018ff461755e03d4e2',
    messagingSenderId: '1098086294215',
    projectId: 'lf07-cyber-physical-system',
    storageBucket: 'lf07-cyber-physical-system.appspot.com',
    iosBundleId: 'com.example.lf07CyberPhysicalSystem',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBHtMSkV8Dcb2A85DuHPLKIp_W_bP9I0E0',
    appId: '1:1098086294215:ios:160fea931ee780b903d4e2',
    messagingSenderId: '1098086294215',
    projectId: 'lf07-cyber-physical-system',
    storageBucket: 'lf07-cyber-physical-system.appspot.com',
    iosBundleId: 'com.example.lf07CyberPhysicalSystem.RunnerTests',
  );
}
