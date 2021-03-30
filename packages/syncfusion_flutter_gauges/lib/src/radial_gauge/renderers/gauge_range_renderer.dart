import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../axis/radial_axis.dart';
import '../common/radial_gauge_renderer.dart';
import '../range/gauge_range.dart';
import '../renderers/radial_axis_renderer_base.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';

/// This class has methods to render the gauge range
///
class GaugeRangeRenderer {
  /// Creates the instance for gauge range renderer
  GaugeRangeRenderer(GaugeRange gaugeRange) {
    range = gaugeRange;
    needsRepaintRange = true;
  }

  /// Holds the instance of corresponding gauge range
  late GaugeRange range;

  /// Holds the radial axis renderer
  late RadialAxisRendererBase axisRenderer;

  /// Specifies whether to repaint the range
  late bool needsRepaintRange;

  /// Specifies the range axis
  late RadialAxis axis;

  /// Specifies the start width
  late double actualStartWidth;

  /// Specifies the actual end width
  late double actualEndWidth;

  /// Specifies the outer start offset
  late double _outerStartOffset;

  /// Specifies the outer end offset
  late double _outerEndOffset;

  /// Specifies the inner start offset
  late double _innerStartOffset;

  /// Specifies the inner end offset
  late double _innerEndOffset;

  /// Specifies the outer arc
  late ArcData outerArc;

  /// Specifies the inner arc
  late ArcData innerArc;

  /// Specifies the outer arc sweep angle
  late double outerArcSweepAngle;

  /// Specifies the inner arc sweep angle
  late double innerArcSweepAngle;

  /// Specifies the thickness value
  late double thickness;

  /// Specifies the range rect
  Rect? rangeRect;

  /// Specifies the range start radian
  late double rangeStartRadian;

  /// Specifies the range end radian
  late double rangeEndRadian;

  /// Specifies the range mid radian
  late double _rangeMidRadian;

  /// Specifies the center value
  late Offset center;

  /// Specifies the maximum angle
  late double _maxAngle;

  /// Specifies the range start value
  late double _rangeStartValue;

  /// Specifies the range ed value
  late double _rangeEndValue;

  /// Specifies the range mid value
  late double _rangeMidValue;

  /// Specifies the label angle
  late double labelAngle;

  /// Holds the label position
  late Offset labelPosition;

  /// Holds the label size
  late Size labelSize;

  /// Holds the actual start value
  late double actualStartValue;

  /// Holds the actual end value
  late double actualEndValue;

  /// Holds the total offset
  late double _totalOffset;

  /// Specifies the actual range offset
  late double _actualRangeOffset;

  /// Specifies the path rect
  late Rect pathRect;

  /// Calculates the range position
  void calculateRangePosition() {
    _calculateActualWidth();
    _actualRangeOffset =
        axisRenderer.getActualValue(range.rangeOffset, range.sizeUnit, true);
    center = !axis.canScaleToFit
        ? Offset(
            axisRenderer.axisSize.width / 2, axisRenderer.axisSize.height / 2)
        : axisRenderer.axisCenter;
    _totalOffset = _actualRangeOffset < 0
        ? axisRenderer.getAxisOffset() + _actualRangeOffset
        : (_actualRangeOffset + axisRenderer.axisOffset);
    _maxAngle = axisRenderer.sweepAngle;
    actualStartValue = getMinMax(range.startValue, axis.minimum, axis.maximum);
    actualEndValue = getMinMax(range.endValue, axis.minimum, axis.maximum);
    _calculateRangeAngle();
    if (actualStartWidth != actualEndWidth) {
      _calculateInEqualWidthArc();
    } else {
      _calculateEqualWidthArc();
    }

    if (range.label != null) {
      labelSize = getTextSize(range.label!, range.labelStyle);
      _calculateLabelPosition();
    }
  }

  /// Method to calculate rect for in equal width range
  void _calculateInEqualWidthArc() {
    _outerEndOffset = 0;
    _outerStartOffset = _outerEndOffset;
    _innerStartOffset = actualStartWidth;
    _innerEndOffset = actualEndWidth;

    outerArc = _getRadiusToAngleConversion(_outerStartOffset, _outerEndOffset);
    innerArc = _getRadiusToAngleConversion(_innerStartOffset, _innerEndOffset);

    outerArcSweepAngle =
        _getSweepAngle(outerArc.endAngle - outerArc.startAngle);
    innerArcSweepAngle =
        _getSweepAngle(innerArc.endAngle - innerArc.startAngle);
    innerArcSweepAngle *= -1;

    final double left = outerArc.arcRect.left < innerArc.arcRect.left
        ? outerArc.arcRect.left
        : innerArc.arcRect.left;
    final double top = outerArc.arcRect.top < innerArc.arcRect.top
        ? outerArc.arcRect.top
        : innerArc.arcRect.top;
    final double right = outerArc.arcRect.right < innerArc.arcRect.right
        ? innerArc.arcRect.right
        : outerArc.arcRect.right;
    final double bottom = outerArc.arcRect.bottom < innerArc.arcRect.bottom
        ? innerArc.arcRect.bottom
        : outerArc.arcRect.bottom;
    pathRect = Rect.fromLTRB(left, top, right, bottom);
  }

