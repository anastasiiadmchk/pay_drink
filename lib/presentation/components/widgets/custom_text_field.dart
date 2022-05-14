import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pay_drink/theme/app_colors.dart';
import 'package:pay_drink/theme/text_styles.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    required this.title,
    this.isReadOnly = false,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.onTap,
    this.onChanged,
    this.focusNode,
    this.onValidate,
    this.controller,
    this.obscureText,
    this.onSubmitted,
    this.keyboardType,
    this.isInputValid,
    this.textInputAction,
    this.onClearText,
    this.isClearTextAvailable,
  }) : super(key: key);

  final String title;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final Function(String value)? onChanged;
  final TextEditingController? controller;
  final FutureOr<bool> Function(String value)? onValidate;
  final ValueNotifier<bool>? isInputValid;
  final bool isReadOnly;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final Function(String value)? onSubmitted;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final bool? isClearTextAvailable;
  final VoidCallback? onClearText;
  final bool autofocus;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _showPassword;
  @override
  void initState() {
    super.initState();
    _showPassword = !(widget.obscureText ?? false);
    widget.controller?.addListener(_onValidate);
    _onValidate();
  }

  Future<void> _onValidate() async {
    if (widget.onValidate != null && widget.isInputValid != null) {
      widget.isInputValid!.value =
          await widget.onValidate?.call(widget.controller!.text) ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onFieldTapped,
      child: Container(
        height: 48,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.uiPaleWarmGrey,
        ),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Row(
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      widget.title.toUpperCase(),
                      style: TextStyles.labelSmallRegularTextStyle
                          .copyWith(fontSize: 8),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: CupertinoTextField(
                      autofocus: widget.autofocus,
                      onTap: widget.onTap,
                      autocorrect: false,
                      textInputAction: widget.textInputAction,
                      textCapitalization: widget.textCapitalization,
                      onSubmitted: widget.onSubmitted,
                      readOnly: widget.isReadOnly,
                      controller: widget.controller,
                      onChanged: widget.onChanged,
                      focusNode: widget.focusNode,
                      decoration: const BoxDecoration(),
                      expands: false,
                      maxLines: 1,
                      padding: EdgeInsets.zero,
                      keyboardType: widget.keyboardType,
                      cursorColor: AppColors.uiDarkGrey,
                      obscureText: !_showPassword,
                      style: TextStyles.inputFieldTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.isClearTextAvailable ?? false)
              GestureDetector(
                onTap: _onClearTextTapped,
                child: const Icon(Icons.clear_outlined),
              ),
            if (widget.obscureText ?? false)
              GestureDetector(
                onTap: _onShowPasswordTapped,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8.0),
                  child: Icon(
                    _showPassword ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.uiDarkGrey,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  void _onFieldTapped() {
    if (widget.onTap == null && widget.focusNode != null) {
      FocusScope.of(context).unfocus();
      widget.focusNode?.requestFocus();
    } else {
      widget.onTap?.call();
    }
  }

  void _onShowPasswordTapped() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _onClearTextTapped() {
    widget.onClearText?.call();
  }
}
