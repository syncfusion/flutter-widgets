import '../../general/culture_info.dart';
import '../../range/range.dart';
import '../format_section.dart';
import '../format_tokens/enums.dart';
import 'format_token_base.dart';

/// Contains Am Pm Token descriptions.
class AmPmToken extends FormatTokenBase {
  final RegExp _aMPMRegex = RegExp('[Am/PM]{4,}');

  /// Edge between AM and PM symbols.
  static const int _defaultAMPMEdge = 12;

  /// AM symbol.
  static const String _defaultAM = 'AM';

  /// PM symbol.
  static const String _defaultPM = 'PM';

  /// Tries to parse format string.
  @override
  int tryParse(String strFormat, int iIndex) {
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
    return tryParseRegex(_aMPMRegex, strFormat, iIndex);
  }

  /// Applies format to the value.

  @override
  String applyFormat(double value, bool bShowHiddenSymbols, CultureInfo culture,
      FormatSection section) {
    final DateTime date = Range.fromOADate(value);

    final int iHour = date.hour;

    if (iHour >= _defaultAMPMEdge) {
      return _defaultPM;
    } else {
      return _defaultAM;
    }
  }

  /// Applies format to the value.
  @override
  // ignore: unused_element
  String applyFormatString(String value, bool bShowHiddenSymbols) {
    throw Exception();
  }

  /// Checks the AMPM is other pattern.
  // ignore: unused_element
  static String _checkAndApplyAMPM(String format) {
    return format;
  }

  /// Gets type of the token. Read-only.

  @override
  TokenType get tokenType {
    return TokenType.amPm;
  }
}
