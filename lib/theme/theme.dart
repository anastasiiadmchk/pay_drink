import 'package:flutter/material.dart';
import 'package:pay_drink/theme/app_colors.dart';
import 'package:pay_drink/theme/text_styles.dart';

class VendBmrTheme {
  static ThemeData mainTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColors.milkWhite,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryBlueColor,
      elevation: 0,
    ),
    primaryColorLight: AppColors.primaryBlueColor,
    textTheme: TextTheme(headline1: TextStyles.headingPrimaryTextStyle),
    primaryColor: AppColors.primaryBlueColor,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.grey),
  );
}
