import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../configs/colors.dart';
import '../../configs/session.dart';
import 'package:http/http.dart' as http;

String baseUrl = Session.baseUrl;

class FoodUser extends StatefulWidget {
  const FoodUser({super.key});

  @override
  State<FoodUser> createState() => _FoodUserState();
}

class _FoodUserState extends State<FoodUser> {
  var foodReceived = [];

  @override
  void initState() {
    Session.firstAcessFood ? _getFoods() : _getFoodsOnShared();

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
                        child: Text(
                          'Alimentos',
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
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Aqui voce encontra os alimentos cadastrados.',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            color: Cores.blueClear,
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
                              prefixIcon: const Icon(Icons.search_rounded),
                              hintText: 'Pesquise por alimentos',
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
                                borderRadius: BorderRadius.circular(50)),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            backgroundColor: Cores.blueHeavy,
                          ),
                          onPressed: () => {
                                _getFoods()
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 3,
                            ),
                            child: Text(
                              'Buscar',
                              style: TextStyle(
                                color: Cores.white,
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
    );
  }

  Widget _findList() {
    if (foodReceived.isNotEmpty) {
      // retorna os cartões
      return Expanded(
        child: ListView.builder(
          itemCount: foodReceived.length,
          itemBuilder: (context, index) {
            return GestureDetector(
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
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            '${foodReceived[index]['name']}',
                            style: const TextStyle(fontSize: 24),
                            maxLines: 1,
                            minFontSize: 18,
                          ),
                        ),
                        Text('${foodReceived[index]['type']}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            '${foodReceived[index]['description']}',
                            style: const TextStyle(fontSize: 18),
                            maxLines: 3,
                            minFontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${foodReceived[index]['calorie']} Kcal em ${foodReceived[index]['weight']}g'),
                        Text('Atualizado em: ${_regexDateTime(index)}'),
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

  void _getFoods() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token').toString();
    if (Session.userId == '') {
      Session.userId = prefs.getString('userid').toString();
    }

    if (Session.env == 'local') {
      const foods = [
        {
          "food_id": 1,
          "name": "arroz",
          "description":
              "arroz branco cozido em temperatura média para testar o tamanho de palavras porque pode caber muitas palavras aqui e ainda ter espaço para mais palavras meu deus como tem muitas palavras",
          "type": "grão",
          "color": "branco",
          "weight": 100,
          "calorie": 129,
          "protein": 2.5,
          "lipid": 0.23,
          "carbohydrate": 28.18,
          "updated_at": '05/10/2020'
        },
        {
          "food_id": 2,
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
        },
        {
          "food_id": 3,
          "name": "peito de frango",
          "description": "peito de frango cozido",
          "type": "carne",
          "color": "branco",
          "weight": 100,
          "calorie": 165,
          "protein": 31.02,
          "lipid": 3.57,
          "carbohydrate": 0,
          "updated_at": '05/10/2028'
        },
        {
          "food_id": 4,
          "name": "Ovo",
          "description": "cozido",
          "type": "ovo",
          "color": "branco",
          "weight": 100,
          "calorie": 165,
          "protein": 31.02,
          "lipid": 3.57,
          "carbohydrate": 0,
          "updated_at": '05/10/2028'
        }
      ];

      foodReceived = foods;
    } else {
      http.Response response = await http.get(
        Uri.parse('$baseUrl/foods'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
      );
      var body = await jsonDecode(response.body);

      if (body['success'] == true) {
        if (body['body']['count'] > 0) {
          foodReceived = body['body']['foods'];
          _setFoodsOnShared();
        }
      } else {
        foodReceived = [];
      }
      setState(() {});
    }
    Session.firstAcessFood = false;
    prefs.setString('firstacessfood', 'false');
  }

  String _regexDateTime(int index) {
    if (foodReceived[index]['updated_at'] != null) {
      DateTime dateTime = DateTime.parse(foodReceived[index]['updated_at'].toString());
      String formattedDateTime = '';

      formattedDateTime = '${dateTime.hour}:${dateTime.minute}:${dateTime.second} de ${dateTime.day}/${dateTime.month}/${dateTime.year}';

      return formattedDateTime;

    } else {
      return '00:00:00 de 06/05/2020';
    }
  }
  
  void _getFoodsOnShared() async {
    final prefs = await SharedPreferences.getInstance();

    int counter = 0;
    while (counter >= 0) {
      String? foodString = prefs.getString('save.food.$counter');
      var food = jsonDecode(foodString.toString());

      if (food == null) {
        counter = -1;
      } else {
        foodReceived.add(food);

        counter ++;
      }
    }

    setState(() {});
  }

  void _setFoodsOnShared() async {
    final prefs = await SharedPreferences.getInstance();

    for (int counter=0; counter < foodReceived.length; counter++) {
      String food = jsonEncode(foodReceived[counter]).toString();

      await prefs.setString('save.food.$counter', food);
    }
  }
}
