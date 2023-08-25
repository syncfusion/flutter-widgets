part of xlsio;

/// CalcEngine encapsulates the code required to parse and compute formulas.
class CalcEngine {
  /// Create a new instance for CalcEngine.
  CalcEngine(Worksheet parentObject) {
    _grid = parentObject;
    _initLibraryFunctions();

    _tokens = <String>[
      _tokenAdd,
      _tokenSubtract,
      _tokenMultiply,
      _tokenDivide,
      _tokenLess,
      _tokenGreater,
      _tokenEqual,
      _tokenLesseq,
      _tokenGreaterEq,
      _tokenNoEqual,
      _tokenAnd,
      _tokenOr
    ];

    _dateTime1900Double = Range._toOADate(_dateTime1900);
  }
  static SheetFamilyItem? _defaultFamilyItem;
  static Map<dynamic, dynamic>? _modelToSheetID;
  static Map<dynamic, dynamic>? _sheetFamiliesList;
  static int _sheetFamilyID = 0;

  /// A static property that gets/sets character to be recognized by the parsing code as the delimiter for arguments in a named formula's argument list.
  static String parseArgumentSeparator = ',';

  /// A static property that gets/sets the character to be recognized by the parsing engine as decimal separator for numbers.
  static String parseDecimalSeparator = '.';

  /// A static property that gets/sets the character to be recognized by the parsing engine as datetime separator for date.
  static String parseDateTimeSeparator = '/';

  /// Gets or sets whether dates can be used as operands in calculations. The default value is false.
  bool useDatesInCalculations = false;

  /// A property that gets/sets whether Strings concatenated using the '&amp;' operator should be
  /// returned inside double quote marks.
  bool useNoAmpersandQuotes = false;

  /// A property that gets or sets the calculations of the <see cref='CalcEngine'/> computations to mimic the computations of Excel.
  bool excelLikeComputations = false;
  final bool _currentRowNotationEnabled = true;
  static int _tokenCount = 0;
  Worksheet? _grid;
  List<String>? _sortedSheetNames;
  static const String _sheetToken = '!';
  static const int _intMaxValue = 2147483647;
  static const int _intMinValue = -2147483648;
  static const String _tokenAdd = 'a';
  static const String _tokenSubtract = 's';
  static const String _tokenMultiply = 'm';
  static const String _tokenDivide = 'd';
  static const String _tokenLess = 'l';
  static const String _tokenGreater = 'g';
  static const String _tokenEqual = 'e';
  static const String _tokenLesseq = 'k';
  static const String _tokenGreaterEq = 'j';
  static const String _tokenNoEqual = 'o';
  static const String _tokenAnd = 'c';
  static const String _tokenOr = '~';

  final String _braceLeft = '{';
  final String _braceRight = '}';
  final String _stringAnd = '&'; ////'AND';
  final String _trueValueStr = 'TRUE';
  final String _falseValueStr = 'FALSE';
  final String _stringOr = '^'; ////'OR';
  final String _charTIC = "'";
  final String _tic = '"';
  static String _formulaChar = '=';
  final String _uniqueStringMarker = String.fromCharCode(127);
  final String _markerChar = '`';
  final String _ifMarker = 'qIF${String.fromCharCode(130)}';

  static const String _stringFixedReference = r'$';
  static const String _stringGreaterEq = '>=';
  static const String _stringLessEq = '<=';
  static const String _stringNoEqual = '<>';

  final String _rightBracket = String.fromCharCode(131);
  final String _leftBracket = String.fromCharCode(130);
  static final String _bMarker = String.fromCharCode(146);
  final String _bMarker2 = _bMarker + _bMarker;

  final String _charAnd = 'i';
  final String _charOr = 'w';
  static const String _charDivide = '/';
  static const String _charAdd = '+';
  static const String _charSubtract = '-';
  static const String _charLess = '<';
  static const String _charLesseq = 'f';
  static const String _charEqual = '=';
  static const String _charGreaterEq = 'h';
  static const String _charNoEqual = 'p';
  static const String _charMultiply = '*';
  static const String _charGreater = '>';

  final String _charEP = 'x';
  final String _charEM = 'r';

  static const String _tokenEM = 'v';
  static const String _tokenEP = 't';

  final int _operatorsCannotStartAnExpression = 0;
  final int _cannotParse = 1;
  final int _badLibrary = 2;
  final int _numberContains2DecimalPoints = 4;
  final int _expressionCannotEndWithAnOperator = 5;
  final int _invalidCharactersFollowingAnOperator = 6;
  final int _mismatchedParentheses = 8;
  final int _requiresASingleArgument = 10;
  final int _requires3Args = 11;
  final int _badIndex = 14;
  final int _tooComplex = 15;
  final int _missingFormula = 17;
  final int _improperFormula = 18;
  final int _cellEmpty = 20;
  final int _badFormula = 21;
  final int _emptyExpression = 22;
  final int _mismatchedTics = 24;
  final int _wrongNumberArguments = 25;
  final int _invalidArguments = 26;
  final int _missingSheet = 30;

  bool _inAPull = false;
  final bool _checkDanglingStack = false;
  bool _isRangeOperand = false;
  bool _multiTick = false;
  bool _isInteriorFunction = false;

  final DateTime _dateTime1900 = DateTime(1900);
  late double _dateTime1900Double;

  /// This field holds equivalent double value of 1904(DateTime).
  static const double _oADate1904 = 1462.0;

  /// Set the boolean as true
  static const bool _treat1900AsLeapYear = true;
  List<String> _tokens = <String>[];

  ///used to force refreshing calculations
  int _calcID = 0;
  bool _useFormulaValues = false;

  /// Field that turns on/off processing of the ICalcData.ValueChanged event.
  bool _ignoreValueChanged = false;
  ////Holds the cell being calculated.. set in CellModel.GetFormattedText.
  String _cell = '';
  int _computedValueLevel = 0;
  final int _maximumRecursiveCalls = 100;
  final bool _supportRangeOperands = true;
  bool _exceptionThrown = false;

  /// Gets or sets whether the formula is array formula or not.
  bool _isArrayFormula = false;
  bool _ignoreSubtotal = false;
  final bool _treatStringsAsZero = true;

  /// Below property is set as true when the DoubleTIC replace with '~' symbol.
  bool _isDoubleQuotes = false;
  bool _ignoreBracet = false;
  final bool _rethrowExceptions = false;
  final bool _supportLogicalOperators = false;
  final bool _supportsSheetRanges = true;
  final String _tempSheetPlaceHolder = String.fromCharCode(133);

  final int _columnMaxCount = -1;
  // ignore: unused_field
  int _hitCount = 0;
  Map<dynamic, dynamic>? _libraryFunctions;
  final String _validFunctionNameChars = '_';
  final bool _getValueFromArgPreserveLeadingZeros = false;
  bool _ignoreCellValue = false;
  bool _findNamedRange = false;
  // ignore: unused_field
  bool _exteriorFormula = false;
  bool _isIndexInteriorFormula = false;
  bool _isErrorString = false;
  // default value is false.This proerty set as true when the cell is empty.
  // ignore: prefer_final_fields
  bool _matchType = false;

  /// This field will be set as true, if the 1904 date system is enabled in Excel.
  final bool _useDate1904 = false;
  final List<String> _errorStrings = <String>[
    '#N/A',
    '#VALUE!',
    '#REF!',
    '#DIV/0!',
    '#NUM!',
    '#NAME?',
    '#NULL!'
  ];

  /// The list of error strings which are used within the Essential Calculate internally. Users can make changes to this internal error strings.
  /// Default settings by assigning the new strings to the corresponding position.Reload_errorStrings should be invoked to reset or modify the internal error strings.
  final List<String> _formulaErrorStrings = <String>[
    'binary operators cannot start an expression', ////0
    'cannot parse', ////1
    'bad library', ////2
    'invalid char in front of', ////3
    'number contains 2 decimal points', ////4
    'expression cannot end with an operator', ////5
    'invalid characters following an operator', ////6
    'invalid character in number', ////7
    'mismatched parentheses', ////8
    'unknown formula name', ////9
    'requires a single argument', ////10
    'requires 3 arguments', ////11
    'invalid Math argument', ////12
    'requires 2 arguments', ////13
    '#NAME?', ////'bad index',						////14
    'too complex', ////15
    'circular reference: ', ////16
    'missing formula', ////17
    'improper formula', ////18
    'invalid expression', ////19
    'cell empty', ////20
    'bad formula', ////21
    'empty expression', ////22
    '', ////23
    'mismatched string quotes', ////24
    'wrong number of arguments', ////25
    'invalid arguments', ////26
    'iterations do not converge', ////27
    'Control named "{0}" is already registered', ////28
    'Calculation overflow', ////29
    'Missing sheet' ////30
  ];

  /// A static property that gets/sets character by which string starts with, can be treated as formula.
  static String get _formulaCharacter {
    if (_formulaChar == '0') {
      _formulaChar = '=';
    }
    return _formulaChar;
  }

  List<String>? get _sortedSheetNamesList {
    final SheetFamilyItem? family = _getSheetFamilyItem(_grid);

    if (_sortedSheetNames == null) {
      if (family != null && family._sheetNameToToken != null) {
        final List<String> names =
            family._sheetNameToToken!.keys.cast<String>().toList();
        _sortedSheetNames = names.map((String s) => s).toList();
        _sortedSheetNames!.sort();
      }
    }
    return _sortedSheetNames;
  }

  ////Used to determine if this CalcEngine instance is a member of
  ////several sheets. If so, then dependent cells are tracked through a static member
  ////so that they are known across instances.
  bool get _isSheeted {
    final SheetFamilyItem? family = _getSheetFamilyItem(_grid);
    return family != null && family._isSheeted;
  }

  /// A read-only property that gets a mapping between a formula cell and a list of cells upon which it depends.
  Map<dynamic, dynamic>? get _dependentFormulaCells {
    if (_isSheeted) {
      final SheetFamilyItem? family = _getSheetFamilyItem(_grid);
      family!._sheetDependentFormulaCells ??= <dynamic, dynamic>{};

      return family._sheetDependentFormulaCells;
    }
    return <dynamic, dynamic>{};
  }

  /// A read-only property that gets the collection of FormulaInfo Objects being used by the CalcEngine.
  Map<dynamic, dynamic>? get _formulaInfoTable {
    if (_isSheeted) {
      final SheetFamilyItem? family = _getSheetFamilyItem(_grid);
      family!._sheetFormulaInfoTable ??= <dynamic, dynamic>{};

      return family._sheetFormulaInfoTable;
    }
    return <dynamic, dynamic>{};
  }

  /// createSheetFamilyID is a method to create familyID for a sheet.
  static int createSheetFamilyID() {
    if (_sheetFamilyID == _intMaxValue) {
      _sheetFamilyID = _intMinValue;
    }

    return _sheetFamilyID++;
  }

  /// register_gridAsSheet is a method that registers an Worksheet Object so it can be referenced in a formula from another Worksheet Object.
  void _registerGridAsSheet(
      String refName, Worksheet model, int sheetFamilyID) {
    refName = refName.replaceAll("'", "''");

    _modelToSheetID ??= <dynamic, dynamic>{};

    if (_modelToSheetID![model] == null) {
      _modelToSheetID![model] = sheetFamilyID;
    }
    final SheetFamilyItem? family = _getSheetFamilyItem(model);

    family!._isSheeted = true;

    final String refName1 = refName.toUpperCase();

    family._sheetNameToParentObject ??= <dynamic, dynamic>{};

    family._tokenToParentObject ??= <dynamic, dynamic>{};

    family._sheetNameToToken ??= <dynamic, dynamic>{};

    family._parentObjectToToken ??= <dynamic, dynamic>{};

    if (family._sheetNameToParentObject!.containsKey(refName1)) {
      final String token = family._sheetNameToToken![refName1] as String;

      family._tokenToParentObject![token] = model;
      family._parentObjectToToken![model] = token;
    } else {
      final String token = _sheetToken + _tokenCount.toString() + _sheetToken;
      _tokenCount++;

      family._tokenToParentObject![token] = model;
      family._sheetNameToToken![refName1] = token;
      family._sheetNameToParentObject![refName1] = model;
      family._parentObjectToToken![model] = token;
      _sortedSheetNames = null;
    }
  }

  static SheetFamilyItem? _getSheetFamilyItem(Worksheet? model) {
    if (model == null) {
      return null;
    }

    if (_sheetFamilyID == 0) {
      _defaultFamilyItem ??= SheetFamilyItem();

      return _defaultFamilyItem;
    }

    _sheetFamiliesList ??= <dynamic, dynamic>{};

    final int i =
        _modelToSheetID![model] != null ? _modelToSheetID![model] as int : 0;

    if (_sheetFamiliesList![i] == null) {
      _sheetFamiliesList![i] = SheetFamilyItem();
    }

    return _sheetFamiliesList![i] as SheetFamilyItem;
  }

  /// A method that adds a function to the function library.
  bool _addFunction(String name, String func) {
    name = name.toUpperCase();
    if (!_libraryFunctions!.containsKey(name)) {
      _libraryFunctions![name] = func;
      return true;
    }
    return false;
  }

  /// Creates and initially loads the function library with the supported functions.
  void _initLibraryFunctions() {
    _libraryFunctions = <dynamic, dynamic>{};
    _addFunction('Sum', '_computeSum');
    _addFunction('Average', '_computeAvg');
    _addFunction('Max', '_computeMax');
    _addFunction('Min', '_computeMin');
    _addFunction('Count', '_computeCount');
    _addFunction('If', '_computeIf');
    _addFunction('Index', '_computeIndex');
    _addFunction('Match', '_computeMatch');
    _addFunction('And', '_computeAnd');
    _addFunction('Or', '_computeOr');
    _addFunction('Not', '_computeNot');
    _addFunction('Today', '_computeToday');
    _addFunction('Now', '_computeNow');
    _addFunction('Trim', '_computeTrim');
    _addFunction('Concatenate', '_computeConcatenate');
    _addFunction('Upper', '_computeUpper');
    _addFunction('Lower', '_computeLower');
    _addFunction('AverageIFS', '_computeAverageIFS');
    _addFunction('SumIFS', '_computeSumIFS');
    _addFunction('MinIFS', '_computeMinIFS');
    _addFunction('MaxIFS', '_computeMaxIFS');
    _addFunction('CountIFS', '_computeCountIFS');
    _addFunction('VLookUp', '_computeVLoopUp');
    _addFunction('SumIf', '_computeSumIf');
    _addFunction('SumProduct', '_computeSumProduct');
    _addFunction('Product', '_computeProduct');
    _addFunction('Row', '_computeRow');
  }

  /// A method that increases the calculation level of the CalcEngine.
  void _updateCalcID() {
    _calcID++;
    if (_calcID == _intMaxValue) {
      _calcID = _intMinValue + 1;
    }
  }

  /// This method retrieves the value in the requested cell reference using fresh computations
  /// for any cells that affect the value of the requested cell.
  String _pullUpdatedValue(String cellRef) {
    bool isUseFormulaValueChanged = false;
    _inAPull = true;
    _multiTick = false;
    final Worksheet? grd = _grid;
    final String saveCell = _cell;
    final String s = cellRef.toUpperCase();

    _updateCalcID();
    String txt = '';
    if (!_dependentFormulaCells!.containsKey(s) &&
        !_formulaInfoTable!.containsKey(s)) {
      txt = _getValueFromParentObject(s, true);

      if (_useFormulaValues) {
        isUseFormulaValueChanged = true;
        _useFormulaValues = false;
      }

      _useFormulaValues = isUseFormulaValueChanged;
      final bool saveIVC = _ignoreValueChanged;
      _ignoreValueChanged = true;
      final int row = _getRowIndex(s);
      final int col = _getColIndex(s);
      _grid!._setValueRowCol(txt, row, col);
      _ignoreValueChanged = saveIVC;
    }

    _grid = grd;
    _cell = saveCell;
    _inAPull = false;

    return txt;
  }

  /// A method to retrieve the row index from a cell reference.
  int _getRowIndex(String s) {
    if (_currentRowNotationEnabled && s.isEmpty) {
      return 0;
    } else {
      int i = 0;

      int? result;
      bool bIsLetter = false;

      if (i < s.length && s[i] == _sheetToken) {
        i++;
        while (i < s.length && s[i] != _sheetToken) {
          i++;
        }

        i++;
      }

      while (i < s.length && _isLetter(s.codeUnitAt(i))) {
        bIsLetter = true;
        i++;
      }

      result = int.tryParse(s.substring(i));
      if (i < s.length && result != null) {
        return result;
      }

      if (bIsLetter) {
        return -1;
      }
    }
    throw Exception(_formulaErrorStrings[_badIndex]);
  }

  /// A method that gets the column index from a cell reference passed in.
  int _getColIndex(String s) {
    int i = 0;
    int k = 0;
    s = s.toUpperCase();

    if (i < s.length && s[i] == _sheetToken) {
      i++;
      while (i < s.length && s[i] != _sheetToken) {
        i++;
      }

      i++;
    }
    while (i < s.length && _isLetter(s.codeUnitAt(i))) {
      k = k * 26 + s.codeUnitAt(i) - 'A'.codeUnitAt(0) + 1;
      i++;
    }

    if (k == 0) {
      return -1;
    }

    return k;
  }

  bool _isLetter(int char) {
    return (char >= 0x41 && char <= 0x5A) || (char >= 0x61 && char <= 0x7A);
  }

  static bool _isDigit(int char) {
    return char >= 0x30 && char <= 0x39;
  }

  bool _isLetterOrDigit(int c) {
    return _isLetter(c) || _isDigit(c);
  }

  String _getSheetToken(String s) {
    int i = 0;
    String s1 = '';
    if (i < s.length && s[i] == _sheetToken) {
      i++;
      while (i < s.length && s[i] != _sheetToken) {
        i++;
      }

      if (i < s.length) {
        s1 = s.substring(0, i + 1);
      }
    }

    if (i < s.length) {
      return s1;
    }

    throw Exception(_formulaErrorStrings[_improperFormula]);
  }

  /// A method that computes a parsed formula.
  String _computeFormula(String parsedFormula) {
    String s = _computedValue(parsedFormula);

    if (useNoAmpersandQuotes &&
        s.length > 1 &&
        s[0] == _tic[0] &&
        s[s.length - 1] == _tic[0]) {
      s = s.substring(1, 1 + s.length - 2);
    }
    return s;
  }

