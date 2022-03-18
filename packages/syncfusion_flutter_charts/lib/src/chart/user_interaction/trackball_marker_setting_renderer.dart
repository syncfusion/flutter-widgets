import 'dart:ui' as dart_ui;
import '../chart_series/series.dart';
import '../chart_series/xy_data_series.dart';
import '../common/trackball_marker_settings.dart';

/// Creates a class for TrackballMarkerSettingsRenderer.
class TrackballMarkerSettingsRenderer {
  /// Creates an argument constructor for TrackballMarkerSettings class.
  TrackballMarkerSettingsRenderer(this._trackballMarkerSettings);

  ///ignore: unused_field
  final TrackballMarkerSettings? _trackballMarkerSettings;

  /// Specifies the marker image.
  dart_ui.Image? image;
}

/// Class to store the group mode details of trackball template.
class TrackballGroupingModeInfo {
  /// Creates an argument constructor for TrackballGroupingModeInfo class.
  TrackballGroupingModeInfo(this.points, this.currentPointIndices,
      this.visibleSeriesIndices, this.visibleSeriesList);

  /// Specifies the cartesian chart points.
  final List<CartesianChartPoint<dynamic>> points;

  /// Specifies the current point indices.
  final List<int> currentPointIndices;

  /// Specifies the visible series indices.
  final List<int> visibleSeriesIndices;

  /// Specifies the cartesian visible series list.
  final List<CartesianSeries<dynamic, dynamic>> visibleSeriesList;
}
