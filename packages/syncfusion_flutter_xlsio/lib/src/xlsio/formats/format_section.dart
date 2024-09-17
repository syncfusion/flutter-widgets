import '../formats/format_tokens/enums.dart';
import '../formats/format_tokens/format_token_base.dart';
import '../formats/format_tokens/hour_token.dart';
import '../formats/format_tokens/milli_second_token.dart';
import '../formats/format_tokens/month_token.dart';
import '../formats/format_tokens/second_token.dart';
import '../general/culture_info.dart';
import '../general/enums.dart';
import '../general/workbook.dart';
import '../worksheet/worksheet.dart';

/// Class used for Format Section.
class FormatSection {
  /// Initializes a new instance of the FormatSection class based on array of tokens.
  FormatSection(Workbook workbook, List<FormatTokenBase> arrTokens) {
    _workbook = workbook;
    _arrTokens = arrTokens;
    _prepareFormat();
  }

  /// Table for token type detection. Value in TokenType arrays must be sorted.
  final List<dynamic> _defultPossibleTokens = <dynamic>[
    <TokenType>[
      TokenType.unknown,
      TokenType.string,
      TokenType.reservedPlace,
      TokenType.character,
      TokenType.color
    ],
    ExcelFormatType.unknown,
    <TokenType>[TokenType.general, TokenType.culture],
    ExcelFormatType.general,
    <TokenType>[
      TokenType.unknown,
      TokenType.string,
      TokenType.reservedPlace,
      TokenType.character,
      TokenType.color,
      TokenType.condition,
      TokenType.text,
      TokenType.asterix,
      TokenType.culture,
    ],
    ExcelFormatType.text,
    <TokenType>[
      TokenType.unknown,
      TokenType.string,
      TokenType.reservedPlace,
      TokenType.character,
      TokenType.color,
      TokenType.condition,
      TokenType.significantDigit,
      TokenType.insignificantDigit,
      TokenType.placeReservedDigit,
      TokenType.percent,
      TokenType.scientific,
      TokenType.thousandsSeparator,
      TokenType.decimalPoint,
      TokenType.asterix,
      TokenType.fraction,
      TokenType.culture,
      TokenType.dollar,
    ],
    ExcelFormatType.number,
    <TokenType>[
      TokenType.unknown,
      TokenType.day,
      TokenType.string,
      TokenType.reservedPlace,
      TokenType.character,
      TokenType.color,
      TokenType.condition,
      TokenType.significantDigit,
      TokenType.insignificantDigit,
      TokenType.placeReservedDigit,
      TokenType.percent,
      TokenType.scientific,
      TokenType.thousandsSeparator,
      TokenType.decimalPoint,
      TokenType.asterix,
      TokenType.fraction,
      TokenType.culture,
      TokenType.dollar,
    ],
    ExcelFormatType.number,
    <TokenType>[
      TokenType.unknown,
      TokenType.hour,
      TokenType.hour24,
      TokenType.minute,
      TokenType.minuteTotal,
      TokenType.second,
      TokenType.secondTotal,
      TokenType.year,
      TokenType.month,
      TokenType.day,
      TokenType.string,
      TokenType.reservedPlace,
      TokenType.character,
      TokenType.amPm,
      TokenType.color,
      TokenType.condition,
      TokenType.significantDigit,
      TokenType.decimalPoint,
      TokenType.asterix,
      TokenType.fraction,
      TokenType.culture,
    ],
    ExcelFormatType.dateTime
  ];

  /// Break tokens when locating hour token.
  final List<TokenType> _defultBreakHour = <TokenType>[TokenType.minute];

  /// Break tokens when locating second token.
  final List<TokenType> _defultBreakSecond = <TokenType>[
    TokenType.minute,
    TokenType.hour,
    TokenType.day,
    TokenType.month,
    TokenType.year,
  ];

  /// Return this value when element wasn't found.
  final int _defultNotFoundIndex = -1;

  /// Possible digit tokens in the millisecond token.
  final List<dynamic> _defultMilliSecondTokens = <dynamic>[
    TokenType.significantDigit,
  ];

  /// Maximum month token length.
  final int _defultMonthTokenLength = 5;

  /// Array of tokens.
  late List<FormatTokenBase> _arrTokens;

  /// Indicates whether format is prepared.
  bool _bFormatPrepared = false;

