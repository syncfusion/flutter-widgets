part of pdf;

/// Represents a fields which is calculated before the document saves.
abstract class PdfAutomaticField {
  // constructor
  PdfAutomaticField._(PdfFont? font, {Rect? bounds, PdfBrush? brush})
      : super() {
    this.font = font ?? PdfStandardFont(PdfFontFamily.helvetica, 8);
    if (bounds != null) {
      _bounds = _Rectangle.fromRect(bounds);
    } else {
      _bounds = _Rectangle.empty;
    }
    this.brush = brush ?? PdfBrushes.black;
  }
  // fields
  late _Rectangle _bounds;

  PdfPen? _pen;

  Size _templateSize = const Size(0, 0);

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
  /// List<int> bytes = document.save();
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
  /// List<int> bytes = document.save();
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
  /// List<int> bytes = document.save();
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
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  ///```
  Rect get bounds {
    return _bounds.rect;
  }

  set bounds(Rect value) {
    _bounds = _Rectangle.fromRect(value);
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
  /// List<int> bytes = document.save();
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
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  ///```
  void draw(PdfGraphics graphics, [Offset? location]) {
    location ??= const Offset(0, 0);
    graphics._autoFields!
        .add(_PdfAutomaticFieldInfo(this, _Point.fromOffset(location)));
  }

  String? _getValue(PdfGraphics graphics) {
    return graphics as String;
  }

  void _performDraw(PdfGraphics graphics, _Point? location, double scalingX,
      double scalingY) {
    if (bounds.height == 0 || bounds.width == 0) {
      final String text = _getValue(graphics)!;
      _templateSize = font.measureString(text,
          layoutArea: bounds.size, format: stringFormat);
    }
  }

  Size _obtainSize() {
    if (bounds.height == 0 || bounds.width == 0) {
      return _templateSize;
    } else {
      return bounds.size;
    }
  }

  // fields
  static const double _letterLimit = 26.0;
  static const int _acsiiStartIndex = 65 - 1;

  // methods
  static String _convert(int intArabic, PdfNumberStyle numberStyle) {
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
}
