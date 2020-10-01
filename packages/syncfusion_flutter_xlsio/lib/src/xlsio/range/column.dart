part of xlsio;

/// Represents the colunm class.
class Column {
  /// Create an instance of column.
  Column(Worksheet sheet) {
    worksheet = sheet;
  }

  /// Represents the column width.
  double width;

  /// Represents the column index.
  int index;

  /// Parent worksheet.
  Worksheet worksheet;
}
