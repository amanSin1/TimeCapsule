import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ThemeClass {
  // Make these fields static
  static Color lightPrimaryColor = HexColor('#DF0054');
  static Color darkPrimaryColor = HexColor('#480032');
  static Color secondaryColor = HexColor('#FF8B6A');
  static Color accentColor = HexColor('#FFD2BB');

  // Define static themes using the static fields
  static ThemeData lightTheme = ThemeData(
    primaryColor: ThemeData.light().scaffoldBackgroundColor,
    colorScheme: const ColorScheme.light().copyWith(
      primary: lightPrimaryColor, // Corrected to use static field
      secondary: secondaryColor,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: ThemeData.dark().scaffoldBackgroundColor,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: darkPrimaryColor, // Corrected to use static field
    ),
  );
}