  /// Position of decimal separator.
  int _iDecimalPointPos = -1;

  /// Position of E/E+ or E- signs in format string.
  int _iScientificPos = -1;

  /// Position where fraction sign '/' was met for the first time.
  int _iFractionPos = -1;

  /// Indicates whether number format contains fraction sign.
  bool _bFraction = false;

  /// End position of the integer value.
  int _iIntegerEnd = -1;

  /// Section format type.
  ExcelFormatType _formatType = ExcelFormatType.unknown;

  /// Indicates whether we digits must be grouped.
  final bool _bGroupDigits = false;

  /// Indicates whether more than one decimal point was met in the format string.
  bool _bMultiplePoints = false;

  /// Indicates whether the milli second format having the value.
  bool isMilliSecondFormatValue = false;

  /// Represents the workbook.
  late Workbook _workbook;

  /// Gets the number of tokens in the section.
  int get _count {
    return _arrTokens.length;
  }

  /// Gets the section type.
  ExcelFormatType get formatType {
    if (_formatType == ExcelFormatType.unknown) {
      _detectFormatType();
    }

    return _formatType;
  }

  /// Prepares format if necessary.
  void _prepareFormat() {
    if (_bFormatPrepared) {
      return;
    }

    _preparePositions();

    if (formatType == ExcelFormatType.dateTime) {
      _setRoundSeconds();
      _iDecimalPointPos = -1;
      _bFraction = false;
    }

    _iIntegerEnd = _count - 1;
    _bFormatPrepared = true;
  }

  /// Prepares tokens and sets iternal position pointers.
  void _preparePositions() {
    bool bDigit = false;
    _bMultiplePoints = false;

    final int len = _count;
    for (int i = 0; i < len; i++) {
      final FormatTokenBase token = _arrTokens[i];

      switch (token.tokenType) {
        case TokenType.amPm:
          final HourToken? hour = _findCorrespondingHourSection(i);
          if (hour != null) {
            hour.isAmPm = true;
          }
          break;

        case TokenType.minute:
          _checkMinuteToken(i);
          break;

        case TokenType.decimalPoint:
          if (_iDecimalPointPos < 0) {
            _iDecimalPointPos = _assignPosition(_iDecimalPointPos, i);
          } else {
            _bMultiplePoints = true;
          }
          break;

        case TokenType.scientific:
          _iScientificPos = _assignPosition(_iScientificPos, i);
          break;

        case TokenType.significantDigit:
        case TokenType.insignificantDigit:
        case TokenType.placeReservedDigit:
          if (!bDigit) {
            bDigit = true;
          }
          break;

        case TokenType.fraction:
          if (_iFractionPos < 0) {
            _iFractionPos = i;
            _bFraction = true;
          } else {
            _bFraction = false;
          }
          break;

        case TokenType.unknown:
        case TokenType.section:
        case TokenType.hour:
        case TokenType.hour24:
        case TokenType.minuteTotal:
        case TokenType.second:
        case TokenType.secondTotal:
        case TokenType.year:
        case TokenType.month:
        case TokenType.day:
        case TokenType.string:
        case TokenType.reservedPlace:
        case TokenType.character:
        case TokenType.color:
        case TokenType.condition:
        case TokenType.text:
        case TokenType.percent:
        case TokenType.general:
        case TokenType.thousandsSeparator:
        case TokenType.asterix:
        case TokenType.milliSecond:
        case TokenType.culture:
        case TokenType.dollar:
          break;
      }
    }
  }

  /// Searches for corresponding hour token.
  HourToken? _findCorrespondingHourSection(int index) {
    int i = index;

    do {
      i--;
      if (i < 0) {
        i += _count;
      }

      final FormatTokenBase token = _arrTokens[i];

      if (token.tokenType == TokenType.hour) {
        return token as HourToken;
      }
    } while (i != index);

    return null;
  }

  /// Applies format to the value.
  String applyFormat(double value, bool bShowReservedSymbols) {
    _prepareFormat();
    value = _prepareValue(value, bShowReservedSymbols);

    double dFractionValue = 0;

    if (_formatType == ExcelFormatType.dateTime) {
      value = double.parse(value.toStringAsFixed(10));
    }
    bool bAddNegative = value < 0;

    if (value == 0) {
      bAddNegative &= dFractionValue > 0;
    }
    String strResult;
    strResult = _applyFormatNumber(value, bShowReservedSymbols, 0, _iIntegerEnd,
        false, _bGroupDigits, bAddNegative);

    strResult = Worksheet.convertSecondsMinutesToHours(strResult, value);

    if (_bFraction) {
      dFractionValue = value;
    }
    return strResult;
  }

