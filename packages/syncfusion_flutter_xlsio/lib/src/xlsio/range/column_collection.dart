part of xlsio;

/// Reprsents the colunm collection.
class ColumnCollection {
  /// Create a instance of rows collection.
  ColumnCollection(Worksheet worksheet) {
    _worksheet = worksheet;
    _innerList = <Column>[];
  }

  /// Parent worksheet.
  late Worksheet _worksheet;

  /// Inner list.
  late List<Column?> _innerList;

  /// Represents count of elements.
  int _iCount = 0;

  /// Represents parent worksheet.
  Worksheet get worksheet {
    return _worksheet;
  }

  /// Get/set the inner list.
  List<Column?> get innerList {
    return _innerList;
  }

  /// Returns the count of pivot reference collection.
  int get count {
    return _innerList.length;
  }

  /// Indexer get of the class
  Column? operator [](int index) {
    if (index <= _innerList.length) {
      return _innerList[index - 1];
    } else {
      return null;
    }
  }

  /// Indexer set of the class
  operator []=(int index, Column? value) {
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

      final List<Column?> list =
          List<Column?>.filled(_iCount, null, growable: true);

      list.setAll(0, _innerList);

      _innerList = list;
    }
  }

  /// Add row to the row collection.
  Column add() {
    final Column column = Column(_worksheet);
    innerList.add(column);
    column.index = innerList.length;
    return column;
  }

  /// clear the column.
  void _clear() {
    _innerList.clear();
  }
}
