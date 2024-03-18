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
import 'pdf_multiple_value_field.dart';

/// Represents PDF document page number field.
/// Represents an automatic field to display page number within a section.
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
/// //Create the page number field
/// PdfPageNumberField pageNumber = PdfPageNumberField(
///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
///     brush: PdfSolidBrush(PdfColor(0, 0, 0)));
/// //Sets the number style for page number
/// pageNumber.numberStyle = PdfNumberStyle.upperRoman;
/// //Create the composite field with page number page count
/// PdfCompositeField compositeField = PdfCompositeField(
///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
///     text: 'Page No: {0}',
///     fields: <PdfAutomaticField>[pageNumber]);
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
class PdfPageNumberField extends PdfMultipleValueField {
  // constructor
  /// Initializes a new instance of the [PdfPageNumberField] class
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
  /// //Create the page number field
  /// PdfPageNumberField pageNumber = PdfPageNumberField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  /// //Sets the number style for page number
  /// pageNumber.numberStyle = PdfNumberStyle.upperRoman;
  /// //Create the composite field with page number page count
  /// PdfCompositeField compositeField = PdfCompositeField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     text: 'Page No: {0}',
  ///     fields: <PdfAutomaticField>[pageNumber]);
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
  PdfPageNumberField(
      {super.font, super.brush, super.bounds, bool? isSectionPageNumber}) {
    _helper = PdfPageNumberFieldHelper(this);
    _helper._isSectionPageNumber =
        isSectionPageNumber != null && isSectionPageNumber;
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
  /// //Create the page number field
  /// PdfPageNumberField pageNumber = PdfPageNumberField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  /// //Sets the number style for page number
  /// pageNumber.numberStyle = PdfNumberStyle.upperRoman;
  /// //Create the composite field with page number page count
  /// PdfCompositeField compositeField = PdfCompositeField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     text: 'Page No: {0}',
  ///     fields: <PdfAutomaticField>[pageNumber]);
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
  late PdfPageNumberFieldHelper _helper;
}

/// [PdfPageNumberField] helper
class PdfPageNumberFieldHelper {
  /// internal constructor
  PdfPageNumberFieldHelper(this.base);

  /// internal field
  PdfPageNumberField base;

  /// Represents an automatic field to display page number within a section.
  bool _isSectionPageNumber = false;

  /// internal method
  static PdfPageNumberFieldHelper getHelper(PdfPageNumberField field) {
    return field._helper;
  }

  /// internal method
  String? getValue(PdfGraphics graphics) {
    String? result;
    if (PdfGraphicsHelper.getHelper(graphics).page is PdfPage) {
      final PdfPage page = PdfDynamicField.getPageFromGraphics(graphics);
      result = internalGetValue(page);
    }
    return result;
  }

  /// internal method
  String internalGetValue(PdfPage? page) {
    if (_isSectionPageNumber) {
      final PdfSection section = PdfPageHelper.getHelper(page!).section!;
      final int index = PdfSectionHelper.getHelper(section).indexOf(page) + 1;
      return PdfAutomaticFieldHelper.convert(index, base.numberStyle);
    } else {
      final PdfDocument document = PdfSectionCollectionHelper.getHelper(
              PdfSectionHelper.getHelper(
                      PdfPageHelper.getHelper(page!).section!)
                  .parent!)
          .document!;
      final int pageIndex = document.pages.indexOf(page) + 1;
      return PdfAutomaticFieldHelper.convert(pageIndex, base.numberStyle);
    }
  }
}
