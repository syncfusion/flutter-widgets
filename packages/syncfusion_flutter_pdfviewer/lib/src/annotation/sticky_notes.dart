import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../control/enums.dart';
import 'annotation.dart';
import 'annotation_view.dart';

/// Represents the sticky note annotation in the page.
class StickyNoteAnnotation extends Annotation {
  /// Initializes a new instance of [StickyNoteAnnotation] class.
  StickyNoteAnnotation({
    required super.pageNumber,
    required String text,
    required Offset position,
    required PdfStickyNoteIcon icon,
  }) {
    _text = text;
    _icon = icon;
    setBounds(_getDefualtStickyNoteSize(position));
  }

  String _text = '';
  late PdfStickyNoteIcon _icon;
  int _pageRotation = 0;

  /// Gets or sets the text of the [StickyNoteAnnotation].
  String get text => _text;
  set text(String newValue) {
    if (_text != newValue) {
      final bool canChange = onPropertyChange?.call(this, 'text') ?? true;
      if (canChange) {
        final String oldValue = _text;
        _text = newValue;
        onPropertyChanged?.call(this, 'text', oldValue, newValue);
        notifyChange();
      }
    }
  }

  /// Gets or sets the icon of [StickyNoteAnnotation].
  PdfStickyNoteIcon get icon => _icon;
  set icon(PdfStickyNoteIcon newValue) {
    if (_icon != newValue) {
      final bool canChange = onPropertyChange?.call(this, 'icon') ?? true;
      if (canChange) {
        final PdfStickyNoteIcon oldValue = _icon;
        _icon = newValue;
        setBounds(_getDefualtStickyNoteSize(position));
        onPropertyChanged?.call(this, 'icon', oldValue, newValue);
        notifyChange();
      }
    }
  }

  /// Gets or sets the position of the [StickyNoteAnnotation].
  Offset get position => boundingBox.topLeft;
  set position(Offset newValue) {
    if (position.dx != newValue.dx || position.dy != newValue.dy) {
      final bool canChange = onPropertyChange?.call(this, 'position') ?? true;
      if (canChange) {
        final Offset oldValue = position;
        setBounds(newValue & boundingBox.size);
        onPropertyChanged?.call(this, 'position', oldValue, newValue);
        notifyChange();
      }
    }
  }

  /// Default sticky note size.
  Rect _getDefualtStickyNoteSize(Offset position) {
    switch (icon) {
      case PdfStickyNoteIcon.comment:
        return Rect.fromLTWH(position.dx, position.dy, 24, 24);
      case PdfStickyNoteIcon.note:
        return Rect.fromLTWH(position.dx, position.dy, 18, 20);
      case PdfStickyNoteIcon.help:
        return Rect.fromLTWH(position.dx, position.dy, 20, 20);
      case PdfStickyNoteIcon.insert:
        return Rect.fromLTWH(position.dx, position.dy, 17, 20);
      case PdfStickyNoteIcon.key:
        return Rect.fromLTWH(position.dx, position.dy, 13, 18);
      case PdfStickyNoteIcon.newParagraph:
        return Rect.fromLTWH(position.dx, position.dy, 13, 20);
      case PdfStickyNoteIcon.paragraph:
        return Rect.fromLTWH(position.dx, position.dy, 20, 20);
    }
  }
}

/// Extension methods for [StickyNoteAnnotation].
extension StickyNoteAnnotationExtension on StickyNoteAnnotation {
  /// Sets the pageRotation of the [StickyNoteAnnotation].
  int get pageRotation => _pageRotation;
  set pageRotation(int value) {
    _pageRotation = value;
  }

  /// Sets the icon of the [StickyNoteAnnotation].
  void setIcon(PdfStickyNoteIcon icon) {
    _icon = icon;
    setBounds(_getDefualtStickyNoteSize(position));
    notifyChange();
  }

  /// Sets the position of the [StickyNoteAnnotation].
  void setPosition(Offset position) {
    setBounds(position & boundingBox.size);
    notifyChange();
  }

  /// Sets the text of the [StickyNoteAnnotation].
  void setText(String text) {
    _text = text;
    notifyChange();
  }
}

