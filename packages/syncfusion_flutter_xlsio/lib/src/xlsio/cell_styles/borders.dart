part of xlsio;

/// Represents cell borders
class Borders {
  /// Represent the left border.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// // set borders line style and color.
  /// style.borders.left.lineStyle = LineStyle.thick;
  /// style.borders.left.color = '#9954CC';
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late Border left;

  /// Represent the right border.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// // set borders line style and color.
  /// style.borders.right.lineStyle = LineStyle.thick;
  /// style.borders.right.color = '#9954CC';
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late Border right;

  /// Represent the bottom border.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// // set borders line style and color.
  /// style.borders.bottom.lineStyle = LineStyle.thick;
  /// style.borders.bottom.color = '#9954CC';
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late Border bottom;

  /// Represent the top border.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// // set borders line style and color.
  /// style.borders.all.lineStyle = LineStyle.thick;
  /// style.borders.all.color = '#9954CC';
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late Border top;

  /// Represent the all borders.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// // set borders line style and color.
  /// style.borders.all.lineStyle = LineStyle.thick;
  /// style.borders.all.color = '#9954CC';
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late Border all;

  /// Represent the workbook.
  late Workbook _workbook;
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
  late Border _left;

  /// Represent the right border.
  late Border _right;

  /// Represent the bottom border.
  late Border _bottom;

  /// Represent the top border.
  late Border _top;

  /// Represent the all borders.
  late Border _all;

  /// Represent the workbook.
  @override
  late Workbook _workbook;

  /// Represent the left border.
  @override
  // ignore: unnecessary_getters_setters
  Border get left {
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
  Border get right {
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
  Border get bottom {
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
  Border get top {
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
  Border get all {
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
    bordersCollection.all = (all as CellBorder)._clone();
    bordersCollection.left = (left as CellBorder)._clone();
    bordersCollection.right = (right as CellBorder)._clone();
    bordersCollection.top = (top as CellBorder)._clone();
    bordersCollection.bottom = (bottom as CellBorder)._clone();
    return bordersCollection;
  }

  /// Compares two instances of the Cell borders.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object toCompare) {
    // ignore: test_types_in_equals
    final BordersCollection toCompareBorders = toCompare as BordersCollection;

    return all.color == toCompareBorders.all.color &&
        all.colorRgb == toCompareBorders.all.colorRgb &&
        all.lineStyle == toCompareBorders.all.lineStyle &&
        left.color == toCompareBorders.left.color &&
        left.colorRgb == toCompareBorders.left.colorRgb &&
        left.lineStyle == toCompareBorders.left.lineStyle &&
        right.color == toCompareBorders.right.color &&
        right.colorRgb == toCompareBorders.right.colorRgb &&
        right.lineStyle == toCompareBorders.right.lineStyle &&
        top.color == toCompareBorders.top.color &&
        top.colorRgb == toCompareBorders.top.colorRgb &&
        top.lineStyle == toCompareBorders.top.lineStyle &&
        bottom.color == toCompareBorders.bottom.color &&
        bottom.colorRgb == toCompareBorders.bottom.colorRgb &&
        bottom.lineStyle == toCompareBorders.bottom.lineStyle;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hash(all, left, right, top, bottom);

  /// Crear all the borders.
  void _clear() {}
}

/// Represents cell borders
class BordersCollectionWrapper implements Borders {
  /// Creates an new instances of borders.
  BordersCollectionWrapper(List<Range> arrRanges, Workbook book) {
    _arrRanges = arrRanges;
    _workbook = book;
    _bordersCollection = <Borders>[];
    for (final Range range in _arrRanges) {
      _bordersCollection.add(range.cellStyle.borders);
    }
  }

  /// Represent the left border.
  Border? _left;

  /// Represent the right border.
  Border? _right;

  /// Represent the bottom border.
  Border? _bottom;

  /// Represent the top border.
  Border? _top;

  /// Represent the all borders.
  Border? _all;

  /// Represent the workbook.
  @override
  late Workbook _workbook;

  late List<Range> _arrRanges;
  late List<Borders> _bordersCollection;

  /// Represent the left border.
  @override
  Border get left {
    if (_left == null) {
      final List<Border> borders = <Border>[];
      for (final Borders border in _bordersCollection) {
        borders.add(border.left);
      }
      _left = CellBorderWrapper(borders);
    }
    return _left!;
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
      final List<Border?> borders = <Border?>[];
      for (final Borders border in _bordersCollection) {
        borders.add(border.right);
      }
      _right = CellBorderWrapper(borders);
    }
    return _right!;
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
      final List<Border?> borders = <Border?>[];
      for (final Borders border in _bordersCollection) {
        borders.add(border.bottom);
      }
      _bottom = CellBorderWrapper(borders);
    }
    return _bottom!;
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
      final List<Border?> borders = <Border?>[];
      for (final Borders border in _bordersCollection) {
        borders.add(border.top);
      }
      _top = CellBorderWrapper(borders);
    }
    return _top!;
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
      final List<Border?> borders = <Border?>[];
      for (final Borders border in _bordersCollection) {
        borders.add(border.all);
      }
      _all = CellBorderWrapper(borders);
    }
    return _all!;
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
