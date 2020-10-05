part of xlsio;

/// <summary>
/// Class used for Month Token.
/// </summary>
class _MonthToken extends _FormatTokenBase {
  /// <summary>
  /// Regular expression for minutes part of the format:
  /// </summary>
  final _monthRegex = RegExp('[Mm]{3,}');

  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  @override
  int _tryParse(String strFormat, int iIndex) {
    return _tryParseRegex(_monthRegex, strFormat, iIndex);
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String _applyFormat(double value, bool bShowHiddenSymbols,
      CultureInfo culture, _FormatSection section) {
    final DateTime date = Range._fromOADate(value);
    final DateFormat formatter = DateFormat(_strFormat.toUpperCase());
    final String formatted = formatter.format(date);
    return formatted;
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
    return _TokenType.month;
  }
}
