import 'dart:convert';

import 'package:Yan/components/foods_listed.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../configs/colors.dart';
import '../../configs/session.dart';

import '../../interfaces/get_foods.dart';

String baseUrl = Session.baseUrl;

class FoodUser extends StatefulWidget {
  const FoodUser({super.key});

  @override
  State<FoodUser> createState() => _FoodUserState();
}

class _FoodUserState extends State<FoodUser> {
  var foodReceived = [];
  String search = '';

  @override
  void initState() {
    Session.firstAcessFood ? getFoods('') : _getFoodsOnShared();

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
                            onChanged: (value) => {
                              search = value
                            },
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
                            getFoods(search)
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
          foodsListed(foodReceived),
        ],
      ),
    );
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
}
