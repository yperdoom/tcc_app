import 'package:Yan/enumerators/hint_text_fields.dart';
import 'package:flutter/material.dart';

InputDecoration textFieldDecoration(
  String fieldName, {
  Color textColor = Colors.white,
}) {
  return InputDecoration(
    label: Text(fieldName),
    labelStyle: TextStyle(
      color: textColor,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
    border: const OutlineInputBorder(),
    hintText: hintTextField(fieldName),
    hintStyle: const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
  );
}
