import 'package:Yan/components/data_table_colums.dart';
import 'package:Yan/components/data_table_rows.dart';
import 'package:Yan/components/parse_double.dart';
import 'package:Yan/components/text_style.dart';
import 'package:flutter/material.dart';

Widget dataTableFoods(var prescriptionReceived) {
  double oldCalorie = prescriptionReceived['recommended_calorie'];
  double oldCarbo = prescriptionReceived['recommended_carbohydrate'];
  double oldProtein = prescriptionReceived['recommended_protein'];
  double oldLipid = prescriptionReceived['recommended_lipid'];
  double oldTotal = oldCalorie + oldCarbo + oldProtein + oldLipid;

  double newCalorie = prescriptionReceived['meals'][0]['calorie'];
  double newCarbo = prescriptionReceived['meals'][0]['carbohydrate'];
  double newProtein = prescriptionReceived['meals'][0]['protein'];
  double newLipid = prescriptionReceived['meals'][0]['lipid'];
  double newTotal = newCalorie + newCarbo + newProtein + newLipid;

  double firstRowSize = 14;
  double firstColSize = 14;
  FontWeight firstColFont = FontWeight.w800;
  double moreColSize = 16;
  FontWeight moreColFont = FontWeight.w800;

  var rows = [
    <DataCell>[
      celula('Calorias', firstColSize, firstColFont),
      celula(parseDouble(oldCalorie), moreColSize, moreColFont),
      celula(parseDouble(newCalorie), moreColSize, moreColFont)
    ],
    <DataCell>[
      celula('Carboidratos', firstColSize, firstColFont),
      celula(parseDouble(oldCarbo), moreColSize, moreColFont),
      celula(parseDouble(newCarbo), moreColSize, moreColFont)
    ],
    <DataCell>[
      celula('Calorias', firstColSize, firstColFont),
      celula(parseDouble(oldProtein), moreColSize, moreColFont),
      celula(parseDouble(newProtein), moreColSize, moreColFont)
    ],
    <DataCell>[
      celula('Lipídios', firstColSize, firstColFont),
      celula(parseDouble(oldLipid), moreColSize, moreColFont),
      celula(parseDouble(newLipid), moreColSize, moreColFont)
    ],
    <DataCell>[
      celula('Total', firstColSize, firstColFont),
      celula(parseDouble(oldTotal), moreColSize, moreColFont),
      celula(parseDouble(newTotal), moreColSize, moreColFont)
    ]
  ];

  return DataTable(
    columns: dataTableColums([
      'Nutrientes',
      'Recomendados',
      'Encontrados'
    ], firstRowSize),
    rows: dataTableRows(rows),
  );
}

DataCell celula(
  String text,
  double fontSize,
  FontWeight fontWeight,
) {
  return DataCell(
    Text(
      text,
      style: textStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    ),
  );
}
