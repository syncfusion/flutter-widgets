import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../axis/radial_axis.dart';
import '../common/axis_label.dart';
import '../common/common.dart';
import '../common/radial_gauge_renderer.dart';
import '../renderers/gauge_pointer_renderer.dart';
import '../renderers/gauge_range_renderer.dart';
import '../renderers/radial_axis_renderer.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';

/// Represents the renderer for radial axis
class RadialAxisRendererBase {
  /// Creates the instance for radial axis renderer
  RadialAxisRendererBase() {
    needsRepaintAxis = true;
  }

  /// Specifies the radial axis renderer
  RadialAxisRenderer? renderer;

  /// Specifies whether to include axis elements when calculating the radius
  final bool _useAxisElementsInsideRadius = true;

  /// Specifies the axis corresponding to this renderer;
  late RadialAxis axis;

  ///Specifies the axis rect
  late Rect axisRect;

  /// Specifies the start radian value
  late double startRadian;

  /// Specifies the end radian value
  late double endRadian;

  ///Specifies the radius value
  late double radius;

  ///Specifies the axis center
  late double _center;

  ///Specifies the center X value of axis
  late double centerX;

  ///Specifies the center  Y value od axis
  late double centerY;

  /// Specifies the actual axis width
  late double actualAxisWidth;

  /// Specifies the list of axis labels
  List<CircularAxisLabel>? axisLabels;

  /// Specifies the offset value of major ticks
  late List<TickOffset> majorTickOffsets;

  /// Specifies the offset value of minor ticks
  late List<TickOffset> minorTickOffsets;

  /// Specifies the major tick count
  late num _majorTicksCount;

  ///Holds the sweep angle of the axis
  late double sweepAngle;

  /// Holds the size of the axis
  late Size axisSize;

  /// Holds the length of major tick based on coordinate unit
  late double actualMajorTickLength;

  /// Holds the length of minor tick based on coordinate unit
  late double actualMinorTickLength;

  /// Specifies the maximum label size
  late Size _maximumLabelSize;

  /// Specifies whether the ticks are placed outside
  late bool _isTicksOutside;

  /// Specifies whether the labels are placed outside
  late bool _isLabelsOutside;

  /// Specifies the maximum length of tick by comparing major and minor tick
  late double _maximumTickLength;

  /// Specifies whether to repaint the axis;
  late bool needsRepaintAxis;

  /// Specifies the axis path
  late Path axisPath;

  /// Specifies the axis offset
  late double axisOffset;

  /// Specifies the start corner radian
  late double startCornerRadian;

  /// Specifies the sweep corner radian
  late double sweepCornerRadian;

  /// Specifies the actual label offset
  late double _actualLabelOffset;

  /// Specifies the actual tick offset
  late double _actualTickOffset;

  /// Specifies the corner angle
  late double cornerAngle;

  /// Specifies the listener
  ImageStreamListener? listener;

  /// Specifies the background image info;
  ImageInfo? backgroundImageInfo;

  /// Specifies the image stream
  ImageStream? imageStream;

  /// Specifies the difference in the radius
  late double _diffInRadius;

  /// Specifies the center point of the axis
  late Offset axisCenter;

  /// Specifies the rendering details corresponding to the gauge.
  late RenderingDetails renderingDetails;

  /// Specifies the actual interval of the axis
  num? _actualInterval;

  /// Specifies whether the maximum value is included in axis labels
  late bool isMaxiumValueIncluded = false;

  /// To calculate the radius and the center point based on the angle
  Offset _getAxisBounds() {
    final Offset centerOffset = _getCenter();
    final double minScale = math.min(axisSize.height, axisSize.width);
    final double x = ((centerOffset.dx * 2) - minScale) / 2;
    final double y = ((centerOffset.dy * 2) - minScale) / 2;
    Rect bounds = Rect.fromLTRB(x, y, minScale, minScale);
    final double centerYDiff = (axisSize.height / 2 - centerOffset.dy).abs();
    final double centerXDiff = (axisSize.width / 2 - centerOffset.dx).abs();
    double diff = 0;
    if (axisSize.width > axisSize.height) {
      diff = centerYDiff / 2;
      final double angleRadius = axisSize.height / 2 + diff;
      if (axisSize.width / 2 < angleRadius) {
        final double actualDiff = axisSize.width / 2 - axisSize.height / 2;
        diff = actualDiff * 0.7;
      }

      bounds = Rect.fromLTRB(
          x - diff / 2, y, x + minScale + (diff / 2), y + minScale + diff);
    } else {
      diff = centerXDiff / 2;
      final double angleRadius = axisSize.width / 2 + diff;

      if (axisSize.height / 2 < angleRadius) {
        final double actualDiff = axisSize.height / 2 - axisSize.width / 2;
        diff = actualDiff * 0.7;
      }

      bounds = Rect.fromLTRB(x - diff / 2, y - diff / 2,
          x + minScale + (diff / 2), y + minScale + (diff / 2));
    }

    _diffInRadius = diff;

    return Offset(
        bounds.left + (bounds.width / 2), bounds.top + (bounds.height / 2));
  }

