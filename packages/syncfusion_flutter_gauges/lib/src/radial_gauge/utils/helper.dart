import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../radial_gauge/styles/radial_text_style.dart';
import '../../radial_gauge/utils/enum.dart';

/// Specifies the offset value of tick
class TickOffset {
  /// Holds the start point
  late Offset startPoint;

  /// Holds the end point
  late Offset endPoint;

  /// Holds the tick value
  late double value;
}

/// Represents the arc data
class ArcData {
  /// Represents the start angle
  late double startAngle;

  /// Represents the end angle
  late double endAngle;

  /// Represents the arc rect
  late Rect arcRect;
}

/// Converts degree to radian
double getDegreeToRadian(double degree) {
  return degree * (math.pi / 180);
}

/// Converts radian to degree
double getRadianToDegree(double radian) {
  return 180 / math.pi * radian;
}

/// To get the degree from the point
Offset getDegreeToPoint(double degree, double radius, Offset center) {
  degree = getDegreeToRadian(degree);
  return Offset(center.dx + math.cos(degree) * radius,
      center.dy + math.sin(degree) * radius);
}

/// Methods to get the saturation color
Color getSaturationColor(Color color) {
  final num contrast =
      ((color.red * 299 + color.green * 587 + color.blue * 114) / 1000).round();
  final Color saturationColor =
      contrast >= 128 ? const Color(0xFF333333) : const Color(0xFFF5F5F5);
  return saturationColor;
}

/// Measure the text and return the text size
//ignore: unused_element
Size getTextSize(String textValue, GaugeTextStyle textStyle) {
  Size size;
  final TextPainter textPainter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
    text: TextSpan(
        text: textValue,
        style: TextStyle(
            color: textStyle.color,
            fontSize: textStyle.fontSize,
            fontFamily: textStyle.fontFamily,
            fontStyle: textStyle.fontStyle,
            fontWeight: textStyle.fontWeight)),
  );
  textPainter.layout();
  size = Size(textPainter.width, textPainter.height);
  return size;
}

/// Returns the revised gradient stop
List<double> calculateGradientStops(
    List<double?> offsets, bool isInversed, double sweepAngle) {
  final List<double> gradientStops = List<double>.filled(offsets.length, 0);

  // Normalizes the provided offset values to the corresponding sweep angle
  for (int i = 0; i < offsets.length; i++) {
    final double offset = offsets[i]!;
    double stop = ((sweepAngle / 360) * offset).abs();
    if (isInversed) {
      stop = 1 - stop;
    }
    gradientStops[i] = stop;
  }

  return isInversed ? gradientStops.reversed.toList() : gradientStops;
}

/// Method returns the curve animation function based on the animation type
Curve getCurveAnimation(AnimationType type) {
  Curve curve = Curves.linear;
  switch (type) {
    case AnimationType.bounceOut:
      curve = Curves.bounceOut;
      break;
    case AnimationType.ease:
      curve = Curves.ease;
      break;
    case AnimationType.easeInCirc:
      curve = Curves.easeInCirc;
      break;
    case AnimationType.easeOutBack:
      curve = Curves.easeOutBack;
      break;
    case AnimationType.elasticOut:
      curve = Curves.elasticOut;
      break;
    case AnimationType.linear:
      curve = Curves.linear;
      break;
    case AnimationType.slowMiddle:
      curve = Curves.slowMiddle;
      break;
  }
  return curve;
}

/// Represents the circular interval list
class CircularIntervalList<T> {
  /// Creates the circular interval list
  CircularIntervalList(this._values);

  /// Specifies the list of value
  final List<T> _values;

  /// Specifies the index value
  int _index = 0;

  /// To get the value of next
  T get next {
    if (_index >= _values.length) {
      _index = 0;
    }
    return _values[_index++];
  }
}

/// Method to draw the dashed path
Path dashPath(Path source, {CircularIntervalList<double>? dashArray}) {
  final Path path = Path();
  const double intialValue = 0.0;

  if (dashArray != null) {
    for (final PathMetric measurePath in source.computeMetrics()) {
      double distance = intialValue;
      bool draw = true;
      while (distance < measurePath.length) {
        final double length = dashArray.next;
        if (draw) {
          path.addPath(measurePath.extractPath(distance, distance + length),
              Offset.zero);
        }
        distance += length;
        draw = !draw;
      }
    }
  }
  return path;
}

/// Calculates the corner radius angle
double cornerRadiusAngle(double totalRadius, double circleRadius) {
  final double perimeter = (totalRadius + totalRadius + circleRadius) / 2;
  final double area = math.sqrt(perimeter *
      (perimeter - totalRadius) *
      (perimeter - totalRadius) *
      (perimeter - circleRadius));
  final double cornerRadiusAngle =
      math.asin((2 * area) / (totalRadius * totalRadius)) * (180 / math.pi);
  return cornerRadiusAngle;
}

/// Base class for radial axis internal usage.
class RadialAxisInheritedWidget extends InheritedWidget {
  /// Creates [RadialAxisInheritedWidget].
  const RadialAxisInheritedWidget({
    super.key,
    required this.minimum,
    required this.maximum,
    required Widget child,
  }) : super(child: child);

  /// Defines the minimum value of axis.
  final double minimum;

  /// Defines the maximum value of axis.
  final double maximum;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
