// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:Yan/components/auto_sized_text.dart';
import 'package:Yan/components/espaco.dart';
import 'package:Yan/components/prescription_created.dart';
import 'package:Yan/components/row_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Yan/components/parse_double.dart';
import 'package:Yan/components/prescription_adapted.dart';
import 'package:Yan/components/regex_date_time.dart';
import 'package:Yan/configs/colors.dart';

class GetPrescription extends StatefulWidget {
  const GetPrescription({super.key});

  @override
  State<GetPrescription> createState() => _GetPrescriptionState();
}

class _GetPrescriptionState extends State<GetPrescription> {
  var prescriptionReceived = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    prescriptionReceived = jsonDecode(
      jsonEncode(arguments),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Visualizar prescrição',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Cores.blueHeavy,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          '${prescriptionReceived['name']}',
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  prescriptionReceived['is_adapted_prescription']
                      ? Column(
                          children: [
                            rowText('Nutrientes recomendados || Nutrientes encontrados'),
                            rowText('Calorias: ${parseDouble(prescriptionReceived['recommended_calorie'])} kcal || ${parseDouble(prescriptionReceived['meals'][0]['calorie'])} kcal'),
                            rowText('Carboidratos: ${parseDouble(prescriptionReceived['recommended_carbohydrate'])} kcal || ${parseDouble(prescriptionReceived['meals'][0]['carbohydrate'])} kcal'),
                            rowText('Proteinas: ${parseDouble(prescriptionReceived['recommended_protein'])} kcal || ${parseDouble(prescriptionReceived['meals'][0]['protein'])} kcal'),
                            rowText('Lipídios: ${parseDouble(prescriptionReceived['recommended_lipid'])} kcal || ${parseDouble(prescriptionReceived['meals'][0]['lipid'])} kcal'),
                          ],
                        )
                      : Column(
                          children: [
                            rowText('Calorias recomendadas: ${parseDouble(prescriptionReceived['recommended_calorie'])} kcal'),
                            rowText('Carboidratos recomendadas: ${parseDouble(prescriptionReceived['recommended_carbohydrate'])} kcal'),
                            rowText('Proteinas recomendadas: ${parseDouble(prescriptionReceived['recommended_protein'])} kcal'),
                            rowText('Lipídios recomendados: ${parseDouble(prescriptionReceived['recommended_lipid'])} kcal'),
                          ],
                        ),
                  espaco(20),
                  rowText(prescriptionReceived['is_adapted_prescription'] ? 'Essa prescrição foi adaptada.' : 'Essa prescrição foi prescrita por um profissional.'),
                  const SizedBox(height: 10),
                  prescriptionReceived['is_adapted_prescription']
                      ? espaco(0)
                      : Row(
                          children: [
                            Expanded(
                              child: autoSizedText('Receitas: ${prescriptionReceived['meal_amount']}', 18),
                            ),
                          ],
                        ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: autoSizedText('Última vez atualizado em: ${regexDateTime(prescriptionReceived['updated_at'])}', 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          prescriptionReceived['is_adapted_prescription'] ? prescriptionAdapted(prescriptionReceived['meals'][0]['foods']) : prescriptionCreated(prescriptionReceived['meals']),
        ],
      ),
    );
  }
}