  String _computedValue(String formula) {
    _exceptionThrown = false;
    bool isEmptyString = false;
    if (_textIsEmpty(formula)) {
      return formula;
    }
    try {
      _computedValueLevel++;

      if (_computedValueLevel > _maximumRecursiveCalls) {
        _computedValueLevel = 0;
        throw Exception(_formulaErrorStrings[_tooComplex]);
      }

      final Stack stack = Stack();

      int i = 0;
      stack._clear();
      String sheet = '';
      // String book = '';

      i = 0;
      while (i < formula.length) {
        if (formula[i] == _bMarker) {
          i = i + 1;
          continue;
        }

        if (formula[i] == _sheetToken) {
          sheet = formula[i];
          i++;
          while (i < formula.length && formula[i] != _sheetToken) {
            sheet += formula[i];
            i++;
          }

          if (i < formula.length) {
            sheet += formula[i];
            i++;
          } else {
            continue;
          }
        }

        if (formula.substring(i).startsWith(_trueValueStr)) {
          stack._push(_trueValueStr);
          i += _trueValueStr.length;
        } else if (formula.substring(i).startsWith(_falseValueStr)) {
          stack._push(_falseValueStr);
          i += _falseValueStr.length;
        } else if (formula[i] == _tic[0] || formula[i] == '|') {
          String s = formula[i];
          i++;

          while (i < formula.length && formula[i] != _tic[0]) {
            s = s + formula[i];
            i = i + 1;
          }
          if (_multiTick) {
            s = s.replaceAll('|', _tic);
          }
          stack._push(s + _tic);
          i += 1;
        } else if (_isUpper(formula[i])) {
          ////cell loc
          final List<dynamic> result = _processUpperCase(formula, i, sheet);
          formula = result[1] as String;
          i = result[2] as int;
          sheet = result[3] as String;
          final String s = result[0] as String;
          //Below condition is added to return Error String when s is Error String.
          if (_errorStrings.contains(s)) {
            return s;
          }
          stack._push(_getValueFromParentObject(s, true));
        } else if (formula[i] == 'q') {
          formula = _computeInteriorFunctions(formula);
          final int ii = formula.substring(i + 1).indexOf(_leftBracket);
          if (ii > 0) {
            int bracketCount = 0;
            // bool bracketFound = false;
            final int start = ii + i + 2;
            int k = start;
            while (k < formula.length &&
                (formula[k] != _rightBracket || bracketCount > 0)) {
              if (formula[k] == _leftBracket) {
                bracketCount++;
                // bracketFound = true;
              } else if (formula[k] == _leftBracket) {
                bracketCount--;
              }

              k++;
            }

            final String name = formula.substring(i + 1, i + 1 + ii);
            if (name == 'AVG' && excelLikeComputations) {
              return _formulaErrorStrings[_badIndex];
            }
            if (_libraryFunctions![name] != null) {
              final int j =
                  formula.substring(i + ii + 1).indexOf(_rightBracket);
              String args = formula.substring(i + ii + 2, i + ii + 2 + j - 1);

              try {
                final String function = _libraryFunctions![name] as String;
                final List<String> argArray =
                    _splitArgsPreservingQuotedCommas(args);
                final StringBuffer sb = StringBuffer();
                const bool isFormulaUpdated = false;
                for (int index = 0; index < argArray.length; index++) {
                  final String range = argArray[index];
                  _findNamedRange = false;
                  if (index == argArray.length - 1) {
                    sb.write(range);
                  } else {
                    sb.write(range + parseArgumentSeparator);
                  }
                }
                if (isFormulaUpdated || _findNamedRange) {
                  args = sb.toString();
                }
                _findNamedRange = false;
                final String result = _func(function, args);
                stack._push(result);
              } catch (e) {
                _exceptionThrown = true;
                if (_errorStrings.contains(e.toString())) {
                  return e.toString();
                } else if (_exceptionThrown) {
                  return _errorStrings[1];
                }
              }
              i += j + ii + 2;
            } else {
              return _formulaErrorStrings[_missingFormula];
            }
          } else if (formula[0] == _bMarker) {
            ////Restart the processing with the formula without library finctions.
            i = 0;
            stack._clear();
            continue;
          } else {
            return _formulaErrorStrings[_improperFormula];
          }
        } else if (_isDigit(formula.codeUnitAt(i)) || formula[i] == 'u') {
          String s = '';

          if (i < formula.length && formula[i] == formula[i].toUpperCase()) {
            final List<dynamic> result = _processUpperCase(formula, i, sheet);
            formula = result[1] as String;
            i = result[2] as int;
            sheet = result[3] as String;

            s = s + _getValueFromParentObject(result[0], true);
          } else {
            while (i < formula.length &&
                (_isDigit(formula.codeUnitAt(i)) ||
                    formula[i] == parseDecimalSeparator ||
                    formula[i] == (':'))) {
              s = s + formula[i];
              i = i + 1;
            }
          }

          stack._push(s);
        } else if (formula[i] == parseDateTimeSeparator) {
          String s = '';
          while (i < formula.length && formula[i] == parseDateTimeSeparator) {
            s = s + formula[i];
            i = i + 1;
          }
          while (stack._count > 0) {
            s = stack._pop().toString() + s;
          }
          stack._push(s);
        } else if (formula[i] == parseArgumentSeparator) {
          i++;
          continue;
        } else {
          switch (formula[i]) {
            case '#':
              {
                int errIndex = 0;
                if (formula.substring(i).contains('#N/A') ||
                    formula.substring(i).contains('#VALUE!') ||
                    formula.substring(i).contains('#REF!') ||
                    formula.substring(i).contains('#DIV/0!') ||
                    formula.substring(i).contains('#NUM!') ||
                    formula.substring(i).contains('#NAME?') ||
                    formula.substring(i).contains('#NULL!')) {
                  // ignore: prefer_contains
                  if (formula.indexOf('!') == -1 ||
                      // ignore: prefer_contains
                      formula.substring(i).indexOf('!') == -1) {
                    // ignore: prefer_contains
                    errIndex = (formula.substring(i).indexOf('#N/A') > -1)
                        ? (formula.substring(i).indexOf('#N/A') + 4 + i)
                        : (formula.substring(i).indexOf('?') + 1 + i);
                  } else {
                    errIndex = formula.substring(i).indexOf('!') + 1 + i;
                  }
                  stack._push(formula.substring(i, i + errIndex - i));
                } else {
                  errIndex = i + 1;
                  stack._push(formula.substring(i, i + errIndex - i));
                }
                i = errIndex;
                break;
              }

            case 'n':
              {
                i = i + 1;

                String s = '';
                if (formula.substring(i).startsWith('Infinity') ||
                    formula
                        .substring(i)
                        .startsWith(double.infinity.toString())) {
                  s = double.infinity.toString();
                  i += s.length;
                } else if (formula.substring(i).startsWith('uInfinity') ||
                    formula
                        .substring(i)
                        .startsWith((-double.infinity).toString())) {
                  s = (-double.infinity).toString();
                  i += s.length + 1;
                } else if (formula.substring(i).startsWith(_trueValueStr)) {
                  s = _trueValueStr;
                  i += s.length;
                } else if (formula.substring(i).startsWith(_falseValueStr)) {
                  s = _falseValueStr;
                  i += s.length;
                } else if (i <= formula.length - 3 &&
                    formula.substring(i, i + 3).toUpperCase() ==
                        (double.nan).toString().toUpperCase()) {
                  i += 3;
                  s = _errorStrings[1];
                } else {
                  while (i < formula.length &&
                      (_isDigit(formula.codeUnitAt(i)) ||
                          formula[i] == parseDecimalSeparator)) {
                    s = s + formula[i];
                    i = i + 1;
                  }
                }
                stack._push(s);
              }

              break;
            case _tokenAdd:
              {
                final double d = _pop(stack);
                final double d1 = _pop(stack);
                if (d == (double.nan) || d1 == (double.nan)) {
                  stack._push('#VALUE!');
                } else {
                  stack._push((d1 + d).toString());
                }
                i = i + 1;
              }

              break;
            case _tokenSubtract:
              {
                final double d = _pop(stack);
                final double d1 = _pop(stack);
                if (d == (double.nan) || d1 == (double.nan)) {
                  stack._push('#VALUE!');
                } else {
                  stack._push((d1 - d).toString());
                }
                i = i + 1;
              }

              break;
            case _tokenMultiply:
              {
                final double d = _pop(stack);
                final double d1 = _pop(stack);
                if (d == (double.nan) || d1 == (double.nan)) {
                  stack._push('#VALUE!');
                } else {
                  stack._push((d1 * d).toString());
                }
                i = i + 1;
              }

              break;
            case _tokenDivide:
              {
                final double d = _pop(stack);
                final double d1 = _pop(stack);
                if (d.isNaN || d1.isNaN) {
                  stack._push('#VALUE!');
                } else if (d == 0) {
                  stack._push(_errorStrings[3]);
                } else {
                  stack._push((d1 / d).toString());
                }
                i = i + 1;
              }

              break;
            case _tokenLess:
              {
                final String s1 = _popString(stack);
                final String s2 = _popString(stack);

                double? d, d1;
                String val = '';
                d = double.tryParse(s1);
                d1 = double.tryParse(s2);
                if (d != null && d1 != null) {
                  val = (d1 < d) ? _trueValueStr : _falseValueStr;
                } else {
                  d = double.tryParse(s1.replaceAll(_tic, ''));
                  d1 = double.tryParse(s2.replaceAll(_tic, ''));
                  if (d != null || d1 != null) {
                    // ignore: prefer_contains
                    if (s1.startsWith(_tic) && s2.indexOf(_tic) == -1) {
                      val = _trueValueStr;
                    }
                    // ignore: prefer_contains
                    else if (s2.startsWith(_tic) && s1.indexOf(_tic) == -1) {
                      val = _falseValueStr;
                    } else if (d != null && d1 != null) {
                      val = (d1 < d) ? _trueValueStr : _falseValueStr;
                    }
                  } else {
                    val = (s2.toUpperCase().replaceAll(_tic, '').compareTo(
                                s1.toUpperCase().replaceAll(_tic, '')) <
                            0)
                        ? _trueValueStr
                        : _falseValueStr;
                  }
                }

                stack._push(val);
                i = i + 1;
              }

              break;
            case _tokenGreater:
              {
                final String s1 = _popString(stack);
                final String s2 = _popString(stack);

                double? d, d1;
                String val = '';
                d = double.tryParse(s1);
                d1 = double.tryParse(s2);
                if (d != null && d1 != null) {
                  val = (d1 > d) ? _trueValueStr : _falseValueStr;
                }
                if (val == '') {
                  d = double.tryParse(s1.replaceAll(_tic, ''));
                  d1 = double.tryParse(s2.replaceAll(_tic, ''));
                  if (d != null || d1 != null) {
                    // ignore: prefer_contains
                    if (s1.startsWith(_tic) && s2.indexOf(_tic) == -1) {
                      val = _falseValueStr;
                    }
                    // ignore: prefer_contains
                    else if (s2.startsWith(_tic) && s1.indexOf(_tic) == -1) {
                      val = _trueValueStr;
                    } else if (d != null && d1 != null) {
                      val = (d1 > d) ? _trueValueStr : _falseValueStr;
                    }
                  } else {
                    val = (s2.toUpperCase().replaceAll(_tic, '').compareTo(
                                s1.toUpperCase().replaceAll(_tic, '')) >
                            0)
                        ? _trueValueStr
                        : _falseValueStr;
                  }
                }

                stack._push(val);
                i = i + 1;
              }

              break;
            case _tokenEqual:
              {
                final String s1 = _popString(stack);
                final String s2 = _popString(stack);

                String val = '';
                double? d, d1;
                // ignore: prefer_contains
                if ((s1.startsWith(_tic) && s2.indexOf(_tic) == -1) ||
                    // ignore: prefer_contains
                    (s2.startsWith(_tic) && s1.indexOf(_tic) == -1)) {
                  d = double.tryParse(s1.replaceAll(_tic, ''));
                  d1 = double.tryParse(s2.replaceAll(_tic, ''));
                  if (d == null && d1 == null) {
                    val = (s1.replaceAll(_tic, '').toUpperCase() ==
                            s2.replaceAll(_tic, '').toUpperCase())
                        ? _trueValueStr
                        : _falseValueStr;
                  } else {
                    val = _falseValueStr;
                  }
                } else {
                  val = (s1.toUpperCase() == s2.toUpperCase())
                      ? _trueValueStr
                      : _falseValueStr;
                }

                stack._push(val);
                i = i + 1;
              }

              break;
            case _tokenLesseq:
              {
                final String s1 = _popString(stack);
                final String s2 = _popString(stack);

                double? d, d1;
                String val = '';
                d = double.tryParse(s1);
                d1 = double.tryParse(s2);

                if (d != null && d1 != null) {
                  val = (d1 >= d) ? _trueValueStr : _falseValueStr;
                } else {
                  d = double.tryParse(s1.replaceAll(_tic, ''));
                  d1 = double.tryParse(s2.replaceAll(_tic, ''));
                  if (d != null || d1 != null) {
                    // ignore: prefer_contains
                    if (s1.startsWith(_tic) && s2.indexOf(_tic) == -1) {
                      val = _trueValueStr;
                    }
                    // ignore: prefer_contains
                    else if (s2.startsWith(_tic) && s1.indexOf(_tic) == -1) {
                      val = _falseValueStr;
                    } else if (d != null && d1 != null) {
                      val = (d1 >= d) ? _trueValueStr : _falseValueStr;
                    }
                  } else {
                    val = (s1.toUpperCase().replaceAll(_tic, '').compareTo(
                                s2.toUpperCase().replaceAll(_tic, '')) <=
                            0)
                        ? _trueValueStr
                        : _falseValueStr;
                  }
                }
                stack._push(val);
                i = i + 1;
              }

              break;
            case _tokenGreaterEq:
              {
                final String s1 = _popString(stack);
                final String s2 = _popString(stack);

                double? d, d1;
                String val = '';

                d = double.tryParse(s1);
                d1 = double.tryParse(s2);
                if (d != null && d1 != null) {
                  val = (d1 >= d) ? _trueValueStr : _falseValueStr;
                } else {
                  d = double.tryParse(s1.replaceAll(_tic, ''));
                  d1 = double.tryParse(s2.replaceAll(_tic, ''));
                  if (d != null || d1 != null) {
                    // ignore: prefer_contains
                    if (s1.startsWith(_tic) && s2.indexOf(_tic) == -1) {
                      val = _falseValueStr;
                    }
                    // ignore: prefer_contains
                    else if (s2.startsWith(_tic) && s1.indexOf(_tic) == -1) {
                      val = _trueValueStr;
                    } else if (d != null && d1 != null) {
                      val = (d1 >= d) ? _trueValueStr : _falseValueStr;
                    }
                  } else {
                    val = (s2.toUpperCase().replaceAll(_tic, '').compareTo(
                                s1.toUpperCase().replaceAll(_tic, '')) >=
                            0)
                        ? _trueValueStr
                        : _falseValueStr;
                  }
                }

                stack._push(val);
                i = i + 1;
              }

              break;
            case _tokenNoEqual:
              {
                final String s1 = _popString(stack);
                final String s2 = _popString(stack);

                double? d, d1;
                String val;
                d = double.tryParse(s1);
                d1 = double.tryParse(s2);
                if (d != null && d1 != null) {
                  val = (d1 != d) ? _trueValueStr : _falseValueStr;
                } else {
                  // ignore: prefer_contains
                  if ((s1.startsWith(_tic) && s2.indexOf(_tic) == -1) ||
                      // ignore: prefer_contains
                      (s2.startsWith(_tic) && s1.indexOf(_tic) == -1)) {
                    d = double.tryParse(s1.replaceAll(_tic, ''));
                    d1 = double.tryParse(s2.replaceAll(_tic, ''));
                    if (d == null && d1 == null) {
                      val = (s1.replaceAll(_tic, '').toUpperCase() !=
                              s2.replaceAll(_tic, '').toUpperCase())
                          ? _trueValueStr
                          : _falseValueStr;
                    } else {
                      val = _trueValueStr;
                    }
                  } else {
                    val = (s1.toUpperCase().replaceAll(_tic, '') !=
                            s2.toUpperCase().replaceAll(_tic, ''))
                        ? _trueValueStr
                        : _falseValueStr;
                  }
                }

                stack._push(val);
                i = i + 1;
              }

              break;
            case _tokenAnd: ////and Strings....
              {
                String s1 = _popString(stack);
                if (s1.isNotEmpty && s1[0] == _tic[0]) {
                  if (s1.length > 1 && s1[s1.length - 1] == _tic[0]) {
                    s1 = s1.substring(1, 1 + s1.length - 2);
                  }
                }
                String s2 = '';
                if (stack._count > 0) {
                  s2 = _popString(stack);
                }
                if (s2.isNotEmpty && s2[0] == _tic[0]) {
                  if (s2.length > 1 && s2[s2.length - 1] == _tic[0]) {
                    s2 = s2.substring(1, 1 + s2.length - 2);
                  }
                }
                if (s1 == '' && s2 == '') {
                  isEmptyString = true;
                }
                if (s1.isNotEmpty &&
                    s1[0] == '#' &&
                    // ignore: prefer_contains
                    _errorStrings.indexOf(s1) > -1) {
                  stack._push(s1);
                } else if (s2.isNotEmpty &&
                    s2[0] == '#' &&
                    // ignore: prefer_contains
                    _errorStrings.indexOf(s2) > -1) {
                  stack._push(s2);
                } else {
                  stack._push(_tic + s2 + s1 + _tic);
                }

                i = i + 1;
              }

              break;
            case _tokenOr: // exponential
              {
                final double d = _pop(stack);
                int? x = int.tryParse(d.toString());
                if (x != null && _isErrorString) {
                  _isErrorString = false;
                  return _errorStrings[x];
                }
                final double d1 = _pop(stack);
                x = int.tryParse(d.toString());
                if (x != null && _isErrorString) {
                  _isErrorString = false;
                  return _errorStrings[x];
                }
                stack._push(pow(d1, d).toString());
                i = i + 1;
              }

              break;
            default:
              {
                _computedValueLevel = 0;
                return _errorStrings[1];
              }
          }
        }
      }

      if (stack._count == 0) {
        return '';
      } else {
        String s = '';
        double? d;
        int cc = stack._count;
        do {
          {
            //Checks if the stack element is a error String. If yes, then stops popping other stack element and returns the error String.
            final String p = stack._pop().toString();
            if (_errorStrings.contains(p)) {
              s = p;
              break;
            } else {
              s = p + s;
            }
          }

          if (s == '' &&
              _isCellReference(formula) &&
              _treatStringsAsZero &&
              !isEmptyString) {
            s = '0';
          }
          d = double.tryParse(s);
          if (!_checkDanglingStack && d != null) {
            return s;
          }
          if (s.contains('~') && _isDoubleQuotes) {
            s = s.replaceAll('~', _tic + _tic);
            _isDoubleQuotes = false;
          }
          cc--;
        } while (cc > 0 &&
            !(s.contains(_falseValueStr) || s.contains(_trueValueStr)));
        if (s.contains(_tic + _tic) && s != (_tic + _tic) && !_multiTick) {
          s = s.replaceAll(_tic + _tic, _tic);
        }
        if (_errorStrings.contains(s)) {
          return s;
        } else {
          return s;
        }
      }
    } catch (e) {
      _exceptionThrown = true;
      _computedValueLevel = 0;
      // ignore: prefer_contains
      if (e.toString().indexOf(_formulaErrorStrings[_cellEmpty]) > -1) {
        return '';
      } else {
        return e.toString();
      }
    } finally {
      _computedValueLevel--;
      if (_computedValueLevel < 0) {
        _computedValueLevel = 0;
      }
    }
  }

  String _func(String function, String args) {
    switch (function) {
      case '_computeSum':
        return _computeSum(args);
      case '_computeAvg':
        return _computeAvg(args);
      case '_computeMax':
        return _computeMax(args);
      case '_computeMin':
        return _computeMin(args);
      case '_computeCount':
        return _computeCount(args);
      case '_computeIf':
        return _computeIf(args);
      case '_computeIndex':
        return _computeIndex(args);
      case '_computeMatch':
        return _computeMatch(args);
      case '_computeAnd':
        return _computeAnd(args);
      case '_computeOr':
        return _computeOr(args);
      case '_computeNot':
        return _computeNot(args);
      case '_computeToday':
        return _computeToday(args);
      case '_computeNow':
        return _computeNow(args);
      case '_computeTrim':
        return _computeTrim(args);
      case '_computeConcatenate':
        return _computeConcatenate(args);
      case '_computeUpper':
        return _computeUpper(args);
      case '_computeLower':
        return _computeLower(args);
      case '_computeAverageIFS':
        return _computeAverageIFS(args);
      case '_computeSumIFS':
        return _computeSumIFS(args);
      case '_computeMinIFS':
        return _computeMinIFS(args);
      case '_computeMaxIFS':
        return _computeMaxIFS(args);
      case '_computeCountIFS':
        return _computeCountIFS(args);
      case '_computeVLoopUp':
        return _computeVLoopUp(args);
      case '_computeSumIf':
        return _computeSumIf(args);
      case '_computeSumProduct':
        return _computeSumProduct(args);
      case '_computeProduct':
        return _computeProduct(args);
      default:
        return args;
    }
  }

  /// Returns the sum of all values listed in the argument.
  String _computeSum(String range) {
    double? sum = 0;
    String s1;
    double? d;
    String adjustRange;
    final List<String> ranges = _splitArgsPreservingQuotedCommas(range);
    if (range == '') {
      return _formulaErrorStrings[_wrongNumberArguments];
    }
    for (final String r in ranges) {
      adjustRange = r;
      if (adjustRange.contains(':') && _isRange(adjustRange)) {
        if (r.startsWith(_tic)) {
          return _errorStrings[1];
        }
        final List<String?> cells = _getCellsFromArgs(adjustRange);
        for (final String? s in cells) {
          try {
            s1 = _getValueFromArg(s);
            if (_errorStrings.contains(s1)) {
              return s1;
            }
          } catch (e) {
            _exceptionThrown = true;
            return e.toString();
          }

          if (s1.isNotEmpty) {
            d = double.tryParse(s1);
            if (d != null) {
              sum = sum! + d;
            }
          }
        }
      } else {
        try {
          s1 = _getValueFromArg(adjustRange);
          if (_errorStrings.contains(s1)) {
            return s1;
          }
        } catch (e) {
          _exceptionThrown = true;
          return e.toString();
        }

        if (s1.isNotEmpty) {
          d = double.tryParse(s1);
          final double? d1 = double.tryParse(s1.replaceAll(_tic, ''));
          if ((_isCellReference(adjustRange) && d != null && !d.isNaN) ||
              (!_isCellReference(adjustRange) && d1 != null && !d1.isNaN)) {
            sum = sum! + d!;
          }
        }
      }
    }
    return sum.toString();
  }

  /// Returns the simple average of all values listed in the argument.
  String _computeAvg(String range) {
    double sum = 0;
    int count = 0;
    double? d;
    String s1;
    final List<String> ranges = _splitArgsPreservingQuotedCommas(range);
    if (ranges.isEmpty || range == '') {
      return _formulaErrorStrings[_invalidArguments];
    }
    for (final String r in ranges) {
      // ignore: prefer_contains
      if (r.indexOf(':') > -1 && _isRange(r)) {
        for (final String? s in _getCellsFromArgs(r)) {
          try {
            s1 = _getValueFromArg(s);
            if (_errorStrings.contains(s1)) {
              return s1;
            }
          } catch (e) {
            _exceptionThrown = true;
            return _errorStrings[4];
          }

          if (s1.isNotEmpty) {
            d = double.tryParse(s1);
            if (d != null) {
              sum = sum + d;
              count++;
            }
          }
        }
      } else {
        try {
          s1 = _getValueFromArg(r);
          if (_errorStrings.contains(s1)) {
            return s1;
          }
        } catch (e) {
          _exceptionThrown = true;
          return _errorStrings[4];
        }

        if (s1.isNotEmpty) {
          d = double.tryParse(s1.replaceAll(_tic, ''));
          if (d != null) {
            sum = sum + d;
            count++;
          } else {
            if (s1.startsWith(_tic)) {
              return _errorStrings[1];
            }
          }
        }
      }
    }

    if (count > 0) {
      sum = sum / count.toDouble();
    }
    return sum.toString();
  }

  /// Returns the maximum value of all values listed in the argument.
  String _computeMax(String range) {
    double maxValue = -double.maxFinite;
    double? d;
    String s1;
    final List<String> ranges = _splitArgsPreservingQuotedCommas(range);
    if (ranges.length == 1 && !range.startsWith(_tic) && (range == '')) {
      return _formulaErrorStrings[_wrongNumberArguments];
    }

    for (final String r in ranges) {
      ////cell range
      // ignore: prefer_contains
      if (r.indexOf(':') > -1 && _isRange(r)) {
        if (r.startsWith(_tic)) {
          return _errorStrings[1];
        }
        for (final String? s in _getCellsFromArgs(r)) {
          try {
            s1 = _getValueFromArg(s);
            if (_errorStrings.contains(s1)) {
              return s1;
            }
          } catch (e) {
            _exceptionThrown = true;
            return e.toString();
          }

          if (s1.isNotEmpty) {
            d = double.tryParse(s1.replaceAll(_tic, ''));
            if (d != null) {
              maxValue = max(maxValue, d);
            } else if (_errorStrings.contains(s1)) {
              return s1;
            }
          }
        }
      } else {
        try {
          s1 = _getValueFromArg(r);
        } catch (e) {
          _exceptionThrown = true;
          return e.toString();
        }

        if (s1.isNotEmpty) {
          d = double.tryParse(s1.replaceAll(_tic, ''));
          if (d != null) {
            maxValue = max(maxValue, d);
          } else {
            if (s1.startsWith(_tic)) {
              return _errorStrings[1];
            }
          }
        }
      }
    }
    if (maxValue != -double.maxFinite) {
      return maxValue.toString();
    }

    return '0';
  }

