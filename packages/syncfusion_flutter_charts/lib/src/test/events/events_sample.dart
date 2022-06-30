import 'package:flutter/material.dart';
import '../../../charts.dart';
import '../annotation/annotation_sample.dart';
import '../pie_series/pie_sample.dart';

/// Method to get the chart event sample
SfCartesianChart getChartEventsSample(String sampleName) {
  SfCartesianChart chart;
  final List<ChartData> data = <ChartData>[
    ChartData(2014, 40),
    ChartData(2015, 24),
    ChartData(2016, 15),
    ChartData(2017, 25),
    ChartData(2018, 30),
  ];
  final dynamic data1 = <_ScatterSampl>[
    _ScatterSampl(DateTime(2005, 0), 'India', 1.5, 32, 28, 680, 760, 1,
        Colors.deepOrange),
    _ScatterSampl(DateTime(2006, 0), 'China', 2.2, 24, 44, 550, 880, 2,
        Colors.deepPurple),
    _ScatterSampl(
        DateTime(2007, 0), 'USA', 3.32, 36, 48, 440, 788, 3, Colors.lightGreen),
    _ScatterSampl(
        DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    _ScatterSampl(
        DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5, Colors.purple)
  ];
  final List<_EventData> eventData = <_EventData>[
    _EventData(DateTime(2005, 0), 'India', 1.5, 32, 28, 680, 760, 1,
        Colors.deepOrange),
    _EventData(DateTime(2006, 0), 'China', 2.2, 24, 44, 550, 880, 2,
        Colors.deepPurple),
    _EventData(
        DateTime(2007, 0), 'USA', 3.32, 36, 48, 440, 788, 3, Colors.lightGreen),
    _EventData(
        DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    _EventData(
        DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5, Colors.purple)
  ];
  switch (sampleName) {
    case 'cartesian_onActualRangeChanged_numeric':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        onActualRangeChanged: (ActualRangeChangedArgs args) =>
            _actualRangeChanged(args),
        series: <ChartSeries<ChartData, num>>[
          ColumnSeries<ChartData, num>(
            animationDuration: 0,
            dataSource: data,
            xValueMapper: (ChartData sales, _) => sales.x,
            yValueMapper: (ChartData sales, _) => sales.y,
          )
        ],
      );
      break;
    case 'cartesian_onMarkerRender':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          onMarkerRender: (MarkerRenderArgs markerargs) {
            if (markerargs.pointIndex == 2) {
              markerargs.markerHeight = 50.0;
              markerargs.markerWidth = 50.0;
              markerargs.shape = DataMarkerType.none;
            }
          },
          primaryXAxis: CategoryAxis(),
          series: <LineSeries<_SalesData1, dynamic>>[
            LineSeries<_SalesData1, dynamic>(
                markerSettings: const MarkerSettings(
                  isVisible: true,
                  height: 15,
                  width: 17,
                ),
                // Bind data source
                dataSource: <_SalesData1>[
                  _SalesData1('Jan', 35),
                  _SalesData1('Feb', 28),
                  _SalesData1('Mar', 34),
                  _SalesData1('Apr', 32),
                  _SalesData1('May', 40)
                ],
                xValueMapper: (_SalesData1 sales, _) => sales.year,
                yValueMapper: (_SalesData1 sales, _) => sales.sales)
          ]);
      break;
    case 'events_marker_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          onMarkerRender: (MarkerRenderArgs markerargs) {
            if (markerargs.pointIndex == 2) {
              markerargs.markerHeight = 15.0;
              markerargs.markerWidth = 15.0;
              markerargs.shape = DataMarkerType.triangle;
            }
          },
          primaryXAxis: CategoryAxis(),
          series: <ScatterSeries<_ScatterSampl, String>>[
            ScatterSeries<_ScatterSampl, String>(
                dataSource: data1,
                animationDuration: 0,
                xValueMapper: (_ScatterSampl sales, _) => sales.category,
                yValueMapper: (_ScatterSampl sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'cartesian_RangeChanged_dateTime':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(),
        onActualRangeChanged: (ActualRangeChangedArgs args) =>
            _rangeChangedDate(args),
        series: <ChartSeries<_EventData, DateTime>>[
          ColumnSeries<_EventData, DateTime>(
              animationDuration: 0,
              dataSource: eventData,
              xValueMapper: (_EventData sales, _) => sales.year,
              yValueMapper: (_EventData sales, _) => sales.sales1)
        ],
      );
      break;
    case 'cartesian_RangeChanged_category':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: CategoryAxis(),
        onActualRangeChanged: (ActualRangeChangedArgs args) =>
            _rangeChangedCategory(args),
        series: <ChartSeries<_EventData, String>>[
          ColumnSeries<_EventData, String>(
              animationDuration: 0,
              dataSource: eventData,
              xValueMapper: (_EventData sales, _) => sales.category,
              yValueMapper: (_EventData sales, _) => sales.sales1)
        ],
      );
      break;
    case 'cartesian_AxisLabel_DataLabel_Legend':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        legend: Legend(isVisible: true),
        primaryXAxis: NumericAxis(
            axisLabelFormatter: (AxisLabelRenderDetails args) =>
                ChartAxisLabel('8', args.textStyle)),
        primaryYAxis: NumericAxis(
          axisLabelFormatter: (AxisLabelRenderDetails args) =>
              ChartAxisLabel('10', args.textStyle),
        ),
        onLegendItemRender: (LegendRenderArgs args) => _legendItem(args),
        onDataLabelRender: (DataLabelRenderArgs args) =>
            args.text = 'Custom Label',
        series: <ChartSeries<ChartData, num>>[
          ColumnSeries<ChartData, num>(
              animationDuration: 0,
              dataSource: data,
              xValueMapper: (ChartData sales, _) => sales.x,
              yValueMapper: (ChartData sales, _) => sales.y,
              dataLabelSettings: const DataLabelSettings(isVisible: true))
        ],
      );
      break;
    default:
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
      );
  }
  return chart;
}

