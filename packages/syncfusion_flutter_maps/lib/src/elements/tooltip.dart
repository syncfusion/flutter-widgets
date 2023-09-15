import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../maps.dart';

import '../common.dart';
import '../controller/map_controller.dart';
import '../utils.dart';

// ignore_for_file: public_member_api_docs
class MapTooltip extends StatefulWidget {
  const MapTooltip({
    Key? key,
    this.mapSource,
    required this.sublayers,
    this.shapeTooltipBuilder,
    this.bubbleTooltipBuilder,
    required this.markerTooltipBuilder,
    required this.tooltipSettings,
    required this.themeData,
    required this.controller,
  }) : super(key: key);

  final MapShapeSource? mapSource;
  final List<MapSublayer>? sublayers;
  final IndexedWidgetBuilder? shapeTooltipBuilder;
  final IndexedWidgetBuilder? bubbleTooltipBuilder;
  final IndexedWidgetBuilder? markerTooltipBuilder;
  final MapTooltipSettings tooltipSettings;
  final SfMapsThemeData themeData;
  final MapController? controller;

  @override
  State<MapTooltip> createState() => _MapTooltipState();
}

class _MapTooltipState extends State<MapTooltip>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late bool isDesktop;

  Widget? _child;

  void adoptChild(int index, MapLayerElement element, {int? sublayerIndex}) {
    late Widget? current;
    switch (element) {
      case MapLayerElement.shape:
        setState(() {
          if (sublayerIndex != null) {
            final MapShapeSublayer sublayer =
                // ignore: avoid_as
                widget.sublayers![sublayerIndex] as MapShapeSublayer;
            current = sublayer.shapeTooltipBuilder?.call(context, index);
          } else {
            current = widget.shapeTooltipBuilder?.call(context, index);
          }

          _child = IgnorePointer(child: current);
        });
        break;
      case MapLayerElement.bubble:
        setState(() {
          if (sublayerIndex != null) {
            final MapShapeSublayer sublayer =
                // ignore: avoid_as
                widget.sublayers![sublayerIndex] as MapShapeSublayer;
            current = sublayer.bubbleTooltipBuilder?.call(context, index);
          } else {
            current = widget.bubbleTooltipBuilder?.call(context, index);
          }

          _child = IgnorePointer(child: current);
        });
        break;
      case MapLayerElement.marker:
        setState(() {
          if (sublayerIndex != null) {
            final MapShapeSublayer sublayer =
                // ignore: avoid_as
                widget.sublayers![sublayerIndex] as MapShapeSublayer;
            current = sublayer.markerTooltipBuilder?.call(context, index);
          } else {
            current = widget.markerTooltipBuilder?.call(context, index);
          }

          _child = IgnorePointer(child: current);
        });
        break;
      case MapLayerElement.vector:
        setState(() {
          if (sublayerIndex != null) {
            final MapSublayer sublayer =
                // ignore: avoid_as
                widget.sublayers![sublayerIndex];
            current = sublayer.tooltipBuilder?.call(context, index);
          }

          _child = IgnorePointer(child: current);
        });
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;
    return _MapTooltipRenderObjectWidget(
      source: widget.mapSource,
      tooltipSettings: widget.tooltipSettings,
      themeData: widget.themeData,
      state: this,
      child: _child,
    );
  }
}

/// A Render object widget which draws tooltip shape.
class _MapTooltipRenderObjectWidget extends SingleChildRenderObjectWidget {
  const _MapTooltipRenderObjectWidget({
    required this.source,
    required this.tooltipSettings,
    required this.themeData,
    required this.state,
    Widget? child,
  }) : super(child: child);

  final MapShapeSource? source;
  final MapTooltipSettings tooltipSettings;
  final SfMapsThemeData themeData;
  final _MapTooltipState state;

  @override
  _RenderMapTooltip createRenderObject(BuildContext context) {
    return _RenderMapTooltip(
      source: source,
      tooltipSettings: tooltipSettings,
      themeData: themeData,
      mediaQueryData: MediaQuery.of(context),
      context: context,
      state: state,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderMapTooltip renderObject) {
    renderObject
      ..source = source
      ..tooltipSettings = tooltipSettings
      ..themeData = themeData
      ..mediaQueryData = MediaQuery.of(context)
      ..context = context;
  }
}

class _RenderMapTooltip extends ShapeLayerChildRenderBoxBase {
  _RenderMapTooltip({
    required MapShapeSource? source,
    required MapTooltipSettings tooltipSettings,
    required SfMapsThemeData themeData,
    required MediaQueryData mediaQueryData,
    required this.context,
    required _MapTooltipState state,
  })  : _source = source,
        _tooltipSettings = tooltipSettings,
        _themeData = themeData,
        _mediaQueryData = mediaQueryData,
        _state = state {
    _scaleAnimation =
        CurvedAnimation(parent: _state.controller, curve: Curves.easeOutBack);
  }

