import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../maps.dart';
import '../common.dart';
import '../utils.dart';

// ignore_for_file: public_member_api_docs
typedef _ZoomingCallback = void Function(MapZoomDetails details);

typedef _PanningCallback = void Function(MapPanDetails details);

typedef _ZoomToCallback = void Function(double factor);

typedef _PanToCallback = void Function(MapLatLng? latlng);

class MapController {
  final List<int> _toggledIndices = <int>[];
  List<int> get toggledIndices => _toggledIndices;
  ObserverList<VoidCallback>? _listeners = ObserverList<VoidCallback>();
  ObserverList<_ZoomingCallback>? _zoomingListeners =
      ObserverList<_ZoomingCallback>();
  ObserverList<_PanningCallback>? _panningListeners =
      ObserverList<_PanningCallback>();
  ObserverList<VoidCallback>? _refreshListeners = ObserverList<VoidCallback>();
  ObserverList<VoidCallback>? _resetListeners = ObserverList<VoidCallback>();
  ObserverList<VoidCallback>? _toggledListeners = ObserverList<VoidCallback>();
  ObserverList<VoidCallback>? _zoomPanListeners = ObserverList<VoidCallback>();

  double shapeLayerSizeFactor = 1.0;
  double localScale = 1.0;
  double tileLayerLocalScale = 1.0;
  bool isInInteractive = false;
  Offset pinchCenter = Offset.zero;
  Offset panDistance = Offset.zero;
  Offset normalize = Offset.zero;
  Offset shapeLayerOrigin = Offset.zero;
  Rect currentBounds = Rect.zero;

  late _ZoomToCallback onZoomLevelChange;
  late _PanToCallback onPanChange;
  late Size shapeLayerBoxSize;
  late Offset shapeLayerOffset;
  late double tileZoomLevel;
  late TileZoomLevelDetails tileCurrentLevelDetails;

  GlobalKey? tooltipKey;
  Size? tileLayerBoxSize;
  Gesture? gesture;
  MapLatLng? visibleFocalLatLng;
  Rect? visibleBounds;
  MapLatLngBounds? visibleLatLngBounds;
  Size? totalTileSize;
  LayerType? layerType;

  // Stores the index of current tapped item which is used
  // to identify whether the legend item is toggled or un-toggled.
  int _currentToggledItemIndex = -1;
  int get currentToggledItemIndex => _currentToggledItemIndex;
  set currentToggledItemIndex(int value) {
    // Having possibilities to get same value in the [_currentToggledItemIndex]
    // When the same index is toggled and un-toggled, without toggling other
    // item. By considering this scenario, return condition is avoided here.
    _currentToggledItemIndex = value;

    if (_currentToggledItemIndex != -1) {
      notifyToggleListeners();
    }
  }

  void addToggleListener(VoidCallback listener) {
    _toggledListeners?.add(listener);
  }

  void removeToggleListener(VoidCallback listener) {
    _toggledListeners?.remove(listener);
  }

  void notifyToggleListeners() {
    for (final VoidCallback listener in _toggledListeners!) {
      listener();
    }
  }

  void addZoomPanListener(VoidCallback listener) {
    _zoomPanListeners?.add(listener);
  }

  void removeZoomPanListener(VoidCallback listener) {
    _zoomPanListeners?.remove(listener);
  }

  void notifyZoomPanListeners() {
    for (final VoidCallback listener in _zoomPanListeners!) {
      listener();
    }
  }

  bool wasToggled(MapModel model) {
    return toggledIndices.contains(model.legendMapperIndex);
  }

  void addZoomingListener(_ZoomingCallback listener) {
    _zoomingListeners?.add(listener);
  }

  void removeZoomingListener(_ZoomingCallback listener) {
    _zoomingListeners?.remove(listener);
  }

  void addPanningListener(_PanningCallback listener) {
    _panningListeners?.add(listener);
  }

  void removePanningListener(_PanningCallback listener) {
    _panningListeners?.remove(listener);
  }

  void addResetListener(VoidCallback listener) {
    _resetListeners?.add(listener);
  }

  void removeResetListener(VoidCallback listener) {
    _resetListeners?.remove(listener);
  }

  void addRefreshListener(VoidCallback listener) {
    _refreshListeners?.add(listener);
  }

  void removeRefreshListener(VoidCallback listener) {
    _refreshListeners?.remove(listener);
  }

  void addListener(VoidCallback listener) {
    _listeners?.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners?.remove(listener);
  }

  void notifyZoomingListeners(MapZoomDetails details) {
    for (final _ZoomingCallback listener in _zoomingListeners!) {
      listener(details);
    }
  }