  /// Returns the minimum value of all values listed in the argument.
  String _computeMin(String range) {
    double minValue = double.maxFinite;
    double? d;
    String s1;
    final List<String> ranges = _splitArgsPreservingQuotedCommas(range);
    if (range == '') {
      return _formulaErrorStrings[_wrongNumberArguments];
    }

    for (final String r in ranges) {
      ////cell range
      // ignore: prefer_contains
      if (r.indexOf(':') > -1 && _isRange(r)) {
        if (r.startsWith(_tic)) {
          return _errorStrings[1];
        }
        for (final String? s in _getCellsFromArgs(r)) {
          try {
            s1 = _getValueFromArg(s);
            final DateTime? result = DateTime.tryParse(s1.replaceAll(_tic, ''));
            d = double.tryParse(s1);
            if (result != null && d == null) {
              s1 = _getSerialDateTimeFromDate(result).toString();
            }
            if (_errorStrings.contains(s1)) {
              return s1;
            }
          } catch (e) {
            _exceptionThrown = true;
            return e.toString();
          }

          if (s1.isNotEmpty) {
            double.tryParse(s1.replaceAll(_tic, ''));
            if (d != null) {
              minValue = min(minValue, d);
            }
          }
        }
      } else {
        try {
          s1 = _getValueFromArg(r);
        } catch (e) {
          _exceptionThrown = true;
          return e.toString();
        }

        if (s1.isNotEmpty) {
          d = double.tryParse(s1.replaceAll(_tic, ''));
          if (d != null) {
            minValue = min(minValue, d);
          } else {
            if (s1.startsWith(_tic)) {
              return _errorStrings[1];
            }
          }
        }
      }
    }
    if (minValue != double.maxFinite) {
      return minValue.toString();
    }

    return '0';
  }

  /// Returns the count of all values (including text) listed in the argument to evaluate to a number.
  String _computeCount(String range) {
    int count = 0;
    String s1 = '';
    double? d;
    DateTime? dt;
    List<String> array;
    _isIndexInteriorFormula = false;
    final List<String> ranges = _splitArgsPreservingQuotedCommas(range);
    for (final String r in ranges) {
      ////is a cellrange
      if (r.contains(':') && _isRange(r)) {
        for (final String? s in _getCellsFromArgs(r.replaceAll(_tic, ''))) {
          try {
            s1 = _getValueFromArg(s);
          } catch (e) {
            _exceptionThrown = true;
            return _errorStrings[4];
          }

          if (s1.isNotEmpty) {
            if (s1 == (_formulaErrorStrings[19])) {
              return _formulaErrorStrings[19];
            }
            d = double.tryParse(s1.replaceAll(_tic, ''));
            dt = DateTime.tryParse(s1.replaceAll(_tic, ''));
            if (d != null || dt != null) {
              count++;
            }
          }
        }
      } else {
        try {
          if (r == ('') && !r.startsWith(_tic)) {
            count++;
          }
          if (r.contains(parseArgumentSeparator)) {
            array = _splitArgsPreservingQuotedCommas(r);
            for (final String str in array) {
              d = double.tryParse(str.replaceAll(_tic, ''));
              dt = DateTime.tryParse(str.replaceAll(_tic, ''));
              if (d != null || dt != null) {
                count++;
              }
            }
          } else {
            s1 = _getValueFromArg(r);
          }
        } catch (e) {
          _exceptionThrown = true;
          return _errorStrings[4];
        }

        if (s1.isNotEmpty) {
          if (s1 == (_formulaErrorStrings[19])) {
            return _formulaErrorStrings[19];
          }
          d = double.tryParse(s1.replaceAll(_tic, ''));
          dt = DateTime.tryParse(s1.replaceAll(_tic, ''));
          if (d != null ||
              dt != null ||
              s1 == _trueValueStr ||
              s1 == _falseValueStr) {
            count++;
          }
        }
      }
    }
    return count.toString();
  }

  /// Conditionally computes one of two alternatives depending upon a logical expression.
  String _computeIf(String args) {
    if (args == '') {
      return _formulaErrorStrings[_wrongNumberArguments];
    }
    String s1 = '';
    ////parsed formula
    if (args.isNotEmpty &&
        _indexOfAny(args, <String>[parseArgumentSeparator, ':']) == -1) {
      return _formulaErrorStrings[_requires3Args];
    } else {
      final List<String> s = _splitArgsPreservingQuotedCommas(args);
      if (s.length <= 3) {
        try {
          double? d1 = 0;
          final String argument1 = (s[0] == '') ? '0' : _getValueFromArg(s[0]);
          d1 = double.tryParse(argument1);
          if (d1 != null) {
            if (_errorStrings.contains(argument1)) {
              return argument1;
            }
            final bool flag = argument1.replaceAll(_tic, '') == 'true' ||
                argument1.replaceAll(_tic, '') == 'false';
            if ((!_isCellReference(s[0]) &&
                    !flag &&
                    argument1.startsWith(_tic)) ||
                (_isCellReference(s[0]) && argument1.startsWith(_tic))) {
              return _errorStrings[1];
            }
          }

          s1 = _getValueFromArg(s[0]);
          double? d = 0;
          d = double.tryParse(s1);
          if (s1.replaceAll(_tic, '').toUpperCase() == _trueValueStr ||
              (d != null && d != 0)) {
            //Below code has been added to return the cell range when the if formula is interior formula
            if (_computedValueLevel > 1 &&
                _isRange(s[1]) &&
                !s[1].contains(_tic)) {
              s1 = s[1];
            } else if ((s[1] == '') && _treatStringsAsZero) {
              s1 = '0';
            } else {
              s1 = _getValueFromArg(s[1]);
            }
            if ((s1 == '') && _treatStringsAsZero && _computedValueLevel > 1) {
              s1 = '0';
            } else if (!(s1 == '') &&
                s1[0] == _tic[0] &&
                !_isCellReference(s[1]) &&
                useNoAmpersandQuotes) {
              s1 = s1.replaceAll(RegExp(r"^'|'$"), '');
            }
          } else if (s.length < 3 &&
              (s1.replaceAll(_tic, '').toUpperCase() == _falseValueStr ||
                  (d != null && d == 0))) {
            s1 = _falseValueStr;
          } else if (s1.replaceAll(_tic, '').toUpperCase() == _falseValueStr ||
              s1 == '' ||
              (d != null && d == 0)) {
            //Below code has been added to return the cell range when the if formula is interior formula
            if (_computedValueLevel > 1 &&
                _isRange(s[2]) &&
                !s[2].contains(_tic)) {
              s1 = s[2];
            } else if ((s[2] == '') && _treatStringsAsZero) {
              s1 = '0';
            } else {
              s1 = _getValueFromArg(s[2]);
            }
            if ((s1 == '') && _treatStringsAsZero && _computedValueLevel > 1) {
              s1 = '0';
            } else if (!(s1 == '') &&
                s1[0] == _tic[0] &&
                !_isCellReference(s[2]) &&
                useNoAmpersandQuotes) {
              s1 = s.length == 3 ? s1 : _falseValueStr;
              s1 = s1.replaceAll(RegExp(r"^'|'$"), '');
            }
          }
        } catch (e) {
          _exceptionThrown = true;
          return e.toString();
        }
      } else {
        return _formulaErrorStrings[_requires3Args];
      }
    }
    return s1;
  }

  /// Returns the value at a specified row and column from within a given range.
  String _computeIndex(String arg) {
    String result;
    if (arg == '') {
      return _formulaErrorStrings[_invalidArguments];
    }
    final List<String> args = _splitArgsPreservingQuotedCommas(arg);
    final int argCount = args.length;
    if (argCount < 2 || args.isEmpty) {
      return _formulaErrorStrings[_wrongNumberArguments];
    }
    for (int index = 1; index < argCount; index++) {
      //To check third argument since it is optional
      if (index <= (argCount - 1)) {
        //To Check #NAME?,#VALUE! error string for argument 2,3 since it is numeric type
        final String checkString2 = _getValueFromArg(args[1]);
        if (_errorStrings.contains(checkString2)) {
          return checkString2;
        }
      }
    }
    String r = args[0];
    r = r.replaceAll(_tic, ' ');
    int i = r.indexOf(':');
    ////Single Cell
    if (i == -1) {
      if (_isCellReference(r)) {
        r = '$r:$r';
      }
    }
    final String sheet = _getSheetToken(r);
    i = r.indexOf(':');
    int row = (argCount == 1)
        ? 1
        : double.tryParse(_getValueFromArg(args[1]))!.toInt();
    int col = (argCount <= 2)
        ? 1
        : double.tryParse(_getValueFromArg(args[2]))!.toInt();
    int top = _getRowIndex(r.substring(0, i));
    int bottom = _getRowIndex(r.substring(i + 1));
    if (!(top != -1 || bottom == -1) == (top == -1 || bottom != -1)) {
      return _errorStrings[5];
    }
    if (top == -1 && _grid is Worksheet) {
      top = _grid!.getFirstRow();
    }
    if (bottom == -1 && _grid is Worksheet) {
      bottom = _grid!.getLastRow();
    }
    int left = _getColIndex(r.substring(0, i));
    int right = _getColIndex(r.substring(i + 1));
    if (left == -1 && _grid is Worksheet) {
      left = _grid!.getFirstColumn();
    }
    if (right == -1 && _grid is Worksheet) {
      right = _grid!.getLastColumn();
    }
    if (argCount == 2 && row > bottom - top + 1) {
      col = row;
      row = 1;
    }
    if (row > bottom - top + 1 || col > right - left + 1) {
      return _errorStrings[2];
    }

    row = _getRowIndex(r.substring(0, i)) + (row <= 0 ? row : row - 1);
    if (_getRowIndex(r.substring(0, i)) == -1 && _grid is Worksheet) {
      row = _grid!.getFirstRow();
    }
    col = _getColIndex(r.substring(0, i)) + (col <= 0 ? col : col - 1);
    if (_getColIndex(r.substring(0, i)) == -1 && _grid is Worksheet) {
      col = _grid!.getFirstColumn();
    }

    result = _getValueFromArg(sheet + _getAlphaLabel(col) + row.toString());
    if (!_isIndexInteriorFormula && result.isEmpty) {
      return '0';
    }
    return result;
  }

  /// Finds the index a specified value in a lookup_range.
  String _computeMatch(String arg) {
    if (arg == '') {
      return _formulaErrorStrings[_invalidArguments];
    }
    final List<String> args = _splitArgsPreservingQuotedCommas(arg);
    final int argCount = args.length;
    if (argCount != 3 && argCount != 2 || arg.isEmpty) {
      return _formulaErrorStrings[_wrongNumberArguments];
    }
    // To Check the error String
    final String checkString = _getValueFromArg(args[0]);
    if (_errorStrings.contains(checkString)) {
      return checkString;
    }
    int m = 1;
    List<String?> cells = <String?>[];
    final String r = args[1].replaceAll(_tic, ' ');
    final int i = r.indexOf(':');
    if (argCount == 3) {
      // To Check the error String
      final String checkString = _getValueFromArg(args[2]);
      if (_errorStrings.contains(checkString)) {
        return checkString;
      }
      String thirdArg = _getValueFromArg(args[2]);
      thirdArg = thirdArg.replaceAll(_tic, ' ');
      m = double.tryParse(thirdArg)!.toInt();
      if (thirdArg.contains(_tic) &&
          (thirdArg.contains(_trueValueStr) ||
              thirdArg.contains(_falseValueStr))) {
        return _errorStrings[1];
      } else if (thirdArg == _falseValueStr) {
        m = 0;
      } else if (thirdArg == _trueValueStr) {
        m = 1;
      }
    }
    final String searchItem =
        _getValueFromArg(args[0]).replaceAll(_tic, ' ').toUpperCase();
    if (searchItem == '') {
      return _errorStrings[5];
    }
    if (i > -1) {
      int row1 = _getRowIndex(r.substring(0, i + 1));
      int row2 = _getRowIndex(r.substring(0, i + 1));
      int col1 = _getColIndex(r.substring(0, i + 1));
      int col2 = _getColIndex(r.substring(0, i + 1));
      if (_grid is Worksheet) {
        if (!(row1 != -1 || row2 == -1) == (row1 == -1 || row2 != -1)) {
          return _errorStrings[5];
        }
        if (row1 == -1) {
          row1 = _grid!.getFirstRow();
        }
        if (col1 == -1) {
          col1 = _grid!.getFirstColumn();
        }
        if (row2 == -1) {
          row2 = _grid!.getLastRow();
        }
        if (col2 == -1) {
          col2 = _grid!.getLastColumn();
        }
      }
    }
    if (cells.isEmpty) {
      cells = _getCellsFromArgs(_stripTics(r));
    }
    int index = 1;
    int emptyValueIndex = 0;
    String oldValue = '';
    String newValue = '';
    for (final String? s in cells) {
      if (s != null) {
        if (_isCellReference(s.replaceAll(_tic, ' '))) {
          newValue = _getValueFromArg(s).replaceAll(_tic, ' ').toUpperCase();
        } else {
          newValue = s.replaceAll(_tic, '').toUpperCase();
        }
      }
      if (oldValue != '') {
        if (m == 1) {
          if (_matchCompare(newValue, oldValue) < 0 && newValue == searchItem) {
            index--;
            break;
          } else if (m == -1) {
            if (_matchCompare(newValue, oldValue) > 0) {
              index = -1;
              break;
            }
          }
        }
      }
      if ((m == 0 || m == 1) && _matchCompare(searchItem, newValue) == 0) {
        break;
      } else if (m == 1 && _matchCompare(searchItem, newValue) < 0) {
        index--;
        break;
      } else if (m == -1 && _matchCompare(searchItem, newValue) > 0) {
        index--;
        break;
      }
      if (m == 1 && newValue == '') {
        emptyValueIndex++;
      } else {
        index++;
      }
      if (oldValue == '' && newValue != '') {
        index = index + emptyValueIndex;
        emptyValueIndex = 0;
      }
      oldValue = newValue;
    }
    if (index > 0 && index <= cells.length) {
      return index.toString();
    } else {
      return '#N/A';
    }
  }

  /// Removes outer quote marks from a string with no inner quote marks.
  String _stripTics(String s) {
    if (s.length > 1 && s[0] == _tic[0] && s[s.length - 1] == _tic[0]) {
      if (s.substring(1, s.length - 2).contains(_tic)) {
        s = s.substring(1, s.length - 2);
      } else if (_multiTick) {
        s = s.substring(1, s.length - 2);
      }
    }
    return s;
  }

  int _matchCompare(Object o1, Object o2) {
    final String s1 = o1.toString();
    final String s2 = o2.toString();
    final double? d1 = double.tryParse(s1);
    final double? d2 = double.tryParse(s2);
    if (s1.contains('.') || s2.contains('.')) {
      return d1!.compareTo(d2!);
    } else {
      return s1.compareTo(s2);
    }
  }

  /// Returns the And of all values treated as logical values listed in the argument.
  String _computeAnd(String range) {
    bool sum = true;
    if (range.isEmpty) {
      return _formulaErrorStrings[_wrongNumberArguments];
    }
    String? s1;
    double? d;
    final List<String> ranges = _splitArgsPreservingQuotedCommas(range);
    for (final String r in ranges) {
      if (_splitArguments(r, ':').length > 1 &&
          _isCellReference(r.replaceAll(_tic, ''))) {
        for (final String? s in _getCellsFromArgs(r)) {
          try {
            s1 = _getValueFromArg(s);
            if (_errorStrings.contains(s1)) {
              return s1;
            }
          } catch (e) {
            _exceptionThrown = true;
            return _errorStrings[4];
          }
          d = double.tryParse(s1);
          sum &= s1 == ''
              ? _trueValueStr.toLowerCase() == 'true'
              : ((s1 == _trueValueStr) || d != null && d != 0);
          if (!sum) {
            return _falseValueStr;
          }
        }
      } else {
        try {
          s1 = _getValueFromArg(r);
          if (s1.startsWith(_tic) &&
              (r.replaceAll(_tic, '').toLowerCase() != 'true')) {
            return _errorStrings[1];
          }
          if (ranges.length == 1) {
            if (s1.isEmpty) {
              return _errorStrings[1];
            }
          }
          if (_errorStrings.contains(s1)) {
            return s1;
          }

          if (DateTime.tryParse(s1) != null) {
            return _trueValueStr;
          } else if ((double.tryParse(s1) == null) &&
              s1 != '' &&
              !(s1.replaceAll(_tic, '').toLowerCase() == 'true' ||
                  s1.replaceAll(_tic, '').toLowerCase() == 'false')) {
            return (_isCellReference(r)) ? _errorStrings[1] : _errorStrings[5];
          }
        } catch (e) {
          _exceptionThrown = true;
          return _errorStrings[4];
        }
        d = double.tryParse(s1);
        sum &= (s1.replaceAll(_tic, '').toLowerCase() == 'true') ||
            d != null && d != 0;
        if (!sum) {
          return _falseValueStr;
        }
      }
    }
    return sum ? _trueValueStr : _falseValueStr;
  }

  /// Returns the And of all values treated as logical values listed in the argument.
  String _computeOr(String range) {
    bool sum = false;
    if (range.isEmpty) {
      return _formulaErrorStrings[_wrongNumberArguments];
    }
    String s1;
    double? d;
    final List<String> ranges = _splitArgsPreservingQuotedCommas(range);
    for (final String r in ranges) {
      if (_splitArguments(r, ':').length > 1 &&
          _isCellReference(r.replaceAll(_tic, ''))) {
        for (final String? s in _getCellsFromArgs(r)) {
          try {
            s1 = _getValueFromArg(s);
            if (_errorStrings.contains(s1)) {
              return s1;
            }
          } catch (e) {
            _exceptionThrown = true;
            return _errorStrings[4];
          }
          d = double.tryParse(s1);
          sum &= s1 == ''
              ? _trueValueStr.toLowerCase() == 'true'
              : ((s1 == _trueValueStr) || d != null && d != 0);
          if (!sum) {
            return _falseValueStr;
          }
        }
      } else {
        try {
          s1 = _getValueFromArg(r);
          if (s1.startsWith(_tic) &&
              (r.replaceAll(_tic, '').toLowerCase() != 'true')) {
            return _errorStrings[1];
          }
          if (ranges.length == 1) {
            if (s1.isEmpty) {
              return _errorStrings[1];
            }
          }
          if (_errorStrings.contains(s1)) {
            return s1;
          }

          if (DateTime.tryParse(s1) != null) {
            return _trueValueStr;
          } else if ((double.tryParse(s1) == null) &&
              s1 != '' &&
              !(s1.replaceAll(_tic, '').toLowerCase() == 'true' ||
                  s1.replaceAll(_tic, '').toLowerCase() == 'false')) {
            return (_isCellReference(r)) ? _errorStrings[1] : _errorStrings[5];
          }
        } catch (e) {
          _exceptionThrown = true;
          return _errorStrings[4];
        }
        d = double.tryParse(s1);
        sum |= (s1.replaceAll(_tic, '').toLowerCase() == 'true') ||
            d != null && d != 0;
        if (sum) {
          return _trueValueStr;
        }
      }
    }
    return sum ? _trueValueStr : _falseValueStr;
  }

  ///  Flips the logical value represented by the argument.
  String _computeNot(String args) {
    double? d1;
    String s = args;
    ////parsed formula
    if (args.isNotEmpty &&
        !_isLetter(args.codeUnitAt(0)) &&
        _indexOfAny(args, <String>[parseArgumentSeparator, ':']) > -1) {
      return _formulaErrorStrings[_requiresASingleArgument];
    } else {
      try {
        s = _getValueFromArg(s);
        d1 = double.tryParse(s);
        if (s == _trueValueStr) {
          s = _falseValueStr;
        } else if (s == _falseValueStr) {
          s = _trueValueStr;
        } else if (d1 != null) {
          ////Flip the value.
          if (d1.abs() > 1e-10) {
            s = _falseValueStr;
          } else {
            s = _trueValueStr;
          }
        }
      } catch (e) {
        _exceptionThrown = true;
        return e.toString();
      }
    }
    return s;
  }

  /// A method to split the arguments using argument seperator.
  List<String> _splitArguments(String args, String argSeperator) {
    final List<String> splitArg = <String>[];
    int start = 0;
    int ticCount = 0;
    for (int i = 0; i < args.length; i++) {
      if (args[i] == '"') {
        if (ticCount == 0) {
          ticCount++;
        } else {
          ticCount = 0;
        }
      }
      if (args[i] == argSeperator && ticCount != 1) {
        splitArg.add(args.substring(start, i - start));
        start = i + 1;
      }
      if (i == (args.length - 1)) {
        splitArg.add(args.substring(start, i - start + 1));
      }
    }

    final List<String> argList = splitArg;
    return argList;
  }

  /// A Virtual method to compute the value based on the argument passed in.
  String _getValueFromArg(String? arg) {
    if (_textIsEmpty(arg)) {
      return '';
    }
    double? d;
    arg = arg!.replaceAll('u', '-');
    arg = arg.replaceAll('~', _tic + _tic);

    if (!_isUpper(arg[0]) &&
        (_isDigit(arg[0].codeUnitAt(0)) ||
            arg[0] == parseDecimalSeparator ||
            arg[0] == '+' ||
            arg[0] == '-' ||
            arg[0] == 'n' ||
            (arg.length == 1 && (arg[0] == 'i' || arg[0] == 'j')))) {
      if (arg[0] == 'n') {
        arg = arg.substring(1);
      }
      d = double.tryParse(arg);
      if (d != null) {
        return _getValueFromArgPreserveLeadingZeros ? arg : d.toString();
      } else if (arg.startsWith(_trueValueStr) ||
          arg.startsWith(_falseValueStr)) {
        return arg;
      }
    }
    if (_ignoreCellValue &&
        !(arg.startsWith(_trueValueStr) || arg.startsWith(_falseValueStr))) {
      _ignoreCellValue = false;
      return arg;
    }

    ////Not a number.
    if ((_indexOfAny(arg, <String>['+', '-', '/', '*', ')', ')', '{']) == -1 &&
            _isUpper(arg[0])) ||
        arg[0] == _sheetToken) {
      if (!arg.startsWith(_sheetToken)) {
        arg = _putTokensForSheets(arg);
      }
      String s1 = _getValueFromParentObject(arg, true);
      if (arg != _trueValueStr && arg != _falseValueStr) {
        d = double.tryParse(s1.replaceAll(_tic, ''));
        if (!_getValueFromArgPreserveLeadingZeros &&
            !_isCellReference(arg) &&
            s1.isNotEmpty &&
            d != null) {
          s1 = d.toString();
        }
      }
      return s1;
    }
    return _computedValue(arg);
  }

  List<dynamic> _processUpperCase(String formula, int i, String sheet) {
    String s = '';
    while (i < formula.length && (_isUpper(formula[i]) || formula[i] == ' ')) {
      s = s + formula[i];
      i = i + 1;
    }

    while (i < formula.length && _isDigit(formula.codeUnitAt(i))) {
      s = s + formula[i];
      i = i + 1;
    }
    if (_supportRangeOperands && i < formula.length && formula[i] == ':') {
      s = s + formula[i];
      //s = '';
      i = i + 1;
      while (i < formula.length && formula[i] == formula[i].toUpperCase()) {
        s = s + formula[i];
        i = i + 1;
      }

      while (i < formula.length && _isDigit(formula.codeUnitAt(i))) {
        s = s + formula[i];
        i = i + 1;
      }
      if (_errorStrings.contains(_getCellFrom(s))) {
        s = _getCellFrom(s);
      } else {
        s = sheet + _getCellFrom(s);
      }
      sheet = '';
    } else {
      s = sheet + s;
      sheet = '';
    }
    return <dynamic>[s, formula, i, sheet];
  }

