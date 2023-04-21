import 'package:app_tcc/views/client/food_user.dart';
import 'package:app_tcc/views/client/home_user.dart';
import 'package:app_tcc/views/client/info_user.dart';
import 'package:app_tcc/views/client/personal_user.dart';
import 'package:flutter/material.dart';

class ClientPage extends StatefulWidget {
  const ClientPage({super.key});

  @override
  State<ClientPage> createState() => _ClientPage();
}

class _ClientPage extends State<ClientPage> {
  int _selectedIndex = 1;

  final List<Widget> pages = [
    const InfoUser(),
    const HomeUser(),
    const FoodUser(),
    const PersonalUser(),
  ];

  void _navigationWithNavBar(BuildContext context, int index) async {
    _selectedIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline_rounded),
            label: 'Infos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: 'Food',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Persona',
          )
        ],
        backgroundColor: const Color(0xff1E4CFF),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: (index) {
          _navigationWithNavBar(context, index);
        },
      ),
    );
  }
}
