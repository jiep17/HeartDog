

import 'package:flutter/material.dart';
import 'package:heartdog/src/pages/home_page.dart';
import 'package:heartdog/src/pages/profile_page.dart';

class ControlPages extends StatefulWidget {
  const ControlPages({super.key});
  

  @override
  State<ControlPages> createState() => _ControlPagesState();
}

class _ControlPagesState extends State<ControlPages> {
  int _indexPage = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ProfilePage()
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_indexPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexPage,
        onTap: (int index) {
          setState(() {
            _indexPage = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Inicio',
          ),
        ]
      ),
    );
  }
}