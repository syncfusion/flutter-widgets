import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../maps.dart';
import '../common.dart';
import '../controller/map_controller.dart';
import '../elements/marker.dart';
import '../elements/toolbar.dart';
import '../elements/tooltip.dart';
import '../layer/layer_base.dart';
import '../layer/vector_layers.dart';
import '../settings.dart';
import '../utils.dart';

Offset _pixelFromLatLng(MapLatLng latLng, double scale) {
  final double latitude =
      latLng.latitude.clamp(minimumLatitude, maximumLatitude);
  final double longitude =
      latLng.longitude.clamp(minimumLongitude, maximumLongitude);
  return pixelFromLatLng(
      latitude, longitude, Size.square(getTotalTileWidth(scale)));
}

MapLatLng _pixelToLatLng(Offset point, double scale) {
  return pixelToLatLng(point, Size.square(getTotalTileWidth(scale)));
}

/// Represents the tile factor like x position, y position and scale value.
@immutable
class _MapTileCoordinate {
  /// Creates a [_MapTileCoordinate].
  const _MapTileCoordinate(this.x, this.y, this.z);

  /// Represents the x-coordinate of the tile.
  final int x;

  /// Represents the y-coordinate of the tile.
  final int y;

  /// Represents the scale value of the tile.
  final int z;

  double distanceTo(Offset startPoint, Offset endPoint) {
    final double dx = startPoint.dx - endPoint.dx;
    final double dy = startPoint.dy - endPoint.dy;
    return sqrt(dx * dx + dy * dy);
  }

  @override
  String toString() => '_MapTileCoordinate($x, $y, $z)';

  @override
  bool operator ==(dynamic other) {
    if (other is _MapTileCoordinate) {
      return x == other.x && y == other.y && z == other.z;
    }
    return false;
  }

  @override
  int get hashCode => hashValues(x.hashCode, y.hashCode, z.hashCode);
}

/// Represents the information about the tile.
@immutable
class _MapTile {
  /// Creates a [_MapTile].
  const _MapTile({
    required this.xyzKey,
    required this.coordinates,
    required this.tilePos,
    required this.level,
    required this.image,
  });

  /// Provides a unique key for each tile. The format of [xyzKey] looks `x:y:z`,
  /// where z denotes zoom level, x and y denotes tile coordinates.
  final String xyzKey;

  /// Represents the tile x-position, y-position and scale value.
  final _MapTileCoordinate coordinates;

  /// Represents the tile left and top position.
  final Offset tilePos;

  /// Represents the scale transform details of the tile.
  final TileZoomLevelDetails level;

  /// Add tile to the image.
  final Widget image;

  @override
  int get hashCode => coordinates.hashCode;

  @override
  bool operator ==(Object other) {
    return other is _MapTile && coordinates == other.coordinates;
  }
}

/// Provides options for adding, removing, deleting, updating markers
/// collection and converting pixel points to latitude and longitude.
class MapTileLayerController extends MapLayerController {
  /// Creates of [_TileLayerState].
  late _TileLayerState _state;

  /// Returns the current markers count.
  int get markersCount => _markersCount;
  int _markersCount = 0;

  /// Converts pixel point to [MapLatLng].
  MapLatLng pixelToLatLng(Offset position) {
    final Offset localPointCenterDiff = Offset(
        (_state._size!.width / 2) - position.dx,
        (_state._size!.height / 2) - position.dy);
    final Offset actualCenterPixelPosition =
        _pixelFromLatLng(_state._currentFocalLatLng, _state._currentZoomLevel);
    final Offset newCenterPoint =
        actualCenterPixelPosition - localPointCenterDiff;
    return _pixelToLatLng(newCenterPoint, _state._currentZoomLevel);
  }
}

// ignore_for_file: public_member_api_docs
class TileLayer extends StatefulWidget {
  const TileLayer({
    required this.urlTemplate,
    required this.initialFocalLatLng,
    required this.initialZoomLevel,
    required this.zoomPanBehavior,
    required this.sublayers,
    required this.initialMarkersCount,
    required this.markerBuilder,
    required this.markerTooltipBuilder,
    required this.tooltipSettings,
    required this.controller,
    required this.onWillZoom,
    required this.onWillPan,
    required this.isTransparent,
  });

  final String urlTemplate;
  final MapLatLng initialFocalLatLng;
  final int initialZoomLevel;
  final MapZoomPanBehavior? zoomPanBehavior;
  final List<MapSublayer>? sublayers;
  final int initialMarkersCount;
  final MapMarkerBuilder? markerBuilder;
  final IndexedWidgetBuilder? markerTooltipBuilder;
  final MapTooltipSettings tooltipSettings;
  final MapTileLayerController? controller;
  final WillZoomCallback? onWillZoom;
  final WillPanCallback? onWillPan;
  final bool isTransparent;

  @override
  _TileLayerState createState() => _TileLayerState();
}

class _TileLayerState extends State<TileLayer> with TickerProviderStateMixin {
  // Both width and height of each tile is 256.
  static const double tileSize = 256;
  static const double _frictionCoefficient = 0.05;
  // The [globalTileStart] represents the tile start factor value based on
  // the zoom level.
  static const Offset _globalTileStart = Offset.zero;

  final Map<String, _MapTile> _tiles = <String, _MapTile>{};
  final Map<double, TileZoomLevelDetails> _levels =
      <double, TileZoomLevelDetails>{};

  late double _currentZoomLevel;
  late int _nextZoomLevel;
  late double _touchStartZoomLevel;
  late MapLatLng _touchStartLatLng;
  late MapLatLng _currentFocalLatLng;
  late Offset _touchStartLocalPoint;
  late Offset _touchStartGlobalPoint;
  late bool _isDesktop;
  late double _maximumReachedScaleOnInteraction;
  late MapLatLng _newFocalLatLng;
  late SfMapsThemeData _mapsThemeData;
  late MapLayerInheritedWidget _ancestor;
  late AnimationController _zoomLevelAnimationController;
  late AnimationController _focalLatLngAnimationController;
  late CurvedAnimation _flingZoomLevelCurvedAnimation;
  late CurvedAnimation _flingFocalLatLngCurvedAnimation;
  late CurvedAnimation _zoomLevelCurvedAnimation;
  late CurvedAnimation _focalLatLngCurvedAnimation;
  late MapLatLngTween _focalLatLngTween;
  late Tween<double> _zoomLevelTween;

