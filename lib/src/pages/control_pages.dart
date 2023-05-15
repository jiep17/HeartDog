

import 'package:flutter/material.dart';
import 'package:heartdog/src/pages/home_page.dart';
import 'package:heartdog/src/pages/monitoring/monitoring_pages.dart';
import 'package:heartdog/src/pages/profile/profile_page.dart';

class ControlPages extends StatefulWidget {
  const ControlPages({super.key});
  

  @override
  State<ControlPages> createState() => _ControlPagesState();
}

class _ControlPagesState extends State<ControlPages> {
  int _indexPage = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ProfilePage(),
    const MonitoringPage(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,//ocultamos el iconButton retroceder del appbar
        title: Image.asset(
          'assets/images/barbeat_logo.png', // Ruta de la imagen del logo
          fit: BoxFit.contain, // Ajustar la imagen dentro del AppBar
          height: AppBar().preferredSize.height,
        ),
      ),
      body: _pages[_indexPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexPage,
        onTap: (int index) {
          setState(() {
            _indexPage = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
            tooltip: "Mira estadisticas"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
            tooltip: "Revisa tu datos"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.visibility),
            label: 'Monitoreo',
            tooltip: "Monitoreo"
          ),
        ]
      ),
    );
  }
}