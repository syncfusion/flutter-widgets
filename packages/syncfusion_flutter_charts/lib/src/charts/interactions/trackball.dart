import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../common/chart_point.dart';
import '../common/marker.dart';
import '../utils/enum.dart';
import 'behavior.dart';

/// Options to customize the markers that are displayed when
/// trackball is enabled.
///
/// Trackball markers are used to provide information about the exact
/// point location, when the trackball is visible. You can add a shape to adorn
/// each data point. Trackball markers can be enabled by using the
/// [markerVisibility] property in [TrackballMarkerSettings].
/// Provides the options like color, border width, border color and shape of the
/// marker to customize the appearance.
class TrackballMarkerSettings extends MarkerSettings {
  /// Creating an argument constructor of TrackballMarkerSettings class.
  const TrackballMarkerSettings({
    this.markerVisibility = TrackballVisibilityMode.auto,
    super.height,
    super.width,
    super.color,
    super.shape,
    super.borderWidth,
    super.borderColor,
    super.image,
  });

  /// Whether marker should be visible or not when trackball is enabled.
  ///
  /// The below values are applicable for this:
  /// * TrackballVisibilityMode.auto - If the [isVisible] property in the series
  /// `markerSettings` is set to true, then the trackball marker will also be
  /// displayed for that particular series, else it will not be displayed.
  /// * TrackballVisibilityMode.visible - Makes the trackball marker visible
  /// for all the series,
  /// irrespective of considering the [isVisible] property's value in the
  /// `markerSettings`.
  /// * TrackballVisibilityMode.hidden - Hides the trackball marker for all
  /// the series.
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

class TrackballInfo {
  TrackballInfo({
    required this.position,
    this.name,
    this.color,
  });

  /// Local position of the tooltip.
  final Offset? position;

  /// Specifies the series name.
  final String? name;

  /// Specifies the series color.
  final Color? color;
}

/// Class to store trackball tooltip start and end positions.
class TooltipPositions {
  /// Creates the parameterized constructor for the class TooltipPositions.
  const TooltipPositions(this.tooltipTop, this.tooltipBottom);

  /// Specifies the tooltip top value.
  final List<num> tooltipTop;

  /// Specifies the tooltip bottom value.
  final List<num> tooltipBottom;
}

/// Class to store the string values with their corresponding series renderer.
class TrackballElement {
  /// Creates the parameterized constructor for the class _TrackballElement.
  TrackballElement(this.label, this.seriesRenderer);

  /// Specifies the trackball label value.
  final String label;

  /// Specifies the value of cartesian series renderer.
  final dynamic seriesRenderer;

  /// Specifies whether to render the trackball element.
  bool needRender = true;
}

class ClosestPoints {
  /// Creates the parameterized constructor for class ClosestPoints.
  const ClosestPoints(
      {required this.closestPointX, required this.closestPointY});

  /// Holds the closest x point value.
  final double closestPointX;

  /// Holds the closest y point value.
  final double closestPointY;
}

/// Represents the chart location.
class ChartLocation {
  /// Creates an instance of chart location.
  ChartLocation(this.x, this.y);

  /// Specifies the value of x.
  double x;

  /// Specifies the value of y.
  double y;
}

class ChartTrackballInfo<T, D> extends TrackballInfo {
  ChartTrackballInfo({
    required super.position,
    required this.point,
    required this.series,
    required this.pointIndex,
    required this.seriesIndex,
    this.lowYPos,
    this.highXPos,
    this.highYPos,
    this.openXPos,
    this.openYPos,
    this.closeXPos,
    this.closeYPos,
    this.minYPos,
    this.maxXPos,
    this.maxYPos,
    this.lowerXPos,
    this.lowerYPos,
    this.upperXPos,
    this.upperYPos,
    super.name,
    super.color,
  });

  final CartesianChartPoint<D> point;
  final dynamic series;
  final int pointIndex;
  final int seriesIndex;
  double? lowYPos;
  double? highXPos;
  double? highYPos;
  double? openXPos;
  double? openYPos;
  double? closeXPos;
  double? closeYPos;
  double? minYPos;
  double? maxXPos;
  double? maxYPos;
  double? lowerXPos;
  double? lowerYPos;
  double? upperXPos;
  double? upperYPos;
}

class TrackballRenderObject extends SingleChildRenderObjectWidget {
  const TrackballRenderObject(
      {Key? key,
      required Widget child,
      required this.template,
      required this.xPos,
      required this.yPos,
      required this.trackballBehavior,
      this.chartPointInfo,
      this.index})
      : super(key: key, child: child);

  final Widget template;
  final int? index;
  final List<ChartPointInfo>? chartPointInfo;
  final double xPos;
  final double yPos;
  final TrackballBehavior trackballBehavior;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return TrackballTemplateRenderBox(
      template,
      xPos,
      yPos,
      trackballBehavior,
      chartPointInfo,
      index,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant TrackballTemplateRenderBox renderObject) {
    renderObject.template = template;
    renderObject.index = index;
    renderObject.xPos = xPos;
    renderObject.yPos = yPos;
    renderObject.trackballBehavior = trackballBehavior;
    renderObject.chartPointInfo = chartPointInfo;
  }
}
