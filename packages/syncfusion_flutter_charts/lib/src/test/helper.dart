import 'package:flutter/material.dart';

class _ChartDataValues {
  _ChartDataValues(this.rectValues);
  List<dynamic> rectValues;
}

/// Represents the chart color data values
class ChartColorDataValues {
  /// Creates an instance of chart color data values
  ChartColorDataValues(this.rectValues);

  /// Holds the rect value
  Color rectValues;
}

/// Method to get the points value
// ignore: library_private_types_in_public_api
List<_ChartDataValues> getPointsValues(
    List<dynamic> trackerRegion, List<dynamic> trackerRegion1) {
  final List<_ChartDataValues> stackedColumnPoints = <_ChartDataValues>[];
  stackedColumnPoints.add(_ChartDataValues(trackerRegion));
  stackedColumnPoints.add(_ChartDataValues(trackerRegion1));

  return stackedColumnPoints;
}

/// Method to get color values
List<ChartColorDataValues> getColorValues(Color color1, Color color2) {
  final List<ChartColorDataValues> chartColorDataValues =
      <ChartColorDataValues>[];
  chartColorDataValues.add(ChartColorDataValues(color1));
  chartColorDataValues.add(ChartColorDataValues(color2));

  return chartColorDataValues;
}

// Offset? getTouchPosition(dynamic seriesRenderer) {
//   Offset? position;
//   if (seriesRenderer is CartesianSeriesRenderer) {
//     if (seriesRenderer is BarSeriesRenderer) {
//       final BarSeriesRenderer cSeriesRenderer = seriesRenderer;
//       final BarSegment cSegment = cSeriesRenderer._segments[0] as BarSegment;
//       position = cSegment.segmentRect.center;
//     } else if (seriesRenderer is ColumnSeriesRenderer) {
//       final ColumnSeriesRenderer cSeriesRenderer = seriesRenderer;
//       final ColumnSegment cSegment =
//           cSeriesRenderer._segments[0] as ColumnSegment;
//       position = cSegment.segmentRect.middleRect.topLeft;
//     } else if (seriesRenderer is BubbleSeriesRenderer) {
//       final BubbleSeriesRenderer cSeriesRenderer = seriesRenderer;
//       final BubbleSegment cSegment =
//           cSeriesRenderer._segments[1] as BubbleSegment;
//       position = cSegment._segmentRect!.middleRect.topRight;
//     } else if (seriesRenderer is FastLineSeriesRenderer) {
//       final FastLineSeriesRenderer cSeriesRenderer = seriesRenderer;
//       final _ChartLocation value = cSeriesRenderer._dataPoints[0].markerPoint!;
//       position = Offset(value.x, value.y);
//     } else if (seriesRenderer is LineSeriesRenderer) {
//       final LineSeriesRenderer cSeriesRenderer = seriesRenderer;
//       final _ChartLocation value = cSeriesRenderer._dataPoints[0].markerPoint!;
//       position = Offset(value.x, value.y);
//     }
//   } else if (seriesRenderer is CircularSeriesRenderer) {
//     if (seriesRenderer is PieSeriesRenderer) {
//       final PieSeriesRenderer pSeriesRenderer = seriesRenderer;
//       final ChartPoint<dynamic> cPoint = pSeriesRenderer._renderPoints![1];
//       position = Offset(cPoint.labelRect.left, cPoint.labelRect.top);
//     }
//     if (seriesRenderer is DoughnutSeriesRenderer) {
//       final DoughnutSeriesRenderer dSeriesRenderer = seriesRenderer;
//       final ChartPoint<dynamic> cPoint = dSeriesRenderer._renderPoints![1];
//       position = Offset(cPoint.labelRect.left, cPoint.labelRect.top);
//     }
//     if (seriesRenderer is RadialBarSeriesRenderer) {
//       final RadialBarSeriesRenderer rSeriesRenderer = seriesRenderer;
//       final ChartPoint<dynamic> cPoint = rSeriesRenderer._renderPoints![1];
//       position = Offset(cPoint.labelRect.left, cPoint.labelRect.top);
//     }
//   } else if (seriesRenderer is PyramidSeriesRenderer) {
//     position = seriesRenderer._renderPoints![0].region!.bottomCenter;
//   }
//   return position;
// }
