import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  var prescriptionReceived = [];

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
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
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
          _findList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMeal,
        backgroundColor: const Color(0xff1E4CFF),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _findList() {
    _getMeals();

    if (mealReceived.isNotEmpty) {
      // retorna os cartões
      return Expanded(
        child: ListView.builder(
          itemCount: mealReceived.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _editMeals(index),
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

  Future<dynamic> _editMeals(var index) async {
    var prescriptionUpdated = {};

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
                children: [],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _getMeals() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token').toString();
    if (Session.userId == '') {
      Session.userId = prefs.getString('userid').toString();
    }

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
        Uri.parse('$baseUrl/prescription/${Session.userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
      );
      var body = await jsonDecode(response.body);

      print(body);

      if (body['success'] == true) {
        if (body['body'] > 0) {
          mealReceived = body['body'];
        }
      } else {
        mealReceived = [];
      }
    }
  }

  Future<dynamic> _addMeal() async {
    var prescriptionUpdated = {};

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Expanded(
                        child: AutoSizeText(
                          'Adaptar refeição: ',
                          style: TextStyle(fontSize: 18),
                          maxLines: 1,
                          minFontSize: 12,
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
                            label: const Text('Prescrição'),
                            labelStyle: TextStyle(
                              color: Cores.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          isExpanded: true,
                          value: prescriptionUpdated['state'],
                          items: prescriptionReceived.map<DropdownMenuItem<Object>>((estado) {
                            return DropdownMenuItem(
                              value: estado['value'],
                              child: Text('${estado['value']}'),
                            );
                          }).toList(),
                          hint: const Text('Selecione uma prescrição'),
                          onChanged: (newValue) {
                            prescriptionUpdated['state'] = newValue;
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
                            prescriptionUpdated['name'] = value;
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
                        child: TextField(
                          decoration: InputDecoration(
                            icon: const Icon(Icons.mail_outlined),
                            label: const Text('E-mail'),
                            labelStyle: TextStyle(
                              color: Cores.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            prescriptionUpdated['email'] = value;
                          },
                          maxLength: 30,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          decoration: InputDecoration(
                            icon: const Icon(Icons.home_outlined),
                            label: const Text('Cidade'),
                            labelStyle: TextStyle(
                              color: Cores.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            prescriptionUpdated['city'] = value;
                          },
                          maxLength: 30,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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
                            backgroundColor:
                                MaterialStateProperty.all(Cores.blue),
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
                            backgroundColor:
                                MaterialStateProperty.all(Cores.blue),
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
        ),
      ),
    );
  }
}
