part of xlsio;

/// CalcEngine encapsulates the code required to parse and compute formulas.
class CalcEngine {
  /// Create a new instance for CalcEngine.
  CalcEngine(Worksheet parentObject) {
    _grid = parentObject;
    _initLibraryFunctions();

    _tokens = [
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

    _dateTime1900Double = Range.toOADate(_dateTime1900);
  }
  static SheetFamilyItem _defaultFamilyItem;
  static Map _modelToSheetID;
  static Map _sheetFamiliesList;
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
  final _currentRowNotationEnabled = true;
  static int _tokenCount = 0;
  Worksheet _grid;
  List<String> _sortedSheetNames;
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

  final _braceLeft = '{';
  final _braceRight = '}';
  final _stringAnd = '&'; ////'AND';
  final _trueValueStr = 'TRUE';
  final _falseValueStr = 'FALSE';
  final _stringOr = '^'; ////'OR';
  final _charTIC = "'";
  final _tic = '\'';
  static String _formulaChar = '=';
  final _uniqueStringMarker = String.fromCharCode(127);
  final _markerChar = '`';
  final _ifMarker = 'qIF' + String.fromCharCode(130);

  static const String _stringFixedReference = '\$';
  static const String _stringGreaterEq = '>=';
  static const String _stringLessEq = '<=';
  static const String _stringNoEqual = '<>';

  final _rightBracket = String.fromCharCode(131);
  final _leftBracket = String.fromCharCode(130);
  static final _bMarker = String.fromCharCode(146);
  final _bMarker2 = _bMarker.toString() + _bMarker.toString();

  final _charAnd = 'i';
  final _charOr = 'w';
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

  final _charEP = 'x';
  final _charEM = 'r';

  static const String _tokenEM = 'v';
  static const String _tokenEP = 't';

  final _operatorsCannotStartAnExpression = 0;
  final _cannotParse = 1;
  final _badLibrary = 2;
  final _numberContains2DecimalPoints = 4;
  final _expressionCannotEndWithAnOperator = 5;
  final _invalidCharactersFollowingAnOperator = 6;
  final _mismatchedParentheses = 8;
  final _requires3Args = 11;
  final _badIndex = 14;
  final _tooComplex = 15;
  final _missingFormula = 17;
  final _improperFormula = 18;
  final _cellEmpty = 20;
  final _emptyExpression = 22;
  final _mismatchedTics = 24;
  final _wrongNumberArguments = 25;
  final _invalidArguments = 26;
  final _missingSheet = 30;

  bool _inAPull = false;
  final _checkDanglingStack = false;
  bool _isRangeOperand = false;
  bool _multiTick = false;
  double _dateTime1900Double;
  final _dateTime1900 = DateTime(1900, 1, 1, 0, 0, 0);

  /// This field holds equivalent double value of 1904(DateTime).
  static const double _oADate1904 = 1462.0;

  /// Set the boolean as true
  static final _treat1900AsLeapYear = true;
  List<String> _tokens;

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
  Map _libraryFunctions;
  final String _validFunctionNameChars = '_';
  final bool _getValueFromArgPreserveLeadingZeros = false;
  bool _ignoreCellValue = false;
  bool _findNamedRange = false;
  bool _isIndexInteriorFormula = false;
  bool _isErrorString = false;

  /// This field will be set as true, if the 1904 date system is enabled in Excel.
  final bool _useDate1904 = false;
  final List<dynamic> _errorStrings = [
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
  List<String> formulaErrorStrings = [
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
    if (_formulaChar == '\0') {
      _formulaChar = '=';
    }
    return _formulaChar;
  }

  List<String> get _sortedSheetNamesList {
    final SheetFamilyItem family = _getSheetFamilyItem(_grid);

    if (_sortedSheetNames == null) {
      if (family != null && family._sheetNameToToken != null) {
        final List<dynamic> names = family._sheetNameToToken.keys.toList();
        _sortedSheetNames = names.map((s) => s as String).toList();
        _sortedSheetNames.sort();
      }
    }
    return _sortedSheetNames;
  }

  ////Used to determine if this CalcEngine instance is a member of
  ////several sheets. If so, then dependent cells are tracked through a static member
  ////so that they are known across instances.
  bool get _isSheeted {
    final SheetFamilyItem family = _getSheetFamilyItem(_grid);
    return (family == null) ? false : family._isSheeted;
  }

  /// A read-only property that gets a mapping between a formula cell and a list of cells upon which it depends.
  Map get _dependentFormulaCells {
    if (_isSheeted) {
      final SheetFamilyItem family = _getSheetFamilyItem(_grid);
      family._sheetDependentFormulaCells ??= <dynamic, dynamic>{};

      return family._sheetDependentFormulaCells;
    }
    return <dynamic, dynamic>{};
  }

  /// A read-only property that gets the collection of FormulaInfo Objects being used by the CalcEngine.
  Map get _formulaInfoTable {
    if (_isSheeted) {
      final SheetFamilyItem family = _getSheetFamilyItem(_grid);
      family._sheetFormulaInfoTable ??= <dynamic, dynamic>{};

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
  void registerGridAsSheet(String refName, Worksheet model, int sheetFamilyID) {
    refName = refName.replaceAll("'", "''");

    _modelToSheetID ??= <dynamic, dynamic>{};

    if (_modelToSheetID[model] == null) {
      _modelToSheetID[model] = sheetFamilyID;
    }
    final SheetFamilyItem family = _getSheetFamilyItem(model);

    family._isSheeted = true;

    final String refName1 = refName.toUpperCase();

    family._sheetNameToParentObject ??= <dynamic, dynamic>{};

    family._tokenToParentObject ??= <dynamic, dynamic>{};

    family._sheetNameToToken ??= <dynamic, dynamic>{};

    family._parentObjectToToken ??= <dynamic, dynamic>{};

    if (family._sheetNameToParentObject.containsKey(refName1)) {
      final String token = family._sheetNameToToken[refName1] as String;

      family._tokenToParentObject[token] = model;
      family._parentObjectToToken[model] = token;
    } else {
      final String token = _sheetToken + _tokenCount.toString() + _sheetToken;
      _tokenCount++;

      family._tokenToParentObject[token] = model;
      family._sheetNameToToken[refName1] = token;
      family._sheetNameToParentObject[refName1] = model;
      family._parentObjectToToken[model] = token;
      _sortedSheetNames = null;
    }
  }

  static SheetFamilyItem _getSheetFamilyItem(Worksheet model) {
    if (model == null) return null;

    if (_sheetFamilyID == 0) {
      _defaultFamilyItem ??= SheetFamilyItem();

      return _defaultFamilyItem;
    }

    _sheetFamiliesList ??= <dynamic, dynamic>{};

    final int i =
        _modelToSheetID[model] != null ? _modelToSheetID[model] as int : 0;

    if (_sheetFamiliesList[i] == null) {
      _sheetFamiliesList[i] = SheetFamilyItem();
    }

    return _sheetFamiliesList[i] as SheetFamilyItem;
  }

  /// A method that adds a function to the function library.
  bool _addFunction(String name, String func) {
    name = name.toUpperCase();
    if (!_libraryFunctions.containsKey(name)) {
      _libraryFunctions[name] = func;
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
  String pullUpdatedValue(String cellRef) {
    bool isUseFormulaValueChanged = false;
    _inAPull = true;
    _multiTick = false;
    final Worksheet grd = _grid;
    final String saveCell = _cell;
    final String s = cellRef.toUpperCase();

    _updateCalcID();
    String txt;
    if (!_dependentFormulaCells.containsKey(s) &&
        !_formulaInfoTable.containsKey(s)) {
      txt = getValueFromParentObject(s, true);

      if (_useFormulaValues) {
        isUseFormulaValueChanged = true;
        _useFormulaValues = false;
      }

      _useFormulaValues = isUseFormulaValueChanged;
      final bool saveIVC = _ignoreValueChanged;
      _ignoreValueChanged = true;
      final int row = _getRowIndex(s);
      final int col = _getColIndex(s);
      _grid.setValueRowCol(txt, row, col);
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

      int result;
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
    throw Exception(formulaErrorStrings[_badIndex]);
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

  bool _isDigit(int char) {
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

      if (i < s.length) s1 = s.substring(0, i + 1);
    }

    if (i < s.length) {
      return s1;
    }

    throw Exception(formulaErrorStrings[_improperFormula]);
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
    if (textIsEmpty(formula)) {
      return formula;
    }
    try {
      _computedValueLevel++;

      if (_computedValueLevel > _maximumRecursiveCalls) {
        _computedValueLevel = 0;
        throw Exception(formulaErrorStrings[_tooComplex]);
      }

      final Stack _stack = Stack();

      int i = 0;
      _stack._clear();
      String sheet = '';
      // String book = '';

      i = 0;
      while (i < formula.length) {
        if (formula[i] == _bMarker) {
          i = i + 1;
          continue;
        }

        if (formula[i] == _sheetToken) {
          sheet = formula[i].toString();
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
          _stack._push(_trueValueStr);
          i += _trueValueStr.length;
        } else if (formula.substring(i).startsWith(_falseValueStr)) {
          _stack._push(_falseValueStr);
          i += _falseValueStr.length;
        } else if (formula[i] == _tic[0] || formula[i] == '|') {
          String s = formula[i].toString();
          i++;

          while (i < formula.length && formula[i] != _tic[0]) {
            s = s + formula[i];
            i = i + 1;
          }
          if (_multiTick) {
            s = s.replaceAll('|', _tic);
          }
          _stack._push(s + _tic);
          i += 1;
        } else if (_isUpper(formula[i])) {
          ////cell loc
          final List result = _processUpperCase(formula, i, sheet);
          formula = result[1];
          i = result[2];
          sheet = result[3];
          final String s = result[0];
          //Below condition is added to return Error String when s is Error String.
          if (_errorStrings.contains(s)) return s;
          _stack._push(getValueFromParentObject(s, true));
        } else if (formula[i] == 'q') {
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
              return formulaErrorStrings[_badIndex];
            }
            if (_libraryFunctions[name] != null) {
              final int j =
                  formula.substring(i + ii + 1).indexOf(_rightBracket);
              String args = formula.substring(i + ii + 2, i + ii + 2 + j - 1);

              try {
                final String function = _libraryFunctions[name];

                final List<String> argArray =
                    _splitArgsPreservingQuotedCommas(args);
                final StringBuffer sb = StringBuffer();
                final bool isFormulaUpdated = false;
                for (int index = 0; index < argArray.length; index++) {
                  final String range = argArray[index];
                  _findNamedRange = false;
                  if (index == argArray.length - 1) {
                    sb.write(range);
                  } else {
                    sb.write(range + parseArgumentSeparator);
                  }
                }
                if (isFormulaUpdated || _findNamedRange) args = sb.toString();
                _findNamedRange = false;
                final String result = _func(function, args);
                _stack._push(result);
              } catch (e) {
                _exceptionThrown = true;
                if (_errorStrings.contains(e.toString())) {
                  return e.toString();
                } else if (_exceptionThrown) {
                  return _errorStrings[1].toString();
                }
              }
              i += j + ii + 2;
            } else {
              return formulaErrorStrings[_missingFormula];
            }
          } else if (formula[0] == _bMarker) {
            ////Restart the processing with the formula without library finctions.
            i = 0;
            _stack._clear();
            continue;
          } else {
            return formulaErrorStrings[_improperFormula];
          }
        } else if (_isDigit(formula.codeUnitAt(i)) || formula[i] == 'u') {
          String s = '';

          if (i < formula.length && formula[i] == formula[i].toUpperCase()) {
            final List result = _processUpperCase(formula, i, sheet);
            formula = result[1];
            i = result[2];
            sheet = result[3];

            s = s + getValueFromParentObject(result[0], true);
          } else {
            while (i < formula.length &&
                (_isDigit(formula.codeUnitAt(i)) ||
                    formula[i] == parseDecimalSeparator ||
                    formula[i] == (':'))) {
              s = s + formula[i];
              i = i + 1;
            }
          }

          _stack._push(s);
        } else if (formula[i] == parseDateTimeSeparator) {
          String s = '';
          while (i < formula.length && formula[i] == parseDateTimeSeparator) {
            s = s + formula[i];
            i = i + 1;
          }
          while (_stack.count > 0) {
            s = _stack._pop().toString() + s;
          }
          _stack._push(s);
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
                  _stack._push(formula.substring(i, i + errIndex - i));
                } else {
                  errIndex = i + 1;
                  _stack._push(formula.substring(i, i + errIndex - i));
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
                  s = _errorStrings[1].toString();
                } else {
                  while (i < formula.length &&
                      (_isDigit(formula.codeUnitAt(i)) ||
                          formula[i] == parseDecimalSeparator)) {
                    s = s + formula[i];
                    i = i + 1;
                  }
                }
                _stack._push(s);
              }

              break;
            case _tokenAdd:
              {
                final double d = _pop(_stack);
                final double d1 = _pop(_stack);
                if (d == (double.nan) || d1 == (double.nan)) {
                  _stack._push('#VALUE!');
                } else {
                  _stack._push((d1 + d).toString());
                }
                i = i + 1;
              }

              break;
            case _tokenSubtract:
              {
                final double d = _pop(_stack);
                final double d1 = _pop(_stack);
                if (d == (double.nan) || d1 == (double.nan)) {
                  _stack._push('#VALUE!');
                } else {
                  _stack._push((d1 - d).toString());
                }
                i = i + 1;
              }

              break;
            case _tokenMultiply:
              {
                final double d = _pop(_stack);
                final double d1 = _pop(_stack);
                if (d == (double.nan) || d1 == (double.nan)) {
                  _stack._push('#VALUE!');
                } else {
                  _stack._push((d1 * d).toString());
                }
                i = i + 1;
              }

              break;
            case _tokenDivide:
              {
                final double d = _pop(_stack);
                final double d1 = _pop(_stack);
                if (d == double.nan || d1 == double.nan) {
                  _stack._push('#VALUE!');
                } else if (d == 0) {
                  _stack._push(_errorStrings[3].toString());
                } else {
                  _stack._push((d1 / d).toString());
                }
                i = i + 1;
              }

              break;
            case _tokenLess:
              {
                final String s1 = _popString(_stack);
                final String s2 = _popString(_stack);

                double d, d1;
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
                    if ((s1.startsWith(_tic) && s2.indexOf(_tic) == -1)) {
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

                _stack._push(val);
                i = i + 1;
              }

              break;
            case _tokenGreater:
              {
                final String s1 = _popString(_stack);
                final String s2 = _popString(_stack);

                double d, d1;
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
                    if ((s1.startsWith(_tic) && s2.indexOf(_tic) == -1)) {
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

                _stack._push(val);
                i = i + 1;
              }

              break;
            case _tokenEqual:
              {
                final String s1 = _popString(_stack);
                final String s2 = _popString(_stack);

                String val = '';
                double d, d1;
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

                _stack._push(val);
                i = i + 1;
              }

              break;
            case _tokenLesseq:
              {
                final String s1 = _popString(_stack);
                final String s2 = _popString(_stack);

                double d, d1;
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
                    if ((s1.startsWith(_tic) && s2.indexOf(_tic) == -1)) {
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
                _stack._push(val);
                i = i + 1;
              }

              break;
            case _tokenGreaterEq:
              {
                final String s1 = _popString(_stack);
                final String s2 = _popString(_stack);

                double d, d1;
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
                    if ((s1.startsWith(_tic) && s2.indexOf(_tic) == -1)) {
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

                _stack._push(val);
                i = i + 1;
              }

              break;
            case _tokenNoEqual:
              {
                final String s1 = _popString(_stack);
                final String s2 = _popString(_stack);

                double d, d1;
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

                _stack._push(val);
                i = i + 1;
              }

              break;
            case _tokenAnd: ////and Strings....
              {
                String s1 = _popString(_stack);
                if (s1.isNotEmpty && s1[0] == _tic[0]) {
                  if (s1.length > 1 && s1[s1.length - 1] == _tic[0]) {
                    s1 = s1.substring(1, 1 + s1.length - 2);
                  }
                }
                String s2 = '';
                if (_stack.count > 0) s2 = _popString(_stack);
                if (s2.isNotEmpty && s2[0] == _tic[0]) {
                  if (s2.length > 1 && s2[s2.length - 1] == _tic[0]) {
                    s2 = s2.substring(1, 1 + s2.length - 2);
                  }
                }
                if (s1 == '' && s2 == '') isEmptyString = true;
                if (s1.isNotEmpty &&
                    s1[0] == '#' &&
                    // ignore: prefer_contains
                    _errorStrings.indexOf(s1) > -1) {
                  _stack._push(s1);
                } else if (s2.isNotEmpty &&
                    s2[0] == '#' &&
                    // ignore: prefer_contains
                    _errorStrings.indexOf(s2) > -1) {
                  _stack._push(s2);
                } else {
                  _stack._push(_tic + s2 + s1 + _tic);
                }

                i = i + 1;
              }

              break;
            case _tokenOr: // exponential
              {
                final double d = _pop(_stack);
                int x = int.tryParse(d.toString());
                if (x != null && _isErrorString) {
                  _isErrorString = false;
                  return _errorStrings[x].toString();
                }
                final double d1 = _pop(_stack);
                x = int.tryParse(d.toString());
                if (x != null && _isErrorString) {
                  _isErrorString = false;
                  return _errorStrings[x].toString();
                }
                _stack._push(math.pow(d1, d).toString());
                i = i + 1;
              }

              break;
            default:
              {
                _computedValueLevel = 0;
                return _errorStrings[1].toString();
              }
          }
        }
      }

      if (_stack.count == 0) {
        return '';
      } else {
        String s = '';
        double d;
        int cc = _stack.count;
        do {
          {
            //Checks if the stack element is a error String. If yes, then stops popping other stack element and returns the error String.
            final String p = _stack._pop().toString();
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
              !isEmptyString) s = '0';
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
      if (e.toString().indexOf(formulaErrorStrings[_cellEmpty]) > -1) {
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
        break;
      case '_computeAvg':
        return _computeAvg(args);
        break;
      case '_computeMax':
        return _computeMax(args);
        break;
      case '_computeMin':
        return _computeMin(args);
        break;
      case '_computeCount':
        return _computeCount(args);
        break;
      case '_computeIf':
        return _computeIf(args);
        break;
      default:
        return args;
        break;
    }
  }

  /// Returns the sum of all values listed in the argument.
  String _computeSum(String range) {
    double sum = 0;
    String s1;
    double d;
    String adjustRange;
    final List<String> ranges = _splitArgsPreservingQuotedCommas(range);
    if (range == null || range == '') {
      return formulaErrorStrings[_wrongNumberArguments];
    }
    for (final r in ranges) {
      adjustRange = r;
      ////is a cellrange
      // ignore: prefer_contains
      if (adjustRange.indexOf(':') > -1 && _isRange(adjustRange)) {
        if (r.startsWith(_tic)) {
          return _errorStrings[1].toString();
        }
        final List<String> cells = _getCellsFromArgs(adjustRange);
        for (final s in cells) {
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
              sum = sum + d;
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
          final double d1 = double.tryParse(s1.replaceAll(_tic, ''));
          if ((_isCellReference(adjustRange) && d != null && !d.isNaN) ||
              (!_isCellReference(adjustRange) && d1 != null && !d1.isNaN)) {
            sum = sum + d;
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
    double d;
    String s1;
    final List<String> ranges = _splitArgsPreservingQuotedCommas(range);
    if (ranges.isEmpty || range == null || range == '') {
      return formulaErrorStrings[_invalidArguments];
    }
    for (final r in ranges) {
      // ignore: prefer_contains
      if (r.indexOf(':') > -1 && _isRange(r)) {
        for (final s in _getCellsFromArgs(r)) {
          try {
            s1 = _getValueFromArg(s);
            if (_errorStrings.contains(s1)) {
              return s1;
            }
          } catch (e) {
            _exceptionThrown = true;
            return _errorStrings[4].toString();
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
          return _errorStrings[4].toString();
        }

        if (s1.isNotEmpty) {
          d = double.tryParse(s1.replaceAll(_tic, ''));
          if (d != null) {
            sum = sum + d;
            count++;
          } else {
            if (s1.startsWith(_tic)) {
              return _errorStrings[1].toString();
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
    double max = -double.maxFinite;
    double d;
    String s1;
    final List<String> ranges = _splitArgsPreservingQuotedCommas(range);
    if (ranges.length == 1 &&
        !range.startsWith(_tic) &&
        (range == null || range == '')) {
      return formulaErrorStrings[_wrongNumberArguments];
    }

    for (final r in ranges) {
      ////cell range
      // ignore: prefer_contains
      if (r.indexOf(':') > -1 && _isRange(r)) {
        if (r.startsWith(_tic)) {
          return _errorStrings[1].toString();
        }
        for (final s in _getCellsFromArgs(r)) {
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
              max = math.max(max, d);
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
            max = math.max(max, d);
          } else {
            if (s1.startsWith(_tic)) {
              return _errorStrings[1].toString();
            }
          }
        }
      }
    }
    if (max != -double.maxFinite) {
      return max.toString();
    }

    return '0';
  }

  /// Returns the minimum value of all values listed in the argument.
  String _computeMin(String range) {
    double min = double.maxFinite;
    double d;
    String s1;
    final List<String> ranges = _splitArgsPreservingQuotedCommas(range);
    if (range == null || range == '') {
      return formulaErrorStrings[_wrongNumberArguments];
    }

    for (final r in ranges) {
      ////cell range
      // ignore: prefer_contains
      if (r.indexOf(':') > -1 && _isRange(r)) {
        if (r.startsWith(_tic)) {
          return _errorStrings[1].ToString();
        }
        for (final s in _getCellsFromArgs(r)) {
          try {
            s1 = _getValueFromArg(s);
            final DateTime result = DateTime.tryParse(s1.replaceAll(_tic, ''));
            d = double.tryParse(s1);
            if (s1 != null && result != null && d == null) {
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
              min = math.min(min, d);
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
            min = math.min(min, d);
          } else {
            if (s1.startsWith(_tic)) {
              return _errorStrings[1].ToString();
            }
          }
        }
      }
    }
    if (min != double.maxFinite) {
      return min.toString();
    }

    return '0';
  }

  /// Returns the count of all values (including text) listed in the argument to evaluate to a number.
  String _computeCount(String range) {
    int count = 0;
    String s1 = '';
    double d;
    DateTime dt;
    List<String> array;
    if (_isIndexInteriorFormula) _isIndexInteriorFormula = false;
    final List<String> ranges = _splitArgsPreservingQuotedCommas(range);
    for (final String r in ranges) {
      ////is a cellrange
      if (r.contains(':') && _isRange(r)) {
        for (final String s in _getCellsFromArgs(r.replaceAll(_tic, ''))) {
          try {
            s1 = _getValueFromArg(s);
          } catch (e) {
            _exceptionThrown = true;
            return _errorStrings[4].toString();
          }

          if (s1.isNotEmpty) {
            if (s1 == (formulaErrorStrings[19])) {
              return formulaErrorStrings[19];
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
          if (r == ('') && !(r.startsWith(_tic))) count++;
          if (r.contains(parseArgumentSeparator.toString())) {
            array = _splitArgsPreservingQuotedCommas(r);
            for (final str in array) {
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
          return _errorStrings[4].toString();
        }

        if (s1.isNotEmpty) {
          if (s1 == (formulaErrorStrings[19])) {
            return formulaErrorStrings[19];
          }
          d = double.tryParse(s1.replaceAll(_tic, ''));
          dt = DateTime.tryParse(s1.replaceAll(_tic, ''));
          if (d != null ||
              dt != null ||
              s1 == (_trueValueStr) ||
              s1 == (_falseValueStr)) {
            count++;
          }
        }
      }
    }
    return count.toString();
  }

  /// Conditionally computes one of two alternatives depending upon a logical expression.
  String _computeIf(String args) {
    if (args == null || args == '') {
      return formulaErrorStrings[_wrongNumberArguments];
    }
    String s1 = '';
    ////parsed formula
    if (args.isNotEmpty &&
        _indexOfAny(args, [parseArgumentSeparator, ':']) == -1) {
      return formulaErrorStrings[_requires3Args];
    } else {
      final List<String> s = _splitArgsPreservingQuotedCommas(args);
      if (s.length <= 3) {
        try {
          double d1 = 0;
          final String argument1 =
              (s[0] == null || s[0] == '') ? '0' : _getValueFromArg(s[0]);
          d1 = double.tryParse(argument1);
          if (d1 != null) {
            if (_errorStrings.contains(argument1)) {
              return argument1;
            }
            final bool flag = (argument1.replaceAll(_tic, '') == 'true' ||
                argument1.replaceAll(_tic, '') == 'false');
            if ((!_isCellReference(s[0]) &&
                    !flag &&
                    argument1.startsWith(_tic)) ||
                (_isCellReference(s[0]) && argument1.startsWith(_tic))) {
              return _errorStrings[1].toString();
            }
          }

          s1 = _getValueFromArg(s[0]);
          double d = 0;
          d = double.tryParse(s1);
          if (s1.replaceAll(_tic, '').toUpperCase() == (_trueValueStr) ||
              (d != null && d != 0)) {
            //Below code has been added to return the cell range when the if formula is interior formula
            if (_computedValueLevel > 1 &&
                _isRange(s[1]) &&
                !s[1].contains(_tic)) {
              s1 = s[1];
            } else if ((s[1] == null || s[1] == '') && _treatStringsAsZero) {
              s1 = '0';
            } else {
              s1 = _getValueFromArg(s[1]);
            }
            if ((s1 == null || s1 == '') &&
                _treatStringsAsZero &&
                _computedValueLevel > 1) {
              s1 = '0';
            } else if (!(s1 == null || s1 == '') &&
                s1[0] == _tic[0] &&
                !_isCellReference(s[1]) &&
                useNoAmpersandQuotes) {
              s1 = s1.replaceAll(RegExp('^\'|\'\$'), '');
            }
          } else if (s.length < 3 &&
              (s1.replaceAll(_tic, '').toUpperCase() == (_falseValueStr) ||
                  (d != null && d == 0))) {
            s1 = _falseValueStr;
          } else if (s1.replaceAll(_tic, '').toUpperCase() ==
                  (_falseValueStr) ||
              s1 == '' ||
              (d != null && d == 0)) {
            //Below code has been added to return the cell range when the if formula is interior formula
            if (_computedValueLevel > 1 &&
                _isRange(s[2]) &&
                !s[2].contains(_tic)) {
              s1 = s[2];
            } else if ((s[2] == null || s[2] == '') && _treatStringsAsZero) {
              s1 = '0';
            } else {
              s1 = _getValueFromArg(s[2]);
            }
            if ((s1 == null || s1 == '') &&
                _treatStringsAsZero &&
                _computedValueLevel > 1) {
              s1 = '0';
            } else if (!(s1 == null || s1 == '') &&
                s1[0] == _tic[0] &&
                !_isCellReference(s[2]) &&
                useNoAmpersandQuotes) {
              s1 = s.length == 3 ? s1 : _falseValueStr;
              s1 = s1.replaceAll(RegExp('^\'|\'\$'), '');
            }
          }
        } catch (e) {
          _exceptionThrown = true;
          return e.toString();
        }
      } else {
        return formulaErrorStrings[_requires3Args];
      }
    }
    return s1;
  }

  /// A Virtual method to compute the value based on the argument passed in.
  String _getValueFromArg(String arg) {
    if (textIsEmpty(arg)) {
      return '';
    }
    double d;
    arg = arg.replaceAll('u', '-');
    arg = arg.replaceAll('~', _tic + _tic);

    if (_ignoreCellValue &&
        !(arg.startsWith(_trueValueStr) || arg.startsWith(_falseValueStr))) {
      _ignoreCellValue = false;
      return arg;
    }

    ////Not a number.
    if ((_indexOfAny(arg, ['+', '-', '/', '*', ')', ')', '{']) == -1 &&
            _isUpper(arg[0])) ||
        arg[0] == _sheetToken) {
      if (!arg.startsWith(_sheetToken.toString())) {
        arg = _putTokensForSheets(arg);
      }
      String s1 = getValueFromParentObject(arg, true);
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

  List _processUpperCase(String formula, int i, String sheet) {
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
    return [s, formula, i, sheet];
  }

  /// A method that parses the text in a formula passed in.
  String parseFormula(String formula) {
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
      if (_computedValueLevel <= 1) _isArrayFormula = false;
    }
  }

  List _isDate(Object o, DateTime date) {
    date = _dateTime1900;
    date = DateTime.tryParse(o.toString());
    return [(date != null && date.difference(_dateTime1900).inDays >= 0), date];
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
    if (textIsEmpty(text)) {
      return text;
    }
    if (text.contains(_tic)) {
      text = checkForStringTIC(text);
    }

    if (_formulaChar.isNotEmpty && text.isNotEmpty && _formulaChar == text[0]) {
      text = text.substring(1);
    }

    ////Save Strings...
    final List result = _saveStrings(text);
    final Map formulaStrings = result[0];
    text = result[1];

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
      final SheetFamilyItem family = _getSheetFamilyItem(_grid);
      if (family._sheetNameToParentObject != null &&
          family._sheetNameToParentObject.isNotEmpty) {
        try {
          if (!text.startsWith(_sheetToken.toString())) {
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
        return _errorStrings[5].toString();
      }
    }

    ////Look for inner matching and parse pieces without parens with _parseSimple.
    if (!_ignoreBracet) {
      while ((i = text.indexOf(')')) > -1) {
        final int k = text.substring(0, i).lastIndexOf('(');
        if (k == -1) {
          throw Exception(formulaErrorStrings[_mismatchedParentheses]);
        }

        if (k == i - 1) {
          throw Exception(formulaErrorStrings[_emptyExpression]);
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
      throw Exception(formulaErrorStrings[_mismatchedParentheses]);
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
        throw Exception(formulaErrorStrings[_mismatchedParentheses]);
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
          _libraryFunctions[formula.substring(i + 1, i + 1 + len)] != null) {
        if (formula.substring(i + 1, i + 1 + len) == 'AREAS') {
          _ignoreBracet = true;
        } else {
          _ignoreBracet = false;
        }
        final String s = formula.substring(
            leftParens, leftParens + rightParens - leftParens + 1);
        formula = formula.substring(0, i + 1) +
            'q' +
            formula.substring(i + 1, i + 1 + len) +
            s.replaceAll('(', _leftBracket).replaceAll(')', _rightBracket) +
            formula.substring(rightParens + 1);
      } else {
        String s = '';
        if (leftParens > 0) {
          s = formula.substring(0, leftParens);
        }

        s = s +
            '{' +
            formula.substring(
                leftParens + 1, leftParens + 1 + rightParens - leftParens - 1) +
            '}';
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

    final String sb = text;
    bool process = true;
    while (process) {
      sb.replaceAll('--', '+');
      sb.replaceAll('++', '+');
      ////Mark unary minus with u-token.

      sb
          .replaceAll(
              parseArgumentSeparator + '-', parseArgumentSeparator + 'u')
          .replaceAll(_leftBracket + '-', _leftBracket + 'u')
          .replaceAll('=-', '=u')
          .replaceAll('>-', '>u')
          .replaceAll('<-', '<u')
          .replaceAll('/-', '/u')
          .replaceAll('*-', '*u')
          .replaceAll('+-', '+u')
          .replaceAll('^-', '^u');
      ////Get rid of leading pluses.
      sb
          .replaceAll(
              parseArgumentSeparator + ',+', parseArgumentSeparator + ',')
          .replaceAll(_leftBracket + '+', _leftBracket.toString())
          .replaceAll('=+', '=')
          .replaceAll('>+', '>')
          .replaceAll('<+', '<')
          .replaceAll('/+', '/')
          .replaceAll('*+', '*')
          .replaceAll('^+', '^');
      if (sb.isNotEmpty && sb[0] == '+') {
        sb.replaceRange(0, 1, '');
      }

      process = text != sb.toString();
      text = sb.toString();
    }
    text = sb
        .replaceAll(_stringLessEq, _charLesseq.toString())
        .replaceAll(_stringGreaterEq, _charGreaterEq.toString())
        .replaceAll(_stringNoEqual, _charNoEqual.toString())
        .replaceAll(_stringOr, _charOr.toString())
        .replaceAll(_stringAnd, _charAnd.toString())
        .toString();

    String tempText = text;
    while (tempText.contains('\$')) {
      final int d = tempText.indexOf('\$');
      final List<String> _markers = [
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
              (d > 0 &&
                  _indexOfAny(tempText[d - 1].toString(), _markers) > -1) ||
          (d < tempText.length &&
              _indexOfAny(tempText[d + 1].toString(), _markers) > -1)) {
        return _errorStrings[5].toString();
      } else {
        tempText = tempText.replaceRange(d, d + 1, '');
        text = tempText;
      }
    }
    if (text == '') {
      return text;
    }

    bool needToContinue = true;

    List result;
    result = _parseSimpleFromMarkers(
        text, [_tokenEP, _tokenEM], [_charEP, _charEM], needToContinue);
    text = result[0];
    needToContinue = result[1];
    result =
        _parseSimpleFromMarkers(text, [_tokenOr], [_charOr], needToContinue);
    text = result[0];
    needToContinue = result[1];
    if (needToContinue) {
      result = _parseSimpleFromMarkers(text, [_tokenMultiply, _tokenDivide],
          [_charMultiply, _charDivide], needToContinue);
      text = result[0];
      needToContinue = result[1];
    }

    if (needToContinue) {
      result = _parseSimpleFromMarkers(text, [_tokenAdd, _tokenSubtract],
          [_charAdd, _charSubtract], needToContinue);
      text = result[0];
      needToContinue = result[1];
    }

    if (needToContinue) {
      result = _parseSimpleFromMarkers(
          text, [_tokenAnd], [_charAnd], needToContinue);
      text = result[0];
      needToContinue = result[1];
    }

    if (needToContinue) {
      result = _parseSimpleFromMarkers(
          text,
          [
            _tokenLess,
            _tokenGreater,
            _tokenEqual,
            _tokenLesseq,
            _tokenGreaterEq,
            _tokenNoEqual
          ],
          [
            _charLess,
            _charGreater,
            _charEqual,
            _charLesseq,
            _charGreaterEq,
            _charNoEqual
          ],
          needToContinue);
      text = result[0];
      needToContinue = result[1];
    }

    return text;
  }

  List _parseSimpleFromMarkers(String text, List<String> _markers,
      List<String> operators, bool needToContinue) {
    int i;
    String op = '';
    for (final c in operators) {
      op = op + c;
    }

    ////Mark unary minus with u-token.
    final String sb = text;
    if (text.startsWith(parseArgumentSeparator.toString()) ||
        text.startsWith('%')) {
      return [_errorStrings[5].toString(), needToContinue];
    }
    text = sb
        .replaceAll('---', '-')
        .replaceAll('--', '+')
        .replaceAll(parseArgumentSeparator + '-', parseArgumentSeparator + 'u')
        .replaceAll(_leftBracket + '-', _leftBracket + 'u')
        .replaceAll('=-', '=u')
        .replaceAll('>-', '>u')
        .replaceAll('<-', '<u')
        .replaceAll('/-', '/u')
        .replaceAll('*-', '*u')
        .replaceAll('+-', '-')
        .replaceAll('--', '-u')
        .replaceAll('w-', 'wu')
        .toString();

    ////Get rid of leading pluses.
    text = sb
        .replaceAll(
            parseArgumentSeparator + '+', parseArgumentSeparator.toString())
        .replaceAll(_leftBracket + '+', _leftBracket.toString())
        .replaceAll('=+', '=')
        .replaceAll('>+', '>')
        .replaceAll('<+', '<')
        .replaceAll('/+', '/')
        .replaceAll('*+', '*')
        .replaceAll('++', '+')
        .toString();

    if (text.isNotEmpty && text[0] == '-') {
      ////Leading unary minus.
      text = text.substring(1).replaceAll('-', '„');
      text = '0-' + text;
      final List iResult = _parseSimpleFromMarkers(
          text, [_tokenSubtract], [_charSubtract], needToContinue);
      text = iResult[0];
      needToContinue = iResult[1];
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
                  formulaErrorStrings[_operatorsCannotStartAnExpression]);
            }

            ////Process left argument.
            j = i - 1;

            if (text[j] == _tic[0]) {
              ////String
              final int k = text.substring(0, j - 1).lastIndexOf(_tic);
              if (k < 0) {
                throw Exception(formulaErrorStrings[_cannotParse]);
              }

              left = text.substring(k, k + j - k + 1); ////Keep the tics.
              leftIndex = k;
            } else if (text[j] == _bMarker) {
              ////Block of already parsed code.
              final int k = _findLastNonQB(text.substring(0, j - 1));
              if (k < 0) {
                throw Exception(formulaErrorStrings[_cannotParse]);
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
                  left = 'n' + _trueValueStr;
                } else if (left == _falseValueStr) {
                  left = 'n' + _falseValueStr;
                } else {
                  return [_errorStrings[5].toString(), needToContinue];
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
                    formulaErrorStrings[_numberContains2DecimalPoints]);
              }

              j = j + 1;

              if (j == 0 || (j > 0 && !_isUpper(text[j - 1]))) {
                left = 'n' + text.substring(j, j + i - j); ////'n' for number
                leftIndex = j;
              } else {
                j = j - 1;
                while (j > -1 &&
                    (_isUpper(text[j]) ||
                        _isDigit(text.codeUnitAt(j)) ||
                        text[j] == '_' ||
                        text[j] == '\\')) {
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

                  final List<String> leftValue = _getCellsFromArgs(left, false);
                  if (leftValue.isNotEmpty) left = leftValue[0];
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
                formulaErrorStrings[_expressionCannotEndWithAnOperator]);
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
                throw Exception(formulaErrorStrings[_cannotParse]);
              }

              right = text.substring(j, j + k + 2);
              rightIndex = k + j + 2;
            } else if (text[j] == _bMarker) {
              ////Block of already parsed code.
              final int k = _findNonQB(text.substring(j + 1));
              if (k < 0) {
                throw Exception(formulaErrorStrings[_cannotParse]);
              }

              right = text.substring(j + 1, j + 1 + k);

              if (isU) {
                right = right + 'nu1m'; ////multiply quantity by -1...
              }

              rightIndex = k + j + 2;
            } else if (text[j] == '#') {
              int rightErrorIndex = 0;
              for (final err in _errorStrings) {
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
                throw Exception(formulaErrorStrings[_cannotParse]);
              }

              right = text.substring(j, j + k - j + 1);

              if (isU) {
                right = 'u' + right;
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

              right = 'n' + text.substring(i + 1, i + 1 + j - i - 1);
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

                final List<String> rightValue = _getCellsFromArgs(right, false);
                if (rightValue.isNotEmpty) right = rightValue[0];
              } else {
                //// handle normal cell reference
                j = j - 1;
                right = text.substring(i + 1, i + 1 + j - i);
                isU = text[j] == 'u';
                if (isU) {
                  right = 'u' + right;
                }
              }
              noCellReference = !_isCellReference(right);
              if (noCellReference) {
                if (!_findNamedRange) {
                  if (right == _trueValueStr) {
                    right = 'n' + _trueValueStr;
                  } else if (right == _falseValueStr) {
                    right = 'n' + _falseValueStr;
                  } else {
                    return [_errorStrings[5].toString(), needToContinue];
                  }
                }
                _findNamedRange = false;
              }

              rightIndex = j + 1;
            } else {
              throw Exception(
                  formulaErrorStrings[_invalidCharactersFollowingAnOperator]);
            }
          }

          final int p = op.indexOf(text[i]);
          String s = _bMarker + (left) + (right) + _markers[p] + _bMarker;
          if (leftIndex > 0) {
            s = text.substring(0, leftIndex) + s;
          }

          if (rightIndex < text.length) {
            s = s + text.substring(rightIndex);
          }

          s = s.replaceAll(_bMarker2, _bMarker.toString());

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
            throw Exception(formulaErrorStrings[_cannotParse]);
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
            throw Exception(formulaErrorStrings[_badLibrary]);
          }
        } else if (!_isDigit(text.codeUnitAt(j))) {
          ////number
          ////Throw new Exception(formulaErrorStrings[invalid_char_in_number]).
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
            throw Exception(formulaErrorStrings[_numberContains2DecimalPoints]);
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
                  throw Exception(formulaErrorStrings[_missingSheet]);
                } else {
                  return [_errorStrings[2].toString(), needToContinue];
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

      return [text, needToContinue];
    } catch (e) {
      _exceptionThrown = true;
      return [e.toString(), needToContinue];
    }
  }

  /// Determines whether the arg is a valid cell name.
  bool _isCellReference(String args) {
    if (textIsEmpty(args)) {
      return false;
    }
    args = _putTokensForSheets(args);
    final String _sheetTokenStr = _getSheetToken(args);
    bool containsBoth = false;
    if (!textIsEmpty(_sheetTokenStr)) {
      args = args.replaceAll(_sheetTokenStr, '');
    }

    bool isAlpha = false, isNum = false;
    if (args.indexOf(':') != args.lastIndexOf(':')) {
      return false;
    }
    args.runes.forEach((int c) {
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
        return false;
      }
    });
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
  String getValueFromParentObject(String cell1, bool calculateFormula) {
    if (cell1 == _trueValueStr || cell1 == _falseValueStr) {
      return cell1;
    }

    final int i = cell1.lastIndexOf(_sheetToken);
    int row = 0, col = 0;
    final Worksheet grd = _grid;
    final SheetFamilyItem family = _getSheetFamilyItem(_grid);
    if (i > -1 && family._tokenToParentObject != null) {
      _grid = family._tokenToParentObject[cell1.substring(0, i + 1)];
      row = _getRowIndex(cell1);
      if (row == -1 && _grid is Worksheet) {
        row = (_grid).getFirstRow();
      }
      col = _getColIndex(cell1);
      if (col == -1 && _grid is Worksheet) {
        col = (_grid).getFirstColumn();
      }
    } else if (i == -1) {
      row = _getRowIndex(cell1);
      if (row == -1 && _grid is Worksheet) {
        row = (_grid).getFirstRow();
      }
      col = _getColIndex(cell1);
      if (col == -1 && _grid is Worksheet) {
        col = (_grid).getFirstColumn();
      }
      if (_isSheeted && family._parentObjectToToken != null) {
        cell1 = family._parentObjectToToken[_grid] + cell1;
      }
    }

    final String saveCell = _cell;
    _cell = cell1;

    String val = '';
    if (calculateFormula) {
      val = _getValueComputeFormulaIfNecessary(row, col, _grid);
    } else {
      final Object s = _grid.getValueRowCol(row, col);
      val = s != null ? s.toString() : '';
    }

    _grid = grd;
    _cell = saveCell;
    return val;
  }

  String _getValueComputeFormulaIfNecessary(int row, int col, Worksheet grd) {
    try {
      bool alreadyComputed = false;
      FormulaInfo formula = _formulaInfoTable[_cell] as FormulaInfo;
      final Object o = grd.getValueRowCol(row, col);
      String val = (o != null && o.toString() != '')
          ? o.toString()
          : ''; ////null; //xx _grid[row, col];
      DateTime result;
      result = DateTime.tryParse(val);
      if (val != null &&
          double.tryParse(val.replaceAll(_tic, '')) == null &&
          result != null) {
        final Worksheet sheet = _grid;
        if (sheet != null) {
          final Range range = sheet.getRangeByIndex(row, col);
          if (range != null && range.dateTime != null) {
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

          if (!_dependentFormulaCells.containsKey(_cell)) {
            _dependentFormulaCells[_cell] = <dynamic, dynamic>{};
          }

          bool compute = true;
          final bool isArray = _isArrayFormula;
          try {
            formula._parsedFormula = parseFormula(val);
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
            formula._formulaValue = _computeFormula(formula._parsedFormula);
            alreadyComputed = true;
          }
          if (formula != null) {
            if (!_ignoreSubtotal) formula._calcID = _calcID;
            if (!_formulaInfoTable.containsKey(_cell)) {
              _formulaInfoTable[_cell] = formula;
            }
            if (formula._formulaValue != null) {
              val = formula._formulaValue;
            } else {
              val = '';
            }
          }
          _ignoreSubtotal = tempIgnoreSubtotal;
        }
      }

      if (formula != null) {
        if (_useFormulaValues || (!_inAPull || alreadyComputed)) {
          if (formula._formulaValue != null) {
            val = formula._formulaValue;
          } else {
            val = '';
          }
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
            val == null &&
            val == '' &&
            _computedValueLevel > 1 &&
            !formula._parsedFormula.startsWith(_ifMarker)) {
          return '0';
        }
      }

      val ??= '';
      if (val == 'NaN') val = 'Exception: #VALUE!';
      return val;
    } finally {
      if (_computedValueLevel <= 1) _isArrayFormula = false;
    }
  }

  double _getSerialDateTimeFromDate(DateTime dt) {
    double d = Range.toOADate(dt) - _dateTime1900Double;
    d = 1 + Range.toOADate(dt) - _dateTime1900Double;
    if (_treat1900AsLeapYear && d > 59) {
      d += 1;
    }
    if (_useDate1904) d = d - _oADate1904;
    return d;
  }

  bool _isUpper(String letter) {
    return _isLetter(letter.codeUnitAt(0)) && letter[0] != letter.toLowerCase();
  }

  String _getCellFrom(String range) {
    String s = '';
    final List<String> cells = _getCellsFromArgs(range);
    if (cells.length == 1) return cells[0];
    final int last = cells.length - 1;
    final int r1 = _getRowIndex(cells[0]);
    if (r1 == _getRowIndex(cells[last])) {
      final int c1 = _getColIndex(cells[0]);
      final int c2 = _getColIndex(cells[last]);
      final int c = _getColIndex(_cell);
      if (c >= c1 && c <= c2) {
        s = RangeInfo.getAlphaLabel(c) + r1.toString();
      }
    }
    return s;
  }

  /// A method that retrieves a String array of cells from the range passed in.
  List<String> _getCellsFromArgs(String args, [bool findCellsFromRange]) {
    findCellsFromRange ??= true;

    args = _markColonsInQuotes(args);

    int row1 = 0;
    int col1 = 0;

    int i = args.indexOf(':');

    String sheet = '';
    final String book = '';

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
          count = (_grid).getLastColumn();
        }
        args = 'A' +
            args.substring(0, i) +
            ':' +
            RangeInfo.getAlphaLabel(count) +
            args.substring(i + 1);
        i = args.indexOf(':');
      }
    }
    if (!findCellsFromRange) return [sheet + args];
    int row2 = 0;
    int col2 = 0;
    final List<String> argList = args.split(':');
    if (argList.length > 2) {
      int minCol, minRow, maxCol, maxRow, d;
      minCol = minRow = _intMaxValue;
      maxCol = maxRow = _intMinValue;
      for (final tempArgs in argList) {
        d = _getRowIndex(tempArgs);
        minRow = math.min(minRow, d);
        maxRow = math.max(maxRow, d);

        d = _getColIndex(tempArgs);
        minCol = math.min(minCol, d);
        maxCol = math.max(maxCol, d);
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

    if (!(row1 != -1 || row2 == -1) == ((row1 == -1 || row2 != -1))) {
      throw Exception(_errorStrings[5].toString());
    }
    if (row1 == -1 && _grid is Worksheet) {
      row1 = (_grid).getFirstRow();
    }
    if (col1 == -1 && _grid is Worksheet) {
      col1 = (_grid).getFirstColumn();
    }
    if (row2 == -1 && _grid is Worksheet) {
      row2 = (_grid).getLastRow();
    }
    if (col2 == -1 && _grid is Worksheet) {
      col2 = (_grid).getLastColumn();
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
    final List<String> cells = List<String>(numCells);
    int k = 0;
    for (i = row1; i <= row2; ++i) {
      for (j = col1; j <= col2; ++j) {
        try {
          cells[k++] = book + sheet + RangeInfo.getAlphaLabel(j) + i.toString();
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
    if (args.indexOf(':') == -1) return args;

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

    final List result = _saveStrings(args);
    final Map formulaStrings = result[0];
    args = result[1];

    final List<String> results = args.split(parseArgumentSeparator);
    final List<String> pieces = [];
    for (final s in results) {
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

  List _saveStrings(String text) {
    Map strings;
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
              throw Exception(formulaErrorStrings[_mismatchedTics]);
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
          throw Exception(formulaErrorStrings[_mismatchedTics]);
        }
      }
    }

    return [strings, text];
  }

  String _setStrings(String retValue, Map strings) {
    for (final s in strings.keys) {
      retValue = retValue.replaceAll(s, strings[s] as String);
    }
    return retValue;
  }

  String _putTokensForSheets(String text) {
    final SheetFamilyItem family = _getSheetFamilyItem(_grid);

    if (_supportsSheetRanges) {
      text = _handleSheetRanges(text, family);
    }

    if (_sortedSheetNamesList != null) {
      for (final String name in _sortedSheetNamesList) {
        String token = family._sheetNameToToken[name] as String;
        token = token.replaceAll(_sheetToken, _tempSheetPlaceHolder);

        String s = "'" + name.toUpperCase() + "'" + _sheetToken;
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

  String _popString(Stack _stack) {
    Object o = _stack._pop();
    o ??= '';
    final double d = double.tryParse(o.toString());
    if (!_getValueFromArgPreserveLeadingZeros && d != null) {
      return d.toString();
    }

    if (_errorStrings.contains(o.toString().replaceAll(_tic, ''))) {
      return o.toString();
    } else {
      return o.toString();
    }
  }

  double _pop(Stack _stack) {
    final Object o = _stack._pop();

    String s = '';
    if (o != null) {
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

      final double d = double.tryParse(s);
      if (d != null) {
        return d;
      } else if (useDatesInCalculations) {
        DateTime dt;
        final List listResult = _isDate(o, dt);
        if (listResult[0]) {
          return _getSerialDateTimeFromDate(listResult[1]);
        }
      }
    }
    if (s == null || s == '' && _treatStringsAsZero) {
      return 0;
    } else if (o != null && o.toString().isNotEmpty) {
      return double.nan;
    }
    return 0;
  }

  /// Tests whether a String is NULL or empty.
  static bool textIsEmpty(String s) {
    return s == null || s == '';
  }

  int _lastIndexOfAny(String text, List<String> tokens) {
    for (final token in tokens) {
      final int index = text.lastIndexOf(token);
      if (index != -1) return index;
    }
    return -1;
  }

  int _indexOfAny(String text, List<String> tokens) {
    for (final String token in tokens) {
      final int index = text.indexOf(token);
      if (index != -1) return index;
    }
    return -1;
  }

  /// This method check '\'in the String and removes if the String contains  '\'\.
  String checkForStringTIC(String text) {
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
              throw Exception(formulaErrorStrings[_mismatchedTics]);
            }
          }
          //Below condition is avoid to remove "\"\ while it placed inside of the String value(eg., \"<p>\"\"Req\"\" </p>\").
          if (j < text.length - 2 && text[j + 1] == _tic[0]) {
            stringTIC = true;
            j = text.indexOf(_tic, j + 2);
            if (j == -1) {
              throw Exception(formulaErrorStrings[_mismatchedTics]);
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
        } else if (j == -1) return text;
      }
    }
    return text;
  }
}
