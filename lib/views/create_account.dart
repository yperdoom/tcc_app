// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:app_tcc/components/espaco.dart';
import 'package:app_tcc/components/text_field_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../configs/colors.dart';

String email = '';
String password = '';
String name = '';
String phone = '';
DateTime birthday = DateTime.now();
String age = '';
String height = '';
String weight = '';
String fatPercentage = '';
String sex = '';
String managerId = '';
var managers = [];

var sexReceived = [
  {
    "code": 1,
    "value": "male",
    "name": "Masculino"
  },
  {
    "code": 2,
    "value": "female",
    "name": "Feminino"
  },
];

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key, managers});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPage();
}

class _CreateAccountPage extends State<CreateAccountPage> {
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    managers = jsonDecode(arguments.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar uma nova conta'),
        backgroundColor: Cores.black,
      ),
      backgroundColor: Cores.black,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: createAccountForm(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final data = {
            email: email,
            password: password,
            name: name,
            phone: phone,
            birthday: birthday.toString(),
            age: age,
            height: height,
            weight: weight,
            fatPercentage: fatPercentage,
            sex: sex,
            managerId: managerId
          };

          print(data);
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => const MainPage()),
          // );
        },
        backgroundColor: Cores.blue,
        child: const Icon(Icons.create),
      ),
    );
  }
}

Widget createAccountForm(BuildContext context) {
  return Form(
    child: Column(
      children: <Widget>[
        espaco(15),
        TextField(
          decoration: textFieldDecoration('E-mail'),
          keyboardType: TextInputType.emailAddress,
          onChanged: (String text) => email = text,
        ),
        espaco(15),
        TextField(
          obscureText: true,
          decoration: textFieldDecoration('Senha'),
          keyboardType: TextInputType.text,
          onChanged: (String text) => password = text,
        ),
        espaco(15),
        TextField(
          decoration: textFieldDecoration('Nome'),
          keyboardType: TextInputType.text,
          onChanged: (String text) => name = text,
        ),
        espaco(15),
        TextField(
          decoration: textFieldDecoration('Celular'),
          keyboardType: TextInputType.phone,
          maxLength: 11,
          onChanged: (String text) => {
            phone = text
          },
        ),
        espaco(15),
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              child: Text(
                'Aniversário',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        espaco(5),
        SizedBox(
          height: 80,
          width: 300,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (newBirthdayDate) {
              birthday = newBirthdayDate.toUtc();
            },
          ),
        ),
        espaco(15),
        TextField(
          decoration: textFieldDecoration('Altura'),
          keyboardType: TextInputType.number,
          onChanged: (text) => {
            height = text
          },
        ),
        espaco(15),
        TextField(
          decoration: textFieldDecoration('Peso'),
          keyboardType: TextInputType.number,
          onChanged: (text) => {
            weight = text
          },
        ),
        espaco(15),
        TextField(
          decoration: textFieldDecoration('Porcentagem de gordura'),
          keyboardType: TextInputType.number,
          onChanged: (text) => {
            fatPercentage = text
          },
        ),
        espaco(15),
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
                items: sexReceived.map<DropdownMenuItem<Object>>((sexo) {
                  return DropdownMenuItem(
                    value: sexo['value'],
                    child: Text('${sexo['name']}'),
                  );
                }).toList(),
                hint: const Text('Selecione um sexo'),
                onChanged: (newValue) {
                  sex = newValue.toString();
                },
              ),
            ),
          ],
        ),
        espaco(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: DropdownButtonFormField<Object>(
                decoration: InputDecoration(
                  label: const Text('Nutricionista'),
                  labelStyle: TextStyle(
                    color: Cores.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                  border: const OutlineInputBorder(),
                ),
                isExpanded: true,
                items: managers.map<DropdownMenuItem<Object>>((manager) {
                  return DropdownMenuItem(
                    value: manager['_id'],
                    child: Text('${manager['name']}'),
                  );
                }).toList(),
                hint: const Text('Selecione um nutricionista'),
                onChanged: (newValue) {
                  managerId = newValue.toString();
                },
              ),
            ),
          ],
        ),
        espaco(15),
      ],
    ),
  );
}
