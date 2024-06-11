import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef TooltipWidgetBuilder = Widget? Function(
    BuildContext, TooltipInfo?, Size);

/// Holds details of a tooltip is shown.
@immutable
class TooltipInfo {
  const TooltipInfo({
    required this.primaryPosition,
    required this.secondaryPosition,
    this.text,
    this.surfaceBounds,
  });

  /// Global position of the tooltip. Used when tooltip renders on top.
  final Offset primaryPosition;

  /// Global position of the tooltip. Used when tooltip renders on bottom.
  final Offset secondaryPosition;

  /// Text to be displayed in the tooltip.
  final String? text;

  /// [RenderBox] of the tooltip.
  final Rect? surfaceBounds;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is TooltipInfo &&
        other.text == text &&
        other.surfaceBounds == surfaceBounds;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      primaryPosition,
      secondaryPosition,
      text,
      surfaceBounds,
    ];
    return Object.hashAll(values);
  }
}

class TooltipOpacity extends Opacity {
  const TooltipOpacity({
    super.key,
    required super.opacity,
    super.alwaysIncludeSemantics = false,
    super.child,
  });

  @override
  RenderOpacity createRenderObject(BuildContext context) {
    return TooltipOpacityRenderBox(
      opacity: opacity,
      alwaysIncludeSemantics: alwaysIncludeSemantics,
    );
  }
}

class TooltipOpacityRenderBox extends RenderOpacity {
  TooltipOpacityRenderBox({
    super.opacity = 1.0,
    super.alwaysIncludeSemantics = false,
    super.child,
  });
}

class CoreTooltip extends StatefulWidget {
  const CoreTooltip({
    super.key,
    required this.builder,
    this.animationDuration = 500,
    this.showDuration = 3000,
    this.innerPadding = 5.0,
    this.color = Colors.black,
    this.borderColor = Colors.black,
    this.borderWidth = 0.0,
    this.shouldAlwaysShow = false,
    this.elevation = 0.0,
    this.shadowColor,
    this.triangleHeight = 7.0,
    this.preferTooltipOnTop,
    this.opacity = 1.0,
  });

  final TooltipWidgetBuilder? builder;
  final int animationDuration;
  final int showDuration;
  final double innerPadding;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final Color? shadowColor;
  final double elevation;
  final bool shouldAlwaysShow;
  final double triangleHeight;
  final bool? preferTooltipOnTop;
  final double opacity;

  @override
  State<CoreTooltip> createState() => CoreTooltipState();
}

