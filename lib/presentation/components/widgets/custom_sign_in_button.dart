import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSignInButton extends StatelessWidget {
  const CustomSignInButton({
    Key? key,
    required this.onPressed,
    this.text = '',
    this.style = CustomSignInButtonStyle.black,
    this.height = 44,
    this.logo,
    this.color,
    this.borderColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.iconAlignment = IconAlignment.center,
    this.textStyle,
  }) : super(key: key);

  final VoidCallback onPressed;

  final String text;

  final CustomSignInButtonStyle style;

  final double height;

  final Widget? logo;

  final Color? color;
  final Color? borderColor;

  final TextStyle? textStyle;

  final BorderRadius borderRadius;

  final IconAlignment iconAlignment;

  Decoration? get _decoration {
    switch (style) {
      case CustomSignInButtonStyle.black:
      case CustomSignInButtonStyle.white:
        return null;

      case CustomSignInButtonStyle.whiteOutlined:
        return BoxDecoration(
          border: Border.all(
            width: 2,
            color: borderColor ?? textStyle?.color ?? Colors.white,
          ),
          borderRadius: borderRadius,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      textAlign: TextAlign.center,
      style: textStyle,
    );

    final logoIcon = Center(
      child: SizedBox(
        child: logo,
      ),
    );

    var children = <Widget>[];

    switch (iconAlignment) {
      case IconAlignment.center:
        children = [
          logoIcon,
          Flexible(
            child: textWidget,
          ),
        ];
        break;
      case IconAlignment.left:
        children = [
          logoIcon,
          Expanded(
            child: textWidget,
          ),
          Opacity(
            opacity: 0,
            child: logoIcon,
          )
        ];
        break;
    }

    return SizedBox(
      height: height,
      child: SizedBox.expand(
        child: CupertinoButton(
          borderRadius: borderRadius,
          padding: EdgeInsets.zero,
          color: color,
          onPressed: onPressed,
          child: Container(
            decoration: _decoration,
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

enum IconAlignment {
  center,

  left,
}

enum CustomSignInButtonStyle {
  black,

  white,

  whiteOutlined,
}
