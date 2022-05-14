import 'package:flutter/material.dart';
import 'package:pay_drink/presentation/components/widgets/custom_sign_in_button.dart';

import 'package:pay_drink/theme/app_colors.dart';
import 'package:pay_drink/theme/text_styles.dart';

class ContinueWithGoogleButton extends StatelessWidget {
  const ContinueWithGoogleButton({Key? key, required this.onPressed})
      : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomSignInButton(
      height: 48,
      onPressed: onPressed,
      borderColor: AppColors.uiLightGrey,
      iconAlignment: IconAlignment.left,
      style: CustomSignInButtonStyle.whiteOutlined,
      logo: const Padding(
        padding: EdgeInsets.only(
          left: 14,
          right: 14,
        ),
        child: Icon(
          Icons.g_mobiledata_rounded,
          size: 22,
        ),
      ),
      borderRadius: BorderRadius.circular(24),
      textStyle: TextStyles.bodyTitleTextStyle.copyWith(color: Colors.black54),
      text: 'Continue with google',
    );
  }
}
