import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../../officechart.dart';

/// Represent the Chart Text Area.
class ChartTextArea {
  /// Create an instances of [ChartTextArea] class.
  ChartTextArea(Object parent) {
    _parent = parent;
    if (_parent is Chart) {
      _chart = _parent as Chart;
    } else if (_parent is ChartCategoryAxis) {
      _chart = (_parent as ChartCategoryAxis).chart;
    } else if (_parent is ChartValueAxis) {
      _chart = (_parent as ChartValueAxis).chart;
    } else if (_parent is ChartSerie) {
      _chart = (_parent as ChartSerie).chart;
    }
    _createFont();
  }

  /// Represent the title name.
  String? text;

  /// Represent the color.
  String get color {
    return _font.color;
  }

  set color(String value) {
    _font.color = value;
  }

  /// Parent chart.
  // ignore: unused_field
  late Chart _chart;

  /// Parent object.
  late Object _parent;

  /// Reprent the font.
  late Font _font;

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

  // ignore: public_member_api_docs
  bool get hasText {
    return _hasText;
  }

  // ignore: public_member_api_docs
  bool get overlay {
    return _overlay;
  }

  /// Create a new font.
  void _createFont() {
    _font = Font();
  }
}
