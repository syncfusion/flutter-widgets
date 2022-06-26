part of xlsio;

/// Represents a column in the table.
class ExcelTableColumn {
  /// Gets or sets the name of the column.
  /// ```dart
  /// // Create a new Excel Document.
  ///   final Workbook workbook = Workbook(1);
  ///   // Accessing sheet via index.
  ///   final Worksheet sheet = workbook.worksheets[0];
  ///
  ///   //Load data
  ///   sheet.getRangeByName('A1').setText('Fruits');
  ///   sheet.getRangeByName('A2').setText('banana');
  ///   sheet.getRangeByName('A3').setText('Cherry');
  ///   sheet.getRangeByName('A4').setText('Banana');
  ///
  ///   sheet.getRangeByName('B1').setText('CostA');
  ///   sheet.getRangeByName('B2').setNumber(744.6);
  ///   sheet.getRangeByName('B3').setNumber(5079.6);
  ///   sheet.getRangeByName('B4').setNumber(1267.5);
  ///
  ///   sheet.getRangeByName('C1').setText('CostB');
  ///   sheet.getRangeByName('C2').setNumber(162.56);
  ///   sheet.getRangeByName('C3').setNumber(1249.2);
  ///   sheet.getRangeByName('C4').setNumber(1062.5);
  ///
  ///   // Creates a table with specified name and data range.Adds it to the tables collection.
  ///   final ExcelTable table =
  ///       sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));
  ///
  ///   // Modifyies Column Name
  ///   table.columns[0].columnName = 'Fruits Varieties';
  ///
  ///   // Set TableStyle
  ///   table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleMedium10;
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   saveAsExcel(bytes, 'Table.xlsx');
  ///   workbook.dispose();
  /// ```
  late String columnName;

  /// Gets or sets the function used for total calculation.
  /// ```dart
  /// // Create a new Excel Document.
  ///   final Workbook workbook = Workbook(1);
  ///   // Accessing sheet via index.
  ///   final Worksheet sheet = workbook.worksheets[0];
  ///
  ///   //Load data
  ///   sheet.getRangeByName('A1').setText('Fruits');
  ///   sheet.getRangeByName('A2').setText('banana');
  ///   sheet.getRangeByName('A3').setText('Cherry');
  ///   sheet.getRangeByName('A4').setText('Banana');
  ///
  ///   sheet.getRangeByName('B1').setText('CostA');
  ///   sheet.getRangeByName('B2').setNumber(744.6);
  ///   sheet.getRangeByName('B3').setNumber(5079.6);
  ///   sheet.getRangeByName('B4').setNumber(1267.5);
  ///
  ///   sheet.getRangeByName('C1').setText('CostB');
  ///   sheet.getRangeByName('C2').setNumber(162.56);
  ///   sheet.getRangeByName('C3').setNumber(1249.2);
  ///   sheet.getRangeByName('C4').setNumber(1062.5);
  ///
  ///   // Creates a table with specified name and data range.Adds it to the tables collection.
  ///   final ExcelTable table =
  ///       sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));
  ///
  ///   // Set TableStyle
  ///   table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleMedium10;
  ///
  ///   // Set Totals
  ///   table.showTotalRow = true;
  ///   table.columns[0].totalRowLabel = 'Total';
  ///   table.columns[1].totalFormula = ExcelTableTotalFormula.sum;
  ///   table.columns[2].totalFormula = ExcelTableTotalFormula.average;
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   saveAsExcel(bytes, 'Table.xlsx');
  ///   workbook.dispose();
  /// ```
  late ExcelTableTotalFormula totalFormula;

  /// Gets or sets the label for the total row.
  /// ```dart
  /// // Create a new Excel Document.
  ///   final Workbook workbook = Workbook(1);
  ///   // Accessing sheet via index.
  ///   final Worksheet sheet = workbook.worksheets[0];
  ///
  ///   //Load data
  ///   sheet.getRangeByName('A1').setText('Fruits');
  ///   sheet.getRangeByName('A2').setText('banana');
  ///   sheet.getRangeByName('A3').setText('Cherry');
  ///   sheet.getRangeByName('A4').setText('Banana');
  ///
  ///   sheet.getRangeByName('B1').setText('CostA');
  ///   sheet.getRangeByName('B2').setNumber(744.6);
  ///   sheet.getRangeByName('B3').setNumber(5079.6);
  ///   sheet.getRangeByName('B4').setNumber(1267.5);
  ///
  ///   sheet.getRangeByName('C1').setText('CostB');
  ///   sheet.getRangeByName('C2').setNumber(162.56);
  ///   sheet.getRangeByName('C3').setNumber(1249.2);
  ///   sheet.getRangeByName('C4').setNumber(1062.5);
  ///
  ///   // Creates a table with specified name and data range.Adds it to the tables collection.
  ///   final ExcelTable table =
  ///       sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));
  ///
  ///   // Set TableStyle
  ///   table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleMedium10;
  ///
  ///   // Set Totals
  ///   table.showTotalRow = true;
  ///   table.columns[0].totalRowLabel = 'Total';
  ///   table.columns[1].totalFormula = ExcelTableTotalFormula.sum;
  ///   table.columns[2].totalFormula = ExcelTableTotalFormula.average;
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   saveAsExcel(bytes, 'Table.xlsx');
  ///   workbook.dispose();
  /// ```
  late String totalRowLabel;
}
