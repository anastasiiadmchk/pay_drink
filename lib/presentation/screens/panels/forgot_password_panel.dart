import 'package:flutter/material.dart';

import 'package:pay_drink/core/utils/navigation.dart';
import 'package:pay_drink/domain/blocs/auth/auth_cubit.dart';
import 'package:pay_drink/presentation/components/widgets/custom_button.dart';
import 'package:pay_drink/presentation/components/widgets/custom_text_field.dart';
import 'package:pay_drink/theme/app_colors.dart';
import 'package:pay_drink/theme/text_styles.dart';

class ForgotPasswordPanel extends StatefulWidget {
  const ForgotPasswordPanel({
    Key? key,
    required this.authCubit,
  }) : super(key: key);

  final AuthCubit authCubit;

  @override
  _ForgotPasswordPanelState createState() => _ForgotPasswordPanelState();
}

class _ForgotPasswordPanelState extends State<ForgotPasswordPanel> {
  final _emailController = TextEditingController();
  late final ValueNotifier<bool> _isEmailValid;
  final FocusNode _emailFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _isEmailValid = ValueNotifier(false);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 18, top: 22),
                child: GestureDetector(
                  onTap: () => NavigationUtil.popScreen(context: context),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.uiDarkGrey,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      bottom: 10,
                      top: 16,
                    ),
                    child: Text(
                      'Forgot password',
                      style: TextStyles.headingPrimaryTextStyle,
                    ),
                  ),
                  Text(
                    'Password',
                    style: TextStyles.labelTextTextStyle.copyWith(),
                    textAlign: TextAlign.center,
                  ),
                  CustomTextField(
                    title: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    focusNode: _emailFocus,
                    isInputValid: _isEmailValid,
                    controller: _emailController,
                    onValidate: (value) => (value.trim().isNotEmpty),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    width: MediaQuery.of(context).size.width,
                    child: CustomButton(
                      isEnabledListenable: _isEmailValid,
                      onPressed: () => widget.authCubit.requestResetPassword(
                        email: _emailController.text,
                      ),
                      title: 'Reset_password',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
