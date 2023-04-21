// ignore_for_file: use_build_context_synchronously

import 'package:app_tcc/configs/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/login.dart';
import 'views/client_page.dart';
import 'views/admin.dart';
import 'configs/session.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'APP TCC',
      theme: Session.darkMode ? ThemeData.dark() : ThemeData.light(),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  bool knoowToken = false;

  void verificationToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    String? firstAcess = prefs.getString('firstAcess');
    bool? darkMode = prefs.getBool('darkMode');
    String? url = prefs.getString('url');
    String? env = prefs.getString('env');

    if (firstAcess == null) {
      await switchLigthTheme();
    }

    if (darkMode == false) {
      Session.darkMode = false;
    }

    if (url != null) {
      Session.baseUrl = url.toString();
    }

    if (env != null) {
      Session.env = env.toString();
    }

    // await Future.delayed(const Duration(seconds: 2));

    if (token == null || token.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
    final String? scope = prefs.getString('scope');

    if (scope == null || scope.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }

    if (scope == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminPage()),
      );
    }

    if (scope == 'manager') {}

    if (scope == 'client' || scope == 'trying') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ClientPage()),
      );
    }
  }

  @override
  void initState() {
    verificationToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Cores.black,
      ),
      backgroundColor: Cores.black,
      body: Center(
        child: CircularProgressIndicator(
          color: Cores.blueHeavy,
        ),
      ),
    );
  }

  Future<dynamic> switchLigthTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Bem vindo ao app nutricional, neste momento pedimos que informe com qual tema deseja utilizar nosso APP, mas lembre-se que essa configuração pode ser alterada mais tarde.',
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async => {
                        await prefs.setString('firstAcess', 'não'),
                        await prefs.setBool('darkMode', false),
                        Navigator.pop(context)
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        textStyle: MaterialStateProperty.all(
                          TextStyle(
                            color: Cores.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      child: Text(
                        'Light',
                        style: TextStyle(
                          color: Cores.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async => {
                        await prefs.setString('firstAcess', 'não'),
                        await prefs.setBool('darkMode', true),
                        Navigator.pop(context)
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                        textStyle: MaterialStateProperty.all(
                          TextStyle(
                            color: Cores.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      child: Text(
                        'Dark',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
    );
  }
}
