part of maps;

typedef _ZoomingCallback = void Function(MapZoomDetails details);

typedef _PanningCallback = void Function(MapPanDetails details);

typedef _ZoomToCallback = void Function(double factor, {MapLatLng latlng});

typedef _PanToCallback = void Function(MapLatLng latlng);

class _DefaultController {
  final List<int> _toggledIndices = <int>[];
  List<int> get toggledIndices => _toggledIndices;
  ObserverList<VoidCallback> _listeners = ObserverList<VoidCallback>();
  ObserverList<_ZoomingCallback> _zoomingListeners =
      ObserverList<_ZoomingCallback>();
  ObserverList<_PanningCallback> _panningListeners =
      ObserverList<_PanningCallback>();
  ObserverList<VoidCallback> _resetListeners = ObserverList<VoidCallback>();
  ObserverList<VoidCallback> _toggledListeners = ObserverList<VoidCallback>();

  _ZoomToCallback onZoomLevelChange;
  _PanToCallback onPanChange;

  Size shapeLayerBoxSize;
  double shapeLayerSizeFactor = 1.0;
  Offset shapeLayerOffset;
  Offset shapeLayerOrigin;
  _Gesture gesture;
  MapLatLng visibleFocalLatLng;
  Rect visibleBounds;
  MapLatLngBounds visibleLatLngBounds;
  double localScale = 1.0;
  bool isInInteractive = false;
  Offset pinchCenter = Offset.zero;
  Offset panDistance = Offset.zero;
  Offset adjustment = Offset.zero;
  Rect currentBounds = Rect.zero;

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
    _toggledListeners.add(listener);
  }

  void removeToggleListener(VoidCallback listener) {
    _toggledListeners?.remove(listener);
  }

  void notifyToggleListeners() {
    for (final VoidCallback listener in _toggledListeners) {
      listener();
    }
  }

  bool wasToggled(_MapModel model) {
    return toggledIndices.contains(model.legendMapperIndex);
  }

  void addZoomingListener(_ZoomingCallback listener) {
    _zoomingListeners.add(listener);
  }

  void removeZoomingListener(_ZoomingCallback listener) {
    _zoomingListeners?.remove(listener);
  }

  void addPanningListener(_PanningCallback listener) {
    _panningListeners.add(listener);
  }

  void removePanningListener(_PanningCallback listener) {
    _panningListeners?.remove(listener);
  }

  void addResetListener(VoidCallback listener) {
    _resetListeners.add(listener);
  }

  void removeResetListener(VoidCallback listener) {
    _resetListeners.remove(listener);
  }

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void notifyZoomingListeners(MapZoomDetails details) {
    for (final _ZoomingCallback listener in _zoomingListeners) {
      listener(details);
    }
  }

  void notifyPanningListeners(MapPanDetails details) {
    for (final _PanningCallback listener in _panningListeners) {
      listener(details);
    }
  }

  void notifyResetListeners() {
    for (final VoidCallback listener in _resetListeners) {
      listener();
    }
  }

  void notifyListeners() {
    for (final VoidCallback listener in _listeners) {
      listener();
    }
  }

  void updateVisibleBounds([Offset translation, double factor]) {
    factor ??= shapeLayerSizeFactor;
    translation ??= shapeLayerOffset;
    visibleFocalLatLng = getVisibleFocalLatLng(translation, factor);
    visibleBounds = getVisibleBounds(translation, factor, visibleFocalLatLng);
    visibleLatLngBounds = getVisibleLatLngBounds(
        visibleBounds.topRight, visibleBounds.bottomLeft, translation, factor);
  }

  MapLatLng getVisibleFocalLatLng([Offset translation, double factor]) {
    factor ??= shapeLayerSizeFactor;
    translation ??= shapeLayerOffset;
    return _pixelToLatLng(
        Offset(shapeLayerBoxSize.width / 2, shapeLayerBoxSize.height / 2),
        shapeLayerBoxSize,
        translation,
        factor);
  }

  Rect getVisibleBounds(
      [Offset translation, double factor, MapLatLng focalLatLng]) {
    factor ??= shapeLayerSizeFactor;
    translation ??= shapeLayerOffset;
    focalLatLng ??= getVisibleFocalLatLng(translation, factor);
    return Rect.fromCenter(
        center: _pixelFromLatLng(
            visibleFocalLatLng.latitude,
            visibleFocalLatLng.longitude,
            shapeLayerBoxSize,
            translation,
            factor),
        width: shapeLayerBoxSize.width,
        height: shapeLayerBoxSize.height);
  }

  MapLatLngBounds getVisibleLatLngBounds(Offset topRight, Offset bottomLeft,
      [Offset translation, double factor]) {
    factor ??= shapeLayerSizeFactor;
    translation ??= shapeLayerOffset;
    return MapLatLngBounds(
        _pixelToLatLng(topRight, shapeLayerBoxSize, translation, factor),
        _pixelToLatLng(bottomLeft, shapeLayerBoxSize, translation, factor));
  }

  Offset getZoomingTranslation(
      {Offset origin, double scale, Offset previousOrigin}) {
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

  void applyTransform(PaintingContext context, Offset offset) {
    switch (gesture) {
      case _Gesture.scale:
        // Translating to the focal point
        // which we got from [ScaleUpdateDetails.localFocalPoint].
        context.canvas
          ..translate(offset.dx + pinchCenter.dx + adjustment.dx,
              offset.dy + pinchCenter.dy + adjustment.dy)
          ..scale(localScale)
          // Moving back to the original position to draw shapes.
          ..translate(-pinchCenter.dx, -pinchCenter.dy);
        break;
      case _Gesture.pan:
        context.canvas
            .translate(offset.dx + panDistance.dx, offset.dy + panDistance.dy);
        break;
      default:
        context.canvas
            .translate(offset.dx + adjustment.dx, offset.dy + adjustment.dy);
    }
  }

  void dispose() {
    _listeners = null;
    _toggledListeners = null;
    _zoomingListeners = null;
    _panningListeners = null;
    _resetListeners = null;
  }
}
