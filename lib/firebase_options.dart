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
    apiKey: 'AIzaSyAd8IIxg38mAoMu_fbbyt-Xtc-ym_LWcHk',
    appId: '1:572398802928:web:20d58f1499556c3570ef35',
    messagingSenderId: '572398802928',
    projectId: 'historiasmundo-b9a7b',
    authDomain: 'historiasmundo-b9a7b.firebaseapp.com',
    storageBucket: 'historiasmundo-b9a7b.firebasestorage.app',
    measurementId: 'G-6S9Z0RM6VT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC3EvHCnoBVpY8NkrLYHiYXAO_9E2bXg58',
    appId: '1:572398802928:android:5f210fef298d359770ef35',
    messagingSenderId: '572398802928',
    projectId: 'historiasmundo-b9a7b',
    storageBucket: 'historiasmundo-b9a7b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDRc0lZYJHIKOdKp0e2_892Ulu6YF172E0',
    appId: '1:572398802928:ios:f6f667af158c151e70ef35',
    messagingSenderId: '572398802928',
    projectId: 'historiasmundo-b9a7b',
    storageBucket: 'historiasmundo-b9a7b.firebasestorage.app',
    iosBundleId: 'com.example.historiasMundo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDRc0lZYJHIKOdKp0e2_892Ulu6YF172E0',
    appId: '1:572398802928:ios:f6f667af158c151e70ef35',
    messagingSenderId: '572398802928',
    projectId: 'historiasmundo-b9a7b',
    storageBucket: 'historiasmundo-b9a7b.firebasestorage.app',
    iosBundleId: 'com.example.historiasMundo',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAd8IIxg38mAoMu_fbbyt-Xtc-ym_LWcHk',
    appId: '1:572398802928:web:8d42563fb99d68f970ef35',
    messagingSenderId: '572398802928',
    projectId: 'historiasmundo-b9a7b',
    authDomain: 'historiasmundo-b9a7b.firebaseapp.com',
    storageBucket: 'historiasmundo-b9a7b.firebasestorage.app',
    measurementId: 'G-JH667PLBLC',
  );
}