import 'dart:math' show Point, sqrt;
import 'package:flutter/material.dart';

import '../../pdfviewer.dart';
import 'annotation.dart';
import 'annotation_view.dart';

/// Represents the highlight annotation on the text contents in the page.
class HighlightAnnotation extends Annotation {
  /// Initializes a new instance of [HighlightAnnotation] class.
  ///
  /// The [textBoundsCollection] represents the bounds collection of the highlight annotations that are added in the multiple lines of text.
  HighlightAnnotation({
    required List<PdfTextLine> textBoundsCollection,
  })  : assert(textBoundsCollection.isNotEmpty),
        assert(_checkTextMarkupRects(textBoundsCollection)),
        super(pageNumber: textBoundsCollection.first.pageNumber) {
    _textMarkupRects = <Rect>[];

    double minX = textBoundsCollection.first.bounds.left,
        minY = textBoundsCollection.first.bounds.top,
        maxX = textBoundsCollection.first.bounds.right,
        maxY = textBoundsCollection.first.bounds.bottom;

    for (final PdfTextLine textLine in textBoundsCollection) {
      final Rect rect = textLine.bounds;
      _textMarkupRects.add(rect);
      minX = minX < rect.left ? minX : rect.left;
      minY = minY < rect.top ? minY : rect.top;
      maxX = maxX > rect.right ? maxX : rect.right;
      maxY = maxY > rect.bottom ? maxY : rect.bottom;
    }

    setBounds(Rect.fromLTRB(minX, minY, maxX, maxY));
  }

  late final List<Rect> _textMarkupRects;
}

/// Represents the strikethrough annotation on the text contents in the page.
class StrikethroughAnnotation extends Annotation {
  /// Initializes a new instance of [StrikethroughAnnotation] class.
  ///
  /// The [textBoundsCollection] represents the bounds collection of the strikethrough annotations that are added in the multiple lines of text.
  StrikethroughAnnotation({
    required List<PdfTextLine> textBoundsCollection,
  })  : assert(textBoundsCollection.isNotEmpty),
        assert(_checkTextMarkupRects(textBoundsCollection)),
        super(pageNumber: textBoundsCollection.first.pageNumber) {
    _textMarkupRects = <Rect>[];

    double minX = textBoundsCollection.first.bounds.left,
        minY = textBoundsCollection.first.bounds.top,
        maxX = textBoundsCollection.first.bounds.right,
        maxY = textBoundsCollection.first.bounds.bottom;

    for (final PdfTextLine textLine in textBoundsCollection) {
      final Rect rect = textLine.bounds;
      _textMarkupRects.add(rect);
      minX = minX < rect.left ? minX : rect.left;
      minY = minY < rect.top ? minY : rect.top;
      maxX = maxX > rect.right ? maxX : rect.right;
      maxY = maxY > rect.bottom ? maxY : rect.bottom;
    }

    setBounds(Rect.fromLTRB(minX, minY, maxX, maxY));
  }

  late final List<Rect> _textMarkupRects;
}

/// Represents the underline annotation on the text contents in the page.
class UnderlineAnnotation extends Annotation {
  /// Initializes a new instance of [UnderlineAnnotation] class.
  ///
  /// The [textBoundsCollection] represents the bounds collection of the underline annotations that are added in the multiple lines of text.
  UnderlineAnnotation({
    required List<PdfTextLine> textBoundsCollection,
  })  : assert(textBoundsCollection.isNotEmpty),
        assert(_checkTextMarkupRects(textBoundsCollection)),
        super(pageNumber: textBoundsCollection.first.pageNumber) {
    _textMarkupRects = <Rect>[];

    double minX = textBoundsCollection.first.bounds.left,
        minY = textBoundsCollection.first.bounds.top,
        maxX = textBoundsCollection.first.bounds.right,
        maxY = textBoundsCollection.first.bounds.bottom;

    for (final PdfTextLine textLine in textBoundsCollection) {
      final Rect rect = textLine.bounds;
      _textMarkupRects.add(rect);
      minX = minX < rect.left ? minX : rect.left;
      minY = minY < rect.top ? minY : rect.top;
      maxX = maxX > rect.right ? maxX : rect.right;
      maxY = maxY > rect.bottom ? maxY : rect.bottom;
    }

    setBounds(Rect.fromLTRB(minX, minY, maxX, maxY));
  }

  late final List<Rect> _textMarkupRects;
}

