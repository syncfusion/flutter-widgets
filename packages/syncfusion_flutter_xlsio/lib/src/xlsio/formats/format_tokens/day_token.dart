part of xlsio;

/// Class used for describing Day Tokens.
class _DayToken extends _FormatTokenBase {
  /// Regular expression for minutes part of the format:
  final RegExp _dayRegex = RegExp('[Dd]+');

  /// Format string in lower case.
  String _strFormatLower = '';

  @override

  /// Tries to parse format string.
  int _tryParse(String strFormat, int iIndex) {
    final int iResult = _tryParseRegex(_dayRegex, strFormat, iIndex);

    if (iResult != iIndex) {
      _strFormatLower = _strFormat.toLowerCase();
    }

    return iResult;
  }

  /// Applies format to the value.
  @override
  String _applyFormat(double value, bool bShowHiddenSymbols,
      CultureInfo culture, _FormatSection section) {
    double tempValue = value;

    if (_strFormatLower.length > 2 &&
        tempValue < 60 &&
        section.formatType == ExcelFormatType.dateTime) {
      tempValue = tempValue - 1;
    }

    final DateTime date = Range._fromOADate(tempValue);
    return DateFormat(' $_strFormatLower').format(date).substring(1);
  }

  @override

  /// Applies format to the value.
  // ignore: unused_element
  String _applyFormatString(String value, bool bShowHiddenSymbols) {
    return '';
  }

  @override

  /// Gets type of the token. Read-only.
  _TokenType get _tokenType {
    return _TokenType.day;
  }
}
