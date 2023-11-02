import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heartdog/src/services/pulse_services.dart';
import 'package:heartdog/src/util/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HeartRatePage extends StatefulWidget {
  final String title;
  final List<double> frequencyData;

  const HeartRatePage({
    Key? key,
    required this.title,
    required this.frequencyData,
  }) : super(key: key);

  @override
  State<HeartRatePage> createState() => _HeartRatePageState();
}

class _HeartRatePageState extends State<HeartRatePage> {
  String dogId = "";
  final pulseService = PulseService();
  Timer? timer;
  SharedPreferences? prefs;
  late Future<List<Map<String, dynamic>>> pulseData;
  int average_bpm = 0;
  double min_bpm = 0;
  double max_bpm = 0;
  final List<double> beatsPerMinuteList = [];

  @override
  void initState() {
    super.initState();
    pulseData = fetchPulseData();
    //_loadPrefs();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        pulseData = fetchPulseData();
      });
    });
    //ecgData = fetchECGData();
  }

  @override
  void dispose() {
    // Detiene el Timer cuando el widget se desmonta
    timer?.cancel();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> fetchPulseData() async {
    // final dogId = "0b1f6d8e-886f-49c1-8b4c-19605338ec6e";
    await _loadPrefs();

    final now = DateTime.now();
    final startOfMinute =
        DateTime(now.year, now.month, now.day, now.hour, now.minute);
    final timestampStart = startOfMinute.millisecondsSinceEpoch;
    final timestampEnd =
        startOfMinute.add(const Duration(minutes: 1)).millisecondsSinceEpoch;

    final response =
        await pulseService.getPulseData(dogId, timestampStart, timestampEnd);

    for (final data in response) {
      final dynamic beatsPerMinute = data['beats_per_minute'];
      if (beatsPerMinute is double) {
        beatsPerMinuteList.add(beatsPerMinute);
      }
    }

    setState(() {
      if (response.lastOrNull != null) {
        average_bpm = response.lastOrNull?["avg"];
      }
      if (beatsPerMinuteList.isNotEmpty) {
        min_bpm = beatsPerMinuteList
            .reduce((min, current) => min < current ? min : current);
        max_bpm = beatsPerMinuteList
            .reduce((max, current) => max > current ? max : current);
      }
    });

    return response;
  }

  _loadPrefs() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
      dogId = prefs!.getString('dogId')!;
    }
  }

  @override
  Widget build(BuildContext context) {
    /*double average = calculateAverage(widget.frequencyData);
    double min =
        widget.frequencyData.reduce((curr, next) => curr < next ? curr : next);
    double max =
        widget.frequencyData.reduce((curr, next) => curr > next ? curr : next);*/

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondColor,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: pulseData,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        return SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          primaryYAxis: NumericAxis(),
                          series: <LineSeries<Map<String, dynamic>, String>>[
                            LineSeries<Map<String, dynamic>, String>(
                              dataSource: snapshot.data!,
                              xValueMapper: (Map<String, dynamic> ecgData, _) =>
                                  formatTimestamp(ecgData['created_time']),
                              // Mantén los valores en milisegundos
                              yValueMapper: (Map<String, dynamic> ecgData, _) =>
                                  ecgData['beats_per_minute']
                                      .toDouble(), // Convierte el valor a double
                            ),
                          ],
                        );
                      } else {
                        return const Center(
                            child: Text('No se encontraron datos de Pulso.'));
                      }
                    }),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Datos obtenidos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Promedio: ${average_bpm.toStringAsFixed(1)} ppm',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Mínimo: ${min_bpm.toStringAsFixed(1)} ppm',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Máximo: ${max_bpm.toStringAsFixed(1)} ppm',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Valores normales',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                      /*SizedBox(height: 8.0),
                      Text(
                        'Promedio: 70-90 ppm',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textColor,
                        ),
                      ),*/
                      SizedBox(height: 8.0),
                      Text(
                        'Mínimo: 100 ppm',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Máximo: 180 ppm',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // todo: Acción al hacer clic en el botón de historial de datos
                // Navegar a la vista de historial de datos
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(AppColors.secondaryColor),
              ),
              child: const Text(
                'Ver Historial de Datos',
                style: TextStyle(color: AppColors.textColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double calculateAverage(List<double> data) {
    double sum = data.reduce((curr, next) => curr + next);
    return sum / data.length;
  }

  String formatTimestamp(dynamic timestamp) {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final String formattedTime =
        '${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
    return formattedTime;
  }
}
