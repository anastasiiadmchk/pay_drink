import 'package:flutter/material.dart';
import 'package:pay_drink/presentation/components/widgets/custom_sign_in_button.dart';

import 'package:pay_drink/theme/app_colors.dart';
import 'package:pay_drink/theme/text_styles.dart';

class ContinueWithAppleButton extends StatelessWidget {
  const ContinueWithAppleButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomSignInButton(
      height: 48,
      onPressed: onPressed,
      iconAlignment: IconAlignment.left,
      color: Colors.black,
      logo: const Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 4,
        ),
        child: Icon(
          Icons.apple,
          size: 24,
          color: Colors.white,
        ),
      ),
      borderRadius: BorderRadius.circular(24),
      textStyle: TextStyles.bodyTitleTextStyle,
      text: 'Continue with apple',
    );
  }
}
