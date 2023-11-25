import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

Widget autoSizedText(String text) {
  return AutoSizeText(
    text,
    style: const TextStyle(fontSize: 18),
    // maxLines: 10,
    minFontSize: 12,
  );
}
