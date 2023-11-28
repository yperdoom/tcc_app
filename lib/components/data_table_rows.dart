import 'package:Yan/components/text_style.dart';
import 'package:flutter/material.dart';

List<DataRow> dataTableRows(var rows) {
  List<DataRow> linhas = [];

  for (int i = 0; i < rows.length; i++) {
    print(rows[i]['field']);

    linhas.add(DataRow(
      cells: <DataCell>[
        DataCell(Text(rows[i]['field'].toString(), style: textStyle(fontSize: 18.0))),
        DataCell(Text(rows[i]['old'].toString(), style: textStyle(fontSize: 18.0, fontWeight: FontWeight.w400))),
        DataCell(Text(rows[i]['new'].toString(), style: textStyle(fontSize: 18.0, fontWeight: FontWeight.w400))),
      ],
    ));
  }

  return linhas;
}
