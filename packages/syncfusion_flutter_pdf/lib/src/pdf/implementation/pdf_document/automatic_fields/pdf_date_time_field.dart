part of pdf;

/// Represents date and time automated field.
class PdfDateTimeField extends _PdfStaticField {
  // constructor
  /// Initializes a new instance of the [PdfDateTimeField] class.
  ///
  /// [font] - Specifies the [PdfFont] to use.
  /// [brush] - The object that is used to fill the string.
  /// [bounds] - Specifies the location and size of the field.
  PdfDateTimeField({PdfFont font, PdfBrush brush, Rect bounds})
      : super(font: font, brush: brush, bounds: bounds);

  // fields
  String _formatString = "dd'/'MM'/'yyyy hh':'mm':'ss";
  String _locale = 'en_US';

  /// Get the current date and set the required date.
  DateTime date = DateTime.now();

  // properties
  /// Gets the date format string.
  String get dateFormatString => _formatString;

  /// Sets the date format string.
  set dateFormatString(String value) {
    if (value != null) {
      _formatString = value;
    }
  }

  /// Gets the locale for date and time culture.
  String get locale => _locale;

  /// Sets the locale for date and time culture
  set locale(String value) {
    if (value != null) {
      _locale = value;
    }
  }

  // implementation
  @override
  String _getValue(PdfGraphics graphics) {
    initializeDateFormatting(locale);
    final DateFormat formatter = DateFormat(dateFormatString, locale);
    final String value = formatter.format(date);
    return value;
  }
}
