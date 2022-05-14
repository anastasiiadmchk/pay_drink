import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pay_drink/app/service_locator.dart';
import 'package:pay_drink/core/utils/log.dart';
import 'package:pay_drink/domain/repositories/auth_repo.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepoImpl implements AuthRepo {
  final _firebaseAuth = locator<FirebaseAuth>();
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final user = userCredential.user;

      return user;
    } catch (e, s) {
      signOut();
      if (e is PlatformException) {
        if (e.code == 'popup_closed_by_user') {
          return null;
        } else if (e.code == 'popup_blocked_by_browser') {
          return null;
        } else if (e.code == 'sign_in_cancelled') {
          return null;
        }
      }
      logError('AuthRepoImpl::signInWithGoogle:', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
    } catch (e, s) {
      logError('AuthRepoImpl::logOut:', error: e, stackTrace: s);
      return Future.error(e);
    }
  }

  @override
  Future<User?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      return user;
    } catch (e, s) {
      signOut();
      logError(
        'AuthRepoImpl::signInWithEmailPassword',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Future<User?> createUserWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      return user;
    } catch (e, s) {
      logError(
        'AuthRepoImpl::createUserWithEmailPassword',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Future<User?> signInWithApple() async {
    try {
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final UserCredential authResult =
          await _firebaseAuth.signInWithCredential(oauthCredential);

      return authResult.user;
    } catch (e, s) {
      logError('AuthRepoImpl::signInWithApple:', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<User?> silentLogin() async {
    try {
      return Future.value(_firebaseAuth.currentUser);
    } catch (e, s) {
      logError('AuthRepoImpl::silentLogin:', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<void> requestResetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(
        email: email,
      );
    } catch (e, s) {
      logError('AuthRepoImpl::requestResetPassword', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<String> verifyResetPasswordCode({required String code}) async {
    try {
      return _firebaseAuth.verifyPasswordResetCode(code);
    } catch (e, s) {
      logError(
        'AuthRepoImpl::verifyResetPasswordCode:',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    try {
      await _firebaseAuth.confirmPasswordReset(
        code: code,
        newPassword: newPassword,
      );
    } catch (e, s) {
      logError('AuthRepoImpl::confirmPasswordReset:', error: e, stackTrace: s);
      rethrow;
    }
  }

  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRST'
        'UVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<bool> isUserExists({
    required String userId,
  }) async {
    try {
      final user = await _usersCollection.doc(userId).get();
      return user.exists;
    } catch (e, s) {
      logError('AuthRepoImpl::isUserExists:', error: e, stackTrace: s);
      return false;
    }
  }
}
