import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../gauges.dart';
import '../pointers/range_pointer.dart';
import '../renderers/gauge_pointer_renderer.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';

/// This class has methods to render the range pointer
///
class RangePointerRenderer extends GaugePointerRenderer {
  /// Creates the instance for range pointer renderer
  RangePointerRenderer() : super() {
    isDragStarted = false;
    animationEndValue = 0;
  }

  /// Holds the start arc value
  late double startArc;

  /// Holds the end arc value
  late double endArc;

  /// Holds the actual range thickness
  late double actualRangeThickness;

  /// Specifies the range arc top
  late double _rangeArcTop;

  /// Specifies the range arc bottom
  late double _rangeArcBottom;

  /// Specifies the range arc left
  late double _rangeArcLeft;

  /// Specifies the range arc right
  late double _rangeArcRight;

  /// Specifies the arc rect
  late Rect arcRect;

  /// Specifies the arc path
  late Path arcPath;

  /// Specifies the start radian of range arc
  late double startCornerRadian;

  /// Specifies the sweep radian of range arc
  late double sweepCornerRadian;

  /// Specifies the center value for range corner
  late double _cornerCenter;

  /// Specifies the angle for corner cap
  late double cornerAngle;

  /// Specifies the actual pointer offset value
  late double _actualPointerOffset;

  /// Specifies total offset for the range pointer
  late double totalOffset;

  /// Method to calculate pointer position
  @override
  void calculatePosition() {
    final RangePointer rangePointer = gaugePointer as RangePointer;
    currentValue = getMinMax(currentValue, axis.minimum, axis.maximum);
    actualRangeThickness = axisRenderer.getActualValue(
        rangePointer.width, rangePointer.sizeUnit, false);
    _actualPointerOffset = axisRenderer.getActualValue(
        rangePointer.pointerOffset, rangePointer.sizeUnit, true);
    totalOffset = _actualPointerOffset < 0
        ? axisRenderer.getAxisOffset() + _actualPointerOffset
        : (_actualPointerOffset + axisRenderer.axisOffset);
    final double minFactor = (axis.onCreateAxisRenderer != null &&
            axisRenderer.renderer != null &&
            axisRenderer.renderer!.valueToFactor(axis.minimum) != null)
        ? axisRenderer.renderer!.valueToFactor(axis.minimum) ??
            axisRenderer.valueToFactor(axis.minimum)
        : axisRenderer.valueToFactor(axis.minimum);
    startArc = (minFactor * axisRenderer.sweepAngle) + axis.startAngle;
    final double maxFactor = (axis.onCreateAxisRenderer != null &&
            axisRenderer.renderer != null &&
            axisRenderer.renderer!.valueToFactor(currentValue) != null)
        ? axisRenderer.renderer!.valueToFactor(currentValue) ??
            axisRenderer.valueToFactor(currentValue)
        : axisRenderer.valueToFactor(currentValue);
    final double rangeEndAngle =
        (maxFactor * axisRenderer.sweepAngle) + axis.startAngle;
    endArc = rangeEndAngle - startArc;

    _rangeArcLeft =
        -(axisRenderer.radius - (actualRangeThickness / 2 + totalOffset));
    _rangeArcTop =
        -(axisRenderer.radius - (actualRangeThickness / 2 + totalOffset));
    _rangeArcRight =
        axisRenderer.radius - (actualRangeThickness / 2 + totalOffset);
    _rangeArcBottom =
        axisRenderer.radius - (actualRangeThickness / 2 + totalOffset);

    _createRangeRect(rangePointer);
  }

  /// To creates the arc rect for range pointer
  void _createRangeRect(RangePointer rangePointer) {
    arcRect = Rect.fromLTRB(
        _rangeArcLeft, _rangeArcTop, _rangeArcRight, _rangeArcBottom);
    pointerRect = Rect.fromLTRB(
        _rangeArcLeft, _rangeArcTop, _rangeArcRight, _rangeArcBottom);
    arcPath = Path();
    arcPath.arcTo(
        arcRect, getDegreeToRadian(startArc), getDegreeToRadian(endArc), true);
    _calculateCornerStylePosition(rangePointer);
  }

  /// Calculates the rounded corner position
  void _calculateCornerStylePosition(RangePointer rangePointer) {
    _cornerCenter = (arcRect.right - arcRect.left) / 2;
    cornerAngle = cornerRadiusAngle(_cornerCenter, actualRangeThickness / 2);

    switch (rangePointer.cornerStyle) {
      case CornerStyle.startCurve:
        {
          startCornerRadian = axis.isInversed
              ? getDegreeToRadian(-cornerAngle)
              : getDegreeToRadian(cornerAngle);
          sweepCornerRadian = axis.isInversed
              ? getDegreeToRadian(endArc + cornerAngle)
              : getDegreeToRadian(endArc - cornerAngle);
        }
        break;
      case CornerStyle.endCurve:
        {
          startCornerRadian = getDegreeToRadian(0);
          sweepCornerRadian = axis.isInversed
              ? getDegreeToRadian(endArc + cornerAngle)
              : getDegreeToRadian(endArc - cornerAngle);
        }
        break;
      case CornerStyle.bothCurve:
        {
          startCornerRadian = axis.isInversed
              ? getDegreeToRadian(-cornerAngle)
              : getDegreeToRadian(cornerAngle);
          sweepCornerRadian = axis.isInversed
              ? getDegreeToRadian(endArc + 2 * cornerAngle)
              : getDegreeToRadian(endArc - 2 * cornerAngle);
        }
        break;
      case CornerStyle.bothFlat:
        {
          startCornerRadian = getDegreeToRadian(startArc);
          sweepCornerRadian = getDegreeToRadian(endArc);
        }
        break;
    }
  }

  /// Calculates the range sweep angle
  double getSweepAngle() {
    return getRadianToDegree(sweepCornerRadian) / axisRenderer.sweepAngle;
  }
}
