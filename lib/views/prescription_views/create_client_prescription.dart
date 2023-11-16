// ignore_for_file: use_build_context_synchronously

import 'package:Yan/views/prescription_views/create_client_meal.dart';
import 'package:flutter/material.dart';
import '../../configs/colors.dart';
import '../../configs/session.dart';

String baseUrl = Session.baseUrl;
var prescription = {};

class CreateClientPrescription extends StatefulWidget {
  const CreateClientPrescription({super.key});

  @override
  State<CreateClientPrescription> createState() =>
      _CreateClientPrescriptionState();
}

class _CreateClientPrescriptionState extends State<CreateClientPrescription> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Criar prescrição diária',
          style: TextStyle(fontSize: 18),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 100,
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
                            prescription['name'] = value;
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
                            icon: const Icon(Icons.numbers_outlined),
                            label: const Text('Quantidade de prescrições'),
                            labelStyle: TextStyle(
                              color: Cores.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            prescription['meal_amount'] = int.parse(value);
                            setState(() {});
                          },
                          maxLength: 30,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: prescription['meal_amount'] ?? 0,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Refeição ${index + 1}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                textStyle: MaterialStateProperty.all(
                                  const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateClientMeal(),
                                    settings:
                                        RouteSettings(arguments: index + 1),
                                  ),
                                );
                              },
                              child: Text(
                                'Criar conta',
                                style: TextStyle(
                                  color: Cores.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
