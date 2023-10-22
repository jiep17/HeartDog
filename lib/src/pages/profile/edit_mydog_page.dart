import 'package:flutter/material.dart';
import 'package:heartdog/src/models/breed.dart';
import 'package:heartdog/src/models/dog.dart';
import 'package:heartdog/src/models/vet.dart';
import 'package:heartdog/src/services/breed_services.dart';
import 'package:heartdog/src/services/dog_services.dart';
import 'package:heartdog/src/services/vet_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_colors.dart';

class EditMyDogPage extends StatefulWidget {
  final String dogId;

  const EditMyDogPage({Key? key, required this.dogId}) : super(key: key);

  @override
  _EditMyDogPageState createState() => _EditMyDogPageState();
}

class _EditMyDogPageState extends State<EditMyDogPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  int _selectedAge = 1;
  String _selectedRace = "";
  String _selectedVet = "";
  String _notes = "";
  final List<String> _selectedDiseases = [];
  final List<String> _diseases = [
    'Arritmia',
    'Hipertenso',
    'Cancer',
    'Diabetes canina',
    'Epileptico'
  ];

  Vet _auxVet = Vet(id: '', name: '', lastname: '', phone: '', clinicName: '', disponibilityStart: '', disponibilityEnd: '');

  List<Breed> _breeds = [];
  List<Vet> _vets = [];
  
  @override
  void initState() {
    super.initState();
    _loadDogData();
  }

  Future<String> getIdOwner() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId')!;
  }
  
  // Add a function to load the existing dog data based on dogId
void _loadDogData() async {
  try {
    List<Breed> breeds = await BreedService().getBreeds();
    List<Vet> vets = await VetService().getVets();

    String ownerId  = await getIdOwner();
    Dog dog = await DogService().getDogByOwnerIdAndDogId(ownerId, widget.dogId);

    setState(() {
      _breeds = breeds;
      _vets = vets;
      _nameController.text = dog.name;
      _selectedAge = dog.age;
      _weightController.text = dog.weight.toString();
      _selectedRace = dog.breedId;
      _selectedVet = dog.veterinarianId;
      _notes = dog.note;
      // _selectedDiseases.clear(); // You need to parse the notes and set selected diseases accordingly.
    }); 
  } catch (e) {
    // Handle the error if dog data cannot be loaded.
    print('Error loading dog data: $e');
  }
}

  void _updateDogNotes() {
    setState(() {
      if (_selectedDiseases.isNotEmpty) {
        _notes = _selectedDiseases.join(', ');
      } else {
        _notes = "";
      }
    });
  }

  void _updateDog() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String ownerId  = await getIdOwner();
    _updateDogNotes();

    // Create a Dog object with the updated information
    Dog updatedDog = Dog(
      name: _nameController.text,
      age: _selectedAge,
      weight: double.parse(_weightController.text),
      veterinarianId: _selectedVet,
      breedId: _selectedRace,
      note: _notes,
      id: '',
      ownerId: ''
    );

    try {
      // Update the dog information using the DogService
      await DogService().updateDog(ownerId, widget.dogId, updatedDog);
      // Handle success and navigation
      Navigator.of(context).pushNamed('/controlpages');
    } catch (e) {
      // Handle the error if the dog information cannot be updated.
      print('Error updating dog information: $e');
    }
  }

  String? _validateName(String? value) {
    final RegExp nameExp = RegExp(r'^[a-zA-Z]+$');
    if (!nameExp.hasMatch(value!)) {
      return 'El campo debe contener solo letras';
    }
    return null;
  }

  String? _validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa el peso.';
    }

    double? weight = double.tryParse(value);
    if (weight == null || weight <= 0) {
      return 'El peso debe ser mayor a 0.';
    }

    return null;
  }


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
          child: Form(
              key: _formKey,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: ListView(children: [
                    const Text(
                      'Crear información de mi mascota',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                    controller: _nameController,
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
                                    validator: _validateName),
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
                                        child: DropdownButton<Breed>(
                                        value: _breeds.isNotEmpty 
                                            ? _selectedRace.isNotEmpty? _breeds.firstWhere((breed) => breed.id == _selectedRace, orElse: () => _breeds[0])
                                                : _breeds[0]
                                            : null,
                                          items: _breeds.map((Breed breed) {
                                            return DropdownMenuItem<Breed>(
                                              value: breed,
                                              child: Text(breed.name),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedRace = value?.id ??
                                                  ''; // Actualizar _selectedRace
                                            });
                                          },
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
                                    controller: _weightController,
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
                                    validator: _validateWeight),
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
                                                    style:
                                                        const TextStyle(fontSize: 16),
                                                  ),
                                                  const Text(
                                                    ' años',
                                                    style:
                                                        TextStyle(fontSize: 16),
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
                                        color:
                                            _selectedDiseases.contains(option)
                                                ? Colors.white
                                                : Colors.black,
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
                                  height: 14,
                                ),
                                const Text(
                                  'Veterinario',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 14,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      side: const BorderSide(
                                        width: 1,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    child: SizedBox(
                                      height: 58,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<Vet>(
                                         value: _vets.isNotEmpty 
                                            ? _selectedVet.isNotEmpty? _vets.firstWhere((vet) => vet.id == _selectedVet, orElse: () => _auxVet)
                                                :_auxVet
                                            : null,
                                          items:
                                          [  DropdownMenuItem<Vet>(
                                                  value: _auxVet, 
                                                  child: Text("Sin veterinario"),
                                            ),
                                            ..._vets.map((Vet vet) {
                                            return DropdownMenuItem<Vet>(
                                              value: vet,
                                              child: Text(vet.name),
                                            );
                                          }).toList()
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedVet = value!.id ?? 
                                               '';
                                            });
                                          },
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
                                SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _updateDog,
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.secondaryColor),
                                      child: const Text(
                                        "Guardar cambios",
                                        style: TextStyle(
                                            color: AppColors.textColor),
                                      ),
                                    ))
                              ],
                            ))),
                  ])))),
    );
  }
}
