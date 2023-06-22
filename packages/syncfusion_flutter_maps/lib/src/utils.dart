import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../maps.dart';
import 'common.dart';
import 'controller/map_controller.dart';
import 'controller/map_provider.dart';

// ignore_for_file: public_member_api_docs

// Using this factor, the tooltip position of the bubble and marker is
// determined from the total height.
const double tooltipHeightFactor = 0.25;

const double minimumLatitude = -85.05112878;
const double maximumLatitude = 85.05112878;
const double minimumLongitude = -180;
const double maximumLongitude = 180;

const double kDefaultMinZoomLevel = 1.0;
const double kDefaultMaxZoomLevel = 15.0;

// Combines the two color values and returns a new saturated color. We have
// used black color as default mix color.
Color getSaturatedColor(Color color, [Color mix = Colors.black]) {
  const double factor = 0.2;
  return color == Colors.transparent
      ? color
      : Color.fromRGBO(
          ((1 - factor) * color.red + factor * mix.red).toInt(),
          ((1 - factor) * color.green + factor * mix.green).toInt(),
          ((1 - factor) * color.blue + factor * mix.blue).toInt(),
          1);
}

Size getBoxSize(BoxConstraints constraints) {
  final double width = constraints.hasBoundedWidth ? constraints.maxWidth : 300;
  final double height =
      constraints.hasBoundedHeight ? constraints.maxHeight : 300;
  return Size(width, height);
}

Offset pixelFromLatLng(num latitude, num longitude, Size size,
    [Offset offset = Offset.zero, double scale = 1.0]) {
  final double x = (longitude + 180.0) / 360.0;
  final double sinLatitude = sin(latitude * pi / 180.0);
  final double y =
      0.5 - log((1.0 + sinLatitude) / (1.0 - sinLatitude)) / (4.0 * pi);
  final double mapSize = size.longestSide * scale;
  final double dx = offset.dx + ((x * mapSize).clamp(0.0, mapSize));
  final double dy = offset.dy + ((y * mapSize).clamp(0.0, mapSize));
  return Offset(dx, dy);
}

MapLatLng getPixelToLatLng(
    Offset offset, Size size, Offset translation, double scale) {
  return pixelToLatLng(offset, size, translation, scale);
}

MapLatLng pixelToLatLng(Offset offset, Size size,
    [Offset translation = Offset.zero, double scale = 1.0]) {
  final double mapSize = size.longestSide * scale;
  final double x =
      ((offset.dx - translation.dx).clamp(0, mapSize - 1) / mapSize) - 0.5;
  final double y =
      0.5 - ((offset.dy - translation.dy).clamp(0, mapSize - 1) / mapSize);
  final double latitude = 90 - 360 * atan(exp(-y * 2 * pi)) / pi;
  final double longitude = 360 * x;
  return MapLatLng(latitude, longitude);
}

MapLatLng getFocalLatLng(MapLatLngBounds bounds) {
  final double latitude =
      (bounds.southwest.latitude + bounds.northeast.latitude) / 2;
  final double longitude =
      (bounds.southwest.longitude + bounds.northeast.longitude) / 2;
  return MapLatLng(latitude, longitude);
}

double getZoomLevel(MapLatLngBounds bounds, LayerType layerType, Size size,
    [double actualShapeSizeFactor = 1.0]) {
  switch (layerType) {
    case LayerType.shape:
      final Offset northEast = pixelFromLatLng(
          bounds.northeast.latitude, bounds.northeast.longitude, size);
      final Offset southWest = pixelFromLatLng(
          bounds.southwest.latitude, bounds.southwest.longitude, size);
      final Rect boundsRect = Rect.fromPoints(northEast, southWest);
      final double latZoom = size.height / boundsRect.height;
      final double lngZoom = size.width / boundsRect.width;
      return min(latZoom.abs(), lngZoom.abs()) / actualShapeSizeFactor;
    case LayerType.tile:
      // Calculating the scale value for the given bounds using the
      // default tile layer size with default minimum zoom level.
      final Size tileLayerSize =
          Size.square(getTotalTileWidth(kDefaultMinZoomLevel));
      final Offset northEast = pixelFromLatLng(
          bounds.northeast.latitude, bounds.northeast.longitude, tileLayerSize);
      final Offset southWest = pixelFromLatLng(
          bounds.southwest.latitude, bounds.southwest.longitude, tileLayerSize);
      final Rect boundsRect = Rect.fromPoints(northEast, southWest);
      // Converting scale into zoom level.
      final double latZoomLevel = log(boundsRect.height / size.height) / log(2);
      final double lngZoomLevel = log(boundsRect.width / size.width) / log(2);
      return min(latZoomLevel.abs(), lngZoomLevel.abs()) + 1;
  }
}

String getTrimText(String text, TextStyle style, double maxWidth,
    TextPainter painter, double width,
    [double? nextTextHalfWidth, bool isInsideLastLabel = false]) {
  final int actualTextLength = text.length;
  String trimmedText = text;
  int trimLength = 3; // 3 dots
  while (width > maxWidth) {
    if (trimmedText.length <= 4) {
      trimmedText = '${trimmedText[0]}...';
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

// Calculates the shape's path center and width for data label rendering.
void findPathCenterAndWidth(
    double signedArea, double centerX, double centerY, MapModel mapModel) {
  // Used mathematical formula to find the center of polygon points.
  signedArea /= 2;
  centerX = centerX / (6 * signedArea);
  centerY = centerY / (6 * signedArea);
  mapModel.shapePathCenter = Offset(centerX, centerY);
  double minX = double.infinity;
  double maxX = double.negativeInfinity;
  double distance,
      minDistance = double.infinity,
      maxDistance = double.negativeInfinity;

  final List<double> minDistances = <double>[double.infinity];
  final List<double> maxDistances = <double>[double.negativeInfinity];
  for (final List<Offset> points in mapModel.pixelPoints!) {
    for (final Offset point in points) {
      distance = (centerY - point.dy).abs();
      if (point.dx < centerX) {
        // Collected all points which is less 10 pixels distance from
        // 'center y' to position the labels more smartly.
        if (distance < 10) {
          minDistances.add(point.dx);
        }
        if (distance < minDistance) {
          minX = point.dx;
          minDistance = distance;
        }
      } else if (point.dx > centerX) {
        if (distance < 10) {
          maxDistances.add(point.dx);
        }

        if (distance > maxDistance) {
          maxX = point.dx;
          maxDistance = distance;
        }
      }
    }
  }

  mapModel.shapeWidth =
      max(maxX, maxDistances.reduce(max)) - min(minX, minDistances.reduce(min));
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
