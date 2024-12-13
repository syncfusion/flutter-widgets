import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:xml/xml.dart';

import '../../officechart.dart';

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
    chart.series = ChartSeriesCollection(_worksheet, chart);
    chart.primaryCategoryAxis = ChartCategoryAxis(_worksheet, chart);
    chart.primaryValueAxis = ChartValueAxis(_worksheet, chart);
    chart.primaryValueAxis.hasMajorGridLines = true;
    chart.plotArea = ChartPlotArea(_worksheet, chart);
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

    _chartSerialization!.saveCharts(sheet);
  }

  /// Serialize the charts.
  @override
  Future<void> serializeCharts(Worksheet sheet) async {
    _chartSerialization ??= ChartSerialization(sheet.workbook);

    _chartSerialization!.saveChartsAsync(sheet);
  }

  /// Serialize the chart drawings.
  @override
  void serializeChartDrawingSync(XmlBuilder builder, Worksheet sheet) {
    _chartSerialization ??= ChartSerialization(sheet.workbook);

    _chartSerialization!.serializeChartDrawing(builder, sheet);
  }

  /// Serialize the chart drawings.
  @override
  Future<void> serializeChartDrawing(
      XmlBuilder builder, Worksheet sheet) async {
    _chartSerialization ??= ChartSerialization(sheet.workbook);

    _chartSerialization!.serializeChartDrawingAsync(builder, sheet);
  }
}
