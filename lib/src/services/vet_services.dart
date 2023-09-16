import 'dart:convert';
import 'package:heartdog/src/models/vet.dart';
import 'package:http/http.dart' as http;

class VetService {
  final String apiUrl = 'http://107.21.241.233:443/api/v1/vets'; 

  Future<List<Vet>> getVets() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> vetData = json.decode(response.body);
      List<Vet> vets = vetData.map((data) => Vet.fromJson(data)).toList();
      return vets;
    } else {
      throw Exception('Failed to load vets');
    }
  }
}
