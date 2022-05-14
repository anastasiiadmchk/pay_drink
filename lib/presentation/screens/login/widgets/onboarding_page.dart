import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    Key? key,
    required this.topWidget,
    required this.bottomText,
  }) : super(key: key);

  final Widget topWidget;
  final String bottomText;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 9,
          child: topWidget,
        ),
        Flexible(
          flex: 4,
          child: Padding(
            padding: EdgeInsets.only(
              left: screenWidth * 0.07,
              right: screenWidth * 0.07,
              top: 24,
            ),
            child: SizedBox(
              height: screenHeight * 0.11,
              child: Text(
                bottomText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
