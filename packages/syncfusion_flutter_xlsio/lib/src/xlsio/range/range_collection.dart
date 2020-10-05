part of xlsio;

/// Represents the worksheet rows.
class RangeCollection {
  /// Create a instance of rows collection.
  RangeCollection([Row row]) {
    if (row != null) _row = row;
    _innerList = [];
  }

  /// Parent worksheet.
  Row _row;

  /// Represents count of elements.
  int _iCount = 0;

  /// Represents count of elements.
  List<Range> _innerList;

  /// Represents inner list.
  List<Range> get innerList {
    return _innerList;
  }

  /// Returns the count of pivot reference collection.
  int get count {
    return _innerList.length;
  }

  /// Indexer get of the class
  Range operator [](index) {
    if (index < _innerList.length) {
      return _innerList[index];
    } else {
      return null;
    }
  }

  /// Indexer set of the class
  operator []=(index, value) {
    if (_iCount <= index) {
      _updateSize(index + 1);
    }
    _innerList[index] = value;
  }

  /// Updates count of storage array.
  void _updateSize(int iCount) {
    if (iCount > _iCount) {
      final int iBufCount = _iCount * 2;

      _iCount = (iCount >= iBufCount) ? iCount : iBufCount;

      final List<Range> list = List<Range>(_iCount);

      if (_innerList != null) list.setAll(0, _innerList);

      _innerList = list;
    }
  }

  /// Add row to the row collection.
  Range add() {
    final Range range = Range(_row._worksheet);
    innerList.add(range);
    return range;
  }

  /// clear the Range.
  void _clear() {
    if (_innerList != null) {
      for (int i = 0; i < _innerList.length; i++) {
        final Range range = _innerList[i];
        _innerList[i] = null;

        if (range != null) range._clear();
      }
      _innerList = null;
    }
  }
}
