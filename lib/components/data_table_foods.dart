import 'package:Yan/components/data_table_colums.dart';
import 'package:Yan/components/data_table_rows.dart';
import 'package:Yan/components/parse_double.dart';
import 'package:flutter/material.dart';

Widget dataTableFoods(var prescriptionReceived) {
  var rows = [
    {
      "field": "Calorias",
      "old": prescriptionReceived['recommended_calorie'],
      "new": parseDouble(prescriptionReceived['meals'][0]['calorie'])
    },
    {
      "field": "Carboidratos",
      "old": prescriptionReceived['recommended_carbohydrate'],
      "new": parseDouble(prescriptionReceived['meals'][0]['carbohydrate'])
    },
    {
      "field": "Proteinas",
      "old": prescriptionReceived['recommended_protein'],
      "new": parseDouble(prescriptionReceived['meals'][0]['protein'])
    },
    {
      "field": "Lipídios",
      "old": prescriptionReceived['recommended_lipid'],
      "new": parseDouble(prescriptionReceived['meals'][0]['lipid'])
    }
  ];

  return DataTable(
    columns: dataTableColums([
      'Nutrientes',
      'Recomendados',
      'Encontrados'
    ]),
    rows: dataTableRows(rows),
  );
}
