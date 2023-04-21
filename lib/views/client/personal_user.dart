// ignore_for_file: use_build_context_synchronously
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../configs/colors.dart';
import '../../configs/session.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

String baseUrl = Session.baseUrl;

class PersonalUser extends StatefulWidget {
  const PersonalUser({super.key});

  @override
  State<PersonalUser> createState() => _PersonalUserState();
}

class _PersonalUserState extends State<PersonalUser> {
  var userReceived = {};

  @override
  void initState() {
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
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 40, bottom: 12),
                        child: Text(
                          'Informações Pessoais',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            color: Cores.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _EditUser(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('token');
          await prefs.remove('scope');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
          );
        },
        backgroundColor: Cores.blue,
        child: const Icon(Icons.navigation),
      ),
    );
  }

  Widget _EditUser() {
    _getUser();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Não temos nada aqui no momento :(',
                style: TextStyle(
                  color: Cores.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Switch(
              value: Session.darkMode,
              activeColor: Cores.blue,
              onChanged: (bool value) {
                setState(() async {
                  Session.darkMode = value;
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('darkMode', value);
                });
                setState(() {});
              },
            )
          ],
        ),
      ],
    );
  }

  void _editFood() async {
    print('pq nom trabaia?');
  }

  void _getUser() async {
    if (Session.env == 'local') {
      const user = {
        "user_id": 2,
        "name": "feijão",
        "description": "feijao branco cozido",
        "type": "grão",
        "color": "preto",
        "weight": 100,
        "calorie": 103,
        "protein": 6.6,
        "lipid": 0.5,
        "carbohydrate": 14.6,
        "updated_at": '05/10/2020'
      };

      userReceived = user;
    } else {
      http.Response response = await http.get(
        Uri.parse('$baseUrl/prescriptions'),
      );
      print(response);
      if (response.body.isNotEmpty) {
        // mealReceived = response;
      }
    }
  }
}
