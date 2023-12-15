import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../axis/axis.dart';
import '../base/chart_base.dart';
import '../chart_behavior/zoom_behavior.dart';
import '../common/cartesian_state_properties.dart';
import '../common/common.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import 'zooming_painter.dart';

/// Customizes the zooming options.
///
/// Customize the various zooming actions such as tap zooming, selection zooming,
/// zoom pinch. In selection zooming, you can long-press and drag to select a
/// range on the chart to be zoomed in and also you can customize the selection
/// zooming rectangle using `selectionRectBorderWidth`,
/// `selectionRectBorderColor` and `selectionRectColor` properties.
///
/// Pinch zooming can be performed by moving two fingers over the chart.
/// Default mode is [ZoomMode.xy]. Zooming will be stopped after reaching
/// `maximumZoomLevel`.
///
/// _Note:_ This is only applicable for `SfCartesianChart`.
class ZoomPanBehavior {
  /// Creating an argument constructor of ZoomPanBehavior class.
  ZoomPanBehavior(
      {this.enablePinching = false,
      this.enableDoubleTapZooming = false,
      this.enablePanning = false,
      this.enableSelectionZooming = false,
      this.enableMouseWheelZooming = false,
      this.zoomMode = ZoomMode.xy,
      this.maximumZoomLevel = 0.01,
      this.selectionRectBorderWidth = 1,
      this.selectionRectBorderColor,
      this.selectionRectColor});

  /// Enables or disables the pinch zooming.
  ///
  /// Pinching can be performed by moving two fingers over the
  /// chart. You can zoom the chart through pinch gesture in touch enabled devices.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     enablePinching: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final bool enablePinching;

  /// Enables or disables the double tap zooming.
  ///
  /// Zooming will enable when you tap double time in plotarea.
  /// After reaching the maximum zoom level, zooming will be stopped.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     enableDoubleTapZooming: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final bool enableDoubleTapZooming;

  /// Enables or disables the panning.
  ///
  /// Panning can be performed on a zoomed axis.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     enablePanning: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final bool enablePanning;

  /// Enables or disables the selection zooming.
  ///
  /// Selection zooming can be performed by long-press and then dragging.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     enableSelectionZooming: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final bool enableSelectionZooming;

  /// Enables or disables the mouseWheelZooming.
  ///
  /// Mouse wheel zooming can be performed by rolling the mouse wheel up or
  /// down. The place where the cursor is hovering gets zoomed in or out
  /// according to the mouse wheel rolling up or down.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     enableMouseWheelZooming: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final bool enableMouseWheelZooming;

  /// By default, both the x and y-axes in the chart can be zoomed.
  ///
  /// It can be changed by setting value to this property.
  ///
  /// Defaults to `ZoomMode.xy`.
  ///
  /// Also refer [ZoomMode].
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     zoomMode: ZoomMode.x
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final ZoomMode zoomMode;

  /// Maximum zoom level.
  ///
  /// Zooming will be stopped after reached this value and ranges from 0 to 1.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     maximumZoomLevel: 0.8
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final double maximumZoomLevel;

  /// Border width of the selection zooming rectangle.
  ///
  /// Used to change the stroke width of the selection rectangle.
  ///
  /// Defaults to `1`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     enableSelectionZooming: true,
  ///     selectionRectBorderWidth: 2
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final double selectionRectBorderWidth;

  /// Border color of the selection zooming rectangle.
  ///
  /// It used to change the stroke color of the selection rectangle.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     enableSelectionZooming: true,
  ///     selectionRectBorderColor: Colors.red
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final Color? selectionRectBorderColor;

