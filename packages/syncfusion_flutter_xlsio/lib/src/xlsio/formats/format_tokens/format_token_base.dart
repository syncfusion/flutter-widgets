part of xlsio;

/// Base class for formula tokens.
abstract class _FormatTokenBase {
  /// Part of format.
  String _strFormat = '';

  /// Tries to parse format string.
  int _tryParse(String strFormat, int iIndex);

  /// Tries to parse format string using regular expression.
  int _tryParseRegex(RegExp regex, String strFormat, int iIndex) {
    final int iFormatLength = strFormat.length;
    if (iFormatLength == 0) {
      final Error error = ArgumentError('strFormat - string cannot be empty');
      throw error;
    }

    if (iIndex < 0 || iIndex > iFormatLength) {
      final Error error = ArgumentError(
          'iIndex - Value cannot be less than 0 or greater than Format Length');
      throw error;
    }
    final Match? m = regex.matchAsPrefix(strFormat, iIndex);
    if (regex.hasMatch(strFormat) && m != null && m.start == iIndex) {
      _format = regex.stringMatch(strFormat)!;
      iIndex += _strFormat.length;
      if (m.end != iIndex) {
        _format = _strFormat + _strFormat;
        iIndex = m.end;
      }
    }
    return iIndex;
  }

  /// Applies format to the value.
  String _applyFormat(double value, bool bShowHiddenSymbols,
      CultureInfo culture, _FormatSection section);

  /// Applies format to the value.
  // ignore: unused_element
  String _applyFormatString(String value, bool bShowHiddenSymbols);

  /// Gets or sets format of the token.
  String get _format {
    return _strFormat;
  }

  set _format(String value) {
    if (value.isEmpty) {
      final Error error = ArgumentError('value - string cannot be empty.');
      throw error;
    }

    if (_strFormat != value) {
      _strFormat = value;
      _onFormatChange();
    }
  }

  /// Searches for string from strings array in the format starting from the specified position.
  // ignore: unused_element
  int _findString(
      List<String> arrStrings, String strFormat, int iIndex, bool bIgnoreCase) {
    final int iFormatLength = strFormat.length;

    if (iFormatLength == 0) {
      final Error error = ArgumentError('strFormat - string cannot be empty.');
      throw error;
    }

    if (iIndex < 0 || iIndex > iFormatLength - 1) {
      final Error error = ArgumentError(
          'iIndex - Value cannot be less than 0 and greater than than format length - 1.');
      throw error;
    }
    return -1;
  }

  /// This method is called after format string was changed.
  void _onFormatChange() {}

  /// Gets type of the token. Read-only.
  _TokenType get _tokenType {
    return _TokenType.general;
  }
}
