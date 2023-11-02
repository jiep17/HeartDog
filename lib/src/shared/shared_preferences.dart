// ignore_for_file: non_constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._internal();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences _preferences;

  initPrefs() async {
    _preferences = await _prefs;
  }

  factory UserPreferences() {
    return _instance;
  }

  get dogId {
    return _preferences.getString('dogId');
  }

  set DogId(String value) {
    _preferences.setString('dogId', value);
  }

  get userId {
    return _preferences.getString('userId');
  }

  set UserId(String value) {
    _preferences.setString('userId', value);
  }

  UserPreferences._internal();
}
