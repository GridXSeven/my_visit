import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:visits_prod/brains/templates_brain.dart';
import 'package:visits_prod/components/buttons/custom_button.dart';
import 'package:visits_prod/components/cards/cards.dart';
import 'package:visits_prod/components/scaffolds/custom_scaffold.dart';
import 'package:visits_prod/ui_blocs/create_card/providers/create_card_brain.dart';
import 'package:visits_prod/ui_blocs/create_card/widgets/form_field.dart';
import 'package:visits_prod/ui_blocs/create_card/widgets/form_image.dart';

class CreateCardPage extends StatelessWidget {
  const CreateCardPage({required this.template, Key? key}) : super(key: key);

  final Template template;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (c) => CreateCardBrain(template),
      child: Consumer<CreateCardBrain>(
          builder: (context, CreateCardBrain brain, child) {
        return CustomScaffold(
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (brain.previewFile != null)
                        CardFile(file: brain.previewFile!),
                      ...List.generate(brain.controllers.length, (i) {
                        var controller = brain
                            .controllers[brain.controllers.keys.toList()[i]];
                        if (controller is GenTextPickerController) {
                          return GenTextField(
                            controller: controller,
                          );
                        } else if (controller is GenImagePickerController) {
                          return GenImagePicker(
                            controller: controller,
                          );
                        }
                        return Container();
                      }),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              SizedBox(
                height: 16,
              ),
              CustomButton(
                text: "preview",
                onTap: () async {
                  await brain.updatePdf();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => PreviewPage(
                        file: brain.previewFile!,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 16,
              ),
              CustomButton(
                text: "Confirm",
                onTap: () async {
                  await brain.create();
                  Navigator.pop(context);
                  print("confirm");
                },
              ),
              SizedBox(
                height: 32,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class PreviewPage extends StatelessWidget {
  const PreviewPage({required this.file, Key? key}) : super(key: key);

  final File file;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SfPdfViewer.file(file),
    );
  }
}
