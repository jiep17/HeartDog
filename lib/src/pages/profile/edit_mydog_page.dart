

import 'package:flutter/material.dart';

import '../../util/app_colors.dart';

class EditMyDogPage extends StatefulWidget {
  const EditMyDogPage({super.key});

  @override
  State<EditMyDogPage> createState() => _EditMyDogPageState();
}

class _EditMyDogPageState extends State<EditMyDogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: AppColors.textColor, // establecer el color de los iconos
        ),
        title: Image.asset(
          'assets/images/barbeat_logo.png', // Ruta de la imagen del logo
          fit: BoxFit.contain, // Ajustar la imagen dentro del AppBar
          height: AppBar().preferredSize.height,
        ),
      ),
      body: Container(),
    );
  }
}