import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../graphics/fonts/pdf_font.dart';
import '../../graphics/pdf_graphics.dart';
import 'pdf_static_field.dart';

/// Represents date and time automated field.
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
/// //Create the composite field
/// PdfCompositeField compositeField = PdfCompositeField(
///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
///     text: 'Time:{0}');
/// //Create the date and time field
/// PdfDateTimeField dateTimeField = PdfDateTimeField(
///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
///     brush: PdfSolidBrush(PdfColor(0, 0, 0)));
/// //Add date&time field to composite fields
/// compositeField.fields.add(dateTimeField);
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
class PdfDateTimeField extends PdfStaticField {
  // constructor
  /// Initializes a new instance of the [PdfDateTimeField] class.
  ///
  /// [font] - Specifies the [PdfFont] to use.
  /// [brush] - The object that is used to fill the string.
  /// [bounds] - Specifies the location and size of the field.
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
  /// //Create the composite field
  /// PdfCompositeField compositeField = PdfCompositeField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     text: 'Time:{0}');
  /// //Create the date and time field
  /// PdfDateTimeField dateTimeField = PdfDateTimeField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  /// //Add date&time field to composite fields
  /// compositeField.fields.add(dateTimeField);
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
  PdfDateTimeField({super.font, super.brush, super.bounds});

  /// Get the current date and set the required date.
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
  /// //Create the composite field
  /// PdfCompositeField compositeField = PdfCompositeField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     text: 'Time:{0}');
  /// //Create the date and time field
  /// PdfDateTimeField dateTimeField = PdfDateTimeField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  /// //Gets the date and time
  /// DateTime dateTime = dateTimeField.date;
  /// //Add date&time field to composite fields
  /// compositeField.fields.add(dateTimeField);
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
  DateTime date = DateTime.now();

  // properties
  /// Gets or sets the date format string.
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
  /// //Create the composite field
  /// PdfCompositeField compositeField = PdfCompositeField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     text: 'Time:{0}');
  /// //Create the date and time field
  /// PdfDateTimeField dateTimeField = PdfDateTimeField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  /// //Sets the date and time format
  /// dateTimeField.dateFormatString = 'hh\':\'mm\':\'ss';
  /// //Add date&time field to composite fields
  /// compositeField.fields.add(dateTimeField);
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
  String dateFormatString = "dd'/'MM'/'yyyy hh':'mm':'ss";

  /// Gets or sets the locale for date and time culture.
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
  /// //Create the composite field
  /// PdfCompositeField compositeField = PdfCompositeField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     text: 'Time:{0}');
  /// //Create the date and time field
  /// PdfDateTimeField dateTimeField = PdfDateTimeField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  /// //Sets the date and time locale
  /// dateTimeField.locale = 'en_US';
  /// //Add date&time field to composite fields
  /// compositeField.fields.add(dateTimeField);
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
  String locale = 'en_US';

  // implementation
  String _getValue(PdfGraphics? graphics) {
    initializeDateFormatting(locale);
    final DateFormat formatter = DateFormat(dateFormatString, locale);
    final String value = formatter.format(date);
    return value;
  }
}

// ignore: avoid_classes_with_only_static_members
/// [PdfDateTimeField] helper
class PdfDateTimeFieldHelper {
  /// internal method
  static String getValue(PdfDateTimeField field, PdfGraphics? graphics) {
    return field._getValue(graphics);
  }
}
