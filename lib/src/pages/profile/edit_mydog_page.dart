import 'package:flutter/material.dart';
import '../../util/app_colors.dart';

class EditMyDogPage extends StatefulWidget {
  const EditMyDogPage({super.key});

  @override
  State<EditMyDogPage> createState() => _EditMyDogPageState();
}

class _EditMyDogPageState extends State<EditMyDogPage> {
  int _selectedAge = 1;
  String _selectedRace = 'Chihuahua';
  List<String> _selectedDiseases = [];
  List<String> _diseases = [
    'Arritmia',
    'Hipertenso',
    'Cancer',
    'Diabetes canina',
    'Epileptico'
  ];

  List<String> _dogRaces = [
    'Chihuahua',
    'Pomerania',
    'Yorkshire Terrier',
    'Pug',
    'Bichón Frisé',
    'Shih Tzu',
    'Bulldog Francés',
    'Pinscher Miniatura',
    'Shetland Sheepdog',
    'Westie',
    'Pequines'
  ];

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
                        'Editar información de mi mascota',
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
                                  vertical: 25, horizontal: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Nombre',
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
                                    'Raza',
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
                                        //width: double.infinity,
                                        height: 58,

                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: _selectedRace,
                                            items:
                                                _dogRaces.map((String option) {
                                              return DropdownMenuItem<String>(
                                                value: option,
                                                child: Text(option),
                                              );
                                            }).toList(),

                                            onChanged: (value) {
                                              setState(() {
                                                _selectedRace = value!;
                                              });
                                            },
                                            //dropdownColor: Colors.white,
                                            isExpanded: true,

                                            menuMaxHeight: 250,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  const Text(
                                    'Peso',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  TextFormField(
                                    
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true, signed: false),
                                    cursorColor: AppColors.primaryColor,
                                    textInputAction: TextInputAction.done,
                                    style: const TextStyle(
                                      color: AppColors.textColor,
                                    ),
                                    onTapOutside: (event) => {
                                      //event.
                                    },

                                    decoration: const InputDecoration(
                                      suffixText: 'Kilogramos',
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
                                    'Edad',
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
                                        //width: double.infinity,
                                        height: 58,

                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<int>(
                                            value: _selectedAge,
                                            items: List.generate(15, (index) {
                                              int age = index + 1;
                                              return DropdownMenuItem<int>(
                                                value: age,
                                                child: Text(age.toString()),
                                              );
                                            }),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedAge = value!;
                                              });
                                            },
                                            //dropdownColor: Colors.white,
                                            isExpanded: true,

                                            menuMaxHeight: 250,

                                            selectedItemBuilder:
                                                (BuildContext context) {
                                              return List<Widget>.generate(15,
                                                  (int index) {
                                                return Row(
                                                  children: [
                                                    Text(
                                                      _selectedAge.toString(),
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    Text(
                                                      ' años',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                );
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
                                    'Condición médica',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),

                                  const Text(
                                    'Selecciona una o varias',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),

                                  

                                  const SizedBox(
                                    height: 12,
                                  ),


                                  Wrap(
                                    spacing:
                                        8.0, // Espacio horizontal entre los chips
                                    runSpacing:
                                        2.0, // Espacio vertical entre los chips
                                    children: _diseases.map((String option) {
                                      return FilterChip(
                                        selectedColor: AppColors.blueColor,
                                        labelStyle: TextStyle(
                                          color: _selectedDiseases.contains(option) ? Colors.white : Colors.black,
                                          ),
                                        label: Text(option),
                                        selected:
                                            _selectedDiseases.contains(option),
                                        onSelected: (selected) {
                                          setState(() {
                                            if (selected) {
                                              _selectedDiseases.add(option);
                                            } else {
                                              _selectedDiseases.remove(option);
                                            }
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),


                                  const SizedBox(
                                    height: 22,
                                  ),
                                  SizedBox(
                                      width: double.infinity,
                                      height: 45,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.primaryColor),
                                        child: const Text("Guardar cambios"),
                                      ))
                                ],
                              ))),
                    ]))));
  }
}
