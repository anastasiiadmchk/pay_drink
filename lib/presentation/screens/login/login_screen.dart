import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pay_drink/core/utils/navigation.dart';
import 'package:pay_drink/core/utils/toast_notification_utils.dart';
import 'package:pay_drink/domain/blocs/auth/auth_cubit.dart';
import 'package:pay_drink/domain/blocs/auth/auth_state.dart';
import 'package:pay_drink/presentation/components/wrappers/screen.dart';
import 'package:pay_drink/presentation/screens/home/home_screen.dart';
import 'package:pay_drink/presentation/screens/login/widgets/continue_with_google_button.dart';
import 'package:pay_drink/presentation/screens/login/widgets/update_overflow.dart';
import 'package:pay_drink/presentation/screens/panels/sign_in_panel.dart';

class LoginScreen extends Screen {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthCubit bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<AuthCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<AuthCubit, AuthState>(
        bloc: bloc,
        listener: _stateChangeHandler,
        builder: _buildBody,
      ),
    );
  }

  Widget _buildBody(BuildContext context, AuthState state) {
    return UpdateOverflow(
      isUpdating: state.isLoading,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              "assets/start_loading.gif",
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(
          //     left: MediaQuery.of(context).size.width * 0.1,
          //     right: MediaQuery.of(context).size.width * 0.1,
          //     bottom: MediaQuery.of(context).size.height * 0.01,
          //   ),
          //   child:
          //       // Platform.isIOS
          //       //     ? ContinueWithAppleButton(
          //       //         onPressed: bloc.signInWithApple,
          //       //       )
          //       // :
          //       ContinueWithGoogleButton(
          //     onPressed: bloc.signInWithGoogle,
          //   ),
          // ),
          SignInPanel(authCubit: bloc),
          const Spacer(),
          // TextButton(
          //   onPressed: () => _onMoreOptionsPressed(state),
          //   child: Text(
          //     'More options',
          //     style: TextStyles.bodyTextTextStyle
          //         .copyWith(color: AppColors.primaryBlueColor),
          //   ),
          // ),
        ],
      ),
    );
  }

  void _onMoreOptionsPressed(AuthState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black38,
      isScrollControlled: true,
      builder: (context) {
        return UpdateOverflow(
          isUpdating: state.isLoading,
          child: Wrap(
            children: [
              Material(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                color: Colors.white,
                child: SignInPanel(authCubit: bloc),
              ),
            ],
          ),
        );
      },
    );
  }

  void _stateChangeHandler(
    BuildContext context,
    AuthState state,
  ) {
    if (state is AuthSuccess) {
      NavigationUtil.toScreenAndCleanBackstack(
        context: context,
        screen: const HomeScreen(),
      );
    }
    _buildErrorToasts(state, context);
  }

  void _buildErrorToasts(
    AuthState state,
    BuildContext context,
  ) {
    if (state is InvalidEmailAuthFailure) {
      ToastNotificationUtils.showToast(
        context,
        message: 'Invalid email',
        toastType: ToastType.error,
      );
    }
    if (state is EmailAlreadyInUseFailure) {
      ToastNotificationUtils.showToast(
        context,
        message: 'Error - email in use',
        toastType: ToastType.error,
      );
    }
    if (state is UserDisabledFailure) {
      ToastNotificationUtils.showToast(
        context,
        message: 'Error user disabled',
        toastType: ToastType.error,
      );
    }
    if (state is WeakPasswordFailure) {
      ToastNotificationUtils.showToast(
        context,
        message: 'Error weak password',
        toastType: ToastType.error,
      );
    }
    if (state is UserNotFoundFailure) {
      ToastNotificationUtils.showToast(
        context,
        message: 'Error user not found',
        toastType: ToastType.error,
      );
    }
    if (state is WrongPasswordFailure) {
      ToastNotificationUtils.showToast(
        context,
        message: 'Error wrong password',
        toastType: ToastType.error,
      );
    }

    if (state is PasswordResetRequested) {
      ToastNotificationUtils.showToast(
        context,
        message: 'Auth check inbox',
        toastType: ToastType.info,
      );
    }

    if (state is DifferentCredentialFailure) {
      ToastNotificationUtils.showToast(
        context,
        message: 'Error different credential',
        toastType: ToastType.error,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
