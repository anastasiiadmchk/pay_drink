import 'package:flutter/material.dart';
import 'package:pay_drink/core/utils/navigation.dart';
import 'package:pay_drink/theme/app_colors.dart';

class CustomCloseButton extends StatelessWidget {
  final Alignment? alignment;
  final Color? color;
  final double? bottomIndent;
  final double? topIndent;
  const CustomCloseButton({
    Key? key,
    this.alignment,
    this.color,
    this.bottomIndent,
    this.topIndent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.topLeft,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: 20.15,
          top: topIndent ?? 24.15,
          bottom: bottomIndent ?? 24.15,
          end: 20.15,
        ),
        child: GestureDetector(
          onTap: () => NavigationUtil.popScreen(context: context),
          child: Icon(
            Icons.close,
            color: color ?? AppColors.uiDarkGrey,
          ),
        ),
      ),
    );
  }
}
