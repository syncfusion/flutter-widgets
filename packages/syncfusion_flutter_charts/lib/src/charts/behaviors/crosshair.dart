import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../axis/axis.dart';
import '../axis/category_axis.dart';
import '../axis/datetime_axis.dart';
import '../axis/datetime_category_axis.dart';
import '../axis/logarithmic_axis.dart';
import '../axis/numeric_axis.dart';
import '../base.dart';
import '../common/callbacks.dart';
import '../common/interactive_tooltip.dart';
import '../interactions/behavior.dart';
import '../series/chart_series.dart';
import '../utils/constants.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';

/// This class has the properties of the crosshair behavior.
///
/// Crosshair behavior has the activation mode and line type property to set
/// the behavior of the crosshair. It also has the property to customize
/// the appearance.
///
/// Provide options for activation mode, line type, line color, line width,
/// hide delay for customizing the behavior of the crosshair.
class CrosshairBehavior extends ChartBehavior {
  /// Creating an argument constructor of [CrosshairBehavior] class.
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
  ///   );
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
  ///   _crosshairBehavior = CrosshairBehavior(
  ///      enable: true,lineColor: Colors.red
  ///    );
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
  /// Odd value is considered as rendering size and even value is
  /// considered as gap.
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

  /// Hold crosshair target position.
  Offset? _position;
  Timer? _crosshairHideTimer;

  final List<Path> _verticalPaths = <Path>[];
  final List<Path> _horizontalPaths = <Path>[];
  final List<String> _verticalLabels = <String>[];
  final List<String> _horizontalLabels = <String>[];
  final List<Offset> _verticalLabelPositions = <Offset>[];
  final List<Offset> _horizontalLabelPositions = <Offset>[];

  @override
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

