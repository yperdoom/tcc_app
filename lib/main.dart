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
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
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
    String? url = prefs.getString('url');
    String? env = prefs.getString('env');
    String? firstAcessInfo = prefs.getString('firstacessinfo');
    String? firstAcessHome = prefs.getString('firstacesshome');
    String? firstAcessFood = prefs.getString('firstacessfood');
    String? firstAcessUser = prefs.getString('firstacessuser');

    if (url != null) {
      Session.baseUrl = url.toString();
    }

    if (env != null) {
      Session.env = env.toString();
    }

    if (firstAcessInfo != null) {
      if (firstAcessInfo.toString() == 'true') {
        Session.firstAcessInfo = true;
      }
    } else {
      Session.firstAcessInfo = true;
    }
    if (firstAcessHome != null) {
      if (firstAcessHome.toString() == 'true') {
        Session.firstAcessHome = true;
      }
    } else {
      Session.firstAcessHome = true;
    }
    if (firstAcessFood != null) {
      if (firstAcessFood.toString() == 'true') {
        Session.firstAcessFood = true;
      }
    } else {
      Session.firstAcessFood = true;
    }
    if (firstAcessUser != null) {
      if (firstAcessUser.toString() == 'true') {
        Session.firstAcessUser = true;
      }
    } else {
      Session.firstAcessUser = true;
    }

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
}
