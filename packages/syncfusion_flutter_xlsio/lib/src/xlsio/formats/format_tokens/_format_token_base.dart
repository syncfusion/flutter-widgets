part of xlsio;

/// <summary>
/// Base class for formula tokens.
/// </summary>
abstract class FormatTokenBase {
  /// <summary>
  /// Part of format.
  /// </summary>
  String _strFormat;

  //Class methods
  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  int tryParse(String strFormat, int iIndex);

  /// <summary>
  /// Tries to parse format string using regular expression.
  /// </summary>
  int tryParseRegex(RegExp regex, String strFormat, int iIndex) {
    if (regex == null) throw ("regex - Value can't be null");

    if (strFormat == null) throw ("strFormat - Value can't be null");

    final int iFormatLength = strFormat.length;

    if (iFormatLength == 0) throw ('strFormat - string cannot be empty');

    if (iIndex < 0 || iIndex > iFormatLength) {
      throw ('iIndex - Value cannot be less than 0 or greater than Format Length');
    }
    final Match m = regex.matchAsPrefix(strFormat, iIndex);
    if (regex.hasMatch(strFormat) && m != null && m.start == iIndex) {
      format = regex.stringMatch(strFormat);
      iIndex += _strFormat.length;
      if (m.end != iIndex) {
        format = _strFormat + _strFormat;
        iIndex = m.end;
      }
    }
    return iIndex;
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  String applyFormat(double value, bool bShowHiddenSymbols, CultureInfo culture,
      FormatSection section);

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  String applyFormatString(String value, bool bShowHiddenSymbols);

  /// <summary>
  /// Gets or sets format of the token.
  /// </summary>
  String get format {
    return _strFormat;
  }

  set format(String value) {
    if (value == null) throw ('value - string cannot be null.');

    if (value.isEmpty) throw ('value - string cannot be empty.');

    if (_strFormat != value) {
      _strFormat = value;
      onFormatChange();
    }
  }

  /// <summary>
  /// Searches for string from strings array in the format starting from the specified position.
  /// </summary>
  int findString(
      List<String> arrStrings, String strFormat, int iIndex, bool bIgnoreCase) {
    if (strFormat == null) throw ('strFormat - string cannot be null.');

    final int iFormatLength = strFormat.length;

    if (iFormatLength == 0) throw ('strFormat - string cannot be empty.');

    if (iIndex < 0 || iIndex > iFormatLength - 1) {
      throw ('iIndex - Value cannot be less than 0 and greater than than format length - 1.');
    }
    return -1;
  }

  /// <summary>
  /// This method is called after format string was changed.
  /// </summary>
  void onFormatChange() {}

  /// <summary>
  /// Gets type of the token. Read-only.
  /// </summary>
  TokenType get tokenType {
    return TokenType.general;
  }
}
