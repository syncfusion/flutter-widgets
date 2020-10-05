part of xlsio;

/// Represents cell borders
class Borders {
  /// Represent the left border.
  Border left;

  /// Represent the right border.
  Border right;

  /// Represent the bottom border.
  Border bottom;

  /// Represent the top border.
  Border top;

  /// Represent the all borders.
  Border all;

  /// Represent the workbook.
  Workbook _workbook;
}

/// Represents cell borders
class BordersCollection implements Borders {
  /// Creates an new instances of borders.
  BordersCollection(Workbook book) {
    _workbook = book;
    left = CellBorder(LineStyle.none, '#000000');
    right = CellBorder(LineStyle.none, '#000000');
    top = CellBorder(LineStyle.none, '#000000');
    bottom = CellBorder(LineStyle.none, '#000000');
    all = CellBorder(LineStyle.none, '#000000');
  }

  /// Represent the left border.
  Border _left;

  /// Represent the right border.
  Border _right;

  /// Represent the bottom border.
  Border _bottom;

  /// Represent the top border.
  Border _top;

  /// Represent the all borders.
  Border _all;

  /// Represent the workbook.
  @override
  Workbook _workbook;

  /// Represent the left border.
  @override
  // ignore: unnecessary_getters_setters
  CellBorder get left {
    return _left;
  }

  @override
  // ignore: unnecessary_getters_setters
  set left(Border value) {
    _left = value;
  }

  /// Represent the right border.
  @override
  // ignore: unnecessary_getters_setters
  CellBorder get right {
    return _right;
  }

  @override
  // ignore: unnecessary_getters_setters
  set right(Border value) {
    _right = value;
  }

  /// Represent the bottom border.
  @override
  // ignore: unnecessary_getters_setters
  CellBorder get bottom {
    return _bottom;
  }

  @override
  // ignore: unnecessary_getters_setters
  set bottom(Border value) {
    _bottom = value;
  }

  /// Represents the top border.
  @override
  // ignore: unnecessary_getters_setters
  CellBorder get top {
    return _top;
  }

  @override
  // ignore: unnecessary_getters_setters
  set top(Border value) {
    _top = value;
  }

  /// Represent the all borders.
  @override
  // ignore: unnecessary_getters_setters
  CellBorder get all {
    return _all;
  }

  @override
  // ignore: unnecessary_getters_setters
  set all(Border value) {
    _all = value;
  }

  /// Clone method of BordersCollecton.
  BordersCollection _clone() {
    final BordersCollection bordersCollection = BordersCollection(_workbook);
    bordersCollection.all = all._clone();
    bordersCollection.left = left._clone();
    bordersCollection.right = right._clone();
    bordersCollection.top = top._clone();
    bordersCollection.bottom = bottom._clone();
    return bordersCollection;
  }

  /// Compares two instances of the Cell borders.
  @override
  bool operator ==(Object toCompare) {
    final BordersCollection toCompareBorders = toCompare;

    return (all.color == toCompareBorders.all.color &&
        all.lineStyle == toCompareBorders.all.lineStyle &&
        left.color == toCompareBorders.left.color &&
        left.lineStyle == toCompareBorders.left.lineStyle &&
        right.color == toCompareBorders.right.color &&
        right.lineStyle == toCompareBorders.right.lineStyle &&
        top.color == toCompareBorders.top.color &&
        top.lineStyle == toCompareBorders.top.lineStyle &&
        bottom.color == toCompareBorders.bottom.color &&
        bottom.lineStyle == toCompareBorders.bottom.lineStyle);
  }

  @override
  int get hashCode => hashValues(all, left, right, top, bottom);

  /// Crear all the borders.
  void _clear() {
    if (_all != null) {
      _all = null;
    }

    if (_left != null) {
      _left = null;
    }

    if (_right != null) {
      _right = null;
    }

    if (_top != null) {
      _top = null;
    }

    if (_bottom != null) {
      _bottom = null;
    }
  }
}

/// Represents cell borders
class BordersCollectionWrapper implements Borders {
  /// Creates an new instances of borders.
  BordersCollectionWrapper(List<Range> arrRanges, Workbook book) {
    _arrRanges = arrRanges;
    _workbook = book;
    _bordersCollection = [];
    for (final Range range in _arrRanges) {
      _bordersCollection.add(range.cellStyle.borders);
    }
  }

  /// Represent the left border.
  Border _left;

  /// Represent the right border.
  Border _right;

  /// Represent the bottom border.
  Border _bottom;

  /// Represent the top border.
  Border _top;

  /// Represent the all borders.
  Border _all;

  /// Represent the workbook.
  @override
  Workbook _workbook;

  List<Range> _arrRanges;
  List<Borders> _bordersCollection;

  /// Represent the left border.
  @override
  Border get left {
    if (_left == null) {
      final List<Border> borders = [];
      for (final Borders border in _bordersCollection) {
        borders.add(border.left);
      }
      _left = CellBorderWrapper(borders);
    }
    return _left;
  }

  @override
  set left(Border value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      range.cellStyle.borders.left = value;
    }
  }

  /// Represent the right border.
  @override
  Border get right {
    if (_right == null) {
      final List<Border> borders = [];
      for (final Borders border in _bordersCollection) {
        borders.add(border.right);
      }
      _right = CellBorderWrapper(borders);
    }
    return _right;
  }

  @override
  set right(Border value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      range.cellStyle.borders.right = value;
    }
  }

  /// Represent the bottom border.
  @override
  Border get bottom {
    if (_bottom == null) {
      final List<Border> borders = [];
      for (final Borders border in _bordersCollection) {
        borders.add(border.bottom);
      }
      _bottom = CellBorderWrapper(borders);
    }
    return _bottom;
  }

  @override
  set bottom(Border value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      range.cellStyle.borders.bottom = value;
    }
  }

  /// Represents the top border.
  @override
  Border get top {
    if (_top == null) {
      final List<Border> borders = [];
      for (final Borders border in _bordersCollection) {
        borders.add(border.top);
      }
      _top = CellBorderWrapper(borders);
    }
    return _top;
  }

  @override
  set top(Border value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      range.cellStyle.borders.top = value;
    }
  }

  /// Represent the all borders.
  @override
  Border get all {
    if (_all == null) {
      final List<Border> borders = [];
      for (final Borders border in _bordersCollection) {
        borders.add(border.all);
      }
      _all = CellBorderWrapper(borders);
    }
    return _all;
  }

  @override
  set all(Border value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      range.cellStyle.borders.all = value;
    }
  }

  /// Clear the borders.
  // ignore: unused_element
  void _clear() {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      (range.cellStyle.borders as BordersCollection)._clear();
    }
  }
}
