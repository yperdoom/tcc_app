import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class IpSelectPage extends StatefulWidget {
  const IpSelectPage({super.key});

  @override
  State<IpSelectPage> createState() => _IpSelectPage();
}

class _IpSelectPage extends State<IpSelectPage> {
  String url_actualy = 'https://tcc2.pedro/api';
  String url_digitada = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IP select Page'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                label: Text('Url'),
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
              onChanged: syncUrl,
            ),
            Text(
              url_digitada,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(
              width: 130,
              height: 50,
              child: ElevatedButton(
                onPressed: () => setUrl,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.pop(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.login_outlined),
      ),
    );
  }

  syncUrl(String url) {
    url_digitada = url;
  }

  void setUrl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('url', url_digitada);
    setState(() {});
    getUrl();
  }

  getUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final url = await prefs.getString('url');
    url_actualy = url.toString();
  }
}