/// Represents the squiggly annotation on the text contents in the page.
class SquigglyAnnotation extends Annotation {
  /// Initializes a new instance of [SquigglyAnnotation] class.
  ///
  /// The [textBoundsCollection] represents the bounds collection of the squiggly annotations that are added in the multiple lines of text.
  SquigglyAnnotation({
    required List<PdfTextLine> textBoundsCollection,
  })  : assert(textBoundsCollection.isNotEmpty),
        assert(_checkTextMarkupRects(textBoundsCollection)),
        super(pageNumber: textBoundsCollection.first.pageNumber) {
    _textMarkupRects = <Rect>[];

    double minX = textBoundsCollection.first.bounds.left,
        minY = textBoundsCollection.first.bounds.top,
        maxX = textBoundsCollection.first.bounds.right,
        maxY = textBoundsCollection.first.bounds.bottom;

    for (final PdfTextLine textLine in textBoundsCollection) {
      final Rect rect = textLine.bounds;
      _textMarkupRects.add(rect);
      minX = minX < rect.left ? minX : rect.left;
      minY = minY < rect.top ? minY : rect.top;
      maxX = maxX > rect.right ? maxX : rect.right;
      maxY = maxY > rect.bottom ? maxY : rect.bottom;
    }

    setBounds(Rect.fromLTRB(minX, minY, maxX, maxY));
  }

  late final List<Rect> _textMarkupRects;
}

/// A widget representing a text markup annotation.
class TextMarkupAnnotationView extends InteractiveGraphicsView
    with AnnotationView {
  /// Creates a [TextMarkupAnnotationView].
  TextMarkupAnnotationView(
      {Key? key,
      required this.annotation,
      bool isSelected = false,
      Color selectorColor = defaultSelectorColor,
      double heightPercentage = 1})
      : super(
          key: key,
          color: annotation.color,
          strokeWidth: 1,
          opacity: annotation.opacity,
          isSelected: isSelected,
          selectorColor: selectorColor,
        ) {
    _textMarkupType = annotation is HighlightAnnotation
        ? TextMarkupType.highlight
        : annotation is StrikethroughAnnotation
            ? TextMarkupType.strikethrough
            : annotation is UnderlineAnnotation
                ? TextMarkupType.underline
                : TextMarkupType.squiggly;
    _heightPercentage = heightPercentage;
  }

  late final TextMarkupType _textMarkupType;

  late final double _heightPercentage;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderTextMarkupAnnotationView(
      textMarkupType: _textMarkupType,
      annotation: annotation,
      color: color,
      opacity: opacity,
      isSelected: isSelected,
      selectorColor: selectorColor,
      heightPercentage: _heightPercentage,
    );
  }

  @override
  void updateRenderObject(BuildContext context,
      covariant RenderInteractiveGraphicsView renderObject) {
    if (renderObject is RenderTextMarkupAnnotationView) {
      renderObject.heightPercentage = _heightPercentage;
    }
    super.updateRenderObject(context, renderObject);
  }

  @override
  final Annotation annotation;
}

/// A render object widget representing a text markup annotation.
class RenderTextMarkupAnnotationView extends RenderInteractiveGraphicsView {
  /// Creates a [RenderTextMarkupAnnotationView].
  RenderTextMarkupAnnotationView({
    required TextMarkupType textMarkupType,
    required this.annotation,
    required Color color,
    required double opacity,
    required bool isSelected,
    required Color selectorColor,
    double heightPercentage = 1,
  }) : super(
          strokeColor: color,
          opacity: opacity,
          strokeWidth: 1,
          isSelected: isSelected,
          selectorColor: selectorColor,
        ) {
    _textMarkupType = textMarkupType;
    _heightPercentage = heightPercentage;
  }

  late final TextMarkupType _textMarkupType;
  late double _heightPercentage;

  /// The height percentage.
  double get heightPercentage => _heightPercentage;
  set heightPercentage(double value) {
    if (_heightPercentage == value) {
      return;
    }
    _heightPercentage = value;
    markNeedsPaint();
  }

  /// The annotation to be rendered.
  final Annotation annotation;

  Rect get _bounds {
    return annotation.uiBounds;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    final Paint paint = Paint()..color = color.withOpacity(opacity);

    if (_textMarkupType == TextMarkupType.highlight) {
      _drawHighlight(canvas, paint, offset);
    } else if (_textMarkupType == TextMarkupType.strikethrough) {
      _drawStrikethrough(canvas, paint, offset);
    } else if (_textMarkupType == TextMarkupType.underline) {
      _drawUnderline(canvas, paint, offset);
    } else if (_textMarkupType == TextMarkupType.squiggly) {
      _drawSquiggly(canvas, paint, offset);
    }
    super.paint(context, offset);
  }

