part of xlsio;

/// <summary>
/// Class used for Significant Digit Token.
/// </summary>
class _SignificantDigitToken extends _FormatTokenBase {
  /// <summary>
  /// Format character.
  /// </summary>
  final _defaultFormatChar = '0';

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String _applyFormat(double value, bool bShowHiddenSymbols,
      CultureInfo culture, _FormatSection section) {
    return _strFormat;
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  // ignore: unused_element
  String _applyFormatString(String value, bool bShowHiddenSymbols) {
    return _strFormat;
  }

  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  @override
  int _tryParse(String strFormat, int iIndex) {
    final int iFormatLength = strFormat.length;

    if (iFormatLength == 0) throw ('strFormat - string cannot be empty');

    if (iIndex < 0 || iIndex > iFormatLength - 1) {
      throw ('iIndex-Value cannot be less than 0 and greater than format length - 1.');
    }

    final String chCurrent = strFormat[iIndex];

    if (_isNumeric(chCurrent)) {
      iIndex++;
      _strFormat = chCurrent;
    } else if (strFormat[iIndex] == '\\' &&
        strFormat[iIndex + 1] == _formatChar) {
      _strFormat = strFormat[iIndex + 1];
      iIndex = iIndex + 2;
    }
    return iIndex;
  }

  ///Checking the string is numeric or not.
  bool _isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  /// <summary>
  /// Format character. Read-only.
  /// </summary>
  String get _formatChar {
    if (_strFormat == '') return _defaultFormatChar;
    return _strFormat;
  }

  /// <summary>
  /// Gets type of the token. Read-only.
  /// </summary>
  @override
  _TokenType get _tokenType {
    return _TokenType.significantDigit;
  }
}