  Size? _size;
  MapController? _controller;
  int _pointerCount = 0;
  Gesture? _gestureType;
  Timer? _doubleTapTimer;
  bool _isSizeChanged = false;
  bool _hasSublayer = false;
  bool _isZoomedUsingToolbar = false;
  bool _isFlingAnimationActive = false;
  bool _doubleTapEnabled = false;
  List<Widget>? _markers;
  MapZoomDetails? _zoomDetails;
  MapPanDetails? _panDetails;
  Timer? _zoomingDelayTimer;
  MapLatLng? _mouseCenterLatLng;
  double? _mouseStartZoomLevel;
  Offset? _mouseStartLocalPoint;
  Offset? _mouseStartGlobalPoint;
  Offset? _touchStartOffset;

  bool _hasTooltipBuilder() {
    if (widget.markerTooltipBuilder != null) {
      return true;
    } else if (_hasSublayer) {
      final Iterator<MapSublayer> iterator = widget.sublayers!.iterator;
      while (iterator.moveNext()) {
        final MapSublayer sublayer = iterator.current;
        if ((sublayer is MapShapeSublayer &&
                (sublayer.shapeTooltipBuilder != null ||
                    sublayer.bubbleTooltipBuilder != null ||
                    sublayer.markerTooltipBuilder != null)) ||
            (sublayer is MapVectorLayer && sublayer.tooltipBuilder != null)) {
          return true;
        }
      }
    }
    return false;
  }

  // Generate tiles for the visible bounds and placed the tiles in a positioned
  // widget.
  Widget _buildTiles() {
    // Calculate new visible bounds based on the [_currentFocalLatLng] value
    // and request new tiles for the visible bounds. This method called only
    // when new zoom level reached.
    _requestAndPopulateNewTiles();
    // The populated tiles are stored in the [_tiles] collection field.
    final List<_MapTile> tiles = _tiles.values.toList();
    final List<Widget> positionedTiles = <Widget>[];
    for (final _MapTile tile in tiles) {
      positionedTiles.add(_getPositionedTiles(tile));
    }

    return Stack(children: positionedTiles);
  }

  // Generate tiles for the new zoom level based on the focalLatLng value.
  void _requestAndPopulateNewTiles() {
    _updateZoomLevel();
    final double tileCount = pow(2, _nextZoomLevel).toDouble();
    final Offset actualCenterPixelPosition =
        _pixelFromLatLng(_currentFocalLatLng, _currentZoomLevel);
    final Rect newVisibleBounds = Rect.fromCenter(
        center: actualCenterPixelPosition,
        width: _size!.width,
        height: _size!.height);
    final MapLatLngBounds visibleLatLngBounds = MapLatLngBounds(
        _pixelToLatLng(newVisibleBounds.topRight, _currentZoomLevel),
        _pixelToLatLng(newVisibleBounds.bottomLeft, _currentZoomLevel));
    _updateVisibleBounds(visibleLatLngBounds);
    final Offset halfSize = Offset(_size!.width, _size!.height) / 2;

    // The [globalTileEnd] represents the tile end factor value based on
    // the zoom level.
    final Offset globalTileEnd = Offset(tileCount - 1, tileCount - 1);

    // The [visualTileStart] and [visualTileEnd] represents the visual
    // bounds of the tiles in pixel based on the [focalLatLng] value.
    final Offset visualTileStart = actualCenterPixelPosition - halfSize;
    final Offset visualTileEnd = actualCenterPixelPosition + halfSize;
    final double currentLevelTileSize =
        tileSize * _levels[_nextZoomLevel]!.scale;

    // The [startX], [startY], [endX] and [endY] represents the visual
    // bounds of the tiles in factor.
    final int startX = (visualTileStart.dx / currentLevelTileSize).floor();
    final int startY = (visualTileStart.dy / currentLevelTileSize).floor();
    final int endX = (visualTileEnd.dx / currentLevelTileSize).ceil();
    final int endY = (visualTileEnd.dy / currentLevelTileSize).ceil();
    final List<_MapTileCoordinate> tileCoordinates = <_MapTileCoordinate>[];

    for (int i = startX; i <= endX; i++) {
      for (int j = startY; j <= endY; j++) {
        final _MapTileCoordinate tileCoordinate =
            _MapTileCoordinate(i, j, _nextZoomLevel);

        if ((tileCoordinate.x < _globalTileStart.dx ||
                tileCoordinate.x > globalTileEnd.dx) ||
            (tileCoordinate.y < _globalTileStart.dy ||
                tileCoordinate.y > globalTileEnd.dy)) {
          continue;
        }

        final _MapTile? tile = _tiles[_tileFactorToKey(tileCoordinate)];
        if (tile != null) {
          continue;
        } else {
          tileCoordinates.add(tileCoordinate);
        }
      }
    }

    final Offset tileCenter = Offset((startX + endX) / 2, (startY + endY) / 2);
    tileCoordinates.sort((_MapTileCoordinate a, _MapTileCoordinate b) =>
        (a.distanceTo(Offset(a.x.toDouble(), a.y.toDouble()), tileCenter) -
                b.distanceTo(
                    Offset(b.x.toDouble(), b.y.toDouble()), tileCenter))
            .toInt());

    for (int i = 0; i < tileCoordinates.length; i++) {
      _addTile(tileCoordinates[i]);
    }
  }

  void _updateVisibleBounds(MapLatLngBounds latLngBounds) {
    final TileZoomLevelDetails level = _levels[_nextZoomLevel]!;
    Offset topRight =
        _pixelFromLatLng(latLngBounds.northeast, level.zoomLevel) -
            level.origin!;
    // Adjust the topRight value based on the current scale value.
    topRight = Offset(topRight.dx * level.scale, topRight.dy * level.scale) +
        level.translatePoint;
    Offset bottomLeft =
        _pixelFromLatLng(latLngBounds.southwest, level.zoomLevel) -
            level.origin!;
    // Adjust the bottomLeft value based on the current scale value.
    bottomLeft =
        Offset(bottomLeft.dx * level.scale, bottomLeft.dy * level.scale) +
            level.translatePoint;
    _controller!.visibleBounds = Rect.fromPoints(bottomLeft, topRight);
  }

