import '../../formats/format_tokens/enums.dart';
import '../../general/culture_info.dart';
import '../format_section.dart';
import 'format_token_base.dart';

/// Class used for describing DecimalSeparatorToken.
class DecimalPointToken extends FormatTokenBase {
  /// Format character.
  static const String _defaultFormat = '.';

  /// Applies format to the value.
  @override
  String applyFormat(double value, bool bShowHiddenSymbols, CultureInfo culture,
      FormatSection section) {
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
          'iIndex - Value cannot be less than 0 and greater than than format length - 1.');
      throw error;
    }

    final String chCurrent = stringFormat[iIndex];

    if (chCurrent == _defaultFormat) {
      iIndex++;
      strFormat = chCurrent;
    } else if (stringFormat[iIndex] == r'\\' &&
        stringFormat[iIndex + 1] == _defaultFormat) {
      strFormat = stringFormat[iIndex + 1];
      iIndex = iIndex + 2;
    }
    return iIndex;
  }

  /// Applies format to the value.
  @override
  // ignore: unused_element
  String applyFormatString(String value, bool bShowHiddenSymbols) {
    return '';
  }

  /// Gets type of the token. Read-only.
  @override
  TokenType get tokenType {
    return TokenType.decimalPoint;
  }
}
