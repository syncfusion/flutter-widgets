import 'package:syncfusion_flutter_sliders/sliders.dart';
// import 'package:syncfusion_flutter_charts/charts.dart' hide LabelPlacement;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  return runApp(RangeSelectorApp());
}

/// This widget will be the root of application.
class RangeSelectorApp extends StatelessWidget {
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
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();

  // final List<Data> _chartData = <Data>[
  //   Data(x: DateTime(2003, 01, 01), y: 3.4),
  //   Data(x: DateTime(2004, 01, 01), y: 2.8),
  //   Data(x: DateTime(2005, 01, 01), y: 1.6),
  //   Data(x: DateTime(2006, 01, 01), y: 2.3),
  //   Data(x: DateTime(2007, 01, 01), y: 2.5),
  //   Data(x: DateTime(2008, 01, 01), y: 2.9),
  //   Data(x: DateTime(2009, 01, 01), y: 3.8),
  //   Data(x: DateTime(2010, 01, 01), y: 2.0),
  // ];

  final DateTime _dateMin = DateTime(2003, 01, 01);
  final DateTime _dateMax = DateTime(2010, 01, 01);
  final SfRangeValues _dateValues =
      SfRangeValues(DateTime(2005, 01, 01), DateTime(2008, 01, 01));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter Range Selector'),
      ),
      body: Container(
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.all(0),
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
                    // child: Container(
                    //   child: SfCartesianChart(
                    //     margin: const EdgeInsets.all(0),
                    //     primaryXAxis: DateTimeAxis(
                    //       minimum: dateMin,
                    //       maximum: dateMax,
                    //       isVisible: false,
                    //     ),
                    //     primaryYAxis:
                    // NumericAxis(isVisible: false, maximum: 4),
                    //     series: <SplineAreaSeries<Data, DateTime>>[
                    //       SplineAreaSeries<Data, DateTime>(
                    //           dataSource: chartData,
                    //           xValueMapper: (Data sales, _) => sales.x,
                    //           yValueMapper: (Data sales, _) => sales.y)
                    //     ],
                    //   ),
                    //   height: 200,
                    // ),
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
  Data({this.x, this.y});

  /// Spline series x points.
  final DateTime x;

  /// Spline series y points.
  final double y;
}
