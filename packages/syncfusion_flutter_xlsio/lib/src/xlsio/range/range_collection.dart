part of xlsio;

/// Represents the worksheet rows.
class RangeCollection {
  /// Create a instance of rows collection.
  RangeCollection(Row row) {
    _row = row;
    _innerList = <Range?>[];
  }

  /// Parent worksheet.
  late Row _row;

  /// Represents count of elements.
  int _iCount = 0;

  /// Represents count of elements.
  late List<Range?> _innerList;

  /// Represents inner list.
  List<Range?> get innerList {
    return _innerList;
  }

  /// Returns the count of pivot reference collection.
  int get count {
    return _innerList.length;
  }

  /// Indexer get of the class
  Range? operator [](int index) {
    if (index <= _innerList.length) {
      return _innerList[index - 1];
    } else {
      return null;
    }
  }

  /// Indexer set of the class
  operator []=(int index, Range? value) {
    if (_iCount < index) {
      _updateSize(index);
    }
    _innerList[index - 1] = value;
  }

  /// Updates count of storage array.
  void _updateSize(int iCount) {
    if (iCount > _iCount) {
      final int iBufCount = _iCount * 2;

      _iCount = (iCount >= iBufCount) ? iCount : iBufCount;

      final List<Range?> list =
          List<Range?>.filled(_iCount, null, growable: true);

      list.setAll(0, _innerList);

      _innerList = list;
    }
  }

  /// Add row to the row collection.
  Range add() {
    final Range range = Range(_row._worksheet);
    innerList.add(range);
    range.row = range.lastRow = _row.index;
    range._index = range.column = range.lastColumn = innerList.length;
    return range;
  }

  /// Get a cell from cells collection based on column.
  Range? _getCell(int columnIndex) {
    for (final Range? range in innerList) {
      if (range != null) {
        if (range._index == columnIndex) {
          return range;
        }
      }
    }
    return null;
  }

  /// clear the Range.
  void _clear() {
    for (int i = 0; i < _innerList.length; i++) {
      final Range? range = _innerList[i];
      _innerList[i] = null;

      if (range != null) {
        range._clear();
      }
    }
    _innerList.clear();
  }
}
