import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../treemap.dart';
import 'layouts.dart';

/// The tooltip provides additional information about the treemap tiles.
class TreemapTooltip extends StatefulWidget {
  /// Creates a tooltip for treemap tiles.
  const TreemapTooltip({Key? key, required this.settings}) : super(key: key);

  /// Option to customizes the appearance of the tooltip.
  final TreemapTooltipSettings settings;

  @override
  _TreemapTooltipState createState() => _TreemapTooltipState();
}

class _TreemapTooltipState extends State<TreemapTooltip>
    with SingleTickerProviderStateMixin {
  Widget? _child;
  late bool _isDesktop;
  late AnimationController controller;

  void adoptChild(TreemapTile tile) {
    if (mounted) {
      setState(() {
        final Widget? child = tile.level.tooltipBuilder!.call(context, tile);
        _child = child != null ? IgnorePointer(child: child) : null;
      });
    }
  }

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;
    final TreemapTooltipSettings settings = widget.settings.copyWith(
        color: widget.settings.color ??
            (themeData.brightness == Brightness.light
                ? const Color.fromRGBO(117, 117, 117, 1)
                : const Color.fromRGBO(245, 245, 245, 1)));
    return _TreemapTooltipRenderObjectWidget(
        child: _child, settings: settings, state: this);
  }
}

/// A Render object widget which draws tooltip shape.
class _TreemapTooltipRenderObjectWidget extends SingleChildRenderObjectWidget {
  const _TreemapTooltipRenderObjectWidget(
      {Widget? child, required this.settings, required this.state})
      : super(child: child);

  final _TreemapTooltipState state;
  final TreemapTooltipSettings settings;

  @override
  RenderTooltip createRenderObject(BuildContext context) {
    return RenderTooltip(
      settings: settings,
      mediaQueryData: MediaQuery.of(context),
      state: state,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderTooltip renderObject) {
    renderObject
      ..settings = settings
      ..mediaQueryData = MediaQuery.of(context);
  }
}

/// Render box of [TreemapTooltip].
class RenderTooltip extends RenderProxyBox {
  /// Creates [RenderTooltip].
  RenderTooltip({
    required TreemapTooltipSettings settings,
    required MediaQueryData mediaQueryData,
    required _TreemapTooltipState state,
  })   : _settings = settings,
        _mediaQueryData = mediaQueryData,
        _state = state {
    _scaleAnimation =
        CurvedAnimation(parent: _state.controller, curve: Curves.easeOutBack);
    _textDirection = Directionality.of(_state.context);
  }

  /// Tooltip nose height.
  static const double tooltipTriangleHeight = 7.0;
  // Pixels to be moved from the top, to position the tooltip inside the tile.
  static const double _topPadding = 15.0;
  final _TreemapTooltipState _state;
  final _TooltipShape _tooltipShape = const _TooltipShape();
  final Duration _waitDuration = const Duration(seconds: 3);
  final Duration _hideDeferDuration = const Duration(milliseconds: 500);
  late Animation<double> _scaleAnimation;
  Timer? _showTimer;
  Timer? _hideDeferTimer;
  Size? _tileSize;
  Offset? _position;
  bool _preferTooltipOnTop = true;
  bool _shouldCalculateTooltipPosition = false;
  TreemapTile? _previousTile;
  late TextDirection _textDirection;
  PointerKind? _pointerKind;

  /// Customizes the appearance of the tooltip.
  TreemapTooltipSettings get settings => _settings;
  late TreemapTooltipSettings _settings;
  set settings(TreemapTooltipSettings value) {
    if (_settings == value) {
      return;
    }
    _settings = value;
  }

  /// [MediaQueryData] used to handle the orientation changes.
  MediaQueryData get mediaQueryData => _mediaQueryData;
  MediaQueryData _mediaQueryData;
  set mediaQueryData(MediaQueryData value) {
    if (_mediaQueryData.orientation == value.orientation) {
      return;
    }
    _mediaQueryData = value;
    hide(immediately: true);
  }

