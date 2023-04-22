import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.red,
      primaryColor: isDarkTheme ? Colors.black : Colors.white,
      backgroundColor: isDarkTheme ? Colors.black : const Color(0xffF1F5FB),
      indicatorColor: isDarkTheme ? Colors.black : Color(0xffCBDCF8),
      hintColor: isDarkTheme ? Colors.black : Color(0xffEECED3),
      highlightColor: isDarkTheme ? Colors.black : Color(0xffFCE192),
      hoverColor: isDarkTheme ? Colors.black : Color(0xff4285F4),
      focusColor: isDarkTheme ? Colors.black : Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      cardColor: isDarkTheme ? Colors.black : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
    );
  }
}
