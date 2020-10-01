part of xlsio;

/// <summary>
/// Class used for describing Day Tokens.
/// </summary>
class DayToken extends FormatTokenBase {
  /// <summary>
  /// Regular expression for minutes part of the format:
  /// </summary>
  final _dayRegex = RegExp('[Dd]+');

  /// <summary>
  /// Format string in lower case.
  /// </summary>
  String _strFormatLower;

  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  @override
  int tryParse(String strFormat, int iIndex) {
    final int iResult = tryParseRegex(_dayRegex, strFormat, iIndex);

    if (iResult != iIndex) {
      _strFormatLower = _strFormat.toLowerCase();
    }

    return iResult;
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String applyFormat(double value, bool bShowHiddenSymbols, CultureInfo culture,
      FormatSection section) {
    double tempValue = value;

    if (_strFormatLower.length > 2 &&
        tempValue < 60 &&
        section.formatType == ExcelFormatType.dateTime) {
      tempValue = tempValue - 1;
    }

    final DateTime date = Range.fromOADate(tempValue);
    return DateFormat(' ' + _strFormatLower).format(date).substring(1);
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
    return TokenType.day;
  }
}
