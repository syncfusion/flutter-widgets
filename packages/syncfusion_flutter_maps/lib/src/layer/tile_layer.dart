import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../maps.dart';
import '../common.dart';
import '../controller/map_controller.dart';
import '../elements/marker.dart';
import '../elements/toolbar.dart';
import '../elements/tooltip.dart';
import '../layer/vector_layers.dart';
import '../layer/zoomable.dart';
import '../theme.dart';
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
  bool operator ==(Object other) {
    if (other is _MapTileCoordinate) {
      return x == other.x && y == other.y && z == other.z;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(x.hashCode, y.hashCode, z.hashCode);
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
    this.initialLatLngBounds,
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
  final MapLatLngBounds? initialLatLngBounds;
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
  State<TileLayer> createState() => _TileLayerState();
}

class _TileLayerState extends State<TileLayer> with TickerProviderStateMixin {
  // Both width and height of each tile is 256.
  static const double tileSize = 256;
  // The [globalTileStart] represents the tile start factor value based on
  // the zoom level.
  static const Offset _globalTileStart = Offset.zero;

  final Map<String, _MapTile> _tiles = <String, _MapTile>{};
  final Map<double, TileZoomLevelDetails> _levels =
      <double, TileZoomLevelDetails>{};

  late double _currentZoomLevel;
  late int _nextZoomLevel;
  late MapLatLng _currentFocalLatLng;
  late bool _isDesktop;
  late SfMapsThemeData _mapsThemeData;
  late MapLayerInheritedWidget _ancestor;

  Size? _size;
  MapController? _controller;
  bool _hasSublayer = false;
  List<Widget>? _markers;
  ZoomableController? _zoomController;

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
      final double levelIndex = zoom.toDouble();
      // The [_levels] collection contains each integer zoom level origin,
      // scale and translationPoint. The scale and translationPoint are
      // calculated in every pinch zoom level for scaling the tiles.
      level = _levels[levelIndex] = TileZoomLevelDetails();
      level.origin = _getLevelOrigin(_currentFocalLatLng, levelIndex);
      level.zoomLevel = levelIndex;

      if (levelsCount == 0 ||
          (_zoomController != null &&
              _zoomController!.actionType == ActionType.pinch)) {
        _updateZoomLevelTransform(
            level, _currentFocalLatLng, _currentZoomLevel);
      }
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

    current = Stack(children: <Widget>[
      _buildTiles(),
      if (_hasSublayer)
        SublayerContainer(ancestor: _ancestor, children: widget.sublayers!),
      if (_markers != null && _markers!.isNotEmpty)
        MarkerContainer(
          markerTooltipBuilder: widget.markerTooltipBuilder,
          controller: _controller!,
          themeData: _mapsThemeData,
          children: _markers,
        ),
    ]);

    children.add(current);
    if (widget.zoomPanBehavior != null) {
      children.add(BehaviorView(
          zoomLevel: _currentZoomLevel,
          focalLatLng: _currentFocalLatLng,
          controller: _controller!,
          behavior: widget.zoomPanBehavior!,
          onWillZoom: widget.onWillZoom,
          onWillPan: widget.onWillPan,
          enableMouseWheelZooming:
              widget.zoomPanBehavior!.enableMouseWheelZooming));
      if (_isDesktop && widget.zoomPanBehavior!.showToolbar) {
        children.add(MapToolbar(
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

  void _handledZoomPanChange() {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
        _handledZoomPanChange();
      });
      return;
    }

    setState(() {
      _currentZoomLevel = _zoomController!.zoomLevel;
      final Offset point = Offset(
          (_size!.width / 2) - _zoomController!.actualRect.left,
          (_size!.height / 2) - _zoomController!.actualRect.top);
      final MapLatLng newFocalLatLng = pixelToLatLng(
          point, Size.square(getTotalTileWidth(_currentZoomLevel)));
      _currentFocalLatLng = newFocalLatLng;
      _handleTransform();
      if (_hasSublayer) {
        _controller!
          ..visibleFocalLatLng = _currentFocalLatLng
          ..tileZoomLevel = _currentZoomLevel;
        if (_zoomController!.actionType == ActionType.pinchFling ||
            _zoomController!.actionType == ActionType.panFling) {
          _invalidateSublayer();
        }
      }
      _controller!.notifyZoomPanListeners();
    });
  }

  void _invalidateSublayer() {
    _controller!
      ..isInInteractive = false
      ..normalize = Offset.zero
      ..panDistance = Offset.zero
      ..gesture = null
      ..localScale = 1.0;
  }

  void _initializeController() {
    _ancestor =
        context.dependOnInheritedWidgetOfExactType<MapLayerInheritedWidget>()!;
    _controller ??= _ancestor.controller
      ..tileZoomLevel = _currentZoomLevel
      ..visibleFocalLatLng = _currentFocalLatLng;
    if (_ancestor.zoomController != null) {
      _zoomController ??= _ancestor.zoomController!
        ..addListener(_handledZoomPanChange);
    }
  }

  void _validateInitialBounds() {
    final MapLatLngBounds? bounds =
        widget.zoomPanBehavior?.latLngBounds ?? widget.initialLatLngBounds;
    if (bounds != null) {
      final double zoomLevel =
          getZoomLevel(bounds, _controller!.layerType!, _size!);
      _currentFocalLatLng = getFocalLatLng(bounds);
      if (widget.zoomPanBehavior != null) {
        _currentZoomLevel = zoomLevel.clamp(
            widget.zoomPanBehavior!.minZoomLevel,
            widget.zoomPanBehavior!.maxZoomLevel);
      } else {
        _currentZoomLevel =
            zoomLevel.clamp(kDefaultMinZoomLevel, kDefaultMaxZoomLevel);
      }
      _nextZoomLevel = _currentZoomLevel.floor();
      _controller!
        ..tileZoomLevel = _currentZoomLevel
        ..visibleFocalLatLng = _currentFocalLatLng;
    }
  }

  @override
  void initState() {
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
    _hasSublayer = widget.sublayers != null && widget.sublayers!.isNotEmpty;
    widget.controller?.addListener(refreshMarkers);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _initializeController();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(TileLayer oldWidget) {
    _hasSublayer = widget.sublayers != null && widget.sublayers!.isNotEmpty;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (_zoomController != null) {
      _zoomController!.removeListener(_handledZoomPanChange);
    }
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
    final MapsThemeData effectiveMapsThemeData = MapsThemeData(context);
    _isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;

    _mapsThemeData = SfMapsTheme.of(context)!;
    _mapsThemeData = _mapsThemeData.copyWith(
      tooltipColor: widget.tooltipSettings.color ??
          _mapsThemeData.tooltipColor ??
          effectiveMapsThemeData.tooltipColor,
      tooltipStrokeColor: widget.tooltipSettings.strokeColor ??
          _mapsThemeData.tooltipStrokeColor ??
          effectiveMapsThemeData.tooltipStrokeColor,
      tooltipStrokeWidth: widget.tooltipSettings.strokeWidth ??
          _mapsThemeData.tooltipStrokeWidth,
      tooltipBorderRadius: _mapsThemeData.tooltipBorderRadius
          .resolve(Directionality.of(context)),
      markerIconColor: _mapsThemeData.markerIconColor ??
          effectiveMapsThemeData.markerIconColor,
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size newSize = getBoxSize(constraints);
        if (_size == null || _size != newSize) {
          _size = newSize;
          _controller!.tileLayerBoxSize = _size;
          _validateInitialBounds();
          // Recalculate tiles bounds origin for all existing zoom level
          // when size changed.
          _updateZoomLevelTransforms(_currentFocalLatLng, _currentZoomLevel);
        }

        return _buildTileLayer();
      },
    );
  }
}