  /// Color of the selection zooming rectangle.
  ///
  /// It used to change the background color of the selection rectangle.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     enableSelectionZooming: true,
  ///     selectionRectColor: Colors.yellow
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final Color? selectionRectColor;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is ZoomPanBehavior &&
        other.enablePinching == enablePinching &&
        other.enableDoubleTapZooming == enableDoubleTapZooming &&
        other.enablePanning == enablePanning &&
        other.enableSelectionZooming == enableSelectionZooming &&
        other.enableMouseWheelZooming == enableMouseWheelZooming &&
        other.zoomMode == zoomMode &&
        other.maximumZoomLevel == maximumZoomLevel &&
        other.selectionRectBorderWidth == selectionRectBorderWidth &&
        other.selectionRectBorderColor == selectionRectBorderColor &&
        other.selectionRectColor == selectionRectColor;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    final List<Object?> values = <Object?>[
      enablePinching,
      enableDoubleTapZooming,
      enablePanning,
      enableSelectionZooming,
      enableMouseWheelZooming,
      zoomMode,
      maximumZoomLevel,
      selectionRectBorderWidth,
      selectionRectBorderColor,
      selectionRectColor
    ];
    return Object.hashAll(values);
  }

  /// Holds the value of cartesian state properties.
  late CartesianStateProperties _stateProperties;

  /// Increases the magnification of the plot area.
  void zoomIn() {
    _stateProperties.canSetRangeController = true;
    final SfCartesianChart chart = _stateProperties.chart;
    final ZoomPanBehaviorRenderer zoomPanBehaviorRenderer =
        _stateProperties.zoomPanBehaviorRenderer;
    zoomPanBehaviorRenderer._zoomingBehaviorDetails.isZoomIn = true;
    zoomPanBehaviorRenderer._zoomingBehaviorDetails.isZoomOut = false;
    final double? zoomFactor =
        zoomPanBehaviorRenderer._zoomingBehaviorDetails.zoomFactor;
    _stateProperties.zoomProgress = true;
    ChartAxisRendererDetails axisDetails;
    bool? needZoom;
    for (int index = 0;
        index < _stateProperties.chartAxis.axisRenderersCollection.length;
        index++) {
      axisDetails = AxisHelper.getAxisRendererDetails(
          _stateProperties.chartAxis.axisRenderersCollection[index]);
      if ((axisDetails.orientation == AxisOrientation.vertical &&
              chart.zoomPanBehavior.zoomMode != ZoomMode.x) ||
          (axisDetails.orientation == AxisOrientation.horizontal &&
              chart.zoomPanBehavior.zoomMode != ZoomMode.y)) {
        if (axisDetails.zoomFactor <= 1.0 && axisDetails.zoomFactor > 0.0) {
          if (axisDetails.zoomFactor - 0.1 < 0) {
            needZoom = false;
            break;
          } else {
            zoomPanBehaviorRenderer._zoomingBehaviorDetails
                .setZoomFactorAndZoomPosition(
                    _stateProperties.chartState, axisDetails, zoomFactor);
            needZoom = true;
          }
        }
        if (chart.onZooming != null) {
          bindZoomEvent(chart, axisDetails, chart.onZooming!);
        }
      }
    }
    if (needZoom ?? false) {
      zoomPanBehaviorRenderer._zoomingBehaviorDetails.createZoomState();
    }
  }

  /// Decreases the magnification of the plot area.
  void zoomOut() {
    _stateProperties.canSetRangeController = true;
    final SfCartesianChart chart = _stateProperties.chart;
    final ZoomPanBehaviorRenderer zoomPanBehaviorRenderer =
        _stateProperties.zoomPanBehaviorRenderer;
    zoomPanBehaviorRenderer._zoomingBehaviorDetails.isZoomOut = true;
    zoomPanBehaviorRenderer._zoomingBehaviorDetails.isZoomIn = false;
    final double? zoomFactor =
        zoomPanBehaviorRenderer._zoomingBehaviorDetails.zoomFactor;
    ChartAxisRendererDetails axisDetails;
    for (int index = 0;
        index < _stateProperties.chartAxis.axisRenderersCollection.length;
        index++) {
      axisDetails = AxisHelper.getAxisRendererDetails(
          _stateProperties.chartAxis.axisRenderersCollection[index]);
      if ((axisDetails.orientation == AxisOrientation.vertical &&
              chart.zoomPanBehavior.zoomMode != ZoomMode.x) ||
          (axisDetails.orientation == AxisOrientation.horizontal &&
              chart.zoomPanBehavior.zoomMode != ZoomMode.y)) {
        if (axisDetails.zoomFactor < 1.0 && axisDetails.zoomFactor > 0.0) {
          zoomPanBehaviorRenderer._zoomingBehaviorDetails
              .setZoomFactorAndZoomPosition(
                  _stateProperties.chartState, axisDetails, zoomFactor);
          axisDetails.zoomFactor = axisDetails.zoomFactor > 1.0
              ? 1.0
              : (axisDetails.zoomFactor < 0.0 ? 0.0 : axisDetails.zoomFactor);
        }
        if (chart.onZooming != null) {
          bindZoomEvent(chart, axisDetails, chart.onZooming!);
        }
      }
    }
    zoomPanBehaviorRenderer._zoomingBehaviorDetails.createZoomState();
  }

  /// Changes the zoom level using zoom factor.
  ///
  /// Here, you can pass the zoom factor of an axis to magnify the plot
  /// area. The value ranges from 0 to 1.
  void zoomByFactor(double zoomFactor) {
    _stateProperties.canSetRangeController = true;
    final SfCartesianChart chart = _stateProperties.chart;
    ChartAxisRendererDetails axisDetails;
    for (int index = 0;
        index < _stateProperties.chartAxis.axisRenderersCollection.length;
        index++) {
      axisDetails = AxisHelper.getAxisRendererDetails(
          _stateProperties.chartAxis.axisRenderersCollection[index]);
      axisDetails.zoomFactor = zoomFactor;
      if (chart.onZooming != null) {
        bindZoomEvent(chart, axisDetails, chart.onZooming!);
      }
      _stateProperties.zoomPanBehaviorRenderer._zoomingBehaviorDetails
          .createZoomState();
    }
  }

  /// Zooms the chart for a given rectangle value.
  ///
  /// Here, you can pass the rectangle with the left, right, top, and bottom values,
  /// using which the selection zooming will be performed.
  void zoomByRect(Rect rect) {
    _stateProperties.canSetRangeController = true;
    _stateProperties.zoomPanBehaviorRenderer._zoomingBehaviorDetails
        .doSelectionZooming(rect);
  }

  /// Change the zoom level of an appropriate axis.
  ///
  ///  Here, you need to pass axis, zoom factor, zoom position of the zoom level that needs to be modified.
  void zoomToSingleAxis(
      ChartAxis axis, double zoomPosition, double zoomFactor) {
    _stateProperties.canSetRangeController = true;
    final ChartAxisRenderer? axisRenderer = findExistingAxisRenderer(
        axis, _stateProperties.chartAxis.axisRenderersCollection);
    final ChartAxisRendererDetails axisDetails =
        AxisHelper.getAxisRendererDetails(axisRenderer!);
    // ignore: unnecessary_null_comparison
    if (axisRenderer != null) {
      axisDetails.zoomFactor = zoomFactor;
      axisDetails.zoomPosition = zoomPosition;
      _stateProperties.zoomPanBehaviorRenderer._zoomingBehaviorDetails
          .createZoomState();
    }
  }

  /// Pans the plot area for given left, right, top, and bottom directions.
  ///
  /// To perform this action, the plot area needs to be in zoomed state.
  void panToDirection(String direction) {
    _stateProperties.canSetRangeController = true;
    final SfCartesianChart chart = _stateProperties.chart;
    ChartAxisRendererDetails axisDetails;
    direction = direction.toLowerCase();
    for (int axisIndex = 0;
        axisIndex < _stateProperties.chartAxis.axisRenderersCollection.length;
        axisIndex++) {
      axisDetails = AxisHelper.getAxisRendererDetails(
          _stateProperties.chartAxis.axisRenderersCollection[axisIndex]);
      if (axisDetails.orientation == AxisOrientation.horizontal) {
        if (direction == 'left') {
          axisDetails.zoomPosition =
              (axisDetails.zoomPosition > 0 && axisDetails.zoomPosition <= 0.9)
                  ? axisDetails.zoomPosition - 0.1
                  : axisDetails.zoomPosition;
          axisDetails.zoomPosition =
              axisDetails.zoomPosition < 0.0 ? 0.0 : axisDetails.zoomPosition;
        }
        if (direction == 'right') {
          axisDetails.zoomPosition =
              (axisDetails.zoomPosition >= 0 && axisDetails.zoomPosition < 1)
                  ? axisDetails.zoomPosition + 0.1
                  : axisDetails.zoomPosition;
          axisDetails.zoomPosition =
              axisDetails.zoomPosition > 1.0 ? 1.0 : axisDetails.zoomPosition;
        }
      } else {
        if (direction == 'bottom') {
          axisDetails.zoomPosition =
              (axisDetails.zoomPosition > 0 && axisDetails.zoomPosition <= 0.9)
                  ? axisDetails.zoomPosition - 0.1
                  : axisDetails.zoomPosition;
          axisDetails.zoomPosition =
              axisDetails.zoomPosition < 0.0 ? 0.0 : axisDetails.zoomPosition;
        }
        if (direction == 'top') {
          axisDetails.zoomPosition =
              (axisDetails.zoomPosition >= 0 && axisDetails.zoomPosition < 1)
                  ? axisDetails.zoomPosition + 0.1
                  : axisDetails.zoomPosition;
          axisDetails.zoomPosition =
              axisDetails.zoomPosition > 1.0 ? 1.0 : axisDetails.zoomPosition;
        }
      }
      if (chart.onZooming != null) {
        bindZoomEvent(chart, axisDetails, chart.onZooming!);
      }
    }
    _stateProperties.zoomPanBehaviorRenderer._zoomingBehaviorDetails
        .createZoomState();
  }

  /// Returns the plot area back to its original position after zooming.
  void reset() {
    _stateProperties.canSetRangeController = true;
    final SfCartesianChart chart = _stateProperties.chart;
    ChartAxisRendererDetails axisDetails;
    for (int index = 0;
        index < _stateProperties.chartAxis.axisRenderersCollection.length;
        index++) {
      axisDetails = AxisHelper.getAxisRendererDetails(
          _stateProperties.chartAxis.axisRenderersCollection[index]);
      axisDetails.zoomFactor = 1.0;
      axisDetails.zoomPosition = 0.0;
      if (chart.onZoomReset != null) {
        bindZoomEvent(chart, axisDetails, chart.onZoomReset!);
      }
    }
    _stateProperties.zoomPanBehaviorRenderer._zoomingBehaviorDetails
        .createZoomState();
  }
}