  /// Calculates the default values of the axis
  void _calculateDefaultValues() {
    startRadian = getDegreeToRadian(axis.startAngle);
    sweepAngle = _getSweepAngle();
    endRadian = getDegreeToRadian(sweepAngle);
    _center = math.min(axisSize.width / 2, axisSize.height / 2);

    if (!axis.canScaleToFit) {
      radius = _center * axis.radiusFactor;
      centerX = (axisSize.width / 2) - (axis.centerX * axisSize.width);
      centerY = (axisSize.height / 2) - (axis.centerY * axisSize.height);
      axisCenter =
          Offset(axisSize.width / 2 - centerX, axisSize.height / 2 - centerY);
    } else {
      final Offset centerPoint = _getAxisBounds();
      centerX = centerPoint.dx;
      centerY = centerPoint.dy;
      radius = (_center + _diffInRadius) * axis.radiusFactor;
      axisCenter = Offset(centerX, centerY);
    }

    actualAxisWidth = getActualValue(
        axis.axisLineStyle.thickness, axis.axisLineStyle.thicknessUnit, false);
    actualMajorTickLength = _getTickLength(true);
    actualMinorTickLength = _getTickLength(false);
    _maximumTickLength = actualMajorTickLength > actualMinorTickLength
        ? actualMajorTickLength
        : actualMinorTickLength;
    _actualLabelOffset =
        getActualValue(axis.labelOffset, axis.offsetUnit, true);
    _actualTickOffset = getActualValue(axis.tickOffset, axis.offsetUnit, true);
    if (axis.backgroundImage != null) {
      listener = ImageStreamListener(_updateBackgroundImage);
    }
  }

  /// Method to calculate the axis range
  void calculateAxisRange(BoxConstraints constraints, BuildContext context,
      SfGaugeThemeData gaugeThemeData, RenderingDetails animationDetails) {
    renderingDetails = animationDetails;
    axisSize = Size(constraints.maxWidth, constraints.maxHeight);
    _calculateAxisElementsPosition(context);
    if (axis.pointers != null && axis.pointers!.isNotEmpty) {
      _renderPointers();
    }

    if (axis.ranges != null && axis.ranges!.isNotEmpty) {
      _renderRanges();
    }
  }

  /// Methods to calculate axis elements position
  void _calculateAxisElementsPosition(BuildContext context) {
    _isTicksOutside = axis.ticksPosition == ElementsPosition.outside;
    _isLabelsOutside = axis.labelsPosition == ElementsPosition.outside;
    _calculateDefaultValues();
    axisLabels = (axis.onCreateAxisRenderer != null &&
            renderer != null &&
            renderer!.generateVisibleLabels() != null)
        ? renderer!.generateVisibleLabels() ?? generateVisibleLabels()
        : generateVisibleLabels();
    if (axis.showLabels) {
      _measureAxisLabels();
    }

    axisOffset = _useAxisElementsInsideRadius ? getAxisOffset() : 0;

    if (axis.showTicks) {
      _calculateMajorTicksPosition();
      _calculateMinorTickPosition();
    }

    if (axis.showLabels) {
      _calculateAxisLabelsPosition();
    }

    _calculateAxisRect();
    if (axis.showAxisLine) {
      _calculateCornerStylePosition();
    }

    if (axis.backgroundImage != null && backgroundImageInfo?.image == null) {
      _loadBackgroundImage(context);
    }
  }

  /// To calculate the center based on the angle
  Offset _getCenter() {
    final double x = axisSize.width / 2;
    final double y = axisSize.height / 2;
    radius = _center;
    Offset actualCenter = Offset(x, y);
    final double actualStartAngle = _getWrapAngle(axis.startAngle, -630, 630);
    final double actualEndAngle =
        _getWrapAngle(axis.startAngle + sweepAngle.abs(), -630, 630);
    final List<double> regions = <double>[
      -630,
      -540,
      -450,
      -360,
      -270,
      -180,
      -90,
      0,
      90,
      180,
      270,
      360,
      450,
      540,
      630
    ];
    final List<int> region = <int>[];
    if (actualStartAngle < actualEndAngle) {
      for (int i = 0; i < regions.length; i++) {
        if (regions[i] > actualStartAngle && regions[i] < actualEndAngle) {
          region.add(((regions[i] % 360) < 0
                  ? (regions[i] % 360) + 360
                  : (regions[i] % 360))
              .toInt());
        }
      }
    } else {
      for (int i = 0; i < regions.length; i++) {
        if (regions[i] < actualStartAngle && regions[i] > actualEndAngle) {
          region.add(((regions[i] % 360) < 0
                  ? (regions[i] % 360) + 360
                  : (regions[i] % 360))
              .toInt());
        }
      }
    }

    final double startRadian = 2 * math.pi * (actualStartAngle / 360);
    final double endRadian = 2 * math.pi * (actualEndAngle / 360);
    final Offset startPoint = Offset(x + (radius * math.cos(startRadian)),
        y + (radius * math.sin(startRadian)));
    final Offset endPoint = Offset(
        x + (radius * math.cos(endRadian)), y + (radius * math.sin(endRadian)));

    switch (region.length) {
      case 0:
        actualCenter =
            _getCenterForLengthZero(startPoint, endPoint, x, y, radius, region);
        break;
      case 1:
        actualCenter =
            _getCenterLengthOne(startPoint, endPoint, x, y, radius, region);
        break;
      case 2:
        actualCenter =
            _getCenterForLengthTwo(startPoint, endPoint, x, y, radius, region);
        break;
      case 3:
        actualCenter = _getCenterForLengthThree(
            startPoint, endPoint, x, y, radius, region);
        break;
    }

    return actualCenter;
  }

  /// Calculate the center point when the region length is zero
  Offset _getCenterForLengthZero(Offset startPoint, Offset endPoint, double x,
      double y, double radius, List<int> region) {
    final double longX = (x - startPoint.dx).abs() > (x - endPoint.dx).abs()
        ? startPoint.dx
        : endPoint.dx;
    final double longY = (y - startPoint.dy).abs() > (y - endPoint.dy).abs()
        ? startPoint.dy
        : endPoint.dy;
    final Offset midPoint =
        Offset((x + longX).abs() / 2, (y + longY).abs() / 2);
    final double xValue = x + (x - midPoint.dx);
    final double yValue = y + (y - midPoint.dy);
    return Offset(xValue, yValue);
  }