  /// A method that parses the text in a formula passed in.
  String _parseFormula(String formula) {
    try {
      if (formula.isNotEmpty && formula[0] == CalcEngine._formulaCharacter) {
        formula = formula.substring(1);
      }

      if (formula.isNotEmpty && formula[0] == '+') {
        formula = formula.substring(1);
      }

      _isRangeOperand = _supportRangeOperands && _isRange(formula);
      return _parse(formula.trim());
    } finally {
      if (_computedValueLevel <= 1) {
        _isArrayFormula = false;
      }
    }
  }

  List<dynamic> _isDate(Object o, DateTime? date) {
    date = _dateTime1900;
    date = DateTime.tryParse(o.toString());
    return <dynamic>[
      (date != null && date.difference(_dateTime1900).inDays >= 0),
      date
    ];
  }

  bool _isRange(String range) {
    ////checks if range holds a stand-alone range. Used to id when user inputs
    ////a formula that is just a range. Part of the support for using ranges as
    ////operands of binary operators. This method allows a range to be used with
    ////the formula assignment operator, =
    bool bIsRange = false;
    final int i = range.indexOf(':');
    if (i > 1 && i < range.length - 2) {
      ////check left side
      int j = i - 1;

      if (_isDigit(range.codeUnitAt(j))) {
        //// left side must end in digit
        bool needToCheckRightSide = false;
        j--;
        while (j > 0 && _isDigit(range.codeUnitAt(j))) {
          j--;
        }

        if (_isLetter(range.codeUnitAt(j))) {
          ////letters must come now
          j--;
          while (j >= 0 && _isLetter(range.codeUnitAt(j))) {
            j--;
          }

          if (j > -1 && range[j] == _stringFixedReference[0]) {
            j--;
          }

          if (j < 0 || j == 0) {
            needToCheckRightSide = true; ////might have a range
          } else {
            if (range[j] == _sheetToken) {
              if (j-- > 1 && range[j] == _charTIC) {
                needToCheckRightSide =
                    range.substring(0, j - 1).lastIndexOf(_charTIC) == 0;
              } else if (j > 0 && _isDigit(range.codeUnitAt(j))) {
                needToCheckRightSide =
                    range.substring(0, j).lastIndexOf(_sheetToken) == 0;
              }
            }
          }
        }

        if (needToCheckRightSide) {
          ////check right side
          j = i + 1;

          if (range[j] == _sheetToken) {
            j++;
            while (j < range.length && range[j] != _sheetToken) {
              j++;
            }

            if (j < range.length) {
              j++;
            }
          }

          ////handle possible sheetnames
          if (j < range.length - 6 && range[j] == _charTIC) {
            j = range.indexOf(_sheetToken, j + 1);
            if (j < range.length - 2) {
              j++;
            }
          }

          if (j < range.length - 2 && range[j] == _stringFixedReference[0]) {
            j++;
          }

          if (_isLetter(range.codeUnitAt(j))) {
            j++;
            while (j < range.length - 1 && _isLetter(range.codeUnitAt(j))) {
              j++;
            }

            if (_isDigit(range.codeUnitAt(j))) {
              j++;
              while (j < range.length && _isDigit(range.codeUnitAt(j))) {
                j++;
              }

              bIsRange = j == range.length;
            }
          }
        }
      }
    }
    return bIsRange;
  }

  String _parse(String text) {
    _exceptionThrown = false;
    if (_textIsEmpty(text)) {
      return text;
    }
    if (text.contains(_tic)) {
      text = _checkForStringTIC(text);
    }

    if (_formulaChar.isNotEmpty && text.isNotEmpty && _formulaChar == text[0]) {
      text = text.substring(1);
    }

    ////Save Strings...
    final List<dynamic> result = _saveStrings(text);
    final Map<dynamic, dynamic>? formulaStrings =
        result[0] as Map<dynamic, dynamic>?;
    text = result[1] as String;

    ////Make braces Strings...
    text = text.replaceAll(_braceLeft, _tic);
    text = text.replaceAll(_braceRight, _tic);

    text = text.replaceAll('-+', '-');
    int i = 0;
    if (!text.endsWith(_bMarker) ||
        _lastIndexOfAny(text, _tokens) != (text.length - 2)) {
      text = text.toUpperCase();
    }
// ignore: prefer_contains
    if (text.indexOf(_sheetToken) > -1) {
      ////Replace sheet references with tokens.
      final SheetFamilyItem? family = _getSheetFamilyItem(_grid);
      if (family!._sheetNameToParentObject != null &&
          family._sheetNameToParentObject!.isNotEmpty) {
        try {
          if (!text.startsWith(_sheetToken)) {
            text = _putTokensForSheets(text);
          }
        } catch (e) {
          _exceptionThrown = true;
          if (_rethrowExceptions) {
            rethrow; ////Rethrow so the caller can handle the bad parse on formula name.
          } else {
            return e.toString();
          }
        }
      }
    }
    if (_isRangeOperand) {
      _isRangeOperand = false;
      return _getCellFrom(_parseSimple(text));
    }

    text = text.replaceAll(' ', '');
    text = text.replaceAll('=>', '>=');
    text = text.replaceAll('=<', '<=');

    try {
      text = _markLibraryFormulas(text);
    } catch (e) {
      _exceptionThrown = true;
      if (_rethrowExceptions) {
        rethrow; ////Rethrow so the caller can handle the bad parse on formula name.
      } else {
        return _errorStrings[5];
      }
    }

    ////Look for inner matching and parse pieces without parens with _parseSimple.
    if (!_ignoreBracet) {
      while ((i = text.indexOf(')')) > -1) {
        final int k = text.substring(0, i).lastIndexOf('(');
        if (k == -1) {
          throw Exception(_formulaErrorStrings[_mismatchedParentheses]);
        }

        if (k == i - 1) {
          throw Exception(_formulaErrorStrings[_emptyExpression]);
        }
        String s = '';
        if (_ignoreBracet) {
          s = text.substring(k, k + i - k + 1);
        } else {
          s = text.substring(k + 1, k + 1 + i - k - 1);
        }

        text = text.substring(0, k) + _parseSimple(s) + text.substring(i + 1);
      }
    }

    ////All parens should have been removed.
    // ignore: prefer_contains
    if (!_ignoreBracet && text.indexOf('(') > -1) {
      throw Exception(_formulaErrorStrings[_mismatchedParentheses]);
    }

    String retValue = _parseSimple(text);
    if (formulaStrings != null && formulaStrings.isNotEmpty) {
      retValue = _setStrings(retValue, formulaStrings);
    }
    return retValue;
  }

  /// Tokenizes all library references.
  String _markLibraryFormulas(String formula) {
    int rightParens = formula.indexOf(')');
    while (rightParens > -1) {
      int parenCount = 0;
      int leftParens = rightParens - 1;
      while (
          leftParens > -1 && (formula[leftParens] != '(' || parenCount != 0)) {
        if (formula[leftParens] == ')') {
          parenCount++;
        } else if (formula[leftParens] == ')') {
          parenCount--;
        }

        leftParens--;
      }

      if (leftParens == -1) {
        throw Exception(_formulaErrorStrings[_mismatchedParentheses]);
      }

      int i = leftParens - 1;
      while (i > -1 &&
          (_isLetterOrDigit(formula.codeUnitAt(i)) ||
              // ignore: prefer_contains
              _validFunctionNameChars.indexOf(formula[i]) > -1 ||
              formula[i] == parseDecimalSeparator)) {
        i--;
      }

      final int len = leftParens - i - 1;

      if (len > 0 &&
          _libraryFunctions![formula.substring(i + 1, i + 1 + len)] != null) {
        if (formula.substring(i + 1, i + 1 + len) == 'AREAS' ||
            formula.substring(i + 1, i + 1 + len) == 'ROW') {
          _ignoreBracet = true;
        } else {
          _ignoreBracet = false;
        }
        final String s = formula.substring(
            leftParens, leftParens + rightParens - leftParens + 1);
        formula =
            '${formula.substring(0, i + 1)}q${formula.substring(i + 1, i + 1 + len)}${s.replaceAll('(', _leftBracket).replaceAll(')', _rightBracket)}${formula.substring(rightParens + 1)}';
      } else {
        String s = '';
        if (leftParens > 0) {
          s = formula.substring(0, leftParens);
        }

        s = '$s{${formula.substring(leftParens + 1, leftParens + 1 + rightParens - leftParens - 1)}}';
        if (rightParens < formula.length) {
          s = s + formula.substring(rightParens + 1);
        }
        formula = s;
      }

      rightParens = formula.indexOf(')');
    }

    formula = formula.replaceAll('{', '(').replaceAll('}', ')');
    return formula;
  }

  int _findLastNonQB(String text) {
    int ret = -1;
    // ignore: prefer_contains
    if (text.indexOf(_bMarker) > -1) {
      int bracketLevel = 0;
      for (int i = text.length - 1; i >= 0; --i) {
        if (text[i] == _rightBracket) {
          bracketLevel--;
        } else if (text[i] == _leftBracket) {
          bracketLevel++;
        } else if (text[i] == _bMarker && bracketLevel == 0) {
          ret = i;
          break;
        }
      }
    }

    return ret;
  }

  String _parseSimple(String text) {
    ////strip leading plus
    if (text.isNotEmpty && text[0] == '+') {
      text = text.substring(1);
    }
    if (text == '#N/A' || text == '#N~A') {
      return '#N/A';
    } else if (text.contains('#N/A')) {
      text = text.replaceAll('#N/A', '#N~A');
    } else if (text == 'true' || text == 'false') {
      return text;
    }

    if (text == '#DIV/0!' || text == '#DIV~0!') {
      return '#DIV/0!';
    } else if (text.contains('#DIV/0!')) {
      text = text.replaceAll('#DIV/0!', '#DIV~0!');
    }
    //text = HandleEmbeddedEs(text);

    ////TraceUtil.TraceCurrentMethodInfoIf(Switches.FormulaCell.TraceVerbose, text, this);

    String sb = text;
    bool process = true;
    while (process) {
      sb = sb.replaceAll('--', '+');
      sb = sb.replaceAll('++', '+');
      ////Mark unary minus with u-token.

      sb = sb
          .replaceAll('$parseArgumentSeparator-', '${parseArgumentSeparator}u')
          .replaceAll('$_leftBracket-', '${_leftBracket}u')
          .replaceAll('=-', '=u')
          .replaceAll('>-', '>u')
          .replaceAll('<-', '<u')
          .replaceAll('/-', '/u')
          .replaceAll('*-', '*u')
          .replaceAll('+-', '+u')
          .replaceAll('^-', '^u');
      ////Get rid of leading pluses.
      sb = sb
          .replaceAll('$parseArgumentSeparator,+', '$parseArgumentSeparator,')
          .replaceAll('$_leftBracket+', _leftBracket)
          .replaceAll('=+', '=')
          .replaceAll('>+', '>')
          .replaceAll('<+', '<')
          .replaceAll('/+', '/')
          .replaceAll('*+', '*')
          .replaceAll('^+', '^');
      if (sb.isNotEmpty && sb[0] == '+') {
        sb = sb.replaceRange(0, 1, '');
      }

      process = text != sb;
      text = sb;
    }
    text = sb
        .replaceAll(_stringLessEq, _charLesseq)
        .replaceAll(_stringGreaterEq, _charGreaterEq)
        .replaceAll(_stringNoEqual, _charNoEqual)
        .replaceAll(_stringOr, _charOr)
        .replaceAll(_stringAnd, _charAnd);

    String tempText = text;
    while (tempText.contains(r'$')) {
      final int d = tempText.indexOf(r'$');
      final List<String> markers = <String>[
        ')',
        parseArgumentSeparator,
        '}',
        '+',
        '-',
        '*',
        '/',
        '<',
        '>',
        '=',
        '&',
        ':',
        '%'
      ];
      if ((tempText.length == 1 && d == 0) ||
          tempText.length - 1 == d &&
              (d > 0 && _indexOfAny(tempText[d - 1], markers) > -1) ||
          (d < tempText.length && _indexOfAny(tempText[d + 1], markers) > -1)) {
        return _errorStrings[5];
      } else {
        tempText = tempText.replaceRange(d, d + 1, '');
        text = tempText;
      }
    }
    if (text == '') {
      return text;
    }

    bool needToContinue = true;

    List<dynamic> result;
    result = _parseSimpleFromMarkers(text, <String>[_tokenEP, _tokenEM],
        <String>[_charEP, _charEM], needToContinue);
    text = result[0] as String;
    needToContinue = result[1] as bool;
    result = _parseSimpleFromMarkers(
        text, <String>[_tokenOr], <String>[_charOr], needToContinue);
    text = result[0] as String;
    needToContinue = result[1] as bool;
    if (needToContinue) {
      result = _parseSimpleFromMarkers(
          text,
          <String>[_tokenMultiply, _tokenDivide],
          <String>[_charMultiply, _charDivide],
          needToContinue);
      text = result[0] as String;
      needToContinue = result[1] as bool;
    }

    if (needToContinue) {
      result = _parseSimpleFromMarkers(
          text,
          <String>[_tokenAdd, _tokenSubtract],
          <String>[_charAdd, _charSubtract],
          needToContinue);
      text = result[0] as String;
      needToContinue = result[1] as bool;
    }

    if (needToContinue) {
      result = _parseSimpleFromMarkers(
          text, <String>[_tokenAnd], <String>[_charAnd], needToContinue);
      text = result[0] as String;
      needToContinue = result[1] as bool;
    }

    if (needToContinue) {
      result = _parseSimpleFromMarkers(
          text,
          <String>[
            _tokenLess,
            _tokenGreater,
            _tokenEqual,
            _tokenLesseq,
            _tokenGreaterEq,
            _tokenNoEqual
          ],
          <String>[
            _charLess,
            _charGreater,
            _charEqual,
            _charLesseq,
            _charGreaterEq,
            _charNoEqual
          ],
          needToContinue);
      text = result[0] as String;
      needToContinue = result[1] as bool;
    }

    return text;
  }

  List<dynamic> _parseSimpleFromMarkers(String text, List<String> markers,
      List<String> operators, bool needToContinue) {
    int i;
    String op = '';
    for (final String c in operators) {
      op = op + c;
    }

    ////Mark unary minus with u-token.
    final String sb = text;
    if (text.startsWith(parseArgumentSeparator) || text.startsWith('%')) {
      return <dynamic>[_errorStrings[5], needToContinue];
    }
    text = sb
        .replaceAll('---', '-')
        .replaceAll('--', '+')
        .replaceAll('$parseArgumentSeparator-', '${parseArgumentSeparator}u')
        .replaceAll('$_leftBracket-', '${_leftBracket}u')
        .replaceAll('=-', '=u')
        .replaceAll('>-', '>u')
        .replaceAll('<-', '<u')
        .replaceAll('/-', '/u')
        .replaceAll('*-', '*u')
        .replaceAll('+-', '-')
        .replaceAll('--', '-u')
        .replaceAll('w-', 'wu');

    ////Get rid of leading pluses.
    text = sb
        .replaceAll('$parseArgumentSeparator+', parseArgumentSeparator)
        .replaceAll('$_leftBracket+', _leftBracket)
        .replaceAll('=+', '=')
        .replaceAll('>+', '>')
        .replaceAll('<+', '<')
        .replaceAll('/+', '/')
        .replaceAll('*+', '*')
        .replaceAll('++', '+');

    if (text.isNotEmpty && text[0] == '-') {
      ////Leading unary minus.
      text = text.substring(1).replaceAll('-', '„');
      text = '0-$text';
      final List<dynamic> iResult = _parseSimpleFromMarkers(text,
          <String>[_tokenSubtract], <String>[_charSubtract], needToContinue);
      text = iResult[0] as String;
      needToContinue = iResult[1] as bool;
      text = text.replaceAll('„', '-');
    } else if (text.isNotEmpty && text[0] == '+') {
      ////Leading plus.
      text = text.substring(1);
    }
    try {
      if (_indexOfAny(text, operators) > -1) {
        while ((i = _indexOfAny(text, operators)) > -1) {
          String left = '';
          String right = '';

          int leftIndex = 0;
          int rightIndex = 0;

          final bool isNotOperator =
              _supportLogicalOperators && text[i] == String.fromCharCode(145);
          int j;

          if (!isNotOperator) {
            if (i < 1 && text[i] != '-') {
              throw Exception(
                  _formulaErrorStrings[_operatorsCannotStartAnExpression]);
            }

            ////Process left argument.
            j = i - 1;

            if (text[j] == _tic[0]) {
              ////String
              final int k = text.substring(0, j - 1).lastIndexOf(_tic);
              if (k < 0) {
                throw Exception(_formulaErrorStrings[_cannotParse]);
              }

              left = text.substring(k, k + j - k + 1); ////Keep the tics.
              leftIndex = k;
            } else if (text[j] == _bMarker) {
              ////Block of already parsed code.
              final int k = _findLastNonQB(text.substring(0, j - 1));
              if (k < 0) {
                throw Exception(_formulaErrorStrings[_cannotParse]);
              }

              left = text.substring(k + 1, k + 1 + j - k - 1);
              leftIndex = k + 1;
            } else if (text[j] == '!' || text[j] == '?') {
              int leftErrorIndex = 1;
              j = j - 1;
              while (text[j] != '#') {
                leftErrorIndex++;
                j--;
              }
              left = text.substring(j, j + leftErrorIndex + 1);
              leftIndex = j;
            } else if (text[j] == _rightBracket) {
              ////Library member.
              int bracketCount = 0;
              int k = j - 1;
              while (k > 0 && (text[k] != 'q' || bracketCount != 0)) {
                if (text[k] == 'q') {
                  bracketCount--;
                } else if (text[k] == _rightBracket) {
                  bracketCount++;
                }

                k--;
              }

              if (k < 0) {
                throw Exception(_formulaErrorStrings[_badLibrary]);
              }

              left = text.substring(k, j + 1);
              leftIndex = k;
            } else if (!_isDigit(text.codeUnitAt(j)) &&
                text[j] != '%' &&
                (!text.contains(':') ||
                    (text.contains(':') && i < text.indexOf(':')))) {
              while (j >= 0 && (_isUpper(text[j]))) {
                j--;
              }
              while (j > -1 &&
                  (_isUpper(text[j]) ||
                      _isDigit(text.codeUnitAt(j)) ||
                      text[j] == '_' ||
                      text[j] == '.')) {
                j--;
              }

              left =
                  text.substring(j + 1, j + 1 + i - j - 1); ////'n' for number
              leftIndex = j + 1;
              if (!_findNamedRange) {
                if (left == _trueValueStr) {
                  left = 'n$_trueValueStr';
                } else if (left == _falseValueStr) {
                  left = 'n$_falseValueStr';
                } else {
                  return <dynamic>[_errorStrings[5], needToContinue];
                }
              }
              _findNamedRange = false;
            } else {
              bool period = false;
              bool percent = false;
              while (j > -1 &&
                  (_isDigit(text.codeUnitAt(j)) ||
                      (!period && text[j] == parseDecimalSeparator) ||
                      (!percent && text[j] == '%') ||
                      text[j] == 'u' ||
                      text[j] == '_')) {
                if (text[j] == parseDecimalSeparator) {
                  period = true;
                } else if (text[j] == '%') {
                  percent = true;
                }

                j = j - 1;
              }

              ////Add error check for 2%.
              if (j > -1 && period && text[j] == parseDecimalSeparator) {
                throw Exception(
                    _formulaErrorStrings[_numberContains2DecimalPoints]);
              }

              j = j + 1;

              if (j == 0 || (j > 0 && !_isUpper(text[j - 1]))) {
                left = 'n${text.substring(j, j + i - j)}'; ////'n' for number
                leftIndex = j;
              } else {
                j = j - 1;
                while (j > -1 &&
                    (_isUpper(text[j]) ||
                        _isDigit(text.codeUnitAt(j)) ||
                        text[j] == '_' ||
                        text[j] == r'\\')) {
                  j = j - 1;
                }

                ////include any unary minus as part of the left piece
                if (j > -1 && text[j] == 'u') {
                  j = j - 1;
                }

                if (j > -1 && text[j] == _sheetToken) {
                  j = j - 1;
                  while (j > -1 && text[j] != _sheetToken) {
                    j = j - 1;
                  }
                  {
                    while (j > -1 && text[j] != _sheetToken) {
                      j = j - 1;
                    }
                  }
                  if (j > -1 && text[j] == _sheetToken) {
                    j = j - 1;
                  }
                  if (j > -1 && text[j] == 'u') {
                    j = j - 1;
                  }
                }

                if (j > -1 && text[j] == ':') {
                  //// handle range operands
                  j = j - 1;
                  while (j > -1 && _isDigit(text.codeUnitAt(j))) {
                    j = j - 1;
                  }

                  while (j > -1 && _isUpper(text[j])) {
                    j = j - 1;
                  }

                  if (j > -1 && text[j] == _sheetToken) {
                    j--;
                    while (j > -1 && text[j] != _sheetToken) {
                      j--;
                    }

                    if (j > -1 && text[j] == _sheetToken) {
                      j--;
                    }
                    if (j > -1 && text[j] == 'u') {
                      j = j - 1;
                    }
                  }

                  j = j + 1;
                  left = text.substring(j, j + i - j);

                  final List<String?> leftValue =
                      _getCellsFromArgs(left, false);
                  if (leftValue.isNotEmpty) {
                    left = leftValue[0]!;
                  }
                } else {
                  //// handle normal cell reference
                  j = j + 1;
                  left = text.substring(j, j + i - j);
                }

                leftIndex = j;
              }
            }
          } else {
            leftIndex = i;
          }

          ////Process right argument.
          if (i == text.length - 1) {
            throw Exception(
                _formulaErrorStrings[_expressionCannotEndWithAnOperator]);
          } else {
            j = i + 1;

            bool isU = text[j] == 'u';
            if (isU) {
              j++; ////ship for now, but add back later
            }

            if (text[j] == _tic[0]) {
              ////String
              final int k = text.substring(j + 1).indexOf(_tic);
              if (k < 0) {
                throw Exception(_formulaErrorStrings[_cannotParse]);
              }

              right = text.substring(j, j + k + 2);
              rightIndex = k + j + 2;
            } else if (text[j] == _bMarker) {
              ////Block of already parsed code.
              final int k = _findNonQB(text.substring(j + 1));
              if (k < 0) {
                throw Exception(_formulaErrorStrings[_cannotParse]);
              }

              right = text.substring(j + 1, j + 1 + k);

              if (isU) {
                right = '${right}nu1m'; ////multiply quantity by -1...
              }

              rightIndex = k + j + 2;
            } else if (text[j] == '#') {
              int rightErrorIndex = 0;
              for (final String err in _errorStrings) {
                final String e = err.replaceAll('/', '~');
                // ignore: prefer_contains
                if (text.indexOf(e) > -1) {
                  rightErrorIndex += e.length;
                  j += e.length - 1;
                  break;
                }
              }
              right = text.substring(i + 1, j + 1 + rightErrorIndex);
              rightIndex = j + 1;
            } else if (text[j] == 'q') {
              final int k = j + 1;

              if (k == text.length) {
                throw Exception(_formulaErrorStrings[_cannotParse]);
              }

              right = text.substring(j, j + k - j + 1);

              if (isU) {
                right = 'u$right';
              }

              rightIndex = k + 1;
            } else if (_isDigit(text.codeUnitAt(j)) ||
                text[j] == parseDecimalSeparator) {
              bool period = text[j] == parseDecimalSeparator;
              j = j + 1;
              while (j < text.length &&
                  (_isDigit(text.codeUnitAt(j)) ||
                      (!period && text[j] == parseDecimalSeparator))) {
                if (text[j] == parseDecimalSeparator) {
                  period = true;
                }

                j = j + 1;
              }

              right = 'n${text.substring(i + 1, i + 1 + j - i - 1)}';
              rightIndex = j;
            } else if (_isUpper(text[j]) || text[j] == _sheetToken) {
              if (text[j] == _sheetToken) {
                j++;
                while (j < text.length && text[j] != _sheetToken) {
                  j++;
                }
              }
              j = j + 1;
              int j0 = 0;
              // bool inbracket = false;
              while (j < text.length && (_isUpper(text[j]))) {
                j++;
                j0++;
              }

              bool noCellReference =
                  (j == text.length) || !_isDigit(text.codeUnitAt(j));
              if (j0 > 1) {
                while (j < text.length &&
                    (_isUpper(text[j]) || _isDigit(text.codeUnitAt(j)))) {
                  j++;
                }
                noCellReference = true;
              }
              while (j < text.length &&
                  (_isUpper(text[j]) ||
                      _isDigit(text.codeUnitAt(j)) ||
                      text[j] == '_' ||
                      text[j] == '.')) {
                j = j + 1;
              }

              if (j < text.length && text[j] == ':') {
                //// handle range operands
                j = j + 1;
                if (j < text.length && text[j] == _sheetToken) {
                  j++;
                  while (j < text.length && text[j] != _sheetToken) {
                    j = j + 1;
                  }

                  if (j < text.length && text[j] == _sheetToken) {
                    j++;
                  }
                }

                while (j < text.length && _isUpper(text[j])) {
                  j = j + 1;
                }

                while (j < text.length && _isDigit(text.codeUnitAt(j))) {
                  j = j + 1;
                }

                j = j - 1;

                right = text.substring(i + 1, i + 1 + j - i);

                final List<String?> rightValue =
                    _getCellsFromArgs(right, false);
                if (rightValue.isNotEmpty) {
                  right = rightValue[0]!;
                }
              } else {
                //// handle normal cell reference
                j = j - 1;
                right = text.substring(i + 1, i + 1 + j - i);
                isU = text[j] == 'u';
                if (isU) {
                  right = 'u$right';
                }
              }
              noCellReference = !_isCellReference(right);
              if (noCellReference) {
                if (!_findNamedRange) {
                  if (right == _trueValueStr) {
                    right = 'n$_trueValueStr';
                  } else if (right == _falseValueStr) {
                    right = 'n$_falseValueStr';
                  } else {
                    return <dynamic>[_errorStrings[5], needToContinue];
                  }
                }
                _findNamedRange = false;
              }

              rightIndex = j + 1;
            } else {
              throw Exception(
                  _formulaErrorStrings[_invalidCharactersFollowingAnOperator]);
            }
          }

          final int p = op.indexOf(text[i]);
          String s = _bMarker + left + right + markers[p] + _bMarker;
          if (leftIndex > 0) {
            s = text.substring(0, leftIndex) + s;
          }

          if (rightIndex < text.length) {
            s = s + text.substring(rightIndex);
          }

          s = s.replaceAll(_bMarker2, _bMarker);

          text = s;
        }
      } else {
        ////No operators  ..must be number, reference, or library method.

        ////Process left argument.
        int j = text.length - 1;

        ////Block of already parsed code.
        if (text[j] == _bMarker) {
          final int k = _findLastNonQB(text.substring(0, j - 1));
          if (k < 0) {
            throw Exception(_formulaErrorStrings[_cannotParse]);
          }
        } else if (text[j] == _rightBracket) {
          ////library member
          int bracketCount = 0;
          int k = j - 1;
          while (k > 0 && (text[k] != 'q' || bracketCount != 0)) {
            if (text[k] == 'q') {
              bracketCount--;
            } else if (text[k] == _rightBracket) {
              bracketCount++;
            }

            k--;
          }

          if (k < 0) {
            throw Exception(_formulaErrorStrings[_badLibrary]);
          }
        } else if (!_isDigit(text.codeUnitAt(j))) {
          ////number
          ////Throw new Exception(_formulaErrorStrings[invalid_char_in_number]).
        } else {
          bool period = false;
          bool percent = false;

          while (j > -1 &&
              (_isDigit(text.codeUnitAt(j)) ||
                  (!period && text[j] == parseDecimalSeparator) ||
                  (!percent && text[j] == '%'))) {
            if (text[j] == parseDecimalSeparator) {
              period = true;
            } else if (text[j] == '%') {
              percent = true;
            }

            j = j - 1;
          }

          if (j > -1 && period && text[j] == parseDecimalSeparator) {
            throw Exception(
                _formulaErrorStrings[_numberContains2DecimalPoints]);
          }
        }

        if (text.isNotEmpty && (_isUpper(text[0]) || text[0] == _sheetToken)) {
          ////Check if cell reference.
          bool ok = true;
          bool checkLetter = true;
          bool oneTokenFound = false;
          for (int k = 0; k < text.length; ++k) {
            if (text[k] == _sheetToken) {
              if (k > 0 && !oneTokenFound) {
                if (_rethrowExceptions) {
                  throw Exception(_formulaErrorStrings[_missingSheet]);
                } else {
                  return <dynamic>[_errorStrings[2], needToContinue];
                }
              }

              oneTokenFound = true;
              k++;
              while (k < text.length && _isDigit(text.codeUnitAt(k))) {
                k++;
              }

              if (k == text.length || text[k] != _sheetToken) {
                ok = false;
                break;
              }
            } else {
              if (!checkLetter && _isLetter(text.codeUnitAt(k))) {
                ok = false;
                break;
              }

              if (_isLetterOrDigit(text.codeUnitAt(k)) ||
                  text[k] == _sheetToken) {
                checkLetter = _isUpper(text[k]);
              } else {
                ok = false;
                break;
              }
            }
          }

          if (ok) {
            needToContinue = false;
          }
        }
      }

      return <dynamic>[text, needToContinue];
    } catch (e) {
      _exceptionThrown = true;
      return <dynamic>[e.toString(), needToContinue];
    }
  }

