import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../maps.dart';
import '../behavior/zoom_pan_behavior.dart';
import '../controller/default_controller.dart';
import '../elements/shapes.dart';
import '../enum.dart';
import '../layer/layer_base.dart';
import '../utils.dart';

double _getDesiredValue(double value, MapController controller) {
  return controller.tileCurrentLevelDetails != null
      ? value / controller.tileCurrentLevelDetails.scale
      : value /
          (controller.gesture == Gesture.scale ? controller.localScale : 1);
}

Offset _getTranslationOffset(MapController controller, bool isTileLayer) {
  return isTileLayer
      ? -controller.tileCurrentLevelDetails.origin
      : controller.shapeLayerOffset;
}

Offset _updatePointsToScaledPosition(Offset point, MapController controller) {
  if (controller.tileCurrentLevelDetails != null) {
    return Offset(point.dx * controller.tileCurrentLevelDetails.scale,
            point.dy * controller.tileCurrentLevelDetails.scale) +
        controller.tileCurrentLevelDetails.translatePoint;
  }

  return point;
}

/// Base class for all vector layers.
abstract class MapVectorLayer extends MapSublayer {
  /// Creates a [MapVectorLayer].
  const MapVectorLayer({
    Key key,
    IndexedWidgetBuilder tooltipBuilder,
  }) : super(key: key, tooltipBuilder: tooltipBuilder);
}

/// A sublayer which renders group of [MapLine] on [MapShapeLayer] and
/// [MapTileLayer].
///
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///  return Scaffold(
///    body: SfMaps(
///      layers: [
///       MapShapeLayer(
///          source: MapShapeSource.asset(
///             "assets/world_map.json",
///              shapeDataField: "continent",
///          ),
///          sublayers: [
///           MapLineLayer(
///              lines: List<MapLine>.generate(
///               lines.length,
///                (int index) {
///                 return MapLine(
///                    from: lines[index].from,
///                    to: lines[index].to,
///                  );
///                },
///              ).toSet(),
///            ),
///          ],
///        ),
///      ],
///    ),
/// );
/// }
/// ```
///
/// See also:
/// * [MapArcLayer], for adding arcs.
/// * [MapPolylineLayer], for polylines.
/// * [MapCircleLayer], for adding circles.
/// * [MapPolygonLayer], for adding polygons.
class MapLineLayer extends MapVectorLayer {
  /// Creates the [MapLineLayer].
  MapLineLayer({
    Key key,
    @required this.lines,
    this.animation,
    this.color,
    this.width = 2,
    IndexedWidgetBuilder tooltipBuilder,
  })  : assert(lines != null),
        super(key: key, tooltipBuilder: tooltipBuilder);

  /// A collection of [MapLine].
  ///
  /// Every single [MapLine] connects two location coordinates through a
  /// straight line.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///       MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///           MapLineLayer(
  ///              lines: List<MapLine>.generate(
  ///               lines.length,
  ///                (int index) {
  ///                 return MapLine(
  ///                    from: lines[index].from,
  ///                    to: lines[index].to,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  /// );
  /// }
  /// ```
  final Set<MapLine> lines;

  /// Animation for the [lines] in [MapLineLayer].
  ///
  /// By default, [lines] will be rendered without any animation. The
  /// animation can be set as shown in the below code snippet. You can customise
  /// the animation flow, curve, duration and listen to the animation status.
  ///
  /// ```dart
  /// AnimationController _animationController;
  /// Animation _animation;
  ///
  /// @override
  /// void initState() {
  ///   _animationController = AnimationController(
  ///      duration: Duration(seconds: 3),
  ///      vsync: this,
  ///   );
  ///
  ///  _animation = CurvedAnimation(
  ///    parent: _animationController,
  ///    curve: Curves.easeInOut),
  ///  );
  ///
  ///  _animationController.forward(from: 0);
  ///  super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///       MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///           MapLineLayer(
  ///              lines: List<MapLine>.generate(
  ///               lines.length,
  ///                (int index) {
  ///                 return MapLine(
  ///                    from: lines[index].from,
  ///                    to: lines[index].to,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///              animation: _animation,
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  /// );
  /// }
  ///
  ///  @override
  ///  void dispose() {
  ///    animationController?.dispose();
  ///    super.dispose();
  ///  }
  /// ```
  final Animation animation;

  /// The color of all the [lines].
  ///
  /// For setting color for each [MapLine], please check the [MapLine.color]
  /// property.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///       MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///           MapLineLayer(
  ///              lines: List<MapLine>.generate(
  ///               lines.length,
  ///                (int index) {
  ///                 return MapLine(
  ///                    from: lines[index].from,
  ///                    to: lines[index].to,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///              color: Colors.green,
  ///              width: 2,
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  /// );
  /// }
  /// ```
  ///
  /// See also:
  /// [width], to set the width.
  final Color color;

  /// The width of all the [lines].
  ///
  /// For setting width for each [MapLine], please check the [MapLine.width]
  /// property.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///       MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///           MapLineLayer(
  ///              lines: List<MapLine>.generate(
  ///               lines.length,
  ///                (int index) {
  ///                 return MapLine(
  ///                    from: lines[index].from,
  ///                    to: lines[index].to,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///              width: 2,
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  /// );
  /// }
  /// ```
  ///
  /// See also:
  /// [color], to set the color.
  final double width;

  @override
  Widget build(BuildContext context) {
    return _MapLineLayer(
      lines: lines,
      animation: animation,
      color: color,
      width: width,
      tooltipBuilder: tooltipBuilder,
      lineLayer: this,
    );
  }
}

class _MapLineLayer extends StatefulWidget {
  _MapLineLayer({
    this.lines,
    this.animation,
    this.color,
    this.width,
    this.tooltipBuilder,
    this.lineLayer,
  });

  final Set<MapLine> lines;
  final Animation animation;
  final Color color;
  final double width;
  final IndexedWidgetBuilder tooltipBuilder;
  final MapLineLayer lineLayer;

  @override
  _MapLineLayerState createState() => _MapLineLayerState();
}

class _MapLineLayerState extends State<_MapLineLayer>
    with SingleTickerProviderStateMixin {
  AnimationController _hoverAnimationController;
  SfMapsThemeData _mapsThemeData;

  @override
  void initState() {
    super.initState();
    _hoverAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
  }

  @override
  void dispose() {
    _hoverAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows;
    _mapsThemeData = SfMapsTheme.of(context);
    return _MapLineLayerRenderObject(
      lines: widget.lines,
      animation: widget.animation,
      color: widget.color ??
          (_mapsThemeData.brightness == Brightness.light
              ? const Color.fromRGBO(140, 140, 140, 1)
              : const Color.fromRGBO(208, 208, 208, 1)),
      width: widget.width,
      tooltipBuilder: widget.tooltipBuilder,
      lineLayer: widget.lineLayer,
      themeData: _mapsThemeData,
      isDesktop: isDesktop,
      hoverAnimationController: _hoverAnimationController,
    );
  }
}

class _MapLineLayerRenderObject extends LeafRenderObjectWidget {
  const _MapLineLayerRenderObject({
    this.lines,
    this.animation,
    this.color,
    this.width,
    this.tooltipBuilder,
    this.lineLayer,
    this.themeData,
    this.isDesktop,
    this.hoverAnimationController,
  });

  final Set<MapLine> lines;
  final Animation animation;
  final Color color;
  final double width;
  final IndexedWidgetBuilder tooltipBuilder;
  final MapLineLayer lineLayer;
  final SfMapsThemeData themeData;
  final bool isDesktop;
  final AnimationController hoverAnimationController;

  @override
  _RenderMapLine createRenderObject(BuildContext context) {
    return _RenderMapLine(
      lines: lines,
      animation: animation,
      color: color,
      width: width,
      tooltipBuilder: tooltipBuilder,
      context: context,
      lineLayer: lineLayer,
      themeData: themeData,
      isDesktop: isDesktop,
      hoverAnimationController: hoverAnimationController,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderMapLine renderObject) {
    renderObject
      ..lines = lines
      .._animation = animation
      ..color = color
      ..width = width
      ..tooltipBuilder = tooltipBuilder
      ..context = context
      ..lineLayer = lineLayer
      ..themeData = themeData;
  }
}

class _RenderMapLine extends RenderBox implements MouseTrackerAnnotation {
  _RenderMapLine({
    Set<MapLine> lines,
    Animation animation,
    Color color,
    double width,
    IndexedWidgetBuilder tooltipBuilder,
    BuildContext context,
    MapLineLayer lineLayer,
    SfMapsThemeData themeData,
    bool isDesktop,
    AnimationController hoverAnimationController,
  })  : _lines = lines,
        _animation = animation,
        _color = color,
        _width = width,
        _tooltipBuilder = tooltipBuilder,
        context = context,
        lineLayer = lineLayer,
        _themeData = themeData,
        isDesktop = isDesktop,
        hoverAnimationController = hoverAnimationController {
    selectedLinePoints = <Offset>[];
    _forwardHoverColor = ColorTween();
    _reverseHoverColor = ColorTween();
    _hoverColorAnimation = CurvedAnimation(
        parent: hoverAnimationController, curve: Curves.easeInOut);
    linesInList = _lines?.toList();
    _tapGestureRecognizer = TapGestureRecognizer()..onTapUp = _handleTapUp;
  }

  TapGestureRecognizer _tapGestureRecognizer;
  MapController controller;
  AnimationController hoverAnimationController;
  RenderSublayerContainer vectorLayerContainer;
  MapLineLayer lineLayer;
  BuildContext context;
  MapLine selectedLine;
  int selectedIndex = -1;
  double touchTolerance = 5;
  List<MapLine> linesInList;
  List<Offset> selectedLinePoints;
  Animation<double> _hoverColorAnimation;
  ColorTween _forwardHoverColor;
  ColorTween _reverseHoverColor;
  MapLine _previousHoverItem;
  MapLine _currentHoverItem;
  bool isDesktop;

  Set<MapLine> get lines => _lines;
  Set<MapLine> _lines;
  set lines(Set<MapLine> value) {
    assert(value != null);
    if (_lines == value || value == null) {
      return;
    }
    _lines = value;
    linesInList = _lines?.toList();
    markNeedsPaint();
  }

  Animation get animation => _animation;
  Animation _animation;
  set animation(Animation value) {
    if (_animation == value) {
      return;
    }
    _animation = value;
  }

  IndexedWidgetBuilder get tooltipBuilder => _tooltipBuilder;
  IndexedWidgetBuilder _tooltipBuilder;
  set tooltipBuilder(IndexedWidgetBuilder value) {
    if (_tooltipBuilder == value) {
      return;
    }
    _tooltipBuilder = value;
  }

  Color get color => _color;
  Color _color;
  set color(Color value) {
    if (_color == value) {
      return;
    }
    _color = value;

    // The previousHoverItem is not null when change the line color dynamically
    // after hover on the [MapLine]. So reset the previousHoverItem here.
    if (isDesktop && _previousHoverItem != null) {
      _previousHoverItem = null;
    }
    markNeedsPaint();
  }

  double get width => _width;
  double _width;
  set width(double value) {
    if (_width == value) {
      return;
    }
    _width = value;
    markNeedsPaint();
  }

  SfMapsThemeData get themeData => _themeData;
  SfMapsThemeData _themeData;
  set themeData(SfMapsThemeData value) {
    if (_themeData == value) {
      return;
    }
    _themeData = value;
    markNeedsPaint();
  }

  void _updateHoverItemTween() {
    if (isDesktop) {
      final Color hoverStrokeColor = _getHoverColor(selectedLine);
      final Color beginColor = selectedLine.color ?? _color;

      if (_previousHoverItem != null) {
        _reverseHoverColor.begin = hoverStrokeColor;
        _reverseHoverColor.end = beginColor;
      }

      if (_currentHoverItem != null) {
        _forwardHoverColor.begin = beginColor;
        _forwardHoverColor.end = hoverStrokeColor;
      }
      hoverAnimationController.forward(from: 0);
    }
  }

  Color _getHoverColor(MapLine line) {
    final Color color = line.color ?? _color;
    final bool canAdjustHoverOpacity =
        double.parse(color.opacity.toStringAsFixed(2)) != hoverColorOpacity;
    return _themeData.shapeHoverColor != null &&
            _themeData.shapeHoverColor != Colors.transparent
        ? _themeData.shapeHoverColor
        : color.withOpacity(
            canAdjustHoverOpacity ? hoverColorOpacity : minHoverOpacity);
  }

  void _handleTapUp(TapUpDetails details) {
    selectedLine.onTap?.call();
    _handleInteraction(details.localPosition);
  }

  void _handlePointerExit(PointerExitEvent event) {
    if (isDesktop && _currentHoverItem != null) {
      _previousHoverItem = _currentHoverItem;
      _currentHoverItem = null;
      _updateHoverItemTween();
    }

    final RenderSublayerContainer vectorParent = parent;
    final ShapeLayerChildRenderBoxBase tooltipRenderer =
        vectorParent.tooltipKey?.currentContext?.findRenderObject();
    tooltipRenderer?.hideTooltip();
  }

  void _handleZooming(MapZoomDetails details) {
    markNeedsPaint();
  }

  void _handlePanning(MapPanDetails details) {
    markNeedsPaint();
  }

  void _handleReset() {
    markNeedsPaint();
  }

  void _handleRefresh() {
    markNeedsPaint();
  }

  void _handleInteraction(Offset position) {
    final RenderSublayerContainer vectorParent = parent;
    if (vectorParent.tooltipKey != null && _tooltipBuilder != null) {
      final ShapeLayerChildRenderBoxBase tooltipRenderer =
          vectorParent.tooltipKey.currentContext.findRenderObject();
      if (selectedLinePoints != null && selectedLinePoints.isNotEmpty) {
        final Offset startPoint = selectedLinePoints[0];
        final Offset endPoint = selectedLinePoints[1];
        final Offset lineMidPosition = Offset(
            min(startPoint.dx, endPoint.dx) +
                ((startPoint.dx - endPoint.dx).abs() / 2),
            min(startPoint.dy, endPoint.dy) +
                ((startPoint.dy - endPoint.dy).abs() / 2));
        position =
            !paintBounds.contains(lineMidPosition) ? position : lineMidPosition;
        tooltipRenderer.paintTooltip(
          selectedIndex,
          null,
          MapLayerElement.vector,
          vectorParent.getSublayerIndex(lineLayer),
          position,
        );
      }
    }
  }

  @override
  MouseCursor get cursor => SystemMouseCursors.basic;

  @override
  PointerEnterEventListener get onEnter => null;

  // As onHover property of MouseHoverAnnotation was removed only in the
  // beta channel, once it is moved to stable, will remove this property.
  @override
  // ignore: override_on_non_overriding_member
  PointerHoverEventListener get onHover => null;

  @override
  PointerExitEventListener get onExit => _handlePointerExit;

  @override
  // ignore: override_on_non_overriding_member
  bool get validForMouseTracker => true;

