import 'package:flutter/material.dart';
import 'package:pay_drink/theme/app_colors.dart';

class BackButton extends StatelessWidget {
  const BackButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 20.15,
          top: 24.15,
          bottom: 23.43,
        ),
        child: GestureDetector(
          onTap: onTap,
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.uiDarkGrey,
          ),
        ),
      ),
    );
  }
}
