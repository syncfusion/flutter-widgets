part of officechart;

/// This class represents ChartSeries object.
class ChartSerie {
  /// Create an instances of [ChartSerie] class.
  ChartSerie(Worksheet worksheet, Chart chart) {
    _worksheet = worksheet;
    _chart = chart;
  }

  /// Parent worksheet.
  // ignore: unused_field
  late Worksheet _worksheet;

  /// Parent chart.
  late Chart _chart;

  /// Represent the serie name.
  String? name;

  ///Represents chart series format
  ChartSerieDataFormat? _chartSeriesDataFormat;

  /// serie name.
  late int _index;

  /// serie name or formula.
  // ignore: prefer_final_fields
  String _nameOrFormula = '';

  /// Check if the serie name is default.
  // ignore: prefer_final_fields
  bool _isDefaultName = false;

  /// Chart Range Values
  Range? _values;

  /// Chart Range Values
  Range? _categoryLabels;

  /// Chart DataLabels
  ChartDataLabels? _dataLabels;

  /// Represents the PlotArea border line property
  ExcelChartLinePattern linePattern = ExcelChartLinePattern.none;

  /// ChartArea border line color property
  String? linePatternColor;

  /// Chart type for the series.
  ExcelChartType get _serieType {
    return _chart.chartType;
  }

  ///Represents chart serie format.
  ChartSerieDataFormat get serieFormat {
    return _chartSeriesDataFormat ??= _ChartSerieDataFormatImpl(_chart);
  }

  /// Gets chart text area object.
  ///
  /// ```dart
  /// Workbook workbook = Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1').text = 'Items';
  /// sheet.getRangeByName('B1').text = 'Count';
  /// sheet.getRangeByName('A2').text = 'Beverages';
  /// sheet.getRangeByName('A3').text = 'Condiments';
  /// sheet.getRangeByName('A4').text = 'Confections';
  /// sheet.getRangeByName('B2').number = 2776;
  /// sheet.getRangeByName('B3').number = 1077;
  /// sheet.getRangeByName('B4').number = 2287;
  /// ChartCollection charts = new ChartCollection(sheet);
  /// Chart chart = charts.add();
  /// chart.chartType = ExcelChartType.line;
  /// chart.dataRange = sheet.getRangeByName('A1:B4');
  /// ChartSerie serie = chart.series[0];
  /// serie.dataLabels.IsValue = true;
  /// serie.dataLabels.textArea.size = 12;
  /// serie.dataLabels.textArea.bold = true;
  /// serie.dataLabels.textArea.color = '#0000A0';
  /// serie.linePattern = ExcelChartLinePattern.dash;
  /// chart.isSeriesInRows = false;
  /// sheet.charts = charts;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('Chart.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  ChartDataLabels get dataLabels {
    return _dataLabels ??= ChartDataLabels(this);
  }
}
