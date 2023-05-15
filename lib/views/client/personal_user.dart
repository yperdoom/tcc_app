// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../configs/colors.dart';
import '../../configs/session.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

String baseUrl = Session.baseUrl;

class PersonalUser extends StatefulWidget {
  const PersonalUser({super.key});

  @override
  State<PersonalUser> createState() => _PersonalUserState();
}

class _PersonalUserState extends State<PersonalUser> {
  var userReceived = {};
  var userUpdate = {};
  bool errorPhone = false;
  bool errorDocument = false;
  var statesReceived = [
    {"code": 1, "value": "AC", "name": "Acre"},
    {"code": 2, "value": "AL", "name": "Alagoas"},
    {"code": 3, "value": "AP", "name": "Amapá"},
    {"code": 4, "value": "AM", "name": "Amazonas"},
    {"code": 5, "value": "BA", "name": "Bahia"},
    {"code": 6, "value": "CE", "name": "Ceará"},
    {"code": 7, "value": "DF", "name": "Distrito Federal"},
    {"code": 8, "value": "ES", "name": "Espírito Santo"},
    {"code": 9, "value": "GO", "name": "Goiás"},
    {"code": 10, "value": "MA", "name": "Maranhão"},
    {"code": 11, "value": "MT", "name": "Mato Grosso"},
    {"code": 12, "value": "MS", "name": "Mato Grosso do Sul"},
    {"code": 13, "value": "MG", "name": "Minas Gerais"},
    {"code": 14, "value": "PA", "name": "Pará"},
    {"code": 15, "value": "PB", "name": "Paraíba"},
    {"code": 16, "value": "PR", "name": "Paraná"},
    {"code": 17, "value": "PE", "name": "Pernambuco"},
    {"code": 18, "value": "PI", "name": "Piauí"},
    {"code": 19, "value": "RJ", "name": "Rio de Janeiro"},
    {"code": 20, "value": "RN", "name": "Rio Grande do Norte"},
    {"code": 21, "value": "RS", "name": "Rio Grande do Sul"},
    {"code": 22, "value": "RO", "name": "Rondônia"},
    {"code": 23, "value": "RR", "name": "Roraima"},
    {"code": 24, "value": "SC", "name": "Santa Catarina"},
    {"code": 25, "value": "SP", "name": "São Paulo"},
    {"code": 26, "value": "SE", "name": "Sergipe"},
    {"code": 27, "value": "TO", "name": "Tocantins"},
  ];
  var sexReceived = [
    {"code": 1, "value": "male", "name": "Masculino"},
    {"code": 2, "value": "female", "name": "Feminino"},
  ];

