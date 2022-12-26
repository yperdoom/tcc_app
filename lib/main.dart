import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'admin.dart';

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
  bool loading = false;

  void verificationToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    print(token);

    loading = true;
    await Future.delayed(const Duration(seconds: 2));

    if (token == null || token.isEmpty) {
      loading = false;
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
    final String? scope = prefs.getString('scope');

    if (scope == null || scope.isEmpty) {
      loading = false;
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }

    if (scope == 'admin') {
      loading = false;
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminPage()),
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
        title: const Text('loading'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
