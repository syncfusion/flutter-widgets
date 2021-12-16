import 'package:flutter/foundation.dart';

import '../common.dart';

typedef _ListenerEntry = void Function(MarkerAction action,
    [List<int>? indices]);

/// Base class of [MapShapeLayerController] and [MapTileLayerController].
abstract class MapLayerController extends ChangeNotifier {
  ObserverList<_ListenerEntry>? _listeners = ObserverList<_ListenerEntry>();

  /// Adds marker dynamically in the provided index.
  ///
  /// If the [MapShapeLayer.initialMarkersCount] is 10 and if the index given
  /// for the [insertMarker] method is 10 which is greater than the available
  /// indices, then the marker will be added as a last item.
  ///
  /// See also:
  /// * [MapShapeLayer.markerBuilder], to return the [MapMarker].
  void insertMarker(int index) {
    _notifyMarkerListeners(MarkerAction.insert, <int>[index]);
  }

  /// Removes the marker in the provided index.
  void removeMarkerAt(int index) {
    _notifyMarkerListeners(MarkerAction.removeAt, <int>[index]);
  }

  /// Updates the markers in the given indices dynamically.
  /// See also:
  /// * [MapShapeLayer.markerBuilder], to return the updated [MapMarker].
  void updateMarkers(List<int> indices) {
    _notifyMarkerListeners(MarkerAction.replace, indices);
  }

  /// Clears all the markers.
  void clearMarkers() {
    _notifyMarkerListeners(MarkerAction.clear);
  }

  /// Call all the registered listeners.
  void _notifyMarkerListeners(MarkerAction action, [List<int>? indices]) {
    for (final _ListenerEntry listener in _listeners!) {
      listener(action, indices);
    }
  }

  @override
  void addListener(Object listener) {
    if (listener is _ListenerEntry) {
      _listeners!.add(listener);
    } else {
      // ignore: avoid_as
      super.addListener(listener as VoidCallback);
    }
  }

  @override
  void removeListener(Object listener) {
    if (listener is _ListenerEntry) {
      _listeners!.remove(listener);
    } else {
      // ignore: avoid_as
      super.removeListener(listener as VoidCallback);
    }
  }

  @override
  void dispose() {
    _listeners = null;
    super.dispose();
  }
}
