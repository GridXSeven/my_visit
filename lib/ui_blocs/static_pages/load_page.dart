import 'package:flutter/material.dart';
import 'package:visits_prod/components/scaffolds/custom_scaffold.dart';
import 'package:visits_prod/ui_blocs/onboarding/onboarding_page.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({Key? key}) : super(key: key);

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (c) => OnboardingPage(),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      loaded: false,
      body: Container(),
    );
  }
}
