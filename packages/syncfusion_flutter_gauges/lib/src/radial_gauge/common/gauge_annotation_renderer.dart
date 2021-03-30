import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../annotation/gauge_annotation.dart';
import '../axis/radial_axis.dart';
import '../gauge/radial_gauge.dart';
import '../renderers/radial_axis_renderer_base.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import 'radial_gauge_renderer.dart';

/// Represents the annotation renderer
///
// ignore: must_be_immutable
class AnnotationRenderer extends StatefulWidget {
  ///Creates the annotation renderer
  ///
  // ignore: prefer_const_constructors_in_immutables
  AnnotationRenderer(
      {Key? key,
      required this.annotation,
      required this.gauge,
      required this.axis,
      this.interval,
      required this.duration,
      required this.renderingDetails,
      required this.axisRenderer})
      : super(
          key: key,
        );

  /// specifies the annotation
  final GaugeAnnotation annotation;

  /// Specifies the radial gauge
  final SfRadialGauge gauge;

  /// Specifies the annotation axis
  final RadialAxis axis;

  /// Specifies the interval duration
  final List<double?>? interval;

  /// Specifies the animation duration
  final int duration;

  /// Hold the radial gauge animation details
  final RenderingDetails renderingDetails;

  /// Holds the radial axis renderer
  final RadialAxisRendererBase axisRenderer;

  @override
  State<StatefulWidget> createState() {
    return AnnotationRendererState();
  }
}

/// Represents the annotation renderer state
class AnnotationRendererState extends State<AnnotationRenderer>
    with SingleTickerProviderStateMixin {
  /// Holds the animation controller
  AnimationController? animationController;

  /// Holds the animation value
  Animation<double>? animation;

  /// Specifies the offset of positioning the annotation
  late Offset annotationPosition;

  @override
  void initState() {
    _calculateAxisPosition(widget.annotation, widget.axis, widget.axisRenderer);
    if (widget.renderingDetails.needsToAnimateAnnotation) {
      animationController = AnimationController(vsync: this)
        ..duration = Duration(milliseconds: widget.duration);
      animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: animationController!,
          curve: Interval(widget.interval![0]!, widget.interval![1]!,
              curve: Curves.fastOutSlowIn)));
    }
    super.initState();
  }

  // Calculate the pixel position in axis to place the annotation widget.
  void _calculateAxisPosition(GaugeAnnotation annotation, RadialAxis axis,
      RadialAxisRendererBase axisRenderer) {
    final double value = annotation.positionFactor;
    final double offset = value * (axisRenderer.radius);
    final double angle = _calculateActualAngle(annotation, axis, axisRenderer);
    final double radian = getDegreeToRadian(angle);
    if (!axis.canScaleToFit) {
      final double x = (axisRenderer.axisSize.width / 2) +
          (offset - (axisRenderer.actualAxisWidth / 2)) * math.cos(radian) -
          axisRenderer.centerX;
      final double y = (axisRenderer.axisSize.height / 2) +
          (offset - (axisRenderer.actualAxisWidth / 2)) * math.sin(radian) -
          axisRenderer.centerY;
      annotationPosition = Offset(x, y);
    } else {
      final double x = axisRenderer.axisCenter.dx +
          (offset - (axisRenderer.actualAxisWidth / 2)) * math.cos(radian);
      final double y = axisRenderer.axisCenter.dy +
          (offset - (axisRenderer.actualAxisWidth / 2)) * math.sin(radian);
      annotationPosition = Offset(x, y);
    }
  }

  /// Calculates the actual angle value
  double _calculateActualAngle(GaugeAnnotation annotation, RadialAxis axis,
      RadialAxisRendererBase axisRenderer) {
    double actualValue = 0;
    if (annotation.angle != null) {
      actualValue = annotation.angle!;
    } else if (annotation.axisValue != null) {
      actualValue = (axisRenderer.valueToFactor(annotation.axisValue!) *
              axisRenderer.sweepAngle) +
          axis.startAngle;
    }
    return actualValue;
  }

  /// To update the load time animation of annotation
  void _updateAnimation() {
    if (widget.gauge.axes[widget.gauge.axes.length - 1] == widget.axis &&
        widget.axis.annotations![widget.axis.annotations!.length - 1] ==
            widget.annotation &&
        animation!.value == 1) {
      widget.renderingDetails.needsToAnimateAnnotation = false;
    }
  }

  @override
  void didUpdateWidget(AnnotationRenderer oldWidget) {
    _calculateAxisPosition(widget.annotation, widget.axis, widget.axisRenderer);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.renderingDetails.needsToAnimateAnnotation) {
      animationController!.forward(from: 0);
      return AnimatedBuilder(
          animation: animationController!,
          child: widget.annotation.widget,
          builder: (BuildContext context, Widget? _widget) {
            _updateAnimation();
            return Opacity(
                opacity: animation!.value,
                child: _AnnotationRenderObject(
                    child: widget.annotation.widget,
                    position: annotationPosition,
                    horizontalAlignment: widget.annotation.horizontalAlignment,
                    verticalAlignment: widget.annotation.verticalAlignment));
          });
    } else {
      return _AnnotationRenderObject(
          child: widget.annotation.widget,
          position: annotationPosition,
          horizontalAlignment: widget.annotation.horizontalAlignment,
          verticalAlignment: widget.annotation.verticalAlignment);
    }
  }

  @override
  void dispose() {
    if (animationController != null) {
      animationController!
          .dispose(); // Need to dispose the animation controller instance
      // otherwise it will cause memory leak
    }
    super.dispose();
  }
}

