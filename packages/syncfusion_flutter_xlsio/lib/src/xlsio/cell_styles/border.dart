part of xlsio;

/// Represent cell individual border.
class Border {
  /// Gets/sets border line style.
  LineStyle lineStyle;

  /// Gets/sets borderline color.
  String color;
}

/// Represent cell individual border.
class CellBorder implements Border {
  /// Creates a instance of Border
  CellBorder(LineStyle mline, String mcolor) {
    lineStyle = mline;
    color = mcolor;
  }

  /// Gets/sets border line style.
  @override
  LineStyle lineStyle = LineStyle.none;

  /// Gets/sets borderline color.
  @override
  String color = '#000000';

  /// Clone method of Cell Border.
  CellBorder clone() {
    final CellBorder cellBorder = CellBorder(lineStyle, color);
    return cellBorder;
  }
}

/// Represent wrapper class for cell individual border.
class CellBorderWrapper implements Border {
  /// Creates a instance of Border
  CellBorderWrapper(List<Border> borders) {
    _borders = borders;
  }

  List<Border> _borders;

  /// Gets/sets border line style.
  final LineStyle _lineStyle = LineStyle.none;

  /// Gets/sets borderline color.
  final String _color = '#000000';

  /// Gets/sets border line style.
  @override
  LineStyle get lineStyle {
    LineStyle lineStyleStyle = _lineStyle;
    bool first = true;

    for (final Border border in _borders) {
      if (first) {
        lineStyleStyle = border.lineStyle;
        first = false;
      } else if (border.lineStyle != lineStyleStyle) {
        return LineStyle.none;
      }
    }
    return lineStyleStyle;
  }

  @override
  set lineStyle(LineStyle value) {
    for (final Border border in _borders) {
      border.lineStyle = value;
    }
  }

  /// Gets/sets borderline color.
  @override
  String get color {
    String colorStyle = _color;
    bool first = true;

    for (final Border border in _borders) {
      if (first) {
        colorStyle = border.color;
        first = false;
      } else if (border.color != colorStyle) {
        return '#000000';
      }
    }
    return colorStyle;
  }

  @override
  set color(String value) {
    for (final Border border in _borders) {
      border.color = value;
    }
  }
}
