import 'dart:convert';

import 'package:Yan/components/row_title.dart';
import 'package:Yan/views/prescription_views/adapter_prescription.dart';
import 'package:Yan/views/client/get_prescription.dart';
import 'package:Yan/components/hero_header_decoration.dart';
import 'package:Yan/views/prescription_views/create_client_prescription.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Yan/components/header_title.dart';
import 'package:Yan/components/parse_double.dart';
import 'package:Yan/components/regex_date_time.dart';
import '../../configs/colors.dart';
import '../../configs/session.dart';
import 'package:flutter/material.dart';
import 'package:Yan/interfaces/get_prescriptions.dart';

String baseUrl = Session.baseUrl;

class HomeUser extends StatefulWidget {
  const HomeUser({super.key});

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  var prescriptionsReceived = [];
  String search = '';

  @override
  void initState() {
    Session.firstAcessHome ? getPrescriptions('') : _getPrescriptionsOnShared();

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
              decoration: heroHeaderDecoration(),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  rowTitle('Home'),
                  headerTitle('home'),
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
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: Cores.white,
                              ),
                              hintText: 'Pesquise suas receitas',
                              hintStyle: TextStyle(
                                color: Cores.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            onChanged: (value) {
                              search = value;
                            },
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
                          onPressed: () async => {
                            getPrescriptions(search),
                            setState(() {})
                          },
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
        onPressed: () {
          if (prescriptionsReceived.isEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateClientPrescription(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdapterPrescription(),
                settings: RouteSettings(arguments: prescriptionsReceived),
              ),
            );
          }
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
                        prescriptionsReceived[index]['is_adapted_prescription']
                            ? Text(
                                '${parseDouble(prescriptionsReceived[index]['meals'][0]['calorie'])} Kcal',
                                style: TextStyle(
                                  color: Cores.white,
                                ),
                              )
                            : Text(
                                '${parseDouble(prescriptionsReceived[index]['recommended_calorie'])} Kcal',
                                style: TextStyle(
                                  color: Cores.white,
                                ),
                              ),
                        Text(
                          'Em: ${regexDateTime(prescriptionsReceived[index]['updated_at'])}',
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

  void _getPrescriptionsOnShared() async {
    final prefs = await SharedPreferences.getInstance();
    int? prescriptionLength = prefs.getInt('save.prescription.length');

    if (prescriptionLength != null) {
      for (int counter = 0; counter <= prescriptionLength; counter++) {
        String? prescriptionString = prefs.getString('save.prescription.$counter');
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
        String? prescriptionString = prefs.getString('save.prescription.$counter');
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
}
