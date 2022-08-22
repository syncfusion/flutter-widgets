part of xlsio;

/// Class used for Format Section.
class _FormatSection {
  /// Initializes a new instance of the FormatSection class based on array of tokens.
  _FormatSection(Workbook workbook, List<_FormatTokenBase> arrTokens) {
    _workbook = workbook;
    _arrTokens = arrTokens;
    _prepareFormat();
  }

  /// Table for token type detection. Value in TokenType arrays must be sorted.
  final List<dynamic> _defultPossibleTokens = <dynamic>[
    <_TokenType>[
      _TokenType.unknown,
      _TokenType.string,
      _TokenType.reservedPlace,
      _TokenType.character,
      _TokenType.color
    ],
    ExcelFormatType.unknown,
    <_TokenType>[_TokenType.general, _TokenType.culture],
    ExcelFormatType.general,
    <_TokenType>[
      _TokenType.unknown,
      _TokenType.string,
      _TokenType.reservedPlace,
      _TokenType.character,
      _TokenType.color,
      _TokenType.condition,
      _TokenType.text,
      _TokenType.asterix,
      _TokenType.culture,
    ],
    ExcelFormatType.text,
    <_TokenType>[
      _TokenType.unknown,
      _TokenType.string,
      _TokenType.reservedPlace,
      _TokenType.character,
      _TokenType.color,
      _TokenType.condition,
      _TokenType.significantDigit,
      _TokenType.insignificantDigit,
      _TokenType.placeReservedDigit,
      _TokenType.percent,
      _TokenType.scientific,
      _TokenType.thousandsSeparator,
      _TokenType.decimalPoint,
      _TokenType.asterix,
      _TokenType.fraction,
      _TokenType.culture,
      _TokenType.dollar,
    ],
    ExcelFormatType.number,
    <_TokenType>[
      _TokenType.unknown,
      _TokenType.day,
      _TokenType.string,
      _TokenType.reservedPlace,
      _TokenType.character,
      _TokenType.color,
      _TokenType.condition,
      _TokenType.significantDigit,
      _TokenType.insignificantDigit,
      _TokenType.placeReservedDigit,
      _TokenType.percent,
      _TokenType.scientific,
      _TokenType.thousandsSeparator,
      _TokenType.decimalPoint,
      _TokenType.asterix,
      _TokenType.fraction,
      _TokenType.culture,
      _TokenType.dollar,
    ],
    ExcelFormatType.number,
    <_TokenType>[
      _TokenType.unknown,
      _TokenType.hour,
      _TokenType.hour24,
      _TokenType.minute,
      _TokenType.minuteTotal,
      _TokenType.second,
      _TokenType.secondTotal,
      _TokenType.year,
      _TokenType.month,
      _TokenType.day,
      _TokenType.string,
      _TokenType.reservedPlace,
      _TokenType.character,
      _TokenType.amPm,
      _TokenType.color,
      _TokenType.condition,
      _TokenType.significantDigit,
      _TokenType.decimalPoint,
      _TokenType.asterix,
      _TokenType.fraction,
      _TokenType.culture,
    ],
    ExcelFormatType.dateTime
  ];

  /// Break tokens when locating hour token.
  final List<_TokenType> _defultBreakHour = <_TokenType>[_TokenType.minute];

  /// Break tokens when locating second token.
  final List<_TokenType> _defultBreakSecond = <_TokenType>[
    _TokenType.minute,
    _TokenType.hour,
    _TokenType.day,
    _TokenType.month,
    _TokenType.year,
  ];

  /// Return this value when element wasn't found.
  final int _defultNotFoundIndex = -1;

  /// Possible digit tokens in the millisecond token.
  final List<dynamic> _defultMilliSecondTokens = <dynamic>[
    _TokenType.significantDigit,
  ];

  /// Maximum month token length.
  final int _defultMonthTokenLength = 5;

  /// Array of tokens.
  late List<_FormatTokenBase> _arrTokens;

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
  bool _isMilliSecondFormatValue = false;

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
      final _FormatTokenBase token = _arrTokens[i];

