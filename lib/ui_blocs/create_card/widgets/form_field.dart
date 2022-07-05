import 'package:flutter/material.dart';
import 'package:visits_prod/brains/templates_brain.dart';
import 'package:visits_prod/components/fields/custom_text_field.dart';

class GenTextPickerController {
  TextEditingController controller = TextEditingController();

  FirebaseField data;
  GenTextPickerController({required this.data});
}

class GenTextField extends StatelessWidget {
  const GenTextField({required this.controller, Key? key}) : super(key: key);

  final GenTextPickerController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: CustomTextField(
        controller: controller.controller,
        label: controller.data.title,
      ),
    );
  }
}
