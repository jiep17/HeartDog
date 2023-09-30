import 'package:flutter/material.dart';
import 'package:heartdog/src/services/ecg_services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_colors.dart';

class ECGGraphPage extends StatefulWidget {
  @override
  _ECGGraphPageState createState() => _ECGGraphPageState();
}

class _ECGGraphPageState extends State<ECGGraphPage> {
  late Future<String> dogId;
  late Future<List<Map<String, dynamic>>> ecgData;

  @override
  void initState() {
    super.initState();
    ecgData = fetchECGData();
  }

  Future<List<Map<String, dynamic>>> fetchECGData() async {
    final ecgService = ECGService();

    final prefs = await SharedPreferences.getInstance();
    final dogId = prefs.getString('dogId')!;
    // final dogId = "0b1f6d8e-886f-49c1-8b4c-19605338ec6e";
    final now = DateTime.now();
    final timestampEnd = now.millisecondsSinceEpoch;
    final timestampStart = now.subtract(const Duration(seconds: 4)).millisecondsSinceEpoch;
    final response = await ecgService.getECGData(dogId, timestampStart, timestampEnd);
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
      body: FractionallySizedBox(
        widthFactor: 0.9, // Establece el ancho al 90% de la pantalla
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: ecgData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Center(
                child: SfCartesianChart(
                  primaryXAxis: NumericAxis(
                    // Configura el eje X para que muestre las marcas de tiempo en milisegundos
                    labelFormat: '{value}ms', // Mostrará el tiempo en milisegundos
                    interval: 1000, // Intervalo de 15 milisegundos
                  ),
                  primaryYAxis: NumericAxis(),
                  series: <LineSeries<Map<String, dynamic>, double>>[
                    LineSeries<Map<String, dynamic>, double>(
                      dataSource: snapshot.data!,
                      xValueMapper: (Map<String, dynamic> ecgData, _) =>
                          ecgData['timestamp'].toDouble(), // Mantén los valores en milisegundos
                      yValueMapper: (Map<String, dynamic> ecgData, _) =>
                          ecgData['value'].toDouble(), // Convierte el valor a double
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('No se encontraron datos de ECG.'));
            }
          },
        ),
      ),
    );
  }
}
