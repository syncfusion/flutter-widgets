import 'package:flutter/material.dart';
import '../../../charts.dart';

dynamic _histogramData;

/// Method to get the histrogram chart
SfCartesianChart getHistogramchart(String sampleName) {
  SfCartesianChart chart;
  _histogramData = <_HistogramSample>[
    _HistogramSample(1),
    _HistogramSample(9),
    _HistogramSample(4),
    _HistogramSample(7),
    _HistogramSample(5)
  ];

  // final List<Color> color = <Color>[];
  // color.add(Colors.pink[50]);
  // color.add(Colors.pink[200]);
  // color.add(Colors.pink);

  // final List<double> stops = <double>[];
  // stops.add(0.0);
  // stops.add(0.5);
  // stops.add(1.0);

  // final LinearGradient gradientColors = LinearGradient(colors: color, stops: stops);

  switch (sampleName) {
    case 'marker_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <HistogramSeries<_HistogramSample, String>>[
            HistogramSeries<_HistogramSample, String>(
                dataSource: _histogramData,
                animationDuration: 0,
                yValueMapper: (_HistogramSample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'marker_cutomization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <HistogramSeries<_HistogramSample, String>>[
            HistogramSeries<_HistogramSample, String>(
                enableTooltip: true,
                dataSource: _histogramData,
                animationDuration: 0,
                yValueMapper: (_HistogramSample sales, _) => sales.sales1,
                pointColorMapper: (_HistogramSample sales, _) => Colors.red,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.diamond,
                    borderColor: Colors.red,
                    borderWidth: 5)),
          ]);
      break;
    case 'marker_EmptyPoint':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <HistogramSeries<_HistogramSample, String>>[
            HistogramSeries<_HistogramSample, String>(
                enableTooltip: true,
                dataSource: _histogramData,
                animationDuration: 0,
                yValueMapper: (_HistogramSample sales, _) => sales.sales1,
                pointColorMapper: (_HistogramSample sales, _) => Colors.red,
                emptyPointSettings: EmptyPointSettings(
                    mode: EmptyPointMode.zero, color: Colors.green),
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.horizontalLine,
                    borderColor: Colors.red,
                    borderWidth: 5)),
          ]);
      break;
    case 'marker_rect':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <HistogramSeries<_HistogramSample, String>>[
            HistogramSeries<_HistogramSample, String>(
                enableTooltip: true,
                dataSource: _histogramData,
                animationDuration: 0,
                yValueMapper: (_HistogramSample sales, _) => sales.sales1,
                pointColorMapper: (_HistogramSample sales, _) => Colors.red,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.rectangle,
                    borderColor: Colors.red,
                    borderWidth: 5)),
          ]);
      break;
    case 'marker_pentagon':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <HistogramSeries<_HistogramSample, String>>[
            HistogramSeries<_HistogramSample, String>(
                enableTooltip: true,
                dataSource: _histogramData,
                yValueMapper: (_HistogramSample sales, _) => sales.sales1,
                pointColorMapper: (_HistogramSample sales, _) => Colors.red,
                animationDuration: 0,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.pentagon,
                    borderColor: Colors.red,
                    borderWidth: 5)),
          ]);
      break;
    case 'marker_verticalLine':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <HistogramSeries<_HistogramSample, String>>[
            HistogramSeries<_HistogramSample, String>(
                enableTooltip: true,
                dataSource: _histogramData,
                yValueMapper: (_HistogramSample sales, _) => sales.sales1,
                pointColorMapper: (_HistogramSample sales, _) => Colors.red,
                animationDuration: 0,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.verticalLine,
                    borderColor: Colors.red,
                    borderWidth: 5)),
          ]);
      break;
    case 'marker_invertTriangle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <HistogramSeries<_HistogramSample, String>>[
            HistogramSeries<_HistogramSample, String>(
                enableTooltip: true,
                dataSource: _histogramData,
                yValueMapper: (_HistogramSample sales, _) => sales.sales1,
                pointColorMapper: (_HistogramSample sales, _) => Colors.red,
                animationDuration: 0,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.invertedTriangle,
                    borderColor: Colors.red,
                    borderWidth: 5)),
          ]);
      break;
    case 'marker_triangle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <HistogramSeries<_HistogramSample, String>>[
            HistogramSeries<_HistogramSample, String>(
                enableTooltip: true,
                dataSource: _histogramData,
                yValueMapper: (_HistogramSample sales, _) => sales.sales1,
                pointColorMapper: (_HistogramSample sales, _) => Colors.red,
                animationDuration: 0,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.triangle,
                    borderColor: Colors.red,
                    borderWidth: 5)),
          ]);
      break;
    default:
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
      );
  }

  return chart;
}

class _HistogramSample {
  _HistogramSample(this.sales1);
  final int sales1;
}