  /// Assigns position to the variable and checks if it wasn't assigned
  ///  before (throws ForamtException if it was).
  int _assignPosition(int iToAssign, int iCurrentPos) {
    if (iToAssign >= 0) {
      throw const FormatException();
    }

    iToAssign = iCurrentPos;
    return iToAssign;
  }

  /// Applies part of the format tokens to the value.
  String _applyFormatNumber(
      double value,
      bool bShowReservedSymbols,
      int iStartToken,
      int iEndToken,
      bool bForward,
      bool bGroupDigits,
      bool bAddNegativeSign) {
    final List<String> builder = <String>[];
    final int iDelta = bForward ? 1 : -1;
    final int iStart = bForward ? iStartToken : iEndToken;
    final int iEnd = bForward ? iEndToken : iStartToken;
    final CultureInfo culture = _workbook.cultureInfo;
    final double originalValue = value;

    for (int i = iStart; _checkCondition(iEnd, bForward, i); i += iDelta) {
      final FormatTokenBase token = _arrTokens[i];
      final double tempValue = originalValue;
      String strTokenResult =
          token.applyFormat(tempValue, bShowReservedSymbols, culture, this);

      //If the Month token length is 5 , Ms Excel consider as 1.
      if (token is MonthToken &&
          token.format.length == _defultMonthTokenLength) {
        strTokenResult = strTokenResult.substring(0, 1);
      }

      if (token is MilliSecondToken) {
        final int milliSecond = int.parse(strTokenResult.substring(1));
        if (token.format == '0' && milliSecond >= 5) {
          isMilliSecondFormatValue = true;
        } else if (token.format == '00' && milliSecond >= 50) {
          isMilliSecondFormatValue = true;
        } else if (token.format == '000' && milliSecond >= 500) {
          isMilliSecondFormatValue = true;
        }
      }

      builder.add(strTokenResult);
    }

    if (bForward) {
      return builder.join();
    } else {
      return builder.reversed.join();
    }
  }

  /// Checks whether iPos is inside range of correct values.
  bool _checkCondition(int iEndToken, bool bForward, int iPos) {
    return bForward ? iPos <= iEndToken : iPos >= iEndToken;
  }

  /// Prepares value for format application.
  double _prepareValue(double value, bool bShowReservedSymbols) {
    final int len = _count;
    for (int i = 0; i < len; i++) {
      final FormatTokenBase token = _arrTokens[i];

      if (token.tokenType == TokenType.percent) {
        value *= 100;
      }
    }
    return value;
  }

  /// Tries to detect format type.
  void _detectFormatType() {
    _formatType = ExcelFormatType.unknown;

    final int len = _defultPossibleTokens.length;
    for (int i = 0; i < len; i += 2) {
      final List<TokenType> arrPossibleTokens =
          _defultPossibleTokens[i] as List<TokenType>;
      final ExcelFormatType formatType =
          _defultPossibleTokens[i + 1] as ExcelFormatType;

      if (formatType == ExcelFormatType.number && _bMultiplePoints) {
        continue;
      }

      if (_checkTokenTypes(arrPossibleTokens)) {
        _formatType = formatType;
        break;
      }
    }
  }

  /// Checks whether section contains only specified token types.
  bool _checkTokenTypes(List<TokenType> arrPossibleTokens) {
    final int iCount = _count;
    if (iCount == 0 && arrPossibleTokens.isEmpty) {
      return true;
    }

    final int len = iCount;
    for (int i = 0; i < len; i++) {
      final FormatTokenBase token = _arrTokens[i];

      if (!_containsIn(arrPossibleTokens, token.tokenType)) {
        return false;
      }
    }

    return true;
  }

