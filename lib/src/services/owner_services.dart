import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:heartdog/src/models/owner.dart';

class OwnerService {
  final String apiUrl = 'http://107.21.241.233:443/api/v1/owners'; // Reemplaza con tu URL

  Future<int> registerOwner(Owner owner) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(owner),
    );

    if (response.statusCode == 201) {
      // Registro exitoso
      final responseData = jsonDecode(response.body)['data'];
      // return Owner.fromJson(responseData);
      return 1;
    } else {
      // Si la solicitud no fue exitosa, lanza una excepción o maneja el error según tu necesidad
      return 2;
    }
  }

    Future<Owner> getOwner(String id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final data = jsonResponse['data'];
      return Owner.fromJson(data);
    } else {
      // Si la solicitud no fue exitosa, lanza una excepción o maneja el error según tu necesidad
      throw Exception('Error al obtener el owner');
    }
  }


}
