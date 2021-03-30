import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../axis/radial_axis.dart';
import '../common/radial_gauge_renderer.dart';
import '../gauge/radial_gauge.dart';
import '../pointers/widget_pointer.dart';
import '../renderers/radial_axis_renderer_base.dart';
import '../renderers/widget_pointer_renderer_base.dart';
import '../utils/helper.dart';

/// Represents the annotation renderer
///
// ignore: must_be_immutable
class WidgetPointerContainer extends StatefulWidget {
  ///Creates the annotation renderer
  ///
  // ignore: prefer_const_constructors_in_immutables
  WidgetPointerContainer(
      {Key? key,
      required this.widgetPointer,
      required this.gauge,
      required this.axis,
      required this.renderingDetails,
      required this.interval,
      required this.duration,
      required this.axisRenderer,
      required this.pointerRenderer,
      required this.startValue,
      required this.endValue,
      required this.curve})
      : super(
          key: key,
        );

  /// specifies the annotation
  final WidgetPointer widgetPointer;

  /// Specifies the radial gauge
  final SfRadialGauge gauge;

  /// Specifies the annotation axis
  final RadialAxis axis;

  /// Hold the radial gauge animation details
  final RenderingDetails renderingDetails;

  /// Specifies the axis renderer
  final RadialAxisRendererBase axisRenderer;

  /// Specifies the pointer renderer
  final WidgetPointerRenderer pointerRenderer;

  /// Specifies the interval duration
  final List<double?> interval;

  /// Specifies the animation duration
  final int duration;

  /// Specifies the animation start value
  final double? startValue;

  /// Specifies the animation end value
  final double? endValue;

  /// Specifies the animation curve
  final Curve curve;

  @override
  State<StatefulWidget> createState() {
    return WidgetPointerContainerState();
  }
}

/// Represents the annotation renderer state
class WidgetPointerContainerState extends State<WidgetPointerContainer>
    with SingleTickerProviderStateMixin {
  /// Specifies the offset of positioning the annotation
  double? pointerAngle;

  /// Holds the animation controller
  AnimationController? animationController;

  /// Specifies the pointer animation
  Animation<double>? pointerAnimation;

  /// Specifies the pointer needs to get animate
  bool needsPointerAnimation = false;

  /// Refreshes the pointer position while dragging
  void refresh() {
    setState(() {});
  }

  @override
  void didUpdateWidget(WidgetPointerContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    animationController = AnimationController(vsync: this);
    widget.pointerRenderer.pointerRenderer = widget;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    needsPointerAnimation =
        widget.pointerRenderer.getIsPointerAnimationEnabled();
    final Widget _widget = widget.widgetPointer.child;
    if (widget.renderingDetails.needsToAnimatePointers ||
        needsPointerAnimation) {
      animationController!.duration = Duration(milliseconds: widget.duration);
      pointerAnimation =
          Tween<double>(begin: widget.startValue, end: widget.endValue).animate(
              CurvedAnimation(
                  parent: animationController!,
                  curve: Interval(widget.interval[0]!, widget.interval[1]!,
                      curve: widget.curve)));
      animationController!.forward(from: 0.0);

      return AnimatedBuilder(
          animation: animationController!,
          child: _widget,
          builder: (context, _widget) {
            _updateAnimation();
            final Offset? offset = _getWidgetOffset();

            return Opacity(
                opacity: offset == null ||
                        (widget.renderingDetails.needsToAnimatePointers &&
                            widget.axis.minimum ==
                                widget.pointerRenderer.currentValue)
                    ? 0
                    : 1,
                child: _WidgetPointerRenderObject(
                    child: _widget!,
                    position: offset ?? Offset(0, 0),
                    renderer: widget.pointerRenderer));
          });
    } else {
      return _WidgetPointerRenderObject(
          child: _widget,
          position: _getWidgetOffset()!,
          renderer: widget.pointerRenderer);
    }
  }

  /// Updates the animation of widget pointer
  void _updateAnimation() {
    // Disables the animation once the animation reached the current
    // pointer angle
    // final double _angle = pointerAngle;
    if (needsPointerAnimation &&
        pointerAngle != null &&
        pointerAngle ==
            widget.axisRenderer.sweepAngle *
                    widget.pointerRenderer.animationEndValue! +
                widget.axis.startAngle) {
      widget.pointerRenderer.needsAnimate = false;
    }

    if (widget.renderingDetails.needsToAnimatePointers &&
        widget.gauge.axes[widget.gauge.axes.length - 1] == widget.axis &&
        widget.axis.pointers![widget.axis.pointers!.length - 1] ==
            widget.widgetPointer &&
        ((!widget.renderingDetails.isOpacityAnimation &&
                pointerAngle != null &&
                pointerAngle ==
                    widget.axisRenderer.sweepAngle *
                            widget.pointerRenderer.animationEndValue! +
                        widget.axis.startAngle) ||
            (widget.renderingDetails.isOpacityAnimation &&
                pointerAnimation!.value == 1))) {
      widget.renderingDetails.needsToAnimatePointers = false;
    }
  }

  /// Calculates the poition of the widget
  Offset? _getWidgetOffset() {
    pointerAngle = 0;
    Offset? offset;
    bool? needsShowPointer;
    if (pointerAnimation != null) {
      needsShowPointer = widget.axis.isInversed
          ? pointerAnimation!.value < 1
          : pointerAnimation!.value > 0;
    }

    if ((widget.renderingDetails.needsToAnimatePointers &&
            (!widget.renderingDetails.isOpacityAnimation &&
                widget.axis.minimum != widget.pointerRenderer.currentValue)) ||
        (needsPointerAnimation &&
            (!widget.gauge.enableLoadingAnimation ||
                (widget.gauge.enableLoadingAnimation &&
                    pointerAnimation!.value != 1 &&
                    !widget.renderingDetails.isOpacityAnimation &&
                    !widget.renderingDetails.needsToAnimatePointers)))) {
      if ((widget.renderingDetails.needsToAnimatePointers &&
              needsShowPointer != null &&
              needsShowPointer) ||
          !widget.renderingDetails.needsToAnimatePointers) {
        pointerAngle =
            (widget.axisRenderer.sweepAngle * pointerAnimation!.value) +
                widget.axis.startAngle;
        offset = widget.pointerRenderer.getPointerOffset(
            getDegreeToRadian(pointerAngle!), widget.widgetPointer);
      }
    } else {
      offset = widget.pointerRenderer.offset;
      pointerAngle = widget.pointerRenderer.angle;
    }

    return offset;
  }

  @override
  void dispose() {
    if (animationController != null) {
      animationController!.dispose();
    }

    super.dispose();
  }
}

