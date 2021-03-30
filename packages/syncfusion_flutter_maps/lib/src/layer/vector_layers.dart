import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../maps.dart';
import '../behavior/zoom_pan_behavior.dart';
import '../common.dart';
import '../controller/map_controller.dart';
import '../layer/layer_base.dart';
import '../utils.dart';
import 'shape_layer.dart';
import 'tile_layer.dart';

/// This enum supported only for circle and polygon shapes.
enum _VectorFillType { inner, outer }

double _getCurrentWidth(double width, MapController controller) {
  return controller.layerType == LayerType.tile
      ? width / controller.tileCurrentLevelDetails.scale
      : width /
          (controller.gesture == Gesture.scale ? controller.localScale : 1);
}

Offset _getTranslation(MapController controller) {
  return controller.layerType == LayerType.tile
      ? -controller.tileCurrentLevelDetails.origin!
      : controller.shapeLayerOffset;
}

Offset _getScaledOffset(Offset offset, MapController controller) {
  if (controller.layerType == LayerType.tile) {
    return Offset(offset.dx * controller.tileCurrentLevelDetails.scale,
            offset.dy * controller.tileCurrentLevelDetails.scale) +
        controller.tileCurrentLevelDetails.translatePoint;
  }

  return offset;
}

void _drawInvertedPath(
    PaintingContext context,
    Path path,
    MapController controller,
    Paint fillPaint,
    Paint strokePaint,
    Offset offset) {
  // Path.combine option is not supported in web platform, so we have obtained
  // inverted rendering using [Path.fillType] for web and [Path.combine] for
  // other platforms.
  if (kIsWeb) {
    context.canvas.drawPath(
        Path()
          ..addPath(path, offset)
          ..addRect(controller.visibleBounds!)
          ..fillType = PathFillType.evenOdd,
        fillPaint);
    context.canvas.drawPath(path, strokePaint);
  } else {
    context.canvas
      ..drawPath(
          Path.combine(
            PathOperation.difference,
            Path()..addRect(controller.visibleBounds!),
            path,
          ),
          fillPaint)
      ..drawPath(path, strokePaint);
  }
}

Color _getHoverColor(
    Color? elementColor, Color layerColor, SfMapsThemeData themeData) {
  final Color color = elementColor ?? layerColor;
  final bool canAdjustHoverOpacity =
      double.parse(color.opacity.toStringAsFixed(2)) != hoverColorOpacity;
  return themeData.shapeHoverColor != null &&
          themeData.shapeHoverColor != Colors.transparent
      ? themeData.shapeHoverColor!
      : color.withOpacity(
          canAdjustHoverOpacity ? hoverColorOpacity : minHoverOpacity);
}

/// Base class for all vector layers.
abstract class MapVectorLayer extends MapSublayer {
  /// Creates a [MapVectorLayer].
  const MapVectorLayer({
    Key? key,
    IndexedWidgetBuilder? tooltipBuilder,
  }) : super(key: key, tooltipBuilder: tooltipBuilder);
}

