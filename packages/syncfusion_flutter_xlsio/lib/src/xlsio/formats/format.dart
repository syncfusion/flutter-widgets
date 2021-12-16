part of xlsio;

/// Represents the format Impl class.
class _Format {
  /// Initializes new instance of the format.
  _Format(FormatsCollection parent, [int index = 0, String strFormat = '']) {
    _parent = parent;
    _index = index;
    _formatString = strFormat;
  }

  late FormatsCollection _parent;

  /// Format index used in other records.
  int _index = 0;

  /// Format string.
  String? _formatString;

  /// Parsed format.
  _FormatSectionCollection? _parsedFormat;

  /// Reference to the format parser.
  final _FormatParser _parser = _FormatParser();

  /// Returns format type for a specified value.
  ExcelFormatType _getFormatTypeFromDouble(double value) {
    _prepareFormat();
    return _parsedFormat!._getFormatTypeFromDouble(value);
  }

  /// Checks whether format is already parsed, if it isn't than parses it.
  void _prepareFormat() {
    if (_parsedFormat != null) {
      return;
    }

    final String? formatString = _formatString;
    _parsedFormat = _parser._parse(_parent.parent, formatString);
  }

  /// Applies format to the value.
  String _applyFormat(double value, bool bShowHiddenSymbols) {
    _prepareFormat();
    return _parsedFormat!._applyFormat(value, bShowHiddenSymbols);
  }

  /// clear the format.
  void _clear() {
    _parser._clear();
    if (_parsedFormat != null) {
      _parsedFormat!._dispose();
      _parsedFormat!._innerList.clear();
    }
    _parsedFormat = null;
  }
}
