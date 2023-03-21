import 'package:app_tcc/views/client_page.dart';
import 'package:app_tcc/views/ip_select.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../configs/session.dart';
import 'admin.dart';
import 'dart:async';
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
        backgroundColor: Colors.black,
      ),
      body: Container(
        height: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.bottomLeft,
            colors: <Color>[
              Color(0xff1E4CFF),
              Color(0xff517AFF),
            ],
            tileMode: TileMode.mirror,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                color: Colors.black,
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
                      children: const [
                        Text(
                          'Oi, bem vindo :)',
                          style: TextStyle(
                            color: Colors.white,
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
                            decoration: const InputDecoration(
                              label: Text('Email'),
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(),
                              hintText: 'Digite teu e-mail aqui...',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            onChanged: _setEmail,
                          ),
                          const SizedBox(height: 15),
                          // Senha set field
                          TextField(
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Senha',
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(),
                              hintText: 'Digite tua senha aqui...',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
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
                            onPressed: null,
                            child: const Text(
                              'Recuperar senha',
                              style: TextStyle(
                                color: Colors.white,
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
                                  const Color(0xFF3A62FF),
                                ),
                                textStyle: MaterialStateProperty.all(
                                  const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Entrar',
                                style: TextStyle(
                                  color: Colors.white,
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
                children: const [
                  Text(
                    'Desenvolvido por Pedro Henrique Antunes Pinto',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 16,
                      color: Colors.white,
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

  void _setEmail(String email) {
    emailTemporary = email;
  }

  void _setPassword(String password) {
    passwordTemporary = password;
  }

  void _login(BuildContext context) async {
    if (env == 'dev') {
      if (emailTemporary == 'admin' && passwordTemporary == 'admin') {
        _toAdminLogin();
      }
      if (emailTemporary == 'client' && passwordTemporary == 'client') {
        _toClientLogin();
      }
    }
    print(baseUrl);

    http.Response response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'email': emailTemporary,
          'password': passwordTemporary,
        },
      ),
    );

    print(response.body);
  }

  void _toAdminLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', 'j12hd9128djh12id3i2h923');
    await prefs.setString('scope', 'admin');
    setState(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminPage()),
      );
    });
  }

  void _toClientLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', 'j12hd9128djh12id3i2h923');
    await prefs.setString('scope', 'client');
    setState(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ClientPage()),
      );
    });
  }
}
