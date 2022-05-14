import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay_drink/core/utils/log.dart';
import 'package:pay_drink/domain/blocs/auth/auth_state.dart';
import 'package:pay_drink/domain/repositories/auth_repo.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required AuthRepo authRepo})
      : super(const AuthState(isLoading: false)) {
    _authRepo = authRepo;
  }

  late final AuthRepo _authRepo;

  Future<void> silentLogin() async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));

      final user = await _authRepo.silentLogin();
      if (user == null) {
        emit(AuthFailure());
        return;
      }

      await isUserRegistered(userId: user.uid);
      emit(state.copyWith(isLoading: false, firebaseUser: user));
    } catch (e) {
      emit(AuthFailure());
      emit(stableState.copyWith(isLoading: false));
    }
  }

  Future<void> switchSignUp() async {
    final stableState = state;
    try {
      emit(state.copyWith(isSignIn: !state.isSignIn));
    } catch (e, s) {
      logError('AuthCubit::switchSignIn:', error: e, stackTrace: s);
      emit(stableState);
    }
  }

  Future<void> requestResetPassword({required String email}) async {
    final stableState = state;
    try {
      await _authRepo.requestResetPassword(email: email);
      emit(PasswordResetRequested());
    } catch (e) {
      _emitAuthError(e);
      emit(stableState);
    }
  }

  Future<void> signInWithGoogle() async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));
      final user = await _authRepo.signInWithGoogle();
      if (user != null) {
        await isUserRegistered(userId: user.uid);
        emit(stableState.copyWith(isLoading: false, firebaseUser: user));
        return;
      }
      emit(AuthFailure());
      emit(stableState.copyWith(isLoading: false));
    } catch (e, s) {
      logError('AuthCubit::signInWithGoogle:', error: e, stackTrace: s);
      emit(stableState);
    }
  }

  Future<void> signInWithApple() async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));
      final user = await _authRepo.signInWithApple();

      if (user != null) {
        await isUserRegistered(userId: user.uid);
        emit(stableState.copyWith(isLoading: false, firebaseUser: user));
        return;
      }

      emit(UserNotFoundFailure());
      emit(stableState.copyWith(isLoading: false));
    } catch (e, s) {
      logError('AuthCubit::signInWithApple:', error: e, stackTrace: s);
      emit(stableState);
    }
  }

  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));
      final user = await _authRepo.signInWithEmailPassword(
        email: email,
        password: password,
      );

      if (user != null) {
        await isUserRegistered(userId: user.uid);
        emit(stableState.copyWith(isLoading: false, firebaseUser: user));
        return;
      }

      emit(UserNotFoundFailure());
    } catch (e, s) {
      logError('AuthCubit::signInWithEmailPassword:', error: e, stackTrace: s);
      _emitAuthError(e);
      emit(stableState);
    }
  }

  Future<void> signOut() async {
    final stableState = state;
    try {
      await _authRepo.signOut();
      emit(const Unauthorized());
    } catch (e, s) {
      logError('AuthCubit::signOut:', error: e, stackTrace: s);
      emit(stableState);
    }
  }

  Future<void> isUserRegistered({
    required String userId,
  }) async {
    try {
      final isUserExists = await _authRepo.isUserExists(userId: userId);
      if (isUserExists) {
        emit(AuthSuccess());
      } else {
        emit(InsufficientUserInfo());
      }
    } catch (e, s) {
      logError('AuthCubit::isUserRegistered:', error: e, stackTrace: s);
      emit(AuthFailure());
    }
  }

  void _emitAuthError(Object e) {
    if (e is FirebaseAuthException) {
      if (e.code == 'invalid-email') {
        emit(InvalidEmailAuthFailure());
      }
      if (e.code == 'user-not-found') {
        emit(UserNotFoundFailure());
      }
      if (e.code == 'wrong-password') {
        emit(WrongPasswordFailure());
      }
      if (e.code == 'account-exists-with-different-credential') {
        emit(DifferentCredentialFailure());
      }
      if (e.code == 'invalid-email') {
        emit(InvalidEmailAuthFailure());
      }
      if (e.code == 'email-already-in-use') {
        emit(EmailAlreadyInUseFailure());
      }
      if (e.code == 'user-disabled') {
        emit(UserDisabledFailure());
      }
      if (e.code == 'weak-password') {
        emit(WeakPasswordFailure());
      }
    } else {
      emit(AuthFailure(error: 'Unexpected error has occurred.'));
    }
  }
}
