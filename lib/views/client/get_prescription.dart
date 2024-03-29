// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
// import 'dart:io';
import 'package:Yan/components/auto_sized_text.dart';
import 'package:Yan/components/data_table_foods.dart';
import 'package:Yan/components/espaco.dart';
import 'package:Yan/components/prescription_created.dart';
import 'package:Yan/components/row_text.dart';
import 'package:Yan/components/parse_double.dart';
import 'package:Yan/components/prescription_adapted.dart';
import 'package:Yan/components/regex_date_time.dart';
import 'package:Yan/configs/colors.dart';
import 'package:Yan/configs/session.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

String baseUrl = Session.baseUrl;

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
                  const SizedBox(height: 20),
                  prescriptionReceived['is_adapted_prescription']
                      ? Container(child: dataTableFoods(prescriptionReceived))
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
                              child: autoSizedText('Receitas: ${prescriptionReceived['meal_amount']}', 18, 1),
                            ),
                          ],
                        ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: autoSizedText('Última vez atualizado em: ${regexDateTime(prescriptionReceived['updated_at'])}', 18, 2),
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
      // floatingActionButton: prescriptionReceived['is_adapted_prescription']
      //     ? FloatingActionButton(
      //         onPressed: () async {
      // final prefs = await SharedPreferences.getInstance();
      // var token = prefs.getString('token').toString();
      // if (Session.userId == '') {
      //   Session.userId = prefs.getString('userid').toString();
      // }
      // if (Session.managerId == '') {
      //   Session.managerId = prefs.getString('managerid').toString();
      // }

      // Uri url = Uri.parse('$baseUrl/prescription/readapter');
      // Map<String, String> headers = <String, String>{
      //   'Content-Type': 'application/json; charset=UTF-8',
      //   'Authorization': token
      // };

      // Object prescriptionToAdapter = jsonEncode({
      //   "foods": prescriptionReceived['meals'][0]['foods'],
      //   "mealId": prescriptionReceived['meals'][0]['_id'],
      //   "prescriptionId": prescriptionReceived['_id'],
      //   "name": prescriptionReceived['meals'][0]['name'],
      //   "type": prescriptionReceived['meals'][0]['type'],
      //   "userId": Session.userId,
      //   "managerId": Session.managerId
      // });

      // print('prescriptionToAdapter');
      // print(prescriptionToAdapter);

      // http.Response response = await http.put(
      //   url,
      //   headers: headers,
      //   body: prescriptionToAdapter,
      // );
      // var body = await jsonDecode(response.body);

      // print(body);

      // if (body['success'] == true) {
      //   Navigator.pop(context);
      //   popup(context, false, 'Adaptação refeita com sucesso!');
      //   sleep(const Duration(seconds: 1));
      //   Navigator.pop(context);
      //   Navigator.pop(context);
      //   setState(() {});
      // } else {
      //   popup(context, true, 'Houve um erro ao criar essa adaptação!\n ${body['message'].toString()}!');
      // }
      //     },
      //     backgroundColor: Cores.blue,
      //     child: const Icon(Icons.replay_outlined),
      //   )
      // : FloatingActionButton(
      //     onPressed: () async {
      //       Navigator.pop(context);
      //     },
      //     backgroundColor: Cores.blue,
      //     child: const Icon(Icons.navigation),
      //   ),
    );
  }

  void popup(BuildContext context, bool error, String message) async {
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
              height: 200,
              decoration: error
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Cores.redError,
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Text(
                message,
                style: const TextStyle(fontSize: 24, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
