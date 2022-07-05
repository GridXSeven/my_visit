import 'package:flutter/material.dart';
import 'package:visits_prod/components/loaders/loader_page.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({required this.body, this.loaded = true, Key? key})
      : super(key: key);

  final Widget body;
  final bool loaded;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loaded ? SafeArea(child: body) : LoaderPage(),
    );
  }
}
