import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  return runApp(ChartApp());
}

///Renders the chart widget
class ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chart Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: _MyHomePage());
  }
}

class _MyHomePage extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  _MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Syncfusion Flutter Chart')),
        body:
            SfCartesianChart()); // Commented until the chart moves to null safety;
  }
}
