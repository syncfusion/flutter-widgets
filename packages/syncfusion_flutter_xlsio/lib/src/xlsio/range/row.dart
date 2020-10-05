part of xlsio;

/// <summary>
/// Represents the worksheet row.
/// </summary>
class Row {
  /// <summary>
  /// Create an instance of Row.
  /// </summary>
  /// <param name="sheet">Parent worksheet</param>
  Row(Worksheet sheet) {
    _worksheet = sheet;
  }

  /// <summary>
  /// Represents the row height.
  /// </summary>
  double height;

  /// <summary>
  /// Represents the row index.
  /// </summary>
  int index;

  /// Parent worksheet.
  Worksheet _worksheet;

  /// Range collection in the row.
  RangeCollection _ranges;

  /// Represents parent worksheet.
  Worksheet get worksheet {
    return _worksheet;
  }

  /// <summary>
  ///  Gets/Sets a images collections in the worksheet
  /// </summary>
  RangeCollection get ranges {
    _ranges ??= RangeCollection(this);
    return _ranges;
  }

  /// clear the row.
  void _clear() {
    if (_ranges != null) {
      _ranges._clear();
    }
  }
}
