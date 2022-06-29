// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import '../../../charts.dart';
import '../area_series/area_sample.dart';
import '../bar_series/bar_sample.dart';
import '../column_series/column_sample.dart';
import '../line_series/line_sample.dart';
import '../range_area_series/range_area_sample.dart';
import '../range_column_series/range_column_sample.dart';

/// To get the user interaction chart
SfCartesianChart getUserInteractionChart(String sampleName) {
  SfCartesianChart chart;

  columnData = <ColumnSample>[
    ColumnSample(DateTime(2005, 0, 1), 'India', 1, 32, 28, 680, 760, 1,
        Colors.deepOrange),
    ColumnSample(DateTime(2006, 0, 1), 'China', 2, 24, 44, 550, 880, 2,
        Colors.deepPurple),
    ColumnSample(
        DateTime(2007, 0, 1), 'USA', 3, 36, 48, 440, 788, 3, Colors.lightGreen),
    ColumnSample(
        DateTime(2008, 0, 1), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    ColumnSample(DateTime(2009, 0, 1), 'Russia', 5.87, 54, 66, 444, 566, 5,
        Colors.purple)
  ];
  final dynamic data = <RangeAreaData>[
    RangeAreaData(DateTime(2005, 0, 1), 'India', 1.5, 32, 28, 680, 760, 1,
        Colors.deepOrange),
    RangeAreaData(DateTime(2006, 0, 1), 'China', 2.2, 24, 44, 550, 880, 2,
        Colors.deepPurple),
    RangeAreaData(DateTime(2007, 0, 1), 'USA', 3.32, 36, 48, 440, 788, 3,
        Colors.lightGreen),
    RangeAreaData(
        DateTime(2008, 0, 1), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    RangeAreaData(DateTime(2009, 0, 1), 'Russia', 5.87, 54, 66, 444, 566, 5,
        Colors.purple)
  ];

  final dynamic barData = <BarSample>[
    BarSample(DateTime(2005, 0, 1), 'India', 1, 32, 28, 680, 760, 1,
        Colors.deepOrange),
    BarSample(DateTime(2006, 0, 1), 'China', 2, 24, 44, 550, 880, 2,
        Colors.deepPurple),
    BarSample(
        DateTime(2007, 0, 1), 'USA', 3, 36, 48, 440, 788, 3, Colors.lightGreen),
    BarSample(
        DateTime(2008, 0, 1), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    BarSample(DateTime(2009, 0, 1), 'Russia', 5.87, 54, 66, 444, 566, 5,
        Colors.purple)
  ];

  final dynamic areaData = <AreaData>[
    AreaData(DateTime(2005, 0, 1), 'India', 1.5, 32, 28, 680, 760, 1,
        Colors.deepOrange),
    AreaData(DateTime(2006, 0, 1), 'China', 2.2, 24, 44, 550, 880, 2,
        Colors.deepPurple),
    AreaData(DateTime(2007, 0, 1), 'USA', 3.32, 36, 48, 440, 788, 3,
        Colors.lightGreen),
    AreaData(
        DateTime(2008, 0, 1), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    AreaData(DateTime(2009, 0, 1), 'Russia', 5.87, 54, 66, 444, 566, 5,
        Colors.purple)
  ];
  final dynamic lineData = <LineSample>[
    LineSample(DateTime(2005, 0, 1), 'India', 1.5, 32, 28, 680, 760, 1,
        Colors.deepOrange),
    LineSample(DateTime(2006, 0, 1), 'China', 2.2, 24, 44, 550, 880, 2,
        Colors.deepPurple),
    LineSample(DateTime(2007, 0, 1), 'USA', 3.32, 36, 48, 440, 788, 3,
        Colors.lightGreen),
    LineSample(
        DateTime(2008, 0, 1), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    LineSample(DateTime(2009, 0, 1), 'Russia', 5.87, 54, 66, 444, 566, 5,
        Colors.purple)
  ];
  final dynamic lineData1 = <LineSample>[
    LineSample(
        DateTime(2006, 0, 1), 'german', 1, 31, 27, 681, 762, 2, Colors.blue),
    LineSample(
        DateTime(2007, 0, 1), 'Uk', 2, 24, 42, 551, 882, 3, Colors.green),
    LineSample(
        DateTime(2008, 0, 1), 'africa', 3, 37, 47, 442, 788, 4, Colors.yellow),
    LineSample(
        DateTime(2009, 0, 1), 'Canada', 4, 39, 49, 350, 563, 5, Colors.black),
    LineSample(
        DateTime(2010, 0, 1), 'India', 5, 53, 65, 447, 566, 6, Colors.purple)
  ];

  final dynamic hiloSeriesDate = <ChartSamplesData>[
    ChartSamplesData(
        17, DateTime(2016, 02, 15), 95.02, 98.89, 94.61, 96.04, 167001070),
    ChartSamplesData(
        18, DateTime(2016, 02, 22), 96.31, 98.0237, 93.32, 96.91, 158759600),
    ChartSamplesData(
        19, DateTime(2016, 02, 29), 96.86, 103.75, 96.65, 103.01, 201482180),
    ChartSamplesData(
        20, DateTime(2016, 03, 07), 102.39, 102.83, 100.15, 102.26, 155437450),
    ChartSamplesData(
        21, DateTime(2016, 03, 14), 101.91, 106.5, 101.78, 105.92, 181323210),
    ChartSamplesData(
        22, DateTime(2016, 03, 21), 105.93, 107.65, 104.89, 105.67, 119054360),
    ChartSamplesData(
        23, DateTime(2016, 03, 28), 106, 110.42, 104.88, 109.99, 147641240),
    ChartSamplesData(
        24, DateTime(2016, 04, 04), 110.42, 112.19, 108.121, 108.66, 145351790),
    ChartSamplesData(
        25, DateTime(2016, 04, 11), 108.97, 112.39, 108.66, 109.85, 161518860),
    ChartSamplesData(
        26, DateTime(2016, 04, 18), 108.89, 108.95, 104.62, 105.68, 188775240),
    ChartSamplesData(
        27, DateTime(2016, 04, 25), 105, 105.65, 92.51, 93.74, 345910030),
    ChartSamplesData(
        28, DateTime(2016, 05, 02), 93.965, 95.9, 91.85, 92.72, 225114110),
    ChartSamplesData(
        29, DateTime(2016, 05, 09), 93, 93.77, 89.47, 90.52, 215596350),
    ChartSamplesData(
        30, DateTime(2016, 05, 16), 92.39, 95.43, 91.65, 95.22, 212312980),
    ChartSamplesData(
        31, DateTime(2016, 05, 23), 95.87, 100.73, 95.67, 100.35, 203902650),
    ChartSamplesData(
        32, DateTime(2016, 05, 30), 99.6, 100.4, 96.63, 97.92, 140064910),
    ChartSamplesData(
        33, DateTime(2016, 06, 06), 97.99, 101.89, 97.55, 98.83, 124731320),
    ChartSamplesData(
        34, DateTime(2016, 06, 13), 98.69, 99.12, 95.3, 95.33, 191017280),
    ChartSamplesData(
        35, DateTime(2016, 06, 20), 96, 96.89, 92.65, 93.4, 206149160),
    ChartSamplesData(
        36, DateTime(2016, 06, 27), 93, 96.465, 91.5, 95.89, 184254460),
    ChartSamplesData(
        37, DateTime(2016, 07, 04), 95.39, 96.89, 94.37, 96.68, 111769640),
    ChartSamplesData(
        38, DateTime(2016, 07, 11), 96.75, 99.3, 96.73, 98.78, 142244590),
    ChartSamplesData(
        39, DateTime(2016, 07, 18), 98.7, 101, 98.31, 98.66, 147358320),
    ChartSamplesData(
        40, DateTime(2016, 07, 25), 98.25, 104.55, 96.42, 104.21, 252358930),
    ChartSamplesData(
        41, DateTime(2016, 08, 01), 104.41, 107.65, 104, 107.48, 168265830),
    ChartSamplesData(
        42, DateTime(2016, 08, 08), 107.52, 108.94, 107.16, 108.18, 124255340),
    ChartSamplesData(
        43, DateTime(2016, 08, 15), 108.14, 110.23, 108.08, 109.36, 131814920),
    ChartSamplesData(
        44, DateTime(2016, 08, 22), 108.86, 109.32, 106.31, 106.94, 123373540),
    ChartSamplesData(
        45, DateTime(2016, 08, 29), 106.62, 108, 105.5, 107.73, 134426100),
    ChartSamplesData(
        46, DateTime(2016, 09, 05), 107.9, 108.76, 103.13, 103.13, 168312530),
    ChartSamplesData(
        47, DateTime(2016, 09, 12), 102.65, 116.13, 102.53, 114.92, 388543710),
    ChartSamplesData(
        48, DateTime(2016, 09, 19), 115.19, 116.18, 111.55, 112.71, 200842480),
    ChartSamplesData(
        49, DateTime(2016, 09, 26), 111.64, 114.64, 111.55, 113.05, 156186800),
    ChartSamplesData(
        50, DateTime(2016, 10, 03), 112.71, 114.56, 112.28, 114.06, 125587350),
    ChartSamplesData(
        51, DateTime(2016, 10, 10), 115.02, 118.69, 114.72, 117.63, 208231690),
    ChartSamplesData(
        52, DateTime(2016, 10, 17), 117.33, 118.21, 113.8, 116.6, 114497020),
    ChartSamplesData(
        53, DateTime(2016, 10, 24), 117.1, 118.36, 113.31, 113.72, 204530120),
    ChartSamplesData(
        54, DateTime(2016, 10, 31), 113.65, 114.23, 108.11, 108.84, 155287280),
    ChartSamplesData(
        55, DateTime(2016, 11, 07), 110.08, 111.72, 105.83, 108.43, 206825070),
    ChartSamplesData(
        56, DateTime(2016, 11, 14), 107.71, 110.54, 104.08, 110.06, 197790040),
    ChartSamplesData(
        57, DateTime(2016, 11, 21), 110.12, 112.42, 110.01, 111.79, 93992370),
    ChartSamplesData(
        58, DateTime(2016, 11, 28), 111.43, 112.465, 108.85, 109.9, 155229390),
    ChartSamplesData(
        59, DateTime(2016, 12, 05), 110, 114.7, 108.25, 113.95, 151624650),
    ChartSamplesData(
        60, DateTime(2016, 12, 12), 113.29, 116.73, 112.49, 115.97, 194003220),
    ChartSamplesData(
        61, DateTime(2016, 12, 19), 115.8, 117.5, 115.59, 116.52, 113106370),
    ChartSamplesData(
        62, DateTime(2016, 12, 26), 116.52, 118.0166, 115.43, 115.82, 84354060),
  ];

  switch (sampleName) {
    case 'line_with_multiselect':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          enableMultiSelection: true,
          selectionGesture: ActivationMode.singleTap,
          primaryXAxis: CategoryAxis(),
          selectionType: SelectionType.series,
          series: <LineSeries<ColumnSample, String>>[
            LineSeries<ColumnSample, String>(
              // initialSelectedDataIndexes: <int>[1,0],
              selectionBehavior: SelectionBehavior(
                  enable: true,
                  selectedColor: Colors.red,
                  unselectedColor: Colors.grey,
                  selectedBorderColor: Colors.blue,
                  unselectedBorderColor: Colors.lightGreen,
                  selectedBorderWidth: 2,
                  unselectedBorderWidth: 0),
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
            LineSeries<ColumnSample, String>(
              selectionBehavior: SelectionBehavior(
                  enable: true,
                  selectedColor: Colors.red,
                  unselectedColor: Colors.grey,
                  selectedBorderColor: Colors.blue,
                  unselectedBorderColor: Colors.lightGreen,
                  selectedBorderWidth: 2,
                  unselectedBorderWidth: 0),
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales2,
            )
          ]);
      break;
    case 'line_with_clustermode':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          enableMultiSelection: true,
          selectionGesture: ActivationMode.singleTap,
          primaryXAxis: CategoryAxis(),
          selectionType: SelectionType.cluster,
          series: <LineSeries<ColumnSample, String>>[
            LineSeries<ColumnSample, String>(
              // initialSelectedDataIndexes: <int>[1,0],
              selectionBehavior: SelectionBehavior(
                  enable: true,
                  selectedColor: Colors.red,
                  unselectedColor: Colors.grey,
                  selectedBorderColor: Colors.blue,
                  unselectedBorderColor: Colors.lightGreen,
                  selectedBorderWidth: 2,
                  unselectedBorderWidth: 0),
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
            LineSeries<ColumnSample, String>(
              selectionBehavior: SelectionBehavior(
                  enable: true,
                  selectedColor: Colors.red,
                  unselectedColor: Colors.grey,
                  selectedBorderColor: Colors.blue,
                  unselectedBorderColor: Colors.lightGreen,
                  selectedBorderWidth: 2,
                  unselectedBorderWidth: 0),
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales2,
            )
          ]);
      break;
    case 'bar_with_multiselect':
      chart = chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.singleTap,
          enableMultiSelection: true,
          primaryXAxis: CategoryAxis(),
          selectionType: SelectionType.point,
          series: <BarSeries<BarSample, String>>[
            BarSeries<BarSample, String>(
              selectionBehavior: SelectionBehavior(
                  enable: true,
                  selectedColor: Colors.red,
                  unselectedColor: Colors.grey,
                  selectedBorderColor: Colors.blue,
                  unselectedBorderColor: Colors.lightGreen,
                  selectedBorderWidth: 2,
                  unselectedBorderWidth: 0),
              enableTooltip: true,
              dataSource: barData,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'column_series_selection':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          enableMultiSelection: true,
          selectionGesture: ActivationMode.singleTap,
          primaryXAxis: CategoryAxis(),
          selectionType: SelectionType.series,
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              selectionBehavior: SelectionBehavior(
                  enable: true,
                  selectedColor: Colors.red,
                  unselectedColor: Colors.grey,
                  selectedBorderColor: Colors.blue,
                  unselectedBorderColor: Colors.lightGreen,
                  selectedBorderWidth: 2,
                  unselectedBorderWidth: 0),
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
            ColumnSeries<ColumnSample, String>(
              selectionBehavior: SelectionBehavior(
                  enable: true,
                  selectedColor: Colors.red,
                  unselectedColor: Colors.grey,
                  selectedBorderColor: Colors.blue,
                  unselectedBorderColor: Colors.lightGreen,
                  selectedBorderWidth: 2,
                  unselectedBorderWidth: 0),
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales2,
            )
          ]);
      break;
    case 'column_with_customization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          enableMultiSelection: true,
          // ignore: avoid_print
          onSelectionChanged: (SelectionArgs args) => print(args.selectedColor),
          selectionGesture: ActivationMode.singleTap,
          primaryXAxis: CategoryAxis(),
          selectionType: SelectionType.point,
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              selectionBehavior: SelectionBehavior(
                  enable: true,
                  selectedColor: Colors.red,
                  unselectedColor: Colors.grey,
                  selectedBorderColor: Colors.blue,
                  unselectedBorderColor: Colors.lightGreen,
                  selectedBorderWidth: 2,
                  unselectedBorderWidth: 0),
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'area_multiselect':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          enableMultiSelection: true,
          selectionGesture: ActivationMode.singleTap,
          primaryXAxis: CategoryAxis(),
          selectionType: SelectionType.series,
          series: <AreaSeries<AreaData, String>>[
            AreaSeries<AreaData, String>(
                dataSource: areaData,
                selectionBehavior: SelectionBehavior(
                    enable: true,
                    selectedColor: Colors.red,
                    unselectedColor: Colors.grey,
                    selectedBorderColor: Colors.blue,
                    unselectedBorderColor: Colors.lightGreen,
                    selectedBorderWidth: 2,
                    unselectedBorderWidth: 0),
                xValueMapper: (AreaData sales, _) => sales.category,
                yValueMapper: (AreaData sales, _) => sales.sales2),
            AreaSeries<AreaData, String>(
                dataSource: areaData,
                selectionBehavior: SelectionBehavior(
                    enable: true,
                    selectedColor: Colors.red,
                    unselectedColor: Colors.grey,
                    selectedBorderColor: Colors.blue,
                    unselectedBorderColor: Colors.lightGreen,
                    selectedBorderWidth: 2,
                    unselectedBorderWidth: 0),
                xValueMapper: (AreaData sales, _) => sales.category,
                yValueMapper: (AreaData sales, _) => sales.sales1)
          ]);
      break;
    case 'area_selection':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.singleTap,
          primaryXAxis: CategoryAxis(),
          selectionType: SelectionType.series,
          series: <AreaSeries<AreaData, String>>[
            AreaSeries<AreaData, String>(
                dataSource: areaData,
                selectionBehavior: SelectionBehavior(
                    enable: true,
                    selectedColor: Colors.red,
                    unselectedColor: Colors.grey,
                    selectedBorderColor: Colors.blue,
                    unselectedBorderColor: Colors.lightGreen,
                    selectedBorderWidth: 2,
                    unselectedBorderWidth: 0),
                xValueMapper: (AreaData sales, _) => sales.category,
                yValueMapper: (AreaData sales, _) => sales.sales2),
            AreaSeries<AreaData, String>(
                dataSource: areaData,
                selectionBehavior: SelectionBehavior(
                    enable: true,
                    selectedColor: Colors.red,
                    unselectedColor: Colors.grey,
                    selectedBorderColor: Colors.blue,
                    unselectedBorderColor: Colors.lightGreen,
                    selectedBorderWidth: 2,
                    unselectedBorderWidth: 0),
                xValueMapper: (AreaData sales, _) => sales.category,
                yValueMapper: (AreaData sales, _) => sales.sales1)
          ]);
      break;
    case 'trackball touch':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          //isTransposed: true,
          onTrackballPositionChanging: (TrackballArgs args) {
            args.chartPointInfo.label = 'Custom Text';
          },
          trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
            tooltipAlignment: ChartAlignment.far,
          ),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              dataSource: columnData,
              isTrackVisible: true,
              isVisible: true,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'trackball Rectseries':
      final dynamic data = <RangeColumnSample>[
        RangeColumnSample(DateTime(2005, 0, 1), 'Sun', 1, 3.1, 10.8, 2.5, 9.8),
        RangeColumnSample(DateTime(2006, 0, 1), 'Mon', 2, 5.7, 14.4, 4.7, 11.4),
        RangeColumnSample(DateTime(2007, 0, 1), 'Tue', 3, 8.4, 16.9, 6.4, 14.4),
        RangeColumnSample(
            DateTime(2008, 0, 1), 'Wed', 4, 10.6, 19.2, 9.6, 17.2),
        RangeColumnSample(DateTime(2009, 0, 1), 'Thu', 5, 8.5, 8.5, 7.5, 15.1),
        RangeColumnSample(DateTime(2010, 0, 1), 'Fri', 6, 6.0, 12.5, 3.0, 10.5),
        RangeColumnSample(DateTime(2011, 0, 1), 'Sat', 7, 1.5, 6.9, 1.2, 7.0),
      ];
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          isTransposed: true,
          onTrackballPositionChanging: (TrackballArgs args) {
            args.chartPointInfo.label = 'Custom Text';
          },
          trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
            tooltipAlignment: ChartAlignment.far,
          ),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
            ),
          ]);
      break;
    case 'trackball tooltipsetting':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          //isTransposed: true,
          trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            lineType: TrackballLineType.vertical,
            tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
            tooltipSettings:
                const InteractiveTooltip(enable: true, format: 'point.x%'),
          ),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              dataSource: columnData,
              isTrackVisible: true,
              isVisible: true,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'trackball horizontalOrientation':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          isTransposed: true,
          trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
            lineType: TrackballLineType.horizontal,
            tooltipSettings:
                const InteractiveTooltip(enable: true, format: 'point.x%'),
          ),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              dataSource: columnData,
              isTrackVisible: true,
              isVisible: true,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'trackball inverted axis':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          isTransposed: false,
          onTrackballPositionChanging: (TrackballArgs args) {
            args.chartPointInfo.label = 'Custom Text';
            args.chartPointInfo.xPosition = 20.0;
            args.chartPointInfo.yPosition = 30.0;
          },
          trackballBehavior: TrackballBehavior(
              enable: true,
              tooltipAlignment: ChartAlignment.far,
              tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
              activationMode: ActivationMode.singleTap,
              tooltipSettings:
                  const InteractiveTooltip(enable: true, format: 'point.x%')),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
              dataSource: columnData,
              isTrackVisible: true,
              isVisible: true,
              xValueMapper: (ColumnSample sales, _) => sales.numeric,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'trackball verticalOrientation':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          isTransposed: true,
          trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
            tooltipAlignment: ChartAlignment.near,
            lineType: TrackballLineType.vertical,
            tooltipSettings:
                const InteractiveTooltip(enable: true, format: 'point.x%'),
          ),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              dataSource: columnData,
              isTrackVisible: true,
              isVisible: true,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'DateTime Axis trackball tooltipsettingformat':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          isTransposed: true,
          trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            tooltipSettings: const InteractiveTooltip(
                enable: true,
                format: 'point.x%',
                color: Colors.red,
                borderColor: Colors.green),
          ),
          series: <ColumnSeries<ColumnSample, DateTime>>[
            ColumnSeries<ColumnSample, DateTime>(
              dataSource: columnData,
              isTrackVisible: true,
              isVisible: true,
              xValueMapper: (ColumnSample sales, _) => sales.year,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'trackball tooltipDisplaymode':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          isTransposed: true,
          onTrackballPositionChanging: (TrackballArgs args) {
            args.chartPointInfo.label = 'Custom Text';
            args.chartPointInfo.xPosition = 20.0;
            args.chartPointInfo.yPosition = 30.0;
          },
          trackballBehavior: TrackballBehavior(
              enable: true,
              lineWidth: 0.0,
              tooltipAlignment: ChartAlignment.far,
              tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
              activationMode: ActivationMode.singleTap,
              tooltipSettings: const InteractiveTooltip(
                  enable: true, format: 'point.x%', arrowLength: 500)),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
              dataSource: columnData,
              isTrackVisible: true,
              isVisible: true,
              xValueMapper: (ColumnSample sales, _) => sales.numeric,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);

      break;
    case 'NumericAxis trackballRect':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          isTransposed: true,
          onTrackballPositionChanging: (TrackballArgs args) {
            args.chartPointInfo.label = 'Custom Text';
          },
          trackballBehavior: TrackballBehavior(
              enable: true,
              tooltipAlignment: ChartAlignment.near,
              tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
              activationMode: ActivationMode.singleTap,
              tooltipSettings: const InteractiveTooltip(
                enable: true,
                format: 'point.x%',
              )),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
              dataSource: columnData,
              isTrackVisible: true,
              isVisible: true,
              xValueMapper: (ColumnSample sales, _) => sales.numeric,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'NumericAxis trackball':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          //isTransposed: true,
          onTrackballPositionChanging: (TrackballArgs args) {
            args.chartPointInfo.label = 'Custom Text';
          },
          trackballBehavior: TrackballBehavior(
              enable: true,
              lineType: TrackballLineType.horizontal,
              lineDashArray: const <double>[10, 20],
              tooltipAlignment: ChartAlignment.center,
              tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
              activationMode: ActivationMode.singleTap,
              tooltipSettings: const InteractiveTooltip(
                enable: true,
                format: 'point.x%',
              )),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
              dataSource: columnData,
              isTrackVisible: true,
              isVisible: true,
              xValueMapper: (ColumnSample sales, _) => sales.numeric,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'trackball tooltipsize':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          isTransposed: true,
          onTrackballPositionChanging: (TrackballArgs args) {
            args.chartPointInfo.label = 'Custom Text';
          },
          trackballBehavior: TrackballBehavior(
              enable: true,
              lineWidth: 0.0,
              tooltipAlignment: ChartAlignment.center,
              tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
              activationMode: ActivationMode.singleTap,
              tooltipSettings: const InteractiveTooltip(
                  enable: true, format: 'point.x%', arrowLength: 500)),
          series: <RangeAreaSeries<RangeAreaData, num>>[
            RangeAreaSeries<RangeAreaData, num>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (RangeAreaData sales, _) => sales.numeric,
              lowValueMapper: (RangeAreaData sales, _) => sales.sales1,
              highValueMapper: (RangeAreaData sales, _) => sales.sales2,
            )
          ]);
      break;
    case 'trackball areaseries':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          isTransposed: true,
          onTrackballPositionChanging: (TrackballArgs args) {
            args.chartPointInfo.label = 'Custom Text';
          },
          trackballBehavior: TrackballBehavior(
              enable: true,
              lineWidth: 0.0,
              tooltipAlignment: ChartAlignment.center,
              tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
              activationMode: ActivationMode.singleTap,
              tooltipSettings: const InteractiveTooltip(
                  enable: true, format: 'point.x%', arrowLength: 200)),
          series: <AreaSeries<AreaData, num>>[
            AreaSeries<AreaData, num>(
                enableTooltip: true,
                dataSource: areaData,
                xValueMapper: (AreaData sales, _) => sales.numeric,
                yValueMapper: (AreaData sales, _) => sales.sales1),
          ]);

      break;
    case 'category trackball isright':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          isTransposed: true,
          onTrackballPositionChanging: (TrackballArgs args) {
            args.chartPointInfo.label = 'Custom Text';
          },
          trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
            tooltipAlignment: ChartAlignment.near,
          ),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              dataSource: columnData,
              //isTrackVisible: true,
              isVisible: true,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category trackball isright1':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          isTransposed: true,
          onTrackballPositionChanging: (TrackballArgs args) {
            args.chartPointInfo.label = 'Custom Text';
          },
          trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
            tooltipAlignment: ChartAlignment.near,
          ),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              dataSource: columnData,
              //isTrackVisible: true,
              isVisible: true,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category trackball tooltipalignment':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          isTransposed: true,
          onTrackballPositionChanging: (TrackballArgs args) {
            args.chartPointInfo.label = 'Custom Text';
          },
          trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
            tooltipAlignment: ChartAlignment.far,
          ),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              dataSource: columnData,
              //isTrackVisible: true,
              isVisible: true,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category trackball horizontal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          //isTransposed: true,
          onTrackballPositionChanging: (TrackballArgs args) {
            args.chartPointInfo.label = 'Custom Text';
          },
          trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
              tooltipAlignment: ChartAlignment.near,
              lineType: TrackballLineType.horizontal),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              dataSource: columnData,
              //isTrackVisible: true,
              isVisible: true,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category trackball horizontal1':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          //isTransposed: true,
          onTrackballPositionChanging: (TrackballArgs args) {
            args.chartPointInfo.label = 'Custom Text';
          },
          trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
              tooltipAlignment: ChartAlignment.far,
              lineType: TrackballLineType.horizontal),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              dataSource: columnData,
              //isTrackVisible: true,
              isVisible: true,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category trackball floatAll Points':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          //isTransposed: true,
          onTrackballPositionChanging: (TrackballArgs args) {
            args.chartPointInfo.label = 'Custom Text';
          },
          trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
              tooltipAlignment: ChartAlignment.far,
              lineType: TrackballLineType.horizontal),
          series: <LineSeries<LineSample, String>>[
            LineSeries<LineSample, String>(
              enableTooltip: true,
              dataSource: lineData,
              xValueMapper: (LineSample sales, _) => sales.category,
              yValueMapper: (LineSample sales, _) => sales.sales1,
            ),
            LineSeries<LineSample, String>(
              enableTooltip: true,
              dataSource: lineData,
              xValueMapper: (LineSample sales, _) => sales.category,
              yValueMapper: (LineSample sales, _) => sales.sales1,
            )
          ]);

      break;
    case 'category trackball nextPointInfo':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          //isTransposed: true,
          onTrackballPositionChanging: (TrackballArgs args) {
            args.chartPointInfo.label = 'Custom Text';
          },
          trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
              tooltipAlignment: ChartAlignment.far,
              lineType: TrackballLineType.horizontal),
          series: <LineSeries<LineSample, String>>[
            LineSeries<LineSample, String>(
              enableTooltip: true,
              dataSource: lineData,
              xValueMapper: (LineSample sales, _) => sales.category,
              yValueMapper: (LineSample sales, _) => sales.sales1,
            ),
            LineSeries<LineSample, String>(
              enableTooltip: true,
              dataSource: lineData1,
              xValueMapper: (LineSample sales, _) => sales.category,
              yValueMapper: (LineSample sales, _) => sales.sales1,
            )
          ]);

      break;
    case 'trackball leftrect':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          isTransposed: true,
          onTrackballPositionChanging: (TrackballArgs args) {
            args.chartPointInfo.label = 'Custom Text';
          },
          trackballBehavior: TrackballBehavior(
            enable: true,
            lineType: TrackballLineType.horizontal,
            activationMode: ActivationMode.singleTap,
            tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
            tooltipAlignment: ChartAlignment.far,
          ),
          series: <LineSeries<LineSample, String>>[
            LineSeries<LineSample, String>(
              enableTooltip: true,
              dataSource: lineData,
              xValueMapper: (LineSample sales, _) => sales.category,
              yValueMapper: (LineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'trackball default marker':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
            tooltipSettings:
                const InteractiveTooltip(enable: true, canShowMarker: true),
          ),
          series: <LineSeries<LineSample, String>>[
            LineSeries<LineSample, String>(
              enableTooltip: true,
              dataSource: lineData,
              xValueMapper: (LineSample sales, _) => sales.category,
              yValueMapper: (LineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'trackball marker shape':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          trackballBehavior: TrackballBehavior(
            enable: true,
            tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
            tooltipSettings:
                const InteractiveTooltip(enable: true, canShowMarker: true),
            markerSettings: const TrackballMarkerSettings(
                markerVisibility: TrackballVisibilityMode.visible,
                shape: DataMarkerType.triangle,
                color: Colors.red),
          ),
          series: <LineSeries<LineSample, String>>[
            LineSeries<LineSample, String>(
              enableTooltip: true,
              dataSource: lineData,
              xValueMapper: (LineSample sales, _) => sales.category,
              yValueMapper: (LineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'category trackball multiple series':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
              tooltipAlignment: ChartAlignment.far,
              lineType: TrackballLineType.horizontal),
          series: <LineSeries<LineSample, String>>[
            LineSeries<LineSample, String>(
              enableTooltip: true,
              dataSource: lineData,
              xValueMapper: (LineSample sales, _) => sales.category,
              yValueMapper: (LineSample sales, _) => sales.sales1,
            ),
            LineSeries<LineSample, String>(
              enableTooltip: true,
              dataSource: lineData,
              xValueMapper: (LineSample sales, _) => sales.category,
              yValueMapper: (LineSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category trackball with indicator':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
              tooltipAlignment: ChartAlignment.far,
              lineType: TrackballLineType.horizontal),
          indicators: <TechnicalIndicators<ChartSamplesData, num>>[
            /// Bollinger band indicator mentioned here.
            BollingerBandIndicator<ChartSamplesData, num>(
                seriesName: 'AAPL',
                animationDuration: 0,
                period: 14,
                standardDeviation: 2),
          ],
          series: <HiloOpenCloseSeries<ChartSamplesData, num>>[
            HiloOpenCloseSeries<ChartSamplesData, num>(
              enableTooltip: true,
              dataSource: hiloSeriesDate,
              name: 'AAPL',
              xValueMapper: (ChartSamplesData sales, _) => sales.z,
              highValueMapper: (ChartSamplesData sales, _) => sales.high,
              lowValueMapper: (ChartSamplesData sales, _) => sales.low,
              openValueMapper: (ChartSamplesData sales, _) => sales.open,
              closeValueMapper: (ChartSamplesData sales, _) => sales.close,
            )
          ]);
      break;
    default:
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
      );
  }

  return chart;
}

/// Represents the chart sample data
class ChartSamplesData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSamplesData(
      this.z, this.x, this.open, this.close, this.low, this.high, this.volume);

  /// Holds z value of the datapoint
  final num z;

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}