  @override
  void initState() {
    print(Session.firstAcessUser);
    Session.firstAcessUser ? _getUser() : _getUserOnShared();

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
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 50, bottom: 12),
                        child: Text(
                          'Informações Pessoais',
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
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    top: 5,
                    bottom: 8,
                    right: 10,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              'Bem vindo ${userReceived['name']}, nesta tela você poderá controlar todas as informações referente a sua conta.',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Expanded(
                            child: AutoSizeText(
                              'Informações cadastradas: ',
                              style: TextStyle(fontSize: 18),
                              maxLines: 1,
                              minFontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              'E-mail cadastrado: ${userReceived['email']}',
                              style: const TextStyle(fontSize: 18),
                              maxLines: 1,
                              minFontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              'Telefone cadastrado: ${_regexPhone()}',
                              style: const TextStyle(fontSize: 18),
                              maxLines: 1,
                              minFontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              'Documento cadastrado: ${_regexDocument()}',
                              style: const TextStyle(fontSize: 18),
                              maxLines: 1,
                              minFontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              'Cidade cadastrada: ${userReceived['city']} - ${userReceived['state']}',
                              style: const TextStyle(fontSize: 18),
                              maxLines: 1,
                              minFontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              'Aniversário cadastrado: ${_regexBirthday()}',
                              style: const TextStyle(fontSize: 18),
                              maxLines: 1,
                              minFontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () => _editUser(),
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
                                'Editar cadastro',
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
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                _logout();
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all(Cores.redExit),
                                textStyle: MaterialStateProperty.all(
                                  TextStyle(
                                    color: Cores.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Sair',
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
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('scope');
    await prefs.remove('userid');
    await prefs.remove('save.user');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainPage(),
      ),
    );
  }

  void _editUser() async {
    bool isMale;
    if (userReceived['client']['sex'] == 'male') {
      isMale = true;
    } else {
      isMale = false;
    }

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
                          'Editar informações: ',
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
                            userUpdate['name'] = value;
                          },
                          maxLength: 30,
                          controller:
                              TextEditingController(text: userReceived['name']),
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
                            userUpdate['email'] = value;
                          },
                          maxLength: 30,
                          controller: TextEditingController(
                              text: userReceived['email']),
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
                        child: errorPhone
                            ? TextField(
                                decoration: InputDecoration(
                                  icon: const Icon(Icons.phone_iphone_outlined),
                                  label: const Text('Telefone'),
                                  labelStyle: TextStyle(
                                    color: Cores.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                  errorText: 'Tamanho mínimo não atingido',
                                  border: const OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  userUpdate['phone'] = value;
                                  if (value.length == 11) {
                                    errorPhone = false;
                                    Navigator.pop(context);
                                    _editUser();
                                  }
                                },
                                maxLength: 11,
                                controller: TextEditingController(
                                    text: userReceived['phone']),
                                keyboardType: TextInputType.phone,
                              )
                            : TextField(
                                decoration: InputDecoration(
                                  icon: const Icon(Icons.phone_iphone_outlined),
                                  label: const Text('Telefone'),
                                  labelStyle: TextStyle(
                                    color: Cores.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                  border: const OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  userUpdate['phone'] = value;
                                  if (value.length == 11) {
                                    errorPhone = false;
                                    Navigator.pop(context);
                                    _editUser();
                                  }
                                },
                                maxLength: 11,
                                controller: TextEditingController(
                                    text: userReceived['phone']),
                                keyboardType: TextInputType.phone,
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: errorDocument
                            ? TextField(
                                decoration: InputDecoration(
                                  icon: const Icon(Icons.contacts_outlined),
                                  label: const Text('Documento'),
                                  labelStyle: TextStyle(
                                    color: Cores.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                  errorText: 'Tamanho mínimo não atingido',
                                  border: const OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  userUpdate['document'] = value;
                                  if (value.length == 11 || value.isEmpty) {
                                    errorDocument = false;
                                    Navigator.pop(context);
                                    _editUser();
                                  }
                                },
                                maxLength: 11,
                                controller: TextEditingController(
                                    text: userReceived['document']),
                                keyboardType: TextInputType.number,
                              )
                            : TextField(
                                decoration: InputDecoration(
                                  icon: const Icon(Icons.contacts_outlined),
                                  label: const Text('Documento'),
                                  labelStyle: TextStyle(
                                    color: Cores.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                  border: const OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  userUpdate['document'] = value;
                                  if (value.length == 11 || value.isEmpty) {
                                    errorDocument = false;
                                    Navigator.pop(context);
                                    _editUser();
                                  }
                                },
                                maxLength: 11,
                                controller: TextEditingController(
                                    text: userReceived['document']),
                                keyboardType: TextInputType.number,
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
                            icon: isMale
                                ? const Icon(Icons.male_outlined)
                                : const Icon(Icons.female_outlined),
                            label: const Text('Sexo'),
                            labelStyle: TextStyle(
                              color: Cores.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          isExpanded: true,
                          value: userReceived['client']['sex'],
                          items:
                              sexReceived.map<DropdownMenuItem<Object>>((sexo) {
                            return DropdownMenuItem(
                              value: sexo['value'],
                              child: Text('${sexo['name']}'),
                            );
                          }).toList(),
                          hint: const Text('Selecione um sexo'),
                          onChanged: (newValue) {
                            userUpdate['client']['sex'] = newValue;
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
                            userUpdate['city'] = value;
                          },
                          maxLength: 30,
                          controller:
                              TextEditingController(text: userReceived['city']),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<Object>(
                          decoration: InputDecoration(
                            label: const Text('Estado'),
                            labelStyle: TextStyle(
                              color: Cores.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          isExpanded: true,
                          value: userReceived['state'],
                          items: statesReceived
                              .map<DropdownMenuItem<Object>>((estado) {
                            return DropdownMenuItem(
                              value: estado['value'],
                              child: Text('${estado['value']}'),
                            );
                          }).toList(),
                          hint: const Text('Selecione um estado'),
                          onChanged: (newValue) {
                            userUpdate['state'] = newValue;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 80,
                        width: 300,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: DateTime.parse(
                              userReceived['birthday'].toString()),
                          onDateTimeChanged: (newBirthdayDate) {
                            setState(() {
                              userUpdate['birthday'] = newBirthdayDate.toUtc();
                            });
                          },
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
                          onPressed: () => {_saveUser()},
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

  String _regexBirthday() {
    if (userReceived['birthday'] != null) {
      DateTime birthday = DateTime.parse(userReceived['birthday'].toString());
      String formattedBirthday = '';

      formattedBirthday = '${birthday.day}/${birthday.month}/${birthday.year}';

      return formattedBirthday;
    } else {
      return '08/08/2008';
    }
  }

  String _regexPhone() {
    String phone = userReceived['phone'].toString();
    String formattedPhone = '1234';

    if (phone.length == 11) {
      formattedPhone =
          '(${phone[0]}${phone[1]})${phone[2]} ${phone[3]}${phone[4]}${phone[5]}${phone[6]}-${phone[7]}${phone[8]}${phone[9]}${phone[10]}';
    }

    return formattedPhone;
  }

  String _regexDocument() {
    String document = userReceived['document'].toString();
    String formattedDocument = '';

    if (document.length == 11) {
      formattedDocument =
          '${document[0]}${document[1]}${document[2]}.${document[3]}${document[4]}${document[5]}.${document[6]}${document[7]}${document[8]}-${document[9]}${document[10]}';
    }

    return formattedDocument;
  }

  void _saveUser() async {
    if (userUpdate['document'] == null) { userUpdate['document'] = ''; }
    print(userUpdate['document']);

    if (userUpdate['phone'] == null || userUpdate['phone'].length < 11) {
      errorPhone = true;
    }
    if (userUpdate['document'].length > 0 && userUpdate['document'].length < 11) {
      errorDocument = true;
    }
    if (errorDocument == true || errorPhone == true) {
      Navigator.pop(context);
      _editUser();
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Cores.redError),
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: const Text(
                    'Confira as informações inseridas e tente novamente',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                    textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      );
    } else {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token').toString();
      if (Session.userId == '') {
        Session.userId = prefs.getString('userid').toString();
      }

      if (Session.env == 'local') {
        userReceived = userUpdate;
        Navigator.pop(context);
        setState(() {});
      } else {
        Map<String, String> headers = <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        };

        print(userUpdate);

        Object userToUpdate = jsonEncode({
          'client_id': userUpdate['client']['client_id'],
          'name': userUpdate['name'],
          'phone': userUpdate['phone'],
          'document': userUpdate['document'],
          'sex': userUpdate['client']['sex'],
          'city': userUpdate['city'],
          'state': userUpdate['state'],
          'birthday': _regexBirthday(),
          'age': userUpdate['client']['age'],
          'height': userUpdate['client']['height'],
          'weight': userUpdate['client']['weight'],
          'fat_percentage': userUpdate['client']['fat_percentage'],
        });

        http.Response response = await http.put(
          Uri.parse('$baseUrl/user/client/${Session.userId}'),
          headers: headers,
          body: userToUpdate,
        );
        var body = await jsonDecode(response.body);

        print(body);
        if (body['success'] == true) {
          userReceived = body['body'];
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(10),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Cores.blue),
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                    child: const Text(
                      'Usuário editado com sucesso!',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
    }
  }

  void _getUser() async {
    errorDocument == false;
    errorPhone == false;

    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token').toString();
    if (Session.userId == '') {
      Session.userId = prefs.getString('userid').toString();
    }

    if (Session.env == 'local') {
      var user = {
        "user_id": 2,
        "name": "Pedro",
        "email": "pedro.tepo@mail.com",
        "password": "dasdasad",
        "scope": "client",
        "phone": "54211111111",
        "document": "00011122254",
        "city": "Nonoai",
        "state": "RS",
        "birthday": DateTime.utc(2000, 09, 08),
        "updated_at": "05/10/2020 05:07"
      };

      userReceived = user;
    } else {
      http.Response response = await http.get(
        Uri.parse('$baseUrl/user/client/${Session.userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
      );

      var body = await jsonDecode(response.body);

      if (body.isNotEmpty) {
        userReceived = body['body'];

        userUpdate = userReceived;
        _setUserOnShared();
      }

      setState(() {});
    }
    Session.firstAcessUser = false;
    prefs.setString('firstacessuser', 'false');
  }

  void _getUserOnShared() async {
    final prefs = await SharedPreferences.getInstance();

    String? infoString = prefs.getString('save.user');
    var user = jsonDecode(infoString.toString());

    if (user != null) {
      userReceived = user;
    } else {
      _getUser();
    }

    setState(() {});
  }

  void _setUserOnShared() async {
    final prefs = await SharedPreferences.getInstance();

    String user = jsonEncode(userReceived).toString();

    await prefs.setString('save.user', user);
  }
}