  static const double tooltipTriangleHeight = 7;
  final _MapTooltipState _state;
  final _TooltipShape _tooltipShape = const _TooltipShape();
  final Duration _hideDeferDuration = const Duration(milliseconds: 500);
  late Animation<double> _scaleAnimation;
  Timer? _showTimer;
  Timer? _hideDeferTimer;
  Offset? _currentPosition;
  MapLayerElement? _previousElement;
  int? _previousSublayerIndex;
  int? _previousElementIndex;
  Rect? _elementRect;
  PointerKind? _pointerKind;
  bool _preferTooltipOnTop = true;
  bool _shouldCalculateTooltipPosition = false;

  BuildContext context;

  MapTooltipSettings get tooltipSettings => _tooltipSettings;
  MapTooltipSettings _tooltipSettings;
  set tooltipSettings(MapTooltipSettings value) {
    if (_tooltipSettings == value) {
      return;
    }
    _tooltipSettings = value;
  }

  MapShapeSource? get source => _source;
  MapShapeSource? _source;
  set source(MapShapeSource? value) {
    if (_source == value) {
      return;
    }
    _source = value;
    hideTooltip(immediately: true);
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

  MediaQueryData get mediaQueryData => _mediaQueryData;
  MediaQueryData _mediaQueryData;
  set mediaQueryData(MediaQueryData value) {
    if (_mediaQueryData.orientation == value.orientation) {
      return;
    }
    _mediaQueryData = value;
    hideTooltip(immediately: true);
  }

  void _update(Offset? position, int? index, MapLayerElement? element,
      int? sublayerIndex) {
    if (index != null) {
      _state.adoptChild(index, element!, sublayerIndex: sublayerIndex);
      _currentPosition = position;
      if (child != null && child!.attached) {
        _showTooltip();
      }
    } else if (child != null && child!.attached) {
      _hideDeferTimer?.cancel();
      _hideDeferTimer = Timer(_hideDeferDuration, hideTooltip);
    }
  }

  void _showTooltip() {
    _shouldCalculateTooltipPosition = true;
    _hideDeferTimer?.cancel();
    if (_state.isDesktop) {
      if (_state.controller.value == 0 ||
          _state.controller.status == AnimationStatus.reverse) {
        _state.controller.forward(from: 0.0);
        _startShowTimer();
        return;
      }

      _startShowTimer();
      markNeedsPaint();
    } else {
      _state.controller.forward(from: 0.0);
      _startShowTimer();
    }
  }

  void _startShowTimer() {
    if (_tooltipSettings.hideDelay == double.infinity) {
      return;
    }
    _showTimer?.cancel();
    if (_pointerKind == PointerKind.touch) {
      _showTimer = Timer(
          Duration(seconds: _tooltipSettings.hideDelay.toInt()), hideTooltip);
    }
  }

  @override
  void hideTooltip({bool immediately = false}) {
    _previousElement = null;
    _previousElementIndex = null;
    _previousSublayerIndex = null;
    _pointerKind = null;
    _showTimer?.cancel();
    immediately ? _state.controller.reset() : _state.controller.reverse();
  }

  void _updateTooltipIfNeeded(Offset? position, int? index, Rect? elementRect,
      MapLayerElement? element, int? sublayerIndex) {
    if (sublayerIndex == _previousSublayerIndex &&
        element != MapLayerElement.shape &&
        element != MapLayerElement.vector &&
        _previousElement == element) {
      if (_previousElementIndex == index) {
        if (_state.isDesktop && _pointerKind == PointerKind.hover) {
          return;
        }

        _startShowTimer();
        return;
      }
    }
    _previousSublayerIndex = sublayerIndex;
    _previousElement = element;
    _previousElementIndex = index;
    // We are storing the element rect to calculate the exact position of the
    // bubble or marker in the paint method.
    _elementRect = elementRect;
    _update(position, index, element, sublayerIndex);
  }

  void _handleZooming(MapZoomDetails details) {
    hideTooltip(immediately: true);
  }

  void _handlePanning(MapPanDetails details) {
    hideTooltip(immediately: true);
  }

  void _handleReset() {
    hideTooltip(immediately: true);
  }

  @override
  void paintTooltip(int? elementIndex, Rect? elementRect,
      MapLayerElement? element, PointerKind kind,
      [int? sublayerIndex, Offset? position]) {
    _pointerKind = kind;
    _updateTooltipIfNeeded(
        position, elementIndex, elementRect, element, sublayerIndex);
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void adoptChild(RenderObject child) {
    super.adoptChild(child);
    _showTooltip();
  }

  @override
  void dropChild(RenderObject child) {
    super.dropChild(child);
    markNeedsPaint();
  }

  @override
  void performLayout() {
    size = getBoxSize(constraints);
    child?.layout(constraints);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _scaleAnimation.addListener(markNeedsPaint);
    if (_state.widget.controller != null) {
      _state.widget.controller!
        ..addZoomPanListener(_handleReset)
        ..addRefreshListener(_handleReset)
        ..addZoomingListener(_handleZooming)
        ..addPanningListener(_handlePanning)
        ..addResetListener(_handleReset);
    }
  }

  @override
  void detach() {
    _showTimer?.cancel();
    _hideDeferTimer?.cancel();
    _scaleAnimation.removeListener(markNeedsPaint);
    if (_state.widget.controller != null) {
      _state.widget.controller!
        ..removeZoomPanListener(_handleReset)
        ..removeRefreshListener(_handleReset)
        ..removeZoomingListener(_handleZooming)
        ..removePanningListener(_handlePanning)
        ..removeResetListener(_handleReset);
    }
    super.detach();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null &&
        child!.attached &&
        (child!.size.width > 0 || child!.size.height > 0) &&
        (_currentPosition != null || _elementRect != null)) {
      // We are calculating the tooltip position in paint method because of the
      // child didn't get layouts while forwarding the animation controller.
      if (_shouldCalculateTooltipPosition) {
        _updateTooltipPositionAndDirection();
        _shouldCalculateTooltipPosition = false;
      }

      _tooltipShape.paint(
          context,
          offset,
          _currentPosition!,
          _preferTooltipOnTop,
          this,
          _scaleAnimation,
          _themeData,
          _tooltipSettings);
    }
  }

  void _updateTooltipPositionAndDirection() {
    final double tooltipHeight = child!.size.height;
    final Rect bounds = Offset.zero & size;
    // For bubble and marker.
    if (_elementRect != null) {
      // Checking tooltip element rect lies inside tooltip render box bounds.
      // If not, we are creating a new rect based on the visible area.
      if (bounds.overlaps(_elementRect!)) {
        _updateElementRect(bounds);
      }
      final double halfRectWidth = _elementRect!.width / 2;
      Offset tooltipPosition = _elementRect!.topLeft +
          Offset(halfRectWidth, _elementRect!.height * tooltipHeightFactor);
      _preferTooltipOnTop = bounds.contains(
          tooltipPosition - Offset(0.0, tooltipHeight + tooltipTriangleHeight));
      if (!_preferTooltipOnTop) {
        // To get the tooltip position at bottom based on the current rect,
        // we had subtracted 1 with the tooltipHeightFactor.
        tooltipPosition = _elementRect!.topLeft +
            Offset(halfRectWidth,
                _elementRect!.height * (1 - tooltipHeightFactor));
      }
      _currentPosition = tooltipPosition;
    }
    // For shape.
    else {
      _preferTooltipOnTop = bounds.contains(_currentPosition! -
          Offset(0.0, tooltipHeight + tooltipTriangleHeight));
    }
  }

  void _updateElementRect(Rect bounds) {
    double left = _elementRect!.left;
    double right = _elementRect!.right;
    double top = _elementRect!.top;
    double bottom = _elementRect!.bottom;
    if (_elementRect!.left < bounds.left) {
      left = bounds.left;
    }
    if (_elementRect!.right > bounds.right) {
      right = bounds.right;
    }
    if (_elementRect!.top < bounds.top) {
      top = bounds.top;
    }
    if (_elementRect!.bottom > bounds.bottom) {
      bottom = bounds.bottom;
    }

    _elementRect = Rect.fromLTRB(left, top, right, bottom);
  }
}

/// Base class for map tooltip shapes.
class _TooltipShape {
  const _TooltipShape();

