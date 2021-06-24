import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../maps.dart';
import 'common.dart';
import 'controller/map_controller.dart';
import 'controller/map_provider.dart';

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

Size getBoxSize(BoxConstraints constraints) {
  final double width = constraints.hasBoundedWidth ? constraints.maxWidth : 300;
  final double height =
      constraints.hasBoundedHeight ? constraints.maxHeight : 300;
  return Size(width, height);
}

Offset pixelFromLatLng(num latitude, num longitude, Size size,
    [Offset offset = const Offset(0, 0), double scale = 1.0]) {
  final double x = (longitude + 180.0) / 360.0;
  final double sinLatitude = sin(latitude * pi / 180.0);
  final double y =
      0.5 - log((1.0 + sinLatitude) / (1.0 - sinLatitude)) / (4.0 * pi);
  final double mapSize = size.longestSide * scale;
  final double dx = offset.dx + ((x * mapSize + 0.5).clamp(0.0, mapSize - 1));
  final double dy = offset.dy + ((y * mapSize + 0.5).clamp(0.0, mapSize - 1));
  return Offset(dx, dy);
}

MapLatLng getPixelToLatLng(
    Offset offset, Size size, Offset translation, double scale) {
  return pixelToLatLng(offset, size, translation, scale);
}

MapLatLng pixelToLatLng(Offset offset, Size size,
    [Offset translation = const Offset(0, 0), double scale = 1.0]) {
  final double mapSize = size.longestSide * scale;
  final double x =
      ((offset.dx - translation.dx).clamp(0, mapSize - 1) / mapSize) - 0.5;
  final double y =
      0.5 - ((offset.dy - translation.dy).clamp(0, mapSize - 1) / mapSize);
  final double latitude = 90 - 360 * atan(exp(-y * 2 * pi)) / pi;
  final double longitude = 360 * x;
  return MapLatLng(latitude, longitude);
}

String getTrimText(String text, TextStyle style, double maxWidth,
    TextPainter painter, double width,
    [double? nextTextHalfWidth, bool isInsideLastLabel = false]) {
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

    if (isInsideLastLabel && nextTextHalfWidth != null) {
      width = painter.width + nextTextHalfWidth;
    } else {
      width = nextTextHalfWidth != null
          ? painter.width / 2 + nextTextHalfWidth
          : painter.width;
    }
  }

  return trimmedText;
}

double getTotalTileWidth(double zoom) {
  return 256 * pow(2, zoom).toDouble();
}

Offset getTranslationOffset(MapController controller) {
  if (controller.layerType == LayerType.tile) {
    return -controller.tileCurrentLevelDetails.origin!;
  } else {
    if (!controller.isInInteractive) {
      return controller.shapeLayerOffset;
    } else {
      if (controller.gesture == Gesture.scale) {
        return controller.getZoomingTranslation() + controller.normalize;
      }

      return controller.shapeLayerOffset + controller.panDistance;
    }
  }
}

double getLayerSizeFactor(MapController controller) {
  return controller.layerType == LayerType.tile
      ? 1.0
      : (controller.shapeLayerSizeFactor *
          (controller.gesture == Gesture.scale ? controller.localScale : 1.0));
}

MapProvider getSourceProvider(
    Object geoJsonSource, GeoJSONSourceType geoJSONSourceType) {
  switch (geoJSONSourceType) {
    case GeoJSONSourceType.asset:
      return AssetMapProvider(geoJsonSource.toString());
    case GeoJSONSourceType.network:
      return NetworkMapProvider(geoJsonSource.toString());
    case GeoJSONSourceType.memory:
      // ignore: avoid_as
      return MemoryMapProvider(geoJsonSource as Uint8List);
  }
}

/// An interpolation between two latlng.
///
/// This class specializes the interpolation of [Tween<MapLatLng>] to use
/// [MapLatLng.lerp].
class MapLatLngTween extends Tween<MapLatLng> {
  /// Creates an [MapLatLng] tween.
  MapLatLngTween({MapLatLng? begin, MapLatLng? end})
      : super(begin: begin, end: end);

  @override
  MapLatLng lerp(double t) => MapLatLng.lerp(begin, end, t)!;
}
