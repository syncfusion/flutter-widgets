import 'dart:ui';

import '../graphics/brushes/pdf_solid_brush.dart';
import '../graphics/pdf_pen.dart';
import 'enum.dart';

/// internal class
class PaintParams {
  /// internal constructor
  PaintParams(
      {this.backBrush,
      this.foreBrush,
      this.borderPen,
      this.bounds,
      this.style,
      this.borderWidth,
      this.shadowBrush});

  /// internal field
  PdfBrush? backBrush;

  /// internal field
  PdfBrush? foreBrush;

  /// internal field
  PdfPen? borderPen;

  /// internal field
  Rect? bounds;

  /// internal field
  PdfBorderStyle? style;

  /// internal field
  int? borderWidth;

  /// internal field
  PdfBrush? shadowBrush;
}
