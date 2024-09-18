import '../formats/format_tokens/enums.dart';
import '../formats/format_tokens/format_token_base.dart';
import '../general/enums.dart';
import '../general/workbook.dart';
import 'format_section.dart';

/// Class used for Section Collection.
class FormatSectionCollection {
  /// Initializes a new instance of the FormatSectionCollection class.
  FormatSectionCollection(Workbook workbook,
      [List<FormatTokenBase>? arrTokens]) {
    _workbook = workbook;
    innerList = <FormatSection?>[];
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
  late List<FormatSection?> innerList;

  // Indexer of the class
  FormatSection? operator [](dynamic index) => innerList[index];

  // Returns the count of pivot reference collection.
  int get _count {
    return innerList.length;
  }

  /// Indicates whether format contains conditions.
  final bool _bConditionalFormat = false;

  /// Represents the workbook.
  late Workbook _workbook;

  /// Returns format type for a specified value.
  ExcelFormatType getFormatTypeFromDouble(double value) {
    final FormatSection? section = _getSection(value);

    if (section == null) {
      throw const FormatException("Can't find required format section.");
    }

    return section.formatType;
  }

  /// Splits array of tokens by SectionSeparator.
  void _parse(List<FormatTokenBase>? arrTokens) {
    if (arrTokens == null) {
      throw Exception('arrTokens should not be null');
    }

    List<FormatTokenBase> arrCurrentSection = <FormatTokenBase>[];

    final int len = arrTokens.length;
    for (int i = 0; i < len; i++) {
      final FormatTokenBase token = arrTokens[i];

      if (token.tokenType == TokenType.section) {
        innerList.add(FormatSection(_workbook, arrCurrentSection));
        arrCurrentSection = <FormatTokenBase>[];
      } else {
        arrCurrentSection.add(token);
      }
    }

    innerList.add(FormatSection(_workbook, arrCurrentSection));
  }

  /// Applies format to the value.
  String applyFormat(double value, bool bShowReservedSymbols) {
    final FormatSection? section = _getSection(value);

    if (section != null) {
      if (!_bConditionalFormat && value < 0 && _count > 1) {
        value = -value;
      }
      if ((section.formatType == ExcelFormatType.text) &&
          innerList.length == _defaultTextSection) {
        if (value == 0.0) {
          return '';
        }
      }
      return section.applyFormat(value, bShowReservedSymbols);
    }

    throw const FormatException("Can't locate correct section.");
  }

  /// Returns section for formatting with specified index.
  FormatSection? _getSectionFromIndex(int iSectionIndex) {
    return this[iSectionIndex % _count];
  }

  /// Returns section that corresponds to the specified value.
  FormatSection? _getSection(double value) {
    FormatSection? result;

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
  FormatSection? _getZeroSection() {
    if (_bConditionalFormat) {
      throw Exception(
          'This method is not supported for number formats with conditions.');
    }

    final int iSectionsCount = innerList.length;
    final int iLastSection = iSectionsCount - 1;
    FormatSection? result;

    if (iLastSection < _defaultZeroSection) {
      result = this[_defaultPostiveSection];
    } else {
      result = this[_defaultZeroSection];
    }
    return result;
  }

  void dispose() {
    final int count = innerList.length;

    for (int i = 0; i < count; i++) {
      innerList[i]!.clear();
      innerList[i] = null;
    }
  }
}
