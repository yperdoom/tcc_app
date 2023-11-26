import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

Widget autoSizedText(String text, double fontSize) {
  return AutoSizeText(
    text,
    style: TextStyle(fontSize: fontSize),
    // maxLines: 10,
    minFontSize: 12,
  );
}
