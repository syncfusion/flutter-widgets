import 'dart:async';

import 'package:flutter/material.dart';

import '../../common/utils/helper.dart';
import '../axis/axis.dart';
import '../axis/category_axis.dart';
import '../axis/datetime_category_axis.dart';
import '../base/chart_base.dart';
import '../chart_behavior/chart_behavior.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
import '../common/cartesian_state_properties.dart';
import '../common/common.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import 'crosshair_painter.dart';

/// This class has the properties of the crosshair behavior.
///
/// Crosshair behavior has the activation mode and line type property to set the behavior of the crosshair.
/// It also has the property to customize the appearance.
///
/// Provide options for activation mode, line type, line color, line width, hide delay for customizing the
/// behavior of the crosshair.
class CrosshairBehavior {
  /// Creating an argument constructor of CrosshairBehavior class.
  CrosshairBehavior({
    this.activationMode = ActivationMode.longPress,
    this.lineType = CrosshairLineType.both,
    this.lineDashArray,
    this.enable = false,
    this.lineColor,
    this.lineWidth = 1,
    this.shouldAlwaysShow = false,
    this.hideDelay = 0,
  });

  /// Toggles the visibility of the crosshair.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late CrosshairBehavior _crosshairBehavior;
  ///
  /// void initState() {
  ///   _crosshairBehavior = CrosshairBehavior(enable: true);
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     crosshairBehavior: _crosshairBehavior
  ///   );
  /// }
  /// ```
  final bool enable;

  /// Width of the crosshair line.
  ///
  /// Defaults to `1`.
  ///
  /// ```dart
  /// late CrosshairBehavior _crosshairBehavior;
  ///
  /// void initState() {
  ///   _crosshairBehavior = CrosshairBehavior(
  ///     enable: true,
  ///     lineWidth: 5
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     crosshairBehavior: _crosshairBehavior
  /// }
  /// ```
  final double lineWidth;

  /// Color of the crosshair line.
  ///
  /// Color will be applied based on the brightness
  /// property of the app.
  ///
  /// ```dart
  /// late CrosshairBehavior _crosshairBehavior;
  ///
  /// void initState() {
  ///   _crosshairBehavior = CrosshairBehavior(enable: true);
  ///     enable: true,
  ///     lineColor: Colors.red
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     crosshairBehavior: _crosshairBehavior
  ///   );
  /// }
  /// ```
  final Color? lineColor;

  /// Dashes of the crosshair line.
  ///
  /// Any number of values can be provided in the list.
  /// Odd value is considered as rendering size and even value is considered as gap.
  ///
  /// Defaults to `[0,0]`.
  ///
  /// ```dart
  /// late CrosshairBehavior _crosshairBehavior;
  ///
  /// void initState() {
  ///   _crosshairBehavior = CrosshairBehavior(
  ///     enable: true,
  ///     lineDashArray: [10,10]
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     crosshairBehavior: _crosshairBehavior
  ///   );
  /// }
  /// ```
  final List<double>? lineDashArray;

  /// Gesture for activating the crosshair.
  ///
  /// Crosshair can be activated in tap, double tap
  /// and long press.
  ///
  /// Defaults to `ActivationMode.longPress`.
  ///
  /// Also refer [ActivationMode].
  ///
  /// ```dart
  /// late CrosshairBehavior _crosshairBehavior;
  ///
  /// void initState() {
  ///   _crosshairBehavior = CrosshairBehavior(
  ///     enable: true,
  ///     activationMode: ActivationMode.doubleTap
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     crosshairBehavior: _crosshairBehavior
  ///   );
  /// }
  /// ```
  final ActivationMode activationMode;

