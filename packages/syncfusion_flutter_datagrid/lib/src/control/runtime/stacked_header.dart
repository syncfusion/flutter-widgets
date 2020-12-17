part of datagrid;

/// Row configuration for stacked header in [SfDataGrid]. The columns for this
/// stacked header row are provided in the [stackedHeaderCells] property of the
/// [StackedHeaderRow] object.
///
/// See also:
///
/// [StackedHeaderCell] – which provides the configuration for column in stacked
/// header row.
class StackedHeaderRow {
  /// Creates the [StackedHeaderRow] for [SfDataGrid] widget.
  StackedHeaderRow({List<StackedHeaderCell> cells}) {
    this.cells = cells ?? [];
  }

  /// The name of the stacked header row.
  ///
  /// This is used to identify the header rows uniquely in
  /// [stackedHeaderCellBuilder]. Each stacked header row must be named
  /// uniquely.
  String name;

  /// The collection of [StackedHeaderCell] in stacked header row.
  List<StackedHeaderCell> cells;
}

/// Column configuration for stacked header row in `SfDataGrid`.
///
/// See also:
///
/// [StackedHeaderRow] – which provides configuration for stacked header row.
class StackedHeaderCell {
  /// Creates the [StackedHeaderCell] for [StackedHeaderRow].
  StackedHeaderCell({@required this.columnNames, @required this.child});

  /// The collection of string which is the [GridColumn.mappingName] of the
  /// columns defined in the [SfDataGrid].
  ///
  /// The columns are spanned as a stacked header based on this collection. If
  /// the given collection has the sequence of columns which are presented in
  /// the [SfDataGrid], those columns will be spanned. Otherwise, stacked header
  ///  is added for each column which are not in sequence order in regular
  /// columns.
  final List<String> columnNames;

  /// The widget that represents the data of this cell.
  ///
  /// Typically, a [Text] widget.
  final Widget child;

  List<int> _childColumnIndexes;
}
