part of officechart;

/// Represents chart plot area object.
class ChartPlotArea {
  /// Create an instances of [ChartPlotArea] class.
  ChartPlotArea(Worksheet worksheet, Chart chart) {
    _worksheet = worksheet;
    _chart = chart;
  }

  /// Parent worksheet.
  // ignore: unused_field
  late Worksheet _worksheet;

  /// Parent chart.
  // ignore: unused_field
  late Chart _chart;

  /// Represent PlotArea border line property
  ExcelChartLinePattern linePattern = ExcelChartLinePattern.none;

  /// ChartArea border line color property
  String? linePatternColor;
}