  /// Type of crosshair line.
  ///
  /// By default, both vertical and horizontal lines will be
  /// displayed. You can change this by specifying values to this property.
  ///
  /// Defaults to `CrosshairLineType.both`.
  ///
  /// Also refer [CrosshairLineType].
  ///
  /// ```dart
  /// late CrosshairBehavior _crosshairBehavior;
  ///
  /// void initState() {
  ///   _crosshairBehavior = CrosshairBehavior(
  ///     enable: true,
  ///     lineType: CrosshairLineType.horizontal
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     crosshairBehavior: _crosshairBehavior
  ///   );
  /// }
  /// ```
  final CrosshairLineType lineType;

  /// Enables or disables the crosshair.
  ///
  /// By default, the crosshair will be hidden on touch.
  /// To avoid this, set this property to true.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late CrosshairBehavior _crosshairBehavior;
  ///
  /// void initState() {
  ///   _crosshairBehavior = CrosshairBehavior(
  ///     enable: true,
  ///     shouldAlwaysShow: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     crosshairBehavior: _crosshairBehavior
  ///   );
  /// }
  /// ```
  final bool shouldAlwaysShow;

  /// Time delay for hiding the crosshair.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// late CrosshairBehavior _crosshairBehavior;
  ///
  /// void initState() {
  ///   _crosshairBehavior = CrosshairBehavior(
  ///     enable: true,
  ///     hideDelay: 3000
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     crosshairBehavior: _crosshairBehavior
  ///   );
  /// }
  /// ```
  final double hideDelay;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is CrosshairBehavior &&
        other.activationMode == activationMode &&
        other.lineType == lineType &&
        other.lineDashArray == lineDashArray &&
        other.enable == enable &&
        other.lineColor == lineColor &&
        other.lineWidth == lineWidth &&
        other.shouldAlwaysShow == shouldAlwaysShow &&
        other.hideDelay == hideDelay;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    final List<Object?> values = <Object?>[
      activationMode,
      lineType,
      lineDashArray,
      enable,
      lineColor,
      lineWidth,
      shouldAlwaysShow,
      hideDelay
    ];
    return Object.hashAll(values);
  }

  /// Represents the cartesian state properties.
  late CartesianStateProperties _stateProperties;

  /// Displays the crosshair at the specified x and y-positions.
  ///
  /// x & y - x and y values/pixel where the crosshair needs to be shown.
  ///
  /// coordinateUnit - specify the type of x and y values given. `pixel` or `point` for logical pixel and chart data point respectively.
  ///
  /// Defaults to `point`.
  void show(dynamic x, double y, [String coordinateUnit = 'point']) {
    // ignore: unnecessary_null_comparison
    if (_stateProperties != null) {
      final CrosshairBehaviorRenderer crosshairBehaviorRenderer =
          _stateProperties.crosshairBehaviorRenderer;
      final CrosshairRenderingDetails renderingDetails =
          CrosshairHelper.getRenderingDetails(crosshairBehaviorRenderer);
      renderingDetails.internalShow(x, y, coordinateUnit);
    }
  }

  /// Displays the crosshair at the specified point index.
  ///
  /// pointIndex - index of point at which the crosshair needs to be shown.
  void showByIndex(int pointIndex) {
    // ignore: unnecessary_null_comparison
    if (_stateProperties != null) {
      final CrosshairBehaviorRenderer crosshairBehaviorRenderer =
          _stateProperties.crosshairBehaviorRenderer;
      final CrosshairRenderingDetails renderingDetails =
          CrosshairHelper.getRenderingDetails(crosshairBehaviorRenderer);
      if (validIndex(pointIndex, 0, renderingDetails.crosshairPainter!.chart)) {
        if (renderingDetails.crosshairPainter != null) {
          final List<CartesianSeriesRenderer> visibleSeriesRenderer =
              renderingDetails.crosshairPainter!.stateProperties.chartSeries
                  .visibleSeriesRenderers;
          final SeriesRendererDetails seriesRendererDetails =
              SeriesHelper.getSeriesRendererDetails(visibleSeriesRenderer[0]);
          final List<CartesianChartPoint<dynamic>> dataPoints =
              getSampledData(seriesRendererDetails);
          // ignore: unnecessary_null_comparison
          if (pointIndex != null &&
              pointIndex.abs() < seriesRendererDetails.dataPoints.length) {
            renderingDetails.crosshairPainter!.generateAllPoints(Offset(
                dataPoints[pointIndex].markerPoint!.x,
                dataPoints[pointIndex].markerPoint!.y));
          }
          renderingDetails.crosshairPainter!.canResetPath = false;
          renderingDetails.crosshairPainter!.stateProperties
              .repaintNotifiers['crosshair']!.value++;
        }
      }
    }
  }

  /// Hides the crosshair if it is displayed.
  void hide() {
    // ignore: unnecessary_null_comparison
    if (_stateProperties != null) {
      final CrosshairBehaviorRenderer crosshairBehaviorRenderer =
          _stateProperties.crosshairBehaviorRenderer;
      final CrosshairRenderingDetails renderingDetails =
          CrosshairHelper.getRenderingDetails(crosshairBehaviorRenderer);
      if (renderingDetails.crosshairPainter != null) {
        renderingDetails.crosshairPainter!.canResetPath = false;
        ValueNotifier<int>(renderingDetails.crosshairPainter!.stateProperties
            .repaintNotifiers['crosshair']!.value++);
        renderingDetails.crosshairPainter!.timer?.cancel();
        if (!_stateProperties.isTouchUp) {
          renderingDetails.crosshairPainter!.stateProperties
              .repaintNotifiers['crosshair']!.value++;
          renderingDetails.crosshairPainter!.canResetPath = true;
          renderingDetails.position = null;
        } else {
          if (!shouldAlwaysShow) {
            final double duration = (hideDelay == 0 &&
                    renderingDetails.crosshairPainter!.stateProperties
                            .enableDoubleTap ==
                        true)
                ? 200
                : hideDelay;
            renderingDetails.crosshairPainter!.timer =
                Timer(Duration(milliseconds: duration.toInt()), () {
              renderingDetails.crosshairPainter!.stateProperties
                  .repaintNotifiers['crosshair']!.value++;
              renderingDetails.crosshairPainter!.canResetPath = true;
              renderingDetails.position = null;
            });
          }
        }
      }
    }
  }
}

