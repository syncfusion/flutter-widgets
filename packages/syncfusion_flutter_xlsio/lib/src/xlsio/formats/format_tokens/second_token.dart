import '../../formats/format_tokens/enums.dart';
import '../../general/culture_info.dart';
import '../../range/range.dart';
import '../format_section.dart';
import 'format_token_base.dart';

/// Class used for Seconds Token.
class SecondToken extends FormatTokenBase {
  /// Regular expression for minutes part of the format:
  final RegExp _secondRegex = RegExp('[sS]+');

  /// Long type of the format.
  static const String defaultFormatLong = '00';

  /// Half of possible milliseconds.
  static const int defaultMilliSecondHalf = 500;

  /// Indicates whether number of seconds must be rounded.
  // ignore: prefer_final_fields
  bool roundValue = true;

  /// Tries to parse format string.
  @override
  int tryParse(String strFormat, int iIndex) {
    return tryParseRegex(_secondRegex, strFormat, iIndex);
  }

  /// Applies format to the value.

  @override
  String applyFormat(double value, bool bShowHiddenSymbols, CultureInfo culture,
      FormatSection section) {
    final DateTime date = Range.fromOADate(value);

    int iSecond = date.second;
    final int iMilliSecond = date.millisecond;

    if (roundValue && iMilliSecond >= defaultMilliSecondHalf) {
      iSecond++;
    }

    if (strFormat.length > 1) {
      /// when second is more than 59, display it as 00.
      return (iSecond > 59) ? defaultFormatLong : iSecond.toString();
    } else {
      return iSecond.toString();
    }
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
    return TokenType.second;
  }
}
