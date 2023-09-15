import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get the legend sample
SfCartesianChart getLegendchart(String sampleName) {
  SfCartesianChart chart;
  final dynamic data = <LegendSample1>[
    LegendSample1(
        DateTime(2005, 0), 'India', 1, 32, 28, 680, 760, 1, Colors.deepOrange),
    LegendSample1(
        DateTime(2006, 0), 'China', 2, 24, 44, 550, 880, 2, Colors.deepPurple),
    LegendSample1(
        DateTime(2007, 0), 'USA', 3, 36, 48, 440, 788, 3, Colors.lightGreen),
    LegendSample1(
        DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    LegendSample1(
        DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5, Colors.purple)
  ];

  switch (sampleName) {
    case 'customization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
              isVisible: true,
              position: LegendPosition.left,
              backgroundColor: Colors.red,
              borderColor: Colors.black,
              borderWidth: 1,
              height: '150',
              iconBorderColor: Colors.orange,
              iconBorderWidth: 2,
              iconHeight: 12,
              iconWidth: 12,
              isResponsive: true,
              itemPadding: 15,
              opacity: 0.5,
              orientation: LegendItemOrientation.vertical,
              overflowMode: LegendItemOverflowMode.wrap,
              width: '250'),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'LineSeries'),
          ]);
      break;
    case 'withoutSeriesName':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
            isVisible: true,
          ),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
              dataSource: data,
              xValueMapper: (LegendSample1 sales, _) => sales.xData,
              yValueMapper: (LegendSample1 sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'withSeriesLegendName':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
            isVisible: true,
          ),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'LineSeries',
                legendItemText: 'Legends Text'),
          ]);
      break;
    case 'withLegendName':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
            isVisible: true,
          ),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                legendItemText: 'Legends Text'),
          ]);
      break;
    case 'legend_triangleMarker':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
            isVisible: true,
          ),
          series: <ScatterSeries<LegendSample1, int?>>[
            ScatterSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(
                    isVisible: true, shape: DataMarkerType.triangle),
                legendIconType: LegendIconType.seriesType),
          ]);
      break;
    case 'legend_circleMarker':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
            isVisible: true,
          ),
          series: <ScatterSeries<LegendSample1, int?>>[
            ScatterSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(
                    isVisible: true, shape: DataMarkerType.circle),
                legendIconType: LegendIconType.seriesType),
          ]);
      break;
    case 'legend_pentagonMarker':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
            isVisible: true,
          ),
          series: <ScatterSeries<LegendSample1, int?>>[
            ScatterSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(
                    isVisible: true, shape: DataMarkerType.pentagon),
                legendIconType: LegendIconType.seriesType),
          ]);
      break;
    case 'legend_rectangleMarker':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
            isVisible: true,
          ),
          series: <ScatterSeries<LegendSample1, int?>>[
            ScatterSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(
                    isVisible: true, shape: DataMarkerType.rectangle),
                legendIconType: LegendIconType.seriesType),
          ]);
      break;
    case 'legend_invertedTriangleMarker':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
            isVisible: true,
          ),
          series: <ScatterSeries<LegendSample1, int?>>[
            ScatterSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(
                    isVisible: true, shape: DataMarkerType.invertedTriangle),
                legendIconType: LegendIconType.seriesType),
          ]);
      break;
    case 'legend_HLineMarker':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
            isVisible: true,
          ),
          series: <ScatterSeries<LegendSample1, int?>>[
            ScatterSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(
                    isVisible: true, shape: DataMarkerType.horizontalLine),
                legendIconType: LegendIconType.seriesType),
          ]);
      break;
    case 'legend_VLineMarker':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
            isVisible: true,
          ),
          series: <ScatterSeries<LegendSample1, int?>>[
            ScatterSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(
                    isVisible: true, shape: DataMarkerType.verticalLine),
                legendIconType: LegendIconType.seriesType),
          ]);
      break;
    case 'legendverticalLine':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
            isVisible: true,
          ),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'LineSeries',
                legendIconType: LegendIconType.verticalLine),
          ]);
      break;
    case 'legend_diamondMarker':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
            isVisible: true,
          ),
          series: <ScatterSeries<LegendSample1, int?>>[
            ScatterSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(
                    isVisible: true, shape: DataMarkerType.diamond),
                legendIconType: LegendIconType.seriesType),
          ]);
      break;
    case 'legend_line_with_Marker_shape':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
            isVisible: true,
          ),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(
                    isVisible: true, shape: DataMarkerType.triangle),
                legendIconType: LegendIconType.seriesType),
          ]);
      break;
    case 'legend_dashLine_with_Marker_shape':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
            isVisible: true,
          ),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                dashArray: <double>[3, 2],
                markerSettings: const MarkerSettings(
                    isVisible: true, shape: DataMarkerType.circle),
                legendIconType: LegendIconType.seriesType),
          ]);
      break;
    case 'legendAlignment_near':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(isVisible: true, alignment: ChartAlignment.near),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'LineSeries'),
          ]);
      break;
    case 'legendAlignment_far':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(isVisible: true, alignment: ChartAlignment.far),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'LineSeries'),
          ]);
      break;
    case 'legendAlignment_center':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend:
              const Legend(isVisible: true, alignment: ChartAlignment.center),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'LineSeries'),
          ]);
      break;
    case 'legend_titleAlignment':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
              isVisible: true,
              title: LegendTitle(
                  text: 'Legend Title', alignment: ChartAlignment.near)),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                legendIconType: LegendIconType.circle,
                name: 'LineSeries'),
          ]);
      break;
    case 'legendCircle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
            isVisible: true,
          ),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'LineSeries',
                legendIconType: LegendIconType.circle),
          ]);
      break;
    case 'legendDiamond':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
            isVisible: true,
          ),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'LineSeries',
                legendIconType: LegendIconType.diamond),
          ]);
      break;
    case 'legendHLine':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
            isVisible: true,
          ),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'LineSeries',
                legendIconType: LegendIconType.horizontalLine),
          ]);
      break;
    case 'legendInvertedTriangle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(isVisible: true, title: LegendTitle(text: 'ad')),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'LineSeries',
                legendIconType: LegendIconType.invertedTriangle),
          ]);
      break;
    case 'legendpentagon':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
            isVisible: true,
          ),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'LineSeries',
                legendIconType: LegendIconType.pentagon),
          ]);
      break;
    case 'legendrectangle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
            isVisible: true,
          ),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'LineSeries',
                legendIconType: LegendIconType.rectangle),
          ]);
      break;
    case 'legendtriangle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
            isVisible: true,
          ),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'LineSeries',
                legendIconType: LegendIconType.triangle),
          ]);
      break;
    case 'multipleSeries':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
              isVisible: true,
              height: '150',
              width: '200',
              overflowMode: LegendItemOverflowMode.none),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'LineSeries1'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales2,
                name: 'LineSeries2'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales3,
                name: 'LineSeries3'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales4,
                name: 'LineSeries4'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.xData,
                name: 'LineSeries5'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales3,
                name: 'LineSeries6'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales4,
                name: 'LineSeries7'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.xData,
                name: 'LineSeries8'),
          ]);
      break;
    case 'legendScrollable':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
              isVisible: true,
              height: '150',
              width: '200',
              overflowMode: LegendItemOverflowMode.scroll),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'LineSeries1'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales2,
                name: 'LineSeries2'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales3,
                name: 'LineSeries3'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales4,
                name: 'LineSeries4'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.xData,
                name: 'LineSeries5'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales3,
                name: 'LineSeries6'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales4,
                name: 'LineSeries7'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.xData,
                name: 'LineSeries8'),
          ]);
      break;
    case 'multipleSeries_overflow':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
              isVisible: true,
              height: '150',
              width: '200',
              overflowMode: LegendItemOverflowMode.wrap),
          series: <ChartSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'LineSeries1'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales2,
                name: 'LineSeries2'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales3,
                name: 'LineSeries3'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales4,
                name: 'LineSeries4'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.xData,
                name: 'LineSeries5'),
          ]);
      break;
    case 'left':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
              isVisible: true,
              position: LegendPosition.left,
              backgroundColor: Colors.red,
              borderColor: Colors.black,
              borderWidth: 1),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'LineSeries'),
          ]);
      break;
    case 'top':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
              isVisible: true,
              position: LegendPosition.top,
              backgroundColor: Colors.red,
              borderColor: Colors.black,
              borderWidth: 1),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'LineSeries'),
          ]);
      break;
    case 'right':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
              isVisible: true,
              position: LegendPosition.right,
              backgroundColor: Colors.red,
              borderColor: Colors.black,
              borderWidth: 1),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'LineSeries'),
          ]);
      break;
    case 'spline_legend':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(isVisible: true),
          series: <ChartSeries<LegendSample1, int?>>[
            SplineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'SplineSeries'),
          ]);
      break;
    case 'bar_legend':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
              height: '22',
              width: '200',
              overflowMode: LegendItemOverflowMode.wrap,
              orientation: LegendItemOrientation.vertical,
              isVisible: true),
          series: <ChartSeries<LegendSample1, int?>>[
            BarSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'BarSeries'),
          ]);
      break;

    case 'area_legend':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(isVisible: true),
          series: <ChartSeries<LegendSample1, int?>>[
            AreaSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'AreaSeries'),
          ]);
      break;
    case 'stepLine_legend':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(isVisible: true),
          series: <ChartSeries<LegendSample1, int?>>[
            StepLineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'StepLineSeries'),
          ]);
      break;
    case 'bubble_legend':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(isVisible: true),
          series: <ChartSeries<LegendSample1, int?>>[
            BubbleSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                sizeValueMapper: (LegendSample1 sales, _) => sales.xData,
                name: 'BubbleSeries'),
          ]);
      break;
    case 'legend_template':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: Legend(
              isVisible: true,
              // Templating the legend item
              legendItemBuilder:
                  (String name, dynamic series, dynamic point, int index) {
                return const SizedBox(
                    height: 20, width: 10, child: Text('Legend Template'));
              }),
          series: <ChartSeries<LegendSample1, int?>>[
            BubbleSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                sizeValueMapper: (LegendSample1 sales, _) => sales.xData,
                name: 'BubbleSeries'),
          ]);
      break;
    case 'toggleSeriesVisibility':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(isVisible: true, toggleSeriesVisibility: false),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'LineSeries',
                legendIconType: LegendIconType.horizontalLine),
          ]);
      break;
    case 'IsVisibleInLegend':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
            isVisible: true,
          ),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                isVisible: false,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'LineSeries',
                legendIconType: LegendIconType.horizontalLine),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                isVisibleInLegend: true,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales2,
                name: 'LineSeries',
                legendIconType: LegendIconType.horizontalLine)
          ]);
      break;
    case 'onLegendItemRender':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(isVisible: true),
          onLegendItemRender: (LegendRenderArgs args) {
            args.text = 'Legend Text';
            args.legendIconType = LegendIconType.diamond;
          },
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
              dataSource: data,
              xValueMapper: (LegendSample1 sales, _) => sales.xData,
              yValueMapper: (LegendSample1 sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'legend_itemBuilder':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        title: ChartTitle(text: 'Transport Usage - 2018'),
        legend: Legend(
            isVisible: true,
            opacity: 0.9,
            legendItemBuilder:
                (String name, dynamic series, dynamic point, int index) {
              return SizedBox(
                  height: 30,
                  width: 80,
                  child: Row(children: <Widget>[
                    Text(index.toString()),
                  ]));
            }),
        series: <LineSeries<LegendSample1, int?>>[
          LineSeries<LegendSample1, int?>(
            dataSource: data,
            xValueMapper: (LegendSample1 sales, _) => sales.xData,
            yValueMapper: (LegendSample1 sales, _) => sales.sales1,
          ),
        ],
      );
      break;
    case 'legend_horizontalOrientation':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
              isVisible: true,
              height: '120',
              width: '100',
              overflowMode: LegendItemOverflowMode.wrap,
              orientation: LegendItemOrientation.horizontal),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'LineSeries1'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales2,
                name: 'LineSeries2'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales3,
                name: 'LineSeries3'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales4,
                name: 'LineSeries4'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.xData,
                name: 'LineSeries5'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales3,
                name: 'LineSeries6'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales4,
                name: 'LineSeries7'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.xData,
                name: 'LineSeries8'),
          ]);
      break;
    case 'gradient':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
              isVisible: true,
              position: LegendPosition.left,
              backgroundColor: Colors.red,
              borderColor: Colors.black,
              borderWidth: 1,
              height: '150',
              iconBorderColor: Colors.orange,
              iconBorderWidth: 2,
              iconHeight: 12,
              iconWidth: 12),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: _getRangeColumnData());
      break;

    case 'legend_onTap':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(isVisible: true),
          onLegendTapped: (LegendTapArgs args) => () {},
          series: <ChartSeries<LegendSample1, int?>>[
            BarSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'BarSeries'),
          ]);
      break;
    case 'legend_onTapWithItemBuilder':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: Legend(
              isVisible: true,
              legendItemBuilder:
                  (String name, dynamic series, dynamic point, int index) {
                return const SizedBox(
                    height: 20, width: 10, child: Text('Legend Template'));
              }),
          onLegendTapped: (LegendTapArgs args) => () {},
          series: <ChartSeries<LegendSample1, int?>>[
            BarSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'BarSeries'),
          ]);
      break;
    case 'legend_vertical':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(
              isVisible: true,
              height: '22',
              width: '100',
              overflowMode: LegendItemOverflowMode.wrap,
              orientation: LegendItemOrientation.vertical),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'LineSeries1'),
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales2,
                name: 'LineSeries2')
          ]);
      break;
    default:
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend:
              const Legend(isVisible: true, position: LegendPosition.bottom),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <LineSeries<LegendSample1, int?>>[
            LineSeries<LegendSample1, int?>(
                dataSource: data,
                xValueMapper: (LegendSample1 sales, _) => sales.xData,
                yValueMapper: (LegendSample1 sales, _) => sales.sales1,
                name: 'LineSeries'),
          ]);
  }

  return chart;
}

