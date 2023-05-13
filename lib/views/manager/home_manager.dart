import 'dart:convert';

import 'package:app_tcc/views/client/create_prescription.dart';
import 'package:app_tcc/views/client/get_prescription.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../configs/colors.dart';
import '../../configs/session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String baseUrl = Session.baseUrl;

class HomeUser extends StatefulWidget {
  const HomeUser({super.key});

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  var prescriptionsReceived = [];

  @override
  void initState() {
    Session.firstAcessHome ? _getPrescriptions() : _getPrescriptionsOnShared();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Hero(
            tag: 'dash',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.bottomLeft,
                  colors: <Color>[
                    Cores.blueHeavy,
                    Cores.blueLight,
                  ],
                  tileMode: TileMode.mirror,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 12, bottom: 8),
                        child: const Text(
                          'Home',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Expanded(
                        child: Text(
                          'Aqui voce encontra as receitas criadas por seu profissional e as receitas adaptadas por você.',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            color: Color(0xffBDD6D8),
                            fontWeight: FontWeight.w300,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Cores.blueDark,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              prefixIcon: Icon(Icons.search_rounded, color: Cores.white),
                              hintText: 'Pesquise suas receitas',
                              hintStyle: TextStyle(
                                color: Cores.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            backgroundColor: const Color(0xff1E4CFF),
                          ),
                          onPressed: () => {_getPrescriptions()},
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 3,
                            ),
                            child: Text(
                              'Buscar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          _findList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CreatePrescription(),
                settings: RouteSettings(arguments: prescriptionsReceived)),
          )
        },
        backgroundColor: const Color(0xff1E4CFF),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _findList() {
    if (prescriptionsReceived.isNotEmpty) {
      // retorna os cartões
      return Expanded(
        child: ListView.builder(
          itemCount: prescriptionsReceived.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GetPrescription(),
                    settings: RouteSettings(
                      arguments: prescriptionsReceived[index],
                    ),
                  ),
                ),
              },
              // onTap: () => showInfoDetails(index),
              child: Container(
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
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                          'Refeições: ${prescriptionsReceived[index]['meal_amount']}',
                          style: TextStyle(
                            color: Cores.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${prescriptionsReceived[index]['recommended_calorie']} Kcal',
                          style: TextStyle(
                            color: Cores.white,
                          ),
                        ),
                        Text(
                          'Atualizado em: ${_regexDateTime(index)}',
                          style: TextStyle(
                            color: Cores.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    // retorna mensagem que não tem nada
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

  void _getPrescriptions() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token').toString();
    if (Session.userId == '') {
      Session.userId = prefs.getString('userid').toString();
    }

    if (Session.env == 'local') {
      const meals = [];

      prescriptionsReceived = meals;
    } else {
      http.Response response = await http.get(
        Uri.parse('$baseUrl/prescriptions/${Session.userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
      );
      var body = await jsonDecode(response.body);

      if (body['success'] == true) {
        if (body['body']['count'] > 0) {
          prescriptionsReceived = body['body']['prescriptions'];

          _setPrescriptionsOnShared();
        }
      } else {
        prescriptionsReceived = [];
      }

      setState(() {});
    }
    Session.firstAcessHome = false;
    prefs.setString('firstacesshome', 'false');
  }

  String _regexDateTime(int index) {
    if (prescriptionsReceived[index]['updated_at'] != null) {
      DateTime dateTime =
          DateTime.parse(prescriptionsReceived[index]['updated_at'].toString());
      String formattedDateTime = '';

      formattedDateTime =
          '${dateTime.hour}:${dateTime.minute}:${dateTime.second} de ${dateTime.day}/${dateTime.month}/${dateTime.year}';

      return formattedDateTime;
    } else {
      return '00:00:00 de 06/05/2020';
    }
  }

  void _getPrescriptionsOnShared() async {
    final prefs = await SharedPreferences.getInstance();
    int? prescriptionLength = prefs.getInt('save.prescription.length');

    if (prescriptionLength != null) {
      for (int counter = 0; counter <= prescriptionLength; counter++) {
        String? prescriptionString =
            prefs.getString('save.prescription.$counter');
        var prescription = jsonDecode(prescriptionString.toString());

        if (prescription == null) {
          await prefs.setInt('save.prescription.length', counter - 1);
        } else {
          prescriptionsReceived.add(prescription);
        }
      }
    } else {
      int counter = 0;
      while (counter >= 0) {
        String? prescriptionString =
            prefs.getString('save.prescription.$counter');
        var prescription = jsonDecode(prescriptionString.toString());

        if (prescription == null) {
          await prefs.setInt('save.prescription.length', counter - 1);
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
      'save.prescription.length',
      prescriptionsReceived.length - 1,
    );
    for (int counter = 0; counter < prescriptionsReceived.length; counter++) {
      String prescription = jsonEncode(
        prescriptionsReceived[counter],
      ).toString();

      await prefs.setString('save.prescription.$counter', prescription);
    }
  }
}
