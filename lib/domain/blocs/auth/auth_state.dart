import 'package:firebase_auth/firebase_auth.dart';
import 'package:pay_drink/domain/models/user/user_model.dart';

class AuthState {
  final bool isLoading;
  final bool isSignIn;
  final User? firebaseUser;
  final UserModel? userModel;

  const AuthState({
    this.isLoading = false,
    this.isSignIn = true,
    this.firebaseUser,
    this.userModel,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isSignIn,
    User? firebaseUser,
    UserModel? userModel,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isSignIn: isSignIn ?? this.isSignIn,
      firebaseUser: firebaseUser ?? this.firebaseUser,
      userModel: userModel ?? this.userModel,
    );
  }
}

class AuthSuccess extends AuthState {}

class PasswordResetRequested extends AuthState {}

class InsufficientUserInfo extends AuthState {}

class AuthFailure extends AuthState {
  final String? error;
  AuthFailure({this.error});
}

class Unauthorized extends AuthState {
  const Unauthorized()
      : super(
          isLoading: false,
          firebaseUser: null,
          userModel: null,
        );
}

class InvalidEmailAuthFailure extends AuthFailure {}

class EmailAlreadyInUseFailure extends AuthFailure {}

class UserDisabledFailure extends AuthFailure {}

class WeakPasswordFailure extends AuthFailure {}

class UserNotFoundFailure extends AuthFailure {}

class WrongPasswordFailure extends AuthFailure {}

class DifferentCredentialFailure extends AuthFailure {}