class CoreTooltipState extends State<CoreTooltip>
    with SingleTickerProviderStateMixin {
  final GlobalKey _tooltipKey = GlobalKey();
  late AnimationController _controller;
  late CurvedAnimation _animation;

  bool _isDesktop = false;
  TooltipInfo? _info;
  PointerDeviceKind _pointerDeviceKind = PointerDeviceKind.touch;

  /// In desktop mode, the tooltip will be displayed upon hover interaction,
  /// which means that the show method may be triggered for every hover
  /// movement. To prevent this, we have delayed show method for 100ms.
  Timer? _desktopShowDelayTimer;
  Timer? _showTimer;

  void show(TooltipInfo info, PointerDeviceKind kind,
      {bool immediately = false}) {
    if (_isDesktop && kind == PointerDeviceKind.mouse) {
      _desktopShowDelayTimer?.cancel();
      if (immediately) {
        _show(info, kind);
      } else {
        _desktopShowDelayTimer = Timer(const Duration(milliseconds: 50), () {
          _show(info, kind);
          _desktopShowDelayTimer = null;
        });
      }
    } else {
      _show(info, kind);
    }
  }

  void _show(TooltipInfo info, PointerDeviceKind kind) {
    final bool startFromZero = _info != info;
    _info = info;
    _pointerDeviceKind = kind;
    _controller.forward(from: startFromZero ? 0 : null);
    _startShowTimer();
    final RenderObjectElement? tooltipElement =
        _tooltipKey.currentContext as RenderObjectElement?;
    if (tooltipElement != null &&
        tooltipElement.mounted &&
        tooltipElement.renderObject.attached) {
      final RenderObject? renderObject = tooltipElement.findRenderObject();
      if (renderObject != null &&
          renderObject.attached &&
          renderObject is RenderConstrainedLayoutBuilder) {
        renderObject.markNeedsBuild();
      }
    }
  }

  void hide({bool immediately = false}) {
    immediately ? _controller.reset() : _controller.reverse();
    // (_tooltipKey.currentContext?.findRenderObject()
    //         as RenderConstrainedLayoutBuilder<BoxConstraints, RenderBox>?)
    //     ?.markNeedsBuild();
  }

  void _startShowTimer() {
    // if (_isDesktop && _pointerDeviceKind == PointerDeviceKind.mouse) {
    // } else {
    _showTimer?.cancel();
    if (widget.showDuration.isInfinite || widget.shouldAlwaysShow) {
      return;
    }

    _showTimer = Timer(
        // When the [animationDuration] is 3000 and the [showDuration] is 3000,
        // the tooltip will start hiding after it completes the scale animation,
        // without staying in the visual for 3 seconds.
        // So, [widget.animationDuration] has been considered in [_showTimer].
        Duration(milliseconds: widget.animationDuration + widget.showDuration),
        () {
      if (mounted) {
        hide();
        _showTimer = null;
      }
    });
    // }
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationDuration),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    super.initState();
  }

  @override
  void dispose() {
    _info = null;
    _isDesktop = false;
    _controller.dispose();
    _animation.dispose();

    _desktopShowDelayTimer?.cancel();
    _showTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData chartThemeData = Theme.of(context);
    _isDesktop = kIsWeb ||
        chartThemeData.platform == TargetPlatform.macOS ||
        chartThemeData.platform == TargetPlatform.windows ||
        chartThemeData.platform == TargetPlatform.linux;
    return TooltipOpacity(
      opacity: widget.opacity,
      child: LayoutBuilder(
        key: _tooltipKey,
        builder: (BuildContext context, BoxConstraints constraints) {
          return _CoreTooltipRenderObjectWidget(
            primaryPosition: _info?.primaryPosition,
            secondaryPosition: _info?.secondaryPosition,
            edgeBounds: _info?.surfaceBounds,
            innerPadding: widget.innerPadding,
            color: widget.color,
            borderColor: widget.borderColor,
            borderWidth: widget.borderWidth,
            shadowColor: widget.shadowColor,
            elevation: widget.elevation,
            shouldAlwaysShow: widget.shouldAlwaysShow,
            triangleHeight: widget.triangleHeight,
            preferTooltipOnTop: widget.preferTooltipOnTop,
            isDesktop: _isDesktop,
            deviceKind: _pointerDeviceKind,
            state: this,
            child: widget.builder?.call(context, _info, constraints.biggest),
          );
        },
      ),
    );
  }
}

class _CoreTooltipRenderObjectWidget extends SingleChildRenderObjectWidget {
  const _CoreTooltipRenderObjectWidget({
    required this.primaryPosition,
    required this.secondaryPosition,
    required this.edgeBounds,
    required this.innerPadding,
    required this.color,
    required this.borderColor,
    required this.borderWidth,
    required this.shadowColor,
    required this.elevation,
    required this.shouldAlwaysShow,
    required this.triangleHeight,
    required this.preferTooltipOnTop,
    required this.isDesktop,
    required this.deviceKind,
    required this.state,
    super.child,
  });

  final Offset? primaryPosition;
  final Offset? secondaryPosition;
  final Rect? edgeBounds;
  final double innerPadding;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final Color? shadowColor;
  final double elevation;
  final bool shouldAlwaysShow;
  final double triangleHeight;
  final bool? preferTooltipOnTop;
  final bool isDesktop;
  final PointerDeviceKind deviceKind;
  final CoreTooltipState state;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _CoreTooltipRenderBox()
      ..primaryPosition = primaryPosition
      ..secondaryPosition = secondaryPosition
      ..edgeBounds = edgeBounds
      ..innerPadding = innerPadding
      ..color = color
      ..borderColor = borderColor
      ..borderWidth = borderWidth
      ..shadowColor = shadowColor
      ..elevation = elevation
      ..shouldAlwaysShow = shouldAlwaysShow
      ..triangleHeight = triangleHeight
      ..preferTooltipOnTop = preferTooltipOnTop
      .._state = state
      ..textDirection = Directionality.of(context);
  }

  @override
  void updateRenderObject(
      BuildContext context, _CoreTooltipRenderBox renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..primaryPosition = primaryPosition
      ..secondaryPosition = secondaryPosition
      ..edgeBounds = edgeBounds
      ..innerPadding = innerPadding
      ..color = color
      ..borderColor = borderColor
      ..borderWidth = borderWidth
      ..shadowColor = shadowColor
      ..elevation = elevation
      ..shouldAlwaysShow = shouldAlwaysShow
      ..triangleHeight = triangleHeight
      ..preferTooltipOnTop = preferTooltipOnTop
      .._state = state
      ..textDirection = Directionality.of(context);
  }
}

