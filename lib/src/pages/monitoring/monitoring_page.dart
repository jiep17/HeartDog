import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heartdog/src/models/generic_pulse.dart';
import 'package:heartdog/src/models/generic_temperature.dart';
import 'package:heartdog/src/pages/monitoring/heart_rate.dart';
import 'package:heartdog/src/services/pulse_services.dart';
import 'package:heartdog/src/services/temperature_services.dart';
import 'package:heartdog/src/shared/shared_preferences.dart';
import 'package:heartdog/src/util/app_colors.dart';
import 'package:intl/intl.dart';

class MonitoringPage extends StatefulWidget {
  const MonitoringPage({Key? key}) : super(key: key);

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  final pulseService = PulseService();
  final tempService = TemperatureService();
  Timer? timer;
  final UserPreferences _preferences = UserPreferences();
  GenericPulse? pulse;
  GenericTemperature? temperature;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      getLastValuesPulseAndTemperature();
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void getLastValuesPulseAndTemperature() async {
    if (_preferences.dogId != null) {
      var temporal1 = await tempService.getLastRecordTemp(_preferences.dogId);
      var temporal2 = await pulseService.getLastRecordPulse(_preferences.dogId);

      if (mounted) {
        setState(() {
          temperature = temporal1;
          pulse = temporal2;
        });
      }
    }
  }

  String epochToFormattedString(int epochMillis) {
    const timeZoneOffset =
        Duration(hours: -5); // Zona horaria de Lima, Perú (UTC-5)
    final dateTime = DateTime.fromMillisecondsSinceEpoch(epochMillis)
        .toUtc()
        .add(timeZoneOffset);

    final formattedDate =
        DateFormat('dd/MM/yyyy HH:mm', 'es_PE').format(dateTime);

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título y estado del animal
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Text(
                      'Salud: Normal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Temperatura
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Temperatura',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  (temperature != null)
                      ? Text(
                          '${temperature!.data.temp} °C',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )
                      : const Text(
                          '- °C',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                  const SizedBox(height: 10),
                  (temperature != null)
                      ? Text(
                          'Último registro: ${epochToFormattedString(temperature!.data.createdTime)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )
                      : const Text(
                          'Último registro: -',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )
                ],
              ),
            ),
            // Otras variables fisiológicas
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Acción al hacer clic en "Frecuencia cardíaca"
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HeartRatePage(title: 'Frecuencia cardíaca'),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.favorite,
                                size: 32,
                                color: AppColors.primaryColor,
                              ),
                              const Text(
                                'Frecuencia cardíaca',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              (pulse != null)
                                  ? Text(
                                      '${pulse!.data.avg} ppm',
                                      style: const TextStyle(fontSize: 24),
                                    )
                                  : const Text(
                                      '- ppm',
                                      style: TextStyle(fontSize: 24),
                                    ),
                              const SizedBox(height: 10),
                              (pulse != null)
                                  ? Text(
                                      'Último registro: ${epochToFormattedString(temperature!.data.createdTime)}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    )
                                  : const Text(
                                      'Último registro: -',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/ecg_graph');
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Icon(
                                Icons.query_stats,
                                color: AppColors.primaryColor,
                                size: 32,
                              ),
                              Text(
                                'Electrocardiograma',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Normal',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
