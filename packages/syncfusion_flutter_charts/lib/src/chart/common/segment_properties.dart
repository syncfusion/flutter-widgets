import 'package:flutter/material.dart';
import '../chart_segment/chart_segment.dart';
import '../chart_segment/waterfall_segment.dart';
import '../chart_series/series.dart';
import '../chart_series/waterfall_series.dart';
import '../chart_series/xy_data_series.dart';
import 'cartesian_state_properties.dart';

/// Represents the segment properties class
class SegmentProperties {
  /// Argument constructor for SegmentProperties class
  SegmentProperties(this.stateProperties, this.segment);

  ///Color of the segment
  Color? color, strokeColor;

  ///Border width of the segment
  double? strokeWidth;

  /// Represents the value of chart series
  late XyDataSeries<dynamic, dynamic> series;

  /// Represents the value of old series
  XyDataSeries<dynamic, dynamic>? oldSeries;

  ///Chart series renderer
  late CartesianSeriesRenderer seriesRenderer;

  /// Represents the value of old series renderer
  CartesianSeriesRenderer? oldSeriesRenderer;

  /// Rectangle of the segment
  RRect? segmentRect;

  /// Default fill color & stroke color
  Paint? defaultFillColor, defaultStrokeColor;

  /// Represents the old segment index
  int? oldSegmentIndex;

  /// Represents the series index
  late int seriesIndex;

  /// Represents the current, old and next point
  CartesianChartPoint<dynamic>? currentPoint, point, oldPoint, nextPoint;

  /// Old series visibility property.
  bool? oldSeriesVisible;

  /// Old  rect region.
  Rect? oldRegion;

  /// Represents the Cartesian state properties
  final CartesianStateProperties stateProperties;

  /// Represents the segment
  final ChartSegment segment;

  /// Represents the value of path
  late Path path;

  /// Represents the value of stroke path
  Path? strokePath;

  /// Represents the value of path rect
  Rect? pathRect;

  /// Represents the track bar rect
  late RRect trackBarRect;

  /// Represents the tracker fill paint
  Paint? trackerFillPaint;

  /// Represents the tracker stroke paint
  Paint? trackerStrokePaint;

  /// Represents the value of x, high and low
  late double x, low, high;

  /// Represents the value of openX and closeX value
  late double openX, closeX;

  /// Represents the value of top rect y and bottom rect y value
  late double topRectY, bottomRectY;

  /// Represents the low, high, min and max point value
  late ChartLocation lowPoint, highPoint, minPoint, maxPoint;

  /// Represents the point color mapper value
  Color? pointColorMapper;

  /// Specifies the value of isSolid and isBull
  late bool isSolid = false, isBull = false;

  /// Specifies the value of track rect
  late RRect trackRect;

  /// Colors of the negative point, intermediate point and total point.
  Color? negativePointsColor, intermediateSumColor, totalSumColor;

  /// Represents the value a1, y1, x2, y2, x3 and y3
  late double x1, y1, x2, y2, x3, y3;

  /// Represents the value of midX, midY
  late num midX, midY;

  /// Represents the value of cumulative position
  late double currentCummulativePos, nextCummulativePos;

  /// Represents the cumulative value
  late double currentCummulativeValue, nextCummulativeValue;

  /// Represents the value of border path
  Path? borderPath;

  /// Represents the  openY, closeY
  late double openY, closeY;

  /// Represents the value of min and max
  late double min, max;

  /// Represents the value of lowerX and upperX
  late double lowerX, upperX;

  /// Method to get series tracker fill.
  Paint getTrackerFillPaint() {
    final dynamic seriesWithTrack = series;
    trackerFillPaint = Paint()
      ..color = seriesWithTrack.trackColor
      ..style = PaintingStyle.fill;
    return trackerFillPaint!;
  }

  /// Method to get series tracker stroke color.
  Paint getTrackerStrokePaint() {
    final dynamic seriesWithTrack = series;
    trackerStrokePaint = Paint()
      ..color = seriesWithTrack.trackBorderColor
      ..strokeWidth = seriesWithTrack.trackBorderWidth
      ..style = PaintingStyle.stroke;
    seriesWithTrack.trackBorderWidth == 0
        ? trackerStrokePaint!.color = Colors.transparent
        : trackerStrokePaint!.color;
    return trackerStrokePaint!;
  }

  /// Get the color of connector lines.
  Paint? getConnectorLineStrokePaint() {
    if (series is WaterfallSeries) {
      final WaterfallSeries<dynamic, dynamic> waterfallSeries =
          series as WaterfallSeries<dynamic, dynamic>;

      (segment as WaterfallSegment).connectorLineStrokePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = waterfallSeries.connectorLineSettings.width
        ..color = waterfallSeries.connectorLineSettings.color ??
            stateProperties
                .renderingDetails.chartTheme.waterfallConnectorLineColor;
      return (segment as WaterfallSegment).connectorLineStrokePaint!;
    }

    return null;
  }
}