/// A widget representing a sticky note annotation.
class StickyNoteAnnotationView extends InteractiveGraphicsView
    with AnnotationView {
  /// Creates a [StickyNoteAnnotationView].
  StickyNoteAnnotationView({
    Key? key,
    required this.annotation,
    this.onAnnotationMoved,
    this.onAnnotationMoving,
    this.onTap,
    this.onDoubleTap,
    bool isSelected = false,
    bool canEdit = true,
    Color selectorColor = defaultSelectorColor,
    double selectorStorkeWidth = 1,
    double heightPercentage = 1,
  }) : super(
          key: key,
          color: annotation.color,
          strokeWidth: 1,
          opacity: annotation.opacity,
          isSelected: isSelected,
          selectorColor: selectorColor,
          canMove: canEdit,
          selectorStorkeWidth: selectorStorkeWidth,
        ) {
    _heightPercentage = heightPercentage;
  }

  /// Height percentage of the pdf page.
  late final double _heightPercentage;

  /// Called when the annotation is moved.
  final AnnotationMoveEndedCallback? onAnnotationMoved;

  /// Called when the annotation is moving.
  final AnnotationMovingCallback? onAnnotationMoving;

  /// Called when the annotation is tapped.
  final VoidCallback? onTap;

  /// Called when the annotation is double tapped.
  final VoidCallback? onDoubleTap;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderStickyNoteAnnotationView(
      stickyNoteAnnotation: annotation,
      color: color,
      opacity: opacity,
      isSelected: isSelected,
      selectorColor: selectorColor,
      selectorStorkeWidth: selectorStorkeWidth,
      heightPercentage: _heightPercentage,
      onAnnotationMoved: onAnnotationMoved,
      onAnnotationMoving: onAnnotationMoving,
      onDoubleTap: onDoubleTap,
      onTap: onTap,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderInteractiveGraphicsView renderObject,
  ) {
    if (renderObject is RenderStickyNoteAnnotationView) {
      renderObject
        ..heightPercentage = _heightPercentage
        ..selectorStorkeWidth = selectorStorkeWidth
        ..onAnnotationMoved = onAnnotationMoved
        ..onAnnotationMoving = onAnnotationMoving
        .._onDoubleTap = onDoubleTap
        .._onTap = onTap;
    }
    super.updateRenderObject(context, renderObject);
  }

  @override
  final StickyNoteAnnotation annotation;
}

/// A render object widget representing a text markup annotation.
class RenderStickyNoteAnnotationView extends RenderInteractiveGraphicsView {
  /// Creates a [RenderStickyNoteAnnotationView].
  RenderStickyNoteAnnotationView({
    required this.stickyNoteAnnotation,
    required Color color,
    required double opacity,
    required bool isSelected,
    Color selectorColor = defaultSelectorColor,
    double selectorStorkeWidth = selectionBorderThickness,
    this.onAnnotationMoved,
    this.onAnnotationMoving,
    VoidCallback? onTap,
    void Function()? onDoubleTap,
    double heightPercentage = 1,
  })  : _onDoubleTap = onDoubleTap,
        super(
          strokeColor: color,
          opacity: opacity,
          strokeWidth: 1,
          isSelected: isSelected,
          selectorColor: selectorColor,
          selectorStorkeWidth: selectorStorkeWidth,
        ) {
    _onTap = onTap;
    _heightPercentage = heightPercentage;
    _selectorStorkeWidth = selectorStorkeWidth;

    _doubleTapGestureRecognizer = DoubleTapGestureRecognizer()
      ..onDoubleTap = _onDoubleTap
      ..gestureSettings = const DeviceGestureSettings(touchSlop: 0.0);
    super.tapGestureRecognizer.gestureSettings = const DeviceGestureSettings(
      touchSlop: 0.0,
    );
    _strokePath = Path();
    _fillPath = Path();
  }

  late double _heightPercentage;
  late DoubleTapGestureRecognizer _doubleTapGestureRecognizer;
  late Path _fillPath;
  late Path _strokePath;
  late double _selectorStorkeWidth;

  /// The height percentage.
  double get heightPercentage => _heightPercentage;
  set heightPercentage(double value) {
    if (_heightPercentage == value) {
      return;
    }
    _heightPercentage = value;
    markNeedsPaint();
  }

  /// The selector stroke width.
  @override
  double get selectorStorkeWidth => _selectorStorkeWidth;
  @override
  set selectorStorkeWidth(double value) {
    if (_selectorStorkeWidth == value) {
      return;
    }
    _selectorStorkeWidth = value;
    markNeedsPaint();
  }

  /// The annotation to be rendered.
  final StickyNoteAnnotation stickyNoteAnnotation;

  /// Called when the annotation is moved.
  AnnotationMoveEndedCallback? onAnnotationMoved;

  /// Called when the annotation is moving.
  AnnotationMovingCallback? onAnnotationMoving;

  /// Called when the annotation is tapped.
  VoidCallback? _onTap;

  /// Called when the annotation is double tapped.
  VoidCallback? _onDoubleTap;

  Rect get _bounds {
    return stickyNoteAnnotation.uiBounds;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    _applyRotationTransform(canvas, stickyNoteAnnotation.pageRotation, offset);
    _drawStickyNoteIcon(canvas, offset);
    super.paint(context, offset);
    canvas.restore();
  }

