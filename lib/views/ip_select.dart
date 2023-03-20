import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class IpSelectPage extends StatefulWidget {
  const IpSelectPage({super.key});

  @override
  State<IpSelectPage> createState() => _IpSelectPage();
}

class _IpSelectPage extends State<IpSelectPage> {
  final String urlProduction = 'https://tcc2.pedro/api';
  final String urlLocal = 'http://10.1.1.7:4030';
  final String urlLocalAmo = 'http://10.1.1.8:4030';
  String urlActualy = '';
  String urlDigitada = '';
  String ipSelect = '';
  String portSelect = '';

  @override
  void initState() {
    super.initState();
    getUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IP select Page'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Set to production env button
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => setUrl(urlProduction),
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
                    'Set to production',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Set to local env button
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => setUrl(urlLocal),
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
                    'Set to local',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Set to local amo env button
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => setUrl(urlLocalAmo),
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
                    'Set to amo local',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // url with ip select fields
              Row(
                children: [
                  // ip select field
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 10),
                    child: SizedBox(
                      width: 200,
                      child: TextField(
                        decoration: const InputDecoration(
                          label: Text('IP'),
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(),
                          hintText: '192.168.0.2',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: syncIp,
                      ),
                    ),
                  ),
                  // port select field
                  SizedBox(
                    width: 100,
                    child: TextField(
                      decoration: const InputDecoration(
                        label: Text('Port'),
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(),
                        hintText: '3000',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: syncPort,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Set typed ip as url
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => setIpAsUrl(),
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
                    'Set typed ip as url',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // typed url field
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  decoration: const InputDecoration(
                    label: Text('Url'),
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(),
                    hintText: 'Digite a url desejada aqui...',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  onChanged: syncUrl,
                ),
              ),
              const SizedBox(height: 15),
              // Set typed string as url
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => setUrl(urlDigitada),
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
                    'Set typed url as url',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Text to inform url actually
              const Text(
                'Url atualmente em uso: ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 24,
                ),
              ),
              Text(
                urlActualy,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      ),
      // return to main page
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
    urlDigitada = url;
  }

  void syncIp(String ip) {
    ipSelect = ip;
  }

  void syncPort(String port) {
    portSelect = port;
  }

  void setIpAsUrl() async {
    String url = 'http://$ipSelect:$portSelect';
    setUrl(url);
  }

  void setUrl(String url) async {
    if (url.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('url', url);
    }
    setState(() {});
    getUrl();
  }

  getUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final String? url = prefs.getString('url');
    urlActualy = url.toString();
    setState(() {});
  }
}
