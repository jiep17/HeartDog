import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleItem {
  BluetoothDevice device;
  int rssi;

  BleItem({
    required this.device,
    required this.rssi
  });
}