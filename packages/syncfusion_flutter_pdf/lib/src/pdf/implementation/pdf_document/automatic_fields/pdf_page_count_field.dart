import 'dart:ui';

import '../../graphics/brushes/pdf_solid_brush.dart';
import '../../graphics/fonts/pdf_font.dart';
import '../../graphics/pdf_graphics.dart';
import '../../pages/enum.dart';
import '../../pages/pdf_page.dart';
import '../../pages/pdf_section.dart';
import '../../pages/pdf_section_collection.dart';
import '../pdf_document.dart';
import 'pdf_automatic_field.dart';
import 'pdf_dynamic_field.dart';
import 'pdf_single_value_field.dart';

/// Represents total PDF document page count automatic field.
/// Represents an automatic field to display total number of pages
/// in section(if set isSectionPageCount as true).
/// ```dart
/// //Create a new pdf document
/// PdfDocument document = PdfDocument();
/// //Add the pages to the document
/// for (int i = 1; i <= 5; i++) {
///   document.pages.add().graphics.drawString(
///       'page$i', PdfStandardFont(PdfFontFamily.timesRoman, 11),
///       bounds: Rect.fromLTWH(250, 0, 615, 100));
/// }
/// //Create the footer with specific bounds
/// PdfPageTemplateElement footer = PdfPageTemplateElement(
///     Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 50));
/// //Create the page count field
/// PdfPageCountField count = PdfPageCountField(
///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
///     brush: PdfSolidBrush(PdfColor(0, 0, 0)));
/// //set the number style for page count
/// count.numberStyle = PdfNumberStyle.upperRoman;
/// //Create the composite field with page number page count
/// PdfCompositeField compositeField = PdfCompositeField(
///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
///     text: 'Page Count: {0}',
///     fields: <PdfAutomaticField>[count]);
/// compositeField.bounds = footer.bounds;
/// //Add the composite field in footer
/// compositeField.draw(
///     footer.graphics,
///     Offset(
///         290, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 19).height));
/// //Add the footer at the bottom of the document
/// document.template.bottom = footer;
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfPageCountField extends PdfSingleValueField {
  // constructor
  /// Initializes a new instance of the [PdfPageCountField] class
  /// and may also with the classes are [PdfFont], [PdfBrush] and [Rect].
  /// ```dart
  /// //Create a new pdf document
  /// PdfDocument document = PdfDocument();
  /// //Add the pages to the document
  /// for (int i = 1; i <= 5; i++) {
  ///   document.pages.add().graphics.drawString(
  ///       'page$i', PdfStandardFont(PdfFontFamily.timesRoman, 11),
  ///       bounds: Rect.fromLTWH(250, 0, 615, 100));
  /// }
  /// //Create the footer with specific bounds
  /// PdfPageTemplateElement footer = PdfPageTemplateElement(
  ///     Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 50));
  /// //Create the page count field
  /// PdfPageCountField count = PdfPageCountField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  /// //set the number style for page count
  /// count.numberStyle = PdfNumberStyle.upperRoman;
  /// //Create the composite field with page number page count
  /// PdfCompositeField compositeField = PdfCompositeField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     text: 'Page Count: {0}',
  ///     fields: <PdfAutomaticField>[count]);
  /// compositeField.bounds = footer.bounds;
  /// //Add the composite field in footer
  /// compositeField.draw(
  ///     footer.graphics,
  ///     Offset(
  ///         290, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 19).height));
  /// //Add the footer at the bottom of the document
  /// document.template.bottom = footer;
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfPageCountField(
      {PdfFont? font, PdfBrush? brush, Rect? bounds, bool? isSectionPageCount})
      : super(font, brush, bounds) {
    _isSectionPageCount = isSectionPageCount != null && isSectionPageCount;
  }

  // fields
  /// Gets or sets the specific number style.
  /// ```dart
  /// //Create a new pdf document
  /// PdfDocument document = PdfDocument();
  /// //Add the pages to the document
  /// for (int i = 1; i <= 5; i++) {
  ///   document.pages.add().graphics.drawString(
  ///       'page$i', PdfStandardFont(PdfFontFamily.timesRoman, 11),
  ///       bounds: Rect.fromLTWH(250, 0, 615, 100));
  /// }
  /// //Create the footer with specific bounds
  /// PdfPageTemplateElement footer = PdfPageTemplateElement(
  ///     Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 50));
  /// //Create the page count field
  /// PdfPageCountField count = PdfPageCountField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  /// //Gets or Sets the number style for page count
  /// count.numberStyle = PdfNumberStyle.upperRoman;
  /// //Create the composite field with page number page count
  /// PdfCompositeField compositeField = PdfCompositeField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     text: 'Page Count: {0}',
  ///     fields: <PdfAutomaticField>[count]);
  /// compositeField.bounds = footer.bounds;
  /// //Add the composite field in footer
  /// compositeField.draw(
  ///     footer.graphics,
  ///     Offset(
  ///         290, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 19).height));
  /// //Add the footer at the bottom of the document
  /// document.template.bottom = footer;
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfNumberStyle numberStyle = PdfNumberStyle.numeric;

  /// Represents an automatic field to display total number of pages in section.
  bool _isSectionPageCount = false;

  // implementation
  String? _getValue(PdfGraphics graphics) {
    String? result;
    if (PdfGraphicsHelper.getHelper(graphics).page is PdfPage) {
      final PdfPage page = PdfDynamicField.getPageFromGraphics(graphics);
      if (_isSectionPageCount) {
        final PdfSection section = PdfPageHelper.getHelper(page).section!;
        final int count = PdfSectionHelper.getHelper(section).count;
        return PdfAutomaticFieldHelper.convert(count, numberStyle);
      } else {
        final PdfDocument document = PdfSectionCollectionHelper.getHelper(
                PdfSectionHelper.getHelper(
                        PdfPageHelper.getHelper(page).section!)
                    .parent!)
            .document!;
        final int number = document.pages.count;
        return PdfAutomaticFieldHelper.convert(number, numberStyle);
      }
    }
    return result;
  }
}

// ignore: avoid_classes_with_only_static_members
/// [PdfPageCountField] helper
class PdfPageCountFieldHelper {
  /// internal method
  static String? getValue(PdfPageCountField field, PdfGraphics graphics) {
    return field._getValue(graphics);
  }
}
