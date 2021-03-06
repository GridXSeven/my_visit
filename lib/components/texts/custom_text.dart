import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText(this.text, {this.style, Key? key}) : super(key: key);

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
    );
  }
}
