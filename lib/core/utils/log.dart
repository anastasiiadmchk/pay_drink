import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final _logger = Logger();

void logInfo(String? message) => _logger.i(message);

void logWarning(String message) => _logger.w(message);

void logError(dynamic message, {Object? error, StackTrace? stackTrace}) {
  String errorMessage = '';
  try {
    errorMessage = message.toString();
  } catch (e, s) {
    errorMessage = 'Not possible cast ${error.runtimeType} to String: ';
    errorMessage += e.toString();
    if (kDebugMode) {
      print('$e, $s');
    }
  }
  if (Firebase.apps.isNotEmpty && !kIsWeb && !kDebugMode) {
    FirebaseCrashlytics.instance
        .recordError(error, stackTrace, reason: errorMessage);
  } else {
    if (kDebugMode) {
      print(errorMessage);
    }
  }
  _logger.e(errorMessage, [error, stackTrace]);
}

void logVerbose(dynamic message) => _logger.v(message);

void logUser({
  required int userId,
  required String firebaseUserId,
  String? email,
  String? firstName,
  String? lastName,
  String? nickName,
}) {
  // FirebaseCrashlytics.instance.setUserIdentifier(userId.toString());
  // FirebaseCrashlytics.instance.setCustomKey('firebaseUserId', firebaseUserId);

  // if (email != null) {
  //   FirebaseCrashlytics.instance.setCustomKey('email', email);
  // }

  // if (firstName != null) {
  //   FirebaseCrashlytics.instance.setCustomKey('First name', firstName);
  // }
  // if (lastName != null) {
  //   FirebaseCrashlytics.instance.setCustomKey('Last name', lastName);
  // }
  // if (nickName != null) {
  //   FirebaseCrashlytics.instance.setCustomKey('Nickname', nickName);
  // }
}
