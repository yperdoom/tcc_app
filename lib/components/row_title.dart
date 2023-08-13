import 'package:flutter/material.dart';

import '../configs/colors.dart';

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
          style: TextStyle(
            fontFamily: 'Urbanist',
            color: Cores.white,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
      ),
    ],
  );
}
