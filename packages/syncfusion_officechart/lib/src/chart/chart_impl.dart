part of officechart;

/// Represents a chart sheet in the workbook.
class Chart {
  /// Create an instances of [Chart] class.
  Chart(Worksheet sheet) {
    _worksheet = sheet;
    _createChartTitle();
    hasLegend = true;
  }

  /// Represents chart plot area.
  ChartPlotArea? _plotArea;

  /// Parent worksheet.
  late Worksheet _worksheet;

  /// DataRange for the chart series.
  Range? _dataRange;

  /// DataRange for the chart serieValues used in helper methods.
  Range? _serieValue;

  /// True if series are in rows in DataRange;
  /// otherwise False.
  bool _bSeriesInRows = true;

  /// Collection of all the series of this chart.
  late ChartSeriesCollection _series;

  /// Get or Set primaryCategoryAxis
  late ChartCategoryAxis _primaryCategoryAxis;

  /// Get or Set primary value axis
  late ChartValueAxis _primaryValueAxis;

  /// Represent the chart text area object.
  ChartTextArea? _textArea;

  /// Represent the default chart title name.
  final String _defaultChartTitle = 'Chart Title';

  /// Represent the indicates whether show the legend or not.
  bool _bHasLegend = false;

  /// Represent the chart legend.
  ChartLegend? _legend;

  /// Represent the clustered chart collection.
  final List<ExcelChartType> _chartsCluster = <ExcelChartType>[
    ExcelChartType.bar,
    ExcelChartType.column,
    ExcelChartType.columnClustered3D,
    ExcelChartType.barClustered3D
  ];

  /// Represent the stacked chart collection.
  final List<ExcelChartType> _stackedCharts = <ExcelChartType>[
    ExcelChartType.barStacked,
    ExcelChartType.columnStacked,
    ExcelChartType.lineStacked,
    ExcelChartType.lineMarkersStacked,
    ExcelChartType.areaStacked,
    ExcelChartType.columnStacked3D,
    ExcelChartType.barStacked3D
  ];

  /// Represent 100% charts.Here each value in a series is shown as a portion of 100%.
  final List<ExcelChartType> _charts100 = <ExcelChartType>[
    ExcelChartType.columnStacked100,
    ExcelChartType.barStacked100,
    ExcelChartType.lineStacked100,
    ExcelChartType.areaStacked100,
    ExcelChartType.columnStacked1003D,
    ExcelChartType.barStacked1003D,
    ExcelChartType.areaStacked100,
    ExcelChartType.lineMarkersStacked100,
  ];

  /// Chart type.
  ExcelChartType _chartType = ExcelChartType.column;

  ///Indicated wheather chart type is 3D
  bool _is3DChart = false;

  ///Indicates wheather chart type is bar/column
  bool _isColumnOrBar = false;

  /// Indicates whether rotation has default value.
  bool _isDefaultRotation = true;

  /// Indicates whether elevation has default value.
  bool _isdefaultElevation = true;

  ///Represents rotation of 3D chart
  int _rotation = 20;

  ///Represents perspective of 3D chart
  int _perspective = 15;

  ///Represents elvation angle of  3D chart
  int _elevationAngle = 15;

  /// Depth of points relative to width.
  int _depthPercent = 100;

  ///Indicates whether the chart axes are at right angles, independent of chart rotation or elevation.
  bool _rightAngleAxes = false;

  /// Represent chart index.
  late int index;

  /// Represents the chart top row.
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
  /// ChartCollection charts = ChartCollection(sheet);
  /// Chart chart = charts.add();
  /// chart.chartType = ExcelChartType.bar;
  /// chart.dataRange = sheet.getRangeByName('A1:B4');
  /// chart.topRow = 8;
  /// sheet.charts = charts;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('Chart.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late int topRow;

  /// Represent the chart left colunm.
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
  /// ChartCollection charts = ChartCollection(sheet);
  /// Chart chart = charts.add();
  /// chart.chartType = ExcelChartType.bar;
  /// chart.dataRange = sheet.getRangeByName('A1:B4');
  /// chart.leftColumn = 4;
  /// sheet.charts = charts;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('Chart.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late int leftColumn;

