part of xlsio;

/// Class used for Section Collection.
class _FormatSectionCollection {
  /// Initializes a new instance of the FormatSectionCollection class.
  _FormatSectionCollection(Workbook workbook,
      [List<_FormatTokenBase>? arrTokens]) {
    _workbook = workbook;
    _innerList = <_FormatSection?>[];
    if (arrTokens != null) {
      _parse(arrTokens);
    }
  }

  /// Index of section with positive number format.
  static const int _defaultPostiveSection = 0;

  /// Index of section with negative number format.
  static const int _defaultNegativeSection = 1;

  /// Index of section with positive number format.
  static const int _defaultZeroSection = 2;

  /// Index of section with positive number format.
  static const int _defaultTextSection = 3;

  /// Represent the inner collection of format section.
  late List<_FormatSection?> _innerList;

  // Indexer of the class
  _FormatSection? operator [](dynamic index) => _innerList[index];

  // Returns the count of pivot reference collection.
  int get _count {
    return _innerList.length;
  }

  /// Indicates whether format contains conditions.
  final bool _bConditionalFormat = false;

  /// Represents the workbook.
  late Workbook _workbook;

  /// Returns format type for a specified value.
  ExcelFormatType _getFormatTypeFromDouble(double value) {
    final _FormatSection? section = _getSection(value);

    if (section == null) {
      throw const FormatException("Can't find required format section.");
    }

    return section.formatType;
  }

  /// Splits array of tokens by SectionSeparator.
  void _parse(List<_FormatTokenBase>? arrTokens) {
    if (arrTokens == null) {
      throw Exception('arrTokens should not be null');
    }

    List<_FormatTokenBase> arrCurrentSection = <_FormatTokenBase>[];

    final int len = arrTokens.length;
    for (int i = 0; i < len; i++) {
      final _FormatTokenBase token = arrTokens[i];

      if (token._tokenType == _TokenType.section) {
        _innerList.add(_FormatSection(_workbook, arrCurrentSection));
        arrCurrentSection = <_FormatTokenBase>[];
      } else {
        arrCurrentSection.add(token);
      }
    }

    _innerList.add(_FormatSection(_workbook, arrCurrentSection));
  }

  /// Applies format to the value.
  String _applyFormat(double value, bool bShowReservedSymbols) {
    final _FormatSection? section = _getSection(value);

    if (section != null) {
      if (!_bConditionalFormat && value < 0 && _count > 1) {
        value = -value;
      }
      if ((section.formatType == ExcelFormatType.text) &&
          _innerList.length == _defaultTextSection) {
        if (value == 0.0) {
          return '';
        }
      }
      return section._applyFormat(value, bShowReservedSymbols);
    }

    throw const FormatException("Can't locate correct section.");
  }

  /// Returns section for formatting with specified index.
  _FormatSection? _getSectionFromIndex(int iSectionIndex) {
    return this[iSectionIndex % _count];
  }

  /// Returns section that corresponds to the specified value.
  _FormatSection? _getSection(double value) {
    _FormatSection? result;

    if (value > 0) {
      result = _getSectionFromIndex(_defaultPostiveSection);
    } else if (value < 0) {
      result = _getSectionFromIndex(_defaultNegativeSection);
    } else {
      result = _getZeroSection(); //GetSection( _defaultZeroSection );
    }

    return result;
  }

  /// Searches for section that should be used for zero number formatting.
  _FormatSection? _getZeroSection() {
    if (_bConditionalFormat) {
      throw Exception(
          'This method is not supported for number formats with conditions.');
    }

    final int iSectionsCount = _innerList.length;
    final int iLastSection = iSectionsCount - 1;
    _FormatSection? result;

    if (iLastSection < _defaultZeroSection) {
      result = this[_defaultPostiveSection];
    } else {
      result = this[_defaultZeroSection];
    }
    return result;
  }

  void _dispose() {
    final int count = _innerList.length;

    for (int i = 0; i < count; i++) {
      _innerList[i]!._clear();
      _innerList[i] = null;
    }
  }
}