/// Creates a renderer class for [ZoomPanBehavior] class
class ZoomPanBehaviorRenderer with ZoomBehavior {
  /// Creates an argument constructor for ZoomPanBehavior renderer class.
  ZoomPanBehaviorRenderer(this._stateProperties) {
    _zoomingBehaviorDetails = ZoomingBehaviorDetails(_stateProperties);
  }

  /// Holds the value of zoom behavior details.
  late ZoomingBehaviorDetails _zoomingBehaviorDetails;
  final CartesianStateProperties _stateProperties;

  /// Performs panning action.
  @override
  void onPan(double xPos, double yPos) =>
      _zoomingBehaviorDetails.doPan(xPos, yPos);

  /// Performs the double-tap action.
  @override
  void onDoubleTap(double xPos, double yPos, double? zoomFactor) =>
      _zoomingBehaviorDetails.doubleTapZooming(xPos, yPos, zoomFactor);

  /// Draws selection zoomRect.
  @override
  void onPaint(Canvas canvas) =>
      _zoomingBehaviorDetails.painter.drawRect(canvas);

  /// Performs selection zooming.
  @override
  void onDrawSelectionZoomRect(
          double currentX, double currentY, double startX, double startY) =>
      _zoomingBehaviorDetails.drawSelectionZoomRect(
          currentX, currentY, startX, startY);

