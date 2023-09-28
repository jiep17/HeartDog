import 'package:flutter/material.dart';
import 'package:heartdog/src/models/owner.dart';
import 'package:heartdog/src/services/dog_services.dart';
import 'package:heartdog/src/services/owner_services.dart';
import 'package:heartdog/src/util/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/dog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final DogService _dogService = DogService();
  final OwnerService _ownerService = OwnerService();
  String _idOwner = "";
  String _activeDogId = "";

  Owner _owner =
      Owner(id: '', name: '', lastname: '', email: '', password: '', phone: '');

  @override
  void initState() {
    super.initState();
    _loadData(); // Cargar datos al iniciar la página
  }

  Future<String> getIdOwner() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId')!;
  }

  Future<void> _loadData() async {
    try {
      String idOwner = await getIdOwner();
      Owner owner = await _ownerService.getOwner(idOwner);

      final prefs = await SharedPreferences.getInstance();
      String activeDogId = prefs.getString('dogId') ?? "";

      setState(() {
        _idOwner = idOwner;
        _owner = owner;
        _activeDogId = activeDogId;
      });
    } catch (e) {
      // Manejar error de obtención de razas
      print('Error');
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
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(_owner.lastname,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18))
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/edit_info_page');
                        },
                        child: Icon(
                          Icons.edit,
                          size: 24,
                          color: AppColors.primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // Botón para agregar un nuevo perro

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/create_mydog_page');
                },
                child: Text('Agregar un nuevo perro'),
              ),

              const SizedBox(height: 20),

              // Mascotas
              FutureBuilder<List<Dog>>(
                future: _dogService.getDogsByOwnerId(_idOwner),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text(
                        'No tienes ningun perro registrado.'); // Mensaje si no hay perros
                  } else {
                    // Si hay datos, muestra la lista de perros en tarjetas de mascota
                    final dogs = snapshot.data!;
                    return Column(
                      children: [
                        for (final dog in dogs)
                          Column(
                            children: [
                              ListTile(
                                title: Text(""),
                                leading: Radio<String>(
                                  value: dog.id,
                                  groupValue: _activeDogId,
                                  onChanged: (String? newValue) async {
                                    setState(() {
                                      _activeDogId = newValue!;
                                    });

                                    // Guardar el ID del perro activo en las preferencias
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString('dogId', _activeDogId);
                                  },
                                ),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                '/edit_mydog_page',
                                                arguments: dog.id,
                                              );
                                            },
                                            child: const Icon(
                                              Icons.edit,
                                              size: 24,
                                              color: AppColors.primaryColor,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Nombre: ${dog.name}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Edad: ${dog.age} años',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Raza: ${dog.breed_id}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Peso: ${dog.weight} kg',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    );
                  }
                },
              ),
              SizedBox(
                height: 30,
              ),

              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/');
                },
                child: Text(
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
}