/// Method to get the accumulation chart
SfCircularChart getAccumulationChart(String sampleName) {
  SfCircularChart chart;
  final dynamic circularData = <LegendSample>[
    LegendSample('Bus', 10),
    LegendSample('Car', 15),
    LegendSample('Cycle', 10),
    LegendSample('Train', 25),
    LegendSample('Bike', 9),
  ];
  switch (sampleName) {
    case 'accumulationLegend_customization':
      chart = SfCircularChart(
        key: GlobalKey<State<SfCircularChart>>(),
        title: ChartTitle(text: 'Transport Usage - 2018'),
        legend: const Legend(
            isVisible: true,
            position: LegendPosition.left,
            backgroundColor: Colors.red,
            borderColor: Colors.black,
            borderWidth: 1,
            height: '150',
            iconBorderColor: Colors.orange,
            iconBorderWidth: 2,
            iconHeight: 12,
            iconWidth: 12,
            isResponsive: true,
            itemPadding: 15,
            opacity: 0.5,
            orientation: LegendItemOrientation.vertical,
            overflowMode: LegendItemOverflowMode.wrap,
            width: '250'),
        series: <PieSeries<LegendSample, String>>[
          PieSeries<LegendSample, String>(
            dataSource: circularData,
            xValueMapper: (LegendSample data, _) => data.xVal,
            yValueMapper: (LegendSample data, _) => data.yVal,
          ),
        ],
      );
      break;
    case 'legend_bottom':
      chart = SfCircularChart(
        key: GlobalKey<State<SfCircularChart>>(),
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        series: <PieSeries<LegendSample, String>>[
          PieSeries<LegendSample, String>(
            dataSource: circularData,
            xValueMapper: (LegendSample data, _) => data.xVal,
            yValueMapper: (LegendSample data, _) => data.yVal,
          ),
        ],
      );
      break;
    case 'legend_left':
      chart = SfCircularChart(
        key: GlobalKey<State<SfCircularChart>>(),
        legend: const Legend(isVisible: true, position: LegendPosition.left),
        series: <PieSeries<LegendSample, String>>[
          PieSeries<LegendSample, String>(
            dataSource: circularData,
            xValueMapper: (LegendSample data, _) => data.xVal,
            yValueMapper: (LegendSample data, _) => data.yVal,
          ),
        ],
      );
      break;
    case 'legend_top':
      chart = SfCircularChart(
        key: GlobalKey<State<SfCircularChart>>(),
        legend: const Legend(isVisible: true, position: LegendPosition.top),
        series: <PieSeries<LegendSample, String>>[
          PieSeries<LegendSample, String>(
            dataSource: circularData,
            xValueMapper: (LegendSample data, _) => data.xVal,
            yValueMapper: (LegendSample data, _) => data.yVal,
          ),
        ],
      );
      break;
    case 'legend_auto':
      chart = SfCircularChart(
        key: GlobalKey<State<SfCircularChart>>(),
        legend: const Legend(isVisible: true, position: LegendPosition.auto),
        series: <PieSeries<LegendSample, String>>[
          PieSeries<LegendSample, String>(
            dataSource: circularData,
            xValueMapper: (LegendSample data, _) => data.xVal,
            yValueMapper: (LegendSample data, _) => data.yVal,
          ),
        ],
      );
      break;
    case 'doughnut_legend':
      chart = SfCircularChart(
        key: GlobalKey<State<SfCircularChart>>(),
        legend: const Legend(isVisible: true),
        series: <CircularSeries<LegendSample, String>>[
          DoughnutSeries<LegendSample, String>(
            dataSource: circularData,
            xValueMapper: (LegendSample data, _) => data.xVal,
            yValueMapper: (LegendSample data, _) => data.yVal,
          ),
        ],
      );
      break;
    case 'radialbar_legend':
      chart = SfCircularChart(
        key: GlobalKey<State<SfCircularChart>>(),
        legend: const Legend(isVisible: true),
        series: <CircularSeries<LegendSample, String>>[
          RadialBarSeries<LegendSample, String>(
            dataSource: circularData,
            xValueMapper: (LegendSample data, _) => data.xVal,
            yValueMapper: (LegendSample data, _) => data.yVal,
          ),
        ],
      );
      break;
    case 'toggleSeriesVisibility':
      chart = SfCircularChart(
        key: GlobalKey<State<SfCircularChart>>(),
        legend: const Legend(isVisible: true, toggleSeriesVisibility: false),
        series: <CircularSeries<LegendSample, String>>[
          RadialBarSeries<LegendSample, String>(
            dataSource: circularData,
            xValueMapper: (LegendSample data, _) => data.xVal,
            yValueMapper: (LegendSample data, _) => data.yVal,
          ),
        ],
      );
      break;

    case 'legend_template':
      chart = SfCircularChart(
        key: GlobalKey<State<SfCircularChart>>(),
        legend: Legend(
            isVisible: true,
            // Templating the legend item
            legendItemBuilder:
                (String name, dynamic series, dynamic point, int index) {
              return SizedBox(
                  height: 20, width: 10, child: Text(point.y.toString()));
            }),
        series: <CircularSeries<LegendSample, String>>[
          RadialBarSeries<LegendSample, String>(
            dataSource: circularData,
            xValueMapper: (LegendSample data, _) => data.xVal,
            yValueMapper: (LegendSample data, _) => data.yVal,
          ),
        ],
      );
      break;

    case 'onLegendItemRender':
      chart = SfCircularChart(
        key: GlobalKey<State<SfCircularChart>>(),
        legend: const Legend(
          isVisible: true,
        ),
        onLegendItemRender: (LegendRenderArgs args) {
          args.text = 'Legend Text';
          args.legendIconType = LegendIconType.diamond;
        },
        series: <PieSeries<LegendSample, String>>[
          PieSeries<LegendSample, String>(
            dataSource: circularData,
            xValueMapper: (LegendSample data, _) => data.xVal,
            yValueMapper: (LegendSample data, _) => data.yVal,
          ),
        ],
      );
      break;
    case 'legend_onTapWithTemplate':
      chart = SfCircularChart(
        key: GlobalKey<State<SfCircularChart>>(),
        legend: Legend(
            isVisible: true,
            // Templating the legend item
            legendItemBuilder:
                (String name, dynamic series, dynamic point, int index) {
              return SizedBox(height: 20, width: 10, child: Container());
            }),
        onLegendTapped: (LegendTapArgs args) => () {},
        series: <CircularSeries<LegendSample, String>>[
          RadialBarSeries<LegendSample, String>(
            dataSource: circularData,
            xValueMapper: (LegendSample data, _) => data.xVal,
            yValueMapper: (LegendSample data, _) => data.yVal,
          ),
        ],
      );
      break;
    case 'legend_onTap':
      chart = SfCircularChart(
        key: GlobalKey<State<SfCircularChart>>(),
        legend: const Legend(isVisible: true, position: LegendPosition.auto),
        onLegendTapped: (LegendTapArgs args) => () {},
        series: <PieSeries<LegendSample, String>>[
          PieSeries<LegendSample, String>(
            dataSource: circularData,
            xValueMapper: (LegendSample data, _) => data.xVal,
            yValueMapper: (LegendSample data, _) => data.yVal,
          ),
        ],
      );
      break;
    default:
      chart = SfCircularChart(
        key: GlobalKey<State<SfCircularChart>>(),
        title: ChartTitle(text: 'Transport Usage - 2018'),
        legend: const Legend(
          isVisible: true,
        ),
        series: <PieSeries<LegendSample, String>>[
          PieSeries<LegendSample, String>(
            dataSource: circularData,
            xValueMapper: (LegendSample data, _) => data.xVal,
            yValueMapper: (LegendSample data, _) => data.yVal,
          ),
        ],
      );
      break;
  }
  return chart;
}

