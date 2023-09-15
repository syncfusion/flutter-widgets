part of xlsio;

/// Base class for charts
abstract class ChartHelper {
  /// Serialize the charts.
  void serializeChartsSync(Worksheet sheet);

  /// Serialize the charts.
  Future<void> serializeCharts(Worksheet sheet);

  /// Serialize the chart drawings
  void serializeChartDrawingSync(XmlBuilder builder, Worksheet sheet);

  /// Serialize the chart drawings
  void serializeChartDrawing(XmlBuilder builder, Worksheet sheet);
}
