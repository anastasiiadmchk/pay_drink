import 'package:flutter/material.dart';
import 'package:pay_drink/app/service_locator.dart';
import 'package:pay_drink/domain/repositories/analytics_repo.dart';

class NavigationUtil {
  static void toScreen({
    required BuildContext context,
    required Widget screen,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen),
    );

    locator<AnalyticsRepo>().setCurrentScreen(
      screen.runtimeType.toString(),
    );
  }

  static void toScreenFade({
    required BuildContext context,
    required Widget screen,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: screen,
          );
        },
      ),
    );

    locator<AnalyticsRepo>().setCurrentScreen(
      screen.runtimeType.toString(),
    );
  }

  static void popScreen({required BuildContext context}) {
    Navigator.of(context).pop();
  }

  static void toScreenAndCleanBackstack({
    required BuildContext context,
    required Widget screen,
  }) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => screen),
      (r) => false,
    );

    locator<AnalyticsRepo>().setCurrentScreen(
      screen.runtimeType.toString(),
    );
  }

  static void popToTabs({
    required BuildContext context,
  }) {
    Navigator.of(context).popUntil(
      (r) => r.isFirst,
    );
  }

  static void toScreenReplacement({
    required BuildContext context,
    required Widget screen,
  }) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => screen),
    );

    locator<AnalyticsRepo>().setCurrentScreen(
      screen.runtimeType.toString(),
    );
  }
}
