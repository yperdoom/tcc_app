import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../configs/colors.dart';
import '../../configs/session.dart';
import 'package:http/http.dart' as http;

String baseUrl = Session.baseUrl;

class FoodManager extends StatefulWidget {
  const FoodManager({super.key});

  @override
  State<FoodManager> createState() => _FoodManagerState();
}

class _FoodManagerState extends State<FoodManager> {
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
                              prefixIcon: Icon(Icons.search_rounded, color: Cores.white),
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
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
              onTap: () => showFoodDetails(index),
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
                decoration: BoxDecoration(color: Cores.blueDark, borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            '${foodReceived[index]['name']}',
                            style: TextStyle(
                              fontSize: 24,
                              color: Cores.white,
                            ),
                            maxLines: 1,
                            minFontSize: 18,
                          ),
                        ),
                        Text(
                          '${foodReceived[index]['type']}',
                          style: TextStyle(
                            color: Cores.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            '${foodReceived[index]['description']}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Cores.white,
                            ),
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
                        Text(
                          '${foodReceived[index]['calorie']} Kcal em ${foodReceived[index]['weight']}g',
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

  Future<dynamic> showFoodDetails(var index) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: const [
                      Expanded(
                        child: AutoSizeText(
                          'Abaixo verá informações sobre o alimento selecionado:',
                          style: TextStyle(fontSize: 18),
                          maxLines: 2,
                          minFontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          '${foodReceived[index]['name']}',
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AutoSizeText(
                          '${foodReceived[index]['type']}',
                          style: const TextStyle(fontSize: 18),
                          maxLines: 1,
                          minFontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          '${foodReceived[index]['description']}',
                          style: const TextStyle(fontSize: 18),
                          maxLines: 1,
                          minFontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          'Calorias: ${foodReceived[index]['calorie']} Kcal',
                          style: const TextStyle(fontSize: 18),
                          maxLines: 1,
                          minFontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          'Carboidratos: ${foodReceived[index]['carbohydrate']}g',
                          style: const TextStyle(fontSize: 18),
                          maxLines: 1,
                          minFontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          'Proteinas: ${foodReceived[index]['protein']}g',
                          style: const TextStyle(fontSize: 18),
                          maxLines: 1,
                          minFontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          'Lipídios: ${foodReceived[index]['lipid']}g',
                          style: const TextStyle(fontSize: 18),
                          maxLines: 1,
                          minFontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          _getMedidaBase(index),
                          style: const TextStyle(fontSize: 16),
                          maxLines: 1,
                          minFontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      AutoSizeText(
                        'Última vez atualizado em:',
                        style: TextStyle(fontSize: 18),
                        maxLines: 1,
                        minFontSize: 12,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        _regexDateTime(index),
                        style: const TextStyle(fontSize: 18),
                        maxLines: 1,
                        minFontSize: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getMedidaBase(int index) {
    if (foodReceived[index]['weight'] != null) {
      return 'Peso base: ${foodReceived[index]['weight']}g';
    }

    if (foodReceived[index]['portion'] != null) {
      return 'Porções base: ${foodReceived[index]['portion']}';
    }

    if (foodReceived[index]['mililiter'] != null) {
      return 'Litragem base: ${foodReceived[index]['mililiter']}ml';
    }
    return 'Não foi possível identificar o tipo de quantificação base utilizada nesse alimento!';
  }

  void _getFoods() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token').toString();
    if (Session.userId == '') {
      Session.userId = prefs.getString('userid').toString();
    }

    if (Session.env == 'local') {
      const foods = [];

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

      String formattedTime = '${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
      String formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      formattedDateTime = '$formattedDate às $formattedTime';

      return formattedDateTime;
    } else {
      return '06/05/2020 às 00:00:00';
    }
  }

  void _getFoodsOnShared() async {
    final prefs = await SharedPreferences.getInstance();
    int? foodLength = prefs.getInt('save.food.length');

    if (foodLength != null) {
      for (int counter = 0; counter <= foodLength; counter++) {
        String? foodString = prefs.getString('save.food.$counter');
        var food = jsonDecode(foodString.toString());

        if (food == null) {
          await prefs.setInt('save.food.length', counter - 1);
        } else {
          foodReceived.add(food);
        }
      }
    } else {
      int counter = 0;
      while (counter >= 0) {
        String? foodString = prefs.getString('save.food.$counter');
        var food = jsonDecode(foodString.toString());

        if (food == null) {
          counter = -1;
        } else {
          foodReceived.add(food);

          counter++;
        }
      }
    }

    setState(() {});
  }

  void _setFoodsOnShared() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(
      'save.food.length',
      foodReceived.length - 1,
    );
    for (int counter = 0; counter < foodReceived.length; counter++) {
      String food = jsonEncode(
        foodReceived[counter],
      ).toString();

      await prefs.setString('save.food.$counter', food);
    }
  }
}
