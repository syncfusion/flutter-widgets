import 'package:flutter/foundation.dart';

import '../treemap.dart';
import 'layouts.dart';

/// Drilled in and out call back
typedef DrillDownCallback = void Function(TreemapTile tile, bool isDrilledIn);

/// Whenever the user modifies a selection, hover or drilldown, the controller
/// notifies its listeners.
class TreemapController {
  ObserverList<VoidCallback>? _selectionListeners =
      ObserverList<VoidCallback>();
  ObserverList<VoidCallback>? _hoverListeners = ObserverList<VoidCallback>();
  ObserverList<DrillDownCallback>? _drillDownListeners =
      ObserverList<DrillDownCallback>();

  /// Register method that will be called when the selection is changed.
  void addSelectionListener(VoidCallback listener) {
    _selectionListeners?.add(listener);
  }

  /// Register method that will be called when the hover is changed.
  void addHoverListener(VoidCallback listener) {
    _hoverListeners?.add(listener);
  }

  /// Register method that will be called when the drilldown visible index is
  /// changed.
  void addDrillDownListener(DrillDownCallback listener) {
    _drillDownListeners?.add(listener);
  }

  /// Remove a previously register selection method.
  void removeSelectionListener(VoidCallback listener) {
    _selectionListeners?.remove(listener);
  }

  /// Remove a previously register selection method.
  void removeHoverListener(VoidCallback listener) {
    _hoverListeners?.remove(listener);
  }

  /// Remove a previously register selection method.
  void removeDrillDownListener(DrillDownCallback listener) {
    _drillDownListeners?.remove(listener);
  }

  /// This method should be called whenever the selection changes.
  void notifySelectionListeners() {
    for (final VoidCallback listener in _selectionListeners!) {
      listener();
    }
  }

  /// This method should be called whenever the hover changes.
  void notifyHoverListeners() {
    for (final VoidCallback listener in _hoverListeners!) {
      listener();
    }
  }

  /// This method should be called whenever the drilldown visible index changes.
  void notifyDrilldownListeners(TreemapTile tile, bool isDrilledIn) {
    for (final DrillDownCallback listener in _drillDownListeners!) {
      listener(tile, isDrilledIn);
    }
  }

  /// Previous selected tile.
  TreemapTile? get previousSelectedTile => _previousSelectedTile;
  TreemapTile? _previousSelectedTile;

  /// Current selected tile.
  TreemapTile? get selectedTile => _selectedTile;
  TreemapTile? _selectedTile;
  set selectedTile(TreemapTile? value) {
    _previousSelectedTile = _selectedTile;
    _selectedTile = _selectedTile == value ? null : value;
    notifySelectionListeners();
  }

  /// Previous hovered tile.
  TreemapTile? get previousHoveredTile => _previousHoveredTile;
  TreemapTile? _previousHoveredTile;

  /// Current hover tile.
  TreemapTile? get hoveredTile => _hoveredTile;
  TreemapTile? _hoveredTile;
  set hoveredTile(TreemapTile? value) {
    if (_hoveredTile == value) {
      return;
    }
    _previousHoveredTile = _hoveredTile;
    _hoveredTile = value;
    notifyHoverListeners();
  }

  /// Previous drilldown index.
  int get previousVisibleLevelIndex => _previousVisibleLevelIndex;
  int _previousVisibleLevelIndex = -1;

  /// Current drill down index.
  int get visibleLevelIndex => _visibleLevelIndex;
  int _visibleLevelIndex = 0;
  set visibleLevelIndex(int value) {
    if (_visibleLevelIndex == value) {
      return;
    }
    _previousVisibleLevelIndex = _visibleLevelIndex;
    _visibleLevelIndex = value;
  }

  /// Removes all of the object's resources. The object is no longer useable
  /// and should be removed when this method is called.
  void dispose() {
    _selectionListeners = null;
    _hoverListeners = null;
    _drillDownListeners = null;
  }
}
