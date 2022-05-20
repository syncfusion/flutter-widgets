part of xlsio;

/// Class used for Significant Digit Token.

class _SignificantDigitToken extends _FormatTokenBase {
  /// Format character.

  final String _defaultFormatChar = '0';

  /// Applies format to the value.

  @override
  String _applyFormat(double value, bool bShowHiddenSymbols,
      CultureInfo culture, _FormatSection section) {
    return _strFormat;
  }

  /// Applies format to the value.

  @override
  // ignore: unused_element
  String _applyFormatString(String value, bool bShowHiddenSymbols) {
    return _strFormat;
  }

  /// Tries to parse format string.

  @override
  int _tryParse(String strFormat, int iIndex) {
    final int iFormatLength = strFormat.length;

    if (iFormatLength == 0) {
      final Error error = ArgumentError('strFormat - string cannot be empty');
      throw error;
    }

    if (iIndex < 0 || iIndex > iFormatLength - 1) {
      final Error error = ArgumentError(
          'iIndex-Value cannot be less than 0 and greater than format length - 1.');
      throw error;
    }

    final String chCurrent = strFormat[iIndex];

    if (_isNumeric(chCurrent)) {
      iIndex++;
      _strFormat = chCurrent;
    } else if (strFormat[iIndex] == r'\\' &&
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

  /// Format character. Read-only.
  String get _formatChar {
    if (_strFormat == '') {
      return _defaultFormatChar;
    }
    return _strFormat;
  }

  /// Gets type of the token. Read-only.

  @override
  _TokenType get _tokenType {
    return _TokenType.significantDigit;
  }
}
