import 'package:flutter/material.dart';
import 'package:heartdog/src/shared/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'src/app.dart';
import 'dart:io';


void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = UserPreferences();
  await prefs.initPrefs();

  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove();

  if (Platform.isAndroid) {
    [
      Permission.location,
      Permission.storage,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan
    ].request().then((status) {
      runApp(const MyApp());
    });
  }else{
    runApp(const MyApp());
  }
  
}