  /// Performs pinch start action.
  @override
  void onPinchStart(ChartAxis axis, double firstX, double firstY,
      double secondX, double secondY, double scaleFactor) {}

  /// Performs pinch end action.
  @override
  void onPinchEnd(ChartAxis axis, double firstX, double firstY, double secondX,
      double secondY, double scaleFactor) {}

  /// Performs pinch zooming.
  @override
  void onPinch(ChartAxisRendererDetails axisDetails, double position,
      double scaleFactor) {
    axisDetails.zoomFactor = scaleFactor;
    axisDetails.zoomPosition = position;
  }
}

/// Represents the zoom axis range class.
class ZoomAxisRange {
  /// Creates an instance of zoom axis range class.
  ZoomAxisRange({this.actualMin, this.actualDelta, this.min, this.delta});

  /// Holds the value of actual minimum, actual delta, minimum and delta value.
  double? actualMin, actualDelta, min, delta;
}

/// Represents the zooming behavior details class.
class ZoomingBehaviorDetails {
  /// Creates an instance for zooming behavior details.
  ZoomingBehaviorDetails(this.stateProperties);

  ZoomPanBehavior get _zoomPanBehavior => _chart.zoomPanBehavior;
  SfCartesianChart get _chart => stateProperties.chart;

  /// Creates an instance of cartesian state properties.
  final CartesianStateProperties stateProperties;

  /// Holds the value of zoom rect painter.
  late ZoomRectPainter painter;

  /// Holds the previously moved position.
  Offset? previousMovedPosition;

  /// Specifies whether the panning or pinching is done.
  bool? isPanning, isPinching;

  /// Specifies whether to do perform selection.
  bool canPerformSelection = false;

  /// Holds the value of zooming rect.
  Rect zoomingRect = Rect.zero;

  /// Specifies whether to draw with delay.
  bool delayRedraw = false;

  /// Specifies the value of zoom factor and zoom position.
  double? zoomFactor, _zoomPosition;

  /// Specifies whether the zoom in or zoom out is performed.
  late bool isZoomIn, isZoomOut;

  /// Specifies the value of rect path.
  Path? rectPath;

  /// Below method for double tap zooming.
  void doubleTapZooming(double xPos, double yPos, double? zoomFactor) {
    stateProperties.canSetRangeController = true;
    stateProperties.zoomProgress = true;
    ChartAxisRendererDetails axisDetails;
    double cumulative, origin, maxZoomFactor;
    for (int axisIndex = 0;
        axisIndex < stateProperties.chartAxis.axisRenderersCollection.length;
        axisIndex++) {
      axisDetails = AxisHelper.getAxisRendererDetails(
          stateProperties.chartAxis.axisRenderersCollection[axisIndex]);
      if (_chart.onZoomStart != null) {
        bindZoomEvent(_chart, axisDetails, _chart.onZoomStart!);
      }
      axisDetails.previousZoomFactor = axisDetails.zoomFactor;
      axisDetails.previousZoomPosition = axisDetails.zoomPosition;
      if ((axisDetails.orientation == AxisOrientation.vertical &&
              _zoomPanBehavior.zoomMode != ZoomMode.x) ||
          (axisDetails.orientation == AxisOrientation.horizontal &&
              _zoomPanBehavior.zoomMode != ZoomMode.y)) {
        cumulative = math.max(
            math.max(1 / _minMax(axisDetails.zoomFactor, 0, 1), 1) + (0.25), 1);
        if (cumulative >= 1) {
          origin = axisDetails.orientation == AxisOrientation.horizontal
              ? xPos / stateProperties.chartAxis.axisClipRect.width
              : 1 - (yPos / stateProperties.chartAxis.axisClipRect.height);
          origin = origin > 1
              ? 1
              : origin < 0
                  ? 0
                  : origin;
          zoomFactor =
              cumulative == 1 ? 1 : _minMax(1 / cumulative, 0, 1).toDouble();
          _zoomPosition = (cumulative == 1)
              ? 0
              : axisDetails.zoomPosition +
                  ((axisDetails.zoomFactor - zoomFactor) * origin);
          if (axisDetails.zoomPosition != _zoomPosition ||
              axisDetails.zoomFactor != zoomFactor) {
            zoomFactor = (_zoomPosition! + zoomFactor) > 1
                ? (1 - _zoomPosition!)
                : zoomFactor;
          }

          axisDetails.zoomPosition = _zoomPosition!;
          axisDetails.zoomFactor = zoomFactor;
          axisDetails.bounds = Rect.zero;
          axisDetails.visibleLabels = <AxisLabel>[];
        }
        maxZoomFactor = _zoomPanBehavior.maximumZoomLevel;
        if (zoomFactor! < maxZoomFactor) {
          axisDetails.zoomFactor = maxZoomFactor;
          axisDetails.zoomPosition = 0.0;
          zoomFactor = maxZoomFactor;
        }
      }

      if (_chart.onZoomEnd != null) {
        bindZoomEvent(_chart, axisDetails, _chart.onZoomEnd!);
      }
    }
    createZoomState();
  }

