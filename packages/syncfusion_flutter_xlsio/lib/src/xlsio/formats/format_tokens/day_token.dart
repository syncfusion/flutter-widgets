part of xlsio;

/// <summary>
/// Class used for describing Day Tokens.
/// </summary>
class _DayToken extends _FormatTokenBase {
  /// <summary>
  /// Regular expression for minutes part of the format:
  /// </summary>
  final _dayRegex = RegExp('[Dd]+');

  /// <summary>
  /// Format string in lower case.
  /// </summary>
  String _strFormatLower = '';

  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  @override
  int _tryParse(String strFormat, int iIndex) {
    final int iResult = _tryParseRegex(_dayRegex, strFormat, iIndex);

    if (iResult != iIndex) {
      _strFormatLower = _strFormat.toLowerCase();
    }

    return iResult;
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
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
    return DateFormat(' ' + _strFormatLower).format(date).substring(1);
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
    return _TokenType.day;
  }
}
