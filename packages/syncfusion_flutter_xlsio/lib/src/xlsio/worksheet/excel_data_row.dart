part of xlsio;

/// Represents the data cell for importing data.
///
/// The data for each row can be passed as the cells argument to the
/// constructor of each [ExcelDataRow] object.
class ExcelDataRow {
  /// Create an instand for ExcelDataRow.
  const ExcelDataRow({required List<ExcelDataCell> cells}) : _cells = cells;

  /// The data for this row.
  final List<ExcelDataCell> _cells;

  /// Returns the collection of [ExcelDataCell] which is created for [ExcelDataRow].
  List<ExcelDataCell> get cells {
    return _cells;
  }
}

/// Represents the data cell for importing data.
///
/// The list of [ExcelDataCell] objects should be passed as the cells argument
/// to the constructor of each [ExcelDataRow] object.
class ExcelDataCell {
  /// Create an instand for ExcelDataRow.
  const ExcelDataCell({required this.columnHeader, required this.value});

  /// The header of a column
  final Object columnHeader;

  /// The value of a cell.
  final Object? value;
}
