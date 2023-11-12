// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../configs/colors.dart';
import '../../configs/session.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:http/http.dart' as http;

String baseUrl = Session.baseUrl;

class CreateManagerPrescription extends StatefulWidget {
  const CreateManagerPrescription({super.key});

  @override
  State<CreateManagerPrescription> createState() => _CreateManagerPrescriptionState();
}

class Food {
  final int? food_id;
  final String? name;
  final String? description;
  final bool? selected;

  Food({
    required this.food_id,
    required this.name,
    required this.description,
    this.selected = false,
  });
}

class _CreateManagerPrescriptionState extends State<CreateManagerPrescription> {
  var payloadToCreate = {};
  var mealsToCreate = [];
  var clientReceived = {};
  var prescriptionNutrients = {};
  var typesReceived = [
    {
      "code": 1,
      "value": "Lanche"
    },
    {
      "code": 2,
      "value": "Café da manhã"
    },
    {
      "code": 3,
      "value": "Café da tarde"
    },
    {
      "code": 4,
      "value": "Almoço"
    },
    {
      "code": 5,
      "value": "Janta"
    },
  ];
  var foodsReceived = [];
  List<Food> foodsSelected = [];
  int foodAmount = 0;
  bool mealAmountError = false;
  late List<MultiSelectItem<Food>> _foods;