  /// Determines whether the arg is a valid cell name.
  bool _isCellReference(String args) {
    if (_textIsEmpty(args)) {
      return false;
    }
    args = _putTokensForSheets(args);
    final String sheetTokenStr = _getSheetToken(args);
    bool containsBoth = false;
    if (!_textIsEmpty(sheetTokenStr)) {
      args = args.replaceAll(sheetTokenStr, '');
    }

    bool isAlpha = false, isNum = false;
    if (args.indexOf(':') != args.lastIndexOf(':')) {
      return false;
    }
    bool result = true;
    for (final int c in args.runes) {
      if (_isLetter(c)) {
        isAlpha = true;
      } else if (_isDigit(c)) {
        isNum = true;
      } else if (String.fromCharCode(c) == ':') {
        if (isAlpha && isNum) {
          containsBoth = true;
        }
        isAlpha = false;
        isNum = false;
      } else {
        result = false;
      }
    }
    if (!result) {
      return false;
    }
    if (args.contains(':') && !args.contains(_tic)) {
      if (containsBoth && isAlpha && isNum) {
        return true;
      } else if (((isAlpha && !isNum) || (!isAlpha && isNum)) &&
          !containsBoth) {
        return true;
      } else {
        return false;
      }
    }
    if (isAlpha && isNum && !args.contains(_tic)) {
      return true;
    }

    return false;
  }

  /// Returns the value of specified cell in a _grid.
  String _getValueFromParentObject(String cell1, bool calculateFormula) {
    if (cell1 == _trueValueStr || cell1 == _falseValueStr) {
      return cell1;
    }

    final int i = cell1.lastIndexOf(_sheetToken);
    int row = 0, col = 0;
    int row1 = 0, col1 = 0;
    final Worksheet? grd = _grid;
    final SheetFamilyItem? family = _getSheetFamilyItem(_grid);
    if (i > -1 && family!._tokenToParentObject != null) {
      _grid =
          family._tokenToParentObject![cell1.substring(0, i + 1)] as Worksheet?;
      row1 = row = _getRowIndex(cell1);
      if (row == -1 && _grid is Worksheet) {
        row = _grid!.getFirstRow();
      }
      col1 = col = _getColIndex(cell1);
      if (col == -1 && _grid is Worksheet) {
        col = _grid!.getFirstColumn();
      }
      if (row1 > 1048576 || col1 > 16384 || row1 == -1 || col1 == -1) {
        return '';
      }
    } else if (i == -1) {
      row = _getRowIndex(cell1);
      if (row == -1 && _grid is Worksheet) {
        row = _grid!.getFirstRow();
      }
      col = _getColIndex(cell1);
      if (col == -1 && _grid is Worksheet) {
        col = _grid!.getFirstColumn();
      }
      if (_isSheeted && family!._parentObjectToToken != null) {
        cell1 = (family._parentObjectToToken![_grid] as String) + cell1;
      }
    }

    final String saveCell = _cell;
    _cell = cell1;

    String val = '';
    if (calculateFormula) {
      val = _getValueComputeFormulaIfNecessary(row, col, _grid!);
    } else {
      final Object s = _grid!._getValueRowCol(row, col);
      val = s.toString();
    }

    _grid = grd;
    _cell = saveCell;
    return val;
  }

  String _getValueComputeFormulaIfNecessary(int row, int col, Worksheet grd) {
    try {
      bool alreadyComputed = false;
      FormulaInfo? formula = _formulaInfoTable!.containsKey(_cell)
          ? _formulaInfoTable![_cell] as FormulaInfo
          : null;
      final Object o = grd._getValueRowCol(row, col);
      String? val = (o.toString() != '')
          ? o.toString()
          : ''; ////null; //xx _grid[row, col];
      DateTime? result;
      result = DateTime.tryParse(val);
      if (double.tryParse(val.replaceAll(_tic, '')) == null && result != null) {
        final Worksheet? sheet = _grid;
        if (sheet != null) {
          final Range range = sheet.getRangeByIndex(row, col);
          if (range.dateTime != null) {
            val = _getSerialDateTimeFromDate(result).toString();
          }
        } else {
          val = _getSerialDateTimeFromDate(result).toString();
        }
      }

      //Below condition has been checked to parse the array formulas in CalcEngine,
      if ((val.endsWith('}') && val.startsWith('{') && formula != null) ||
          (val != '' &&
              val.endsWith('}') &&
              val.startsWith('{') &&
              val[1] == CalcEngine._formulaCharacter)) {
        _isArrayFormula = true;
      }
      if ((val == '' && formula == null) ||
          (val != '' &&
              val[0] != CalcEngine._formulaCharacter &&
              !val.endsWith('%') &&
              !val.endsWith('}') &&
              !val.startsWith('{'))) {
        if (formula != null && val == formula._formulaValue) {
          return formula._formulaValue;
        } else {
          return val;
        }
      }
      if (val.isNotEmpty && val[0] == CalcEngine._formulaCharacter ||
          _isArrayFormula) {
        if (formula != null) {
          if (_useFormulaValues && !_ignoreSubtotal) {
            formula._calcID = _calcID;
          }
        } else {
          formula = FormulaInfo();

          if (!_dependentFormulaCells!.containsKey(_cell)) {
            _dependentFormulaCells![_cell] = <dynamic, dynamic>{};
          }

          bool compute = true;
          final bool isArray = _isArrayFormula;
          try {
            formula._parsedFormula = _parseFormula(val);
          } catch (e) {
            if (_inAPull) {
              val = e.toString();
              formula = null;
            } else {
              formula._formulaValue = e.toString();
            }
            compute = false;
          }
          _isArrayFormula = isArray;
          final bool tempIgnoreSubtotal = _ignoreSubtotal;
          if (formula != null && !formula._parsedFormula.contains('SUBTOTAL')) {
            _ignoreSubtotal = false;
          }
          if (compute) {
            formula!._formulaValue = _computeFormula(formula._parsedFormula);
            alreadyComputed = true;
          }
          if (formula != null) {
            if (!_ignoreSubtotal) {
              formula._calcID = _calcID;
            }
            if (!_formulaInfoTable!.containsKey(_cell)) {
              _formulaInfoTable![_cell] = formula;
            }
            val = formula._formulaValue;
          }
          _ignoreSubtotal = tempIgnoreSubtotal;
        }
      }

      if (formula != null) {
        if (_useFormulaValues || (!_inAPull || alreadyComputed)) {
          val = formula._formulaValue;
        } else if (!alreadyComputed) {
          if (_calcID == formula._calcID) {
            val = formula._formulaValue;
          } else {
            final bool tempIgnoreSubtotal = _ignoreSubtotal;
            if (!formula._parsedFormula.contains('SUBTOTAL')) {
              _ignoreSubtotal = false;
            }
            val = _computeFormula(formula._parsedFormula);
            formula._formulaValue = val;
            if (!_ignoreSubtotal || tempIgnoreSubtotal) {
              formula._calcID = _calcID;
            }
            _ignoreSubtotal = tempIgnoreSubtotal;
          }
        }
        if (_treatStringsAsZero &&
            val == '' &&
            _computedValueLevel > 1 &&
            !formula._parsedFormula.startsWith(_ifMarker)) {
          return '0';
        }
      }
      if (val == 'NaN') {
        val = 'Exception: #VALUE!';
      }
      return val;
    } finally {
      if (_computedValueLevel <= 1) {
        _isArrayFormula = false;
      }
    }
  }

  double _getSerialDateTimeFromDate(DateTime dt) {
    double d = Range._toOADate(dt) - _dateTime1900Double;
    d = 1 + Range._toOADate(dt) - _dateTime1900Double;
    if (_treat1900AsLeapYear && d > 59) {
      d += 1;
    }
    if (_useDate1904) {
      d = d - _oADate1904;
    }
    return d;
  }

  bool _isUpper(String letter) {
    return _isLetter(letter.codeUnitAt(0)) && letter[0] != letter.toLowerCase();
  }

  String _getCellFrom(String range) {
    String s = '';
    final List<String?> cells = _getCellsFromArgs(range);
    if (cells.length == 1) {
      return cells[0]!;
    }
    final int last = cells.length - 1;
    final int r1 = _getRowIndex(cells[0]!);
    if (r1 == _getRowIndex(cells[last]!)) {
      final int c1 = _getColIndex(cells[0]!);
      final int c2 = _getColIndex(cells[last]!);
      final int c = _getColIndex(_cell);
      if (c >= c1 && c <= c2) {
        s = _getAlphaLabel(c) + r1.toString();
      }
    }
    return s;
  }

  /// A method that retrieves a String array of cells from the range passed in.
  List<String?> _getCellsFromArgs(String args, [bool? findCellsFromRange]) {
    findCellsFromRange ??= true;

    args = _markColonsInQuotes(args);

    int row1 = 0;
    int col1 = 0;

    int i = args.indexOf(':');

    String sheet = '';
    const String book = '';

    final String argsRet = args;
    int j = args.indexOf(_sheetToken);
    if (j > -1) {
      final int j1 = args.indexOf(_sheetToken, j + 1);
      if (j1 > -1) {
        sheet = args.substring(j, j + j1 - j + 1);
        args = args.replaceAll(sheet, '');
        i = args.indexOf(':');
      }
    }

    if (i > 0 && _isDigit(args.codeUnitAt(i - 1))) {
      int k1 = i - 2;
      while (k1 >= 0 && _isDigit(args.codeUnitAt(k1))) {
        k1--;
      }

      if (k1 == -1 || !_isLetter(args.codeUnitAt(k1))) {
        int count = (_columnMaxCount > 0) ? _columnMaxCount : 16384;
        if (_grid is Worksheet) {
          count = _grid!.getLastColumn();
        }
        args =
            'A${args.substring(0, i)}:${_getAlphaLabel(count)}${args.substring(i + 1)}';
        i = args.indexOf(':');
      }
    }
    if (!findCellsFromRange) {
      return <String?>[sheet + args];
    }
    int row2 = 0;
    int col2 = 0;
    final List<String> argList = args.split(':');
    if (argList.length > 2) {
      int minCol, minRow, maxCol, maxRow, d;
      minCol = minRow = _intMaxValue;
      maxCol = maxRow = _intMinValue;
      for (final String tempArgs in argList) {
        d = _getRowIndex(tempArgs);
        minRow = min(minRow, d);
        maxRow = max(maxRow, d);

        d = _getColIndex(tempArgs);
        minCol = min(minCol, d);
        maxCol = max(maxCol, d);
      }
      row1 = minRow;
      row2 = maxRow;
      col1 = minCol;
      col2 = maxCol;
    } else {
      row1 = _getRowIndex(argList[0]);
      col1 = _getColIndex(argList[0]);
      row2 = _getRowIndex(argList[1]);
      col2 = _getColIndex(argList[1]);
    }
    // Check Whether rowIndex can get from the arguments
    final bool isDigit = _canGetRowIndex(args.substring(0, i));
    if (!isDigit) {
      _ignoreCellValue = true;
      args = argsRet;
      return _splitArgsPreservingQuotedCommas(args);
    }

    if (!(row1 != -1 || row2 == -1) == (row1 == -1 || row2 != -1)) {
      throw Exception(_errorStrings[5]);
    }
    if (row1 == -1 && _grid is Worksheet) {
      row1 = _grid!.getFirstRow();
    }
    if (col1 == -1 && _grid is Worksheet) {
      col1 = _grid!.getFirstColumn();
    }
    if (row2 == -1 && _grid is Worksheet) {
      row2 = _grid!.getLastRow();
    }
    if (col2 == -1 && _grid is Worksheet) {
      col2 = _grid!.getLastColumn();
    }
    if (row1 > row2) {
      i = row2;
      row2 = row1;
      row1 = i;
    }

    if (col1 > col2) {
      i = col2;
      col2 = col1;
      col1 = i;
    }

    final int numCells = (row2 - row1 + 1) * (col2 - col1 + 1);
    final List<String?> cells = List<String?>.filled(numCells, null);
    int k = 0;
    for (i = row1; i <= row2; ++i) {
      for (j = col1; j <= col2; ++j) {
        try {
          cells[k++] = book + sheet + _getAlphaLabel(j) + i.toString();
        } catch (e) {
          continue;
        }
      }
    }
    return cells;
  }

