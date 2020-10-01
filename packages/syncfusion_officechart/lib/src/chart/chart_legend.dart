part of officechart;

/// Represents an legend on the chart.
class ChartLegend {
  /// Create an instances of [ChartLegend] class.
  ChartLegend(Worksheet worksheet, Chart chart) {
    _worksheet = worksheet;
    _chart = chart;
  }

  /// Parent worksheet.
  Worksheet _sheet;

  set _worksheet(Worksheet value) {
    value = _sheet;
  }

  /// Parent chart.
  Chart _chart;

  /// Gets and sets the chart legend position.
  ExcelLegendPosition position;

  /// Represent the chart text area.
  ChartTextArea _textArea;

  /// Gets the chart legend have text area or not.
  bool get _hasTextArea {
    return _textArea != null;
  }

  /// Gets the chart legend text area.
  ChartTextArea get textArea {
    _textArea ??= ChartTextArea(_chart);
    return _textArea;
  }
}
