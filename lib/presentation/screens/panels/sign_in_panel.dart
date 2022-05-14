import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pay_drink/core/notifiers/group_value_notifier.dart';
import 'package:pay_drink/core/utils/navigation.dart';
import 'package:pay_drink/domain/blocs/auth/auth_cubit.dart';
import 'package:pay_drink/domain/blocs/auth/auth_state.dart';
import 'package:pay_drink/presentation/components/widgets/custom_button.dart';
import 'package:pay_drink/presentation/components/widgets/custom_text_field.dart';
import 'package:pay_drink/presentation/screens/login/widgets/continue_with_apple_button.dart';
import 'package:pay_drink/presentation/screens/login/widgets/continue_with_google_button.dart';
import 'package:pay_drink/presentation/screens/panels/forgot_password_panel.dart';

import 'package:pay_drink/theme/app_colors.dart';
import 'package:pay_drink/theme/text_styles.dart';

class SignInPanel extends StatefulWidget {
  const SignInPanel({
    Key? key,
    required this.authCubit,
  }) : super(key: key);

  final AuthCubit authCubit;

  @override
  State<SignInPanel> createState() => _SignInPanelState();
}

class _SignInPanelState extends State<SignInPanel> {
  static const _fadeDuration = Duration(milliseconds: 250);

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  late final ValueNotifier<bool> _isEmailValid;
  late final ValueNotifier<bool> _isPasswordValid;
  late final GroupValueNotifier _isLoginButtonEnabled;

  // Required for getting proper focus on these fields.
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _isEmailValid = ValueNotifier<bool>(false);
    _isPasswordValid = ValueNotifier<bool>(false);
    _isLoginButtonEnabled =
        GroupValueNotifier([_isEmailValid, _isPasswordValid]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: widget.authCubit,
      builder: (context, state) {
        return GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: _buildSignIn(state, context),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _isLoginButtonEnabled.dispose();
    super.dispose();
  }

  Widget _buildSignIn(AuthState state, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(end: 18, top: 22),
            child: GestureDetector(
              onTap: () => NavigationUtil.popScreen(context: context),
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.uiDarkGrey,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsetsDirectional.only(
                  bottom: 10,
                  top: 16,
                ),
                alignment: AlignmentDirectional.topStart,
                child: DefaultTextStyle(
                  style: TextStyles.headingPrimaryTextStyle,
                  child: Row(
                    children: const [
                      Text('Sign In'),
                      SizedBox(width: 4),
                    ],
                  ),
                ),
              ),
              CustomTextField(
                title: 'Email',
                keyboardType: TextInputType.emailAddress,
                focusNode: _emailFocus,
                controller: _emailController,
                isInputValid: _isEmailValid,
                onValidate: (value) => (value.trim().isNotEmpty),
              ),
              CustomTextField(
                title: 'Password',
                obscureText: true,
                focusNode: _passwordFocus,
                controller: _passwordController,
                isInputValid: _isPasswordValid,
                onValidate: (value) => (value.trim().isNotEmpty),
              ),
              const SizedBox(height: 6),
              CustomButton(
                isEnabledListenable: _isLoginButtonEnabled.result,
                onPressed: () => _onSignInPressed(state),
                child: const Text(
                  'Sign in',
                  key: Key('sign_in_button'),
                ),
              ),
              SizedBox(
                height: 90,
                child: _buildForgotPassword(),
              ),
              Container(
                margin: const EdgeInsets.only(
                  bottom: 12,
                ),
                height: 16,
                child: Stack(
                  children: [
                    const Center(
                      child: Divider(
                        color: AppColors.uiLightGrey,
                        thickness: 1,
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(99),
                          color: AppColors.uiPaleGrey,
                        ),
                        child: Text(
                          'Or'.toUpperCase(),
                          style: TextStyles.labelSmallBold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              if (Platform.isIOS)
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 5),
                  child: ContinueWithAppleButton(
                    onPressed: () async {
                      NavigationUtil.popScreen(context: context);
                      await widget.authCubit.signInWithApple();
                    },
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ContinueWithGoogleButton(
                  onPressed: () async {
                    // NavigationUtil.popScreen(context: context);
                    await widget.authCubit.signInWithGoogle();
                  },
                ),
              ),
            ],
          ),
        ),
        // Container(
        //   alignment: Alignment.topCenter,
        //   decoration: const BoxDecoration(color: AppColors.uiPaleGrey),
        //   height: 64,
        //   margin: const EdgeInsets.only(top: 16),
        //   width: MediaQuery.of(context).size.width,
        //   padding: const EdgeInsets.only(top: 12),
        //   child: _buildFooter(state),
        // )
      ],
    );
  }

  Widget _buildWithFade({
    required Widget firstChild,
    required Widget secondChild,
  }) {
    return AnimatedSwitcher(
      duration: _fadeDuration,
      child: widget.authCubit.state.isSignIn ? firstChild : secondChild,
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.topCenter,
      child: CupertinoButton(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        onPressed: _onForgotPasswordPressed,
        child: Text(
          'Forgot my password',
          style: TextStyles.labelTextTextStyle.copyWith(
            color: AppColors.primaryBlueColor,
          ),
        ),
      ),
    );
  }

  void _onForgotPasswordPressed() {
    showModalBottomSheet(
      barrierColor: Colors.black38,
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Material(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            color: Colors.white,
            child: ForgotPasswordPanel(
              authCubit: widget.authCubit,
            ),
          ),
        );
      },
    );
  }

  // Widget _buildFooter(AuthState state) {
  //   return _buildWithFade(
  //     firstChild: RichText(
  //       key: const Key('sign_in_footer'),
  //       textAlign: TextAlign.center,
  //       text: TextSpan(
  //         children: [
  //           TextSpan(
  //             text: '${'auth_no_account'} ',
  //             style: TextStyles.cardBodyTextStyle
  //                 .copyWith(color: AppColors.uiBlackColor),
  //           ),
  //           TextSpan(
  //             text: 'auth_create_account',
  //             style: TextStyles.cardBodyTextStyle
  //                 .copyWith(color: AppColors.primaryBlueColor),
  //             recognizer: TapGestureRecognizer()
  //               ..onTap = widget.authCubit.switchSignUp,
  //           ),
  //         ],
  //       ),
  //     ),
  //     secondChild: RichText(
  //       key: const Key('sign_up_footer'),
  //       textAlign: TextAlign.center,
  //       text: TextSpan(
  //         children: [
  //           TextSpan(
  //             text: '${'auth_already_have'} ',
  //             style: TextStyles.cardBodyTextStyle
  //                 .copyWith(color: AppColors.uiBlackColor),
  //           ),
  //           TextSpan(
  //             text: 'Log in',
  //             style: TextStyles.cardBodyTextStyle
  //                 .copyWith(color: AppColors.primaryBlueColor),
  //             recognizer: TapGestureRecognizer()
  //               ..onTap = widget.authCubit.switchSignUp,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  void _onSignInPressed(AuthState state) {
    NavigationUtil.popScreen(context: context);

    if (state.isSignIn) {
      widget.authCubit.signInWithEmailPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } else {
      print('ff');
      // widget.authCubit.createWithEmailPassword(
      //   email: _emailController.text,
      //   password: _passwordController.text,
      // );
    }
  }

  void _onTermsOfServicePressed() {
    // launch(Constants.termsOfUse);
  }

  void _onPrivacyPolicyPressed() {
    // launch(Constants.privacyPolicy);
  }
}
