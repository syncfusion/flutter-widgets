import 'dart:math';
import 'dart:ui';

import 'enum.dart';
import 'helper.dart';

Offset calculateExplodingCenter(double midAngle, double currentRadius,
    Offset center, String explodeOffset) {
  final double explodeCenter = percentToValue(explodeOffset, currentRadius)!;
  return calculateOffset(midAngle, explodeCenter, center);
}

/// Find the deviation angle.
num findAngleDeviation(num innerRadius, num outerRadius, num totalAngle) {
  final num midRadius = (innerRadius + outerRadius) / 2;
  final num circumference = 2 * pi * midRadius;
  final num rimSize = (innerRadius - outerRadius).abs();
  final num deviation = ((rimSize / 2) / circumference) * 100;
  return (deviation * 360) / 100;
}

/// Calculate arc path for circular series segment.
Path calculateArcPath(double innerRadius, double radius, Offset center,
    double startAngle, double endAngle, double degree,
    {bool isAnimate = false}) {
  final Path path = Path();
  final double startRadian = degreesToRadians(startAngle);
  final double endRadian = degreesToRadians(endAngle);
  final double sweepRadian = degreesToRadians(degree);

  if (isAnimate) {
    final Offset innerRadiusStartPoint = Offset(
        innerRadius * cos(startRadian) + center.dx,
        innerRadius * sin(startRadian) + center.dy);
    path.moveTo(innerRadiusStartPoint.dx, innerRadiusStartPoint.dy);
  }

  final Offset radiusStartPoint = Offset(radius * cos(startRadian) + center.dx,
      radius * sin(startRadian) + center.dy);

  // Check if the angle between startAngle and endAngle is equal to
  // a full circle (2 * pi radians) by rounding both values to 5 decimal
  // places and comparing them to avoid precision errors.
  final bool isFullCircle = (endRadian - startRadian).toStringAsFixed(5) ==
      (2 * pi).toStringAsFixed(5);
  final double midAngle = (endRadian + startRadian) / 2;

  if (isFullCircle) {
    path.arcTo(Rect.fromCircle(center: center, radius: radius), startRadian,
        midAngle - startRadian, true);
    path.arcTo(Rect.fromCircle(center: center, radius: radius), midAngle,
        endRadian - midAngle, true);
  } else {
    path.lineTo(radiusStartPoint.dx, radiusStartPoint.dy);
    path.arcTo(Rect.fromCircle(center: center, radius: radius), startRadian,
        sweepRadian, true);
  }

  if (isFullCircle) {
    path.arcTo(Rect.fromCircle(center: center, radius: innerRadius), endRadian,
        midAngle - endRadian, true);
    path.arcTo(Rect.fromCircle(center: center, radius: innerRadius), midAngle,
        startRadian - midAngle, true);
  } else {
    final Offset innerRadiusEndPoint = Offset(
        innerRadius * cos(endRadian) + center.dx,
        innerRadius * sin(endRadian) + center.dy);

    path.lineTo(innerRadiusEndPoint.dx, innerRadiusEndPoint.dy);
    path.arcTo(Rect.fromCircle(center: center, radius: innerRadius), endRadian,
        startRadian - endRadian, true);
    path.lineTo(radiusStartPoint.dx, radiusStartPoint.dy);
  }

  return path;
}

/// Calculate series start or end angle based on animation type.
double calculateAngle(bool isRealTimeAnimation, int startAngle, int endAngle) {
  // Segment animation
  if (isRealTimeAnimation) {
    final int finalEndAngle =
        startAngle == endAngle ? 360 + endAngle : endAngle;
    return finalEndAngle - 90;
  }
  // Series animation
  return startAngle - 90;
}

/// Calculate rounded corners arc path.
Path calculateRoundedCornerArcPath(CornerStyle cornerStyle, double innerRadius,
    double outerRadius, Offset center, double startAngle, double endAngle) {
  final Path path = Path();

  if (cornerStyle == CornerStyle.startCurve ||
      cornerStyle == CornerStyle.bothCurve) {
    final Offset startPoint = calculateOffset(startAngle, innerRadius, center);
    final Offset endPoint = calculateOffset(startAngle, outerRadius, center);

    path.moveTo(startPoint.dx, startPoint.dy);
    path.arcToPoint(endPoint,
        radius: Radius.circular((innerRadius - outerRadius).abs() / 2));
  }

  path.addArc(Rect.fromCircle(center: center, radius: outerRadius),
      degreesToRadians(startAngle), degreesToRadians(endAngle - startAngle));

  if (cornerStyle == CornerStyle.endCurve ||
      cornerStyle == CornerStyle.bothCurve) {
    final Offset endPoint = calculateOffset(endAngle, innerRadius, center);
    path.arcToPoint(endPoint,
        radius: Radius.circular((innerRadius - outerRadius).abs() / 2));
  }

  path.arcTo(
      Rect.fromCircle(center: center, radius: innerRadius),
      degreesToRadians(endAngle),
      degreesToRadians(startAngle) - degreesToRadians(endAngle),
      false);

  if (cornerStyle == CornerStyle.endCurve) {
    path.close();
  }

  return path;
}
