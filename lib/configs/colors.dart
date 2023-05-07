import 'package:app_tcc/configs/session.dart';
import 'package:flutter/material.dart';

class Cores {
  static Color black = Session.darkMode ? Colors.black : Colors.white;
  static Color white = Session.darkMode ? Colors.white : Colors.black;
  static Color selectedIcon = Session.darkMode ? Colors.white : Colors.black;
  static Color blueDark =
      Session.darkMode ? const Color(0xff1E2429) : const Color(0xffBDD6D8);
  static Color blueHeavy = const Color(0xff1E4CFF);
  static Color blue = const Color(0xFF3A62FF);
  static Color blueLight = const Color(0xff517AFF);
  static Color blueOpaque = const Color.fromARGB(255, 33, 149, 243);
  static Color blueClear =
      Session.darkMode ? const Color(0xffBDD6D8) : const Color(0xff1E2429);
  static Color redError = const Color.fromARGB(255, 141, 9, 0);
  static Color redExit = const Color.fromARGB(255, 201, 13, 0);
  static Color greyHeavy = const Color(0xFFD1D1D1);
  static Color grey = Colors.grey;
}