  /// Below method is for panning the zoomed chart.
  void doPan(double xPos, double yPos) {
    stateProperties.canSetRangeController = true;
    num currentScale, value;
    ChartAxisRendererDetails axisDetails;
    double currentZoomPosition;
    bool isNeedPan = false;
    for (int axisIndex = 0;
        axisIndex < stateProperties.chartAxis.axisRenderersCollection.length;
        axisIndex++) {
      axisDetails = AxisHelper.getAxisRendererDetails(
          stateProperties.chartAxis.axisRenderersCollection[axisIndex]);
      axisDetails.previousZoomFactor = axisDetails.zoomFactor;
      axisDetails.previousZoomPosition = axisDetails.zoomPosition;
      if ((axisDetails.orientation == AxisOrientation.vertical &&
              _zoomPanBehavior.zoomMode != ZoomMode.x) ||
          (axisDetails.orientation == AxisOrientation.horizontal &&
              _zoomPanBehavior.zoomMode != ZoomMode.y)) {
        currentZoomPosition = axisDetails.zoomPosition;
        currentScale = math.max(1 / _minMax(axisDetails.zoomFactor, 0, 1), 1);
        if (axisDetails.orientation == AxisOrientation.horizontal) {
          value = (previousMovedPosition!.dx - xPos) /
              stateProperties.chartAxis.axisClipRect.width /
              currentScale;
          currentZoomPosition = _minMax(
                  axisDetails.axis.isInversed
                      ? axisDetails.zoomPosition - value
                      : axisDetails.zoomPosition + value,
                  0,
                  1 - axisDetails.zoomFactor)
              .toDouble();
          axisDetails.zoomPosition = currentZoomPosition;
          if (((axisDetails.previousZoomPosition != null &&
                      axisDetails.previousZoomPosition! > 0.0) ||
                  currentZoomPosition > 0.0) &&
              !isNeedPan) {
            isNeedPan = true;
          }
        } else {
          value = (previousMovedPosition!.dy - yPos) /
              stateProperties.chartAxis.axisClipRect.height /
              currentScale;
          currentZoomPosition = _minMax(
                  axisDetails.axis.isInversed
                      ? axisDetails.zoomPosition + value
                      : axisDetails.zoomPosition - value,
                  0,
                  1 - axisDetails.zoomFactor)
              .toDouble();
          axisDetails.zoomPosition = currentZoomPosition;
          if (currentZoomPosition > 0.0 && !isNeedPan) {
            isNeedPan = true;
          }
        }
      }
      if (_chart.onZooming != null) {
        bindZoomEvent(_chart, axisDetails, _chart.onZooming!);
      }
    }
    if (isNeedPan) {
      createZoomState();
    }
  }

  /// Below method for drawing selection rectangle.
  void drawSelectionZoomRect(
      double currentX, double currentY, double startX, double startY) {
    stateProperties.canSetRangeController = true;
    final Rect clipRect = stateProperties.chartAxis.axisClipRect;
    final Offset startPosition = Offset(
        (startX < clipRect.left) ? clipRect.left : startX,
        (startY < clipRect.top) ? clipRect.top : startY);
    final Offset currentMousePosition = Offset(
        (currentX > clipRect.right)
            ? clipRect.right
            : ((currentX < clipRect.left) ? clipRect.left : currentX),
        (currentY > clipRect.bottom)
            ? clipRect.bottom
            : ((currentY < clipRect.top) ? clipRect.top : currentY));
    rectPath = Path();
    if (_zoomPanBehavior.zoomMode == ZoomMode.x) {
      rectPath!.moveTo(startPosition.dx, clipRect.top);
      rectPath!.lineTo(startPosition.dx, clipRect.bottom);
      rectPath!.lineTo(currentMousePosition.dx, clipRect.bottom);
      rectPath!.lineTo(currentMousePosition.dx, clipRect.top);
      rectPath!.close();
    } else if (_zoomPanBehavior.zoomMode == ZoomMode.y) {
      rectPath!.moveTo(clipRect.left, startPosition.dy);
      rectPath!.lineTo(clipRect.left, currentMousePosition.dy);
      rectPath!.lineTo(clipRect.right, currentMousePosition.dy);
      rectPath!.lineTo(clipRect.right, startPosition.dy);
      rectPath!.close();
    } else {
      rectPath!.moveTo(startPosition.dx, startPosition.dy);
      rectPath!.lineTo(startPosition.dx, currentMousePosition.dy);
      rectPath!.lineTo(currentMousePosition.dx, currentMousePosition.dy);
      rectPath!.lineTo(currentMousePosition.dx, startPosition.dy);
      rectPath!.close();
    }
    zoomingRect = rectPath!.getBounds();
    stateProperties.repaintNotifiers['zoom']!.value++;
  }