  Rect _getPaintRect(Rect rect, Offset offset) {
    final Rect localRect = rect.translate(-_bounds.left, -_bounds.top);
    final Offset globalOffset = Offset(
      offset.dx + localRect.left / heightPercentage,
      offset.dy + localRect.top / heightPercentage,
    );
    return globalOffset & (localRect.size / heightPercentage);
  }

  void _applyRotationTransform(Canvas canvas, int rotation, Offset offset) {
    final double centerX = offset.dx + paintBounds.width / 2;
    final double centerY = offset.dy + paintBounds.height / 2;
    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.rotate(-rotation * math.pi / 180);
    canvas.translate(-centerX, -centerY);
  }

  void _drawStickyNoteIcon(Canvas canvas, Offset offset) {
    final Paint fillPaint = Paint();
    fillPaint.color = color.withValues(alpha: opacity);
    fillPaint.style = PaintingStyle.fill;

    final Paint strokePaint = Paint()
      ..color = Colors.black.withValues(alpha: opacity)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final Rect paintRect = _getPaintRect(
      stickyNoteAnnotation.isSelected
          ? stickyNoteAnnotation.intermediateBounds
          : stickyNoteAnnotation.boundingBox,
      offset,
    );
    canvas.save();

    _fillPath.reset();
    _strokePath.reset();

    switch (stickyNoteAnnotation.icon) {
      case PdfStickyNoteIcon.comment:
        _fillPath = Path()
          ..moveTo(0, 3)
          ..cubicTo(0, 0.89543, 0.89543, 0, 3, 0)
          ..lineTo(23, 0)
          ..cubicTo(24.1046, 0, 25, 0.89543, 25, 3)
          ..lineTo(25, 24)
          ..lineTo(20.7868, 19.7499)
          ..cubicTo(20.4113, 19.371, 19.8999, 19.1579, 19.3665, 19.1579)
          ..lineTo(3, 19.1579)
          ..cubicTo(0.89543, 19.1579, 0, 18.2625, 0, 17.1579)
          ..lineTo(0, 3)
          ..close();
        _strokePath = Path()
          ..moveTo(5, 7)
          ..lineTo(21, 7)
          ..moveTo(5, 12)
          ..lineTo(21, 12)
          ..moveTo(25, 24)
          ..lineTo(25, 3)
          ..cubicTo(25, 0.89543, 24.1046, 0, 23, 0)
          ..lineTo(3, 0)
          ..cubicTo(0.89543, 0, 0, 0.89543, 0, 3)
          ..lineTo(0, 17.1579)
          ..cubicTo(0, 18.2625, 0.89543, 19.1579, 3, 19.1579)
          ..lineTo(19.3665, 19.1579)
          ..cubicTo(19.8999, 19.1579, 20.4113, 19.371, 20.7868, 19.7499)
          ..lineTo(25, 24)
          ..close();
        break;
      case PdfStickyNoteIcon.note:
        _fillPath = Path()
          ..moveTo(0, 23)
          ..lineTo(0, 0)
          ..lineTo(23, 0)
          ..lineTo(23, 13)
          ..lineTo(13, 23)
          ..lineTo(0, 23)
          ..close();
        _strokePath = Path()
          ..moveTo(13, 23)
          ..lineTo(0, 23)
          ..lineTo(0, 0)
          ..lineTo(23, 0)
          ..lineTo(23, 13)
          ..moveTo(13, 23)
          ..lineTo(23, 13)
          ..moveTo(13, 23)
          ..lineTo(13, 13)
          ..lineTo(23, 13);
        break;
      case PdfStickyNoteIcon.help:
        _fillPath = Path()
          ..moveTo(23, 12)
          ..cubicTo(23, 18.0751, 18.0751, 23, 12, 23)
          ..cubicTo(5.92487, 23, 0, 18.0751, 0, 12)
          ..cubicTo(0, 5.92487, 5.92487, 0, 12, 0)
          ..cubicTo(18.0751, 0, 23, 5.92487, 23, 12)
          ..close();
        _strokePath = Path()
          ..moveTo(8.5, 10)
          ..cubicTo(8.5, 8.93913, 8.86875, 7.92172, 9.52513, 7.17157)
          ..cubicTo(10.1815, 6.42143, 11.0717, 6, 12, 6)
          ..cubicTo(12.9283, 6, 13.8185, 6.42143, 14.4749, 7.17157)
          ..cubicTo(15.1313, 7.92172, 15.5, 8.5, 15.5, 9.5)
          ..cubicTo(15.5, 12.5, 12, 11.7106, 12, 14)
          ..lineTo(12, 15)
          ..moveTo(12, 19)
          ..lineTo(12, 17)
          ..moveTo(23, 12)
          ..cubicTo(23, 18.0751, 18.0751, 23, 12, 23)
          ..cubicTo(5.92487, 23, 0, 18.0751, 0, 12)
          ..cubicTo(0, 5.92487, 5.92487, 0, 12, 0)
          ..cubicTo(18.0751, 0, 23, 5.92487, 23, 12)
          ..close();
        break;
      case PdfStickyNoteIcon.insert:
        _fillPath = Path()
          ..moveTo(0, 40)
          ..lineTo(20, 0)
          ..lineTo(40, 40)
          ..close();
        _strokePath = Path()
          ..moveTo(0, 40)
          ..lineTo(20, 0)
          ..lineTo(40, 40)
          ..close();
        break;
      case PdfStickyNoteIcon.key:
        _fillPath = _strokePath = Path()
          ..moveTo(7, 0)
          ..cubicTo(3.68629, 0, 0, 3.68629, 0, 7)
          ..cubicTo(0, 9.22085, 2.2066, 11.1599, 4, 12.1973)
          ..lineTo(4, 21)
          ..lineTo(7, 22.5)
          ..lineTo(9, 21)
          ..lineTo(8.5, 19.5)
          ..lineTo(9.5, 18.5)
          ..lineTo(8.5, 16.5)
          ..lineTo(10, 15)
          ..lineTo(10, 12.1973)
          ..cubicTo(11.7934, 11.1599, 13, 9.22085, 13, 7)
          ..cubicTo(13, 3.68629, 10.3137, 0, 7, 0)
          ..close();
        break;
      case PdfStickyNoteIcon.newParagraph:
        _fillPath = Path()
          ..moveTo(22, 14)
          ..lineTo(0, 14)
          ..lineTo(12, 0)
          ..lineTo(22, 14)
          ..close();
        _strokePath = Path()
          ..moveTo(15, 24)
          ..lineTo(15, 21)
          ..moveTo(15, 21)
          ..lineTo(15, 18)
          ..lineTo(17.5, 18)
          ..cubicTo(18.3284, 18, 19, 18.6716, 19, 19.5)
          ..cubicTo(19, 20.3284, 18.3284, 21, 17.5, 21)
          ..lineTo(15, 21)
          ..moveTo(5, 24)
          ..lineTo(5, 18)
          ..moveTo(5, 18)
          ..lineTo(5, 17)
          ..moveTo(5, 18)
          ..lineTo(10, 23)
          ..moveTo(10, 23)
          ..lineTo(10, 17)
          ..moveTo(10, 23)
          ..lineTo(10, 24)
          ..moveTo(0, 14)
          ..lineTo(22, 14)
          ..lineTo(12, 0)
          ..lineTo(0, 14)
          ..close();
        break;
      case PdfStickyNoteIcon.paragraph:
        _fillPath = Path()
          ..moveTo(11, 14)
          ..lineTo(7.5, 14)
          ..cubicTo(3.91015, 14, 0, 11.0899, 0, 7.5)
          ..cubicTo(0, 3.91015, 3.91015, 0, 7.5, 0)
          ..lineTo(11, 0)
          ..lineTo(11, 14)
          ..close();
        _strokePath = Path()
          ..moveTo(11, 14)
          ..lineTo(7.5, 14)
          ..cubicTo(3.91015, 14, 0, 11.0899, 0, 7.5)
          ..cubicTo(0, 3.91015, 3.91015, 0, 7.5, 0)
          ..lineTo(11, 0)
          ..moveTo(11, 14)
          ..lineTo(11, 24)
          ..moveTo(11, 14)
          ..lineTo(11, 0)
          ..moveTo(24, 0)
          ..lineTo(17, 0)
          ..moveTo(17, 0)
          ..lineTo(17, 24)
          ..moveTo(17, 0)
          ..lineTo(11, 0)
          ..close();
        break;
    }

    canvas.translate(paintRect.left, paintRect.top);
    final Rect fillRect = _fillPath.getBounds();
    final Rect strokeRect = _strokePath.getBounds();
    final Rect iconRect = fillRect.expandToInclude(strokeRect);

    canvas.scale(
      paintRect.width / iconRect.width,
      paintRect.height / iconRect.height,
    );

    canvas.drawPath(_fillPath, fillPaint);
    canvas.drawPath(_strokePath, strokePaint);
    canvas.restore();
  }

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      tapGestureRecognizer.addPointer(event);
      _doubleTapGestureRecognizer.addPointer(event);
      if (canEdit) {
        panGestureRecognizer.addPointer(event);
      }
    }
  }

  @override
  void onDragUpdate(DragUpdateDetails details) {
    if (canEdit) {
      onAnnotationMoving?.call(stickyNoteAnnotation, details.delta);
    }
  }

  @override
  void onDragEnd(DragEndDetails details) {
    if (canEdit) {
      onAnnotationMoved?.call(stickyNoteAnnotation, Offset.zero);
    }
  }

  @override
  void onTap() {
    _onTap?.call();
  }
}
