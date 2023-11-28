import 'dart:convert';
import 'package:heartdog/src/models/generic_temperature.dart';
import 'package:http/http.dart' as http;

class TemperatureService {
  final String apiUrl = "http://54.226.24.48:19215/api/v1/temp-data";

  Future<GenericTemperature?> getLastRecordTemp(String dogId) async {

    final Uri uri = Uri.parse('$apiUrl/$dogId/last-record');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final genericPulse =
          GenericTemperature.fromJson(json.decode(response.body));
      return genericPulse;
    } else {
      return null;
    }
  }
}