  /// Below method for zooming selected portion.
  void doSelectionZooming(Rect zoomRect) {
    stateProperties.canSetRangeController = true;
    final Rect rect = stateProperties.chartAxis.axisClipRect;
    ChartAxisRendererDetails axisDetails;
    for (int axisIndex = 0;
        axisIndex < stateProperties.chartAxis.axisRenderersCollection.length;
        axisIndex++) {
      axisDetails = AxisHelper.getAxisRendererDetails(
          stateProperties.chartAxis.axisRenderersCollection[axisIndex]);
      if (_chart.onZoomStart != null) {
        bindZoomEvent(_chart, axisDetails, _chart.onZoomStart!);
      }
      axisDetails.previousZoomFactor = axisDetails.zoomFactor;
      axisDetails.previousZoomPosition = axisDetails.zoomPosition;
      if (axisDetails.orientation == AxisOrientation.horizontal) {
        if (_zoomPanBehavior.zoomMode != ZoomMode.y) {
          axisDetails.zoomPosition +=
              ((zoomRect.left - rect.left) / (rect.width)).abs() *
                  axisDetails.zoomFactor;
          axisDetails.zoomFactor *= zoomRect.width / rect.width;
          axisDetails.zoomFactor =
              axisDetails.zoomFactor >= _zoomPanBehavior.maximumZoomLevel
                  ? axisDetails.zoomFactor
                  : _zoomPanBehavior.maximumZoomLevel;
        }
      } else {
        if (_zoomPanBehavior.zoomMode != ZoomMode.x) {
          axisDetails.zoomPosition += (1 -
                  ((zoomRect.height + (zoomRect.top - rect.top)) /
                          (rect.height))
                      .abs()) *
              axisDetails.zoomFactor;
          axisDetails.zoomFactor *= zoomRect.height / rect.height;

          axisDetails.zoomFactor =
              axisDetails.zoomFactor >= _zoomPanBehavior.maximumZoomLevel
                  ? axisDetails.zoomFactor
                  : _zoomPanBehavior.maximumZoomLevel;
        }
      }
      if (_chart.onZoomEnd != null) {
        bindZoomEvent(_chart, axisDetails, _chart.onZoomEnd!);
      }
    }

    zoomRect = Rect.zero;
    rectPath = Path();
    createZoomState();
  }

  /// Below method is for pinch zooming.
  void performPinchZooming(
      List<PointerEvent> touchStartList, List<PointerEvent> touchMoveList) {
    stateProperties.canSetRangeController = true;
    num touch0StartX,
        touch0StartY,
        touch1StartX,
        touch1StartY,
        touch0EndX,
        touch0EndY,
        touch1EndX,
        touch1EndY;
    if (!(zoomingRect.width > 0 && zoomingRect.height > 0)) {
      _calculateZoomAxesRange(_chart);
      delayRedraw = true;
      final Rect clipRect = stateProperties.chartAxis.axisClipRect;
      final Rect containerRect =
          stateProperties.renderingDetails.chartContainerRect;
      touch0StartX = touchStartList[0].position.dx - containerRect.left;
      touch0StartY = touchStartList[0].position.dy - containerRect.top;
      touch0EndX = touchMoveList[0].position.dx - containerRect.left;
      touch0EndY = touchMoveList[0].position.dy - containerRect.top;
      touch1StartX = touchStartList[1].position.dx - containerRect.left;
      touch1StartY = touchStartList[1].position.dy - containerRect.top;
      touch1EndX = touchMoveList[1].position.dx - containerRect.left;
      touch1EndY = touchMoveList[1].position.dy - containerRect.top;
      double scaleX, scaleY, clipX, clipY;
      Rect pinchRect;
      scaleX =
          (touch0EndX - touch1EndX).abs() / (touch0StartX - touch1StartX).abs();
      scaleY =
          (touch0EndY - touch1EndY).abs() / (touch0StartY - touch1StartY).abs();
      clipX = ((clipRect.left - touch0EndX) / scaleX) +
          math.min(touch0StartX, touch1StartX);
      clipY = ((clipRect.top - touch0EndY) / scaleY) +
          math.min(touch0StartY, touch1StartY);
      pinchRect = Rect.fromLTWH(
          clipX, clipY, clipRect.width / scaleX, clipRect.height / scaleY);
      _calculatePinchZoomFactor(_chart, pinchRect);
      stateProperties.zoomProgress = true;
      createZoomState();
    }
  }

  /// To create zoomed states.
  void createZoomState() {
    stateProperties.rangeChangeBySlider = false;
    stateProperties.isRedrawByZoomPan = true;
    stateProperties.zoomedAxisRendererStates = <ChartAxisRenderer>[];
    stateProperties.zoomedAxisRendererStates
        .addAll(stateProperties.chartAxis.axisRenderersCollection);
    stateProperties.renderingDetails.isLegendToggled = false;
    stateProperties.redraw();
  }

