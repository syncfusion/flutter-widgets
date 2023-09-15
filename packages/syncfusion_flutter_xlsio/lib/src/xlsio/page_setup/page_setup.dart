part of xlsio;

/// Represents a class contains page setup settings.
class PageSetup {
  /// Indicates whether to print the gridlines in the worksheet.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1:D4').text = 'GridLines';
  /// sheet.pageSetup.showGridlines = true;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'showGridlines.xlsx');
  /// workbook.dispose();
  /// ```
  late bool showGridlines;

  /// Indcates whether the fit to page is selected.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1:M40').text = 'PagePrint';
  /// sheet.pageSetup.isFitToPage = true;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'isFitToPage.xlsx');
  /// workbook.dispose();
  /// ```
  late bool isFitToPage;

  /// Indicates whether to print row and column heading in the worksheet.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1:D4').text = 'Headings';
  /// sheet.pageSetup.showHeadings = true;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'showHeadings.xlsx');
  /// workbook.dispose();
  /// ```
  late bool showHeadings;

  /// Indicates whether to center the sheet content horizontally when it is printed.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1:D4').text = 'Hello';
  /// sheet.pageSetup.isCenterHorizontally = true;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'isCenterHorizontally.xlsx');
  /// workbook.dispose();
  /// ```
  late bool isCenterHorizontally;

  /// Indicates whether to center the sheet content vertically when it is printed.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1:D4').text = 'Hello';
  /// sheet.pageSetup.isCenterVertically = true;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'isCenterVertically.xlsx');
  /// workbook.dispose();
  /// ```
  late bool isCenterVertically;

  /// Indicates whether to print the worksheet as black and white.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// style.fontColor = '#C67878';
  /// final Range range = sheet.getRangeByName('A1:D4');
  /// range.text = 'BlackWhite';
  /// range.cellStyle = style;
  /// sheet.pageSetup.isBlackAndWhite = true;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'isBlackAndWhite.xlsx');
  /// workbook.dispose();
  /// ```
  late bool isBlackAndWhite;

  /// Indicates whether to use auto first page number.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1:M40').text = 'Hello';
  /// sheet.pageSetup.autoFirstPageNumber = false;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'autoFirstPageNumber.xlsx');
  /// workbook.dispose();
  /// ```
  late bool autoFirstPageNumber;

  /// Indicates whether to print the worksheet as draft without graphics.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// style.fontColor = '#C67878';
  /// final Range range = sheet.getRangeByName('A1:D4');
  /// range.text = 'BlackWhite';
  /// range.cellStyle = style;
  /// sheet.pageSetup.isDraft = true;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'isDraft.xlsx');
  /// workbook.dispose();
  /// ```
  late bool isDraft;

  /// Represents the print quality, in dpi.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1:M40').text = 'Hello';
  /// sheet.pageSetup.printQuality = 700;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'printQuality.xlsx');
  /// workbook.dispose();
  /// ```
  late int printQuality;

  /// Represents the height of the pages that the worksheet will be scaled.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1:M40').text = 'Hello';
  /// sheet.pageSetup.fitToPagesTall = 2;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'fitToPagesTall.xlsx');
  /// workbook.dispose();
  /// ```
  late int fitToPagesTall;

  /// Represents the width of the pages the worksheet will be scaled.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1:M40').text = 'Hello';
  /// sheet.pageSetup.fitToPagesWide = 2;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'fitToPagesWide.xlsx');
  /// workbook.dispose();
  /// ```
  late int fitToPagesWide;

  /// Represents the size of the left margin, in inches
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1:M20').text = 'Hello';
  /// sheet.pageSetup.topMargin = 1;
  /// Sets the value of the left margin
  /// sheet.pageSetup.leftMargin = 1;
  /// sheet.pageSetup.rightMargin = 1;
  /// sheet.pageSetup.bottomMargin = 1;
  /// sheet.pageSetup.footerMargin = 1;
  /// sheet.pageSetup.headerMargin = 1;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'leftMargin.xlsx');
  /// workbook.dispose();
  /// ```
  late double leftMargin;

  /// Represents the size of the bottom margin, in inches
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1:M20').text = 'Hello';
  /// sheet.pageSetup.topMargin = 1;
  /// sheet.pageSetup.leftMargin = 1;
  /// sheet.pageSetup.rightMargin = 1;
  /// Sets the value of the bottom margin
  /// sheet.pageSetup.bottomMargin = 1;
  /// sheet.pageSetup.footerMargin = 1;
  /// sheet.pageSetup.headerMargin = 1;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'bottomMargin.xlsx');
  /// workbook.dispose();
  /// ```
  late double bottomMargin;

  /// Represents the size of the footer margin, in inches
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1:M20').text = 'Hello';
  /// sheet.pageSetup.topMargin = 1;
  /// sheet.pageSetup.leftMargin = 1;
  /// sheet.pageSetup.rightMargin = 1;
  /// sheet.pageSetup.bottomMargin = 1;
  /// Sets the value of the footer margin
  /// sheet.pageSetup.footerMargin = 1;
  /// sheet.pageSetup.headerMargin = 1;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'footerMargin.xlsx');
  /// workbook.dispose();
  /// ```
  late double footerMargin;