  void notifyPanningListeners(MapPanDetails details) {
    for (final _PanningCallback listener in _panningListeners!) {
      listener(details);
    }
  }

  void notifyResetListeners() {
    for (final VoidCallback listener in _resetListeners!) {
      listener();
    }
  }

  void notifyRefreshListeners() {
    for (final VoidCallback listener in _refreshListeners!) {
      listener();
    }
  }

  void notifyListeners() {
    for (final VoidCallback listener in _listeners!) {
      listener();
    }
  }

  void updateVisibleBounds([Offset? translation, double? factor]) {
    factor ??= shapeLayerSizeFactor;
    translation ??= shapeLayerOffset;
    visibleFocalLatLng = getVisibleFocalLatLng(translation, factor);
    visibleBounds = getVisibleBounds(translation, factor, visibleFocalLatLng);
    visibleLatLngBounds = getVisibleLatLngBounds(visibleBounds!.topRight,
        visibleBounds!.bottomLeft, translation, factor);
  }

  MapLatLng getVisibleFocalLatLng([Offset? translation, double? factor]) {
    factor ??= shapeLayerSizeFactor;
    translation ??= shapeLayerOffset;
    return pixelToLatLng(
        Offset(shapeLayerBoxSize.width / 2, shapeLayerBoxSize.height / 2),
        shapeLayerBoxSize,
        translation,
        factor);
  }

  Rect getVisibleBounds(
      [Offset? translation, double? factor, MapLatLng? focalLatLng]) {
    factor ??= shapeLayerSizeFactor;
    translation ??= shapeLayerOffset;
    focalLatLng ??= getVisibleFocalLatLng(translation, factor);
    return Rect.fromCenter(
        center: pixelFromLatLng(
            visibleFocalLatLng!.latitude,
            visibleFocalLatLng!.longitude,
            shapeLayerBoxSize,
            translation,
            factor),
        width: shapeLayerBoxSize.width,
        height: shapeLayerBoxSize.height);
  }

  MapLatLngBounds getVisibleLatLngBounds(Offset topRight, Offset bottomLeft,
      [Offset? translation, double? factor]) {
    factor ??= shapeLayerSizeFactor;
    translation ??= shapeLayerOffset;
    return MapLatLngBounds(
        pixelToLatLng(topRight, shapeLayerBoxSize, translation, factor),
        pixelToLatLng(bottomLeft, shapeLayerBoxSize, translation, factor));
  }

  Offset getZoomingTranslation(
      {Offset? origin, double? scale, Offset? previousOrigin}) {
    origin ??= pinchCenter;
    scale ??= localScale;
    previousOrigin ??= shapeLayerOffset;
    final double width = shapeLayerBoxSize.width;
    final double height = shapeLayerBoxSize.height;
    final double diffWidth = width - width * scale;
    final double diffHeight = height - height * scale;
    final double dx = diffWidth * (origin.dx - previousOrigin.dx) / width;
    final double dy = diffHeight * (origin.dy - previousOrigin.dy) / height;
    return previousOrigin + Offset(dx, dy);
  }

  Size getTileSize([double? zoomLevel]) {
    zoomLevel ??= tileZoomLevel;
    return Size.square(256 * pow(2, zoomLevel).toDouble());
  }

  void applyTransform(PaintingContext context, Offset offset,
      [bool isVectorLayer = false]) {
    if (isVectorLayer && layerType == LayerType.tile) {
      context.canvas
        ..translate(offset.dx + tileCurrentLevelDetails.translatePoint.dx,
            offset.dy + tileCurrentLevelDetails.translatePoint.dy)
        ..scale(tileCurrentLevelDetails.scale);
    } else {
      switch (gesture) {
        case Gesture.scale:
          // Translating to the focal point
          // which we got from [ScaleUpdateDetails.localFocalPoint].
          context.canvas
            ..translate(offset.dx + pinchCenter.dx + normalize.dx,
                offset.dy + pinchCenter.dy + normalize.dy)
            ..scale(localScale)
            // Moving back to the original position to draw shapes.
            ..translate(-pinchCenter.dx, -pinchCenter.dy);
          break;
        case Gesture.pan:
          context.canvas.translate(
              offset.dx + panDistance.dx, offset.dy + panDistance.dy);
          break;
        default:
          context.canvas
              .translate(offset.dx + normalize.dx, offset.dy + normalize.dy);
      }
    }
  }

  void dispose() {
    _listeners = null;
    _toggledListeners = null;
    _zoomPanListeners = null;
    _zoomingListeners = null;
    _panningListeners = null;
    _resetListeners = null;
    _refreshListeners = null;
  }
}