  /// Below method is for pinch zooming.
  void _calculatePinchZoomFactor(SfCartesianChart chart, Rect pinchRect) {
    stateProperties.canSetRangeController = true;
    final ZoomMode mode = _zoomPanBehavior.zoomMode;
    num selectionMin, selectionMax, rangeMin, rangeMax, value, axisTrans;
    double currentZoomPosition, currentZoomFactor;
    double currentFactor, currentPosition, maxZoomFactor, minZoomFactor = 1.0;
    final Rect clipRect = stateProperties.chartAxis.axisClipRect;
    final List<ZoomAxisRange> zoomAxes = stateProperties.zoomAxes;
    ChartAxisRendererDetails axisDetails;
    for (int axisIndex = 0;
        axisIndex < stateProperties.chartAxis.axisRenderersCollection.length;
        axisIndex++) {
      axisDetails = AxisHelper.getAxisRendererDetails(
          stateProperties.chartAxis.axisRenderersCollection[axisIndex]);
      axisDetails.previousZoomFactor = axisDetails.zoomFactor;
      axisDetails.previousZoomPosition = axisDetails.zoomPosition;
      if ((axisDetails.orientation == AxisOrientation.horizontal &&
              mode != ZoomMode.y) ||
          (axisDetails.orientation == AxisOrientation.vertical &&
              mode != ZoomMode.x)) {
        if (axisDetails.orientation == AxisOrientation.horizontal) {
          value = pinchRect.left - clipRect.left;
          axisTrans = clipRect.width / zoomAxes[axisIndex].delta!;
          rangeMin = value / axisTrans + zoomAxes[axisIndex].min!;
          value = pinchRect.left + pinchRect.width - clipRect.left;
          rangeMax = value / axisTrans + zoomAxes[axisIndex].min!;
        } else {
          value = pinchRect.top - clipRect.top;
          axisTrans = clipRect.height / zoomAxes[axisIndex].delta!;
          rangeMin = (value * -1 + clipRect.height) / axisTrans +
              zoomAxes[axisIndex].min!;
          value = pinchRect.top + pinchRect.height - clipRect.top;
          rangeMax = (value * -1 + clipRect.height) / axisTrans +
              zoomAxes[axisIndex].min!;
        }
        selectionMin = math.min(rangeMin, rangeMax);
        selectionMax = math.max(rangeMin, rangeMax);
        currentPosition = (selectionMin - zoomAxes[axisIndex].actualMin!) /
            zoomAxes[axisIndex].actualDelta!;
        currentFactor =
            (selectionMax - selectionMin) / zoomAxes[axisIndex].actualDelta!;
        currentZoomPosition = currentPosition < 0 ? 0 : currentPosition;
        currentZoomFactor = currentFactor > 1 ? 1 : currentFactor;
        maxZoomFactor = _zoomPanBehavior.maximumZoomLevel;
        if (axisDetails.axis.autoScrollingDelta != null &&
            axisDetails.scrollingDelta != null) {
          // To find zoom factor for corresponding auto scroll delta.
          minZoomFactor =
              axisDetails.scrollingDelta! / zoomAxes[axisIndex].actualDelta!;
        }
        if (currentZoomFactor < maxZoomFactor) {
          axisDetails.zoomFactor = maxZoomFactor;
          currentZoomFactor = maxZoomFactor;
        }
        if (currentZoomFactor > minZoomFactor) {
          // To restrict zoom factor to corresponding auto scroll delta.
          axisDetails.zoomFactor = minZoomFactor;
          currentZoomFactor = minZoomFactor;
        }
        stateProperties.zoomPanBehaviorRenderer
            .onPinch(axisDetails, currentZoomPosition, currentZoomFactor);
      }
      if (chart.onZooming != null) {
        bindZoomEvent(chart, axisDetails, chart.onZooming!);
      }
    }
  }

  num _minMax(num value, num min, num max) =>
      value > max ? max : (value < min ? min : value);

  /// Below method is for storing calculated zoom range.
  void _calculateZoomAxesRange(SfCartesianChart chart) {
    ChartAxisRendererDetails axisDetails;
    ZoomAxisRange range;
    VisibleRange? axisRange;
    for (int index = 0;
        index < stateProperties.chartAxis.axisRenderersCollection.length;
        index++) {
      axisDetails = AxisHelper.getAxisRendererDetails(
          stateProperties.chartAxis.axisRenderersCollection[index]);
      range = ZoomAxisRange();
      if (axisDetails.visibleRange != null) {
        axisRange = axisDetails.visibleRange!;
      }
      if (stateProperties.zoomAxes.isNotEmpty &&
          index <= stateProperties.zoomAxes.length - 1) {
        if (!delayRedraw) {
          stateProperties.zoomAxes[index].min = axisRange!.minimum.toDouble();
          stateProperties.zoomAxes[index].delta = axisRange.delta.toDouble();
        }
      } else {
        if (axisDetails.actualRange != null) {
          range.actualMin = axisDetails.actualRange!.minimum.toDouble();
          range.actualDelta = axisDetails.actualRange!.delta.toDouble();
        }
        range.min = axisRange!.minimum.toDouble();
        range.delta = axisRange.delta.toDouble();
        stateProperties.zoomAxes.add(range);
      }
    }
  }

