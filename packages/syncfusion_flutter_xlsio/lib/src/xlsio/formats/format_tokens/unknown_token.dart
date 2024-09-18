import '../../formats/format_tokens/enums.dart';
import '../../general/culture_info.dart';
import '../format_section.dart';
import 'format_token_base.dart';

/// Class used for UnknownToken.

class UnknownToken extends FormatTokenBase {
  /// Tries to parse format string.

  @override
  int tryParse(String stringFormat, int iIndex) {
    final int iFormatLength = stringFormat.length;

    if (iFormatLength == 0) {
      final Error error =
          ArgumentError('stringFormat - string cannot be empty');
      throw error;
    }
    strFormat = stringFormat[iIndex];
    return iIndex + 1;
  }

  /// Applies format to the value.

  @override
  String applyFormat(double value, bool bShowHiddenSymbols, CultureInfo culture,
      FormatSection section) {
    if (strFormat == 'g' || strFormat == 'G') {
      return '';
    } else {
      return strFormat;
    }
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
    return TokenType.unknown;
  }
}
