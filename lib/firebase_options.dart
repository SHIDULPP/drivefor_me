// File generated for Drive For Me user app (Firebase project driveforme-706f9).
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxERp0eZ0Ob_N_YF_SEeX-JxsQOqE1VY8',
    appId: '1:38589530732:android:fba40d20148ca084a48e49',
    messagingSenderId: '38589530732',
    projectId: 'driveforme-706f9',
    storageBucket: 'driveforme-706f9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBwj4csZsF_1XfRTSEDmtPgfKfOwC5k4yw',
    appId: '1:38589530732:ios:1680bea114be683aa48e49',
    messagingSenderId: '38589530732',
    projectId: 'driveforme-706f9',
    storageBucket: 'driveforme-706f9.firebasestorage.app',
    iosBundleId: 'com.example.driveformeUser',
  );
}