  ///Calculates the center when the region length is two.
  Offset _getCenterLengthOne(Offset startPoint, Offset endPoint, double x,
      double y, double radius, List<int> region) {
    Offset point1 = Offset(0, 0);
    Offset point2 = Offset(0, 0);
    final double maxRadian = 2 * math.pi * region[0] / 360;
    final Offset maxPoint = Offset(
        x + (radius * math.cos(maxRadian)), y + (radius * math.sin(maxRadian)));

    switch (region[0]) {
      case 270:
        point1 = Offset(startPoint.dx, maxPoint.dy);
        point2 = Offset(endPoint.dx, y);
        break;
      case 0:
      case 360:
        point1 = Offset(x, endPoint.dy);
        point2 = Offset(maxPoint.dx, startPoint.dy);
        break;
      case 90:
        point1 = Offset(endPoint.dx, y);
        point2 = Offset(startPoint.dx, maxPoint.dy);
        break;
      case 180:
        point1 = Offset(maxPoint.dx, startPoint.dy);
        point2 = Offset(x, endPoint.dy);
        break;
    }

    final Offset midPoint =
        Offset((point1.dx + point2.dx) / 2, (point1.dy + point2.dy) / 2);
    final double xValue =
        x + ((x - midPoint.dx) >= radius ? 0 : (x - midPoint.dx));
    final double yValue =
        y + ((y - midPoint.dy) >= radius ? 0 : (y - midPoint.dy));
    return Offset(xValue, yValue);
  }

  ///Calculates the center when the region length is two.
  Offset _getCenterForLengthTwo(Offset startPoint, Offset endPoint, double x,
      double y, double radius, List<int> region) {
    Offset point1;
    Offset point2;
    final double minRadian = 2 * math.pi * region[0] / 360;
    final double maxRadian = 2 * math.pi * region[1] / 360;
    final Offset maxPoint = Offset(
        x + (radius * math.cos(maxRadian)), y + (radius * math.sin(maxRadian)));
    final Offset minPoint = Offset(
        x + (radius * math.cos(minRadian)), y + (radius * math.sin(minRadian)));

    if ((region[0] == 0 && region[1] == 90) ||
        (region[0] == 180 && region[1] == 270)) {
      point1 = Offset(minPoint.dx, maxPoint.dy);
    } else {
      point1 = Offset(maxPoint.dx, minPoint.dy);
    }

    if (region[0] == 0 || region[0] == 180) {
      point2 = Offset(_getMinMaxValue(startPoint, endPoint, region[0]),
          _getMinMaxValue(startPoint, endPoint, region[1]));
    } else {
      point2 = Offset(_getMinMaxValue(startPoint, endPoint, region[1]),
          _getMinMaxValue(startPoint, endPoint, region[0]));
    }

    final Offset midPoint = Offset(
        (point1.dx - point2.dx).abs() / 2 >= radius
            ? 0
            : (point1.dx + point2.dx) / 2,
        (point1.dy - point2.dy).abs() / 2 >= radius
            ? 0
            : (point1.dy + point2.dy) / 2);
    final double xValue = x +
        (midPoint.dx == 0
            ? 0
            : (x - midPoint.dx) >= radius
                ? 0
                : (x - midPoint.dx));
    final double yValue = y +
        (midPoint.dy == 0
            ? 0
            : (y - midPoint.dy) >= radius
                ? 0
                : (y - midPoint.dy));
    return Offset(xValue, yValue);
  }

  ///Calculates the center when the region length is three.
  Offset _getCenterForLengthThree(Offset startPoint, Offset endPoint, double x,
      double y, double radius, List<int> region) {
    final double region0Radian = 2 * math.pi * region[0] / 360;
    final double region1Radian = 2 * math.pi * region[1] / 360;
    final double region2Radian = 2 * math.pi * region[2] / 360;
    final Offset region0Point = Offset(x + (radius * math.cos(region0Radian)),
        y + (radius * math.sin(region0Radian)));
    final Offset region1Point = Offset(x + (radius * math.cos(region1Radian)),
        y + (radius * math.sin(region1Radian)));
    final Offset region2Point = Offset(x + (radius * math.cos(region2Radian)),
        y + (radius * math.sin(region2Radian)));
    Offset regionStartPoint = Offset(0, 0);
    Offset regionEndPoint = Offset(0, 0);
    switch (region[2]) {
      case 0:
      case 360:
        regionStartPoint = Offset(region0Point.dx, region1Point.dy);
        regionEndPoint =
            Offset(region2Point.dx, math.max(startPoint.dy, endPoint.dy));
        break;
      case 90:
        regionStartPoint =
            Offset(math.min(startPoint.dx, endPoint.dx), region0Point.dy);
        regionEndPoint = Offset(region1Point.dx, region2Point.dy);
        break;
      case 180:
        regionStartPoint =
            Offset(region2Point.dx, math.min(startPoint.dy, endPoint.dy));
        regionEndPoint = Offset(region0Point.dx, region1Point.dy);
        break;
      case 270:
        regionStartPoint = Offset(region1Point.dx, region2Point.dy);
        regionEndPoint =
            Offset(math.max(startPoint.dx, endPoint.dx), region0Point.dy);
        break;
    }

    final Offset midRegionPoint = Offset(
        (regionStartPoint.dx - regionEndPoint.dx).abs() / 2 >= radius
            ? 0
            : (regionStartPoint.dx + regionEndPoint.dx) / 2,
        (regionStartPoint.dy - regionEndPoint.dy).abs() / 2 >= radius
            ? 0
            : (regionStartPoint.dy + regionEndPoint.dy) / 2);
    final double xValue = x +
        (midRegionPoint.dx == 0
            ? 0
            : (x - midRegionPoint.dx) >= radius
                ? 0
                : (x - midRegionPoint.dx));
    final double yValue = y +
        (midRegionPoint.dy == 0
            ? 0
            : (y - midRegionPoint.dy) >= radius
                ? 0
                : (y - midRegionPoint.dy));
    return Offset(xValue, yValue);
  }

