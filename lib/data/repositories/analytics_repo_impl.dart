import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:pay_drink/core/utils/log.dart';
import 'package:pay_drink/domain/models/enums/sign_in_providers.dart';
import 'package:pay_drink/domain/repositories/analytics_repo.dart';
import 'package:pay_drink/theme/constants.dart';

class AnalyticsRepoImpl implements AnalyticsRepo {
  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics.instance;

  String get _getPlatform {
    if (kIsWeb) {
      return Constants.web;
    } else if (Platform.isAndroid) {
      return Constants.android;
    } else if (Platform.isIOS) {
      return Constants.iOS;
    } else {
      return Constants.unknown;
    }
  }

  String _getSignInProvider(SignInProvider service) {
    switch (service) {
      case SignInProvider.google:
        return 'Google';
      case SignInProvider.apple:
        return 'Apple';
      case SignInProvider.email:
        return 'Email';
      default:
        return 'Unknown';
    }
  }

  @override
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters}) async {
    await runZonedGuarded(() async {
      logInfo('Analytics event added: name: $name\nparameters: $parameters');
      await _firebaseAnalytics.logEvent(name: name, parameters: parameters);
    }, (e, s) {
      logError('AnalyticsServiceImpl::logEvent: $e $s');
    });
  }

  @override
  Future<void> login(String userId, SignInProvider provider) async {
    logEvent(
      'login',
      parameters: {
        'user_id': userId,
        'platform': _getPlatform,
        'provider': _getSignInProvider(provider)
      },
    );
  }

  @override
  Future<void> newUser(SignInProvider service) async {
    await logEvent(
      'sign_up',
      parameters: {
        'sign_in_provider': _getSignInProvider(service),
        'platform': _getPlatform,
      },
    );
  }

  @override
  Future<void> setCurrentScreen(String? screenName) async {
    await runZonedGuarded(() async {
      logEvent('Analytics current screen: $screenName');
      await _firebaseAnalytics.setCurrentScreen(screenName: screenName);
    }, (e, s) {
      logError('AnalyticsServiceImpl::setCurrentScreen');
    });
  }

  @override
  Future<void> setUserProperties({
    required String userId,
    required String? userName,
    required String? userEmail,
  }) async {
    logInfo(
      'AnalyticsService::setUserProperties:\nid: '
      '$userId\nname: $userName\nemail: $userEmail',
    );
    await _firebaseAnalytics.setUserId(id: userId);
    await _firebaseAnalytics.setUserProperty(
      name: 'user_name',
      value: userName,
    );
    await _firebaseAnalytics.setUserProperty(
      name: 'user_email',
      value: userEmail,
    );
  }

  @override
  Future<void> loggedOut({required String userId}) async {
    logEvent(
      'logged_out',
      parameters: {
        'user_id': userId,
        'platform': _getPlatform,
      },
    );
  }
}
