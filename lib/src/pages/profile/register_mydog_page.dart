import 'package:flutter/material.dart';
import 'package:heartdog/src/models/breed.dart';
import 'package:heartdog/src/models/dog.dart';
import 'package:heartdog/src/models/vet.dart';
import 'package:heartdog/src/services/breed_services.dart';
import 'package:heartdog/src/services/dog_services.dart';
import 'package:heartdog/src/services/vet_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/app_colors.dart';

class RegisterMyDogPage extends StatefulWidget {
  const RegisterMyDogPage({super.key});

  @override
  State<RegisterMyDogPage> createState() => _RegisterMyDogPageState();
}

class _RegisterMyDogPageState extends State<RegisterMyDogPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();



  Vet _auxVet = Vet(id: '', name: '', lastname: '', phone: '', clinicName: '', disponibilityStart: '', disponibilityEnd: '');
  int _selectedAge = 6;
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

  List<Breed> _breeds = [];
  List<Vet> _vets = [];

  @override
  void initState() {
    super.initState();
    _loadData(); // Cargar datos al iniciar la página
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

  Future<String> getIdOwner() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId')!;
  }

  void _updateDogNotes() {
    setState(() {
      if(_selectedDiseases.isNotEmpty) {
        _notes = _selectedDiseases
            .join(', '); // Concatenar las enfermedades seleccionadas
      } else {
        _notes = "";
      }

    });
  }

  Future<void> _loadData() async {
    // Obtener la lista de razas
    try {
      List<Breed> breeds = await BreedService().getBreeds();
      setState(() {
         _breeds = breeds;
      });

      if (_breeds.isEmpty) {
        setState(() {
          _selectedRace = '';
        });
      } else {
        setState(() {
          _selectedRace = _breeds[0].id;
        });
      }
    } catch (e) {
      // Manejar error de obtención de razas
      print('Error al obtener las razas: $e');
    }

    // Obtener la lista de veterinarios
    try {
      List<Vet> vets = await VetService().getVets();
      setState(() {
        _vets = vets;
      });

    } catch (e) {
      // Manejar error de obtención de veterinarios
      print('Error al obtener los veterinarios: $e');
    }
  }

  Future<void> _saveDog() async {
    // Validar el formulario antes de guardar
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _updateDogNotes();

    String idOwner = await getIdOwner();

    // Crear un objeto Dog con los datos ingresados por el usuario
    Dog dog = Dog(
      id: '', // El servidor asignará un ID
      ownerId: idOwner, // Debes proporcionar el ID del dueño
      name: _nameController.text,
      age: _selectedAge,
      weight: double.parse(_weightController.text),
      veterinarianId: _selectedVet, // Obtener el ID del veterinario seleccionado
      breedId: _selectedRace, // Obtener el ID de la raza seleccionada
      note: _notes, // Notas obtenidas de la selección de enfermedades
    );

    try {
      Dog registeredDog = await DogService().registerADog(dog);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushNamed('/controlpages');
      print('Perro registrado con éxito. ID: ${registeredDog.id}');
    } catch (e) {
      // Manejar el error, por ejemplo, mostrar un mensaje de error
      print('Error al registrar el perro: $e');
    }
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
                                      onPressed: _saveDog,
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
