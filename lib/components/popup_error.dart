import 'package:flutter/material.dart';
import '../configs/colors.dart';

void popupError(BuildContext context, String message, double lines) async {
  if (lines >= 2) {
    lines = 2;
  }

  return showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(10),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 120 * lines,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Cores.redError),
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Text(message, style: const TextStyle(fontSize: 24, color: Colors.white), textAlign: TextAlign.center),
          ),
        ],
      ),
    ),
  );
}
