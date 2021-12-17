import 'dart:ui';

import '../../drawing/drawing.dart';
import '../../graphics/brushes/pdf_solid_brush.dart';
import '../../graphics/figures/pdf_template.dart';
import '../../graphics/fonts/pdf_font.dart';
import '../../graphics/pdf_graphics.dart';
import 'pdf_automatic_field.dart';

/// internal class
abstract class PdfStaticField extends PdfAutomaticField {
  // constructor
  /// Represents automatic field which value can be evaluated
  /// in the moment of creation.
  PdfStaticField({PdfFont? font, PdfBrush? brush, Rect? bounds}) {
    PdfAutomaticFieldHelper(this).internal(font, brush: brush, bounds: bounds);
  }

  // fields
  PdfTemplate? _template;
  final List<PdfGraphics> _graphicsList = <PdfGraphics>[];

  // implementation
  void _performDraw(PdfGraphics graphics, PdfPoint? location, double scalingX,
      double scalingY) {
    final String? value =
        PdfAutomaticFieldHelper.getHelper(this).getValue(graphics);
    final Offset drawLocation =
        Offset(location!.x + bounds.left, location.y + bounds.top);

    if (_template == null) {
      _template = PdfTemplate(
          PdfAutomaticFieldHelper.getHelper(this).obtainSize().width,
          PdfAutomaticFieldHelper.getHelper(this).obtainSize().height);
      _template!.graphics!.drawString(value!, font,
          pen: pen,
          brush: brush,
          bounds: Rect.fromLTWH(
              0,
              0,
              PdfAutomaticFieldHelper.getHelper(this).obtainSize().width,
              PdfAutomaticFieldHelper.getHelper(this).obtainSize().height),
          format: stringFormat);
      graphics.drawPdfTemplate(
          _template!,
          drawLocation,
          Size(_template!.size.width * scalingX,
              _template!.size.height * scalingY));
      _graphicsList.add(graphics);
    } else {
      if (!_graphicsList.contains(graphics)) {
        graphics.drawPdfTemplate(
            _template!,
            drawLocation,
            Size(_template!.size.width * scalingX,
                _template!.size.height * scalingY));
        _graphicsList.add(graphics);
      }
    }
  }
}

// ignore: avoid_classes_with_only_static_members
/// [PdfStaticField] helper
class PdfStaticFieldHelper {
  /// internal method
  static void performDraw(PdfStaticField staticField, PdfGraphics graphics,
      PdfPoint? location, double scalingX, double scalingY) {
    staticField._performDraw(graphics, location, scalingX, scalingY);
  }
}
