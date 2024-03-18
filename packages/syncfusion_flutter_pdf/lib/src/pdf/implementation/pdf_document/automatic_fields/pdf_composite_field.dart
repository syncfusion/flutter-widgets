import '../../graphics/fonts/pdf_font.dart';
import '../../graphics/pdf_graphics.dart';
import 'pdf_automatic_field.dart';
import 'pdf_multiple_value_field.dart';

/// Represents class which can concatenate multiple
/// automatic fields into single string.
/// ```dart
/// //Create a new pdf document
/// PdfDocument document = PdfDocument();
/// //Add the pages to the document
/// for (int i = 1; i <= 5; i++) {
///   document.pages.add().graphics.drawString(
///       'page$i', PdfStandardFont(PdfFontFamily.timesRoman, 11),
///       bounds: Rect.fromLTWH(250, 0, 615, 100));
/// }
/// //Create the header with specific bounds
/// PdfPageTemplateElement header = PdfPageTemplateElement(
///     Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 300));
/// //Create the date and time field
/// PdfDateTimeField dateAndTimeField = PdfDateTimeField(
///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
///     brush: PdfSolidBrush(PdfColor(0, 0, 0)));
/// //Create the composite field with date field
/// PdfCompositeField compositefields = PdfCompositeField(
///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
///      text: '{0}       Header',
///     fields: <PdfAutomaticField>[dateAndTimeField]);
/// //Add composite field in header
/// compositefields.draw(header.graphics,
///     Offset(0, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 11).height));
/// //Add the header at top of the document
/// document.template.top = header;
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfCompositeField extends PdfMultipleValueField {
  // constructor
  /// Initializes the new instance of the [PdfCompositeField] class.
  ///
  /// [font] - Specifies the [PdfFont] to use.
  /// [brush] - Specifies the color and texture to the text.
  /// [text] - The wide-chracter string to be drawn.
  /// [fields] - The list of [PdfAutomaticField] objects.
  /// ```dart
  /// //Create a new pdf document
  /// PdfDocument document = PdfDocument();
  /// //Add the pages to the document
  /// for (int i = 1; i <= 5; i++) {
  ///   document.pages.add().graphics.drawString(
  ///       'page$i', PdfStandardFont(PdfFontFamily.timesRoman, 11),
  ///       bounds: Rect.fromLTWH(250, 0, 615, 100));
  /// }
  /// //Create the header with specific bounds
  /// PdfPageTemplateElement header = PdfPageTemplateElement(
  ///     Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 300));
  /// //Create the date and time field
  /// PdfDateTimeField dateAndTimeField = PdfDateTimeField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  /// //Create the composite field with date field
  /// PdfCompositeField compositefields = PdfCompositeField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     text: '{0}      Header',
  ///     fields: <PdfAutomaticField>[dateAndTimeField]);
  /// //Add composite field in header
  /// compositefields.draw(header.graphics,
  ///     Offset(0, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 11).height));
  /// //Add the header at top of the document
  /// document.template.top = header;
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfCompositeField(
      {super.font,
      super.brush,
      String? text,
      List<PdfAutomaticField>? fields}) {
    this.text = (text == null) ? '' : text;
    if (fields != null) {
      this.fields = fields;
    }
  }

  // field
  /// Internal variable to store list of automatic fields.
  List<PdfAutomaticField>? _fields;

  // properties
  /// Get or set the text for user format to display the page details
  /// (eg. Input text:page {0} of {1} as dispalyed to page 1 of 5)
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
  /// PdfPageTemplateElement footer =
  ///     PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 50));
  /// //Create the page number field
  /// PdfPageNumberField pageNumber = PdfPageNumberField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  /// //Sets the number style for page number
  /// pageNumber.numberStyle = PdfNumberStyle.upperRoman;
  /// //Create the composite field
  /// PdfCompositeField compositeField = PdfCompositeField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  /// //Set text to composite field.
  /// compositeField.text = 'Page {0}';
  /// //Add page number field to composite fields
  /// compositeField.fields.add(pageNumber);
  /// //Set bounds to composite field.
  /// compositeField.bounds = footer.bounds;
  /// //Add the composite field in footer
  /// compositeField.draw(footer.graphics,
  ///     Offset(290, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 19).height));
  /// //Add the footer at the bottom of the document
  /// document.template.bottom = footer;
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  String text = '';

  /// Gets or sets the automatic fields(like page number, page count and etc.,)
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
  /// PdfPageTemplateElement footer =
  ///     PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 50));
  /// //Create the page number field
  /// PdfPageNumberField pageNumber = PdfPageNumberField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  /// //Sets the number style for page number
  /// pageNumber.numberStyle = PdfNumberStyle.upperRoman;
  /// //Create the composite field
  /// PdfCompositeField compositeField = PdfCompositeField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  /// //Set text to composite field.
  /// compositeField.text = 'Page {0}';
  /// //Sets page number field to composite fields
  /// compositeField.fields = <PdfAutomaticField>[pageNumber];
  /// //Set bounds to composite field.
  /// compositeField.bounds = footer.bounds;
  /// //Add the composite field in footer
  /// compositeField.draw(footer.graphics,
  ///     Offset(290, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 19).height));
  /// //Add the footer at the bottom of the document
  /// document.template.bottom = footer;
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  List<PdfAutomaticField> get fields {
    _fields ??= <PdfAutomaticField>[];
    return _fields!;
  }

  set fields(List<PdfAutomaticField> value) {
    _fields = value;
  }

  // implementation
  String _getValue(PdfGraphics graphics) {
    String? copyText;
    if (fields.isNotEmpty) {
      copyText = text;
      for (int i = 0; i < fields.length; i++) {
        copyText = copyText!.replaceAll('{$i}',
            PdfAutomaticFieldHelper.getHelper(fields[i]).getValue(graphics)!);
      }
    }
    return (copyText == null) ? text : copyText;
  }
}

// ignore: avoid_classes_with_only_static_members
/// [PdfCompositeField] helper
class PdfCompositeFieldHelper {
  /// internal method
  static String getValue(PdfCompositeField field, PdfGraphics graphics) {
    return field._getValue(graphics);
  }
}
