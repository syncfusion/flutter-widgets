part of xlsio;

/// Class used for Section Collection.
class FormatSectionCollection {
  /// Index of section with positive number format.
  static const int _defaultPostiveSection = 0;

  /// Index of section with negative number format.
  static const int _defaultNegativeSection = 1;

  /// Index of section with positive number format.
  static const int _defaultZeroSection = 2;

  /// Index of section with positive number format.
  static const int _defaultTextSection = 3;

  /// Represent the inner collection of format section.
  List<FormatSection> innerList;

  // Indexer of the class
  // ignore: public_member_api_docs
  FormatSection operator [](index) => innerList[index];

  // Returns the count of pivot reference collection.
  int get _count {
    return innerList.length;
  }

  /// Indicates whether format contains conditions.
  final _bConditionalFormat = false;

  /// Represents the workbook.
  Workbook _workbook;

  /// Initializes a new instance of the FormatSectionCollection class.
  // ignore: sort_constructors_first
  FormatSectionCollection(Workbook workbook,
      [List<FormatTokenBase> arrTokens]) {
    _workbook = workbook;
    innerList = [];
    if (arrTokens != null) _parse(arrTokens);
  }

  /// Returns format type for a specified value.
  ExcelFormatType _getFormatTypeFromDouble(double value) {
    final FormatSection section = _getSection(value);

    if (section == null) {
      throw FormatException("Can't find required format section.");
    }

    return section.formatType;
  }

  /// Splits array of tokens by SectionSeparator.
  void _parse(List<FormatTokenBase> arrTokens) {
    if (arrTokens == null) throw Exception('arrTokens should not be null');

    List<FormatTokenBase> arrCurrentSection = [];

    final int len = arrTokens.length;
    for (int i = 0; i < len; i++) {
      final FormatTokenBase token = arrTokens[i];

      if (token.tokenType == TokenType.section) {
        innerList.add(FormatSection(_workbook, this, arrCurrentSection));
        arrCurrentSection = [];
      } else {
        arrCurrentSection.add(token);
      }
    }

    innerList.add(FormatSection(_workbook, this, arrCurrentSection));
  }

  /// Applies format to the value.
  String _applyFormat(double value, bool bShowReservedSymbols, [Range cell]) {
    final FormatSection section = _getSection(value);

    if (section != null) {
      if (!_bConditionalFormat && value < 0 && _count > 1) value = -value;
      if ((section.formatType == ExcelFormatType.text) &&
          innerList.length == _defaultTextSection) {
        if (value == 0.0) {
          return '';
        }
      }
      return section.applyFormat(value, bShowReservedSymbols, cell);
    }

    throw FormatException("Can't locate correct section.");
  }

  /// Returns section for formatting with specified index.
  FormatSection _getSectionFromIndex(int iSectionIndex) {
    return this[iSectionIndex % _count];
  }

  /// Returns section that corresponds to the specified value.
  FormatSection _getSection(double value) {
    FormatSection result;

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
  FormatSection _getZeroSection() {
    if (_bConditionalFormat) {
      throw Exception(
          'This method is not supported for number formats with conditions.');
    }

    final int iSectionsCount = innerList.length;
    final int iLastSection = iSectionsCount - 1;
    FormatSection result;

    if (iLastSection < _defaultZeroSection) {
      result = this[_defaultPostiveSection];
    } else {
      result = this[_defaultZeroSection];
    }
    return result;
  }

  void _dispose() {
    final int count = innerList.length;

    for (int i = 0; i < count; i++) {
      innerList[i]._clear();
      innerList[i] = null;
    }
  }
}
