import 'dart:convert';
import 'package:heartdog/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final String apiUrl = 'http://107.21.241.233:443/api/v1/authenticate/owner';

  Future<int> loginUser(User user) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    print(response.statusCode);

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      final data = jsonResponse['data'];
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', data['id']);
      prefs.setString('email', data['email']);
      prefs.setString('token', data['token']);
      return 1;

    } else {
      throw Exception('Error al iniciar sesión');
    }
  }
}
