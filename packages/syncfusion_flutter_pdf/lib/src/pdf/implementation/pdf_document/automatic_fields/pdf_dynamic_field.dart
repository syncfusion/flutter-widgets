import 'dart:ui';

import '../../graphics/brushes/pdf_solid_brush.dart';
import '../../graphics/fonts/pdf_font.dart';
import '../../graphics/pdf_graphics.dart';
import '../../pages/pdf_page.dart';
import 'pdf_automatic_field.dart';

/// Represents class which can concatenate multiple automatic fields
/// into single string.
abstract class PdfDynamicField extends PdfAutomaticField {
  // constructor
  /// internal constructor
  PdfDynamicField({PdfFont? font, Rect? bounds, PdfBrush? brush}) {
    PdfAutomaticFieldHelper(this).internal(font, bounds: bounds, brush: brush);
  }

  // public methods
  /// internal method
  static PdfPage getPageFromGraphics(PdfGraphics graphics) {
    final PdfPage? page = PdfGraphicsHelper.getHelper(graphics).page;
    ArgumentError.checkNotNull(page, 'page');
    return page!;
  }
}
