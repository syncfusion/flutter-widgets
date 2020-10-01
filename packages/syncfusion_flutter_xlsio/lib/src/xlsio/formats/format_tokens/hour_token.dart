part of xlsio;

// ignore: public_member_api_docs
class HourToken extends FormatTokenBase {
  /// <summary>
  /// Regular expression for hours part of the format:
  /// </summary>
  static RegExp hourRegex = RegExp('[hH]+');

  /// <summary>
  /// Defined 12hr format.
  /// </summary>
  static const String dEF_FORMAT = 'h';

  /// <summary>
  /// Long format.
  /// </summary>
  static const String dEF_FORMAT_LONG = '00';

  /// <summary>
  /// Indicates whether token should be formatted using am/pm time format.
  /// </summary>
  bool isAmPm = false;

  @override
  String _strFormat;

  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  @override
  int tryParse(String strFormat, int iIndex) {
    return tryParseRegex(hourRegex, strFormat, iIndex);
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String applyFormat(double value, bool bShowHiddenSymbols, CultureInfo culture,
      FormatSection section) {
    final DateTime date = Range.fromOADate(value);
    int iHour = date.hour;
    if (isAmPm) iHour = int.parse(DateFormat(dEF_FORMAT).format(date));
    if (_strFormat.length > 1) {
      return NumberFormat(dEF_FORMAT_LONG).format(iHour);
    } else {
      return iHour.toString();
    }
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String applyFormatString(String value, bool bShowHiddenSymbols) {
    return '';
  }

  /// <summary>
  /// Gets type of the token. Read-only.
  /// </summary>
  @override
  TokenType get tokenType {
    return TokenType.hour;
  }
}
