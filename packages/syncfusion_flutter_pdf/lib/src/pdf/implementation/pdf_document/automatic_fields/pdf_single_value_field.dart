import 'dart:ui';

import '../../drawing/drawing.dart';
import '../../graphics/brushes/pdf_solid_brush.dart';
import '../../graphics/figures/pdf_template.dart';
import '../../graphics/fonts/pdf_font.dart';
import '../../graphics/pdf_graphics.dart';
import '../../pages/pdf_page.dart';
import '../pdf_document.dart';
import 'pdf_automatic_field.dart';
import 'pdf_dynamic_field.dart';
import 'pdf_template_value_pair.dart';

/// internal class
abstract class PdfSingleValueField extends PdfDynamicField {
  // constructor
  /// internal constructor
  PdfSingleValueField([PdfFont? font, PdfBrush? brush, Rect? bounds])
      : super(font: font, bounds: bounds, brush: brush);

  // field
  final Map<PdfDocument?, PdfTemplateValuePair> _list =
      <PdfDocument?, PdfTemplateValuePair>{};
  final List<PdfGraphics> _painterGraphics = <PdfGraphics>[];

  // implementation
  void _performDraw(PdfGraphics graphics, PdfPoint? location, double scalingX,
      double scalingY) {
    if (PdfGraphicsHelper.getHelper(graphics).page is PdfPage) {
      final PdfPage page = PdfDynamicField.getPageFromGraphics(graphics);
      final PdfDocument? document = PdfPageHelper.getHelper(page).document;
      final String? value =
          PdfAutomaticFieldHelper.getHelper(this).getValue(graphics);

      if (_list.containsKey(document)) {
        final PdfTemplateValuePair pair = _list[document]!;
        if (pair.value != value) {
          final Size size =
              PdfAutomaticFieldHelper.getHelper(this).obtainSize();
          pair.template.reset(size.width, size.height);
          pair.template.graphics!.drawString(value!, font,
              pen: pen,
              brush: brush,
              bounds: bounds.topLeft & size,
              format: stringFormat);
        }

        if (!_painterGraphics.contains(graphics)) {
          final Offset drawLocation =
              Offset(location!.x + bounds.left, location.y + bounds.top);
          graphics.drawPdfTemplate(
              pair.template,
              drawLocation,
              Size(pair.template.size.width * scalingX,
                  pair.template.size.height * scalingY));
          _painterGraphics.add(graphics);
        }
      } else {
        final PdfTemplate template = PdfTemplate(
            PdfAutomaticFieldHelper.getHelper(this).obtainSize().width,
            PdfAutomaticFieldHelper.getHelper(this).obtainSize().height);
        _list[document] = PdfTemplateValuePair(template, value!);
        final PdfTemplateValuePair pair = _list[document]!;
        template.graphics!.drawString(value, font,
            pen: pen,
            brush: brush,
            bounds: Rect.fromLTWH(
                bounds.left, bounds.top, bounds.width, bounds.height),
            format: stringFormat);
        final Offset drawLocation =
            Offset(location!.x + bounds.left, location.y + bounds.top);
        graphics.drawPdfTemplate(
            pair.template,
            drawLocation,
            Size(pair.template.size.width * scalingX,
                pair.template.size.height * scalingY));
        _painterGraphics.add(graphics);
      }
    }
  }
}

// ignore: avoid_classes_with_only_static_members
/// [PdfSingleValueField] value
class PdfSingleValueFieldHelper {
  /// internal method
  static void performDraw(PdfSingleValueField field, PdfGraphics graphics,
      PdfPoint? location, double scalingX, double scalingY) {
    field._performDraw(graphics, location, scalingX, scalingY);
  }
}