/// Metho to get the circular chart sample
SfCircularChart? getCircularChartSample(String sampleName) {
  SfCircularChart? circularChart;
  final dynamic data = <PieSample>[
    PieSample('India', 1, 32, 28, Colors.deepOrange),
    PieSample('China', 2, 24, 44, Colors.deepPurple),
    PieSample('USA', 3, 36, 48, Colors.lightGreen),
    PieSample('Japan', 4, 38, 50, Colors.red),
    PieSample('Russia', 5, 54, 66, Colors.purple)
  ];
  switch (sampleName) {
    case 'circular_DataLabel_Legend':
      circularChart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Default Rendering'),
          onLegendItemRender: (LegendRenderArgs args) =>
              _circularLegendItem(args),
          onDataLabelRender: (DataLabelRenderArgs args) =>
              _circularDataLabel(args),
          series: <CircularSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside))
          ]);
      break;
    case 'circular_Empty_DataLabel':
      circularChart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          onDataLabelRender: (DataLabelRenderArgs args) {
            args.text = '';
          },
          series: <CircularSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside))
          ]);
      break;
  }
  return circularChart;
}

/// Method to get the pyramid chart sample
SfPyramidChart? getPyramidChartSample(String sampleName) {
  SfPyramidChart? circularChart;
  final dynamic data = <PieSample>[
    PieSample('India', 1, 32, 28, Colors.deepOrange),
    PieSample('China', 2, 24, 44, Colors.deepPurple),
    PieSample('USA', 3, 36, 48, Colors.lightGreen),
    PieSample('Japan', 4, 38, 50, Colors.red),
    PieSample('Russia', 5, 54, 66, Colors.purple)
  ];
  switch (sampleName) {
    case 'triangular_DataLabel_Legend':
      circularChart = SfPyramidChart(
          key: GlobalKey<State<SfPyramidChart>>(),
          title: ChartTitle(text: 'Default Rendering'),
          onLegendItemRender: (LegendRenderArgs args) =>
              _circularLegendItem(args),
          onDataLabelRender: (DataLabelRenderArgs args) =>
              _circularDataLabel(args),
          series: PyramidSeries<PieSample, String>(
            animationDuration: 0,
            dataSource: data,
            xValueMapper: (PieSample sales, _) => sales.category,
            yValueMapper: (PieSample sales, _) => sales.sales1,
          ));
      break;
  }
  return circularChart;
}

LegendRenderArgs _circularLegendItem(LegendRenderArgs args) {
  args.text = 'Custom Legend';
  args.legendIconType = LegendIconType.diamond;
  return args;
}

DataLabelRenderArgs _circularDataLabel(DataLabelRenderArgs args) {
  args.text = 'Custom Label';
  return args;
}

void _actualRangeChanged(ActualRangeChangedArgs args) {
  if (args.orientation == AxisOrientation.vertical) {
    args.visibleMin = 5;
    args.visibleMax = 50;
    args.visibleInterval = 5;
  } else {
    args.visibleMin = 2008;
    args.visibleMax = 2020;
    args.visibleInterval = 4;
  }
}

void _rangeChangedCategory(ActualRangeChangedArgs args) {
  if (args.orientation == AxisOrientation.vertical) {
    args.visibleMin = 5;
    args.visibleMax = 50;
    args.visibleInterval = 5;
  } else {
    args.visibleMin = 2;
    args.visibleMax = 4;
    args.visibleInterval = 1;
  }
}

void _rangeChangedDate(ActualRangeChangedArgs args) {
  if (args.orientation == AxisOrientation.vertical) {
    args.visibleMin = 5;
    args.visibleMax = 50;
    args.visibleInterval = 5;
  } else {
    args.visibleMin = DateTime(2006, 0).millisecondsSinceEpoch;
    args.visibleMax = DateTime(2008, 0).millisecondsSinceEpoch;
    args.visibleInterval = 1;
  }
}

void _legendItem(LegendRenderArgs args) {
  args.text = 'Custom Legend';
  args.legendIconType = LegendIconType.diamond;
}

class _EventData {
  _EventData(this.year, this.category, this.numeric, this.sales1, this.sales2,
      this.sales3, this.sales4, this.xData,
      [this.lineColor]);
  final DateTime year;
  final String category;
  final double numeric;
  final int sales1;
  final int sales2;
  final int sales3;
  final int sales4;
  final int xData;
  final Color? lineColor;
}

class _SalesData1 {
  _SalesData1(this.year, this.sales);
  final String year;
  final double sales;
}

class _ScatterSampl {
  _ScatterSampl(this.year, this.category, this.numeric, this.sales1,
      this.sales2, this.sales3, this.sales4, this.xData,
      [this.lineColor]);
  final DateTime year;
  final String category;
  final double numeric;
  final int sales1;
  final int sales2;
  final int sales3;
  final int sales4;
  final int xData;
  final Color? lineColor;
}