  static const double marginSpace = 6.0;

  /// Paints the tooltip shapes based on the value passed to it.
  void paint(
      PaintingContext context,
      Offset offset,
      Offset center,
      bool preferTooltipOnTop,
      RenderProxyBox parentBox,
      Animation<double> tooltipAnimation,
      SfMapsThemeData themeData,
      MapTooltipSettings tooltipSettings) {
    const double tooltipTriangleWidth = 12.0;
    const double halfTooltipTriangleWidth = tooltipTriangleWidth / 2;
    const double elevation = 0.0;

    Path path = Path();
    BorderRadius borderRadius =
        themeData.tooltipBorderRadius.resolve(TextDirection.ltr);
    final double tooltipWidth = parentBox.child!.size.width;
    double tooltipHeight = parentBox.child!.size.height;
    final double halfTooltipWidth = tooltipWidth / 2;
    double halfTooltipHeight = tooltipHeight / 2;

    double triangleHeight = _RenderMapTooltip.tooltipTriangleHeight;
    final double tooltipStartPoint = triangleHeight + tooltipHeight / 2;
    double tooltipTriangleOffsetY = tooltipStartPoint - triangleHeight;

    final double endGlobal = parentBox.size.width - marginSpace;
    double rightLineWidth = center.dx + halfTooltipWidth > endGlobal
        ? endGlobal - center.dx
        : halfTooltipWidth;
    final double leftLineWidth = center.dx - halfTooltipWidth < marginSpace
        ? center.dx - marginSpace
        : tooltipWidth - rightLineWidth;
    rightLineWidth = leftLineWidth < halfTooltipWidth
        ? halfTooltipWidth - leftLineWidth + rightLineWidth
        : rightLineWidth;

    double moveNosePoint = leftLineWidth < tooltipWidth * 0.2
        ? tooltipWidth * 0.2 - leftLineWidth
        : 0.0;
    moveNosePoint = rightLineWidth < tooltipWidth * 0.2
        ? -(tooltipWidth * 0.2 - rightLineWidth)
        : moveNosePoint;

    double shiftText = leftLineWidth > rightLineWidth
        ? -(halfTooltipWidth - rightLineWidth)
        : 0.0;
    shiftText = leftLineWidth < rightLineWidth
        ? (halfTooltipWidth - leftLineWidth)
        : shiftText;

    rightLineWidth = rightLineWidth + elevation;
    if (!preferTooltipOnTop) {
      // We had multiplied -1 with the below values to move its position from
      // top to bottom.
      //       ________
      //      |___  ___|    to     ___/\___
      //          \/              |________|
      triangleHeight *= -1;
      halfTooltipHeight *= -1;
      tooltipTriangleOffsetY *= -1;
      tooltipHeight *= -1;
      borderRadius = BorderRadius.only(
        topRight: Radius.elliptical(
            borderRadius.bottomRight.x, -borderRadius.bottomRight.y),
        bottomRight: Radius.elliptical(
            borderRadius.topRight.x, -borderRadius.topRight.y),
        topLeft: Radius.elliptical(
            borderRadius.bottomLeft.x, -borderRadius.bottomLeft.y),
        bottomLeft:
            Radius.elliptical(borderRadius.topLeft.x, -borderRadius.topLeft.y),
      );
    }

    path = _getTooltipPath(
        path,
        triangleHeight,
        halfTooltipHeight,
        halfTooltipTriangleWidth,
        tooltipTriangleOffsetY,
        moveNosePoint,
        rightLineWidth,
        leftLineWidth,
        borderRadius,
        tooltipHeight);

    context.canvas.save();
    context.canvas
        .translate(center.dx, center.dy - triangleHeight - halfTooltipHeight);
    context.canvas.scale(tooltipAnimation.value);
    // In web HTML rendering, fill color clipped half of its tooltip's size.
    // To avoid this issue we are drawing stroke before fill.
    final Color? strokeColor =
        tooltipSettings.strokeColor ?? themeData.tooltipStrokeColor;
    final Paint paint = Paint()
      ..color = strokeColor ?? Colors.transparent
      // We are drawing stroke before fill to avoid tooltip rendering issue
      // in a web HTML rendering. Due to this, half of the stroke width only
      // visible to us so that we are twice the stroke width.
      ..strokeWidth =
          (tooltipSettings.strokeWidth ?? themeData.tooltipStrokeWidth) * 2
      ..style = PaintingStyle.stroke;
    // Drawing stroke.
    context.canvas.drawPath(path, paint);
    // Drawing fill color.
    paint
      ..style = PaintingStyle.fill
      ..color = tooltipSettings.color ?? themeData.tooltipColor!;
    context.canvas.drawPath(path, paint);

    context.canvas.clipPath(path);
    context.paintChild(parentBox.child!,
        offset - _getShiftPosition(offset, center, parentBox));
    context.canvas.restore();
  }

