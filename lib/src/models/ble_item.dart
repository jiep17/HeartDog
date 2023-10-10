import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleItem {
  BluetoothDevice device;
  int rssi;
  bool isHovered = false;
  bool isTouched = false;
  DateTime timeStamp;

  BleItem({
    required this.device,
    required this.rssi,
    required this.timeStamp
  });
}