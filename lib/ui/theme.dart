import 'package:flutter/material.dart';

const Color bluishClr = Color(0xFF4E5AE8);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFFF4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
Color darkHeaderClr = const Color(0xFF424242);

class Themes {
  static final light = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: primaryClr,
      background: Colors.white,
    ),
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: darkGreyClr,
      brightness: Brightness.dark,
      background: darkGreyClr,
    ),
  );
}
