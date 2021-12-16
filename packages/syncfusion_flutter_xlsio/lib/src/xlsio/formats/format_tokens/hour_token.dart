part of xlsio;

// ignore: public_member_api_docs
class _HourToken extends _FormatTokenBase {
  /// Regular expression for hours part of the format:
  static RegExp hourRegex = RegExp('[hH]+');

  /// Defined 12hr format.
  static const String _defaultFormat = 'h';

  /// Long format.
  static const String _defaultFormatLong = '00';

  /// Indicates whether token should be formatted using am/pm time format.
  // ignore: prefer_final_fields
  bool _isAmPm = false;

  @override
  // ignore: prefer_final_fields
  String _strFormat = '';

  /// Tries to parse format string.
  @override
  int _tryParse(String strFormat, int iIndex) {
    return _tryParseRegex(hourRegex, strFormat, iIndex);
  }

  /// Applies format to the value.
  @override
  String _applyFormat(double value, bool bShowHiddenSymbols,
      CultureInfo culture, _FormatSection section) {
    final DateTime date = Range._fromOADate(value);
    int iHour = date.hour;
    if (_isAmPm) {
      iHour = int.parse(DateFormat(_defaultFormat).format(date));
    }
    if (_strFormat.length > 1) {
      return NumberFormat(_defaultFormatLong).format(iHour);
    } else {
      return iHour.toString();
    }
  }

  /// Applies format to the value.
  @override
  // ignore: unused_element
  String _applyFormatString(String value, bool bShowHiddenSymbols) {
    return '';
  }

  /// Gets type of the token. Read-only.
  @override
  _TokenType get _tokenType {
    return _TokenType.hour;
  }
}
