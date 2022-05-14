import 'package:flutter/material.dart';
import 'package:pay_drink/theme/app_colors.dart';

class CardWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool isLoading;
  const CardWidget({
    Key? key,
    required this.child,
    this.padding,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.uiPaleGrey, width: 1),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.1),
          )
        ],
        borderRadius: BorderRadius.circular(
          10,
        ),
        color: Colors.white,
      ),
      padding: padding ?? const EdgeInsets.all(16),
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Stack(
        children: [
          child,
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
        ],
      ),
    );
  }
}
