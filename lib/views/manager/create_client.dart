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

class CreateClient extends StatefulWidget {
  const CreateClient({super.key});

  @override
  State<CreateClient> createState() => _CreateClientState();
}

class Food {
  final int? food_id;
  final String? name;
  final bool? selected;

  Food({
    required this.food_id,
    required this.name,
    this.selected = false,
  });
}

class _CreateClientState extends State<CreateClient> {
  var prescriptionsReceived = [];
  var payloadToAdapter = {};
  var mealsReceived = [];
  var foodsReceived = [];
  List<Food> foodsSelected = [];
  int foodAmount = 0;

  @override
  void initState() {
    _getFoodsOnShared();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    prescriptionsReceived = List<dynamic>.from(
      jsonDecode(
        jsonEncode(arguments),
      ),
    );
    final _foods = foodsSelected
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
          'Adaptar refeição',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
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
                        payloadToAdapter['name'] = value;
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
                      items: prescriptionsReceived.map<DropdownMenuItem<Object>>((prescription) {
                        return DropdownMenuItem(
                          value: prescription['_id'],
                          child: Text('${prescription['name']} - ${prescription['recommended_calorie']} kcal'),
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
                      items: mealsReceived.map<DropdownMenuItem<Object>>((meal) {
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                  child: AutoSizeText(
                    'Selecione: $foodAmount alimento(s).',
                    style: TextStyle(fontSize: 18),
                    maxLines: 1,
                    minFontSize: 12,
                  ),
                )
              ]),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: MultiSelectDialogField(
                  items: _foods,
                  title: const Text("Alimentos"),
                  selectedColor: Cores.blue,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    border: Border.all(
                      color: Cores.grey,
                      width: 2,
                    ),
                  ),
                  buttonIcon: Icon(
                    Icons.pets,
                    color: Cores.grey,
                  ),
                  unselectedColor: Cores.grey,
                  itemsTextStyle: TextStyle(color: Cores.white),
                  selectedItemsTextStyle: TextStyle(color: Cores.blueOpaque),
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
                    payloadToAdapter['foods'] = foods;
                  },
                ),
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
                      onPressed: () => _adapter(),
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

  void _adapter() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token').toString();
    if (Session.userId == '') {
      Session.userId = prefs.getString('userid').toString();
    }

    if (Session.env == 'local') {
      const meals = [];

      prescriptionsReceived = meals;
    } else {
      Map<String, String> headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      };

      Object prescriptionToAdapter = jsonEncode({
        "foods": payloadToAdapter['foods'],
        "mealId": payloadToAdapter['meal_id'],
        "prescriptionId": payloadToAdapter['prescription_id'],
        "name": payloadToAdapter['name'],
        "type": payloadToAdapter['type'],
        "userId": Session.userId,
      });

      http.Response response = await http.post(
        Uri.parse('$baseUrl/prescription/adapter'),
        headers: headers,
        body: prescriptionToAdapter,
      );
      var body = await jsonDecode(response.body);

      print(body);

      if (body['success'] == true) {
        Navigator.pop(context);
        popup(context, false, 'Adaptação feita com sucesso!');
      } else {
        prescriptionsReceived = [];
        popup(context, true, 'Houve um erro ao criar essa adaptação!\n ${body['message'].toString()}!');
      }
    }
    Session.firstAcessHome = false;
    prefs.setString('firstacesshome', 'false');
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
        payloadToAdapter['type'] = mealsReceived[i]['type'];
        foodAmount = mealsReceived[i]['food_amount'];
      }
    }
    setState(() {});
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
          name: foodsReceived[i]['name'],
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
