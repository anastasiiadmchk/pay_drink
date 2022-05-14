import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay_drink/core/utils/navigation.dart';
import 'package:pay_drink/core/utils/toast_notification_utils.dart';
import 'package:pay_drink/domain/blocs/auth/auth_cubit.dart';
import 'package:pay_drink/domain/blocs/auth/auth_state.dart';
import 'package:pay_drink/domain/blocs/onboarding/onboarding_cubit.dart';
import 'package:pay_drink/domain/blocs/onboarding/onboarding_state.dart';
import 'package:pay_drink/domain/blocs/user/user_cubit.dart';
import 'package:pay_drink/domain/models/user/user_model.dart';
import 'package:pay_drink/presentation/screens/home/home_screen.dart';
import 'package:pay_drink/presentation/screens/login/login_screen.dart';
import 'package:pay_drink/presentation/screens/login/widgets/update_overflow.dart';
import 'package:pay_drink/presentation/screens/onboarding/widgets/birth_info_widget.dart';
import 'package:pay_drink/presentation/screens/onboarding/widgets/name_info_widget.dart';
import 'package:rive/rive.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final OnboardingCubit _onboardingCubit;
  late final AuthCubit _authCubit;

  QuestionareeType questionareeType = QuestionareeType.name;

  // ignore: prefer_const_constructors
  UserModel userModel = UserModel();

  @override
  void initState() {
    super.initState();

    _onboardingCubit = BlocProvider.of<OnboardingCubit>(context);
    _authCubit = BlocProvider.of<AuthCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: BlocListener<AuthCubit, AuthState>(
          listener: _authListener,
          child: BlocConsumer<OnboardingCubit, OnboardingState>(
            listener: _onboardingListener,
            bloc: _onboardingCubit,
            builder: _buildBody,
          ),
        ),
      ),
    );
  }

  void _authListener(BuildContext context, AuthState authState) {
    if (authState is Unauthorized || authState is AuthFailure) {
      NavigationUtil.toScreenReplacement(
        context: context,
        screen: const LoginScreen(),
      );
    }
  }

  void _onboardingListener(BuildContext context, OnboardingState state) {
    if (state is UserCreationSuccess) {
      NavigationUtil.toScreenAndCleanBackstack(
        context: context,
        screen: const HomeScreen(),
      );
    }
    if (state is UserStateFailure) {
      ToastNotificationUtils.showToast(
        context,
        message: 'something_went_wrong',
        toastType: ToastType.error,
      );
    }
  }

  Widget _buildBody(BuildContext context, OnboardingState onboardingState) {
    late Widget Function(OnboardingState state) questionareeScreen;

    switch (onboardingState.questionareeScreen) {
      case QuestionareeType.name:
        questionareeScreen = ((state) => NameInfoWidget(
              onNextTap: _onNameNextTap,
              onBack: _signOut,
              userModel: userModel,
              sheetHeaderText: 'Input your name',
            ));
        break;
      case QuestionareeType.birth:
        questionareeScreen = (state) => BirthInfoWidget(
              onNextTap: _onBirthNextTap,
              onBack: () {
                _onboardingCubit
                    .changeQuestionareeScreen(QuestionareeType.name);
              },
              userModel: userModel,
              sheetHeaderText: '',
            );
        break;
    }
    // TODO: Fix keyboard behaviour when switching the modal screens.

    questionareeType = onboardingState.questionareeScreen;
    final isModalChanged =
        onboardingState.questionareeScreen != questionareeType;

    return UpdateOverflow(
      isUpdating: onboardingState.isCreatingUserLoad,
      child: Stack(
        children: [
          AnimatedSwitcher(
            duration: Duration(
              milliseconds: isModalChanged ? 500 : 0,
            ),
            child: questionareeScreen(onboardingState),
          ),
        ],
      ),
    );
  }

  void _onNameNextTap(userModelFromWidget) {
    userModel = userModelFromWidget;
    _onboardingCubit.changeQuestionareeScreen(QuestionareeType.birth);
  }

  Future<void> _signOut() async {
    await _authCubit.signOut();
    BlocProvider.of<UserCubit>(context).resetUserModel();
  }

  void _onBirthNextTap(
    userModelFromWidget,
  ) {
    userModel = userModelFromWidget;
    _onboardingCubit.createFirestoreUser(
      userModel: userModel,
    );
  }
}
