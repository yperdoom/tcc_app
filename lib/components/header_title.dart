import 'package:Yan/enumerators/header_text_pages.dart';
import 'package:flutter/material.dart';

Widget headerTitle(String page) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: Text(
          headerText(page),
          style: const TextStyle(
            fontFamily: 'Urbanist',
            color: Color(0xffBDD6D8),
            fontWeight: FontWeight.w300,
            fontSize: 18,
          ),
        ),
      ),
    ],
  );
}
