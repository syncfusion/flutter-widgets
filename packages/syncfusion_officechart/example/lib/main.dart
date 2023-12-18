import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;
import 'package:syncfusion_officechart/officechart.dart';

//Local imports
import 'helper/save_file_mobile.dart'
    if (dart.library.html) 'helper/save_file_web.dart';

void main() {
  runApp(CreateOfficeChartWidget());
}

/// Represents the office chart widget class.
class CreateOfficeChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CreateOfficeChartStatefulWidget(title: 'Create Excel document'),
    );
  }
}

/// Represents the office chart stateful widget class.
class CreateOfficeChartStatefulWidget extends StatefulWidget {
  /// Initalize the instance of the [CreateOfficeChartStatefulWidget] class.
  const CreateOfficeChartStatefulWidget({Key? key, required this.title})
      : super(key: key);

  /// title.
  final String title;
  @override
  // ignore: library_private_types_in_public_api
  _CreateOfficeChartState createState() => _CreateOfficeChartState();
}

class _CreateOfficeChartState extends State<CreateOfficeChartStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightBlue,
                disabledForegroundColor: Colors.grey,
              ),
              onPressed: generateOfficeChart,
              child: const Text('Generate Excel Chart'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> generateOfficeChart() async {
    //Create a Excel document.

    //Creating a workbook.
    final Workbook workbook = Workbook(0);
    //Adding a Sheet with name to workbook.
    final Worksheet sheet1 = workbook.worksheets.addWithName('Budget');
    sheet1.showGridlines = false;

    sheet1.enableSheetCalculations();
    sheet1.getRangeByIndex(1, 1).columnWidth = 19.86;
    sheet1.getRangeByIndex(1, 2).columnWidth = 14.38;
    sheet1.getRangeByIndex(1, 3).columnWidth = 12.98;
    sheet1.getRangeByIndex(1, 4).columnWidth = 12.08;
    sheet1.getRangeByIndex(1, 5).columnWidth = 8.82;
    sheet1.getRangeByName('A1:A18').rowHeight = 20.2;

    //Adding cell style.
    final Style style1 = workbook.styles.add('Style1');
    style1.backColor = '#D9E1F2';
    style1.hAlign = HAlignType.left;
    style1.vAlign = VAlignType.center;
    style1.bold = true;

    final Style style2 = workbook.styles.add('Style2');
    style2.backColor = '#8EA9DB';
    style2.vAlign = VAlignType.center;
    style2.numberFormat = r'[Red](\$#,###)';
    style2.bold = true;

    sheet1.getRangeByName('A10').cellStyle = style1;
    sheet1.getRangeByName('B10:D10').cellStyle.backColor = '#D9E1F2';
    sheet1.getRangeByName('B10:D10').cellStyle.hAlign = HAlignType.right;
    sheet1.getRangeByName('B10:D10').cellStyle.vAlign = VAlignType.center;
    sheet1.getRangeByName('B10:D10').cellStyle.bold = true;

    sheet1.getRangeByName('A11:A17').cellStyle.vAlign = VAlignType.center;
    sheet1.getRangeByName('A11:D17').cellStyle.borders.bottom.lineStyle =
        LineStyle.thin;
    sheet1.getRangeByName('A11:D17').cellStyle.borders.bottom.color = '#BFBFBF';

    sheet1.getRangeByName('D18').cellStyle = style2;
    sheet1.getRangeByName('D18').cellStyle.vAlign = VAlignType.center;
    sheet1.getRangeByName('A18:C18').cellStyle.backColor = '#8EA9DB';
    sheet1.getRangeByName('A18:C18').cellStyle.vAlign = VAlignType.center;
    sheet1.getRangeByName('A18:C18').cellStyle.bold = true;
    sheet1.getRangeByName('A18:C18').numberFormat = r'\$#,###';

    sheet1.getRangeByIndex(10, 1).setText('Category');
    sheet1.getRangeByIndex(10, 2).setText('Expected cost');
    sheet1.getRangeByIndex(10, 3).setText('Actual Cost');
    sheet1.getRangeByIndex(10, 4).setText('Difference');
    sheet1.getRangeByIndex(11, 1).setText('Venue');
    sheet1.getRangeByIndex(12, 1).setText('Seating & Decor');
    sheet1.getRangeByIndex(13, 1).setText('Technical team');
    sheet1.getRangeByIndex(14, 1).setText('Performers');
    sheet1.getRangeByIndex(15, 1).setText("Performer's transport");
    sheet1.getRangeByIndex(16, 1).setText("Performer's stay");
    sheet1.getRangeByIndex(17, 1).setText('Marketing');
    sheet1.getRangeByIndex(18, 1).setText('Total');

    sheet1.getRangeByName('B11:D17').numberFormat = r'\$#,###';
    sheet1.getRangeByName('D11').numberFormat = r'[Red](\$#,###)';
    sheet1.getRangeByName('D12').numberFormat = r'[Red](\$#,###)';
    sheet1.getRangeByName('D14').numberFormat = r'[Red](\$#,###)';

    sheet1.getRangeByName('B11').setNumber(16250);
    sheet1.getRangeByName('B12').setNumber(1600);
    sheet1.getRangeByName('B13').setNumber(1000);
    sheet1.getRangeByName('B14').setNumber(12400);
    sheet1.getRangeByName('B15').setNumber(3000);
    sheet1.getRangeByName('B16').setNumber(4500);
    sheet1.getRangeByName('B17').setNumber(3000);
    sheet1.getRangeByName('B18').setFormula('=SUM(B11:B17)');

    sheet1.getRangeByName('C11').setNumber(17500);
    sheet1.getRangeByName('C12').setNumber(1828);
    sheet1.getRangeByName('C13').setNumber(800);
    sheet1.getRangeByName('C14').setNumber(14000);
    sheet1.getRangeByName('C15').setNumber(2600);
    sheet1.getRangeByName('C16').setNumber(4464);
    sheet1.getRangeByName('C17').setNumber(2700);
    sheet1.getRangeByName('C18').setFormula('=SUM(C11:C17)');

    sheet1.getRangeByName('D11').setFormula('=IF(C11>B11,C11-B11,B11-C11)');
    sheet1.getRangeByName('D12').setFormula('=IF(C12>B12,C12-B12,B12-C12)');
    sheet1.getRangeByName('D13').setFormula('=IF(C13>B13,C13-B13,B13-C13)');
    sheet1.getRangeByName('D14').setFormula('=IF(C14>B14,C14-B14,B14-C14)');
    sheet1.getRangeByName('D15').setFormula('=IF(C15>B15,C15-B15,B15-C15)');
    sheet1.getRangeByName('D16').setFormula('=IF(C16>B16,C16-B16,B16-C16)');
    sheet1.getRangeByName('D17').setFormula('=IF(C17>B17,C17-B17,B17-C17)');
    sheet1.getRangeByName('D18').setFormula('=IF(C18>B18,C18-B18,B18-C18)');

    // Create chart collection for worksheet.
    final ChartCollection charts = ChartCollection(sheet1);

    // Add a chart to the chart collection.
    final Chart chart = charts.add();
    chart.chartType = ExcelChartType.pie;
    chart.dataRange = sheet1.getRangeByName('A11:B17');
    chart.isSeriesInRows = false;
    chart.chartTitle = 'Event Expenses';
    chart.chartTitleArea.bold = true;
    chart.chartTitleArea.size = 16;
    chart.topRow = 1;
    chart.bottomRow = 10;
    chart.leftColumn = 1;
    chart.rightColumn = 5;
    sheet1.charts = charts;

    //Save and launch Excel.
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    await saveAndLaunchFile(bytes, 'ExpenseReport.xlsx');
  }
}
