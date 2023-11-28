// ignore_for_file: use_build_context_synchronously

import 'package:Yan/components/text_field_decoration.dart';
import 'package:Yan/interfaces/get_managers.dart';
import 'package:Yan/views/main_pages/client_page.dart';
import 'package:Yan/views/main_pages/create_account.dart';
import 'package:Yan/views/main_pages/ip_select.dart';
import 'package:Yan/views/main_pages/manager_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../components/popup_error.dart';
import '../../configs/colors.dart';
import '../../configs/session.dart';
import 'admin_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

String baseUrl = Session.baseUrl;
String env = Session.env;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  String emailTemporary = '';
  String passwordTemporary = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Cores.black,
      ),
      body: Container(
        height: double.maxFinite,
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                color: Cores.black,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Imagem da unoesc
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onLongPress: () {
                            setState(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const IpSelectPage(),
                                ),
                              );
                            });
                          },
                          child: Image.asset(
                            'assets/images/branco.png',
                            width: 200,
                            height: 80,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Mensagem de boas vindas
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Oi, bem vindo :)',
                          style: TextStyle(
                            color: Cores.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                    Form(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 15),
                          // Email set field
                          TextField(
                            decoration: textFieldDecoration('E-mail'),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: _setEmail,
                          ),
                          const SizedBox(height: 15),
                          // Senha set field
                          TextField(
                            obscureText: true,
                            decoration: textFieldDecoration('Senha'),
                            keyboardType: TextInputType.text,
                            onChanged: _setPassword,
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                              _createAccount(context);
                            },
                            child: Text(
                              'Criar conta',
                              style: TextStyle(
                                color: Cores.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 130,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () => _login(context),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                  Cores.blue,
                                ),
                                textStyle: MaterialStateProperty.all(
                                  TextStyle(
                                    color: Cores.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Entrar',
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
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Desenvolvido por Pedro Henrique Antunes Pinto',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 16,
                      color: Cores.white,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void _tryApp() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('token', 'j12hd9128djh12id3i2h923');
  //   await prefs.setString('scope', 'trying');
  //   await prefs.setString('env', 'local');
  //   Session.env = 'local';
  //   setState(() {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const ClientPage()),
  //     );
  //   });
  // }

  void _setEmail(String email) {
    emailTemporary = email;
  }

  void _setPassword(String password) {
    passwordTemporary = password;
  }

  void _createAccount(BuildContext context) async {
    var managers = await getManagers();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateAccountPage(),
        settings: RouteSettings(arguments: json.encode(managers)),
      ),
    );
  }

  void _login(BuildContext context) async {
    if (env == 'dev') {
      if (emailTemporary == 'admin' && passwordTemporary == 'admin') {
        _toAdminLogin('j12hd9128djh12id3i2h923', 'admin', '1');
      }
      if (emailTemporary == 'client' && passwordTemporary == 'client') {
        _toClientLogin('j12hd9128djh12id3i2h923', 'client', '1', '1');
      }
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Center(
          child: CircularProgressIndicator(
            color: Cores.blueHeavy,
          ),
        ),
      ),
    );

    Uri url = Uri.parse('$baseUrl/login');
    Map<String, String>? headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    Object? data = jsonEncode(
      <String, String>{
        'email': emailTemporary,
        'password': passwordTemporary,
      },
    );

    print(url);
    print(headers);
    print(data);

    var response = await http.post(url, headers: headers, body: data).timeout(const Duration(seconds: 10), onTimeout: () {
      return http.Response('server_error', 400);
    });

    print(response);

    if (response.statusCode == 400) {
      Navigator.pop(context);
      popupError(context, 'Houve um erro ao efetuar login em sua conta, favor contatar o administrador do sistema para que possamos resolver seu problema: (54) 9 9658-2060', 5);
    }

    var body = await jsonDecode(response.body);

    print(body);

    if (body['success'] == true) {
      if (body['scope'] == 'admin') {
        _toAdminLogin(body['token'], body['scope'], body['userId'].toString());
      } else if (body['scope'] == 'client') {
        _toClientLogin(body['token'], body['scope'], body['userId'].toString(), body['managerId'].toString());
      } else if (body['scope'] == 'manager') {
        _toManagerLogin(body['token'], body['scope'], body['userId'].toString());
      } else {
        popupError(context, 'Houve um erro ao efetuar login em sua conta, favor contatar o administrador do sistema para que possamos resolver seu problema: (54) 9 9658-2060', 5);
      }
    } else {
      Navigator.pop(context);
      popupError(context, body['message'], 2);
      // popupError(context, 'Houve um erro ao efetuar login em sua conta, favor contatar o administrador do sistema para que possamos resolver seu problema: (54) 9 9658-2060');
    }
  }

  void _toAdminLogin(String token, String scope, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('scope', scope);
    await prefs.setString('userid', userId);
    Session.userId = userId;
    setState(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminPage()),
      );
    });
  }

  void _toClientLogin(String token, String scope, String userId, String managerId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('scope', scope);
    await prefs.setString('userid', userId);
    await prefs.setString('managerid', managerId);
    Session.userId = userId;
    Session.managerId = managerId;
    setState(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ClientPage()),
      );
    });
  }

  void _toManagerLogin(String token, String scope, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('scope', scope);
    await prefs.setString('userid', userId);
    Session.userId = userId;
    setState(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ManagerPage()),
      );
    });
  }
}