  @override
  void initState() {
    _getFoodsOnShared();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    clientReceived = jsonDecode(
      jsonEncode(arguments),
    );

    _foods = foodsSelected
        .map(
          (food) => MultiSelectItem<Food>(
            food,
            food.name.toString(),
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Prescrever',
          style: TextStyle(fontSize: 18),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 100,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _onSave(),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            icon: const Icon(Icons.person_outlined),
                            label: const Text('Nome da prescrição'),
                            labelStyle: TextStyle(
                              color: Cores.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            payloadToCreate['name'] = value;
                          },
                          maxLength: 30,
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _verifyMealAmount(),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          _getMeals(),
        ],
      ),
    );
  }

  void _savePrescription(var meals) {
    // TO-DO

    print(meals);
    print(prescriptionNutrients);
    print(payloadToCreate); // oq eu vou mandar pra api pra salvar
    print(clientReceived); // informaçòes do cliente
    print(mealsToCreate); // oq eu vou trabalhar em cima pra mudar
  }

  Widget _getMeals() {
    if (payloadToCreate['meal_amount'] != null) {
      for (int i = 0; i < payloadToCreate['meal_amount']; i++) {
        if (mealsToCreate.length < payloadToCreate['meal_amount']) {
          mealsToCreate.add({});
        }
      }

      // retorna os cartões
      return Expanded(
        child: ListView.builder(
          itemCount: payloadToCreate['meal_amount'],
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
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    Text(
                      'Refeição ${index + 1}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              label: const Text('Nome'),
                              labelStyle: TextStyle(
                                color: Cores.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              mealsToCreate[index]['name'] = value;
                            },
                            maxLength: 30,
                            keyboardType: TextInputType.name,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<Object>(
                            decoration: InputDecoration(
                              label: const Text('Tipo de refeição'),
                              labelStyle: TextStyle(
                                color: Cores.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                              border: const OutlineInputBorder(),
                            ),
                            isExpanded: true,
                            items: typesReceived.map<DropdownMenuItem<Object>>((types) {
                              return DropdownMenuItem(
                                value: types['value'],
                                child: Text('${types['value']}'),
                              );
                            }).toList(),
                            hint: const Text('Selecione um tipo'),
                            onChanged: (newValue) {
                              mealsToCreate[index]['type'] = newValue;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
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
                          List foods = [];
                          for (int i = 0; i < results.length; i++) {
                            foods.add(results[i].food_id);
                          }
                          mealsToCreate[index]['foods'] = foods;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 300,
                          height: 70,
                          child: ElevatedButton(
                            onPressed: () async {
                              _selectFoods(index);
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

  void _selectFoods(int index) async {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Scaffold(
          body: Column(
            children: [
              _getFoods(index),
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

  Widget _getFoods(int mealIndex) {
    print(mealsToCreate[0]['nutrients']);
    print(mealsToCreate[mealIndex]['foods']);
    if (mealsToCreate[mealIndex]['foods'] != null) {
      if (mealsToCreate[mealIndex]['nutrients'] == null) {
        print('RECONHECEU QUE É NULO');
        mealsToCreate[mealIndex]['nutrients'] = [];

        for (int i = 0; i < mealsToCreate[mealIndex]['foods'].length; i++) {
          mealsToCreate[mealIndex]['nutrients'].add(0);
        }
      }
      mealsToCreate[mealIndex]['food_correspondent'] = [];

      for (int i = 0; i < mealsToCreate[mealIndex]['foods'].length; i++) {
        for (int j = 0; j < foodsReceived.length; j++) {
          if (mealsToCreate[mealIndex]['foods'][i] == foodsReceived[j]['food_id']) {
            mealsToCreate[mealIndex]['food_correspondent'].add(foodsReceived[j]);
          }
        }
      }

      print(mealsToCreate[0]['nutrients']);

      Widget visual = Expanded(
        child: ListView.builder(
          itemCount: mealsToCreate[mealIndex]['foods'].length,
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
                      '${mealsToCreate[mealIndex]['food_correspondent'][index]['description']}',
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
                            controller: TextEditingController(text: mealsToCreate[mealIndex]['nutrients'][index].toString()),
                            onChanged: (value) {
                              mealsToCreate[mealIndex]['nutrients'][index] = value;
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

  Object _calcNutriProportion(int index) {
    var meal = {};

    meal['foods'] = mealsToCreate[index]['foods'];
    meal['food_amount'] = mealsToCreate[index]['foods'].length;

    double calorie = 0;
    double carbohydrate = 0;
    double protein = 0;
    double lipid = 0;
    for (int fi = 0; fi < mealsToCreate[index]['foods'].length; fi++) {
      double nutriOfFood = double.parse(mealsToCreate[index]['nutrients'][fi]);
      int foodWeight = mealsToCreate[index]['food_correspondent'][fi]['weight'];
      double percentage = (nutriOfFood * 100) / foodWeight;

      double calorieOfFood = mealsToCreate[index]['food_correspondent'][fi]['calorie'];
      calorie += calorieOfFood * (percentage / 100);

      double carbohydrateOfFood = mealsToCreate[index]['food_correspondent'][fi]['carbohydrate'];
      carbohydrate += carbohydrateOfFood * (percentage / 100);

      double proteinOfFood = mealsToCreate[index]['food_correspondent'][fi]['protein'];
      protein += proteinOfFood * (percentage / 100);

      double lipidOfFood = mealsToCreate[index]['food_correspondent'][fi]['lipid'];
      lipid += lipidOfFood * (percentage / 100);
    }

    meal['recommended_calorie'] = calorie;
    meal['calorie'] = calorie;
    meal['recommended_protein'] = protein;
    meal['protein'] = protein;
    meal['recommended_lipid'] = lipid;
    meal['lipid'] = lipid;
    meal['recommended_carbohydrate'] = carbohydrate;
    meal['carbohydrate'] = carbohydrate;

    return meal;
  }

  void _calcPrescripNutriProportion(var meals) {
    double calorie = 0;
    double carbohydrate = 0;
    double protein = 0;
    double lipid = 0;

    for (int i = 0; i < meals.length; i++) {
      calorie += meals[i]['calorie'];
      carbohydrate += meals[i]['carbohydrate'];
      protein += meals[i]['protein'];
      lipid += meals[i]['lipid'];
    }

    prescriptionNutrients['recommended_calorie'] = calorie;
    prescriptionNutrients['recommended_carbohydrate'] = carbohydrate;
    prescriptionNutrients['recommended_protein'] = protein;
    prescriptionNutrients['recommended_lipid'] = lipid;
  }

  AutoSizeText _autoText(String message) {
    AutoSizeText autoText = AutoSizeText(
      message,
      style: TextStyle(
        fontSize: 22,
        color: Cores.white,
      ),
      maxLines: 1,
      minFontSize: 16,
      textAlign: TextAlign.center,
    );

    return autoText;
  }

  void _confirmatePopup(BuildContext context, var meals) async {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.only(
          top: 100,
          right: 30,
          left: 30,
          bottom: 150,
        ),
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _autoText('Revise os valores prescritos:'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _autoText('Calorias totais: ${prescriptionNutrients['recommended_calorie'].toStringAsFixed(2)}'),
                    // 'Refeições: ${_prepareMealMessage(meals)}',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _autoText('Carboidratos totais: ${prescriptionNutrients['recommended_carbohydrate'].toStringAsFixed(2)}'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _autoText('Proteinas totais: ${prescriptionNutrients['recommended_protein'].toStringAsFixed(2)}'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _autoText('Lipídios totais: ${prescriptionNutrients['recommended_lipid'].toStringAsFixed(2)}'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Cores.redExit),
                        textStyle: MaterialStateProperty.all(
                          TextStyle(
                            color: Cores.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Cores.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => _savePrescription(meals),
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
                        'Confirmar',
                        style: TextStyle(
                          color: Cores.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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

  // String _prepareMealMessage(var meals) {
  //   if (meals != null || meals != []) {
  //     String message = '';
  //     for (int i = 0; i < meals.length; i++) {
  //       if (meals[i] != null) {
  //         message
  //       }
  //     }
  //   }
  //   return 'Não foram encontradas refeições';
  // }

  Widget _verifyMealAmount() {
    Widget amountWidget;

    if (mealAmountError == true) {
      amountWidget = Expanded(
        child: TextField(
          decoration: InputDecoration(
            icon: const Icon(Icons.person_outlined),
            label: const Text('Quantidade de refeições'),
            errorText: 'Você precisa informar um número válido',
            labelStyle: TextStyle(
              color: Cores.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              if (int.tryParse(value) is int) {
                mealAmountError = false;
                payloadToCreate['meal_amount'] = int.tryParse(value);
              } else {
                mealAmountError = true;
              }
            });
          },
          keyboardType: TextInputType.number,
        ),
      );
    } else {
      amountWidget = Expanded(
        child: TextField(
          decoration: InputDecoration(
            icon: const Icon(Icons.person_outlined),
            label: const Text('Quantidade de refeições'),
            labelStyle: TextStyle(
              color: Cores.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              if (int.tryParse(value) is int) {
                mealAmountError = false;
                payloadToCreate['meal_amount'] = int.tryParse(value);
              } else {
                mealAmountError = true;
              }
            });
          },
          keyboardType: TextInputType.number,
        ),
      );
    }

    setState(() {});

    return amountWidget;
  }

  void _onSave() {
    var meals = [];
    for (int i = 0; i < mealsToCreate.length; i++) {
      if (mealsToCreate[i] != null) {
        meals.add(_calcNutriProportion(i));
      }
    }

    _calcPrescripNutriProportion(meals);

    _confirmatePopup(context, meals);
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
        foodsReceived.add(food);

        counter++;
      }
    }
    _initSelectedFoods();

    setState(() {});
  }

  void _initSelectedFoods() {
    for (int i = 0; i < foodsReceived.length; i++) {
      foodsSelected.add(
        Food(
          food_id: foodsReceived[i]['food_id'],
          name: foodsReceived[i]['description'],
          description: foodsReceived[i]['description'],
        ),
      );
    }
  }

  void popup(BuildContext context, bool error, String message) async {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 200,
              decoration: error
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Cores.redError,
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Text(
                message,
                style: const TextStyle(fontSize: 24, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
