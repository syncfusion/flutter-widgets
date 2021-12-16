part of xlsio;

/// Contains Am Pm Token descriptions.
class _AmPmToken extends _FormatTokenBase {
  final RegExp _aMPMRegex = RegExp('[Am/PM]{4,}');

  /// Edge between AM and PM symbols.
  static const int _defaultAMPMEdge = 12;

  /// AM symbol.
  static const String _defaultAM = 'AM';

  /// PM symbol.
  static const String _defaultPM = 'PM';

  /// Tries to parse format string.
  @override
  int _tryParse(String strFormat, int iIndex) {
    final int iFormatLength = strFormat.length;

    if (iFormatLength == 0) {
      throw 'strFormat - string cannot be empty.';
    }

    if (iIndex < 0 || iIndex > iFormatLength - 1) {
      throw 'iIndex - Value cannot be less than 0 and greater than than format length - 1.';
    }
    return _tryParseRegex(_aMPMRegex, strFormat, iIndex);
  }

  /// Applies format to the value.

  @override
  String _applyFormat(double value, bool bShowHiddenSymbols,
      CultureInfo culture, _FormatSection section) {
    final DateTime date = Range._fromOADate(value);

    final int iHour = date.hour;

    if (iHour >= _defaultAMPMEdge) {
      return _defaultPM;
    } else {
      return _defaultAM;
    }
  }

  /// Applies format to the value.
  @override
  // ignore: unused_element
  String _applyFormatString(String value, bool bShowHiddenSymbols) {
    throw Exception();
  }

  /// Checks the AMPM is other pattern.
  // ignore: unused_element
  static String _checkAndApplyAMPM(String format) {
    return format;
  }

  /// Gets type of the token. Read-only.

  @override
  _TokenType get _tokenType {
    return _TokenType.amPm;
  }
}