  /// Displays the crosshair at the specified x and y-positions.
  ///
  /// x & y - x and y values/pixel where the crosshair needs to be shown.
  ///
  /// coordinateUnit - specify the type of x and y values given. `pixel` or
  /// `point` for logical pixel and chart data point respectively.
  ///
  /// Defaults to `point`.
  void show(dynamic x, double y, [String coordinateUnit = 'point']) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }

    assert(x != null);
    assert(!y.isNaN);
    if (coordinateUnit == 'point') {
      _position = rawValueToPixelPoint(
          x, y, parent.xAxis, parent.yAxis, parent.isTransposed);
    } else if (coordinateUnit == 'pixel') {
      if (x is num) {
        _position = Offset(x.toDouble(), y);
      } else {
        _position = Offset(
            rawValueToPixelPoint(
                    x, y, parent.xAxis, parent.yAxis, parent.isTransposed)
                .dx,
            y);
      }
    }

    _show();
  }

  /// Displays the crosshair at the specified point index.
  ///
  /// pointIndex - index of point at which the crosshair needs to be shown.
  void showByIndex(int pointIndex) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent != null &&
        parent.plotArea != null &&
        parent.plotArea!.firstChild != null) {
      final CartesianSeriesRenderer seriesRenderer =
          parent.plotArea!.firstChild as CartesianSeriesRenderer;
      final List<num> visibleIndexes = seriesRenderer.visibleIndexes;
      if (visibleIndexes.isNotEmpty &&
          visibleIndexes.first <= pointIndex &&
          pointIndex <= visibleIndexes.last) {
        final num y = seriesRenderer.trackballYValue(pointIndex);
        if (seriesRenderer.xRawValues.isNotEmpty && !y.isNaN) {
          show(seriesRenderer.xRawValues[pointIndex], y.toDouble());
        }
      }
    }
  }

  /// Hides the crosshair if it is displayed.
  void hide() {
    _position = null;
    _resetCrosshairHolders();
    (parentBox as RenderBehaviorArea?)?.invalidate();
  }

  /// To customize the necessary pointer events in behaviors.
  /// (e.g., CrosshairBehavior, TrackballBehavior, ZoomingBehavior).
  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerMoveEvent) {
      _handlePointerMove(event);
    } else if (event is PointerHoverEvent) {
      _handlePointerHover(event);
    } else if (event is PointerCancelEvent || event is PointerUpEvent) {
      _hideCrosshair(immediately: true);
    }
  }

  void _handlePointerMove(PointerMoveEvent details) {
    if (activationMode == ActivationMode.singleTap) {
      _showCrosshair(parentBox!.globalToLocal(details.position));
    }
  }

  void _handlePointerHover(PointerHoverEvent details) {
    if (activationMode == ActivationMode.singleTap) {
      _showCrosshair(parentBox!.globalToLocal(details.position));
    }
  }

  /// Called when a pointer or mouse enter on the screen.
  @override
  void handlePointerEnter(PointerEnterEvent details) {
    if (activationMode == ActivationMode.singleTap) {
      _showCrosshair(parentBox!.globalToLocal(details.position));
    }
  }

  /// Called when a pointer or mouse exit on the screen.
  @override
  void handlePointerExit(PointerExitEvent details) {
    _hideCrosshair(immediately: true);
  }

  /// Called when a long press gesture by a primary button has been
  /// recognized in behavior.
  @override
  void handleLongPressStart(LongPressStartDetails details) {
    if (activationMode == ActivationMode.longPress) {
      _showCrosshair(parentBox!.globalToLocal(details.globalPosition));
    }
  }

  /// Called when moving after the long press gesture by a primary button is
  /// recognized in behavior.
  @override
  void handleLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    if (activationMode == ActivationMode.longPress) {
      _showCrosshair(parentBox!.globalToLocal(details.globalPosition));
    }
  }

  /// Called when the pointer stops contacting the screen after a long-press
  /// by a primary button in behavior.
  @override
  void handleLongPressEnd(LongPressEndDetails details) {
    _hideCrosshair();
  }

  /// Called when the pointer tap has contacted the screen in behavior.
  @override
  void handleTapDown(TapDownDetails details) {
    if (activationMode == ActivationMode.singleTap) {
      _showCrosshair(parentBox!.globalToLocal(details.globalPosition));
    }
  }

  /// Called when pointer has stopped contacting screen in behavior.
  @override
  void handleTapUp(TapUpDetails details) {
    _hideCrosshair();
  }

  /// Called when pointer tap has contacted the screen double time in behavior.
  @override
  void handleDoubleTap(Offset position) {
    if (activationMode == ActivationMode.doubleTap) {
      _showCrosshair(parentBox!.globalToLocal(position));
      _hideCrosshair(doubleTapHideDelay: 200);
    }
  }

  void _showCrosshair(Offset localPosition) {
    if (enable) {
      show(localPosition.dx, localPosition.dy, 'pixel');
    }
  }

  void _hideCrosshair({int doubleTapHideDelay = 0, bool immediately = false}) {
    if (immediately) {
      hide();
    } else if (!shouldAlwaysShow) {
      final int hideDelayDuration =
          hideDelay > 0 ? hideDelay.toInt() : doubleTapHideDelay;
      _crosshairHideTimer?.cancel();
      _crosshairHideTimer =
          Timer(Duration(milliseconds: hideDelayDuration), () {
        _crosshairHideTimer = null;
        hide();
      });
    }
  }

  void _resetCrosshairHolders() {
    _verticalPaths.clear();
    _horizontalPaths.clear();
    _verticalLabels.clear();
    _horizontalLabels.clear();
    _verticalLabelPositions.clear();
    _horizontalLabelPositions.clear();
  }

  void _show() {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (_position == null || parent == null) {
      return;
    }

    final RenderCartesianAxes? cartesianAxes = parent.cartesianAxes;
    if (cartesianAxes == null) {
      return;
    }

    _calculateTooltipLabelAndPositions(parent, cartesianAxes);
    parent.invalidate();
  }

  void _calculateTooltipLabelAndPositions(
      RenderBehaviorArea parent, RenderCartesianAxes cartesianAxes) {
    final Rect plotAreaBounds = parent.paintBounds;
    if (plotAreaBounds.contains(_position!)) {
      _resetCrosshairHolders();

      final Offset plotAreaOffset =
          (parent.parentData! as BoxParentData).offset;
      RenderChartAxis? child = cartesianAxes.firstChild;
      while (child != null) {
        final InteractiveTooltip interactiveTooltip = child.interactiveTooltip;
        if (child.isVisible &&
            interactiveTooltip.enable &&
            child.visibleLabels.isNotEmpty) {
          final TextStyle textStyle = child.chartThemeData!.crosshairTextStyle!
              .merge(interactiveTooltip.textStyle);

          final Offset parentDataOffset =
              (child.parentData! as BoxParentData).offset;
          final Offset axisOffset = parentDataOffset.translate(
              -plotAreaOffset.dx, -plotAreaOffset.dy);
          final Rect axisBounds = axisOffset & child.size;

          if (child.isVertical) {
            _computeVerticalAxisTooltips(
              child,
              _position!,
              textStyle,
              axisBounds,
              plotAreaBounds,
              interactiveTooltip.arrowLength,
              interactiveTooltip.arrowWidth,
              interactiveTooltip.borderRadius,
            );
          } else {
            _computeHorizontalAxisTooltips(
              child,
              _position!,
              textStyle,
              axisBounds,
              plotAreaBounds,
              interactiveTooltip.arrowLength,
              interactiveTooltip.arrowWidth,
              interactiveTooltip.borderRadius,
            );
          }
        }

        final CartesianAxesParentData childParentData =
            child.parentData! as CartesianAxesParentData;
        child = childParentData.nextSibling;
      }
    }
  }

  void _computeHorizontalAxisTooltips(
    RenderChartAxis axis,
    Offset position,
    TextStyle textStyle,
    Rect axisBounds,
    Rect plotAreaBounds,
    double arrowLength,
    double arrowWidth,
    double borderRadius,
  ) {
    final num actualXValue = _actualXValue(axis, position, plotAreaBounds);
    String label = _resultantString(axis, actualXValue);
    label = _triggerCrosshairCallback(axis, label, actualXValue);
    final Size labelSize = measureText(label, textStyle);

    final String tooltipPosition = axis.opposedPosition ? 'Top' : 'Bottom';
    final Rect tooltipRect = _calculateTooltipRect(
        tooltipPosition, position, labelSize, axisBounds, arrowLength);

    final Rect validatedRect = _validateRectBounds(tooltipRect, axisBounds);
    _validateRectXPosition(validatedRect, plotAreaBounds);

    final RRect tooltipRRect =
        RRect.fromRectAndRadius(validatedRect, Radius.circular(borderRadius));

    final Path tooltipAndArrowPath = Path()
      ..addRRect(tooltipRRect)
      ..addPath(
          _tooltipArrowHeadPath(
              tooltipPosition, tooltipRRect, position, arrowLength, arrowWidth),
          Offset.zero);

    _horizontalPaths.add(tooltipAndArrowPath);
    _horizontalLabels.add(label);
    _horizontalLabelPositions.add(_textPosition(tooltipRRect, labelSize));
  }

  void _computeVerticalAxisTooltips(
    RenderChartAxis axis,
    Offset position,
    TextStyle textStyle,
    Rect axisBounds,
    Rect plotAreaBounds,
    double arrowLength,
    double arrowWidth,
    double borderRadius,
  ) {
    final num actualYValue = _actualYValue(axis, position);
    String label = _resultantString(axis, actualYValue);
    label = _triggerCrosshairCallback(axis, label, actualYValue);
    final Size labelSize = measureText(label, textStyle);

    final String tooltipPosition = axis.opposedPosition ? 'Right' : 'Left';
    final Rect tooltipRect = _calculateTooltipRect(
        tooltipPosition, position, labelSize, axisBounds, arrowLength);

    final Rect validatedRect = _validateRectBounds(tooltipRect, axisBounds);
    _validateRectYPosition(validatedRect, plotAreaBounds);

    final RRect tooltipRRect =
        RRect.fromRectAndRadius(validatedRect, Radius.circular(borderRadius));

    final Path tooltipAndArrowPath = Path()
      ..addRRect(tooltipRRect)
      ..addPath(
          _tooltipArrowHeadPath(
              tooltipPosition, tooltipRRect, position, arrowLength, arrowWidth),
          Offset.zero);

    _verticalPaths.add(tooltipAndArrowPath);
    _verticalLabels.add(label);
    _verticalLabelPositions.add(_textPosition(tooltipRRect, labelSize));
  }

  num _actualXValue(
      RenderChartAxis axis, Offset position, Rect plotAreaBounds) {
    return axis.pixelToPoint(axis.paintBounds,
        position.dx - plotAreaBounds.left, position.dy - plotAreaBounds.top);
  }

  num _actualYValue(RenderChartAxis axis, Offset position) {
    return axis.pixelToPoint(axis.paintBounds, position.dx, position.dy);
  }

  String _triggerCrosshairCallback(
      RenderChartAxis axis, String label, num value) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent != null &&
        parent.onCrosshairPositionChanging != null &&
        parent.chartThemeData != null) {
      final CrosshairRenderArgs crosshairEventArgs = CrosshairRenderArgs(
        axis.widget,
        _rawValue(axis, value),
        axis.name,
        axis.isVertical ? AxisOrientation.vertical : AxisOrientation.horizontal,
      );
      crosshairEventArgs.text = label;
      parent.onCrosshairPositionChanging!(crosshairEventArgs);
      return crosshairEventArgs.text;
    }
    return label;
  }

  Rect _validateRectBounds(Rect tooltipRect, Rect axisBounds) {
    const double padding = 0.5; // Padding between the corners.
    Rect validatedRect = tooltipRect;
    double difference = 0;

    if (tooltipRect.left < axisBounds.left) {
      difference = (axisBounds.left - tooltipRect.left) + padding;
      validatedRect = validatedRect.translate(difference, 0);
    }
    if (tooltipRect.right > axisBounds.right) {
      difference = (tooltipRect.right - axisBounds.right) + padding;
      validatedRect = validatedRect.translate(-difference, 0);
    }
    if (tooltipRect.top < axisBounds.top) {
      difference = (axisBounds.top - tooltipRect.top) + padding;
      validatedRect = validatedRect.translate(0, difference);
    }

    if (tooltipRect.bottom > axisBounds.bottom) {
      difference = (tooltipRect.bottom - axisBounds.bottom) + padding;
      validatedRect = validatedRect.translate(0, -difference);
    }
    return validatedRect;
  }

  Rect _validateRectXPosition(Rect labelRect, Rect axisClipRect) {
    if (labelRect.right >= axisClipRect.right) {
      return Rect.fromLTRB(
          labelRect.left - (labelRect.right - axisClipRect.right),
          labelRect.top,
          axisClipRect.right,
          labelRect.bottom);
    } else if (labelRect.left <= axisClipRect.left) {
      return Rect.fromLTRB(
          axisClipRect.left,
          labelRect.top,
          labelRect.right + (axisClipRect.left - labelRect.left),
          labelRect.bottom);
    }
    return labelRect;
  }

  Rect _validateRectYPosition(Rect labelRect, Rect axisClipRect) {
    if (labelRect.bottom >= axisClipRect.bottom) {
      return Rect.fromLTRB(
          labelRect.left,
          labelRect.top - (labelRect.bottom - axisClipRect.bottom),
          labelRect.right,
          axisClipRect.bottom);
    } else if (labelRect.top <= axisClipRect.top) {
      return Rect.fromLTRB(labelRect.left, axisClipRect.top, labelRect.right,
          labelRect.bottom + (axisClipRect.top - labelRect.top));
    }
    return labelRect;
  }

  Rect _calculateTooltipRect(String axis, Offset position, Size labelSize,
      Rect axisBounds, double arrowLength) {
    final double labelWidthWithPadding = labelSize.width + crosshairPadding;
    final double labelHeightWithPadding = labelSize.height + crosshairPadding;
    switch (axis) {
      case 'Left':
        return Rect.fromLTWH(
            axisBounds.right - labelWidthWithPadding - arrowLength,
            position.dy - (labelHeightWithPadding / 2),
            labelWidthWithPadding,
            labelHeightWithPadding);

      case 'Right':
        return Rect.fromLTWH(
            axisBounds.left + arrowLength,
            position.dy - (labelHeightWithPadding / 2),
            labelSize.width + crosshairPadding,
            labelHeightWithPadding);

      case 'Top':
        return Rect.fromLTWH(
            position.dx - (labelWidthWithPadding / 2),
            axisBounds.bottom - labelHeightWithPadding - arrowLength,
            labelWidthWithPadding,
            labelHeightWithPadding);

      case 'Bottom':
        return Rect.fromLTWH(
            position.dx - (labelWidthWithPadding / 2),
            axisBounds.top + arrowLength,
            labelWidthWithPadding,
            labelSize.height + crosshairPadding);
    }
    return Rect.zero;
  }

  Path _tooltipArrowHeadPath(String axis, RRect tooltipRect, Offset position,
      double arrowLength, double arrowWidth) {
    final Path arrowPath = Path();
    final double tooltipLeft = tooltipRect.left;
    final double tooltipRight = tooltipRect.right;
    final double tooltipTop = tooltipRect.top;
    final double tooltipBottom = tooltipRect.bottom;
    final double rectHalfWidth = tooltipRect.width / 2;
    final double rectHalfHeight = tooltipRect.height / 2;
    switch (axis) {
      case 'Left':
        arrowPath.moveTo(
            tooltipRight, tooltipTop + rectHalfHeight - arrowWidth);
        arrowPath.lineTo(
            tooltipRight, tooltipBottom - rectHalfHeight + arrowWidth);
        arrowPath.lineTo(tooltipRight + arrowLength, position.dy);
        arrowPath.close();
        return arrowPath;

      case 'Right':
        arrowPath.moveTo(tooltipLeft, tooltipTop + rectHalfHeight - arrowWidth);
        arrowPath.lineTo(
            tooltipLeft, tooltipBottom - rectHalfHeight + arrowWidth);
        arrowPath.lineTo(tooltipLeft - arrowLength, position.dy);
        arrowPath.close();
        return arrowPath;

      case 'Top':
        arrowPath.moveTo(position.dx, tooltipBottom + arrowLength);
        arrowPath.lineTo(
            (tooltipRight - rectHalfWidth) + arrowWidth, tooltipBottom);
        arrowPath.lineTo(
            (tooltipLeft + rectHalfWidth) - arrowWidth, tooltipBottom);
        arrowPath.close();
        return arrowPath;

      case 'Bottom':
        arrowPath.moveTo(position.dx, tooltipTop - arrowLength);
        arrowPath.lineTo(
            (tooltipRight - rectHalfWidth) + arrowWidth, tooltipTop);
        arrowPath.lineTo(
            (tooltipLeft + rectHalfWidth) - arrowWidth, tooltipTop);
        arrowPath.close();
        return arrowPath;
    }
    return arrowPath;
  }

  Offset _textPosition(RRect tooltipRect, Size labelSize) {
    return Offset(
        (tooltipRect.left + tooltipRect.width / 2) - labelSize.width / 2,
        (tooltipRect.top + tooltipRect.height / 2) - labelSize.height / 2);
  }

  String _resultantString(RenderChartAxis axis, num actualValue) {
    final String resultantString =
        _interactiveTooltipLabel(actualValue, axis).toString();
    if (axis.interactiveTooltip.format != null) {
      return axis.interactiveTooltip.format!
          .replaceAll('{value}', resultantString);
    } else {
      return resultantString;
    }
  }

  /// To get interactive tooltip label.
  String _interactiveTooltipLabel(num value, RenderChartAxis axis) {
    if (axis is RenderCategoryAxis) {
      final num index = value < 0 ? 0 : value;
      final List<String?> labels = axis.labels;
      final int labelsLength = labels.length;
      return labels[(index.round() >= labelsLength
                  ? (index.round() > labelsLength
                      ? labelsLength - 1
                      : index - 1)
                  : index)
              .round()]
          .toString();
    } else if (axis is RenderDateTimeCategoryAxis) {
      final num index = value < 0 ? 0 : value;
      final List<int> labels = axis.labels;
      final int labelsLength = labels.length;
      final int milliseconds = labels[(index.round() >= labelsLength
              ? (index.round() > labelsLength ? labelsLength - 1 : index - 1)
              : index)
          .round()];
      final num interval = axis.visibleRange!.minimum.ceil();
      final num previousInterval =
          labels.isNotEmpty ? labels[labelsLength - 1] : interval;
      final DateFormat dateFormat = axis.dateFormat ??
          dateTimeCategoryAxisLabelFormat(
              axis, interval.toInt(), previousInterval.toInt());
      return dateFormat
          .format(DateTime.fromMillisecondsSinceEpoch(milliseconds.toInt()));
    } else if (axis is RenderDateTimeAxis) {
      final num interval = axis.visibleRange!.minimum.ceil();
      final List<AxisLabel> visibleLabels = axis.visibleLabels;
      final num previousInterval = visibleLabels.isNotEmpty
          ? visibleLabels[visibleLabels.length - 1].value
          : interval;
      final DateFormat dateFormat = axis.dateFormat ??
          dateTimeAxisLabelFormat(
              axis, interval.toInt(), previousInterval.toInt());
      return dateFormat
          .format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));
    } else if (axis is RenderLogarithmicAxis) {
      return logAxisLabel(
          axis, axis.toPow(value), axis.interactiveTooltip.decimalPlaces);
    } else if (axis is RenderNumericAxis) {
      return numericAxisLabel(
          axis, value, axis.interactiveTooltip.decimalPlaces);
    } else {
      return '';
    }
  }

  // It specifies for callback value field.
  dynamic _rawValue(RenderChartAxis axis, num value) {
    if (axis is RenderCategoryAxis) {
      final num index = value < 0 ? 0 : value;
      final int labelsLength = axis.labels.length;
      final String? label = axis.labels[(index.round() >= labelsLength
              ? (index.round() > labelsLength ? labelsLength - 1 : index - 1)
              : index)
          .round()];
      return axis.labels.indexOf(label);
    } else if (axis is RenderDateTimeCategoryAxis) {
      final num index = value < 0 ? 0 : value;
      final int labelsLength = axis.labels.length;
      return axis.labels[(index.round() >= labelsLength
              ? (index.round() > labelsLength ? labelsLength - 1 : index - 1)
              : index)
          .round()];
    } else {
      return value;
    }
  }

  /// Override this method to customize the crosshair tooltips & line rendering.
  @override
  void onPaint(PaintingContext context, Offset offset,
      SfChartThemeData chartThemeData, ThemeData themeData) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (_position == null || parent == null) {
      return;
    }

    if (parent.paintBounds.contains(_position!)) {
      _drawCrosshairLines(context, _position!, parent, chartThemeData);
      _drawCrosshairTooltip(context, parent);
    }
  }

  void _drawCrosshairLines(PaintingContext context, Offset offset,
      RenderBehaviorArea parent, SfChartThemeData chartThemeData) {
    Color crosshairLineColor =
        (lineColor ?? chartThemeData.crosshairLineColor)!;
    if (parent.onCrosshairPositionChanging != null &&
        parent.chartThemeData != null) {
      final CrosshairRenderArgs crosshairEventArgs = CrosshairRenderArgs();
      crosshairEventArgs.text = '';
      crosshairEventArgs.lineColor = crosshairLineColor;
      parent.onCrosshairPositionChanging!(crosshairEventArgs);
      crosshairLineColor = crosshairEventArgs.lineColor;
    }

    final Paint paint = Paint()
      ..isAntiAlias = true
      ..color = crosshairLineColor
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    switch (lineType) {
      case CrosshairLineType.both:
        drawHorizontalAxisLine(context, offset, lineDashArray, paint);
        drawVerticalAxisLine(context, offset, lineDashArray, paint);
        break;

      case CrosshairLineType.horizontal:
        drawHorizontalAxisLine(context, offset, lineDashArray, paint);
        break;

      case CrosshairLineType.vertical:
        drawVerticalAxisLine(context, offset, lineDashArray, paint);
        break;

      case CrosshairLineType.none:
        break;
    }
  }

  /// Override this method to customize the horizontal line drawing and styling.
  @protected
  void drawHorizontalAxisLine(PaintingContext context, Offset offset,
      List<double>? dashArray, Paint paint) {
    if (parentBox == null) {
      return;
    }

    final Rect plotAreaBounds = parentBox!.paintBounds;
    final Offset start = Offset(plotAreaBounds.left, offset.dy);
    final Offset end = Offset(plotAreaBounds.right, offset.dy);
    drawDashes(context.canvas, dashArray, paint, start: start, end: end);
  }

  /// Override this method to customize the vertical line drawing and styling.
  @protected
  void drawVerticalAxisLine(PaintingContext context, Offset offset,
      List<double>? dashArray, Paint paint) {
    if (parentBox == null) {
      return;
    }

    final Rect plotAreaBounds = parentBox!.paintBounds;
    final Offset start = Offset(offset.dx, plotAreaBounds.top);
    final Offset end = Offset(offset.dx, plotAreaBounds.bottom);
    drawDashes(context.canvas, dashArray, paint, start: start, end: end);
  }

  void _drawCrosshairTooltip(
      PaintingContext context, RenderBehaviorArea parent) {
    final RenderCartesianAxes? cartesianAxes = parent.cartesianAxes;
    if (cartesianAxes == null) {
      return;
    }

    final Color themeBackgroundColor =
        parent.chartThemeData!.crosshairBackgroundColor!;
    _drawHorizontalAxisTooltip(context, cartesianAxes, themeBackgroundColor);
    _drawVerticalAxisTooltip(context, cartesianAxes, themeBackgroundColor);
  }

  void _drawHorizontalAxisTooltip(PaintingContext context,
      RenderCartesianAxes cartesianAxes, Color themeBackgroundColor) {
    if (_horizontalPaths.isNotEmpty &&
        _horizontalLabels.isNotEmpty &&
        _horizontalLabelPositions.isNotEmpty) {
      final Paint fillPaint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.fill;
      final Paint strokePaint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.stroke;

      RenderChartAxis? child = cartesianAxes.firstChild;
      int index = 0;
      while (child != null) {
        final InteractiveTooltip interactiveTooltip = child.interactiveTooltip;
        if (!child.isVertical &&
            child.isVisible &&
            interactiveTooltip.enable &&
            child.visibleLabels.isNotEmpty) {
          final TextStyle textStyle = child.chartThemeData!.crosshairTextStyle!
              .merge(interactiveTooltip.textStyle);
          fillPaint.color = interactiveTooltip.color ?? themeBackgroundColor;
          strokePaint
            ..color = interactiveTooltip.borderColor ?? themeBackgroundColor
            ..strokeWidth = interactiveTooltip.borderWidth;

          drawHorizontalAxisTooltip(
              context,
              _horizontalLabelPositions[index],
              _horizontalLabels[index],
              textStyle,
              _horizontalPaths[index],
              fillPaint,
              strokePaint);

          index++;
        }

        final CartesianAxesParentData childParentData =
            child.parentData! as CartesianAxesParentData;
        child = childParentData.nextSibling;
      }
    }
  }

  void _drawVerticalAxisTooltip(PaintingContext context,
      RenderCartesianAxes cartesianAxes, Color themeBackgroundColor) {
    if (_verticalPaths.isNotEmpty &&
        _verticalLabels.isNotEmpty &&
        _verticalLabelPositions.isNotEmpty) {
      final Paint fillPaint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.fill;
      final Paint strokePaint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.stroke;

      RenderChartAxis? child = cartesianAxes.firstChild;
      int index = 0;
      while (child != null) {
        final InteractiveTooltip interactiveTooltip = child.interactiveTooltip;
        if (child.isVertical &&
            child.isVisible &&
            interactiveTooltip.enable &&
            child.visibleLabels.isNotEmpty) {
          final TextStyle textStyle = child.chartThemeData!.crosshairTextStyle!
              .merge(interactiveTooltip.textStyle);
          fillPaint.color = interactiveTooltip.color ?? themeBackgroundColor;
          strokePaint
            ..color = interactiveTooltip.borderColor ?? themeBackgroundColor
            ..strokeWidth = interactiveTooltip.borderWidth;

          drawVerticalAxisTooltip(
              context,
              _verticalLabelPositions[index],
              _verticalLabels[index],
              textStyle,
              _verticalPaths[index],
              fillPaint,
              strokePaint);

          index++;
        }

        final CartesianAxesParentData childParentData =
            child.parentData! as CartesianAxesParentData;
        child = childParentData.nextSibling;
      }
    }
  }

  /// Override this method to customize the horizontal axis tooltip with styling
  /// and it's position.
  @protected
  void drawHorizontalAxisTooltip(
      PaintingContext context, Offset position, String text, TextStyle style,
      [Path? path, Paint? fillPaint, Paint? strokePaint]) {
    _drawTooltipAndLabel(
        context, position, text, style, path, fillPaint, strokePaint);
  }

  /// Override this method to customize the vertical axis tooltip with styling
  /// and it's position.
  @protected
  void drawVerticalAxisTooltip(
      PaintingContext context, Offset position, String text, TextStyle style,
      [Path? path, Paint? fillPaint, Paint? strokePaint]) {
    _drawTooltipAndLabel(
        context, position, text, style, path, fillPaint, strokePaint);
  }

  void _drawTooltipAndLabel(
      PaintingContext context, Offset position, String text, TextStyle style,
      [Path? path, Paint? fillPaint, Paint? strokePaint]) {
    if (text.isEmpty) {
      return;
    }

    // Draw tooltip rectangle.
    if (path != null && fillPaint != null && strokePaint != null) {
      context.canvas.drawPath(path, strokePaint);
      context.canvas.drawPath(path, fillPaint);
    }

    // Draw label.
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        textAlign: TextAlign.center,
        maxLines: getMaxLinesContent(text),
        textDirection: TextDirection.rtl);
    textPainter
      ..layout()
      ..paint(context.canvas, position);
  }
}
