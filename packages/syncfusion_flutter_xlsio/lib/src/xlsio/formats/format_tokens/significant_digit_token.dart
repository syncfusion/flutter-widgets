import '../../formats/format_tokens/enums.dart';
import '../../general/culture_info.dart';
import '../format_section.dart';
import 'format_token_base.dart';

/// Class used for Significant Digit Token.

class SignificantDigitToken extends FormatTokenBase {
  /// Format character.

  final String _defaultFormatChar = '0';

  /// Applies format to the value.

  @override
  String applyFormat(double value, bool bShowHiddenSymbols, CultureInfo culture,
      FormatSection section) {
    return strFormat;
  }

  /// Applies format to the value.

  @override
  // ignore: unused_element
  String applyFormatString(String value, bool bShowHiddenSymbols) {
    return strFormat;
  }

  /// Tries to parse format string.

  @override
  int tryParse(String stringFormat, int iIndex) {
    final int iFormatLength = stringFormat.length;

    if (iFormatLength == 0) {
      final Error error =
          ArgumentError('stringFormat - string cannot be empty');
      throw error;
    }

    if (iIndex < 0 || iIndex > iFormatLength - 1) {
      final Error error = ArgumentError(
          'iIndex-Value cannot be less than 0 and greater than format length - 1.');
      throw error;
    }

    final String chCurrent = stringFormat[iIndex];

    if (_isNumeric(chCurrent)) {
      iIndex++;
      strFormat = chCurrent;
    } else if (stringFormat[iIndex] == r'\\' &&
        stringFormat[iIndex + 1] == _formatChar) {
      strFormat = stringFormat[iIndex + 1];
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
    if (strFormat == '') {
      return _defaultFormatChar;
    }
    return strFormat;
  }

  /// Gets type of the token. Read-only.

  @override
  TokenType get tokenType {
    return TokenType.significantDigit;
  }
}
