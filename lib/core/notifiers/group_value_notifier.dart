import 'package:flutter/cupertino.dart';

class GroupValueNotifier {
  final List<ValueNotifier<bool>> isValidValuesList;
  late final ValueNotifier<bool> result;

  GroupValueNotifier(this.isValidValuesList) {
    _create();
  }

  void _create() {
    result = ValueNotifier(isValidValuesList.every((isValid) => isValid.value));
    for (final isValid in isValidValuesList) {
      isValid.addListener(_onIsValidChanged);
    }
  }

  void _onIsValidChanged() {
    if (isValidValuesList.any((isValid) => !isValid.value)) {
      result.value = false;
    } else {
      result.value = true;
    }
  }

  void dispose() {
    for (final element in isValidValuesList) {
      element.dispose();
    }
    result.dispose();
  }
}