  Path _getTooltipPath(
      Path path,
      double tooltipTriangleHeight,
      double halfTooltipHeight,
      double halfTooltipTriangleWidth,
      double tooltipTriangleOffsetY,
      double moveNosePoint,
      double rightLineWidth,
      double leftLineWidth,
      BorderRadius borderRadius,
      double tooltipHeight) {
    path.reset();

    path.moveTo(0, tooltipTriangleHeight + halfTooltipHeight);
    // preferTooltipOnTop is true,
    //        /

    // preferTooltipOnTop is false,
    //        \
    path.lineTo(
        halfTooltipTriangleWidth + moveNosePoint, tooltipTriangleOffsetY);
    // preferTooltipOnTop is true,
    //         ___
    //        /

    // preferTooltipOnTop is false,
    //        \___
    path.lineTo(
        rightLineWidth - borderRadius.bottomRight.x, tooltipTriangleOffsetY);
    // preferTooltipOnTop is true,
    //         ___|
    //        /

    // preferTooltipOnTop is false,
    //        \___
    //            |
    path.quadraticBezierTo(rightLineWidth, tooltipTriangleOffsetY,
        rightLineWidth, tooltipTriangleOffsetY - borderRadius.bottomRight.y);
    path.lineTo(rightLineWidth,
        tooltipTriangleOffsetY - tooltipHeight + borderRadius.topRight.y);
    // preferTooltipOnTop is true,
    //     _______
    //         ___|
    //        /

    // preferTooltipOnTop is false,
    //         \___
    //     ________|
    path.quadraticBezierTo(
        rightLineWidth,
        tooltipTriangleOffsetY - tooltipHeight,
        rightLineWidth - borderRadius.topRight.x,
        tooltipTriangleOffsetY - tooltipHeight);
    path.lineTo(-leftLineWidth + borderRadius.topLeft.x,
        tooltipTriangleOffsetY - tooltipHeight);
    // preferTooltipOnTop is true,
    //     _______
    //    |    ___|
    //        /

    // preferTooltipOnTop is false,
    //         \___
    //    |________|
    path.quadraticBezierTo(
        -leftLineWidth,
        tooltipTriangleOffsetY - tooltipHeight,
        -leftLineWidth,
        tooltipTriangleOffsetY - tooltipHeight + borderRadius.topLeft.y);
    path.lineTo(
        -leftLineWidth, tooltipTriangleOffsetY - borderRadius.bottomLeft.y);
    // preferTooltipOnTop is true,
    //      ________
    //     |___  ___|
    //          /

    // preferTooltipOnTop is false,
    //      ___ \___
    //     |________|
    path.quadraticBezierTo(-leftLineWidth, tooltipTriangleOffsetY,
        -leftLineWidth + borderRadius.bottomLeft.x, tooltipTriangleOffsetY);
    path.lineTo(
        -halfTooltipTriangleWidth + moveNosePoint, tooltipTriangleOffsetY);
    // preferTooltipOnTop is true,
    //       ________
    //      |___  ___|
    //          \/

    // preferTooltipOnTop is false,
    //       ___/\___
    //      |________|
    path.close();

    return path;
  }

  Offset _getShiftPosition(
      Offset offset, Offset center, RenderProxyBox parent) {
    final Size childSize = parent.child!.size;
    final double halfChildWidth = childSize.width / 2;
    final double halfChildHeight = childSize.height / 2;

    // Shifting the position of the tooltip to the left side, if its right
    // edge goes out of the map's right edge.
    if (center.dx + halfChildWidth + marginSpace > parent.size.width) {
      return Offset(
          childSize.width + center.dx - parent.size.width + marginSpace,
          halfChildHeight);
    }
    // Shifting the position of the tooltip to the right side, if its left
    // edge goes out of the map's left edge.
    else if (center.dx - halfChildWidth - marginSpace < offset.dx) {
      return Offset(center.dx - marginSpace, halfChildHeight);
    }

    return Offset(halfChildWidth, halfChildHeight);
  }
}