  /// To calculate the value based on the angle
  double _getMinMaxValue(Offset startPoint, Offset endPoint, int degree) {
    final double minX = math.min(startPoint.dx, endPoint.dx);
    final double minY = math.min(startPoint.dy, endPoint.dy);
    final double maxX = math.max(startPoint.dx, endPoint.dx);
    final double maxY = math.max(startPoint.dy, endPoint.dy);
    switch (degree) {
      case 270:
        return maxY;
      case 0:
      case 360:
        return minX;
      case 90:
        return minY;
      case 180:
        return maxX;
    }

    return 0;
  }

  /// To calculate the wrap angle
  double _getWrapAngle(double angle, double min, double max) {
    if (max - min == 0) {
      return min;
    }

    angle = ((angle - min) % (max - min)) + min;
    while (angle < min) {
      angle += max - min;
    }

    return angle;
  }

  /// Calculates the rounded corner position
  void _calculateCornerStylePosition() {
    final double cornerCenter = (axisRect.right - axisRect.left) / 2;
    cornerAngle = cornerRadiusAngle(cornerCenter, actualAxisWidth / 2);

    switch (axis.axisLineStyle.cornerStyle) {
      case CornerStyle.startCurve:
        {
          startCornerRadian = axis.isInversed
              ? getDegreeToRadian(-cornerAngle)
              : getDegreeToRadian(cornerAngle);
          sweepCornerRadian = axis.isInversed
              ? getDegreeToRadian((-sweepAngle) + cornerAngle)
              : getDegreeToRadian(sweepAngle - cornerAngle);
        }
        break;
      case CornerStyle.endCurve:
        {
          startCornerRadian = getDegreeToRadian(0);
          sweepCornerRadian = axis.isInversed
              ? getDegreeToRadian((-sweepAngle) + cornerAngle)
              : getDegreeToRadian(sweepAngle - cornerAngle);
        }
        break;
      case CornerStyle.bothCurve:
        {
          startCornerRadian = axis.isInversed
              ? getDegreeToRadian(-cornerAngle)
              : getDegreeToRadian(cornerAngle);
          sweepCornerRadian = axis.isInversed
              ? getDegreeToRadian((-sweepAngle) + (2 * cornerAngle))
              : getDegreeToRadian(sweepAngle - (2 * cornerAngle));
        }
        break;
      case CornerStyle.bothFlat:
        startCornerRadian = !axis.isInversed
            ? getDegreeToRadian(0)
            : getDegreeToRadian(axis.startAngle + sweepAngle);
        final double _value = axis.isInversed ? -1 : 1;
        sweepCornerRadian = getDegreeToRadian(sweepAngle * _value);
        break;
    }
  }

  /// Calculates the axis rect
  void _calculateAxisRect() {
    axisRect = Rect.fromLTRB(
        -(radius - (actualAxisWidth / 2 + axisOffset)),
        -(radius - (actualAxisWidth / 2 + axisOffset)),
        radius - (actualAxisWidth / 2 + axisOffset),
        radius - (actualAxisWidth / 2 + axisOffset));
    axisPath = Path();
    final Rect rect = Rect.fromLTRB(
      axisRect.left + axisSize.width / 2,
      axisRect.top + axisSize.height / 2,
      axisRect.right + axisSize.width / 2,
      axisRect.bottom + axisSize.height / 2,
    );
    axisPath.arcTo(rect, startRadian, endRadian, false);
  }

  /// Method to calculate the angle from the tapped point
  void calculateAngleFromOffset(Offset offset) {
    final double actualCenterX = axisSize.width * axis.centerX;
    final double actualCenterY = axisSize.height * axis.centerY;
    double angle =
        math.atan2(offset.dy - actualCenterY, offset.dx - actualCenterX) *
                (180 / math.pi) +
            360;
    final double actualEndAngle = axis.startAngle + sweepAngle;
    if (angle < 360 && angle > 180) {
      angle += 360;
    }

    if (angle > actualEndAngle) {
      angle %= 360;
    }

    if (angle >= axis.startAngle && angle <= actualEndAngle) {
      final double angleFactor = (angle - axis.startAngle) / sweepAngle;
      final double value = (axis.onCreateAxisRenderer != null &&
              renderer != null &&
              renderer!.factorToValue(angleFactor) != null)
          ? renderer!.factorToValue(angleFactor) ?? factorToValue(angleFactor)
          : factorToValue(angleFactor);
      if (value >= axis.minimum && value <= axis.maximum) {
        final double _tappedValue = _angleToValue(angle);
        axis.onAxisTapped!(_tappedValue);
      }
    }
  }

  /// Calculate the offset for axis line based on ticks and labels
  double getAxisOffset() {
    double offset = 0;
    offset = _isTicksOutside
        ? axis.showTicks
            ? (_maximumTickLength + _actualTickOffset)
            : 0
        : 0;
    offset += _isLabelsOutside
        ? axis.showLabels
            ? (math.max(_maximumLabelSize.height, _maximumLabelSize.width) / 2 +
                _actualLabelOffset)
            : 0
        : 0;
    return offset;
  }

  /// Converts the axis value to angle
  double _valueToAngle(double value) {
    double angle = 0;
    value = getMinMax(value, axis.minimum, axis.maximum);
    if (!axis.isInversed) {
      angle = (sweepAngle / (axis.maximum - axis.minimum).abs()) *
          (axis.minimum - value).abs();
    } else {
      angle = sweepAngle -
          ((sweepAngle / (axis.maximum - axis.minimum).abs()) *
              (axis.minimum - value).abs());
    }

    return angle;
  }

  /// Converts the angle to corresponding axis value
  double _angleToValue(double angle) {
    double value = 0;
    if (!axis.isInversed) {
      value = (((angle - axis.startAngle) / sweepAngle) *
              (axis.maximum - axis.minimum)) +
          axis.minimum;
    } else {
      value = (axis.maximum -
          (((angle - axis.startAngle) / sweepAngle) *
              (axis.maximum - axis.minimum)));
    }

    return value;
  }

