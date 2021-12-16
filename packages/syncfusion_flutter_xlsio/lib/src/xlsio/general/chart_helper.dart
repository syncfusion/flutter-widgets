part of xlsio;

/// Base class for charts
abstract class ChartHelper {
  /// Serialize the charts.
  void serializeCharts(Worksheet sheet);

  /// Serialize the chart drawings
  void serializeChartDrawing(XmlBuilder builder, Worksheet sheet);
}
