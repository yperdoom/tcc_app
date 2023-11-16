// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../configs/colors.dart';
import '../../configs/session.dart';

String baseUrl = Session.baseUrl;
var meal = {};
var foods = [];

class Food {
  final int? id;
  final String? foodId;
  final String? name;
  final bool? selected;

  Food({
    required this.id,
    required this.foodId,
    required this.name,
    this.selected = false,
  });
}

late List<MultiSelectItem<Food>> _foods;

class CreateClientMeal extends StatefulWidget {
  const CreateClientMeal({super.key});

  @override
  State<CreateClientMeal> createState() => _CreateClientMealState();
}

class _CreateClientMealState extends State<CreateClientMeal> {
  int index = 1;
  @override
  void initState() {
    _getFoodsOnShared();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    index = jsonDecode(
      jsonEncode(arguments),
    );

    print('OIOOOIOIOIOIOIOIOI');
    print(foods[0]);

    _foods = foods
        .map((food) => MultiSelectItem<Food>(
              Food(id: food['id'], foodId: food['foodId'], name: food['name']),
              food.name.toString(),
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Criar refeicao $index',
          style: const TextStyle(fontSize: 18),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 100,
              height: 50,
              child: ElevatedButton(
                onPressed: () => {
                  _saveMeal(context, index),
                },
                style: _buttomStyle(),
                child: Text(
                  'Salvar',
                  style: _textStyle(),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: _form(context),
            ),
          ),
        ],
      ),
    );
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
        Food foodToSave = Food(
          id: counter + 1,
          foodId: food['_id'],
          name: food['description'],
        );

        foods.add({
          'id': foodToSave.id,
          'foodId': foodToSave.foodId,
          'name': foodToSave.name,
        });

        counter++;
      }
    }

    setState(() {});
  }
}

void _saveMeal(BuildContext context, int index) async {
  final prefs = await SharedPreferences.getInstance();

  prefs.setString(
    '$index-meal_to_created',
    jsonEncode(meal).toString(),
  );
  Navigator.pop(context);
}

Widget _form(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const SizedBox(height: 5),
      _formCard('name'),
      const SizedBox(height: 10),
      _formCard('type'),
      const SizedBox(height: 10),
      _formFoodSelectCard(),
      const SizedBox(height: 10),
      _formFoodSelectedViewCard(context),
    ],
  );
}

Widget _formFoodSelectCard() {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0),
    child: MultiSelectDialogField(
      items: _foods,
      title: const Text("Alimentos"),
      selectedColor: Cores.blue,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        border: Border.all(
          color: Cores.grey,
          width: 2,
        ),
      ),
      unselectedColor: Cores.grey,
      itemsTextStyle: TextStyle(color: Cores.white),
      selectedItemsTextStyle: TextStyle(
        color: Cores.blueOpaque,
      ),
      buttonText: Text(
        "Alimentos selecionados",
        style: TextStyle(
          color: Cores.white,
          fontSize: 16,
        ),
      ),
      onConfirm: (results) {
        List foodsToSave = [];
        for (int i = 0; i < results.length; i++) {
          foodsToSave.add(results[i].foodId);
        }
        meal['foods'] = foodsToSave;
      },
    ),
  );
}

Widget _formFoodSelectedViewCard(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        width: 300,
        height: 70,
        child: ElevatedButton(
          onPressed: () async {
            _selectFoods(context);
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(Cores.blue),
            textStyle: MaterialStateProperty.all(
              TextStyle(
                color: Cores.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          child: Text(
            'Selecionar proporção dos alimentos',
            style: TextStyle(
              color: Cores.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _formCard(String field) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: TextField(
          decoration: _textFieldDecoration(_hintText(field)),
          onChanged: (value) {
            meal[field] = value;
          },
          maxLength: 30,
          keyboardType: TextInputType.text,
        ),
      ),
    ],
  );
}

String _hintText(String text) {
  if (text == 'name') {
    return 'Nome da refeicao';
  }
  if (text == 'type') {
    return 'Tipo da refeicao';
  }
  return '';
}

InputDecoration _textFieldDecoration(String text) {
  return InputDecoration(
    // icon: const Icon(Icons.person_outlined),
    label: Text(text),
    labelStyle: TextStyle(
      color: Cores.white,
      fontWeight: FontWeight.w600,
      fontSize: 18,
    ),
    border: const OutlineInputBorder(),
  );
}

ButtonStyle _buttomStyle() {
  return ButtonStyle(
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
    ),
    backgroundColor: MaterialStateProperty.all(Cores.blue),
    textStyle: MaterialStateProperty.all(
      TextStyle(
        color: Cores.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

TextStyle _textStyle() {
  return TextStyle(
    color: Cores.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
}

void _selectFoods(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(10),
      child: Scaffold(
        body: Column(
          children: [
            _getFoods(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 100,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Cores.blue),
                        textStyle: MaterialStateProperty.all(
                          TextStyle(
                            color: Cores.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      child: Text(
                        'Salvar',
                        style: TextStyle(
                          color: Cores.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _getFoods() {
  print(meal['nutrients']);
  print(meal['foods']);
  if (meal['foods'] != null) {
    if (meal['nutrients'] == null) {
      print('RECONHECEU QUE É NULO');
      meal['nutrients'] = [];

      for (int i = 0; i < meal['foods'].length; i++) {
        meal['nutrients'].add(0);
      }
    }
    meal['food_correspondent'] = [];

    for (int i = 0; i < meal['foods'].length; i++) {
      for (int j = 0; j < foods.length; j++) {
        if (meal['foods'][i] == foods[j]['food_id']) {
          meal['food_correspondent'].add(foods[j]);
        }
      }
    }

    print(meal['nutrients']);

    Widget visual = Expanded(
      child: ListView.builder(
        itemCount: meal['foods'].length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(
                left: 12,
                bottom: 10,
                top: 15,
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
                  Text(
                    '${meal['food_correspondent'][index]['description']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            label: const Text('Quantidade deste alimento'),
                            labelStyle: TextStyle(
                              color: Cores.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          controller: TextEditingController(
                            text: meal['nutrients'][index].toString(),
                          ),
                          onChanged: (value) {
                            meal['nutrients'][index] = value;
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );

    return visual;
  }

  return Expanded(
    child: Text(
      'Nenhum alimento foi selecionado :(',
      style: TextStyle(
        color: Cores.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