  /// Calculates the range angle
  void _calculateRangeAngle() {
    if (!axis.isInversed) {
      _rangeStartValue = axis.startAngle +
          (_maxAngle /
              ((axis.maximum - axis.minimum) /
                  (actualStartValue - axis.minimum)));
      _rangeEndValue = axis.startAngle +
          (_maxAngle /
              ((axis.maximum - axis.minimum) /
                  (actualEndValue - axis.minimum)));
      _rangeMidValue = axis.startAngle +
          (_maxAngle /
              ((axis.maximum - axis.minimum) /
                  ((actualEndValue - actualStartValue) / 2 +
                      actualStartValue)));
    } else {
      _rangeStartValue = axis.startAngle +
          _maxAngle -
          (_maxAngle /
              ((axis.maximum - axis.minimum) /
                  (actualStartValue - axis.minimum)));
      _rangeEndValue = axis.startAngle +
          _maxAngle -
          (_maxAngle /
              ((axis.maximum - axis.minimum) /
                  (actualEndValue - axis.minimum)));
      _rangeMidValue = axis.startAngle +
          _maxAngle -
          (_maxAngle /
              ((axis.maximum - axis.minimum) /
                  ((actualEndValue - actualStartValue) / 2 +
                      actualStartValue)));
    }

    rangeStartRadian = getDegreeToRadian(_rangeStartValue);
    rangeEndRadian = getDegreeToRadian(_rangeEndValue);
    _rangeMidRadian = getDegreeToRadian(_rangeMidValue);
  }

  /// Method to calculate the rect for range with equal start and end width
  void _calculateEqualWidthArc() {
    thickness = actualStartWidth;
    final double startFactor = (axis.onCreateAxisRenderer != null &&
            axisRenderer.renderer != null &&
            axisRenderer.renderer!.valueToFactor(actualStartValue) != null)
        ? axisRenderer.renderer!.valueToFactor(actualStartValue) ??
            axisRenderer.valueToFactor(actualStartValue)
        : axisRenderer.valueToFactor(actualStartValue);
    rangeStartRadian = getDegreeToRadian(
        (startFactor * axisRenderer.sweepAngle) + axis.startAngle);
    final double endFactor = (axis.onCreateAxisRenderer != null &&
            axisRenderer.renderer != null &&
            axisRenderer.renderer!.valueToFactor(actualEndValue) != null)
        ? axisRenderer.renderer!.valueToFactor(actualEndValue) ??
            axisRenderer.valueToFactor(actualEndValue)
        : axisRenderer.valueToFactor(actualEndValue);
    final double endRadian = getDegreeToRadian(
        (endFactor * axisRenderer.sweepAngle) + axis.startAngle);
    rangeEndRadian = endRadian - rangeStartRadian;

    rangeRect = Rect.fromLTRB(
        -(axisRenderer.radius - (actualStartWidth / 2 + _totalOffset)),
        -(axisRenderer.radius - (actualStartWidth / 2 + _totalOffset)),
        axisRenderer.radius - (actualStartWidth / 2 + _totalOffset),
        axisRenderer.radius - (actualStartWidth / 2 + _totalOffset));
  }

  /// Method to calculate the sweep angle
  double _getSweepAngle(double sweepAngle) {
    if (sweepAngle < 0 && !axis.isInversed) {
      sweepAngle += 360;
    }

    if (sweepAngle > 0 && axis.isInversed) {
      sweepAngle -= 360;
    }
    return sweepAngle;
  }

  /// Converts radius to angle
  ArcData _getRadiusToAngleConversion(double startOffset, double endOffset) {
    final double startRadius = axisRenderer.radius - startOffset;
    final double endRadius = axisRenderer.radius - endOffset;
    final double midRadius =
        axisRenderer.radius - (startOffset + endOffset) / 2;

    final double startX = startRadius * math.cos(getDegreeToRadian(0));
    final double startY = startRadius * math.sin(getDegreeToRadian(0));
    final Offset rangeStartOffset = Offset(startX, startY);

    final double endX = endRadius * math.cos(rangeEndRadian - rangeStartRadian);
    final double endY = endRadius * math.sin(rangeEndRadian - rangeStartRadian);
    final Offset rangeEndOffset = Offset(endX, endY);

    final double midX =
        midRadius * math.cos(_rangeMidRadian - rangeStartRadian);
    final double midY =
        midRadius * math.sin(_rangeMidRadian - rangeStartRadian);
    final Offset rangeMidOffset = Offset(midX, midY);
    return _getArcData(rangeStartOffset, rangeEndOffset, rangeMidOffset);
  }

