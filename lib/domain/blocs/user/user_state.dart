import 'package:pay_drink/domain/models/user/user_model.dart';

class UserState {
  final bool isLoading;
  final UserModel? userModel;

  const UserState({
    this.isLoading = false,
    this.userModel,
  });

  UserState copyWith({
    bool? isLoading,
    final bool? isEdited,
    UserModel? userModel,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      userModel: userModel ?? this.userModel,
    );
  }
}

class UserEditSuccess extends UserState {}

class NoUser extends UserFailure {}

class UserEditFailure extends UserFailure {}

class UserGetFailure extends UserFailure {}

class UserFailure extends UserState {
  final String? error;
  UserFailure({this.error});
}
