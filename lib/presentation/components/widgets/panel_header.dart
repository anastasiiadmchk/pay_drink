import 'package:flutter/material.dart';
import 'package:pay_drink/core/utils/navigation.dart';
import 'package:pay_drink/theme/app_colors.dart';
import 'package:pay_drink/theme/text_styles.dart';

class PanelHeader extends StatelessWidget {
  const PanelHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.uiPaleGrey,
            offset: Offset(0, 1),
            spreadRadius: 2,
            blurRadius: 5,
          )
        ],
        color: Colors.white,
      ),
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 20,
            ),
            child: GestureDetector(
              onTap: () => NavigationUtil.popScreen(context: context),
              child: const Icon(
                Icons.close,
                color: AppColors.uiDarkGrey,
              ),
            ),
          ),
          Text(
            'Sol'.toUpperCase(),
            style: TextStyles.subheaderSectionTextStyle.copyWith(
              color: AppColors.uiBlackColor,
            ),
          ),
          const Visibility(
            maintainInteractivity: false,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: false,
            child: Padding(
              padding: EdgeInsetsDirectional.only(end: 20, top: 22),
              child: Icon(
                Icons.close,
                color: AppColors.uiDarkGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
