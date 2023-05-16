import 'dart:convert';

import 'package:app_tcc/views/manager/create_client.dart';
import 'package:app_tcc/views/manager/get_prescription.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../configs/colors.dart';
import '../../configs/session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String baseUrl = Session.baseUrl;

class HomeManager extends StatefulWidget {
  const HomeManager({super.key});

  @override
  State<HomeManager> createState() => _HomeManagerState();
}

class _HomeManagerState extends State<HomeManager> {
  var clientsReceived = [];
  String search = '';

  @override
  void initState() {
    Session.firstAcessHome ? _getClients() : _getClientsOnShared();

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
                          'Aqui voce encontra todos os clientes cadastrados no sistema.',
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
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: Cores.white,
                              ),
                              hintText: 'Pesquise seus clientes',
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
                          onPressed: () => {
                            _getClients(),
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
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateClient(),
              settings: RouteSettings(arguments: clientsReceived),
            ),
          )
        },
        backgroundColor: const Color(0xff1E4CFF),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _findList() {
    if (clientsReceived.isNotEmpty) {
      // retorna os cartões
      return Expanded(
        child: ListView.builder(
          itemCount: clientsReceived.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GetPrescription(),
                    settings: RouteSettings(
                      arguments: clientsReceived[index],
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
                            '${clientsReceived[index]['name']}',
                            style: TextStyle(
                              fontSize: 24,
                              color: Cores.white,
                            ),
                            maxLines: 1,
                            minFontSize: 18,
                          ),
                        ),
                        Text(
                          'Refeições: ${clientsReceived[index]['meal_amount']}',
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
                          '${clientsReceived[index]['recommended_calorie']} Kcal',
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

  void _getClients() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token').toString();
    if (Session.userId == '') {
      Session.userId = prefs.getString('userid').toString();
    }

    if (Session.env == 'local') {
      const meals = [];

      clientsReceived = meals;
    } else {
      http.Response response = await http.get(
        Uri.parse('$baseUrl/user/clients/${Session.userId}?search=$search'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
      );
      var body = await jsonDecode(response.body);

      if (body['success'] == true) {
        if (body['body']['count'] > 0) {
          clientsReceived = body['body']['prescriptions'];

          _setClientsOnShared();
        } else {
          clientsReceived = [];
          _setClientsOnShared();
        }
      } else {
        clientsReceived = [];
        _setClientsOnShared();
      }

      setState(() {});
    }
    Session.firstAcessHome = false;
    prefs.setString('firstacesshome', 'false');
  }

  String _regexDateTime(int index) {
    if (clientsReceived[index]['updated_at'] != null) {
      DateTime dateTime =
          DateTime.parse(clientsReceived[index]['updated_at'].toString());
      String formattedDateTime = '';

      String formattedTime =
          '${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
      String formattedDate =
          '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      formattedDateTime = '$formattedDate às $formattedTime';

      return formattedDateTime;
    } else {
      return '06/05/2020 às 00:00:00';
    }
  }

  void _getClientsOnShared() async {
    final prefs = await SharedPreferences.getInstance();
    int? clientLength = prefs.getInt('save.client.length');

    if (clientLength != null) {
      for (int counter = 0; counter <= clientLength; counter++) {
        String? clientString = prefs.getString('save.client.$counter');
        var client = jsonDecode(clientString.toString());

        if (client == null) {
          await prefs.setInt('save.client.length', counter - 1);
        } else {
          clientsReceived.add(client);
        }
      }
    } else {
      int counter = 0;
      while (counter >= 0) {
        String? clientString = prefs.getString('save.client.$counter');
        var client = jsonDecode(clientString.toString());

        if (client == null) {
          await prefs.setInt('save.client.length', counter - 1);
          counter = -1;
        } else {
          clientsReceived.add(client);

          counter++;
        }
      }
    }

    setState(() {});
  }

  void _setClientsOnShared() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(
      'save.client.length',
      clientsReceived.length - 1,
    );
    for (int counter = 0; counter < clientsReceived.length; counter++) {
      String client = jsonEncode(
        clientsReceived[counter],
      ).toString();

      await prefs.setString('save.client.$counter', client);
    }
  }
}
