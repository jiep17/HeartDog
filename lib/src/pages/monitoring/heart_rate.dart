import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries>[
            LineSeries<double, String>(
              dataSource: frequencyData,
              xValueMapper: (double value, _) =>
                  ['10:10', '10:20', '10:30', '10:40', '10:50', '10:60'][
                      frequencyData.indexOf(value)],
              yValueMapper: (value, _) => value,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
