import 'package:flutter/material.dart';

List<DataRow> dataTableRows(var rows) {
  List<DataRow> linhas = [];

  for (int i = 0; i < rows.length; i++) {
    linhas.add(DataRow(
      cells: rows[i],
    ));
  }

  return linhas;
}
