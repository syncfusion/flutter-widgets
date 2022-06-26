import 'dart:ui';
import 'package:flutter/material.dart';
import '../common/segment_properties.dart';

/// Creates the segments for chart series.
///
/// It has the public method and properties to customize the segment in the chart series, User can customize
/// the calculation of the segment points by using the method [calculateSegmentPoints]. It has the property to
/// store the old value of the series to support dynamic animation.
///
/// Provides the public properties color, stroke color, fill paint, stroke paint, series and old series to customize and dynamically
/// change each segment in the chart.
///
abstract class ChartSegment {
  /// Gets the color of the series.
  Paint getFillPaint();

  /// Gets the border color of the series.
  Paint getStrokePaint();

  /// Calculates the rendering bounds of a segment.
  void calculateSegmentPoints();

  /// Draws segment in series bounds.
  void onPaint(Canvas canvas);

  /// Fill paint of the segment.
  Paint? fillPaint;

  /// Stroke paint of the segment.
  Paint? strokePaint;

  /// Animation factor value.
  late double animationFactor;

  /// Current point offset value.
  List<Offset> points = <Offset>[];

  /// Current index value.
  int? currentSegmentIndex;

  /// Represents the segment properties.
  SegmentProperties? _segmentProperties;

  /// To dispose the objects.
  void dispose() {
    _segmentProperties = null;
  }
}

// ignore: avoid_classes_with_only_static_members
/// Helper class to get the private fields of chart segment
class SegmentHelper {
  /// Method to get the segment properties of corresponding chart segment.
  static SegmentProperties getSegmentProperties(ChartSegment chartSegment) =>
      chartSegment._segmentProperties!;

  /// Method to set the segment properties of corresponding chart segment.
  static void setSegmentProperties(
          ChartSegment segment, SegmentProperties segmentProperties) =>
      segment._segmentProperties = segmentProperties;
}
