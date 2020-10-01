part of xlsio;

/// <summary>
/// Class used for 24 hour Token.
/// </summary>
class Hour24Token extends FormatTokenBase {
  /// <summary>
  /// Regular expression for hours part of the format:
  /// </summary>
  final _hourRegex = RegExp('\\[[hH]+\\]');

  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  @override
  int tryParse(String strFormat, int iIndex) {
    return tryParseRegex(_hourRegex, strFormat, iIndex);
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String applyFormat(double value, bool bShowHiddenSymbols, CultureInfo culture,
      FormatSection section) {
    double temp = value;
    if (temp <= 60) temp = temp - 1;
    final DateTime date = Range.fromOADate(value);
    double dHour;
    dHour = temp * FormatConstants._hoursInDay;
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
  String applyFormatString(String value, bool bShowHiddenSymbols) {
    return '';
  }

  /// <summary>
  /// Gets type of the token. Read-only.
  /// </summary>
  @override
  TokenType get tokenType {
    return TokenType.hour24;
  }
}
