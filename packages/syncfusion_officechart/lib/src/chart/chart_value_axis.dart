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
  // ignore: unused_field
  late Worksheet _worksheet;

  // Parent chart.
  late Chart _chart;
}
