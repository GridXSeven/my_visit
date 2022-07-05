import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:visits_prod/brains/navigation/custom_navigator.dart';
import 'package:visits_prod/ui_blocs/create_card/select_template_page.dart';

class CardFile extends StatefulWidget {
  const CardFile({required this.file, this.onTap, Key? key}) : super(key: key);

  final File file;
  final VoidCallback? onTap;

  @override
  State<CardFile> createState() => _CardFileState();
}

class _CardFileState extends State<CardFile> {
  double heightCoef = 3.5 / 2;

  PdfViewerController controller = PdfViewerController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
        print(1);
        if (controller.pageNumber == 1) {
          controller.jumpToPage(2);
        } else {
          controller.jumpToPage(1);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: heightCoef,
              child: IgnorePointer(
                ignoring: true,
                child: SfPdfViewer.file(
                  widget.file,
                  controller: controller,
                  onDocumentLoaded: (v) {
                    print(v.document.pages[0].size);
                    //Size(240.8, 141.8)
                    Size fileSize = v.document.pages[0].size;
                    heightCoef = fileSize.width / fileSize.height;
                    setState(() {});
                  },
                  pageLayoutMode: PdfPageLayoutMode.single,
                  canShowScrollHead: false,
                  pageSpacing: 0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardNetwork extends StatefulWidget {
  const CardNetwork({required this.url, this.onTap, Key? key})
      : super(key: key);

  final String url;
  final VoidCallback? onTap;

  @override
  State<CardNetwork> createState() => _CardNetworkState();
}

class _CardNetworkState extends State<CardNetwork> {
  double heightCoef = 3.5 / 2;

  File? file;

  @override
  void initState() {
    getFile();
    super.initState();
  }

  void getFile() async {
    final file = File(
        '${(await getTemporaryDirectory()).path}/${widget.url.substring(widget.url.lastIndexOf("/") + 1)}.pdf');
    var exists = await file.exists();
    print(
        '${(await getTemporaryDirectory()).path}/${widget.url.substring(widget.url.lastIndexOf("/") + 1)}.pdf');
    if (exists) {
      this.file = file;
    } else {
      this.file = await getFileNetwork();
    }
    setState(() {});
  }

  Future<File> getFileNetwork() async {
    final byteData = await http.get(Uri.parse(widget.url));

    var file = await saveFileToCache(byteData);

    return file;
  }

  Future<File> saveFileToCache(http.Response byteData) async {
    final file = File(
        '${(await getTemporaryDirectory()).path}/${widget.url.substring(widget.url.lastIndexOf("/") + 1)}.pdf');
    await file.writeAsBytes(byteData.bodyBytes);
    return file;
  }

  PdfViewerController controller = PdfViewerController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            widget.onTap?.call();
            print(1);
            if (controller.pageNumber == 1) {
              controller.jumpToPage(2);
            } else {
              controller.jumpToPage(1);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: heightCoef,
                  child: file != null
                      ? IgnorePointer(
                          ignoring: true,
                          child: SfPdfViewer.file(
                            file!,
                            controller: controller,
                            onDocumentLoaded: (v) {
                              print(v.document.pages[0].size);
                              //Size(240.8, 141.8)
                              Size fileSize = v.document.pages[0].size;
                              heightCoef = fileSize.width / fileSize.height;
                              print(fileSize.width);
                              print(fileSize.height);
                              setState(() {});
                            },
                            pageLayoutMode: PdfPageLayoutMode.single,
                            canShowScrollHead: false,
                            pageSpacing: 0,
                          ),
                        )
                      : Container(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CardEmptyCreate extends StatefulWidget {
  const CardEmptyCreate({Key? key}) : super(key: key);

  @override
  State<CardEmptyCreate> createState() => _CardEmptyCreateState();
}

class _CardEmptyCreateState extends State<CardEmptyCreate> {
  double heightCoef = 240.75 / 141.75;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            CustomNavigator.push(context, SelectTemplatePage());
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: heightCoef,
                  child: Container(
                    child: Center(
                      child: Icon(Icons.add),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
