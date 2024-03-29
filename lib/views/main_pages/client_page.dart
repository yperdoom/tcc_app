import 'package:Yan/configs/colors.dart';
import 'package:Yan/views/client/food_user.dart';
import 'package:Yan/views/client/home_user.dart';
import 'package:Yan/views/client/info_user.dart';
import 'package:Yan/views/client/personal_user.dart';
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
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.info_outline_rounded),
            label: 'Infos',
            backgroundColor: Cores.blueHeavy,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_rounded),
            label: 'Home',
            backgroundColor: Cores.blueHeavy,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.fastfood_outlined),
            label: 'Food',
            backgroundColor: Cores.blueHeavy,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outlined),
            label: 'Persona',
            backgroundColor: Cores.blueHeavy,
          )
        ],
        backgroundColor: Cores.blueHeavy,
        currentIndex: _selectedIndex,
        selectedItemColor: Cores.selectedIcon,
        onTap: (index) {
          _navigationWithNavBar(context, index);
        },
      ),
    );
  }
}