  // Calculate tiles visual bounds origin for each new zoom level.
  TileZoomLevelDetails? _updateZoomLevel() {
    final int zoom = _nextZoomLevel;

    // Remove zoom-out level tiles from the [_tiles] collection when doing
    // zoom-out action.
    final List<double> removePrevLevels = <double>[];
    final int levelsCount = _levels.entries.length;
    for (final MapEntry<double, TileZoomLevelDetails> level
        in _levels.entries) {
      final double key = level.key;

      if (levelsCount > 1) {
        if (!widget.isTransparent) {
          if (key > zoom) {
            removePrevLevels.add(key);
          }
        } else if (zoom != key) {
          removePrevLevels.add(key);
        }
      }
    }

    for (final double levelKey in removePrevLevels) {
      _removeTilesAtZoom(levelKey);
      _levels.remove(levelKey);
    }

    TileZoomLevelDetails? level = _levels[zoom];
    if (level == null) {
      // The [_levels] collection contains each integer zoom level origin,
      // scale and translationPoint. The scale and translationPoint are
      // calculated in every pinch zoom level for scaling the tiles.
      level = _levels[zoom.toDouble()] = TileZoomLevelDetails();
      level.origin = _getLevelOrigin(_currentFocalLatLng, zoom.toDouble());
      level.zoomLevel = zoom.toDouble();

      if (_gestureType != null && _gestureType == Gesture.scale) {
        _updateZoomLevelTransform(
            level, _currentFocalLatLng, _currentZoomLevel);
      } else {
        level.scale = 1.0;
        level.translatePoint = Offset.zero;
      }
    }

    // Recalculate tiles bounds origin for all existing zoom level
    // when size changed.
    if (_isSizeChanged) {
      _updateZoomLevelTransforms(_currentFocalLatLng, _currentZoomLevel);
    }

    final double totalTileWidth = getTotalTileWidth(level.zoomLevel);
    _controller!
      ..totalTileSize = Size(totalTileWidth, totalTileWidth)
      ..tileCurrentLevelDetails = _levels[_nextZoomLevel]!;
    return level;
  }

  void _removeTilesAtZoom(double zoom) {
    final List<String> removePrevTiles = <String>[];
    for (final MapEntry<String, _MapTile> tile in _tiles.entries) {
      if (tile.value.coordinates.z != zoom) {
        continue;
      }
      removePrevTiles.add(tile.key);
    }
    removePrevTiles.forEach(_removeTile);
  }

  void _removeTile(String key) {
    final _MapTile? tile = _tiles[key];
    if (tile == null) {
      return;
    }

    _tiles.remove(key);
  }

  Offset _getLevelOrigin(MapLatLng center, double zoom) {
    final Offset halfSize = Offset(_size!.width / 2.0, _size!.height / 2.0);
    return _pixelFromLatLng(center, zoom) - halfSize;
  }

  // Calculate amount of scale and translation for each zoom level while
  // scaling.
  void _updateZoomLevelTransform(
      TileZoomLevelDetails level, MapLatLng center, double zoom) {
    if (level.origin == null) {
      return;
    }
    final double currentScale =
        getTotalTileWidth(zoom) / getTotalTileWidth(level.zoomLevel);
    final Offset scaledPixelOrigin = _getLevelOrigin(center, zoom);
    level.translatePoint = Offset(
        (level.origin!.dx * currentScale) - scaledPixelOrigin.dx,
        (level.origin!.dy * currentScale) - scaledPixelOrigin.dy);
    level.scale = currentScale;

    if (level.zoomLevel == _nextZoomLevel) {
      _controller!.tileCurrentLevelDetails.translatePoint =
          level.translatePoint;
      _controller!.tileCurrentLevelDetails.scale = level.scale;
    }
  }

  String _tileFactorToKey(_MapTileCoordinate tileFactor) {
    return '${tileFactor.x}:${tileFactor.y}:${tileFactor.z}';
  }

  // This method is used to request visual tiles and store it in a [_tiles]
  // collection.
  void _addTile(_MapTileCoordinate tileFactor) {
    final String tileFactorToKey = _tileFactorToKey(tileFactor);
    final String url = _getTileUrl(tileFactor.x, tileFactor.y, tileFactor.z);
    final TileZoomLevelDetails level = _levels[tileFactor.z]!;
    final double tileLeftPos = (tileFactor.x * tileSize) - level.origin!.dx;
    final double tileTopPos = (tileFactor.y * tileSize) - level.origin!.dy;

    _tiles[tileFactorToKey] = _MapTile(
      coordinates: tileFactor,
      xyzKey: tileFactorToKey,
      tilePos: Offset(tileLeftPos, tileTopPos),
      level: _levels[tileFactor.z]!,
      image: Image.network(
        url,
        fit: BoxFit.fill,
      ),
    );
  }

  // Converts the [urlTemplate] format into respective map
  // providers URL format.
  String _getTileUrl(int x, int y, int z) {
    String? previousLetter;
    String? currentLetter;
    String url = '';

    if (widget.urlTemplate.contains('{quadkey}')) {
      final String quadKey = _getQuadKey(x, y, z);
      final List<String> splitQuad = widget.urlTemplate.split('{quadkey}');
      url = splitQuad[0] + quadKey + splitQuad[1];
    } else {
      for (int i = 0; i < widget.urlTemplate.length; i++) {
        previousLetter = currentLetter;
        currentLetter = widget.urlTemplate[i];

        if (previousLetter == '{' && widget.urlTemplate[i] == 'x') {
          currentLetter = x.toString();
        } else if (previousLetter == '{' && widget.urlTemplate[i] == 'y') {
          currentLetter = y.toString();
        } else if (previousLetter == '{' && widget.urlTemplate[i] == 'z') {
          currentLetter = z.toString();
        }

        if (widget.urlTemplate[i] != '{' && widget.urlTemplate[i] != '}') {
          url += currentLetter;
        }
      }
    }
    return url;
  }

  // Converts the xyz coordinate into quadKey for bing map.
  String _getQuadKey(int x, int y, int z) {
    final StringBuffer quadKey = StringBuffer();
    for (int i = z; i > 0; i--) {
      int digit = 0;
      final int mask = 1 << (i - 1);
      if ((x & mask) != 0) {
        digit++;
      }
      if ((y & mask) != 0) {
        digit++;
        digit++;
      }
      quadKey.write(digit);
    }
    return quadKey.toString();
  }

  // This method used to move each tile based on the amount of
  // translation and scaling value in the respective levels.
  Widget _getPositionedTiles(_MapTile tile) {
    final Offset tilePos = tile.tilePos;
    final TileZoomLevelDetails level = tile.level;
    final double tileLeftPos =
        (tilePos.dx * level.scale) + level.translatePoint.dx;
    final double tileTopPos =
        (tilePos.dy * level.scale) + level.translatePoint.dy;

    return Positioned(
      left: tileLeftPos,
      top: tileTopPos,
      width: tileSize * level.scale,
      height: tileSize * level.scale,
      child: tile.image,
    );
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (_zoomLevelAnimationController.isAnimating && !_doubleTapEnabled) {
      _zoomLevelAnimationController.stop();
      _isZoomedUsingToolbar = false;
      _handleZoomingAnimationEnd();
    }

    if (_focalLatLngAnimationController.isAnimating) {
      _focalLatLngAnimationController.stop();
      _handleFocalLatLngAnimationEnd();
    }

    if (widget.zoomPanBehavior != null &&
        widget.zoomPanBehavior!.enableDoubleTapZooming) {
      _doubleTapTimer ??= Timer(kDoubleTapTimeout, _resetDoubleTapTimer);
    }

    widget.zoomPanBehavior?.handleEvent(event);
  }