      switch (token._tokenType) {
        case _TokenType.amPm:
          final _HourToken? hour = _findCorrespondingHourSection(i);
          if (hour != null) {
            hour._isAmPm = true;
          }
          break;

        case _TokenType.minute:
          _checkMinuteToken(i);
          break;

        case _TokenType.decimalPoint:
          if (_iDecimalPointPos < 0) {
            _iDecimalPointPos = _assignPosition(_iDecimalPointPos, i);
          } else {
            _bMultiplePoints = true;
          }
          break;

        case _TokenType.scientific:
          _iScientificPos = _assignPosition(_iScientificPos, i);
          break;

        case _TokenType.significantDigit:
        case _TokenType.insignificantDigit:
        case _TokenType.placeReservedDigit:
          if (!bDigit) {
            bDigit = true;
          }
          break;

        case _TokenType.fraction:
          if (_iFractionPos < 0) {
            _iFractionPos = i;
            _bFraction = true;
          } else {
            _bFraction = false;
          }
          break;

        case _TokenType.unknown:
        case _TokenType.section:
        case _TokenType.hour:
        case _TokenType.hour24:
        case _TokenType.minuteTotal:
        case _TokenType.second:
        case _TokenType.secondTotal:
        case _TokenType.year:
        case _TokenType.month:
        case _TokenType.day:
        case _TokenType.string:
        case _TokenType.reservedPlace:
        case _TokenType.character:
        case _TokenType.color:
        case _TokenType.condition:
        case _TokenType.text:
        case _TokenType.percent:
        case _TokenType.general:
        case _TokenType.thousandsSeparator:
        case _TokenType.asterix:
        case _TokenType.milliSecond:
        case _TokenType.culture:
        case _TokenType.dollar:
          break;
      }
    }
  }

  /// Searches for corresponding hour token.
  _HourToken? _findCorrespondingHourSection(int index) {
    int i = index;

    do {
      i--;
      if (i < 0) {
        i += _count;
      }

      final _FormatTokenBase token = _arrTokens[i];

      if (token._tokenType == _TokenType.hour) {
        return token as _HourToken;
      }
    } while (i != index);

    return null;
  }

  /// Applies format to the value.
  String _applyFormat(double value, bool bShowReservedSymbols) {
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

    strResult = Worksheet._convertSecondsMinutesToHours(strResult, value);

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
      final _FormatTokenBase token = _arrTokens[i];
      final double tempValue = originalValue;
      String strTokenResult =
          token._applyFormat(tempValue, bShowReservedSymbols, culture, this);

      //If the Month token length is 5 , Ms Excel consider as 1.
      if (token is _MonthToken &&
          token._format.length == _defultMonthTokenLength) {
        strTokenResult = strTokenResult.substring(0, 1);
      }

      if (token is _MilliSecondToken) {
        final int milliSecond = int.parse(strTokenResult.substring(1));
        if (token._format == '0' && milliSecond >= 5) {
          _isMilliSecondFormatValue = true;
        } else if (token._format == '00' && milliSecond >= 50) {
          _isMilliSecondFormatValue = true;
        } else if (token._format == '000' && milliSecond >= 500) {
          _isMilliSecondFormatValue = true;
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
      final _FormatTokenBase token = _arrTokens[i];

      if (token._tokenType == _TokenType.percent) {
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
      final List<_TokenType> arrPossibleTokens =
          _defultPossibleTokens[i] as List<_TokenType>;
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
  bool _checkTokenTypes(List<_TokenType> arrPossibleTokens) {
    final int iCount = _count;
    if (iCount == 0 && arrPossibleTokens.isEmpty) {
      return true;
    }

    final int len = iCount;
    for (int i = 0; i < len; i++) {
      final _FormatTokenBase token = _arrTokens[i];

      if (!_containsIn(arrPossibleTokens, token._tokenType)) {
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
    final _FormatTokenBase token = _arrTokens[iTokenIndex];

    if (token._tokenType != _TokenType.minute) {
      final Error error = ArgumentError('Wrong token type.');
      throw error;
    }

    final bool bMinute = (_findTimeToken(iTokenIndex - 1, _defultBreakHour,
                false, <_TokenType>[_TokenType.hour, _TokenType.hour24]) !=
            -1) ||
        (_findTimeToken(iTokenIndex + 1, _defultBreakSecond, true,
                <_TokenType>[_TokenType.second, _TokenType.secondTotal]) !=
            -1);

    if (!bMinute) {
      final _MonthToken month = _MonthToken();
      month._format = token._format;
      _arrTokens[iTokenIndex] = month;
    }
  }

  /// Searches for required time token.
  int _findTimeToken(int iTokenIndex, List<_TokenType> arrBreakTypes,
      bool bForward, List<_TokenType> arrTypes) {
    final int iCount = _count;
    final int iDelta = bForward ? 1 : -1;

    while (iTokenIndex >= 0 && iTokenIndex < iCount) {
      final _FormatTokenBase token = _arrTokens[iTokenIndex];
      final _TokenType tokenType = token._tokenType;

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
      final _FormatTokenBase token = _arrTokens[i];

      if (token._tokenType == _TokenType.decimalPoint) {
        final int iStartIndex = i;
        String strFormat = '';

        i++;
        while (i < iCount &&
            // ignore: prefer_contains
            (_defultMilliSecondTokens.indexOf(_arrTokens[i]._tokenType) !=
                -1)) {
          strFormat += _arrTokens[i]._format;
          i++;
        }

        if (i != iStartIndex + 1) {
          final _MilliSecondToken milli = _MilliSecondToken();
          milli._format = strFormat;
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
      final _FormatTokenBase token = _arrTokens[i];

      if (token._tokenType == _TokenType.second) {
        (token as _SecondToken)._roundValue = false;
      }
    }
  }

  /// Indicates whether type of specified token is in the array of tokens.
  bool _containsIn(List<_TokenType> arrPossibleTokens, _TokenType token) {
    int iFirstIndex = 0;
    int iLastIndex = arrPossibleTokens.length - 1;

    while (iLastIndex != iFirstIndex) {
      final double iMiddleIndex = (iLastIndex + iFirstIndex) / 2;
      final _TokenType curToken = arrPossibleTokens[iMiddleIndex.floor()];

      if (_TokenType.values.indexOf(curToken) >=
          _TokenType.values.indexOf(token)) {
        if (iLastIndex == iMiddleIndex.floor()) {
          break;
        }

        iLastIndex = iMiddleIndex.floor();
      } else if (_TokenType.values.indexOf(curToken) <
          _TokenType.values.indexOf(token)) {
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
  static double _round(double value) {
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

  void _clear() {
    _arrTokens.clear();
  }
}
