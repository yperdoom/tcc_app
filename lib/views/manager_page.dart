import 'package:app_tcc/configs/colors.dart';
import 'package:app_tcc/views/manager/food_manager.dart';
import 'package:app_tcc/views/manager/home_manager.dart';
import 'package:app_tcc/views/manager/info_manager.dart';
import 'package:app_tcc/views/manager/personal_manager.dart';
import 'package:flutter/material.dart';

class ManagerPage extends StatefulWidget {
  const ManagerPage({super.key});

  @override
  State<ManagerPage> createState() => _ManagerPage();
}

class _ManagerPage extends State<ManagerPage> {
  int _selectedIndex = 1;

  final List<Widget> pages = [
    const InfoManager(),
    const HomeManager(),
    const FoodManager(),
    const PersonalManager(),
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
