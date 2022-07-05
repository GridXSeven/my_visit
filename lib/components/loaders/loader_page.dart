import 'package:flutter/material.dart';
import 'package:visits_prod/components/loaders/small_loader.dart';

class LoaderPage extends StatelessWidget {
  const LoaderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: SmallLoader()),
    );
  }
}
