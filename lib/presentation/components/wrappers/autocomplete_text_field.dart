import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class AutocompleteTextField extends StatefulWidget {
  const AutocompleteTextField({
    required this.textFieldBuilder,
    required this.onValue,
    this.validator,
    this.debounceDuration = const Duration(milliseconds: 600),
    this.controller,
    Key? key,
  }) : super(key: key);

  final Widget Function(TextEditingController controller) textFieldBuilder;
  final Function(String value) onValue;
  final bool Function(String value)? validator;
  final TextEditingController? controller;
  final Duration debounceDuration;

  @override
  State<AutocompleteTextField> createState() => _AutocompleteTextFieldState();
}

class _AutocompleteTextFieldState extends State<AutocompleteTextField> {
  final autocompleteSubject = PublishSubject<String>();

  late final TextEditingController controller;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();

    controller.addListener(() {
      autocompleteSubject.add(controller.text);
    });

    autocompleteSubject.stream
        .debounceTime(widget.debounceDuration)
        .where(widget.validator ?? (value) => value.isNotEmpty)
        .distinct()
        .listen(widget.onValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.textFieldBuilder(controller);
  }
}
