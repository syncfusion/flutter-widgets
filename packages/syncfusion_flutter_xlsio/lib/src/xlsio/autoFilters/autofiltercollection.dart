part of xlsio;

/// Represents an AutoFilter collections
class AutoFilterCollection {
  ///Constructor an AutoFilter collections
  AutoFilterCollection(Worksheet worksheet) {
    _worksheet = worksheet;
  }
  // ignore: unused_field
  ///Represents worksheet
  late Worksheet _worksheet;

  ///Represents first row
  late int _topRow;

  ///Represents first column
  late int _leftColumn;

  ///Represents last row
  late int _bottomRow;

  ///Represents last column
  late int _rightColumn;

  ///Range to be filtered.
  late Range _range;

  /// Represents the presence of adjacent non-empty cells.
  late bool _hasAdjacents = false;

  /// Gets the list of elements in the instance
  final List<AutoFilter> _innerList = <AutoFilter>[];

  /// Gets the number of elements contained in the inthe InnerList.
  int get count {
    return _innerList.length;
  }

  ///Get filterRange
  Range get filterRange {
    return _range;
  }

  ///Set range to be filtered.
  set filterRange(Range value) {
    value = _updateFilterRange(value);
    _range = value;

    _innerList.clear();

    for (int i = value.column; i <= value.lastColumn; i++) {
      _innerList.add(_AutoFilterImpl(this, _worksheet, _topRow, _bottomRow));

      final _AutoFilterImpl filter =
          _innerList[_innerList.length - 1] as _AutoFilterImpl;

      filter._colIndex = i;
    }
  }

  /// Update range to be filtered.
  Range _updateFilterRange(Range filterRange) {
    _initializeFilterRange(filterRange.row, filterRange.column,
        filterRange.lastRow, filterRange.lastColumn);
    final int tempTopRow = _topRow;
    final int tempLeftColumn = _leftColumn;
    final int tempBottomRow = _bottomRow;
    final int tempRightColumn = _rightColumn;

    if (filterRange.isSingleRange) {
      //checkRange(_topRow, _leftColumn);
      bool isEmptyCell = false;
      if (filterRange.worksheet
          .getRangeByIndex(_topRow, _leftColumn)
          .cells
          .isEmpty) {
        isEmptyCell = true;
      }
      filterRange = _includeAdjacents(
          _topRow, _leftColumn, _bottomRow, _rightColumn, filterRange, true);
      if (isEmptyCell) {
        if (tempTopRow == _topRow) {
          if (!_isRowNotEmpty(
              _topRow, _leftColumn, _rightColumn, filterRange)) {
            _topRow++;
          }
        }
        if (tempLeftColumn == _leftColumn) {
          if (!_isColumnNotEmpty(
              _leftColumn, _topRow, _bottomRow, filterRange)) {
            _leftColumn++;
          }
        }
        if (tempBottomRow == _bottomRow) {
          if (!_isRowNotEmpty(
              _bottomRow, _leftColumn, _rightColumn, filterRange)) {
            _bottomRow--;
          }
        }
        if (tempRightColumn == _rightColumn) {
          if (!_isColumnNotEmpty(
              _rightColumn, _topRow, _bottomRow, filterRange)) {
            _rightColumn--;
          }
        }
      }
    }

    return filterRange;
  }

  /// Initializes the filter range values.
  void _initializeFilterRange(
      int topRow, int leftColumn, int bottomRow, int rightColumn) {
    _topRow = topRow;
    _leftColumn = leftColumn;
    _bottomRow = bottomRow;
    _rightColumn = rightColumn;
  }

