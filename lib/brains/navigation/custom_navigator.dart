import 'package:flutter/material.dart';

class CustomNavigator {
  static Future<dynamic> push(BuildContext context, dynamic page) async {
    return await Navigator.push(
        context, MaterialPageRoute(builder: (c) => page));
  }
}
