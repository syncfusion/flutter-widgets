part of xlsio;

/// <summary>
/// Contains Am Pm Token descriptions.
/// </summary>
class AmPmToken extends FormatTokenBase {
  final _aMPMRegex = RegExp('[Am/PM]{4,}');

  /// <summary>
  /// Edge between AM and PM symbols.
  /// </summary>
  static const _defaultAMPMEdge = 12;

  /// <summary>
  /// AM symbol.
  /// </summary>
  static const String _defaultAM = 'AM';

  /// <summary>
  /// PM symbol.
  /// </summary>
  static const String _defaultPM = 'PM';

  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  @override
  int tryParse(String strFormat, int iIndex) {
    if (strFormat == null) throw ('strFormat');

    final int iFormatLength = strFormat.length;

    if (iFormatLength == 0) throw ('strFormat - string cannot be empty.');

    if (iIndex < 0 || iIndex > iFormatLength - 1) {
      throw ('iIndex - Value cannot be less than 0 and greater than than format length - 1.');
    }
    return tryParseRegex(_aMPMRegex, strFormat, iIndex);
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String applyFormat(double value, bool bShowHiddenSymbols, CultureInfo culture,
      FormatSection section) {
    final DateTime date = Range.fromOADate(value);

    final int iHour = date.hour;

    if (iHour >= _defaultAMPMEdge) {
      return _defaultPM;
    } else {
      return _defaultAM;
    }
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String applyFormatString(String value, bool bShowHiddenSymbols) {
    throw Exception();
  }

  /// <summary>
  /// Checks the AMPM is other pattern.
  /// </summary>
  static String checkAndApplyAMPM(String format) {
    if (format == null) throw ("format - Value can't be null");
    return format;
  }

  /// <summary>
  /// Gets type of the token. Read-only.
  /// </summary>
  @override
  TokenType get tokenType {
    return TokenType.amPm;
  }
}