  ///Indicates wheather row is empty or not
  bool _isRowNotEmpty(int row, int left, int right, Range filterRange) {
    for (int column = left; column <= right; column++) {
      if (filterRange.worksheet.getRangeByIndex(row, column).cells.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  ///Indicates wheather row is empty or not
  ///true represents column is not empty
  ///False indicates row is empty
  bool _isColumnNotEmpty(int column, int top, int bottom, Range filterRange) {
    for (int row = top; row <= bottom; row++) {
      if (filterRange.worksheet.getRangeByIndex(row, column).cells.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  /// Includes adjacent non-empty cells in the internal
  /// range object that stores filtered range.
  Range _includeAdjacents(int topRow, int leftColumn, int bottomRow,
      int rightColumn, Range filterRange, bool isEnd) {
    _initializeFilterRange(topRow, leftColumn, bottomRow, rightColumn);
    _hasAdjacents = false;
    _getTopAdjacents(topRow, leftColumn, bottomRow, rightColumn, filterRange);
    _getLeftAdjacents(topRow, leftColumn, bottomRow, rightColumn, filterRange);
    _getBottomAdjacents(
        topRow, leftColumn, bottomRow, rightColumn, filterRange);
    _getRightAdjacents(topRow, leftColumn, bottomRow, rightColumn, filterRange);
    filterRange = filterRange.worksheet
        .getRangeByIndex(_topRow, _leftColumn, _bottomRow, _rightColumn);
    if (_hasAdjacents) {
      filterRange = _includeAdjacents(
          _topRow, _leftColumn, _bottomRow, _rightColumn, filterRange, false);
    }

    if (isEnd) {
      for (int i = filterRange.column; i <= filterRange.lastColumn; i++) {
        if (filterRange.worksheet
            .getRangeByIndex(filterRange.row, i)
            .cells
            .isNotEmpty) {
          for (int j = filterRange.column; j <= filterRange.lastColumn; j++) {
            if (filterRange.worksheet
                .getRangeByIndex(filterRange.row + 1, j)
                .cells
                .isEmpty) {
              break;
            }
          }
        }
      }
    }
    return filterRange;
  }

  /// Checks for non-empty adjacent cells
  /// which are above the existing filter range to find the top most row in the filter range.
  void _getTopAdjacents(int topRow, int leftColumn, int bottomRow,
      int rightColumn, Range filterRange) {
    late int row;
    if (topRow != 1)
      row = topRow - 1;
    else
      return;
    final int maxColumnCount = filterRange.workbook._maxRowCount;
    for (int column = leftColumn != 1 ? leftColumn - 1 : leftColumn;
        column <=
            (rightColumn != maxColumnCount ? rightColumn + 1 : rightColumn);
        column++) {
      if (filterRange.worksheet.getRangeByIndex(row, column).cells.isEmpty) {
        _hasAdjacents = true;
        _topRow = row;
        break;
      }
    }
  }

  /// Checks for non-empty adjacent cells
  /// which are left to the existing filter range to
  /// find the left most column in the filter range.
  void _getLeftAdjacents(int topRow, int leftColumn, int bottomRow,
      int rightColumn, Range filterRange) {
    int column;
    if (leftColumn != 1)
      column = leftColumn - 1;
    else
      return;
    final int maxRowCount = filterRange.workbook._maxRowCount;
    for (int row = topRow != 1 ? topRow - 1 : topRow;
        row <= (bottomRow != maxRowCount ? bottomRow + 1 : bottomRow);
        row++) {
      if (filterRange.worksheet.getRangeByIndex(row, column).cells.isEmpty) {
        _hasAdjacents = true;
        _leftColumn = column;
        break;
      }
    }
  }

  /// Includes adjacent non-empty cells in the bottom of the internal
  /// range object that stores filtered range.
  void _getBottomAdjacents(int topRow, int leftColumn, int bottomRow,
      int rightColumn, Range filterRange) {
    int row;

    if (bottomRow != filterRange.workbook._maxRowCount)
      row = bottomRow + 1;
    else
      return;
    final int maxColumnCount = filterRange.workbook._maxColumnCount;
    for (int column = leftColumn != 1 ? leftColumn - 1 : leftColumn;
        column <=
            (rightColumn != maxColumnCount ? rightColumn + 1 : rightColumn);
        column++) {
      if (filterRange.worksheet.getRangeByIndex(row, column).cells.isEmpty) {
        _hasAdjacents = true;
        _bottomRow = row;
        break;
      }
    }
  }

  /// Includes adjacent non-empty cells in the right of the internal range
  /// object that stores filtered range.
  void _getRightAdjacents(int topRow, int leftColumn, int bottomRow,
      int rightColumn, Range filterRange) {
    int column;
    if (rightColumn != filterRange.workbook._maxColumnCount)
      column = rightColumn + 1;
    else
      return;
    final int maxRowCount = filterRange.workbook._maxRowCount;
    for (int row = topRow != 1 ? topRow - 1 : topRow;
        row <= (bottomRow != maxRowCount ? bottomRow + 1 : bottomRow);
        row++) {
      if (filterRange.worksheet.getRangeByIndex(row, column).cells.isEmpty) {
        _hasAdjacents = true;
        _rightColumn = column;
        break;
      }
    }
  }

  ///Operator for get column index
  AutoFilter operator [](int columnIndex) {
    if (columnIndex > _innerList.length) {
      throw Exception('index Out of Range');
    }

    return _innerList[columnIndex] as _AutoFilterImpl;
  }

  ///Set range adjacents for Bottom column
  Range _includeBottomAdjacents(int topRow, int leftColumn, int bottomRow,
      int rightColumn, Range filterRange) {
    _initializeFilterRange(topRow, leftColumn, bottomRow, rightColumn);
    _hasAdjacents = false;
    _getBottomAdjacents(
        topRow, leftColumn, bottomRow, rightColumn, filterRange);
    filterRange = filterRange.worksheet
        .getRangeByIndex(_topRow, _leftColumn, _bottomRow, _rightColumn);
    if (_hasAdjacents)
      filterRange = _includeBottomAdjacents(
          _topRow, _leftColumn, _bottomRow, _rightColumn, filterRange);
    return filterRange;
  }
}