  /// Represents the size of the header margin, in inches
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1:M20').text = 'Hello';
  /// sheet.pageSetup.topMargin = 1;
  /// sheet.pageSetup.leftMargin = 1;
  /// sheet.pageSetup.rightMargin = 1;
  /// sheet.pageSetup.bottomMargin = 1;
  /// sheet.pageSetup.footerMargin = 1;
  /// Sets the value of the header margin
  /// sheet.pageSetup.headerMargin = 1;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'headerMargin.xlsx');
  /// workbook.dispose();
  /// ```
  late double headerMargin;

  /// Represents the size of the right margin, in inches
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1:M20').text = 'Hello';
  /// sheet.pageSetup.topMargin = 1;
  /// sheet.pageSetup.leftMargin = 1;
  /// Sets the value of the right margin
  /// sheet.pageSetup.rightMargin = 1;
  /// sheet.pageSetup.bottomMargin = 1;
  /// sheet.pageSetup.footerMargin = 1;
  /// sheet.pageSetup.headerMargin = 1;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'rightMargin.xlsx');
  /// workbook.dispose();
  /// ```
  late double rightMargin;

  /// Represents the size of the top margin, in inches
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1:M20').text = 'Hello';
  /// Sets the value of the top margin
  /// sheet.pageSetup.topMargin = 1;
  /// sheet.pageSetup.leftMargin = 1;
  /// sheet.pageSetup.rightMargin = 1;
  /// sheet.pageSetup.bottomMargin = 1;
  /// sheet.pageSetup.footerMargin = 1;
  /// sheet.pageSetup.headerMargin = 1;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'topMargin.xlsx');
  /// workbook.dispose();
  /// ```
  late double topMargin;

  /// Represents the printing orientation of the worksheet.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1:D4').text = 'Hello';
  /// sheet.pageSetup.orientation = ExcelPageOrientation.landscape;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'orientation.xlsx');
  /// workbook.dispose();
  /// ```
  late ExcelPageOrientation orientation;

  /// Represents the order in which the worksheet to be printed.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1:M40').text = 'Hello';
  /// sheet.pageSetup.order = ExcelPageOrder.overThenDown;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'orientation.xlsx');
  /// workbook.dispose();
  /// ```
  late ExcelPageOrder order;

  /// Represents the paper size for the worksheet.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1:M40').text = 'Hello';
  /// sheet.pageSetup.paperSize = ExcelPaperSize.a2Paper;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'paperSize.xlsx');
  /// workbook.dispose();
  /// ```
  late ExcelPaperSize paperSize;

  /// Represents the values to be printed insead of cell errors in the worksheet.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1:D3').text = 'Hello';
  /// sheet.getRangeByName('B4').number = 987;
  /// sheet.getRangeByName('C4').number = 5678;
  /// sheet.getRangeByName('D4').formula = 'ASIN(B4:C4)';
  /// sheet.pageSetup.printErrors = CellErrorPrintOptions.dash;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'printErrors.xlsx');
  /// workbook.dispose();
  /// ```
  late CellErrorPrintOptions printErrors;

  /// Represents the first page number to be used.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1:M40').text = 'Hello';
  /// sheet.pageSetup.firstPageNumber = 20;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'orientation.xlsx');
  /// workbook.dispose();
  /// ```
  late int firstPageNumber;

  /// Represents the columns to be repeated at each page.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1').text = 'S:NO';
  /// sheet.getRangeByName('A2').text = 'Name';
  /// sheet.getRangeByName('A3').text = 'Roll NO';
  /// sheet.getRangeByName('A4').text = 'Tottal mark';
  /// sheet.getRangeByName('B1:MM1').number = 1;
  /// sheet.getRangeByName('B2:MM2').text = 'Names';
  /// sheet.getRangeByName('B3:MM3').number = 7584;
  /// sheet.getRangeByName('B4:MM4').number = 423;
  /// sheet.pageSetup.printTitleColumns = 'A1:A4';
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'printTitleColumns.xlsx');
  /// workbook.dispose();
  /// ```
  late String printTitleColumns;

  /// Represents the rows to be repeated at each page.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1').text = 'S:NO';
  /// sheet.getRangeByName('B1').text = 'Name';
  /// sheet.getRangeByName('C1').text = 'Roll NO';
  /// sheet.getRangeByName('D1').text = 'Tottal mark';
  /// sheet.getRangeByName('A2:A100').number = 1;
  /// sheet.getRangeByName('B2:B100').text = 'Names';
  /// sheet.getRangeByName('C2:C100').number = 36288;
  /// sheet.getRangeByName('D2:D100').number = 425;
  /// sheet.pageSetup.printTitleRows = 'A1:D1';
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'printTitleRows.xlsx');
  /// workbook.dispose();
  /// ```
  late String printTitleRows;

  /// Represents the range to be printed
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1:M20').text = 'Hello';
  /// sheet.pageSetup.printArea = 'A1:E20';
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'printArea.xlsx');
  /// workbook.dispose();
  /// ```
  late String printArea;
}
