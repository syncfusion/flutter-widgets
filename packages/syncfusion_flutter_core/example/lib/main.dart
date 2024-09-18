import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  return runApp(const ChartApp());
}

class ChartApp extends StatelessWidget {
  const ChartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chart Demo',
      home: _SalesAnalysisPage(),
    );
  }
}

class _SalesAnalysisPage extends StatefulWidget {
  @override
  State createState() => _SalesAnalysisPageState();
}

class _SalesAnalysisPageState extends State<_SalesAnalysisPage> {
  late List<_SalesData> _sales;

  @override
  void initState() {
    _sales = <_SalesData>[
      _SalesData('Jan', 35),
      _SalesData('Feb', 28),
      _SalesData('Mar', 34),
      _SalesData('Apr', 32),
      _SalesData('May', 40),
      _SalesData('Jun', 47),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Syncfusion Flutter Chart')),
      body: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        // Chart title.
        title: const ChartTitle(text: 'Half yearly sales analysis'),
        // Enable legend.
        legend: const Legend(isVisible: true),
        // Enable tooltip.
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<_SalesData, String>>[
          LineSeries(
            name: 'Sales',
            dataSource: _sales,
            xValueMapper: (_SalesData sales, int index) => sales.year,
            yValueMapper: (_SalesData sales, int index) => sales.sales,
            // Enable data label.
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _sales.clear();
    super.dispose();
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