  /// Calculates the major ticks position
  void _calculateMajorTicksPosition() {
    if (axisLabels != null && axisLabels!.isNotEmpty) {
      double angularSpaceForTicks;
      if (_actualInterval != null) {
        _majorTicksCount = (axis.maximum - axis.minimum) / _actualInterval!;
        angularSpaceForTicks =
            getDegreeToRadian(sweepAngle / (_majorTicksCount));
      } else {
        _majorTicksCount = axisLabels!.length;
        angularSpaceForTicks =
            getDegreeToRadian(sweepAngle / (_majorTicksCount - 1));
      }

      final double axisLineWidth = axis.showAxisLine ? actualAxisWidth : 0;
      double angleForTicks = 0;
      double tickStartOffset = 0;
      double tickEndOffset = 0;
      majorTickOffsets = <TickOffset>[];
      angleForTicks = axis.isInversed
          ? getDegreeToRadian(axis.startAngle + sweepAngle - 90)
          : getDegreeToRadian(axis.startAngle - 90);
      final double offset = _isLabelsOutside
          ? axis.showLabels
              ? (math.max(_maximumLabelSize.height, _maximumLabelSize.width) /
                      2 +
                  _actualLabelOffset)
              : 0
          : 0;
      if (!_isTicksOutside) {
        tickStartOffset = radius - (axisLineWidth + _actualTickOffset + offset);
        tickEndOffset = radius -
            (axisLineWidth +
                actualMajorTickLength +
                _actualTickOffset +
                offset);
      } else {
        final bool isGreater = actualMajorTickLength > actualMinorTickLength;

        // Calculates the major tick position based on the tick length
        // and another features offset value
        if (!_useAxisElementsInsideRadius) {
          tickStartOffset = radius + _actualTickOffset;
          tickEndOffset = radius + actualMajorTickLength + _actualTickOffset;
        } else {
          tickStartOffset = isGreater
              ? radius - offset
              : radius - (_maximumTickLength - actualMajorTickLength + offset);
          tickEndOffset = radius - (offset + _maximumTickLength);
        }
      }

      _calculateOffsetForMajorTicks(
          tickStartOffset, tickEndOffset, angularSpaceForTicks, angleForTicks);
    }
  }

  /// Calculates the offset for major ticks
  void _calculateOffsetForMajorTicks(double tickStartOffset,
      double tickEndOffset, double angularSpaceForTicks, double angleForTicks) {
    final num length =
        _actualInterval != null ? _majorTicksCount : _majorTicksCount - 1;
    for (num i = 0; i <= length; i++) {
      double tickAngle = 0;
      final num count =
          _actualInterval != null ? _majorTicksCount : _majorTicksCount - 1;
      if (i == 0 || i == count) {
        tickAngle =
            _getTickPositionInCorner(i, angleForTicks, tickStartOffset, true);
      } else {
        tickAngle = angleForTicks;
      }
      final List<Offset> tickPosition =
          _getTickPosition(tickStartOffset, tickEndOffset, tickAngle);
      final TickOffset tickOffset = TickOffset();
      tickOffset.startPoint = tickPosition[0];
      tickOffset.endPoint = tickPosition[1];
      final double degree = (axis.isInversed
              ? getRadianToDegree(tickAngle) +
                  90 -
                  (axis.startAngle + sweepAngle)
              : (getRadianToDegree(tickAngle) + 90 - axis.startAngle)) /
          sweepAngle;
      tickOffset.value = (axis.onCreateAxisRenderer != null &&
              renderer != null &&
              renderer!.factorToValue(degree) != null)
          ? renderer!.factorToValue(degree) ?? factorToValue(degree)
          : factorToValue(degree);
      final Offset centerPoint =
          !axis.canScaleToFit ? Offset(centerX, centerY) : const Offset(0, 0);
      tickOffset.startPoint = Offset(tickOffset.startPoint.dx - centerPoint.dx,
          tickOffset.startPoint.dy - centerPoint.dy);
      tickOffset.endPoint = Offset(tickOffset.endPoint.dx - centerPoint.dx,
          tickOffset.endPoint.dy - centerPoint.dy);
      majorTickOffsets.add(tickOffset);
      if (axis.isInversed) {
        angleForTicks -= angularSpaceForTicks;
      } else {
        angleForTicks += angularSpaceForTicks;
      }
    }
  }

  /// Returns the corresponding range color for the value
  Color? getRangeColor(num value, SfGaugeThemeData gaugeThemeData) {
    Color? color;
    if (axis.ranges != null && axis.ranges!.isNotEmpty) {
      for (int i = 0; i < axis.ranges!.length; i++) {
        if (axis.ranges![i].startValue <= value.roundToDouble() &&
            axis.ranges![i].endValue >= value.roundToDouble()) {
          color = axis.ranges![i].color ?? gaugeThemeData.rangeColor;
          break;
        }
      }
    }
    return color;
  }

  /// Calculates the angle to adjust the start and end tick
  double _getTickPositionInCorner(
      num num, double angleForTicks, double startOffset, bool isMajor) {
    final double thickness =
        isMajor ? axis.majorTickStyle.thickness : axis.minorTickStyle.thickness;
    final double angle =
        cornerRadiusAngle(startOffset + actualAxisWidth / 2, thickness / 2);
    if (num == 0) {
      final double ticksAngle = !axis.isInversed
          ? getRadianToDegree(angleForTicks) + angle
          : getRadianToDegree(angleForTicks) - angle;
      return getDegreeToRadian(ticksAngle);
    } else {
      final double ticksAngle = !axis.isInversed
          ? getRadianToDegree(angleForTicks) - angle
          : getRadianToDegree(angleForTicks) + angle;
      return getDegreeToRadian(ticksAngle);
    }
  }