/// Represents the legend sample
class LegendSample1 {
  /// Creates an instance legend smaple
  LegendSample1(this.year, this.category, this.numeric, this.sales1,
      this.sales2, this.sales3, this.sales4,
      [this.xData, this.lineColor]);

  /// Holds the year value
  final DateTime year;

  /// Holds the category value
  final String category;

  /// Holds the numeric value
  final double numeric;

  /// Holds the sales1 value
  final int sales1;

  /// Holds the sales2 value
  final int sales2;

  /// Holds the sales3 value
  final int sales3;

  /// Holds the sales4 value
  final int sales4;

  /// Holds the xData value
  final int? xData;

  /// Holds the line color value
  final Color? lineColor;
}

/// Represents the legend sample
class LegendSample {
  /// Creates an instance of legend smaple
  LegendSample(this.xVal, this.yVal, [this.img, this.radius]);

  /// Holds the xVal
  final String xVal;

  /// Holds the yVal
  final int yVal;

  /// Holds the radius
  final String? radius;

  /// Holds the img
  final Image? img;
}

List<ChartSeries<OrdinalSales, dynamic>> _getRangeColumnData() {
  final dynamic chartData = <OrdinalSales>[
    OrdinalSales('Sun', 1, 3.1, 10.8, 2.5, 9.8),
    OrdinalSales('Mon', 2, 5.7, 14.4, 4.7, 11.4),
    OrdinalSales('Tue', 3, 8.4, 16.9, 6.4, 14.4),
    OrdinalSales('Wed', 4, 10.6, 19.2, 9.6, 17.2),
    OrdinalSales('Thu', 5, 8.5, 16.1, 7.5, 15.1),
    OrdinalSales('Fri', 6, 6.0, 12.5, 3.0, 10.5),
    OrdinalSales('Sat', 7, 1.5, 6.9, 1.2, 7.0),
  ];

  return <ChartSeries<OrdinalSales, dynamic>>[
    RangeColumnSeries<OrdinalSales, dynamic>(
        enableTooltip: true,
        gradient: const LinearGradient(
            colors: <Color>[Colors.blue, Colors.red, Colors.yellow],
            stops: <double>[0.0, 0.5, 1.0]),
        color: Colors.pink,
        dataSource: chartData,
        xValueMapper: (OrdinalSales sales, _) => sales.category,
        lowValueMapper: (OrdinalSales sales, _) => sales.low1,
        highValueMapper: (OrdinalSales sales, _) => sales.high1,
        name: 'India'),
    ScatterSeries<OrdinalSales, dynamic>(
        enableTooltip: true,
        dataSource: chartData,
        markerSettings: const MarkerSettings(
          isVisible: true,
        ),
        color: Colors.blue,
        xValueMapper: (OrdinalSales sales, _) => sales.category,
        yValueMapper: (OrdinalSales sales, _) => sales.numeric,
        name: 'Germany'),
  ];
}

/// Sample ordinal data type.
class OrdinalSales {
  /// Creates an instance of ordinal sample
  OrdinalSales(this.category, this.numeric, this.low1, this.high1, this.low2,
      this.high2);

  /// Holds the category value
  final String category;

  /// Holds the numeric value
  final double numeric;

  /// Holds the low1 value
  final num low1;

  /// Holds the high1 value
  final num high1;

  /// Holds the low2 value
  final num low2;

  /// Holds the high2 value
  final num high2;
}
