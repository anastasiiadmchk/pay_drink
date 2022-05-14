import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepo {
  Future<User?> signInWithGoogle();

  Future<User?> signInWithApple();

  Future<User?> signInWithEmailPassword({
    required String email,
    required String password,
  });
  Future<User?> createUserWithEmailPassword({
    required String email,
    required String password,
  });
  Future<void> requestResetPassword({required String email});

  Future<User?> silentLogin();
  Future<bool> isUserExists({
    required String userId,
  });

  Future<void> signOut();
}
