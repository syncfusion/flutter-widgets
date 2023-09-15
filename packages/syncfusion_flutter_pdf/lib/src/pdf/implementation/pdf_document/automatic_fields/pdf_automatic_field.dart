import 'dart:ui';

import '../../drawing/drawing.dart';
import '../../graphics/brushes/pdf_brush.dart';
import '../../graphics/brushes/pdf_solid_brush.dart';
import '../../graphics/fonts/enums.dart';
import '../../graphics/fonts/pdf_font.dart';
import '../../graphics/fonts/pdf_standard_font.dart';
import '../../graphics/fonts/pdf_string_format.dart';
import '../../graphics/pdf_graphics.dart';
import '../../graphics/pdf_pen.dart';
import '../../pages/enum.dart';
import 'pdf_automatic_field_info.dart';
import 'pdf_composite_field.dart';
import 'pdf_date_time_field.dart';
import 'pdf_destination_page_number_field.dart';
import 'pdf_multiple_value_field.dart';
import 'pdf_page_count_field.dart';
import 'pdf_page_number_field.dart';
import 'pdf_single_value_field.dart';
import 'pdf_static_field.dart';

/// Represents a fields which is calculated before the document saves.
abstract class PdfAutomaticField {
  /// Initialize [PdfAutomaticField] object
  void _internal(PdfFont? font,
      {Rect? bounds, PdfBrush? brush, PdfAutomaticFieldHelper? helper}) {
    _helper = helper!;
    this.font = font ?? PdfStandardFont(PdfFontFamily.helvetica, 8);
    if (bounds != null) {
      _bounds = PdfRectangle.fromRect(bounds);
    } else {
      _bounds = PdfRectangle.empty;
    }
    this.brush = brush ?? PdfBrushes.black;
  }

  // fields
  late PdfAutomaticFieldHelper _helper;
  late PdfRectangle _bounds;
  PdfPen? _pen;

  /// Gets or sets the font of the field.
  ///```dart
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
  /// dateAndTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);
  /// dateAndTimeField.dateFormatString = 'E, MM.dd.yyyy';
  /// //Create the composite field.
  /// PdfCompositeField compositefields = PdfCompositeField();
  /// //Gets or sets the font.
  /// compositefields.font = PdfStandardFont(PdfFontFamily.timesRoman, 19);
  /// //Gets or sets the brush.
  /// compositefields.brush = PdfSolidBrush(PdfColor(0, 0, 0));
  /// //Gets or sets the text.
  /// compositefields.text = '{0}      Header';
  /// //Gets or sets the fields.
  /// compositefields.fields = <PdfAutomaticField>[dateAndTimeField];
  /// //Add composite field in header
  /// compositefields.draw(header.graphics,
  ///     Offset(0, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 11).height));
  /// //Add the header at top of the document
  /// document.template.top = header;
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  ///```
  late PdfFont font;

  /// Gets or sets the brush of the field.
  ///```dart
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
  /// dateAndTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);
  /// dateAndTimeField.dateFormatString = 'E, MM.dd.yyyy';
  /// //Create the composite field.
  /// PdfCompositeField compositefields = PdfCompositeField();
  /// //Gets or sets the font.
  /// compositefields.font = PdfStandardFont(PdfFontFamily.timesRoman, 19);
  /// //Gets or sets the brush.
  /// compositefields.brush = PdfSolidBrush(PdfColor(0, 0, 0));
  /// //Gets or sets the text.
  /// compositefields.text = '{0}      Header';
  /// //Gets or sets the fields.
  /// compositefields.fields = <PdfAutomaticField>[dateAndTimeField];
  /// //Add composite field in header
  /// compositefields.draw(header.graphics,
  ///     Offset(0, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 11).height));
  /// //Add the header at top of the document
  /// document.template.top = header;
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  ///```
  late PdfBrush brush;

  /// Gets or sets the stringFormat of the field.
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
  /// dateAndTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);
  /// dateAndTimeField.dateFormatString = 'E, MM.dd.yyyy';
  /// //Create the composite field with date field
  /// PdfCompositeField compositefields = PdfCompositeField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     text: '{0}      Header',
  ///     fields: <PdfAutomaticField>[dateAndTimeField]);
  /// compositefields.stringFormat =
  ///    PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle);
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
  PdfStringFormat? stringFormat;

