import 'package:flutter/material.dart';
import 'package:pay_drink/core/utils/navigation.dart';
import 'package:pay_drink/presentation/screens/qr/scanner_page.dart';
import 'package:pay_drink/theme/app_colors.dart';
import 'package:pay_drink/theme/text_styles.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
          _closeBtn(context),
          const Spacer(),
          Center(
            child: Text(
              'Thank you!',
              style: TextStyles.headingPrimaryTextStyle,
            ),
          ),
          const Spacer()
        ]));
  }

  Widget _closeBtn(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 20.15,
          top: 44.15,
          bottom: 44.15,
        ),
        child: GestureDetector(
          onTap: () => NavigationUtil.toScreenAndCleanBackstack(
              context: context, screen: const ScannerPage()),
          child: const Icon(
            Icons.close_rounded,
            color: AppColors.uiDarkGrey,
          ),
        ),
      ),
    );
  }
}
