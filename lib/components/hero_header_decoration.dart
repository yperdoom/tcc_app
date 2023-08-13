import 'package:flutter/material.dart';

import '../configs/colors.dart';

BoxDecoration heroHeaderDecoration() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.bottomLeft,
      colors: <Color>[
        Cores.blueHeavy,
        Cores.blueLight,
      ],
      tileMode: TileMode.mirror,
    ),
  );
}
