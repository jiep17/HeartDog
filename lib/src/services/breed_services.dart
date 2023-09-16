import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/breed.dart';

class BreedService {
  final String apiUrl = 'http://34.204.154.158:443/api/v1/breeds';

  Future<List<Breed>> getBreeds() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> breedData = json.decode(response.body);
      List<Breed> breeds = breedData.map((data) => Breed.fromJson(data)).toList();
      return breeds;
    } else {
      throw Exception('Failed to load breeds');
    }
  }
}
