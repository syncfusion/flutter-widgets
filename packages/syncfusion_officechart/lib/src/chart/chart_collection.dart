part of officechart;

/// Represents the worksheet rows.
class ChartCollection extends ChartHelper {
  /// Create a instance of [ChartCollection] class.
  ///
  /// ```dart
  /// Workbook workbook = Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// ChartCollection charts = ChartCollection(sheet);
  /// ```
  ChartCollection(Worksheet worksheet) {
    _worksheet = worksheet;
    _innerList = <Chart>[];
  }

  /// Parent worksheet.
  late Worksheet _worksheet;

  /// Represents parent worksheet.
  Worksheet get worksheet {
    return _worksheet;
  }

  /// Parent Serializer
  ChartSerialization? _chartSerialization;

  /// Inner list.
  late List<Chart> _innerList;

  /// Represents the innerlist
  List<Chart> get innerList {
    return _innerList;
  }

  /// Returns the count of chart collection.
  int get count {
    return _innerList.length;
  }

  /// Indexer of the class
  Chart operator [](dynamic index) => innerList[index];

  /// Add chart to the chart collection.
  ///
  /// ```dart
  /// Workbook workbook = Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// ChartCollection chart = ChartCollection(sheet);
  /// chart.add();
  /// sheet.charts = chart;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('EmptyChart.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  Chart add() {
    final Chart chart = Chart(_worksheet);
    chart._series = ChartSeriesCollection(_worksheet, chart);
    chart._primaryCategoryAxis = ChartCategoryAxis(_worksheet, chart);
    chart._primaryValueAxis = ChartValueAxis(_worksheet, chart);
    chart._primaryValueAxis.hasMajorGridLines = true;
    chart._plotArea = ChartPlotArea(_worksheet, chart);
    innerList.add(chart);
    chart.name = 'Chart${innerList.length}';
    chart.index = innerList.length;
    chart.topRow = 0;
    chart.bottomRow = 19;
    chart.leftColumn = 0;
    chart.rightColumn = 9;
    chart.primaryCategoryAxis.numberFormat = 'General';
    chart.primaryValueAxis.numberFormat = 'General';
    _worksheet.chartCount++;
    return chart;
  }

  /// Serialize the charts.
  @override
  void serializeChartsSync(Worksheet sheet) {
    _chartSerialization ??= ChartSerialization(sheet.workbook);

    _chartSerialization!._saveCharts(sheet);
  }

  /// Serialize the charts.
  @override
  Future<void> serializeCharts(Worksheet sheet) async {
    _chartSerialization ??= ChartSerialization(sheet.workbook);

    _chartSerialization!._saveChartsAsync(sheet);
  }

  /// Serialize the chart drawings.
  @override
  void serializeChartDrawingSync(XmlBuilder builder, Worksheet sheet) {
    _chartSerialization ??= ChartSerialization(sheet.workbook);

    _chartSerialization!._serializeChartDrawing(builder, sheet);
  }

  /// Serialize the chart drawings.
  @override
  Future<void> serializeChartDrawing(
      XmlBuilder builder, Worksheet sheet) async {
    _chartSerialization ??= ChartSerialization(sheet.workbook);

    _chartSerialization!._serializeChartDrawingAsync(builder, sheet);
  }
}
