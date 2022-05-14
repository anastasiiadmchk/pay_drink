import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pay_drink/core/utils/navigation.dart';
import 'package:pay_drink/domain/models/user/user_model.dart';
import 'package:pay_drink/presentation/components/widgets/custom_button.dart';
import 'package:pay_drink/presentation/components/widgets/custom_text_field.dart';
import 'package:pay_drink/presentation/components/widgets/question_sheet.dart';
import 'package:pay_drink/theme/constants.dart';

class BirthInfoWidget extends StatefulWidget {
  final Function(UserModel) onNextTap;
  final Function() onBack;
  final UserModel userModel;
  final String sheetHeaderText;
  final String? nextBtnTitle;

  const BirthInfoWidget({
    Key? key,
    required this.onNextTap,
    required this.onBack,
    required this.userModel,
    required this.sheetHeaderText,
    this.nextBtnTitle,
  }) : super(key: key);

  @override
  State<BirthInfoWidget> createState() => _BirthInfoWidgetState();
}

class _BirthInfoWidgetState extends State<BirthInfoWidget> {
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _birthPlaceController = TextEditingController();
  final TextEditingController _birthTimeController = TextEditingController();

  late final ValueNotifier<bool> _birthDateNotifier;

  DateTime _birthDate = DateTime.now();

  @override
  void initState() {
    _birthDateNotifier = ValueNotifier<bool>(false);

    super.initState();
  }

  @override
  void dispose() {
    _birthDateController.dispose();
    _birthTimeController.dispose();
    _birthPlaceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QuestionSheet(
      key: const ValueKey('birth'),
      onBack: widget.onBack,
      nextBtnTitle: widget.nextBtnTitle,
      onNextTap: _onBirthNextTap,
      sheetHeaderText: widget.sheetHeaderText,
      questions: [
        CustomTextField(
          title: 'Birth Date',
          isReadOnly: true,
          controller: _birthDateController,
          isInputValid: _birthDateNotifier,
          onTap: _buildCupertinoDatePicker,
          onValidate: (value) => value.trim().isNotEmpty,
        ),
      ],
      isNextButtonEnabled: _birthDateNotifier,
    );
  }

  void _onBirthNextTap() {
    widget.onNextTap(
      widget.userModel.copyWith(
        birthdate: _birthDate,
      ),
    );
  }

  Future<void> _buildCupertinoDatePicker() async {
    await showCupertinoModalPopup(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          color: Colors.white,
          child: Column(
            children: [
              Flexible(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (date) {
                    _birthDate = date;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
                child: CustomButton(
                  onPressed: _onConfirmDatePressed,
                  title: 'Confirm date',
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _onConfirmDatePressed() {
    _birthDateController.text =
        DateFormat(Constants.setBirthDateFormat).format(_birthDate);
    NavigationUtil.popScreen(context: context);
  }
}
