part of xlsio;

/// Represent cell individual border.
class Border {
  /// Gets/sets border line style.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// // set borders line.
  /// style.borders.all.lineStyle = LineStyle.thick;
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late LineStyle lineStyle;

  /// Gets/sets borderline color.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// // set borders line color.
  /// style.borders.all.lineStyle = LineStyle.thick;
  /// style.borders.all.color = '#9954CC';
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late String color;

  /// Gets/sets borderline color Rgb.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// // set borders line color.
  /// style.borders.all.lineStyle = LineStyle.thick;
  /// style.borders.all.colorRgb = Color.fromARBG(255, 255, 56, 255);
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late Color colorRgb;
}

/// Represent cell individual border.
class CellBorder implements Border {
  /// Creates a instance of Border
  CellBorder(this.lineStyle, String mcolor) {
    color = mcolor;
  }

  /// Gets/sets border line style.
  @override
  LineStyle lineStyle = LineStyle.none;

  String _color = '#000000';

  /// Gets/sets borderline color.
  @override
  String get color => _color;

  @override
  set color(String value) {
    _color = value;
    _colorRgb =
        Color(int.parse(_color.substring(1, 7), radix: 16) + 0xFF000000);
  }

  late Color _colorRgb;

  /// Gets/sets borderline color Rgb.
  @override
  Color get colorRgb => _colorRgb;

  @override
  set colorRgb(Color value) {
    _colorRgb = value;
    _color = _colorRgb.value.toRadixString(16).toUpperCase();
  }

  /// Clone method of Cell Border.
  CellBorder _clone() {
    final CellBorder cellBorder = CellBorder(lineStyle, color);
    return cellBorder;
  }
}

/// Represent wrapper class for cell individual border.
class CellBorderWrapper implements Border {
  /// Creates a instance of Border
  CellBorderWrapper(List<Border?> borders) {
    _borders = borders;
  }

  late List<Border?> _borders;

  /// Gets/sets border line style.
  final LineStyle _lineStyle = LineStyle.none;

  /// Gets/sets borderline color.
  final String _color = '#000000';

  /// Gets/sets borderline color Rgb.
  final Color _colorRgb = const Color.fromARGB(255, 0, 0, 0);

  /// Gets/sets border line style.
  @override
  LineStyle get lineStyle {
    LineStyle lineStyleStyle = _lineStyle;
    bool first = true;

    for (final Border? border in _borders) {
      if (first) {
        lineStyleStyle = border!.lineStyle;
        first = false;
      } else if (border!.lineStyle != lineStyleStyle) {
        return LineStyle.none;
      }
    }
    return lineStyleStyle;
  }

  @override
  set lineStyle(LineStyle value) {
    for (final Border? border in _borders) {
      border!.lineStyle = value;
    }
  }

  /// Gets/sets borderline color.
  @override
  String get color {
    String colorStyle = _color;
    bool first = true;

    for (final Border? border in _borders) {
      if (first) {
        colorStyle = border!.color;
        first = false;
      } else if (border!.color != colorStyle) {
        return '#000000';
      }
    }
    return colorStyle;
  }

  @override
  set color(String value) {
    for (final Border? border in _borders) {
      border!.color = value;
    }
  }

  /// Gets/sets borderline color Rgb.
  @override
  Color get colorRgb {
    Color colorStyle = _colorRgb;
    bool first = true;

    for (final Border? border in _borders) {
      if (first) {
        colorStyle = border!.colorRgb;
        first = false;
      } else if (border!.colorRgb != colorStyle) {
        return const Color.fromARGB(255, 0, 0, 0);
      }
    }
    return colorStyle;
  }

  @override
  set colorRgb(Color value) {
    for (final Border? border in _borders) {
      border!.colorRgb = value;
    }
  }
}
