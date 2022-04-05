part of officechart;

/// Represents an legend on the chart.
class ChartLegend {
  /// Create an instances of [ChartLegend] class.
  ChartLegend(Worksheet worksheet, Chart chart) {
    _worksheet = worksheet;
    _chart = chart;
  }

  /// Parent worksheet.
  // ignore: unused_field
  late Worksheet _worksheet;

  /// Parent chart.
  late Chart _chart;

  /// Gets and sets the chart legend position.
  ExcelLegendPosition position = ExcelLegendPosition.right;

  /// Represent the chart text area.
  ChartTextArea? _textArea;

  /// Gets the chart legend have text area or not.
  bool get _hasTextArea {
    return _textArea != null;
  }

  /// Gets the chart legend text area.
  ChartTextArea get textArea {
    _textArea ??= ChartTextArea(_chart);
    return _textArea!;
  }
}
