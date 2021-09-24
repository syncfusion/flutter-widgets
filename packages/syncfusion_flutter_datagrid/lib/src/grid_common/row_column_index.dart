import 'utility_helper.dart';

/// Holds the coordinates for a cell.
class RowColumnIndex {
  /// Creates the [RowColumnIndex] to hold coordinates of a cell.
  RowColumnIndex(this.rowIndex, this.columnIndex);

  /// An index of a row.
  int rowIndex = 0;

  /// An index of a column.
  int columnIndex = 0;

  /// Creates the empty object with row index and column index set to
  /// `int.MinValue`.
  static RowColumnIndex get empty => RowColumnIndex(maxvalue, minvalue);

  /// Whether this object is empty.
  ///
  /// Returns true, if this instance is empty, otherwise false.
  bool get isEmpty => rowIndex == minvalue;

  /// Whether this object and a specified object are equal.
  bool equals(RowColumnIndex obj) {
    final RowColumnIndex other = obj;
    return other.rowIndex == rowIndex && other.columnIndex == columnIndex;
  }

  /// A 32-bit signed integer that is the hash code for this object.
  ///
  /// Returns the hash code for this object.
  int getHashCode() => (rowIndex * 2654435761) + columnIndex;

  /// The type name with state of this object.
  ///
  /// Returns the type name with state of this object.
  @override
  String toString() => '''
              RowColumnPosition { 
              RowIndex =
              $rowIndex,
              ColumnIndex =  $columnIndex }''';
}
