import 'dart:convert';
import 'package:http/http.dart' as http;

class PulseService {
  final String apiUrl = "http://54.226.24.48:19215/api/v1/pulse-data";

  Future<List<Map<String, dynamic>>> getPulseData(String dogId, int timestampStart, int timestampEnd) async {
    final Uri uri = Uri.parse('$apiUrl/$dogId?timestamp_start=$timestampStart&timestamp_end=$timestampEnd');

    final response = await http.get(uri);
    
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load Pulse data');
    }
  }
}