/// A sublayer which renders group of [MapLine] on [MapShapeLayer] and
/// [MapTileLayer].
///
/// ```dart
///   List<Model> _lines;
///   MapZoomPanBehavior _zoomPanBehavior;
///   MapShapeSource _mapSource;
///
///   @override
///   void initState() {
///     _zoomPanBehavior = MapZoomPanBehavior(
///       focalLatLng: MapLatLng(40.7128, -95.3698),
///       zoomLevel: 3,
///     );
///
///     _mapSource = MapShapeSource.asset(
///       "assets/world_map.json",
///       shapeDataField: "continent",
///     );
///
///     _lines = <Model>[
///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
///     ];
///
///     super.initState();
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: SfMaps(
///         layers: [
///           MapShapeLayer(
///             source: _mapSource,
///             zoomPanBehavior: _zoomPanBehavior,
///             sublayers: [
///               MapLineLayer(
///                 lines: List<MapLine>.generate(
///                   _lines.length,
///                   (int index) {
///                     return MapLine(
///                       from: _lines[index].from,
///                       to: _lines[index].to,
///                     );
///                   },
///                 ).toSet(),
///               ),
///             ],
///           ),
///         ],
///       ),
///     );
///   }
///
/// class Model {
///   Model(this.from, this.to);
///
///   MapLatLng from;
///   MapLatLng to;
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
    Key? key,
    required this.lines,
    this.animation,
    this.color,
    this.width = 2,
    IndexedWidgetBuilder? tooltipBuilder,
  }) : super(key: key, tooltipBuilder: tooltipBuilder);

  /// A collection of [MapLine].
  ///
  /// Every single [MapLine] connects two location coordinates through a
  /// straight line.
  ///
  /// ```dart
  /// List<Model> _lines;
  /// MapZoomPanBehavior _zoomPanBehavior;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _zoomPanBehavior = MapZoomPanBehavior(
  ///      focalLatLng: MapLatLng(40.7128, -95.3698),
  ///      zoomLevel: 3,
  ///    );
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "continent",
  ///    );
  ///
  ///    _lines = <Model>[
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
  ///    ];
  ///
  ///    super.initState();
  ///  }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfMaps(
  ///         layers: [
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///             sublayers: [
  ///               MapLineLayer(
  ///                 lines: List<MapLine>.generate(
  ///                   _lines.length,
  ///                   (int index) {
  ///                     return MapLine(
  ///                       from: _lines[index].from,
  ///                       to: _lines[index].to,
  ///                     );
  ///                   },
  ///                 ).toSet(),
  ///               ),
  ///             ],
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class Model {
  ///   Model(this.from, this.to);
  ///
  ///   MapLatLng from;
  ///   MapLatLng to;
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
  ///   AnimationController _animationController;
  ///   Animation _animation;
  ///   MapZoomPanBehavior _zoomPanBehavior;
  ///   MapShapeSource _mapSource;
  ///   List<Model> _lines;
  ///
  ///   @override
  ///   void initState() {
  ///     _zoomPanBehavior = MapZoomPanBehavior(
  ///       focalLatLng: MapLatLng(40.7128, -95.3698),
  ///       zoomLevel: 3,
  ///     );
  ///
  ///     _mapSource = MapShapeSource.asset(
  ///       "assets/world_map.json",
  ///       shapeDataField: "continent",
  ///     );
  ///
  ///     _lines = <Model>[
  ///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
  ///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
  ///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
  ///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
  ///     ];
  ///
  ///     _animationController = AnimationController(
  ///       duration: Duration(seconds: 3),
  ///       vsync: this,
  ///     );
  ///
  ///     _animation =
  ///         CurvedAnimation(parent: _animationController,
  ///         curve: Curves.easeInOut);
  ///
  ///     _animationController.forward(from: 0);
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfMaps(
  ///         layers: [
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///             sublayers: [
  ///               MapLineLayer(
  ///                 lines: List<MapLine>.generate(
  ///                   _lines.length,
  ///                   (int index) {
  ///                     return MapLine(
  ///                       from: _lines[index].from,
  ///                       to: _lines[index].to,
  ///                     );
  ///                   },
  ///                 ).toSet(),
  ///                 animation: _animation,
  ///               ),
  ///             ],
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  ///   @override
  ///   void dispose() {
  ///     _animationController?.dispose();
  ///     super.dispose();
  ///   }
  /// }
  ///
  /// class Model {
  ///   Model(this.from, this.to);
  ///
  ///   MapLatLng from;
  ///   MapLatLng to;
  /// }
  /// ```
  final Animation? animation;

  /// The color of all the [lines].
  ///
  /// For setting color for each [MapLine], please check the [MapLine.color]
  /// property.
  ///
  /// ```dart
  /// List<Model> _lines;
  /// MapZoomPanBehavior _zoomPanBehavior;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _zoomPanBehavior = MapZoomPanBehavior(
  ///      focalLatLng: MapLatLng(40.7128, -95.3698),
  ///      zoomLevel: 3,
  ///    );
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "continent",
  ///    );
  ///
  ///    _lines = <Model>[
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
  ///    ];
  ///
  ///    super.initState();
  ///  }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfMaps(
  ///         layers: [
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///             sublayers: [
  ///               MapLineLayer(
  ///                 lines: List<MapLine>.generate(
  ///                   _lines.length,
  ///                   (int index) {
  ///                     return MapLine(
  ///                       from: _lines[index].from,
  ///                       to: _lines[index].to,
  ///                     );
  ///                   },
  ///                 ).toSet(),
  ///                 color: Colors.green,
  ///               ),
  ///             ],
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class Model {
  ///   Model(this.from, this.to);
  ///
  ///   MapLatLng from;
  ///   MapLatLng to;
  /// }
  /// ```
  ///
  /// See also:
  /// [width], to set the width.
  final Color? color;

  /// The width of all the [lines].
  ///
  /// For setting width for each [MapLine], please check the [MapLine.width]
  /// property.
  ///
  /// ```dart
  /// List<Model> _lines;
  /// MapZoomPanBehavior _zoomPanBehavior;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _zoomPanBehavior = MapZoomPanBehavior(
  ///      focalLatLng: MapLatLng(40.7128, -95.3698),
  ///      zoomLevel: 3,
  ///    );
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "continent",
  ///    );
  ///
  ///    _lines = <Model>[
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
  ///    ];
  ///
  ///    super.initState();
  ///  }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfMaps(
  ///         layers: [
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///             sublayers: [
  ///               MapLineLayer(
  ///                 lines: List<MapLine>.generate(
  ///                   _lines.length,
  ///                   (int index) {
  ///                     return MapLine(
  ///                       from: _lines[index].from,
  ///                       to: _lines[index].to,
  ///                     );
  ///                   },
  ///                 ).toSet(),
  ///                 width: 2,
  ///               ),
  ///             ],
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class Model {
  ///   Model(this.from, this.to);
  ///
  ///   MapLatLng from;
  ///   MapLatLng to;
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    if (lines.isNotEmpty) {
      final _DebugVectorShapeTree pointerTreeNode =
          _DebugVectorShapeTree(lines);
      properties.add(pointerTreeNode.toDiagnosticsNode());
    }
    properties.add(ObjectFlagProperty<Animation>.has('animation', animation));
    properties.add(ObjectFlagProperty<IndexedWidgetBuilder>.has(
        'tooltip', tooltipBuilder));
    if (color != null) {
      properties.add(ColorProperty('color', color));
    }

    properties.add(DoubleProperty('width', width));
  }
}

class _MapLineLayer extends StatefulWidget {
  _MapLineLayer({
    required this.lines,
    required this.animation,
    required this.color,
    required this.width,
    required this.tooltipBuilder,
    required this.lineLayer,
  });

  final Set<MapLine> lines;
  final Animation? animation;
  final Color? color;
  final double width;
  final IndexedWidgetBuilder? tooltipBuilder;
  final MapLineLayer lineLayer;

  @override
  _MapLineLayerState createState() => _MapLineLayerState();
}

class _MapLineLayerState extends State<_MapLineLayer>
    with SingleTickerProviderStateMixin {
  MapController? _controller;
  late AnimationController _hoverAnimationController;
  late SfMapsThemeData _mapsThemeData;
  late MapLayerInheritedWidget ancestor;

  @override
  void initState() {
    super.initState();
    _hoverAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
  }

  @override
  void didChangeDependencies() {
    if (_controller == null) {
      ancestor = context
          .dependOnInheritedWidgetOfExactType<MapLayerInheritedWidget>()!;
      _controller = ancestor.controller;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller = null;
    _hoverAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;
    _mapsThemeData = SfMapsTheme.of(context)!;
    return _MapLineLayerRenderObject(
      controller: _controller,
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
      state: this,
    );
  }
}

class _MapLineLayerRenderObject extends LeafRenderObjectWidget {
  const _MapLineLayerRenderObject({
    required this.controller,
    required this.lines,
    required this.animation,
    required this.color,
    required this.width,
    required this.tooltipBuilder,
    required this.lineLayer,
    required this.themeData,
    required this.isDesktop,
    required this.hoverAnimationController,
    required this.state,
  });

  final MapController? controller;
  final Set<MapLine> lines;
  final Animation? animation;
  final Color color;
  final double width;
  final IndexedWidgetBuilder? tooltipBuilder;
  final MapLineLayer lineLayer;
  final SfMapsThemeData themeData;
  final bool isDesktop;
  final AnimationController hoverAnimationController;
  final _MapLineLayerState state;

  @override
  _RenderMapLine createRenderObject(BuildContext context) {
    return _RenderMapLine(
      controller: controller,
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
      state: state,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderMapLine renderObject) {
    renderObject
      ..lines = lines
      ..animation = animation
      ..color = color
      ..width = width
      ..tooltipBuilder = tooltipBuilder
      ..context = context
      ..themeData = themeData
      ..state = state;
  }
}

class _RenderMapLine extends RenderBox implements MouseTrackerAnnotation {
  _RenderMapLine({
    required MapController? controller,
    required Set<MapLine> lines,
    required Animation? animation,
    required Color color,
    required double width,
    required IndexedWidgetBuilder? tooltipBuilder,
    required BuildContext context,
    required MapLineLayer lineLayer,
    required SfMapsThemeData themeData,
    required bool isDesktop,
    required AnimationController hoverAnimationController,
    required this.state,
  })   : _controller = controller,
        _lines = lines,
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
    linesInList = _lines.toList();
    _tapGestureRecognizer = TapGestureRecognizer()..onTapUp = _handleTapUp;
  }

  final MapController? _controller;
  _MapLineLayerState state;
  int selectedIndex = -1;
  double touchTolerance = 5;

  late TapGestureRecognizer _tapGestureRecognizer;
  late AnimationController hoverAnimationController;
  late MapLineLayer lineLayer;
  late BuildContext context;
  late Animation<double> _hoverColorAnimation;
  late ColorTween _forwardHoverColor;
  late ColorTween _reverseHoverColor;
  late bool isDesktop;

  MapLine? selectedLine;
  List<MapLine>? linesInList;
  List<Offset>? selectedLinePoints;
  MapLine? _previousHoverItem;
  MapLine? _currentHoverItem;

  Set<MapLine> get lines => _lines;
  Set<MapLine> _lines;
  set lines(Set<MapLine>? value) {
    assert(value != null);
    if (_lines == value || value == null) {
      return;
    }
    _lines = value;
    linesInList = _lines.toList();
    markNeedsPaint();
  }

  Animation? get animation => _animation;
  Animation? _animation;
  set animation(Animation? value) {
    if (_animation == value) {
      return;
    }
    _animation = value;
  }

  IndexedWidgetBuilder? get tooltipBuilder => _tooltipBuilder;
  IndexedWidgetBuilder? _tooltipBuilder;
  set tooltipBuilder(IndexedWidgetBuilder? value) {
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
      final Color hoverStrokeColor =
          _getHoverColor(selectedLine?.color, _color, _themeData);
      final Color beginColor = selectedLine?.color ?? _color;

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

  void _handleTapUp(TapUpDetails details) {
    selectedLine?.onTap?.call();
    _handleInteraction(details.localPosition);
  }

  void _handlePointerExit(PointerExitEvent event) {
    if (isDesktop && _currentHoverItem != null) {
      _previousHoverItem = _currentHoverItem;
      _currentHoverItem = null;
      _updateHoverItemTween();
    }

    final ShapeLayerChildRenderBoxBase tooltipRenderer =
        _controller!.tooltipKey!.currentContext!.findRenderObject()
            // ignore: avoid_as
            as ShapeLayerChildRenderBoxBase;
    tooltipRenderer.hideTooltip();
  }

  void _handleZooming(MapZoomDetails details) {
    markNeedsPaint();
  }

  void _handlePanning(MapPanDetails details) {
    markNeedsPaint();
  }

  void _handleInteraction(Offset position,
      [PointerKind kind = PointerKind.touch]) {
    if (_controller?.tooltipKey != null && _tooltipBuilder != null) {
      final ShapeLayerChildRenderBoxBase tooltipRenderer =
          _controller!.tooltipKey!.currentContext!.findRenderObject()
              // ignore: avoid_as
              as ShapeLayerChildRenderBoxBase;
      if (selectedLinePoints != null && selectedLinePoints!.isNotEmpty) {
        final Offset startPoint = selectedLinePoints![0];
        final Offset endPoint = selectedLinePoints![1];
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
          kind,
          state.ancestor.sublayers!.indexOf(lineLayer),
          position,
        );
      }
    }
  }

  @override
  MouseCursor get cursor => SystemMouseCursors.basic;

  @override
  PointerEnterEventListener? get onEnter => null;

  // As onHover property of MouseHoverAnnotation was removed only in the
  // beta channel, once it is moved to stable, will remove this property.
  @override
  // ignore: override_on_non_overriding_member
  PointerHoverEventListener? get onHover => null;

  @override
  PointerExitEventListener get onExit => _handlePointerExit;

  @override
  // ignore: override_on_non_overriding_member
  bool get validForMouseTracker => true;

  @override
  bool hitTestSelf(Offset position) {
    if (_animation != null && !_animation!.isCompleted) {
      return false;
    }

    final Size boxSize = _controller?.layerType == LayerType.tile
        ? _controller!.totalTileSize!
        : size;
    final Offset translationOffset = _getTranslation(_controller!);
    int index = linesInList!.length - 1;
    for (final MapLine line in linesInList!.reversed) {
      final double width = line.width ?? _width;
      if (line.onTap != null || _tooltipBuilder != null || isDesktop) {
        final double actualTouchTolerance =
            width < touchTolerance ? touchTolerance : width / 2;
        Offset startPoint = pixelFromLatLng(
          line.from.latitude,
          line.from.longitude,
          boxSize,
          translationOffset,
          _controller!.shapeLayerSizeFactor,
        );
        Offset endPoint = pixelFromLatLng(
          line.to.latitude,
          line.to.longitude,
          boxSize,
          translationOffset,
          _controller!.shapeLayerSizeFactor,
        );
        startPoint = _getScaledOffset(startPoint, _controller!);
        endPoint = _getScaledOffset(endPoint, _controller!);

        if (_liesPointOnLine(
            startPoint, endPoint, actualTouchTolerance, position)) {
          selectedLine = line;
          selectedIndex = index;
          selectedLinePoints!
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
    } else if (event is PointerHoverEvent && isDesktop) {
      if (_currentHoverItem != selectedLine) {
        _previousHoverItem = _currentHoverItem;
        _currentHoverItem = selectedLine;
        _updateHoverItemTween();
      }

      // ignore: avoid_as
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      _handleInteraction(
          renderBox.globalToLocal(event.position), PointerKind.hover);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (_controller != null) {
      _controller!
        ..addZoomingListener(_handleZooming)
        ..addPanningListener(_handlePanning)
        ..addResetListener(markNeedsPaint)
        ..addRefreshListener(markNeedsPaint);
    }
    _animation?.addListener(markNeedsPaint);
    _hoverColorAnimation.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    if (_controller != null) {
      _controller!
        ..removeZoomingListener(_handleZooming)
        ..removePanningListener(_handlePanning)
        ..removeResetListener(markNeedsPaint)
        ..removeRefreshListener(markNeedsPaint);
    }
    _animation?.removeListener(markNeedsPaint);
    _hoverColorAnimation.removeListener(markNeedsPaint);
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
    if (_animation != null && _animation!.value == 0.0) {
      return;
    }
    context.canvas.save();
    Offset startPoint;
    Offset endPoint;
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;
    Path path = Path();
    final Size boxSize = _controller?.layerType == LayerType.tile
        ? _controller!.totalTileSize!
        : size;
    final Offset translationOffset = _getTranslation(_controller!);
    _controller!.applyTransform(context, offset, true);

    for (final MapLine line in lines) {
      startPoint = pixelFromLatLng(
        line.from.latitude,
        line.from.longitude,
        boxSize,
        translationOffset,
        _controller!.shapeLayerSizeFactor,
      );
      endPoint = pixelFromLatLng(
        line.to.latitude,
        line.to.longitude,
        boxSize,
        translationOffset,
        _controller!.shapeLayerSizeFactor,
      );

      if (_previousHoverItem != null &&
          _previousHoverItem == line &&
          _themeData.shapeHoverColor != Colors.transparent) {
        paint.color = _reverseHoverColor.evaluate(_hoverColorAnimation)!;
      } else if (_currentHoverItem != null &&
          selectedLine == line &&
          _themeData.shapeHoverColor != Colors.transparent) {
        paint.color = _forwardHoverColor.evaluate(_hoverColorAnimation)!;
      } else {
        paint.color = line.color ?? _color;
      }

      paint.strokeWidth = _getCurrentWidth(line.width ?? _width, _controller!);
      path
        ..reset()
        ..moveTo(startPoint.dx, startPoint.dy)
        ..lineTo(endPoint.dx, endPoint.dy);
      if (_animation != null) {
        path = _getAnimatedPath(path, _animation!);
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
///  List<Model> _arcs;
///  MapZoomPanBehavior _zoomPanBehavior;
///  MapShapeSource _mapSource;
///
///  @override
///  void initState() {
///    _zoomPanBehavior = MapZoomPanBehavior(
///      focalLatLng: MapLatLng(40.7128, -95.3698),
///      zoomLevel: 3,
///    );
///
///   _mapSource = MapShapeSource.asset(
///      "assets/world_map.json",
///      shapeDataField: "continent",
///    );
///
///   _arcs = <Model>[
///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
///    ];
///  super.initState();
///  }
///
///  @override
///  Widget build(BuildContext context) {
///    return Scaffold(
///      body: SfMaps(
///        layers: [
///          MapShapeLayer(
///            source: _mapSource,
///            zoomPanBehavior: _zoomPanBehavior,
///            sublayers: [
///              MapArcLayer(
///                arcs: List<MapArc>.generate(
///                  _arcs.length,
///                  (int index) {
///                    return MapArc(
///                      from: _arcs[index].from,
///                      to: _arcs[index].to,
///                    );
///                  },
///                ).toSet(),
///              ),
///            ],
///          ),
///        ],
///      ),
///    );
///  }
///
/// class Model {
///   Model(this.from, this.to);
///
///   MapLatLng from;
///   MapLatLng to;
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
    Key? key,
    required this.arcs,
    this.animation,
    this.color,
    this.width = 2,
    IndexedWidgetBuilder? tooltipBuilder,
  }) : super(key: key, tooltipBuilder: tooltipBuilder);

  /// A collection of [MapArc].
  ///
  /// Every single [MapArc] connects two location coordinates through an
  /// arc. The [MapArc.heightFactor] and [MapArc.controlPointFactor] can be
  /// modified to change the appearance of the arcs.
  ///
  /// ```dart
  ///  List<Model> _arcs;
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _zoomPanBehavior = MapZoomPanBehavior(
  ///      focalLatLng: MapLatLng(40.7128, -95.3698),
  ///      zoomLevel: 3,
  ///    );
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "continent",
  ///    );
  ///
  ///   _arcs = <Model>[
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
  ///    ];
  ///  super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///            source: _mapSource,
  ///            zoomPanBehavior: _zoomPanBehavior,
  ///            sublayers: [
  ///              MapArcLayer(
  ///                arcs: List<MapArc>.generate(
  ///                  _arcs.length,
  ///                  (int index) {
  ///                    return MapArc(
  ///                      from: _arcs[index].from,
  ///                      to: _arcs[index].to,
  ///                    );
  ///                  },
  ///                ).toSet(),
  ///              ),
  ///            ],
  ///          ),
  ///        ],
  ///      ),
  ///    );
  ///  }
  ///
  /// class Model {
  ///   Model(this.from, this.to);
  ///
  ///   MapLatLng from;
  ///   MapLatLng to;
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
  ///  AnimationController _animationController;
  ///  Animation _animation;
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  MapShapeSource _mapSource;
  ///  List<Model> _arcs;
  ///
  ///  @override
  ///  void initState() {
  ///    _zoomPanBehavior = MapZoomPanBehavior(
  ///      focalLatLng: MapLatLng(40.7128, -95.3698),
  ///      zoomLevel: 3,
  ///    );
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "continent",
  ///    );
  ///
  ///    _arcs = <Model>[
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
  ///    ];
  ///
  ///    _animationController = AnimationController(
  ///       duration: Duration(seconds: 3),
  ///       vsync: this,
  ///     );
  ///
  ///     _animation =
  ///         CurvedAnimation(parent: _animationController,
  ///         curve: Curves.easeInOut);
  ///
  ///     _animationController.forward(from: 0);
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfMaps(
  ///         layers: [
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///             sublayers: [
  ///               MapArcLayer(
  ///                 arcs: List<MapArc>.generate(
  ///                   _arcs.length,
  ///                   (int index) {
  ///                     return MapArc(
  ///                       from: _arcs[index].from,
  ///                       to: _arcs[index].to,
  ///                     );
  ///                   },
  ///                 ).toSet(),
  ///                 animation: _animation,
  ///               ),
  ///             ],
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  ///   @override
  ///   void dispose() {
  ///     _animationController?.dispose();
  ///     super.dispose();
  ///   }
  /// }
  ///
  /// class Model {
  ///   Model(this.from, this.to);
  ///
  ///   MapLatLng from;
  ///   MapLatLng to;
  /// }
  /// ```
  final Animation? animation;

  /// The color of all the [arcs].
  ///
  /// For setting color for each [MapArc], please check the [MapArc.color]
  /// property.
  ///
  /// ```dart
  ///  List<Model> _arcs;
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _zoomPanBehavior = MapZoomPanBehavior(
  ///      focalLatLng: MapLatLng(40.7128, -95.3698),
  ///      zoomLevel: 3,
  ///    );
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "continent",
  ///    );
  ///
  ///   _arcs = <Model>[
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
  ///    ];
  ///  super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///            source: _mapSource,
  ///            zoomPanBehavior: _zoomPanBehavior,
  ///            sublayers: [
  ///              MapArcLayer(
  ///                arcs: List<MapArc>.generate(
  ///                  _arcs.length,
  ///                  (int index) {
  ///                    return MapArc(
  ///                      from: _arcs[index].from,
  ///                      to: _arcs[index].to,
  ///                    );
  ///                  },
  ///                ).toSet(),
  ///                color: Colors.green,
  ///              ),
  ///            ],
  ///          ),
  ///        ],
  ///      ),
  ///    );
  ///  }
  ///
  /// class Model {
  ///   Model(this.from, this.to);
  ///
  ///   MapLatLng from;
  ///   MapLatLng to;
  /// }
  /// ```
  ///
  /// See also:
  /// [width], to set the width for the map arc.
  final Color? color;

  /// The width of all the [arcs].
  ///
  /// For setting width for each [MapArc], please check the [MapArc.width]
  /// property.
  ///
  /// ```dart
  ///  List<Model> _arcs;
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _zoomPanBehavior = MapZoomPanBehavior(
  ///      focalLatLng: MapLatLng(40.7128, -95.3698),
  ///      zoomLevel: 3,
  ///    );
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "continent",
  ///    );
  ///
  ///   _arcs = <Model>[
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
  ///    ];
  ///  super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///            source: _mapSource,
  ///            zoomPanBehavior: _zoomPanBehavior,
  ///            sublayers: [
  ///              MapArcLayer(
  ///                arcs: List<MapArc>.generate(
  ///                  _arcs.length,
  ///                  (int index) {
  ///                    return MapArc(
  ///                      from: _arcs[index].from,
  ///                      to: _arcs[index].to,
  ///                    );
  ///                  },
  ///                ).toSet(),
  ///                width: 2.0,
  ///              ),
  ///            ],
  ///          ),
  ///        ],
  ///      ),
  ///    );
  ///  }
  ///
  /// class Model {
  ///   Model(this.from, this.to);
  ///
  ///   MapLatLng from;
  ///   MapLatLng to;
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    if (arcs.isNotEmpty) {
      final _DebugVectorShapeTree pointerTreeNode = _DebugVectorShapeTree(arcs);
      properties.add(pointerTreeNode.toDiagnosticsNode());
    }
    properties.add(ObjectFlagProperty<Animation>.has('animation', animation));
    properties.add(ObjectFlagProperty<IndexedWidgetBuilder>.has(
        'tooltip', tooltipBuilder));
    if (color != null) {
      properties.add(ColorProperty('color', color));
    }

    properties.add(DoubleProperty('width', width));
  }
}

class _MapArcLayer extends StatefulWidget {
  const _MapArcLayer({
    required this.arcs,
    required this.animation,
    required this.color,
    required this.width,
    required this.tooltipBuilder,
    required this.arcLayer,
  });

  final Set<MapArc> arcs;
  final Animation? animation;
  final Color? color;
  final double width;
  final IndexedWidgetBuilder? tooltipBuilder;
  final MapArcLayer arcLayer;

  @override
  _MapArcLayerState createState() => _MapArcLayerState();
}

class _MapArcLayerState extends State<_MapArcLayer>
    with SingleTickerProviderStateMixin {
  MapController? _controller;
  late AnimationController _hoverAnimationController;
  late SfMapsThemeData _mapsThemeData;
  late MapLayerInheritedWidget ancestor;

  @override
  void initState() {
    super.initState();
    _hoverAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
  }

  @override
  void didChangeDependencies() {
    if (_controller == null) {
      ancestor = context
          .dependOnInheritedWidgetOfExactType<MapLayerInheritedWidget>()!;
      _controller = ancestor.controller;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller = null;
    _hoverAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;
    _mapsThemeData = SfMapsTheme.of(context)!;
    return _MapArcLayerRenderObject(
      controller: _controller,
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
      state: this,
    );
  }
}

class _MapArcLayerRenderObject extends LeafRenderObjectWidget {
  const _MapArcLayerRenderObject({
    required this.controller,
    required this.arcs,
    required this.animation,
    required this.color,
    required this.width,
    required this.tooltipBuilder,
    required this.arcLayer,
    required this.themeData,
    required this.isDesktop,
    required this.hoverAnimationController,
    required this.state,
  });

  final MapController? controller;
  final Set<MapArc> arcs;
  final Animation? animation;
  final Color color;
  final double width;
  final IndexedWidgetBuilder? tooltipBuilder;
  final MapArcLayer arcLayer;
  final SfMapsThemeData themeData;
  final bool isDesktop;
  final AnimationController hoverAnimationController;
  final _MapArcLayerState state;

  @override
  _RenderMapArc createRenderObject(BuildContext context) {
    return _RenderMapArc(
      controller: controller,
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
      state: state,
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
      ..themeData = themeData
      ..state = state;
  }
}

class _RenderMapArc extends RenderBox implements MouseTrackerAnnotation {
  _RenderMapArc({
    required MapController? controller,
    required Set<MapArc> arcs,
    required Animation? animation,
    required Color color,
    required double width,
    required IndexedWidgetBuilder? tooltipBuilder,
    required BuildContext context,
    required MapArcLayer arcLayer,
    required SfMapsThemeData themeData,
    required bool isDesktop,
    required AnimationController hoverAnimationController,
    required this.state,
  })   : _controller = controller,
        _arcs = arcs,
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
    arcsInList = _arcs.toList();
    _tapGestureRecognizer = TapGestureRecognizer()..onTapUp = _handleTapUp;
  }

  final MapController? _controller;
  int selectedIndex = -1;
  double touchTolerance = 5;

  late _MapArcLayerState state;
  late MapArcLayer arcLayer;
  late BuildContext context;
  late MapArc selectedArc;
  late AnimationController hoverAnimationController;
  late TapGestureRecognizer _tapGestureRecognizer;
  late Animation<double> _hoverColorAnimation;
  late ColorTween _forwardHoverColor;
  late ColorTween _reverseHoverColor;
  late List<Offset> selectedLinePoints;
  late bool isDesktop;

  List<MapArc>? arcsInList;
  MapArc? _previousHoverItem;
  MapArc? _currentHoverItem;

  Set<MapArc> get arcs => _arcs;
  Set<MapArc> _arcs;
  set arcs(Set<MapArc>? value) {
    assert(value != null);
    if (_arcs == value || value == null) {
      return;
    }
    _arcs = value;
    arcsInList = _arcs.toList();
    markNeedsPaint();
  }

  IndexedWidgetBuilder? get tooltipBuilder => _tooltipBuilder;
  IndexedWidgetBuilder? _tooltipBuilder;
  set tooltipBuilder(IndexedWidgetBuilder? value) {
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

  Animation? get animation => _animation;
  Animation? _animation;
  set animation(Animation? value) {
    if (_animation == value) {
      return;
    }
    _animation = value;
  }

  void _updateHoverItemTween() {
    if (isDesktop) {
      final Color hoverStrokeColor =
          _getHoverColor(selectedArc.color, _color, _themeData);
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

    final ShapeLayerChildRenderBoxBase tooltipRenderer =
        _controller!.tooltipKey!.currentContext!.findRenderObject()
            // ignore: avoid_as
            as ShapeLayerChildRenderBoxBase;
    tooltipRenderer.hideTooltip();
  }

  void _handleZooming(MapZoomDetails details) {
    markNeedsPaint();
  }

  void _handlePanning(MapPanDetails details) {
    markNeedsPaint();
  }

  @override
  MouseCursor get cursor => SystemMouseCursors.basic;

  @override
  PointerEnterEventListener? get onEnter => null;

  // As onHover property of MouseHoverAnnotation was removed only in the
  // beta channel, once it is moved to stable, will remove this property.
  @override
  // ignore: override_on_non_overriding_member
  PointerHoverEventListener? get onHover => null;

  @override
  PointerExitEventListener get onExit => _handlePointerExit;

  @override
  // ignore: override_on_non_overriding_member
  bool get validForMouseTracker => true;

  void _handleInteraction(Offset position,
      [PointerKind kind = PointerKind.touch]) {
    if (_controller?.tooltipKey != null && _tooltipBuilder != null) {
      final ShapeLayerChildRenderBoxBase tooltipRenderer =
          _controller!.tooltipKey!.currentContext!.findRenderObject()
              // ignore: avoid_as
              as ShapeLayerChildRenderBoxBase;
      tooltipRenderer.paintTooltip(
        selectedIndex,
        null,
        MapLayerElement.vector,
        kind,
        state.ancestor.sublayers?.indexOf(arcLayer),
        position,
      );
    }
  }

  @override
  bool hitTestSelf(Offset position) {
    if (_animation != null && !_animation!.isCompleted) {
      return false;
    }

    final Size boxSize = _controller?.layerType == LayerType.tile
        ? _controller!.totalTileSize!
        : size;
    final Offset translationOffset = _getTranslation(_controller!);
    int index = arcsInList!.length - 1;
    for (final MapArc arc in arcsInList!.reversed) {
      final double width = arc.width ?? _width;
      if (arc.onTap != null || _tooltipBuilder != null || isDesktop) {
        final double actualTouchTolerance =
            width < touchTolerance ? touchTolerance : width / 2;
        Offset startPoint = pixelFromLatLng(
          arc.from.latitude,
          arc.from.longitude,
          boxSize,
          translationOffset,
          _controller!.shapeLayerSizeFactor,
        );
        Offset endPoint = pixelFromLatLng(
          arc.to.latitude,
          arc.to.longitude,
          boxSize,
          translationOffset,
          _controller!.shapeLayerSizeFactor,
        );
        startPoint = _getScaledOffset(startPoint, _controller!);
        endPoint = _getScaledOffset(endPoint, _controller!);
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
    } else if (event is PointerHoverEvent && isDesktop) {
      if (_currentHoverItem != selectedArc) {
        _previousHoverItem = _currentHoverItem;
        _currentHoverItem = selectedArc;
        _updateHoverItemTween();
      }

      // ignore: avoid_as
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      _handleInteraction(
          renderBox.globalToLocal(event.position), PointerKind.hover);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (_controller != null) {
      _controller!
        ..addZoomingListener(_handleZooming)
        ..addPanningListener(_handlePanning)
        ..addResetListener(markNeedsPaint)
        ..addRefreshListener(markNeedsPaint);
    }
    _animation?.addListener(markNeedsPaint);
    _hoverColorAnimation.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    if (_controller != null) {
      _controller!
        ..removeZoomingListener(_handleZooming)
        ..removePanningListener(_handlePanning)
        ..removeResetListener(markNeedsPaint)
        ..removeRefreshListener(markNeedsPaint);
    }
    _animation?.removeListener(markNeedsPaint);
    _hoverColorAnimation.removeListener(markNeedsPaint);
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
    if (_animation != null && _animation!.value == 0) {
      return;
    }
    context.canvas.save();
    Offset startPoint;
    Offset endPoint;
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;
    Path path = Path();
    final Size boxSize = _controller?.layerType == LayerType.tile
        ? _controller!.totalTileSize!
        : size;
    final Offset translationOffset = _getTranslation(_controller!);
    _controller!.applyTransform(context, offset, true);

    for (final MapArc arc in arcs) {
      startPoint = pixelFromLatLng(
        arc.from.latitude,
        arc.from.longitude,
        boxSize,
        translationOffset,
        _controller!.shapeLayerSizeFactor,
      );
      endPoint = pixelFromLatLng(
        arc.to.latitude,
        arc.to.longitude,
        boxSize,
        translationOffset,
        _controller!.shapeLayerSizeFactor,
      );
      final Offset controlPoint = _calculateControlPoint(
          startPoint, endPoint, arc.heightFactor, arc.controlPointFactor);

      if (_previousHoverItem != null &&
          _previousHoverItem == arc &&
          _themeData.shapeHoverColor != Colors.transparent) {
        paint.color = _reverseHoverColor.evaluate(_hoverColorAnimation)!;
      } else if (_currentHoverItem != null &&
          selectedArc == arc &&
          _themeData.shapeHoverColor != Colors.transparent) {
        paint.color = _forwardHoverColor.evaluate(_hoverColorAnimation)!;
      } else {
        paint.color = arc.color ?? _color;
      }

      paint.strokeWidth = _getCurrentWidth(arc.width ?? _width, _controller!);
      path
        ..reset()
        ..moveTo(startPoint.dx, startPoint.dy)
        ..quadraticBezierTo(
            controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
      if (_animation != null) {
        path = _getAnimatedPath(path, _animation!);
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
///  MapZoomPanBehavior _zoomPanBehavior;
///  List<MapLatLng> _polyLines;
///  MapShapeSource _mapSource;
///
///   @override
///   void initState() {
///     _polyLines = <MapLatLng>[
///       MapLatLng(13.0827, 80.2707),
///       MapLatLng(14.4673, 78.8242),
///       MapLatLng(14.9091, 78.0092),
///       MapLatLng(16.2160, 77.3566),
///       MapLatLng(17.1557, 76.8697),
///       MapLatLng(18.0975, 75.4249),
///       MapLatLng(18.5204, 73.8567),
///       MapLatLng(19.0760, 72.8777),
///     ];
///
///     _mapSource = MapShapeSource.asset(
///       'assets/india.json',
///       shapeDataField: 'name',
///     );
///
///     _zoomPanBehavior = MapZoomPanBehavior(
///         zoomLevel: 3, focalLatLng: MapLatLng(15.3173, 76.7139));
///     super.initState();
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(title: Text('Polyline')),
///       body: SfMaps(
///         layers: [
///           MapShapeLayer(
///             source: _mapSource,
///             sublayers: [
///               MapPolylineLayer(
///                 polylines: List<MapPolyline>.generate(
///                   1,
///                   (int index) {
///                     return MapPolyline(
///                       points: _polyLines,
///                     );
///                   },
///                 ).toSet(),
///               ),
///             ],
///             zoomPanBehavior: _zoomPanBehavior,
///           ),
///         ],
///       ),
///     );
///   }
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
    Key? key,
    required this.polylines,
    this.animation,
    this.color,
    this.width = 2,
    IndexedWidgetBuilder? tooltipBuilder,
  }) : super(key: key, tooltipBuilder: tooltipBuilder);

  /// A collection of [MapPolyline].
  ///
  /// Every single [MapPolyline] connects multiple location coordinates through
  /// group of [MapPolyline.points].
  ///
  /// ```dart
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  List<MapLatLng> _polyLines;
  ///  MapShapeSource _mapSource;
  ///
  ///   @override
  ///   void initState() {
  ///     _polyLines = <MapLatLng>[
  ///       MapLatLng(13.0827, 80.2707),
  ///       MapLatLng(14.4673, 78.8242),
  ///       MapLatLng(14.9091, 78.0092),
  ///       MapLatLng(16.2160, 77.3566),
  ///       MapLatLng(17.1557, 76.8697),
  ///       MapLatLng(18.0975, 75.4249),
  ///       MapLatLng(18.5204, 73.8567),
  ///       MapLatLng(19.0760, 72.8777),
  ///     ];
  ///
  ///     _mapSource = MapShapeSource.asset(
  ///       'assets/india.json',
  ///       shapeDataField: 'name',
  ///     );
  ///
  ///     _zoomPanBehavior = MapZoomPanBehavior(
  ///         zoomLevel: 3, focalLatLng: MapLatLng(15.3173, 76.7139));
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       appBar: AppBar(title: Text('Polyline')),
  ///       body: SfMaps(
  ///         layers: [
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             sublayers: [
  ///               MapPolylineLayer(
  ///                 polylines: List<MapPolyline>.generate(
  ///                   1,
  ///                   (int index) {
  ///                     return MapPolyline(
  ///                       points: _polyLines,
  ///                     );
  ///                   },
  ///                 ).toSet(),
  ///               ),
  ///             ],
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
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
  /// MapZoomPanBehavior _zoomPanBehavior;
  /// List<MapLatLng> _polyLines;
  /// MapShapeSource _mapSource;
  ///
  /// @override
  /// void initState() {
  ///   _polyLines = <MapLatLng>[
  ///     MapLatLng(13.0827, 80.2707),
  ///     MapLatLng(14.4673, 78.8242),
  ///     MapLatLng(14.9091, 78.0092),
  ///     MapLatLng(16.2160, 77.3566),
  ///     MapLatLng(17.1557, 76.8697),
  ///     MapLatLng(18.0975, 75.4249),
  ///     MapLatLng(18.5204, 73.8567),
  ///     MapLatLng(19.0760, 72.8777),
  ///   ];
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///     'assets/india.json',
  ///     shapeDataField: 'name',
  ///   );
  ///
  ///   _zoomPanBehavior = MapZoomPanBehavior(
  ///       zoomLevel: 3, focalLatLng: MapLatLng(15.3173, 76.7139));
  ///
  ///   _animationController = AnimationController(
  ///     duration: Duration(seconds: 3),
  ///     vsync: this,
  ///   );
  ///
  ///   _animation =
  ///       CurvedAnimation(parent: _animationController,
  ///       curve: Curves.easeInOut);
  ///
  ///   _animationController.forward(from: 0);
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfMaps(
  ///       layers: [
  ///         MapShapeLayer(
  ///           source: _mapSource,
  ///           zoomPanBehavior: _zoomPanBehavior,
  ///           sublayers: [
  ///             MapPolylineLayer(
  ///               polylines: [
  ///                 MapPolyline(
  ///                   points: _polyLines,
  ///                 )
  ///               ].toSet(),
  ///               animation: _animation,
  ///             ),
  ///           ],
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  ///
  /// @override
  /// void dispose() {
  ///   _animationController?.dispose();
  ///   super.dispose();
  /// }
  /// ```
  final Animation? animation;

  /// The color of all the [polylines].
  ///
  /// For setting color for each [MapPolyline], please check the
  /// [MapPolyline.color] property.
  ///
  /// ```dart
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  List<MapLatLng> _polyLines;
  ///  MapShapeSource _mapSource;
  ///
  ///   @override
  ///   void initState() {
  ///     _polyLines = <MapLatLng>[
  ///       MapLatLng(13.0827, 80.2707),
  ///       MapLatLng(14.4673, 78.8242),
  ///       MapLatLng(14.9091, 78.0092),
  ///       MapLatLng(16.2160, 77.3566),
  ///       MapLatLng(17.1557, 76.8697),
  ///       MapLatLng(18.0975, 75.4249),
  ///       MapLatLng(18.5204, 73.8567),
  ///       MapLatLng(19.0760, 72.8777),
  ///     ];
  ///
  ///     _mapSource = MapShapeSource.asset(
  ///       'assets/india.json',
  ///       shapeDataField: 'name',
  ///     );
  ///
  ///     _zoomPanBehavior = MapZoomPanBehavior(
  ///         zoomLevel: 3, focalLatLng: MapLatLng(15.3173, 76.7139));
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       appBar: AppBar(title: Text('Polyline')),
  ///       body: SfMaps(
  ///         layers: [
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             sublayers: [
  ///               MapPolylineLayer(
  ///                 polylines: List<MapPolyline>.generate(
  ///                   1,
  ///                   (int index) {
  ///                     return MapPolyline(
  ///                       points: _polyLines,
  ///                     );
  ///                   },
  ///                 ).toSet(),
  ///                 color: Colors.green,
  ///               ),
  ///             ],
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  /// ```
  ///
  /// See also:
  /// [width], for setting the width.
  final Color? color;

  /// The width of all the [polylines].
  ///
  /// For setting width for each [MapPolyline], please check the
  /// [MapPolyline.width] property.
  ///
  /// ```dart
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  List<MapLatLng> _polyLines;
  ///  MapShapeSource _mapSource;
  ///
  ///   @override
  ///   void initState() {
  ///     _polyLines = <MapLatLng>[
  ///       MapLatLng(13.0827, 80.2707),
  ///       MapLatLng(14.4673, 78.8242),
  ///       MapLatLng(14.9091, 78.0092),
  ///       MapLatLng(16.2160, 77.3566),
  ///       MapLatLng(17.1557, 76.8697),
  ///       MapLatLng(18.0975, 75.4249),
  ///       MapLatLng(18.5204, 73.8567),
  ///       MapLatLng(19.0760, 72.8777),
  ///     ];
  ///
  ///     _mapSource = MapShapeSource.asset(
  ///       'assets/india.json',
  ///       shapeDataField: 'name',
  ///     );
  ///
  ///     _zoomPanBehavior = MapZoomPanBehavior(
  ///         zoomLevel: 3, focalLatLng: MapLatLng(15.3173, 76.7139));
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       appBar: AppBar(title: Text('Polyline')),
  ///       body: SfMaps(
  ///         layers: [
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             sublayers: [
  ///               MapPolylineLayer(
  ///                 polylines: List<MapPolyline>.generate(
  ///                   1,
  ///                   (int index) {
  ///                     return MapPolyline(
  ///                       points: _polyLines,
  ///                     );
  ///                   },
  ///                 ).toSet(),
  ///                 width : 2.0,
  ///               ),
  ///             ],
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    if (polylines.isNotEmpty) {
      final _DebugVectorShapeTree pointerTreeNode =
          _DebugVectorShapeTree(polylines);
      properties.add(pointerTreeNode.toDiagnosticsNode());
    }
    properties.add(ObjectFlagProperty<Animation>.has('animation', animation));
    properties.add(ObjectFlagProperty<IndexedWidgetBuilder>.has(
        'tooltip', tooltipBuilder));
    if (color != null) {
      properties.add(ColorProperty('color', color));
    }

    properties.add(DoubleProperty('width', width));
  }
}

class _MapPolylineLayer extends StatefulWidget {
  const _MapPolylineLayer({
    required this.polylines,
    required this.animation,
    required this.color,
    required this.width,
    required this.tooltipBuilder,
    required this.polylineLayer,
  });

  final Set<MapPolyline> polylines;
  final Animation? animation;
  final Color? color;
  final double width;
  final IndexedWidgetBuilder? tooltipBuilder;
  final MapPolylineLayer polylineLayer;

  @override
  _MapPolylineLayerState createState() => _MapPolylineLayerState();
}

class _MapPolylineLayerState extends State<_MapPolylineLayer>
    with SingleTickerProviderStateMixin {
  MapController? _controller;
  late AnimationController _hoverAnimationController;
  late SfMapsThemeData _mapsThemeData;
  late MapLayerInheritedWidget ancestor;

  @override
  void initState() {
    super.initState();
    _hoverAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
  }

  @override
  void didChangeDependencies() {
    if (_controller == null) {
      ancestor = context
          .dependOnInheritedWidgetOfExactType<MapLayerInheritedWidget>()!;
      _controller = ancestor.controller;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller = null;
    _hoverAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;
    _mapsThemeData = SfMapsTheme.of(context)!;
    return _MapPolylineLayerRenderObject(
      controller: _controller,
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
      state: this,
    );
  }
}

class _MapPolylineLayerRenderObject extends LeafRenderObjectWidget {
  const _MapPolylineLayerRenderObject({
    required this.controller,
    required this.polylines,
    required this.animation,
    required this.color,
    required this.width,
    required this.tooltipBuilder,
    required this.polylineLayer,
    required this.themeData,
    required this.isDesktop,
    required this.hoverAnimationController,
    required this.state,
  });

  final MapController? controller;
  final Set<MapPolyline> polylines;
  final Animation? animation;
  final Color color;
  final double width;
  final IndexedWidgetBuilder? tooltipBuilder;
  final MapPolylineLayer polylineLayer;
  final SfMapsThemeData themeData;
  final bool isDesktop;
  final AnimationController hoverAnimationController;
  final _MapPolylineLayerState state;

  @override
  _RenderMapPolyline createRenderObject(BuildContext context) {
    return _RenderMapPolyline(
      controller: controller,
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
      state: state,
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
      ..themeData = themeData
      ..state = state;
  }
}

class _RenderMapPolyline extends RenderBox implements MouseTrackerAnnotation {
  _RenderMapPolyline({
    required MapController? controller,
    required Set<MapPolyline> polylines,
    required Animation? animation,
    required Color color,
    required double width,
    required IndexedWidgetBuilder? tooltipBuilder,
    required BuildContext context,
    required MapPolylineLayer polylineLayer,
    required SfMapsThemeData themeData,
    required bool isDesktop,
    required AnimationController hoverAnimationController,
    required this.state,
  })   : _controller = controller,
        _polylines = polylines,
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
    polylinesInList = _polylines.toList();
    _tapGestureRecognizer = TapGestureRecognizer()..onTapUp = _handleTapUp;
  }

  final MapController? _controller;
  int selectedIndex = -1;
  double touchTolerance = 5;
  late _MapPolylineLayerState state;
  late TapGestureRecognizer _tapGestureRecognizer;
  late MapPolylineLayer polylineLayer;
  late BuildContext context;
  late MapPolyline selectedPolyline;
  late AnimationController hoverAnimationController;
  late Animation<double> _hoverColorAnimation;
  late ColorTween _forwardHoverColor;
  late ColorTween _reverseHoverColor;
  late bool isDesktop;

  List<MapPolyline>? polylinesInList;
  MapPolyline? _previousHoverItem;
  MapPolyline? _currentHoverItem;

  Set<MapPolyline> get polylines => _polylines;
  Set<MapPolyline> _polylines;
  set polylines(Set<MapPolyline>? value) {
    assert(value != null);
    if (_polylines == value || value == null) {
      return;
    }
    _polylines = value;
    polylinesInList = _polylines.toList();
    markNeedsPaint();
  }

  Animation? get animation => _animation;
  Animation? _animation;
  set animation(Animation? value) {
    if (_animation == value) {
      return;
    }
    _animation = value;
  }

  IndexedWidgetBuilder? get tooltipBuilder => _tooltipBuilder;
  IndexedWidgetBuilder? _tooltipBuilder;
  set tooltipBuilder(IndexedWidgetBuilder? value) {
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
      final Color hoverStrokeColor =
          _getHoverColor(selectedPolyline.color, _color, _themeData);
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

    final ShapeLayerChildRenderBoxBase tooltipRenderer =
        _controller!.tooltipKey!.currentContext!.findRenderObject()
            // ignore: avoid_as
            as ShapeLayerChildRenderBoxBase;
    tooltipRenderer.hideTooltip();
  }

  void _handleZooming(MapZoomDetails details) {
    markNeedsPaint();
  }

  void _handlePanning(MapPanDetails details) {
    markNeedsPaint();
  }

  void _handleInteraction(Offset position,
      [PointerKind kind = PointerKind.touch]) {
    if (_controller?.tooltipKey != null && _tooltipBuilder != null) {
      final ShapeLayerChildRenderBoxBase tooltipRenderer =
          _controller!.tooltipKey!.currentContext!.findRenderObject()
              // ignore: avoid_as
              as ShapeLayerChildRenderBoxBase;
      tooltipRenderer.paintTooltip(
        selectedIndex,
        null,
        MapLayerElement.vector,
        kind,
        state.ancestor.sublayers?.indexOf(polylineLayer),
        position,
      );
    }
  }

  @override
  MouseCursor get cursor => SystemMouseCursors.basic;

  @override
  PointerEnterEventListener? get onEnter => null;

  // As onHover property of MouseHoverAnnotation was removed only in the
  // beta channel, once it is moved to stable, will remove this property.
  @override
  // ignore: override_on_non_overriding_member
  PointerHoverEventListener? get onHover => null;

  @override
  PointerExitEventListener get onExit => _handlePointerExit;

  @override
  // ignore: override_on_non_overriding_member
  bool get validForMouseTracker => true;

  @override
  bool hitTestSelf(Offset position) {
    if (_animation != null && !_animation!.isCompleted) {
      return false;
    }

    final Size boxSize = _controller?.layerType == LayerType.tile
        ? _controller!.totalTileSize!
        : size;
    final Offset translationOffset = _getTranslation(_controller!);
    bool tappedOnLine = false;
    int index = polylinesInList!.length - 1;
    for (final MapPolyline polyline in polylinesInList!.reversed) {
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
            _controller!.shapeLayerSizeFactor,
          );
          Offset endPoint = pixelFromLatLng(
            nextPoint.latitude,
            nextPoint.longitude,
            boxSize,
            translationOffset,
            _controller!.shapeLayerSizeFactor,
          );
          startPoint = _getScaledOffset(startPoint, _controller!);
          endPoint = _getScaledOffset(endPoint, _controller!);

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
    if (_controller != null) {
      _controller!
        ..addZoomingListener(_handleZooming)
        ..addPanningListener(_handlePanning)
        ..addResetListener(markNeedsPaint)
        ..addRefreshListener(markNeedsPaint);
    }
    _animation?.addListener(markNeedsPaint);
    _hoverColorAnimation.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    if (_controller != null) {
      _controller!
        ..removeZoomingListener(_handleZooming)
        ..removePanningListener(_handlePanning)
        ..removeResetListener(markNeedsPaint)
        ..removeRefreshListener(markNeedsPaint);
    }
    _animation?.removeListener(markNeedsPaint);
    _hoverColorAnimation.removeListener(markNeedsPaint);
    polylinesInList?.clear();
    polylinesInList = null;
    super.detach();
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    if (event is PointerDownEvent) {
      _tapGestureRecognizer.addPointer(event);
    } else if (event is PointerHoverEvent && isDesktop) {
      if (_currentHoverItem != selectedPolyline) {
        _previousHoverItem = _currentHoverItem;
        _currentHoverItem = selectedPolyline;
        _updateHoverItemTween();
      }

      // ignore: avoid_as
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      _handleInteraction(
          renderBox.globalToLocal(event.position), PointerKind.hover);
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
    if (_animation != null && _animation!.value == 0.0) {
      return;
    }
    context.canvas.save();
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;
    Path path = Path();
    final Size boxSize = _controller?.layerType == LayerType.tile
        ? _controller!.totalTileSize!
        : size;
    final Offset translationOffset = _getTranslation(_controller!);
    _controller!.applyTransform(context, offset, true);
    for (final MapPolyline polyline in polylines) {
      final MapLatLng startCoordinate = polyline.points[0];
      final Offset startPoint = pixelFromLatLng(
          startCoordinate.latitude,
          startCoordinate.longitude,
          boxSize,
          translationOffset,
          _controller!.shapeLayerSizeFactor);
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
            _controller!.shapeLayerSizeFactor);
        path.lineTo(nextPoint.dx, nextPoint.dy);
      }

      if (_previousHoverItem != null &&
          _previousHoverItem == polyline &&
          _themeData.shapeHoverColor != Colors.transparent) {
        paint.color = _reverseHoverColor.evaluate(_hoverColorAnimation)!;
      } else if (_currentHoverItem != null &&
          selectedPolyline == polyline &&
          _themeData.shapeHoverColor != Colors.transparent) {
        paint.color = _forwardHoverColor.evaluate(_hoverColorAnimation)!;
      } else {
        paint.color = polyline.color ?? _color;
      }

      paint.strokeWidth =
          _getCurrentWidth(polyline.width ?? _width, _controller!);
      if (_animation != null) {
        path = _getAnimatedPath(path, _animation!);
      }
      _drawDashedLine(context.canvas, polyline.dashArray, paint, path);
    }
    context.canvas.restore();
  }
}

/// A sublayer which renders group of [MapPolygon] on [MapShapeLayer] and
/// [MapTileLayer].
///
/// ```dart
///  MapZoomPanBehavior _zoomPanBehavior;
///  List<MapLatLng> _polygon;
///  MapShapeSource _mapSource;
///
///  @override
///  void initState() {
///    _polygon = <MapLatLng>[
///      MapLatLng(38.8026, -116.4194),
///      MapLatLng(46.8797, -110.3626),
///      MapLatLng(41.8780, -93.0977),
///    ];
///
///    _mapSource = MapShapeSource.asset(
///      'assets/usa.json',
///      shapeDataField: 'name',
///    );
///
///    _zoomPanBehavior = MapZoomPanBehavior();
///    super.initState();
///  }
///
///  @override
///  Widget build(BuildContext context) {
///    return Scaffold(
///      appBar: AppBar(title: Text('Polygon shape')),
///      body: SfMaps(layers: [
///        MapShapeLayer(
///          source: _mapSource,
///          sublayers: [
///            MapPolygonLayer(
///              polygons: List<MapPolygon>.generate(
///                1,
///                (int index) {
///                  return MapPolygon(
///                    points: _polygon,
///                  );
///                },
///              ).toSet(),
///            ),
///          ],
///          zoomPanBehavior: _zoomPanBehavior,
///        ),
///      ]),
///    );
///  }
///
/// See also:
/// * `[MapPolygonLayer.inverted]`, named constructor, for adding inverted
/// polygon shape.
/// ```
class MapPolygonLayer extends MapVectorLayer {
  /// Creates the [MapPolygonLayer].
  MapPolygonLayer({
    Key? key,
    required this.polygons,
    this.color,
    this.strokeWidth = 1,
    this.strokeColor,
    IndexedWidgetBuilder? tooltipBuilder,
  })  : _fillType = _VectorFillType.inner,
        super(key: key, tooltipBuilder: tooltipBuilder);

  /// Creates the inverted color polygon shape.
  ///
  /// You can highlight particular on the map to make more readable by applying
  /// the opacity to the outer area of highlighted polygon area using the
  /// polygons property of [MapPolygonLayer.inverted].
  ///
  /// ```dart
  ///  List<MapLatLng> _polygon;
  ///  MapShapeSource _dataSource;
  ///
  ///   @override
  ///   void initState() {
  ///     _polygon = <MapLatLng>[
  ///       MapLatLng(27.6648, -81.5158),
  ///       MapLatLng(32.3078, -64.7505),
  ///       MapLatLng(18.2208, -66.5901),
  ///     ];
  ///
  ///     _dataSource = MapShapeSource.asset(
  ///       'assets/usa.json',
  ///       shapeDataField: 'name',
  ///     );
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfMaps(
  ///         layers: [
  ///           MapShapeLayer(
  ///             source: _dataSource,
  ///            sublayers: [
  ///              MapPolygonLayer.inverted(
  ///                 polygons: List<MapPolygon>.generate(
  ///                   1,
  ///                  (int index) {
  ///                     return MapPolygon(
  ///                       points: _polygon,
  ///                     );
  ///                  },
  ///                 ).toSet(),
  ///              ),
  ///             ],
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// See also:
  /// * [`MapPolygonLayer`], for adding normal polygon shape.
  /// ```
  MapPolygonLayer.inverted({
    Key? key,
    required this.polygons,
    this.strokeWidth = 1,
    this.color,
    this.strokeColor,
    IndexedWidgetBuilder? tooltipBuilder,
  })  : _fillType = _VectorFillType.outer,
        super(key: key, tooltipBuilder: tooltipBuilder);

  /// A collection of [MapPolygon].
  ///
  /// Every single [MapPolygon] is a closed path which connects multiple
  /// location coordinates through group of [MapPolygon.points].
  ///
  /// ```dart
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  List<MapLatLng> _polygon;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _polygon = <MapLatLng>[
  ///      MapLatLng(38.8026, -116.4194),
  ///      MapLatLng(46.8797, -110.3626),
  ///      MapLatLng(41.8780, -93.0977),
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/usa.json',
  ///      shapeDataField: 'name',
  ///    );
  ///
  ///    _zoomPanBehavior = MapZoomPanBehavior();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(title: Text('Polygon shape')),
  ///      body: SfMaps(layers: [
  ///        MapShapeLayer(
  ///          source: _mapSource,
  ///          sublayers: [
  ///            MapPolygonLayer(
  ///              polygons: List<MapPolygon>.generate(
  ///                1,
  ///                (int index) {
  ///                  return MapPolygon(
  ///                    points: _polygon,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///          zoomPanBehavior: _zoomPanBehavior,
  ///        ),
  ///      ]),
  ///    );
  ///  }
  ///```
  final Set<MapPolygon> polygons;

  /// The fill color of all the [MapPolygon].
  ///
  /// For setting color for each [MapPolygon], please check the
  /// [MapPolygon.color] property.
  ///
  /// ```dart
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  List<MapLatLng> _polygon;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _polygon = <MapLatLng>[
  ///      MapLatLng(38.8026, -116.4194),
  ///      MapLatLng(46.8797, -110.3626),
  ///      MapLatLng(41.8780, -93.0977),
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/usa.json',
  ///      shapeDataField: 'name',
  ///    );
  ///
  ///    _zoomPanBehavior = MapZoomPanBehavior();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(title: Text('Polygon shape')),
  ///      body: SfMaps(layers: [
  ///        MapShapeLayer(
  ///          source: _mapSource,
  ///          sublayers: [
  ///            MapPolygonLayer(
  ///              polygons: List<MapPolygon>.generate(
  ///                1,
  ///                (int index) {
  ///                  return MapPolygon(
  ///                    points: _polygon,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///              color: Colors.green,
  ///            ),
  ///          ],
  ///          zoomPanBehavior: _zoomPanBehavior,
  ///        ),
  ///      ]),
  ///    );
  ///  }
  ///```
  final Color? color;

  /// The stroke width of all the [MapPolygon].
  ///
  /// For setting stroke width for each [MapPolygon], please check the
  /// [MapPolygon.strokeWidth] property.
  ///
  /// ```dart
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  List<MapLatLng> _polygon;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _polygon = <MapLatLng>[
  ///      MapLatLng(38.8026, -116.4194),
  ///      MapLatLng(46.8797, -110.3626),
  ///      MapLatLng(41.8780, -93.0977),
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/usa.json',
  ///      shapeDataField: 'name',
  ///    );
  ///
  ///    _zoomPanBehavior = MapZoomPanBehavior();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(title: Text('Polygon shape')),
  ///      body: SfMaps(layers: [
  ///        MapShapeLayer(
  ///          source: _mapSource,
  ///          sublayers: [
  ///            MapPolygonLayer(
  ///              polygons: List<MapPolygon>.generate(
  ///                1,
  ///                (int index) {
  ///                  return MapPolygon(
  ///                    points: _polygon,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///              strokeColor: Colors.red,
  ///              strokeWidth: 5.0,
  ///            ),
  ///          ],
  ///          zoomPanBehavior: _zoomPanBehavior,
  ///        ),
  ///      ]),
  ///    );
  ///  }
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
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  List<MapLatLng> _polygon;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _polygon = <MapLatLng>[
  ///      MapLatLng(38.8026, -116.4194),
  ///      MapLatLng(46.8797, -110.3626),
  ///      MapLatLng(41.8780, -93.0977),
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/usa.json',
  ///      shapeDataField: 'name',
  ///    );
  ///
  ///    _zoomPanBehavior = MapZoomPanBehavior();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(title: Text('Polygon shape')),
  ///      body: SfMaps(layers: [
  ///        MapShapeLayer(
  ///          source: _mapSource,
  ///          sublayers: [
  ///            MapPolygonLayer(
  ///              polygons: List<MapPolygon>.generate(
  ///                1,
  ///                (int index) {
  ///                  return MapPolygon(
  ///                    points: _polygon,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///              strokeColor: Colors.red,
  ///              strokeWidth: 5.0,
  ///            ),
  ///          ],
  ///          zoomPanBehavior: _zoomPanBehavior,
  ///        ),
  ///      ]),
  ///    );
  ///  }
  ///```
  ///
  /// See also:
  /// [strokeWidth], to set the stroke width for the polygon.
  final Color? strokeColor;

  /// Strategies for painting a polygon in a canvas.
  final _VectorFillType _fillType;

  @override
  Widget build(BuildContext context) {
    return _MapPolygonLayer(
      polygons: polygons,
      color: color,
      strokeWidth: strokeWidth,
      strokeColor: strokeColor,
      tooltipBuilder: tooltipBuilder,
      polygonLayer: this,
      fillType: _fillType,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    if (polygons.isNotEmpty) {
      final _DebugVectorShapeTree pointerTreeNode =
          _DebugVectorShapeTree(polygons);
      properties.add(pointerTreeNode.toDiagnosticsNode());
    }
    properties.add(ObjectFlagProperty<IndexedWidgetBuilder>.has(
        'tooltip', tooltipBuilder));
    if (color != null) {
      properties.add(ColorProperty('color', color));
    }

    if (strokeColor != null) {
      properties.add(ColorProperty('strokeColor', strokeColor));
    }

    properties.add(DoubleProperty('strokeWidth', strokeWidth));
  }
}

class _MapPolygonLayer extends StatefulWidget {
  const _MapPolygonLayer({
    required this.polygons,
    required this.color,
    required this.strokeWidth,
    required this.strokeColor,
    required this.tooltipBuilder,
    required this.polygonLayer,
    required this.fillType,
  });

  final Set<MapPolygon> polygons;
  final Color? color;
  final double strokeWidth;
  final Color? strokeColor;
  final IndexedWidgetBuilder? tooltipBuilder;
  final MapPolygonLayer polygonLayer;
  final _VectorFillType fillType;

  @override
  _MapPolygonLayerState createState() => _MapPolygonLayerState();
}

class _MapPolygonLayerState extends State<_MapPolygonLayer>
    with SingleTickerProviderStateMixin {
  MapController? _controller;
  late AnimationController _hoverAnimationController;
  late SfMapsThemeData _mapsThemeData;
  late MapLayerInheritedWidget ancestor;

  @override
  void initState() {
    super.initState();
    _hoverAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
  }

  @override
  void didChangeDependencies() {
    if (_controller == null) {
      ancestor = context
          .dependOnInheritedWidgetOfExactType<MapLayerInheritedWidget>()!;
      _controller = ancestor.controller;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller = null;
    _hoverAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      if (widget.fillType == _VectorFillType.outer) {
        for (final MapPolygon polygon in widget.polygons) {
          assert(
              polygon.color == null,
              throw FlutterError.fromParts(<DiagnosticsNode>[
                ErrorSummary('Incorrect MapPolygon arguments.'),
                ErrorDescription(
                    'Inverted polygons cannot be customized individually.'),
                ErrorHint(
                    '''To customize all the polygon's color, use MapPolygonLayer.color''')
              ]));
          assert(
              polygon.strokeColor == null,
              throw FlutterError.fromParts(<DiagnosticsNode>[
                ErrorSummary('Incorrect MapPolygon arguments.'),
                ErrorDescription(
                    'Inverted polygons cannot be customized individually.'),
                ErrorHint(
                    '''To customize all the polygon's stroke color, use MapPolygonLayer.strokeColor''')
              ]));
          assert(
              polygon.strokeWidth == null,
              throw FlutterError.fromParts(<DiagnosticsNode>[
                ErrorSummary('Incorrect MapPolygon arguments.'),
                ErrorDescription(
                    'Inverted polygons cannot be customized individually.'),
                ErrorHint(
                    '''To customize all the polygon's stroke width, use MapPolygonLayer.strokeWidth''')
              ]));
        }
      }
      return true;
    }());

    final ThemeData themeData = Theme.of(context);
    final bool isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;
    _mapsThemeData = SfMapsTheme.of(context)!;
    return _MapPolygonLayerRenderObject(
      controller: _controller,
      polygons: widget.polygons,
      color: widget.color ??
          (widget.fillType == _VectorFillType.inner
              ? const Color.fromRGBO(51, 153, 144, 1)
              : (_mapsThemeData.brightness == Brightness.light
                  ? const Color.fromRGBO(3, 3, 3, 0.15)
                  : const Color.fromRGBO(0, 0, 0, 0.2))),
      strokeWidth: widget.strokeWidth,
      strokeColor: widget.strokeColor ??
          (widget.fillType == _VectorFillType.inner
              ? const Color.fromRGBO(51, 153, 144, 1)
              : (_mapsThemeData.brightness == Brightness.light
                  ? const Color.fromRGBO(98, 0, 238, 1)
                  : const Color.fromRGBO(187, 134, 252, 0.5))),
      tooltipBuilder: widget.tooltipBuilder,
      polygonLayer: widget.polygonLayer,
      hoverAnimationController: _hoverAnimationController,
      themeData: _mapsThemeData,
      isDesktop: isDesktop,
      fillType: widget.fillType,
      state: this,
    );
  }
}

class _MapPolygonLayerRenderObject extends LeafRenderObjectWidget {
  const _MapPolygonLayerRenderObject({
    required this.controller,
    required this.polygons,
    required this.color,
    required this.strokeWidth,
    required this.strokeColor,
    required this.tooltipBuilder,
    required this.polygonLayer,
    required this.hoverAnimationController,
    required this.themeData,
    required this.isDesktop,
    required this.fillType,
    required this.state,
  });

  final MapController? controller;
  final Set<MapPolygon> polygons;
  final Color color;
  final double strokeWidth;
  final Color strokeColor;
  final IndexedWidgetBuilder? tooltipBuilder;
  final MapPolygonLayer polygonLayer;
  final AnimationController hoverAnimationController;
  final SfMapsThemeData themeData;
  final bool isDesktop;
  final _VectorFillType fillType;
  final _MapPolygonLayerState state;

  @override
  _RenderMapPolygon createRenderObject(BuildContext context) {
    return _RenderMapPolygon(
      controller: controller,
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
      fillType: fillType,
      state: state,
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
      ..fillType = fillType
      ..state = state;
  }
}

class _RenderMapPolygon extends RenderBox implements MouseTrackerAnnotation {
  _RenderMapPolygon({
    required MapController? controller,
    required Set<MapPolygon> polygons,
    required Color color,
    required double strokeWidth,
    required Color strokeColor,
    required IndexedWidgetBuilder? tooltipBuilder,
    required SfMapsThemeData themeData,
    required BuildContext context,
    required MapPolygonLayer polygonLayer,
    required AnimationController hoverAnimationController,
    required bool isDesktop,
    required this.fillType,
    required this.state,
  })   : _controller = controller,
        _polygons = polygons,
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
    _polygonsInList = _polygons.toList();
    _tapGestureRecognizer = TapGestureRecognizer()..onTapUp = _handleTapUp;
  }

  final MapController? _controller;
  int _selectedIndex = -1;
  late _MapPolygonLayerState state;
  late _VectorFillType fillType;
  late AnimationController hoverAnimationController;
  late bool isDesktop;
  late MapPolygonLayer polygonLayer;
  late BuildContext context;
  late TapGestureRecognizer _tapGestureRecognizer;
  late Animation<double> _hoverColorAnimation;
  late ColorTween _forwardHoverColor;
  late ColorTween _reverseHoverColor;
  late ColorTween _forwardHoverStrokeColor;
  late ColorTween _reverseHoverStrokeColor;
  late MapPolygon _selectedPolygon;

  MapPolygon? _previousHoverItem;
  MapPolygon? _currentHoverItem;
  List<MapPolygon>? _polygonsInList;

  Set<MapPolygon> get polygons => _polygons;
  Set<MapPolygon> _polygons;
  set polygons(Set<MapPolygon>? value) {
    assert(value != null);
    if (_polygons == value || value == null) {
      return;
    }
    _polygons = value;
    _polygonsInList = _polygons.toList();
    markNeedsPaint();
  }

  IndexedWidgetBuilder? get tooltipBuilder => _tooltipBuilder;
  IndexedWidgetBuilder? _tooltipBuilder;
  set tooltipBuilder(IndexedWidgetBuilder? value) {
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
      return _themeData.shapeHoverColor!;
    }
    final Color color = polygon.color ?? _color;
    return color.withOpacity(
        (double.parse(color.opacity.toStringAsFixed(2)) != hoverColorOpacity)
            ? hoverColorOpacity
            : minHoverOpacity);
  }

  Color _getHoverStrokeColor(MapPolygon polygon) {
    if (hasHoverStrokeColor) {
      return _themeData.shapeHoverStrokeColor!;
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

    final ShapeLayerChildRenderBoxBase tooltipRenderer =
        _controller!.tooltipKey!.currentContext!.findRenderObject()
            // ignore: avoid_as
            as ShapeLayerChildRenderBoxBase;
    tooltipRenderer.hideTooltip();
  }

  void _handleZooming(MapZoomDetails details) {
    markNeedsPaint();
  }

  void _handlePanning(MapPanDetails details) {
    markNeedsPaint();
  }

  void _handleInteraction(Offset position,
      [PointerKind kind = PointerKind.touch]) {
    if (_controller?.tooltipKey != null && _tooltipBuilder != null) {
      final ShapeLayerChildRenderBoxBase tooltipRenderer =
          _controller!.tooltipKey!.currentContext!.findRenderObject()
              // ignore: avoid_as
              as ShapeLayerChildRenderBoxBase;
      tooltipRenderer.paintTooltip(_selectedIndex, null, MapLayerElement.vector,
          kind, state.ancestor.sublayers?.indexOf(polygonLayer), position);
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _selectedPolygon.onTap?.call();
    _handleInteraction(details.localPosition);
  }

  @override
  MouseCursor get cursor => SystemMouseCursors.basic;

  @override
  PointerEnterEventListener? get onEnter => null;

  // As onHover property of MouseHoverAnnotation was removed only in the
  // beta channel, once it is moved to stable, will remove this property.
  @override
  // ignore: override_on_non_overriding_member
  PointerHoverEventListener? get onHover => null;

  @override
  PointerExitEventListener get onExit => _handlePointerExit;

  @override
  // ignore: override_on_non_overriding_member
  bool get validForMouseTracker => true;

  @override
  bool hitTestSelf(Offset position) {
    int index = _polygonsInList!.length - 1;
    final Size boxSize = _controller?.layerType == LayerType.tile
        ? _controller!.totalTileSize!
        : size;
    final Offset translationOffset = getTranslationOffset(_controller!);
    for (final MapPolygon polygon in _polygonsInList!.reversed) {
      if (polygon.onTap != null || _tooltipBuilder != null || canHover) {
        final Path path = Path();

        final MapLatLng startCoordinate = polygon.points[0];
        Offset startPoint = pixelFromLatLng(
            startCoordinate.latitude,
            startCoordinate.longitude,
            boxSize,
            translationOffset,
            getLayerSizeFactor(_controller!));
        startPoint = _getScaledOffset(startPoint, _controller!);
        path.moveTo(startPoint.dx, startPoint.dy);

        for (int j = 1; j < polygon.points.length; j++) {
          final MapLatLng nextCoordinate = polygon.points[j];
          Offset nextPoint = pixelFromLatLng(
              nextCoordinate.latitude,
              nextCoordinate.longitude,
              boxSize,
              translationOffset,
              getLayerSizeFactor(_controller!));
          nextPoint = _getScaledOffset(nextPoint, _controller!);
          path.lineTo(nextPoint.dx, nextPoint.dy);
        }
        path.close();
        if (path.contains(position)) {
          _selectedPolygon = polygon;
          _selectedIndex = index;
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
    } else if (event is PointerHoverEvent && isDesktop) {
      if (_currentHoverItem != _selectedPolygon) {
        _previousHoverItem = _currentHoverItem;
        _currentHoverItem = _selectedPolygon;
        _initializeHoverItemTween();
      }

      // ignore: avoid_as
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      _handleInteraction(
          renderBox.globalToLocal(event.position), PointerKind.hover);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (_controller != null) {
      _controller!
        ..addZoomingListener(_handleZooming)
        ..addPanningListener(_handlePanning)
        ..addResetListener(markNeedsPaint)
        ..addRefreshListener(markNeedsPaint);
    }
    _hoverColorAnimation.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    if (_controller != null) {
      _controller!
        ..removeZoomingListener(_handleZooming)
        ..removePanningListener(_handlePanning)
        ..removeResetListener(markNeedsPaint)
        ..removeRefreshListener(markNeedsPaint);
    }
    _hoverColorAnimation.removeListener(markNeedsPaint);
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
    final Size boxSize = _controller?.layerType == LayerType.tile
        ? _controller!.totalTileSize!
        : size;
    final Offset translationOffset = getTranslationOffset(_controller!);
    // Check whether the color will apply to the inner side or outer side of
    // the polygon shape.
    final bool isInverted = fillType == _VectorFillType.outer;

    Path path = Path();
    for (final MapPolygon polygon in polygons) {
      // Creating new path for each polygon for applying individual polygon
      // customization like color, strokeColor and strokeWidth customization.
      // For inverted polygon, all polygons are added in a single path to make
      // the polygons area to be transparent while combining the path.
      if (!isInverted) {
        path = Path();
      }

      final MapLatLng startLatLng = polygon.points[0];
      Offset startPoint = pixelFromLatLng(
          startLatLng.latitude,
          startLatLng.longitude,
          boxSize,
          translationOffset,
          getLayerSizeFactor(_controller!));

      startPoint = _getScaledOffset(startPoint, _controller!);
      path.moveTo(startPoint.dx, startPoint.dy);

      for (int j = 1; j < polygon.points.length; j++) {
        final MapLatLng nextCoordinate = polygon.points[j];
        Offset nextPoint = pixelFromLatLng(
            nextCoordinate.latitude,
            nextCoordinate.longitude,
            boxSize,
            translationOffset,
            getLayerSizeFactor(_controller!));
        nextPoint = _getScaledOffset(nextPoint, _controller!);
        path.lineTo(nextPoint.dx, nextPoint.dy);
      }
      path.close();

      if (!isInverted) {
        _updateFillColor(polygon, fillPaint);
        _updateStroke(polygon, strokePaint);
        context.canvas..drawPath(path, fillPaint)..drawPath(path, strokePaint);
      }
    }

    if (isInverted) {
      fillPaint.color = _color;
      strokePaint
        ..strokeWidth = _strokeWidth
        ..color = _strokeColor;
      _drawInvertedPath(
          context, path, _controller!, fillPaint, strokePaint, offset);
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
          ? _reverseHoverColor.evaluate(_hoverColorAnimation)!
          : (polygon.color ?? _color);
    } else if (_currentHoverItem != null && _currentHoverItem == polygon) {
      paint.color = _themeData.shapeHoverColor != Colors.transparent
          ? _forwardHoverColor.evaluate(_hoverColorAnimation)!
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
      paint.strokeWidth = polygon.strokeWidth ?? _strokeWidth;
    } else if (_currentHoverItem != null && _currentHoverItem == polygon) {
      _updateHoverStrokeColor(paint, polygon, _forwardHoverStrokeColor);
      if (_themeData.shapeHoverStrokeWidth != null &&
          _themeData.shapeHoverStrokeWidth! > 0.0) {
        paint.strokeWidth = _themeData.shapeHoverStrokeWidth!;
      } else {
        paint.strokeWidth = polygon.strokeWidth ?? _strokeWidth;
      }
    } else {
      _updateDefaultStroke(paint, polygon);
    }
  }

  void _updateDefaultStroke(Paint paint, MapPolygon polygon) {
    paint
      ..color = polygon.strokeColor ?? _strokeColor
      ..strokeWidth = polygon.strokeWidth ?? _strokeWidth;
  }

  void _updateHoverStrokeColor(
      Paint paint, MapPolygon polygon, ColorTween tween) {
    if (_themeData.shapeHoverStrokeColor != Colors.transparent) {
      paint.color = tween.evaluate(_hoverColorAnimation)!;
    } else {
      paint.color = polygon.strokeColor ?? _strokeColor;
    }
  }
}

/// A sublayer which renders group of [MapCircle] on [MapShapeLayer] and
/// [MapTileLayer].
///
/// ```dart
///  List<MapLatLng> _circles;
///  MapShapeSource _mapSource;
///
///  @override
///  void initState() {
///    _circles = const <MapLatLng>[
///      MapLatLng(-14.235004, -51.92528),
///      MapLatLng(51.16569, 10.451526),
///      MapLatLng(-25.274398, 133.775136),
///      MapLatLng(20.593684, 78.96288),
///      MapLatLng(61.52401, 105.318756)
///    ];
///
///    _mapSource = MapShapeSource.asset(
///      'assets/world_map.json',
///      shapeDataField: 'name',
///    );
///    super.initState();
///  }
///
///  @override
///  Widget build(BuildContext context) {
///    return Scaffold(
///      body: Center(
///          child: Container(
///        height: 350,
///        child: Padding(
///          padding: EdgeInsets.only(left: 15, right: 15),
///          child: SfMaps(
///            layers: <MapLayer>[
///              MapShapeLayer(
///                source: _mapSource,
///                sublayers: [
///                  MapCircleLayer(
///                    circles: List<MapCircle>.generate(
///                      _circles.length,
///                      (int index) {
///                        return MapCircle(
///                          center: _circles[index],
///                        );
///                      },
///                    ).toSet(),
///                  ),
///                ],
///              ),
///            ],
///          ),
///        ),
///      )),
///    );
///  }
///
/// See also:
/// * `MapCircleLayer.inverted()` named constructor, for inverted color support.
/// ```
class MapCircleLayer extends MapVectorLayer {
  /// Creates the [MapCircleLayer].
  MapCircleLayer({
    Key? key,
    required this.circles,
    this.animation,
    this.color,
    this.strokeWidth = 1,
    this.strokeColor,
    IndexedWidgetBuilder? tooltipBuilder,
  })  : _fillType = _VectorFillType.inner,
        super(key: key, tooltipBuilder: tooltipBuilder);

  /// You may highlight a specific area on a map to make it more readable by
  /// using the [circles] property of [MapCircleLayer.inverted] by adding mask
  /// to the outer region of the highlighted circles.
  ///
  /// Only one [MapCircleLayer.inverted] can be added and must be positioned at
  /// the top of all sublayers added under the [sublayers] property.
  ///
  /// ```dart
  ///  List<MapLatLng> _circles;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _circles = const <MapLatLng>[
  ///      MapLatLng(-14.235004, -51.92528),
  ///      MapLatLng(51.16569, 10.451526),
  ///      MapLatLng(-25.274398, 133.775136),
  ///      MapLatLng(20.593684, 78.96288),
  ///      MapLatLng(61.52401, 105.318756)
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/world_map.json',
  ///      shapeDataField: 'name',
  ///    );
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfMaps(
  ///         layers: [
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             sublayers: [
  ///               MapCircleLayer.inverted(
  ///                 circles: List<MapCircle>.generate(
  ///                   _circles.length,
  ///                   (int index) {
  ///                     return MapCircle(
  ///                       center: _circles[index],
  ///                     );
  ///                   },
  ///                 ).toSet(),
  ///               ),
  ///             ],
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// See also:
  /// * [MapCircleLayer()], for normal circle shape on the map.
  /// ```
  MapCircleLayer.inverted({
    Key? key,
    required this.circles,
    this.animation,
    this.strokeWidth = 1,
    this.color,
    this.strokeColor,
    IndexedWidgetBuilder? tooltipBuilder,
  })  : _fillType = _VectorFillType.outer,
        super(key: key, tooltipBuilder: tooltipBuilder);

  /// A collection of [MapCircle].
  ///
  /// Every single [MapCircle] is drawn based on the given [MapCircle.center]
  /// and [MapCircle.radius].
  ///
  /// ```dart
  ///  List<MapLatLng> _circles;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _circles = const <MapLatLng>[
  ///      MapLatLng(-14.235004, -51.92528),
  ///      MapLatLng(51.16569, 10.451526),
  ///      MapLatLng(-25.274398, 133.775136),
  ///      MapLatLng(20.593684, 78.96288),
  ///      MapLatLng(61.52401, 105.318756)
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/world_map.json',
  ///      shapeDataField: 'name',
  ///    );
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: Center(
  ///          child: Container(
  ///        height: 350,
  ///        child: Padding(
  ///          padding: EdgeInsets.only(left: 15, right: 15),
  ///          child: SfMaps(
  ///            layers: <MapLayer>[
  ///              MapShapeLayer(
  ///                source: _mapSource,
  ///                sublayers: [
  ///                  MapCircleLayer(
  ///                    circles: List<MapCircle>.generate(
  ///                      _circles.length,
  ///                      (int index) {
  ///                        return MapCircle(
  ///                          center: _circles[index],
  ///                        );
  ///                      },
  ///                    ).toSet(),
  ///                  ),
  ///                ],
  ///              ),
  ///            ],
  ///          ),
  ///        ),
  ///      )),
  ///    );
  ///  }
  /// ```
  final Set<MapCircle> circles;

  /// Animation for the [circles] in [MapCircleLayer].
  ///
  /// By default, [circles] will be rendered without any animation. The
  /// animation can be set as shown in the below code snippet. You can customise
  /// the animation flow, curve, duration and listen to the animation status.
  ///
  /// ```dart
  ///  List<MapLatLng> circles;
  ///  MapShapeSource _mapSource;
  ///  AnimationController _animationController;
  ///  Animation _animation;
  ///
  ///  @override
  ///  void initState() {
  ///    _circles = const <MapLatLng>[
  ///      MapLatLng(-14.235004, -51.92528),
  ///      MapLatLng(51.16569, 10.451526),
  ///      MapLatLng(-25.274398, 133.775136),
  ///      MapLatLng(20.593684, 78.96288),
  ///      MapLatLng(61.52401, 105.318756)
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/world_map.json',
  ///      shapeDataField: 'name',
  ///    );
  ///    _animationController = AnimationController(
  ///      duration: Duration(seconds: 3),
  ///      vsync: this,
  ///    );
  ///
  ///    _animation =
  ///        CurvedAnimation(parent: _animationController,
  ///        curve: Curves.easeInOut);
  ///
  ///    _animationController.forward(from: 0);
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: Center(
  ///          child: Container(
  ///        height: 350,
  ///        child: Padding(
  ///          padding: EdgeInsets.only(left: 15, right: 15),
  ///          child: SfMaps(
  ///            layers: <MapLayer>[
  ///              MapShapeLayer(
  ///                source: _mapSource,
  ///                sublayers: [
  ///                  MapCircleLayer(
  ///                    circles: List<MapCircle>.generate(
  ///                      _circles.length,
  ///                      (int index) {
  ///                        return MapCircle(
  ///                          center: _circles[index],
  ///                        );
  ///                      },
  ///                    ).toSet(),
  ///                    animation: _animation,
  ///                  ),
  ///                ],
  ///              ),
  ///            ],
  ///          ),
  ///        ),
  ///      )),
  ///    );
  ///  }
  ///
  ///  @override
  ///  void dispose() {
  ///    _animationController?.dispose();
  ///    super.dispose();
  ///  }
  /// ```
  final Animation? animation;

  /// The fill color of all the [MapCircle].
  ///
  /// For setting color for each [MapCircle], please check the
  /// [MapCircle.color] property.
  ///
  /// ```dart
  ///  List<MapLatLng> _circles;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _circles = const <MapLatLng>[
  ///      MapLatLng(-14.235004, -51.92528),
  ///      MapLatLng(51.16569, 10.451526),
  ///      MapLatLng(-25.274398, 133.775136),
  ///      MapLatLng(20.593684, 78.96288),
  ///      MapLatLng(61.52401, 105.318756)
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/world_map.json',
  ///      shapeDataField: 'name',
  ///    );
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: Center(
  ///          child: Container(
  ///        height: 350,
  ///        child: Padding(
  ///          padding: EdgeInsets.only(left: 15, right: 15),
  ///          child: SfMaps(
  ///            layers: <MapLayer>[
  ///              MapShapeLayer(
  ///                source: _mapSource,
  ///                sublayers: [
  ///                  MapCircleLayer(
  ///                    circles: List<MapCircle>.generate(
  ///                      _circles.length,
  ///                      (int index) {
  ///                        return MapCircle(
  ///                          center: _circles[index],
  ///                        );
  ///                      },
  ///                    ).toSet(),
  ///                    color: Colors.red,
  ///                  ),
  ///                ],
  ///              ),
  ///            ],
  ///          ),
  ///        ),
  ///      )),
  ///    );
  ///  }
  /// ```
  final Color? color;

  /// The stroke width of all the [MapCircle].
  ///
  /// For setting stroke width for each [MapCircle], please check the
  /// [MapCircle.strokeWidth] property.
  ///
  /// ```dart
  ///  List<MapLatLng> _circles;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _circles = const <MapLatLng>[
  ///      MapLatLng(-14.235004, -51.92528),
  ///      MapLatLng(51.16569, 10.451526),
  ///      MapLatLng(-25.274398, 133.775136),
  ///      MapLatLng(20.593684, 78.96288),
  ///      MapLatLng(61.52401, 105.318756)
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/world_map.json',
  ///      shapeDataField: 'name',
  ///    );
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: Center(
  ///          child: Container(
  ///        height: 350,
  ///        child: Padding(
  ///          padding: EdgeInsets.only(left: 15, right: 15),
  ///          child: SfMaps(
  ///            layers: <MapLayer>[
  ///              MapShapeLayer(
  ///                source: _mapSource,
  ///                sublayers: [
  ///                  MapCircleLayer(
  ///                    circles: List<MapCircle>.generate(
  ///                      _circles.length,
  ///                      (int index) {
  ///                        return MapCircle(
  ///                          center: _circles[index],
  ///                        );
  ///                      },
  ///                    ).toSet(),
  ///                    strokeWidth: 4.0,
  ///                    strokeColor: Colors.red,
  ///                  ),
  ///                ],
  ///              ),
  ///            ],
  ///          ),
  ///        ),
  ///      )),
  ///    );
  ///  }
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
  ///  List<MapLatLng> _circles;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _circles = const <MapLatLng>[
  ///      MapLatLng(-14.235004, -51.92528),
  ///      MapLatLng(51.16569, 10.451526),
  ///      MapLatLng(-25.274398, 133.775136),
  ///      MapLatLng(20.593684, 78.96288),
  ///      MapLatLng(61.52401, 105.318756)
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/world_map.json',
  ///      shapeDataField: 'name',
  ///    );
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: Center(
  ///          child: Container(
  ///        height: 350,
  ///        child: Padding(
  ///          padding: EdgeInsets.only(left: 15, right: 15),
  ///          child: SfMaps(
  ///            layers: <MapLayer>[
  ///              MapShapeLayer(
  ///                source: _mapSource,
  ///                sublayers: [
  ///                  MapCircleLayer(
  ///                    circles: List<MapCircle>.generate(
  ///                      _circles.length,
  ///                      (int index) {
  ///                        return MapCircle(
  ///                          center: _circles[index],
  ///                        );
  ///                      },
  ///                    ).toSet(),
  ///                    strokeWidth: 4.0,
  ///                    strokeColor: Colors.red,
  ///                  ),
  ///                ],
  ///              ),
  ///            ],
  ///          ),
  ///        ),
  ///      )),
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// [strokeWidth], to set the stroke width for the circles.
  final Color? strokeColor;

  /// Strategies for painting a circle in a canvas.
  final _VectorFillType _fillType;

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
      fillType: _fillType,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    if (circles.isNotEmpty) {
      final _DebugVectorShapeTree pointerTreeNode =
          _DebugVectorShapeTree(circles);
      properties.add(pointerTreeNode.toDiagnosticsNode());
    }
    properties.add(ObjectFlagProperty<Animation>.has('animation', animation));
    properties.add(ObjectFlagProperty<IndexedWidgetBuilder>.has(
        'tooltip', tooltipBuilder));

    if (color != null) {
      properties.add(ColorProperty('color', color));
    }

    if (strokeColor != null) {
      properties.add(ColorProperty('strokeColor', strokeColor));
    }

    properties.add(DoubleProperty('strokeWidth', strokeWidth));
  }
}

class _MapCircleLayer extends StatefulWidget {
  const _MapCircleLayer({
    required this.circles,
    required this.animation,
    required this.color,
    required this.strokeWidth,
    required this.strokeColor,
    required this.tooltipBuilder,
    required this.circleLayer,
    required this.fillType,
  });

  final Set<MapCircle> circles;
  final Animation? animation;
  final Color? color;
  final double strokeWidth;
  final Color? strokeColor;
  final IndexedWidgetBuilder? tooltipBuilder;
  final MapCircleLayer circleLayer;
  final _VectorFillType fillType;

  @override
  _MapCircleLayerState createState() => _MapCircleLayerState();
}

class _MapCircleLayerState extends State<_MapCircleLayer>
    with SingleTickerProviderStateMixin {
  MapController? _controller;
  late AnimationController _hoverAnimationController;
  late SfMapsThemeData _mapsThemeData;
  late MapLayerInheritedWidget ancestor;

  @override
  void initState() {
    super.initState();
    _hoverAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
  }

  @override
  void didChangeDependencies() {
    if (_controller == null) {
      ancestor = context
          .dependOnInheritedWidgetOfExactType<MapLayerInheritedWidget>()!;
      _controller = ancestor.controller;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller = null;
    _hoverAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      if (widget.fillType == _VectorFillType.outer) {
        for (final MapCircle circle in widget.circles) {
          assert(
              circle.color == null,
              throw FlutterError.fromParts(<DiagnosticsNode>[
                ErrorSummary('Incorrect MapCircle arguments.'),
                ErrorDescription(
                    'Inverted circles cannot be customized individually.'),
                ErrorHint(
                    '''To customize all the circle's color, use MapCircleLayer.color''')
              ]));
          assert(
              circle.strokeColor == null,
              throw FlutterError.fromParts(<DiagnosticsNode>[
                ErrorSummary('Incorrect MapCircle arguments.'),
                ErrorDescription(
                    'Inverted circles cannot be customized individually.'),
                ErrorHint(
                    '''To customize all the circle's stroke color, use MapCircleLayer.strokeColor''')
              ]));
          assert(
              circle.strokeWidth == null,
              throw FlutterError.fromParts(<DiagnosticsNode>[
                ErrorSummary('Incorrect MapCircle arguments.'),
                ErrorDescription(
                    'Inverted circles cannot be customized individually.'),
                ErrorHint(
                    '''To customize all the circle's stroke width, use MapCircleLayer.strokeWidth''')
              ]));
        }
      }
      return true;
    }());

    final ThemeData themeData = Theme.of(context);
    final bool isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;
    _mapsThemeData = SfMapsTheme.of(context)!;
    return _MapCircleLayerRenderObject(
      controller: _controller,
      circles: widget.circles,
      animation: widget.animation,
      color: widget.color ??
          (widget.fillType == _VectorFillType.inner
              ? const Color.fromRGBO(51, 153, 144, 1)
              : (_mapsThemeData.brightness == Brightness.light
                  ? const Color.fromRGBO(3, 3, 3, 0.15)
                  : const Color.fromRGBO(0, 0, 0, 0.2))),
      strokeWidth: widget.strokeWidth,
      strokeColor: widget.strokeColor ??
          (widget.fillType == _VectorFillType.inner
              ? const Color.fromRGBO(51, 153, 144, 1)
              : (_mapsThemeData.brightness == Brightness.light
                  ? const Color.fromRGBO(98, 0, 238, 1)
                  : const Color.fromRGBO(187, 134, 252, 0.5))),
      tooltipBuilder: widget.tooltipBuilder,
      circleLayer: widget.circleLayer,
      hoverAnimationController: _hoverAnimationController,
      themeData: _mapsThemeData,
      isDesktop: isDesktop,
      fillType: widget.fillType,
      state: this,
    );
  }
}

class _MapCircleLayerRenderObject extends LeafRenderObjectWidget {
  const _MapCircleLayerRenderObject({
    required this.controller,
    required this.circles,
    required this.animation,
    required this.color,
    required this.strokeWidth,
    required this.strokeColor,
    required this.tooltipBuilder,
    required this.circleLayer,
    required this.hoverAnimationController,
    required this.themeData,
    required this.isDesktop,
    required this.fillType,
    required this.state,
  });

  final MapController? controller;
  final Set<MapCircle> circles;
  final Animation? animation;
  final Color color;
  final double strokeWidth;
  final Color strokeColor;
  final IndexedWidgetBuilder? tooltipBuilder;
  final MapCircleLayer circleLayer;
  final AnimationController hoverAnimationController;
  final SfMapsThemeData themeData;
  final bool isDesktop;
  final _VectorFillType fillType;
  final _MapCircleLayerState state;

  @override
  _RenderMapCircle createRenderObject(BuildContext context) {
    return _RenderMapCircle(
      controller: controller,
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
      fillType: fillType,
      state: state,
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
      ..fillType = fillType
      ..state = state;
  }
}

class _RenderMapCircle extends RenderBox implements MouseTrackerAnnotation {
  _RenderMapCircle({
    required MapController? controller,
    required Set<MapCircle> circles,
    required Animation? animation,
    required Color color,
    required double strokeWidth,
    required Color strokeColor,
    required IndexedWidgetBuilder? tooltipBuilder,
    required SfMapsThemeData themeData,
    required BuildContext context,
    required MapCircleLayer circleLayer,
    required AnimationController hoverAnimationController,
    required bool isDesktop,
    required this.fillType,
    required this.state,
  })   : _controller = controller,
        _circles = circles,
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
    _circlesInList = _circles.toList();
    _tapGestureRecognizer = TapGestureRecognizer()..onTapUp = _handleTapUp;
  }

  final MapController? _controller;
  late int _selectedIndex = -1;
  late _VectorFillType fillType;
  late _MapCircleLayerState state;
  late AnimationController hoverAnimationController;
  late MapCircleLayer circleLayer;
  late bool isDesktop;
  late BuildContext context;
  late TapGestureRecognizer _tapGestureRecognizer;
  late Animation<double> _hoverColorAnimation;
  late ColorTween _forwardHoverColor;
  late ColorTween _reverseHoverColor;
  late ColorTween _forwardHoverStrokeColor;
  late ColorTween _reverseHoverStrokeColor;
  late MapCircle _selectedCircle;

  MapCircle? _previousHoverItem;
  MapCircle? _currentHoverItem;
  List<MapCircle>? _circlesInList;

  Set<MapCircle> get circles => _circles;
  Set<MapCircle> _circles;
  set circles(Set<MapCircle>? value) {
    assert(value != null);
    if (_circles == value || value == null) {
      return;
    }
    _circles = value;
    _circlesInList = _circles.toList();
    markNeedsPaint();
  }

  Animation? get animation => _animation;
  Animation? _animation;
  set animation(Animation? value) {
    if (_animation == value) {
      return;
    }
    _animation = value;
  }

  IndexedWidgetBuilder? get tooltipBuilder => _tooltipBuilder;
  IndexedWidgetBuilder? _tooltipBuilder;
  set tooltipBuilder(IndexedWidgetBuilder? value) {
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
      return _themeData.shapeHoverColor!;
    }
    final Color color = circle.color ?? _color;
    return color.withOpacity(
        (double.parse(color.opacity.toStringAsFixed(2)) != hoverColorOpacity)
            ? hoverColorOpacity
            : minHoverOpacity);
  }

  Color _getHoverStrokeColor(MapCircle circle) {
    if (hasHoverStrokeColor) {
      return _themeData.shapeHoverStrokeColor!;
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

    final ShapeLayerChildRenderBoxBase tooltipRenderer =
        // ignore: lines_longer_than_80_chars
        // ignore: avoid_as
        _controller!.tooltipKey!.currentContext!.findRenderObject()
            // ignore: avoid_as
            as ShapeLayerChildRenderBoxBase;
    tooltipRenderer.hideTooltip();
  }

  void _handleZooming(MapZoomDetails details) {
    markNeedsPaint();
  }

  void _handlePanning(MapPanDetails details) {
    markNeedsPaint();
  }

  void _handleInteraction(Offset position,
      [PointerKind kind = PointerKind.touch]) {
    if (_controller?.tooltipKey != null && _tooltipBuilder != null) {
      final ShapeLayerChildRenderBoxBase tooltipRenderer =
          // ignore: avoid_as
          _controller!.tooltipKey!.currentContext!.findRenderObject()
              // ignore: avoid_as
              as ShapeLayerChildRenderBoxBase;
      final Size boxSize = _controller?.layerType == LayerType.tile
          ? _controller!.totalTileSize!
          : size;
      final Offset translationOffset = _getTranslation(_controller!);

      if (_selectedIndex != -1) {
        Offset center = pixelFromLatLng(
          _selectedCircle.center.latitude,
          _selectedCircle.center.longitude,
          boxSize,
          translationOffset,
          _controller!.shapeLayerSizeFactor,
        );
        center = _getScaledOffset(center, _controller!);

        final Rect circleRect =
            Rect.fromCircle(center: center, radius: _selectedCircle.radius);
        tooltipRenderer.paintTooltip(
          _selectedIndex,
          circleRect,
          MapLayerElement.vector,
          kind,
          state.ancestor.sublayers?.indexOf(circleLayer),
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
  PointerEnterEventListener? get onEnter => null;

  // As onHover property of MouseHoverAnnotation was removed only in the
  // beta channel, once it is moved to stable, will remove this property.
  @override
  // ignore: override_on_non_overriding_member
  PointerHoverEventListener? get onHover => null;

  @override
  PointerExitEventListener get onExit => _handlePointerExit;

  @override
  // ignore: override_on_non_overriding_member
  bool get validForMouseTracker => true;

  @override
  bool hitTestSelf(Offset position) {
    if (_animation != null && !_animation!.isCompleted) {
      return false;
    }

    int index = _circlesInList!.length - 1;
    final Size boxSize = _controller?.layerType == LayerType.tile
        ? _controller!.totalTileSize!
        : size;
    final Offset translationOffset = getTranslationOffset(_controller!);

    for (final MapCircle circle in _circlesInList!.reversed) {
      if (circle.onTap != null || _tooltipBuilder != null || canHover) {
        final Path path = Path();
        Offset center = pixelFromLatLng(
          circle.center.latitude,
          circle.center.longitude,
          boxSize,
          translationOffset,
          getLayerSizeFactor(_controller!),
        );

        center = _getScaledOffset(center, _controller!);
        path.addOval(Rect.fromCircle(
          center: center,
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
    if (_controller != null) {
      _controller!
        ..addZoomingListener(_handleZooming)
        ..addPanningListener(_handlePanning)
        ..addResetListener(markNeedsPaint)
        ..addRefreshListener(markNeedsPaint);
    }
    _animation?.addListener(markNeedsPaint);
    _hoverColorAnimation.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    if (_controller != null) {
      _controller!
        ..removeZoomingListener(_handleZooming)
        ..removePanningListener(_handlePanning)
        ..removeResetListener(markNeedsPaint)
        ..removeRefreshListener(markNeedsPaint);
    }
    _animation?.removeListener(markNeedsPaint);
    _hoverColorAnimation.removeListener(markNeedsPaint);
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

      // ignore: avoid_as
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      _handleInteraction(
          renderBox.globalToLocal(event.position), PointerKind.hover);
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
    if (_animation != null && _animation!.value == 0.0) {
      return;
    }

    context.canvas.save();
    final Paint fillPaint = Paint()..isAntiAlias = true;
    final Paint strokePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;
    final Size boxSize = _controller?.layerType == LayerType.tile
        ? _controller!.totalTileSize!
        : size;
    final Offset translationOffset = getTranslationOffset(_controller!);
    // Check whether the color will apply to the inner side or outer side of
    // the circle shape.
    final bool isInverted = fillType == _VectorFillType.outer;

    Path path = Path();
    for (final MapCircle circle in circles) {
      // Creating new path for each circle for applying individual circle
      // customization like color, strokeColor and strokeWidth customization.
      // For inverted circle, all circles are added in a single path to make
      // the circles area to be transparent while combining the path.
      if (!isInverted) {
        path = Path();
      }
      Offset circleCenter = pixelFromLatLng(
        circle.center.latitude,
        circle.center.longitude,
        boxSize,
        translationOffset,
        getLayerSizeFactor(_controller!),
      );

      circleCenter = _getScaledOffset(circleCenter, _controller!);
      final Rect circleRect = Rect.fromCircle(
        center: circleCenter,
        radius: circle.radius * (_animation?.value ?? 1.0),
      );

      path.addOval(circleRect);
      if (!isInverted) {
        _updateFillColor(circle, fillPaint);
        _updateStroke(circle, strokePaint);
        context.canvas..drawPath(path, fillPaint)..drawPath(path, strokePaint);
      }
    }

    if (isInverted) {
      fillPaint.color = _color;
      strokePaint
        ..strokeWidth = _strokeWidth
        ..color = _strokeColor;
      _drawInvertedPath(
          context, path, _controller!, fillPaint, strokePaint, offset);
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
          ? _reverseHoverColor.evaluate(_hoverColorAnimation)!
          : (circle.color ?? _color);
    } else if (_currentHoverItem != null && _currentHoverItem == circle) {
      paint.color = _themeData.shapeHoverColor != Colors.transparent
          ? _forwardHoverColor.evaluate(_hoverColorAnimation)!
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
      paint.strokeWidth = circle.strokeWidth ?? _strokeWidth;
    } else if (_currentHoverItem != null && _currentHoverItem == circle) {
      _updateHoverStrokeColor(paint, circle, _forwardHoverStrokeColor);
      if (_themeData.shapeHoverStrokeWidth != null &&
          _themeData.shapeHoverStrokeWidth! > 0.0) {
        paint.strokeWidth = _themeData.shapeHoverStrokeWidth!;
      } else {
        paint.strokeWidth = circle.strokeWidth ?? _strokeWidth;
      }
    } else {
      _updateDefaultStroke(paint, circle);
    }
  }

  void _updateDefaultStroke(Paint paint, MapCircle circle) {
    paint
      ..color = circle.strokeColor ?? _strokeColor
      ..strokeWidth = circle.strokeWidth ?? _strokeWidth;
  }

  void _updateHoverStrokeColor(
      Paint paint, MapCircle circle, ColorTween tween) {
    if (_themeData.shapeHoverStrokeColor != Colors.transparent) {
      paint.color = tween.evaluate(_hoverColorAnimation)!;
    } else {
      paint.color = circle.strokeColor ?? _strokeColor;
    }
  }
}

/// Creates a line between the two geographical coordinates on the map.
///
/// ```dart
///   List<Model> _lines;
///   MapZoomPanBehavior _zoomPanBehavior;
///   MapShapeSource _mapSource;
///
///   @override
///   void initState() {
///     _zoomPanBehavior = MapZoomPanBehavior(
///       focalLatLng: MapLatLng(40.7128, -95.3698),
///       zoomLevel: 3,
///     );
///
///     _mapSource = MapShapeSource.asset(
///       "assets/world_map.json",
///       shapeDataField: "continent",
///     );
///
///     _lines = <Model>[
///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
///     ];
///
///     super.initState();
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: SfMaps(
///         layers: [
///           MapShapeLayer(
///             source: _mapSource,
///             zoomPanBehavior: _zoomPanBehavior,
///             sublayers: [
///               MapLineLayer(
///                 lines: List<MapLine>.generate(
///                   _lines.length,
///                   (int index) {
///                     return MapLine(
///                       from: _lines[index].from,
///                       to: _lines[index].to,
///                     );
///                   },
///                 ).toSet(),
///               ),
///             ],
///           ),
///         ],
///       ),
///     );
///   }
///
/// class Model {
///   Model(this.from, this.to);
///
///   MapLatLng from;
///   MapLatLng to;
/// }
/// ```
class MapLine extends DiagnosticableTree {
  /// Creates a [MapLine].
  const MapLine({
    required this.from,
    required this.to,
    this.dashArray = const [0, 0],
    this.color,
    this.width,
    this.onTap,
  });

  /// The starting coordinate of the line.
  ///
  ///```dart
  ///   List<Model> _lines;
  ///   MapZoomPanBehavior _zoomPanBehavior;
  ///   MapShapeSource _mapSource;
  ///
  ///   @override
  ///   void initState() {
  ///     _zoomPanBehavior = MapZoomPanBehavior(
  ///       focalLatLng: MapLatLng(40.7128, -95.3698),
  ///       zoomLevel: 3,
  ///     );
  ///
  ///     _mapSource = MapShapeSource.asset(
  ///       "assets/world_map.json",
  ///       shapeDataField: "continent",
  ///     );
  ///
  ///     _lines = <Model>[
  ///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
  ///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
  ///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
  ///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
  ///     ];
  ///
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfMaps(
  ///         layers: [
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///             sublayers: [
  ///               MapLineLayer(
  ///                 lines: List<MapLine>.generate(
  ///                   _lines.length,
  ///                   (int index) {
  ///                     return MapLine(
  ///                       from: _lines[index].from,
  ///                       to: _lines[index].to,
  ///                     );
  ///                   },
  ///                 ).toSet(),
  ///               ),
  ///             ],
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class Model {
  ///   Model(this.from, this.to);
  ///
  ///   MapLatLng from;
  ///   MapLatLng to;
  /// }
  ///```
  final MapLatLng from;

  /// The ending coordinate of the line.
  ///
  /// ```dart
  ///   List<Model> _lines;
  ///   MapZoomPanBehavior _zoomPanBehavior;
  ///   MapShapeSource _mapSource;
  ///
  ///   @override
  ///   void initState() {
  ///     _zoomPanBehavior = MapZoomPanBehavior(
  ///       focalLatLng: MapLatLng(40.7128, -95.3698),
  ///       zoomLevel: 3,
  ///     );
  ///
  ///     _mapSource = MapShapeSource.asset(
  ///       "assets/world_map.json",
  ///       shapeDataField: "continent",
  ///     );
  ///
  ///     _lines = <Model>[
  ///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
  ///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
  ///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
  ///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
  ///     ];
  ///
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfMaps(
  ///         layers: [
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///             sublayers: [
  ///               MapLineLayer(
  ///                 lines: List<MapLine>.generate(
  ///                   _lines.length,
  ///                   (int index) {
  ///                     return MapLine(
  ///                       from: _lines[index].from,
  ///                       to: _lines[index].to,
  ///                     );
  ///                   },
  ///                 ).toSet(),
  ///               ),
  ///             ],
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class Model {
  ///   Model(this.from, this.to);
  ///
  ///   MapLatLng from;
  ///   MapLatLng to;
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
  ///   List<Model> _lines;
  ///   MapZoomPanBehavior _zoomPanBehavior;
  ///   MapShapeSource _mapSource;
  ///
  ///   @override
  ///   void initState() {
  ///     _zoomPanBehavior = MapZoomPanBehavior(
  ///       focalLatLng: MapLatLng(40.7128, -95.3698),
  ///       zoomLevel: 3,
  ///     );
  ///
  ///     _mapSource = MapShapeSource.asset(
  ///       "assets/world_map.json",
  ///       shapeDataField: "continent",
  ///     );
  ///
  ///     _lines = <Model>[
  ///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
  ///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
  ///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
  ///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
  ///     ];
  ///
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfMaps(
  ///         layers: [
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///             sublayers: [
  ///               MapLineLayer(
  ///                 lines: List<MapLine>.generate(
  ///                   _lines.length,
  ///                   (int index) {
  ///                     return MapLine(
  ///                       from: _lines[index].from,
  ///                       to: _lines[index].to,
  ///                       dashArray: [8, 3, 4, 3],
  ///                     );
  ///                   },
  ///                 ).toSet(),
  ///               ),
  ///             ],
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class Model {
  ///   Model(this.from, this.to);
  ///
  ///   MapLatLng from;
  ///   MapLatLng to;
  /// }
  ///```
  final List<double> dashArray;

  /// Color of the line.
  ///
  /// ```dart
  ///   List<Model> _lines;
  ///   MapZoomPanBehavior _zoomPanBehavior;
  ///   MapShapeSource _mapSource;
  ///
  ///   @override
  ///   void initState() {
  ///     _zoomPanBehavior = MapZoomPanBehavior(
  ///       focalLatLng: MapLatLng(40.7128, -95.3698),
  ///       zoomLevel: 3,
  ///     );
  ///
  ///     _mapSource = MapShapeSource.asset(
  ///       "assets/world_map.json",
  ///       shapeDataField: "continent",
  ///     );
  ///
  ///     _lines = <Model>[
  ///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
  ///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
  ///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
  ///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
  ///     ];
  ///
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfMaps(
  ///         layers: [
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///             sublayers: [
  ///               MapLineLayer(
  ///                 lines: List<MapLine>.generate(
  ///                   _lines.length,
  ///                   (int index) {
  ///                     return MapLine(
  ///                       from: _lines[index].from,
  ///                       to: _lines[index].to,
  ///                       color: Colors.blue,
  ///                     );
  ///                   },
  ///                 ).toSet(),
  ///               ),
  ///             ],
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class Model {
  ///   Model(this.from, this.to);
  ///
  ///   MapLatLng from;
  ///   MapLatLng to;
  /// }
  ///```
  final Color? color;

  /// Width of the line.
  ///
  /// ```dart
  ///   List<Model> _lines;
  ///   MapZoomPanBehavior _zoomPanBehavior;
  ///   MapShapeSource _mapSource;
  ///
  ///   @override
  ///   void initState() {
  ///     _zoomPanBehavior = MapZoomPanBehavior(
  ///       focalLatLng: MapLatLng(40.7128, -95.3698),
  ///       zoomLevel: 3,
  ///     );
  ///
  ///     _mapSource = MapShapeSource.asset(
  ///       "assets/world_map.json",
  ///       shapeDataField: "continent",
  ///     );
  ///
  ///     _lines = <Model>[
  ///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
  ///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
  ///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
  ///       Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
  ///     ];
  ///
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfMaps(
  ///         layers: [
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///             sublayers: [
  ///               MapLineLayer(
  ///                 lines: List<MapLine>.generate(
  ///                   _lines.length,
  ///                   (int index) {
  ///                     return MapLine(
  ///                       from: _lines[index].from,
  ///                       to: _lines[index].to,
  ///                       width: 4.0,
  ///                     );
  ///                   },
  ///                 ).toSet(),
  ///               ),
  ///             ],
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class Model {
  ///   Model(this.from, this.to);
  ///
  ///   MapLatLng from;
  ///   MapLatLng to;
  /// }
  ///```
  final double? width;

  /// Callback to receive tap event for this line.
  ///
  /// You can customize the appearance of the tapped line based on the index
  /// passed on it as shown in the below code snippet.
  ///
  /// ```dart
  ///  List<Model> _lines;
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  MapShapeSource _mapSource;
  ///  int _selectedIndex;
  ///
  ///  @override
  ///  void initState() {
  ///    _zoomPanBehavior = MapZoomPanBehavior(
  ///      focalLatLng: MapLatLng(40.7128, -95.3698),
  ///      zoomLevel: 3,
  ///    );
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "continent",
  ///    );
  ///
  ///    _lines = <Model>[
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
  ///    ];
  ///
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///            source: _mapSource,
  ///            zoomPanBehavior: _zoomPanBehavior,
  ///            sublayers: [
  ///              MapLineLayer(
  ///                lines: List<MapLine>.generate(
  ///                  _lines.length,
  ///                  (int index) {
  ///                    return MapLine(
  ///                        from: _lines[index].from,
  ///                        to: _lines[index].to,
  ///                        color:
  ///                            _selectedIndex == index ? Colors.blue
  ///                                : Colors.red,
  ///                        onTap: () {
  ///                          setState(() {
  ///                            _selectedIndex = index;
  ///                          });
  ///                        });
  ///                  },
  ///                ).toSet(),
  ///              ),
  ///            ],
  ///          ),
  ///        ],
  ///      ),
  ///    );
  ///  }
  ///
  /// class Model {
  ///  Model(this.from, this.to);
  ///
  ///  MapLatLng from;
  ///  MapLatLng to;
  /// }
  ///```
  final VoidCallback? onTap;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MapLatLng>('from', from));
    properties.add(DiagnosticsProperty<MapLatLng>('to', to));
    properties.add((DiagnosticsProperty<List<double>>('dashArray', dashArray)));
    if (color != null) {
      properties.add(ColorProperty('color', color));
    }

    if (width != null) {
      properties.add(DoubleProperty('width', width));
    }

    properties.add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
  }
}

/// Creates a polyline by connecting multiple geographical coordinates through
/// group of [points].
///
/// ```dart
///  MapZoomPanBehavior _zoomPanBehavior;
///  List<MapLatLng> _polyLines;
///  MapShapeSource _mapSource;
///
///   @override
///   void initState() {
///     _polyLines = <MapLatLng>[
///       MapLatLng(13.0827, 80.2707),
///       MapLatLng(14.4673, 78.8242),
///       MapLatLng(14.9091, 78.0092),
///       MapLatLng(16.2160, 77.3566),
///       MapLatLng(17.1557, 76.8697),
///       MapLatLng(18.0975, 75.4249),
///       MapLatLng(18.5204, 73.8567),
///       MapLatLng(19.0760, 72.8777),
///     ];
///
///     _mapSource = MapShapeSource.asset(
///       'assets/india.json',
///       shapeDataField: 'name',
///     );
///
///     _zoomPanBehavior = MapZoomPanBehavior(
///         zoomLevel: 3, focalLatLng: MapLatLng(15.3173, 76.7139));
///     super.initState();
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(title: Text('Polyline')),
///       body: SfMaps(
///         layers: [
///           MapShapeLayer(
///             source: _mapSource,
///             sublayers: [
///               MapPolylineLayer(
///                 polylines: List<MapPolyline>.generate(
///                   1,
///                   (int index) {
///                     return MapPolyline(
///                       points: _polyLines,
///                     );
///                   },
///                 ).toSet(),
///               ),
///             ],
///             zoomPanBehavior: _zoomPanBehavior,
///           ),
///         ],
///       ),
///     );
///   }
/// ```
class MapPolyline extends DiagnosticableTree {
  /// Creates a [MapPolyline].
  const MapPolyline({
    required this.points,
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
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  List<MapLatLng> _polyLines;
  ///  MapShapeSource _mapSource;
  ///
  ///   @override
  ///   void initState() {
  ///     _polyLines = <MapLatLng>[
  ///       MapLatLng(13.0827, 80.2707),
  ///       MapLatLng(14.4673, 78.8242),
  ///       MapLatLng(14.9091, 78.0092),
  ///       MapLatLng(16.2160, 77.3566),
  ///       MapLatLng(17.1557, 76.8697),
  ///       MapLatLng(18.0975, 75.4249),
  ///       MapLatLng(18.5204, 73.8567),
  ///       MapLatLng(19.0760, 72.8777),
  ///     ];
  ///
  ///     _mapSource = MapShapeSource.asset(
  ///       'assets/india.json',
  ///       shapeDataField: 'name',
  ///     );
  ///
  ///     _zoomPanBehavior = MapZoomPanBehavior(
  ///         zoomLevel: 3, focalLatLng: MapLatLng(15.3173, 76.7139));
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       appBar: AppBar(title: Text('Polyline')),
  ///       body: SfMaps(
  ///         layers: [
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             sublayers: [
  ///               MapPolylineLayer(
  ///                 polylines: List<MapPolyline>.generate(
  ///                   1,
  ///                   (int index) {
  ///                     return MapPolyline(
  ///                       points: _polyLines,
  ///                     );
  ///                   },
  ///                 ).toSet(),
  ///               ),
  ///             ],
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  /// ```
  final List<MapLatLng> points;

  /// The dash pattern for the polyline.
  ///
  /// A sequence of dash and gap will be rendered based on the values in this
  /// list. Once all values of the list is rendered, it will be repeated
  /// again till the end of the polyline.
  ///
  /// ```dart
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  List<MapLatLng> _polyLines;
  ///  MapShapeSource _mapSource;
  ///
  ///   @override
  ///   void initState() {
  ///     _polyLines = <MapLatLng>[
  ///       MapLatLng(13.0827, 80.2707),
  ///       MapLatLng(14.4673, 78.8242),
  ///       MapLatLng(14.9091, 78.0092),
  ///       MapLatLng(16.2160, 77.3566),
  ///       MapLatLng(17.1557, 76.8697),
  ///       MapLatLng(18.0975, 75.4249),
  ///       MapLatLng(18.5204, 73.8567),
  ///       MapLatLng(19.0760, 72.8777),
  ///     ];
  ///
  ///     _mapSource = MapShapeSource.asset(
  ///       'assets/india.json',
  ///       shapeDataField: 'name',
  ///     );
  ///
  ///     _zoomPanBehavior = MapZoomPanBehavior(
  ///         zoomLevel: 3, focalLatLng: MapLatLng(15.3173, 76.7139));
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       appBar: AppBar(title: Text('Polyline')),
  ///       body: SfMaps(
  ///         layers: [
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             sublayers: [
  ///               MapPolylineLayer(
  ///                 polylines: List<MapPolyline>.generate(
  ///                   1,
  ///                   (int index) {
  ///                     return MapPolyline(
  ///                       points: _polyLines,
  ///                       dashArray: [8, 3, 4, 3],
  ///                     );
  ///                   },
  ///                 ).toSet(),
  ///               ),
  ///             ],
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  /// ```
  final List<double> dashArray;

  /// Color of the polyline.
  ///
  /// ```dart
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  List<MapLatLng> _polyLines;
  ///  MapShapeSource _mapSource;
  ///
  ///   @override
  ///   void initState() {
  ///     _polyLines = <MapLatLng>[
  ///       MapLatLng(13.0827, 80.2707),
  ///       MapLatLng(14.4673, 78.8242),
  ///       MapLatLng(14.9091, 78.0092),
  ///       MapLatLng(16.2160, 77.3566),
  ///       MapLatLng(17.1557, 76.8697),
  ///       MapLatLng(18.0975, 75.4249),
  ///       MapLatLng(18.5204, 73.8567),
  ///       MapLatLng(19.0760, 72.8777),
  ///     ];
  ///
  ///     _mapSource = MapShapeSource.asset(
  ///       'assets/india.json',
  ///       shapeDataField: 'name',
  ///     );
  ///
  ///     _zoomPanBehavior = MapZoomPanBehavior(
  ///         zoomLevel: 3, focalLatLng: MapLatLng(15.3173, 76.7139));
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       appBar: AppBar(title: Text('Polyline')),
  ///       body: SfMaps(
  ///         layers: [
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             sublayers: [
  ///               MapPolylineLayer(
  ///                 polylines: List<MapPolyline>.generate(
  ///                   1,
  ///                   (int index) {
  ///                     return MapPolyline(
  ///                       points: _polyLines,
  ///                       color: Colors.blue,
  ///                     );
  ///                   },
  ///                 ).toSet(),
  ///               ),
  ///             ],
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  /// ```
  final Color? color;

  /// Width of the polyline.
  ///
  /// ```dart
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  List<MapLatLng> _polyLines;
  ///  MapShapeSource _mapSource;
  ///
  ///   @override
  ///   void initState() {
  ///     _polyLines = <MapLatLng>[
  ///       MapLatLng(13.0827, 80.2707),
  ///       MapLatLng(14.4673, 78.8242),
  ///       MapLatLng(14.9091, 78.0092),
  ///       MapLatLng(16.2160, 77.3566),
  ///       MapLatLng(17.1557, 76.8697),
  ///       MapLatLng(18.0975, 75.4249),
  ///       MapLatLng(18.5204, 73.8567),
  ///       MapLatLng(19.0760, 72.8777),
  ///     ];
  ///
  ///     _mapSource = MapShapeSource.asset(
  ///       'assets/india.json',
  ///       shapeDataField: 'name',
  ///     );
  ///
  ///     _zoomPanBehavior = MapZoomPanBehavior(
  ///         zoomLevel: 3, focalLatLng: MapLatLng(15.3173, 76.7139));
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       appBar: AppBar(title: Text('Polyline')),
  ///       body: SfMaps(
  ///         layers: [
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             sublayers: [
  ///               MapPolylineLayer(
  ///                 polylines: List<MapPolyline>.generate(
  ///                   1,
  ///                   (int index) {
  ///                     return MapPolyline(
  ///                       points: _polyLines,
  ///                       width: 4,
  ///                     );
  ///                   },
  ///                 ).toSet(),
  ///               ),
  ///             ],
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  /// ```
  final double? width;

  /// Callback to receive tap event for this polyline.
  ///
  /// You can customize the appearance of the tapped polyline based on the
  /// index passed in it as shown in the below code snippet.
  ///
  /// ```dart
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  List<MapLatLng> _polyLines;
  ///  MapShapeSource _mapSource;
  ///  int _selectedIndex;
  ///
  ///   @override
  ///   void initState() {
  ///     _polyLines = <MapLatLng>[
  ///       MapLatLng(13.0827, 80.2707),
  ///       MapLatLng(14.4673, 78.8242),
  ///       MapLatLng(14.9091, 78.0092),
  ///       MapLatLng(16.2160, 77.3566),
  ///       MapLatLng(17.1557, 76.8697),
  ///       MapLatLng(18.0975, 75.4249),
  ///       MapLatLng(18.5204, 73.8567),
  ///       MapLatLng(19.0760, 72.8777),
  ///     ];
  ///
  ///     _mapSource = MapShapeSource.asset(
  ///       'assets/india.json',
  ///       shapeDataField: 'name',
  ///     );
  ///
  ///     _zoomPanBehavior = MapZoomPanBehavior(
  ///         zoomLevel: 3, focalLatLng: MapLatLng(15.3173, 76.7139));
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       appBar: AppBar(title: Text('Polyline')),
  ///       body: SfMaps(
  ///         layers: [
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             sublayers: [
  ///               MapPolylineLayer(
  ///                 polylines: List<MapPolyline>.generate(
  ///                   1,
  ///                   (int index) {
  ///                     return MapPolyline(
  ///                       points: _polyLines,
  ///                       color: _selectedIndex == index
  ///                         ? Colors.blue
  ///                         : Colors.red,
  ///                       onTap: () {
  ///                         setState(() {
  ///                          _selectedIndex = index;
  ///                         });
  ///                       },
  ///                     );
  ///                   },
  ///                 ).toSet(),
  ///               ),
  ///             ],
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  /// ```
  final VoidCallback? onTap;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<List<MapLatLng>>('points', points));
    properties.add((DiagnosticsProperty<List<double>>('dashArray', dashArray)));
    if (color != null) {
      properties.add(ColorProperty('color', color));
    }

    if (width != null) {
      properties.add(DoubleProperty('width', width));
    }

    properties.add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
  }
}

/// Creates a closed path which connects multiple geographical coordinates
/// through group of [MapPolygon.points].
///
/// ```dart
///  MapZoomPanBehavior _zoomPanBehavior;
///  List<MapLatLng> _polygon;
///  MapShapeSource _mapSource;
///
///  @override
///  void initState() {
///    _polygon = <MapLatLng>[
///      MapLatLng(38.8026, -116.4194),
///      MapLatLng(46.8797, -110.3626),
///      MapLatLng(41.8780, -93.0977),
///    ];
///
///    _mapSource = MapShapeSource.asset(
///      'assets/usa.json',
///      shapeDataField: 'name',
///    );
///
///    _zoomPanBehavior = MapZoomPanBehavior();
///    super.initState();
///  }
///
///  @override
///  Widget build(BuildContext context) {
///    return Scaffold(
///      appBar: AppBar(title: Text('Polygon shape')),
///      body: SfMaps(layers: [
///        MapShapeLayer(
///          source: _mapSource,
///          sublayers: [
///            MapPolygonLayer(
///              polygons: List<MapPolygon>.generate(
///                1,
///                (int index) {
///                  return MapPolygon(
///                    points: _polygon,
///                  );
///                },
///              ).toSet(),
///            ),
///          ],
///          zoomPanBehavior: _zoomPanBehavior,
///        ),
///      ]),
///    );
///  }
/// ```
class MapPolygon extends DiagnosticableTree {
  /// Creates a [MapPolygon].
  const MapPolygon({
    required this.points,
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
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  List<MapLatLng> _polygon;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _polygon = <MapLatLng>[
  ///      MapLatLng(38.8026, -116.4194),
  ///      MapLatLng(46.8797, -110.3626),
  ///      MapLatLng(41.8780, -93.0977),
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/usa.json',
  ///      shapeDataField: 'name',
  ///    );
  ///
  ///    _zoomPanBehavior = MapZoomPanBehavior();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(title: Text('Polygon shape')),
  ///      body: SfMaps(layers: [
  ///        MapShapeLayer(
  ///          source: _mapSource,
  ///          sublayers: [
  ///            MapPolygonLayer(
  ///              polygons: List<MapPolygon>.generate(
  ///                1,
  ///                (int index) {
  ///                  return MapPolygon(
  ///                    points: _polygon,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///          zoomPanBehavior: _zoomPanBehavior,
  ///        ),
  ///      ]),
  ///    );
  ///  }
  /// ```
  final List<MapLatLng> points;

  /// Specifies the fill color of the polygon.
  ///
  /// ```dart
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  List<MapLatLng> _polygon;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _polygon = <MapLatLng>[
  ///      MapLatLng(38.8026, -116.4194),
  ///      MapLatLng(46.8797, -110.3626),
  ///      MapLatLng(41.8780, -93.0977),
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/usa.json',
  ///      shapeDataField: 'name',
  ///    );
  ///
  ///    _zoomPanBehavior = MapZoomPanBehavior();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(title: Text('Polygon shape')),
  ///      body: SfMaps(layers: [
  ///        MapShapeLayer(
  ///          source: _mapSource,
  ///          sublayers: [
  ///            MapPolygonLayer(
  ///              polygons: List<MapPolygon>.generate(
  ///                1,
  ///                (int index) {
  ///                  return MapPolygon(
  ///                    points: _polygon,
  ///                    color: Colors.blue,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///          zoomPanBehavior: _zoomPanBehavior,
  ///        ),
  ///      ]),
  ///    );
  ///  }
  /// ```
  final Color? color;

  /// Specifies the stroke color of the polygon.
  ///
  /// ```dart
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  List<MapLatLng> _polygon;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _polygon = <MapLatLng>[
  ///      MapLatLng(38.8026, -116.4194),
  ///      MapLatLng(46.8797, -110.3626),
  ///      MapLatLng(41.8780, -93.0977),
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/usa.json',
  ///      shapeDataField: 'name',
  ///    );
  ///
  ///    _zoomPanBehavior = MapZoomPanBehavior();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(title: Text('Polygon shape')),
  ///      body: SfMaps(layers: [
  ///        MapShapeLayer(
  ///          source: _mapSource,
  ///          sublayers: [
  ///            MapPolygonLayer(
  ///              polygons: List<MapPolygon>.generate(
  ///                1,
  ///                (int index) {
  ///                  return MapPolygon(
  ///                    points: _polygon,
  ///                    strokeColor: Colors.red,
  ///                    strokeWidth: 4.0
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///          zoomPanBehavior: _zoomPanBehavior,
  ///        ),
  ///      ]),
  ///    );
  ///  }
  /// ```
  final Color? strokeColor;

  /// Specifies the stroke width of the polygon.
  ///
  /// ```dart
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  List<MapLatLng> _polygon;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _polygon = <MapLatLng>[
  ///      MapLatLng(38.8026, -116.4194),
  ///      MapLatLng(46.8797, -110.3626),
  ///      MapLatLng(41.8780, -93.0977),
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/usa.json',
  ///      shapeDataField: 'name',
  ///    );
  ///
  ///    _zoomPanBehavior = MapZoomPanBehavior();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(title: Text('Polygon shape')),
  ///      body: SfMaps(layers: [
  ///        MapShapeLayer(
  ///          source: _mapSource,
  ///          sublayers: [
  ///            MapPolygonLayer(
  ///              polygons: List<MapPolygon>.generate(
  ///                1,
  ///                (int index) {
  ///                  return MapPolygon(
  ///                    points: _polygon,
  ///                    strokeWidth: 4,
  ///                    strokeColor: Colors.red,
  ///                  );
  ///                },
  ///              ).toSet(),
  ///            ),
  ///          ],
  ///          zoomPanBehavior: _zoomPanBehavior,
  ///        ),
  ///      ]),
  ///    );
  ///  }
  /// ```
  final double? strokeWidth;

  /// Callback to receive tap event for this polygon.
  ///
  /// You can customize the appearance of the tapped polygon based on the index
  /// passed on it as shown in the below code snippet.
  ///
  /// ```dart
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  List<MapLatLng> _polygon;
  ///  MapShapeSource _mapSource;
  ///  int _selectedIndex;
  ///
  ///  @override
  ///  void initState() {
  ///    _polygon = <MapLatLng>[
  ///      MapLatLng(38.8026, -116.4194),
  ///      MapLatLng(46.8797, -110.3626),
  ///      MapLatLng(41.8780, -93.0977),
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/usa.json',
  ///      shapeDataField: 'name',
  ///    );
  ///
  ///    _zoomPanBehavior = MapZoomPanBehavior();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(title: Text('Polygon shape')),
  ///      body: SfMaps(layers: [
  ///        MapShapeLayer(
  ///          source: _mapSource,
  ///          sublayers: [
  ///            MapPolygonLayer(
  ///              polygons: List<MapPolygon>.generate(
  ///                1,
  ///                (int index) {
  ///                  return MapPolygon(
  ///                    points: _polygon,
  ///                    color: _selectedIndex == index
  ///                      ? Colors.blue
  ///                      : Colors.red,
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
  ///          zoomPanBehavior: _zoomPanBehavior,
  ///        ),
  ///      ]),
  ///    );
  ///  }
  final VoidCallback? onTap;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<List<MapLatLng>>('points', points));
    if (color != null) {
      properties.add(ColorProperty('color', color));
    }

    if (strokeColor != null) {
      properties.add(ColorProperty('strokeColor', strokeColor));
    }

    if (strokeWidth != null) {
      properties.add(DoubleProperty('strokeWidth', strokeWidth));
    }

    properties.add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
  }
}

/// Creates a circle which is drawn based on the given [center] and
/// [radius].
///
/// ```dart
///  List<MapLatLng> _circles;
///  MapShapeSource _mapSource;
///
///  @override
///  void initState() {
///    _circles = const <MapLatLng>[
///      MapLatLng(-14.235004, -51.92528),
///      MapLatLng(51.16569, 10.451526),
///      MapLatLng(-25.274398, 133.775136),
///      MapLatLng(20.593684, 78.96288),
///      MapLatLng(61.52401, 105.318756)
///    ];
///
///    _mapSource = MapShapeSource.asset(
///      'assets/world_map.json',
///      shapeDataField: 'name',
///    );
///    super.initState();
///  }
///
///  @override
///  Widget build(BuildContext context) {
///    return Scaffold(
///      body: Center(
///          child: Container(
///        height: 350,
///        child: Padding(
///          padding: EdgeInsets.only(left: 15, right: 15),
///          child: SfMaps(
///            layers: <MapLayer>[
///              MapShapeLayer(
///                source: _mapSource,
///                sublayers: [
///                  MapCircleLayer(
///                    circles: List<MapCircle>.generate(
///                      _circles.length,
///                      (int index) {
///                        return MapCircle(
///                          center: _circles[index],
///                        );
///                      },
///                    ).toSet(),
///                  ),
///                ],
///              ),
///            ],
///          ),
///        ),
///      )),
///    );
///  }
/// ```
class MapCircle extends DiagnosticableTree {
  /// Creates a [MapCircle].
  const MapCircle({
    required this.center,
    this.radius = 5,
    this.color,
    this.strokeColor,
    this.strokeWidth,
    this.onTap,
  });

  /// The center of the circle.
  ///
  /// ```dart
  ///  List<MapLatLng> _circles;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _circles = const <MapLatLng>[
  ///      MapLatLng(-14.235004, -51.92528),
  ///      MapLatLng(51.16569, 10.451526),
  ///      MapLatLng(-25.274398, 133.775136),
  ///      MapLatLng(20.593684, 78.96288),
  ///      MapLatLng(61.52401, 105.318756)
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/world_map.json',
  ///      shapeDataField: 'name',
  ///    );
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: Center(
  ///          child: Container(
  ///        height: 350,
  ///        child: Padding(
  ///          padding: EdgeInsets.only(left: 15, right: 15),
  ///          child: SfMaps(
  ///            layers: <MapLayer>[
  ///              MapShapeLayer(
  ///                source: _mapSource,
  ///                sublayers: [
  ///                  MapCircleLayer(
  ///                    circles: List<MapCircle>.generate(
  ///                      _circles.length,
  ///                      (int index) {
  ///                        return MapCircle(
  ///                          center: _circles[index],
  ///                        );
  ///                      },
  ///                    ).toSet(),
  ///                  ),
  ///                ],
  ///              ),
  ///            ],
  ///          ),
  ///        ),
  ///      )),
  ///    );
  ///  }
  /// ```
  final MapLatLng center;

  /// The radius of the circle.
  ///
  /// ```dart
  ///  List<MapLatLng> _circles;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _circles = const <MapLatLng>[
  ///      MapLatLng(-14.235004, -51.92528),
  ///      MapLatLng(51.16569, 10.451526),
  ///      MapLatLng(-25.274398, 133.775136),
  ///      MapLatLng(20.593684, 78.96288),
  ///      MapLatLng(61.52401, 105.318756)
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/world_map.json',
  ///      shapeDataField: 'name',
  ///    );
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: Center(
  ///          child: Container(
  ///        height: 350,
  ///        child: Padding(
  ///          padding: EdgeInsets.only(left: 15, right: 15),
  ///          child: SfMaps(
  ///            layers: <MapLayer>[
  ///              MapShapeLayer(
  ///                source: _mapSource,
  ///                sublayers: [
  ///                  MapCircleLayer(
  ///                    circles: List<MapCircle>.generate(
  ///                      _circles.length,
  ///                      (int index) {
  ///                        return MapCircle(
  ///                          center: _circles[index],
  ///                          radius: 20,
  ///                        );
  ///                      },
  ///                    ).toSet(),
  ///                  ),
  ///                ],
  ///              ),
  ///            ],
  ///          ),
  ///        ),
  ///      )),
  ///    );
  ///  }
  /// ```
  final double radius;

  /// The fill color of the circle.
  ///
  /// ```dart
  ///  List<MapLatLng> _circles;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _circles = const <MapLatLng>[
  ///      MapLatLng(-14.235004, -51.92528),
  ///      MapLatLng(51.16569, 10.451526),
  ///      MapLatLng(-25.274398, 133.775136),
  ///      MapLatLng(20.593684, 78.96288),
  ///      MapLatLng(61.52401, 105.318756)
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/world_map.json',
  ///      shapeDataField: 'name',
  ///    );
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: Center(
  ///          child: Container(
  ///        height: 350,
  ///        child: Padding(
  ///          padding: EdgeInsets.only(left: 15, right: 15),
  ///          child: SfMaps(
  ///            layers: <MapLayer>[
  ///              MapShapeLayer(
  ///                source: _mapSource,
  ///                sublayers: [
  ///                  MapCircleLayer(
  ///                    circles: List<MapCircle>.generate(
  ///                      _circles.length,
  ///                      (int index) {
  ///                        return MapCircle(
  ///                          center: _circles[index],
  ///                          color: Colors.blue,
  ///                        );
  ///                      },
  ///                    ).toSet(),
  ///                  ),
  ///                ],
  ///              ),
  ///            ],
  ///          ),
  ///        ),
  ///      )),
  ///    );
  ///  }
  /// ```
  final Color? color;

  /// Stroke width of the circle.
  ///
  /// ```dart
  ///  List<MapLatLng> _circles;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _circles = const <MapLatLng>[
  ///      MapLatLng(-14.235004, -51.92528),
  ///      MapLatLng(51.16569, 10.451526),
  ///      MapLatLng(-25.274398, 133.775136),
  ///      MapLatLng(20.593684, 78.96288),
  ///      MapLatLng(61.52401, 105.318756)
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/world_map.json',
  ///      shapeDataField: 'name',
  ///    );
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: Center(
  ///          child: Container(
  ///        height: 350,
  ///        child: Padding(
  ///          padding: EdgeInsets.only(left: 15, right: 15),
  ///          child: SfMaps(
  ///            layers: <MapLayer>[
  ///              MapShapeLayer(
  ///                source: _mapSource,
  ///                sublayers: [
  ///                  MapCircleLayer(
  ///                    circles: List<MapCircle>.generate(
  ///                      _circles.length,
  ///                      (int index) {
  ///                        return MapCircle(
  ///                          center: _circles[index],
  ///                          strokeWidth: 4,
  ///                          strokeColor: Colors.blue,
  ///                        );
  ///                      },
  ///                    ).toSet(),
  ///                  ),
  ///                ],
  ///              ),
  ///            ],
  ///          ),
  ///        ),
  ///      )),
  ///    );
  ///  }
  /// ```
  final double? strokeWidth;

  /// Stroke color of the circle.
  ///
  /// ```dart
  ///  List<MapLatLng> _circles;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _circles = const <MapLatLng>[
  ///      MapLatLng(-14.235004, -51.92528),
  ///      MapLatLng(51.16569, 10.451526),
  ///      MapLatLng(-25.274398, 133.775136),
  ///      MapLatLng(20.593684, 78.96288),
  ///      MapLatLng(61.52401, 105.318756)
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/world_map.json',
  ///      shapeDataField: 'name',
  ///    );
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: Center(
  ///          child: Container(
  ///        height: 350,
  ///        child: Padding(
  ///          padding: EdgeInsets.only(left: 15, right: 15),
  ///          child: SfMaps(
  ///            layers: <MapLayer>[
  ///              MapShapeLayer(
  ///                source: _mapSource,
  ///                sublayers: [
  ///                  MapCircleLayer(
  ///                    circles: List<MapCircle>.generate(
  ///                      _circles.length,
  ///                      (int index) {
  ///                        return MapCircle(
  ///                          center: _circles[index],
  ///                          strokeWidth: 4,
  ///                          strokeColor: Colors.blue,
  ///                        );
  ///                      },
  ///                    ).toSet(),
  ///                  ),
  ///                ],
  ///              ),
  ///            ],
  ///          ),
  ///        ),
  ///      )),
  ///    );
  ///  }
  /// ```
  final Color? strokeColor;

  /// Callback to receive tap event for this circle.
  ///
  /// You can customize the appearance of the tapped circle based on the index
  /// passed on it as shown in the below code snippet.
  ///
  /// ```dart
  ///  List<MapLatLng> _circles;
  ///  MapShapeSource _mapSource;
  ///  int _selectedIndex;
  ///
  ///  @override
  ///  void initState() {
  ///    _circles = const <MapLatLng>[
  ///      MapLatLng(-14.235004, -51.92528),
  ///      MapLatLng(51.16569, 10.451526),
  ///      MapLatLng(-25.274398, 133.775136),
  ///      MapLatLng(20.593684, 78.96288),
  ///      MapLatLng(61.52401, 105.318756)
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/world_map.json',
  ///      shapeDataField: 'name',
  ///    );
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: Center(
  ///          child: Container(
  ///        height: 350,
  ///        child: Padding(
  ///          padding: EdgeInsets.only(left: 15, right: 15),
  ///          child: SfMaps(
  ///            layers: <MapLayer>[
  ///              MapShapeLayer(
  ///                source: _mapSource,
  ///                sublayers: [
  ///                  MapCircleLayer(
  ///                    circles: List<MapCircle>.generate(
  ///                      _circles.length,
  ///                      (int index) {
  ///                        return MapCircle(
  ///                          center: _circles[index],
  ///                          color: _selectedIndex == index
  ///                            ? Colors.blue
  ///                            : Colors.red,
  ///                          onTap: () {
  ///                            setState(() {
  ///                             _selectedIndex = index;
  ///                          });
  ///                        });
  ///                      },
  ///                    ).toSet(),
  ///                  ),
  ///                ],
  ///              ),
  ///            ],
  ///          ),
  ///        ),
  ///      )),
  ///    );
  ///  }
  /// ```
  final VoidCallback? onTap;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MapLatLng>('center', center));
    properties.add(DoubleProperty('radius', radius));
    if (color != null) {
      properties.add(ColorProperty('color', color));
    }

    if (strokeColor != null) {
      properties.add(ColorProperty('strokeColor', strokeColor));
    }

    if (strokeWidth != null) {
      properties.add(DoubleProperty('strokeWidth', strokeWidth));
    }

    properties.add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
  }
}

/// Creates an arc by connecting the two geographical coordinates.
///
/// ```dart
///  List<Model> _arcs;
///  MapZoomPanBehavior _zoomPanBehavior;
///  MapShapeSource _mapSource;
///
///  @override
///  void initState() {
///    _zoomPanBehavior = MapZoomPanBehavior(
///      focalLatLng: MapLatLng(40.7128, -95.3698),
///      zoomLevel: 3,
///    );
///
///   _mapSource = MapShapeSource.asset(
///      "assets/world_map.json",
///      shapeDataField: "continent",
///    );
///
///   _arcs = <Model>[
///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
///    ];
///  super.initState();
///  }
///
///  @override
///  Widget build(BuildContext context) {
///    return Scaffold(
///      body: SfMaps(
///        layers: [
///          MapShapeLayer(
///            source: _mapSource,
///            zoomPanBehavior: _zoomPanBehavior,
///            sublayers: [
///              MapArcLayer(
///                arcs: List<MapArc>.generate(
///                  _arcs.length,
///                  (int index) {
///                    return MapArc(
///                      from: _arcs[index].from,
///                      to: _arcs[index].to,
///                    );
///                  },
///                ).toSet(),
///              ),
///            ],
///          ),
///        ],
///      ),
///    );
///  }
///
/// class Model {
///   Model(this.from, this.to);
///
///   MapLatLng from;
///   MapLatLng to;
/// }
/// ```
class MapArc extends DiagnosticableTree {
  /// Creates a [MapArc].
  const MapArc({
    required this.from,
    required this.to,
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
  ///  List<Model> _arcs;
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _zoomPanBehavior = MapZoomPanBehavior(
  ///      focalLatLng: MapLatLng(40.7128, -95.3698),
  ///      zoomLevel: 3,
  ///    );
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "continent",
  ///    );
  ///
  ///   _arcs = <Model>[
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
  ///    ];
  ///  super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///            source: _mapSource,
  ///            zoomPanBehavior: _zoomPanBehavior,
  ///            sublayers: [
  ///              MapArcLayer(
  ///                arcs: List<MapArc>.generate(
  ///                  _arcs.length,
  ///                  (int index) {
  ///                    return MapArc(
  ///                      from: _arcs[index].from,
  ///                      to: _arcs[index].to,
  ///                    );
  ///                  },
  ///                ).toSet(),
  ///              ),
  ///            ],
  ///          ),
  ///        ],
  ///      ),
  ///    );
  ///  }
  ///
  /// class Model {
  ///   Model(this.from, this.to);
  ///
  ///   MapLatLng from;
  ///   MapLatLng to;
  /// }
  ///```
  final MapLatLng from;

  /// Represents the end coordinate of an arc.
  ///
  /// ```dart
  ///  List<Model> _arcs;
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _zoomPanBehavior = MapZoomPanBehavior(
  ///      focalLatLng: MapLatLng(40.7128, -95.3698),
  ///      zoomLevel: 3,
  ///    );
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "continent",
  ///    );
  ///
  ///   _arcs = <Model>[
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
  ///    ];
  ///  super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///            source: _mapSource,
  ///            zoomPanBehavior: _zoomPanBehavior,
  ///            sublayers: [
  ///              MapArcLayer(
  ///                arcs: List<MapArc>.generate(
  ///                  _arcs.length,
  ///                  (int index) {
  ///                    return MapArc(
  ///                      from: _arcs[index].from,
  ///                      to: _arcs[index].to,
  ///                    );
  ///                  },
  ///                ).toSet(),
  ///              ),
  ///            ],
  ///          ),
  ///        ],
  ///      ),
  ///    );
  ///  }
  ///
  /// class Model {
  ///   Model(this.from, this.to);
  ///
  ///   MapLatLng from;
  ///   MapLatLng to;
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
  ///  List<Model> _arcs;
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _zoomPanBehavior = MapZoomPanBehavior(
  ///      focalLatLng: MapLatLng(40.7128, -95.3698),
  ///      zoomLevel: 3,
  ///    );
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "continent",
  ///    );
  ///
  ///   _arcs = <Model>[
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
  ///    ];
  ///  super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///            source: _mapSource,
  ///            zoomPanBehavior: _zoomPanBehavior,
  ///            sublayers: [
  ///              MapArcLayer(
  ///                arcs: List<MapArc>.generate(
  ///                  _arcs.length,
  ///                  (int index) {
  ///                    return MapArc(
  ///                      from: _arcs[index].from,
  ///                      to: _arcs[index].to,
  ///                      heightFactor: 0.6,
  ///                    );
  ///                  },
  ///                ).toSet(),
  ///              ),
  ///            ],
  ///          ),
  ///        ],
  ///      ),
  ///    );
  ///  }
  ///
  /// class Model {
  ///   Model(this.from, this.to);
  ///
  ///   MapLatLng from;
  ///   MapLatLng to;
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
  ///  List<Model> _arcs;
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _zoomPanBehavior = MapZoomPanBehavior(
  ///      focalLatLng: MapLatLng(40.7128, -95.3698),
  ///      zoomLevel: 3,
  ///    );
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "continent",
  ///    );
  ///
  ///   _arcs = <Model>[
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
  ///    ];
  ///  super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///            source: _mapSource,
  ///            zoomPanBehavior: _zoomPanBehavior,
  ///            sublayers: [
  ///              MapArcLayer(
  ///                arcs: List<MapArc>.generate(
  ///                  _arcs.length,
  ///                  (int index) {
  ///                    return MapArc(
  ///                      from: _arcs[index].from,
  ///                      to: _arcs[index].to,
  ///                      controlPointFactor: 0.4,
  ///                    );
  ///                  },
  ///                ).toSet(),
  ///              ),
  ///            ],
  ///          ),
  ///        ],
  ///      ),
  ///    );
  ///  }
  ///
  /// class Model {
  ///   Model(this.from, this.to);
  ///
  ///   MapLatLng from;
  ///   MapLatLng to;
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
  ///  List<Model> _arcs;
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _zoomPanBehavior = MapZoomPanBehavior(
  ///      focalLatLng: MapLatLng(40.7128, -95.3698),
  ///      zoomLevel: 3,
  ///    );
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "continent",
  ///    );
  ///
  ///   _arcs = <Model>[
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
  ///    ];
  ///  super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///            source: _mapSource,
  ///            zoomPanBehavior: _zoomPanBehavior,
  ///            sublayers: [
  ///              MapArcLayer(
  ///                arcs: List<MapArc>.generate(
  ///                  _arcs.length,
  ///                  (int index) {
  ///                    return MapArc(
  ///                      from: _arcs[index].from,
  ///                      to: _arcs[index].to,
  ///                      dashArray: [8, 3, 4, 3],
  ///                    );
  ///                  },
  ///                ).toSet(),
  ///              ),
  ///            ],
  ///          ),
  ///        ],
  ///      ),
  ///    );
  ///  }
  ///
  /// class Model {
  ///   Model(this.from, this.to);
  ///
  ///   MapLatLng from;
  ///   MapLatLng to;
  /// }
  ///```
  final List<double> dashArray;

  /// Color of the arc.
  ///
  /// ```dart
  ///  List<Model> _arcs;
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _zoomPanBehavior = MapZoomPanBehavior(
  ///      focalLatLng: MapLatLng(40.7128, -95.3698),
  ///      zoomLevel: 3,
  ///    );
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "continent",
  ///    );
  ///
  ///   _arcs = <Model>[
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
  ///    ];
  ///  super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///            source: _mapSource,
  ///            zoomPanBehavior: _zoomPanBehavior,
  ///            sublayers: [
  ///              MapArcLayer(
  ///                arcs: List<MapArc>.generate(
  ///                  _arcs.length,
  ///                  (int index) {
  ///                    return MapArc(
  ///                      from: _arcs[index].from,
  ///                      to: _arcs[index].to,
  ///                      color: Colors.blue,
  ///                    );
  ///                  },
  ///                ).toSet(),
  ///              ),
  ///            ],
  ///          ),
  ///        ],
  ///      ),
  ///    );
  ///  }
  ///
  /// class Model {
  ///   Model(this.from, this.to);
  ///
  ///   MapLatLng from;
  ///   MapLatLng to;
  /// }
  ///```
  final Color? color;

  /// Width of the arc.
  ///
  /// ```dart
  ///  List<Model> _arcs;
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _zoomPanBehavior = MapZoomPanBehavior(
  ///      focalLatLng: MapLatLng(40.7128, -95.3698),
  ///      zoomLevel: 3,
  ///    );
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "continent",
  ///    );
  ///
  ///   _arcs = <Model>[
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
  ///    ];
  ///  super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///            source: _mapSource,
  ///            zoomPanBehavior: _zoomPanBehavior,
  ///            sublayers: [
  ///              MapArcLayer(
  ///                arcs: List<MapArc>.generate(
  ///                  _arcs.length,
  ///                  (int index) {
  ///                    return MapArc(
  ///                      from: _arcs[index].from,
  ///                      to: _arcs[index].to,
  ///                       width: 4,
  ///                    );
  ///                  },
  ///                ).toSet(),
  ///              ),
  ///            ],
  ///          ),
  ///        ],
  ///      ),
  ///    );
  ///  }
  ///
  /// class Model {
  ///   Model(this.from, this.to);
  ///
  ///   MapLatLng from;
  ///   MapLatLng to;
  /// }
  ///```
  final double? width;

  /// Callback to receive tap event for this arc.
  ///
  /// You can customize the appearance of the tapped arc based on the index
  /// passed on it as shown in the below code snippet.
  ///
  /// ```dart
  ///  List<Model> _arcs;
  ///  MapZoomPanBehavior _zoomPanBehavior;
  ///  MapShapeSource _mapSource;
  ///  int _selectedIndex;
  ///
  ///  @override
  ///  void initState() {
  ///    _zoomPanBehavior = MapZoomPanBehavior(
  ///      focalLatLng: MapLatLng(40.7128, -95.3698),
  ///      zoomLevel: 3,
  ///    );
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "continent",
  ///    );
  ///
  ///   _arcs = <Model>[
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(44.9778, -93.2650)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(33.4484, -112.0740)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(29.7604, -95.3698)),
  ///      Model(MapLatLng(40.7128, -74.0060), MapLatLng(39.7392, -104.9903)),
  ///    ];
  ///  super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///            source: _mapSource,
  ///            zoomPanBehavior: _zoomPanBehavior,
  ///            sublayers: [
  ///              MapArcLayer(
  ///                arcs: List<MapArc>.generate(
  ///                  _arcs.length,
  ///                  (int index) {
  ///                    return MapArc(
  ///                      from: _arcs[index].from,
  ///                      to: _arcs[index].to,
  ///                      color: _selectedIndex == index
  ///                         ? Colors.blue
  ///                         : Colors.red,
  ///                      onTap: () {
  ///                         setState(() {
  ///                          _selectedIndex = index;
  ///                         });
  ///                      },
  ///                    );
  ///                  },
  ///                ).toSet(),
  ///              ),
  ///            ],
  ///          ),
  ///        ],
  ///      ),
  ///    );
  ///  }
  ///
  /// class Model {
  ///   Model(this.from, this.to);
  ///
  ///   MapLatLng from;
  ///   MapLatLng to;
  /// }
  ///```
  final VoidCallback? onTap;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MapLatLng>('from', from));
    properties.add(DiagnosticsProperty<MapLatLng>('to', to));
    properties.add(DoubleProperty('heightFactor', heightFactor));
    properties.add(DoubleProperty('controlPointFactor', controlPointFactor));
    properties.add((DiagnosticsProperty<List<double>>('dashArray', dashArray)));
    if (color != null) {
      properties.add(ColorProperty('color', color));
    }

    if (width != null) {
      properties.add(DoubleProperty('width', width));
    }

    properties.add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
  }
}

// To calculate dash array path for series
Path? _dashPath(
  Path? source, {
  required _IntervalList<double> dashArray,
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
        )!,
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

class _DebugVectorShapeTree extends DiagnosticableTree {
  _DebugVectorShapeTree(this.vectorShapes);

  final Set<Object> vectorShapes;

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    if (vectorShapes.isNotEmpty) {
      return vectorShapes.map<DiagnosticsNode>((Object vectorShape) {
        if (vectorShape is MapLine) {
          return vectorShape.toDiagnosticsNode();
        } else if (vectorShape is MapArc) {
          return vectorShape.toDiagnosticsNode();
        } else if (vectorShape is MapCircle) {
          return vectorShape.toDiagnosticsNode();
        } else if (vectorShape is MapPolyline) {
          return vectorShape.toDiagnosticsNode();
        } else {
          // ignore: avoid_as
          final MapPolygon polygonShape = vectorShape as MapPolygon;
          return polygonShape.toDiagnosticsNode();
        }
      }).toList();
    }
    return super.debugDescribeChildren();
  }

  @override
  String toStringShort() {
    if (vectorShapes is Set<MapLine>) {
      return vectorShapes.length > 1
          ? 'contains ${vectorShapes.length} lines'
          : 'contains ${vectorShapes.length} line';
    } else if (vectorShapes is Set<MapCircle>) {
      return vectorShapes.length > 1
          ? 'contains ${vectorShapes.length} circles'
          : 'contains ${vectorShapes.length} circle';
    } else if (vectorShapes is Set<MapArc>) {
      return vectorShapes.length > 1
          ? 'contains ${vectorShapes.length} arcs'
          : 'contains ${vectorShapes.length} arc';
    } else if (vectorShapes is Set<MapPolyline>) {
      return vectorShapes.length > 1
          ? 'contains ${vectorShapes.length} polylines'
          : 'contains ${vectorShapes.length} polyline';
    } else {
      return vectorShapes.length > 1
          ? 'contains ${vectorShapes.length} polygons'
          : 'contains ${vectorShapes.length} polygon';
    }
  }
}
