import 'package:Yan/components/text_style.dart';
import 'package:flutter/material.dart';

List<DataColumn> dataTableColums(var colums) {
  List<DataColumn> colunas = <DataColumn>[];

  for (int i = 0; i < colums.length; i++) {
    colunas.add(DataColumn(
      label: Expanded(
        child: Text(
          colums[i].toString(),
          style: textStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
      ),
    ));
  }

  return colunas;
}
