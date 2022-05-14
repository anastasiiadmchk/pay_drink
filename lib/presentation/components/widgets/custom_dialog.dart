import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pay_drink/core/utils/navigation.dart';
import 'package:pay_drink/presentation/components/widgets/custom_chip_button.dart';
import 'package:pay_drink/theme/app_colors.dart';
import 'package:pay_drink/theme/text_styles.dart';

class CustomDialog extends StatelessWidget {
  final String dialogRequestMessage;
  final String confirmButtonTitle;
  final Function() onConfirmPressed;
  const CustomDialog({
    Key? key,
    required this.dialogRequestMessage,
    required this.confirmButtonTitle,
    required this.onConfirmPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 266,
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dialogRequestMessage,
                textAlign: TextAlign.center,
                style: TextStyles.labelTextTextStyle.copyWith(
                  color: AppColors.uiDarkGrey,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 100,
                    child: CustomChipButton(
                      onPressed: () {
                        NavigationUtil.popScreen(context: context);
                      },
                      title: 'Cancel',
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: CupertinoButton(
                      minSize: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      color: AppColors.primaryBlueColor,
                      borderRadius: BorderRadius.circular(24),
                      onPressed: onConfirmPressed,
                      child: Text(
                        confirmButtonTitle,
                        style: TextStyles.uiButtonLargeLabel
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
