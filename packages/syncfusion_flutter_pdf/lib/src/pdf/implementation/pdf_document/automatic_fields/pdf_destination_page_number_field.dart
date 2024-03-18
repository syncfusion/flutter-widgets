import 'dart:ui';

import '../../graphics/brushes/pdf_solid_brush.dart';
import '../../graphics/fonts/pdf_font.dart';
import '../../graphics/pdf_graphics.dart';
import '../../pages/pdf_page.dart';
import 'pdf_page_number_field.dart';

/// Represents class which displays destination page's number.
class PdfDestinationPageNumberField extends PdfPageNumberField {
  // constructor
  /// Initializes a new instance of the [PdfDestinationPageNumberField] class
  /// may include with [PdfFont], [PdfBrush] and [Rect].
  PdfDestinationPageNumberField(
      {PdfPage? page, super.font, super.brush, super.bounds}) {
    if (page != null) {
      this.page = page;
    }
  }

  /// Gets or sets the page.
  PdfPage? page;

  // implementation
  String _getValue(PdfGraphics graphics) {
    return PdfPageNumberFieldHelper.getHelper(this).internalGetValue(page);
  }
}

// ignore: avoid_classes_with_only_static_members
/// [PdfDestinationPageNumberField] helper
class PdfDestinationPageNumberFieldHelper {
  /// internal method
  static String getValue(
      PdfDestinationPageNumberField field, PdfGraphics graphics) {
    return field._getValue(graphics);
  }
}
