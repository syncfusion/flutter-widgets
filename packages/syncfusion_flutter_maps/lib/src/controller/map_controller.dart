import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../maps.dart';
import '../common.dart';
import '../utils.dart';

// ignore_for_file: public_member_api_docs
typedef ZoomingCallback = void Function(MapZoomDetails details);

typedef PanningCallback = void Function(MapPanDetails details);

typedef ZoomToCallback = void Function(double factor);

typedef PanToCallback = void Function(MapLatLng? latlng);

class MapController {
  final List<int> _toggledIndices = <int>[];
  List<int> get toggledIndices => _toggledIndices;
  ObserverList<VoidCallback>? _listeners = ObserverList<VoidCallback>();
  ObserverList<ZoomingCallback>? _zoomingListeners =
      ObserverList<ZoomingCallback>();
  ObserverList<PanningCallback>? _panningListeners =
      ObserverList<PanningCallback>();
  ObserverList<VoidCallback>? _refreshListeners = ObserverList<VoidCallback>();
  ObserverList<VoidCallback>? _resetListeners = ObserverList<VoidCallback>();
  ObserverList<VoidCallback>? _toggledListeners = ObserverList<VoidCallback>();
  ObserverList<VoidCallback>? _zoomPanListeners = ObserverList<VoidCallback>();
  ObserverList<ZoomToCallback>? _toolbarZoomedListeners =
      ObserverList<ZoomToCallback>();

  double shapeLayerSizeFactor = 1.0;
  double localScale = 1.0;
  double tileLayerLocalScale = 1.0;
  bool isInInteractive = false;
  Offset pinchCenter = Offset.zero;
  Offset panDistance = Offset.zero;
  Offset normalize = Offset.zero;
  Offset shapeLayerOrigin = Offset.zero;
  Rect currentBounds = Rect.zero;

  late ZoomToCallback onZoomLevelChange;
  late PanToCallback onPanChange;
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

  void addZoomingListener(ZoomingCallback listener) {
    _zoomingListeners?.add(listener);
  }

  void removeZoomingListener(ZoomingCallback listener) {
    _zoomingListeners?.remove(listener);
  }

  void addToolbarZoomedListener(ZoomToCallback listener) {
    _toolbarZoomedListeners?.add(listener);
  }

  void removeToolbarZoomedListener(ZoomToCallback listener) {
    _toolbarZoomedListeners?.remove(listener);
  }

  void addPanningListener(PanningCallback listener) {
    _panningListeners?.add(listener);
  }

  void removePanningListener(PanningCallback listener) {
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
    for (final ZoomingCallback listener in _zoomingListeners!) {
      listener(details);
    }
  }

  void notifyToolbarZoomedListeners(double newZoomLevel) {
    for (final ZoomToCallback listener in _toolbarZoomedListeners!) {
      listener(newZoomLevel);
    }
  }

  void notifyPanningListeners(MapPanDetails details) {
    for (final PanningCallback listener in _panningListeners!) {
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
        // ignore: no_default_cases
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
    _toolbarZoomedListeners = null;
  }
}
