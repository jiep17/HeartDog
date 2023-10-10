import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:heartdog/src/models/ble_write_data.dart';
import 'package:heartdog/src/services/ecg_services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_colors.dart';

// ignore: must_be_immutable
class ECGGraphPage extends StatefulWidget {
  ECGGraphPage({Key? key}) : super(key: key);
  final List<BluetoothDevice> connectedDeviceList = <BluetoothDevice>[];
  BluetoothCharacteristic? connectedWriteCharacteristic;

  @override
  State<ECGGraphPage> createState() => _ECGGraphPageState();
}

class _ECGGraphPageState extends State<ECGGraphPage> {
  String dogId = "";
  late Future<List<Map<String, dynamic>>> ecgData;
  final ecgService = ECGService();
  bool startCapture = false;
  Timer? timer;
  bool isTimerActive = false;

  StreamSubscription<List<BluetoothDevice>>? _connectedDevicesSubscription;
  List<BluetoothService> _services = [];

  @override
  void initState() {
    super.initState();
    ecgData = fetchECGData();

    _connectedDevicesSubscription = FlutterBluePlus.connectedSystemDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addConnectedDeviceToList(device);
      }
    });
  }

  _addConnectedDeviceToList(BluetoothDevice device) async {
    bool existItem = false;
    for (var item in widget.connectedDeviceList) {
      if (item.remoteId == device.remoteId) {
        existItem = true;
      }
    }

    if (!existItem) {
      widget.connectedDeviceList.add(device);
      _services = await device.discoverServices();
      getBLECharacteristics();
    }
  }

  void getBLECharacteristics() {
    for (BluetoothService service in _services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.write) {
          widget.connectedWriteCharacteristic = characteristic;
        }
      }
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        ecgData = fetchECGData();
      });
    });
    setState(() {
      isTimerActive = true;
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      isTimerActive = false;
    });
  }

  @override
  void dispose() {
    // Detiene el Timer cuando el widget se desmonta
    timer?.cancel();
    _connectedDevicesSubscription?.cancel();
    super.dispose();
  }

  _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    dogId = prefs.getString('dogId')!;
  }


  Future<List<Map<String, dynamic>>> fetchECGData() async {
    // final dogId = "0b1f6d8e-886f-49c1-8b4c-19605338ec6e";
    await _loadPrefs();
    final now = DateTime.now();
    final timestampEnd = now.millisecondsSinceEpoch;
    final timestampStart =
        now.subtract(const Duration(seconds: 5)).millisecondsSinceEpoch;
    final response =
        await ecgService.getECGData(dogId, timestampStart, timestampEnd);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ELECTROCARDIOGRAMA',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    startCapture = !startCapture;

                    if (startCapture) {
                      startTimer();
                    } else {
                      stopTimer();
                    }
                  });

                  if (startCapture) {
                    BleWriteData initSensor =
                        BleWriteData(subject: 'scan-ad8232', status: true);

                    /// SEND THE MESSAGE VIA BLUETOOTH
                    await widget.connectedWriteCharacteristic!
                        .write(utf8.encode(jsonEncode(initSensor.toJson())));
                  } else {
                    BleWriteData stopSensor =
                        BleWriteData(subject: 'scan-ad8232', status: false);

                    /// SEND THE MESSAGE VIA BLUETOOTH
                    await widget.connectedWriteCharacteristic!
                        .write(utf8.encode(jsonEncode(stopSensor.toJson())));
                  }
                },
                style: (!startCapture)
                    ? ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor)
                    : ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                child: (!startCapture)
                    ? const Text("Capturar")
                    : const Text("Pausar"),
              )),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height * 0.7,
            //width: MediaQuery.of(context).size.width * 0.9,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: ecgData,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return Center(
                    child: SfCartesianChart(
                      primaryXAxis: NumericAxis(
                        // Configura el eje X para que muestre las marcas de tiempo en milisegundos
                        labelFormat:
                            '{value}ms', // Mostrará el tiempo en milisegundos
                        interval: 1000, // Intervalo de 15 milisegundos
                      ),
                      primaryYAxis: NumericAxis(),
                      series: <LineSeries<Map<String, dynamic>, double>>[
                        LineSeries<Map<String, dynamic>, double>(
                          dataSource: snapshot.data!,
                          xValueMapper: (Map<String, dynamic> ecgData, _) =>
                              ecgData['timestamp']
                                  .toDouble(), // Mantén los valores en milisegundos
                          yValueMapper: (Map<String, dynamic> ecgData, _) =>
                              ecgData['value']
                                  .toDouble(), // Convierte el valor a double
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                      child: Text('No se encontraron datos de ECG.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
