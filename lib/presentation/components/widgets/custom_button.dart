import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:pay_drink/theme/app_colors.dart';
import 'package:pay_drink/theme/text_styles.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    required this.onPressed,
    Key? key,
    this.title,
    this.child,
    this.titleTextStyle,
    this.isEnabledListenable,
    this.width,
  })  : assert(child != null || title != null),
        super(key: key);

  final VoidCallback? onPressed;
  final String? title;
  final Widget? child;
  final TextStyle? titleTextStyle;
  final ValueListenable<bool>? isEnabledListenable;
  final double? width;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isEnabled = true;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.isEnabledListenable?.value ?? _isEnabled;
    widget.isEnabledListenable?.addListener(_listenisEnabledButton);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: 48,
      child: CupertinoButton(
        color: AppColors.primaryBlueColor,
        disabledColor: AppColors.primaryLightBlue,
        borderRadius: BorderRadius.circular(24),
        onPressed: _isEnabled ? widget.onPressed : null,
        child: DefaultTextStyle(
          style: widget.titleTextStyle ?? TextStyles.subheaderSectionTextStyle,
          child: widget.title != null
              ? Text(
                  widget.title!.toUpperCase(),
                )
              : widget.child!,
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
