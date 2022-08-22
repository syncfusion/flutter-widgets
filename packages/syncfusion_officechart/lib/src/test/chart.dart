part of officechart;

// ignore: public_member_api_docs
void saveAsExcel(List<int>? bytes, String fileName) {
  //Comment the below line when saving Excel document in local machine
  bytes = null;
  //Uncomment the below lines when saving Excel document in local machine
  //Directory('output').create(recursive: true);
  //File('output/$fileName').writeAsBytes(bytes!);
}

// ignore: public_member_api_docs
void xlsiochart() {
  group('Charts', () {
    test('EmptyChart', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final ChartCollection charts = ChartCollection(sheet);
      charts.add();
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelEmptyChart.xlsx');
    });

    test('RangeSeriesNotRow', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A11').text = 'Venue';
      sheet.getRangeByName('A12').text = 'Seating & Decor';
      sheet.getRangeByName('A13').text = 'Technical Team';
      sheet.getRangeByName('A14').text = 'performers';
      sheet.getRangeByName('B11').number = 1700;
      sheet.getRangeByName('B12').number = 1828;
      sheet.getRangeByName('B13').number = 800;
      sheet.getRangeByName('B14').number = 1400;
      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.column;
      chart.dataRange = sheet.getRangeByName('A11:B14');
      chart.isSeriesInRows = false;
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelSeriesNotRowChart.xlsx');
    });

    test('RangeSeriesRow', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      sheet.getRangeByName('A2').text = 'Beverages';
      sheet.getRangeByName('A3').text = 'Condiments';
      sheet.getRangeByName('A4').text = 'Confections';
      sheet.getRangeByName('A5').text = 'Dairy Products';
      sheet.getRangeByName('A6').text = 'Grains / Cereals';

      sheet.getRangeByName('B2').number = 2776;
      sheet.getRangeByName('B3').number = 1077;
      sheet.getRangeByName('B4').number = 2287;
      sheet.getRangeByName('B5').number = 1368;
      sheet.getRangeByName('B6').number = 3325;

      sheet.getRangeByName('C2').number = 925;
      sheet.getRangeByName('C3').number = 378;
      sheet.getRangeByName('C4').number = 880;
      sheet.getRangeByName('C5').number = 581;
      sheet.getRangeByName('C6').number = 189;
      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.column;
      chart1.dataRange = sheet.getRangeByName('A2:C6');
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelRangeSeriesRow.xlsx');
    });

    test('ColumnChart', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Items';
      sheet.getRangeByName('B1').text = r'Amount(in $)';
      sheet.getRangeByName('C1').text = 'Count';

      sheet.getRangeByName('A2').text = 'Beverages';
      sheet.getRangeByName('A3').text = 'Condiments';
      sheet.getRangeByName('A4').text = 'Confections';
      sheet.getRangeByName('A5').text = 'Dairy Products';
      sheet.getRangeByName('A6').text = 'Grains / Cereals';

      sheet.getRangeByName('B2').number = 2776;
      sheet.getRangeByName('B3').number = 1077;
      sheet.getRangeByName('B4').number = 2287;
      sheet.getRangeByName('B5').number = 1368;
      sheet.getRangeByName('B6').number = 3325;

      sheet.getRangeByName('C2').number = 925;
      sheet.getRangeByName('C3').number = 378;
      sheet.getRangeByName('C4').number = 880;
      sheet.getRangeByName('C5').number = 581;
      sheet.getRangeByName('C6').number = 189;
      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.column;
      chart1.dataRange = sheet.getRangeByName('A1:C6');
      chart1.isSeriesInRows = false;
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelColumnChart.xlsx');
    });

    test('PieChart', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A11').text = 'Venue';
      sheet.getRangeByName('A12').text = 'Seating & Decor';
      sheet.getRangeByName('A13').text = 'Technical Team';
      sheet.getRangeByName('A14').text = 'performers';
      sheet.getRangeByName('A15').text = "performer's Transport";
      sheet.getRangeByName('A16').text = "performer's stay";
      sheet.getRangeByName('A17').text = 'Marketing';
      sheet.getRangeByName('B11:B17').numberFormat = r'$#,##0_)';
      sheet.getRangeByName('B11').number = 17500;
      sheet.getRangeByName('B12').number = 1828;
      sheet.getRangeByName('B13').number = 800;
      sheet.getRangeByName('B14').number = 14000;
      sheet.getRangeByName('B15').number = 2600;
      sheet.getRangeByName('B16').number = 4464;
      sheet.getRangeByName('B17').number = 2700;
      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.pie;
      chart1.dataRange = sheet.getRangeByName('A11:B17');
      chart1.isSeriesInRows = false;
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelPieChart.xlsx');
    });

    test('LineChart', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A11').text = 'Venue';
      sheet.getRangeByName('A12').text = 'Seating & Decor';
      sheet.getRangeByName('A13').text = 'Technical Team';
      sheet.getRangeByName('A14').text = 'performers';
      sheet.getRangeByName('A15').text = "performer's Transport";
      sheet.getRangeByName('A16').text = "performer's stay";
      sheet.getRangeByName('A17').text = 'Marketing';
      sheet.getRangeByName('B11:B17').numberFormat = r'$#,##0_)';
      sheet.getRangeByName('B11').number = 17500;
      sheet.getRangeByName('B12').number = 1828;
      sheet.getRangeByName('B13').number = 800;
      sheet.getRangeByName('B14').number = 14000;
      sheet.getRangeByName('B15').number = 2600;
      sheet.getRangeByName('B16').number = 4464;
      sheet.getRangeByName('B17').number = 2700;
      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.line;
      chart.dataRange = sheet.getRangeByName('A11:B17');
      chart.isSeriesInRows = false;
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelLineChart.xlsx');
    });

    test('PieChartPosition', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A11').text = 'Venue';
      sheet.getRangeByName('A12').text = 'Seating & Decor';
      sheet.getRangeByName('A13').text = 'Technical Team';
      sheet.getRangeByName('A14').text = 'performers';
      sheet.getRangeByName('A15').text = "performer's Transport";
      sheet.getRangeByName('A16').text = "performer's stay";
      sheet.getRangeByName('A17').text = 'Marketing';
      sheet.getRangeByName('B11:B17').numberFormat = r'$#,##0_)';
      sheet.getRangeByName('B11').number = 17500;
      sheet.getRangeByName('B12').number = 1828;
      sheet.getRangeByName('B13').number = 800;
      sheet.getRangeByName('B14').number = 14000;
      sheet.getRangeByName('B15').number = 2600;
      sheet.getRangeByName('B16').number = 4464;
      sheet.getRangeByName('B17').number = 2700;
      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.pie;
      chart.dataRange = sheet.getRangeByName('A11:B17');
      chart.isSeriesInRows = false;
      chart.chartTitle = 'Event Expenses';
      chart.chartTitleArea.bold = true;
      chart.chartTitleArea.size = 12;
      chart.topRow = 0;
      chart.bottomRow = 10;
      chart.leftColumn = 0;
      chart.rightColumn = 7;
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelPieChartPosition.xlsx');
    });
    test('BarChart', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Items';
      sheet.getRangeByName('B1').text = r'Amount(in $)';
      sheet.getRangeByName('C1').text = 'Count';

      sheet.getRangeByName('A2').text = 'Beverages';
      sheet.getRangeByName('A3').text = 'Condiments';
      sheet.getRangeByName('A4').text = 'Confections';
      sheet.getRangeByName('A5').text = 'Dairy Products';
      sheet.getRangeByName('A6').text = 'Grains / Cereals';

      sheet.getRangeByName('B2').number = 2776;
      sheet.getRangeByName('B3').number = 1077;
      sheet.getRangeByName('B4').number = 2287;
      sheet.getRangeByName('B5').number = 1368;
      sheet.getRangeByName('B6').number = 3325;

      sheet.getRangeByName('C2').number = 925;
      sheet.getRangeByName('C3').number = 378;
      sheet.getRangeByName('C4').number = 880;
      sheet.getRangeByName('C5').number = 581;
      sheet.getRangeByName('C6').number = 189;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.bar;
      chart1.dataRange = sheet.getRangeByName('A1:C6');
      chart1.hasTitle = true;
      chart1.chartTitleArea.bold = true;
      chart1.chartTitleArea.italic = true;
      chart1.chartTitleArea.size = 15;
      chart1.chartTitleArea.fontName = 'Arial';
      chart1.primaryCategoryAxis.title = 'X axis';
      chart1.primaryCategoryAxis.titleArea.bold = true;
      chart1.primaryValueAxis.title = 'Y axis';
      chart1.primaryValueAxis.titleArea.bold = true;
      chart1.isSeriesInRows = false;
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelBarChart.xlsx');
    });
    test('Bar stacked', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Items';
      sheet.getRangeByName('B1').text = r'Amount(in $)';
      sheet.getRangeByName('C1').text = 'Count';

      sheet.getRangeByName('A2').text = 'Beverages';
      sheet.getRangeByName('A3').text = 'Condiments';
      sheet.getRangeByName('A4').text = 'Confections';
      sheet.getRangeByName('A5').text = 'Dairy Products';
      sheet.getRangeByName('A6').text = 'Grains / Cereals';

      sheet.getRangeByName('B2').number = 2776;
      sheet.getRangeByName('B3').number = 1077;
      sheet.getRangeByName('B4').number = 2287;
      sheet.getRangeByName('B5').number = 1368;
      sheet.getRangeByName('B6').number = 3325;

      sheet.getRangeByName('C2').number = 925;
      sheet.getRangeByName('C3').number = 378;
      sheet.getRangeByName('C4').number = 880;
      sheet.getRangeByName('C5').number = 581;
      sheet.getRangeByName('C6').number = 189;
      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.barStacked;
      chart1.dataRange = sheet.getRangeByName('A1:C6');
      chart1.isSeriesInRows = false;
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelBarStackedChart.xlsx');
    });
    test('Column stacked', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Items';
      sheet.getRangeByName('B1').text = r'Amount(in $)';
      sheet.getRangeByName('C1').text = 'Count';

      sheet.getRangeByName('A2').text = 'Beverages';
      sheet.getRangeByName('A3').text = 'Condiments';
      sheet.getRangeByName('A4').text = 'Confections';
      sheet.getRangeByName('A5').text = 'Dairy Products';
      sheet.getRangeByName('A6').text = 'Grains / Cereals';

      sheet.getRangeByName('B2').number = 2776;
      sheet.getRangeByName('B3').number = 1077;
      sheet.getRangeByName('B4').number = 2287;
      sheet.getRangeByName('B5').number = 1368;
      sheet.getRangeByName('B6').number = 3325;

      sheet.getRangeByName('C2').number = 925;
      sheet.getRangeByName('C3').number = 378;
      sheet.getRangeByName('C4').number = 880;
      sheet.getRangeByName('C5').number = 581;
      sheet.getRangeByName('C6').number = 189;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.columnStacked;
      chart1.dataRange = sheet.getRangeByName('A1:C6');
      chart1.isSeriesInRows = false;
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelColumnStackedChart.xlsx');
    });
    test('Line stacked', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Items';
      sheet.getRangeByName('B1').text = r'Amount(in $)';
      sheet.getRangeByName('C1').text = 'Count';

      sheet.getRangeByName('A2').text = 'Beverages';
      sheet.getRangeByName('A3').text = 'Condiments';
      sheet.getRangeByName('A4').text = 'Confections';
      sheet.getRangeByName('A5').text = 'Dairy Products';
      sheet.getRangeByName('A6').text = 'Grains / Cereals';

      sheet.getRangeByName('B2').number = 2776;
      sheet.getRangeByName('B3').number = 1077;
      sheet.getRangeByName('B4').number = 2287;
      sheet.getRangeByName('B5').number = 1368;
      sheet.getRangeByName('B6').number = 3325;

      sheet.getRangeByName('C2').number = 925;
      sheet.getRangeByName('C3').number = 378;
      sheet.getRangeByName('C4').number = 880;
      sheet.getRangeByName('C5').number = 581;
      sheet.getRangeByName('C6').number = 189;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.lineStacked;
      chart1.dataRange = sheet.getRangeByName('A1:C6');
      chart1.isSeriesInRows = false;
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelLineStackedChart.xlsx');
    });

    test('ChartWithDateAxis', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Moths';
      sheet.getRangeByName('B1').text = 'Internal Sales Amount';
      sheet.getRangeByName('C1').text = 'Reseller Sales Amount';

      sheet
          .getRangeByName('A2')
          .setDateTime(DateTime(2014, 01, 14, 14, 14, 14));
      sheet
          .getRangeByName('A3')
          .setDateTime(DateTime(2014, 02, 14, 14, 14, 14));
      sheet
          .getRangeByName('A4')
          .setDateTime(DateTime(2014, 03, 14, 14, 14, 14));
      sheet
          .getRangeByName('A5')
          .setDateTime(DateTime(2014, 04, 14, 14, 14, 14));
      sheet
          .getRangeByName('A6')
          .setDateTime(DateTime(2014, 05, 14, 14, 14, 14));
      sheet
          .getRangeByName('A7')
          .setDateTime(DateTime(2014, 06, 14, 14, 14, 14));
      sheet
          .getRangeByName('A8')
          .setDateTime(DateTime(2014, 07, 14, 14, 14, 14));
      sheet
          .getRangeByName('A9')
          .setDateTime(DateTime(2014, 08, 14, 14, 14, 14));
      sheet
          .getRangeByName('A10')
          .setDateTime(DateTime(2014, 09, 14, 14, 14, 14));
      sheet
          .getRangeByName('A11')
          .setDateTime(DateTime(2014, 10, 14, 14, 14, 14));
      sheet
          .getRangeByName('A12')
          .setDateTime(DateTime(2014, 11, 14, 14, 14, 14));
      sheet
          .getRangeByName('A13')
          .setDateTime(DateTime(2014, 12, 14, 14, 14, 14));

      sheet.getRangeByName('B2').number = 1.25;
      sheet.getRangeByName('B3').number = 2.5;
      sheet.getRangeByName('B4').number = 1.8;
      sheet.getRangeByName('B5').number = 2;
      sheet.getRangeByName('B6').number = 3;
      sheet.getRangeByName('B7').number = 2;
      sheet.getRangeByName('B8').number = 2.8;
      sheet.getRangeByName('B9').number = 4.2;
      sheet.getRangeByName('B10').number = 4;
      sheet.getRangeByName('B11').number = 2.5;
      sheet.getRangeByName('B12').number = 3.5;
      sheet.getRangeByName('B13').number = 3.5;

      sheet.getRangeByName('C2').number = 0.25;
      sheet.getRangeByName('C3').number = 0.3;
      sheet.getRangeByName('C4').number = 0.4;
      sheet.getRangeByName('C5').number = 0.5;
      sheet.getRangeByName('C6').number = 0.8;
      sheet.getRangeByName('C7').number = 1;
      sheet.getRangeByName('C8').number = 1.2;
      sheet.getRangeByName('C9').number = 1.3;
      sheet.getRangeByName('C10').number = 1.4;
      sheet.getRangeByName('C11').number = 1.5;
      sheet.getRangeByName('C12').number = 1.6;
      sheet.getRangeByName('C13').number = 1.9;

      sheet.getRangeByName('A2:A13').numberFormat = 'm/d/yyyy';
      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.line;
      chart.dataRange = sheet.getRangeByName('A1:C13');
      chart.isSeriesInRows = false;
      chart.chartTitle = 'Event Expenses';
      chart.chartTitleArea.bold = true;
      chart.chartTitleArea.size = 12;
      chart.topRow = 0;
      chart.bottomRow = 10;
      chart.leftColumn = 0;
      chart.rightColumn = 7;
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelChartWithDateAxis.xlsx');
    });

    test('ChartWithAxisNumberFormat', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Moths';
      sheet.getRangeByName('B1').text = 'Internal Sales Amount';
      sheet.getRangeByName('C1').text = 'Reseller Sales Amount';

      sheet
          .getRangeByName('A2')
          .setDateTime(DateTime(2014, 01, 14, 14, 14, 14));
      sheet
          .getRangeByName('A3')
          .setDateTime(DateTime(2014, 02, 14, 14, 14, 14));
      sheet
          .getRangeByName('A4')
          .setDateTime(DateTime(2014, 03, 14, 14, 14, 14));
      sheet
          .getRangeByName('A5')
          .setDateTime(DateTime(2014, 04, 14, 14, 14, 14));
      sheet
          .getRangeByName('A6')
          .setDateTime(DateTime(2014, 05, 14, 14, 14, 14));
      sheet
          .getRangeByName('A7')
          .setDateTime(DateTime(2014, 06, 14, 14, 14, 14));
      sheet
          .getRangeByName('A8')
          .setDateTime(DateTime(2014, 07, 14, 14, 14, 14));
      sheet
          .getRangeByName('A9')
          .setDateTime(DateTime(2014, 08, 14, 14, 14, 14));
      sheet
          .getRangeByName('A10')
          .setDateTime(DateTime(2014, 09, 14, 14, 14, 14));
      sheet
          .getRangeByName('A11')
          .setDateTime(DateTime(2014, 10, 14, 14, 14, 14));
      sheet
          .getRangeByName('A12')
          .setDateTime(DateTime(2014, 11, 14, 14, 14, 14));
      sheet
          .getRangeByName('A13')
          .setDateTime(DateTime(2014, 12, 14, 14, 14, 14));

      sheet.getRangeByName('B2').number = 1.25;
      sheet.getRangeByName('B3').number = 2.5;
      sheet.getRangeByName('B4').number = 1.8;
      sheet.getRangeByName('B5').number = 2;
      sheet.getRangeByName('B6').number = 3;
      sheet.getRangeByName('B7').number = 2;
      sheet.getRangeByName('B8').number = 2.8;
      sheet.getRangeByName('B9').number = 4.2;
      sheet.getRangeByName('B10').number = 4;
      sheet.getRangeByName('B11').number = 2.5;
      sheet.getRangeByName('B12').number = 3.5;
      sheet.getRangeByName('B13').number = 3.5;

      sheet.getRangeByName('C2').number = 0.25;
      sheet.getRangeByName('C3').number = 0.3;
      sheet.getRangeByName('C4').number = 0.4;
      sheet.getRangeByName('C5').number = 0.5;
      sheet.getRangeByName('C6').number = 0.8;
      sheet.getRangeByName('C7').number = 1;
      sheet.getRangeByName('C8').number = 1.2;
      sheet.getRangeByName('C9').number = 1.3;
      sheet.getRangeByName('C10').number = 1.4;
      sheet.getRangeByName('C11').number = 1.5;
      sheet.getRangeByName('C12').number = 1.6;
      sheet.getRangeByName('C13').number = 1.9;

      sheet.getRangeByName('A2:A13').numberFormat = 'm/d/yyyy';
      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.line;
      chart.dataRange = sheet.getRangeByName('A1:C13');
      chart.isSeriesInRows = false;
      chart.chartTitle = 'Event Expenses';
      chart.chartTitleArea.bold = true;
      chart.chartTitleArea.size = 12;
      chart.topRow = 0;
      chart.bottomRow = 10;
      chart.leftColumn = 0;
      chart.rightColumn = 7;
      chart.primaryCategoryAxis.numberFormat = 'mmmm';
      chart.primaryValueAxis.numberFormat = "#'M'";
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelChartWithAxisNumberFormat.xlsx');
    });

    test('ChartWithAxisMinMax', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Moths';
      sheet.getRangeByName('B1').text = 'Internal Sales Amount';
      sheet.getRangeByName('C1').text = 'Reseller Sales Amount';

      sheet
          .getRangeByName('A2')
          .setDateTime(DateTime(2014, 01, 14, 14, 14, 14));
      sheet
          .getRangeByName('A3')
          .setDateTime(DateTime(2014, 02, 14, 14, 14, 14));
      sheet
          .getRangeByName('A4')
          .setDateTime(DateTime(2014, 03, 14, 14, 14, 14));
      sheet
          .getRangeByName('A5')
          .setDateTime(DateTime(2014, 04, 14, 14, 14, 14));
      sheet
          .getRangeByName('A6')
          .setDateTime(DateTime(2014, 05, 14, 14, 14, 14));
      sheet
          .getRangeByName('A7')
          .setDateTime(DateTime(2014, 06, 14, 14, 14, 14));
      sheet
          .getRangeByName('A8')
          .setDateTime(DateTime(2014, 07, 14, 14, 14, 14));
      sheet
          .getRangeByName('A9')
          .setDateTime(DateTime(2014, 08, 14, 14, 14, 14));
      sheet
          .getRangeByName('A10')
          .setDateTime(DateTime(2014, 09, 14, 14, 14, 14));
      sheet
          .getRangeByName('A11')
          .setDateTime(DateTime(2014, 10, 14, 14, 14, 14));
      sheet
          .getRangeByName('A12')
          .setDateTime(DateTime(2014, 11, 14, 14, 14, 14));
      sheet
          .getRangeByName('A13')
          .setDateTime(DateTime(2014, 12, 14, 14, 14, 14));

      sheet.getRangeByName('B2').number = 1.25;
      sheet.getRangeByName('B3').number = 2.5;
      sheet.getRangeByName('B4').number = 1.8;
      sheet.getRangeByName('B5').number = 2;
      sheet.getRangeByName('B6').number = 3;
      sheet.getRangeByName('B7').number = 2;
      sheet.getRangeByName('B8').number = 2.8;
      sheet.getRangeByName('B9').number = 4.2;
      sheet.getRangeByName('B10').number = 4;
      sheet.getRangeByName('B11').number = 2.5;
      sheet.getRangeByName('B12').number = 3.5;
      sheet.getRangeByName('B13').number = 3.5;

      sheet.getRangeByName('C2').number = 0.25;
      sheet.getRangeByName('C3').number = 0.3;
      sheet.getRangeByName('C4').number = 0.4;
      sheet.getRangeByName('C5').number = 0.5;
      sheet.getRangeByName('C6').number = 0.8;
      sheet.getRangeByName('C7').number = 1;
      sheet.getRangeByName('C8').number = 1.2;
      sheet.getRangeByName('C9').number = 1.3;
      sheet.getRangeByName('C10').number = 1.4;
      sheet.getRangeByName('C11').number = 1.5;
      sheet.getRangeByName('C12').number = 1.6;
      sheet.getRangeByName('C13').number = 1.9;

      sheet.getRangeByName('A2:A13').numberFormat = 'm/d/yyyy';
      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.line;
      chart.dataRange = sheet.getRangeByName('A1:C13');
      chart.isSeriesInRows = false;
      chart.chartTitle = 'Event Expenses';
      chart.chartTitleArea.bold = true;
      chart.chartTitleArea.size = 12;
      chart.topRow = 0;
      chart.bottomRow = 10;
      chart.leftColumn = 0;
      chart.rightColumn = 7;
      chart.primaryCategoryAxis.numberFormat = 'mmmm';
      chart.primaryValueAxis.numberFormat = "#'M'";
      chart.primaryValueAxis.maximumValue = 4.0;
      chart.primaryValueAxis.minimumValue = 1.0;
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ChartWithAxisMinMax.xlsx');
    });

    test('Multiple Charts', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Items';
      sheet.getRangeByName('B1').text = r'Amount(in $)';
      sheet.getRangeByName('C1').text = 'Count';

      sheet.getRangeByName('A2').text = 'Beverages';
      sheet.getRangeByName('A3').text = 'Condiments';
      sheet.getRangeByName('A4').text = 'Confections';
      sheet.getRangeByName('A5').text = 'Dairy Products';
      sheet.getRangeByName('A6').text = 'Grains / Cereals';

      sheet.getRangeByName('B2').number = 2776;
      sheet.getRangeByName('B3').number = 1077;
      sheet.getRangeByName('B4').number = 2287;
      sheet.getRangeByName('B5').number = 1368;
      sheet.getRangeByName('B6').number = 3325;

      sheet.getRangeByName('C2').number = 925;
      sheet.getRangeByName('C3').number = 378;
      sheet.getRangeByName('C4').number = 880;
      sheet.getRangeByName('C5').number = 581;
      sheet.getRangeByName('C6').number = 189;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.line;
      chart1.dataRange = sheet.getRangeByName('A1:C6');

      chart1.isSeriesInRows = false;
      final Chart chart2 = charts.add();
      chart2.chartType = ExcelChartType.lineStacked;
      chart2.dataRange = sheet.getRangeByName('A1:C6');
      chart2.isSeriesInRows = false;
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelMultipleChart.xlsx');
    });

    test('ChartWithDataLabelFormats', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A11').text = 'Venue';
      sheet.getRangeByName('A12').text = 'Seating & Decor';
      sheet.getRangeByName('A13').text = 'Technical Team';
      sheet.getRangeByName('A14').text = 'performers';
      sheet.getRangeByName('A15').text = "performer's Transport";
      sheet.getRangeByName('A16').text = "performer's stay";
      sheet.getRangeByName('A17').text = 'Marketing';

      sheet.getRangeByName('B11').number = 17500;
      sheet.getRangeByName('B12').number = 1828;
      sheet.getRangeByName('B13').number = 800;
      sheet.getRangeByName('B14').number = 14000;
      sheet.getRangeByName('B15').number = 2600;
      sheet.getRangeByName('B16').number = 4464;
      sheet.getRangeByName('B17').number = 2700;
      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.line;
      chart1.dataRange = sheet.getRangeByName('A11:B17');
      chart1.isSeriesInRows = false;
      final ChartSerie serie = chart1.series[0];
      serie.dataLabels.isValue = true;
      serie.dataLabels.isCategoryName = true;
      serie.dataLabels.isSeriesName = true;
      serie.dataLabels.numberFormat = r'$#,##0_)';
      serie.dataLabels.textArea.bold = true;
      serie.dataLabels.textArea.size = 12;
      serie.dataLabels.textArea.fontName = 'Arial';
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ChartWithDataLabelFormats.xlsx');
    });

    test('ChartWithDataLabels', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A11').text = 'Venue';
      sheet.getRangeByName('A12').text = 'Seating & Decor';
      sheet.getRangeByName('A13').text = 'Technical Team';
      sheet.getRangeByName('A14').text = 'performers';
      sheet.getRangeByName('A15').text = "performer's Transport";
      sheet.getRangeByName('A16').text = "performer's stay";
      sheet.getRangeByName('A17').text = 'Marketing';

      sheet.getRangeByName('B11').number = 17500;
      sheet.getRangeByName('B12').number = 1828;
      sheet.getRangeByName('B13').number = 800;
      sheet.getRangeByName('B14').number = 14000;
      sheet.getRangeByName('B15').number = 2600;
      sheet.getRangeByName('B16').number = 4464;
      sheet.getRangeByName('B17').number = 2700;
      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.line;
      chart1.dataRange = sheet.getRangeByName('A11:B17');
      chart1.isSeriesInRows = false;
      final ChartSerie serie = chart1.series[0];
      serie.dataLabels.isValue = true;
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ChartWithDataLabels.xlsx');
    });

    test('Legend bottom position and text formatting', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Items';
      sheet.getRangeByName('B1').text = r'Amount(in $)';
      sheet.getRangeByName('C1').text = 'Count';

      sheet.getRangeByName('A2').text = 'Beverages';
      sheet.getRangeByName('A3').text = 'Condiments';
      sheet.getRangeByName('A4').text = 'Confections';
      sheet.getRangeByName('A5').text = 'Dairy Products';
      sheet.getRangeByName('A6').text = 'Grains / Cereals';

      sheet.getRangeByName('B2').number = 2776;
      sheet.getRangeByName('B3').number = 1077;
      sheet.getRangeByName('B4').number = 2287;
      sheet.getRangeByName('B5').number = 1368;
      sheet.getRangeByName('B6').number = 3325;

      sheet.getRangeByName('C2').number = 925;
      sheet.getRangeByName('C3').number = 378;
      sheet.getRangeByName('C4').number = 880;
      sheet.getRangeByName('C5').number = 581;
      sheet.getRangeByName('C6').number = 189;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.line;
      chart1.dataRange = sheet.getRangeByName('A1:C6');
      chart1.isSeriesInRows = false;
      chart1.legend!.position = ExcelLegendPosition.bottom;
      chart1.legend!.textArea.bold = true;
      chart1.legend!.textArea.italic = true;
      chart1.legend!.textArea.size = 14;
      chart1.legend!.textArea.fontName = 'Arial';
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelLegendBottomPostionAndTextFormatting.xlsx');
    });

    test('Legend left position and text formatting', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Items';
      sheet.getRangeByName('B1').text = r'Amount(in $)';
      sheet.getRangeByName('C1').text = 'Count';

      sheet.getRangeByName('A2').text = 'Beverages';
      sheet.getRangeByName('A3').text = 'Condiments';
      sheet.getRangeByName('A4').text = 'Confections';
      sheet.getRangeByName('A5').text = 'Dairy Products';
      sheet.getRangeByName('A6').text = 'Grains / Cereals';

      sheet.getRangeByName('B2').number = 2776;
      sheet.getRangeByName('B3').number = 1077;
      sheet.getRangeByName('B4').number = 2287;
      sheet.getRangeByName('B5').number = 1368;
      sheet.getRangeByName('B6').number = 3325;

      sheet.getRangeByName('C2').number = 925;
      sheet.getRangeByName('C3').number = 378;
      sheet.getRangeByName('C4').number = 880;
      sheet.getRangeByName('C5').number = 581;
      sheet.getRangeByName('C6').number = 189;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.line;
      chart1.dataRange = sheet.getRangeByName('A1:C6');
      chart1.isSeriesInRows = false;
      chart1.legend!.position = ExcelLegendPosition.left;
      chart1.legend!.textArea.bold = true;
      chart1.legend!.textArea.italic = true;
      chart1.legend!.textArea.size = 14;
      chart1.legend!.textArea.fontName = 'Arial';
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelLegendLeftPostionAndTextFormatting.xlsx');
    });

    test('Legend right position and text formatting', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Items';
      sheet.getRangeByName('B1').text = r'Amount(in $)';
      sheet.getRangeByName('C1').text = 'Count';

      sheet.getRangeByName('A2').text = 'Beverages';
      sheet.getRangeByName('A3').text = 'Condiments';
      sheet.getRangeByName('A4').text = 'Confections';
      sheet.getRangeByName('A5').text = 'Dairy Products';
      sheet.getRangeByName('A6').text = 'Grains / Cereals';

      sheet.getRangeByName('B2').number = 2776;
      sheet.getRangeByName('B3').number = 1077;
      sheet.getRangeByName('B4').number = 2287;
      sheet.getRangeByName('B5').number = 1368;
      sheet.getRangeByName('B6').number = 3325;

      sheet.getRangeByName('C2').number = 925;
      sheet.getRangeByName('C3').number = 378;
      sheet.getRangeByName('C4').number = 880;
      sheet.getRangeByName('C5').number = 581;
      sheet.getRangeByName('C6').number = 189;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.column;
      chart1.dataRange = sheet.getRangeByName('A1:C6');
      chart1.isSeriesInRows = false;
      chart1.legend!.position = ExcelLegendPosition.right;
      chart1.legend!.textArea.bold = true;
      chart1.legend!.textArea.italic = true;
      chart1.legend!.textArea.size = 14;
      chart1.legend!.textArea.fontName = 'Arial';
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelLegendRightPostionAndTextFormatting.xlsx');
    });

    test('Legend top position and text formatting', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Items';
      sheet.getRangeByName('B1').text = r'Amount(in $)';
      sheet.getRangeByName('C1').text = 'Count';

      sheet.getRangeByName('A2').text = 'Beverages';
      sheet.getRangeByName('A3').text = 'Condiments';
      sheet.getRangeByName('A4').text = 'Confections';
      sheet.getRangeByName('A5').text = 'Dairy Products';
      sheet.getRangeByName('A6').text = 'Grains / Cereals';

      sheet.getRangeByName('B2').number = 2776;
      sheet.getRangeByName('B3').number = 1077;
      sheet.getRangeByName('B4').number = 2287;
      sheet.getRangeByName('B5').number = 1368;
      sheet.getRangeByName('B6').number = 3325;

      sheet.getRangeByName('C2').number = 925;
      sheet.getRangeByName('C3').number = 378;
      sheet.getRangeByName('C4').number = 880;
      sheet.getRangeByName('C5').number = 581;
      sheet.getRangeByName('C6').number = 189;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.line;
      chart1.dataRange = sheet.getRangeByName('A1:C6');
      chart1.isSeriesInRows = false;
      chart1.legend!.position = ExcelLegendPosition.top;
      chart1.legend!.textArea.bold = true;
      chart1.legend!.textArea.italic = true;
      chart1.legend!.textArea.size = 14;
      chart1.legend!.textArea.fontName = 'Arial';
      chart1.legend!.textArea.color = '#FF0000';
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelLegendTopPostionAndTextFormatting.xlsx');
    });

    test('Chart without legend', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Items';
      sheet.getRangeByName('B1').text = r'Amount(in $)';
      sheet.getRangeByName('C1').text = 'Count';

      sheet.getRangeByName('A2').text = 'Beverages';
      sheet.getRangeByName('A3').text = 'Condiments';
      sheet.getRangeByName('A4').text = 'Confections';
      sheet.getRangeByName('A5').text = 'Dairy Products';
      sheet.getRangeByName('A6').text = 'Grains / Cereals';

      sheet.getRangeByName('B2').number = 2776;
      sheet.getRangeByName('B3').number = 1077;
      sheet.getRangeByName('B4').number = 2287;
      sheet.getRangeByName('B5').number = 1368;
      sheet.getRangeByName('B6').number = 3325;

      sheet.getRangeByName('C2').number = 925;
      sheet.getRangeByName('C3').number = 378;
      sheet.getRangeByName('C4').number = 880;
      sheet.getRangeByName('C5').number = 581;
      sheet.getRangeByName('C6').number = 189;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.line;
      chart1.dataRange = sheet.getRangeByName('A1:C6');
      chart1.isSeriesInRows = false;
      chart1.hasLegend = false;
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelChartWithoutLegend.xlsx');
    });

    test('MultipleWorksheetCharts', () {
      final Workbook workbook = Workbook(2);
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Items';
      sheet.getRangeByName('B1').text = r'Amount(in $)';
      sheet.getRangeByName('C1').text = 'Count';

      sheet.getRangeByName('A2').text = 'Beverages';
      sheet.getRangeByName('A3').text = 'Condiments';
      sheet.getRangeByName('A4').text = 'Confections';
      sheet.getRangeByName('A5').text = 'Dairy Products';
      sheet.getRangeByName('A6').text = 'Grains / Cereals';

      sheet.getRangeByName('B2').number = 2776;
      sheet.getRangeByName('B3').number = 1077;
      sheet.getRangeByName('B4').number = 2287;
      sheet.getRangeByName('B5').number = 1368;
      sheet.getRangeByName('B6').number = 3325;

      sheet.getRangeByName('C2').number = 925;
      sheet.getRangeByName('C3').number = 378;
      sheet.getRangeByName('C4').number = 880;
      sheet.getRangeByName('C5').number = 581;
      sheet.getRangeByName('C6').number = 189;

      ChartCollection charts = ChartCollection(sheet);
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.line;
      chart.dataRange = sheet.getRangeByName('A1:C6');
      chart.isSeriesInRows = false;

      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.column;
      chart1.dataRange = sheet.getRangeByName('A1:C6');
      chart1.isSeriesInRows = false;

      sheet.charts = charts;

      final Worksheet sheet1 = workbook.worksheets[1];
      sheet1.getRangeByName('A11').text = 'Venue';
      sheet1.getRangeByName('A12').text = 'Seating & Decor';
      sheet1.getRangeByName('A13').text = 'Technical Team';
      sheet1.getRangeByName('A14').text = 'performers';
      sheet1.getRangeByName('A15').text = "performer's Transport";
      sheet1.getRangeByName('A16').text = "performer's stay";
      sheet1.getRangeByName('A17').text = 'Marketing';
      sheet1.getRangeByName('B11:B17').numberFormat = r'$#,##0_)';
      sheet1.getRangeByName('B11').number = 17500;
      sheet1.getRangeByName('B12').number = 1828;
      sheet1.getRangeByName('B13').number = 800;
      sheet1.getRangeByName('B14').number = 14000;
      sheet1.getRangeByName('B15').number = 2600;
      sheet1.getRangeByName('B16').number = 4464;
      sheet1.getRangeByName('B17').number = 2700;
      charts = ChartCollection(sheet1);
      final Chart chart2 = charts.add();
      chart2.chartType = ExcelChartType.bar;
      chart2.dataRange = sheet1.getRangeByName('A11:B17');
      chart2.isSeriesInRows = false;

      final Chart chart3 = charts.add();
      chart3.chartType = ExcelChartType.pie;
      chart3.dataRange = sheet1.getRangeByName('A11:B17');
      chart3.isSeriesInRows = false;
      sheet1.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'MultipleWorksheetCharts.xlsx');
    });

    test('MultipleChartsToSingleSheet', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Items';
      sheet.getRangeByName('B1').text = r'Amount(in $)';
      sheet.getRangeByName('C1').text = 'Count';

      sheet.getRangeByName('A2').text = 'Beverages';
      sheet.getRangeByName('A3').text = 'Condiments';
      sheet.getRangeByName('A4').text = 'Confections';
      sheet.getRangeByName('A5').text = 'Dairy Products';
      sheet.getRangeByName('A6').text = 'Grains / Cereals';

      sheet.getRangeByName('B2').number = 2776;
      sheet.getRangeByName('B3').number = 1077;
      sheet.getRangeByName('B4').number = 2287;
      sheet.getRangeByName('B5').number = 1368;
      sheet.getRangeByName('B6').number = 3325;

      sheet.getRangeByName('C2').number = 925;
      sheet.getRangeByName('C3').number = 378;
      sheet.getRangeByName('C4').number = 880;
      sheet.getRangeByName('C5').number = 581;
      sheet.getRangeByName('C6').number = 189;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.line;
      chart1.dataRange = sheet.getRangeByName('A1:C6');
      chart1.isSeriesInRows = false;

      final Chart chart2 = charts.add();
      chart2.chartType = ExcelChartType.bar;
      chart2.dataRange = sheet.getRangeByName('A1:C6');
      chart2.isSeriesInRows = false;

      final Chart chart3 = charts.add();
      chart3.chartType = ExcelChartType.pie;
      chart3.dataRange = sheet.getRangeByName('A1:C6');
      chart3.isSeriesInRows = false;

      final Chart chart4 = charts.add();
      chart4.chartType = ExcelChartType.column;
      chart4.dataRange = sheet.getRangeByName('A1:C6');
      chart4.isSeriesInRows = false;

      final Chart chart5 = charts.add();
      chart5.chartType = ExcelChartType.barStacked;
      chart5.dataRange = sheet.getRangeByName('A1:C6');
      chart5.isSeriesInRows = false;

      final Chart chart6 = charts.add();
      chart6.chartType = ExcelChartType.columnStacked;
      chart6.dataRange = sheet.getRangeByName('A1:C6');
      chart6.isSeriesInRows = false;

      final Chart chart7 = charts.add();
      chart7.chartType = ExcelChartType.lineStacked;
      chart7.dataRange = sheet.getRangeByName('A1:C6');
      chart7.isSeriesInRows = false;
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'MultipleChartsToSingleSheet.xlsx');
    });
    test('ExcelChartAxisFormat', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      sheet.getRangeByName('A2').text = 'Beverages';
      sheet.getRangeByName('A3').text = 'Condiments';
      sheet.getRangeByName('A4').text = 'Confections';
      sheet.getRangeByName('A5').text = 'Dairy Products';
      sheet.getRangeByName('A6').text = 'Grains / Cereals';

      sheet.getRangeByName('B2').number = 2776;
      sheet.getRangeByName('B3').number = 1077;
      sheet.getRangeByName('B4').number = 2287;
      sheet.getRangeByName('B5').number = 1368;
      sheet.getRangeByName('B6').number = 3325;

      sheet.getRangeByName('C2').number = 925;
      sheet.getRangeByName('C3').number = 378;
      sheet.getRangeByName('C4').number = 880;
      sheet.getRangeByName('C5').number = 581;
      sheet.getRangeByName('C6').number = 189;
      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.column;
      chart1.dataRange = sheet.getRangeByName('A2:C6');
      chart1.primaryCategoryAxis.titleArea.fontName = 'Arial';
      chart1.primaryCategoryAxis.titleArea.bold = true;
      chart1.primaryCategoryAxis.titleArea.size = 14;

      chart1.primaryValueAxis.titleArea.bold = true;
      chart1.primaryValueAxis.titleArea.italic = true;
      chart1.primaryValueAxis.titleArea.size = 12;
      final ChartSerie serie = chart1.series[0];
      serie.dataLabels.isValue = true;
      serie.dataLabels.textArea.size = 14;
      serie.dataLabels.textArea.bold = true;
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelChartAxisFormat.xlsx');
    });

    test('ExcelChartAreaColor', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A2').text = 'Beverages';
      sheet.getRangeByName('A3').text = 'Condiments';
      sheet.getRangeByName('A4').text = 'Confections';
      sheet.getRangeByName('A5').text = 'Dairy Products';
      sheet.getRangeByName('A6').text = 'Grains / Cereals';

      sheet.getRangeByName('B2').number = 2776;
      sheet.getRangeByName('B3').number = 1077;
      sheet.getRangeByName('B4').number = 2287;
      sheet.getRangeByName('B5').number = 1368;
      sheet.getRangeByName('B6').number = 3325;

      sheet.getRangeByName('C2').number = 925;
      sheet.getRangeByName('C3').number = 378;
      sheet.getRangeByName('C4').number = 880;
      sheet.getRangeByName('C5').number = 581;
      sheet.getRangeByName('C6').number = 189;
      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.line;
      chart.dataRange = sheet.getRangeByName('A2:C6');
      chart.isSeriesInRows = false;

      chart.chartTitle = 'Test';
      chart.chartTitleArea.bold = true;
      chart.chartTitleArea.color = '#111111';
      chart.chartTitleArea.size = 14;

      chart.primaryCategoryAxis.titleArea.bold = true;
      chart.primaryCategoryAxis.titleArea.size = 12;
      chart.primaryCategoryAxis.titleArea.color = '#00BFFF';

      chart.primaryValueAxis.titleArea.bold = true;
      chart.primaryValueAxis.titleArea.size = 12;
      chart.primaryValueAxis.titleArea.color = '#80FF00';

      final ChartSerie serie = chart.series[0];
      serie.dataLabels.isValue = true;
      serie.dataLabels.textArea.size = 12;
      serie.dataLabels.textArea.bold = true;
      serie.dataLabels.textArea.color = '#FF00FF';
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelChartAreaColor.xlsx');
    });

    test('ExcelChartLinePattern', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A2').text = 'Beverages';
      sheet.getRangeByName('A3').text = 'Condiments';
      sheet.getRangeByName('A4').text = 'Confections';
      sheet.getRangeByName('A5').text = 'Dairy Products';
      sheet.getRangeByName('A6').text = 'Grains / Cereals';

      sheet.getRangeByName('B2').number = 2776;
      sheet.getRangeByName('B3').number = 1077;
      sheet.getRangeByName('B4').number = 2287;
      sheet.getRangeByName('B5').number = 1368;
      sheet.getRangeByName('B6').number = 3325;

      sheet.getRangeByName('C2').number = 925;
      sheet.getRangeByName('C3').number = 378;
      sheet.getRangeByName('C4').number = 880;
      sheet.getRangeByName('C5').number = 581;
      sheet.getRangeByName('C6').number = 189;
      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.line;
      chart.dataRange = sheet.getRangeByName('A2:C6');
      chart.isSeriesInRows = false;

      chart.chartTitle = 'Test';
      chart.chartTitleArea.bold = true;
      chart.chartTitleArea.color = '#FF0000';
      chart.chartTitleArea.size = 14;

      chart.primaryCategoryAxis.titleArea.bold = true;
      chart.primaryCategoryAxis.titleArea.size = 12;
      chart.primaryCategoryAxis.titleArea.color = '#00FFFF';

      chart.primaryValueAxis.titleArea.bold = true;
      chart.primaryValueAxis.titleArea.size = 12;
      chart.primaryValueAxis.titleArea.color = '#ADD8E6';

      final ChartSerie serie = chart.series[0];
      serie.dataLabels.isValue = true;
      serie.dataLabels.textArea.size = 12;
      serie.dataLabels.textArea.bold = true;
      serie.dataLabels.textArea.color = '#0000A0';
      serie.linePattern = ExcelChartLinePattern.dash;

      final ChartSerie serie1 = chart.series[1];
      serie1.linePattern = ExcelChartLinePattern.longDashDot;

      chart.plotArea.linePattern = ExcelChartLinePattern.dashDot;
      chart.plotArea.linePatternColor = '#0000FF';
      chart.linePattern = ExcelChartLinePattern.longDashDotDot;

      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelChartLinePattern.xlsx');
    });

    test('ExcelChartLinePatternColor', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A2').text = 'Beverages';
      sheet.getRangeByName('A3').text = 'Condiments';
      sheet.getRangeByName('A4').text = 'Confections';
      sheet.getRangeByName('A5').text = 'Dairy Products';
      sheet.getRangeByName('A6').text = 'Grains / Cereals';

      sheet.getRangeByName('B2').number = 2776;
      sheet.getRangeByName('B3').number = 1077;
      sheet.getRangeByName('B4').number = 2287;
      sheet.getRangeByName('B5').number = 1368;
      sheet.getRangeByName('B6').number = 3325;

      sheet.getRangeByName('C2').number = 925;
      sheet.getRangeByName('C3').number = 378;
      sheet.getRangeByName('C4').number = 880;
      sheet.getRangeByName('C5').number = 581;
      sheet.getRangeByName('C6').number = 189;
      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.line;
      chart.dataRange = sheet.getRangeByName('A2:C6');
      chart.isSeriesInRows = false;

      chart.chartTitle = 'Test';
      chart.chartTitleArea.bold = true;
      chart.chartTitleArea.color = '#FF0000';
      chart.chartTitleArea.size = 14;

      chart.primaryCategoryAxis.titleArea.bold = true;
      chart.primaryCategoryAxis.titleArea.size = 12;
      chart.primaryCategoryAxis.titleArea.color = '#800080';

      chart.primaryValueAxis.titleArea.bold = true;
      chart.primaryValueAxis.titleArea.size = 12;
      chart.primaryValueAxis.titleArea.color = '#FFFF00';

      final ChartSerie serie = chart.series[0];
      serie.dataLabels.isValue = true;
      serie.dataLabels.textArea.size = 12;
      serie.dataLabels.textArea.bold = true;
      serie.dataLabels.textArea.color = '#00FF00';
      serie.linePattern = ExcelChartLinePattern.dash;
      serie.linePatternColor = '#FF00FF';

      final ChartSerie serie1 = chart.series[1];
      serie1.linePattern = ExcelChartLinePattern.longDashDot;
      serie1.linePatternColor = '#FF0000';

      chart.plotArea.linePattern = ExcelChartLinePattern.solid;
      chart.plotArea.linePatternColor = '#00FFFF';
      chart.linePattern = ExcelChartLinePattern.longDashDotDot;
      chart.linePatternColor = '#0000FF';
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelChartLinePatternColor.xlsx');
    });

    test('MultipleChartsAndPicturesInMultipleSheet', () {
      final Workbook workbook = Workbook(2);
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Items';
      sheet.getRangeByName('B1').text = r'Amount(in $)';
      sheet.getRangeByName('C1').text = 'Count';

      sheet.getRangeByName('A2').text = 'Beverages';
      sheet.getRangeByName('A3').text = 'Condiments';
      sheet.getRangeByName('A4').text = 'Confections';
      sheet.getRangeByName('A5').text = 'Dairy Products';
      sheet.getRangeByName('A6').text = 'Grains / Cereals';

      sheet.getRangeByName('B2').number = 2776;
      sheet.getRangeByName('B3').number = 1077;
      sheet.getRangeByName('B4').number = 2287;
      sheet.getRangeByName('B5').number = 1368;
      sheet.getRangeByName('B6').number = 3325;

      sheet.getRangeByName('C2').number = 925;
      sheet.getRangeByName('C3').number = 378;
      sheet.getRangeByName('C4').number = 880;
      sheet.getRangeByName('C5').number = 581;
      sheet.getRangeByName('C6').number = 189;

      ChartCollection charts = ChartCollection(sheet);
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.line;
      chart.dataRange = sheet.getRangeByName('A1:C6');
      chart.isSeriesInRows = false;

      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.column;
      chart1.dataRange = sheet.getRangeByName('A1:C6');
      chart1.isSeriesInRows = false;

      sheet.charts = charts;
      final Picture picture = sheet.pictures.addBase64(3, 4, _invoicejpeg);
      picture.lastRow = 7;
      picture.lastColumn = 8;

      final Picture picture2 = sheet.pictures.addBase64(3, 4, _image1jpg);
      picture2.lastRow = 7;
      picture2.lastColumn = 8;

      final Picture picture3 = sheet.pictures.addBase64(3, 4, _image3png);
      picture3.lastRow = 7;
      picture3.lastColumn = 8;

      final Worksheet sheet1 = workbook.worksheets[1];
      sheet1.getRangeByName('A11').text = 'Venue';
      sheet1.getRangeByName('A12').text = 'Seating & Decor';
      sheet1.getRangeByName('A13').text = 'Technical Team';
      sheet1.getRangeByName('A14').text = 'performers';
      sheet1.getRangeByName('A15').text = "performer's Transport";
      sheet1.getRangeByName('A16').text = "performer's stay";
      sheet1.getRangeByName('A17').text = 'Marketing';
      sheet1.getRangeByName('B11:B17').numberFormat = r'$#,##0_)';
      sheet1.getRangeByName('B11').number = 17500;
      sheet1.getRangeByName('B12').number = 1828;
      sheet1.getRangeByName('B13').number = 800;
      sheet1.getRangeByName('B14').number = 14000;
      sheet1.getRangeByName('B15').number = 2600;
      sheet1.getRangeByName('B16').number = 4464;
      sheet1.getRangeByName('B17').number = 2700;
      charts = ChartCollection(sheet1);

      final Chart chart4 = charts.add();
      chart4.chartType = ExcelChartType.line;
      chart4.dataRange = sheet1.getRangeByName('A11:B17');
      chart4.isSeriesInRows = false;

      final Chart chart2 = charts.add();
      chart2.chartType = ExcelChartType.bar;
      chart2.dataRange = sheet1.getRangeByName('A11:B17');
      chart2.isSeriesInRows = false;

      final Chart chart3 = charts.add();
      chart3.chartType = ExcelChartType.pie;
      chart3.dataRange = sheet1.getRangeByName('A11:B17');
      chart3.isSeriesInRows = false;

      sheet1.charts = charts;
      final Picture picture4 = sheet1.pictures.addBase64(3, 4, _invoicejpeg);
      picture4.lastRow = 7;
      picture4.lastColumn = 8;

      final Picture picture5 = sheet1.pictures.addBase64(3, 4, _image1jpg);
      picture5.lastRow = 7;
      picture5.lastColumn = 8;

      final Picture picture6 = sheet1.pictures.addBase64(3, 4, _image10jpg);
      picture6.lastRow = 7;
      picture6.lastColumn = 8;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'MultipleChartsAndPicturesInMultipleSheet.xlsx');
    });

    test('MultipleChartsAndPicturesInSingleSheet', () {
      //Create a Excel document.
      //Creating a workbook.
      final Workbook workbook = Workbook();
      //Accessing via index
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A11').text = 'Venue';
      sheet.getRangeByName('A12').text = 'Seating & Decor';
      sheet.getRangeByName('A13').text = 'Technical Team';
      sheet.getRangeByName('A14').text = 'performers';
      sheet.getRangeByName('B11').number = 1700;
      sheet.getRangeByName('B12').number = 1828;
      sheet.getRangeByName('B13').number = 800;
      sheet.getRangeByName('B14').number = 1400;
      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.column;
      chart.dataRange = sheet.getRangeByName('A11:B14');
      chart.isSeriesInRows = false;

      final Chart chart2 = charts.add();
      chart2.chartType = ExcelChartType.line;
      chart2.dataRange = sheet.getRangeByName('A11:B14');
      chart2.isSeriesInRows = false;

      final Chart chart3 = charts.add();
      chart3.chartType = ExcelChartType.bar;
      chart3.dataRange = sheet.getRangeByName('A11:B14');
      chart3.isSeriesInRows = false;

      sheet.charts = charts;

      final Picture picture = sheet.pictures.addBase64(3, 4, _invoicejpeg);
      picture.lastRow = 7;
      picture.lastColumn = 8;

      final Picture picture2 = sheet.pictures.addBase64(3, 4, _image1jpg);
      picture2.lastRow = 7;
      picture2.lastColumn = 8;

      final Picture picture3 = sheet.pictures.addBase64(3, 4, _image3png);
      picture3.lastRow = 7;
      picture3.lastColumn = 8;

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      saveAsExcel(bytes, 'MultipleChartsAndPicturesInSingleSheet.xlsx');
    });

    test('AreaChart', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Fruits';
      sheet.getRangeByName('A2').text = 'Apples';
      sheet.getRangeByName('A3').text = 'Grapes';
      sheet.getRangeByName('A4').text = 'Bananas';
      sheet.getRangeByName('A5').text = 'Oranges';
      sheet.getRangeByName('A6').text = 'Melons';
      sheet.getRangeByName('B1').text = 'Joey';
      sheet.getRangeByName('B2').number = 5;
      sheet.getRangeByName('B3').number = 4;
      sheet.getRangeByName('B4').number = 4;
      sheet.getRangeByName('B5').number = 2;
      sheet.getRangeByName('B6').number = 2;
      sheet.getRangeByName('C1').text = 'Mathew';
      sheet.getRangeByName('C2').number = 3;
      sheet.getRangeByName('C3').number = 5;
      sheet.getRangeByName('C4').number = 4;
      sheet.getRangeByName('C5').number = 1;
      sheet.getRangeByName('C6').number = 7;
      sheet.getRangeByName('D1').text = 'Peter';
      sheet.getRangeByName('D2').number = 2;
      sheet.getRangeByName('D3').number = 2;
      sheet.getRangeByName('D4').number = 3;
      sheet.getRangeByName('D5').number = 5;
      sheet.getRangeByName('D6').number = 6;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.area;
      chart.dataRange = sheet.getRangeByName('A1:D6');
      chart.isSeriesInRows = false;

      //Set Chart Title
      chart.chartTitle = 'Area Chart';

      //Set Legend
      chart.hasLegend = true;
      chart.legend!.position = ExcelLegendPosition.bottom;

      //Positioning the chart in the worksheet
      chart.topRow = 8;
      chart.leftColumn = 1;
      chart.bottomRow = 23;
      chart.rightColumn = 8;

      sheet.charts = charts;

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      saveAsExcel(bytes, 'AreaChart.xlsx');
    });

    test('AreaStackedChart', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Fruits';
      sheet.getRangeByName('A2').text = 'Apples';
      sheet.getRangeByName('A3').text = 'Grapes';
      sheet.getRangeByName('A4').text = 'Bananas';
      sheet.getRangeByName('A5').text = 'Oranges';
      sheet.getRangeByName('A6').text = 'Melons';
      sheet.getRangeByName('B1').text = 'Joey';
      sheet.getRangeByName('B2').number = 5;
      sheet.getRangeByName('B3').number = 4;
      sheet.getRangeByName('B4').number = 4;
      sheet.getRangeByName('B5').number = 2;
      sheet.getRangeByName('B6').number = 2;
      sheet.getRangeByName('C1').text = 'Mathew';
      sheet.getRangeByName('C2').number = 3;
      sheet.getRangeByName('C3').number = 5;
      sheet.getRangeByName('C4').number = 4;
      sheet.getRangeByName('C5').number = 1;
      sheet.getRangeByName('C6').number = 7;
      sheet.getRangeByName('D1').text = 'Peter';
      sheet.getRangeByName('D2').number = 2;
      sheet.getRangeByName('D3').number = 2;
      sheet.getRangeByName('D4').number = 3;
      sheet.getRangeByName('D5').number = 5;
      sheet.getRangeByName('D6').number = 6;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.areaStacked;
      chart.dataRange = sheet.getRangeByName('A1:D6');
      chart.isSeriesInRows = false;

      //Set Chart Title
      chart.chartTitle = 'Stacked Area Chart';

      //Set Legend
      chart.hasLegend = true;
      chart.legend!.position = ExcelLegendPosition.bottom;

      //Positioning the chart in the worksheet
      chart.topRow = 8;
      chart.leftColumn = 1;
      chart.bottomRow = 23;
      chart.rightColumn = 8;

      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      saveAsExcel(bytes, 'AreaStackedChart.xlsx');
    });

    test('AreaStacked100Chart', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Fruits';
      sheet.getRangeByName('A2').text = 'Apples';
      sheet.getRangeByName('A3').text = 'Grapes';
      sheet.getRangeByName('A4').text = 'Bananas';
      sheet.getRangeByName('A5').text = 'Oranges';
      sheet.getRangeByName('A6').text = 'Melons';
      sheet.getRangeByName('B1').text = 'Joey';
      sheet.getRangeByName('B2').number = 5;
      sheet.getRangeByName('B3').number = 4;
      sheet.getRangeByName('B4').number = 4;
      sheet.getRangeByName('B5').number = 2;
      sheet.getRangeByName('B6').number = 2;
      sheet.getRangeByName('C1').text = 'Mathew';
      sheet.getRangeByName('C2').number = 3;
      sheet.getRangeByName('C3').number = 5;
      sheet.getRangeByName('C4').number = 4;
      sheet.getRangeByName('C5').number = 1;
      sheet.getRangeByName('C6').number = 7;
      sheet.getRangeByName('D1').text = 'Peter';
      sheet.getRangeByName('D2').number = 2;
      sheet.getRangeByName('D3').number = 2;
      sheet.getRangeByName('D4').number = 3;
      sheet.getRangeByName('D5').number = 5;
      sheet.getRangeByName('D6').number = 6;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.areaStacked100;
      chart.dataRange = sheet.getRangeByName('A1:D6');
      chart.isSeriesInRows = false;

      //Set Chart Title
      chart.chartTitle = 'Stacked 100 Area Chart';

      //Set Legend
      chart.hasLegend = true;
      chart.legend!.position = ExcelLegendPosition.bottom;

      //Positioning the chart in the worksheet
      chart.topRow = 8;
      chart.leftColumn = 1;
      chart.bottomRow = 23;
      chart.rightColumn = 8;

      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      saveAsExcel(bytes, 'AreaStacked100Chart.xlsx');
    });

    test('columnStacked100Chart', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Fruits';
      sheet.getRangeByName('A2').text = 'Apples';
      sheet.getRangeByName('A3').text = 'Grapes';
      sheet.getRangeByName('A4').text = 'Bananas';
      sheet.getRangeByName('A5').text = 'Oranges';
      sheet.getRangeByName('A6').text = 'Melons';
      sheet.getRangeByName('B1').text = 'Joey';
      sheet.getRangeByName('B2').number = 5;
      sheet.getRangeByName('B3').number = 4;
      sheet.getRangeByName('B4').number = 4;
      sheet.getRangeByName('B5').number = 2;
      sheet.getRangeByName('B6').number = 2;
      sheet.getRangeByName('C1').text = 'Mathew';
      sheet.getRangeByName('C2').number = 3;
      sheet.getRangeByName('C3').number = 5;
      sheet.getRangeByName('C4').number = 4;
      sheet.getRangeByName('C5').number = 1;
      sheet.getRangeByName('C6').number = 7;
      sheet.getRangeByName('D1').text = 'Peter';
      sheet.getRangeByName('D2').number = 2;
      sheet.getRangeByName('D3').number = 2;
      sheet.getRangeByName('D4').number = 3;
      sheet.getRangeByName('D5').number = 5;
      sheet.getRangeByName('D6').number = 6;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.columnStacked100;
      chart.dataRange = sheet.getRangeByName('A1:D6');
      chart.isSeriesInRows = false;

      //Set Chart Title
      chart.chartTitle = 'Stacked 100 Area Chart';

      //Set Legend
      chart.hasLegend = true;
      chart.legend!.position = ExcelLegendPosition.bottom;

      //Positioning the chart in the worksheet
      chart.topRow = 8;
      chart.leftColumn = 1;
      chart.bottomRow = 23;
      chart.rightColumn = 8;

      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      saveAsExcel(bytes, 'ColumnStacked100Chart.xlsx');
    });

    test('BarStacked100Chart', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Fruits';
      sheet.getRangeByName('A2').text = 'Apples';
      sheet.getRangeByName('A3').text = 'Grapes';
      sheet.getRangeByName('A4').text = 'Bananas';
      sheet.getRangeByName('A5').text = 'Oranges';
      sheet.getRangeByName('A6').text = 'Melons';
      sheet.getRangeByName('B1').text = 'Joey';
      sheet.getRangeByName('B2').number = 5;
      sheet.getRangeByName('B3').number = 4;
      sheet.getRangeByName('B4').number = 4;
      sheet.getRangeByName('B5').number = 2;
      sheet.getRangeByName('B6').number = 2;
      sheet.getRangeByName('C1').text = 'Mathew';
      sheet.getRangeByName('C2').number = 3;
      sheet.getRangeByName('C3').number = 5;
      sheet.getRangeByName('C4').number = 4;
      sheet.getRangeByName('C5').number = 1;
      sheet.getRangeByName('C6').number = 7;
      sheet.getRangeByName('D1').text = 'Peter';
      sheet.getRangeByName('D2').number = 2;
      sheet.getRangeByName('D3').number = 2;
      sheet.getRangeByName('D4').number = 3;
      sheet.getRangeByName('D5').number = 5;
      sheet.getRangeByName('D6').number = 6;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.barStacked100;
      chart.dataRange = sheet.getRangeByName('A1:D6');
      chart.isSeriesInRows = false;

      //Set Chart Title
      chart.chartTitle = 'Stacked 100 Area Chart';

      //Set Legend
      chart.hasLegend = true;
      chart.legend!.position = ExcelLegendPosition.bottom;

      //Positioning the chart in the worksheet
      chart.topRow = 8;
      chart.leftColumn = 1;
      chart.bottomRow = 23;
      chart.rightColumn = 8;

      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      saveAsExcel(bytes, 'BarStacked100Chart.xlsx');
    });

    test('LineStacked100Chart', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Fruits';
      sheet.getRangeByName('A2').text = 'Apples';
      sheet.getRangeByName('A3').text = 'Grapes';
      sheet.getRangeByName('A4').text = 'Bananas';
      sheet.getRangeByName('A5').text = 'Oranges';
      sheet.getRangeByName('A6').text = 'Melons';
      sheet.getRangeByName('B1').text = 'Joey';
      sheet.getRangeByName('B2').number = 5;
      sheet.getRangeByName('B3').number = 4;
      sheet.getRangeByName('B4').number = 4;
      sheet.getRangeByName('B5').number = 2;
      sheet.getRangeByName('B6').number = 2;
      sheet.getRangeByName('C1').text = 'Mathew';
      sheet.getRangeByName('C2').number = 3;
      sheet.getRangeByName('C3').number = 5;
      sheet.getRangeByName('C4').number = 4;
      sheet.getRangeByName('C5').number = 1;
      sheet.getRangeByName('C6').number = 7;
      sheet.getRangeByName('D1').text = 'Peter';
      sheet.getRangeByName('D2').number = 2;
      sheet.getRangeByName('D3').number = 2;
      sheet.getRangeByName('D4').number = 3;
      sheet.getRangeByName('D5').number = 5;
      sheet.getRangeByName('D6').number = 6;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.lineStacked100;
      chart.dataRange = sheet.getRangeByName('A1:D6');
      chart.isSeriesInRows = false;

      //Set Chart Title
      chart.chartTitle = 'Stacked 100 Line Chart';

      //Set Legend
      chart.hasLegend = true;
      chart.legend!.position = ExcelLegendPosition.bottom;

      //Positioning the chart in the worksheet
      chart.topRow = 8;
      chart.leftColumn = 1;
      chart.bottomRow = 23;
      chart.rightColumn = 8;

      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      saveAsExcel(bytes, 'LineStacked100Chart.xlsx');
    });
    test('Hyperlink and Images', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByIndex(1, 1);
      sheet.hyperlinks
          .add(range, HyperlinkType.url, 'http://www.syncfusion.com');
      sheet.pictures.addBase64(2, 1, image1jpg);
      final Range range1 = sheet.getRangeByIndex(1, 7);
      sheet.hyperlinks.add(range1, HyperlinkType.workbook, 'Sheet1!A15');
      sheet.getRangeByName('A11').text = 'Venue';
      sheet.getRangeByName('A12').text = 'Seating & Decor';
      sheet.getRangeByName('A13').text = 'Technical Team';
      sheet.getRangeByName('A14').text = 'performers';
      sheet.getRangeByName('B11').number = 1700;
      sheet.getRangeByName('B12').number = 1828;
      sheet.getRangeByName('B13').number = 800;
      sheet.getRangeByName('B14').number = 1400;
      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.column;
      chart.dataRange = sheet.getRangeByName('A11:B14');
      chart.isSeriesInRows = false;
      chart.topRow = 10;
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ChartHyperlinkImage.xlsx');
    });
    test('CategoryWithEmptyValue', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Items';
      sheet.getRangeByName('B1').text = r'Amount(in $)';
      sheet.getRangeByName('C1').text = 'Count';

      sheet.getRangeByName('A3').text = 'Condiments';
      sheet.getRangeByName('A4').text = 'Confections';
      sheet.getRangeByName('A5').text = 'Dairy Products';
      sheet.getRangeByName('A6').text = 'Grains / Cereals';

      sheet.getRangeByName('B2').number = 2776;
      sheet.getRangeByName('B3').number = 1077;
      sheet.getRangeByName('B4').number = 2287;
      sheet.getRangeByName('B5').number = 1368;
      sheet.getRangeByName('B6').number = 3325;

      sheet.getRangeByName('C2').number = 925;
      sheet.getRangeByName('C3').number = 378;
      sheet.getRangeByName('C4').number = 880;
      sheet.getRangeByName('C5').number = 581;
      sheet.getRangeByName('C6').number = 189;
      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.column;
      chart1.dataRange = sheet.getRangeByName('A1:C6');
      chart1.isSeriesInRows = false;
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ChartCategoryWithEmptyValue.xlsx');
    });
  });
}
