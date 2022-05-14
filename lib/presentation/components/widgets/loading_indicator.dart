import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({
    Key? key,
    this.width = 3,
    this.isAlignCenter = true,
    this.color,
  }) : super(key: key);

  final double width;
  final Color? color;
  final bool isAlignCenter;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const CupertinoActivityIndicator();
    }
    final indicator = Platform.isIOS
        ? const CupertinoActivityIndicator()
        : CircularProgressIndicator(
            strokeWidth: width,
            color: color,
          );
    return isAlignCenter ? Center(child: indicator) : indicator;
  }
}
