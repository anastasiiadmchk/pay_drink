import 'package:equatable/equatable.dart';
import 'package:pay_drink/domain/models/user/user_model.dart';

enum QuestionareeType {
  name,
  birth,
}

class OnboardingState extends Equatable {
  final bool isLoading;
  final bool isCreatingUserLoad;
  final UserModel? userModel;
  final QuestionareeType questionareeScreen;

  const OnboardingState({
    this.questionareeScreen = QuestionareeType.name,
    this.isLoading = false,
    this.isCreatingUserLoad = false,
    this.userModel,
  });

  OnboardingState copyWith({
    bool? isLoading,
    bool? isCreatingUserLoad,
    UserModel? userModel,
    QuestionareeType? questionareeScreen,
  }) {
    return OnboardingState(
      isLoading: isLoading ?? this.isLoading,
      isCreatingUserLoad: isCreatingUserLoad ?? this.isCreatingUserLoad,
      userModel: userModel ?? this.userModel,
      questionareeScreen: questionareeScreen ?? this.questionareeScreen,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        userModel,
        questionareeScreen,
        isCreatingUserLoad,
      ];
}

class UserStateFailure extends OnboardingState {
  final String? error;
  const UserStateFailure({
    this.error,
  });
}

class UserCreationSuccess extends OnboardingState {}