  /// Shows the tooltip.
  void show(Offset globalFocalPoint, TreemapTile tile, Size tileSize,
      PointerKind kind) {
    _pointerKind = kind;
    if (_state._isDesktop && _previousTile == tile) {
      return;
    }

    _shouldCalculateTooltipPosition = true;
    _state.adoptChild(tile);
    _position = globalToLocal(globalFocalPoint);
    _tileSize = tileSize;
    _hideDeferTimer?.cancel();
    if (_state._isDesktop && _pointerKind == PointerKind.hover) {
      if (_previousTile != tile) {
        _previousTile = tile;
        if (_state.controller.value > 0) {
          _state.controller.reset();
        }

        _showTimer?.cancel();
        _showTimer = Timer(const Duration(milliseconds: 100), () {
          _state.controller.forward(from: 0.0);
        });
      }
    } else {
      _state.controller.forward(from: 0.0);
      _showTimer?.cancel();
      if (_pointerKind == PointerKind.touch) {
        _showTimer = Timer(_waitDuration, hide);
      }
    }
  }

  /// Hides the tooltip.
  void hide({bool immediately = false}) {
    _previousTile = null;
    _pointerKind = null;
    _showTimer?.cancel();

    if (immediately) {
      _state.controller.reset();
      return;
    }

    if (_state._isDesktop) {
      _hideDeferTimer?.cancel();
      _hideDeferTimer = Timer(_hideDeferDuration, () {
        _state.controller.reverse();
      });
    } else {
      _state.controller.reverse();
    }
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void performLayout() {
    child?.layout(constraints);
    size = Size(constraints.maxWidth, constraints.maxHeight);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _scaleAnimation.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _showTimer?.cancel();
    _hideDeferTimer?.cancel();
    _scaleAnimation.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null && child!.attached && _position != null) {
      // We are calculating the tooltip position in paint method because of the
      // child didn't get layouts while forwarding the animation controller.
      if (_shouldCalculateTooltipPosition) {
        _updatePositionAndDirection();
        _shouldCalculateTooltipPosition = false;
      }

      _tooltipShape.paint(context, offset, _position!, _preferTooltipOnTop,
          this, _scaleAnimation, _settings, _textDirection);
    }
  }

  void _updatePositionAndDirection() {
    final double height = child!.size.height + tooltipTriangleHeight;
    // If the height of the tooltip child is exactly set within the height of
    // the tile, the UI looks like to indicate it to the bottom tile. Thus, we
    // took the tile size of only 70%.
    if ((height + _topPadding) < (_tileSize!.height * 0.7)) {
      _position =
          _position! + Offset(_tileSize!.width / 2, height + _topPadding);
      _preferTooltipOnTop = true;
    } else {
      // Obtaining a tooltip position at 30% of the tile's height.
      _position =
          _position! + Offset(_tileSize!.width / 2, _tileSize!.height * 0.3);
      _preferTooltipOnTop =
          paintBounds.contains(_position! - Offset(0.0, height));
    }
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
      TreemapTooltipSettings tooltipSettings,
      TextDirection textDirection) {
    const double tooltipTriangleWidth = 12.0;
    const double halfTooltipTriangleWidth = tooltipTriangleWidth / 2;
    const double elevation = 0.0;
    Path path = Path();

    BorderRadius borderRadius =
        tooltipSettings.borderRadius.resolve(textDirection);
    final double tooltipWidth = parentBox.child!.size.width;
    double tooltipHeight = parentBox.child!.size.height;
    final double halfTooltipWidth = tooltipWidth / 2;
    double halfTooltipHeight = tooltipHeight / 2;

    double triangleHeight = RenderTooltip.tooltipTriangleHeight;
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
    final Color strokeColor = tooltipSettings.borderColor ?? Colors.transparent;
    final Paint paint = Paint()
      ..color = strokeColor
      // We are drawing stroke before fill to avoid tooltip rendering issue in
      // a web HTML rendering. Due to this, half of the stroke width only
      // visible to us so that we are twice the stroke width.
      ..strokeWidth = tooltipSettings.borderWidth * 2
      ..style = PaintingStyle.stroke;
    // Drawing stroke.
    context.canvas.drawPath(path, paint);
    paint
      ..style = PaintingStyle.fill
      ..color = tooltipSettings.color!;
    // Drawing fill color.
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
      Offset offset, Offset center, RenderProxyBox parentBox) {
    final Size childSize = parentBox.child!.size;
    final double halfChildWidth = childSize.width / 2;
    final double halfChildHeight = childSize.height / 2;

    // Shifting the position of the tooltip to the left side, if its right
    // edge goes out of the map's right edge.
    if (center.dx + halfChildWidth + marginSpace > parentBox.size.width) {
      return Offset(
          childSize.width + center.dx - parentBox.size.width + marginSpace,
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
