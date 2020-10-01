part of officechart;

/// Represents an axis on the chart.
class ChartValueAxis extends ChartAxis {
  /// Create an instances of [ChartValueAxis] class.
  ChartValueAxis(Worksheet worksheet, Chart chart) {
    _worksheet = worksheet;
    _chart = chart;
    super._parentChart = _chart;
  }

  // Parent worksheet.
  Worksheet _sheet;

  set _worksheet(Worksheet value) {
    value = _sheet;
  }

  // Parent chart.
  Chart _chart;
}
