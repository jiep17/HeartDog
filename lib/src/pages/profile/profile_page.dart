import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:heartdog/src/models/owner.dart';
import 'package:heartdog/src/services/breed_services.dart';
import 'package:heartdog/src/services/dog_services.dart';
import 'package:heartdog/src/services/owner_services.dart';
import 'package:heartdog/src/util/app_colors.dart';
import 'package:heartdog/src/widgets/add_user_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/dog.dart';
import '../../widgets/selected_user_tile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final DogService _dogService =
      DogService(); // Reemplaza con tu propio servicio de perros
  final OwnerService _ownerService = OwnerService();
  final BreedService _breedService = BreedService();
  String _idOwner = "";
  late SharedPreferences prefs;

  Owner _owner =
      Owner(id: '', name: '', lastname: '', email: '', password: '', phone: '');

  List<Dog> _myDogs = [];

  Dog? selectedDog;

  int indexSelectedDog = 0;

  bool _isLoadingDogs = true;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<String> getIdOwner() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId')!;
  }

  Future<void> _loadData() async {
    try {
      String idOwner = await getIdOwner();
      Owner owner = await _ownerService.getOwner(idOwner);
      setState(() {
        _idOwner = idOwner;
      });
      await _loadDogs();
      setState(() {
        _owner = owner;
      });
    } catch (e) {
      // Manejar error de obtención de razas
      print('Error');
    }
  }

  Future<void> _loadDogs() async {
    _myDogs = await _dogService.getDogsByOwnerId(_idOwner);

    if (_myDogs.isNotEmpty) {
      for (var dog in _myDogs) {
        final breed = await _breedService.getBreedById(dog.breedId);
        dog.breedName = breed.name;
      }

      setState(() {
        selectedDog = _myDogs[0];
        prefs.setString('dogId', selectedDog!.id);
        _isLoadingDogs = false;
      });
    } else {
      _isLoadingDogs = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Agrega el SingleChildScrollView
        child: Container(
          color: AppColors.backgroundSecondColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: AppColors.blueColor,
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        letterSpacing: 1.0)),
                onPressed: () async {
                  PermissionStatus permissionStatus =
                      await Permission.bluetoothConnect.request();
                  if (permissionStatus == PermissionStatus.granted) {
                    FlutterBluePlus.turnOn();
                  }
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamed('/scan_devices');
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.boxArchive,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    FaIcon(
                      FontAwesomeIcons.bluetoothB,
                      size: 20,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('Conectar wearable'),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.account_circle,
                        size: 84,
                      ),
                      SizedBox(
                        height: 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _owner.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(_owner.lastname,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18))
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/edit_info_page');
                        },
                        child: const Icon(
                          Icons.edit,
                          size: 24,
                          color: AppColors.primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),

              // Botón para agregar un nuevo perro

              /*ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/create_mydog_page');
                },
                child: Text('Agregar un nuevo perro'),
              ),*/

              //const SizedBox(height: 20),

              // Mascotas

              // Si hay datos, muestra la lista de perros en tarjetas de mascota
              //final dogs = snapshot.data!;
              //selectedDog = dogs[indexSelectedDog];
              Column(
                children: [
                  _isLoadingDogs
                      ? const Center(
                          child: Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: CircularProgressIndicator()),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Wrap(spacing: 32, runSpacing: 32, children: [
                            ..._myDogs.asMap().entries.map<Widget>((entry) {
                              final index = entry.key;
                              final item = entry.value;

                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(children: [
                                      SelectedUserTile(onTap: () async {
                                        setState(() {
                                          indexSelectedDog = index;
                                          selectedDog =
                                              _myDogs[indexSelectedDog];
                                        });

                                        prefs.setString(
                                            'dogId', selectedDog!.id);
                                      }),
                                      if (index == indexSelectedDog)
                                        Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Card(
                                              color: Colors.blue,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(80),
                                              ),
                                              elevation: 5,
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 18,
                                                width: 18,
                                                child: const Icon(
                                                  Icons.check,
                                                  size: 15,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ))
                                    ]),
                                    const SizedBox(height: 5),
                                    Text(item.name,
                                        style: const TextStyle(fontSize: 12))
                                  ]);
                            }).toList(),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AddUserButton(onAdduser: () {
                                    Navigator.of(context)
                                        .pushNamed('/create_mydog_page');
                                  }),
                                  const SizedBox(height: 5),
                                  const Text('Agregar otra\nmascota',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12))
                                ])
                          ]),
                        ),
                  (selectedDog != null)
                      ? Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Información de mi\nmascota  🐕',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              '/edit_mydog_page',
                                              arguments: selectedDog!.id);
                                        },
                                        child: const Icon(
                                          Icons.edit,
                                          size: 24,
                                          color: AppColors.primaryColor,
                                        ),
                                      )
                                    ]),
                                const SizedBox(height: 5),
                                Text(
                                  'Nombre: ${selectedDog!.name}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Edad: ${selectedDog!.age} años',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Raza: ${selectedDog!.breedName}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Peso: ${selectedDog!.weight} kg',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
              const SizedBox(
                height: 30,
              ),

              GestureDetector(
                onTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text(
                  'Cerrar sesión',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      decoration: TextDecoration.underline),
                ),
              ) 
            ]),
          ),
        ),
      ),
    );
  }

  void handleContainerTap(int index) {
    setState(() {});
  }
}
