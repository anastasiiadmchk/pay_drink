import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay_drink/core/utils/log.dart';
import 'package:pay_drink/domain/blocs/user/user_state.dart';
import 'package:pay_drink/domain/repositories/user_repo.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit({
    required UserRepo userRepo,
  }) : super(const UserState()) {
    _userRepo = userRepo;
  }
  late final UserRepo _userRepo;

  Future<void> getUserModel() async {
    final stableState = state;
    try {
      if (state.userModel == null || state == NoUser()) {
        emit(state.copyWith(isLoading: true));
        final userModel = await _userRepo.getUserModel();

        emit(
          state.copyWith(
            isLoading: false,
            userModel: userModel,
          ),
        );
      }
    } catch (e, s) {
      logError('UserCubit::getUserModel:', error: e, stackTrace: s);
      emit(UserGetFailure());
      emit(stableState);
    }
  }

  void resetUserModel() {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: false, userModel: null));
      emit(NoUser());
    } catch (e, s) {
      logError('UserCubit::getUserModel:', error: e, stackTrace: s);
      emit(UserGetFailure());
      emit(stableState);
    }
  }

  Future<void> updateUserModel() async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));
      final userModel = await _userRepo.getUserModel();

      emit(
        state.copyWith(
          isLoading: false,
          userModel: userModel,
        ),
      );
    } catch (e, s) {
      logError('UserCubit::editUserModel:', error: e, stackTrace: s);
      emit(UserGetFailure());
      emit(stableState);
    }
  }
}
