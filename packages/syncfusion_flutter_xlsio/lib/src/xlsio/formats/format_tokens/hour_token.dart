part of xlsio;

// ignore: public_member_api_docs
class _HourToken extends _FormatTokenBase {
  /// <summary>
  /// Regular expression for hours part of the format:
  /// </summary>
  static RegExp hourRegex = RegExp('[hH]+');

  /// <summary>
  /// Defined 12hr format.
  /// </summary>
  static const String _defaultFormat = 'h';

  /// <summary>
  /// Long format.
  /// </summary>
  static const String _defaultFormatLong = '00';

  /// <summary>
  /// Indicates whether token should be formatted using am/pm time format.
  /// </summary>
  // ignore: prefer_final_fields
  bool _isAmPm = false;

  @override
  String _strFormat = '';

  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  @override
  int _tryParse(String strFormat, int iIndex) {
    return _tryParseRegex(hourRegex, strFormat, iIndex);
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String _applyFormat(double value, bool bShowHiddenSymbols,
      CultureInfo culture, _FormatSection section) {
    final DateTime date = Range._fromOADate(value);
    int iHour = date.hour;
    if (_isAmPm) iHour = int.parse(DateFormat(_defaultFormat).format(date));
    if (_strFormat.length > 1) {
      return NumberFormat(_defaultFormatLong).format(iHour);
    } else {
      return iHour.toString();
    }
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  // ignore: unused_element
  String _applyFormatString(String value, bool bShowHiddenSymbols) {
    return '';
  }

  /// <summary>
  /// Gets type of the token. Read-only.
  /// </summary>
  @override
  _TokenType get _tokenType {
    return _TokenType.hour;
  }
}
