part of xlsio;

/// Wrapper over conditional format collection for range.
class _CondFormatCollectionWrapper implements ConditionalFormats {
  /// Create an instances of culture info class.
  _CondFormatCollectionWrapper(Range range) {
    _range = range;
    _arrConditionFormat = <ConditionalFormat>[];
    _sheet = range.worksheet;
  }

  /// Worksheet
  late Worksheet _sheet;

  /// Wrapped range object.
  late Range _range;

  _ConditionalFormatsImpl? _condFormats;

  /// List with all wrapped conditions.
  late List<ConditionalFormat> _arrConditionFormat;

  /// Number of begin update calls that have no corresponding end update.
  int _iBeginCount = 0;

  /// Gets the inner list.
  List<ConditionalFormat> get innerList {
    return _arrConditionFormat;
  }

  /// Gets worksheet.
  Worksheet get sheet {
    return _sheet;
  }

  @override

  /// Gets the number of conditional formats in the collection. Read-only.
  int get count {
    return _condFormats!.innerList.length;
  }

  @override

  /// Gets the number of conditional formats in the collection. Read-only.
  set count(int value) {
    _condFormats!.innerList.length = value;
  }

  @override

  /// Adds new condition to the collection.
  ConditionalFormat addCondition() {
    if (_condFormats == null) {
      final Worksheet worksheet = sheet;
      _condFormats = _ConditionalFormatsImpl(worksheet, _range);
      worksheet.conditionalFormats.add(_condFormats!);
    }
    ConditionalFormat format = _condFormats!.addCondition();
    format = _ConditionalFormatWrapper(this, count - 1);
    (format as _ConditionalFormatWrapper)._range = _range;
    _arrConditionFormat.add(format);
    return format;
  }

  /// This method should be called before several updates to the object will take place.
  void _beginUpdate() {
    _iBeginCount++;
  }

  /// This method should be called after several updates to the object.
  void _endUpdate() {
    if (_iBeginCount > 0) {
      _iBeginCount--;
    }
  }
}
