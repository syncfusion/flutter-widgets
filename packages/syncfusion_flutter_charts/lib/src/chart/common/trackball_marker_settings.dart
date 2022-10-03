import 'package:flutter/material.dart';

import '../chart_series/series.dart';
import '../chart_series/xy_data_series.dart';
import '../common/marker.dart';
import '../user_interaction/trackball_marker_setting_renderer.dart';
import '../utils/enum.dart';

/// Options to customize the markers that are displayed when trackball is enabled.
///
/// Trackball markers are used to provide information about the exact point location,
/// when the trackball is visible. You can add a shape to adorn each data point.
/// Trackball markers can be enabled by using the
/// [markerVisibility] property in [TrackballMarkerSettings].
/// Provides the options like color, border width, border color and shape of the
/// marker to customize the appearance.
class TrackballMarkerSettings extends MarkerSettings {
  /// Creating an argument constructor of TrackballMarkerSettings class.
  const TrackballMarkerSettings(
      {this.markerVisibility = TrackballVisibilityMode.auto,
      double? height,
      double? width,
      Color? color,
      DataMarkerType? shape,
      double? borderWidth,
      Color? borderColor,
      ImageProvider? image})
      : super(
            height: height,
            width: width,
            color: color,
            shape: shape,
            borderWidth: borderWidth,
            borderColor: borderColor,
            image: image);

  /// Whether marker should be visible or not when trackball is enabled.
  ///
  /// The below values are applicable for this:
  /// * TrackballVisibilityMode.auto - If the [isVisible] property in the series `markerSettings` is set
  /// to true, then the trackball marker will also be displayed for that
  /// particular series, else it will not be displayed.
  /// * TrackballVisibilityMode.visible - Makes the trackball marker visible for all the series,
  /// irrespective of considering the [isVisible] property's value in the `markerSettings`.
  /// * TrackballVisibilityMode.hidden - Hides the trackball marker for all the series.
  ///
  /// Defaults to `TrackballVisibilityMode.auto`.
  ///
  /// Also refer [TrackballVisibilityMode].
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(
  ///     enable: true,
  ///     markerSettings: TrackballMarkerSettings(
  ///       markerVisibility:  TrackballVisibilityMode.visible,
  ///       width: 10
  ///     )
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  ///```
  final TrackballVisibilityMode markerVisibility;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is TrackballMarkerSettings &&
        other.markerVisibility == markerVisibility &&
        other.height == height &&
        other.width == width &&
        other.color == color &&
        other.shape == shape &&
        other.borderWidth == borderWidth &&
        other.borderColor == borderColor &&
        other.image == image;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      markerVisibility,
      height,
      width,
      color,
      shape,
      borderWidth,
      borderColor,
      image
    ];
    return Object.hashAll(values);
  }
}

/// Options to show the details of the trackball template.
@immutable
class TrackballDetails {
  /// Constructor of TrackballDetails class.
  const TrackballDetails(
      [this.point,
      this.series,
      this.pointIndex,
      this.seriesIndex,
      this.groupingModeInfo]);

  /// It specifies the Cartesian chart point.
  final CartesianChartPoint<dynamic>? point;

  /// It specifies the Cartesian series.
  final CartesianSeries<dynamic, dynamic>? series;

  /// It specifies the point index.
  final int? pointIndex;

  /// It specifies the series index.
  final int? seriesIndex;

  /// It specifies the trackball grouping mode info.
  final TrackballGroupingModeInfo? groupingModeInfo;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is TrackballDetails &&
        other.point == point &&
        other.series == series &&
        other.pointIndex == pointIndex &&
        other.seriesIndex == seriesIndex &&
        other.groupingModeInfo == groupingModeInfo;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      point,
      series,
      pointIndex,
      seriesIndex,
      groupingModeInfo
    ];
    return Object.hashAll(values);
  }
}