/// Represents the render object for widget pointer.
class _WidgetPointerRenderObject extends SingleChildRenderObjectWidget {
  const _WidgetPointerRenderObject(
      {Key? key,
      required Widget child,
      required this.position,
      required this.renderer})
      : super(key: key, child: child);

  /// Specifies the offset position for annotation
  final Offset position;

  /// Specifies the widget pointer renderer
  final WidgetPointerRenderer renderer;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderPointerWidget(position, renderer);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderPointerWidget renderObject) {
    renderObject
      ..position = position
      ..renderer = renderer;
  }
}

/// Render the annotation widget in the respective position.
class _RenderPointerWidget extends RenderShiftedBox {
  _RenderPointerWidget(this._position, this._renderer, [RenderBox? child])
      : super(child);

  /// Holds the annotation position
  Offset? _position;

  /// Gets the annotation position
  Offset? get position => _position!;

  /// Sets the annotation position
  set position(Offset? value) {
    if (_position != value) {
      _position = value;
      markNeedsLayout();
    }
  }

  /// Holds the widget pointer renderer
  WidgetPointerRenderer _renderer;

  /// Gets the widget pointer renderer
  WidgetPointerRenderer get renderer => _renderer;

  /// Sets the widget pointer renderer
  set renderer(WidgetPointerRenderer value) {
    if (_renderer != value) {
      _renderer = value;
      markNeedsLayout();
    }
  }

  /// Specifies the margin value for pointer rect
  final double _margin = 15;

  @override
  void performLayout() {
    final BoxConstraints boxConstraints = constraints;
    if (child != null) {
      child!.layout(boxConstraints, parentUsesSize: true);
      size =
          boxConstraints.constrain(Size(child!.size.width, child!.size.height));

      if (child!.parentData is BoxParentData && position != null) {
        final BoxParentData childParentData =
            child!.parentData as BoxParentData;
        final double dx = position!.dx - child!.size.width / 2;
        final double dy = position!.dy - child!.size.height / 2;
        _renderer.pointerRect = Rect.fromLTRB(
            dx - size.width / 2 - _margin,
            dy - size.height / 2 - _margin,
            dx + size.width / 2 + _margin,
            dy + size.height / 2 + _margin);
        childParentData.offset = Offset(dx, dy);
      }
    } else {
      size = Size.zero;
    }
  }
}
