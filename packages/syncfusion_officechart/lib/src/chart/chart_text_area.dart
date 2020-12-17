part of officechart;

/// Represent the Chart Text Area.
class ChartTextArea {
  /// Create an instances of [ChartTextArea] class.
  ChartTextArea(Object _parent) {
    _parent = _parent;
    if (_parent is Chart) {
      _chart = _parent;
    } else if (_parent is ChartCategoryAxis) {
      _chart = (_parent)._chart;
    } else if (_parent is ChartValueAxis) {
      _chart = (_parent)._chart;
    } else if (_parent is ChartSerie) _chart = (_parent)._chart;
    _createFont();
  }

  /// Represent the title name.
  String text;

  /// Represent the color.
  String color;

  /// Parent chart.
  Chart _parentChart;

  set _chart(Chart value) {
    value = _parentChart;
  }

  /// Parent object.
  // ignore: unused_field
  Object _parent;

  /// Reprent the font.
  Font _font;

  /// Boolean value indicates whether other elements in chart can overlap this text area.
  final bool _overlay = false;

  /// Gets bold.
  bool get bold {
    return _font.bold;
  }

  /// Sets bold.
  set bold(bool value) {
    _font.bold = value;
  }

  /// Gets italic.
  bool get italic {
    return _font.italic;
  }

  /// Sets italic.
  set italic(bool value) {
    _font.italic = value;
  }

  /// Gets font size.
  double get size {
    return _font.size;
  }

  /// Sets font size.
  set size(double value) {
    _font.size = value;
  }

  /// Gets font name.
  String get fontName {
    return _font.name;
  }

  /// Sets font name.
  set fontName(String value) {
    _font.name = value;
  }

  /// Indicates whether text area contains text.
  bool get _hasText {
    return text != null;
  }

  /// Create a new font.
  void _createFont() {
    _font = Font();
  }
}