  // properties
  /// Gets or sets the bounds of the field.
  ///```dart
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
  /// dateAndTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);
  /// dateAndTimeField.dateFormatString = 'E, MM.dd.yyyy';
  /// //Create the composite field.
  /// PdfCompositeField compositefields = PdfCompositeField();
  /// //Gets or sets the bounds.
  /// compositefields.bounds = Rect.fromLTWH(10, 10, 200, 200);
  /// //Gets or sets the font.
  /// compositefields.font = PdfStandardFont(PdfFontFamily.timesRoman, 19);
  /// //Gets or sets the brush.
  /// compositefields.brush = PdfSolidBrush(PdfColor(0, 0, 0));
  /// //Gets or sets the text.
  /// compositefields.text = '{0}      Header';
  /// //Gets or sets the fields.
  /// compositefields.fields = <PdfAutomaticField>[dateAndTimeField];
  /// //Add composite field in header
  /// compositefields.draw(header.graphics,
  ///     Offset(0, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 11).height));
  /// //Add the header at top of the document
  /// document.template.top = header;
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  ///```
  Rect get bounds {
    return _bounds.rect;
  }

  set bounds(Rect value) {
    _bounds = PdfRectangle.fromRect(value);
  }

  /// Gets or sets the pen of the field.
  ///```dart
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
  /// dateAndTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);
  /// dateAndTimeField.dateFormatString = 'E, MM.dd.yyyy';
  /// //Create the composite field.
  /// PdfCompositeField compositefields = PdfCompositeField();
  /// //Gets or sets the font.
  /// compositefields.font = PdfStandardFont(PdfFontFamily.timesRoman, 19);
  /// //Gets or sets the pen.
  /// compositefields.pen = PdfPen(PdfColor(0, 0, 0), width: 2);
  /// //Gets or sets the text.
  /// compositefields.text = '{0}      Header';
  /// //Gets or sets the fields.
  /// compositefields.fields = <PdfAutomaticField>[dateAndTimeField];
  /// //Add composite field in header
  /// compositefields.draw(header.graphics,
  ///     Offset(0, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 11).height));
  /// //Add the header at top of the document
  /// document.template.top = header;
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  ///```
  PdfPen? get pen => _pen;
  set pen(PdfPen? value) {
    _pen = (value == null) ? throw ArgumentError.value('brush') : value;
  }

  // implementation
  /// Draws an element on the Graphics.
  /// Graphics context where the element should be printed.
  /// location has contains X co-ordinate of the element,
  /// Y co-ordinate of the element.
  ///```dart
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
  /// dateAndTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);
  /// dateAndTimeField.dateFormatString = 'E, MM.dd.yyyy';
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
  ///```
  void draw(PdfGraphics graphics, [Offset? location]) {
    location ??= Offset.zero;
    PdfGraphicsHelper.getHelper(graphics)
        .autoFields!
        .add(PdfAutomaticFieldInfo(this, PdfPoint.fromOffset(location)));
  }
}

/// [PdfAutomaticField] helper
class PdfAutomaticFieldHelper {
  /// internal constructor
  PdfAutomaticFieldHelper(this.base);

  /// internal field
  late PdfAutomaticField base;

  /// internal method
  static PdfAutomaticFieldHelper getHelper(PdfAutomaticField base) {
    return base._helper;
  }

  /// internal method
  void internal(PdfFont? font, {Rect? bounds, PdfBrush? brush}) {
    base._internal(font, bounds: bounds, brush: brush, helper: this);
  }

  // fields
  static const double _letterLimit = 26.0;
  static const int _acsiiStartIndex = 65 - 1;
  Size _templateSize = Size.zero;

  // methods
  /// internal method
  static String convert(int intArabic, PdfNumberStyle numberStyle) {
    switch (numberStyle) {
      case PdfNumberStyle.none:
        return '';
      case PdfNumberStyle.numeric:
        return intArabic.toString();
      case PdfNumberStyle.lowerLatin:
        return _arabicToLetter(intArabic).toLowerCase();
      case PdfNumberStyle.lowerRoman:
        return _arabicToRoman(intArabic).toLowerCase();
      case PdfNumberStyle.upperLatin:
        return _arabicToLetter(intArabic);
      case PdfNumberStyle.upperRoman:
        return _arabicToRoman(intArabic);
    }
  }

