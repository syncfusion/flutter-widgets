import 'dart:ui';

import '../../drawing/drawing.dart';
import '../../graphics/brushes/pdf_solid_brush.dart';
import '../../graphics/figures/pdf_template.dart';
import '../../graphics/fonts/pdf_font.dart';
import '../../graphics/pdf_graphics.dart';
import 'pdf_automatic_field.dart';
import 'pdf_dynamic_field.dart';
import 'pdf_template_value_pair.dart';

/// internal class
abstract class PdfMultipleValueField extends PdfDynamicField {
  // constructor
  /// internal constructor
  PdfMultipleValueField({PdfFont? font, PdfBrush? brush, Rect? bounds})
      : super(font: font, bounds: bounds, brush: brush);

  // fields
  final Map<PdfGraphics, PdfTemplateValuePair> _list =
      <PdfGraphics, PdfTemplateValuePair>{};

  // implementation
  void _performDraw(PdfGraphics graphics, PdfPoint? _location, double scalingX,
      double scalingY) {
    final String? value =
        PdfAutomaticFieldHelper.getHelper(this).getValue(graphics);
    if (_list.containsKey(graphics)) {
      final PdfTemplateValuePair pair = _list[graphics]!;
      if (pair.value != value) {
        final Size size = PdfAutomaticFieldHelper.getHelper(this).obtainSize();
        pair.template.reset(size.width, size.height);
        pair.template.graphics!.drawString(value!, font,
            pen: pen,
            brush: brush,
            bounds: Rect.fromLTWH(0, 0, size.width, size.height),
            format: stringFormat);
      }
    } else {
      final PdfTemplate template = PdfTemplate(
          PdfAutomaticFieldHelper.getHelper(this).obtainSize().width,
          PdfAutomaticFieldHelper.getHelper(this).obtainSize().height);
      _list[graphics] = PdfTemplateValuePair(template, value!);
      template.graphics!.drawString(value, font,
          pen: pen,
          brush: brush,
          bounds: Rect.fromLTWH(
              0,
              0,
              PdfAutomaticFieldHelper.getHelper(this).obtainSize().width,
              PdfAutomaticFieldHelper.getHelper(this).obtainSize().height),
          format: stringFormat);
      final Offset drawLocation =
          Offset(_location!.x + bounds.left, _location.y + bounds.top);
      graphics.drawPdfTemplate(
          template,
          drawLocation,
          Size(
              template.size.width * scalingX, template.size.height * scalingY));
    }
  }
}

// ignore: avoid_classes_with_only_static_members
/// [PdfMultipleValueField] helper
class PdfMultipleValueFieldHelper {
  /// internal method
  static void performDraw(PdfMultipleValueField field, PdfGraphics graphics,
      PdfPoint? _location, double scalingX, double scalingY) {
    field._performDraw(graphics, _location, scalingX, scalingY);
  }
}
