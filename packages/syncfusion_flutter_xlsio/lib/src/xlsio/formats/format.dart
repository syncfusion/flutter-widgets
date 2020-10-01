part of xlsio;

/// Represents the format Impl class.
class FormatImpl {
  /// Initializes new instance of the format.
  FormatImpl(FormatsCollection parent, [int index, String strFormat]) {
    _parent = parent;
    this.index = index;
    formatString = strFormat;
  }

  FormatsCollection _parent;

  /// Format index used in other records.
  int index = 0;

  /// Format string.
  String formatString;

  /// Parsed format.
  FormatSectionCollection _parsedFormat;

  /// Reference to the format parser.
  final _parser = FormatParserImpl();

  /// Returns format type for a specified value.
  ExcelFormatType getFormatTypeFromDouble(double value) {
    prepareFormat();
    return _parsedFormat._getFormatTypeFromDouble(value);
  }

  /// Checks whether format is already parsed, if it isn't than parses it.
  void prepareFormat() {
    if (_parsedFormat != null) return;

    final formatString = this.formatString;
    _parsedFormat = _parser.parse(_parent.parent, formatString);
  }

  /// Applies format to the value.
  String applyFormat(double value, bool bShowHiddenSymbols, [Range cell]) {
    prepareFormat();
    return _parsedFormat._applyFormat(value, bShowHiddenSymbols, cell);
  }

  /// clear the format.
  void clear() {
    _parser._clear();
    if (_parsedFormat != null) {
      _parsedFormat._dispose();
      _parsedFormat.innerList.clear();
    }
    _parsedFormat = null;
  }
}
