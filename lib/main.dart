import 'package:Yan/components/loading.dart';
import 'package:Yan/configs/colors.dart';
import 'package:Yan/components/verification_token.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      title: 'APP TCC',
      // theme: ThemeData.light(),
      theme: ThemeData.dark(),
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    verificationToken(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Cores.black,
      ),
      backgroundColor: Cores.black,
      body: Center(
        child: loading(color: Cores.blueHeavy),
      ),
    );
  }
}
