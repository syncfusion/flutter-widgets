part of xlsio;

/// <summary>
/// Class used for 24 hour Token.
/// </summary>
class _Hour24Token extends _FormatTokenBase {
  /// <summary>
  /// Regular expression for hours part of the format:
  /// </summary>
  final _hourRegex = RegExp('\\[[hH]+\\]');

  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  @override
  int _tryParse(String strFormat, int iIndex) {
    return _tryParseRegex(_hourRegex, strFormat, iIndex);
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String _applyFormat(double value, bool bShowHiddenSymbols,
      CultureInfo culture, _FormatSection section) {
    double temp = value;
    if (temp <= 60) temp = temp - 1;
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
    return (dHour.toInt()).toString();
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
    return _TokenType.hour24;
  }
}
