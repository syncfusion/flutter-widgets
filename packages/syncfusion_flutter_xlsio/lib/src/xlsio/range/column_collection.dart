part of xlsio;

/// Reprsents the colunm collection.
class ColumnCollection {
  /// Create a instance of rows collection.
  ColumnCollection(Worksheet worksheet) {
    _worksheet = worksheet;
    _innerList = [];
  }

  /// Parent worksheet.
  Worksheet _worksheet;

  /// Inner list.
  List<Column> _innerList;

  /// Represents parent worksheet.
  Worksheet get worksheet {
    return _worksheet;
  }

  /// Get/set the inner list.
  List<Column> get innerList {
    return _innerList;
  }

  /// Returns the count of pivot reference collection.
  int get count {
    return _innerList.length;
  }

  /// Indexer of the class
  Column operator [](index) => innerList[index];

  /// Add row to the row collection.
  Column add() {
    final Column column = Column(_worksheet);
    innerList.add(column);
    return column;
  }

  /// Add row to the rows collection.
  void addColumn(Column column) {
    if (column != null) {
      bool inserted = false;
      int count = 0;
      final List<Column> columns = [];
      columns.addAll(innerList);
      for (final Column c in columns) {
        if (c.index == column.index) {
          innerList[count] = column;
          inserted = true;
        }
        count++;
      }
      if (!inserted) {
        innerList.add(column);
      }
    }
  }

  /// Get a column from columns collection based on row index.
  Column getColumn(int colIndex) {
    for (final Column col in innerList) {
      if (col.index == colIndex) {
        return col;
      }
    }
    return null;
  }

  /// check whether the column contains.
  bool contains(int colIndex) {
    for (final Column col in innerList) {
      if (col.index == colIndex) {
        return true;
      }
    }
    return false;
  }

  /// clear the column.
  void clear() {
    if (_innerList != null) {
      _innerList.clear();
    }
  }
}
