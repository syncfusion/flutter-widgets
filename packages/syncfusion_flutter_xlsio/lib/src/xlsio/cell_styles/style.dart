part of xlsio;

/// Represents the Style class.
class Style {
  /// Represents cell style name.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// style.backColor = '#37D8E9';
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// // Check style name.
  /// print(workbook.styles[1].name);
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late String name;

  /// Represents cell style index.
  ///  ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// style.backColor = '#37D8E9';
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// // Check index.
  /// print(workbook.styles[1].index);
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late int index;

  /// Gets/sets back color.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// // set back color.
  /// style.backColor = '#37D8E9';
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late String backColor;

  /// Gets/sets borders.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// // set borders line style and color.
  /// style.borders.all.lineStyle = LineStyle.thick;
  /// style.borders.all.color = '#9954CC';
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late Borders borders;

  /// Gets/sets font name.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// // set fontName.
  /// style.fontName = 'Times Roman'
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late String fontName;

  /// Gets/sets font size.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// // set font size.
  /// style.fontSize = 20;
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late double fontSize;

  /// Gets/sets font color.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// // set fontColor.
  /// style.fontColor = '#C67878'
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late String fontColor;

  /// Gets/sets font italic.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// // set font italic.
  /// style.italic = true;
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late bool italic;

  /// Gets/sets font bold.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// // set font bold.
  /// style.bold = true;
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late bool bold;

  /// Gets/sets horizontal alignment.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// // Set horizontal Alignment.
  /// style.hAlign = HAlignType.left;
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late HAlignType hAlign;

  /// Gets/sets cell indent.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// // set cell indent.
  /// style.indent = 1;
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late int indent;

  /// Gets/sets cell rotations.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// // set cell rotations.
  /// style.rotation = 90;
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late int rotation;

  /// Gets/sets vertical alignment.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// // set vertical alignment.
  /// style.vAlign = VAlignType.bottom;
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late VAlignType vAlign;

  /// Gets/sets font underline.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// // set font underline .
  /// style.underline = true;
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late bool underline;

  /// Gets/sets cell wraptext.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// // set wrap text.
  /// style.wrapText = true;
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late bool wrapText;

  /// Gets/sets cell numberFormat index.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// // set number format.
  /// style.numberFormat = '_(\$* #,##0_)';
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// // Check number format index.
  /// print(workbook.styles[1].numberFormatIndex);
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late int numberFormatIndex;

  /// Gets/sets cell numberFormat.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// // set number format.
  /// style.numberFormat = '_(\$* #,##0_)';
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  String? numberFormat;

  /// Gets/Sets cell Lock
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Style style = workbook.styles.add('style');
  /// // set locked.
  /// style.locked = true;
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late bool locked;

  /// Gets/sets back color Rgb.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final CellStyle cellStyle1 = CellStyle(workbook);
  /// cellStyle1.name = 'Style1';
  /// // set backcolor Rgb.
  /// cellStyle1.backColorRgb = Color.fromARgb(255, 56, 250, 0);
  /// workbook.styles.addStyle(cellStyle1);
  /// final Range range1 = sheet.getRangeByIndex(1, 1);
  /// range1.cellStyle = cellStyle1;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late Color backColorRgb;

  /// Gets/sets font color Rgb.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final CellStyle cellStyle1 = CellStyle(workbook);
  /// cellStyle1.name = 'Style1';
  /// // set fontcolor Rgb.
  /// cellStyle1.fontColorRgb = Color.fromARgb(255, 56, 250, 0);
  /// workbook.styles.addStyle(cellStyle1);
  /// final Range range1 = sheet.getRangeByIndex(1, 1);
  /// range1.cellStyle = cellStyle1;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late Color fontColorRgb;
}