/// Crosshair renderer class for mutable fields and methods.
class CrosshairBehaviorRenderer with ChartBehavior {
  /// Creates an argument constructor for Crosshair renderer class.
  CrosshairBehaviorRenderer(this._stateProperties) {
    _crosshairRenderingDetails = CrosshairRenderingDetails(_stateProperties);
  }

  final CartesianStateProperties _stateProperties;

  /// Specifies the value of crosshair rendering details.
  late CrosshairRenderingDetails _crosshairRenderingDetails;

  /// Enables the crosshair on double tap.
  @override
  void onDoubleTap(double xPos, double yPos) =>
      _crosshairRenderingDetails._crosshairBehavior.show(xPos, yPos, 'pixel');

  /// Enables the crosshair on long press.
  @override
  void onLongPress(double xPos, double yPos) =>
      _crosshairRenderingDetails._crosshairBehavior.show(xPos, yPos, 'pixel');

  /// Enables the crosshair on touch down.
  @override
  void onTouchDown(double xPos, double yPos) =>
      _crosshairRenderingDetails._crosshairBehavior.show(xPos, yPos, 'pixel');

  /// Enables the crosshair on touch move.
  @override
  void onTouchMove(double xPos, double yPos) =>
      _crosshairRenderingDetails._crosshairBehavior.show(xPos, yPos, 'pixel');

  /// Enables the crosshair on touch up.
  @override
  void onTouchUp(double xPos, double yPos) =>
      _crosshairRenderingDetails._crosshairBehavior.hide();

  /// Enables the crosshair on mouse hover.
  @override
  void onEnter(double xPos, double yPos) =>
      _crosshairRenderingDetails._crosshairBehavior.show(xPos, yPos, 'pixel');

