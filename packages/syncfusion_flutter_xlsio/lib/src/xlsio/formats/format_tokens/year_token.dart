part of xlsio;

/// Class used for YearToken.

class _YearToken extends _FormatTokenBase {
  /// Regular expression for minutes part of the format:

  final RegExp _yearRegex = RegExp('[yY]+');

  /// Tries to parse format string.

  @override
  int _tryParse(String strFormat, int iIndex) {
    return _tryParseRegex(_yearRegex, strFormat, iIndex);
  }

  /// Applies format to the value.

  @override
  String _applyFormat(double value, bool bShowHiddenSymbols,
      CultureInfo culture, _FormatSection section) {
    final DateTime date = Range._fromOADate(value);
    final int iYear = date.year;

    if (_strFormat.length > 2) {
      return iYear.toString();
    } else {
      return (iYear % 100).toString();
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
    return _TokenType.year;
  }
}
