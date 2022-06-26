part of xlsio;

/// Class used for UnknownToken.

class _UnknownToken extends _FormatTokenBase {
  /// Tries to parse format string.

  @override
  int _tryParse(String strFormat, int iIndex) {
    final int iFormatLength = strFormat.length;

    if (iFormatLength == 0) {
      final Error error = ArgumentError('strFormat - string cannot be empty');
      throw error;
    }
    _strFormat = strFormat[iIndex];
    return iIndex + 1;
  }

  /// Applies format to the value.

  @override
  String _applyFormat(double value, bool bShowHiddenSymbols,
      CultureInfo culture, _FormatSection section) {
    if (_strFormat == 'g' || _strFormat == 'G') {
      return '';
    } else {
      return _strFormat;
    }
  }

  /// Applies format to the value.

  @override
  // ignore: unused_element
  String _applyFormatString(String value, bool bShowHiddenSymbols) {
    return _strFormat;
  }

  /// Gets type of the token. Read-only.

  @override
  _TokenType get _tokenType {
    return _TokenType.unknown;
  }
}