  void _handlePointerMove(PointerMoveEvent event) {
    widget.zoomPanBehavior?.handleEvent(event);
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (_doubleTapTimer != null && _doubleTapTimer!.isActive) {
      _pointerCount++;
    }

    if (_pointerCount == 2) {
      _touchStartLocalPoint = event.localPosition;
      // ignore: avoid_as
      final RenderBox renderBox = context.findRenderObject()! as RenderBox;
      _touchStartGlobalPoint = renderBox.localToGlobal(_touchStartLocalPoint);
      _resetDoubleTapTimer();
      _handleDoubleTap();
    }

    widget.zoomPanBehavior?.handleEvent(event);
  }

  void _resetDoubleTapTimer() {
    _pointerCount = 0;
    if (_doubleTapTimer != null) {
      _doubleTapTimer!.cancel();
      _doubleTapTimer = null;
    }
  }

  // This method called when start pinch zooming or panning action.
  void _handleScaleStart(ScaleStartDetails details) {
    if (widget.zoomPanBehavior != null &&
        !_zoomLevelAnimationController.isAnimating &&
        !_focalLatLngAnimationController.isAnimating) {
      if (widget.zoomPanBehavior!.enablePinching ||
          widget.zoomPanBehavior!.enablePanning) {
        _gestureType = null;
        _touchStartOffset =
            _getTouchStartOffset(details.localFocalPoint, details.focalPoint);
      }
    }
  }

  Offset _getTouchStartOffset(Offset localFocalPoint, Offset globalFocalPoint) {
    _maximumReachedScaleOnInteraction = 1.0;
    _touchStartLocalPoint = localFocalPoint;
    _touchStartGlobalPoint = globalFocalPoint;
    _touchStartZoomLevel = _currentZoomLevel;
    _calculateLatLngFromTappedPoint();
    final MapLatLng touchStartFocalLatLng =
        _calculateVisibleLatLng(_touchStartLocalPoint, _touchStartZoomLevel);
    return _pixelFromLatLng(touchStartFocalLatLng, _touchStartZoomLevel);
  }