  /// Represent the chart bottom row.
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
  /// ChartCollection charts = ChartCollection(sheet);
  /// Chart chart = charts.add();
  /// chart.chartType = ExcelChartType.bar;
  /// chart.dataRange = sheet.getRangeByName('A1:B4');
  /// chart.bottomRow = 10;
  /// sheet.charts = charts;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('Chart.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late int bottomRow;

  /// Represents the chart right colunm.
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
  /// ChartCollection charts = ChartCollection(sheet);
  /// Chart chart = charts.add();
  /// chart.chartType = ExcelChartType.bar;
  /// chart.dataRange = sheet.getRangeByName('A1:B4');
  /// chart.rightColumn = 8;
  /// sheet.charts = charts;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('Chart.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  int rightColumn = 0;

  /// Excel chart type
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
  /// chart.chartType = ExcelChartType.pie;
  /// chart.dataRange = sheet.getRangeByName('A1:B4');
  /// chart.isSeriesInRows = false;
  /// sheet.charts = charts;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('ChartType.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  ExcelChartType get chartType {
    return _chartType;
  }

  set chartType(ExcelChartType value) {
    _chartType = value;
    if (!_chartType.toString().contains('area')) {
      _primaryCategoryAxis._isBetween = true;
    }
    if (value.toString().endsWith('3D')) {
      _is3DChart = true;
    }
    if (value.toString().contains('column') ||
        value.toString().contains('bar')) {
      _isColumnOrBar = true;
    }
  }

  /// Gets the boolean value to display the chart legend, True by default.
  bool get hasLegend {
    return _bHasLegend;
  }

  ///sets the boolean value to display the chart legend, True by default.
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1').text = 'Items';
  /// sheet.getRangeByName('B1').text = 'Count';
  /// sheet.getRangeByName('A2').text = 'Beverages';
  /// sheet.getRangeByName('A3').text = 'Condiments';
  /// sheet.getRangeByName('A4').text = 'Confections';
  /// sheet.getRangeByName('B2').number = 2776;
  /// sheet.getRangeByName('B3').number = 1077;
  /// sheet.getRangeByName('B4').number = 2287;
  /// ChartCollection charts = ChartCollection(sheet);
  /// Chart chart = charts.add();
  /// chart.chartType = ExcelChartType.bar;
  /// chart.dataRange = sheet.getRangeByName('A1:B4');
  /// chart.hasLegend = false;
  /// sheet.charts = charts;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('ChartHasLegend.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  set hasLegend(bool value) {
    if (_bHasLegend != value) {
      _bHasLegend = value;
      _legend = value ? ChartLegend(_worksheet, this) : null;
    }
  }

  /// Represents ChartArea border line property.
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
  /// ChartCollection charts = ChartCollection(sheet);
  /// Chart chart = charts.add();
  /// chart.chartType = ExcelChartType.bar;
  /// chart.dataRange = sheet.getRangeByName('A1:B4');
  /// chart.linePattern = ExcelChartLinePattern.dashDot;
  /// sheet.charts = charts;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('ChartLinePattern.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  ExcelChartLinePattern linePattern = ExcelChartLinePattern.none;

  ///  ChartArea border line color property.
  /// ``` dart
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
  /// ChartCollection charts = ChartCollection(sheet);
  /// Chart chart = charts.add();
  /// chart.chartType = ExcelChartType.bar;
  /// chart.dataRange = sheet.getRangeByName('A1:B4');
  /// chart.linePattern = ExcelChartLinePattern.dashDot;
  /// chart.linePatternColor = "#FFFF00";
  /// sheet.charts = charts;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('ChartLineColor.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  String? linePatternColor;

  /// Gets the chart legend.
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
  /// ChartCollection charts = ChartCollection(sheet);
  /// Chart chart = charts.add();
  /// chart.chartType = ExcelChartType.bar;
  /// chart.dataRange = sheet.getRangeByName('A1:B4');
  /// chart.legend.position = ExcelLegendPosition.bottom;
  /// sheet.charts = charts;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('ChartLegendPosition.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  ChartLegend? get legend {
    return _legend;
  }

  /// Represents charts name.
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
  /// ChartCollection charts = ChartCollection(sheet);
  /// Chart chart = charts.add();
  /// chart.chartType = ExcelChartType.bar;
  /// chart.name = "Sales";
  /// chart.dataRange = sheet.getRangeByName('A1:B4');
  /// sheet.charts = charts;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('ChartName.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late String name;

  /// Gets chart text area.
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
  /// chart.chartType = ExcelChartType.bar;
  /// chart.dataRange = sheet.getRangeByName('A1:B4');
  /// chart.chartTitleArea.bold = true;
  /// chart.chartTitleArea.italic = true;
  /// chart.chartTitleArea.size = 15;
  /// chart.chartTitleArea.fontName = 'Arial';
  /// sheet.charts = charts;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('ChartTitleArea.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  ChartTextArea get chartTitleArea {
    if (_textArea == null) {
      _createChartTitle();
    }
    return _textArea!;
  }

  /// Gets chart title.
  String? get chartTitle {
    return chartTitleArea.text;
  }

  /// sets chart title.
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
  /// chart.chartType = ExcelChartType.bar;
  /// chart.dataRange = sheet.getRangeByName('A1:B4');
  /// chart.chartTitle = 'Sales';
  /// sheet.charts = charts;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('ChartTitle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  set chartTitle(String? value) {
    chartTitleArea.text = value;
  }

  /// Gets indicates whether to display chart title or not.
  bool get hasTitle {
    bool result = false;
    if (_textArea != null) {
      if (_textArea!.text != null) {
        result = true;
      }
    }
    return result;
  }

  /// Sets indicates whether to display chart title or not.
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
  /// chart.chartType = ExcelChartType.bar;
  /// chart.dataRange = sheet.getRangeByName('A1:B4');
  /// chart.hasTitle = true;
  /// sheet.charts = charts;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('ChartHasTitle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  set hasTitle(bool value) {
    if (_textArea != null) {
      if (value && _textArea!.text == null) {
        _textArea!.text = _defaultChartTitle;
      } else if (!value) {
        _textArea!.text = null;
      }
    }
  }

  /// Gets a boolean value indicating whether the chart has plot area.
  bool get _hasPlotArea {
    return _plotArea != null;
  }

  /// True if chart has a category axis. False otherwise. Read-only.
  bool get _isCategoryAxisAvail {
    return true;
  }

  /// True if chart has a value axis. False otherwise. Read-only.
  bool get _isValueAxisAvail {
    return true;
  }

  /// True if chart has a series in row. False otherwise. Read-only.
  bool get isSeriesInRows {
    return _bSeriesInRows;
  }

  /// Sets chart has a series in row.
  ///  ```dart
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
  /// ChartCollection charts = ChartCollection(sheet);
  /// Chart chart = charts.add();
  /// chart.chartType = ExcelChartType.bar;
  /// chart.dataRange = sheet.getRangeByName('A1:B4');
  /// chart.isSeriesInRows = false;
  /// sheet.charts = charts;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('Chart.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  set isSeriesInRows(bool value) {
    final int iCount = _series.count;

    if (dataRange == null && iCount != 0) {
      final Error error = ArgumentError(
          'This property supported only in chart where can detect data range.');
      throw error;
    }

    if (_bSeriesInRows != value) {
      _bSeriesInRows = value;

      if (iCount != 0) {
        _onDataRangeChanged(chartType);
      }
    }
  }

  /// True if chart is a bar chart. False otherwise. Read-only.
  bool get isChartBar {
    return chartType == ExcelChartType.pie;
  }

  /// Get a plotArea
  ///
  ///  ```dart
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
  /// ChartCollection charts = ChartCollection(sheet);
  /// Chart chart = charts.add();
  /// chart.chartType = ExcelChartType.bar;
  /// chart.dataRange = sheet.getRangeByName('A1:B4');
  /// chart.isSeriesInRows = false;
  /// chart.plotArea.linePattern = ExcelChartLinePattern.dashDot;
  /// chart.plotArea.linePatternColor = '#0000FF';
  /// sheet.charts = charts;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('Chart.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  ChartPlotArea get plotArea {
    return _plotArea!;
  }

  /// Get the primaryCategoryAxis
  ///
  ///  ```dart
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
  /// ChartCollection charts = ChartCollection(sheet);
  /// Chart chart = charts.add();
  /// chart.chartType = ExcelChartType.bar;
  /// chart.dataRange = sheet.getRangeByName('A1:B4');
  /// chart.isSeriesInRows = false;
  /// chart.primaryCategoryAxis.title = 'X axis';
  /// chart.primaryCategoryAxis.titleArea.bold = true;
  /// sheet.charts = charts;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('Chart.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  ChartCategoryAxis get primaryCategoryAxis {
    return _primaryCategoryAxis;
  }

  /// Get the primary value axis.
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
  /// ChartCollection charts = ChartCollection(sheet);
  /// Chart chart = charts.add();
  /// chart.chartType = ExcelChartType.bar;
  /// chart.dataRange = sheet.getRangeByName('A1:B4');
  /// chart.isSeriesInRows = false;
  /// chart.primaryValueAxis.title = 'Y axis';
  /// chart.primaryValueAxis.titleArea.bold = true;
  /// sheet.charts = charts;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('Chart.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  ChartValueAxis get primaryValueAxis {
    return _primaryValueAxis;
  }

  ///  Gets the collection of series of the chart. Read-only.
  ChartSeriesCollection get series {
    return _series;
  }

  /// Gets the data range for the chart series.
  Range? get dataRange {
    return _dataRange;
  }

  /// sets the data range for the chart series.
  ///
  ///  ```dart
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
  /// ChartCollection charts = ChartCollection(sheet);
  /// Chart chart = charts.add();
  /// chart.chartType = ExcelChartType.bar;
  /// chart.dataRange = sheet.getRangeByName('A1:B4');
  /// sheet.charts = charts;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('Chart.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  set dataRange(Range? value) {
    if (_dataRange != value) {
      _dataRange = value;
      if (value == null) {
        return;
      }
      final ExcelChartType type = chartType;
      _onDataRangeChanged(type);

      //ChartSerie serie = m_series[0];
    }
  }

  /// sets the rotation of the 3D chart view
  /// (the rotation of the plot area around the z-axis, in degrees)-(0 to 360 degrees).
  /// The value of this property must be from 0 to 360, except for 3-D bar charts,
  /// where the value must be from 0 to 44. The default value is 20. Applies only to 3-D charts.
  /// The following code illustrates how to set <see cref="Rotation"/> for 3-D charts.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A11').text = 'Venue';
  /// sheet.getRangeByName('A12').text = 'Seating & Decor';
  /// sheet.getRangeByName('A13').text = 'Technical Team';
  /// sheet.getRangeByName('A14').text = 'performers';
  /// sheet.getRangeByName('A15').text = "performer's Transport";
  /// sheet.getRangeByName('A16').text = "performer's stay";
  /// sheet.getRangeByName('A17').text = 'Marketing';
  /// sheet.getRangeByName('B11:B17').numberFormat = r'$#,##0_)';
  /// sheet.getRangeByName('B11').number = 17500;
  /// sheet.getRangeByName('B12').number = 1828;
  /// sheet.getRangeByName('B13').number = 800;
  /// sheet.getRangeByName('B14').number = 14000;
  /// sheet.getRangeByName('B15').number = 2600;
  /// sheet.getRangeByName('B16').number = 4464;
  /// sheet.getRangeByName('B17').number = 2700;
  /// final ChartCollection charts = ChartCollection(sheet);
  /// final Chart chart = charts.add();
  /// chart.chartType = ExcelChartType.line3D;
  /// chart.dataRange = sheet.getRangeByName('A11:B17');
  /// chart.isSeriesInRows = false;
  /// chart.chartTitle = 'Line Chart 3D';
  /// chart.rotation = 20;
  /// chart.topRow = 8;
  /// chart.leftColumn = 1;
  /// chart.bottomRow = 23;
  /// chart.rightColumn = 8;
  /// sheet.charts = charts;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'FLUT_6975_3D_LineChart.xlsx');
  /// ```
  int get rotation {
    return _rotation;
  }

  ///Set the rotation of 3D view of chart.
  set rotation(int value) {
    if (value < 0 || value > 360) {
      throw Exception('rotation');
    }
    _rotation = value;
    _isDefaultRotation = false;
  }

  /// Get the perspective for the 3D chart view (0 to 100).
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A11').text = 'Venue';
  /// sheet.getRangeByName('A12').text = 'Seating & Decor';
  /// sheet.getRangeByName('A13').text = 'Technical Team';
  /// sheet.getRangeByName('A14').text = 'performers';
  /// sheet.getRangeByName('A15').text = "performer's Transport";
  /// sheet.getRangeByName('A16').text = "performer's stay";
  /// sheet.getRangeByName('A17').text = 'Marketing';
  /// sheet.getRangeByName('B11:B17').numberFormat = r'$#,##0_)';
  /// sheet.getRangeByName('B11').number = 17500;
  /// sheet.getRangeByName('B12').number = 1828;
  /// sheet.getRangeByName('B13').number = 800;
  /// sheet.getRangeByName('B14').number = 14000;
  /// sheet.getRangeByName('B15').number = 2600;
  /// sheet.getRangeByName('B16').number = 4464;
  /// sheet.getRangeByName('B17').number = 2700;
  /// final ChartCollection charts = ChartCollection(sheet);
  /// final Chart chart = charts.add();
  /// chart.chartType = ExcelChartType.line3D;
  /// chart.dataRange = sheet.getRangeByName('A11:B17');
  /// chart.isSeriesInRows = false;
  /// chart.chartTitle = 'Line Chart 3D';
  /// chart.perspective = 45;
  /// chart.topRow = 8;
  /// chart.leftColumn = 1;
  /// chart.bottomRow = 23;
  /// chart.rightColumn = 8;
  /// sheet.charts = charts;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'FLUT_6975_3D_LineChart.xlsx');
  /// ```
  int get perspective {
    return _perspective;
  }

  ///set the persepective of 3D chart
  set perspective(int value) {
    if (value < 0 || value > 100) {
      throw Exception('elevation');
    }

    _perspective = value;
  }

  /// Get the elevation of the 3-D chart view, in degrees (-90 to +90 degrees).
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A11').text = 'Venue';
  /// sheet.getRangeByName('A12').text = 'Seating & Decor';
  /// sheet.getRangeByName('A13').text = 'Technical Team';
  /// sheet.getRangeByName('A14').text = 'performers';
  /// sheet.getRangeByName('A15').text = "performer's Transport";
  /// sheet.getRangeByName('A16').text = "performer's stay";
  /// sheet.getRangeByName('A17').text = 'Marketing';
  /// sheet.getRangeByName('B11:B17').numberFormat = r'$#,##0_)';
  /// sheet.getRangeByName('B11').number = 17500;
  /// sheet.getRangeByName('B12').number = 1828;
  /// sheet.getRangeByName('B13').number = 800;
  /// sheet.getRangeByName('B14').number = 14000;
  /// sheet.getRangeByName('B15').number = 2600;
  /// sheet.getRangeByName('B16').number = 4464;
  /// sheet.getRangeByName('B17').number = 2700;
  /// final ChartCollection charts = ChartCollection(sheet);
  /// final Chart chart = charts.add();
  /// chart.chartType = ExcelChartType.line3D;
  /// chart.dataRange = sheet.getRangeByName('A11:B17');
  /// chart.isSeriesInRows = false;
  /// chart.chartTitle = 'Line Chart 3D';
  /// chart.elevation = 15;
  /// chart.topRow = 8;
  /// chart.leftColumn = 1;
  /// chart.bottomRow = 23;
  /// chart.rightColumn = 8;
  /// sheet.charts = charts;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'FLUT_6975_3D_LineChart.xlsx');
  /// ```
  int get elevation {
    return _elevationAngle;
  }

  ///set the elevation of 3D chart
  set elevation(int value) {
    if (value < -90 || value > 90) {
      throw Exception('elevation');
    }
    _elevationAngle = value;
    _isdefaultElevation = false;
  }

  /// Returns  the depth of a 3-D chart as a percentage of the chart width
  /// (between 20 and 2000 percent).
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A11').text = 'Venue';
  /// sheet.getRangeByName('A12').text = 'Seating & Decor';
  /// sheet.getRangeByName('A13').text = 'Technical Team';
  /// sheet.getRangeByName('A14').text = 'performers';
  /// sheet.getRangeByName('A15').text = "performer's Transport";
  /// sheet.getRangeByName('A16').text = "performer's stay";
  /// sheet.getRangeByName('A17').text = 'Marketing';
  /// sheet.getRangeByName('B11:B17').numberFormat = r'$#,##0_)';
  /// sheet.getRangeByName('B11').number = 17500;
  /// sheet.getRangeByName('B12').number = 1828;
  /// sheet.getRangeByName('B13').number = 800;
  /// sheet.getRangeByName('B14').number = 14000;
  /// sheet.getRangeByName('B15').number = 2600;
  /// sheet.getRangeByName('B16').number = 4464;
  /// sheet.getRangeByName('B17').number = 2700;
  /// final ChartCollection charts = ChartCollection(sheet);
  /// final Chart chart = charts.add();
  /// chart.chartType = ExcelChartType.line3D;
  /// chart.dataRange = sheet.getRangeByName('A11:B17');
  /// chart.isSeriesInRows = false;
  /// chart.chartTitle = 'Line Chart 3D';
  /// chart.depthPercent = 45;
  /// chart.topRow = 8;
  /// chart.leftColumn = 1;
  /// chart.bottomRow = 23;
  /// chart.rightColumn = 8;
  /// sheet.charts = charts;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'FLUT_6975_3D_LineChart.xlsx');
  /// ```
  int get depthPercent {
    return _depthPercent;
  }

  ///set the elevation of 3D chart
  set depthPercent(int value) {
    if (value < -90 || value > 90) {
      throw Exception('elevation');
    }
    _depthPercent = value;
  }

  /// True if the chart axes are at right angles, independent of chart rotation or elevation. otherwise False.
  /// Returns  the RightAngleAxes of a 3-D chart as a percentage of the chart width
  /// (between 20 and 2000 percent).
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A11').text = 'Venue';
  /// sheet.getRangeByName('A12').text = 'Seating & Decor';
  /// sheet.getRangeByName('A13').text = 'Technical Team';
  /// sheet.getRangeByName('A14').text = 'performers';
  /// sheet.getRangeByName('A15').text = "performer's Transport";
  /// sheet.getRangeByName('A16').text = "performer's stay";
  /// sheet.getRangeByName('A17').text = 'Marketing';
  /// sheet.getRangeByName('B11:B17').numberFormat = r'$#,##0_)';
  /// sheet.getRangeByName('B11').number = 17500;
  /// sheet.getRangeByName('B12').number = 1828;
  /// sheet.getRangeByName('B13').number = 800;
  /// sheet.getRangeByName('B14').number = 14000;
  /// sheet.getRangeByName('B15').number = 2600;
  /// sheet.getRangeByName('B16').number = 4464;
  /// sheet.getRangeByName('B17').number = 2700;
  /// final ChartCollection charts = ChartCollection(sheet);
  /// final Chart chart = charts.add();
  /// chart.chartType = ExcelChartType.line3D;
  /// chart.dataRange = sheet.getRangeByName('A11:B17');
  /// chart.isSeriesInRows = false;
  /// chart.chartTitle = 'Line Chart 3D';
  /// chart.depthPercent = 45;
  /// chart.topRow = 8;
  /// chart.leftColumn = 1;
  /// chart.bottomRow = 23;
  /// chart.rightColumn = 8;
  ///chart.rightAngleAxes=false;
  /// sheet.charts = charts;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'FLUT_6975_3D_LineChart.xlsx');
  /// ```
  bool get rightAngleAxes {
    return _rightAngleAxes;
  }

  ///set the right angle axes of 3D chart
  set rightAngleAxes(bool value) {
    _rightAngleAxes = value;
    if (!value) {
      _isColumnOrBar = false;
    }
  }

  /// Finds the category range in the specified chart range.
  // ignore: unused_element
  Range _getCategoryRange(
      Range chartValues, Range values, double count, bool bIsInRow) {
    final int firstRow = chartValues.row;
    final int lastRow = chartValues.lastRow;
    final int firstColumn = chartValues.column;
    final int lastColumn = chartValues.lastColumn;
    Range result;
    if (chartValues.count == count) {
      values = chartValues;
      return chartValues;
    }
    result = bIsInRow
        ? chartValues.worksheet
            .getRangeByIndex(firstRow, firstColumn, lastRow, firstColumn)
        : chartValues.worksheet
            .getRangeByIndex(firstRow, firstColumn, firstRow, lastColumn);
    if (firstRow == lastRow && firstColumn == lastColumn) {
      values = result;
    } else if (firstRow == lastRow) {
      values = bIsInRow
          ? chartValues.worksheet
              .getRangeByIndex(firstRow, firstColumn, lastRow, lastColumn)
          : chartValues
        ..worksheet.getRangeByIndex(firstRow, firstColumn, lastRow, lastColumn);
    } else {
      final int add = bIsInRow
          ? (firstColumn == lastColumn ? 0 : 1)
          : (firstRow == lastRow ? 0 : 1);
      values = bIsInRow
          ? chartValues.worksheet
              .getRangeByIndex(firstRow, firstColumn + add, lastRow, lastColumn)
          : chartValues.worksheet.getRangeByIndex(
              firstRow + add, firstColumn, lastRow, lastColumn);
    }
    return result;
  }

  /// This method is called if DataRange was changed.
  void _onDataRangeChanged(ExcelChartType type) {
    if (_dataRange == null) {
      _series._clear();
      return;
    }

    Range? serieValue, serieNameRange, axisRange;

    serieNameRange =
        _getSerieOrAxisRange(_dataRange, _bSeriesInRows, serieValue);
    axisRange = _getSerieOrAxisRange(_serieValue, !_bSeriesInRows, _serieValue);
    // }
    if (!_validateSerieRangeForChartType(_serieValue, type, _bSeriesInRows)) {
      final Error error = ArgumentError("Can't set data range.");
      throw error;
    }

    primaryCategoryAxis._categoryLabels = axisRange;
    int iIndex = 0;

    if (serieNameRange != null && axisRange != null) {
      iIndex = _bSeriesInRows
          ? axisRange.lastRow - axisRange.row + 1
          : axisRange.lastColumn - axisRange.column + 1;
    }

    _updateSeriesByDataRange(
        _serieValue, serieNameRange, axisRange, iIndex, _bSeriesInRows);
  }

  /// Gets data range that represents series name or category axis.
  Range? _getSerieOrAxisRange(Range? range, bool bIsInRow, Range? serieRange) {
    if (range == null) {
      final Error error = ArgumentError('range-Value should not be null');
      throw error;
    }

    final int iFirstLen = bIsInRow ? range.row : range.column;
    final int iRowColumn = bIsInRow ? range.lastRow : range.lastColumn;

    final int iFirsCount = bIsInRow ? range.column : range.row;
    final int iLastCount = bIsInRow ? range.lastColumn : range.lastRow;

    int iIndex = -1;

    bool bIsName = false;

    for (int i = iFirsCount; i < iLastCount && !bIsName; i++) {
      final Range curRange = bIsInRow
          ? range.worksheet.getRangeByIndex(iRowColumn, i)
          : range.worksheet.getRangeByIndex(i, iRowColumn);

      bIsName = (curRange.number != null &&
              curRange.dateTime == null &&
              curRange.text == null) ||
          (curRange.dateTime == null &&
              curRange.text == null &&
              curRange.number == null) ||
          curRange.formula != null;

      if (!bIsName) {
        iIndex = i;
      }
    }

    if (iIndex == -1) {
      serieRange = range;
      _serieValue = serieRange;
      return null;
    }

    final Range result = bIsInRow
        ? range.worksheet
            .getRangeByIndex(iFirstLen, iFirsCount, iRowColumn, iIndex)
        : range.worksheet
            .getRangeByIndex(iFirsCount, iFirstLen, iIndex, iRowColumn);

    serieRange = bIsInRow
        ? range.worksheet.getRangeByIndex(
            range.row, result.lastColumn + 1, range.lastRow, range.lastColumn)
        : range.worksheet.getRangeByIndex(
            result.lastRow + 1, range.column, range.lastRow, range.lastColumn);
    _serieValue = serieRange;
    return result;
  }

  /// Updates series value by data range.
  void _updateSeriesByDataRange(Range? serieValue, Range? serieNameRange,
      Range? axisRange, int iIndex, bool isSeriesInRows) {
    Worksheet? sheet;
    if (serieValue != null) {
      sheet = serieValue.worksheet;
    }
    if (sheet == null && serieNameRange != null) {
      sheet = serieNameRange.worksheet;
    }
    sheet ??= _worksheet;
    final int iLen = _series.count;
    for (int i = 0; i < iLen; i++) {
      final Range value = isSeriesInRows
          ? sheet.getRangeByIndex(serieValue!.row + i, serieValue.column,
              serieValue.row + i, serieValue.lastColumn)
          : sheet.getRangeByIndex(serieValue!.row, serieValue.column + i,
              serieValue.lastRow, serieValue.column + i);

      final ChartSerie serie = series[i];
      serie.name = 'Serie${i + 1}';
      serie._index = i;
      int iAddIndex = iIndex;
      serie._values = value;
      serie._isDefaultName = true;
      if (serieNameRange != null) {
        iAddIndex +=
            isSeriesInRows ? serieNameRange.row : serieNameRange.column;

        String? formula = isSeriesInRows
            ? sheet
                .getRangeByIndex(iAddIndex + i, serieNameRange.column,
                    iAddIndex + i, serieNameRange.lastColumn)
                .addressGlobal
            : sheet
                .getRangeByIndex(serieNameRange.row, iAddIndex + i,
                    serieNameRange.lastRow, iAddIndex + i)
                .addressGlobal;
        serie._nameOrFormula = formula;
        formula = isSeriesInRows
            ? sheet
                .getRangeByIndex(iAddIndex + i, serieNameRange.column,
                    iAddIndex + i, serieNameRange.lastColumn)
                .text
            : sheet
                .getRangeByIndex(serieNameRange.row, iAddIndex + i,
                    serieNameRange.lastRow, iAddIndex + i)
                .text;
        serie.name = formula;
      }
    }
  }

  /// Validates Series range for min Series count of custom chart type.
  bool _validateSerieRangeForChartType(
      Range? serieValue, ExcelChartType type, bool isSeriesInRows) {
    if (serieValue == null) {
      final Error error = ArgumentError('serieValue - Value cannot be null');
      throw error;
    }

    final int iSeriesInRangeCount = isSeriesInRows
        ? serieValue.lastRow - serieValue.row + 1
        : serieValue.lastColumn - serieValue.column + 1;
    final int iSeriesCount = _series.count;
    final bool bRemove = iSeriesCount > iSeriesInRangeCount;
    final int iStart = bRemove ? iSeriesInRangeCount : iSeriesCount;
    final int iLen = bRemove ? iSeriesCount : iSeriesInRangeCount;

    for (int i = iStart; i < iLen; i++) {
      if (bRemove) {
        _series.innerList.removeAt(iLen - i + iStart - 1);
      } else {
        _series._add();
      }
    }
    return true;
  }

  /// Create chart text area impl.
  void _createChartTitle() {
    _textArea = ChartTextArea(this);
  }

  /// Indicates whether if given chart type is stacked chart or not.
  bool _getIsStacked(ExcelChartType chartType) {
    return _stackedCharts.contains(chartType);
  }

  /// Indicates whether if given chart type is clustered chart or not.
  bool _getIsClustered(ExcelChartType chartType) {
    return _chartsCluster.contains(chartType);
  }

  /// Indicates whether if given chart type is clustered chart or not.
  bool _getIs100(ExcelChartType chartType) {
    return _charts100.contains(chartType);
  }
}
