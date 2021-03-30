import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../axis/radial_axis.dart';
import '../common/common.dart';
import '../common/radial_gauge_renderer.dart';
import '../pointers/gauge_pointer.dart';
import '../pointers/range_pointer.dart';
import '../pointers/widget_pointer.dart';
import '../renderers/radial_axis_renderer_base.dart';
import '../renderers/widget_pointer_renderer_base.dart';
import '../utils/helper.dart';

/// This class has the methods for customizing the default gauge axis
abstract class GaugePointerRenderer {
  /// Creates the
  GaugePointerRenderer() {
    needsRepaintPointer = true;
    isDragStarted = false;
    animationEndValue = 0;
  }

  /// Holds the corresponding  gauge pointer
  late GaugePointer gaugePointer;

  ///Holds the correponding axis renderer
  late RadialAxisRendererBase axisRenderer;

  /// Specifies the axis for this pointer
  late RadialAxis axis;

  /// Specifies whether to repaint the marker
  late bool needsRepaintPointer;

  /// Specifies the current value of the point
  late double currentValue;

  /// Specifies the pointer rect
  late Rect pointerRect;

  /// Specifies the value whether the pointer is dragged
  bool? isDragStarted;

  /// Specifies the animation value of  pointer
  Animation<double>? pointerAnimation;

  /// Holds the end value of pointer animation
  double? animationEndValue;

  /// Holds the animation start value;
  double? animationStartValue;

  /// Holds the animation rendering details
  late RenderingDetails renderingDetails;

  /// Holds the value whether to animate the pointer
  bool? needsAnimate;

  /// Specifies whether the pointer is hovered
  bool? isHovered;

  /// Method to calculates the pointer position
  void calculatePosition();

  /// Method to update the drag value
  void updateDragValue(double x, double y, RenderingDetails animationDetails) {
    final double actualCenterX = axisRenderer.axisSize.width * axis.centerX;
    final double actualCenterY = axisRenderer.axisSize.height * axis.centerY;
    double angle =
        math.atan2(y - actualCenterY, x - actualCenterX) * (180 / math.pi) +
            360;
    final double endAngle = axis.startAngle + axisRenderer.sweepAngle;
    if (angle < 360 && angle > 180) {
      angle += 360;
    }

    if (angle > endAngle) {
      angle %= 360;
    }

    if (angle >= axis.startAngle && angle <= endAngle) {
      double dragValue = 0;

      /// The current pointer value is calculated from the angle
      if (!axis.isInversed) {
        dragValue = axis.minimum +
            (angle - axis.startAngle) *
                ((axis.maximum - axis.minimum) / axisRenderer.sweepAngle);
      } else {
        dragValue = axis.maximum -
            (angle - axis.startAngle) *
                ((axis.maximum - axis.minimum) / axisRenderer.sweepAngle);
      }

      if (this is RangePointer) {
        final num calculatedInterval = axisRenderer.calculateAxisInterval(3);
        // Restricts the dragging of range pointer from the minimum value
        // of axis
        if (dragValue < axis.minimum + calculatedInterval / 2) {
          return;
        }
      }
      _setCurrentPointerValue(dragValue, animationDetails);
    }
  }

  /// Method to set the current pointer value
  void _setCurrentPointerValue(
      double dragValue, RenderingDetails animationDetails) {
    final double actualValue = getMinMax(dragValue, axis.minimum, axis.maximum);
    const int maximumLabel = 3;
    final int niceInterval =
        axisRenderer.calculateAxisInterval(maximumLabel).toInt();

    // Restricts the dragging of pointer once the maximum value of axis
    // is reached
    if (niceInterval != axis.maximum / 2 &&
        ((actualValue.round() <= niceInterval &&
                currentValue >= axis.maximum - niceInterval) ||
            (actualValue.round() >= axis.maximum - niceInterval &&
                currentValue <= niceInterval))) {
      return;
    }

    if (gaugePointer.onValueChanging != null) {
      final ValueChangingArgs args = ValueChangingArgs()..value = actualValue;
      gaugePointer.onValueChanging!(args);
      if (args.cancel != null && args.cancel!) {
        return;
      }
    }

    if (isHovered != null && !isHovered!) {
      isHovered = true;
    }

    final int index =
        axisRenderer.renderingDetails.axisRenderers.indexOf(axisRenderer);
    final List<GaugePointerRenderer>? pointerRenderers =
        axisRenderer.renderingDetails.gaugePointerRenderers[index];
    final List<GaugePointerRenderer> renderers = (pointerRenderers!.where(
        (element) => element.isHovered != null && element.isHovered!)).toList();
    for (int i = 0; i < renderers.length; i++) {
      if (renderers[i].gaugePointer != this.gaugePointer) {
        renderers[i].isHovered = false;
      }
    }

    currentValue = actualValue;
    calculatePosition();
    createPointerValueChangedArgs();
    if (gaugePointer is WidgetPointer) {
      final WidgetPointerRenderer pointerRenderer =
          this as WidgetPointerRenderer;
      pointerRenderer.refreshPointer();
    } else {
      animationDetails.pointerRepaintNotifier.value++;
    }
  }

  /// Method to fire the on value change end event
  void createPointerValueChangeEndArgs() {
    if (gaugePointer.onValueChangeEnd != null) {
      gaugePointer.onValueChangeEnd!(currentValue);
    }
  }

  /// Method to fire the on value changed event
  void createPointerValueChangedArgs() {
    if (gaugePointer.onValueChanged != null) {
      gaugePointer.onValueChanged!(currentValue);
    }
  }

  /// Method to fire the on value change start event
  void createPointerValueChangeStartArgs() {
    if (gaugePointer.onValueChangeStart != null) {
      gaugePointer.onValueChangeStart!(currentValue);
    }
  }

  /// Specifies whether the pointer animation is enabled
  bool getIsPointerAnimationEnabled() {
    return gaugePointer.enableAnimation &&
        gaugePointer.animationDuration > 0 &&
        needsAnimate != null &&
        needsAnimate!;
  }

  /// Calculates the sweep angle of the pointer
  double getSweepAngle() {
    return (axis.onCreateAxisRenderer != null &&
            axisRenderer.renderer != null &&
            axisRenderer.renderer!.valueToFactor(currentValue) != null)
        ? axisRenderer.renderer!.valueToFactor(currentValue) ??
            axisRenderer.valueToFactor(currentValue)
        : axisRenderer.valueToFactor(currentValue);
  }
}