class _CoreTooltipRenderBox extends RenderProxyBox {
  final double _noseGap = 2.0;
  late CoreTooltipState _state;
  Path _path = Path();
  final _RectangularShape _tooltipShape = const _RectangularShape();

  final Paint _fillPaint = Paint()..isAntiAlias = true;
  final Paint _strokePaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke;

  Offset? _localPrimaryPosition;
  Offset? _localSecondaryPosition;
  Offset? _nosePosition;

  Offset? get primaryPosition => _primaryPosition;
  Offset? _primaryPosition;
  set primaryPosition(Offset? value) {
    if (_primaryPosition == value) {
      return;
    }
    _primaryPosition = value;
    _localPrimaryPosition = value != null ? globalToLocal(value) : null;
    markNeedsPaint();
  }

  Offset? get secondaryPosition => _secondaryPosition;
  Offset? _secondaryPosition;
  set secondaryPosition(Offset? value) {
    if (_secondaryPosition == value) {
      return;
    }
    _secondaryPosition = value;
    _localSecondaryPosition = value != null ? globalToLocal(value) : null;
    markNeedsPaint();
  }

  Rect? _localEdgeBounds;

  Rect? get edgeBounds => _edgeBounds;
  Rect? _edgeBounds;
  set edgeBounds(Rect? value) {
    _edgeBounds = value;
    if (value != null) {
      _localEdgeBounds = Rect.fromPoints(globalToLocal(edgeBounds!.topLeft),
          globalToLocal(edgeBounds!.bottomRight));
    } else {
      _localEdgeBounds = null;
    }
    markNeedsLayout();
  }

  double get innerPadding => _innerPadding;
  double _innerPadding = 5.0;
  set innerPadding(double value) {
    _innerPadding = value;
    markNeedsLayout();
  }

  Color get color => _color;
  Color _color = Colors.black;
  set color(Color value) {
    if (_color == value) {
      return;
    }
    _color = value;
    _fillPaint.color = _color;
    markNeedsPaint();
  }

  Color get borderColor => _borderColor;
  Color _borderColor = Colors.black;
  set borderColor(Color value) {
    if (_borderColor == value) {
      return;
    }
    _borderColor = value;
    _strokePaint.color = _borderColor;
    markNeedsPaint();
  }

  double get borderWidth => _borderWidth;
  double _borderWidth = 0.0;
  set borderWidth(double value) {
    if (_borderWidth == value) {
      return;
    }
    _borderWidth = value;
    _strokePaint.strokeWidth = _borderWidth;
    markNeedsPaint();
  }

  Color? get shadowColor => _shadowColor;
  Color? _shadowColor;
  set shadowColor(Color? value) {
    if (_shadowColor == value) {
      return;
    }
    _shadowColor = value;
    markNeedsPaint();
  }

  double get elevation => _elevation;
  double _elevation = 0.0;
  set elevation(double value) {
    if (_elevation == value) {
      return;
    }
    _elevation = value;
    markNeedsPaint();
  }

  bool get shouldAlwaysShow => _shouldAlwaysShow;
  bool _shouldAlwaysShow = false;
  set shouldAlwaysShow(bool value) {
    if (_shouldAlwaysShow == value) {
      return;
    }
    _shouldAlwaysShow = value;
    markNeedsPaint();
  }

  double get triangleHeight => _triangleHeight;
  double _triangleHeight = 7.0;
  set triangleHeight(double value) {
    _triangleHeight = value;
    markNeedsLayout();
  }

  bool? _effectivePreferTooltipOnTop;

  bool? get preferTooltipOnTop {
    assert(false, 'Use _effectivePreferTooltipOnTop instead.');
    return _preferTooltipOnTop;
  }

  bool? _preferTooltipOnTop;
  set preferTooltipOnTop(bool? value) {
    _preferTooltipOnTop = value;
    _effectivePreferTooltipOnTop = value;
    markNeedsLayout();
  }

  BorderRadius _effectiveBorderRadius = BorderRadius.circular(5);

  BorderRadius get borderRadius => _borderRadius;
  BorderRadius _borderRadius = BorderRadius.circular(5);
  set borderRadius(BorderRadius value) {
    if (_borderRadius == value) {
      return;
    }
    _borderRadius = value;
    _effectiveBorderRadius = _borderRadius.resolve(textDirection);
    markNeedsPaint();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection = TextDirection.ltr;
  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    _effectiveBorderRadius = _borderRadius.resolve(value);
    markNeedsPaint();
  }

