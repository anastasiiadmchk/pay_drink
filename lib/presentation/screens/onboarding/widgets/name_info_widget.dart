import 'package:flutter/material.dart';
import 'package:pay_drink/core/notifiers/group_value_notifier.dart';
import 'package:pay_drink/presentation/components/widgets/custom_text_field.dart';
import 'package:pay_drink/presentation/components/widgets/question_sheet.dart';

class NameInfoWidget extends StatefulWidget {
  final Function(dynamic) onNextTap;
  final Function()? onBack;
  final dynamic userModel;
  final String sheetHeaderText;
  const NameInfoWidget({
    Key? key,
    required this.onNextTap,
    required this.onBack,
    required this.userModel,
    required this.sheetHeaderText,
  }) : super(key: key);

  @override
  State<NameInfoWidget> createState() => _NameInfoWidgetState();
}

class _NameInfoWidgetState extends State<NameInfoWidget> {
  late ValueNotifier<bool> _firstNameNotifier;

  late ValueNotifier<bool> _lastNameNotifier;

  late GroupValueNotifier _isNameNextButtonEnabled;

  final FocusNode _firstNameFocus = FocusNode();

  final FocusNode _middleNameFocus = FocusNode();

  final FocusNode _lastNameFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _middleNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  @override
  void initState() {
    _firstNameNotifier = ValueNotifier<bool>(false);
    _lastNameNotifier = ValueNotifier<bool>(false);

    _isNameNextButtonEnabled = GroupValueNotifier([
      _firstNameNotifier,
      _lastNameNotifier,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    _isNameNextButtonEnabled.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _firstNameFocus.dispose();
    _middleNameFocus.dispose();
    _lastNameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QuestionSheet(
      key: const ValueKey('name'),
      onNextTap: _onNameNextTap,
      onBack: widget.onBack,
      sheetHeaderText: widget.sheetHeaderText,
      questions: [
        CustomTextField(
          autofocus: false,
          title: 'First name',
          textCapitalization: TextCapitalization.words,
          controller: _firstNameController,
          isInputValid: _firstNameNotifier,
          onValidate: _validateName,
          textInputAction: TextInputAction.next,
          focusNode: _firstNameFocus,
          onSubmitted: (value) => _middleNameFocus.requestFocus(),
        ),
        CustomTextField(
          title: 'Middle name',
          autofocus: false,
          controller: _middleNameController,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          onSubmitted: (value) => _lastNameFocus.requestFocus(),
        ),
        CustomTextField(
          title: 'Last name',
          autofocus: false,
          textCapitalization: TextCapitalization.words,
          controller: _lastNameController,
          isInputValid: _lastNameNotifier,
          onValidate: _validateName,
          textInputAction: TextInputAction.done,
          focusNode: _lastNameFocus,
          onSubmitted: (value) {
            if (_firstNameController.text.isEmpty) {
              _firstNameFocus.requestFocus();
              return;
            }
          },
        ),
      ],
      isNextButtonEnabled: _isNameNextButtonEnabled.result,
    );
  }

  void _onNameNextTap() {
    widget.onNextTap(
      widget.userModel.copyWith(
        firstName: _firstNameController.text,
        middleName: _middleNameController.text,
        lastName: _lastNameController.text,
      ),
    );
  }

  bool _validateName(String value) {
    return value.isNotEmpty &&
        !RegExp(r'[^a-zA-Z-]').hasMatch(value) &&
        !RegExp(r'[0-9]').hasMatch(value);
  }
}
