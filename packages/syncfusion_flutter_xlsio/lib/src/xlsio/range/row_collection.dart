part of xlsio;

/// Represents the worksheet rows.
class RowCollection {
  /// Create a instance of rows collection.
  RowCollection(Worksheet worksheet) {
    _worksheet = worksheet;
    _innerList = [];
  }

  /// Parent worksheet.
  Worksheet _worksheet;

  /// Represents count of elements.
  int _iCount = 0;

  /// Represents the inner list.
  List<Row> _innerList;

  /// Represents parent worksheet.
  Worksheet get worksheet {
    return _worksheet;
  }

  /// Represents the inner list.
  List<Row> get innerList {
    return _innerList;
  }

  /// Returns the count of pivot reference collection.
  int get count {
    return _innerList.length;
  }

  /// Indexer get of the class
  Row operator [](index) {
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

      final List<Row> list = List<Row>(_iCount);

      if (_innerList != null) list.setAll(0, _innerList);

      _innerList = list;
    }
  }

  /// Add row to the row collection.
  Row add() {
    final Row row = Row(_worksheet);
    innerList.add(row);
    return row;
  }

  /// Clear the row.
  void _clear() {
    if (_innerList != null) {
      for (int i = 0; i < _innerList.length; i++) {
        final Row row = _innerList[i];
        _innerList[i] = null;

        if (row != null) row._clear();
      }
      _innerList = null;
    }
  }
}
