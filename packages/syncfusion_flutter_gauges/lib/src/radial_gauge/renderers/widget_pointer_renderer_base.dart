import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../common/widget_pointer_renderer.dart';
import '../pointers/widget_pointer.dart';
import '../renderers/gauge_pointer_renderer.dart';
import '../utils/helper.dart';

///  The [WidgetPointerRenderer] has methods to render marker pointer
///
class WidgetPointerRenderer extends GaugePointerRenderer {
  /// Creates the instance for widget pointer renderer
  WidgetPointerRenderer() : super();

  /// Specifies the margin for calculating
  /// marker pointer rect
  final double _margin = 15;

  /// Specifies the marker offset
  late Offset offset;

  /// Specifies the radian value of the marker
  late double _radian;

  /// Specifies the angle value
  late double angle;

  /// Specifies the total offset considering axis element
  late double _totalOffset;

  /// Specifies actual marker offset value
  late double _actualWidgetOffset;

  /// Specifies the widget size
  Size? widgetSize;

  /// Specifies the pointer renderer
  late WidgetPointerContainer? pointerRenderer;

  /// method to calculate the marker position
  @override
  void calculatePosition() {
    final WidgetPointer widgetPointer = gaugePointer as WidgetPointer;
    angle = getPointerAngle();
    _radian = getDegreeToRadian(angle);
    final Offset offset = getPointerOffset(_radian, widgetPointer);

    if (widgetSize != null) {
      pointerRect = Rect.fromLTRB(
          offset.dx - widgetSize!.width / 2 - _margin,
          offset.dy - widgetSize!.height / 2 - _margin,
          offset.dx + widgetSize!.width / 2 + _margin,
          offset.dy + widgetSize!.height / 2 + _margin);
    }
  }

  /// Method returns the angle of  current pointer value
  double getPointerAngle() {
    currentValue = getMinMax(currentValue, axis.minimum, axis.maximum);
    return (axisRenderer.valueToFactor(currentValue) *
            axisRenderer.sweepAngle) +
        axis.startAngle;
  }

  /// Method to refresh the widget pointer
  void refreshPointer() {
    if (pointerRenderer != null) {
      final GlobalKey<WidgetPointerContainerState>? key =
          pointerRenderer!.key as GlobalKey<WidgetPointerContainerState>;
      if (key != null && key.currentState != null) {
        key.currentState!.refresh();
      }
    }
  }

  /// Calculates the marker offset position
  Offset getPointerOffset(double pointerRadian, WidgetPointer widgetPointer) {
    _actualWidgetOffset = axisRenderer.getActualValue(
        widgetPointer.offset, widgetPointer.offsetUnit, true);
    _totalOffset = _actualWidgetOffset < 0
        ? axisRenderer.getAxisOffset() + _actualWidgetOffset
        : (_actualWidgetOffset + axisRenderer.axisOffset);
    if (!axis.canScaleToFit) {
      final double x = (axisRenderer.axisSize.width / 2) +
          (axisRenderer.radius -
                  _totalOffset -
                  (axisRenderer.actualAxisWidth / 2)) *
              math.cos(pointerRadian) -
          axisRenderer.centerX;
      final double y = (axisRenderer.axisSize.height / 2) +
          (axisRenderer.radius -
                  _totalOffset -
                  (axisRenderer.actualAxisWidth / 2)) *
              math.sin(pointerRadian) -
          axisRenderer.centerY;
      offset = Offset(x, y);
    } else {
      final double x = axisRenderer.axisCenter.dx +
          (axisRenderer.radius -
                  _totalOffset -
                  (axisRenderer.actualAxisWidth / 2)) *
              math.cos(pointerRadian);
      final double y = axisRenderer.axisCenter.dy +
          (axisRenderer.radius -
                  _totalOffset -
                  (axisRenderer.actualAxisWidth / 2)) *
              math.sin(pointerRadian);
      offset = Offset(x, y);
    }
    return offset;
  }

  /// Specifies whether the pointer animation is enabled
  bool getIsPointerAnimationEnabled() {
    return gaugePointer.enableAnimation &&
        gaugePointer.animationDuration > 0 &&
        needsAnimate != null &&
        needsAnimate!;
  }
}
