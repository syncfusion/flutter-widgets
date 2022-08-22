part of xlsio;

/// Represents the colunm class.
class Column {
  /// Create an instance of column.
  Column(this.worksheet) {
    _isHidden = false;
  }

  /// Represents the column width.
  double width = 0;

  /// Represents the column index.
  late int index;

  /// Parent worksheet.
  late Worksheet worksheet;

  ///Represents the indicate wheather column hide or not.
  late bool _isHidden;
}
