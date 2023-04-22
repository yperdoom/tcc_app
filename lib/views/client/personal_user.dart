// ignore_for_file: use_build_context_synchronously

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
  var statesReceived = [];

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
                        padding: const EdgeInsets.only(top: 50, bottom: 12),
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                label: const Text('Nome'),
                labelStyle: TextStyle(
                  color: Cores.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                border: const OutlineInputBorder(),
              ),
              controller: TextEditingController(text: userReceived['name']),
              keyboardType: TextInputType.number,
              readOnly: true,
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                label: const Text('E-mail'),
                labelStyle: TextStyle(
                  color: Cores.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                border: const OutlineInputBorder(),
              ),
              controller: TextEditingController(text: userReceived['email']),
              keyboardType: TextInputType.number,
              readOnly: true,
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                label: const Text('Telefone'),
                labelStyle: TextStyle(
                  color: Cores.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                border: const OutlineInputBorder(),
              ),
              controller: TextEditingController(text: userReceived['phone']),
              keyboardType: TextInputType.number,
              readOnly: true,
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                label: const Text('Documento'),
                labelStyle: TextStyle(
                  color: Cores.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                border: const OutlineInputBorder(),
              ),
              controller: TextEditingController(text: userReceived['document']),
              keyboardType: TextInputType.number,
              readOnly: true,
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                label: const Text('Cidade'),
                labelStyle: TextStyle(
                  color: Cores.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                border: const OutlineInputBorder(),
              ),
              controller: TextEditingController(text: userReceived['city']),
              keyboardType: TextInputType.number,
              readOnly: true,
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                label: const Text('Estado'),
                labelStyle: TextStyle(
                  color: Cores.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                border: const OutlineInputBorder(),
              ),
              controller: TextEditingController(text: userReceived['state']),
              keyboardType: TextInputType.number,
              readOnly: true,
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                label: const Text('Aniversário'),
                labelStyle: TextStyle(
                  color: Cores.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                border: const OutlineInputBorder(),
              ),
              controller: TextEditingController(text: userReceived['birthday']),
              keyboardType: TextInputType.number,
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }

  void _editFood() async {
    print('pq nom trabaia?');
  }

  void _getUser() async {
    if (Session.env == 'local') {
      const user = {
        "user_id": 2,
        "name": "Pedro",
        "email": "pedro.tepo@mail.com",
        "password": "dasdasad",
        "scope": "client",
        "phone": "5411111111",
        "document": "00011122254",
        "city": "Nonoai",
        "state": "RS",
        "birthday": "08/09/2000",
        "updated_at": "05/10/2020 05:07"
      };

      const states = [
        {"state": "Acre", "acronym": "AC"},
        {"state": "Alagoas", "acronym": "AL"},
        {"state": "Amapá", "acronym": "AP"},
        {"state": "Amazonas", "acronym": "AM"},
        {"state": "Bahia", "acronym": "BA"},
        {"state": "Ceará", "acronym": "CE"},
        {"state": "Distrito Federal", "acronym": "DF"},
        {"state": "Espírito Santo", "acronym": "ES"},
        {"state": "Goiás", "acronym": "GO"},
        {"state": "Maranhão", "acronym": "MA"},
        {"state": "Mato Grosso", "acronym": "MT"},
        {"state": "Mato Grosso do Sul", "acronym": "MS"},
        {"state": "Minas Gerais", "acronym": "MG"},
        {"state": "Pará", "acronym": "PA"},
        {"state": "Paraíba", "acronym": "PB"},
        {"state": "Paraná", "acronym": "PR"},
        {"state": "Pernambuco", "acronym": "PE"},
        {"state": "Piauí", "acronym": "PI"},
        {"state": "Rio de Janeiro", "acronym": "RJ"},
        {"state": "Rio Grande do Norte", "acronym": "RN"},
        {"state": "Rio Grande do Sul", "acronym": "RS"},
        {"state": "Rondônia", "acronym": "RO"},
        {"state": "Roraima", "acronym": "RR"},
        {"state": "Santa Catarina", "acronym": "SC"},
        {"state": "São Paulo", "acronym": "SP"},
        {"state": "Sergipe", "acronym": "SE"},
        {"state": "Tocantins", "acronym": "TO"},
      ];

      statesReceived = states;
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
