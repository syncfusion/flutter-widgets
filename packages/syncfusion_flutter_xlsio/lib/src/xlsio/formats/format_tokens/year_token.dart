part of xlsio;

/// <summary>
/// Class used for YearToken.
/// </summary>
class YearToken extends FormatTokenBase {
  /// <summary>
  /// Regular expression for minutes part of the format:
  /// </summary>
  final _yearRegex = RegExp('[yY]+');

  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  @override
  int tryParse(String strFormat, int iIndex) {
    return tryParseRegex(_yearRegex, strFormat, iIndex);
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String applyFormat(double value, bool bShowHiddenSymbols, CultureInfo culture,
      FormatSection section) {
    final DateTime date = Range.fromOADate(value);
    final int iYear = date.year;

    if (_strFormat.length > 2) {
      return iYear.toString();
    } else {
      return (iYear % 100).toString();
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
    return TokenType.year;
  }
}