  void _onAnimationUpdate() {
    markNeedsLayout();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! BoxParentData) {
      child.parentData = BoxParentData();
    }
  }

  @override
  void attach(PipelineOwner owner) {
    _state._animation.addListener(_onAnimationUpdate);
    super.attach(owner);
  }

  @override
  void detach() {
    _state._animation.removeListener(_onAnimationUpdate);
    super.detach();
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    if (_state._animation.value == 1.0 &&
        child != null &&
        child!.parentData != null) {
      final BoxParentData childParentData = child!.parentData! as BoxParentData;
      return result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          return child!.hitTest(result, position: transformed);
        },
      );
    }
    return false;
  }

  @override
  void performLayout() {
    // Hide the tooltip while resizing.
    if (!hasSize || size != constraints.biggest) {
      _nosePosition = null;
      _primaryPosition = null;
      _secondaryPosition = null;
      size = constraints.biggest;
      return;
    }

    size = constraints.biggest;
    if (child == null) {
      return;
    }

    final Rect surfaceBounds = _localEdgeBounds ?? paintBounds;
    child?.layout(constraints, parentUsesSize: true);
    _effectivePreferTooltipOnTop ??= _canPreferTooltipOnTop(surfaceBounds);
    _nosePosition = _effectivePreferTooltipOnTop!
        ? _localPrimaryPosition?.translate(0.0, -_noseGap)
        : _localSecondaryPosition?.translate(0.0, _noseGap);
    _validateNosePosition();

    _path = _tooltipShape.outerPath(
      position: _nosePosition,
      preferTooltipOnTop: _effectivePreferTooltipOnTop!,
      child: child!,
      surfaceBounds: surfaceBounds,
      animation: _state._animation,
      fillPaint: _fillPaint,
      strokePaint: _strokePaint,
      borderRadius: _effectiveBorderRadius,
      triangleHeight: _triangleHeight,
      innerPadding: _innerPadding,
    );

    final int multiplier = (_effectivePreferTooltipOnTop! ? 1 : -1);
    final double halfTooltipHeight = child!.size.height / 2;
    final Offset pathShift = Offset(
      _nosePosition!.dx,
      _nosePosition!.dy -
          (_triangleHeight * multiplier + halfTooltipHeight * multiplier),
    );
    _path = _path.shift(pathShift);

    final Rect pathBounds = _path.getBounds();
    final Offset pathCenter = pathBounds.center;
    final double triangleHeight = _triangleHeight * multiplier;
    final Offset childPosition = Offset(
      pathCenter.dx - child!.size.width / 2,
      pathCenter.dy - (child!.size.height + triangleHeight) / 2,
    );
    final BoxParentData childParentData = child!.parentData! as BoxParentData;
    childParentData.offset =
        childPosition + _childShiftOffset(pathBounds, surfaceBounds);
  }

  bool _canPreferTooltipOnTop(Rect surfaceBounds) {
    if (_localPrimaryPosition == null) {
      return true;
    }

    final Size childSize = child?.size ?? Size.zero;
    final Offset tooltipStart = Offset(
      _localPrimaryPosition!.dx - childSize.width / 2,
      _localPrimaryPosition!.dy - _triangleHeight - childSize.height,
    );
    final Rect tooltipBounds = Rect.fromLTWH(
      tooltipStart.dx,
      tooltipStart.dy,
      childSize.width,
      childSize.height + _triangleHeight,
    );

    if (tooltipBounds.top < surfaceBounds.top) {
      return false;
    } else if (tooltipBounds.bottom > surfaceBounds.bottom) {
      return true;
    }

    return true;
  }

  void _validateNosePosition() {
    if (_localEdgeBounds == null) {
      if (_nosePosition!.dx < 0) {
        _nosePosition = Offset(0, _nosePosition!.dy);
      }
      if (_nosePosition!.dx > size.width) {
        _nosePosition = Offset(size.width, _nosePosition!.dy);
      }
      if (_nosePosition!.dy < _noseGap) {
        _nosePosition = Offset(_nosePosition!.dx, _noseGap);
      }
      if (_nosePosition!.dy > size.height) {
        _nosePosition = Offset(_nosePosition!.dx, size.height - _noseGap);
      }
    }
  }

  Offset _childShiftOffset(Rect pathBounds, Rect surfaceBounds) {
    if (_localPrimaryPosition != null) {
      final double start = _localPrimaryPosition!.dx;
      final Size childSize = child!.size;
      final double halfChildWidth = childSize.width / 2;

      final double pathWidth = pathBounds.width;
      final double tooltipRectWidth = child!.size.width;
      // Tooltip nose width which exceeds the tooltip rect width.
      final double excessWidth = pathWidth - tooltipRectWidth;
      // Shifting the position to left side.
      if (start + halfChildWidth > surfaceBounds.right) {
        return Offset(-excessWidth / 2, 0.0);
      }
      // Shifting the position to right side.
      else if (start - halfChildWidth < surfaceBounds.left) {
        return Offset(excessWidth / 2, 0.0);
      }
    }

    return Offset.zero;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final double animationValue = _state._animation.value;
    if (child == null ||
        _nosePosition == null ||
        _effectivePreferTooltipOnTop == null) {
      return;
    }

    context.canvas.save();
    context.canvas.translate(_nosePosition!.dx, _nosePosition!.dy);
    context.canvas.scale(animationValue);
    context.canvas.translate(-_nosePosition!.dx, -_nosePosition!.dy);
    // In web HTML rendering, fill color clipped half of its tooltip's size.
    // To avoid this issue we are drawing stroke before fill.
    // Due to this, half of the stroke width only
    // visible to us so that we are twice the stroke width.
    // TODO(VijayakumarM): Check this comment.
    if (elevation > 0) {
      context.canvas.drawShadow(_path, shadowColor ?? color, elevation, true);
    }
    // Drawing stroke.
    context.canvas.drawPath(_path, _strokePaint);
    // Drawing fill color.
    context.canvas.drawPath(_path, _fillPaint);
    // Clipping corners and to ignore excess portions.
    context.canvas.clipPath(_path);
    // Drawing tooltip's builder/child.
    final BoxParentData childParentData = child!.parentData! as BoxParentData;
    // Used [pushTransform] because scrollable widgets are not scaled with
    // [context.paintChild].
    context.pushTransform(true, Offset(_nosePosition!.dx, _nosePosition!.dy),
        Matrix4.diagonal3Values(animationValue, animationValue, 1),
        (PaintingContext context, Offset translateOffset) {
      context.paintChild(child!, childParentData.offset + offset);
    });

    context.canvas.restore();
  }
}

