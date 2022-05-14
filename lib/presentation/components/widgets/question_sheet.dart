import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pay_drink/presentation/components/widgets/custom_chip_button.dart';
import 'package:pay_drink/theme/text_styles.dart';

class QuestionSheet extends StatefulWidget {
  const QuestionSheet({
    Key? key,
    required this.onNextTap,
    required this.sheetHeaderText,
    required this.questions,
    this.isNextButtonEnabled,
    this.onSkip,
    this.onBack,
    this.nextBtnTitle,
  }) : super(key: key);

  final String sheetHeaderText;
  final String? nextBtnTitle;
  final VoidCallback? onNextTap;
  final List<Widget> questions;
  final ValueListenable<bool>? isNextButtonEnabled;

  final VoidCallback? onSkip;
  final VoidCallback? onBack;

  @override
  _QuestionSheetState createState() => _QuestionSheetState();
}

class _QuestionSheetState extends State<QuestionSheet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.03,
          left: 16,
          right: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.03,
              ),
              child: Text(
                widget.sheetHeaderText,
                style: TextStyles.headingPrimaryTextStyle
                    .copyWith(color: Colors.white),
              ),
            ),
            ...widget.questions,
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (widget.onSkip != null)
                    CupertinoButton(
                      onPressed: widget.onSkip,
                      child: Text(
                        'Skip',
                        style: TextStyles.uiButtonLargeLabel.copyWith(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  if (widget.onBack != null)
                    CupertinoButton(
                      onPressed: widget.onBack,
                      child: Text(
                        'Back',
                        style: TextStyles.uiButtonLargeLabel.copyWith(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  const Spacer(),
                  if (widget.isNextButtonEnabled != null)
                    CustomChipButton(
                      onPressed: widget.onNextTap,
                      title: widget.nextBtnTitle ?? 'Next',
                      isEnabledListenable: widget.isNextButtonEnabled!,
                    ),
                  if (widget.isNextButtonEnabled == null)
                    CustomChipButton(
                      onPressed: widget.onNextTap,
                      title: widget.nextBtnTitle ?? 'Next',
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
