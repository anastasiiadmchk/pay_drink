import 'package:flutter/material.dart';
import 'package:pay_drink/presentation/components/widgets/loading_indicator.dart';
import 'package:pay_drink/theme/app_colors.dart';

class UpdateOverflow extends StatefulWidget {
  final bool isUpdating;
  final Widget child;
  final Widget? topWidget;
  final BorderRadius? borderRadius;

  const UpdateOverflow({
    required this.isUpdating,
    required this.child,
    this.topWidget,
    this.borderRadius,
    Key? key,
  }) : super(key: key);

  @override
  _UpdateOverflowState createState() => _UpdateOverflowState();
}

class _UpdateOverflowState extends State<UpdateOverflow> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child,
        if (widget.isUpdating)
          ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.zero,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white.withOpacity(0.6),
              child: widget.topWidget == null
                  ? const Center(
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: CustomLoadingIndicator(
                          width: 3,
                          color: AppColors.uiDarkGrey,
                        ),
                      ),
                    )
                  : widget.topWidget ?? Container(),
            ),
          ),
      ],
    );
  }
}
