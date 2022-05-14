import 'package:pay_drink/domain/models/enums/sign_in_providers.dart';

abstract class AnalyticsRepo {
  Future<void> setUserProperties({
    required String userId,
    required String? userName,
    required String? userEmail,
  });

  Future<void> newUser(SignInProvider service);

  Future<void> logEvent(String name, {Map<String, dynamic>? parameters});

  Future<void> login(String userId, SignInProvider provider);

  Future<void> setCurrentScreen(String? screenName);

  Future<void> loggedOut({required String userId});
}
