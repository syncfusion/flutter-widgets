part of officechart;

/// Represents an axis on the chart.
class ChartCategoryAxis extends ChartAxis {
  /// Create an instances of [ChartCategoryAxis] class.
  ChartCategoryAxis(Worksheet worksheet, Chart chart) {
    _sheet = worksheet;
    _chart = chart;
    super._parentChart = _chart;
  }

  /// Parent worksheet.
  // ignore: unused_field
  late Worksheet _sheet;

  /// True to cut unused plot area. otherwise False. Default for area and surface charts.
  // ignore: prefer_final_fields
  bool _isBetween = false;

  /// Parent chart.
  late Chart _chart;

  /// sets the category labels for the chart.
  // ignore: avoid_setters_without_getters
  set _categoryLabels(Range? value) {
    final ChartSeriesCollection coll = _chart.series;
    final int iLen = coll.count;
    for (int i = 0; i < iLen; i++) {
      coll[i]._categoryLabels = value;
    }
  }
}
