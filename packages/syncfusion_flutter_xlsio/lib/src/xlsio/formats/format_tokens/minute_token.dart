import '../../formats/format_tokens/enums.dart';
import '../../general/culture_info.dart';
import '../../range/range.dart';
import '../format_section.dart';
import 'format_token_base.dart';
import 'second_token.dart';

/// Class used for Minute Token.
class MinuteToken extends FormatTokenBase {
  /// Regular expression for minutes part of the format:
  final RegExp _minuteRegex = RegExp('[mM]+');

  /// Tries to parse format string.
  @override
  int tryParse(String strFormat, int iIndex) {
    return tryParseRegex(_minuteRegex, strFormat, iIndex);
  }

  /// Applies format to the value.
  @override
  String applyFormat(double value, bool bShowHiddenSymbols, CultureInfo culture,
      FormatSection section) {
    final DateTime date = Range.fromOADate(value);

    int iMinute = date.minute;
    final int iSecond = date.second;
    final int iMilliSecond = date.millisecond;
    if (iMilliSecond >= SecondToken.defaultMilliSecondHalf && iSecond == 59) {
      if (!section.isMilliSecondFormatValue) {
        iMinute++;
      } else {
        section.isMilliSecondFormatValue = false;
      }
    }

    if (strFormat.length > 1) {
      return iMinute.toString();
    } else {
      return iMinute.toString();
    }
  }

  /// Applies format to the value.
  @override
  // ignore: unused_element
  String applyFormatString(String value, bool bShowHiddenSymbols) {
    return '';
  }

  /// This method is called after format string was changed.
  @override
  void onFormatChange() {
    strFormat = strFormat.toLowerCase();
  }

  /// Gets type of the token. Read-only.
  @override
  TokenType get tokenType {
    return TokenType.minute;
  }
}