  /// Method to create the arc data
  ArcData _getArcData(
      Offset rangeStartOffset, Offset rangeEndOffset, Offset rangeMidOffset) {
    final Offset controlPoint =
        _getPointConversion(rangeStartOffset, rangeEndOffset, rangeMidOffset);

    final double distance = math.sqrt(
        math.pow(rangeStartOffset.dx - controlPoint.dx, 2) +
            math.pow(rangeStartOffset.dy - controlPoint.dy, 2));

    double actualStartAngle = getRadianToDegree(math.atan2(
      rangeStartOffset.dy - controlPoint.dy,
      rangeStartOffset.dx - controlPoint.dx,
    ));
    double actualEndAngle = getRadianToDegree(math.atan2(
      rangeEndOffset.dy - controlPoint.dy,
      rangeEndOffset.dx - controlPoint.dx,
    ));

    if (actualStartAngle < 0) {
      actualStartAngle += 360;
    }

    if (actualEndAngle < 0) {
      actualEndAngle += 360;
    }

    if (actualStartValue > actualEndValue) {
      final double temp = actualEndAngle;
      actualEndAngle = actualStartAngle;
      actualStartAngle = temp;
    }

    final ArcData arcData = ArcData();
    arcData.startAngle = actualStartAngle;
    arcData.endAngle = actualEndAngle;
    arcData.arcRect = Rect.fromLTRB(
        controlPoint.dx - distance + _totalOffset,
        controlPoint.dy - distance + _totalOffset,
        controlPoint.dx + distance - _totalOffset,
        controlPoint.dy + distance - _totalOffset);
    return arcData;
  }

  /// calculates the control point for range arc
  Offset _getPointConversion(Offset offset1, Offset offset2, Offset offset3) {
    double distance1 = (offset1.dy - offset2.dy) / (offset1.dx - offset2.dx);
    distance1 = (offset1.dy - offset2.dy) == 0 || (offset1.dx - offset2.dx) == 0
        ? 0
        : distance1;
    double distance2 = (offset3.dy - offset2.dy) / (offset3.dx - offset2.dx);
    distance2 = (offset3.dy - offset2.dy) == 0 || (offset3.dx - offset2.dx) == 0
        ? 0
        : distance2;
    double x = (distance1 * distance2 * (offset3.dy - offset1.dy) +
            distance1 * (offset2.dx + offset3.dx) -
            distance2 * (offset1.dx + offset2.dx)) /
        (2 * (distance1 - distance2));
    final double diff = (1 / distance1).isInfinite ? 0 : (1 / distance1);
    double y = -diff * (x - ((offset1.dx + offset2.dx) / 2)) +
        ((offset1.dy + offset2.dy) / 2);
    x = x.isNaN ? 0 : x;
    y = y.isNaN ? 0 : y;
    return Offset(x, y);
  }

  /// Calculates the actual range width
  void _calculateActualWidth() {
    actualStartWidth = _getRangeValue(range.startWidth);
    actualEndWidth = _getRangeValue(range.endWidth);
  }

  /// Calculates the actual value
  double _getRangeValue(double? value) {
    double actualValue = 0;
    if (value != null) {
      switch (range.sizeUnit) {
        case GaugeSizeUnit.factor:
          {
            actualValue = value * axisRenderer.radius;
          }
          break;
        case GaugeSizeUnit.logicalPixel:
          {
            actualValue = value;
          }
      }
    } else if (range.label != null) {
      final Size size = getTextSize(range.label!, range.labelStyle);
      actualValue = size.height;
    }

    return actualValue;
  }

  /// Calculates the label position
  void _calculateLabelPosition() {
    final double midValueFactor = (axis.onCreateAxisRenderer != null &&
            axisRenderer.renderer != null &&
            axisRenderer.renderer!
                    .valueToFactor((actualEndValue + actualStartValue) / 2) !=
                null)
        ? axisRenderer.renderer!
                .valueToFactor((actualEndValue + actualStartValue) / 2) ??
            axisRenderer.valueToFactor((actualEndValue + actualStartValue) / 2)
        : axisRenderer.valueToFactor((actualEndValue + actualStartValue) / 2);
    final double midAngle =
        (midValueFactor * axisRenderer.sweepAngle) + axis.startAngle;
    final double labelRadian = getDegreeToRadian(midAngle);
    labelAngle = midAngle - 90;
    final double height = actualStartWidth != actualEndWidth
        ? (actualEndWidth - actualStartWidth).abs() / 2
        : actualEndWidth / 2;
    if (!axis.canScaleToFit) {
      final double x = axisRenderer.axisSize.width / 2 +
          ((axisRenderer.radius - (_totalOffset + height)) *
              math.cos(labelRadian)) -
          axisRenderer.centerX;
      final double y = axisRenderer.axisSize.height / 2 +
          ((axisRenderer.radius - (_totalOffset + height)) *
              math.sin(labelRadian)) -
          axisRenderer.centerY;
      labelPosition = Offset(x, y);
    } else {
      final double x = axisRenderer.axisCenter.dx +
          ((axisRenderer.radius - (_totalOffset + height)) *
              math.cos(labelRadian));
      final double y = axisRenderer.axisCenter.dy +
          ((axisRenderer.radius - (_totalOffset + height)) *
              math.sin(labelRadian));
      labelPosition = Offset(x, y);
    }
  }
}
