// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../configs/colors.dart';

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
                  Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          'Calorias recomendadas: ${prescriptionReceived['recommended_calorie']} kcal',
                          style: const TextStyle(fontSize: 18),
                          // maxLines: 10,
                          minFontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          'Carboidratos recomendadas: ${prescriptionReceived['recommended_carbohydrate']} kcal',
                          style: const TextStyle(fontSize: 18),
                          // maxLines: 10,
                          minFontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          'Proteinas recomendadas: ${prescriptionReceived['recommended_protein']} kcal',
                          style: const TextStyle(fontSize: 18),
                          // maxLines: 10,
                          minFontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          'Lipídios recomendados: ${prescriptionReceived['recommended_lipid']} kcal',
                          style: const TextStyle(fontSize: 18),
                          // maxLines: 10,
                          minFontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          // '${prescriptionReceived['is_adapted_prescription']}',
                          prescriptionReceived['is_adapted_prescription'] ? 'Essa prescrição foi adaptada.' : 'Essa prescrição foi prescrita por um profissional.',
                          style: const TextStyle(fontSize: 18),
                          maxLines: 1,
                          minFontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          'Receitas: ${prescriptionReceived['meal_amount']}',
                          style: const TextStyle(fontSize: 18),
                          // maxLines: 10,
                          minFontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          'Última vez atualizado em: ${_regexDateTime(prescriptionReceived['updated_at'])}',
                          style: const TextStyle(fontSize: 18),
                          maxLines: 1,
                          minFontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: prescriptionReceived['meals'].length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(
                    left: 12,
                    bottom: 10,
                    right: 12,
                  ),
                  padding: const EdgeInsets.only(
                    left: 10,
                    top: 5,
                    bottom: 8,
                    right: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Cores.blueDark,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              '${prescriptionReceived['meals'][index]['name']}',
                              style: TextStyle(
                                fontSize: 24,
                                color: Cores.white,
                              ),
                              maxLines: 1,
                              minFontSize: 18,
                            ),
                          ),
                          Text(
                            '${prescriptionReceived['meals'][index]['type']}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Cores.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              _prepareFoodsToShow(prescriptionReceived['meals'][index]['foods']),
                              style: TextStyle(
                                fontSize: 24,
                                color: Cores.white,
                              ),
                              maxLines: 2,
                              minFontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _prepareFoodsToShow(foods) {
    String message = '';

    if (foods.isNotEmpty && foods.length > 0) {
      message = 'Alimentos:';
      for (int i = 0; i < foods.length; i++) {
        message = '$message ${foods[i]['weight']}g de ${foods[i]['name']}';
      }
    }

    return message.isNotEmpty ? message : 'Nenhum alimento encontrado';
  }

  String _regexDateTime(date) {
    if (date != null) {
      DateTime dateTime = DateTime.parse(
        date.toString(),
      );
      String formattedDateTime = '';

      String formattedTime = '${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
      String formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      formattedDateTime = '$formattedDate às $formattedTime';

      return formattedDateTime;
    } else {
      return '06/05/2020 às 00:00:00';
    }
  }
}
