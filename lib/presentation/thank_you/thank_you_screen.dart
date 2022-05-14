import 'package:flutter/material.dart';
import 'package:pay_drink/theme/text_styles.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Thank you!',
          style: TextStyles.headingPrimaryTextStyle,
        ),
      ),
    );
  }
}