  /// Below method is for mouse wheel Zooming.
  void performMouseWheelZooming(
      PointerEvent event, double mouseX, double mouseY) {
    stateProperties.canSetRangeController = true;
    double direction = 0.0;
    if (event is PointerScrollEvent) {
      direction = (event.scrollDelta.dy / 120) > 0 ? -1 : 1;
    } else if (event is PointerPanZoomUpdateEvent) {
      direction = event.panDelta.dy == 0
          ? 0
          : (event.panDelta.dy / 120) > 0
              ? 1
              : -1;
    }
    double origin = 0.5;
    double cumulative, zoomFactor, zoomPosition, maxZoomFactor;
    stateProperties.zoomProgress = true;
    _calculateZoomAxesRange(_chart);
    isPanning = _chart.zoomPanBehavior.enablePanning;
    ChartAxisRendererDetails axisDetails;
    for (int axisIndex = 0;
        axisIndex < stateProperties.chartAxis.axisRenderersCollection.length;
        axisIndex++) {
      axisDetails = AxisHelper.getAxisRendererDetails(
          stateProperties.chartAxis.axisRenderersCollection[axisIndex]);
      if (_chart.onZoomStart != null) {
        bindZoomEvent(_chart, axisDetails, _chart.onZoomStart!);
      }
      axisDetails.previousZoomFactor = axisDetails.zoomFactor;
      axisDetails.previousZoomPosition = axisDetails.zoomPosition;
      if ((axisDetails.orientation == AxisOrientation.vertical &&
              _zoomPanBehavior.zoomMode != ZoomMode.x) ||
          (axisDetails.orientation == AxisOrientation.horizontal &&
              _zoomPanBehavior.zoomMode != ZoomMode.y)) {
        cumulative = math.max(
            math.max(1 / _minMax(axisDetails.zoomFactor, 0, 1), 1) +
                (0.25 * direction),
            1);
        if (cumulative >= 1) {
          origin = axisDetails.orientation == AxisOrientation.horizontal
              ? mouseX / stateProperties.chartAxis.axisClipRect.width
              : 1 - (mouseY / stateProperties.chartAxis.axisClipRect.height);
          origin = origin > 1
              ? 1
              : origin < 0
                  ? 0
                  : origin;
          zoomFactor = ((cumulative == 1) ? 1 : _minMax(1 / cumulative, 0, 1))
              .toDouble();
          zoomPosition = (cumulative == 1)
              ? 0
              : axisDetails.zoomPosition +
                  ((axisDetails.zoomFactor - zoomFactor) * origin);
          if (axisDetails.zoomPosition != zoomPosition ||
              axisDetails.zoomFactor != zoomFactor) {
            zoomFactor = (zoomPosition + zoomFactor) > 1
                ? (1 - zoomPosition)
                : zoomFactor;
          }
          axisDetails.zoomPosition = zoomPosition;
          axisDetails.zoomFactor = zoomFactor;
          axisDetails.bounds = Rect.zero;
          axisDetails.visibleLabels = <AxisLabel>[];
          maxZoomFactor = _zoomPanBehavior.maximumZoomLevel;
          if (zoomFactor < maxZoomFactor) {
            axisDetails.zoomFactor = maxZoomFactor;
            zoomFactor = maxZoomFactor;
          }
          if (_chart.onZoomEnd != null) {
            bindZoomEvent(_chart, axisDetails, _chart.onZoomEnd!);
          }
          if (axisDetails.zoomFactor.toInt() == 1 &&
              axisDetails.zoomPosition.toInt() == 0 &&
              _chart.onZoomReset != null) {
            bindZoomEvent(_chart, axisDetails, _chart.onZoomReset!);
          }
        }
      }
    }
    createZoomState();
  }

  /// Below method is for zoomIn and zoomOut public methods.
  void setZoomFactorAndZoomPosition(SfCartesianChartState chartState,
      ChartAxisRendererDetails axisDetails, double? zoomFactor) {
    final Rect axisClipRect = stateProperties.chartAxis.axisClipRect;
    final num direction = isZoomIn
        ? 1
        : isZoomOut
            ? -1
            : 1;
    final num cumulative = math.max(
        math.max(1 / _minMax(axisDetails.zoomFactor, 0, 1), 1) +
            (0.1 * direction),
        1);
    if (cumulative >= 1) {
      num origin = axisDetails.orientation == AxisOrientation.horizontal
          ? (axisClipRect.left + axisClipRect.width / 2) / axisClipRect.width
          : 1 -
              ((axisClipRect.top + axisClipRect.height / 2) /
                  axisClipRect.height);
      origin = origin > 1
          ? 1
          : origin < 0
              ? 0
              : origin;
      zoomFactor =
          ((cumulative == 1) ? 1 : _minMax(1 / cumulative, 0, 1)).toDouble();
      _zoomPosition = (cumulative == 1)
          ? 0
          : axisDetails.zoomPosition +
              ((axisDetails.zoomFactor - zoomFactor) * origin);
      if (axisDetails.zoomPosition != _zoomPosition ||
          axisDetails.zoomFactor != zoomFactor) {
        zoomFactor = (_zoomPosition! + zoomFactor) > 1
            ? (1 - _zoomPosition!)
            : zoomFactor;
      }

      axisDetails.zoomPosition = _zoomPosition!;
      axisDetails.zoomFactor = zoomFactor;
    }
  }
}

// ignore: avoid_classes_with_only_static_members
/// Helper class to get the zooming behavior rendering details instance from its renderer.
class ZoomPanBehaviorHelper {
  /// Gets the zooming behavior details.
  static ZoomingBehaviorDetails getRenderingDetails(
      ZoomPanBehaviorRenderer renderer) {
    return renderer._zoomingBehaviorDetails;
  }

  /// Method to set the cartesian state properties.
  static void setStateProperties(ZoomPanBehavior zoomPanBehavior,
      CartesianStateProperties stateProperties) {
    zoomPanBehavior._stateProperties = stateProperties;
  }
}
