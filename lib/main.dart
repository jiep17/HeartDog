import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'src/app.dart';
import 'dart:io';


void main() {
  if (Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
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