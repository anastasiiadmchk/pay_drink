import 'package:catcher/catcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pay_drink/app/app.dart';
import 'package:pay_drink/app/service_locator.dart';
import 'package:pay_drink/core/utils/toast_report_handler.dart';

class ApplicationInitializer {
  Future<void> initAndRun() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await _initFirebase();

    await setupLocator();

    late final CatcherOptions catcherReleaseConfig;

    catcherReleaseConfig = CatcherOptions(
      PageReportMode(showStackTrace: true),
      <ReportHandler>[
        ToastReportHandler(),
      ],
    );

    Catcher(
      rootWidget: const App(),
      ensureInitialized: true,
      debugConfig: CatcherOptions(
        SilentReportMode(),
        <ReportHandler>[
          ConsoleHandler(enableDeviceParameters: false),
          // ToastHandler(
          //   customMessage: 'Unexpected error',
          //   length: ToastHandlerLength.long,
          //   gravity: ToastHandlerGravity.top,
          //   backgroundColor: Colors.red.shade300,
          // ),
        ],
      ),
      profileConfig: catcherReleaseConfig,
      releaseConfig: catcherReleaseConfig,
    );
  }

  Future<void> _initFirebase() async {
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(!kDebugMode);
    await FirebasePerformance.instance
        .setPerformanceCollectionEnabled(!kDebugMode);
  }
}