  /// Calculates the minor tick position
  void _calculateMinorTickPosition() {
    if (axisLabels != null && axisLabels!.isNotEmpty) {
      final double axisLineWidth = axis.showAxisLine ? actualAxisWidth : 0;
      double tickStartOffset = 0;
      double tickEndOffset = 0;
      final double offset = _isLabelsOutside
          ? axis.showLabels
              ? (_actualLabelOffset +
                  math.max(_maximumLabelSize.height, _maximumLabelSize.width) /
                      2)
              : 0
          : 0;
      if (!_isTicksOutside) {
        tickStartOffset = radius - (axisLineWidth + _actualTickOffset + offset);
        tickEndOffset = radius -
            (axisLineWidth +
                actualMinorTickLength +
                _actualTickOffset +
                offset);
      } else {
        final bool isGreater = actualMinorTickLength > actualMajorTickLength;
        if (!_useAxisElementsInsideRadius) {
          tickStartOffset = radius + _actualTickOffset;
          tickEndOffset = radius + actualMinorTickLength + _actualTickOffset;
        } else {
          tickStartOffset = isGreater
              ? radius - offset
              : radius - (_maximumTickLength - actualMinorTickLength + offset);
          tickEndOffset = radius - (_maximumTickLength + offset);
        }
      }

      _calculateOffsetForMinorTicks(tickStartOffset, tickEndOffset);
    }
  }

  /// Calculates the offset for minor ticks
  ///
  /// This method is quite a long method. This method could be refactored into
  /// the smaller method but it leads to passing more number of parameter and
  /// which degrades the performance
  void _calculateOffsetForMinorTicks(
      double tickStartOffset, double tickEndOffset) {
    minorTickOffsets = <TickOffset>[];
    double angularSpaceForTicks;
    double totalMinorTicks;
    if (_actualInterval != null) {
      final double majorTicksInterval =
          (axis.maximum - axis.minimum) / _actualInterval!;
      angularSpaceForTicks = getDegreeToRadian(sweepAngle / majorTicksInterval);
      final double maximumLabelValue =
          axisLabels![axisLabels!.length - 2].value.toDouble();
      int remainingTicks;
      final double difference = (axis.maximum - maximumLabelValue);
      if (difference == _actualInterval) {
        remainingTicks = 0;
      } else {
        final double minorTickInterval =
            ((_actualInterval! / 2) / axis.minorTicksPerInterval);
        remainingTicks = difference ~/ minorTickInterval;
      }

      final int labelLength = difference == _actualInterval
          ? axisLabels!.length - 1
          : axisLabels!.length - 2;
      totalMinorTicks =
          (labelLength * axis.minorTicksPerInterval) + remainingTicks;
    } else {
      angularSpaceForTicks =
          getDegreeToRadian(sweepAngle / (_majorTicksCount - 1));
      totalMinorTicks = (axisLabels!.length - 1) * axis.minorTicksPerInterval;
    }

    double angleForTicks = axis.isInversed
        ? getDegreeToRadian(axis.startAngle + sweepAngle - 90)
        : getDegreeToRadian(axis.startAngle - 90);

    const num minorTickIndex = 1; // Since the minor tick rendering
    // needs to be start in the index one
    final double minorTickAngle =
        angularSpaceForTicks / (axis.minorTicksPerInterval + 1);

    for (num i = minorTickIndex; i <= totalMinorTicks; i++) {
      if (axis.isInversed) {
        angleForTicks -= minorTickAngle;
      } else {
        angleForTicks += minorTickAngle;
      }

      final double factor = (axis.isInversed
              ? getRadianToDegree(angleForTicks) +
                  90 -
                  (axis.startAngle + sweepAngle)
              : (getRadianToDegree(angleForTicks) + 90 - axis.startAngle)) /
          sweepAngle;

      final double tickFactor =
          (axis.onCreateAxisRenderer != null && renderer != null)
              ? renderer!.factorToValue(factor) ?? factorToValue(factor)
              : factorToValue(factor);
      final double tickValue = double.parse(tickFactor.toStringAsFixed(5));
      if (tickValue <= axis.maximum && tickValue >= axis.minimum) {
        if (tickValue == axis.maximum) {
          angleForTicks = _getTickPositionInCorner(
              i, angleForTicks, tickStartOffset, false);
        }
        final List<Offset> tickPosition =
            _getTickPosition(tickStartOffset, tickEndOffset, angleForTicks);
        final TickOffset tickOffset = TickOffset();
        tickOffset.startPoint = tickPosition[0];
        tickOffset.endPoint = tickPosition[1];
        tickOffset.value = tickValue;

        final Offset centerPoint =
            !axis.canScaleToFit ? Offset(centerX, centerY) : const Offset(0, 0);
        tickOffset.startPoint = Offset(
            tickOffset.startPoint.dx - centerPoint.dx,
            tickOffset.startPoint.dy - centerPoint.dy);
        tickOffset.endPoint = Offset(tickOffset.endPoint.dx - centerPoint.dx,
            tickOffset.endPoint.dy - centerPoint.dy);
        minorTickOffsets.add(tickOffset);
        if (i % axis.minorTicksPerInterval == 0) {
          if (axis.isInversed) {
            angleForTicks -= minorTickAngle;
          } else {
            angleForTicks += minorTickAngle;
          }
        }
      }
    }
  }

