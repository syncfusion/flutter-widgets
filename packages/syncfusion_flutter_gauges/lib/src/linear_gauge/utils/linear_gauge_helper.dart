import 'package:flutter/material.dart';

import '../../linear_gauge/utils/enum.dart';

RRect _getHorizontalStartCurve(Rect rect, double radius) {
  return RRect.fromRectAndCorners(rect,
      topLeft: Radius.circular(radius), bottomLeft: Radius.circular(radius));
}

RRect _getHorizontalEndCurvePath(Rect rect, double radius) {
  return RRect.fromRectAndCorners(rect,
      topRight: Radius.circular(radius), bottomRight: Radius.circular(radius));
}

RRect _getVerticalStartCurve(Rect rect, double radius) {
  return RRect.fromRectAndCorners(rect,
      topLeft: Radius.circular(radius), topRight: Radius.circular(radius));
}

RRect _getVerticalEndCurvePath(Rect rect, double radius) {
  return RRect.fromRectAndCorners(rect,
      bottomLeft: Radius.circular(radius),
      bottomRight: Radius.circular(radius));
}

/// Returns the start curve path.
RRect getStartCurve(
    {required bool isHorizontal,
    required bool isAxisInversed,
    required Rect rect,
    required double radius}) {
  if (isHorizontal) {
    return !isAxisInversed
        ? _getHorizontalStartCurve(rect, radius)
        : _getHorizontalEndCurvePath(rect, radius);
  } else {
    return !isAxisInversed
        ? _getVerticalEndCurvePath(rect, radius)
        : _getVerticalStartCurve(rect, radius);
  }
}

/// Returns the end curve path.
RRect getEndCurve(
    {required bool isHorizontal,
    required bool isAxisInversed,
    required Rect rect,
    required double radius}) {
  if (isHorizontal) {
    return !isAxisInversed
        ? _getHorizontalEndCurvePath(rect, radius)
        : _getHorizontalStartCurve(rect, radius);
  } else {
    return !isAxisInversed
        ? _getVerticalStartCurve(rect, radius)
        : _getVerticalEndCurvePath(rect, radius);
  }
}

/// Returns the effective element position.
LinearElementPosition getEffectiveElementPosition(
    LinearElementPosition position, bool isMirrored) {
  if (isMirrored) {
    return (position == LinearElementPosition.inside)
        ? LinearElementPosition.outside
        : (position == LinearElementPosition.outside)
            ? LinearElementPosition.inside
            : LinearElementPosition.cross;
  }

  return position;
}

/// Returns the effective label position.
LinearLabelPosition getEffectiveLabelPosition(
    LinearLabelPosition labelPlacement, bool isMirrored) {
  if (isMirrored) {
    labelPlacement = (labelPlacement == LinearLabelPosition.inside)
        ? LinearLabelPosition.outside
        : LinearLabelPosition.inside;
  }

  return labelPlacement;
}

/// Returns the curve animation function based on the animation type
Curve getCurveAnimation(LinearAnimationType type) {
  Curve curve = Curves.linear;
  switch (type) {
    case LinearAnimationType.bounceOut:
      curve = Curves.bounceOut;
      break;
    case LinearAnimationType.ease:
      curve = Curves.ease;
      break;
    case LinearAnimationType.easeInCirc:
      curve = Curves.easeInCirc;
      break;
    case LinearAnimationType.easeOutBack:
      curve = Curves.easeOutBack;
      break;
    case LinearAnimationType.elasticOut:
      curve = Curves.elasticOut;
      break;
    case LinearAnimationType.linear:
      curve = Curves.linear;
      break;
    case LinearAnimationType.slowMiddle:
      curve = Curves.slowMiddle;
      break;
    // ignore: no_default_cases
    default:
      break;
  }
  return curve;
}
