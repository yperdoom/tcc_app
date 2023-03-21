// ignore_for_file: use_build_context_synchronously

import 'package:app_tcc/views/ip_select.dart';
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

    if (scope == 'client') {
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
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: const Center(
        child: CircularProgressIndicator(
          color: Color(0xff1E4CFF),
        ),
      ),
    );
  }
}

// class DarkThemePreference {
//   static const themeStatus = "THEMESTATUS";

//   setDarkTheme(bool value) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setBool(themeStatus, value);
//   }

//   Future<bool> getTheme() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getBool(themeStatus) ?? false;
//   }
// }

// class DarkThemeProvider with ChangeNotifier {
//   DarkThemePreference darkThemePreference = DarkThemePreference();
//   bool _darkTheme = false;

//   bool get darkTheme => _darkTheme;

//   set darkTheme(bool value) {
//     _darkTheme = value;
//     darkThemePreference.setDarkTheme(value);
//     notifyListeners();
//   }
// }
