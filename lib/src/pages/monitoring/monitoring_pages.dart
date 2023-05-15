import 'package:flutter/material.dart';
import 'package:heartdog/src/pages/home_page.dart';
import 'package:heartdog/src/pages/monitoring/heart_rate.dart';
import 'package:heartdog/src/pages/monitoring/respiratory_rate.dart';

class MonitoringPage extends StatefulWidget {
  const MonitoringPage({Key? key}) : super(key: key);

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  final double temperatura = 37.5;

  final List<double> valoresFisiologicos = [
    70.0, // Frecuencia cardiaca
    20.0, // Frecuencia respiratoria (en respiraciones por minuto)
    60.0, // Actividad física (en minutos)
    8.0, // Sueño (en horas)
    3.5, // Nivel de estrés (en una escala de 1 a 5)
    0.8 // Nivel de hidratación (en una escala de 0 a 1)
  ];

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
                  const Text(
                    'Monitoreo',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${temperatura.toStringAsFixed(1)} °C',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // Otras variables fisiológicas
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Acción al hacer clic en "Frecuencia cardíaca"
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HeartRatePage(
                            title: 'Frecuencia cardíaca',
                            frequencyData: [70, 72, 74, 73, 75, 76],
                          ),
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
                                color: Colors.red,
                              ),
                              const Text(
                                'Frecuencia cardíaca',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                valoresFisiologicos[0].toString(),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      // Acción al hacer clic en "Frecuencia respiratoria"
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RespiratoryRatePage(
                          title: 'Frecuencia respiratoria',
                          frequencyData: [70, 72, 74, 73, 75, 76],
                          ),
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
                                Icons.air_outlined,
                                color: Colors.blue,
                              ),
                              const Text(
                                'Frecuencia respiratoria',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                valoresFisiologicos[1].toString(),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/icon-dog-running.png',
                              width: 30,
                              height: 30,
                            ),
                            const Text(
                              'Actividad física',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              valoresFisiologicos[2].toString(),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/icon-dog-sleep.png',
                              width: 30,
                              height: 30,
                            ),
                            const Text(
                              'Sueño',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              valoresFisiologicos[3].toString(),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.add_reaction_outlined,
                              // Icons.stress_outlined,
                              color: Colors.deepPurple,
                            ),
                            const Text(
                              'Nivel de estrés',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              valoresFisiologicos[4].toString(),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.local_drink_outlined,
                              color: Colors.teal,
                            ),
                            const Text(
                              'Nivel de hidratación',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              valoresFisiologicos[5].toString(),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
