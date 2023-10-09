import 'package:flutter/material.dart';
import 'package:heartdog/src/util/app_colors.dart';
import 'package:intl/intl.dart' show DateFormat;

class EditPersonalInfoPage extends StatefulWidget {
  const EditPersonalInfoPage({super.key});

  @override
  State<EditPersonalInfoPage> createState() => _EditPersonalInfoPageState();
}

class _EditPersonalInfoPageState extends State<EditPersonalInfoPage> {
  DateTime _selectedDate = DateTime.now();
  String _selectedGenre = 'Masculino';

  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: AppColors.textColor, // establecer el color de los iconos
          ),
          title: Image.asset(
            'assets/images/barbeat_logo.png', // Ruta de la imagen del logo
            fit: BoxFit.contain, // Ajustar la imagen dentro del AppBar
            height: AppBar().preferredSize.height,
          ),
        ),
        body: Container(
            color: AppColors.backgroundSecondColor,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: ListView(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Editar información personal',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          //shape: ShapeBorder.,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                /*mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,*/
                                children: [
                                  const Icon(
                                    Icons.account_circle,
                                    size: 120,
                                  ),
                                  const SizedBox(
                                    width: 14,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primaryColor),
                                      child: const Row(
                                          //alignment: WrapAlignment.spaceBetween,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(Icons.camera_alt_outlined),
                                            Text('Actualizar foto')
                                          ]),
                                    ),
                                  )
                                ],
                              ))),
                      const SizedBox(
                        height: 20,
                      ),
                      Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          //shape: ShapeBorder.,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Nombres',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    cursorColor: AppColors.primaryColor,
                                    style: const TextStyle(
                                      color: AppColors.textColor,
                                    ),
                                    onTapOutside: (event) => {
                                      //event.
                                    },

                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.primaryColor,
                                            width: 1.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blueGrey, width: 1.0),
                                      ),
                                      //hintText: 'email@example.com',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      //counterText: "${_email.length.toString()}/40",
                                      counterStyle:
                                          TextStyle(color: Colors.white),
                                      focusColor: Colors.white,
                                      hoverColor: Colors.white,
                                    ),
                                    // The validator receives the text that the user has entered.
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  const Text(
                                    'Apellidos',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    cursorColor: AppColors.primaryColor,
                                    style: const TextStyle(
                                      color: AppColors.textColor,
                                    ),
                                    onTapOutside: (event) => {
                                      //event.
                                    },

                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.primaryColor,
                                            width: 1.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blueGrey, width: 1.0),
                                      ),
                                      //hintText: 'email@example.com',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      //counterText: "${_email.length.toString()}/40",
                                      counterStyle:
                                          TextStyle(color: Colors.white),
                                      focusColor: Colors.white,
                                      hoverColor: Colors.white,
                                    ),
                                    // The validator receives the text that the user has entered.
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  const Text(
                                    'Género',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5.0), // ajusta según tus necesidades
                                        ),
                                        side: const BorderSide(
                                            width: 1,
                                            color: AppColors
                                                .primaryColor), // ajusta según tus necesidades
                                      ),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 58,
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            value: _selectedGenre,
                                            items: const [
                                              DropdownMenuItem(
                                                  value: 'Masculino',
                                                  child: Text('Masculino')),
                                              DropdownMenuItem(
                                                  value: 'Femenino',
                                                  child: Text('Femenino')),
                                              DropdownMenuItem(
                                                  value: 'Prefiero no decirlo',
                                                  child: Text(
                                                      'Prefiero no decirlo')),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedGenre = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  const Text(
                                    'Fecha de nacimiento',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        child: TextFormField(
                                          textAlign: TextAlign.center,
                                          readOnly: true,
                                          onTap: () {
                                            _selectDate(context);
                                          },
                                          controller: _dayController,
                                          keyboardType: TextInputType.text,
                                          cursorColor: AppColors.primaryColor,
                                          style: const TextStyle(
                                            color: AppColors.textColor,
                                          ),
                                          onTapOutside: (event) => {
                                            //event.
                                          },

                                          decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors.primaryColor,
                                                  width: 1.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blueGrey,
                                                  width: 1.0),
                                            ),
                                            //hintText: 'email@example.com',
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                            //counterText: "${_email.length.toString()}/40",
                                            counterStyle:
                                                TextStyle(color: Colors.white),
                                            focusColor: Colors.white,
                                            hoverColor: Colors.white,
                                          ),
                                          // The validator receives the text that the user has entered.
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 110,
                                        child: TextFormField(
                                          textAlign: TextAlign.center,
                                          readOnly: true,
                                          onTap: () {
                                            _selectDate(context);
                                          },
                                          controller: _monthController,
                                          keyboardType: TextInputType.text,
                                          cursorColor: AppColors.primaryColor,
                                          style: const TextStyle(
                                            color: AppColors.textColor,
                                          ),
                                          onTapOutside: (event) => {
                                            //event.
                                          },

                                          decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors.primaryColor,
                                                  width: 1.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blueGrey,
                                                  width: 1.0),
                                            ),
                                            //hintText: 'email@example.com',
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                            //counterText: "${_email.length.toString()}/40",
                                            counterStyle:
                                                TextStyle(color: Colors.white),
                                            focusColor: Colors.white,
                                            hoverColor: Colors.white,
                                          ),
                                          // The validator receives the text that the user has entered.
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 60,
                                        child: TextFormField(
                                          textAlign: TextAlign.center,
                                          readOnly: true,
                                          onTap: () {
                                            _selectDate(context);
                                          },
                                          controller: _yearController,
                                          keyboardType: TextInputType.text,
                                          cursorColor: AppColors.primaryColor,
                                          style: const TextStyle(
                                            color: AppColors.textColor,
                                          ),
                                          onTapOutside: (event) => {
                                            //event.
                                          },

                                          decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors.primaryColor,
                                                  width: 1.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blueGrey,
                                                  width: 1.0),
                                            ),
                                            //hintText: 'email@example.com',
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                            //counterText: "${_email.length.toString()}/40",
                                            counterStyle:
                                                TextStyle(color: Colors.white),
                                            focusColor: Colors.white,
                                            hoverColor: Colors.white,
                                          ),
                                          // The validator receives the text that the user has entered.
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  const Text(
                                    'Correo electrónico',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    cursorColor: AppColors.primaryColor,
                                    style: const TextStyle(
                                      color: AppColors.textColor,
                                    ),
                                    onTapOutside: (event) => {
                                      //event.
                                    },

                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.primaryColor,
                                            width: 1.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blueGrey, width: 1.0),
                                      ),
                                      hintText: 'email@example.com',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      //counterText: "${_email.length.toString()}/40",
                                      counterStyle:
                                          TextStyle(color: Colors.white),
                                      focusColor: Colors.white,
                                      hoverColor: Colors.white,
                                    ),
                                    // The validator receives the text that the user has entered.
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 22,
                                  ),
                                  SizedBox(
                                      width: double.infinity,
                                      //height: 40,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.secondaryColor),
                                        child: const Text("Guardar cambios",style: TextStyle(color: AppColors.textColor),),
                                      ))
                                ],
                              ))),
                    ]))));
  }

  //Seleccion de fecha

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale('es', 'ES'),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dayController.text = _selectedDate.day.toString();
        _monthController.text = DateFormat('MMMM', 'es').format(_selectedDate);
        _yearController.text = _selectedDate.year.toString();
      });
    }
  }
}
