part of xlsio;

/// <summary>
/// Class used for organizing Minutes since midnight.
/// </summary>
class MinuteTotalToken extends FormatTokenBase {
  /// <summary>
  /// Regular expression for hours part of the format:
  /// </summary>
  static final _hourRegex = RegExp('\\[[m]+\\]');

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
    double tempValue = value;

    if (tempValue < 60) tempValue = tempValue - 1;
    final double dHour = tempValue * FormatConstants._minutesInDay;
    return dHour.toString();
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
    return TokenType.minuteTotal;
  }
}