  @override
  bool hitTestSelf(Offset position) {
    if (_animation != null && !_animation.isCompleted) {
      return false;
    }

    final bool isTileLayer = controller.tileCurrentLevelDetails != null;
    final Size boxSize = isTileLayer ? controller.totalTileSize : size;
    final Offset translationOffset =
        _getTranslationOffset(controller, isTileLayer);
    int index = linesInList.length - 1;
    for (final MapLine line in linesInList?.reversed) {
      final double width = line.width ?? _width;
      if (line.onTap != null || _tooltipBuilder != null || isDesktop) {
        final double actualTouchTolerance =
            width < touchTolerance ? touchTolerance : width / 2;
        Offset startPoint = pixelFromLatLng(
          line.from.latitude,
          line.from.longitude,
          boxSize,
          translationOffset,
          controller.shapeLayerSizeFactor,
        );
        Offset endPoint = pixelFromLatLng(
          line.to.latitude,
          line.to.longitude,
          boxSize,
          translationOffset,
          controller.shapeLayerSizeFactor,
        );
        startPoint = _updatePointsToScaledPosition(startPoint, controller);
        endPoint = _updatePointsToScaledPosition(endPoint, controller);

        if (_liesPointOnLine(
            startPoint, endPoint, actualTouchTolerance, position)) {
          selectedLine = line;
          selectedIndex = index;
          selectedLinePoints
            ..clear()
            ..add(startPoint)
            ..add(endPoint);
          return true;
        }
      }
      index--;
    }

    return false;
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    if (event is PointerDownEvent) {
      _tapGestureRecognizer.addPointer(event);
    } else if (event is PointerHoverEvent) {
      if (isDesktop && _currentHoverItem != selectedLine) {
        _previousHoverItem = _currentHoverItem;
        _currentHoverItem = selectedLine;
        _updateHoverItemTween();
      }

      final RenderBox renderBox = context.findRenderObject();
      _handleInteraction(renderBox.globalToLocal(event.position));
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    vectorLayerContainer = parent;
    controller = vectorLayerContainer.controller;
    if (controller != null) {
      controller
        ..addZoomingListener(_handleZooming)
        ..addPanningListener(_handlePanning)
        ..addResetListener(_handleReset)
        ..addRefreshListener(_handleRefresh);
    }
    _animation?.addListener(markNeedsPaint);
    _hoverColorAnimation?.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    if (controller != null) {
      controller
        ..removeZoomingListener(_handleZooming)
        ..removePanningListener(_handlePanning)
        ..removeResetListener(_handleReset)
        ..removeRefreshListener(_handleRefresh);
    }
    _animation?.removeListener(markNeedsPaint);
    _hoverColorAnimation?.removeListener(markNeedsPaint);
    linesInList?.clear();
    linesInList = null;
    super.detach();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void performLayout() {
    size = getBoxSize(constraints);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_animation != null && _animation.value == 0.0) {
      return;
    }
    context.canvas.save();
    Offset startPoint;
    Offset endPoint;
    final bool isTileLayer = controller.tileCurrentLevelDetails != null;
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;
    Path path = Path();
    final Size boxSize = isTileLayer ? controller.totalTileSize : size;
    final Offset translationOffset =
        _getTranslationOffset(controller, isTileLayer);
    controller.applyTransform(context, offset, true);

    for (final MapLine line in lines) {
      startPoint = pixelFromLatLng(
        line.from.latitude,
        line.from.longitude,
        boxSize,
        translationOffset,
        controller.shapeLayerSizeFactor,
      );
      endPoint = pixelFromLatLng(
        line.to.latitude,
        line.to.longitude,
        boxSize,
        translationOffset,
        controller.shapeLayerSizeFactor,
      );

      if (_previousHoverItem != null &&
          _previousHoverItem == line &&
          _themeData.shapeHoverColor != Colors.transparent) {
        paint.color = _reverseHoverColor.evaluate(_hoverColorAnimation);
      } else if (_currentHoverItem != null &&
          selectedLine == line &&
          _themeData.shapeHoverColor != Colors.transparent) {
        paint.color = _forwardHoverColor.evaluate(_hoverColorAnimation);
      } else {
        paint.color = line.color ?? _color;
      }

      paint.strokeWidth = _getDesiredValue(line.width ?? _width, controller);
      path
        ..reset()
        ..moveTo(startPoint.dx, startPoint.dy)
        ..lineTo(endPoint.dx, endPoint.dy);
      if (_animation != null) {
        path = _getAnimatedPath(path, _animation);
      }
      _drawDashedLine(context.canvas, line.dashArray, paint, path);
    }
    context.canvas.restore();
  }
}

/// A sublayer which renders group of [MapArc] on [MapShapeLayer] and
/// [MapTileLayer].
///
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///  return Scaffold(
///    body: SfMaps(
///      layers: [
///       MapShapeLayer(
///          source: MapShapeSource.asset(
///             "assets/world_map.json",
///              shapeDataField: "continent",
///          ),
///          sublayers: [
///           MapArcLayer(
///              arcs: List<MapArc>.generate(
///               arcs.length,
///                (int index) {
///                 return MapArc(
///                    from: arcs[index].from,
///                    to: arcs[index].to,
///                  );
///                },
///              ).toSet(),
///            ),
///          ],
///        ),
///      ],
///    ),
/// );
/// }
/// ```
///
/// See also:
/// * [MapLineLayer], for adding lines.
/// * [MapPolylineLayer], for polylines.
/// * [MapCircleLayer], for adding circles.
/// * [MapPolygonLayer], for adding polygons.
class MapArcLayer extends MapVectorLayer {
  /// Creates the [MapArcLayer].
  MapArcLayer({
    Key key,
    @required this.arcs,
    this.animation,
    this.color,
    this.width = 2,
    IndexedWidgetBuilder tooltipBuilder,
  })  : assert(arcs != null),
        super(key: key, tooltipBuilder: tooltipBuilder);

  /// A collection of [MapArc].
  ///
  /// Every single [MapArc] connects two location coordinates through an
  /// arc. The [MapArc.heightFactor] and [MapArc.controlPointFactor] can be
  /// modified to change the appearance of the arcs.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///       MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///           MapArcLayer(
  ///              arcs: List<MapArc>.generate(
  ///               arcs.length,
  ///                (int index) {
  ///                 return MapArc(
  ///                    from: arcs[index].from,
  ///                    to: arcs[index].to,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  /// );
  /// }
  /// ```
  final Set<MapArc> arcs;

  /// Animation for the [arcs] in [MapArcLayer].
  ///
  /// By default, [arcs] will be rendered without any animation. The
  /// animation can be set as shown in the below code snippet. You can customise
  /// the animation flow, curve, duration and listen to the animation status.
  ///
  /// ```dart
  /// AnimationController _animationController;
  /// Animation _animation;
  ///
  /// @override
  /// void initState() {
  ///   _animationController = AnimationController(
  ///      duration: Duration(seconds: 3),
  ///      vsync: this,
  ///   );
  ///
  ///  _animation = CurvedAnimation(
  ///    parent: _animationController,
  ///    curve: Curves.easeInOut),
  ///  );
  ///
  ///  _animationController.forward(from: 0);
  ///  super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///       MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///           MapArcLayer(
  ///              arcs: List<MapArc>.generate(
  ///               arcs.length,
  ///                (int index) {
  ///                 return MapArc(
  ///                    from: arcs[index].from,
  ///                    to: arcs[index].to,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///              animation: _animation,
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  /// );
  /// }
  ///
  ///  @override
  ///  void dispose() {
  ///    animationController?.dispose();
  ///    super.dispose();
  ///  }
  /// ```
  final Animation animation;

  /// The color of all the [arcs].
  ///
  /// For setting color for each [MapArc], please check the [MapArc.color]
  /// property.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///       MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///           MapArcLayer(
  ///              arcs: List<MapArc>.generate(
  ///               arcs.length,
  ///                (int index) {
  ///                 return MapArc(
  ///                    from: arcs[index].from,
  ///                    to: arcs[index].to,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///              color: Colors.green,
  ///              width: 2,
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  /// );
  /// }
  /// ```
  ///
  /// See also:
  /// [width], to set the width for the map arc.
  final Color color;

  /// The width of all the [arcs].
  ///
  /// For setting width for each [MapArc], please check the [MapArc.width]
  /// property.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///       MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///           MapArcLayer(
  ///              arcs: List<MapArc>.generate(
  ///               arcs.length,
  ///                (int index) {
  ///                 return MapArc(
  ///                    from: arcs[index].from,
  ///                    to: arcs[index].to,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///              width: 2,
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  /// );
  /// }
  /// ```
  /// See also:
  /// [color], to set the color.
  final double width;

  @override
  Widget build(BuildContext context) {
    return _MapArcLayer(
      arcs: arcs,
      animation: animation,
      color: color,
      width: width,
      tooltipBuilder: tooltipBuilder,
      arcLayer: this,
    );
  }
}

class _MapArcLayer extends StatefulWidget {
  const _MapArcLayer({
    this.arcs,
    this.animation,
    this.color,
    this.width,
    this.tooltipBuilder,
    this.arcLayer,
  });

  final Set<MapArc> arcs;
  final Animation animation;
  final Color color;
  final double width;
  final IndexedWidgetBuilder tooltipBuilder;
  final MapArcLayer arcLayer;

  @override
  _MapArcLayerState createState() => _MapArcLayerState();
}

class _MapArcLayerState extends State<_MapArcLayer>
    with SingleTickerProviderStateMixin {
  AnimationController _hoverAnimationController;
  SfMapsThemeData _mapsThemeData;

  @override
  void initState() {
    super.initState();
    _hoverAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
  }

  @override
  void dispose() {
    _hoverAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows;
    _mapsThemeData = SfMapsTheme.of(context);
    return _MapArcLayerRenderObject(
      arcs: widget.arcs,
      animation: widget.animation,
      color: widget.color ??
          (_mapsThemeData.brightness == Brightness.light
              ? const Color.fromRGBO(140, 140, 140, 1)
              : const Color.fromRGBO(208, 208, 208, 1)),
      width: widget.width,
      tooltipBuilder: widget.tooltipBuilder,
      arcLayer: widget.arcLayer,
      themeData: _mapsThemeData,
      isDesktop: isDesktop,
      hoverAnimationController: _hoverAnimationController,
    );
  }
}

class _MapArcLayerRenderObject extends LeafRenderObjectWidget {
  const _MapArcLayerRenderObject({
    this.arcs,
    this.animation,
    this.color,
    this.width,
    this.tooltipBuilder,
    this.arcLayer,
    this.themeData,
    this.isDesktop,
    this.hoverAnimationController,
  });

  final Set<MapArc> arcs;
  final Animation animation;
  final Color color;
  final double width;
  final IndexedWidgetBuilder tooltipBuilder;
  final MapArcLayer arcLayer;
  final SfMapsThemeData themeData;
  final bool isDesktop;
  final AnimationController hoverAnimationController;

  @override
  _RenderMapArc createRenderObject(BuildContext context) {
    return _RenderMapArc(
      arcs: arcs,
      animation: animation,
      color: color,
      width: width,
      tooltipBuilder: tooltipBuilder,
      context: context,
      arcLayer: arcLayer,
      themeData: themeData,
      isDesktop: isDesktop,
      hoverAnimationController: hoverAnimationController,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderMapArc renderObject) {
    renderObject
      ..arcs = arcs
      ..animation = animation
      ..color = color
      ..width = width
      ..tooltipBuilder = tooltipBuilder
      ..context = context
      ..arcLayer = arcLayer
      ..themeData = themeData;
  }
}

class _RenderMapArc extends RenderBox implements MouseTrackerAnnotation {
  _RenderMapArc({
    Set<MapArc> arcs,
    Animation animation,
    Color color,
    double width,
    IndexedWidgetBuilder tooltipBuilder,
    BuildContext context,
    MapArcLayer arcLayer,
    SfMapsThemeData themeData,
    bool isDesktop,
    AnimationController hoverAnimationController,
  })  : _arcs = arcs,
        _color = color,
        _width = width,
        _animation = animation,
        _tooltipBuilder = tooltipBuilder,
        context = context,
        arcLayer = arcLayer,
        _themeData = themeData,
        isDesktop = isDesktop,
        hoverAnimationController = hoverAnimationController {
    _forwardHoverColor = ColorTween();
    _reverseHoverColor = ColorTween();
    _hoverColorAnimation = CurvedAnimation(
        parent: hoverAnimationController, curve: Curves.easeInOut);
    arcsInList = _arcs?.toList();
    _tapGestureRecognizer = TapGestureRecognizer()..onTapUp = _handleTapUp;
  }

  TapGestureRecognizer _tapGestureRecognizer;
  MapController controller;
  RenderSublayerContainer vectorLayerContainer;
  MapArcLayer arcLayer;
  BuildContext context;
  MapArc selectedArc;
  int selectedIndex = -1;
  double touchTolerance = 5;
  List<Offset> selectedLinePoints;
  List<MapArc> arcsInList;
  AnimationController hoverAnimationController;
  Animation<double> _hoverColorAnimation;
  ColorTween _forwardHoverColor;
  ColorTween _reverseHoverColor;
  MapArc _previousHoverItem;
  MapArc _currentHoverItem;
  bool isDesktop;

  Set<MapArc> get arcs => _arcs;
  Set<MapArc> _arcs;
  set arcs(Set<MapArc> value) {
    assert(value != null);
    if (_arcs == value || value == null) {
      return;
    }
    _arcs = value;
    arcsInList = _arcs?.toList();
    markNeedsPaint();
  }

  IndexedWidgetBuilder get tooltipBuilder => _tooltipBuilder;
  IndexedWidgetBuilder _tooltipBuilder;
  set tooltipBuilder(IndexedWidgetBuilder value) {
    if (_tooltipBuilder == value) {
      return;
    }
    _tooltipBuilder = value;
  }

  Color get color => _color;
  Color _color;
  set color(Color value) {
    if (_color == value) {
      return;
    }
    _color = value;
    // The previousHoverItem is not null when change the arc color dynamically
    // after hover on the [MapArc]. So reset the previousHoverItem here.
    if (isDesktop && _previousHoverItem != null) {
      _previousHoverItem = null;
    }
    markNeedsPaint();
  }

  double get width => _width;
  double _width;
  set width(double value) {
    if (_width == value) {
      return;
    }
    _width = value;
    markNeedsPaint();
  }

  SfMapsThemeData get themeData => _themeData;
  SfMapsThemeData _themeData;
  set themeData(SfMapsThemeData value) {
    if (_themeData == value) {
      return;
    }
    _themeData = value;
    markNeedsPaint();
  }

  Animation get animation => _animation;
  Animation _animation;
  set animation(Animation value) {
    if (_animation == value) {
      return;
    }
    _animation = value;
  }

  void _updateHoverItemTween() {
    if (isDesktop) {
      final Color hoverStrokeColor = _getHoverColor(selectedArc);
      final Color beginColor = selectedArc.color ?? _color;

      if (_previousHoverItem != null) {
        _reverseHoverColor.begin = hoverStrokeColor;
        _reverseHoverColor.end = beginColor;
      }

      if (_currentHoverItem != null) {
        _forwardHoverColor.begin = beginColor;
        _forwardHoverColor.end = hoverStrokeColor;
      }
      hoverAnimationController.forward(from: 0);
    }
  }

  Color _getHoverColor(MapArc arc) {
    final Color color = arc.color ?? _color;
    final bool canAdjustHoverOpacity =
        double.parse(color.opacity.toStringAsFixed(2)) != hoverColorOpacity;
    return _themeData.shapeHoverColor != null &&
            _themeData.shapeHoverColor != Colors.transparent
        ? _themeData.shapeHoverColor
        : color.withOpacity(
            canAdjustHoverOpacity ? hoverColorOpacity : minHoverOpacity);
  }

  void _handleTapUp(TapUpDetails details) {
    selectedArc.onTap?.call();
    _handleInteraction(details.localPosition);
  }

