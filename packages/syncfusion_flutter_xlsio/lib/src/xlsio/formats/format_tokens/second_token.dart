part of xlsio;

/// Class used for Seconds Token.
class _SecondToken extends _FormatTokenBase {
  /// Regular expression for minutes part of the format:
  final RegExp _secondRegex = RegExp('[sS]+');

  /// Long type of the format.
  static const String _defaultFormatLong = '00';

  /// Half of possible milliseconds.
  static const int _defaultMilliSecondHalf = 500;

  /// Indicates whether number of seconds must be rounded.
  // ignore: prefer_final_fields
  bool _roundValue = true;

  /// Tries to parse format string.
  @override
  int _tryParse(String strFormat, int iIndex) {
    return _tryParseRegex(_secondRegex, strFormat, iIndex);
  }

  /// Applies format to the value.

  @override
  String _applyFormat(double value, bool bShowHiddenSymbols,
      CultureInfo culture, _FormatSection section) {
    final DateTime date = Range._fromOADate(value);

    int iSecond = date.second;
    final int iMilliSecond = date.millisecond;

    if (_roundValue && iMilliSecond >= _defaultMilliSecondHalf) {
      iSecond++;
    }

    if (_strFormat.length > 1) {
      /// when second is more than 59, display it as 00.
      return (iSecond > 59) ? _defaultFormatLong : iSecond.toString();
    } else {
      return iSecond.toString();
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
    return _TokenType.second;
  }
}
