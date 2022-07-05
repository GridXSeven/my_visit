import 'package:flutter/material.dart';
import 'package:visits_prod/ui_utils/context_theme_extensions.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({this.controller, this.label, Key? key})
      : super(key: key);

  final TextEditingController? controller;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: context.theme.colorScheme.primary, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: context.theme.colorScheme.outline, width: 1.0),
        ),
      ),
    );
  }
}
