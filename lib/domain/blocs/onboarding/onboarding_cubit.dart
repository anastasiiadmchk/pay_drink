import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay_drink/core/utils/log.dart';
import 'package:pay_drink/domain/blocs/onboarding/onboarding_state.dart';
import 'package:pay_drink/domain/models/user/user_model.dart';
import 'package:pay_drink/domain/repositories/user_repo.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({
    required UserRepo userRepo,
  }) : super(const OnboardingState()) {
    _userRepo = userRepo;
  }
  late final UserRepo _userRepo;

  Future<void> createFirestoreUser({
    required UserModel userModel,
  }) async {
    final stableState = state;
    try {
      emit(state.copyWith(isCreatingUserLoad: true));

      await _userRepo.createFirestoreUser(userModel: userModel);

      emit(UserCreationSuccess());
    } catch (e, s) {
      logError('OnboardingCubit::createFirebaseUser:', error: e, stackTrace: s);
      emit(stableState);
    }
  }

  void changeQuestionareeScreen(QuestionareeType questionareeScreen) {
    final stableState = state;
    try {
      emit(state.copyWith(questionareeScreen: questionareeScreen));
    } catch (e, s) {
      logError(
        'OnboardingCubit::changeQuestionareeScreen:',
        error: e,
        stackTrace: s,
      );
      emit(stableState);
    }
  }
}
