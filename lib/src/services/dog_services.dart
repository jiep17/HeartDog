import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/dog.dart';

class DogService {
  final String apiUrl = 'http://34.204.154.158:443/api/v1/dogs'; // Reemplaza con tu URL

  Future<List<Dog>> getDogsByOwnerId(String ownerId) async {
    final response = await http.get(
      Uri.parse('$apiUrl/filterByOwner?owner_id=$ownerId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> items = responseData['items'];

      final List<Dog> dogs = items.map((data) => Dog.fromJson(data)).toList();

      return dogs;
    } else {
      // Si la solicitud no fue exitosa, lanza una excepción o maneja el error según tu necesidad
      //throw Exception('Error al obtener la lista de perros');
      return [];
    }
  }


  Future<Dog> registerADog(Dog dog) async {
    
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(dog.toJson()),
    );
    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      final data = jsonResponse['data'];
      return Dog.fromJson(data);
    } else {
      // Si la solicitud no fue exitosa, lanza una excepción o maneja el error según tu necesidad
      throw Exception('Error al registrar el perro');
    }
  }

}