class _RectangularShape {
  const _RectangularShape();
  Path outerPath({
    required Offset? position,
    required bool preferTooltipOnTop,
    required RenderBox child,
    required Rect surfaceBounds,
    required Animation<double> animation,
    required Paint fillPaint,
    required Paint strokePaint,
    required BorderRadius borderRadius,
    required double triangleHeight,
    required double innerPadding,
  }) {
    if (position == null) {
      return Path();
    }

    const double tooltipTriangleWidth = 12.0;
    const double halfTooltipTriangleWidth = tooltipTriangleWidth / 2;
    const double elevation = 0.0;

    final double tooltipWidth = child.size.width;
    double tooltipHeight = child.size.height;
    final double halfTooltipWidth = tooltipWidth / 2;
    double halfTooltipHeight = tooltipHeight / 2;

    final double tooltipStartPoint = triangleHeight + tooltipHeight / 2;
    double tooltipTriangleOffsetY = tooltipStartPoint - triangleHeight;

    final double endGlobal = surfaceBounds.right - innerPadding;
    double rightLineWidth = position.dx + halfTooltipWidth > endGlobal
        ? endGlobal - position.dx
        : halfTooltipWidth;
    final double leftLineWidth =
        position.dx - halfTooltipWidth < surfaceBounds.left + innerPadding
            ? position.dx - surfaceBounds.left - innerPadding
            : tooltipWidth - rightLineWidth;
    rightLineWidth = leftLineWidth < halfTooltipWidth
        ? halfTooltipWidth - leftLineWidth + rightLineWidth
        : rightLineWidth;

    double moveNosePoint = leftLineWidth < tooltipWidth * 0.1
        ? tooltipWidth * 0.1 - leftLineWidth
        : 0.0;
    moveNosePoint = rightLineWidth < tooltipWidth * 0.1
        ? -(tooltipWidth * 0.1 - rightLineWidth)
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

    return _tooltipPath(
      triangleHeight,
      halfTooltipHeight,
      halfTooltipTriangleWidth,
      tooltipTriangleOffsetY,
      moveNosePoint,
      rightLineWidth,
      leftLineWidth,
      borderRadius,
      tooltipHeight,
    );
  }

  Path _tooltipPath(
    double tooltipTriangleHeight,
    double halfTooltipHeight,
    double halfTooltipTriangleWidth,
    double tooltipTriangleOffsetY,
    double moveNosePoint,
    double rightLineWidth,
    double leftLineWidth,
    BorderRadius borderRadius,
    double tooltipHeight,
  ) {
    final Path path = Path();
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
}
