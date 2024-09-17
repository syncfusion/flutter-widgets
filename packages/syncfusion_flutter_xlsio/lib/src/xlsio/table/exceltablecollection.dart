import '../general/workbook.dart';
import '../range/range.dart';
import '../worksheet/worksheet.dart';
import 'exceltable.dart';
import 'exceltable_impl.dart';

/// Represents collections of tables in a worksheet.
class ExcelTableCollection {
  /// Create a instances of tables collection.
  ExcelTableCollection(Worksheet worksheet) {
    _sheet = worksheet;
    _tableCollection = <ExcelTable>[];
  }

  /// Represent the parent worksheet.
  late Worksheet _sheet;

  /// Collection of tables.
  late List<ExcelTable> _tableCollection;

  /// Gets the inner list.
  List<ExcelTable> get innerList {
    return _tableCollection;
  }

  /// Returns the count of table reference collection.
  int get count {
    return _tableCollection.length;
  }

  ///table Cell Index.
  ExcelTable operator [](dynamic index) {
    return _tableCollection[index];
  }

  /// Creates a table with specified name and data range.Adds it to the List Objects collection.
  ExcelTable create(String tableName, Range range) {
    final Workbook book = range.worksheet.workbook;
    range = _checkRange(range);
    _checkOverlap(range);
    final ExcelTableImpl result =
        ExcelTableImpl(tableName, range, _tableCollection.length + 1);
    result.name = _isNameExists(tableName);
    result.dataRange = range;
    result.index = ++book.maxTableIndex;
    _tableCollection.add(result);
    return result;
  }

  /// Checks if the Table Name already exist.
  String _isNameExists(String newTableName) {
    for (int nameCount = 0; nameCount < count; nameCount++) {
      if (newTableName ==
          (_tableCollection[nameCount] as ExcelTableImpl).tableName) {
        throw Exception('Name already exist.Name must be unique');
      }
    }
    return newTableName;
  }

  /// Check the list object range is overlap the another table
  static void _checkOverlap(Range range) {
    final Worksheet sheet = range.worksheet;

    final int row = range.row;
    final int column = range.column;
    final int lastRow = range.lastRow;
    final int lastColumn = range.lastColumn;
    for (int tableCount = 0;
        tableCount < sheet.tableCollection.count;
        tableCount++) {
      final ExcelTable table = sheet.tableCollection[tableCount];
      final int tableRow = table.dataRange.row;
      final int tableColumn = table.dataRange.column;
      final int tableLastRow = table.dataRange.lastRow;
      final int tableLastColumn = table.dataRange.lastColumn;
      if ((row > tableRow - 1 && row < tableLastRow + 1) &&
          (column > tableColumn - 1 && column < tableLastColumn + 1)) {
        throw Exception(
            'A table cannot overlap a range that contains another table');
      }
      if ((row > tableRow - 1 && row < tableLastRow + 1) &&
          (lastColumn > tableColumn - 1 && lastColumn < tableLastColumn + 1)) {
        throw Exception(
            'A table cannot overlap a range that contains  another table');
      }
      if ((lastRow > tableRow - 1 && lastRow < tableLastRow + 1) &&
          (column > tableColumn - 1 && column < tableLastColumn + 1)) {
        throw Exception(
            'A table cannot overlap a range that contains another table');
      }
      if ((lastRow > tableRow - 1 && lastRow < tableLastRow + 1) &&
          (lastColumn > tableColumn - 1 && lastColumn < tableLastColumn + 1)) {
        throw Exception(
            'A table cannot overlap a range that contains another table');
      }
      if ((row < tableRow - 1 && row < tableLastRow + 1) ||
          (lastRow > tableRow - 1 && lastRow < tableLastRow + 1)) {
        if (tableColumn > column && tableLastColumn < lastColumn) {
          throw Exception(
              'A table cannot overlap a range that contains another table');
        }
      }
      if ((column < tableColumn - 1 && column < tableLastColumn + 1) ||
          (lastColumn > tableColumn - 1 && lastColumn < tableLastColumn + 1)) {
        if (tableRow > row && tableLastRow < lastRow) {
          throw Exception(
              'A table cannot overlap a range that contains another table');
        }
      }
    }
  }

  /// Checks whether the range is appropriate.
  Range _checkRange(Range range) {
    if (range.row == range.lastRow) {
      range = _sheet.getRangeByIndex(
          range.row, range.column, range.row + 1, range.lastColumn);
    }
    return range;
  }

  /// Removes a table from the worksheet.
  bool remove(ExcelTable table) {
    return _tableCollection.remove(table);
  }

  /// Removes a table from the worksheet at the specified index.
  void removeAt(int index) {
    if (index < _tableCollection.length) {
      final ExcelTable table = _tableCollection[index];
      remove(table);
    }
  }

  void clear() {
    _tableCollection.clear();
  }
}
