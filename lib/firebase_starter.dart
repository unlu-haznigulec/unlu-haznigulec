import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/config/app_config.dart';

class FirebaseStarter {
  final FirebaseOptions firebaseOptions;
  final Future<void> Function(RemoteMessage) handler;

  FirebaseStarter(this.firebaseOptions, this.handler);

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      name: 'Piapiri',
      options: firebaseOptions,
    );
    FirebaseMessaging.onBackgroundMessage(handler);
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        fatal: true,
        printDetails: AppConfig.instance.flavor != Flavor.prod,
      );
      return true;
    };
  }
}
