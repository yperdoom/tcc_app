// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:app_tcc/views/manager/create_prescription.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../configs/colors.dart';
import '../../configs/session.dart';
import 'package:http/http.dart' as http;

String baseUrl = Session.baseUrl;

class GetClient extends StatefulWidget {
  const GetClient({super.key});

  @override
  State<GetClient> createState() => _GetClientState();
}

class _GetClientState extends State<GetClient> {
  var clientReceived = {};
  var prescriptionsReceived = [];

  @override
  void initState() {
    _getPrescriptions();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    clientReceived = jsonDecode(
      jsonEncode(arguments),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Visualizar cliente',
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
                          '${clientReceived['name']}',
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: const [
                      AutoSizeText(
                        'E-mail:',
                        style: TextStyle(fontSize: 18),
                        minFontSize: 14,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          '${clientReceived['email']}',
                          style: const TextStyle(fontSize: 18),
                          minFontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AutoSizeText(
                        'Gordura: ${clientReceived['fat_percentage']}%',
                        style: const TextStyle(fontSize: 18),
                        minFontSize: 18,
                      ),
                      AutoSizeText(
                        _convertSex(clientReceived['sex']),
                        style: const TextStyle(fontSize: 18),
                        minFontSize: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AutoSizeText(
                        'Altura: ${clientReceived['height']} cm',
                        style: const TextStyle(fontSize: 18),
                        // maxLines: 10,
                        minFontSize: 18,
                      ),
                      AutoSizeText(
                        'Peso: ${clientReceived['weight']} Kg',
                        style: const TextStyle(fontSize: 18),
                        // maxLines: 10,
                        minFontSize: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          'Última vez atualizado em: ${_regexDateTime(clientReceived['updated_at'])}',
                          style: const TextStyle(fontSize: 18),
                          maxLines: 1,
                          minFontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Expanded(
                        child: AutoSizeText(
                          'Prescrições:',
                          style: TextStyle(fontSize: 18),
                          minFontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _getPrescriptionsView(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreatePrescription(),
              settings: RouteSettings(arguments: clientReceived),
            ),
          )
        },
        backgroundColor: const Color(0xff1E4CFF),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _getPrescriptionsView() {
    _getPrescriptionsOnShared();

    if (prescriptionsReceived.isNotEmpty) {
      return Expanded(
        child: ListView.builder(
          itemCount: prescriptionsReceived.length,
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
                          '${prescriptionsReceived[index]['name']}',
                          style: TextStyle(
                            fontSize: 24,
                            color: Cores.white,
                          ),
                          maxLines: 1,
                          minFontSize: 18,
                        ),
                      ),
                      Text(
                        '${prescriptionsReceived[index]['type']}',
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
                          _prepareFoodsToShow(prescriptionsReceived[index]['foods']),
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
      );
    }
    return Expanded(
      child: Text(
        'Não temos nada aqui no momento :(',
        style: TextStyle(
          color: Cores.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _convertSex(String sex) {
    String text = 'não informado';

    if (sex == 'male') {
      text = 'Masculino';
    }
    if (sex == 'female') {
      text = 'Masculino';
    }

    return 'Sexo: $text';
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

  void _getPrescriptions() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token').toString();

    if (Session.env == 'local') {
      const meals = [];

      prescriptionsReceived = meals;
    } else {
      http.Response response = await http.get(
        Uri.parse('$baseUrl/prescriptions/${clientReceived['user_id']}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
      );
      var body = await jsonDecode(response.body);

      print(body);

      if (body['success'] == true) {
        if (body['body']['count'] > 0) {
          prescriptionsReceived = body['body']['prescriptions'];

          _setPrescriptionsOnShared();
        } else {
          prescriptionsReceived = [];

          _setPrescriptionsOnShared();
        }
      } else {
        prescriptionsReceived = [];

        _setPrescriptionsOnShared();
      }

      setState(() {});
    }
  }

  void _getPrescriptionsOnShared() async {
    final prefs = await SharedPreferences.getInstance();
    int? prescriptionLength = prefs.getInt('save.${clientReceived['client_id']}.prescription.length');

    if (prescriptionLength != null) {
      for (int counter = 0; counter <= prescriptionLength; counter++) {
        String? prescriptionString = prefs.getString('save.${clientReceived['client_id']}.prescription.$counter');
        var prescription = jsonDecode(prescriptionString.toString());

        if (prescription == null) {
          await prefs.setInt('save.${clientReceived['client_id']}.prescription.length', counter - 1);
        } else {
          prescriptionsReceived.add(prescription);
        }
      }
    } else {
      int counter = 0;
      while (counter >= 0) {
        String? prescriptionString = prefs.getString('save.${clientReceived['client_id']}.prescription.$counter');
        var prescription = jsonDecode(prescriptionString.toString());

        if (prescription == null) {
          await prefs.setInt('save.${clientReceived['client_id']}.prescription.length', counter - 1);
          counter = -1;
        } else {
          prescriptionsReceived.add(prescription);

          counter++;
        }
      }
    }

    setState(() {});
  }

  void _setPrescriptionsOnShared() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(
      'save.${clientReceived['client_id']}.prescription.length',
      prescriptionsReceived.length - 1,
    );
    for (int counter = 0; counter < prescriptionsReceived.length; counter++) {
      String prescription = jsonEncode(
        prescriptionsReceived[counter],
      ).toString();

      await prefs.setString('save.${clientReceived['client_id']}.prescription.$counter', prescription);
    }
  }
}
