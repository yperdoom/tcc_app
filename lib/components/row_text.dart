import 'package:flutter/material.dart';

import 'auto_sized_text.dart';

Widget rowText(String text) {
  return Row(
    children: [
      Expanded(
        child: autoSizedText(text, 18, 1),
      ),
    ],
  );
}
