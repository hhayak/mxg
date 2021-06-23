import 'package:flutter/material.dart';

class Utils {
  static bool isLight(BuildContext context) =>
      MediaQuery.of(context).platformBrightness == Brightness.light;
}
