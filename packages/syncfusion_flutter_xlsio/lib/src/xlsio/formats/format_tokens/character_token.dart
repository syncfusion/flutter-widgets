import '../../general/culture_info.dart';
import '../format_section.dart';
import '../format_tokens/enums.dart';
import 'format_token_base.dart';

/// Class used for Character Token.
class CharacterToken extends FormatTokenBase {
  /// Start of the token.
  static const String _defaultStart = r'\\';
  static const String _defaultFormatChar = '@';
  static const String _defaultChar = '-';
  static const String _defaultCharSpace = ' ';

  /// Tries to parse format string.
  @override
  int tryParse(String stringFormat, int iIndex) {
    final int iFormatLength = stringFormat.length;

    if (iFormatLength == 0) {
      final Error error =
          ArgumentError('stringFormat - string cannot be empty.');
      throw error;
    }

    if (stringFormat[iIndex] == _defaultChar) {
      strFormat = stringFormat[iIndex];
      iIndex++;
    } else if (stringFormat[iIndex] == _defaultCharSpace) {
      strFormat = stringFormat[iIndex];
      iIndex++;
    } else if (stringFormat[iIndex] == _defaultStart) {
      strFormat = stringFormat[iIndex + 1];
      if (strFormat != _defaultFormatChar) {
        iIndex += 2;
      } else {
        strFormat = _defaultFormatChar;
      }
    } else if (stringFormat[iIndex] == '[' &&
        stringFormat[iIndex + 2] == r'\$') {
      strFormat = stringFormat[iIndex + 1];
      iIndex = stringFormat.indexOf(']', iIndex + 3) + 1;
    }

    return iIndex;
  }

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

  /// Gets type of the token. Read-only.

  @override
  TokenType get tokenType {
    return TokenType.character;
  }
}
