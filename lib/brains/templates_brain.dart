import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:visits_prod/brains/data_layer/firebase_repo.dart';

enum FieldType { string, image, phone, email, url }

extension FieldTypeX on FieldType {
  static FieldType? getType(String value) {
    switch (value) {
      case "string":
        return FieldType.string;
      case "image":
        return FieldType.image;
      case "phone":
        return FieldType.phone;
      case "email":
        return FieldType.email;
      case "url":
        return FieldType.url;
    }
    return null;
  }
}

class TemplatesBrain extends ChangeNotifier {
  List<Template> templates = [];

  void init() async {
    templates = await FirebaseRepo.getAllTemplates();
    notifyListeners();
    print(templates);
  }
}

class Template {
  final String id;
  final String url;
  File? preview;
  final List<FirebaseField> fields;

  Template({
    required this.id,
    required this.url,
    required this.fields,
    this.preview,
  });

  factory Template.fromMap(Map data, String id) {
    return Template(
      id: id,
      url: data["path"],
      fields: fieldsFromList(
          data["fields"] is List ? data["fields"] : data["fields"]["fields"]),
    );
  }
  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);

    final file = File('${(await getTemporaryDirectory()).path}/logo.png');
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

  Future<File> updatePreview() async {
    var file = File(
        '${(await getTemporaryDirectory()).path}/${url.substring(url.lastIndexOf("/") + 1)}.pdf');
    if (!(await file.exists())) {
      file = await getImageFileFromNetwork(
          url, url.substring(url.lastIndexOf("/") + 1));
    }
    final PdfDocument document =
        PdfDocument(inputBytes: await file.readAsBytes());

    final PdfForm form = document.form;

    document.form.setDefaultAppearance(true);
    for (var item in fields) {
      if (item.type == FieldType.image) {
        var page = document.pages[item.page!];
        page.graphics.drawImage(
            PdfBitmap((await getImageFileFromAssets("assets/logo.png"))
                .readAsBytesSync()),
            Rect.fromLTWH(item.l!, item.t!, item.w!, item.h!));
      } else {
        print(1213);
        print(item.index!);
        final PdfTextBoxField name =
            document.form.fields[item.index!] as PdfTextBoxField;
        // name.font = PdfStandardFont(PdfFontFamily.courier, 12);
        name.text = item.title;
      }
    }
    if (true) {
      form.flattenAllFields();
    }
    final List<int> bytes = document.save();
    document.dispose();
    final file2 = File('${(await getTemporaryDirectory()).path}/file.pdf');
    await file2.writeAsBytes(bytes);
    preview = file2;
    return file2;
  }
}

class FirebaseField {
  final FieldType type;
  final String title;
  final String? code;
  final int? index;
  final int? page;
  final double? t;
  final double? l;
  final double? w;
  final double? h;

  FirebaseField({
    required this.title,
    required this.index,
    required this.code,
    required this.type,
    required this.l,
    required this.t,
    required this.w,
    required this.h,
    required this.page,
  });

  factory FirebaseField.fromMap(Map data) {
    print(data);
    return FirebaseField(
      title: data["title"],
      type: FieldTypeX.getType(data["type"]) ?? FieldType.string,
      index: data["index"],
      code: data["code"],
      page: data["page"],
      t: toType<double>(data["t"]),
      l: toType<double>(data["l"]),
      w: toType<double>(data["w"]),
      h: toType<double>(data["h"]),
    );
  }
}

T? toType<T>(dynamic value) {
  try {
    if (T == double) {
      value = value / 1;
    }
    return value as T;
  } catch (e) {
    return null;
  }
}

List<FirebaseField> fieldsFromList(List data) {
  List<FirebaseField> items = [];
  for (var item in data) {
    items.add(FirebaseField.fromMap(item));
  }
  return items;
}
