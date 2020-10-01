part of officechart;

/// Represents chart plot area object.
class ChartPlotArea {
  /// Create an instances of [ChartPlotArea] class.
  ChartPlotArea(Worksheet worksheet, Chart chart) {
    _worksheet = worksheet;
    _chart = chart;
  }

  /// Parent worksheet.
  Worksheet _sheet;

  set _worksheet(Worksheet value) {
    value = _sheet;
  }

  /// Parent chart.
  // ignore: unused_field
  Chart _chart;

  /// Represent PlotArea border line property
  ExcelChartLinePattern linePattern = ExcelChartLinePattern.none;

  /// ChartArea border line color property
  String linePatternColor;
}
