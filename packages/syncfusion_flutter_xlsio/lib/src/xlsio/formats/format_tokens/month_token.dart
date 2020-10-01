part of xlsio;

/// <summary>
/// Class used for Month Token.
/// </summary>
class MonthToken extends FormatTokenBase {
  /// <summary>
  /// Regular expression for minutes part of the format:
  /// </summary>
  final _monthRegex = RegExp('[Mm]{3,}');

  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  @override
  int tryParse(String strFormat, int iIndex) {
    return tryParseRegex(_monthRegex, strFormat, iIndex);
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String applyFormat(double value, bool bShowHiddenSymbols, CultureInfo culture,
      FormatSection section) {
    final DateTime date = Range.fromOADate(value);
    final DateFormat formatter = DateFormat(_strFormat.toUpperCase());
    final String formatted = formatter.format(date);
    return formatted;
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
    return TokenType.month;
  }
}
