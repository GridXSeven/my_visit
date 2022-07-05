import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:visits_prod/brains/templates_brain.dart';
import 'package:visits_prod/ui_blocs/create_card/widgets/form_field.dart';
import 'package:visits_prod/ui_blocs/create_card/widgets/form_image.dart';

class CreateCardBrain extends ChangeNotifier {
  CreateCardBrain(this.template) {
    initCard();
    initFields();
  }
  File? initFile;
  File? previewFile;

  Map controllers = {};
  final Template template;

  ///
  void initCard() async {
    initFile = await getImageFileFromNetwork(template.url, "init");
    previewFile = await initFile
        ?.copy("${(await getTemporaryDirectory()).path}/preview.pdf");
    notifyListeners();
  }

  void initFields() {
    Map newControllers = {};

    for (var field in template.fields) {
      if (field.type == FieldType.image) {
        newControllers[field.code] = GenImagePickerController(data: field);
      } else if (field.type == FieldType.string ||
          field.type == FieldType.phone ||
          field.type == FieldType.email) {
        newControllers[field.code] = GenTextPickerController(data: field);
      }
    }

    controllers = newControllers;
    notifyListeners();
  }

  Future<void> updatePdf() async {
    final PdfDocument document =
        PdfDocument(inputBytes: await initFile!.readAsBytes());

    final PdfForm form = document.form;

    print(form.fields);
    print(form.fields.count);

    document.form.setDefaultAppearance(true);
    for (var item in controllers.values) {
      print(11);
      if (item is GenTextPickerController) {
        print(1213);
        print(item.data.index!);
        final PdfTextBoxField name =
            document.form.fields[item.data.index!] as PdfTextBoxField;
        // name.font = PdfStandardFont(PdfFontFamily.courier, 12);
        name.text = item.controller.text;
      } else if (item is GenImagePickerController) {
        if (item.selectedImage != null) {
          var page = document.pages[item.data.page!];
          page.graphics.drawImage(
              PdfBitmap(item.selectedImage.value!.readAsBytesSync()),
              Rect.fromLTWH(
                  item.data.l!, item.data.t!, item.data.w!, item.data.h!));
        }
      }
    }
    if (true) {
      form.flattenAllFields();
    }

    final List<int> bytes = document.save();
    document.dispose();
    final file = File('${(await getTemporaryDirectory()).path}/file.pdf');
    await file.writeAsBytes(bytes);
    previewFile = file;
    notifyListeners();
  }

  Future<void> create() async {
    await updatePdf();

    File file = previewFile!;
    List<Map> defFields = [];
    List<Map> customFields = [];
    String templateId = template.id;

    for (var item in controllers.values) {
      if (item is GenTextPickerController) {
        defFields.add({
          item.data.code: item.controller.text,
        });
      }
    }
    //todo here

    // await context.read<CardsBrain>().createCard(
    //       file: file,
    //       defFields: defFields,
    //       customFields: customFields,
    //       templateId: templateId,
    //     );
  }

  ///
  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);

    final file = File('${(await getTemporaryDirectory()).path}/file.pdf');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<File> getImageFileFromNetwork(String url, String fileName) async {
    final byteData = await http.get(
      Uri.parse(url),
    );

    final file = File('${(await getTemporaryDirectory()).path}/$fileName.pdf');
    await file.writeAsBytes(byteData.bodyBytes);

    return file;
  }
}
