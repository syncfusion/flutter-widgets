part of xlsio;

/// Represents the colunm class.
class Column {
  /// Create an instance of column.
  Column(this.worksheet);

  /// Represents the column width.
  double width = 0;
  
  /// Represents the hidden property of column
  bool hidden = false;

  /// Represents the column index.
  late int index;

  /// Parent worksheet.
  late Worksheet worksheet;
}
