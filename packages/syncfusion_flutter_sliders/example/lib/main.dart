import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide LabelPlacement;
import 'package:syncfusion_flutter_sliders/sliders.dart';

void main() {
  return runApp(const RangeSelectorApp());
}

/// This widget will be the root of application.
class RangeSelectorApp extends StatelessWidget {
  ///Initialize the instance of the [RangeSelectorApp] class.
  const RangeSelectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Range Selector Demo',
      home: MyHomePage(),
    );
  }
}

/// This widget is the home page of the application.
class MyHomePage extends StatefulWidget {
  /// Initialize the instance of the [MyHomePage] class.
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();

  final List<Data> _chartData = <Data>[
    Data(x: DateTime(2003), y: 3.4),
    Data(x: DateTime(2004), y: 2.8),
    Data(x: DateTime(2005), y: 1.6),
    Data(x: DateTime(2006), y: 2.3),
    Data(x: DateTime(2007), y: 2.5),
    Data(x: DateTime(2008), y: 2.9),
    Data(x: DateTime(2009), y: 3.8),
    Data(x: DateTime(2010), y: 2.0),
  ];

  final DateTime _dateMin = DateTime(2003);
  final DateTime _dateMax = DateTime(2010);
  final SfRangeValues _dateValues =
      SfRangeValues(DateTime(2005), DateTime(2008));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter Range Selector'),
      ),
      body: Container(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  // ignore: missing_required_param
                  child: SfRangeSelector(
                    min: _dateMin,
                    max: _dateMax,
                    initialValues: _dateValues,
                    labelPlacement: LabelPlacement.betweenTicks,
                    interval: 1,
                    dateIntervalType: DateIntervalType.years,
                    dateFormat: DateFormat.y(),
                    showTicks: true,
                    showLabels: true,
                    child: SizedBox(
                      height: 200,
                      child: SfCartesianChart(
                        margin: EdgeInsets.zero,
                        primaryXAxis: DateTimeAxis(
                          minimum: _dateMin,
                          maximum: _dateMax,
                          isVisible: false,
                        ),
                        primaryYAxis: const NumericAxis(
                          isVisible: false,
                          maximum: 4,
                        ),
                        series: <SplineAreaSeries<Data, DateTime>>[
                          SplineAreaSeries<Data, DateTime>(
                              dataSource: _chartData,
                              xValueMapper: (Data sales, int index) => sales.x,
                              yValueMapper: (Data sales, int index) => sales.y)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

/// Storing the spline series data points.
class Data {
  /// Initialize the instance of the [Data] class.
  Data({required this.x, required this.y});

  /// Spline series x points.
  final DateTime x;

  /// Spline series y points.
  final double y;
}
