part of xlsio;

/// Represents a Table in a Worksheet.
class ExcelTable {
  /// Gets or sets the dataRange, which acts as a list type.
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
  ///   table.builtInTableStyle = ExcelTableBuiltInStyles.tableStyleMedium10;
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   saveAsExcel(bytes, 'Table.xlsx');
  ///   workbook.dispose();
  /// ```
  late Range dataRange;

  /// Gets collection of columns in the table. Read-only.
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
  ///   table.builtInTableStyle = ExcelTableBuiltInStyles.tableStyleMedium10;
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
  late List<ExcelTableColumn> columns;

  /// Gets or sets the built-in style for the table.
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
  ///   table.builtInTableStyle = ExcelTableBuiltInStyles.tableStyleMedium10;
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   saveAsExcel(bytes, 'Table.xlsx');
  ///   workbook.dispose();
  /// ```
  late ExcelTableBuiltInStyle builtInTableStyle;

  /// Gets or sets the display name for the table.
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
  ///   table.builtInTableStyle = ExcelTableBuiltInStyles.tableStyleMedium10;
  ///
  ///   // Modify Display Name
  ///   table.displayName = 'FruitsCost';
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   saveAsExcel(bytes, 'Table.xlsx');
  ///   workbook.dispose();
  /// ```
  late String displayName;

  /// Gets or sets a Boolean value indicating whether the Total row is visible.
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
  ///   table.builtInTableStyle = ExcelTableBuiltInStyles.tableStyleMedium10;
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
  late bool showTotalRow;

  /// Gets or sets a Boolean value indicating whether row stripes are present.
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
  ///   table.builtInTableStyle = ExcelTableBuiltInStyles.tableStyleMedium10;
  ///
  ///   //Set Row Stripes
  ///   table.showBandedRows = true;
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   saveAsExcel(bytes, 'Table.xlsx');
  ///   workbook.dispose();
  /// ```
  late bool showBandedRows;

  /// Gets or sets a Boolean value indicating whether column stripes are present.
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
  ///   table.builtInTableStyle = ExcelTableBuiltInStyles.tableStyleMedium10;
  ///
  ///   //Set Column Stripes
  ///   table.showBandedColumns = true;
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   saveAsExcel(bytes, 'Table.xlsx');
  ///   workbook.dispose();
  /// ```
  late bool showBandedColumns;

  /// Gets or sets a Boolean value indicating whether last column format is present.
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
  ///   table.builtInTableStyle = ExcelTableBuiltInStyles.tableStyleMedium10;
  ///
  ///   //Set Show Last Column
  ///   table.showLastColumn = true;
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   saveAsExcel(bytes, 'Table.xlsx');
  ///   workbook.dispose();
  /// ```
  late bool showLastColumn;

  /// Gets or sets a Boolean value indicating whether first column format is present.
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
  ///   table.builtInTableStyle = ExcelTableBuiltInStyles.tableStyleMedium10;
  ///
  ///   //Set Show First Column
  ///   table.showFirstColumn = true;
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   saveAsExcel(bytes, 'Table.xlsx');
  ///   workbook.dispose();
  /// ```
  late bool showFirstColumn;

  /// Gets or sets a Boolean value indicating whether to hide/display the header row.
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
  ///   table.builtInTableStyle = ExcelTableBuiltInStyles.tableStyleMedium10;
  ///
  ///   //Set Header Row
  ///   table.showHeaderRow= false;
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   saveAsExcel(bytes, 'Table.xlsx');
  ///   workbook.dispose();
  /// ```
  late bool showHeaderRow;

  /// Gets or sets the alternative text title.
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
  ///   // Set Table Style
  ///   table.builtInTableStyle = ExcelTableBuiltInStyles.tableStyleMedium10;
  ///
  ///   // Set Alternative Text Title
  ///   table.altTextTitle = 'Cost of Fruits';
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   saveAsExcel(bytes, 'Table.xlsx');
  ///   workbook.dispose();
  /// ```
  late String altTextTitle;

  /// Gets or sets the alternative text description.
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
  ///   table.builtInTableStyle = ExcelTableBuiltInStyles.tableStyleMedium10;
  ///
  ///   // Set Alternative Text
  ///   table.altTextSummary = 'This table provides the cost of fruits';
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   saveAsExcel(bytes, 'Table.xlsx');
  ///   workbook.dispose();
  /// ```
  late String altTextSummary;
}