/// Represents the render object for annotation widget.
class _AnnotationRenderObject extends SingleChildRenderObjectWidget {
  const _AnnotationRenderObject(
      {Key? key,
      required Widget child,
      required this.position,
      required this.horizontalAlignment,
      required this.verticalAlignment})
      : super(key: key, child: child);

  /// Specifies the offset position for annotation
  final Offset position;

  /// How the annotation should be aligned horizontally in the
  /// respective position.
  final GaugeAlignment horizontalAlignment;

  /// How the annotation should be aligned vertically in the
  /// respective position.
  final GaugeAlignment verticalAlignment;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderAnnotationWidget(
        position, horizontalAlignment, verticalAlignment);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderAnnotationWidget renderObject) {
    renderObject
      ..position = position
      ..horizontalAlignment = horizontalAlignment
      ..verticalAlignment = verticalAlignment;
  }
}

/// Render the annotation widget in the respective position.
class _RenderAnnotationWidget extends RenderShiftedBox {
  _RenderAnnotationWidget(
      this._position, this._horizontalAlignment, this._verticalAlignment,
      [RenderBox? child])
      : super(child);

  /// Holds the annotation position
  Offset _position;

  /// Holds the horizontal alignment
  GaugeAlignment _horizontalAlignment;

  /// Holds the vertical alignment
  GaugeAlignment _verticalAlignment;

  /// Gets the annotation position
  Offset get position => _position;

  /// Sets the annotation position
  set position(Offset value) {
    if (_position != value) {
      _position = value;
      markNeedsLayout();
    }
  }

  /// Gets the horizontal alignment of annotation
  GaugeAlignment get horizontalAlignment => _horizontalAlignment;

  /// Sets the horizontal alignment of annotation
  set horizontalAlignment(GaugeAlignment value) {
    if (_horizontalAlignment != value) {
      _horizontalAlignment = value;
      markNeedsLayout();
    }
  }

  /// Gets the vertical alignment of annotation
  GaugeAlignment get verticalAlignment => _verticalAlignment;

  /// Sets the vertical alignment of annotation
  set verticalAlignment(GaugeAlignment value) {
    if (_verticalAlignment != value) {
      _verticalAlignment = value;
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(Size(child!.size.width, child!.size.height));
      if (child!.parentData is BoxParentData) {
        final BoxParentData childParentData =
            child!.parentData as BoxParentData;
        final double dx = position.dx -
            (horizontalAlignment == GaugeAlignment.near
                ? 0
                : horizontalAlignment == GaugeAlignment.center
                    ? child!.size.width / 2
                    : child!.size.width);
        final double dy = position.dy -
            (verticalAlignment == GaugeAlignment.near
                ? 0
                : verticalAlignment == GaugeAlignment.center
                    ? child!.size.height / 2
                    : child!.size.height);
        childParentData.offset = Offset(dx, dy);
      }
    } else {
      size = Size.zero;
    }
  }
}
