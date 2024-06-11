import 'package:syncfusion_flutter_xlsio/xlsio.dart';
// ignore: depend_on_referenced_packages, directives_ordering
import 'package:flutter_test/flutter_test.dart';
import '../../officechart.dart';

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
    test('FLUT-6975-Line with marker Chart', () {
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
      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.lineMarkers;
      chart1.dataRange = sheet.getRangeByName('A1:D6');
      chart1.chartTitle = 'Line chart with marker';
      chart1.isSeriesInRows = false;
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6975_ExcelLineChartwithmarker.xlsx');
    });
    test('FLUT-6975-Line stacked with marker', () {
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
      chart1.chartType = ExcelChartType.lineMarkersStacked;
      chart1.dataRange = sheet.getRangeByName('A1:C6');
      chart1.chartTitle = 'Stacked line chart with marker';
      chart1.isSeriesInRows = false;
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT-6975-ExcelLineStaChartwithmarker.xlsx');
    });

    test('FLUT-6975-Line stacked 100% with marker Chart', () {
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
      chart.chartType = ExcelChartType.lineMarkersStacked100;
      chart.dataRange = sheet.getRangeByName('A1:D6');
      chart.isSeriesInRows = false;

      //Set Chart Title
      chart.chartTitle = 'Line stcked 100 chart with marker ';

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

      saveAsExcel(bytes, 'FLUT-6975-Linestacked100%withMarker.xlsx');
    });

    test('FLUT_6975_3D_LineChart', () {
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
      sheet.getRangeByName('C11:C17').numberFormat = r'$#,##0_)';
      sheet.getRangeByName('C11').number = 18584;
      sheet.getRangeByName('C12').number = 1348;
      sheet.getRangeByName('C13').number = 400;
      sheet.getRangeByName('C14').number = 12000;
      sheet.getRangeByName('C15').number = 1800;
      sheet.getRangeByName('C16').number = 477;
      sheet.getRangeByName('C17').number = 1908;
      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.line3D;
      chart.dataRange = sheet.getRangeByName('A11:C17');
      chart.isSeriesInRows = false;

      //Set Chart Title
      chart.chartTitle = 'Line Chart 3D';

      //Set Rotation and Elevation
      chart.rotation = 20;
      chart.elevation = 15;
      chart.perspective = 45;

      //Positioning the chart in the worksheet
      chart.topRow = 8;
      chart.leftColumn = 1;
      chart.bottomRow = 23;
      chart.rightColumn = 8;

      ///Set gap depth for 3d line
      final ChartSerie serie1 = chart.series[0];
      serie1.serieFormat.commonSerieOptions.gapDepth = 120;

      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6975_3D_LineChart.xlsx');
    });
    test('FLUT_6975_3D_Column_chart', () {
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
      //Set Chart Title
      chart1.chartTitle = 'Column 3D';

      //Set Rotation and Elevation
      chart1.rotation = 40;
      chart1.elevation = 75;
      chart1.perspective = 25;

      //Positioning the chart in the worksheet
      chart1.topRow = 8;
      chart1.leftColumn = 1;
      chart1.bottomRow = 23;
      chart1.rightColumn = 8;
      chart1.chartType = ExcelChartType.column3D;
      chart1.dataRange = sheet.getRangeByName('A2:C6');

      //set gap width and gap depth
      final ChartSerie serie1 = chart1.series[0];
      serie1.serieFormat.commonSerieOptions.gapDepth = 120;
      serie1.serieFormat.commonSerieOptions.gapWidth = 125;

      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6975_3D_Column_chart.xlsx');
    });
    test('FLUT_6975_3D_Column_Clustered3D_chart', () {
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
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.columnClustered3D;
      chart.dataRange = sheet.getRangeByName('A1:C6');
      chart.isSeriesInRows = false;
      //Set Chart Title
      chart.chartTitle = 'Column Clustered 3D chart';

      //Set Rotation and Elevation
      chart.rotation = 35;
      chart.elevation = 25;
      chart.perspective = 45;

      //Positioning the chart in the worksheet
      chart.topRow = 8;
      chart.leftColumn = 1;
      chart.bottomRow = 23;
      chart.rightColumn = 8;

      chart.legend!.position = ExcelLegendPosition.right;
      chart.legend!.textArea.bold = true;
      chart.legend!.textArea.italic = true;
      chart.legend!.textArea.size = 14;
      chart.legend!.textArea.fontName = 'Arial';

      //set gap width and gap depth
      final ChartSerie serie1 = chart.series[0];
      serie1.serieFormat.commonSerieOptions.gapDepth = 105;
      serie1.serieFormat.commonSerieOptions.gapWidth = 105;

      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6975_3D_Column_Clustered3D_chart.xlsx');
    });
    test('FLUT_6975_Column_stacked_3D_chart', () {
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
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.columnStacked3D;
      chart.dataRange = sheet.getRangeByName('A1:C6');
      chart.isSeriesInRows = false;
      //Set Chart Title
      chart.chartTitle = 'Column stacked 3D chart';

      //set gap width and gap depth
      final ChartSerie serie1 = chart.series[0];
      serie1.serieFormat.commonSerieOptions.gapDepth = 135;
      serie1.serieFormat.commonSerieOptions.gapWidth = 120;

      //Set Rotation and Elevation
      chart.rotation = 60;
      chart.elevation = 25;
      chart.perspective = 25;

      //Positioning the chart in the worksheet
      chart.topRow = 8;
      chart.leftColumn = 1;
      chart.bottomRow = 23;
      chart.rightColumn = 8;
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6975_columnStacked3D.xlsx');
    });
    test('FLUT-6975-columnStacked100Chart3D', () {
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
      chart.chartType = ExcelChartType.columnStacked1003D;
      chart.dataRange = sheet.getRangeByName('A1:D6');
      chart.isSeriesInRows = false;

      //Set Chart Title
      chart.chartTitle = 'Column stacked 100 3D chart';

      //Set Rotation and Elevation
      chart.rotation = 30;
      chart.elevation = 55;
      chart.perspective = 50;

      //set gap width and gap depth
      final ChartSerie serie1 = chart.series[0];
      serie1.serieFormat.commonSerieOptions.gapDepth = 125;
      serie1.serieFormat.commonSerieOptions.gapWidth = 105;

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

      saveAsExcel(bytes, 'FLUT_6975_columnStacked1003D_chart.xlsx');
    });
    test('FLUT_6975_BarStacked3DChart', () {
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
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.barStacked3D;
      chart.dataRange = sheet.getRangeByName('A1:C6');
      chart.isSeriesInRows = false;
      //Set Chart Title
      chart.chartTitle = 'Bar stacked 3D chart';

      //Set Rotation and Elevation
      chart.rotation = 30;
      chart.elevation = 25;
      chart.perspective = 60;

      //Positioning the chart in the worksheet
      chart.topRow = 8;
      chart.leftColumn = 1;
      chart.bottomRow = 23;
      chart.rightColumn = 8;

      //set gap width and gap depth
      final ChartSerie serie1 = chart.series[0];
      serie1.serieFormat.commonSerieOptions.gapDepth = 145;
      serie1.serieFormat.commonSerieOptions.gapWidth = 165;

      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6975_BarStacked3DChart.xlsx');
    });
    test('FLUT_6975_Clustered3DBarchart', () {
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
      chart.chartType = ExcelChartType.barClustered3D;
      chart.dataRange = sheet.getRangeByName('A1:D6');
      chart.isSeriesInRows = false;

      //Set Chart Title
      chart.chartTitle = 'Bar Clustered 3D chart';

      //Set Rotation and Elevation
      chart.rotation = 20;
      chart.elevation = 40;
      chart.perspective = 45;

      //set gap width and gap depth
      final ChartSerie serie1 = chart.series[0];
      serie1.serieFormat.commonSerieOptions.gapDepth = 145;
      serie1.serieFormat.commonSerieOptions.gapWidth = 120;

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

      saveAsExcel(bytes, 'FLUT_6975_Clustered3DBarchart.xlsx');
    });

    test('FLUT_6975_BarStacked1003DChart', () {
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
      chart.chartType = ExcelChartType.barStacked1003D;
      chart.dataRange = sheet.getRangeByName('A1:D6');
      chart.isSeriesInRows = false;

      //Set Chart Title
      chart.chartTitle = 'Barstacked1003Dchart';

      //Set Rotation and Elevation
      chart.rotation = 60;
      chart.elevation = 15;
      chart.perspective = 25;

      //set gap width and gap depth
      final ChartSerie serie1 = chart.series[0];
      serie1.serieFormat.commonSerieOptions.gapDepth = 130;
      serie1.serieFormat.commonSerieOptions.gapWidth = 140;

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

      saveAsExcel(bytes, 'FLUT_6975_BarStacked1003DChart.xlsx');
    });
    test('FLUT_6975_PieOfPieChart', () {
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
      final Chart chart2 = charts.add();
      chart1.chartType = ExcelChartType.pieOfPie;
      chart1.dataRange = sheet.getRangeByName('A11:B17');
      chart1.isSeriesInRows = false;
      chart2.chartType = ExcelChartType.pieOfPie;
      chart2.dataRange = sheet.getRangeByName('A11:B17');
      chart2.isSeriesInRows = false;
      //Set Chart Title
      chart1.chartTitle = 'pie of pie chart';

      ///Set position for chart 2
      chart2.topRow = 27;
      chart2.leftColumn = 1;
      chart2.bottomRow = 42;
      chart2.rightColumn = 8;

      //set second pie size, gapwidth and explosion
      final ChartSerie serie1 = chart1.series[0];
      serie1.serieFormat.commonSerieOptions.pieSecondSize = 75;
      serie1.serieFormat.commonSerieOptions.gapWidth = 80;
      serie1.serieFormat.pieExplosionPercent = 10;

      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6975_PieOfPieChart.xlsx');
    });

    test('FLUT_6975_BarOfPieChart', () {
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
      final Chart chart2 = charts.add();
      chart1.chartType = ExcelChartType.pieBar;
      chart1.dataRange = sheet.getRangeByName('A11:B17');
      chart1.isSeriesInRows = false;

      chart2.chartType = ExcelChartType.pieBar;
      chart2.dataRange = sheet.getRangeByName('A11:B17');
      chart2.isSeriesInRows = false;
      //Set Chart Title
      chart1.chartTitle = 'pie of pie chart';

      ///Set position for chart 2
      chart2.topRow = 27;
      chart2.leftColumn = 1;
      chart2.bottomRow = 42;
      chart2.rightColumn = 8;

      //set second pie size, gapwidth and explosion
      final ChartSerie serie1 = chart1.series[0];
      serie1.serieFormat.commonSerieOptions.pieSecondSize = 65;
      serie1.serieFormat.commonSerieOptions.gapWidth = 70;
      serie1.serieFormat.pieExplosionPercent = 10;

      chart1.chartTitle = 'Bar of pie chart';
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6975_BarOfPieChart.xlsx');
    });
    test('FLUT_6975_Pie3DChart', () {
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
      chart1.chartType = ExcelChartType.pie3D;
      chart1.dataRange = sheet.getRangeByName('A11:B17');
      chart1.isSeriesInRows = false;

      //set first slice Angle and explosion
      final ChartSerie serie1 = chart1.series[0];
      serie1.serieFormat.commonSerieOptions.firstSliceAngle = 90;
      serie1.serieFormat.pieExplosionPercent = 105;
      chart1.elevation = 45;
      chart1.perspective = 20;
      //Positioning the chart in the worksheet
      chart1.topRow = 8;
      chart1.leftColumn = 1;
      chart1.bottomRow = 23;
      chart1.rightColumn = 8;

      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6975_Pie3DChart.xlsx');
    });
    test('FLUT_6975_Volume_High_low_close_chart', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Date';
      sheet.getRangeByName('A2').dateTime = DateTime(2017, 4);
      sheet.getRangeByName('A3').dateTime = DateTime(2017, 4, 2);
      sheet.getRangeByName('A4').dateTime = DateTime(2017, 4, 3);
      sheet.getRangeByName('A5').dateTime = DateTime(2017, 4, 4);
      sheet.getRangeByName('A6').dateTime = DateTime(2017, 4, 5);

      sheet.getRangeByName('B1').text = 'Volume';
      sheet.getRangeByName('B2').number = 10000;
      sheet.getRangeByName('B3').number = 20000;
      sheet.getRangeByName('B4').number = 30000;
      sheet.getRangeByName('B5').number = 25000;
      sheet.getRangeByName('B6').number = 15000;

      sheet.getRangeByName('C1').text = 'High';
      sheet.getRangeByName('C2').number = 50;
      sheet.getRangeByName('C3').number = 60;
      sheet.getRangeByName('C4').number = 55;
      sheet.getRangeByName('C5').number = 65;
      sheet.getRangeByName('C6').number = 70;

      sheet.getRangeByName('D1').text = 'Low';
      sheet.getRangeByName('D2').number = 10;
      sheet.getRangeByName('D3').number = 20;
      sheet.getRangeByName('D4').number = 15;
      sheet.getRangeByName('D5').number = 25;
      sheet.getRangeByName('D6').number = 30;

      sheet.getRangeByName('E1').text = 'Close';
      sheet.getRangeByName('E2').number = 40;
      sheet.getRangeByName('E3').number = 30;
      sheet.getRangeByName('E4').number = 45;
      sheet.getRangeByName('E5').number = 35;
      sheet.getRangeByName('E6').number = 60;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.dataRange = sheet.getRangeByName('A1:E6');
      //Set Chart Title
      chart1.chartTitle = 'Volume-High-Low-close';
      chart1.isSeriesInRows = false;

      //set gap width
      final ChartSerie serie1 = chart1.series[0];
      serie1.serieFormat.commonSerieOptions.gapWidth = 105;

      //Positioning the chart in the worksheet
      chart1.topRow = 8;
      chart1.leftColumn = 1;
      chart1.bottomRow = 23;
      chart1.rightColumn = 8;
      chart1.chartType = ExcelChartType.stockVolumeHighLowClose;
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6975_Volume_High_low_close_chart.xlsx');
    });
    test('FLUT_6975_Volume_open_High_low_close_chart', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Date';
      sheet.getRangeByName('A2').dateTime = DateTime(2017, 4);
      sheet.getRangeByName('A3').dateTime = DateTime(2017, 4, 2);
      sheet.getRangeByName('A4').dateTime = DateTime(2017, 4, 3);
      sheet.getRangeByName('A5').dateTime = DateTime(2017, 4, 4);
      sheet.getRangeByName('A6').dateTime = DateTime(2017, 4, 5);

      sheet.getRangeByName('B1').text = 'Volume';
      sheet.getRangeByName('B2').number = 10000;
      sheet.getRangeByName('B3').number = 20000;
      sheet.getRangeByName('B4').number = 30000;
      sheet.getRangeByName('B5').number = 25000;
      sheet.getRangeByName('B6').number = 15000;

      sheet.getRangeByName('C1').text = 'Open';
      sheet.getRangeByName('C2').number = 30;
      sheet.getRangeByName('C3').number = 40;
      sheet.getRangeByName('C4').number = 35;
      sheet.getRangeByName('C5').number = 45;
      sheet.getRangeByName('C6').number = 50;

      sheet.getRangeByName('D1').text = 'High';
      sheet.getRangeByName('D2').number = 50;
      sheet.getRangeByName('D3').number = 60;
      sheet.getRangeByName('D4').number = 55;
      sheet.getRangeByName('D5').number = 65;
      sheet.getRangeByName('D6').number = 70;

      sheet.getRangeByName('E1').text = 'Low';
      sheet.getRangeByName('E2').number = 10;
      sheet.getRangeByName('E3').number = 20;
      sheet.getRangeByName('E4').number = 15;
      sheet.getRangeByName('E5').number = 25;
      sheet.getRangeByName('E6').number = 30;

      sheet.getRangeByName('F1').text = 'Close';
      sheet.getRangeByName('F2').number = 40;
      sheet.getRangeByName('F3').number = 30;
      sheet.getRangeByName('F4').number = 45;
      sheet.getRangeByName('F5').number = 35;
      sheet.getRangeByName('F6').number = 60;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.stockVolumeOpenHighLowClose;
      chart1.dataRange = sheet.getRangeByName('A1:F6');

      //set gap width
      final ChartSerie serie1 = chart1.series[0];
      serie1.serieFormat.commonSerieOptions.gapWidth = 105;

      chart1.topRow = 8;
      chart1.leftColumn = 1;
      chart1.bottomRow = 23;
      chart1.rightColumn = 8;

      chart1.isSeriesInRows = false;
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();

      saveAsExcel(bytes, 'FLUT_6975_Volume_open_High_low_close_chart.xlsx');
    });
    test('FLUT_6975_Stock_Open_High_low_close_chart', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Date';
      sheet.getRangeByName('A2').text = 'Open';
      sheet.getRangeByName('A3').text = 'High';
      sheet.getRangeByName('A4').text = 'Low';
      sheet.getRangeByName('A5').text = 'Close';

      sheet.getRangeByName('B1').dateTime = DateTime(2017, 4);
      sheet.getRangeByName('B2').number = 30;
      sheet.getRangeByName('B3').number = 50;
      sheet.getRangeByName('B4').number = 10;
      sheet.getRangeByName('B5').number = 40;

      sheet.getRangeByName('C1').dateTime = DateTime(2017, 4, 2);
      sheet.getRangeByName('C2').number = 40;
      sheet.getRangeByName('C3').number = 60;
      sheet.getRangeByName('C4').number = 20;
      sheet.getRangeByName('C5').number = 30;

      sheet.getRangeByName('D1').dateTime = DateTime(2017, 4, 3);
      sheet.getRangeByName('D2').number = 35;
      sheet.getRangeByName('D3').number = 55;
      sheet.getRangeByName('D4').number = 15;
      sheet.getRangeByName('D5').number = 45;

      sheet.getRangeByName('E1').dateTime = DateTime(2017, 4, 4);
      sheet.getRangeByName('E2').number = 45;
      sheet.getRangeByName('E3').number = 65;
      sheet.getRangeByName('E4').number = 25;
      sheet.getRangeByName('E5').number = 35;

      sheet.getRangeByName('F1').dateTime = DateTime(2017, 4, 5);
      sheet.getRangeByName('F2').number = 50;
      sheet.getRangeByName('F3').number = 70;
      sheet.getRangeByName('F4').number = 30;
      sheet.getRangeByName('F5').number = 60;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.dataRange = sheet.getRangeByName('A1:F5');
      //Set Chart Title
      chart1.chartTitle = 'Open_highlow-close';

      //Positioning the chart in the worksheet
      chart1.topRow = 3;
      chart1.leftColumn = 1;
      chart1.bottomRow = 23;
      chart1.rightColumn = 8;
      chart1.chartType = ExcelChartType.stockOpenHighLowClose;

      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6975_Stock_Open_High_low_close_chart.xlsx');
    });
    test('FLUT_6975_Stock_High_low_close', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Date';
      sheet.getRangeByName('A2').text = 'High';
      sheet.getRangeByName('A3').text = 'Low';
      sheet.getRangeByName('A4').text = 'Close';

      sheet.getRangeByName('B1').dateTime = DateTime(2017, 4);
      sheet.getRangeByName('B2').number = 50;
      sheet.getRangeByName('B3').number = 10;
      sheet.getRangeByName('B4').number = 40;

      sheet.getRangeByName('C1').dateTime = DateTime(2017, 4, 2);
      sheet.getRangeByName('C2').number = 60;
      sheet.getRangeByName('C3').number = 20;
      sheet.getRangeByName('C4').number = 30;

      sheet.getRangeByName('D1').dateTime = DateTime(2017, 4, 3);
      sheet.getRangeByName('D2').number = 55;
      sheet.getRangeByName('D3').number = 15;
      sheet.getRangeByName('D4').number = 45;

      sheet.getRangeByName('E1').dateTime = DateTime(2017, 4, 4);
      sheet.getRangeByName('E2').number = 65;
      sheet.getRangeByName('E3').number = 25;
      sheet.getRangeByName('E4').number = 35;

      sheet.getRangeByName('F1').dateTime = DateTime(2017, 4, 5);
      sheet.getRangeByName('F2').number = 70;
      sheet.getRangeByName('F3').number = 30;
      sheet.getRangeByName('F4').number = 60;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.dataRange = sheet.getRangeByName('A1:F4');
      //Set Chart Title
      chart1.chartTitle = 'High-Low-close';

      //Positioning the chart in the worksheet
      chart1.topRow = 3;
      chart1.leftColumn = 1;
      chart1.bottomRow = 23;
      chart1.rightColumn = 8;
      chart1.chartType = ExcelChartType.stockHighLowClose;

      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6975_Stock_High_low_close.xlsx');
    });
    test('FLUT_6975_Stock_charts in single sheet', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Date';
      sheet.getRangeByName('A2').dateTime = DateTime(2017, 4);
      sheet.getRangeByName('A3').dateTime = DateTime(2017, 4, 2);
      sheet.getRangeByName('A4').dateTime = DateTime(2017, 4, 3);
      sheet.getRangeByName('A5').dateTime = DateTime(2017, 4, 4);
      sheet.getRangeByName('A6').dateTime = DateTime(2017, 4, 5);

      sheet.getRangeByName('B1').text = 'Volume';
      sheet.getRangeByName('B2').number = 10000;
      sheet.getRangeByName('B3').number = 20000;
      sheet.getRangeByName('B4').number = 30000;
      sheet.getRangeByName('B5').number = 25000;
      sheet.getRangeByName('B6').number = 15000;

      sheet.getRangeByName('C1').text = 'Open';
      sheet.getRangeByName('C2').number = 30;
      sheet.getRangeByName('C3').number = 40;
      sheet.getRangeByName('C4').number = 35;
      sheet.getRangeByName('C5').number = 45;
      sheet.getRangeByName('C6').number = 50;

      sheet.getRangeByName('D1').text = 'High';
      sheet.getRangeByName('D2').number = 50;
      sheet.getRangeByName('D3').number = 60;
      sheet.getRangeByName('D4').number = 55;
      sheet.getRangeByName('D5').number = 65;
      sheet.getRangeByName('D6').number = 70;

      sheet.getRangeByName('E1').text = 'Low';
      sheet.getRangeByName('E2').number = 10;
      sheet.getRangeByName('E3').number = 20;
      sheet.getRangeByName('E4').number = 15;
      sheet.getRangeByName('E5').number = 25;
      sheet.getRangeByName('E6').number = 30;

      sheet.getRangeByName('F1').text = 'Close';
      sheet.getRangeByName('F2').number = 40;
      sheet.getRangeByName('F3').number = 30;
      sheet.getRangeByName('F4').number = 45;
      sheet.getRangeByName('F5').number = 35;
      sheet.getRangeByName('F6').number = 60;
      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.dataRange = sheet.getRangeByName('A1:F6');
      //Set Chart Title
      chart1.chartTitle = 'Stock chart';
      chart1.isSeriesInRows = false;

      //set gap width
      final ChartSerie serie1 = chart1.series[0];
      serie1.serieFormat.commonSerieOptions.gapWidth = 105;

      //Positioning the chart in the worksheet
      chart1.topRow = 8;
      chart1.leftColumn = 1;
      chart1.bottomRow = 23;
      chart1.rightColumn = 8;
      chart1.chartType = ExcelChartType.stockVolumeOpenHighLowClose;
      sheet.charts = charts;

      sheet.getRangeByName('A7').text = 'Date';
      sheet.getRangeByName('A8').text = 'Open';
      sheet.getRangeByName('A9').text = 'High';
      sheet.getRangeByName('A10').text = 'Low';
      sheet.getRangeByName('A11').text = 'Close';

      sheet.getRangeByName('B7').dateTime = DateTime(2017, 4);
      sheet.getRangeByName('B8').number = 30;
      sheet.getRangeByName('B9').number = 50;
      sheet.getRangeByName('B10').number = 10;
      sheet.getRangeByName('B11').number = 40;

      sheet.getRangeByName('C7').dateTime = DateTime(2017, 4, 2);
      sheet.getRangeByName('C8').number = 40;
      sheet.getRangeByName('C9').number = 60;
      sheet.getRangeByName('C10').number = 20;
      sheet.getRangeByName('C11').number = 30;

      sheet.getRangeByName('D7').dateTime = DateTime(2017, 4, 3);
      sheet.getRangeByName('D8').number = 35;
      sheet.getRangeByName('D9').number = 55;
      sheet.getRangeByName('D10').number = 15;
      sheet.getRangeByName('D11').number = 45;

      sheet.getRangeByName('E7').dateTime = DateTime(2017, 4, 4);
      sheet.getRangeByName('E8').number = 45;
      sheet.getRangeByName('E9').number = 65;
      sheet.getRangeByName('E10').number = 25;
      sheet.getRangeByName('E11').number = 35;

      sheet.getRangeByName('F7').dateTime = DateTime(2017, 4, 5);
      sheet.getRangeByName('F8').number = 50;
      sheet.getRangeByName('F9').number = 70;
      sheet.getRangeByName('F10').number = 30;
      sheet.getRangeByName('F11').number = 60;

      final Chart chart2 = charts.add();
      chart2.dataRange = sheet.getRangeByName('A7:F11');
      //Set Chart Title
      chart2.chartTitle = 'Stock chart';
      chart2.isSeriesInRows = true;
      chart2.chartType = ExcelChartType.stockOpenHighLowClose;

      sheet.getRangeByName('A12').text = 'Date';
      sheet.getRangeByName('A13').text = 'High';
      sheet.getRangeByName('A14').text = 'Low';
      sheet.getRangeByName('A15').text = 'Close';

      sheet.getRangeByName('B12').dateTime = DateTime(2017, 4);
      sheet.getRangeByName('B13').number = 50;
      sheet.getRangeByName('B14').number = 10;
      sheet.getRangeByName('B15').number = 40;

      sheet.getRangeByName('C12').dateTime = DateTime(2017, 4, 2);
      sheet.getRangeByName('C13').number = 60;
      sheet.getRangeByName('C14').number = 20;
      sheet.getRangeByName('C15').number = 30;

      sheet.getRangeByName('D12').dateTime = DateTime(2017, 4, 3);
      sheet.getRangeByName('D13').number = 55;
      sheet.getRangeByName('D14').number = 15;
      sheet.getRangeByName('D15').number = 45;

      sheet.getRangeByName('E12').dateTime = DateTime(2017, 4, 4);
      sheet.getRangeByName('E13').number = 65;
      sheet.getRangeByName('E14').number = 25;
      sheet.getRangeByName('E15').number = 35;

      sheet.getRangeByName('F12').dateTime = DateTime(2017, 4, 5);
      sheet.getRangeByName('F13').number = 70;
      sheet.getRangeByName('F14').number = 30;
      sheet.getRangeByName('F15').number = 60;

      final Chart chart3 = charts.add();
      chart3.dataRange = sheet.getRangeByName('A12:F15');
      //Set Chart Title
      chart3.chartTitle = 'High-Low-close';
      chart3.isSeriesInRows = true;
      chart3.chartType = ExcelChartType.stockHighLowClose;

      sheet.getRangeByName('A16').text = 'Date';
      sheet.getRangeByName('A17').dateTime = DateTime(2017, 4);
      sheet.getRangeByName('A18').dateTime = DateTime(2017, 4, 2);
      sheet.getRangeByName('A19').dateTime = DateTime(2017, 4, 3);
      sheet.getRangeByName('A20').dateTime = DateTime(2017, 4, 4);
      sheet.getRangeByName('A21').dateTime = DateTime(2017, 4, 5);

      sheet.getRangeByName('B16').text = 'Volume';
      sheet.getRangeByName('B17').number = 10000;
      sheet.getRangeByName('B18').number = 20000;
      sheet.getRangeByName('B19').number = 30000;
      sheet.getRangeByName('B20').number = 25000;
      sheet.getRangeByName('B21').number = 15000;

      sheet.getRangeByName('C16').text = 'High';
      sheet.getRangeByName('C17').number = 50;
      sheet.getRangeByName('C18').number = 60;
      sheet.getRangeByName('C19').number = 55;
      sheet.getRangeByName('C20').number = 65;
      sheet.getRangeByName('C21').number = 70;

      sheet.getRangeByName('D16').text = 'Low';
      sheet.getRangeByName('D17').number = 10;
      sheet.getRangeByName('D18').number = 20;
      sheet.getRangeByName('D19').number = 15;
      sheet.getRangeByName('D20').number = 25;
      sheet.getRangeByName('D21').number = 30;

      sheet.getRangeByName('E16').text = 'Close';
      sheet.getRangeByName('E17').number = 40;
      sheet.getRangeByName('E18').number = 30;
      sheet.getRangeByName('E19').number = 45;
      sheet.getRangeByName('E20').number = 35;
      sheet.getRangeByName('E21').number = 60;

      final Chart chart4 = charts.add();
      chart4.dataRange = sheet.getRangeByName('A16:E21');
      //Set Chart Title
      chart4.chartTitle = 'Volume-High-Low-close-chart';
      chart4.isSeriesInRows = false;

      //set gap width
      final ChartSerie serie2 = chart4.series[0];
      serie2.serieFormat.commonSerieOptions.gapWidth = 105;

      //Positioning the charts in the worksheet
      chart1.topRow = 8;
      chart1.leftColumn = 1;
      chart1.bottomRow = 23;
      chart1.rightColumn = 8;

      chart2.topRow = 8;
      chart2.leftColumn = 10;
      chart2.bottomRow = 22;
      chart2.rightColumn = 19;

      chart3.topRow = 27;
      chart3.leftColumn = 1;
      chart3.bottomRow = 42;
      chart3.rightColumn = 8;

      chart4.topRow = 27;
      chart4.leftColumn = 10;
      chart4.bottomRow = 42;
      chart4.rightColumn = 19;

      chart4.chartType = ExcelChartType.stockVolumeHighLowClose;
      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();

      saveAsExcel(bytes, 'FLUT_6975_Sock_charts.xlsx');
    });
    test('FLUT_6975_3D_charts', () {
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
      final Chart chart1 = charts.add();
      final Chart chart2 = charts.add();
      final Chart chart3 = charts.add();
      final Chart chart4 = charts.add();
      final Chart chart5 = charts.add();

      chart1.chartType = ExcelChartType.line3D;
      chart1.dataRange = sheet.getRangeByName('A1:D6');

      chart2.chartType = ExcelChartType.column3D;
      chart2.dataRange = sheet.getRangeByName('A1:D6');

      chart3.chartType = ExcelChartType.columnClustered3D;
      chart3.dataRange = sheet.getRangeByName('A1:D6');

      chart4.chartType = ExcelChartType.columnStacked1003D;
      chart4.dataRange = sheet.getRangeByName('A1:D6');

      chart5.chartType = ExcelChartType.barStacked1003D;
      chart5.dataRange = sheet.getRangeByName('A1:D6');

      //Set Chart Title
      chart1.chartTitle = 'Line 3D chart';
      chart2.chartTitle = 'column 3D chart';
      chart3.chartTitle = 'Column clustered 3D chart';
      chart4.chartTitle = 'ColumnStacked1003D chart';
      chart5.chartTitle = 'Barstacked100 chart';
      //Set Rotation and Elevation,perspective
      chart1.rotation = 20;
      chart1.elevation = 15;
      chart1.perspective = 25;
      final ChartSerie serie1 = chart1.series[0];
      serie1.serieFormat.commonSerieOptions.gapDepth = 55;

      chart2.rotation = 20;
      chart2.elevation = 15;
      chart2.perspective = 30;
      chart2.rightAngleAxes = false;

      chart3.rotation = 25;
      chart3.elevation = 10;
      chart3.perspective = 40;
      chart3.rightAngleAxes = false;

      chart3.rotation = 40;
      chart3.elevation = 55;
      chart3.perspective = 15;

      chart4.rotation = 30;
      chart4.elevation = 25;
      chart4.perspective = 25;

      chart5.rotation = 35;
      chart5.elevation = 60;
      chart5.perspective = 10;

      //Positioning the charts in the worksheet
      chart1.topRow = 8;
      chart1.leftColumn = 1;
      chart1.bottomRow = 23;
      chart1.rightColumn = 8;

      chart2.topRow = 8;
      chart2.leftColumn = 10;
      chart2.bottomRow = 22;
      chart2.rightColumn = 19;

      chart3.topRow = 27;
      chart3.leftColumn = 1;
      chart3.bottomRow = 42;
      chart3.rightColumn = 8;

      chart4.topRow = 27;
      chart4.leftColumn = 10;
      chart4.bottomRow = 42;
      chart4.rightColumn = 19;

      chart5.topRow = 45;
      chart5.leftColumn = 1;
      chart5.bottomRow = 60;
      chart5.rightColumn = 8;

      chart1.isSeriesInRows = false;
      chart2.isSeriesInRows = false;

      sheet.charts = charts;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6975_3D_charts.xlsx');
    });
    test('FLUT_6975_doughNutExploded_chart', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Food';
      sheet.getRangeByName('A2').text = 'Fruit';
      sheet.getRangeByName('A3').text = 'Vegetable';
      sheet.getRangeByName('A4').text = 'Dairy';
      sheet.getRangeByName('A5').text = 'Proptein';
      sheet.getRangeByName('A6').text = 'Grains';
      sheet.getRangeByName('A7').text = 'Others';

      sheet.getRangeByName('B1').text = 'Percentage';
      sheet.getRangeByName('B2').number = 0.36;
      sheet.getRangeByName('B3').number = 0.14;
      sheet.getRangeByName('B4').number = 0.13;
      sheet.getRangeByName('B5').number = 0.28;
      sheet.getRangeByName('B6').number = 0.9;
      sheet.getRangeByName('B7').number = 0.15;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.doughnutExploded;
      chart.dataRange = sheet.getRangeByName('A2:B7');
      chart.isSeriesInRows = false;

      ///set doughnut hole size
      chart.series[0].serieFormat.commonSerieOptions.holeSizePercent = 50;

      ///set firstslice angle
      chart.series[0].serieFormat.commonSerieOptions.firstSliceAngle = 20;

      ///set explosion percentage
      chart.series[0].serieFormat.pieExplosionPercent = 30;

      //Set Chart Title
      chart.chartTitle = 'Exploded Doughnut Chart ';

      chart.series[0].dataLabels.isValue = true;

      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6975_doughnutExploded_chart.xlsx');
    });
    test('FLUT_6975_doughNut_chart', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Company';
      sheet.getRangeByName('A2').text = 'Company A';
      sheet.getRangeByName('A3').text = 'Company B';
      sheet.getRangeByName('A4').text = 'Company C';
      sheet.getRangeByName('A5').text = 'Company D';
      sheet.getRangeByName('A6').text = 'Company E';
      sheet.getRangeByName('A7').text = 'Others';

      sheet.getRangeByName('B1').dateTime = DateTime(2016);
      sheet.getRangeByName('B2').number = 0.28;
      sheet.getRangeByName('B3').number = 0.5;
      sheet.getRangeByName('B4').number = 0.17;
      sheet.getRangeByName('B5').number = 0.18;
      sheet.getRangeByName('B6').number = 0.17;
      sheet.getRangeByName('B7').number = 0.15;

      sheet.getRangeByName('C1').dateTime = DateTime(2017);
      sheet.getRangeByName('C2').number = 0.25;
      sheet.getRangeByName('C3').number = 0.9;
      sheet.getRangeByName('C4').number = 0.19;
      sheet.getRangeByName('C5').number = 0.22;
      sheet.getRangeByName('C6').number = 0.15;
      sheet.getRangeByName('C7').number = 0.10;

      sheet.getRangeByName('D1').dateTime = DateTime(2018);
      sheet.getRangeByName('D2').number = 0.35;
      sheet.getRangeByName('D3').number = 0.1;
      sheet.getRangeByName('D4').number = 0.145;
      sheet.getRangeByName('D5').number = 0.55;
      sheet.getRangeByName('D6').number = 0.55;
      sheet.getRangeByName('D7').number = 0.40;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.doughnut;
      chart.dataRange = sheet.getRangeByName('A2:D7');
      chart.isSeriesInRows = false;

      chart.series[0].serieFormat.commonSerieOptions.holeSizePercent = 80;
      chart.series[0].serieFormat.commonSerieOptions.firstSliceAngle = 10;
      chart.series[0].serieFormat.pieExplosionPercent = 50;

      //Set Chart Title
      chart.chartTitle = 'Doughnut Chart ';

      chart.series[0].dataLabels.isValue = true;
      chart.series[1].dataLabels.isValue = true;
      chart.series[2].dataLabels.isValue = true;

      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6975_doughnut_chart.xlsx');
    });
    test('FLUT_6975_Stockchartwithmarker', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Date';
      sheet.getRangeByName('A2').text = 'Open';
      sheet.getRangeByName('A3').text = 'High';
      sheet.getRangeByName('A4').text = 'Low';
      sheet.getRangeByName('A5').text = 'Close';

      sheet.getRangeByName('B1').dateTime = DateTime(2017, 4);
      sheet.getRangeByName('B2').number = 30;
      sheet.getRangeByName('B3').number = 50;
      sheet.getRangeByName('B4').number = 10;
      sheet.getRangeByName('B5').number = 40;

      sheet.getRangeByName('C1').dateTime = DateTime(2017, 4, 2);
      sheet.getRangeByName('C2').number = 40;
      sheet.getRangeByName('C3').number = 60;
      sheet.getRangeByName('C4').number = 20;
      sheet.getRangeByName('C5').number = 30;

      sheet.getRangeByName('D1').dateTime = DateTime(2017, 4, 3);
      sheet.getRangeByName('D2').number = 35;
      sheet.getRangeByName('D3').number = 55;
      sheet.getRangeByName('D4').number = 15;
      sheet.getRangeByName('D5').number = 45;

      sheet.getRangeByName('E1').dateTime = DateTime(2017, 4, 4);
      sheet.getRangeByName('E2').number = 45;
      sheet.getRangeByName('E3').number = 65;
      sheet.getRangeByName('E4').number = 25;
      sheet.getRangeByName('E5').number = 35;

      sheet.getRangeByName('F1').dateTime = DateTime(2017, 4, 5);
      sheet.getRangeByName('F2').number = 50;
      sheet.getRangeByName('F3').number = 70;
      sheet.getRangeByName('F4').number = 30;
      sheet.getRangeByName('F5').number = 60;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.dataRange = sheet.getRangeByName('A1:F5');
      //Set Chart Title
      chart1.chartTitle = 'Open_highlow-close';

      ///apply marker
      final ChartSerie serie1 = chart1.series[0];
      final ChartSerie serie2 = chart1.series[1];
      final ChartSerie serie3 = chart1.series[2];
      final ChartSerie serie4 = chart1.series[3];
      serie1.serieFormat.markerStyle = ExcelChartMarkerType.circle;
      serie1.serieFormat.markerBackgroundColor = '#0000FF';
      serie1.serieFormat.markerBorderColor = '#0000FF';

      serie2.serieFormat.markerStyle = ExcelChartMarkerType.square;
      serie2.serieFormat.markerBackgroundColor = '#FFA500';
      serie2.serieFormat.markerBorderColor = '#FFA500';

      serie3.serieFormat.markerStyle = ExcelChartMarkerType.starSquare;
      serie3.serieFormat.markerBackgroundColor = '#023020';
      serie3.serieFormat.markerBorderColor = '#023020';

      serie4.serieFormat.markerStyle = ExcelChartMarkerType.diamond;
      serie4.serieFormat.markerBackgroundColor = '#964B00';
      serie4.serieFormat.markerBorderColor = '#964B00';

      //Positioning the chart in the worksheet
      chart1.topRow = 3;
      chart1.leftColumn = 1;
      chart1.bottomRow = 23;
      chart1.rightColumn = 8;
      chart1.chartType = ExcelChartType.stockOpenHighLowClose;

      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'Stockchartwithmarker.xlsx');
    });

    test('FLUT-6975-Line with marker Chart', () {
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
      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.line;
      chart1.dataRange = sheet.getRangeByName('A1:D6');
      chart1.chartTitle = 'Line chart with marker';
      chart1.isSeriesInRows = false;

      ///apply marker
      final ChartSerie serie1 = chart1.series[0];
      final ChartSerie serie2 = chart1.series[1];
      final ChartSerie serie3 = chart1.series[2];

      serie1.serieFormat.markerStyle = ExcelChartMarkerType.circle;
      serie1.serieFormat.markerBackgroundColor = '#0000FF';
      serie1.serieFormat.markerBorderColor = '#0000FF';

      serie2.serieFormat.markerStyle = ExcelChartMarkerType.circle;
      serie2.serieFormat.markerBackgroundColor = '#FFA500';
      serie2.serieFormat.markerBorderColor = '#FFA500';

      serie3.serieFormat.markerStyle = ExcelChartMarkerType.circle;
      serie3.serieFormat.markerBackgroundColor = '#023020';
      serie3.serieFormat.markerBorderColor = '#023020';

      sheet.charts = charts;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6975_Line chart with custom marker.xlsx');
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
      chart.isSeriesInRows = true;
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
      final Picture picture = sheet.pictures.addBase64(3, 4, invoicejpeg);
      picture.lastRow = 7;
      picture.lastColumn = 8;

      final Picture picture2 = sheet.pictures.addBase64(3, 4, image1jpg);
      picture2.lastRow = 7;
      picture2.lastColumn = 8;

      final Picture picture3 = sheet.pictures.addBase64(3, 4, image3png);
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
      final Picture picture4 = sheet1.pictures.addBase64(3, 4, invoicejpeg);
      picture4.lastRow = 7;
      picture4.lastColumn = 8;

      final Picture picture5 = sheet1.pictures.addBase64(3, 4, image1jpg);
      picture5.lastRow = 7;
      picture5.lastColumn = 8;

      final Picture picture6 = sheet1.pictures.addBase64(3, 4, image10jpg);
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

      final Picture picture = sheet.pictures.addBase64(3, 4, invoicejpeg);
      picture.lastRow = 7;
      picture.lastColumn = 8;

      final Picture picture2 = sheet.pictures.addBase64(3, 4, image1jpg);
      picture2.lastRow = 7;
      picture2.lastColumn = 8;

      final Picture picture3 = sheet.pictures.addBase64(3, 4, image3png);
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
  group('Charts Async', () {
    test('FLUT-6975-Line with marker ChartAsync ', () async {
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
      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.lineMarkers;
      chart1.dataRange = sheet.getRangeByName('A1:D6');
      chart1.chartTitle = 'Line chart with marker';
      chart1.isSeriesInRows = false;
      sheet.charts = charts;
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'FLUT_6975_ExcelLineChartwithmarkerAsync.xlsx');
    });
    test('FLUT-6975-Line stacked with markerAsync ', () async {
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
      chart1.chartType = ExcelChartType.lineMarkersStacked;
      chart1.dataRange = sheet.getRangeByName('A1:C6');
      chart1.chartTitle = 'Stacked line chart with marker';
      chart1.isSeriesInRows = false;
      sheet.charts = charts;
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'FLUT-6975-ExcelLineStaChartwithmarkerAsync.xlsx');
    });

    test('FLUT_6975_3D_LineChartAsync ', () async {
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
      sheet.getRangeByName('C11:C17').numberFormat = r'$#,##0_)';
      sheet.getRangeByName('C11').number = 18584;
      sheet.getRangeByName('C12').number = 1348;
      sheet.getRangeByName('C13').number = 400;
      sheet.getRangeByName('C14').number = 12000;
      sheet.getRangeByName('C15').number = 1800;
      sheet.getRangeByName('C16').number = 477;
      sheet.getRangeByName('C17').number = 1908;
      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.line3D;
      chart.dataRange = sheet.getRangeByName('A11:C17');
      chart.isSeriesInRows = false;

      //Set Chart Title
      chart.chartTitle = 'Line Chart 3D';

      //Set Rotation and Elevation
      chart.rotation = 20;
      chart.elevation = 15;
      chart.perspective = 45;

      //Positioning the chart in the worksheet
      chart.topRow = 8;
      chart.leftColumn = 1;
      chart.bottomRow = 23;
      chart.rightColumn = 8;

      ///Set gap depth for 3d line
      final ChartSerie serie1 = chart.series[0];
      serie1.serieFormat.commonSerieOptions.gapDepth = 120;

      sheet.charts = charts;
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'FLUT_6975_3D_LineChartAsync.xlsx');
    });
    test('FLUT_6975_3D_Column_chartAsync ', () async {
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
      //Set Chart Title
      chart1.chartTitle = 'Column 3D';

      //Set Rotation and Elevation
      chart1.rotation = 40;
      chart1.elevation = 75;
      chart1.perspective = 25;

      //Positioning the chart in the worksheet
      chart1.topRow = 8;
      chart1.leftColumn = 1;
      chart1.bottomRow = 23;
      chart1.rightColumn = 8;
      chart1.chartType = ExcelChartType.column3D;
      chart1.dataRange = sheet.getRangeByName('A2:C6');

      //set gap width and gap depth
      final ChartSerie serie1 = chart1.series[0];
      serie1.serieFormat.commonSerieOptions.gapDepth = 120;
      serie1.serieFormat.commonSerieOptions.gapWidth = 125;

      sheet.charts = charts;
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'FLUT_6975_3D_Column_chartAsync.xlsx');
    });
    test('FLUT_6975_3D_Column_Clustered3D_chartAsync ', () async {
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
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.columnClustered3D;
      chart.dataRange = sheet.getRangeByName('A1:C6');
      chart.isSeriesInRows = false;
      //Set Chart Title
      chart.chartTitle = 'Column Clustered 3D chart';

      //Set Rotation and Elevation
      chart.rotation = 35;
      chart.elevation = 25;
      chart.perspective = 45;

      //Positioning the chart in the worksheet
      chart.topRow = 8;
      chart.leftColumn = 1;
      chart.bottomRow = 23;
      chart.rightColumn = 8;

      chart.legend!.position = ExcelLegendPosition.right;
      chart.legend!.textArea.bold = true;
      chart.legend!.textArea.italic = true;
      chart.legend!.textArea.size = 14;
      chart.legend!.textArea.fontName = 'Arial';

      //set gap width and gap depth
      final ChartSerie serie1 = chart.series[0];
      serie1.serieFormat.commonSerieOptions.gapDepth = 105;
      serie1.serieFormat.commonSerieOptions.gapWidth = 105;

      sheet.charts = charts;
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'FLUT_6975_3D_Column_Clustered3D_chartAsync.xlsx');
    });
    test('FLUT_6975_Column_stacked_3D_chartAsync ', () async {
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
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.columnStacked3D;
      chart.dataRange = sheet.getRangeByName('A1:C6');
      chart.isSeriesInRows = false;
      //Set Chart Title
      chart.chartTitle = 'Column stacked 3D chart';

      //set gap width and gap depth
      final ChartSerie serie1 = chart.series[0];
      serie1.serieFormat.commonSerieOptions.gapDepth = 135;
      serie1.serieFormat.commonSerieOptions.gapWidth = 120;

      //Set Rotation and Elevation
      chart.rotation = 60;
      chart.elevation = 25;
      chart.perspective = 25;

      //Positioning the chart in the worksheet
      chart.topRow = 8;
      chart.leftColumn = 1;
      chart.bottomRow = 23;
      chart.rightColumn = 8;
      sheet.charts = charts;
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'FLUT_6975_columnStacked3DAsync.xlsx');
    });
    test('FLUT-6975-columnStacked100Chart3DAsync ', () async {
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
      chart.chartType = ExcelChartType.columnStacked1003D;
      chart.dataRange = sheet.getRangeByName('A1:D6');
      chart.isSeriesInRows = false;

      //Set Chart Title
      chart.chartTitle = 'Column stacked 100 3D chart';

      //Set Rotation and Elevation
      chart.rotation = 30;
      chart.elevation = 55;
      chart.perspective = 50;

      //set gap width and gap depth
      final ChartSerie serie1 = chart.series[0];
      serie1.serieFormat.commonSerieOptions.gapDepth = 125;
      serie1.serieFormat.commonSerieOptions.gapWidth = 105;

      //Set Legend
      chart.hasLegend = true;
      chart.legend!.position = ExcelLegendPosition.bottom;

      //Positioning the chart in the worksheet
      chart.topRow = 8;
      chart.leftColumn = 1;
      chart.bottomRow = 23;
      chart.rightColumn = 8;

      sheet.charts = charts;
      final List<int> bytes = await workbook.save();
      workbook.dispose();

      saveAsExcel(bytes, 'FLUT_6975_columnStacked1003D_chartAsync.xlsx');
    });
    test('FLUT_6975_Pie3DChartAsync ', () async {
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
      chart1.chartType = ExcelChartType.pie3D;
      chart1.dataRange = sheet.getRangeByName('A11:B17');
      chart1.isSeriesInRows = false;

      //set first slice Angle and explosion
      final ChartSerie serie1 = chart1.series[0];
      serie1.serieFormat.commonSerieOptions.firstSliceAngle = 90;
      serie1.serieFormat.pieExplosionPercent = 105;
      chart1.elevation = 45;
      chart1.perspective = 20;
      //Positioning the chart in the worksheet
      chart1.topRow = 8;
      chart1.leftColumn = 1;
      chart1.bottomRow = 23;
      chart1.rightColumn = 8;

      sheet.charts = charts;
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'FLUT_6975_Pie3DChartAsync.xlsx');
    });
    test('FLUT_6975_Stock_charts in single sheetAsync ', () async {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Date';
      sheet.getRangeByName('A2').dateTime = DateTime(2017, 4);
      sheet.getRangeByName('A3').dateTime = DateTime(2017, 4, 2);
      sheet.getRangeByName('A4').dateTime = DateTime(2017, 4, 3);
      sheet.getRangeByName('A5').dateTime = DateTime(2017, 4, 4);
      sheet.getRangeByName('A6').dateTime = DateTime(2017, 4, 5);

      sheet.getRangeByName('B1').text = 'Volume';
      sheet.getRangeByName('B2').number = 10000;
      sheet.getRangeByName('B3').number = 20000;
      sheet.getRangeByName('B4').number = 30000;
      sheet.getRangeByName('B5').number = 25000;
      sheet.getRangeByName('B6').number = 15000;

      sheet.getRangeByName('C1').text = 'Open';
      sheet.getRangeByName('C2').number = 30;
      sheet.getRangeByName('C3').number = 40;
      sheet.getRangeByName('C4').number = 35;
      sheet.getRangeByName('C5').number = 45;
      sheet.getRangeByName('C6').number = 50;

      sheet.getRangeByName('D1').text = 'High';
      sheet.getRangeByName('D2').number = 50;
      sheet.getRangeByName('D3').number = 60;
      sheet.getRangeByName('D4').number = 55;
      sheet.getRangeByName('D5').number = 65;
      sheet.getRangeByName('D6').number = 70;

      sheet.getRangeByName('E1').text = 'Low';
      sheet.getRangeByName('E2').number = 10;
      sheet.getRangeByName('E3').number = 20;
      sheet.getRangeByName('E4').number = 15;
      sheet.getRangeByName('E5').number = 25;
      sheet.getRangeByName('E6').number = 30;

      sheet.getRangeByName('F1').text = 'Close';
      sheet.getRangeByName('F2').number = 40;
      sheet.getRangeByName('F3').number = 30;
      sheet.getRangeByName('F4').number = 45;
      sheet.getRangeByName('F5').number = 35;
      sheet.getRangeByName('F6').number = 60;
      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.dataRange = sheet.getRangeByName('A1:F6');
      //Set Chart Title
      chart1.chartTitle = 'Stock chart';
      chart1.isSeriesInRows = false;

      //set gap width
      final ChartSerie serie1 = chart1.series[0];
      serie1.serieFormat.commonSerieOptions.gapWidth = 105;

      //Positioning the chart in the worksheet
      chart1.topRow = 8;
      chart1.leftColumn = 1;
      chart1.bottomRow = 23;
      chart1.rightColumn = 8;
      chart1.chartType = ExcelChartType.stockVolumeOpenHighLowClose;
      sheet.charts = charts;

      sheet.getRangeByName('A7').text = 'Date';
      sheet.getRangeByName('A8').text = 'Open';
      sheet.getRangeByName('A9').text = 'High';
      sheet.getRangeByName('A10').text = 'Low';
      sheet.getRangeByName('A11').text = 'Close';

      sheet.getRangeByName('B7').dateTime = DateTime(2017, 4);
      sheet.getRangeByName('B8').number = 30;
      sheet.getRangeByName('B9').number = 50;
      sheet.getRangeByName('B10').number = 10;
      sheet.getRangeByName('B11').number = 40;

      sheet.getRangeByName('C7').dateTime = DateTime(2017, 4, 2);
      sheet.getRangeByName('C8').number = 40;
      sheet.getRangeByName('C9').number = 60;
      sheet.getRangeByName('C10').number = 20;
      sheet.getRangeByName('C11').number = 30;

      sheet.getRangeByName('D7').dateTime = DateTime(2017, 4, 3);
      sheet.getRangeByName('D8').number = 35;
      sheet.getRangeByName('D9').number = 55;
      sheet.getRangeByName('D10').number = 15;
      sheet.getRangeByName('D11').number = 45;

      sheet.getRangeByName('E7').dateTime = DateTime(2017, 4, 4);
      sheet.getRangeByName('E8').number = 45;
      sheet.getRangeByName('E9').number = 65;
      sheet.getRangeByName('E10').number = 25;
      sheet.getRangeByName('E11').number = 35;

      sheet.getRangeByName('F7').dateTime = DateTime(2017, 4, 5);
      sheet.getRangeByName('F8').number = 50;
      sheet.getRangeByName('F9').number = 70;
      sheet.getRangeByName('F10').number = 30;
      sheet.getRangeByName('F11').number = 60;

      final Chart chart2 = charts.add();
      chart2.dataRange = sheet.getRangeByName('A7:F11');
      //Set Chart Title
      chart2.chartTitle = 'Stock chart';
      chart2.isSeriesInRows = true;
      chart2.chartType = ExcelChartType.stockOpenHighLowClose;

      sheet.getRangeByName('A12').text = 'Date';
      sheet.getRangeByName('A13').text = 'High';
      sheet.getRangeByName('A14').text = 'Low';
      sheet.getRangeByName('A15').text = 'Close';

      sheet.getRangeByName('B12').dateTime = DateTime(2017, 4);
      sheet.getRangeByName('B13').number = 50;
      sheet.getRangeByName('B14').number = 10;
      sheet.getRangeByName('B15').number = 40;

      sheet.getRangeByName('C12').dateTime = DateTime(2017, 4, 2);
      sheet.getRangeByName('C13').number = 60;
      sheet.getRangeByName('C14').number = 20;
      sheet.getRangeByName('C15').number = 30;

      sheet.getRangeByName('D12').dateTime = DateTime(2017, 4, 3);
      sheet.getRangeByName('D13').number = 55;
      sheet.getRangeByName('D14').number = 15;
      sheet.getRangeByName('D15').number = 45;

      sheet.getRangeByName('E12').dateTime = DateTime(2017, 4, 4);
      sheet.getRangeByName('E13').number = 65;
      sheet.getRangeByName('E14').number = 25;
      sheet.getRangeByName('E15').number = 35;

      sheet.getRangeByName('F12').dateTime = DateTime(2017, 4, 5);
      sheet.getRangeByName('F13').number = 70;
      sheet.getRangeByName('F14').number = 30;
      sheet.getRangeByName('F15').number = 60;

      final Chart chart3 = charts.add();
      chart3.dataRange = sheet.getRangeByName('A12:F15');
      //Set Chart Title
      chart3.chartTitle = 'High-Low-close';
      chart3.isSeriesInRows = true;
      chart3.chartType = ExcelChartType.stockHighLowClose;

      sheet.getRangeByName('A16').text = 'Date';
      sheet.getRangeByName('A17').dateTime = DateTime(2017, 4);
      sheet.getRangeByName('A18').dateTime = DateTime(2017, 4, 2);
      sheet.getRangeByName('A19').dateTime = DateTime(2017, 4, 3);
      sheet.getRangeByName('A20').dateTime = DateTime(2017, 4, 4);
      sheet.getRangeByName('A21').dateTime = DateTime(2017, 4, 5);

      sheet.getRangeByName('B16').text = 'Volume';
      sheet.getRangeByName('B17').number = 10000;
      sheet.getRangeByName('B18').number = 20000;
      sheet.getRangeByName('B19').number = 30000;
      sheet.getRangeByName('B20').number = 25000;
      sheet.getRangeByName('B21').number = 15000;

      sheet.getRangeByName('C16').text = 'High';
      sheet.getRangeByName('C17').number = 50;
      sheet.getRangeByName('C18').number = 60;
      sheet.getRangeByName('C19').number = 55;
      sheet.getRangeByName('C20').number = 65;
      sheet.getRangeByName('C21').number = 70;

      sheet.getRangeByName('D16').text = 'Low';
      sheet.getRangeByName('D17').number = 10;
      sheet.getRangeByName('D18').number = 20;
      sheet.getRangeByName('D19').number = 15;
      sheet.getRangeByName('D20').number = 25;
      sheet.getRangeByName('D21').number = 30;

      sheet.getRangeByName('E16').text = 'Close';
      sheet.getRangeByName('E17').number = 40;
      sheet.getRangeByName('E18').number = 30;
      sheet.getRangeByName('E19').number = 45;
      sheet.getRangeByName('E20').number = 35;
      sheet.getRangeByName('E21').number = 60;

      final Chart chart4 = charts.add();
      chart4.dataRange = sheet.getRangeByName('A16:E21');
      //Set Chart Title
      chart4.chartTitle = 'Volume-High-Low-close-chart';
      chart4.isSeriesInRows = false;

      //set gap width
      final ChartSerie serie2 = chart4.series[0];
      serie2.serieFormat.commonSerieOptions.gapWidth = 105;

      //Positioning the charts in the worksheet
      chart1.topRow = 8;
      chart1.leftColumn = 1;
      chart1.bottomRow = 23;
      chart1.rightColumn = 8;

      chart2.topRow = 8;
      chart2.leftColumn = 10;
      chart2.bottomRow = 22;
      chart2.rightColumn = 19;

      chart3.topRow = 27;
      chart3.leftColumn = 1;
      chart3.bottomRow = 42;
      chart3.rightColumn = 8;

      chart4.topRow = 27;
      chart4.leftColumn = 10;
      chart4.bottomRow = 42;
      chart4.rightColumn = 19;

      chart4.chartType = ExcelChartType.stockVolumeHighLowClose;
      sheet.charts = charts;
      final List<int> bytes = await workbook.save();

      saveAsExcel(bytes, 'FLUT_6975_Sock_chartsAsync.xlsx');
    });
    test('FLUT_6975_3D_chartsAsync ', () async {
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
      final Chart chart1 = charts.add();
      final Chart chart2 = charts.add();
      final Chart chart3 = charts.add();
      final Chart chart4 = charts.add();
      final Chart chart5 = charts.add();

      chart1.chartType = ExcelChartType.line3D;
      chart1.dataRange = sheet.getRangeByName('A1:D6');

      chart2.chartType = ExcelChartType.column3D;
      chart2.dataRange = sheet.getRangeByName('A1:D6');

      chart3.chartType = ExcelChartType.columnClustered3D;
      chart3.dataRange = sheet.getRangeByName('A1:D6');

      chart4.chartType = ExcelChartType.columnStacked1003D;
      chart4.dataRange = sheet.getRangeByName('A1:D6');

      chart5.chartType = ExcelChartType.barStacked1003D;
      chart5.dataRange = sheet.getRangeByName('A1:D6');

      //Set Chart Title
      chart1.chartTitle = 'Line 3D chart';
      chart2.chartTitle = 'column 3D chart';
      chart3.chartTitle = 'Column clustered 3D chart';
      chart4.chartTitle = 'ColumnStacked1003D chart';
      chart5.chartTitle = 'Barstacked100 chart';
      //Set Rotation and Elevation,perspective
      chart1.rotation = 20;
      chart1.elevation = 15;
      chart1.perspective = 25;
      final ChartSerie serie1 = chart1.series[0];
      serie1.serieFormat.commonSerieOptions.gapDepth = 55;

      chart2.rotation = 20;
      chart2.elevation = 15;
      chart2.perspective = 30;
      chart2.rightAngleAxes = false;

      chart3.rotation = 25;
      chart3.elevation = 10;
      chart3.perspective = 40;
      chart3.rightAngleAxes = false;

      chart3.rotation = 40;
      chart3.elevation = 55;
      chart3.perspective = 15;

      chart4.rotation = 30;
      chart4.elevation = 25;
      chart4.perspective = 25;

      chart5.rotation = 35;
      chart5.elevation = 60;
      chart5.perspective = 10;

      //Positioning the charts in the worksheet
      chart1.topRow = 8;
      chart1.leftColumn = 1;
      chart1.bottomRow = 23;
      chart1.rightColumn = 8;

      chart2.topRow = 8;
      chart2.leftColumn = 10;
      chart2.bottomRow = 22;
      chart2.rightColumn = 19;

      chart3.topRow = 27;
      chart3.leftColumn = 1;
      chart3.bottomRow = 42;
      chart3.rightColumn = 8;

      chart4.topRow = 27;
      chart4.leftColumn = 10;
      chart4.bottomRow = 42;
      chart4.rightColumn = 19;

      chart5.topRow = 45;
      chart5.leftColumn = 1;
      chart5.bottomRow = 60;
      chart5.rightColumn = 8;

      chart1.isSeriesInRows = false;
      chart2.isSeriesInRows = false;

      sheet.charts = charts;

      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'FLUT_6975_3D_chartsAsync.xlsx');
    });
    test('FLUT_6975_doughNut_chartAsync ', () async {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Company';
      sheet.getRangeByName('A2').text = 'Company A';
      sheet.getRangeByName('A3').text = 'Company B';
      sheet.getRangeByName('A4').text = 'Company C';
      sheet.getRangeByName('A5').text = 'Company D';
      sheet.getRangeByName('A6').text = 'Company E';
      sheet.getRangeByName('A7').text = 'Others';

      sheet.getRangeByName('B1').dateTime = DateTime(2016);
      sheet.getRangeByName('B2').number = 0.28;
      sheet.getRangeByName('B3').number = 0.5;
      sheet.getRangeByName('B4').number = 0.17;
      sheet.getRangeByName('B5').number = 0.18;
      sheet.getRangeByName('B6').number = 0.17;
      sheet.getRangeByName('B7').number = 0.15;

      sheet.getRangeByName('C1').dateTime = DateTime(2017);
      sheet.getRangeByName('C2').number = 0.25;
      sheet.getRangeByName('C3').number = 0.9;
      sheet.getRangeByName('C4').number = 0.19;
      sheet.getRangeByName('C5').number = 0.22;
      sheet.getRangeByName('C6').number = 0.15;
      sheet.getRangeByName('C7').number = 0.10;

      sheet.getRangeByName('D1').dateTime = DateTime(2018);
      sheet.getRangeByName('D2').number = 0.35;
      sheet.getRangeByName('D3').number = 0.1;
      sheet.getRangeByName('D4').number = 0.145;
      sheet.getRangeByName('D5').number = 0.55;
      sheet.getRangeByName('D6').number = 0.55;
      sheet.getRangeByName('D7').number = 0.40;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart = charts.add();
      chart.chartType = ExcelChartType.doughnut;
      chart.dataRange = sheet.getRangeByName('A2:D7');
      chart.isSeriesInRows = false;

      chart.series[0].serieFormat.commonSerieOptions.holeSizePercent = 80;
      chart.series[0].serieFormat.commonSerieOptions.firstSliceAngle = 10;
      chart.series[0].serieFormat.pieExplosionPercent = 50;

      //Set Chart Title
      chart.chartTitle = 'Doughnut Chart ';

      chart.series[0].dataLabels.isValue = true;
      chart.series[1].dataLabels.isValue = true;
      chart.series[2].dataLabels.isValue = true;

      sheet.charts = charts;
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'FLUT_6975_doughnut_chartAsync.xlsx');
    });
    test('FLUT_6975_StockchartwithmarkerAsync ', () async {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Date';
      sheet.getRangeByName('A2').text = 'Open';
      sheet.getRangeByName('A3').text = 'High';
      sheet.getRangeByName('A4').text = 'Low';
      sheet.getRangeByName('A5').text = 'Close';

      sheet.getRangeByName('B1').dateTime = DateTime(2017, 4);
      sheet.getRangeByName('B2').number = 30;
      sheet.getRangeByName('B3').number = 50;
      sheet.getRangeByName('B4').number = 10;
      sheet.getRangeByName('B5').number = 40;

      sheet.getRangeByName('C1').dateTime = DateTime(2017, 4, 2);
      sheet.getRangeByName('C2').number = 40;
      sheet.getRangeByName('C3').number = 60;
      sheet.getRangeByName('C4').number = 20;
      sheet.getRangeByName('C5').number = 30;

      sheet.getRangeByName('D1').dateTime = DateTime(2017, 4, 3);
      sheet.getRangeByName('D2').number = 35;
      sheet.getRangeByName('D3').number = 55;
      sheet.getRangeByName('D4').number = 15;
      sheet.getRangeByName('D5').number = 45;

      sheet.getRangeByName('E1').dateTime = DateTime(2017, 4, 4);
      sheet.getRangeByName('E2').number = 45;
      sheet.getRangeByName('E3').number = 65;
      sheet.getRangeByName('E4').number = 25;
      sheet.getRangeByName('E5').number = 35;

      sheet.getRangeByName('F1').dateTime = DateTime(2017, 4, 5);
      sheet.getRangeByName('F2').number = 50;
      sheet.getRangeByName('F3').number = 70;
      sheet.getRangeByName('F4').number = 30;
      sheet.getRangeByName('F5').number = 60;

      final ChartCollection charts = ChartCollection(sheet);
      final Chart chart1 = charts.add();
      chart1.dataRange = sheet.getRangeByName('A1:F5');
      //Set Chart Title
      chart1.chartTitle = 'Open_highlow-close';

      ///apply marker
      final ChartSerie serie1 = chart1.series[0];
      final ChartSerie serie2 = chart1.series[1];
      final ChartSerie serie3 = chart1.series[2];
      final ChartSerie serie4 = chart1.series[3];
      serie1.serieFormat.markerStyle = ExcelChartMarkerType.circle;
      serie1.serieFormat.markerBackgroundColor = '#0000FF';
      serie1.serieFormat.markerBorderColor = '#0000FF';

      serie2.serieFormat.markerStyle = ExcelChartMarkerType.square;
      serie2.serieFormat.markerBackgroundColor = '#FFA500';
      serie2.serieFormat.markerBorderColor = '#FFA500';

      serie3.serieFormat.markerStyle = ExcelChartMarkerType.starSquare;
      serie3.serieFormat.markerBackgroundColor = '#023020';
      serie3.serieFormat.markerBorderColor = '#023020';

      serie4.serieFormat.markerStyle = ExcelChartMarkerType.diamond;
      serie4.serieFormat.markerBackgroundColor = '#964B00';
      serie4.serieFormat.markerBorderColor = '#964B00';

      //Positioning the chart in the worksheet
      chart1.topRow = 3;
      chart1.leftColumn = 1;
      chart1.bottomRow = 23;
      chart1.rightColumn = 8;
      chart1.chartType = ExcelChartType.stockOpenHighLowClose;

      sheet.charts = charts;
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'StockchartwithmarkerAsync.xlsx');
    });

    test('FLUT-6975-Line with marker ChartAsync ', () async {
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
      final Chart chart1 = charts.add();
      chart1.chartType = ExcelChartType.line;
      chart1.dataRange = sheet.getRangeByName('A1:D6');
      chart1.chartTitle = 'Line chart with marker';
      chart1.isSeriesInRows = false;

      ///apply marker
      final ChartSerie serie1 = chart1.series[0];
      final ChartSerie serie2 = chart1.series[1];
      final ChartSerie serie3 = chart1.series[2];

      serie1.serieFormat.markerStyle = ExcelChartMarkerType.circle;
      serie1.serieFormat.markerBackgroundColor = '#0000FF';
      serie1.serieFormat.markerBorderColor = '#0000FF';

      serie2.serieFormat.markerStyle = ExcelChartMarkerType.circle;
      serie2.serieFormat.markerBackgroundColor = '#FFA500';
      serie2.serieFormat.markerBorderColor = '#FFA500';

      serie3.serieFormat.markerStyle = ExcelChartMarkerType.circle;
      serie3.serieFormat.markerBackgroundColor = '#023020';
      serie3.serieFormat.markerBorderColor = '#023020';

      sheet.charts = charts;
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'FLUT_6975_Line chart with custom markerAsync.xlsx');
    });

    test('ColumnChartAsync ', () async {
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
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'ExcelColumnChartAsync.xlsx');
    });

    test('PieChartAsync ', () async {
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
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'ExcelPieChartAsync.xlsx');
    });

    test('LineChartAsync ', () async {
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
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'ExcelLineChartAsync.xlsx');
    });
    test('BarChartAsync ', () async {
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
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'ExcelBarChartAsync.xlsx');
    });
    test('Bar stackedAsync ', () async {
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
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'ExcelBarStackedChartAsync.xlsx');
    });
    test('Column stackedAsync ', () async {
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
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'ExcelColumnStackedChartAsync.xlsx');
    });
    test('Line stackedAsync ', () async {
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
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'ExcelLineStackedChartAsync.xlsx');
    });
    test('MultipleChartsToSingleSheetAsync ', () async {
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
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'MultipleChartsToSingleSheetAsync.xlsx');
    });
    test('AreaChartAsync ', () async {
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

      final List<int> bytes = await workbook.save();
      workbook.dispose();

      saveAsExcel(bytes, 'AreaChartAsync.xlsx');
    });

    test('AreaStackedChartAsync ', () async {
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
      final List<int> bytes = await workbook.save();
      workbook.dispose();

      saveAsExcel(bytes, 'AreaStackedChartAsync.xlsx');
    });
  });
}
