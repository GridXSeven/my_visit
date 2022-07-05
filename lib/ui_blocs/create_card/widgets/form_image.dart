import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:visits_prod/brains/templates_brain.dart';
import 'package:visits_prod/components/buttons/custom_button.dart';

class GenImagePickerController {
  ValueNotifier<File?> selectedImage = ValueNotifier<File?>(null);
  FirebaseField data;
  GenImagePickerController({required this.data});

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      var file = File(result.files.single.path!);
      selectedImage.value = file;
    }
  }
}

class GenImagePicker extends StatelessWidget {
  const GenImagePicker({required this.controller, Key? key}) : super(key: key);

  final GenImagePickerController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.pickFile();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(controller.data.title),
          ),
          SizedBox(height: 8),
          if (controller.selectedImage != null)
            ValueListenableBuilder<File?>(
                valueListenable: controller.selectedImage,
                builder: (context, v, c) {
                  if (v != null) {
                    return Image.file(v);
                  }
                  return Container();
                }),
          CustomAddButton(
            onTap: () {
              controller.pickFile();
            },
          ),
        ],
      ),
    );
  }
}