  /// Check whether this token is really minute token and substitutes it by Month if necessary.
  void _checkMinuteToken(int iTokenIndex) {
    // Here we should check whether this token is really minute token
    // or it is month token. It can be minute token if it has hour
    // section before it or second section after it.
    final FormatTokenBase token = _arrTokens[iTokenIndex];

    if (token.tokenType != TokenType.minute) {
      final Error error = ArgumentError('Wrong token type.');
      throw error;
    }

    final bool bMinute = (_findTimeToken(iTokenIndex - 1, _defultBreakHour,
                false, <TokenType>[TokenType.hour, TokenType.hour24]) !=
            -1) ||
        (_findTimeToken(iTokenIndex + 1, _defultBreakSecond, true,
                <TokenType>[TokenType.second, TokenType.secondTotal]) !=
            -1);

    if (!bMinute) {
      final MonthToken month = MonthToken();
      month.format = token.format;
      _arrTokens[iTokenIndex] = month;
    }
  }

  /// Searches for required time token.
  int _findTimeToken(int iTokenIndex, List<TokenType> arrBreakTypes,
      bool bForward, List<TokenType> arrTypes) {
    final int iCount = _count;
    final int iDelta = bForward ? 1 : -1;

    while (iTokenIndex >= 0 && iTokenIndex < iCount) {
      final FormatTokenBase token = _arrTokens[iTokenIndex];
      final TokenType tokenType = token.tokenType;

      if (arrBreakTypes.contains(tokenType)) {
        break;
      }

      if (arrTypes.contains(tokenType)) {
        return iTokenIndex;
      }

      iTokenIndex += iDelta;
    }

    return _defultNotFoundIndex;
  }

  /// Sets to all second tokens.

  void _setRoundSeconds() {
    bool bRound = true;
    int iCount = _count;

    for (int i = 0; i < iCount; i++) {
      final FormatTokenBase token = _arrTokens[i];

      if (token.tokenType == TokenType.decimalPoint) {
        final int iStartIndex = i;
        String strFormat = '';

        i++;
        while (i < iCount &&
            // ignore: prefer_contains
            (_defultMilliSecondTokens.indexOf(_arrTokens[i].tokenType) != -1)) {
          strFormat += _arrTokens[i].format;
          i++;
        }

        if (i != iStartIndex + 1) {
          final MilliSecondToken milli = MilliSecondToken();
          milli.format = strFormat;
          final int iRemoveCount = i - iStartIndex;
          _arrTokens.removeRange(iStartIndex, iStartIndex + iRemoveCount);
          _arrTokens.insert(iStartIndex, milli);
          iCount -= iRemoveCount - 1;
          bRound = false;
        }
      }
    }

    if (bRound) {
      return;
    }

    for (int i = 0; i < iCount; i++) {
      final FormatTokenBase token = _arrTokens[i];

      if (token.tokenType == TokenType.second) {
        (token as SecondToken).roundValue = false;
      }
    }
  }

  /// Indicates whether type of specified token is in the array of tokens.
  bool _containsIn(List<TokenType> arrPossibleTokens, TokenType token) {
    int iFirstIndex = 0;
    int iLastIndex = arrPossibleTokens.length - 1;

    while (iLastIndex != iFirstIndex) {
      final double iMiddleIndex = (iLastIndex + iFirstIndex) / 2;
      final TokenType curToken = arrPossibleTokens[iMiddleIndex.floor()];

      if (TokenType.values.indexOf(curToken) >=
          TokenType.values.indexOf(token)) {
        if (iLastIndex == iMiddleIndex.floor()) {
          break;
        }

        iLastIndex = iMiddleIndex.floor();
      } else if (TokenType.values.indexOf(curToken) <
          TokenType.values.indexOf(token)) {
        if (iFirstIndex == iMiddleIndex.floor()) {
          break;
        }

        iFirstIndex = iMiddleIndex.floor();
      }
    }

    return arrPossibleTokens[iFirstIndex] == token ||
        arrPossibleTokens[iLastIndex] == token;
  }

  /// Rounds value.
  static double round(double value) {
    final bool bLargerThanZero = value >= 0;
    double dIntPart =
        bLargerThanZero ? value.floor().toDouble() : value.ceil().toDouble();

    final int iSign = value.sign.toInt();

    final double dFloatPart =
        bLargerThanZero ? value - dIntPart : dIntPart - value;

    if (dFloatPart >= 0.49999999999999995) {
      dIntPart += iSign;
    }

    return dIntPart;
  }

  void clear() {
    _arrTokens.clear();
  }
}
