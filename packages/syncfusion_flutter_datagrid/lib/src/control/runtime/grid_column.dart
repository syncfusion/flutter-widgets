part of datagrid;

/// Provides the base functionalities for all the column types in [SfDataGrid].
class GridColumn {
  /// Creates the [GridColumn] for [SfDataGrid] widget.
  GridColumn(
      {required this.columnName,
      required this.label,
      this.columnWidthMode = ColumnWidthMode.none,
      this.visible = true,
      this.allowSorting = true,
      this.autoFitPadding = const EdgeInsets.all(16.0),
      this.minimumWidth = double.nan,
      this.maximumWidth = double.nan,
      this.width = double.nan,
      this.allowEditing = true}) {
    _actualWidth = double.nan;
    _autoWidth = double.nan;
  }

  late double _autoWidth;

  /// The label of column header.
  ///
  /// Typically, this will be [Text] widget. You can also set [Icon]
  /// (Typically using size 18), or a [Row] with an icon and [Text].
  ///
  /// If you want to take the entire space for widget,
  /// e.g. when you want to use [Center], you can wrap it with an [Expanded].
  ///
  /// The widget will be loaded in text area alone. When sorting is applied,
  /// the default sort icon will be loaded along with the widget.
  final Widget label;

  /// How the column widths are determined.
  ///
  /// This takes higher priority than [SfDataGrid.columnWidthMode].
  ///
  /// Defaults to [ColumnWidthMode.none]
  ///
  /// Also refer [ColumnWidthMode]
  final ColumnWidthMode columnWidthMode;

  /// The name of a column.The name should be unique.
  ///
  /// This must not be empty or null.
  final String columnName;

  /// The actual display width of the column when auto fitted based on
  /// [SfDataGrid.columnWidthMode] or [columnWidthMode].
  ///
  /// Defaults to [double.nan]
  late double _actualWidth;

  /// The minimum width of the column.
  ///
  /// The column width could not be set or auto sized lesser than the
  /// [minimumWidth]
  ///
  /// Defaults to [double.nan]
  final double minimumWidth;

  /// The maximum width of the column.
  ///
  /// The column width could not be set or auto sized greater than the
  /// [maximumWidth]
  ///
  /// Defaults to [double.nan]
  final double maximumWidth;

  /// The width of the column.
  ///
  /// If value is lesser than [minimumWidth], then [minimumWidth]
  /// is set to [width].
  /// Otherwise, If value is greater than [maximumWidth], then the
  /// [maximumWidth] is set to [width].
  ///
  /// Defaults to [double.nan]
  final double width;

  /// Whether column should be hidden.
  ///
  /// Defaults to false.
  final bool visible;

  /// Decides whether user can sort the column simply by tapping the column
  /// header.
  ///
  /// Defaults to true.
  ///
  /// This is applicable only if the [SfDataGrid.allowSorting] is set as true.
  ///
  /// See also:
  ///
  /// * [SfDataGrid.allowSorting] – which allows users to sort the columns in
  /// [SfDataGrid].
  /// * [DataGridSource.sortedColumns] - which is the collection of
  /// [SortColumnDetails] objects to sort the columns in [SfDataGrid].
  /// * [DataGridSource.sort] - call this method when you are adding the
  /// [SortColumnDetails] programmatically to [DataGridSource.sortedColumns].
  final bool allowSorting;

  /// Decides whether cell should be moved into edit mode based on
  /// [SfDataGrid.editingGestureType].
  ///
  /// Defaults to false.
  ///
  /// Editing can be enabled only if the [SfDataGrid.selectionMode] is other
  /// than none and [SfDataGrid.navigationMode] is cell.
  ///
  /// See also,
  ///
  /// You can load the required widget on editing using
  /// [DataGridSource.buildEditWidget] method.
  ///
  /// See also,
  /// [DataGridSource.onCellBeginEdit]- This will be triggered when a cell is
  /// moved to edit mode.
  /// [DataGridSource.onCellSubmit] – This will be triggered when the cell’s
  /// editing is completed.
  final bool allowEditing;

  /// The amount of space which should be added with the auto size calculated
  /// when you use [SfDataGrid.columnWidthMode] as [ColumnWidthMode.auto] or
  /// [ColumnWidthMode.fitByCellValue] or [ColumnWidthMode.fitByColumnName]
  /// option.
  final EdgeInsets autoFitPadding;
}

/// A column which displays the values of the string in its cells.
///
/// This column has all the required APIs to customize the widget [Text] as it
/// displays [Text] for all the cells.
///
/// ``` dart
///  @override
///  Widget build(BuildContext context) {
///    return SfDataGrid(
///      source: employeeDataSource,
///      columns: [
///        GridTextColumn(columnName: 'name', label: Text('Name')),
///        GridTextColumn(columnName: 'designation', label: Text('Designation')),
///      ],
///    );
///  }
/// ```
@Deprecated('Use GridColumn instead.')
class GridTextColumn extends GridColumn {
  /// Creates a String column using [columnName] and [label].
  GridTextColumn({
    required String columnName,
    required Widget label,
    ColumnWidthMode columnWidthMode = ColumnWidthMode.none,
    EdgeInsets autoFitPadding = const EdgeInsets.all(16.0),
    bool visible = true,
    bool allowSorting = true,
    double minimumWidth = double.nan,
    double maximumWidth = double.nan,
    double width = double.nan,
    bool allowEditing = true,
  }) : super(
            columnName: columnName,
            label: label,
            columnWidthMode: columnWidthMode,
            autoFitPadding: autoFitPadding,
            visible: visible,
            allowSorting: allowSorting,
            minimumWidth: minimumWidth,
            maximumWidth: maximumWidth,
            width: width,
            allowEditing: allowEditing);
}