  // This method called when doing pinch zooming or panning action.
  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (widget.zoomPanBehavior != null &&
        !_doubleTapEnabled &&
        (widget.zoomPanBehavior!.enablePinching ||
            widget.zoomPanBehavior!.enablePanning)) {
      final double zoomLevel = _touchStartZoomLevel + log(details.scale) / ln2;
      if (zoomLevel > widget.zoomPanBehavior!.maxZoomLevel ||
          zoomLevel < widget.zoomPanBehavior!.minZoomLevel) {
        _resetDoubleTapTimer();
        return;
      }

      _gestureType ??= _getGestureType(details.scale, details.localFocalPoint);
      if (_gestureType == null) {
        return;
      }

      if (_controller!.localScale < details.scale) {
        _maximumReachedScaleOnInteraction = details.scale;
      }

      _resetDoubleTapTimer();
      _controller!.localScale = details.scale;
      final double newZoomLevel =
          _getZoomLevel(_touchStartZoomLevel + log(details.scale) / ln2);
      switch (_gestureType!) {
        case Gesture.scale:
          if (widget.zoomPanBehavior!.enablePinching &&
              !_focalLatLngAnimationController.isAnimating) {
            final MapLatLng newFocalLatLng =
                _calculateVisibleLatLng(_touchStartLocalPoint, newZoomLevel);
            _controller!
              ..isInInteractive = true
              ..gesture = _gestureType
              ..localScale = details.scale
              ..pinchCenter = _touchStartLocalPoint;
            _invokeOnZooming(newZoomLevel, _touchStartLocalPoint,
                _touchStartGlobalPoint, newFocalLatLng);
          }
          return;
        case Gesture.pan:
          if (widget.zoomPanBehavior!.enablePanning &&
              !_zoomLevelAnimationController.isAnimating) {
            _touchStartOffset ??= _getTouchStartOffset(
                details.localFocalPoint, details.focalPoint);
            final MapLatLng newFocalLatLng =
                _calculateVisibleLatLng(details.localFocalPoint, newZoomLevel);
            final Offset newFocalOffset =
                _pixelFromLatLng(newFocalLatLng, newZoomLevel);

            _controller!
              ..isInInteractive = true
              ..gesture = _gestureType
              ..localScale = 1.0
              ..panDistance = _touchStartOffset! - newFocalOffset;
            _invokeOnPanning(newZoomLevel,
                localFocalPoint: details.localFocalPoint,
                globalFocalPoint: details.focalPoint,
                touchStartLocalPoint: _touchStartLocalPoint,
                newFocalLatLng: newFocalLatLng);
          }
          return;
      }
    }
  }

  // This method is called when the pinching or panning action ends.
  void _handleScaleEnd(ScaleEndDetails details) {
    if (widget.zoomPanBehavior != null &&
        details.velocity.pixelsPerSecond.distance >= kMinFlingVelocity) {
      _resetDoubleTapTimer();
      if (_gestureType == Gesture.pan &&
          widget.zoomPanBehavior!.enablePanning &&
          !_zoomLevelAnimationController.isAnimating) {
        _startFlingAnimationForPanning(details);
      } else if (_gestureType == Gesture.scale &&
          widget.zoomPanBehavior!.enablePinching &&
          !_focalLatLngAnimationController.isAnimating) {
        _startFlingAnimationForPinching(details);
      }
    }

    _controller!.localScale = 1.0;
    _touchStartOffset = null;
    _gestureType = null;
    _panDetails = null;
    _zoomDetails = null;
    _invalidateSublayer();
  }

  void _handleDoubleTap() {
    if (_gestureType == null && widget.zoomPanBehavior != null) {
      _zoomLevelAnimationController.duration =
          const Duration(milliseconds: 200);
      _touchStartZoomLevel = _currentZoomLevel;
      _calculateLatLngFromTappedPoint();
      // When double tapping, we had incremented zoom level by one from the
      // currentZoomLevel.
      double newZoomLevel = _currentZoomLevel + 1;
      newZoomLevel = newZoomLevel.clamp(widget.zoomPanBehavior!.minZoomLevel,
          widget.zoomPanBehavior!.maxZoomLevel);
      if (newZoomLevel == _currentZoomLevel) {
        return;
      }
      _doubleTapEnabled = true;
      final MapLatLng newFocalLatLng =
          _calculateVisibleLatLng(_touchStartLocalPoint, newZoomLevel);
      _invokeOnZooming(newZoomLevel, _touchStartLocalPoint,
          _touchStartGlobalPoint, newFocalLatLng);
    }
  }

  // This methods performs fling animation for panning.
  void _startFlingAnimationForPanning(ScaleEndDetails details) {
    _isFlingAnimationActive = true;
    final Offset currentFocalOffset =
        _pixelFromLatLng(_currentFocalLatLng, _currentZoomLevel);
    final MapLatLng newFocalLatLng = _pixelToLatLng(
        Offset(
            FrictionSimulation(
              _frictionCoefficient,
              currentFocalOffset.dx,
              -details.velocity.pixelsPerSecond.dx,
            ).finalX,
            FrictionSimulation(
              _frictionCoefficient,
              currentFocalOffset.dy,
              -details.velocity.pixelsPerSecond.dy,
            ).finalX),
        _currentZoomLevel);
    _gestureType = null;
    _focalLatLngAnimationController.duration = _getFlingAnimationDuration(
        details.velocity.pixelsPerSecond.distance, _frictionCoefficient);
    widget.zoomPanBehavior!.focalLatLng = newFocalLatLng;
  }

  // This methods performs fling animation for pinching.
  void _startFlingAnimationForPinching(ScaleEndDetails details) {
    _isFlingAnimationActive = true;
    final int direction =
        _controller!.localScale >= _maximumReachedScaleOnInteraction ? 1 : -1;
    double newZoomLevel = _currentZoomLevel +
        (direction *
            (details.velocity.pixelsPerSecond.distance / kMaxFlingVelocity) *
            widget.zoomPanBehavior!.maxZoomLevel);
    newZoomLevel = newZoomLevel.clamp(widget.zoomPanBehavior!.minZoomLevel,
        widget.zoomPanBehavior!.maxZoomLevel);
    _gestureType = null;
    _zoomLevelAnimationController.duration = _getFlingAnimationDuration(
        details.velocity.pixelsPerSecond.distance, _frictionCoefficient);
    widget.zoomPanBehavior!.zoomLevel = newZoomLevel;
  }

  // Returns the animation duration for the given distance and
  // friction co-efficient.
  Duration _getFlingAnimationDuration(
      double distance, double frictionCoefficient) {
    final int duration =
        (log(10.0 / distance) / log(frictionCoefficient / 100)).round();
    final int durationInMs = (duration * 1000).round();
    return Duration(milliseconds: durationInMs < 350 ? 350 : durationInMs);
  }

  // This method called when doing mouse wheel action in web.
  void _handleMouseWheelZooming(PointerSignalEvent event) {
    if (widget.zoomPanBehavior != null &&
        widget.zoomPanBehavior!.enablePinching) {
      if (event is PointerScrollEvent) {
        widget.zoomPanBehavior!.handleEvent(event);
        _gestureType = Gesture.scale;
        _mouseStartZoomLevel ??= _currentZoomLevel;
        _mouseCenterLatLng ??= _currentFocalLatLng;
        _mouseStartLocalPoint ??= event.localPosition;
        _mouseStartGlobalPoint ??= event.position;

        final MapZoomPanBehavior zoomPanBehavior = widget.zoomPanBehavior!;
        final Offset localPointCenterDiff = Offset(
            (_size!.width / 2) - _mouseStartLocalPoint!.dx,
            (_size!.height / 2) - _mouseStartLocalPoint!.dy);
        final Offset actualCenterPixelPosition =
            _pixelFromLatLng(_mouseCenterLatLng!, _mouseStartZoomLevel!);
        final Offset point = actualCenterPixelPosition - localPointCenterDiff;
        _touchStartLatLng = _pixelToLatLng(point, _mouseStartZoomLevel!);
        double scale = _controller!.tileLayerLocalScale -
            (event.scrollDelta.dy / _size!.height);
        _controller!.tileLayerLocalScale = scale;
        final double newZoomLevel =
            _getZoomLevel(_mouseStartZoomLevel! + log(scale) / ln2);
        // If the scale * _mouseStartZoomLevel value goes beyond
        // minZoomLevel, set the min scale value.
        if (scale * _mouseStartZoomLevel! < zoomPanBehavior.minZoomLevel) {
          scale = zoomPanBehavior.minZoomLevel / _mouseStartZoomLevel!;
        }
        // If the scale * _mouseStartZoomLevel value goes beyond
        // maxZoomLevel, set the max scale value.
        else if (scale * _mouseStartZoomLevel! > zoomPanBehavior.maxZoomLevel) {
          scale = zoomPanBehavior.maxZoomLevel / _mouseStartZoomLevel!;
        }

        _controller!
          ..isInInteractive = true
          ..gesture = _gestureType
          ..localScale = scale
          ..pinchCenter = event.localPosition;
        final MapLatLng newFocalLatLng =
            _calculateVisibleLatLng(event.localPosition, newZoomLevel);
        _invokeOnZooming(newZoomLevel, _mouseStartLocalPoint!,
            _mouseStartGlobalPoint!, newFocalLatLng);

        _zoomingDelayTimer?.cancel();
        _zoomingDelayTimer = Timer(const Duration(milliseconds: 300), () {
          _invalidateSublayer();
          _controller!.tileLayerLocalScale = 1.0;
          _mouseStartZoomLevel = null;
          _mouseStartLocalPoint = null;
          _mouseStartGlobalPoint = null;
          _gestureType = null;
          _mouseCenterLatLng = null;
        });
      }
    }
  }

  // Calculate the actual latLng value in the place of tapped location.
  void _calculateLatLngFromTappedPoint() {
    final Offset localPointCenterDiff = Offset(
        (_size!.width / 2) - _touchStartLocalPoint.dx,
        (_size!.height / 2) - _touchStartLocalPoint.dy);
    final Offset actualCenterPixelPosition =
        _pixelFromLatLng(_currentFocalLatLng, _touchStartZoomLevel);
    final Offset point = actualCenterPixelPosition - localPointCenterDiff;
    _touchStartLatLng = _pixelToLatLng(point, _touchStartZoomLevel);

    final Rect newVisibleBounds = Rect.fromCenter(
        center: _pixelFromLatLng(_currentFocalLatLng, _touchStartZoomLevel),
        width: _size!.width,
        height: _size!.height);
    final MapLatLngBounds newVisibleLatLng = MapLatLngBounds(
        _pixelToLatLng(newVisibleBounds.topRight, _touchStartZoomLevel),
        _pixelToLatLng(newVisibleBounds.bottomLeft, _touchStartZoomLevel));
    _zoomDetails = MapZoomDetails(newVisibleBounds: newVisibleLatLng);
    _panDetails = MapPanDetails(newVisibleBounds: newVisibleLatLng);
    _newFocalLatLng = _currentFocalLatLng;
  }

  // Check whether gesture type is scale or pan.
  Gesture? _getGestureType(double scale, Offset focalPoint) {
    // The minimum distance required to start scale or pan gesture.
    const int minScaleDistance = 3;
    final Offset distance = focalPoint - _touchStartLocalPoint;
    if (scale == 1) {
      return distance.dx.abs() > minScaleDistance ||
              distance.dy.abs() > minScaleDistance
          ? Gesture.pan
          : null;
    }

    return (distance.dx.abs() > minScaleDistance ||
            distance.dy.abs() > minScaleDistance)
        ? Gesture.scale
        : null;
  }

  // Calculate new focal coordinate value while scaling, panning or mouse wheel
  // actions.
  MapLatLng _calculateVisibleLatLng(
      Offset localFocalPoint, double newZoomLevel) {
    final Offset focalStartPoint =
        _pixelFromLatLng(_touchStartLatLng, newZoomLevel);
    final Offset newCenterPoint = focalStartPoint -
        localFocalPoint +
        Offset(_size!.width / 2, _size!.height / 2);
    return _pixelToLatLng(newCenterPoint, newZoomLevel);
  }

  // Restricting new zoom level value either to
  // [widget.zoomPanBehavior.minZoomLevel] or
  // [widget.zoomPanBehavior.maxZoomLevel] if the new zoom level value is not
  // in zoom level range.
  double _getZoomLevel(double zoomLevel) {
    return zoomLevel.isNaN
        ? widget.zoomPanBehavior!.minZoomLevel
        : zoomLevel.clamp(
            widget.zoomPanBehavior!.minZoomLevel,
            widget.zoomPanBehavior!.maxZoomLevel,
          );
  }

  // This method called for both pinch zooming action and mouse wheel zooming
  // action for passing [MapZoomDetails] parameters to notify user about the
  // zooming details.
  void _invokeOnZooming(double newZoomLevel,
      [Offset? localFocalPoint,
      Offset? globalFocalPoint,
      MapLatLng? newFocalLatLng]) {
    final Rect newVisibleBounds = Rect.fromCenter(
        center: _pixelFromLatLng(newFocalLatLng!, newZoomLevel),
        width: _size!.width,
        height: _size!.height);

    _zoomDetails = MapZoomDetails(
        localFocalPoint: localFocalPoint,
        globalFocalPoint: globalFocalPoint,
        previousZoomLevel: widget.zoomPanBehavior!.zoomLevel,
        newZoomLevel: newZoomLevel,
        previousVisibleBounds: _zoomDetails != null
            ? _zoomDetails!.newVisibleBounds
            : _controller!.visibleLatLngBounds,
        newVisibleBounds: MapLatLngBounds(
            _pixelToLatLng(newVisibleBounds.topRight, newZoomLevel),
            _pixelToLatLng(newVisibleBounds.bottomLeft, newZoomLevel)));
    _newFocalLatLng = newFocalLatLng;
    if (widget.onWillZoom == null || widget.onWillZoom!(_zoomDetails!)) {
      widget.zoomPanBehavior?.onZooming(_zoomDetails!);
    }
  }

  // This method invoked when user override the [onZooming] method in
  // [ZoomPanBehavior] and called [super.onZooming(details)].
  void _handleZooming(MapZoomDetails details) {
    if (_gestureType != null) {
      // Updating map while pinching and scrolling.
      _currentZoomLevel = details.newZoomLevel!;
      _controller!.tileZoomLevel = _currentZoomLevel;
      _currentFocalLatLng = _newFocalLatLng;
      _controller!.visibleFocalLatLng = _currentFocalLatLng;
      _controller!.visibleLatLngBounds = details.newVisibleBounds;
      widget.zoomPanBehavior!.focalLatLng = _currentFocalLatLng;
      setState(() {
        _handleTransform();
      });
    } else {
      // Updating map via toolbar or double tap or fling animation end.
      final Rect newVisibleBounds = Rect.fromCenter(
          center: _pixelFromLatLng(_currentFocalLatLng, details.newZoomLevel!),
          width: _size!.width,
          height: _size!.height);
      _controller!.visibleLatLngBounds = MapLatLngBounds(
          _pixelToLatLng(newVisibleBounds.topRight, details.newZoomLevel!),
          _pixelToLatLng(newVisibleBounds.bottomLeft, details.newZoomLevel!));
      _isZoomedUsingToolbar = _currentZoomLevel != details.newZoomLevel!;
    }

    widget.zoomPanBehavior!.zoomLevel = details.newZoomLevel!;
  }

  // This method called when dynamically changing the [zoomLevel] property of
  // ZoomPanBehavior.
  void _handleZoomLevelChange(double zoomLevel) {
    if (_gestureType == null &&
        _currentZoomLevel != widget.zoomPanBehavior!.zoomLevel) {
      if (!_isFlingAnimationActive && !_doubleTapEnabled) {
        _zoomLevelAnimationController.duration =
            const Duration(milliseconds: 650);
      }

      _zoomLevelTween.begin = _currentZoomLevel;
      _zoomLevelTween.end = widget.zoomPanBehavior!.zoomLevel;
      _zoomLevelAnimationController.forward(from: 0.0);
    }
  }

  void _handleZoomLevelAnimation() {
    if (_zoomLevelTween.end != null) {
      _currentZoomLevel = _zoomLevelTween.evaluate(_isFlingAnimationActive
          ? _flingZoomLevelCurvedAnimation
          : _zoomLevelCurvedAnimation);
    }

    if (_isFlingAnimationActive || _doubleTapEnabled) {
      _currentFocalLatLng =
          _calculateVisibleLatLng(_touchStartLocalPoint, _currentZoomLevel);
    }

    _handleZoomPanAnimation();
  }

  void _handleZoomPanAnimation() {
    setState(() {
      _handleTransform();
      if (_hasSublayer) {
        _controller!.visibleFocalLatLng = _currentFocalLatLng;
        _controller!.tileZoomLevel = _currentZoomLevel;
        _invalidateSublayer();
      } else {
        _controller!.notifyRefreshListeners();
      }
    });
  }

  void _handleZoomLevelAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _handleZoomingAnimationEnd();
    }
  }

  void _handleZoomingAnimationEnd() {
    _isFlingAnimationActive = false;
    if (_zoomLevelTween.end != null &&
        !_isZoomedUsingToolbar &&
        !_doubleTapEnabled) {
      _touchStartLocalPoint =
          _pixelFromLatLng(_currentFocalLatLng, _zoomLevelTween.begin!);
      // ignore: avoid_as
      final RenderBox renderBox = context.findRenderObject()! as RenderBox;
      _invokeOnZooming(_currentZoomLevel, _touchStartLocalPoint,
          renderBox.localToGlobal(_touchStartLocalPoint), _currentFocalLatLng);
    } else {
      _isZoomedUsingToolbar = false;
      _doubleTapEnabled = false;
    }
  }

  void _invokeOnPanning(double newZoomLevel,
      {required Offset localFocalPoint,
      required Offset globalFocalPoint,
      required Offset touchStartLocalPoint,
      required MapLatLng newFocalLatLng}) {
    final Rect newVisibleBounds = Rect.fromCenter(
        center: _pixelFromLatLng(newFocalLatLng, newZoomLevel),
        width: _size!.width,
        height: _size!.height);

    _panDetails = MapPanDetails(
        globalFocalPoint: globalFocalPoint,
        localFocalPoint: localFocalPoint,
        zoomLevel: widget.zoomPanBehavior!.zoomLevel,
        delta: localFocalPoint - touchStartLocalPoint,
        previousVisibleBounds: _panDetails != null
            ? _panDetails!.newVisibleBounds
            : _controller!.visibleLatLngBounds,
        newVisibleBounds: MapLatLngBounds(
            _pixelToLatLng(newVisibleBounds.topRight, newZoomLevel),
            _pixelToLatLng(newVisibleBounds.bottomLeft, newZoomLevel)));
    _newFocalLatLng = newFocalLatLng;
    if (widget.onWillPan == null || widget.onWillPan!(_panDetails!)) {
      widget.zoomPanBehavior?.onPanning(_panDetails!);
    }
  }

  // This method invoked when user override the [onPanning] method in
  // [ZoomPanBehavior] and called [super.onPanning(details)].
  void _handlePanning(MapPanDetails details) {
    setState(() {
      _currentFocalLatLng = _newFocalLatLng;
      widget.zoomPanBehavior!.focalLatLng = _currentFocalLatLng;
      _controller!.visibleFocalLatLng = _currentFocalLatLng;
      _controller!.visibleLatLngBounds = details.newVisibleBounds;
      _handleTransform();
    });
  }

  // This method called when dynamically changing the [focalLatLng] property of
  // ZoomPanBehavior.
  void _handleFocalLatLngChange(MapLatLng? latlng) {
    if (_gestureType == null &&
        _currentFocalLatLng != widget.zoomPanBehavior!.focalLatLng) {
      if (!_isFlingAnimationActive) {
        _focalLatLngAnimationController.duration =
            const Duration(milliseconds: 650);
      }

      _focalLatLngTween.begin = _currentFocalLatLng;
      _focalLatLngTween.end = widget.zoomPanBehavior!.focalLatLng;
      _focalLatLngAnimationController.forward(from: 0.0);
    }
  }

  void _handleFocalLatLngAnimation() {
    if (_focalLatLngTween.end != null) {
      _currentFocalLatLng = _focalLatLngTween.evaluate(_isFlingAnimationActive
          ? _flingFocalLatLngCurvedAnimation
          : _focalLatLngCurvedAnimation);
    }

    _handleZoomPanAnimation();
  }

  void _handleFocalLatLngAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed && _focalLatLngTween.end != null) {
      _handleFocalLatLngAnimationEnd();
    }
  }

  void _handleFocalLatLngAnimationEnd() {
    _isFlingAnimationActive = false;
    final Offset previousFocalPoint =
        _pixelFromLatLng(_focalLatLngTween.begin!, _currentZoomLevel);
    final Offset currentFocalPoint =
        _pixelFromLatLng(_currentFocalLatLng, _currentZoomLevel);
    // ignore: avoid_as
    final RenderBox renderBox = context.findRenderObject()! as RenderBox;
    _invokeOnPanning(_currentZoomLevel,
        localFocalPoint: currentFocalPoint,
        globalFocalPoint: renderBox.localToGlobal(currentFocalPoint),
        touchStartLocalPoint: previousFocalPoint,
        newFocalLatLng: _currentFocalLatLng);
  }

  // This method invoked when user called the [reset] method in
  // [ZoomPanBehavior].
  void _handleReset() {
    widget.zoomPanBehavior!.zoomLevel = widget.zoomPanBehavior!.minZoomLevel;
  }

  void _invalidateSublayer() {
    _controller!
      ..isInInteractive = false
      ..normalize = Offset.zero
      ..gesture = null
      ..localScale = 1.0;
    if (_hasSublayer) {
      _controller!.notifyRefreshListeners();
    }
  }

  // Scale and transform the existing level tiles if the current zoom level
  // value is in-between the zoom levels i.e.,fractional value. Request
  // new tiles if the current zoom level value reached next zoom level.
  void _handleTransform() {
    final double tileZoom = _currentZoomLevel;
    if ((tileZoom - _nextZoomLevel).abs() >= 1) {
      // Request new tiles when next zoom level reached.
      _nextZoomLevel = tileZoom.toInt();
      _requestAndPopulateNewTiles();
      _updateZoomLevelTransforms(_currentFocalLatLng, _currentZoomLevel);
    } else {
      // Scale and transform the existing tiles.
      _updateZoomLevelTransforms(_currentFocalLatLng, _currentZoomLevel);
    }
  }

  // Calculate amount of scale and translation for all [_levels] while
  // scaling.
  void _updateZoomLevelTransforms(MapLatLng center, double zoom) {
    for (final double key in _levels.keys) {
      _updateZoomLevelTransform(_levels[key]!, center, zoom);
    }
  }

  void refreshMarkers(MarkerAction action, [List<int>? indices]) {
    MapMarker marker;
    final MapTileLayerController controller = widget.controller!;
    switch (action) {
      case MarkerAction.insert:
        int index = indices![0];
        assert(index <= controller._markersCount);
        if (index > controller._markersCount) {
          index = controller._markersCount;
        }
        marker = widget.markerBuilder!(context, index);
        if (index < controller._markersCount) {
          _markers!.insert(index, marker);
        } else if (index == controller._markersCount) {
          _markers!.add(marker);
        }
        controller._markersCount++;
        break;
      case MarkerAction.removeAt:
        final int index = indices![0];
        assert(index < controller._markersCount);
        _markers!.removeAt(index);
        controller._markersCount--;
        break;
      case MarkerAction.replace:
        for (final int index in indices!) {
          assert(index < controller._markersCount);
          marker = widget.markerBuilder!(context, index);
          _markers![index] = marker;
        }
        break;
      case MarkerAction.clear:
        _markers!.clear();
        controller._markersCount = 0;
        break;
    }

    setState(() {
      // Rebuilds to visually update the markers when it was updated or added.
    });
  }

  Widget _buildTileLayer() {
    final List<Widget> children = <Widget>[];
    Widget current;

    current = Listener(
      onPointerDown: _handlePointerDown,
      onPointerMove: _handlePointerMove,
      onPointerUp: _handlePointerUp,
      onPointerSignal: _handleMouseWheelZooming,
      child: GestureDetector(
        onScaleStart: _handleScaleStart,
        onScaleUpdate: _handleScaleUpdate,
        onScaleEnd: _handleScaleEnd,
        child: Stack(children: <Widget>[
          _buildTiles(),
          if (_hasSublayer)
            SublayerContainer(ancestor: _ancestor, children: widget.sublayers!),
          if (_markers != null && _markers!.isNotEmpty)
            MarkerContainer(
              markerTooltipBuilder: widget.markerTooltipBuilder,
              controller: _controller!,
              children: _markers,
            ),
        ]),
      ),
    );

    children.add(current);
    if (widget.zoomPanBehavior != null) {
      children.add(BehaviorViewRenderObjectWidget(
        controller: _controller!,
        zoomPanBehavior: widget.zoomPanBehavior!,
      ));
      if (_isDesktop && widget.zoomPanBehavior!.showToolbar) {
        children.add(MapToolbar(
          onWillZoom: widget.onWillZoom,
          zoomPanBehavior: widget.zoomPanBehavior!,
          controller: _controller,
        ));
      }
    }

    if (_hasTooltipBuilder()) {
      children.add(MapTooltip(
        key: _controller!.tooltipKey,
        controller: _controller,
        sublayers: widget.sublayers,
        markerTooltipBuilder: widget.markerTooltipBuilder,
        tooltipSettings: widget.tooltipSettings,
        themeData: _mapsThemeData,
      ));
    }

    return SizedBox(
      width: _size!.width,
      height: _size!.height,
      child: ClipRect(child: Stack(children: children)),
    );
  }

  void _initializeMapController() {
    if (_controller == null) {
      _ancestor = context
          .dependOnInheritedWidgetOfExactType<MapLayerInheritedWidget>()!;
      _controller = _ancestor.controller
        ..addZoomingListener(_handleZooming)
        ..addPanningListener(_handlePanning)
        ..addResetListener(_handleReset)
        ..tileZoomLevel = _currentZoomLevel
        ..visibleFocalLatLng = _currentFocalLatLng
        ..onZoomLevelChange = _handleZoomLevelChange
        ..onPanChange = _handleFocalLatLngChange;
    }
  }

  @override
  void initState() {
    super.initState();
    _currentFocalLatLng =
        widget.zoomPanBehavior?.focalLatLng ?? widget.initialFocalLatLng;
    _currentZoomLevel = (widget.zoomPanBehavior != null &&
            widget.zoomPanBehavior!.zoomLevel != 1)
        ? widget.zoomPanBehavior!.zoomLevel
        : widget.initialZoomLevel.toDouble();
    widget.zoomPanBehavior?.zoomLevel = _currentZoomLevel;
    _nextZoomLevel = _currentZoomLevel.floor();
    if (widget.controller != null) {
      widget.controller!._markersCount = widget.initialMarkersCount;
    }

    widget.controller?._state = this;
    _markers = <Widget>[];
    for (int i = 0; i < widget.initialMarkersCount; i++) {
      final MapMarker marker = widget.markerBuilder!(context, i);
      _markers!.add(marker);
    }

    _zoomLevelAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 650))
      ..addListener(_handleZoomLevelAnimation)
      ..addStatusListener(_handleZoomLevelAnimationStatusChange);
    _focalLatLngAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 650))
      ..addListener(_handleFocalLatLngAnimation)
      ..addStatusListener(_handleFocalLatLngAnimationStatusChange);
    _flingZoomLevelCurvedAnimation = CurvedAnimation(
        parent: _zoomLevelAnimationController, curve: Curves.decelerate);
    _flingFocalLatLngCurvedAnimation = CurvedAnimation(
        parent: _focalLatLngAnimationController, curve: Curves.decelerate);
    _zoomLevelCurvedAnimation = CurvedAnimation(
        parent: _zoomLevelAnimationController, curve: Curves.easeInOut);
    _focalLatLngCurvedAnimation = CurvedAnimation(
        parent: _focalLatLngAnimationController, curve: Curves.easeInOut);

    _focalLatLngTween = MapLatLngTween();
    _zoomLevelTween = Tween<double>();
    _hasSublayer = widget.sublayers != null && widget.sublayers!.isNotEmpty;
    widget.controller?.addListener(refreshMarkers);
  }

  @override
  void didChangeDependencies() {
    _initializeMapController();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(TileLayer oldWidget) {
    _hasSublayer = widget.sublayers != null && widget.sublayers!.isNotEmpty;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller!
        ..removeZoomingListener(_handleZooming)
        ..removePanningListener(_handlePanning)
        ..removeResetListener(_handleReset);
      _controller = null;
    }

    _zoomLevelAnimationController
      ..removeListener(_handleZoomLevelAnimation)
      ..removeStatusListener(_handleZoomLevelAnimationStatusChange)
      ..dispose();

    _focalLatLngAnimationController
      ..removeListener(_handleFocalLatLngAnimation)
      ..removeStatusListener(_handleFocalLatLngAnimationStatusChange)
      ..dispose();

    widget.controller?.removeListener(refreshMarkers);
    _controller?.dispose();
    _markers!.clear();
    _tiles.clear();
    _levels.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;
    _mapsThemeData = SfMapsTheme.of(context)!;
    _mapsThemeData = _mapsThemeData.copyWith(
      tooltipColor: widget.tooltipSettings.color ?? _mapsThemeData.tooltipColor,
      tooltipStrokeColor: widget.tooltipSettings.strokeColor ??
          _mapsThemeData.tooltipStrokeColor,
      tooltipStrokeWidth: widget.tooltipSettings.strokeWidth ??
          _mapsThemeData.tooltipStrokeWidth,
      tooltipBorderRadius: _mapsThemeData.tooltipBorderRadius
          .resolve(Directionality.of(context)),
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (_size != null) {
          _isSizeChanged = _size!.width != constraints.maxWidth ||
              _size!.height != constraints.maxHeight;
        }
        _size = getBoxSize(constraints);
        _controller!.tileLayerBoxSize = _size;
        return _buildTileLayer();
      },
    );
  }
}