  static String _arabicToRoman(int intArabic) {
    final StringBuffer retval = StringBuffer();
    List<Object> result = _generateNumber(intArabic, 1000, 'M');
    retval.write(result.elementAt(0));
    result = _generateNumber(result.elementAt(1) as int, 900, 'CM');
    retval.write(result.elementAt(0));
    result = _generateNumber(result.elementAt(1) as int, 500, 'D');
    retval.write(result.elementAt(0));
    result = _generateNumber(result.elementAt(1) as int, 400, 'CD');
    retval.write(result.elementAt(0));
    result = _generateNumber(result.elementAt(1) as int, 100, 'C');
    retval.write(result.elementAt(0));
    result = _generateNumber(result.elementAt(1) as int, 90, 'XC');
    retval.write(result.elementAt(0));
    result = _generateNumber(result.elementAt(1) as int, 50, 'L');
    retval.write(result.elementAt(0));
    result = _generateNumber(result.elementAt(1) as int, 40, 'XL');
    retval.write(result.elementAt(0));
    result = _generateNumber(result.elementAt(1) as int, 10, 'X');
    retval.write(result.elementAt(0));
    result = _generateNumber(result.elementAt(1) as int, 9, 'IX');
    retval.write(result.elementAt(0));
    result = _generateNumber(result.elementAt(1) as int, 5, 'V');
    retval.write(result.elementAt(0));
    result = _generateNumber(result.elementAt(1) as int, 4, 'IV');
    retval.write(result.elementAt(0));
    result = _generateNumber(result.elementAt(1) as int, 1, 'I');
    retval.write(result.elementAt(0));
    return retval.toString();
  }

  static List<Object> _generateNumber(int value, int magnitude, String letter) {
    final StringBuffer numberString = StringBuffer();
    while (value >= magnitude) {
      value -= magnitude;
      numberString.write(letter);
    }
    final List<Object> result = <Object>[];
    result.add(numberString.toString());
    result.add(value);
    return result;
  }

  static String _arabicToLetter(int arabic) {
    final List<int> stack = _convertToLetter(arabic.toDouble());
    final StringBuffer result = StringBuffer();

    while (stack.isNotEmpty) {
      final int n = stack.removeLast();
      _appendChar(result, n);
    }
    return result.toString();
  }

  static List<int> _convertToLetter(double arabic) {
    if (arabic <= 0) {
      throw ArgumentError.value('arabic value can not be less 0');
    }
    final List<int> stack = <int>[];
    while ((arabic.toInt()) > _letterLimit) {
      double remainder = arabic % _letterLimit;

      if (remainder == 0.0) {
        arabic = arabic / _letterLimit - 1;
        remainder = _letterLimit;
      } else {
        arabic /= _letterLimit;
      }

      stack.add(remainder.toInt());
    }
    if (arabic > 0) {
      stack.add(arabic.toInt());
    }
    return stack;
  }

  static void _appendChar(StringBuffer result, int number) {
    if (number <= 0 || number > 26) {
      throw ArgumentError.value('Value can not be less 0 and greater 26');
    }
    final String letter = (_acsiiStartIndex + number).toString();
    result.write(String.fromCharCode(int.parse(letter)));
  }

  /// internal method
  String? getValue(PdfGraphics graphics) {
    if (base is PdfCompositeField) {
      return PdfCompositeFieldHelper.getValue(
          base as PdfCompositeField, graphics);
    } else if (base is PdfDateTimeField) {
      return PdfDateTimeFieldHelper.getValue(
          base as PdfDateTimeField, graphics);
    } else if (base is PdfDestinationPageNumberField) {
      return PdfDestinationPageNumberFieldHelper.getValue(
          base as PdfDestinationPageNumberField, graphics);
    } else if (base is PdfPageNumberField) {
      return PdfPageNumberFieldHelper.getHelper(base as PdfPageNumberField)
          .getValue(graphics);
    } else if (base is PdfPageCountField) {
      return PdfPageCountFieldHelper.getValue(
          base as PdfPageCountField, graphics);
    }
    return graphics as String;
  }

  /// internal method
  void performDraw(PdfGraphics graphics, PdfPoint? location, double scalingX,
      double scalingY) {
    if (base.bounds.height == 0 || base.bounds.width == 0) {
      final String text = getValue(graphics)!;
      _templateSize = base.font.measureString(text,
          layoutArea: base.bounds.size, format: base.stringFormat);
    }
    if (base is PdfStaticField) {
      PdfStaticFieldHelper.performDraw(
          base as PdfStaticField, graphics, location, scalingX, scalingY);
    } else if (base is PdfSingleValueField) {
      PdfSingleValueFieldHelper.performDraw(
          base as PdfSingleValueField, graphics, location, scalingX, scalingY);
    } else if (base is PdfMultipleValueField) {
      PdfMultipleValueFieldHelper.performDraw(base as PdfMultipleValueField,
          graphics, location, scalingX, scalingY);
    }
  }

  /// internal method
  Size obtainSize() {
    if (base.bounds.height == 0 || base.bounds.width == 0) {
      return _templateSize;
    } else {
      return base.bounds.size;
    }
  }
}
