part of xlsio;

/// Class used for 24 hour Token.
class _Hour24Token extends _FormatTokenBase {
  /// Regular expression for hours part of the format:
  final RegExp _hourRegex = RegExp(r'\\[[hH]+\\]');

  /// Tries to parse format string.
  @override
  int _tryParse(String strFormat, int iIndex) {
    return _tryParseRegex(_hourRegex, strFormat, iIndex);
  }

  /// Applies format to the value.
  @override
  String _applyFormat(double value, bool bShowHiddenSymbols,
      CultureInfo culture, _FormatSection section) {
    double temp = value;
    if (temp <= 60) {
      temp = temp - 1;
    }
    final DateTime date = Range._fromOADate(value);
    double dHour;
    dHour = temp * _FormatConstants._hoursInDay;
    dHour = (value > 0)
        ? (dHour % 24).ceilToDouble() == date.hour
            ? dHour.ceilToDouble()
            : dHour.floorToDouble()
        : dHour.ceilToDouble();
    if (dHour < 24) {
      dHour = date.hour.toDouble();
    }
    return dHour.toInt().toString();
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
    return _TokenType.hour24;
  }
}
