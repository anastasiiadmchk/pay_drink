import 'dart:io';

import 'package:flutter/material.dart';
import './app_colors.dart';
import './constants.dart';

class TextStyles {
  static TextStyle get bodyTitleTextStyle {
    if (Platform.isIOS) {
      return const TextStyle(
        fontFamily: Constants.sfProDisplayFont,
        fontSize: 16,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w600,
      );
    }
    return const TextStyle(
      fontFamily: Constants.robotoFont,
      fontSize: 16,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle get bodyTextTextStyle {
    if (Platform.isIOS) {
      return const TextStyle(
        fontFamily: Constants.sfCompactTextFont,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );
    }
    return const TextStyle(
      fontFamily: Constants.robotoFont,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle get headingPrimaryTextStyle {
    if (Platform.isIOS) {
      return const TextStyle(
        fontFamily: Constants.sfProDisplayFont,
        fontSize: 36,
        fontWeight: FontWeight.w100,
        color: AppColors.uiBlackColor,
      );
    }
    return const TextStyle(
      fontFamily: Constants.robotoFont,
      fontSize: 36,
      fontWeight: FontWeight.w100,
      color: AppColors.uiBlackColor,
    );
  }

  static TextStyle get uiButtonLargeLabel {
    if (Platform.isIOS) {
      return const TextStyle(
        fontFamily: Constants.sfProFont,
        fontWeight: FontWeight.w700,
        fontSize: 12,
        letterSpacing: -0.5,
        color: AppColors.primaryBlueColor,
      );
    }
    return const TextStyle(
      fontFamily: Constants.robotoFont,
      fontWeight: FontWeight.w700,
      fontSize: 12,
      color: AppColors.primaryBlueColor,
    );
  }

  static TextStyle get labelSmallRegularTextStyle {
    if (Platform.isIOS) {
      return const TextStyle(
        fontFamily: Constants.sfMonoFont,
        color: AppColors.uiDarkGrey,
        fontSize: 10,
      );
    }
    return const TextStyle(
      fontFamily: Constants.robotoMonoFont,
      color: AppColors.uiDarkGrey,
      fontSize: 10,
    );
  }

  static TextStyle get inputFieldTextStyle {
    if (Platform.isIOS) {
      return const TextStyle(
        fontFamily: Constants.sfCompactTextFont,
        fontSize: 14,
        letterSpacing: 0.3,
        color: AppColors.uiBlackColor,
      );
    }
    return const TextStyle(
      fontFamily: Constants.robotoFont,
      fontSize: 14,
      letterSpacing: 0.3,
      color: AppColors.uiBlackColor,
    );
  }

  static TextStyle get subheaderSectionTextStyle {
    if (Platform.isIOS) {
      return const TextStyle(
        fontFamily: Constants.sfProDisplayFont,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
        color: Colors.white,
      );
    }
    return const TextStyle(
      fontFamily: Constants.robotoFont,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      letterSpacing: 1,
      color: Colors.white,
    );
  }

  static TextStyle get labelTextTextStyle {
    if (Platform.isIOS) {
      return const TextStyle(
        fontFamily: Constants.sfProDisplayFont,
        fontSize: 16,
        letterSpacing: 0.3,
        height: 1.6,
        color: AppColors.uiBlackColor,
      );
    }
    return const TextStyle(
      fontFamily: Constants.robotoFont,
      fontSize: 16,
      letterSpacing: 0.3,
      height: 1.6,
      color: AppColors.uiBlackColor,
    );
  }

  static TextStyle get labelSmallBold {
    if (Platform.isIOS) {
      return const TextStyle(
        fontFamily: Constants.sfProTextFont,
        fontWeight: FontWeight.w600,
        color: AppColors.uiBlackColor,
        fontSize: 10,
      );
    }
    return const TextStyle(
      fontFamily: Constants.robotoFont,
      fontWeight: FontWeight.w600,
      color: AppColors.uiBlackColor,
      fontSize: 10,
    );
  }

  static TextStyle get cardHeadingTextStyle {
    if (Platform.isIOS) {
      return const TextStyle(
        fontFamily: Constants.sfMonoFont,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        letterSpacing: 0.5,
        height: 1.6,
      );
    }
    return const TextStyle(
      fontFamily: Constants.robotoMonoFont,
      fontSize: 14,
      letterSpacing: 0.5,
      height: 1.6,
    );
  }

  static TextStyle get cardBodyTextStyle {
    if (Platform.isIOS) {
      return const TextStyle(
        fontFamily: Constants.sfCompactTextFont,
        fontSize: 16,
      );
    }
    return const TextStyle(
      fontFamily: Constants.robotoFont,
      fontSize: 16,
    );
  }

  static TextStyle get bnbTextStyle {
    if (Platform.isIOS) {
      return const TextStyle(
        fontFamily: Constants.sfCompactTextFont,
        fontWeight: FontWeight.w700,
        color: AppColors.uiLightGrey,
      );
    }
    return const TextStyle(
      fontFamily: Constants.robotoFont,
      fontWeight: FontWeight.w700,
      color: AppColors.uiLightGrey,
    );
  }
}
