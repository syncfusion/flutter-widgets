import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'behavior/zoom_pan_behavior.dart';

// ignore_for_file: public_member_api_docs

// Default hover color opacity value.
const double hoverColorOpacity = 0.7;

// If shape color opacity is same hover color opacity,
// hover is not visible in UI.
// So need to decrease hover opacity
const double minHoverOpacity = 0.5;

// Using this factor, the tooltip position of the bubble and marker is
// determined from the total height.
const double tooltipHeightFactor = 0.25;

const double minimumLatitude = -85.05112878;
const double maximumLatitude = 85.05112878;
const double minimumLongitude = -180;
const double maximumLongitude = 180;

enum MarkerAction { insert, removeAt, replace, clear }

Size getBoxSize(BoxConstraints constraints) {
  final double width = constraints.hasBoundedWidth ? constraints.maxWidth : 300;
  final double height =
      constraints.hasBoundedHeight ? constraints.maxHeight : 300;
  return Size(width, height);
}

Offset pixelFromLatLng(num latitude, num longitude, Size size,
    [Offset offset = const Offset(0, 0), double factor = 1.0]) {
  assert(latitude != null);
  assert(longitude != null);
  assert(size != null);

  final double x = (longitude + 180.0) / 360.0;
  final double sinLatitude = sin(latitude * pi / 180.0);
  final double y =
      0.5 - log((1.0 + sinLatitude) / (1.0 - sinLatitude)) / (4.0 * pi);
  final double mapSize = size.longestSide * factor;
  final double dx = offset.dx + _clip(x * mapSize + 0.5, 0.0, mapSize - 1);
  final double dy = offset.dy + _clip(y * mapSize + 0.5, 0.0, mapSize - 1);
  return Offset(dx, dy);
}

MapLatLng getPixelToLatLng(
    Offset offset, Size size, Offset translation, double factor) {
  return pixelToLatLng(offset, size, translation, factor);
}

MapLatLng pixelToLatLng(
    Offset offset, Size size, Offset translation, double factor) {
  final double mapSize = size.longestSide * factor;
  final double x =
      (_clip(offset.dx - translation.dx, 0, mapSize - 1) / mapSize) - 0.5;
  final double y =
      0.5 - (_clip(offset.dy - translation.dy, 0, mapSize - 1) / mapSize);
  final double latitude = 90 - 360 * atan(exp(-y * 2 * pi)) / pi;
  final double longitude = 360 * x;
  return MapLatLng(latitude, longitude);
}

double _clip(double value, double minValue, double maxValue) {
  return min(max(value, minValue), maxValue);
}

double interpolateValue(double value, double min, double max) {
  assert(min != null);
  max ??= value;
  if (value > max) {
    value = max;
  } else if (value < min) {
    value = min;
  }
  return value;
}

String getTrimText(String text, TextStyle style, double maxWidth,
    TextPainter painter, double width,
    [double nextTextHalfWidth]) {
  final int actualTextLength = text.length;
  String trimmedText = text;
  int trimLength = 3; // 3 dots
  while (width > maxWidth) {
    if (trimmedText.length <= 4) {
      trimmedText = trimmedText[0] + '...';
      painter.text = TextSpan(style: style, text: trimmedText);
      painter.layout();
      break;
    } else {
      trimmedText = text.replaceRange(
          actualTextLength - trimLength, actualTextLength, '...');
      painter.text = TextSpan(style: style, text: trimmedText);
      painter.layout();
      trimLength++;
    }

    width = nextTextHalfWidth != null
        ? painter.width / 2 + nextTextHalfWidth
        : painter.width;
  }

  return trimmedText;
}

double getTotalTileWidth(double zoom) {
  return 256 * pow(2, zoom);
}

/// An interpolation between two latlngs.
///
/// This class specializes the interpolation of [Tween<MapLatLng>] to use
/// [MapLatLng.lerp].
class MapLatLngTween extends Tween<MapLatLng> {
  /// Creates an [MapLatLng] tween.
  MapLatLngTween({MapLatLng begin, MapLatLng end})
      : super(begin: begin, end: end);

  @override
  MapLatLng lerp(double t) => MapLatLng.lerp(begin, end, t);
}
