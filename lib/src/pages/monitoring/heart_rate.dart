import 'package:flutter/material.dart';
import 'package:heartdog/src/util/app_colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HeartRatePage extends StatelessWidget {
  final String title;
  final List<double> frequencyData;

  const HeartRatePage({
    Key? key,
    required this.title,
    required this.frequencyData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double average = calculateAverage(frequencyData);
    double min =
        frequencyData.reduce((curr, next) => curr < next ? curr : next);
    double max =
        frequencyData.reduce((curr, next) => curr > next ? curr : next);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
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
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries>[
                    LineSeries<double, String>(
                      dataSource: frequencyData,
                      xValueMapper: (double value, _) => [
                        '10:10',
                        '10:20',
                        '10:30',
                        '10:40',
                        '10:50',
                        '10:60'
                      ][frequencyData.indexOf(value)],
                      yValueMapper: (value, _) => value,
                      color: AppColors.secondaryColor,
                    ),
                  ],
                ),
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
                        'Promedio: ${average.toStringAsFixed(1)} ppm',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Mínimo: ${min.toStringAsFixed(1)} ppm',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Máximo: ${max.toStringAsFixed(1)} ppm',
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
                      SizedBox(height: 8.0),
                      Text(
                        'Promedio: 70-90 ppm',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Mínimo: 60 ppm',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Máximo: 120 ppm',
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
}
