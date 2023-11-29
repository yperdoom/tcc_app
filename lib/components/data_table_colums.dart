import 'package:Yan/components/text_style.dart';
import 'package:flutter/material.dart';

List<DataColumn> dataTableColums(var colums, double fontSize) {
  List<DataColumn> colunas = <DataColumn>[];

  for (int i = 0; i < colums.length; i++) {
    colunas.add(DataColumn(
      label: Text(
        colums[i].toString(),
        style: textStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
      ),
    ));
  }

  return colunas;
}
