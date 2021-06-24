part of xlsio;

/// Represents the worksheet rows.
class RowCollection {
  /// Create a instance of rows collection.
  RowCollection(Worksheet worksheet) {
    _worksheet = worksheet;
    _innerList = <Row?>[];
  }

  /// Parent worksheet.
  late Worksheet _worksheet;

  /// Represents count of elements.
  int _iCount = 0;

  /// Represents the inner list.
  late List<Row?> _innerList;

  /// Represents parent worksheet.
  Worksheet get worksheet {
    return _worksheet;
  }

  /// Represents the inner list.
  List<Row?> get innerList {
    return _innerList;
  }

  /// Returns the count of pivot reference collection.
  int get count {
    return _innerList.length;
  }

  /// Indexer get of the class
  Row? operator [](int index) {
    if (index <= _innerList.length) {
      return _innerList[index - 1];
    } else {
      return null;
    }
  }

  /// Indexer set of the class
  operator []=(int index, Row? value) {
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

      final List<Row?> list = List<Row?>.filled(_iCount, null, growable: true);

      list.setAll(0, _innerList);

      _innerList = list;
    }
  }

  /// Add row to the row collection.
  Row add() {
    final Row row = Row(_worksheet);
    innerList.add(row);
    row.index = innerList.length;
    return row;
  }

  /// Get a row from rows collection based on row index.
  Row? _getRow(int rowIndex) {
    for (final Row? row in innerList) {
      if (row != null) {
        if (row.index == rowIndex) {
          return row;
        }
      }
    }
    return null;
  }

  /// Clear the row.
  void _clear() {
    for (int i = 0; i < _innerList.length; i++) {
      final Row? row = _innerList[i];
      _innerList[i] = null;
      if (row != null) {
        row._clear();
      }
    }
  }
}