  void _handlePointerExit(PointerExitEvent event) {
    if (isDesktop && _currentHoverItem != null) {
      _previousHoverItem = _currentHoverItem;
      _currentHoverItem = null;
      _updateHoverItemTween();
    }

    final RenderSublayerContainer vectorParent = parent;
    final ShapeLayerChildRenderBoxBase tooltipRenderer =
        vectorParent.tooltipKey?.currentContext?.findRenderObject();
    tooltipRenderer?.hideTooltip();
  }

  void _handleZooming(MapZoomDetails details) {
    markNeedsPaint();
  }

  void _handlePanning(MapPanDetails details) {
    markNeedsPaint();
  }

  void _handleReset() {
    markNeedsPaint();
  }

  void _handleRefresh() {
    markNeedsPaint();
  }

  @override
  MouseCursor get cursor => SystemMouseCursors.basic;

  @override
  PointerEnterEventListener get onEnter => null;

  // As onHover property of MouseHoverAnnotation was removed only in the
  // beta channel, once it is moved to stable, will remove this property.
  @override
  // ignore: override_on_non_overriding_member
  PointerHoverEventListener get onHover => null;

  @override
  PointerExitEventListener get onExit => _handlePointerExit;

  @override
  // ignore: override_on_non_overriding_member
  bool get validForMouseTracker => true;

  void _handleInteraction(Offset position) {
    final RenderSublayerContainer vectorParent = parent;
    if (vectorParent.tooltipKey != null && _tooltipBuilder != null) {
      final ShapeLayerChildRenderBoxBase tooltipRenderer =
          vectorParent.tooltipKey.currentContext.findRenderObject();
      tooltipRenderer.paintTooltip(
        selectedIndex,
        null,
        MapLayerElement.vector,
        vectorParent.getSublayerIndex(arcLayer),
        position,
      );
    }
  }

