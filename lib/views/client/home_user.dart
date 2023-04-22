import 'package:auto_size_text/auto_size_text.dart';

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
  var mealReceived = [];

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
                  const Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              prefixIcon: Icon(Icons.search_rounded),
                              hintText: 'Pesquise suas receitas',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            backgroundColor: const Color(0xff1E4CFF),
                          ),
                          onPressed: () => {},
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
          _FindList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMeal,
        backgroundColor: const Color(0xff1E4CFF),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _FindList() {
    _getPrescriptions();

    if (mealReceived.isNotEmpty) {
      // retorna os cartões
      return Expanded(
        child: ListView.builder(
          itemCount: mealReceived.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: _editPrescription,
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
                decoration: const BoxDecoration(
                    color: Color(0xff1E2429),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            '${mealReceived[index]['name']}',
                            style: const TextStyle(fontSize: 24),
                            maxLines: 1,
                            minFontSize: 18,
                          ),
                        ),
                        Text('${mealReceived[index]['type']}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${mealReceived[index]['calorie']} Kcal'),
                        Text(
                            'Atualizado em: ${mealReceived[index]['updated_at']}'),
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
    return const Expanded(
      child: Text(
        'Não temos nada aqui no momento :(',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _editPrescription() async {
    print('pq nom trabaia?');
  }

  void _getPrescriptions() async {
    if (Session.env == 'local') {
      const meals = [
        {
          'name': 'teste 1',
          'type': 'almoço',
          'calorie': 480,
          'protein': 50.2,
          'lipid': 20,
          'carbohydrate': 56,
          'created_at': '08/09/2000',
          'updated_at': '05/10/2020'
        },
        {
          'name': 'teste 2',
          'type': 'almoço',
          'calorie': 480,
          'protein': 50.2,
          'lipid': 20,
          'carbohydrate': 56,
          'created_at': '08/09/2000',
          'updated_at': '05/10/2020'
        },
        {
          'name': 'teste 3',
          'type': 'almoço',
          'calorie': 480,
          'protein': 50.2,
          'lipid': 20,
          'carbohydrate': 56,
          'created_at': '08/09/2000',
          'updated_at': '05/10/2020'
        },
        {
          'name': 'teste 4',
          'type': 'almoço',
          'calorie': 480,
          'protein': 50.2,
          'lipid': 20,
          'carbohydrate': 56,
          'created_at': '08/09/2000',
          'updated_at': '05/10/2020'
        },
        {
          'name': 'teste 5',
          'type': 'almoço',
          'calorie': 480,
          'protein': 50.2,
          'lipid': 20,
          'carbohydrate': 56,
          'created_at': '08/09/2000',
          'updated_at': '05/10/2020'
        },
        {
          'name': 'teste 6',
          'type': 'almoço',
          'calorie': 480,
          'protein': 50.2,
          'lipid': 20,
          'carbohydrate': 56,
          'created_at': '08/09/2000',
          'updated_at': '05/10/2020'
        },
        {
          'name': 'teste 7',
          'type': 'almoço',
          'calorie': 480,
          'protein': 50.2,
          'lipid': 20,
          'carbohydrate': 56,
          'created_at': '08/09/2000',
          'updated_at': '05/10/2020'
        },
        {
          'name': 'teste 8',
          'type': 'almoço',
          'calorie': 480,
          'protein': 50.2,
          'lipid': 20,
          'carbohydrate': 56,
          'created_at': '08/09/2000',
          'updated_at': '05/10/2020'
        },
        {
          'name': 'teste 9',
          'type': 'almoço',
          'calorie': 480,
          'protein': 50.2,
          'lipid': 20,
          'carbohydrate': 56,
          'created_at': '08/09/2000',
          'updated_at': '05/10/2020'
        },
        {
          'name': 'teste 10',
          'type': 'almoço',
          'calorie': 480,
          'protein': 50.2,
          'lipid': 20,
          'carbohydrate': 56,
          'created_at': '08/09/2000',
          'updated_at': '05/10/2020'
        },
      ];

      mealReceived = meals;
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

  void _addMeal() async {
    print('test buttom');
  }
}
