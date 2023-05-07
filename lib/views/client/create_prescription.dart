import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../configs/colors.dart';
import '../../configs/session.dart';
import 'package:http/http.dart' as http;

String baseUrl = Session.baseUrl;

class CreatePrescription extends StatefulWidget {
  const CreatePrescription({super.key});

  @override
  State<CreatePrescription> createState() => _CreatePrescriptionState();
}

class _CreatePrescriptionState extends State<CreatePrescription> {
  var prescriptionsReceived = [];
  var payloadToAdapter = {};
  var mealsReceived = [];
  var foodsReceived = [];

  @override
  void initState() {
    _getFoodsOnShared();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    prescriptionsReceived =
        List<dynamic>.from(jsonDecode(jsonEncode(arguments)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adaptar refeição', style: TextStyle(fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        icon: const Icon(Icons.person_outlined),
                        label: const Text('Nome'),
                        labelStyle: TextStyle(
                          color: Cores.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        payloadToAdapter['name'] = 'Adaptação: $value';
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
                  Expanded(
                    child: DropdownButtonFormField<Object>(
                      decoration: InputDecoration(
                        icon: const Icon(Icons.home_outlined),
                        label: const Text('Prescrição'),
                        labelStyle: TextStyle(
                          color: Cores.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      isExpanded: true,
                      items: prescriptionsReceived
                          .map<DropdownMenuItem<Object>>((prescription) {
                        return DropdownMenuItem(
                          value: prescription['_id'],
                          child: Text(
                              '${prescription['name']} - ${prescription['recommended_calorie']} kcal'),
                        );
                      }).toList(),
                      hint: const AutoSizeText(
                        'Selecione uma prescrição',
                        minFontSize: 10,
                      ),
                      onChanged: (newValue) {
                        _sendPrescription(newValue);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<Object>(
                      decoration: InputDecoration(
                        icon: const Icon(Icons.home_outlined),
                        label: const Text('Refeição'),
                        labelStyle: TextStyle(
                          color: Cores.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      isExpanded: true,
                      items:
                          mealsReceived.map<DropdownMenuItem<Object>>((meal) {
                        return DropdownMenuItem(
                          value: meal['_id'],
                          child: Text('${meal['name']} - ${meal['type']}'),
                        );
                      }).toList(),
                      hint: const AutoSizeText(
                        'Selecione uma refeição',
                        minFontSize: 10,
                      ),
                      onChanged: (newValue) {
                        _sendMeals(newValue);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<Object>(
                      decoration: InputDecoration(
                        label: const Text('Sexo'),
                        labelStyle: TextStyle(
                          color: Cores.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      isExpanded: true,
                      value: payloadToAdapter['food_id'],
                      items:
                          foodsReceived.map<DropdownMenuItem<Object>>((food) {
                        return DropdownMenuItem(
                          value: food['food_id'],
                          child: Text('${food['name']}'),
                        );
                      }).toList(),
                      hint: const Text('Selecione um sexo'),
                      onChanged: (newValue) {
                        payloadToAdapter['food_id'] = newValue;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 120,
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
                        'Cancelar',
                        style: TextStyle(
                          color: Cores.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => {},
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendPrescription(newValue) {
    for (int i = 0; i < prescriptionsReceived.length; i++) {
      if (prescriptionsReceived[i]['_id'] == newValue) {
        payloadToAdapter['prescription_id'] = prescriptionsReceived[i]['_id'];
        mealsReceived = prescriptionsReceived[i]['meals'];
      }
    }
    setState(() {});
  }

  void _sendMeals(newValue) {
    for (int i = 0; i < mealsReceived.length; i++) {
      if (mealsReceived[i]['_id'] == newValue) {
        payloadToAdapter['meal_id'] = mealsReceived[i]['_id'];
      }
    }
    setState(() {});
  }

  // void _selectFood() {
  //   print(foodsReceived[0]['food_id']);

  //   AlertDialog(
  //     title: const Text('Select Topics'),
  //     content: SingleChildScrollView(
  //       child: DropdownButtonFormField<Object>(
  //         decoration: InputDecoration(
  //           label: const Text('Sexo'),
  //           labelStyle: TextStyle(
  //             color: Cores.white,
  //             fontWeight: FontWeight.w600,
  //             fontSize: 18,
  //           ),
  //           border: const OutlineInputBorder(),
  //         ),
  //         isExpanded: true,
  //         value: foodsSelected,
  //         items: foodsReceived.map<DropdownMenuItem<Object>>((food) {
  //           return DropdownMenuItem(
  //             value: food['food_id'],
  //             child: Text('${food['name']}'),
  //           );
  //         }).toList(),
  //         hint: const Text('Selecione um sexo'),
  //         onChanged: (newValue) {
  //           foodsSelected = newValue;
  //         },
  //       ),
  //     ),
  //     actions: [
  //       ElevatedButton(
  //         onPressed: () {
  //           Navigator.pop(context);
  //         },
  //         child: const Text('Ok'),
  //       ),
  //     ],
  //   );
  // }

  // void _itemChange(var itemValue, bool isSelected) {
  //   print('flamengoooooooooooooooooooooooooooooooooo');
  //   setState(() {
  //     if (isSelected) {
  //       foodsSelected.add(itemValue['food_id']);
  //     } else {
  //       foodsSelected.remove(itemValue['food_id']);
  //     }
  //   });
  // }

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

    setState(() {});
  }
}