  @override
  bool hitTestSelf(Offset position) {
    if (_animation != null && !_animation.isCompleted) {
      return false;
    }

    final bool isTileLayer = controller.tileCurrentLevelDetails != null;
    final Size boxSize = isTileLayer ? controller.totalTileSize : size;
    final Offset translationOffset =
        _getTranslationOffset(controller, isTileLayer);
    int index = arcsInList.length - 1;
    for (final MapArc arc in arcsInList?.reversed) {
      final double width = arc.width ?? _width;
      if (arc.onTap != null || _tooltipBuilder != null || isDesktop) {
        final double actualTouchTolerance =
            width < touchTolerance ? touchTolerance : width / 2;
        Offset startPoint = pixelFromLatLng(
          arc.from.latitude,
          arc.from.longitude,
          boxSize,
          translationOffset,
          controller.shapeLayerSizeFactor,
        );
        Offset endPoint = pixelFromLatLng(
          arc.to.latitude,
          arc.to.longitude,
          boxSize,
          translationOffset,
          controller.shapeLayerSizeFactor,
        );
        startPoint = _updatePointsToScaledPosition(startPoint, controller);
        endPoint = _updatePointsToScaledPosition(endPoint, controller);
        final Offset controlPoint = _calculateControlPoint(
            startPoint, endPoint, arc.heightFactor, arc.controlPointFactor);

        if (_liesPointOnArc(startPoint, endPoint, controlPoint,
            actualTouchTolerance, position)) {
          selectedArc = arc;
          selectedIndex = index;
          return true;
        }
      }
      index--;
    }

    return false;
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    if (event is PointerDownEvent) {
      _tapGestureRecognizer.addPointer(event);
    } else if (event is PointerHoverEvent) {
      if (isDesktop && _currentHoverItem != selectedArc) {
        _previousHoverItem = _currentHoverItem;
        _currentHoverItem = selectedArc;
        _updateHoverItemTween();
      }

      final RenderBox renderBox = context.findRenderObject();
      _handleInteraction(renderBox.globalToLocal(event.position));
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    vectorLayerContainer = parent;
    controller = vectorLayerContainer.controller;
    if (controller != null) {
      controller
        ..addZoomingListener(_handleZooming)
        ..addPanningListener(_handlePanning)
        ..addResetListener(_handleReset)
        ..addRefreshListener(_handleRefresh);
    }
    _animation?.addListener(markNeedsPaint);
    _hoverColorAnimation?.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    if (controller != null) {
      controller
        ..removeZoomingListener(_handleZooming)
        ..removePanningListener(_handlePanning)
        ..removeResetListener(_handleReset)
        ..removeRefreshListener(_handleRefresh);
    }
    _animation?.removeListener(markNeedsPaint);
    _hoverColorAnimation?.removeListener(markNeedsPaint);
    arcsInList?.clear();
    arcsInList = null;
    super.detach();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void performLayout() {
    size = getBoxSize(constraints);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_animation != null && _animation.value == 0) {
      return;
    }
    context.canvas.save();
    Offset startPoint;
    Offset endPoint;
    final bool isTileLayer = controller.tileCurrentLevelDetails != null;
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;
    Path path = Path();
    final Size boxSize = isTileLayer ? controller.totalTileSize : size;
    final Offset translationOffset =
        _getTranslationOffset(controller, isTileLayer);
    controller.applyTransform(context, offset, true);

    for (final MapArc arc in arcs) {
      startPoint = pixelFromLatLng(
        arc.from.latitude,
        arc.from.longitude,
        boxSize,
        translationOffset,
        controller.shapeLayerSizeFactor,
      );
      endPoint = pixelFromLatLng(
        arc.to.latitude,
        arc.to.longitude,
        boxSize,
        translationOffset,
        controller.shapeLayerSizeFactor,
      );
      final Offset controlPoint = _calculateControlPoint(
          startPoint, endPoint, arc.heightFactor, arc.controlPointFactor);

      if (_previousHoverItem != null &&
          _previousHoverItem == arc &&
          _themeData.shapeHoverColor != Colors.transparent) {
        paint.color = _reverseHoverColor.evaluate(_hoverColorAnimation);
      } else if (_currentHoverItem != null &&
          selectedArc == arc &&
          _themeData.shapeHoverColor != Colors.transparent) {
        paint.color = _forwardHoverColor.evaluate(_hoverColorAnimation);
      } else {
        paint.color = arc.color ?? _color;
      }

      paint.strokeWidth = _getDesiredValue(arc.width ?? _width, controller);
      path
        ..reset()
        ..moveTo(startPoint.dx, startPoint.dy)
        ..quadraticBezierTo(
            controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
      if (_animation != null) {
        path = _getAnimatedPath(path, _animation);
      }
      _drawDashedLine(context.canvas, arc.dashArray, paint, path);
    }
    context.canvas.restore();
  }

  Offset _calculateControlPoint(Offset startPoint, Offset endPoint,
      double heightFactor, double controlPointFactor) {
    final double width = endPoint.dx - startPoint.dx;
    final double height = endPoint.dy - startPoint.dy;
    // Calculating curve height from base line based on the value of
    // [MapArc.heightFactor].
    final double horizontalDistance = heightFactor * height;
    final double verticalDistance = heightFactor * width;

    // Calculating curve bend point based on the [MapArc.controlPointFactor]
    // value. Converting factor value into pixel value using this formula
    // (((1 − factor)𝑥0 + factor * 𝑥1),((1 − factor)𝑦0 + factor * 𝑦1))
    Offset controlPoint = Offset(
        ((1 - controlPointFactor) * startPoint.dx +
            controlPointFactor * endPoint.dx),
        ((1 - controlPointFactor) * startPoint.dy +
            controlPointFactor * endPoint.dy));

    if (startPoint.dx < endPoint.dx) {
      controlPoint = Offset(controlPoint.dx + horizontalDistance,
          controlPoint.dy - verticalDistance);
    } else {
      controlPoint = Offset(controlPoint.dx - horizontalDistance,
          controlPoint.dy + verticalDistance);
    }
    return controlPoint;
  }
}

/// A sublayer which renders group of [MapPolyline] on [MapShapeLayer] and
/// [MapTileLayer].
///
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///  return Scaffold(
///    body: SfMaps(
///     layers: [
///        MapShapeLayer(
///          source: MapShapeSource.asset(
///             "assets/world_map.json",
///              shapeDataField: "continent",
///          ),
///          sublayers: [
///            MapPolylineLayer(
///              polylines: List<MapPolyline>.generate(
///                polylines.length,
///                (int index) {
///                  return MapPolyline(
///                    points: polylines[index].points,
///                  );
///                },
///              ).toSet(),
///            ),
///          ],
///       ),
///      ],
///    ),
///  );
/// }
/// ```
///
/// See also:
/// * [MapLineLayer], for adding lines.
/// * [MapArcLayer], for arcs.
/// * [MapCircleLayer], for adding circles.
/// * [MapPolygonLayer], for adding polygons.
class MapPolylineLayer extends MapVectorLayer {
  /// Creates the [MapPolylineLayer].
  MapPolylineLayer({
    Key key,
    @required this.polylines,
    this.animation,
    this.color,
    this.width = 2,
    IndexedWidgetBuilder tooltipBuilder,
  })  : assert(polylines != null),
        super(key: key, tooltipBuilder: tooltipBuilder);

  /// A collection of [MapPolyline].
  ///
  /// Every single [MapPolyline] connects multiple location coordinates through
  /// group of [MapPolyline.points].
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///     layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapPolylineLayer(
  ///              polylines: List<MapPolyline>.generate(
  ///                polylines.length,
  ///                (int index) {
  ///                  return MapPolyline(
  ///                    points: polylines[index].points,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///       ),
  ///      ],
  ///    ),
  ///  );
  /// }
  /// ```
  final Set<MapPolyline> polylines;

  /// Animation for the [polylines] in [MapPolylineLayer].
  ///
  /// By default, [polylines] will be rendered without any animation. The
  /// animation can be set as shown in the below code snippet. You can customise
  /// the animation flow, curve, duration and listen to the animation status.
  ///
  /// ```dart
  /// AnimationController _animationController;
  /// Animation _animation;
  ///
  /// @override
  /// void initState() {
  ///   _animationController = AnimationController(
  ///      duration: Duration(seconds: 3),
  ///      vsync: this,
  ///   );
  ///
  ///  _animation = CurvedAnimation(
  ///    parent: _animationController,
  ///    curve: Curves.easeInOut),
  ///  );
  ///
  ///  _animationController.forward(from: 0);
  ///  super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///     layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapPolylineLayer(
  ///              polylines: List<MapPolyline>.generate(
  ///                polylines.length,
  ///                (int index) {
  ///                  return MapPolyline(
  ///                    points: polylines[index].points,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///              animation: _animation,
  ///            ),
  ///          ],
  ///       ),
  ///      ],
  ///    ),
  ///  );
  /// }
  ///
  ///  @override
  ///  void dispose() {
  ///    _animationController?.dispose();
  ///    super.dispose();
  ///  }
  /// ```
  final Animation animation;

  /// The color of all the [polylines].
  ///
  /// For setting color for each [MapPolyline], please check the
  /// [MapPolyline.color] property.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///     layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapPolylineLayer(
  ///              polylines: List<MapPolyline>.generate(
  ///                polylines.length,
  ///                (int index) {
  ///                  return MapPolyline(
  ///                    points: polylines[index].points,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///              color: Colors.green,
  ///            ),
  ///          ],
  ///       ),
  ///      ],
  ///    ),
  ///  );
  /// }
  /// ```
  ///
  /// See also:
  /// [width], for setting the width.
  final Color color;

  /// The width of all the [polylines].
  ///
  /// For setting width for each [MapPolyline], please check the
  /// [MapPolyline.width] property.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///     layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapPolylineLayer(
  ///              polylines: List<MapPolyline>.generate(
  ///                polylines.length,
  ///                (int index) {
  ///                  return MapPolyline(
  ///                    points: polylines[index].points,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///              color: Colors.green,
  ///              width: 5,
  ///            ),
  ///          ],
  ///       ),
  ///      ],
  ///    ),
  ///  );
  /// }
  /// ```
  ///
  /// See also:
  /// [color], for setting the color.
  final double width;

  @override
  Widget build(BuildContext context) {
    return _MapPolylineLayer(
      polylines: polylines,
      animation: animation,
      color: color,
      width: width,
      tooltipBuilder: tooltipBuilder,
      polylineLayer: this,
    );
  }
}

class _MapPolylineLayer extends StatefulWidget {
  const _MapPolylineLayer({
    this.polylines,
    this.animation,
    this.color,
    this.width,
    this.tooltipBuilder,
    this.polylineLayer,
  });

  final Set<MapPolyline> polylines;
  final Animation animation;
  final Color color;
  final double width;
  final IndexedWidgetBuilder tooltipBuilder;
  final MapPolylineLayer polylineLayer;

  @override
  _MapPolylineLayerState createState() => _MapPolylineLayerState();
}

class _MapPolylineLayerState extends State<_MapPolylineLayer>
    with SingleTickerProviderStateMixin {
  AnimationController _hoverAnimationController;
  SfMapsThemeData _mapsThemeData;

  @override
  void initState() {
    super.initState();
    _hoverAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
  }

  @override
  void dispose() {
    _hoverAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows;
    _mapsThemeData = SfMapsTheme.of(context);
    return _MapPolylineLayerRenderObject(
      polylines: widget.polylines,
      animation: widget.animation,
      color: widget.color ??
          (_mapsThemeData.brightness == Brightness.light
              ? const Color.fromRGBO(140, 140, 140, 1)
              : const Color.fromRGBO(208, 208, 208, 1)),
      width: widget.width,
      tooltipBuilder: widget.tooltipBuilder,
      polylineLayer: widget.polylineLayer,
      isDesktop: isDesktop,
      themeData: _mapsThemeData,
      hoverAnimationController: _hoverAnimationController,
    );
  }
}

class _MapPolylineLayerRenderObject extends LeafRenderObjectWidget {
  const _MapPolylineLayerRenderObject({
    this.polylines,
    this.animation,
    this.color,
    this.width,
    this.tooltipBuilder,
    this.polylineLayer,
    this.themeData,
    this.isDesktop,
    this.hoverAnimationController,
  });

  final Set<MapPolyline> polylines;
  final Animation animation;
  final Color color;
  final double width;
  final IndexedWidgetBuilder tooltipBuilder;
  final MapPolylineLayer polylineLayer;
  final SfMapsThemeData themeData;
  final bool isDesktop;
  final AnimationController hoverAnimationController;

  @override
  _RenderMapPolyline createRenderObject(BuildContext context) {
    return _RenderMapPolyline(
      polylines: polylines,
      animation: animation,
      color: color,
      width: width,
      tooltipBuilder: tooltipBuilder,
      context: context,
      polylineLayer: polylineLayer,
      themeData: themeData,
      isDesktop: isDesktop,
      hoverAnimationController: hoverAnimationController,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderMapPolyline renderObject) {
    renderObject
      ..polylines = polylines
      ..animation = animation
      ..color = color
      ..width = width
      ..tooltipBuilder = tooltipBuilder
      ..context = context
      ..polylineLayer = polylineLayer
      ..themeData = themeData;
  }
}

class _RenderMapPolyline extends RenderBox implements MouseTrackerAnnotation {
  _RenderMapPolyline({
    Set<MapPolyline> polylines,
    Animation animation,
    Color color,
    double width,
    IndexedWidgetBuilder tooltipBuilder,
    BuildContext context,
    MapPolylineLayer polylineLayer,
    SfMapsThemeData themeData,
    bool isDesktop,
    AnimationController hoverAnimationController,
  })  : _polylines = polylines,
        _color = color,
        _width = width,
        _animation = animation,
        _tooltipBuilder = tooltipBuilder,
        context = context,
        polylineLayer = polylineLayer,
        _themeData = themeData,
        isDesktop = isDesktop,
        hoverAnimationController = hoverAnimationController {
    _forwardHoverColor = ColorTween();
    _reverseHoverColor = ColorTween();
    _hoverColorAnimation = CurvedAnimation(
        parent: hoverAnimationController, curve: Curves.easeInOut);
    polylinesInList = _polylines?.toList();
    _tapGestureRecognizer = TapGestureRecognizer()..onTapUp = _handleTapUp;
  }

  TapGestureRecognizer _tapGestureRecognizer;
  MapController controller;
  RenderSublayerContainer vectorLayerContainer;
  MapPolylineLayer polylineLayer;
  BuildContext context;
  MapPolyline selectedPolyline;
  int selectedIndex = -1;
  double touchTolerance = 5;
  List<MapPolyline> polylinesInList;
  AnimationController hoverAnimationController;
  Animation<double> _hoverColorAnimation;
  ColorTween _forwardHoverColor;
  ColorTween _reverseHoverColor;
  MapPolyline _previousHoverItem;
  MapPolyline _currentHoverItem;
  bool isDesktop;

  Set<MapPolyline> get polylines => _polylines;
  Set<MapPolyline> _polylines;
  set polylines(Set<MapPolyline> value) {
    assert(value != null);
    if (_polylines == value || value == null) {
      return;
    }
    _polylines = value;
    polylinesInList = _polylines?.toList();
    markNeedsPaint();
  }

  Animation get animation => _animation;
  Animation _animation;
  set animation(Animation value) {
    if (_animation == value) {
      return;
    }
    _animation = value;
  }

  IndexedWidgetBuilder get tooltipBuilder => _tooltipBuilder;
  IndexedWidgetBuilder _tooltipBuilder;
  set tooltipBuilder(IndexedWidgetBuilder value) {
    if (_tooltipBuilder == value) {
      return;
    }
    _tooltipBuilder = value;
  }

  Color get color => _color;
  Color _color;
  set color(Color value) {
    if (_color == value) {
      return;
    }
    _color = value;
    // The previousHoverItem is not null when change the polyline color
    // dynamically after hover on the [MapPolyline]. So reset the
    // previousHoverItem here.
    if (isDesktop && _previousHoverItem != null) {
      _previousHoverItem = null;
    }
    markNeedsPaint();
  }

  double get width => _width;
  double _width;
  set width(double value) {
    if (_width == value) {
      return;
    }
    _width = value;
    markNeedsPaint();
  }

  SfMapsThemeData get themeData => _themeData;
  SfMapsThemeData _themeData;
  set themeData(SfMapsThemeData value) {
    if (_themeData == value) {
      return;
    }
    _themeData = value;
    markNeedsPaint();
  }

  void _updateHoverItemTween() {
    if (isDesktop) {
      final Color hoverStrokeColor = _getHoverColor(selectedPolyline);
      final Color beginColor = selectedPolyline.color ?? _color;

      if (_previousHoverItem != null) {
        _reverseHoverColor.begin = hoverStrokeColor;
        _reverseHoverColor.end = beginColor;
      }

      if (_currentHoverItem != null) {
        _forwardHoverColor.begin = beginColor;
        _forwardHoverColor.end = hoverStrokeColor;
      }
      hoverAnimationController.forward(from: 0);
    }
  }

  Color _getHoverColor(MapPolyline polyline) {
    final Color color = polyline.color ?? _color;
    final bool canAdjustHoverOpacity =
        double.parse(color.opacity.toStringAsFixed(2)) != hoverColorOpacity;
    return _themeData.shapeHoverColor != null &&
            _themeData.shapeHoverColor != Colors.transparent
        ? _themeData.shapeHoverColor
        : color.withOpacity(
            canAdjustHoverOpacity ? hoverColorOpacity : minHoverOpacity);
  }

  void _handleTapUp(TapUpDetails details) {
    selectedPolyline.onTap?.call();
    _handleInteraction(details.localPosition);
  }

  void _handlePointerExit(PointerExitEvent event) {
    if (isDesktop && _currentHoverItem != null) {
      _previousHoverItem = _currentHoverItem;
      _currentHoverItem = null;
      _updateHoverItemTween();
    }

    final RenderSublayerContainer vectorParent = parent;
    final ShapeLayerChildRenderBoxBase tooltipRenderer =
        vectorParent.tooltipKey?.currentContext?.findRenderObject();
    tooltipRenderer?.hideTooltip();
  }

  void _handleZooming(MapZoomDetails details) {
    markNeedsPaint();
  }

  void _handlePanning(MapPanDetails details) {
    markNeedsPaint();
  }

  void _handleReset() {
    markNeedsPaint();
  }

  void _handleRefresh() {
    markNeedsPaint();
  }

  void _handleInteraction(Offset position) {
    final RenderSublayerContainer vectorParent = parent;
    if (vectorParent.tooltipKey != null && _tooltipBuilder != null) {
      final ShapeLayerChildRenderBoxBase tooltipRenderer =
          vectorParent.tooltipKey.currentContext.findRenderObject();
      tooltipRenderer.paintTooltip(
        selectedIndex,
        null,
        MapLayerElement.vector,
        vectorParent.getSublayerIndex(polylineLayer),
        position,
      );
    }
  }

  @override
  MouseCursor get cursor => SystemMouseCursors.basic;

  @override
  PointerEnterEventListener get onEnter => null;

  // As onHover property of MouseHoverAnnotation was removed only in the
  // beta channel, once it is moved to stable, will remove this property.
  @override
  // ignore: override_on_non_overriding_member
  PointerHoverEventListener get onHover => null;

  @override
  PointerExitEventListener get onExit => _handlePointerExit;

  @override
  // ignore: override_on_non_overriding_member
  bool get validForMouseTracker => true;

  @override
  bool hitTestSelf(Offset position) {
    if (_animation != null && !_animation.isCompleted) {
      return false;
    }

    final bool isTileLayer = controller.tileCurrentLevelDetails != null;
    final Size boxSize = isTileLayer ? controller.totalTileSize : size;
    final Offset translationOffset =
        _getTranslationOffset(controller, isTileLayer);
    bool tappedOnLine = false;
    int index = polylinesInList.length - 1;
    for (final MapPolyline polyline in polylinesInList?.reversed) {
      if (tappedOnLine) {
        return true;
      }
      final double width = polyline.width ?? _width;
      if (polyline.onTap != null || _tooltipBuilder != null || isDesktop) {
        final double actualTouchTolerance =
            width < touchTolerance ? touchTolerance : width / 2;

        for (int j = 0; j < polyline.points.length - 1; j++) {
          final MapLatLng currentPoint = polyline.points[j];
          final MapLatLng nextPoint = polyline.points[j + 1];
          Offset startPoint = pixelFromLatLng(
            currentPoint.latitude,
            currentPoint.longitude,
            boxSize,
            translationOffset,
            controller.shapeLayerSizeFactor,
          );
          Offset endPoint = pixelFromLatLng(
            nextPoint.latitude,
            nextPoint.longitude,
            boxSize,
            translationOffset,
            controller.shapeLayerSizeFactor,
          );
          startPoint = _updatePointsToScaledPosition(startPoint, controller);
          endPoint = _updatePointsToScaledPosition(endPoint, controller);

          if (_liesPointOnLine(
              startPoint, endPoint, actualTouchTolerance, position)) {
            tappedOnLine = true;
            selectedPolyline = polyline;
            selectedIndex = index;
            return true;
          }
        }
      }
      index--;
    }

    return false;
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    vectorLayerContainer = parent;
    controller = vectorLayerContainer.controller;
    if (controller != null) {
      controller
        ..addZoomingListener(_handleZooming)
        ..addPanningListener(_handlePanning)
        ..addResetListener(_handleReset)
        ..addRefreshListener(_handleRefresh);
    }
    _animation?.addListener(markNeedsPaint);
    _hoverColorAnimation?.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    if (controller != null) {
      controller
        ..removeZoomingListener(_handleZooming)
        ..removePanningListener(_handlePanning)
        ..removeResetListener(_handleReset)
        ..removeRefreshListener(_handleRefresh);
    }
    _animation?.removeListener(markNeedsPaint);
    _hoverColorAnimation?.removeListener(markNeedsPaint);
    polylinesInList?.clear();
    polylinesInList = null;
    super.detach();
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    if (event is PointerDownEvent) {
      _tapGestureRecognizer.addPointer(event);
    } else if (event is PointerHoverEvent) {
      if (isDesktop && _currentHoverItem != selectedPolyline) {
        _previousHoverItem = _currentHoverItem;
        _currentHoverItem = selectedPolyline;
        _updateHoverItemTween();
      }

      final RenderBox renderBox = context.findRenderObject();
      _handleInteraction(renderBox.globalToLocal(event.position));
    }
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void performLayout() {
    size = getBoxSize(constraints);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_animation != null && _animation.value == 0.0) {
      return;
    }
    context.canvas.save();
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;
    Path path = Path();
    final bool isTileLayer = controller.tileCurrentLevelDetails != null;
    final Size boxSize = isTileLayer ? controller.totalTileSize : size;
    final Offset translationOffset =
        _getTranslationOffset(controller, isTileLayer);
    controller.applyTransform(context, offset, true);
    for (final MapPolyline polyline in polylines) {
      if (polyline.points != null) {
        final MapLatLng startCoordinate = polyline.points[0];
        final Offset startPoint = pixelFromLatLng(
            startCoordinate.latitude,
            startCoordinate.longitude,
            boxSize,
            translationOffset,
            controller.shapeLayerSizeFactor);
        path
          ..reset()
          ..moveTo(startPoint.dx, startPoint.dy);

        for (int j = 1; j < polyline.points.length; j++) {
          final MapLatLng nextCoordinate = polyline.points[j];
          final Offset nextPoint = pixelFromLatLng(
              nextCoordinate.latitude,
              nextCoordinate.longitude,
              boxSize,
              translationOffset,
              controller.shapeLayerSizeFactor);
          path.lineTo(nextPoint.dx, nextPoint.dy);
        }

        if (_previousHoverItem != null &&
            _previousHoverItem == polyline &&
            _themeData.shapeHoverColor != Colors.transparent) {
          paint.color = _reverseHoverColor.evaluate(_hoverColorAnimation);
        } else if (_currentHoverItem != null &&
            selectedPolyline == polyline &&
            _themeData.shapeHoverColor != Colors.transparent) {
          paint.color = _forwardHoverColor.evaluate(_hoverColorAnimation);
        } else {
          paint.color = polyline.color ?? _color;
        }

        paint.strokeWidth =
            _getDesiredValue(polyline.width ?? _width, controller);
        if (_animation != null) {
          path = _getAnimatedPath(path, _animation);
        }
        _drawDashedLine(context.canvas, polyline.dashArray, paint, path);
      }
    }
    context.canvas.restore();
  }
}

/// A sublayer which renders group of [MapPolygon] on [MapShapeLayer] and
/// [MapTileLayer].
///
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///  return Scaffold(
///    body: SfMaps(
///      layers: [
///        MapShapeLayer(
///          source: MapShapeSource.asset(
///             "assets/world_map.json",
///              shapeDataField: "continent",
///          ),
///          sublayers: [
///            MapPolygonLayer(
///              polygons: List<MapPolygon>.generate(
///                polygons.length,
///                (int index) {
///                  return MapPolygon(
///                    points: polygons[index].points,
///                  );
///                },
///              ).toSet(),
///            ),
///          ],
///        ),
///      ],
///    ),
///  );
/// }
/// ```
class MapPolygonLayer extends MapVectorLayer {
  /// Creates the [MapPolygonLayer].
  MapPolygonLayer({
    Key key,
    @required this.polygons,
    this.color = const Color.fromRGBO(51, 153, 144, 1),
    this.strokeWidth = 1,
    this.strokeColor = const Color.fromRGBO(51, 153, 144, 1),
    IndexedWidgetBuilder tooltipBuilder,
  })  : assert(polygons != null),
        super(key: key, tooltipBuilder: tooltipBuilder);

  /// A collection of [MapPolygon].
  ///
  /// Every single [MapPolygon] is a closed path which connects multiple
  /// location coordinates through group of [MapPolygon.points].
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapPolygonLayer(
  ///              polygons: List<MapPolygon>.generate(
  ///                polygons.length,
  ///                (int index) {
  ///                  return MapPolygon(
  ///                    points: polygons[index].points,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  ///```
  final Set<MapPolygon> polygons;

  /// The fill color of all the [MapPolygon].
  ///
  /// For setting color for each [MapPolygon], please check the
  /// [MapPolygon.color] property.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapPolygonLayer(
  ///              polygons: List<MapPolygon>.generate(
  ///                polygons.length,
  ///                (int index) {
  ///                  return MapPolygon(
  ///                    points: polygons[index].points,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///              color: Colors.red,
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  ///```
  final Color color;

  /// The stroke width of all the [MapPolygon].
  ///
  /// For setting stroke width for each [MapPolygon], please check the
  /// [MapPolygon.strokeWidth] property.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapPolygonLayer(
  ///              polygons: List<MapPolygon>.generate(
  ///                polygons.length,
  ///                (int index) {
  ///                  return MapPolygon(
  ///                    points: polygons[index].points,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///              strokeColor: Colors.red,
  ///              strokeWidth: 5,
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  ///```
  /// See also:
  /// [strokeColor], to set the stroke color for the polygon.
  final double strokeWidth;

  /// The stroke color of all the [MapPolygon].
  ///
  /// For setting stroke color for each [MapPolygon], please check the
  /// [MapPolygon.strokeColor] property.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapPolygonLayer(
  ///              polygons: List<MapPolygon>.generate(
  ///                polygons.length,
  ///                (int index) {
  ///                  return MapPolygon(
  ///                    points: polygons[index].points,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///              strokeColor: Colors.red,
  ///              strokeWidth: 5,
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  ///```
  ///
  /// See also:
  /// [strokeWidth], to set the stroke width for the polygon.
  final Color strokeColor;

  @override
  Widget build(BuildContext context) {
    return _MapPolygonLayer(
      polygons: polygons,
      color: color,
      strokeWidth: strokeWidth,
      strokeColor: strokeColor,
      tooltipBuilder: tooltipBuilder,
      polygonLayer: this,
    );
  }
}

class _MapPolygonLayer extends StatefulWidget {
  const _MapPolygonLayer({
    this.polygons,
    this.color,
    this.strokeWidth,
    this.strokeColor,
    this.tooltipBuilder,
    this.polygonLayer,
  });

  final Set<MapPolygon> polygons;
  final Color color;
  final double strokeWidth;
  final Color strokeColor;
  final IndexedWidgetBuilder tooltipBuilder;
  final MapPolygonLayer polygonLayer;

  @override
  _MapPolygonLayerState createState() => _MapPolygonLayerState();
}

class _MapPolygonLayerState extends State<_MapPolygonLayer>
    with SingleTickerProviderStateMixin {
  AnimationController _hoverAnimationController;
  SfMapsThemeData _mapsThemeData;

  @override
  void initState() {
    super.initState();
    _hoverAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
  }

  @override
  void dispose() {
    _hoverAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows;
    _mapsThemeData = SfMapsTheme.of(context);
    return _MapPolygonLayerRenderObject(
      polygons: widget.polygons,
      color: widget.color,
      strokeWidth: widget.strokeWidth,
      strokeColor: widget.strokeColor,
      tooltipBuilder: widget.tooltipBuilder,
      polygonLayer: widget.polygonLayer,
      hoverAnimationController: _hoverAnimationController,
      themeData: _mapsThemeData,
      isDesktop: isDesktop,
    );
  }
}

class _MapPolygonLayerRenderObject extends LeafRenderObjectWidget {
  const _MapPolygonLayerRenderObject({
    this.polygons,
    this.color,
    this.strokeWidth,
    this.strokeColor,
    this.tooltipBuilder,
    this.polygonLayer,
    this.hoverAnimationController,
    this.themeData,
    this.isDesktop,
  });

  final Set<MapPolygon> polygons;
  final Color color;
  final double strokeWidth;
  final Color strokeColor;
  final IndexedWidgetBuilder tooltipBuilder;
  final MapPolygonLayer polygonLayer;
  final AnimationController hoverAnimationController;
  final SfMapsThemeData themeData;
  final bool isDesktop;

  @override
  _RenderMapPolygon createRenderObject(BuildContext context) {
    return _RenderMapPolygon(
      polygons: polygons,
      color: color,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      tooltipBuilder: tooltipBuilder,
      themeData: themeData,
      context: context,
      polygonLayer: polygonLayer,
      hoverAnimationController: hoverAnimationController,
      isDesktop: isDesktop,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderMapPolygon renderObject) {
    renderObject
      ..polygons = polygons
      ..color = color
      ..strokeColor = strokeColor
      ..strokeWidth = strokeWidth
      ..tooltipBuilder = tooltipBuilder
      ..themeData = themeData
      ..context = context
      ..polygonLayer = polygonLayer;
  }
}

class _RenderMapPolygon extends RenderBox implements MouseTrackerAnnotation {
  _RenderMapPolygon({
    Set<MapPolygon> polygons,
    Color color,
    double strokeWidth,
    Color strokeColor,
    IndexedWidgetBuilder tooltipBuilder,
    SfMapsThemeData themeData,
    BuildContext context,
    MapPolygonLayer polygonLayer,
    AnimationController hoverAnimationController,
    bool isDesktop,
  })  : _polygons = polygons,
        _color = color,
        _strokeWidth = strokeWidth,
        _strokeColor = strokeColor,
        _tooltipBuilder = tooltipBuilder,
        _themeData = themeData,
        context = context,
        polygonLayer = polygonLayer,
        hoverAnimationController = hoverAnimationController,
        isDesktop = isDesktop {
    _forwardHoverColor = ColorTween();
    _reverseHoverColor = ColorTween();
    _forwardHoverStrokeColor = ColorTween();
    _reverseHoverStrokeColor = ColorTween();
    _hoverColorAnimation = CurvedAnimation(
        parent: hoverAnimationController, curve: Curves.easeInOut);
    _polygonsInList = _polygons?.toList();
    _tapGestureRecognizer = TapGestureRecognizer()..onTapUp = _handleTapUp;
  }

  MapController controller;
  AnimationController hoverAnimationController;
  RenderSublayerContainer vectorLayerContainer;
  bool isDesktop;
  MapPolygonLayer polygonLayer;
  BuildContext context;
  TapGestureRecognizer _tapGestureRecognizer;
  Animation<double> _hoverColorAnimation;
  ColorTween _forwardHoverColor;
  ColorTween _reverseHoverColor;
  ColorTween _forwardHoverStrokeColor;
  ColorTween _reverseHoverStrokeColor;
  MapPolygon _previousHoverItem;
  MapPolygon _currentHoverItem;
  List<MapPolygon> _polygonsInList;
  int _selectedIndex = -1;
  MapPolygon _selectedPolygon;

  Set<MapPolygon> get polygons => _polygons;
  Set<MapPolygon> _polygons;
  set polygons(Set<MapPolygon> value) {
    assert(value != null);
    if (_polygons == value || value == null) {
      return;
    }
    _polygons = value;
    _polygonsInList = _polygons?.toList();
    markNeedsPaint();
  }

  IndexedWidgetBuilder get tooltipBuilder => _tooltipBuilder;
  IndexedWidgetBuilder _tooltipBuilder;
  set tooltipBuilder(IndexedWidgetBuilder value) {
    if (_tooltipBuilder == value) {
      return;
    }
    _tooltipBuilder = value;
  }

  SfMapsThemeData get themeData => _themeData;
  SfMapsThemeData _themeData;
  set themeData(SfMapsThemeData value) {
    if (_themeData == value) {
      return;
    }
    _themeData = value;
    markNeedsPaint();
  }

  Color get color => _color;
  Color _color;
  set color(Color value) {
    if (_color == value) {
      return;
    }
    _color = value;
    // The previousHoverItem is not null when change the polygon color
    // dynamically after hover on the [MapPolygon]. So reset the
    // previousHoverItem here.
    if (isDesktop && _previousHoverItem != null) {
      _previousHoverItem = null;
    }
    markNeedsPaint();
  }

  double get strokeWidth => _strokeWidth;
  double _strokeWidth;
  set strokeWidth(double value) {
    if (_strokeWidth == value) {
      return;
    }
    _strokeWidth = value;
    markNeedsPaint();
  }

  Color get strokeColor => _strokeColor;
  Color _strokeColor;
  set strokeColor(Color value) {
    if (_strokeColor == value) {
      return;
    }
    _strokeColor = value;
    // The previousHoverItem is not null when change the polygon stroke color
    // dynamically after hover on the [MapPolygon]. So reset the
    // previousHoverItem here.
    if (isDesktop && _previousHoverItem != null) {
      _previousHoverItem = null;
    }
    markNeedsPaint();
  }

  bool get canHover => hasHoverColor || hasHoverStrokeColor;

  bool get hasHoverColor =>
      isDesktop &&
      _themeData.shapeHoverColor != null &&
      _themeData.shapeHoverColor != Colors.transparent;

  bool get hasHoverStrokeColor =>
      isDesktop &&
      _themeData.shapeHoverStrokeColor != null &&
      _themeData.shapeHoverStrokeColor != Colors.transparent;

  void _initializeHoverItemTween() {
    if (isDesktop) {
      final Color hoverFillColor = _getHoverFillColor(_selectedPolygon);
      final Color hoverStrokeColor = _getHoverStrokeColor(_selectedPolygon);
      final Color defaultFillColor = _selectedPolygon.color ?? _color;
      final Color defaultStrokeColor =
          _selectedPolygon.strokeColor ?? _strokeColor;

      if (_previousHoverItem != null) {
        _reverseHoverColor.begin = hoverFillColor;
        _reverseHoverColor.end = defaultFillColor;
        _reverseHoverStrokeColor.begin = hoverStrokeColor;
        _reverseHoverStrokeColor.end = defaultStrokeColor;
      }

      if (_currentHoverItem != null) {
        _forwardHoverColor.begin = defaultFillColor;
        _forwardHoverColor.end = hoverFillColor;
        _forwardHoverStrokeColor.begin = defaultStrokeColor;
        _forwardHoverStrokeColor.end = hoverStrokeColor;
      }
      hoverAnimationController.forward(from: 0);
    }
  }

  Color _getHoverFillColor(MapPolygon polygon) {
    if (hasHoverColor) {
      return _themeData.shapeHoverColor;
    }
    final Color color = polygon.color ?? _color;
    return color.withOpacity(
        (double.parse(color.opacity.toStringAsFixed(2)) != hoverColorOpacity)
            ? hoverColorOpacity
            : minHoverOpacity);
  }

  Color _getHoverStrokeColor(MapPolygon polygon) {
    if (hasHoverStrokeColor) {
      return _themeData.shapeHoverStrokeColor;
    }
    final Color strokeColor = polygon.strokeColor ?? _strokeColor;
    return strokeColor.withOpacity(
        (double.parse(strokeColor.opacity.toStringAsFixed(2)) !=
                hoverColorOpacity)
            ? hoverColorOpacity
            : minHoverOpacity);
  }

  void _handlePointerExit(PointerExitEvent event) {
    if (isDesktop && _currentHoverItem != null) {
      _previousHoverItem = _currentHoverItem;
      _currentHoverItem = null;
      _initializeHoverItemTween();
    }
    final RenderSublayerContainer vectorParent = parent;
    final ShapeLayerChildRenderBoxBase tooltipRenderer =
        vectorParent.tooltipKey?.currentContext?.findRenderObject();
    tooltipRenderer?.hideTooltip();
  }

  void _handleZooming(MapZoomDetails details) {
    markNeedsPaint();
  }

  void _handlePanning(MapPanDetails details) {
    markNeedsPaint();
  }

  void _handleReset() {
    markNeedsPaint();
  }

  void _handleRefresh() {
    markNeedsPaint();
  }

  void _handleInteraction(Offset position) {
    final RenderSublayerContainer vectorParent = parent;
    if (vectorParent.tooltipKey != null && _tooltipBuilder != null) {
      final ShapeLayerChildRenderBoxBase tooltipRenderer =
          vectorParent.tooltipKey.currentContext.findRenderObject();
      tooltipRenderer.paintTooltip(_selectedIndex, null, MapLayerElement.vector,
          vectorParent.getSublayerIndex(polygonLayer), position);
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _selectedPolygon.onTap?.call();
    _handleInteraction(details.localPosition);
  }

  @override
  MouseCursor get cursor => SystemMouseCursors.basic;

  @override
  PointerEnterEventListener get onEnter => null;

  // As onHover property of MouseHoverAnnotation was removed only in the
  // beta channel, once it is moved to stable, will remove this property.
  @override
  // ignore: override_on_non_overriding_member
  PointerHoverEventListener get onHover => null;

  @override
  PointerExitEventListener get onExit => _handlePointerExit;

  @override
  // ignore: override_on_non_overriding_member
  bool get validForMouseTracker => true;

  @override
  bool hitTestSelf(Offset position) {
    int index = _polygonsInList.length - 1;
    final bool isTileLayer = controller.tileCurrentLevelDetails != null;
    final Size boxSize = isTileLayer ? controller.totalTileSize : size;
    final Offset translationOffset =
        _getTranslationOffset(controller, isTileLayer);
    for (final MapPolygon polygon in _polygonsInList?.reversed) {
      if (polygon.onTap != null || _tooltipBuilder != null || canHover) {
        final Path path = Path();
        if (polygon.points != null) {
          final MapLatLng startCoordinate = polygon.points[0];
          final Offset startPoint = pixelFromLatLng(
              startCoordinate.latitude,
              startCoordinate.longitude,
              boxSize,
              translationOffset,
              controller.shapeLayerSizeFactor);
          path.moveTo(startPoint.dx, startPoint.dy);

          for (int j = 1; j < polygon.points.length; j++) {
            final MapLatLng nextCoordinate = polygon.points[j];
            final Offset nextPoint = pixelFromLatLng(
                nextCoordinate.latitude,
                nextCoordinate.longitude,
                boxSize,
                translationOffset,
                controller.shapeLayerSizeFactor);
            path.lineTo(nextPoint.dx, nextPoint.dy);
          }
          path.close();
          if (path.contains(position)) {
            _selectedPolygon = polygon;
            _selectedIndex = index;
            return true;
          }
        }
      }
      index--;
    }

    return false;
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    if (event is PointerDownEvent) {
      _tapGestureRecognizer.addPointer(event);
    } else if (event is PointerHoverEvent && isDesktop) {
      if (_currentHoverItem != _selectedPolygon) {
        _previousHoverItem = _currentHoverItem;
        _currentHoverItem = _selectedPolygon;
        _initializeHoverItemTween();
      }

      final RenderBox renderBox = context.findRenderObject();
      _handleInteraction(renderBox.globalToLocal(event.position));
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    vectorLayerContainer = parent;
    controller = vectorLayerContainer.controller;
    if (controller != null) {
      controller
        ..addZoomingListener(_handleZooming)
        ..addPanningListener(_handlePanning)
        ..addResetListener(_handleReset)
        ..addRefreshListener(_handleRefresh);
    }
    _hoverColorAnimation?.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    if (controller != null) {
      controller
        ..removeZoomingListener(_handleZooming)
        ..removePanningListener(_handlePanning)
        ..removeResetListener(_handleReset)
        ..removeRefreshListener(_handleRefresh);
    }
    _hoverColorAnimation?.removeListener(markNeedsPaint);
    _polygonsInList?.clear();
    _polygonsInList = null;
    super.detach();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void performLayout() {
    size = getBoxSize(constraints);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.save();
    final Paint fillPaint = Paint()..isAntiAlias = true;
    final Paint strokePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;
    final bool isTileLayer = controller.tileCurrentLevelDetails != null;
    final Size boxSize = isTileLayer ? controller.totalTileSize : size;
    final Offset translationOffset =
        _getTranslationOffset(controller, isTileLayer);
    controller.applyTransform(context, offset, true);

    for (final MapPolygon polygon in polygons) {
      final Path path = Path();
      if (polygon.points != null) {
        final MapLatLng startLatLng = polygon.points[0];
        final Offset startPoint = pixelFromLatLng(
            startLatLng.latitude,
            startLatLng.longitude,
            boxSize,
            translationOffset,
            controller.shapeLayerSizeFactor);
        path.moveTo(startPoint.dx, startPoint.dy);

        for (int j = 1; j < polygon.points.length; j++) {
          final MapLatLng nextCoordinate = polygon.points[j];
          final Offset nextPoint = pixelFromLatLng(
              nextCoordinate.latitude,
              nextCoordinate.longitude,
              boxSize,
              translationOffset,
              controller.shapeLayerSizeFactor);
          path.lineTo(nextPoint.dx, nextPoint.dy);
        }
        path.close();
        _updateFillColor(polygon, fillPaint);
        _updateStroke(polygon, strokePaint);
        context.canvas..drawPath(path, fillPaint)..drawPath(path, strokePaint);
      }
    }
    context.canvas.restore();
  }

  void _updateFillColor(MapPolygon polygon, Paint paint) {
    if (!isDesktop) {
      paint.color = polygon.color ?? _color;
      return;
    }

    if (_previousHoverItem != null && _previousHoverItem == polygon) {
      paint.color = _themeData.shapeHoverColor != Colors.transparent
          ? _reverseHoverColor.evaluate(_hoverColorAnimation)
          : (polygon.color ?? _color);
    } else if (_currentHoverItem != null && _currentHoverItem == polygon) {
      paint.color = _themeData.shapeHoverColor != Colors.transparent
          ? _forwardHoverColor.evaluate(_hoverColorAnimation)
          : (polygon.color ?? _color);
    } else {
      paint.color = polygon.color ?? _color;
    }
  }

  void _updateStroke(MapPolygon polygon, Paint paint) {
    if (!isDesktop) {
      _updateDefaultStroke(paint, polygon);
      return;
    }

    if (_previousHoverItem != null && _previousHoverItem == polygon) {
      _updateHoverStrokeColor(paint, polygon, _reverseHoverStrokeColor);
      paint.strokeWidth =
          _getDesiredValue(polygon.strokeWidth ?? _strokeWidth, controller);
    } else if (_currentHoverItem != null && _currentHoverItem == polygon) {
      _updateHoverStrokeColor(paint, polygon, _forwardHoverStrokeColor);
      if (_themeData.shapeHoverStrokeWidth != null &&
          _themeData.shapeHoverStrokeWidth > 0.0) {
        paint.strokeWidth =
            _getDesiredValue(_themeData.shapeHoverStrokeWidth, controller);
      } else {
        paint.strokeWidth =
            _getDesiredValue(polygon.strokeWidth ?? _strokeWidth, controller);
      }
    } else {
      _updateDefaultStroke(paint, polygon);
    }
  }

  void _updateDefaultStroke(Paint paint, MapPolygon polygon) {
    paint
      ..color = polygon.strokeColor ?? _strokeColor
      ..strokeWidth =
          _getDesiredValue(polygon.strokeWidth ?? _strokeWidth, controller);
  }

  void _updateHoverStrokeColor(
      Paint paint, MapPolygon polygon, ColorTween tween) {
    if (_themeData.shapeHoverStrokeColor != Colors.transparent) {
      paint.color = tween.evaluate(_hoverColorAnimation);
    } else {
      paint.color = polygon.strokeColor ?? _strokeColor;
    }
  }
}

/// A sublayer which renders group of [MapCircle] on [MapShapeLayer] and
/// [MapTileLayer].
///
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///  return Scaffold(
///    body: SfMaps(
///      layers: [
///        MapShapeLayer(
///          source: MapShapeSource.asset(
///             "assets/world_map.json",
///              shapeDataField: "continent",
///          ),
///          sublayers: [
///            MapCircleLayer(
///              circles: List<MapCircle>.generate(
///                circles.length,
///                (int index) {
///                  return MapCircle(
///                    center: circles[index],
///                  );
///                },
///              ).toSet(),
///            ),
///          ],
///        ),
///      ],
///    ),
///  );
/// }
/// ```
class MapCircleLayer extends MapVectorLayer {
  /// Creates the [MapCircleLayer].
  MapCircleLayer({
    Key key,
    @required this.circles,
    this.animation,
    this.color = const Color.fromRGBO(51, 153, 144, 1),
    this.strokeWidth = 1,
    this.strokeColor = const Color.fromRGBO(51, 153, 144, 1),
    IndexedWidgetBuilder tooltipBuilder,
  })  : assert(circles != null),
        super(key: key, tooltipBuilder: tooltipBuilder);

  /// A collection of [MapCircle].
  ///
  /// Every single [MapCircle] is drawn based on the given [MapCircle.center]
  /// and [MapCircle.radius].
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapCircleLayer(
  ///              circles: List<MapCircle>.generate(
  ///                circles.length,
  ///                (int index) {
  ///                  return MapCircle(
  ///                    center: circles[index],
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  /// ```
  final Set<MapCircle> circles;

  /// Animation for the [circles] in [MapPolylineLayer].
  ///
  /// By default, [circles] will be rendered without any animation. The
  /// animation can be set as shown in the below code snippet. You can customise
  /// the animation flow, curve, duration and listen to the animation status.
  ///
  /// ```dart
  /// AnimationController _animationController;
  /// Animation _animation;
  ///
  /// @override
  /// void initState() {
  ///   _animationController = AnimationController(
  ///      duration: Duration(seconds: 3),
  ///      vsync: this,
  ///   );
  ///
  ///  _animation = CurvedAnimation(
  ///    parent: _animationController,
  ///    curve: Curves.easeInOut),
  ///  );
  ///
  ///  _animationController.forward(from: 0);
  ///  super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapCircleLayer(
  ///              circles: List<MapCircle>.generate(
  ///                circles.length,
  ///                (int index) {
  ///                  return MapCircle(
  ///                    center: circles[index],
  ///                  );
  ///                },
  ///              ).toSet(),
  ///              animation: _animation,
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  ///
  ///  @override
  ///  void dispose() {
  ///     _animationController?.dispose();
  ///    super.dispose();
  ///  }
  ///
  /// ```
  final Animation animation;

  /// The fill color of all the [MapCircle].
  ///
  /// For setting color for each [MapCircle], please check the
  /// [MapCircle.color] property.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapCircleLayer(
  ///              circles: List<MapCircle>.generate(
  ///                circles.length,
  ///                (int index) {
  ///                  return MapCircle(
  ///                    center: circles[index],
  ///                  );
  ///                },
  ///              ).toSet(),
  ///              color: Colors.red,
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  /// ```
  final Color color;

  /// The stroke width of all the [MapCircle].
  ///
  /// For setting stroke width for each [MapCircle], please check the
  /// [MapCircle.strokeWidth] property.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapCircleLayer(
  ///              circles: List<MapCircle>.generate(
  ///                circles.length,
  ///                (int index) {
  ///                  return MapCircle(
  ///                    center: circles[index],
  ///                  );
  ///                },
  ///              ).toSet(),
  ///              strokeWidth: 4,
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  /// ```
  /// See also:
  /// [strokeColor], to set the stroke color for the circles.
  final double strokeWidth;

  /// The stroke color of all the [MapCircle].
  ///
  /// For setting stroke color for each [MapCircle], please check the
  /// [MapCircle.strokeColor] property.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapCircleLayer(
  ///              circles: List<MapCircle>.generate(
  ///                circles.length,
  ///                (int index) {
  ///                  return MapCircle(
  ///                    center: circles[index],
  ///                  );
  ///                },
  ///              ).toSet(),
  ///              strokeWidth: 4,
  ///              strokeColor: Colors.red,
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  /// ```
  ///
  /// See also:
  /// [strokeWidth], to set the stroke width for the circles.
  final Color strokeColor;

  @override
  Widget build(BuildContext context) {
    return _MapCircleLayer(
      circles: circles,
      animation: animation,
      color: color,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      tooltipBuilder: tooltipBuilder,
      circleLayer: this,
    );
  }
}

class _MapCircleLayer extends StatefulWidget {
  const _MapCircleLayer({
    this.circles,
    this.animation,
    this.color,
    this.strokeWidth,
    this.strokeColor,
    this.tooltipBuilder,
    this.circleLayer,
  });

  final Set<MapCircle> circles;
  final Animation animation;
  final Color color;
  final double strokeWidth;
  final Color strokeColor;
  final IndexedWidgetBuilder tooltipBuilder;
  final MapCircleLayer circleLayer;

  @override
  _MapCircleLayerState createState() => _MapCircleLayerState();
}

class _MapCircleLayerState extends State<_MapCircleLayer>
    with SingleTickerProviderStateMixin {
  AnimationController _hoverAnimationController;
  SfMapsThemeData _mapsThemeData;

  @override
  void initState() {
    super.initState();
    _hoverAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
  }

  @override
  void dispose() {
    _hoverAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows;
    _mapsThemeData = SfMapsTheme.of(context);
    return _MapCircleLayerRenderObject(
      circles: widget.circles,
      animation: widget.animation,
      color: widget.color,
      strokeWidth: widget.strokeWidth,
      strokeColor: widget.strokeColor,
      tooltipBuilder: widget.tooltipBuilder,
      circleLayer: widget.circleLayer,
      hoverAnimationController: _hoverAnimationController,
      themeData: _mapsThemeData,
      isDesktop: isDesktop,
    );
  }
}

class _MapCircleLayerRenderObject extends LeafRenderObjectWidget {
  const _MapCircleLayerRenderObject({
    this.circles,
    this.animation,
    this.color,
    this.strokeWidth,
    this.strokeColor,
    this.tooltipBuilder,
    this.circleLayer,
    this.hoverAnimationController,
    this.themeData,
    this.isDesktop,
  });

  final Set<MapCircle> circles;
  final Animation animation;
  final Color color;
  final double strokeWidth;
  final Color strokeColor;
  final IndexedWidgetBuilder tooltipBuilder;
  final MapCircleLayer circleLayer;
  final AnimationController hoverAnimationController;
  final SfMapsThemeData themeData;
  final bool isDesktop;

  @override
  _RenderMapCircle createRenderObject(BuildContext context) {
    return _RenderMapCircle(
      circles: circles,
      animation: animation,
      color: color,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      tooltipBuilder: tooltipBuilder,
      themeData: themeData,
      context: context,
      circleLayer: circleLayer,
      hoverAnimationController: hoverAnimationController,
      isDesktop: isDesktop,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderMapCircle renderObject) {
    renderObject
      ..circles = circles
      ..animation = animation
      ..color = color
      ..strokeColor = strokeColor
      ..strokeWidth = strokeWidth
      ..tooltipBuilder = tooltipBuilder
      ..themeData = themeData
      ..context = context
      ..circleLayer = circleLayer;
  }
}

class _RenderMapCircle extends RenderBox implements MouseTrackerAnnotation {
  _RenderMapCircle({
    Set<MapCircle> circles,
    Animation animation,
    Color color,
    double strokeWidth,
    Color strokeColor,
    IndexedWidgetBuilder tooltipBuilder,
    SfMapsThemeData themeData,
    BuildContext context,
    MapCircleLayer circleLayer,
    AnimationController hoverAnimationController,
    bool isDesktop,
  })  : _circles = circles,
        _animation = animation,
        _color = color,
        _strokeColor = strokeColor,
        _strokeWidth = strokeWidth,
        _tooltipBuilder = tooltipBuilder,
        _themeData = themeData,
        context = context,
        circleLayer = circleLayer,
        hoverAnimationController = hoverAnimationController,
        isDesktop = isDesktop {
    _forwardHoverColor = ColorTween();
    _reverseHoverColor = ColorTween();
    _forwardHoverStrokeColor = ColorTween();
    _reverseHoverStrokeColor = ColorTween();
    _hoverColorAnimation = CurvedAnimation(
        parent: hoverAnimationController, curve: Curves.easeInOut);
    _circlesInList = _circles?.toList();
    _tapGestureRecognizer = TapGestureRecognizer()..onTapUp = _handleTapUp;
  }

  MapController controller;
  AnimationController hoverAnimationController;
  RenderSublayerContainer vectorLayerContainer;
  MapCircleLayer circleLayer;
  bool isDesktop;
  BuildContext context;
  TapGestureRecognizer _tapGestureRecognizer;
  Animation<double> _hoverColorAnimation;
  ColorTween _forwardHoverColor;
  ColorTween _reverseHoverColor;
  ColorTween _forwardHoverStrokeColor;
  ColorTween _reverseHoverStrokeColor;
  MapCircle _previousHoverItem;
  MapCircle _currentHoverItem;
  int _selectedIndex = -1;
  MapCircle _selectedCircle;
  List<MapCircle> _circlesInList;

  Set<MapCircle> get circles => _circles;
  Set<MapCircle> _circles;
  set circles(Set<MapCircle> value) {
    assert(value != null);
    if (_circles == value || value == null) {
      return;
    }
    _circles = value;
    _circlesInList = _circles?.toList();
    markNeedsPaint();
  }

  Animation get animation => _animation;
  Animation _animation;
  set animation(Animation value) {
    if (_animation == value) {
      return;
    }
    _animation = value;
  }

  IndexedWidgetBuilder get tooltipBuilder => _tooltipBuilder;
  IndexedWidgetBuilder _tooltipBuilder;
  set tooltipBuilder(IndexedWidgetBuilder value) {
    if (_tooltipBuilder == value) {
      return;
    }
    _tooltipBuilder = value;
  }

  SfMapsThemeData get themeData => _themeData;
  SfMapsThemeData _themeData;
  set themeData(SfMapsThemeData value) {
    if (_themeData == value) {
      return;
    }
    _themeData = value;
    markNeedsPaint();
  }

  Color get color => _color;
  Color _color;
  set color(Color value) {
    if (_color == value) {
      return;
    }
    _color = value;
    // The previousHoverItem is not null when change the polygon color
    // dynamically after hover on the [MapCircle]. So reset the
    // previousHoverItem here.
    if (isDesktop && _previousHoverItem != null) {
      _previousHoverItem = null;
    }
    markNeedsPaint();
  }

  double get strokeWidth => _strokeWidth;
  double _strokeWidth;
  set strokeWidth(double value) {
    if (_strokeWidth == value) {
      return;
    }
    _strokeWidth = value;
    markNeedsPaint();
  }

  Color get strokeColor => _strokeColor;
  Color _strokeColor;
  set strokeColor(Color value) {
    if (_strokeColor == value) {
      return;
    }
    _strokeColor = value;
    // The previousHoverItem is not null when change the polygon stroke color
    // dynamically after hover on the [MapCircle]. So reset the
    // previousHoverItem here.
    if (isDesktop && _previousHoverItem != null) {
      _previousHoverItem = null;
    }
    markNeedsPaint();
  }

  bool get canHover => hasHoverColor || hasHoverStrokeColor;

  bool get hasHoverColor =>
      isDesktop &&
      _themeData.shapeHoverColor != null &&
      _themeData.shapeHoverColor != Colors.transparent;

  bool get hasHoverStrokeColor =>
      isDesktop &&
      _themeData.shapeHoverStrokeColor != null &&
      _themeData.shapeHoverStrokeColor != Colors.transparent;

  void _initializeHoverItemTween() {
    if (isDesktop) {
      final Color hoverFillColor = _getHoverFillColor(_selectedCircle);
      final Color hoverStrokeColor = _getHoverStrokeColor(_selectedCircle);
      final Color defaultFillColor = _selectedCircle.color ?? _color;
      final Color defaultStrokeColor =
          _selectedCircle.strokeColor ?? _strokeColor;

      if (_previousHoverItem != null) {
        _reverseHoverColor.begin = hoverFillColor;
        _reverseHoverColor.end = defaultFillColor;
        _reverseHoverStrokeColor.begin = hoverStrokeColor;
        _reverseHoverStrokeColor.end = defaultStrokeColor;
      }

      if (_currentHoverItem != null) {
        _forwardHoverColor.begin = defaultFillColor;
        _forwardHoverColor.end = hoverFillColor;
        _forwardHoverStrokeColor.begin = defaultStrokeColor;
        _forwardHoverStrokeColor.end = hoverStrokeColor;
      }
      hoverAnimationController.forward(from: 0);
    }
  }

  Color _getHoverFillColor(MapCircle circle) {
    if (hasHoverColor) {
      return _themeData.shapeHoverColor;
    }
    final Color color = circle.color ?? _color;
    return color.withOpacity(
        (double.parse(color.opacity.toStringAsFixed(2)) != hoverColorOpacity)
            ? hoverColorOpacity
            : minHoverOpacity);
  }

  Color _getHoverStrokeColor(MapCircle circle) {
    if (hasHoverStrokeColor) {
      return _themeData.shapeHoverStrokeColor;
    }
    final Color strokeColor = circle.strokeColor ?? _strokeColor;
    return strokeColor.withOpacity(
        (double.parse(strokeColor.opacity.toStringAsFixed(2)) !=
                hoverColorOpacity)
            ? hoverColorOpacity
            : minHoverOpacity);
  }

  void _handlePointerExit(PointerExitEvent event) {
    if (isDesktop && _currentHoverItem != null) {
      _previousHoverItem = _currentHoverItem;
      _currentHoverItem = null;
      _initializeHoverItemTween();
    }

    final RenderSublayerContainer vectorParent = parent;
    final ShapeLayerChildRenderBoxBase tooltipRenderer =
        vectorParent.tooltipKey?.currentContext?.findRenderObject();
    tooltipRenderer?.hideTooltip();
  }

  void _handleZooming(MapZoomDetails details) {
    markNeedsPaint();
  }

  void _handlePanning(MapPanDetails details) {
    markNeedsPaint();
  }

  void _handleReset() {
    markNeedsPaint();
  }

  void _handleRefresh() {
    markNeedsPaint();
  }

  void _handleInteraction(Offset position) {
    final RenderSublayerContainer vectorParent = parent;
    if (vectorParent.tooltipKey != null && _tooltipBuilder != null) {
      final ShapeLayerChildRenderBoxBase tooltipRenderer =
          vectorParent.tooltipKey.currentContext.findRenderObject();
      final bool isTileLayer = controller.tileCurrentLevelDetails != null;
      final Size boxSize = isTileLayer ? controller.totalTileSize : size;
      final Offset translationOffset =
          _getTranslationOffset(controller, isTileLayer);

      if (_selectedIndex != -1) {
        final Offset center = pixelFromLatLng(
          _selectedCircle.center.latitude,
          _selectedCircle.center.longitude,
          boxSize,
          translationOffset,
          controller.shapeLayerSizeFactor,
        );

        final Rect circleRect =
            Rect.fromCircle(center: center, radius: _selectedCircle.radius);
        tooltipRenderer.paintTooltip(
          _selectedIndex,
          circleRect,
          MapLayerElement.vector,
          vectorParent.getSublayerIndex(circleLayer),
          position,
        );
      }
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _selectedCircle.onTap?.call();
    _handleInteraction(details.localPosition);
  }

  @override
  MouseCursor get cursor => SystemMouseCursors.basic;

  @override
  PointerEnterEventListener get onEnter => null;

  // As onHover property of MouseHoverAnnotation was removed only in the
  // beta channel, once it is moved to stable, will remove this property.
  @override
  // ignore: override_on_non_overriding_member
  PointerHoverEventListener get onHover => null;

  @override
  PointerExitEventListener get onExit => _handlePointerExit;

  @override
  // ignore: override_on_non_overriding_member
  bool get validForMouseTracker => true;

  @override
  bool hitTestSelf(Offset position) {
    if (_animation != null && !_animation.isCompleted) {
      return false;
    }

    int index = _circlesInList.length - 1;
    final bool isTileLayer = controller.tileCurrentLevelDetails != null;
    final Size boxSize = isTileLayer ? controller.totalTileSize : size;
    final Offset translationOffset =
        _getTranslationOffset(controller, isTileLayer);

    for (final MapCircle circle in _circlesInList?.reversed) {
      if (circle.onTap != null || _tooltipBuilder != null || canHover) {
        final Path path = Path()
          ..addOval(Rect.fromCircle(
            center: pixelFromLatLng(
              circle.center.latitude,
              circle.center.longitude,
              boxSize,
              translationOffset,
              controller.shapeLayerSizeFactor,
            ),
            radius: circle.radius,
          ));
        if (path.contains(position)) {
          _selectedCircle = circle;
          _selectedIndex = index;
          return true;
        }
      }
      index--;
    }
    return false;
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    vectorLayerContainer = parent;
    controller = vectorLayerContainer.controller;
    if (controller != null) {
      controller
        ..addZoomingListener(_handleZooming)
        ..addPanningListener(_handlePanning)
        ..addResetListener(_handleReset)
        ..addRefreshListener(_handleRefresh);
    }
    _animation?.addListener(markNeedsPaint);
    _hoverColorAnimation?.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    if (controller != null) {
      controller
        ..removeZoomingListener(_handleZooming)
        ..removePanningListener(_handlePanning)
        ..removeResetListener(_handleReset)
        ..removeRefreshListener(_handleRefresh);
    }
    _animation?.removeListener(markNeedsPaint);
    _hoverColorAnimation?.removeListener(markNeedsPaint);
    _circlesInList?.clear();
    _circlesInList = null;
    super.detach();
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    if (event is PointerDownEvent) {
      _tapGestureRecognizer.addPointer(event);
    } else if (event is PointerHoverEvent && isDesktop) {
      if (_currentHoverItem != _selectedCircle) {
        _previousHoverItem = _currentHoverItem;
        _currentHoverItem = _selectedCircle;
        _initializeHoverItemTween();
      }

      final RenderBox renderBox = context.findRenderObject();
      _handleInteraction(renderBox.globalToLocal(event.position));
    }
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void performLayout() {
    size = getBoxSize(constraints);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_animation != null && _animation.value == 0.0) {
      return;
    }
    context.canvas.save();
    final Paint fillPaint = Paint()..isAntiAlias = true;
    final Paint strokePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;
    final bool isTileLayer = controller.tileCurrentLevelDetails != null;
    final Size boxSize = isTileLayer ? controller.totalTileSize : size;
    final Offset translationOffset =
        _getTranslationOffset(controller, isTileLayer);
    controller.applyTransform(context, offset, true);

    for (final MapCircle circle in circles) {
      final Path path = Path();
      path
        ..addOval(Rect.fromCircle(
          center: pixelFromLatLng(
            circle.center.latitude,
            circle.center.longitude,
            boxSize,
            translationOffset,
            controller.shapeLayerSizeFactor,
          ),
          radius: _getDesiredValue(
              circle.radius * (_animation?.value ?? 1.0), controller),
        ));
      _updateFillColor(circle, fillPaint);
      _updateStroke(circle, strokePaint);
      context.canvas..drawPath(path, fillPaint)..drawPath(path, strokePaint);
    }
    context.canvas.restore();
  }

  void _updateFillColor(MapCircle circle, Paint paint) {
    if (!isDesktop) {
      paint.color = circle.color ?? _color;
      return;
    }

    if (_previousHoverItem != null && _previousHoverItem == circle) {
      paint.color = _themeData.shapeHoverColor != Colors.transparent
          ? _reverseHoverColor.evaluate(_hoverColorAnimation)
          : (circle.color ?? _color);
    } else if (_currentHoverItem != null && _currentHoverItem == circle) {
      paint.color = _themeData.shapeHoverColor != Colors.transparent
          ? _forwardHoverColor.evaluate(_hoverColorAnimation)
          : (circle.color ?? _color);
    } else {
      paint.color = circle.color ?? _color;
    }
  }

  void _updateStroke(MapCircle circle, Paint paint) {
    if (!isDesktop) {
      _updateDefaultStroke(paint, circle);
      return;
    }

    if (_previousHoverItem != null && _previousHoverItem == circle) {
      _updateHoverStrokeColor(paint, circle, _reverseHoverStrokeColor);
      paint.strokeWidth =
          _getDesiredValue(circle.strokeWidth ?? _strokeWidth, controller);
    } else if (_currentHoverItem != null && _currentHoverItem == circle) {
      _updateHoverStrokeColor(paint, circle, _forwardHoverStrokeColor);
      if (_themeData.shapeHoverStrokeWidth != null &&
          _themeData.shapeHoverStrokeWidth > 0.0) {
        paint.strokeWidth =
            _getDesiredValue(_themeData.shapeHoverStrokeWidth, controller);
      } else {
        paint.strokeWidth =
            _getDesiredValue(circle.strokeWidth ?? _strokeWidth, controller);
      }
    } else {
      _updateDefaultStroke(paint, circle);
    }
  }

  void _updateDefaultStroke(Paint paint, MapCircle circle) {
    paint
      ..color = circle.strokeColor ?? _strokeColor
      ..strokeWidth =
          _getDesiredValue(circle.strokeWidth ?? _strokeWidth, controller);
  }

  void _updateHoverStrokeColor(
      Paint paint, MapCircle circle, ColorTween tween) {
    if (_themeData.shapeHoverStrokeColor != Colors.transparent) {
      paint.color = tween.evaluate(_hoverColorAnimation);
    } else {
      paint.color = circle.strokeColor ?? _strokeColor;
    }
  }
}

/// Creates a line between the two geographical coordinates on the map.
///
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///  return Scaffold(
///    body: SfMaps(
///      layers: [
///       MapShapeLayer(
///          source: MapShapeSource.asset(
///             "assets/world_map.json",
///              shapeDataField: "continent",
///          ),
///          sublayers: [
///           MapLineLayer(
///              lines: List<MapLine>.generate(
///               lines.length,
///                (int index) {
///                 return MapLine(
///                    from: lines[index].from,
///                    to: lines[index].to,
///                  );
///                },
///              ).toSet(),
///            ),
///          ],
///        ),
///      ],
///    ),
/// );
/// }
/// ```
class MapLine {
  /// Creates a [MapLine].
  const MapLine({
    @required this.from,
    @required this.to,
    this.dashArray = const [0, 0],
    this.color,
    this.width,
    this.onTap,
  });

  /// The starting coordinate of the line.
  ///
  ///```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///         MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapLineLayer(
  ///              lines: List<MapLine>.generate(
  ///                lines.length,
  ///                    (int index) {
  ///                  return MapLine(
  ///                    from: lines[index].from,
  ///                    to: lines[index].to,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  ///```
  final MapLatLng from;

  /// The ending coordinate of the line.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapLineLayer(
  ///              lines: List<MapLine>.generate(
  ///                lines.length,
  ///                    (int index) {
  ///                  return MapLine(
  ///                    from: lines[index].from,
  ///                    to: lines[index].to,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  ///```
  final MapLatLng to;

  /// The dash pattern for the line.
  ///
  /// A sequence of dash and gap will be rendered based on the values in this
  /// list. Once all values of the list is rendered, it will be repeated
  /// again till the end of the line.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapLineLayer(
  ///              lines: List<MapLine>.generate(
  ///                lines.length,
  ///                    (int index) {
  ///                  return MapLine(
  ///                    from: lines[index].from,
  ///                    to: lines[index].to,
  ///                    dashArray: [8, 3, 4, 3],
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  ///```
  final List<double> dashArray;

  /// Color of the line.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapLineLayer(
  ///              lines: List<MapLine>.generate(
  ///                lines.length,
  ///                    (int index) {
  ///                  return MapLine(
  ///                    from: lines[index].from,
  ///                    to: lines[index].to,
  ///                    color: Colors.blue,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  ///```
  final Color color;

  /// Width of the line.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapLineLayer(
  ///              lines: List<MapLine>.generate(
  ///                lines.length,
  ///                    (int index) {
  ///                  return MapLine(
  ///                    from: lines[index].from,
  ///                    to: lines[index].to,
  ///                    width: 4,
  ///                    color: Colors.blue,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  ///```
  final double width;

  /// Callback to receive tap event for this line.
  ///
  /// You can customize the appearance of the tapped line based on the index
  /// passed on it as shown in the below code snippet.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapLineLayer(
  ///              lines: List<MapLine>.generate(
  ///                lines.length,
  ///                (int index) {
  ///                  return MapLine(
  ///                    from: lines[index].from,
  ///                    to: lines[index].to,
  ///                   color: _selectedIndex == index
  ///                   ? Colors.blue
  ///                   : Colors.red,
  ///                    onTap: () {
  ///                      setState(() {
  ///                        _selectedIndex = index;
  ///                      });
  ///                    },
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  //          ],
  ///        ),
  ///      ],
  ///   ),
  ///  );
  /// }
  ///```
  final VoidCallback onTap;
}

/// Creates a polyline by connecting multiple geographical coordinates through
/// group of [points].
///
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///  return Scaffold(
///    body: SfMaps(
///     layers: [
///        MapShapeLayer(
///          source: MapShapeSource.asset(
///             "assets/world_map.json",
///              shapeDataField: "continent",
///          ),
///          sublayers: [
///            MapPolylineLayer(
///              polylines: List<MapPolyline>.generate(
///                polylines.length,
///                (int index) {
///                  return MapPolyline(
///                    points: polylines[index].points,
///                  );
///                },
///              ).toSet(),
///            ),
///          ],
///       ),
///      ],
///    ),
///  );
/// }
/// ```
class MapPolyline {
  /// Creates a [MapPolyline].
  const MapPolyline({
    @required this.points,
    this.dashArray = const [0, 0],
    this.color,
    this.width,
    this.onTap,
  });

  /// The geolocation coordinates of the polyline to be drawn.
  ///
  /// Lines are drawn between consecutive [points].
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapPolylineLayer(
  ///             polylines: List<MapPolyline>.generate(
  ///                lines.length,
  ///                   (int index) {
  ///                  return MapPolyline(
  ///                    points: lines[index].points,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  /// ```
  final List<MapLatLng> points;

  /// The dash pattern for the polyline.
  ///
  /// A sequence of dash and gap will be rendered based on the values in this
  /// list. Once all values of the list is rendered, it will be repeated
  /// again till the end of the polyline.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapPolylineLayer(
  ///             polylines: List<MapPolyline>.generate(
  ///                lines.length,
  ///                   (int index) {
  ///                  return MapPolyline(
  ///                    points: lines[index].points,
  ///                    dashArray: [8, 3, 4, 3],
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  /// ```
  final List<double> dashArray;

  /// Color of the polyline.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapPolylineLayer(
  ///             polylines: List<MapPolyline>.generate(
  ///                lines.length,
  ///                   (int index) {
  ///                  return MapPolyline(
  ///                    points: lines[index].points,
  ///                    color: Colors.blue,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  /// ```
  final Color color;

  /// Width of the polyline.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapPolylineLayer(
  ///             polylines: List<MapPolyline>.generate(
  ///                lines.length,
  ///                   (int index) {
  ///                  return MapPolyline(
  ///                    points: lines[index].points,
  ///                    color: Colors.blue,
  ///                    width: 4,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  /// ```
  final double width;

  /// Callback to receive tap event for this polyline.
  ///
  /// You can customize the appearance of the tapped polyline based on the
  /// index passed in it as shown in the below code snippet.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///           MapPolylineLayer(
  ///              polylines: List<MapPolyline>.generate(
  ///                lines.length,
  ///                (int index) {
  ///                  return MapPolyline(
  ///                   points: lines[index].points,
  ///                    color: _selectedIndex == index
  ///                    ? Colors.blue
  ///                    : Colors.red,
  ///                    onTap: () {
  ///                     setState(() {
  ///                        _selectedIndex = index;
  ///                     });
  ///                   },
  ///                  );
  ///                },
  ///             ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///     ],
  ///    ),
  ///  );
  /// }
  /// ```
  final VoidCallback onTap;
}

/// Creates a closed path which connects multiple geographical coordinates
/// through group of [MapPolygon.points].
///
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///  return Scaffold(
///    body: SfMaps(
///      layers: [
///        MapShapeLayer(
///          source: MapShapeSource.asset(
///             "assets/world_map.json",
///              shapeDataField: "continent",
///          ),
///          sublayers: [
///            MapPolygonLayer(
///              polygons: List<MapPolygon>.generate(
///                polygons.length,
///                (int index) {
///                  return MapPolygon(
///                    points: polygons[index].points,
///                  );
///                },
///              ).toSet(),
///            ),
///          ],
///        ),
///      ],
///    ),
///  );
/// }
/// ```
class MapPolygon {
  /// Creates a [MapPolygon].
  const MapPolygon({
    @required this.points,
    this.color,
    this.strokeColor,
    this.strokeWidth,
    this.onTap,
  });

  /// The geolocation coordinates of the polygon to be drawn.
  ///
  /// Lines are drawn between consecutive [points] to form a closed shape.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///       MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapPolygonLayer(
  ///              polygons: List<MapPolygon>.generate(
  ///                polygons.length,
  ///                (int index) {
  ///                  return MapPolygon(
  ///                    points: polygons[index].points,
  ///                 );
  ///               },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///     ],
  ///    ),
  ///  );
  /// }
  /// ```
  final List<MapLatLng> points;

  /// Specifies the fill color of the polygon.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///       MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapPolygonLayer(
  ///              polygons: List<MapPolygon>.generate(
  ///                polygons.length,
  ///                (int index) {
  ///                  return MapPolygon(
  ///                    points: polygons[index].points,
  ///                    color: Colors.blue,
  ///                 );
  ///               },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///     ],
  ///    ),
  ///  );
  /// }
  /// ```
  final Color color;

  /// Specifies the stroke color of the polygon.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///       MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapPolygonLayer(
  ///              polygons: List<MapPolygon>.generate(
  ///                polygons.length,
  ///                (int index) {
  ///                  return MapPolygon(
  ///                    points: polygons[index].points,
  ///                    strokeColor: Colors.red,
  ///                 );
  ///               },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///     ],
  ///    ),
  ///  );
  /// }
  /// ```
  final Color strokeColor;

  /// Specifies the stroke width of the polygon.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///       MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapPolygonLayer(
  ///              polygons: List<MapPolygon>.generate(
  ///                polygons.length,
  ///                (int index) {
  ///                  return MapPolygon(
  ///                    points: polygons[index].points,
  ///                    strokeWidth: 4,
  ///                    strokeColor: Colors.red,
  ///                 );
  ///               },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///     ],
  ///    ),
  ///  );
  /// }
  /// ```
  final double strokeWidth;

  /// Callback to receive tap event for this polygon.
  ///
  /// You can customize the appearance of the tapped polygon based on the index
  /// passed on it as shown in the below code snippet.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///     layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///         sublayers: [
  ///            MapPolygonLayer(
  ///              polygons: List<MapPolygon>.generate(
  ///                polygons.length,
  ///                (int index) {
  ///                 return MapPolygon(
  ///                    points: polygons[index].points,
  ///                   color: _selectedIndex == index
  ///                   ? Colors.blue
  ///                   : Colors.red,
  ///                    onTap: () {
  ///                      setState(() {
  ///                        _selectedIndex = index;
  ///                      });
  ///                    },
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///   ),
  ///  );
  ///}
  final VoidCallback onTap;
}

/// Creates a circle which is drawn based on the given [center] and
/// [radius].
///
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///  return Scaffold(
///    body: SfMaps(
///      layers: [
///        MapShapeLayer(
///          source: MapShapeSource.asset(
///             "assets/world_map.json",
///              shapeDataField: "continent",
///          ),
///          sublayers: [
///            MapCircleLayer(
///              circles: List<MapCircle>.generate(
///                circles.length,
///                (int index) {
///                  return MapCircle(
///                    center: circles[index],
///                  );
///                },
///              ).toSet(),
///            ),
///          ],
///        ),
///      ],
///    ),
///  );
/// }
/// ```
class MapCircle {
  /// Creates a [MapCircle].
  const MapCircle({
    @required this.center,
    this.radius = 5,
    this.color,
    this.strokeColor,
    this.strokeWidth,
    this.onTap,
  });

  /// The center of the circle.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///     layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapCircleLayer(
  ///              circles: List<MapCircle>.generate(
  ///                circles.length,
  ///                (int index) {
  ///                  return MapCircle(
  ///                    center: circles[index],
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  /// ```
  final MapLatLng center;

  /// The radius of the circle.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///     layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapCircleLayer(
  ///              circles: List<MapCircle>.generate(
  ///                circles.length,
  ///                (int index) {
  ///                  return MapCircle(
  ///                    center: circles[index],
  ///                    radius: 20,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  /// ```
  final double radius;

  /// The fill color of the circle.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///     layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapCircleLayer(
  ///              circles: List<MapCircle>.generate(
  ///                circles.length,
  ///                (int index) {
  ///                  return MapCircle(
  ///                    center: circles[index],
  ///                    color: Colors.blue,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  /// ```
  final Color color;

  /// Stroke width of the circle.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///     layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapCircleLayer(
  ///              circles: List<MapCircle>.generate(
  ///                circles.length,
  ///                (int index) {
  ///                  return MapCircle(
  ///                    center: circles[index],
  ///                    strokeWidth: 4,
  ///                    strokeColor: Colors.blue,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  /// ```
  final double strokeWidth;

  /// Stroke color of the circle.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///     layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///            MapCircleLayer(
  ///              circles: List<MapCircle>.generate(
  ///                circles.length,
  ///                (int index) {
  ///                  return MapCircle(
  ///                    center: circles[index],
  ///                    strokeColor: Colors.blue,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  /// ```
  final Color strokeColor;

  /// Callback to receive tap event for this circle.
  ///
  /// You can customize the appearance of the tapped circle based on the index
  /// passed on it as shown in the below code snippet.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///     layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          sublayers: [
  ///           MapCircleLayer(
  ///              circles: List<MapCircle>.generate(
  ///                circles.length,
  ///                (int index) {
  ///                  return MapCircle(
  ///                    center: circles[index],
  ///                    color: _selectedIndex == index
  ///                    ? Colors.blue
  ///                    : Colors.red,
  ///                    onTap: () {
  ///                      setState(() {
  ///                        _selectedIndex = index;
  ///                      });
  ///                    },
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///   ),
  ///  );
  /// }
  /// ```
  final VoidCallback onTap;
}

/// Creates an arc by connecting the two geographical coordinates.
///
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///  return Scaffold(
///    body: SfMaps(
///      layers: [
///       MapShapeLayer(
///          source: MapShapeSource.asset(
///             "assets/world_map.json",
///              shapeDataField: "continent",
///          ),
///          sublayers: [
///           MapArcLayer(
///              arcs: List<MapArc>.generate(
///               arcs.length,
///                (int index) {
///                 return MapArc(
///                    from: arcs[index].from,
///                    to: arcs[index].to,
///                  );
///                },
///              ).toSet(),
///            ),
///          ],
///        ),
///      ],
///    ),
/// );
/// }
/// ```
class MapArc {
  /// Creates a [MapArc].
  const MapArc({
    @required this.from,
    @required this.to,
    this.heightFactor = 0.2,
    this.controlPointFactor = 0.5,
    this.dashArray = const [0, 0],
    this.color,
    this.width,
    this.onTap,
  });

  /// Represents the start coordinate of an arc.
  ///
  ///```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///         MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///            'assets/world_map.json',
  ///             shapeDataField: 'continent',
  ///          ),
  ///          subLayers: [
  ///            MapArcLayer(
  ///              arcs: List<MapArc>.generate(
  ///                arcs.length,
  ///                    (int index) {
  ///                  return MapArc(
  ///                    from: arcs[index].from,
  ///                    to: arcs[index].to,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  ///```
  final MapLatLng from;

  /// Represents the end coordinate of an arc.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///            'assets/world_map.json',
  ///             shapeDataField: 'continent',
  ///          ),
  ///          subLayers: [
  ///            MapArcLayer(
  ///              arcs: List<MapArc>.generate(
  ///                arcs.length,
  ///                    (int index) {
  ///                  return MapArc(
  ///                    from: arcs[index].from,
  ///                    to: arcs[index].to,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  ///```
  final MapLatLng to;

  /// Specifies the distance from the line connecting two points to the arc
  /// bend point.
  ///
  /// Defaults to 0.2.
  ///
  /// The value ranges from -1 to 1.
  ///
  /// By default, the arc will always render above the [from] and [to] points.
  /// To render the arc below the points, set the value between -1 to 0.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///            'assets/world_map.json',
  ///             shapeDataField: 'continent',
  ///          ),
  ///          subLayers: [
  ///            MapArcLayer(
  ///              arcs: List<MapArc>.generate(
  ///                arcs.length,
  ///                    (int index) {
  ///                  return MapArc(
  ///                    from: arcs[index].from,
  ///                    to: arcs[index].to,
  ///                    heightFactor: 0.6,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  ///```
  final double heightFactor;

  /// Specifies the arc bending position.
  ///
  /// Defaults to 0.5.
  ///
  /// The arc will bend at the center between the [from] and [to] points by
  /// default.
  ///
  /// The value ranges from 0 to 1.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///            'assets/world_map.json',
  ///             shapeDataField: 'continent',
  ///          ),
  ///          subLayers: [
  ///            MapArcLayer(
  ///              arcs: List<MapArc>.generate(
  ///                arcs.length,
  ///                    (int index) {
  ///                  return MapArc(
  ///                    from: arcs[index].from,
  ///                    to: arcs[index].to,
  ///                    controlPointFactor: 0.4,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  ///```
  final double controlPointFactor;

  /// The dash pattern for the arc.
  ///
  /// A sequence of dash and gap will be rendered based on the values in this
  /// list. Once all values of the list is rendered, it will be repeated
  /// again till the end of the arc.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          subLayers: [
  ///            MapArcLayer(
  ///              arcs: List<MapArc>.generate(
  ///                arcs.length,
  ///                    (int index) {
  ///                  return MapArc(
  ///                    from: arcs[index].from,
  ///                    to: arcs[index].to,
  ///                    dashArray: [8, 3, 4, 3],
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  ///```
  final List<double> dashArray;

  /// Color of the arc.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          subLayers: [
  ///            MapArcLayer(
  ///              arcs: List<MapArc>.generate(
  ///                arcs.length,
  ///                    (int index) {
  ///                  return MapArc(
  ///                    from: arcs[index].from,
  ///                    to: arcs[index].to,
  ///                    color: Colors.blue,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  ///```
  final Color color;

  /// Width of the arc.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          subLayers: [
  ///            MapArcLayer(
  ///              arcs: List<MapArc>.generate(
  ///                arcs.length,
  ///                    (int index) {
  ///                  return MapArc(
  ///                    from: arcs[index].from,
  ///                    to: arcs[index].to,
  ///                    width: 4,
  ///                    color: Colors.blue,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///        ),
  ///      ],
  ///    ),
  ///  );
  /// }
  ///```
  final double width;

  /// Callback to receive tap event for this arc.
  ///
  /// You can customize the appearance of the tapped arc based on the index
  /// passed on it as shown in the below code snippet.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///             "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///          ),
  ///          subLayers: [
  ///            MapArcLayer(
  ///              arcs: List<MapArc>.generate(
  ///                arcs.length,
  ///                (int index) {
  ///                  return MapArc(
  ///                    from: arcs[index].from,
  ///                    to: arcs[index].to,
  ///                   color: _selectedIndex == index
  ///                   ? Colors.blue
  ///                   : Colors.red,
  ///                    onTap: () {
  ///                      setState(() {
  ///                        _selectedIndex = index;
  ///                      });
  ///                    },
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  //          ],
  ///        ),
  ///      ],
  ///   ),
  ///  );
  /// }
  ///```
  final VoidCallback onTap;
}

// To calculate dash array path for series
Path _dashPath(
  Path source, {
  @required _IntervalList<double> dashArray,
}) {
  if (source == null) {
    return null;
  }
  const double initialValue = 0.0;
  final Path path = Path();
  for (final PathMetric matric in source.computeMetrics()) {
    double distance = initialValue;
    bool canDraw = true;
    while (distance < matric.length) {
      final double length = dashArray.next;
      if (canDraw) {
        path.addPath(
            matric.extractPath(distance, distance + length), Offset.zero);
      }
      distance += length;
      canDraw = !canDraw;
    }
  }
  return path;
}

void _drawDashedLine(
    Canvas canvas, List<double> dashArray, Paint paint, Path path) {
  bool even = false;
  for (int i = 1; i < dashArray.length; i = i + 2) {
    if (dashArray[i] == 0) {
      even = true;
    }
  }
  if (!even) {
    paint.isAntiAlias = false;
    canvas.drawPath(
        _dashPath(
          path,
          dashArray: _IntervalList<double>(dashArray),
        ),
        paint);
  } else {
    canvas.drawPath(path, paint);
  }
}

// A circular array for dash offsets and lengths.
class _IntervalList<double> {
  _IntervalList(this.dashArray);

  final List<double> dashArray;
  int _index = 0;

  double get next {
    if (_index >= dashArray.length) {
      _index = 0;
    }
    return dashArray[_index++];
  }
}

bool _liesPointOnLine(Offset startPoint, Offset endPoint, double touchTolerance,
    Offset touchPosition) {
  final Path path = Path();
  // Calculate distance between two points i.e, d = sqrt[(x1-x2)^2+(y1-y2)^2].
  final double width = endPoint.dx - startPoint.dx;
  final double height = endPoint.dy - startPoint.dy;
  final double lineLength = sqrt(width * width + height * height);
  final double horizontalTouchLength = touchTolerance * height / lineLength;
  final double verticalTouchLength = touchTolerance * width / lineLength;

  final Offset lineTopLeft = Offset(startPoint.dx - horizontalTouchLength,
      startPoint.dy + verticalTouchLength);
  final Offset lineTopRight = Offset(startPoint.dx + horizontalTouchLength,
      startPoint.dy - verticalTouchLength);
  final Offset lineBottomRight = Offset(
      endPoint.dx + horizontalTouchLength, endPoint.dy - verticalTouchLength);
  final Offset lineBottomLeft = Offset(
      endPoint.dx - horizontalTouchLength, endPoint.dy + verticalTouchLength);
  path
    ..moveTo(lineTopLeft.dx, lineTopLeft.dy)
    ..lineTo(lineTopRight.dx, lineTopRight.dy)
    ..lineTo(lineBottomRight.dx, lineBottomRight.dy)
    ..lineTo(lineBottomLeft.dx, lineBottomLeft.dy)
    ..close();
  return path.contains(touchPosition);
}

Path _getAnimatedPath(Path originalPath, Animation animation) {
  final Path extractedPath = Path();
  double currentLength = 0.0;
  final PathMetrics pathMetrics = originalPath.computeMetrics();
  final double pathLength = pathMetrics.fold(
      0.0,
      (double previousValue, PathMetric pathMetric) =>
          previousValue + pathMetric.length);
  final double requiredPathLength = pathLength * animation.value;
  final Iterator<PathMetric> metricsIterator =
      originalPath.computeMetrics().iterator;

  while (metricsIterator.moveNext()) {
    final PathMetric metric = metricsIterator.current;
    final double nextLength = currentLength + metric.length;
    if (nextLength > requiredPathLength) {
      extractedPath.addPath(
          metric.extractPath(0.0, requiredPathLength - currentLength),
          Offset.zero);
      break;
    }
    extractedPath.addPath(metric.extractPath(0.0, metric.length), Offset.zero);
    currentLength = nextLength;
  }

  return extractedPath;
}

bool _liesPointOnArc(Offset startPoint, Offset endPoint, Offset controlPoint,
    double touchTolerance, Offset touchPosition) {
  final Path path = Path();
  final double width = endPoint.dx - startPoint.dx;
  final double height = endPoint.dy - startPoint.dy;
  // Calculate distance between two points i.e, d = sqrt[(x1-x2)^2+(y1-y2)^2].
  final double lineLength = sqrt(width * width + height * height);
  final double horizontalTouchLength = touchTolerance * height / lineLength;
  final double verticalTouchLength = touchTolerance * width / lineLength;

  final Offset lineBottomLeft = Offset(startPoint.dx - horizontalTouchLength,
      startPoint.dy + verticalTouchLength);
  final Offset lineTopLeft = Offset(startPoint.dx + horizontalTouchLength,
      startPoint.dy - verticalTouchLength);
  final Offset lineTopRight = Offset(
      endPoint.dx + horizontalTouchLength, endPoint.dy - verticalTouchLength);
  final Offset lineBottomRight = Offset(
      endPoint.dx - horizontalTouchLength, endPoint.dy + verticalTouchLength);
  final Offset controlPointTop = Offset(controlPoint.dx + horizontalTouchLength,
      controlPoint.dy - verticalTouchLength);
  final Offset controlPointBottom = Offset(
      controlPoint.dx - horizontalTouchLength,
      controlPoint.dy + verticalTouchLength);
  path
    ..moveTo(lineTopLeft.dx, lineTopLeft.dy)
    ..quadraticBezierTo(controlPointTop.dx, controlPointTop.dy, lineTopRight.dx,
        lineTopRight.dy)
    ..lineTo(lineBottomRight.dx, lineBottomRight.dy)
    ..quadraticBezierTo(controlPointBottom.dx, controlPointBottom.dy,
        lineBottomLeft.dx, lineBottomLeft.dy)
    ..close();
  return path.contains(touchPosition);
}
