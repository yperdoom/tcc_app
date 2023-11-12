import 'package:Yan/components/text_style.dart';
import 'package:flutter/material.dart';

Widget rowTitle(String pageName) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        padding: const EdgeInsets.only(top: 12, bottom: 8),
        child: Text(
          pageName,
          style: textStyle(),
        ),
      ),
    ],
  );
}
