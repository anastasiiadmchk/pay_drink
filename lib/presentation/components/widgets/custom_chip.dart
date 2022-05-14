import 'package:flutter/material.dart';
import 'package:pay_drink/theme/text_styles.dart';

class CustomChip extends StatelessWidget {
  const CustomChip({
    Key? key,
    required this.onPressed,
    required this.title,
    required this.isSelected,
    this.borderColor,
    this.textColor,
    this.borderWidth,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String title;
  final bool isSelected;
  final Color? borderColor;
  final Color? textColor;
  final double? borderWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              width: borderWidth ?? 2,
              color: borderColor ?? Colors.white,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        child: Text(
          title,
          style: TextStyles.uiButtonLargeLabel.copyWith(
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
