import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/model/report_handler.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class FirebaseHandler extends ReportHandler {
  final Logger _logger = Logger(filter: DevelopmentFilter());

  @override
  Future<bool> handle(Report error, BuildContext? context) async {
    _logger.log(Level.warning, error.error);
    _logger.log(Level.warning, error.errorDetails);

    await FirebaseCrashlytics.instance
        .recordError(error.error, error.stackTrace);
    return true;
  }

  @override
  List<PlatformType> getSupportedPlatforms() {
    return <PlatformType>[PlatformType.android, PlatformType.iOS];
  }
}