  Rect _getPaintRect(Rect rect, Offset offset) {
    final Rect localRect = rect.translate(-_bounds.left, -_bounds.top);
    final Offset globalOffset = Offset(
        offset.dx + localRect.left / heightPercentage,
        offset.dy + localRect.top / heightPercentage);
    return globalOffset & (localRect.size / heightPercentage);
  }

  void _drawHighlight(Canvas canvas, Paint paint, Offset offset) {
    paint.color = color.withOpacity(opacity * 0.3);
    paint.style = PaintingStyle.fill;
    final HighlightAnnotation highlightAnnotation =
        annotation as HighlightAnnotation;

    for (final Rect rect in highlightAnnotation._textMarkupRects) {
      canvas.drawRect(_getPaintRect(rect, offset), paint);
    }
  }

  void _drawStrikethrough(Canvas canvas, Paint paint, Offset offset) {
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = strokeWidth / heightPercentage;
    for (final Rect rect
        in (annotation as StrikethroughAnnotation)._textMarkupRects) {
      final Rect strikethroughRect = _getPaintRect(rect, offset);
      canvas.drawLine(
          strikethroughRect.centerLeft, strikethroughRect.centerRight, paint);
    }
  }

  void _drawUnderline(Canvas canvas, Paint paint, Offset offset) {
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = strokeWidth / heightPercentage;
    for (final Rect rect
        in (annotation as UnderlineAnnotation)._textMarkupRects) {
      final Rect underlineRect = _getPaintRect(rect, offset);
      canvas.drawLine(
          underlineRect.bottomLeft, underlineRect.bottomRight, paint);
    }
  }

  void _drawSquiggly(Canvas canvas, Paint paint, Offset offset) {
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = strokeWidth / heightPercentage;
    for (final Rect rect
        in (annotation as SquigglyAnnotation)._textMarkupRects) {
      final Rect squigglyRect = _getPaintRect(rect, offset);

      canvas.drawPath(
          _getSquigglyPath(
              Point<double>(
                  squigglyRect.bottomLeft.dx, squigglyRect.bottomRight.dy),
              Point<double>(
                  squigglyRect.bottomRight.dx, squigglyRect.bottomRight.dy),
              squigglyRect.height),
          paint);
    }
  }

  Path _getSquigglyPath(
      Point<double> startPoint, Point<double> endPoint, double height) {
    final double dx = startPoint.x - endPoint.x;
    final double dy = startPoint.y - endPoint.y;
    final double length = sqrt(dx * dx + dy * dy);
    final double x = startPoint.x;
    final double y = startPoint.y;
    bool showUnderlineAtStart = false;
    final double spacing = height * 0.18;
    final Path squigglyPath = Path();
    squigglyPath.moveTo(x, y);
    for (double distance = 0;
        distance + spacing < length;
        distance += spacing) {
      if (showUnderlineAtStart) {
        squigglyPath.lineTo(x + distance + spacing, y);
      } else {
        squigglyPath.lineTo(x + distance + spacing, y - spacing);
      }
      showUnderlineAtStart = !showUnderlineAtStart;
    }
    return squigglyPath;
  }

  @override
  bool hitTestSelf(Offset position) => false;
}

/// Highlight Annotation Extension
extension HighlightAnnotationExtension on HighlightAnnotation {
  /// The list of text markup rectangles.
  List<Rect> get textMarkupRects => _textMarkupRects;
}

/// Underline Annotation Extension
extension UnderlineAnnotationExtension on UnderlineAnnotation {
  /// The list of text markup rectangles.
  List<Rect> get textMarkupRects => _textMarkupRects;
}

/// Strikethrough Annotation Extension
extension StrikethroughAnnotationExtension on StrikethroughAnnotation {
  /// The list of text markup rectangles.
  List<Rect> get textMarkupRects => _textMarkupRects;
}

/// Squiggly Annotation Extension
extension SquigglyAnnotationExtension on SquigglyAnnotation {
  /// The list of text markup rectangles.
  List<Rect> get textMarkupRects => _textMarkupRects;
}

/// Asserts whether the text markup rectangles are valid.
bool _checkTextMarkupRects(List<PdfTextLine> textMarkupRects) {
  int pageNumber = textMarkupRects.first.pageNumber;
  for (final PdfTextLine textLine in textMarkupRects) {
    if (pageNumber <= 0 && textLine.pageNumber != pageNumber) {
      return false;
    }
    if (textLine.bounds.isEmpty || textLine.bounds.isInfinite) {
      return false;
    }
    pageNumber = textLine.pageNumber;
  }
  return true;
}

/// Enumerates the values that represent the type of text markup annotation.
enum TextMarkupType {
  /// Highlight
  highlight,

  /// Underline
  underline,

  /// Strikethrough
  strikethrough,

  /// Squiggly
  squiggly,
}