  /// Calculate the axis label position
  void _calculateAxisLabelsPosition() {
    if (axisLabels != null && axisLabels!.isNotEmpty) {
      // Calculates the angle between each  axis label
      double labelsInterval;
      if (_actualInterval != null) {
        labelsInterval = (axis.maximum - axis.minimum) / _actualInterval!;
      } else {
        labelsInterval = (axisLabels!.length - 1).toDouble();
      }
      final double labelSpaceInAngle = sweepAngle / labelsInterval;
      final double labelSpaceInRadian = getDegreeToRadian(labelSpaceInAngle);
      final double tickLength = actualMajorTickLength > actualMinorTickLength
          ? actualMajorTickLength
          : actualMinorTickLength;
      final double tickPadding =
          axis.showTicks ? tickLength + _actualTickOffset : 0;
      double labelRadian = 0;
      double labelAngle = 0;
      double labelPosition = 0;
      if (!axis.isInversed) {
        labelAngle = axis.startAngle - 90;
        labelRadian = getDegreeToRadian(labelAngle);
      } else {
        labelAngle = axis.startAngle + sweepAngle - 90;
        labelRadian = getDegreeToRadian(labelAngle);
      }

      final double labelSize =
          math.max(_maximumLabelSize.height, _maximumLabelSize.width) / 2;
      if (_isLabelsOutside) {
        final double featureOffset = labelSize;
        labelPosition = _useAxisElementsInsideRadius
            ? radius - featureOffset
            : radius + tickPadding + _actualLabelOffset;
      } else {
        labelPosition =
            radius - (actualAxisWidth + tickPadding + _actualLabelOffset);
      }

      _calculateLabelPosition(labelPosition, labelRadian, labelAngle,
          labelSpaceInRadian, labelSpaceInAngle);
    }
  }

  // Method to calculate label position
  void _calculateLabelPosition(double labelPosition, double labelRadian,
      double labelAngle, double labelSpaceInRadian, double labelSpaceInAngle) {
    for (int i = 0; i < axisLabels!.length; i++) {
      final CircularAxisLabel label = axisLabels![i];
      label.angle = labelAngle;
      if (isMaxiumValueIncluded && i == axisLabels!.length - 1) {
        labelAngle = axis.isInversed
            ? axis.startAngle - 90
            : axis.startAngle + sweepAngle - 90;
        label.value = axis.maximum;
        label.angle = labelAngle;
        labelRadian = getDegreeToRadian(labelAngle);
      } else {
        final double coordinateValue = (axis.isInversed
                ? labelAngle + 90 - (axis.startAngle + sweepAngle)
                : (labelAngle + 90 - axis.startAngle)) /
            sweepAngle;
        label.value = (axis.onCreateAxisRenderer != null &&
                renderer != null &&
                renderer!.factorToValue(coordinateValue) != null)
            ? renderer!.factorToValue(coordinateValue) ??
                factorToValue(coordinateValue)
            : factorToValue(coordinateValue);
      }

      if (!axis.canScaleToFit) {
        final double x =
            ((axisSize.width / 2) - (labelPosition * math.sin(labelRadian))) -
                centerX;
        final double y =
            ((axisSize.height / 2) + (labelPosition * math.cos(labelRadian))) -
                centerY;
        label.position = Offset(x, y);
      } else {
        final double x =
            axisCenter.dx - (labelPosition * math.sin(labelRadian));
        final double y =
            axisCenter.dy + (labelPosition * math.cos(labelRadian));
        label.position = Offset(x, y);
      }

      if (!axis.isInversed) {
        labelRadian += labelSpaceInRadian;
        labelAngle += labelSpaceInAngle;
      } else {
        labelRadian -= labelSpaceInRadian;
        labelAngle -= labelSpaceInAngle;
      }
    }
  }

  /// To find the maximum label size
  void _measureAxisLabels() {
    _maximumLabelSize = const Size(0, 0);
    for (int i = 0; i < axisLabels!.length; i++) {
      final CircularAxisLabel label = axisLabels![i];
      label.labelSize = getTextSize(label.text, label.labelStyle);
      final double maxWidth = _maximumLabelSize.width < label.labelSize.width
          ? label.needsRotateLabel
              ? label.labelSize.height
              : label.labelSize.width
          : _maximumLabelSize.width;
      final double maxHeight = _maximumLabelSize.height < label.labelSize.height
          ? label.labelSize.height
          : _maximumLabelSize.height;

      _maximumLabelSize = Size(maxWidth, maxHeight);
    }
  }

  /// Gets the start and end offset of tick
  List<Offset> _getTickPosition(
      double tickStartOffset, double tickEndOffset, double angleForTicks) {
    final Offset centerPoint = !axis.canScaleToFit
        ? Offset(axisSize.width / 2, axisSize.height / 2)
        : axisCenter;
    final double tickStartX =
        centerPoint.dx - tickStartOffset * math.sin(angleForTicks);
    final double tickStartY =
        centerPoint.dy + tickStartOffset * math.cos(angleForTicks);
    final double tickStopX =
        centerPoint.dx + (1 - tickEndOffset) * math.sin(angleForTicks);
    final double tickStopY =
        centerPoint.dy - (1 - tickEndOffset) * math.cos(angleForTicks);
    final Offset startOffset = Offset(tickStartX, tickStartY);
    final Offset endOffset = Offset(tickStopX, tickStopY);
    return <Offset>[startOffset, endOffset];
  }

  ///Method to calculate teh sweep angle of axis
  double _getSweepAngle() {
    final double actualEndAngle =
        axis.endAngle > 360 ? axis.endAngle % 360 : axis.endAngle;
    double totalAngle = actualEndAngle - axis.startAngle;
    totalAngle = totalAngle <= 0 ? (totalAngle + 360) : totalAngle;
    return totalAngle;
  }

  ///Calculates the axis width based on the coordinate unit
  double getActualValue(double? value, GaugeSizeUnit sizeUnit, bool isOffset) {
    double actualValue = 0;
    if (value != null) {
      switch (sizeUnit) {
        case GaugeSizeUnit.factor:
          {
            if (!isOffset) {
              value = value < 0 ? 0 : value;
              value = value > 1 ? 1 : value;
            }

            actualValue = value * radius;
          }
          break;
        case GaugeSizeUnit.logicalPixel:
          {
            actualValue = value;
          }
          break;
      }
    }

    return actualValue;
  }

