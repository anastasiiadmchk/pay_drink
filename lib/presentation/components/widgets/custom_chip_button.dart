import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pay_drink/theme/app_colors.dart';
import 'package:pay_drink/theme/text_styles.dart';

class CustomChipButton extends StatefulWidget {
  const CustomChipButton({
    Key? key,
    required this.onPressed,
    required this.title,
    this.isEnabledListenable,
    this.padding,
    this.borderColor,
    this.titleColor,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String title;
  final EdgeInsets? padding;
  final Color? borderColor;
  final Color? titleColor;

  final ValueListenable<bool>? isEnabledListenable;

  @override
  State<CustomChipButton> createState() => _CustomChipButtonState();
}

class _CustomChipButtonState extends State<CustomChipButton> {
  bool _isEnabled = true;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.isEnabledListenable?.value ?? _isEnabled;
    widget.isEnabledListenable?.addListener(_listenisEnabledButton);
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _isEnabled ? 1 : 0.5,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.borderColor ?? AppColors.primaryBlueColor,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: CupertinoButton(
          minSize: 0,
          padding: widget.padding ??
              const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          onPressed: _isEnabled ? widget.onPressed : null,
          child: Text(
            widget.title,
            style: TextStyles.uiButtonLargeLabel.copyWith(
              color: widget.titleColor ?? AppColors.primaryBlueColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.isEnabledListenable?.removeListener(_listenisEnabledButton);
    super.dispose();
  }

  void _listenisEnabledButton() {
    setState(() {
      _isEnabled = widget.isEnabledListenable!.value;
    });
  }
}
