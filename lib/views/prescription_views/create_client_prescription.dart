// ignore_for_file: use_build_context_synchronously

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
                          },
                          maxLength: 30,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