  /// Disables the crosshair on mouse exit.
  @override
  void onExit(double xPos, double yPos) =>
      _crosshairRenderingDetails._crosshairBehavior.hide();

  /// Draws the crosshair.
  @override
  void onPaint(Canvas canvas) {
    if (_crosshairRenderingDetails.crosshairPainter != null) {
      _crosshairRenderingDetails.crosshairPainter!.drawCrosshair(canvas);
    }
  }
}

/// Represents the class that holds the rendering details of cross hair.
class CrosshairRenderingDetails {
  /// Creates an instance of cross hair rendering details.
  CrosshairRenderingDetails(this._stateProperties);

  final CartesianStateProperties _stateProperties;

  SfCartesianChart get _chart => _stateProperties.chart;

  CrosshairBehavior get _crosshairBehavior => _chart.crosshairBehavior;

  /// Touch position.
  Offset? position;

  /// Holds the instance of CrosshairPainter.
  CrosshairPainter? crosshairPainter;

  /// Check whether long press activated or not.
  bool isLongPressActivated = false;

  /// To draw cross hair line.
  void drawLine(Canvas canvas, Paint? paint, int? seriesIndex) {
    assert(_crosshairBehavior.lineWidth >= 0,
        'Line width value of crosshair should be greater than 0.');
    if (crosshairPainter != null && paint != null) {
      crosshairPainter!.drawCrosshairLine(canvas, paint, seriesIndex);
    }
  }

  /// To get the paint value for the crosshair.
  Paint? linePainter(Paint paint) => crosshairPainter?.getLinePainter(paint);

  /// To show the crosshair with provided coordinates.
  void internalShow(dynamic x, double y, [String coordinateUnit = 'point']) {
    final CrosshairBehaviorRenderer crosshairBehaviorRenderer =
        _stateProperties.crosshairBehaviorRenderer;
    if (coordinateUnit != 'pixel') {
      final SeriesRendererDetails seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(
              _stateProperties.chartSeries.visibleSeriesRenderers[0]);
      final ChartAxisRendererDetails xAxisDetails =
          seriesRendererDetails.xAxisDetails!;
      final ChartLocation location = calculatePoint(
          (x is DateTime && xAxisDetails is! DateTimeCategoryAxisDetails)
              ? x.millisecondsSinceEpoch
              : ((x is DateTime && xAxisDetails is DateTimeCategoryAxisDetails)
                  ? xAxisDetails.labels
                      .indexOf(xAxisDetails.dateFormat.format(x))
                  : ((x is String && xAxisDetails is CategoryAxisDetails)
                      ? xAxisDetails.labels.indexOf(x)
                      : x)),
          y,
          xAxisDetails,
          seriesRendererDetails.yAxisDetails!,
          seriesRendererDetails.stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          seriesRendererDetails.stateProperties.chartAxis.axisClipRect);
      x = location.x;
      y = location.y.truncateToDouble();
    }

    final CrosshairRenderingDetails renderingDetails =
        CrosshairHelper.getRenderingDetails(crosshairBehaviorRenderer);
    if (renderingDetails.crosshairPainter != null && x != null) {
      renderingDetails.crosshairPainter!
          .generateAllPoints(Offset(x.toDouble(), y));
      renderingDetails.crosshairPainter!.canResetPath = false;
      renderingDetails.crosshairPainter!.stateProperties
          .repaintNotifiers['crosshair']!.value++;
    }
  }
}

// ignore: avoid_classes_with_only_static_members
/// Helper class to get the crosshair rendering details instance from its renderer.
class CrosshairHelper {
  /// Returns the crosshair rendering details instance from its renderer.
  static CrosshairRenderingDetails getRenderingDetails(
      CrosshairBehaviorRenderer renderer) {
    return renderer._crosshairRenderingDetails;
  }

  /// Method to set the cartesian state properties.
  static void setStateProperties(CrosshairBehavior crosshairBehavior,
      CartesianStateProperties stateProperties) {
    crosshairBehavior._stateProperties = stateProperties;
  }
}
