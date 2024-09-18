import '../general/enums.dart';
import 'format_parser.dart';
import 'format_section_collection.dart';
import 'formats_collection.dart';

/// Represents the format Impl class.
class Format {
  /// Initializes new instance of the format.
  Format(FormatsCollection parent, [int index = 0, String strFormat = '']) {
    _parent = parent;
    index = index;
    formatString = strFormat;
  }

  late FormatsCollection _parent;

  /// Format index used in other records.
  int index = 0;

  /// Format string.
  String? formatString;

  /// Parsed format.
  FormatSectionCollection? _parsedFormat;

  /// Reference to the format parser.
  final FormatParser _parser = FormatParser();

  /// Returns format type for a specified value.
  ExcelFormatType getFormatTypeFromDouble(double value) {
    _prepareFormat();
    return _parsedFormat!.getFormatTypeFromDouble(value);
  }

  /// Checks whether format is already parsed, if it isn't than parses it.
  void _prepareFormat() {
    if (_parsedFormat != null) {
      return;
    }

    final String? formatStr = formatString;
    _parsedFormat = _parser.parse(_parent.parent, formatStr);
  }

  /// Applies format to the value.
  String applyFormat(double value, bool bShowHiddenSymbols) {
    _prepareFormat();
    return _parsedFormat!.applyFormat(value, bShowHiddenSymbols);
  }

  /// clear the format.
  void clear() {
    _parser.clear();
    if (_parsedFormat != null) {
      _parsedFormat!.dispose();
      _parsedFormat!.innerList.clear();
    }
    _parsedFormat = null;
  }
}