  ///Calculates the maximum tick length
  double _getTickLength(bool isMajorTick) {
    if (isMajorTick) {
      return getActualValue(
          axis.majorTickStyle.length, axis.majorTickStyle.lengthUnit, false);
    } else {
      return getActualValue(
          axis.minorTickStyle.length, axis.minorTickStyle.lengthUnit, false);
    }
  }

  /// Renders the axis pointers
  void _renderPointers() {
    final int index = renderingDetails.axisRenderers.indexOf(this);
    for (int i = 0; i < axis.pointers!.length; i++) {
      final List<GaugePointerRenderer> pointerRenderers =
          renderingDetails.gaugePointerRenderers[index]!;
      final GaugePointerRenderer pointerRenderer = pointerRenderers[i];
      pointerRenderer.axis = axis;
      pointerRenderer.calculatePosition();
    }
  }

  /// Method to render the range
  void _renderRanges() {
    final int index = renderingDetails.axisRenderers.indexOf(this);
    for (int i = 0; i < axis.ranges!.length; i++) {
      final List<GaugeRangeRenderer> rangeRenderers =
          renderingDetails.gaugeRangeRenderers[index]!;
      final GaugeRangeRenderer rangeRenderer = rangeRenderers[i];
      rangeRenderer.axis = axis;
      rangeRenderer.calculateRangePosition();
    }
  }

  /// Calculates the interval of axis based on its range
  num _getNiceInterval() {
    if (axis.interval != null) {
      return axis.interval!;
    }

    return calculateAxisInterval(axis.maximumLabels);
  }

  /// To calculate the axis label based on the maximum axis label
  num calculateAxisInterval(int actualMaximumValue) {
    final num delta = _getAxisRange();
    final num circumference = 2 * math.pi * _center * (sweepAngle / 360);
    final num desiredIntervalCount =
        math.max(circumference * ((0.533 * actualMaximumValue) / 100), 1);
    num niceInterval = delta / desiredIntervalCount;
    final num minimumInterval =
        math.pow(10, (math.log(niceInterval) / math.log(10)).floor());
    final List<double> intervalDivisions = <double>[10, 5, 2, 1];
    for (int i = 0; i < intervalDivisions.length; i++) {
      final num currentInterval = minimumInterval * intervalDivisions[i];
      if (desiredIntervalCount < (delta / currentInterval)) {
        break;
      }
      niceInterval = currentInterval;
    }

    return niceInterval; // Returns the interval based on the maximum number
    // of labels for 100 labels
  }

  /// To load the image from the image provider
  void _loadBackgroundImage(BuildContext context) {
    final ImageStream newImageStream =
        axis.backgroundImage!.resolve(createLocalImageConfiguration(context));
    if (newImageStream.key != imageStream?.key) {
      imageStream?.removeListener(listener!);
      imageStream = newImageStream;
      imageStream?.addListener(listener!);
    }
  }

  /// Update the background image
  void _updateBackgroundImage(ImageInfo? imageInfo, bool synchronousCall) {
    if (imageInfo?.image != null) {
      backgroundImageInfo = imageInfo;
      renderingDetails.axisRepaintNotifier.value++;
    }
  }

  /// Gets the current axis labels
  CircularAxisLabel _getAxisLabel(num i) {
    num value = i;
    String labelText = value.toString();
    final List<String> list = labelText.split('.');
    value = double.parse(value.toStringAsFixed(3));
    if (list.isNotEmpty &&
        list.length > 1 &&
        (list[1] == '0' || list[1] == '00' || list[1] == '000')) {
      value = value.round();
    }

    labelText = value.toString();

    if (axis.numberFormat != null) {
      labelText = axis.numberFormat!.format(value);
    }
    if (axis.labelFormat != null) {
      labelText = axis.labelFormat!.replaceAll(RegExp('{value}'), labelText);
    }
    AxisLabelCreatedArgs? labelCreatedArgs;
    GaugeTextStyle? argsLabelStyle;
    if (axis.onLabelCreated != null) {
      labelCreatedArgs = AxisLabelCreatedArgs();
      labelCreatedArgs.text = labelText;
      axis.onLabelCreated!(labelCreatedArgs);

      labelText = labelCreatedArgs.text;
      argsLabelStyle = labelCreatedArgs.labelStyle;
    }

    final GaugeTextStyle labelStyle = argsLabelStyle ?? axis.axisLabelStyle;
    final CircularAxisLabel label = CircularAxisLabel(labelStyle, labelText, i,
        labelCreatedArgs != null ? labelCreatedArgs.canRotate ?? false : false);
    label.value = value;
    return label;
  }

  /// Returns the axis range
  num _getAxisRange() {
    return axis.maximum - axis.minimum;
  }

  /// Calculates the visible labels based on axis interval and range
  List<CircularAxisLabel>? generateVisibleLabels() {
    isMaxiumValueIncluded = false;
    final List<CircularAxisLabel> visibleLabels = <CircularAxisLabel>[];
    _actualInterval = _getNiceInterval();
    for (num i = axis.minimum; i <= axis.maximum; i += _actualInterval!) {
      final CircularAxisLabel currentLabel = _getAxisLabel(i);
      visibleLabels.add(currentLabel);
    }

    final CircularAxisLabel label = visibleLabels[visibleLabels.length - 1];
    if (label.value != axis.maximum && label.value < axis.maximum) {
      isMaxiumValueIncluded = true;
      final CircularAxisLabel currentLabel = _getAxisLabel(axis.maximum);
      visibleLabels.add(currentLabel);
    }

    return visibleLabels;
  }

  /// Converts the axis value to factor based on angle
  double valueToFactor(double value) {
    final double angle = _valueToAngle(value);
    return angle / sweepAngle;
  }

  /// Converts the factor value to axis value
  double factorToValue(double factor) {
    final double angle = axis.isInversed
        ? (factor * sweepAngle) + axis.startAngle + sweepAngle
        : (factor * sweepAngle) + axis.startAngle;

    return _angleToValue(angle);
  }
}
