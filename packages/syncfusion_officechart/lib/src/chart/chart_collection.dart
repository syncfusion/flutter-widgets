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
    _innerList = [];
  }

  /// Parent worksheet.
  Worksheet _worksheet;

  /// Parent Serializer
  ChartSerialization _chartSerialization;

  /// Parent Chart .
  Chart _chart;

  /// Inner list.
  List<Chart> _innerList;

  /// Represents parent worksheet.
  Worksheet get worksheet {
    return _worksheet;
  }

  /// Represents parent Chart .
  Chart get chart {
    return _chart;
  }

  /// Represents the innerlist
  List<Chart> get innerList {
    return _innerList;
  }

  /// Returns the count of chart collection.
  int get count {
    return _innerList.length;
  }

  /// Indexer of the class
  Chart operator [](index) => innerList[index];

  /// Add chart to the chart collection.
  ///
  /// ```dart
  /// Workbook workbook = Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// ChartCollection chart = ChartCollection(sheet);
  /// chart.add();
  /// sheet.charts = chart;
  /// workbook.save('EmptyChart.xlsx');
  /// ```
  Chart add() {
    final Chart chart = Chart(_worksheet);
    chart._series = ChartSeriesCollection(worksheet, chart);
    chart._primaryCategoryAxis = ChartCategoryAxis(worksheet, chart);
    chart._primaryValueAxis = ChartValueAxis(worksheet, chart);
    chart._plotArea = ChartPlotArea(worksheet, chart);
    innerList.add(chart);
    chart.name = 'Chart' + innerList.length.toString();
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
  void serializeCharts(Worksheet sheet) {
    _chartSerialization ??= ChartSerialization(sheet.workbook);

    _chartSerialization.saveCharts(sheet);
  }

  /// Serialize the chart drawings.
  @override
  void serializeChartDrawing(XmlBuilder builder, Worksheet sheet) {
    _chartSerialization ??= ChartSerialization(sheet.workbook);

    _chartSerialization.serializeChartDrawing(builder, sheet);
  }
}
