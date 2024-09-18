import '../../formats/format_tokens/enums.dart';
import '../../general/culture_info.dart';
import '../../range/range.dart';
import '../format_section.dart';
import 'constants.dart';
import 'format_token_base.dart';

/// Class used for 24 hour Token.
class Hour24Token extends FormatTokenBase {
  /// Regular expression for hours part of the format:
  final RegExp _hourRegex = RegExp(r'\\[[hH]+\\]');

  /// Tries to parse format string.
  @override
  int tryParse(String stringFormat, int iIndex) {
    return tryParseRegex(_hourRegex, stringFormat, iIndex);
  }

  /// Applies format to the value.
  @override
  String applyFormat(double value, bool bShowHiddenSymbols, CultureInfo culture,
      FormatSection section) {
    double temp = value;
    if (temp <= 60) {
      temp = temp - 1;
    }
    final DateTime date = Range.fromOADate(value);
    double dHour;
    dHour = temp * FormatConstants.hoursInDay;
    dHour = (value > 0)
        ? (dHour % 24).ceilToDouble() == date.hour
            ? dHour.ceilToDouble()
            : dHour.floorToDouble()
        : dHour.ceilToDouble();
    if (dHour < 24) {
      dHour = date.hour.toDouble();
    }
    return dHour.toInt().toString();
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
    return TokenType.hour24;
  }
}
