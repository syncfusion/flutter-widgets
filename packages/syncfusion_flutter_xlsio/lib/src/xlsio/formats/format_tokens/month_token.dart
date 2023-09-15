part of xlsio;

/// Class used for Month Token.

class _MonthToken extends _FormatTokenBase {
  /// Regular expression for minutes part of the format:

  final RegExp _monthRegex = RegExp('[Mm]{3,}');

  /// Tries to parse format string.

  @override
  int _tryParse(String strFormat, int iIndex) {
    return _tryParseRegex(_monthRegex, strFormat, iIndex);
  }

  /// Applies format to the value.

  @override
  String _applyFormat(double value, bool bShowHiddenSymbols,
      CultureInfo culture, _FormatSection section) {
    final DateTime date = Range._fromOADate(value);
    final DateFormat formatter = DateFormat(_strFormat.toUpperCase());
    final String formatted = formatter.format(date);
    return formatted;
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
    return _TokenType.month;
  }
}