  /// To check whether the row index can be obtained from the arguments
  bool _canGetRowIndex(String s) {
    int i = 0;
    if (i < s.length && s[i] == _sheetToken) {
      i++;
      while (i < s.length && s[i] != _sheetToken) {
        i++;
      }
      i++;
    }

    while (i < s.length && _isLetter(s.codeUnitAt(i))) {
      i++;
    }

    if (i < s.length) {
      if (_isDigit(s.codeUnitAt(i))) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  String _markColonsInQuotes(String args) {
    bool inQuotes = false;
    // ignore: prefer_contains
    if (args.indexOf(':') == -1) {
      return args;
    }

    for (int i = 0; i < args.length; ++i) {
      if (args[i] == _tic[0]) {
        inQuotes = !inQuotes;
      } else if (args[i] == ':' && inQuotes) {
        args = args.replaceAll(':', _markerChar);
      }
    }
    return args;
  }

  /// </summary>
  List<String> _splitArgsPreservingQuotedCommas(String args) {
    // ignore: prefer_contains
    if (args.indexOf(_tic) == -1) {
      return args.split(parseArgumentSeparator);
    }

    final List<dynamic> result = _saveStrings(args);
    final Map<dynamic, dynamic> formulaStrings =
        result[0] as Map<dynamic, dynamic>;
    args = result[1] as String;

    final List<String> results = args.split(parseArgumentSeparator);
    final List<String> pieces = <String>[];
    for (final String s in results) {
      String s1 = s;
      s1 = _setStrings(
          s1, formulaStrings); ////replace tokens with original Strings
      pieces.add(s1);
    }
    return pieces;
  }

  int _findNonQB(String text) {
    int ret = -1;
    // ignore: prefer_contains
    if (text.indexOf(_bMarker) > -1) {
      int bracketLevel = 0;
      for (int i = 0; i < text.length; ++i) {
        if (text[i] == _rightBracket) {
          bracketLevel--;
        } else if (text[i] == _leftBracket) {
          bracketLevel++;
        } else if (text[i] == _bMarker && bracketLevel == 0) {
          ret = i;
          break;
        }
      }
    }

    return ret;
  }

  List<dynamic> _saveStrings(String text) {
    Map<dynamic, dynamic>? strings;
    final String tICs2 = _tic + _tic;
    int id = 0;

    int i = -1;
    if ((i = text.indexOf(_tic)) > -1) {
      while (i > -1 && i < text.length) {
        strings ??= <dynamic, dynamic>{};

        int j = (i + 1) < text.length ? text.indexOf(_tic, i + 1) : -1;
        if (j > -1) {
          final String key = _tic + _uniqueStringMarker + id.toString() + _tic;
          if (j < text.length - 2 && text[j + 1] == _tic[0]) {
            j = text.indexOf(_tic, j + 2);
            if (j == -1) {
              throw Exception(_formulaErrorStrings[_mismatchedTics]);
            }
          }

          String s = text.substring(i, i + j - i + 1);
          strings[key] = s;
          s = s.replaceAll(tICs2, _tic);
          id++;
          text = text.substring(0, i) + key + text.substring(j + 1);
          i = i + key.length;
          if (i < text.length) {
            i = text.indexOf(_tic, i);
          }
        } else {
          throw Exception(_formulaErrorStrings[_mismatchedTics]);
        }
      }
    }

    return <dynamic>[strings, text];
  }

  String _setStrings(String retValue, Map<dynamic, dynamic> strings) {
    for (final dynamic s in strings.keys) {
      retValue = retValue.replaceAll(s, strings[s] as String);
    }
    return retValue;
  }

  String _putTokensForSheets(String text) {
    final SheetFamilyItem? family = _getSheetFamilyItem(_grid);

    if (_supportsSheetRanges) {
      text = _handleSheetRanges(text, family!);
    }

    if (_sortedSheetNamesList != null) {
      for (final String name in _sortedSheetNamesList!) {
        String token = family!._sheetNameToToken![name] as String;
        token = token.replaceAll(_sheetToken, _tempSheetPlaceHolder);

        String s = "'${name.toUpperCase()}'$_sheetToken";
        if (!text.contains(s)) {
          s = _sheetToken + name.toUpperCase() + _sheetToken;
        }
        text = text.replaceAll(s, token);
        //do it again without the tics
        s = name.toUpperCase() + _sheetToken;
        text = text.replaceAll(s, token);
      }
    }
    text = text.replaceAll(_tempSheetPlaceHolder, _sheetToken);
    return text;
  }

  String _handleSheetRanges(String text, SheetFamilyItem family) {
    int sheetLoc = text.indexOf(_sheetToken);
    int start = 0;
    while (sheetLoc > 0) {
      final int colonLoc =
          text.substring(start, start + sheetLoc).lastIndexOf(':');
      if (colonLoc > -1) {
        {
          start = sheetLoc + start;
        }
      } else {
        start = sheetLoc + start;
      }

      sheetLoc = text.substring(start + 1).indexOf(_sheetToken) + 1;
    }

    text = text.replaceAll(String.fromCharCode(131), _sheetToken);

    return text;
  }

  String _popString(Stack stack) {
    final Object? o = stack._pop();
    final double? d = double.tryParse(o.toString());
    if (!_getValueFromArgPreserveLeadingZeros && d != null) {
      return d.toString();
    }

    if (_errorStrings.contains(o.toString().replaceAll(_tic, ''))) {
      return o.toString();
    } else {
      return o.toString();
    }
  }

  double _pop(Stack stack) {
    final dynamic o = stack._pop();
    String s = '';
    if (o.toString() == _tic + _tic) {
      return double.nan;
    } else {
      s = o.toString().replaceAll(_tic, '');
    }
    if (s.contains('i') ||
        s.contains('j') ||
        s.contains('I') ||
        s.contains('J')) {
      final String last = s.substring(s.length - 1, s.length - 1 + 1);
      if (last == 'i' || last == 'j' || last == 'I' || last == 'J') {
        return double.nan;
      }
    }
    if (_errorStrings.contains(s)) {
      _isErrorString = true;
      return _errorStrings.indexOf(s).toDouble();
    }
    ////moved from _computedValue above as result of DT26064
    if (s.startsWith('#') || s == '') {
      return 0;
    }

    if (s == _trueValueStr) {
      return 1;
    } else if (s == _falseValueStr) {
      return 0;
    }

    final double? d = double.tryParse(s);
    if (d != null) {
      return d;
    } else if (useDatesInCalculations) {
      DateTime? dt;
      final List<dynamic> listResult = _isDate(o, dt);
      if (listResult[0] as bool) {
        return _getSerialDateTimeFromDate(listResult[1]);
      }
    }
    if (s == '' && _treatStringsAsZero) {
      return 0;
    } else if (o.toString().isNotEmpty) {
      return double.nan;
    }
    return 0;
  }

  /// Tests whether a String is NULL or empty.
  static bool _textIsEmpty(String? s) {
    return s == null || s == '';
  }

  int _lastIndexOfAny(String text, List<String> tokens) {
    for (final String token in tokens) {
      final int index = text.lastIndexOf(token);
      if (index != -1) {
        return index;
      }
    }
    return -1;
  }

  static int _indexOfAny(String text, List<String> tokens) {
    for (final String token in tokens) {
      final int index = text.indexOf(token);
      if (index != -1) {
        return index;
      }
    }
    return -1;
  }

  /// This method check '\'in the String and removes if the String contains  '\'\.
  String _checkForStringTIC(String text) {
    int i = 0;
    bool stringTIC = false;
    final String doubleTIC = _tic + _tic;
    if ((i = text.indexOf(_tic)) > -1) {
      while (i > -1 && i < text.length - 1) {
        int j = (i + 1) < text.length ? text.indexOf(_tic, i + 1) : -1;
        if (j > -1) {
          if (j < text.length - 2 && text[j + 1] == _tic[0]) {
            //Below condition checks whether the parsed text conatins TIC after the double TIC(eg.\"new \"\" name\").
            j = text.indexOf(_tic, j + 2);
            if (j == -1) {
              throw Exception(_formulaErrorStrings[_mismatchedTics]);
            }
          }
          //Below condition is avoid to remove "\"\ while it placed inside of the String value(eg., \"<p>\"\"Req\"\" </p>\").
          if (j < text.length - 2 && text[j + 1] == _tic[0]) {
            stringTIC = true;
            j = text.indexOf(_tic, j + 2);
            if (j == -1) {
              throw Exception(_formulaErrorStrings[_mismatchedTics]);
            }
          }
          String s = text.substring(i, i + j - i + 1);
          if (s != doubleTIC && !stringTIC && s.contains(doubleTIC)) {
            s = s.replaceAll(doubleTIC, '~');
            _isDoubleQuotes = true;
          }
          text = text.substring(0, i) + s + text.substring(j + 1);
          i = i + s.length;
          if (i < text.length - 1) {
            i = text.indexOf(_tic, i);
          }
        } else if (j == -1) {
          return text;
        }
      }
    }
    return text;
  }

  String _computeInteriorFunctions(String formula) {
    try {
      if (_textIsEmpty(formula)) {
        return formula;
      }

      ////int q = formula.LastIndexOf('q');
      int q = _findLastqNotInBrackets(formula);
      while (q > 0) {
        final int last = formula.substring(q).indexOf(_rightBracket);
        if (last == -1) {
          return _formulaErrorStrings[_badFormula];
        }

        String s = formula.substring(q, q + last + 1);

        // To check if the function contains CELL formula embedded with other formulas like INDEX,IF...
        final int q1 = _findLastqNotInBrackets(formula.substring(0, q));
        final String s1 = q1 >= 0
            ? formula.substring(
                q1, q1 + formula.substring(q1).indexOf(_rightBracket))
            : '';

        // Below code has been added to check whether the Value formula is interior of SUMPRODUCT
        if ((s.contains('qVALUE') ||
                s.contains('qINT') ||
                s.contains('qROW')) &&
            s1.contains('SUMPRODUCT')) {
          _exteriorFormula = true;
        }

        if (s1.contains('qINDEX') &&
            (s1.contains('qCELL') ||
                s1.contains('qCOUNT') ||
                s1.contains('qOFFSET'))) {
          _isIndexInteriorFormula = true;
          // Below code has been added to calculate when the index is embedded formula and the index array condtains index formula.
          if (s.startsWith('qINDEX')) {
            _hitCount = _computedValueLevel + 1;
          }
        }

        s = _computedValue(s);
        if (s.isNotEmpty && s[0] == _tic[0] && s[s.length - 1] == _tic[0]) {
          String newS = s.substring(1, 1 + s.length - 2);
          if (newS.contains(_tic)) {
            _multiTick = true;
            newS = newS.replaceAll(_tic, '|');
          }
          s = _tic + newS + _tic;
        }
        if (!_isInteriorFunction) {
          s = _markupResultToIncludeInFormula(s);
        }

        _isInteriorFunction = false;
        formula = formula.substring(0, q) + s + formula.substring(q + last + 1);
        q = _findLastqNotInBrackets(formula);
      }
    } catch (e) {
      _exceptionThrown = true;
      return e.toString();
    }

    return formula;
  }

  int _findLastqNotInBrackets(String s) {
    int found = -1;
    bool lastBracket = false;
    int i = s.length - 1;
    while (i > -1) {
      if (s[i] == 'q' && lastBracket) {
        found = i;
        break;
      }

      if (s[i] == _leftBracket) {
        lastBracket = true;
      } else if (s[i] == _rightBracket) {
        lastBracket = false;
      }

      i--;
    }

    return found;
  }

  String _markupResultToIncludeInFormula(String s) {
    if (s.isNotEmpty && s[0] == '-' && double.tryParse(s) != null) {
      s = 'nu${s.substring(1)}';
    } else if (s.isNotEmpty &&
        (s[0] == _tic[0] || s[0] == _bMarker || s[0] == '#')) {
      ////Pass on the String...
    } else if (s.startsWith('TRUE') || s.startsWith('FALSE')) {
      ////Pass on the bool...
    } else {
      if (double.tryParse(s) != null) {
        s = s.replaceAll(parseArgumentSeparator, String.fromCharCode(32));

        s = 'n$s';
      } else {
        //To pass the computed result of interior functions in single cell array formula
        if (!_isRange(s) &&
            s.startsWith(_braceLeft) &&
            s.endsWith(_braceRight)) {
          s = s.replaceAll('{', '').replaceAll('}', '');
          String strValue = '';
          final List<String> ranges = _splitArgsPreservingQuotedCommas(s);
          for (final String r in ranges) {
            if (double.tryParse(r) != null) {
              strValue += 'n$r$parseArgumentSeparator';
            }
          }
          s = strValue.substring(0, strValue.length - 2);
        } else if (!_isRange(s)) {
          s = _tic + s + _tic;
        }
      }
    }
    return s;
  }

  /// Removes all leading and trailing white-space characters.
  String _computeTrim(String args) {
    String s = _getValueFromArg(args).trim();
    int len = 0;

    ////strip out interior double, triple, etc spaces...
    while (s.length != len) {
      len = s.length;
      s = s.replaceAll('  ', ' ');
    }
    return s;
  }

  /// Returns the current date and time as a date serial number.
  String _computeNow(String argList) {
    if (argList.isNotEmpty) {
      return _formulaErrorStrings[_wrongNumberArguments];
    }
    final DateTime dt = DateTime.now();
    if (excelLikeComputations) {
      return dt.toString();
    }
    return Range._toOADate(dt).toString();
  }

  /// Returns the current date as a date serial number.
  String _computeToday(String argList) {
    if (argList.isNotEmpty) {
      return _formulaErrorStrings[_wrongNumberArguments];
    }
    final DateTime dt = DateTime.now();

    if (excelLikeComputations) {
      final DateTime? result =
          DateTime.tryParse('${dt.year}/${dt.month}/${dt.day}');
      if (result != null) {
        final String date = DateFormat(
                _grid!.workbook.cultureInfo.dateTimeFormat.shortDatePattern)
            .format(result);
        return date;
      }
    }

    //Below code has been modified to return the General format value when Today formula is interior function.
    if (_computedValueLevel > 1) {
      return _getSerialDateTimeFromDate(dt).toString();
    } else {
      return _getSerialDateFromDate(dt.year, dt.month, dt.day).toString();
    }
  }

  /// Returns a single character String.
  String _computeConcatenate(String range) {
    String text = '';
    final List<String> sb = <String>[_tic];

    // Below code has been added to calculate the cell ranges(eg:A1:A5B1:B5a)
    if (!range.contains(parseArgumentSeparator)) {
      range = _adjustRangeArg(range);
    }
    final List<String> ar = _isSeparatorInTIC(range) ////range.IndexOf(TIC) > 0
        ? _getStringArray(range)
        : _splitArgsPreservingQuotedCommas(range);
    if (range.isEmpty) {
      return _formulaErrorStrings[_wrongNumberArguments];
    }
    for (final String r in ar) {
      String toAppend = r;

      final String argumentValue = _getValueFromArg(r);
      if (_errorStrings.contains(argumentValue)) {
        return argumentValue;
      }
      if (r.contains(':') && _isCellReference(r)) {
        return _errorStrings[1];
      }
      if (r == '' || r[0] != _tic[0]) {
        toAppend = _getValueFromArg(r);
      }

      if (sb.length > 1 && sb[sb.length - 1] == _tic[0]) {
        sb.removeAt(sb.length - 1);
      }

      if (toAppend.isNotEmpty && toAppend[0] == _tic[0]) {
        sb.add(toAppend.substring(1));
      } else {
        sb.add(toAppend);
      }
    }

    if (sb[sb.length - 1] != _tic[0]) {
      sb.add(_tic);
    }

    text = sb.join();
    if (text.contains('#N/A')) {
      text = '#N/A';
    }

    if (excelLikeComputations) {
      final String newText =
          text.substring(text.indexOf(_tic) + 1, text.lastIndexOf(_tic) - 1);
      return newText;
    }
    return text;
  }

  // Accepts a possible parsed formula and returns the calculated value without quotes.
  ///
  /// <remarks>
  /// This method is useful in custom functions if you want to allow
  /// your custom functions to handle parsed formulas as arguments. In
  /// this case, calling this method at the beginning of your custom function
  /// will allow you custom function to work only with computed values, and not
  /// have to handle parsed formulas directly.
  /// </remarks>
  String _adjustRangeArg(String range) {
    if (range.length > 1 &&
        range[0] == _bMarker &&
        range[range.length - 1] == _bMarker &&
        !range.substring(1, range.length - 2).contains(_bMarker)) {
      range = _computedValue(range);
    }

    if (range.length > 1 &&
        range[0] == _tic[0] &&
        range[range.length - 1] == _tic[0]) {
      range = range.substring(1, range.length - 2);
    }
    return range;
  }

  /// Returns True if the ParseArgumentSeparator character is included in a String.
  bool _isSeparatorInTIC(String s) {
    int i = s.indexOf(_tic) + 1;
    bool inTic = true;
    while (i > 0 && i < s.length) {
      if (s[i] == parseArgumentSeparator && inTic) {
        return true;
      }

      if (s[i] == _tic[0]) {
        inTic = !inTic;
      }

      i++;
    }

    return false;
  }

  /// Returns an array of Strings from an argument list.
  List<String> _getStringArray(String s) {
    final List<String> argList = <String>[];

    int argStart = 0;
    bool inQuote = false;
    for (int argEnd = 0; argEnd < s.length; argEnd++) {
      final String ch = s[argEnd];
      if (ch == _tic[0]) {
        inQuote = !inQuote;
      } else if (!inQuote && ch == parseArgumentSeparator) {
        argList.add(s.substring(argStart, argEnd - argStart));
        argStart = argEnd + 1;
      }
    }

    argList.add(s.substring(argStart));
    return argList;
  }

  int _getSerialDateFromDate(int y, int m, int d) {
    int days = 0;
    if (y < 1900) {
      y += 1900;
    }

    bool isValidMonth = false;
    while (!isValidMonth) {
      while (m > 12) {
        m -= 12;
        y++;
      }
      // to check month as negative or not
      while (m < 1 && y > 1900) {
        m += 12;
        y--;
      }

      // to check month and year
      if (y < 1900 || (m < 1 && y <= 1900)) {
        return -1;
      }

      isValidMonth = true;
      final DateTime date = DateTime(y, m);
      int x = DateTime(date.year, date.month + 1, date.day - 1).day;
      // to check day with month in the string (for e.g day value as 32303)
      while (d > x) {
        d -= x;
        m++;
        if (m > 12) {
          m -= 12;
          y++;
        }
        final DateTime date = DateTime(y, m);
        x = DateTime(date.year, date.month + 1, date.day - 1).day;
        isValidMonth = false;
      }
      while (d < 1) {
        m--;
        final DateTime date = DateTime(y, m + 1);
        x = DateTime(date.year, date.month, date.day)
            .add(const Duration(hours: -1))
            .day;
        d = x + d;
      }
    }
    days = 1 + DateTime(y, m, d).difference(_dateTime1900).inDays;
    if (_treat1900AsLeapYear && days > 59) {
      days += 1;
    }

    return days;
  }

  /// Converts text to lowercase.
  String _computeLower(String args) {
    return _getValueFromArg(args).toLowerCase();
  }

  /// Converts text to uppercase.
  String _computeUpper(String args) {
    return _getValueFromArg(args).toUpperCase();
  }

  // DateTime _getDateFromSerialDate(int days) {
  //   days -= 1;
  //   if (_treat1900AsLeapYear && days > 59) {
  //     days -= 1;
  //   }

  //   return _dateTime1900.add(Duration(days: days));
  // }

  /// Returns the average of all the cells in a range which is statisfy the given multible criteria
  String _computeAverageIFS(String argsList) {
    if (argsList == '') {
      return _formulaErrorStrings[_invalidArguments];
    }
    final List<String> args = _splitArgsPreservingQuotedCommas(argsList);
    final int argCount = args.length;
    double cellCount = 0;
    final List<String> criteriaRange = <String>[];
    final List<String> criterias = <String>[];
    List<String> tempList = <String>[];
    List<String> criteriaRangeValue = <String>[];
    for (int i = 1; i < argCount; i++) {
      criteriaRange.add(args[i]);
      i++;
      criterias.add(args[i]);
    }
    if (argCount < 3 && criteriaRange.length == criterias.length) {
      return _formulaErrorStrings[_wrongNumberArguments];
    }
    String sumRange = args[0];

    double sum = 0;
    // final List<String> sumRangeCells = _getCellsFromArgs(args[0]);
    List<String?> s2 = _getCellsFromArgs(sumRange);
    bool isLastcriteria = false;
    for (int v = 0; v < criterias.length; v++) {
      String op;
      op = _tokenEqual;
      String criteria = criterias[v];
      if (criteria[0] != _tic[0] && !'=><'.contains(criteria[0])) {
        ////cell reference
        criteria = _getValueFromArg(criteria);
      }
      if (v == criteriaRange.length - 1) {
        isLastcriteria = true;
      }
      op = _findOp(criteria, op);
      criteria = _findCriteria(criteria, op);
      final List<String?> s1 = _getCellsFromArgs(criteriaRange[v]);
      if (s1[0] == _errorStrings[5] || s2[0] == _errorStrings[5]) {
        return _errorStrings[5];
      }
      final int count = s1.length;

      if (count > s2.length) {
        final int i = sumRange.indexOf(':');
        if (i > -1) {
          int startRow = _getRowIndex(sumRange.substring(0, i));
          int row = _getRowIndex(sumRange.substring(i + 1));
          if (!(startRow != -1 || row == -1) == (startRow == -1 || row != -1)) {
            return _errorStrings[5];
          }
          if (startRow == -1 && _grid is Worksheet) {
            startRow = _grid!.getFirstRow();
          }
          int startCol = _getColIndex(sumRange.substring(0, i));
          if (startCol == -1 && _grid is Worksheet) {
            startCol = _grid!.getFirstColumn();
          }
          if (row == -1 && _grid is Worksheet) {
            row = _grid!.getLastRow();
          }
          int col = _getColIndex(sumRange.substring(i + 1));
          if (col == -1 && _grid is Worksheet) {
            col = _grid!.getLastColumn();
          }
          if (startRow != row) {
            row += count - s2.length;
          } else if (startCol != col) {
            col += count - s2.length;
          }

          sumRange = sumRange.substring(0, i + 1) +
              _getAlphaLabel(col) +
              row.toString();
          s2 = _getCellsFromArgs(sumRange);
        }
      }
      double? d = 0.0;
      String s = '';
      double compare = -1.7976931348623157E+308;
      bool isNumber = false;
      if (double.tryParse(criteria) != null) {
        compare = double.tryParse(criteria)!;
        isNumber = true;
      }
      for (int index = 0; index < count; ++index) {
        s = _getValueFromArg(s1[index]); //// +criteria;
        final bool criteriaMatched = _checkForCriteriaMatch(
            s.toUpperCase(), op, criteria.toUpperCase(), isNumber, compare);
        if (criteriaMatched) {
          if (isLastcriteria && criterias.length == 1) {
            cellCount++;
            sum += d!;
          } else {
            //Below code has been modified to check the index of criteria.
            if (tempList.isNotEmpty && v != 0) {
              final int tempCount = tempList.length;
              //Below code has been used to add the values when length was same.
              if (tempCount == s1.length &&
                  _getRowIndex(tempList[index]) == _getRowIndex(s1[index]!)) {
                criteriaRangeValue.add(s1[index]!);
                if (isLastcriteria && s2[index] != null) {
                  s = _getValueFromArg(s2[index]);
                  d = double.tryParse(s);
                  final bool v = d != null;
                  if (v && isLastcriteria) {
                    sum += d;
                    cellCount++;
                  }
                }
              } else {
                for (int i = 0; i < tempCount; i++) {
                  //Below code has been added to compare the old and new criteria ranges and store the values which matches.
                  if (_getRowIndex(tempList[i]) == _getRowIndex(s1[index]!)) {
                    criteriaRangeValue.add(s1[index]!);
                    if (isLastcriteria && s2[index] != null) {
                      s = _getValueFromArg(s2[index]);
                      d = double.tryParse(s);
                      final bool v = d != null;
                      if (v && isLastcriteria) {
                        sum += d;
                        cellCount++;
                      }
                    }
                  }
                }
              }
            } else {
              criteriaRangeValue.add(s1[index]!);
            }
          }
        }
      }
      tempList = criteriaRangeValue;
      criteriaRangeValue = <String>[];
    }
    final double average = sum / cellCount;
    if (_computeIsErr(average.toString()) == _trueValueStr) {
      if (_rethrowExceptions) {
        throw Exception(_formulaErrorStrings[_badFormula]);
      }
      return _errorStrings[3];
    }
    return average.toString();
  }

  /// Below method used to find the criteria value which is combined with tokens.
  String _findCriteria(String criteria, String op1) {
    final int offset = (criteria.isNotEmpty && criteria[0] == _tic[0]) ? 1 : 0;
    if (criteria.substring(offset).startsWith('>=')) {
      criteria = criteria.substring(offset + 2, criteria.length - 1);
      op1 = _tokenGreaterEq;
    } else if (criteria.substring(offset).startsWith('<=')) {
      criteria = criteria.substring(offset + 2, criteria.length - 1);
      op1 = _tokenLesseq;
    } else if (criteria.substring(offset).startsWith('<>')) {
      criteria = criteria.substring(offset + 2, criteria.length - 1);
      op1 = _tokenNoEqual;
    } else if (criteria.substring(offset).startsWith('<')) {
      criteria = criteria.substring(offset + 1, criteria.length - 1);
      op1 = _tokenLess;
    } else if (criteria.substring(offset).startsWith('>')) {
      criteria = criteria.substring(offset + 1, criteria.length - 1);
      op1 = _tokenGreater;
    } else if (criteria.substring(offset).startsWith('=')) {
      criteria = criteria.substring(offset + 1, criteria.length - 1);
      op1 = _tokenEqual;
    }
    criteria = criteria.replaceAll(_tic, '');
    return criteria;
  }

  /// Below method used to find whether the criteria is matched with the Tokens "=",">",">=" or not.
  bool _checkForCriteriaMatch(
      String s, String op, String criteria, bool isNumber, double compare) {
    final String tempcriteria = criteria;
    double? d = 0.0;
    //Below condition has added to match the number when ita text value.eg(s1=\"2\" and comapre="2")
    s = s.replaceAll(_tic, '');
    switch (op) {
      case _tokenEqual:
        if (isNumber) {
          d = double.tryParse(s);
          final bool value = d != null;
          return value && d == compare;
        }
        final int starindex = tempcriteria.indexOf('*');
        if (starindex != -1 && s.isNotEmpty) {
          final bool isstartswith = starindex == 0;
          final bool isendswith = tempcriteria.endsWith('*');
          final List<String> tempArray = criteria.split('*');

          //Below code has added to calculate when criteria contains multiple "*".
          if (tempArray.length > 2) {
            bool isMatch = false;
            for (int i = 0; i < tempArray.length; i++) {
              if (i == 0 && !isstartswith) {
                isMatch = s.startsWith(tempArray[0]);
              } else {
                isMatch = s.contains(tempArray[i]);
              }
              if (!isMatch) {
                return isMatch;
              } else {
                continue;
              }
            }
            return isMatch;
          }

          // Below code has been added avoid to throw argument exception when criteria length was higher than s length.
          else if (!isstartswith && !isendswith) {
            final List<String> criterias = criteria.split('*');
            return s.startsWith(criterias[0]) && s.endsWith(criterias[1]);
          } else if (isstartswith && isendswith) {
            criteria = criteria.replaceAll('*', '');
            return s.contains(criteria);
          } else if (isstartswith) {
            criteria = criteria.replaceAll('*', '');
            return s.endsWith(criteria);
          } else if (isendswith) {
            criteria = criteria.replaceAll('*', '');
            return s.startsWith(criteria);
          }
        }
        return s.isNotEmpty && s == criteria;
      case _tokenNoEqual:
        if (isNumber) {
          d = double.tryParse(s);
          final bool value = d != null;
          return value && d != compare;
        } else {
          return s.isNotEmpty && s.toUpperCase() != criteria.toUpperCase();
        }
      case _tokenGreaterEq:
        //Below code has been added to compare the value when the criteria is string.
        final int tempString =
            s.toUpperCase().compareTo(criteria.toUpperCase());
        if (isNumber) {
          d = double.tryParse(s);
          final bool value = d != null;
          return value && d >= compare;
        } else {
          return s.isNotEmpty && tempString >= 0;
        }
      case _tokenGreater:
        //Below code has been added to compare the value when the criteria is string.
        final int tempString =
            s.toUpperCase().compareTo(criteria.toUpperCase());
        if (isNumber) {
          d = double.tryParse(s);
          final bool value = d != null;
          return value && d > compare;
        } else {
          return s.isNotEmpty && tempString > 0;
        }
      case _tokenLess:
        //Below code has been added to compare the value when the criteria is string.
        final int tempString =
            s.toUpperCase().compareTo(criteria.toUpperCase());
        if (isNumber) {
          d = double.tryParse(s);
          final bool value = d != null;
          return value && d < compare;
        } else {
          return s.isNotEmpty && tempString < 0;
        }
      case _tokenLesseq:
        //Below code has been added to compare the value when the criteria is string.
        final int tempString =
            s.toUpperCase().compareTo(criteria.toUpperCase());
        if (isNumber) {
          d = double.tryParse(s);
          final bool value = d != null;
          return value && d <= compare;
        } else {
          return s.isNotEmpty && tempString <= 0;
        }
    }
    return false;
  }

  /// Returns True is the string denotes an error except #N/A.
  String _computeIsErr(String range) {
    if (range.isEmpty) {
      if (_rethrowExceptions) {
        throw Exception(_formulaErrorStrings[_wrongNumberArguments]);
      }
      return _formulaErrorStrings[_wrongNumberArguments];
    }
    final String tempRange = range.toUpperCase();
    //Below code is modified to get the CalculatedValue when the range is cell reference.
    if (range.isNotEmpty &&
        !range.startsWith('#') &&
        !tempRange.startsWith('NAN') &&
        !tempRange.startsWith('-NAN') &&
        range != double.infinity.toString() &&
        range != double.negativeInfinity.toString()) {
      range = _getValueFromArg(range).toUpperCase().replaceAll(_tic, '');
    } else {
      range = range.toUpperCase();
    }
    if ((range.startsWith('NAN') ||
                range.startsWith('-NAN') ||
                range.startsWith('INFINITY') ||
                range.startsWith('-INFINITY') ||
                range.startsWith('#') ||
                range.startsWith('n#')) &&
            !range.startsWith('#N/A') ||
        range == double.infinity.toString() ||
        range == double.negativeInfinity.toString()) {
      return _trueValueStr;
    } else {
      return _falseValueStr;
    }
  }

  /// Returns the sum of all the cells in a range which is statisfy the given multible criteria
  String _computeSumIFS(String argList) {
    return _calculateIFSFormula(argList, 'SUMIFS');
  }

  String _calculateIFSFormula(String argList, String condition) {
    if (argList == '') {
      return _formulaErrorStrings[_invalidArguments];
    }
    final List<String> args = _splitArgsPreservingQuotedCommas(argList);
    final int argCount = args.length;
    final List<String> criteriaRange = <String>[];
    final List<String> criterias = <String>[];
    List<String> tempList = <String>[];
    for (int i = 1; i < argCount; i++) {
      criteriaRange.add(args[i]);
      i++;
      criterias.add(args[i]);
    }
    if (argCount < 3 && criteriaRange.length == criterias.length) {
      return _formulaErrorStrings[_wrongNumberArguments];
    }
    String calculateRange = args[0];
    double sum = 0;
    double max = -1.7976931348623157E+308;
    double min = double.maxFinite;
    String val = '';
    // final List<String> _calculateRangeCells = _getCellsFromArgs(args[0]);
    List<String?> s2 = _getCellsFromArgs(calculateRange);
    for (int v = 0; v < criterias.length; v++) {
      String op = _tokenEqual;
      String criteria = criterias[v];
      if (criteria[0] != _tic[0] && !'=><'.contains(criteria[0])) {
        ////cell reference
        criteria = _getValueFromArg(criteria);
      }
      op = _findOp(criteria, op);
      criteria = _findCriteria(criteria, op);
      final List<String?> s1 = _getCellsFromArgs(criteriaRange[v]);
      if ((s1[0] != null && s1[0] == _errorStrings[5]) ||
          (s2[0] != null && s2[0] == _errorStrings[5])) {
        return _errorStrings[5];
      }
      if (s1.length != s2.length) {
        return _errorStrings[1];
      }

      final int count = s1.length;
      if (count > s2.length) {
        final int i = calculateRange.indexOf(':');
        if (i > -1) {
          int startRow = _getRowIndex(calculateRange.substring(0, i));
          int row = _getRowIndex(calculateRange.substring(i + 1));
          if (!(startRow != -1 || row == -1) == (startRow == -1 || row != -1)) {
            return _errorStrings[5];
          }
          int startCol = _getColIndex(calculateRange.substring(0, i));
          int col = _getColIndex(calculateRange.substring(i + 1));
          // Supports implenmented only for XlsIO
          if (_grid is Worksheet) {
            if (startRow == -1) {
              startRow = _grid!.getFirstRow();
            }
            if (startCol == -1) {
              startCol = _grid!.getFirstColumn();
            }
            if (row == -1) {
              row = _grid!.getLastRow();
            }
            if (col == -1) {
              col = _grid!.getLastColumn();
            }
          }
          if (startRow != row) {
            row += count - s2.length;
          } else if (startCol != col) {
            col += count - s2.length;
          }
          calculateRange = calculateRange.substring(0, i + 1) +
              _getAlphaLabel(col) +
              row.toString();
          s2 = _getCellsFromArgs(calculateRange);
        }
      }
      // SUMIFS method is modified to handle multiplle criteria's and criteria range for operation.
      String s;
      final List<String> criteriaRangeValue = <String>[];
      // int index1 = criteria.indexOf('*');
      double compare = -1.7976931348623157E+308;
      bool isNumber = false;
      if (double.tryParse(criteria) != null) {
        compare = double.tryParse(criteria)!;
        isNumber = true;
      }
      for (int index = 0; index < count; ++index) {
        s = _getValueFromArg(s1[index]);
        final bool criteriaMatched = _checkForCriteriaMatch(
            s.toUpperCase(), op, criteria.toUpperCase(), isNumber, compare);
        if (criteriaMatched) {
          //Below code has been modified to check the index of criteria.
          if (tempList.isNotEmpty && v != 0) {
            final int tempCount = tempList.length;
            for (int i = 0; i < tempCount; i++) {
              //Below code has been added to compare the old and new criteria ranges and store the values which matches.
              if (_getRowIndex(tempList[i]) == (_getRowIndex(s1[index]!))) {
                criteriaRangeValue.add(s2[index]!);
              }
            }
          } else if (s2[index] != null) {
            criteriaRangeValue.add(s2[index]!);
          }
        }
      }
      //Below code has been modified to return "Zero" if any one of the criteria fails.
      if (criteriaRangeValue.isEmpty) {
        tempList.clear();
        break;
      } else {
        tempList = criteriaRangeValue;
      }
    }
    switch (condition) {
      case 'SUMIFS':
        for (int i = 0; i < tempList.length; i++) {
          final String temp = _getValueFromArg(tempList[i]);
          //To compute sum only for double values.
          double? temp1;
          temp1 = double.tryParse(temp);
          sum = sum + temp1!;
        }
        break;
      case 'MAXIFS':
        for (int i = 0; i < tempList.length; i++) {
          final String temp = _getValueFromArg(tempList[i]);
          //To compute sum only for double values.
          double? temp1;
          temp1 = double.tryParse(temp);
          if (temp1! > max) {
            max = temp1;
          }
        }
        break;
      case 'MINIFS':
        for (int i = 0; i < tempList.length; i++) {
          final String temp = _getValueFromArg(tempList[i]);
          //To compute sum only for double values.
          double? temp1;
          temp1 = double.tryParse(temp);
          if (temp1! < min) {
            min = temp1;
          }
        }
        break;
    }
    //Returns the value
    if (condition == 'SUMIFS') {
      val = sum.toString();
    }
    if (condition == 'MAXIFS') {
      val = max.toString();
    }
    if (condition == 'MINIFS') {
      if (min == 1.7976931348623157e+308) {
        min = 0.0;
      }
      val = min.toString();
    }
    return val;
  }

  /// The MINIFS function returns the minimum value among cells specified by a given set of conditions or criteria.
  String _computeMinIFS(String argList) {
    return _calculateIFSFormula(argList, 'MINIFS');
  }

  /// The MAXIFS function returns the maximum value among cells specified by a given set of conditions or criteria.
  String _computeMaxIFS(String argList) {
    return _calculateIFSFormula(argList, 'MAXIFS');
  }

  /// The COUNTIFS function applies criteria to cells across multiple ranges and counts the number of times all criteria are met.
  String _computeCountIFS(String argList) {
    return _computeCountIFFunctions(argList, false);
  }

  /// Calculates the CountIF and CountIFS formula.
  String _computeCountIFFunctions(String argList, bool isCountif) {
    if (argList == '') {
      return _formulaErrorStrings[_invalidArguments];
    }
    final List<String> args = _splitArgsPreservingQuotedCommas(argList);
    final int argCount = args.length;
    double cellCount = 0;
    // final String cellCountValue = '';
    if (_isIndexInteriorFormula) {
      _isIndexInteriorFormula = false;
    }
    bool isLastcriteria = false;
    final List<String> criteriaRange = <String>[];
    final List<String> criterias = <String>[];
    List<String> tempList = <String>[];
    List<String> criteriaRangeValue = <String>[];
    for (int i = 0; i < argCount; i++) {
      criteriaRange.add(args[i]);
      i++;
      criterias.add(args[i]);
    }
    final List<String?> val = _getCellsFromArgs(criteriaRange[0]);
    if (argCount < 2 &&
        criteriaRange.length == criterias.length &&
        !isCountif) {
      return _formulaErrorStrings[_wrongNumberArguments];
    }
    if (criteriaRange.length != criterias.length) {
      return _errorStrings[1];
    }
    if (argCount != 2 && argCount != 3 && isCountif) {
      if (_rethrowExceptions) {
        throw Exception(_formulaErrorStrings[_wrongNumberArguments]);
      }
      return _formulaErrorStrings[_wrongNumberArguments];
    }
    for (int v = 0; v < criterias.length; v++) {
      String op = _tokenEqual;
      String criteria = criterias[v];
      if (criteria[0] != _tic[0] && !'=><'.contains(criteria[0])) {
        ////cell reference
        criteria = _getValueFromArg(criteria);
      }
      if (v == criteriaRange.length - 1 && !isCountif) {
        isLastcriteria = true;
      }
      if (isCountif) {
        isLastcriteria = true;
      }
      final int length = criteria.length;
      if (length < 1 && isCountif) {
        return '0';
      }
      //Below condition has added to find the criteria for the array structure COUNTIF formula.
      if (_isArrayFormula && isCountif) {
        op = _findOp(criterias[0].replaceAll(_bMarker, ''), op);
        criteria = _findCriteria(criterias[0].replaceAll(_bMarker, ''), op);
      } else {
        op = _findOp(criteria, op);
        criteria = _findCriteria(criteria, op);
      }
      final List<String?> s1 = _getCellsFromArgs(criteriaRange[v]);
      if (s1.length != val.length) {
        return _errorStrings[1];
      }
      if (s1[0] == _errorStrings[5]) {
        if (_rethrowExceptions) {
          throw Exception(_formulaErrorStrings[_badIndex]);
        }
        return _errorStrings[5];
      }
      final int count = s1.length;
      String s;
      double compare = -1.7976931348623157E+308;
      bool isNumber = false;
      if (double.tryParse(criteria) != null) {
        compare = double.tryParse(criteria)!;
        isNumber = true;
      }

      for (int index = 0; index < count; ++index) {
        s = _getValueFromArg(s1[index]); //// +criteria;
        //Below condition has been added to check whether the criteria is number, expression or text. For example, criteria can be expressed as 32, ">32", B4, "apples", or "32".
        final bool criteriaMatched = _checkForCriteriaMatch(
            s.toUpperCase(), op, criteria.toUpperCase(), isNumber, compare);
        //Below code has been added to count the number of occurences of values which the criteria satisfies.
        if (criteriaMatched) {
          if (isCountif && isLastcriteria ||
              isLastcriteria && criterias.length == 1) {
            cellCount++;
          } else {
            //Below code has been modified to check the index of criteria.
            if (tempList.isNotEmpty && v != 0) {
              final int tempCount = tempList.length;
              for (int i = 0; i < tempCount; i++) {
                //Below code has been added to compare the old and new criteria ranges and store the values which matches.
                if (_getRowIndex(tempList[i]) == _getRowIndex(s1[index]!)) {
                  criteriaRangeValue.add(s1[index]!);
                  if (isLastcriteria) {
                    cellCount++;
                  }
                }
              }
            } else {
              criteriaRangeValue.add(s1[index]!);
            }
          }
        }
      }
      tempList = criteriaRangeValue;
      criteriaRangeValue = <String>[];
    }
    return cellCount.toString();
  }

  /// Returns a vertical table look up value.
  String _computeVLoopUp(String args) {
    const bool cachingEnabled = false;
    final List<String> s = _splitArgsPreservingQuotedCommas(args);
    String lookUp = _getValueFromArg(s[0]);
    lookUp = lookUp.replaceAll(_tic, '').toUpperCase();
    DateTime? lookupDatetime;
    double? lookupDoubleValue;
    //Below condition has been added to return the double value while the lookup value as DateTime format.
    lookupDoubleValue = double.tryParse(lookUp.replaceAll(_tic, ''));
    final bool isDouble = lookupDoubleValue != null;
    lookupDatetime = DateTime.tryParse(lookUp);
    final bool isDateTime = lookupDatetime != null;
    if (!isDouble && isDateTime) {
      lookUp = _getSerialDateTimeFromDate(lookupDatetime).toString();
    }
    String r = s[1].replaceAll('"', '');
    if (r == '#REF!') {
      return r;
    }
    final String o1 = _getValueFromArg(s[2]).replaceAll('"', '');
    double? d = 0;
    d = double.tryParse(o1);
    final bool v = d != null;
    if (_computeIsLogical(o1) == _trueValueStr) {
      d = double.parse(_computeN(o1));
    } else if (!v || o1 == 'NaN') {
      return '#N/A';
    }
    if (d < 1) {
      return _errorStrings[1];
    }
    final int col = d.toInt();
    bool match = true, rangeLookup = true;
    if (s.length == 4) {
      match = rangeLookup = (_getValueFromArg(s[3]) == _trueValueStr) ||
          (_getValueFromArg(s[3].replaceAll(_tic, '')) == '1');
    }
    d = double.tryParse(lookUp);
    final bool typeIsNumber = d != null;
    int i = r.indexOf(':');
    ////single cell
    if (i == -1) {
      r = '$r:$r';
      i = r.indexOf(':');
    }
    final int k = r.substring(0, i).lastIndexOf(_sheetToken);
    final SheetFamilyItem? family = _getSheetFamilyItem(_grid);
    Worksheet? dependentGrid;
    if (k > -1) {
      //To avoid grid resetting at run time when the grid has dependent sheets.
      //To return proper value when grid type is ICalcData.
      if (family!._tokenToParentObject != null &&
          (family._tokenToParentObject![r.substring(0, k + 1)] != null)) {
        dependentGrid =
            family._tokenToParentObject![r.substring(0, k + 1)] as Worksheet;
      }
    }
    int row1 = _getRowIndex(r.substring(0, i));
    int row2 = _getRowIndex(r.substring(i + 1));
    int col1 = _getColIndex(r.substring(0, i));
    int col2 = _getColIndex(r.substring(i + 1));
    // Supports implenmented only for XlsIO
    //To return proper value when grid type is ICalcData.
    if (_grid != null || dependentGrid != null) {
      if ((row1 != -1 || row2 == -1) != (row1 == -1 || row2 != -1)) {
        return _errorStrings[5];
      }
      if (row1 == -1) {
        //To avoid grid resetting at run time when the grid has dependent sheets.
        //To return proper value when grid type is ICalcData.
        if (dependentGrid != null) {
          row1 = dependentGrid.getFirstRow();
        } else {
          row1 = _grid!.getFirstRow();
        }
      }
      if (col1 == -1) {
        //To avoid grid resetting at run time when the grid has dependent sheets.
        //To return proper value when grid type is ICalcData.
        if (dependentGrid != null) {
          col1 = dependentGrid.getFirstColumn();
        } else {
          col1 = _grid!.getFirstColumn();
        }
      }
      if (row2 == -1) {
        //To avoid grid resetting at run time when the grid has dependent sheets.
        //To return proper value when grid type is ICalcData.
        if (dependentGrid != null) {
          row2 = dependentGrid.getLastRow();
        } else {
          row2 = _grid!.getLastRow();
        }
      }
      if (col2 == -1) {
        //To avoid grid resetting at run time when the grid has dependent sheets.
        //To return proper value when grid type is ICalcData.
        if (dependentGrid != null) {
          col2 = dependentGrid.getLastColumn();
        } else {
          col2 = _grid!.getLastColumn();
        }
      }
    }
    bool newTable = true;
    String val = '';
    int lastRow = row1, matchCount = 0;
    String s1 = '';
    double? d1 = 0;
    bool doLastRowMark = true;
    bool exactMatch = false;
    final List<String> tableValues = <String>[];
    for (int row = row1; row <= row2; ++row) {
      if (!cachingEnabled) {
        //To avoid grid resetting at run time when the grid has dependent sheets.
        if (dependentGrid != null) {
          s1 = _getValueFromParentObjectGrid(row, col1, true, dependentGrid)
              .toUpperCase()
              .replaceAll('"', '');
        } else {
          s1 = _getValueFromParentObjectGrid(row, col1, true, _grid)
              .toUpperCase()
              .replaceAll('"', '');
        }
        DateTime? matchDateTime;
        double? doubleMatchValue;
        doubleMatchValue = double.tryParse(s1.replaceAll(_tic, ''));
        final bool isDouble = doubleMatchValue != null;
        matchDateTime = DateTime.tryParse(s1);
        final bool isDateTime = matchDateTime != null;
        if (s1 != '' && !isDouble && isDateTime) {
          s1 = _getSerialDateTimeFromDate(matchDateTime).toString();
        }
        if (!tableValues.contains(s1)) {
          tableValues.add(s1);
        }
      }
      d1 = double.tryParse(s1);
      final bool v = d1 != null;
      if (s1 == lookUp ||
          (match &&
              (typeIsNumber
                  ? (v && (d1.compareTo(d) > 0))
                  : s1.compareTo(lookUp) > 0))) {
        if (s1.toUpperCase() == lookUp) {
          if (lookUp == '' && !_matchType) {
            continue;
          } else {
            lastRow = row;
            match = true;
            exactMatch = true;
            matchCount++;
            //Below code has been added to break the condition when the match is false.This codition  break once fine the matched value.
            if (s.length == 4 && s[3] == _falseValueStr) {
              break;
            }
          }
        }
        if (!newTable) {
          break;
        } else {
          doLastRowMark = false;
        }
      }
      if (doLastRowMark) {
        lastRow = row;
      }
      if (matchCount == 0) {
        newTable = true;
      } else {
        newTable = false;
      }

      match = true;
    }

    if (match || s1 == lookUp) {
      //To avoid the calculation when the lookup value is empty.
      if (tableValues.isNotEmpty && lookUp != '') {
        if (!cachingEnabled) {
          tableValues.sort();
        }
        tableValues[0] = (tableValues[0] == '') ? '0' : tableValues[0];
      }
      //To return proper value when grid type is ICalcData.
      if ((!exactMatch &&
              ((!typeIsNumber) ||
                  (typeIsNumber &&
                      tableValues.isNotEmpty &&
                      double.parse(tableValues[0]) > double.parse(lookUp)))) ||
          (!rangeLookup && !exactMatch)) {
        return '#N/A';
      }
      //To return proper value when grid type is ICalcData.
      if (dependentGrid != null) {
        val = _getValueFromParentObjectGrid(
            lastRow, col + col1 - 1, true, dependentGrid);
      } else {
        val =
            _getValueFromParentObjectGrid(lastRow, col + col1 - 1, true, _grid);
      }
      if (val == '' &&
          !_getValueFromParentObjectGrid(lastRow, col + col1 - 1, false, _grid)
              .toUpperCase()
              .startsWith('=IF')) {
        val = '0';
      }
      if (val.isNotEmpty && val[0] == CalcEngine._formulaCharacter) {
        val = _parseFormula(val);
      }
      d = 0;
      d = double.tryParse(val);
      final bool v = d != null;
      if (val.isNotEmpty && val[0] != _tic[0] && !v) {
        val = _tic + val + _tic;
      }
    } else {
      val = '#N/A';
    }
    return val;
  }

  /// Determines whether the value is a logical value.
  String _computeIsLogical(String args) {
    args = _getValueFromArg(args).toUpperCase();

    if (args == _falseValueStr || args == _trueValueStr) {
      return _trueValueStr;
    }

    return _falseValueStr;
  }

  /// Returns a number converted from the provided value.
  String _computeN(String args) {
    String cellReference = '';
    double? val = 0.0;
    DateTime? date;
    final List<String> arg = _splitArguments(args, parseArgumentSeparator);
    final int argCount = arg.length;
    if (argCount != 1) {
      return _formulaErrorStrings[_requiresASingleArgument];
    }
    //Below condition has been modified to calculate when provided the numeric value as string.
    cellReference = _getValueFromArg(args);
    val = double.tryParse(cellReference);
    final bool v = val != null;
    date = DateTime.tryParse(cellReference);
    final bool v1 = date != null;
    if (v) {
      return val.toString();
    } else if (v1) {
      val = _getSerialDateTimeFromDate(date);
    } else if (cellReference == _trueValueStr) {
      val = 1;
    } else if (cellReference == _falseValueStr) {
      val = 0;
    } else if (_errorStrings.contains(cellReference) ||
        _formulaErrorStrings.contains(cellReference)) {
      return cellReference;
    }
    return val.toString();
  }

  String _getValueFromParentObjectGrid(int row, int col, bool calculateFormula,
      [Worksheet? grd]) {
    final SheetFamilyItem? family = _getSheetFamilyItem(grd);
    String cell1 = (family!._parentObjectToToken == null ||
            family._parentObjectToToken!.isEmpty)
        ? ''
        : family._parentObjectToToken![grd].toString();
    cell1 = cell1 + _getAlphaLabel(col) + row.toString();
    final Worksheet? saveGrid = _grid;
    final String saveCell = _cell;
    _cell = cell1;
    _grid = grd;
    String val = '';
    if (calculateFormula) {
      val = _getValueComputeFormulaIfNecessary(row, col, grd!);
    } else {
      final Object s = _grid!._getValueRowCol(row, col);
      val = s.toString();
    }
    DateTime? tempDate;
    double? doubleValue;
    doubleValue = double.tryParse(val);
    final bool isDouble = doubleValue != null;
    tempDate = DateTime.tryParse(val);
    final bool isDateTime = tempDate != null;

    if (excelLikeComputations &&
        useDatesInCalculations &&
        !isDouble &&
        isDateTime) {
      val = Range._toOADate(tempDate).toString();
    }
    _grid = saveGrid;
    _cell = saveCell;
    return val;
  }

  /// Sums the cells specified by some criteria.
  String _computeSumIf(String argList) {
    final List<String> args = _splitArgsPreservingQuotedCommas(argList);
    final int argCount = args.length;
    if (argCount != 2 && argCount != 3) {
      if (_rethrowExceptions) {
        throw Exception(_formulaErrorStrings[_wrongNumberArguments]);
      }
      return _formulaErrorStrings[_wrongNumberArguments];
    }
    final String criteriaRange = args[0];
    String criteria = args[1]; ////.Replace(TIC, string.Empty);
    if (criteria.isEmpty) {
      return '0';
    }
    String op = _tokenEqual;
    if (criteria[0] != _tic[0] && !'=><'.contains(criteria[0])) {
      ////cell reference
      criteria = _getValueFromArg(criteria);
    }
    op = _findOp(criteria, op);
    criteria = _findCriteria(criteria, op);
    String sumRange = (argCount == 2) ? criteriaRange : args[2];

    final List<String?> s1 = _getCellsFromArgs(criteriaRange);
    List<String?> s2 = _getCellsFromArgs(sumRange);
    if (s1[0] == _errorStrings[5] || s2[0] == _errorStrings[5]) {
      return _errorStrings[5];
    }
    final int count = s1.length;
    if (count > s2.length) {
      final int i = sumRange.indexOf(':');
      final int j = criteriaRange.indexOf(':');
      int criteriaStartRow = _getRowIndex(criteriaRange.substring(0, j));
      int criteriaEndRow = _getRowIndex(criteriaRange.substring(j + 1));
      int criteriaStartCol = _getColIndex(criteriaRange.substring(0, j));
      int criteriaEndCol = _getColIndex(criteriaRange.substring(j + 1));
      if ((criteriaStartRow != -1 || criteriaEndRow == -1) !=
          (criteriaStartRow == -1 || criteriaEndRow != -1)) {
        return _errorStrings[5];
      }
      //Below codtion has been added to find the row or column range when  start row or start column is -1.
      if (criteriaStartRow == -1) {
        criteriaStartRow = _grid!.getFirstRow();
      }
      if (criteriaStartCol == -1) {
        criteriaStartCol = _grid!.getFirstColumn();
      }
      if (criteriaEndRow == -1) {
        criteriaEndRow = _grid!.getLastRow();
      }
      if (criteriaEndCol == -1) {
        criteriaEndCol = _grid!.getLastColumn();
      }
      final int criteriaHeight = criteriaEndRow - criteriaStartRow;
      final int crietriaWidth = criteriaEndCol - criteriaStartCol;
      if (i > -1) {
        int startRow = _getRowIndex(sumRange.substring(0, i));
        int row = _getRowIndex(sumRange.substring(i + 1));
        if ((startRow != -1 || row == -1) != (startRow == -1 || row != -1)) {
          return _errorStrings[5];
        }
        int startCol = _getColIndex(sumRange.substring(0, i));
        int col = _getColIndex(sumRange.substring(i + 1));
        if (startRow == -1) {
          startRow = _grid!.getFirstRow();
        }
        if (startCol == -1) {
          startCol = _grid!.getFirstColumn();
        }
        if (row == -1) {
          row = _grid!.getLastRow();
        }
        if (col == -1) {
          col = _grid!.getLastColumn();
        }
        final int width = col - startCol;
        final int height = row - startRow;
        if (width != crietriaWidth) {
          col = startCol + crietriaWidth;
        }
        if (height != criteriaHeight) {
          row = startRow + criteriaHeight;
        }
        sumRange = _getAlphaLabel(startCol) +
            sumRange.substring(1, i + 1) +
            _getAlphaLabel(col) +
            row.toString();
      } else {
        int resultRow = 0, resultCol = 0;
        String resultVal = '';
        resultRow = _getRowIndex(sumRange);
        resultCol = _getColIndex(sumRange);
        resultRow += criteriaHeight;
        resultCol += crietriaWidth;
        resultVal = _getAlphaLabel(resultCol);
        sumRange = '$sumRange:$resultVal$resultRow';
      }
      s2 = _getCellsFromArgs(sumRange);
    }
    double sum = 0;
    double? d = 0.0;
    String s = '';
    double compare = -1.7976931348623157E+308;
    bool isNumber = false;
    if (double.tryParse(criteria) != null) {
      compare = double.tryParse(criteria)!;
      isNumber = true;
    }
    for (int index = 0; index < count; ++index) {
      s = _getValueFromArg(s1[index]); //// +criteria;
      //Below condition is added to return Error string when s is Error string.
      if (_errorStrings.contains(s)) {
        if (_rethrowExceptions) {
          throw Exception(_formulaErrorStrings[_invalidArguments]);
        }
        return s;
      }
      //Below code has beeb added to calculate SUMIF formula when criteria contains *.
      final bool criteriaMatched = _checkForCriteriaMatch(
          s.toUpperCase(), op, criteria.toUpperCase(), isNumber, compare);
      if (criteriaMatched) {
        s = s2[index]!;
        s = _getValueFromArg(s);
        d = double.tryParse(s);
        final bool value = d != null;
        if (value) {
          sum += d;
        }
      }
    }
    return sum.toString();
  }

  /// Below method used to find the operation value which is combined with tokens.
  String _findOp(String criteria, String op1) {
    final int offset = (criteria.isNotEmpty && criteria[0] == _tic[0]) ? 1 : 0;
    if (criteria.substring(offset).startsWith('>=')) {
      op1 = _tokenGreaterEq;
    } else if (criteria.substring(offset).startsWith('<=')) {
      op1 = _tokenLesseq;
    } else if (criteria.substring(offset).startsWith('<>')) {
      op1 = _tokenNoEqual;
    } else if (criteria.substring(offset).startsWith('<')) {
      op1 = _tokenLess;
    } else if (criteria.substring(offset).startsWith('>')) {
      op1 = _tokenGreater;
    } else if (criteria.substring(offset).startsWith('=')) {
      op1 = _tokenEqual;
    }
    return op1;
  }

  /// Returns the sum of the products of corresponding values.
  String _computeSumProduct(String range) {
    double sum = 0;
    int count = 0;
    double? d;
    bool? indexValue = false;
    List<double>? vector;
    List<String>? ranges;
    //Below code has been added to calculate the array structure values.
    if (!range.contains(parseArgumentSeparator) &&
        !range.contains(_sheetToken)) {
      range = _adjustRangeArg(range);
    }
    if (range.contains(_tic) &&
        (range.startsWith(_tic) | range.endsWith(_tic))) {
      ranges = range.split(_tic);
      for (int i = 0; i < ranges!.length; ++i) {
        if (ranges[i] == parseArgumentSeparator) {
          final List<String> list = ranges;
          list.remove(ranges[i]);
          ranges = list.toList();
        }
        // Below code has been added to calculate when the ranges contain array and cell range.("1,1,0,0,0,1,1,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1",G5:G30).
        else if (ranges[i].startsWith(parseArgumentSeparator) &&
            _isCellReference(
                ranges[i].replaceAll(parseArgumentSeparator, ''))) {
          ranges[i] = ranges[i].replaceAll(parseArgumentSeparator, '');
        }
      }
    } else {
      ranges = _splitArgsPreservingQuotedCommas(range);
    }
    for (final String r in ranges) {
      String strArray = '';
      String errorString = '';
      //Below condition has been added to calculate when the argument conatains operators(ex:=SUMPRODUCT(--($V:$V="Monday"),($W:$W>=AB10)*($W:$W< AC10))).
      if (r.contains(':') && !_isCellReference(r)) {
        final String tempr = r.replaceAll(_bMarker, '');
        String finalStringValue = '';
        for (int j = 0; j <= tempr.length - 1; j++) {
          String val = '';
          List<String?>? cells;
          String logicalVal = '';
          String logicTest = '';
          //Below condition has been added to split the cell range.
          while (j != tempr.length &&
              (_isDigit(tempr.codeUnitAt(j)) |
                  (tempr[j] == ':') |
                  (tempr[j] == '!') |
                  (j != 0 &&
                      _isUpper(tempr[j]) &&
                      !_isDigit(tempr.codeUnitAt(j - 1))) |
                  (j == 0 && _isUpper(tempr[j])))) {
            val = val + tempr[j++];
          }
          if (_exteriorFormula && tempr[j] == '{') {
            j++;
            val = tempr.substring(j, tempr.indexOf('}') - 1);
            j += tempr.indexOf('}');
            cells = val.split(';');
            _exteriorFormula = false;
          }

          if (j != tempr.length && (tempr[j] == '"')) {
            logicalVal = logicalVal + tempr[j++];
            while (j != tempr.length && (tempr[j] != '"')) {
              logicalVal = logicalVal + tempr[j++];
            }
            logicalVal = logicalVal + tempr[j++];
          }
          //Below condition has been added to split the logical value.
          //Below code has been modified to sperate the logical value when there is 'n' with TRUE and numeric values.
          while (j != tempr.length &&
              (_isUpper(tempr[j]) |
                      _isDigit(tempr.codeUnitAt(j)) |
                      (tempr[j] == 'n') ||
                  tempr[j] == parseDecimalSeparator ||
                  (_indexOfAny(tempr[j], <String>['a', 's', 'm', 'd', 'c']) >
                          -1 &&
                      _isDigit(tempr.codeUnitAt(j - 1))))) {
            logicalVal = logicalVal + tempr[j++];
          }

          //Below condition used to add the token in logicalvalue.If the token is find break the condition/
          for (final String tempChar in _tokens) {
            if (j != tempr.length && tempr[j] == tempChar) {
              logicalVal = logicalVal + tempr[j];
              break;
            }
          }
          cells ??= _getCellsFromArgs(val);
          int s = 0;
          if ((val == '') && (strArray != '')) {
            final List<String> args =
                _splitArgsPreservingQuotedCommas(strArray);
            final List<String> tempLogicList =
                args[0].replaceAll(_tic, '').split(';');
            final List<String> tempLogicList1 =
                args[1].replaceAll(_tic, '').split(';');
            {
              for (s = 0; s <= tempLogicList.length - 1; s++) {
                if (s + 1 != args.length) {
                  logicTest = _getValueFromArg(_bMarker +
                      tempLogicList[s] +
                      tempLogicList1[s] +
                      logicalVal +
                      _bMarker);
                }
                finalStringValue += '$logicTest;';
              }
            }
            //Below logic has been added to remove the previous value of straArray and to update it with newly calculated value.
            strArray = '';
          } else {
            for (s = 0; s <= cells.length - 1; s++) {
              logicTest = _getValueFromArg(
                  _bMarker + cells[s]! + logicalVal + _bMarker);
              finalStringValue += '$logicTest;';
            }
          }
          if (j == tempr.length - 1) {
            strArray =
                finalStringValue.substring(0, finalStringValue.length - 1);
          } else {
            finalStringValue =
                finalStringValue.substring(0, finalStringValue.length - 1);
            strArray += _tic + finalStringValue + _tic + parseArgumentSeparator;
          }
          finalStringValue = '';
        }
        // perform multiplication
        List<dynamic> result;
        result = _performMultiplication(
            strArray, indexValue, count, vector, errorString);
        indexValue = result[0] as bool;
        count = result[1] as int;
        vector = result[2] as List<double>?;
        errorString = result[3] as String;

        if (errorString != '') {
          return errorString;
        }
      } else if (!r.startsWith(_tic) && r.contains(':')) {
        int i = r.indexOf(':');
        int row1 = _getRowIndex(r.substring(0, i));
        int row2 = _getRowIndex(r.substring(i + 1));
        if ((row1 != -1 || row2 == -1) != (row1 == -1 || row2 != -1)) {
          return _errorStrings[5];
        }
        int col1 = _getColIndex(r.substring(0, i));
        int col2 = _getColIndex(r.substring(i + 1));
        if (_grid is Worksheet) {
          if (row1 == -1 && _grid is Worksheet) {
            row1 = _grid!.getFirstRow();
          }
          if (col1 == -1 && _grid is Worksheet) {
            col1 = _grid!.getFirstColumn();
          }
          if (row2 == -1 && _grid is Worksheet) {
            row2 = _grid!.getLastRow();
          }
          if (col2 == -1 && _grid is Worksheet) {
            col2 = _grid!.getLastColumn();
          }
        }
        if (vector != null && count != (row2 - row1 + 1) * (col2 - col1 + 1)) {
          if (_rethrowExceptions) {
            throw Exception(_formulaErrorStrings[_badFormula]);
          }
          errorString = _errorStrings[1];
        } else if (vector == null) {
          count = (row2 - row1 + 1) * (col2 - col1 + 1);
          vector = List<double>.filled(count, 0);
          for (i = 0; i < count; ++i) {
            vector[i] = 1;
          }
        }
        final SheetFamilyItem? family = _getSheetFamilyItem(_grid);
        final String s = _getSheetToken(r);
        final Worksheet grd = (s == '')
            ? _grid!
            : (family!._tokenToParentObject![s] as Worksheet);

        i = 0;
        for (int row = row1; row <= row2; ++row) {
          for (int col = col1; col <= col2; ++col) {
            d = double.tryParse(
                _getValueFromParentObjectGrid(row, col, true, grd)
                    .replaceAll(_tic, ''));
            final String v = _getValueFromParentObjectGrid(row, col, true, grd)
                .replaceAll(_tic, '');
            if (v == 'true' || v == 'false') {
              indexValue = v.contains('true');
            } else {
              indexValue = null;
            }

            if (d != null) {
              vector[i] = vector[i] * d;
            }
            //Below code is added to calculate the bool values eg(SUMPRODUCT({FALSE,TRUE,FALSE},{FALSE,FALSE,FALSE})).
            else if (indexValue != null) {
              final String val = indexValue.toString();
              double v = 0;
              if (val == 'true') {
                v = 1;
              }
              vector[i] = vector[i] * v;
            } else {
              vector[i] = 0;
            }

            i++;
          }
        }
      }
      //Below condition has been added to calculate eg =SUMPRODUCT({0,0,1,0,1},{75,100,125,125,150}).
      //Below condition has been modified to accept the range of values with Spain Culture.
      else if (r.contains(parseArgumentSeparator) ||
          r.contains(';') ||
          r.contains('{')) {
        String tempr = r.replaceAll(_bMarker, '');
        if (_exteriorFormula) {
          tempr = tempr.replaceAll('{', '').replaceAll('}', '');
          _exteriorFormula = false;
        }
        // perform multiplication
        List<dynamic> result;
        result = _performMultiplication(
            tempr, indexValue, count, vector, errorString);
        indexValue = result[0] as bool;
        count = result[1] as int;
        vector = result[2] as List<double>?;
        errorString = result[3] as String;

        if (errorString != '') {
          return errorString;
        }
      } else {
        final String s1 = _getValueFromArg(r);
        if (_errorStrings.contains(s1)) {
          return s1;
        } else {
          if (_rethrowExceptions) {
            throw Exception(_formulaErrorStrings[_badFormula]);
          }
          errorString = _errorStrings[1];
        }
      }
    }

    for (int i = 0; i < count; ++i) {
      sum += vector![i];
    }

    return sum.toString();
  }

  List<dynamic> _performMultiplication(String strArray, bool? indexValue,
      int count, List<double>? vector, String errorString) {
    // perform multiplication
    List<String> tempRangs;
    List<String> temArray;
    int j = 0;
    double? d = 0;
    if (strArray.contains(';')) {
      tempRangs = strArray.split(';');
      final int listLength = tempRangs.length *
          _splitArgsPreservingQuotedCommas(tempRangs[0]).length;
      temArray = List<String>.filled(listLength, '');
    }
    //Below condition has been added to calculate the Sumproduct Value when parseArgument seperator is not comma(',') with Spain Culture.
    else if (strArray.contains(',')) {
      tempRangs = strArray.split(',');
      temArray = List<String>.filled(
          tempRangs.length *
              _splitArgsPreservingQuotedCommas(tempRangs[0]).length,
          '');
    } else {
      tempRangs = _splitArgsPreservingQuotedCommas(strArray);
      temArray = List<String>.filled(tempRangs.length, '');
    }

    for (int i = 0; i < tempRangs.length; ++i) {
      int e = 0;
      if (tempRangs[i].contains(',')) {
        final List<String> arrayIndex = tempRangs[i].split(',');
        while (e != arrayIndex.length) {
          temArray[j] = arrayIndex[e];
          j++;
          e++;
        }
      } else {
        temArray[i] = tempRangs[i];
      }
    }
    tempRangs = temArray;
    if (vector != null && count != tempRangs.length) {
      if (_rethrowExceptions) {
        throw Exception(_formulaErrorStrings[_badFormula]);
      }
      errorString = _errorStrings[1];
    } else if (vector == null) {
      count = tempRangs.length;
      vector = List<double>.filled(count, 0);
      for (int k = 0; k < count; ++k) {
        vector[k] = 1;
      }
    }
    for (int rr = 0; rr < tempRangs.length; ++rr) {
      d = double.tryParse(tempRangs[rr]);
      final String boolValue = tempRangs[rr].toLowerCase();
      if (d != null) {
        vector[rr] = vector[rr] * d;
      }
      //Below code is added to calculate the bool values eg(SUMPRODUCT({FALSE,TRUE,FALSE},{FALSE,FALSE,FALSE})).
      else if (boolValue == 'true' || boolValue == 'false') {
        double value = 0;
        if (boolValue == 'true') {
          value = 1;
        }
        vector[rr] = vector[rr] * value;
      } else {
        vector[rr] = 0;
      }
    }
    return <dynamic>[indexValue, count, vector, errorString];
  }

  /// Returns the product of the arguments in the list.
  String _computeProduct(String range) {
    double prod = 1;
    double? d;
    String s1;
    bool nohits = true;
    range = _adjustRangeArg(range);
    //Below condition has been modified to calculate when provided the numeric value as string.
    final List<String> ranges =
        _splitArgsPreservingQuotedCommas(range.replaceAll(_tic, ''));
    for (final String r in ranges) {
      ////is a cellrange
      if (r.contains(':')) {
        for (final String? s in _getCellsFromArgs(r)) {
          try {
            s1 = _getValueFromArg(s);
            s1 = _getValueForBool(s1);
          } catch (ex) {
            _exceptionThrown = true;
            //Below code has been added to throw the excpetion when we enabel the RethrowLibraryComputationExceptions property.
            if (_rethrowExceptions) {
              rethrow;
            }
            return ex.toString();
          }

          if (s1.isNotEmpty) {
            //Below condition has been modified to calculate when provided the numeric value as string.
            d = double.tryParse(s1.replaceAll(_tic, ''));
            if (d != null) {
              prod = prod * d;
              nohits = false;
            } else if (_errorStrings.contains(s1)) {
              return s1;
            }
          }
        }
      } else {
        try {
          s1 = _getValueFromArg(r);
          s1 = _getValueForBool(s1);
        } catch (ex) {
          _exceptionThrown = true;
          //Below code has been added to throw the excpetion when we enabel the RethrowLibraryComputationExceptions property.
          if (_rethrowExceptions) {
            rethrow;
          }
          return ex.toString();
        }
        if (s1.isNotEmpty) {
          //Below condition has been modified to calculate when provided the numeric value as string.
          d = double.tryParse(s1.replaceAll(_tic, ''));
          if (d != null) {
            prod = prod * d;
            nohits = false;
          } else if (_errorStrings.contains(s1)) {
            return s1;
          }
        }
      }
    }
    return nohits ? '0' : prod.toString();
  }

  String _getValueForBool(String arg) {
    if (arg == _trueValueStr || arg == 'n$_trueValueStr') {
      return '1';
    } else if (arg == _falseValueStr || arg == 'n$_falseValueStr') {
      return '0';
    }
    return arg;
  }
}
