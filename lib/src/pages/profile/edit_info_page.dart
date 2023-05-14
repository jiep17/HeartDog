import 'package:flutter/material.dart';
import 'package:heartdog/src/util/app_colors.dart';

class EditPersonalInfoPage extends StatefulWidget {
  const EditPersonalInfoPage({super.key});

  @override
  State<EditPersonalInfoPage> createState() => _EditPersonalInfoPageState();
}

class _EditPersonalInfoPageState extends State<EditPersonalInfoPage> {
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
