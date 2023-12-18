import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../common/pdfviewer_helper.dart';
import 'annotation.dart';

/// The default stroke color for annotations.
const Color defaultStrokeColor = Colors.red;

/// The default opacity for annotations.
const double defaultOpacity = 1;

/// The default selection border margin for annotations.
double selectionBorderMargin = 5;

/// The default selection border thickness for annotations.
double selectionBorderThickness = kIsDesktop ? 3 : 1.5;

/// The default color for the annotation selector.
const Color defaultSelectorColor = Color(0xFF6750A4);

/// The default color for the annotation selector when the annotation is locked.
const Color defaultLockedSelectorColor = Colors.grey;

/// A widget representing an annotation.
abstract class AnnotationView {
  /// [Annotation] instance.
  late final Annotation annotation;
}

/// Base Widget for all the annotation views.
class InteractiveGraphicsView extends LeafRenderObjectWidget {
  /// Creates a [InteractiveGraphicsView].
  const InteractiveGraphicsView({
    Key? key,
    this.color = defaultStrokeColor,
    this.opacity = defaultOpacity,
    this.fillColor,
    this.strokeWidth = 5,
    this.isSelected = false,
    this.selectorColor = defaultSelectorColor,
  }) : super(key: key);

  /// The color of the annotation.
  final Color color;

  /// The opacity of the annotation.
  final double opacity;

  /// The fill color of the annotation.
  final Color? fillColor;

  /// The stroke width of the annotation.
  final int strokeWidth;

  /// Whether the annotation is selected.
  final bool isSelected;

  /// The color of the annotation selector.
  final Color selectorColor;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderInteractiveGraphicsView(
      strokeColor: color,
      opacity: opacity,
      fillColor: fillColor,
      strokeWidth: strokeWidth,
      isSelected: isSelected,
      selectorColor: selectorColor,
    );
  }

  @override
  void updateRenderObject(BuildContext context,
      covariant RenderInteractiveGraphicsView renderObject) {
    renderObject
      ..color = color
      ..opacity = opacity
      ..fillColor = fillColor
      ..strokeWidth = strokeWidth
      ..isSelected = isSelected
      ..selectorColor = selectorColor;
  }
}

/// The render object for [InteractiveGraphicsView].
class RenderInteractiveGraphicsView extends RenderBox {
  /// Creates a [RenderInteractiveGraphicsView].
  RenderInteractiveGraphicsView({
    required Color strokeColor,
    required double opacity,
    Color? fillColor,
    required int strokeWidth,
    required bool isSelected,
    required Color selectorColor,
  }) {
    _color = strokeColor;
    _opacity = opacity;
    _fillColor = fillColor;
    _strokeWidth = strokeWidth;
    _isSelected = isSelected;
    _selectorColor = selectorColor;

    tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = onTap
      ..onTapDown = onTapDown
      ..onTapUp = onTapUp
      ..onTapCancel = onTapCancel;

    panGestureRecognizer = PanGestureRecognizer()
      ..onDown = onDragDown
      ..onStart = onDragStart
      ..onEnd = onDragEnd
      ..onUpdate = onDragUpdate
      ..onCancel = onDragCancel;
  }

  late Color _color;
  late double _opacity;
  late Color? _fillColor;
  late int _strokeWidth;
  late bool _isSelected;
  late Color _selectorColor;

  /// The color of the annotation.
  Color get color => _color;
  set color(Color value) {
    if (_color == value) {
      return;
    }
    _color = value;
    markNeedsPaint();
  }

  /// The opacity of the annotation.
  double get opacity => _opacity;
  set opacity(double value) {
    if (_opacity == value) {
      return;
    }
    _opacity = value;
    markNeedsPaint();
  }

  /// The fill color of the annotation.
  Color? get fillColor => _fillColor;
  set fillColor(Color? value) {
    if (_fillColor == value) {
      return;
    }
    _fillColor = value;
    markNeedsPaint();
  }

  /// The stroke width of the annotation.
  int get strokeWidth => _strokeWidth;
  set strokeWidth(int value) {
    if (_strokeWidth == value) {
      return;
    }
    _strokeWidth = value;
    markNeedsPaint();
  }

  /// Whether the annotation is selected.
  bool get isSelected => _isSelected;
  set isSelected(bool value) {
    if (_isSelected == value) {
      return;
    }
    _isSelected = value;
    markNeedsPaint();
  }

  /// The color of the annotation selector.
  Color get selectorColor => _selectorColor;
  set selectorColor(Color value) {
    if (_selectorColor == value) {
      return;
    }
    _selectorColor = value;
    markNeedsPaint();
  }

  /// Whether the annotation can be moved.
  bool canMove = true;

  /// The tap gesture recognizer.
  late TapGestureRecognizer tapGestureRecognizer;

  /// The pan gesture recognizer.
  late PanGestureRecognizer panGestureRecognizer;

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      tapGestureRecognizer.addPointer(event);
      if (canMove) {
        panGestureRecognizer.addPointer(event);
      }
    }
  }

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    size = constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (isSelected) {
      drawSelectionBounds(context, offset);
    }
  }

  /// Draws the selection bounds for the annotation.
  void drawSelectionBounds(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    final Rect selectorBounds =
        Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
    final Paint selectorPaint = Paint()
      ..color = selectorColor
      ..strokeWidth = selectionBorderThickness
      ..style = PaintingStyle.stroke;
    canvas.drawRect(selectorBounds, selectorPaint);
  }

  /// Override this method to handle tap down event.
  void onTapDown(TapDownDetails details) {}

  /// Override this method to handle tap up event.
  void onTapUp(TapUpDetails details) {}

  /// Override this method to handle tap cancel event.
  void onTapCancel() {}

  /// Override this method to handle tap event.
  void onTap() {}

  /// Override this method to handle drag down event.
  void onDragDown(DragDownDetails details) {}

  /// Override this method to handle drag start event.
  void onDragStart(DragStartDetails details) {}

  /// Override this method to handle drag end event.
  void onDragEnd(DragEndDetails details) {}

  /// Override this method to handle drag update event.
  void onDragUpdate(DragUpdateDetails details) {}

  /// Override this method to handle drag cancel event.
  void onDragCancel() {}
}
