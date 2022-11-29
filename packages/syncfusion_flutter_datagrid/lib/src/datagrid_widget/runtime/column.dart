// ignore_for_file: no_default_cases

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/localizations.dart';

import '../../grid_common/enums.dart';
import '../../grid_common/line_size_host.dart';
import '../../grid_common/visible_line_info.dart';
import '../helper/callbackargs.dart';
import '../helper/datagrid_configuration.dart';
import '../helper/datagrid_helper.dart' as grid_helper;
import '../helper/enums.dart';
import '../sfdatagrid.dart';
import 'generator.dart';

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
      this.allowEditing = true,
      this.allowFiltering = true}) {
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
  double get actualWidth => _actualWidth;
  late double _actualWidth;

  /// Determines how the filter menu is supposed to be shown.
  FilteredFrom _filterFrom = FilteredFrom.none;

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
  /// * [DataGridSource.onCellBeginEdit]- This will be triggered when a cell is
  /// moved to edit mode.
  /// * [DataGridSource.onCellSubmit] – This will be triggered when the cell’s
  /// editing is completed.
  final bool allowEditing;

  /// The amount of space which should be added with the auto size calculated
  /// when you use [SfDataGrid.columnWidthMode] as [ColumnWidthMode.auto] or
  /// [ColumnWidthMode.fitByCellValue] or [ColumnWidthMode.fitByColumnName]
  /// option.
  final EdgeInsets autoFitPadding;

  /// Decides whether the UI filtering should be enabled for this column.
  ///
  /// This property has the highest priority over [SfDataGrid.allowFiltering]
  /// property.
  ///
  /// See also,
  /// * [SfDataGrid.onFilterChanging] – This callback will be called if the
  /// column is being filtered through UI filtering.
  /// * [SfDataGrid.onFilterChanged] – This callback will be called if the
  /// column is filtered through UI filtering.
  /// * [DataGridSource.filterConditions] – This property holds the collection
  /// of the filter conditions which are applied for various columns.
  final bool allowFiltering;
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
  @Deprecated('Use GridColumn instead.')
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

/// A column which displays the checkbox column in its cells.
class GridCheckboxColumn extends GridColumn {
  /// Creates the [GridCheckboxColumn] for [SfDataGrid] widget.
  GridCheckboxColumn({
    required String columnName,
    required Widget label,
    double width = double.nan,
  }) : super(
          columnName: columnName,
          label: label,
          width: width,
        );
}

/// Contains all the properties of the checkbox column.
///
/// This settings are applied to checkbox column only if [SfDataGrid.showCheckboxColumn] is `true`.
class DataGridCheckboxColumnSettings {
  ///
  const DataGridCheckboxColumnSettings({
    this.showCheckboxOnHeader = true,
    this.label,
    this.width = 50,
    this.backgroundColor,
  });

  /// Decides whether [Checkbox] should be displayed in header of column which
  /// shows [Checkbox] to select/deselect the rows.
  ///
  /// Defaults to true.
  ///
  /// See also,
  /// [SfDataGrid.showCheckboxColumn] – This enables you to show [Checkbox] in
  /// each row to select/deselect the rows
  final bool showCheckboxOnHeader;

  /// The label of column header of checkbox column.
  ///
  /// Typically, checkbox can be enabled by setting
  /// [DataGridCheckboxColumnSettings.showCheckboxOnHeader] as `true`.
  final Widget? label;

  /// The width of the column.
  ///
  /// Defaults to 50.
  final double width;

  /// The background color of the checkbox column.
  ///
  /// You can customize the appearance of the [Checkbox] by using [ThemeData.checkboxTheme] property.
  final Color? backgroundColor;
}

/// Handles the sizing for all the columns in the [SfDataGrid].
///
/// You can override any available methods in this class to calculate the
/// column width based on your requirement and set the instance to the
/// [SfDataGrid.columnSizer].
///
/// ``` dart
/// class CustomGridColumnSizer extends ColumnSizer {
///   @override
///   double computeHeaderCellWidth(GridColumn column, TextStyle style) {
///     return super.computeHeaderCellWidth(column, style);
///   }
///
///   @override
///   double computeCellWidth(GridColumn column, DataGridRow row, Object? cellValue,
///       TextStyle textStyle) {
///     return super.computeCellWidth(column, row, cellValue, textStyle);
///   }
///
///   @override
///   double computeHeaderCellHeight(GridColumn column, TextStyle textStyle) {
///     return super.computeHeaderCellHeight(column, textStyle);
///   }
///
///   @override
///   double computeCellHeight(GridColumn column, DataGridRow row,
///       Object? cellValue, TextStyle textStyle) {
///     return super.computeCellHeight(column, row, cellValue, textStyle);
///   }
/// }
///
/// final CustomGridColumnSizer _customGridColumnSizer = CustomGridColumnSizer();
///
/// @override
/// Widget build(BuildContext context) {
///   return SfDataGrid(
///     source: _employeeDataSource,
///     columnSizer: _customGridColumnSizer,
///     columnWidthMode: ColumnWidthMode.auto,
///     columns: <GridColumn>[
///       GridColumn(columnName: 'id', label: Text('ID')),
///       GridColumn(columnName: 'name', label: Text('Name')),
///       GridColumn(columnName: 'designation', label: Text('Designation')),
///       GridColumn(columnName: 'salary', label: Text('Salary')),
///   );
/// }
/// ```
class ColumnSizer {
  /// Creates the [ColumnSizer] for [SfDataGrid] widget.
  ColumnSizer() {
    _isColumnSizerLoadedInitially = false;
  }

  DataGridStateDetails? _dataGridStateDetails;

  GridColumn? _autoFillColumn;

  bool _isColumnSizerLoadedInitially = false;

  static const double _sortIconWidth = 20.0;
  static const double _sortNumberWidth = 18.0;
  static const double _filterIconWidth = 34.0;

  void _initialRefresh(double availableWidth) {
    final LineSizeCollection lineSizeCollection =
        _dataGridStateDetails!().container.columnWidths as LineSizeCollection;
    lineSizeCollection.suspendUpdates();
    _refresh(availableWidth);
    lineSizeCollection.resumeUpdates();
  }

  void _refresh(double availableWidth) {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();

    final bool hasAnySizerColumn = dataGridConfiguration.columns.any(
        (GridColumn column) =>
            (column.columnWidthMode != ColumnWidthMode.none) ||
            (column.width != double.nan) ||
            !column.visible);

    final PaddedEditableLineSizeHostBase paddedEditableLineSizeHostBase =
        dataGridConfiguration.container.columnWidths;
    final LineSizeCollection? lineSizeCollection =
        paddedEditableLineSizeHostBase is LineSizeCollection
            ? paddedEditableLineSizeHostBase
            : null;

    if (lineSizeCollection == null) {
      return;
    }

    lineSizeCollection.suspendUpdates();
    _ensureColumnVisibility(dataGridConfiguration);

    if (dataGridConfiguration.columnWidthMode != ColumnWidthMode.none ||
        hasAnySizerColumn) {
      _sizerColumnWidth(dataGridConfiguration, availableWidth);
    }
    dataGridConfiguration.container.updateScrollBars();
    lineSizeCollection.resumeUpdates();
  }

  void _ensureColumnVisibility(DataGridConfiguration dataGridConfiguration) {
    for (final GridColumn column in dataGridConfiguration.columns) {
      final int index = dataGridConfiguration.columns.indexOf(column);
      dataGridConfiguration.container.columnWidths
          .setHidden(index, index, !column.visible);
    }
    // Columns will be auto sized only if Columns doesn't have explicit width
    // defined.
    _sizerColumnWidth(dataGridConfiguration, 0.0);
  }

  void _sizerColumnWidth(
      DataGridConfiguration dataGridConfiguration, double viewPortWidth) {
    double totalColumnSize = 0.0;
    final List<GridColumn> calculatedColumns = <GridColumn>[];

    _autoFillColumn = _getColumnToFill(dataGridConfiguration);

    // Hide Hidden columns
    final List<GridColumn> hiddenColumns = dataGridConfiguration.columns
        .where((GridColumn column) => !column.visible)
        .toList();
    for (final GridColumn column in hiddenColumns) {
      final int index = grid_helper.resolveToScrollColumnIndex(
          dataGridConfiguration, dataGridConfiguration.columns.indexOf(column));
      dataGridConfiguration.container.columnWidths
          .setHidden(index, index, true);
      calculatedColumns.add(column);
    }

    // Set width based on Column.Width
    final List<GridColumn> widthColumns = dataGridConfiguration.columns
        .skipWhile((GridColumn column) => !column.visible)
        .where((GridColumn column) => !(column.width).isNaN)
        .toList();
    for (final GridColumn column in widthColumns) {
      totalColumnSize +=
          _setColumnWidth(dataGridConfiguration, column, column.width);
      calculatedColumns.add(column);
    }

    // Set width based on fitByCellValue mode
    final List<GridColumn> fitByCellValueColumns = dataGridConfiguration.columns
        .skipWhile((GridColumn column) => !column.visible)
        .where((GridColumn column) =>
            column.columnWidthMode == ColumnWidthMode.fitByCellValue &&
            column.width.isNaN)
        .toList();
    for (final GridColumn column in fitByCellValueColumns) {
      if (column._autoWidth.isNaN) {
        final double columnWidth = _getWidthBasedOnColumn(
            dataGridConfiguration, column, ColumnWidthMode.fitByCellValue);
        totalColumnSize += columnWidth;
        _setAutoWidth(column, columnWidth);
      } else {
        totalColumnSize +=
            _setColumnWidth(dataGridConfiguration, column, column._autoWidth);
      }
      calculatedColumns.add(column);
    }

    // Set width based on fitByColumnName mode
    final List<GridColumn> fitByColumnNameColumns = dataGridConfiguration
        .columns
        .skipWhile((GridColumn column) => !column.visible)
        .where((GridColumn column) =>
            column.columnWidthMode == ColumnWidthMode.fitByColumnName &&
            column.width.isNaN)
        .toList();
    for (final GridColumn column in fitByColumnNameColumns) {
      totalColumnSize += _getWidthBasedOnColumn(
          dataGridConfiguration, column, ColumnWidthMode.fitByColumnName);
      calculatedColumns.add(column);
    }

    // Set width based on auto and lastColumnFill
    List<GridColumn> autoColumns = dataGridConfiguration.columns
        .where((GridColumn column) =>
            column.columnWidthMode == ColumnWidthMode.auto &&
            column.visible &&
            column.width.isNaN)
        .toList();

    final List<GridColumn> lastColumnFill =
        dataGridConfiguration.shrinkWrapColumns
            ? <GridColumn>[]
            : dataGridConfiguration.columns
                .skipWhile(
                    (GridColumn column) => calculatedColumns.contains(column))
                .where((GridColumn col) =>
                    col.columnWidthMode == ColumnWidthMode.lastColumnFill &&
                    !_isLastFillColum(col))
                .toList();

    autoColumns = (autoColumns + lastColumnFill).toSet().toList();

    for (final GridColumn column in autoColumns) {
      if (column._autoWidth.isNaN) {
        final double columnWidth = _getWidthBasedOnColumn(
            dataGridConfiguration, column, ColumnWidthMode.auto);
        totalColumnSize += columnWidth;
        _setAutoWidth(column, columnWidth);
      } else {
        totalColumnSize +=
            _setColumnWidth(dataGridConfiguration, column, column._autoWidth);
      }
      calculatedColumns.add(column);
    }
    _setWidthBasedOnGrid(dataGridConfiguration, totalColumnSize,
        calculatedColumns, viewPortWidth);
    _autoFillColumn = null;
  }

  GridColumn? _getColumnToFill(DataGridConfiguration dataGridConfiguration) {
    final GridColumn? column = dataGridConfiguration.columns.lastWhereOrNull(
        (GridColumn c) =>
            c.visible &&
            c.width.isNaN &&
            c.columnWidthMode == ColumnWidthMode.lastColumnFill);
    if (column != null) {
      return column;
    } else {
      if (dataGridConfiguration.columnWidthMode ==
          ColumnWidthMode.lastColumnFill) {
        final GridColumn? lastColumn = dataGridConfiguration.columns
            .lastWhereOrNull((GridColumn c) => c.visible && c.width.isNaN);
        if (lastColumn == null) {
          return null;
        }

        if (lastColumn.columnWidthMode == ColumnWidthMode.none) {
          return lastColumn;
        }
      }
    }
    return null;
  }

  void _setWidthBasedOnGrid(
      DataGridConfiguration dataGridConfiguration,
      double totalColumnSize,
      List<GridColumn> calculatedColumns,
      double viewPortWidth) {
    for (final GridColumn column in dataGridConfiguration.columns) {
      if (calculatedColumns.contains(column) ||
          column.columnWidthMode == ColumnWidthMode.fill ||
          _isLastFillColum(column)) {
        continue;
      }

      switch (dataGridConfiguration.columnWidthMode) {
        case ColumnWidthMode.fitByCellValue:
          if (column._autoWidth.isNaN) {
            final double columnWidth = _getWidthBasedOnColumn(
                dataGridConfiguration, column, ColumnWidthMode.fitByCellValue);
            totalColumnSize += columnWidth;
            _setAutoWidth(column, columnWidth);
          } else {
            totalColumnSize += _setColumnWidth(
                dataGridConfiguration, column, column._autoWidth);
          }
          calculatedColumns.add(column);
          break;
        case ColumnWidthMode.fitByColumnName:
          totalColumnSize += _getWidthBasedOnColumn(
              dataGridConfiguration, column, ColumnWidthMode.fitByColumnName);
          calculatedColumns.add(column);
          break;
        case ColumnWidthMode.auto:
        case ColumnWidthMode.lastColumnFill:
          if (dataGridConfiguration.shrinkWrapColumns) {
            break;
          }
          if (column._autoWidth.isNaN) {
            final double columnWidth = _getWidthBasedOnColumn(
                dataGridConfiguration, column, ColumnWidthMode.auto);
            totalColumnSize += columnWidth;
            _setAutoWidth(column, columnWidth);
          } else {
            totalColumnSize += _setColumnWidth(
                dataGridConfiguration, column, column._autoWidth);
          }
          calculatedColumns.add(column);
          break;
        case ColumnWidthMode.none:
          if (column.visible) {
            totalColumnSize += _setColumnWidth(dataGridConfiguration, column,
                dataGridConfiguration.container.columnWidths.defaultLineSize);
            calculatedColumns.add(column);
          }
          break;
        default:
          break;
      }
    }

    final List<GridColumn> remainingColumns = <GridColumn>[];

    for (final GridColumn column in dataGridConfiguration.columns) {
      if (!calculatedColumns.contains(column)) {
        remainingColumns.add(column);
      }
    }

    final double remainingColumnWidths = viewPortWidth - totalColumnSize;

    if (remainingColumnWidths > 0 &&
        !dataGridConfiguration.shrinkWrapColumns &&
        (totalColumnSize != 0 ||
            (totalColumnSize == 0 && remainingColumns.length == 1) ||
            (dataGridConfiguration.columns.any((GridColumn col) =>
                    col.columnWidthMode == ColumnWidthMode.fill) ||
                dataGridConfiguration.columnWidthMode ==
                    ColumnWidthMode.fill))) {
      _setFillWidth(
          dataGridConfiguration, remainingColumnWidths, remainingColumns);
    } else {
      _setRemainingColumnsWidth(dataGridConfiguration, remainingColumns);
    }
  }

  double _getWidthBasedOnColumn(DataGridConfiguration dataGridConfiguration,
      GridColumn column, ColumnWidthMode columnWidthMode) {
    double width = 0.0;
    switch (columnWidthMode) {
      case ColumnWidthMode.fitByCellValue:
        width = _calculateAllCellsExceptHeaderWidth(column);
        break;
      case ColumnWidthMode.fitByColumnName:
        width = _calculateColumnHeaderWidth(column);
        break;
      case ColumnWidthMode.auto:
        width = _calculateAllCellsWidth(column);
        break;
      default:
        return width;
    }
    return _setColumnWidth(dataGridConfiguration, column, width);
  }

  double _calculateAllCellsWidth(GridColumn column) {
    final double headerWidth =
        _calculateColumnHeaderWidth(column, setWidth: false);
    final double cellWidth =
        _calculateAllCellsExceptHeaderWidth(column, setWidth: false);
    return _getColumnWidth(column, max(cellWidth, headerWidth));
  }

  double _calculateColumnHeaderWidth(GridColumn column,
      {bool setWidth = true}) {
    final double width = _getHeaderCellWidth(column) +
        _getSortIconWidth(column) +
        _getFilterIconWidth(column);
    _updateSetWidth(setWidth, column, width);
    return width;
  }

  double _calculateAllCellsExceptHeaderWidth(GridColumn column,
      {bool setWidth = true}) {
    final double width = _calculateCellWidth(column);
    _updateSetWidth(setWidth, column, width);
    return width;
  }

  void _updateSetWidth(bool setWidth, GridColumn column, double columnWidth) {
    if (setWidth) {
      column._actualWidth = columnWidth;
    }
  }

  double _calculateCellWidth(GridColumn column) {
    double autoFitWidth = 0.0;
    int startRowIndex, endRowIndex;
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();

    if (dataGridConfiguration.source.rows.isEmpty) {
      return double.nan;
    }

    switch (dataGridConfiguration.columnWidthCalculationRange) {
      case ColumnWidthCalculationRange.allRows:
        startRowIndex = 0;
        endRowIndex = dataGridConfiguration.source.rows.length - 1;
        break;
      case ColumnWidthCalculationRange.visibleRows:
        final VisibleLinesCollection visibleLines =
            dataGridConfiguration.container.scrollRows.getVisibleLines(
                dataGridConfiguration.textDirection == TextDirection.rtl);
        startRowIndex =
            visibleLines.firstBodyVisibleIndex <= visibleLines.length - 1
                ? visibleLines.firstBodyVisibleIndex
                : 0;
        endRowIndex = visibleLines.lastBodyVisibleIndex;
        break;
    }

    for (int rowIndex = startRowIndex; rowIndex <= endRowIndex; rowIndex++) {
      autoFitWidth = max(_getCellWidth(column, rowIndex), autoFitWidth);
    }

    return autoFitWidth;
  }

  double _getHeaderCellWidth(GridColumn column) {
    return computeHeaderCellWidth(
        column, _getDefaultTextStyle(_dataGridStateDetails!(), true));
  }

  double _getCellWidth(GridColumn column, int rowIndex) {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    if (grid_helper.isFooterWidgetRow(rowIndex, dataGridConfiguration) ||
        grid_helper.isTableSummaryIndex(dataGridConfiguration, rowIndex)) {
      return 0.0;
    }

    late DataGridRow dataGridRow;
    switch (dataGridConfiguration.columnWidthCalculationRange) {
      case ColumnWidthCalculationRange.allRows:
        dataGridRow = effectiveRows(dataGridConfiguration.source)[rowIndex];
        break;
      case ColumnWidthCalculationRange.visibleRows:
        dataGridRow =
            grid_helper.getDataGridRow(dataGridConfiguration, rowIndex);
        break;
    }
    return _measureCellWidth(
        _getCellValue(dataGridRow, column), column, dataGridRow);
  }

  Object? _getCellValue(DataGridRow dataGridRow, GridColumn column) {
    return dataGridRow
        .getCells()
        .firstWhereOrNull(
            (DataGridCell cell) => cell.columnName == column.columnName)
        ?.value;
  }

  void _setFillWidth(DataGridConfiguration dataGridConfiguration,
      double remainingColumnWidth, List<GridColumn> remainingColumns) {
    final List<GridColumn> removedColumns = <GridColumn>[];
    final List<GridColumn> columns = remainingColumns;
    double totalRemainingFillValue = remainingColumnWidth;

    double removedWidth = 0;
    GridColumn? fillColumn;
    bool isRemoved;
    while (columns.isNotEmpty) {
      isRemoved = false;
      removedWidth = 0;
      final double fillWidth =
          (totalRemainingFillValue / columns.length).floorToDouble();
      final GridColumn column = columns.first;
      if (column == _autoFillColumn &&
          (column.columnWidthMode == ColumnWidthMode.lastColumnFill ||
              dataGridConfiguration.columnWidthMode ==
                  ColumnWidthMode.lastColumnFill)) {
        columns.remove(column);
        fillColumn = column;
        continue;
      }

      final double computedWidth =
          _setColumnWidth(dataGridConfiguration, column, fillWidth);
      if (fillWidth != computedWidth && fillWidth > 0) {
        isRemoved = true;
        columns.remove(column);
        for (final GridColumn removedColumn in removedColumns) {
          if (!columns.contains(removedColumn)) {
            removedWidth += removedColumn._actualWidth;
            columns.add(removedColumn);
          }
        }
        removedColumns.clear();
        totalRemainingFillValue += removedWidth;
      }

      column._actualWidth = computedWidth;
      totalRemainingFillValue -= computedWidth;
      if (!isRemoved) {
        columns.remove(column);
        if (!removedColumns.contains(column)) {
          removedColumns.add(column);
        }
      }
    }

    if (fillColumn != null) {
      double columnWidth = 0.0;
      if (fillColumn._autoWidth.isNaN) {
        _setAutoWidth(fillColumn, columnWidth);
      } else {
        columnWidth = fillColumn._autoWidth;
      }

      _setColumnWidth(dataGridConfiguration, fillColumn,
          max(totalRemainingFillValue, columnWidth));
    }
  }

  void _setRemainingColumnsWidth(DataGridConfiguration dataGridConfiguration,
      List<GridColumn> remainingColumns) {
    for (final GridColumn column in remainingColumns) {
      if (_isLastFillColum(column) ||
          !_isFillColumn(dataGridConfiguration, column)) {
        _setColumnWidth(dataGridConfiguration, column,
            dataGridConfiguration.container.columnWidths.defaultLineSize);
      }
    }
  }

  bool _isFillColumn(
      DataGridConfiguration dataGridConfiguration, GridColumn column) {
    if (!column.width.isNaN) {
      return false;
    } else {
      return column.columnWidthMode == ColumnWidthMode.none
          ? dataGridConfiguration.columnWidthMode == ColumnWidthMode.fill
          : column.columnWidthMode == ColumnWidthMode.fill;
    }
  }

  bool _isLastFillColum(GridColumn column) => column == _autoFillColumn;

  void _setAutoWidth(GridColumn? column, double width) {
    if (column != null) {
      column._autoWidth = width;
    }
  }

  void _resetAutoCalculation() {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    for (final GridColumn column in dataGridConfiguration.columns) {
      column._autoWidth = double.nan;
    }
  }

  double _getSortIconWidth(GridColumn column) {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    double width = 0.0;
    final bool isSortedColumn = dataGridConfiguration.source.sortedColumns
        .any((SortColumnDetails element) => element.name == column.columnName);
    if (isSortedColumn ||
        (column.allowSorting && dataGridConfiguration.allowSorting)) {
      width += _sortIconWidth;
      if (dataGridConfiguration.allowMultiColumnSorting &&
          dataGridConfiguration.showSortNumbers) {
        width += _sortNumberWidth;
      }
    }
    return width;
  }

  double _getFilterIconWidth(GridColumn column) {
    if (_dataGridStateDetails!().allowFiltering && column.allowFiltering) {
      return _filterIconWidth;
    }
    return 0.0;
  }

  double _setColumnWidth(DataGridConfiguration dataGridConfiguration,
      GridColumn column, double columnWidth) {
    final int columnIndex = dataGridConfiguration.columns.indexOf(column);
    final double width = _getColumnWidth(column, columnWidth);
    column._actualWidth = width;
    dataGridConfiguration.container.columnWidths[columnIndex] =
        column._actualWidth;
    return width;
  }

  double _getColumnWidth(GridColumn column, double columnWidth) {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    final int columnIndex = dataGridConfiguration.columns.indexOf(column);
    if (column.width < column._actualWidth) {
      return columnWidth;
    }

    final double width =
        dataGridConfiguration.container.columnWidths[columnIndex];
    return _checkWidthConstraints(column, columnWidth, width);
  }

  double _checkWidthConstraints(
      GridColumn column, double width, double columnWidth) {
    if (!column.minimumWidth.isNaN || !column.maximumWidth.isNaN) {
      if (!column.maximumWidth.isNaN) {
        if (!width.isNaN && column.maximumWidth > width) {
          columnWidth = width;
        } else {
          columnWidth = column.maximumWidth;
        }
      }

      if (!column.minimumWidth.isNaN) {
        if (!width.isNaN && column.minimumWidth < width) {
          if (width > column.maximumWidth) {
            columnWidth = column.maximumWidth;
          } else {
            columnWidth = width;
          }
        } else {
          columnWidth = column.minimumWidth;
        }
      }
    } else {
      if (!width.isNaN) {
        columnWidth = width;
      }
    }
    return columnWidth;
  }

  /// Calculates the width of the header cell based on the [GridColumn.columnName].
  /// You can override this method to perform the custom calculation for height.
  ///
  /// If you want to calculate the width based on different [TextStyle], you can
  /// override this method and call the super method with the required [TextStyle].
  /// Set the custom [ColumnSizer] to [SfDataGrid.columnSizer] property.
  ///
  /// ``` dart
  ///class CustomColumnSizer extends ColumnSizer {
  /// @override
  ///  double computeHeaderCellWidth(GridColumn column,
  ///      TextStyle textStyle) {
  ///   TextStyle style = textStyle;
  ///   if (column.columnName == 'Name')
  ///    style = TextStyle(fontSize: 20, fontStyle: FontStyle.italic);
  ///  return super.computeHeaderCellWidth(column, style);
  /// }
  ///}
  ///```
  ///
  /// The auto size is calculated based on default [TextStyle] of the datagrid.
  @protected
  double computeHeaderCellWidth(GridColumn column, TextStyle style) {
    return _calculateTextSize(
      column: column,
      textStyle: style,
      width: double.infinity,
      value: column.columnName,
      rowIndex: grid_helper.getHeaderIndex(_dataGridStateDetails!()),
    ).width.roundToDouble();
  }

  /// Calculates the width of the cell based on the [DataGridCell.value]. You
  /// can override this method to perform the custom calculation for width.
  ///
  /// If you want to calculate the width based on different [TextStyle], you can
  /// override this method and return the super method with the required [TextStyle].
  /// Set the custom [ColumnSizer] to [SfDataGrid.columnSizer] property.
  ///
  /// The following example show how to pass the different TextStyle for width calculation,
  ///
  /// ``` dart
  ///class CustomColumnSizer extends ColumnSizer {
  /// @override
  ///  double computeCellWidth(GridColumn column, DataGridRow row, Object cellValue,
  ///      TextStyle textStyle) {
  ///   TextStyle style = textStyle;
  ///   if (column.columnName == 'Name')
  ///    style = TextStyle(fontSize: 20, fontStyle: FontStyle.italic);
  ///  return super.computeCellWidth(column, row, cellValue, style);
  /// }
  ///}
  ///```
  ///
  /// The auto size is calculated based on default [TextStyle] of the datagrid.
  @protected
  double computeCellWidth(GridColumn column, DataGridRow row, Object? cellValue,
      TextStyle textStyle) {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    final int rowIndex = grid_helper.resolveToRowIndex(dataGridConfiguration,
        effectiveRows(dataGridConfiguration.source).indexOf(row));

    return _calculateTextSize(
            column: column,
            value: cellValue,
            rowIndex: rowIndex,
            textStyle: textStyle,
            width: double.infinity)
        .width
        .roundToDouble();
  }

  /// Calculates the height of the header cell based on the [GridColumn.columnName].
  ///
  /// ``` dart
  ///class CustomColumnSizer extends ColumnSizer {
  /// @override
  ///  double computeHeaderCellHeight(GridColumn column,
  ///      TextStyle textStyle) {
  ///   TextStyle style = textStyle;
  ///   if (column.columnName == 'Name')
  ///    style = TextStyle(fontSize: 20, fontStyle: FontStyle.italic);
  ///  return super.computeHeaderCellHeight(column, style);
  /// }
  ///}
  ///```
  ///
  /// The auto size is calculated based on default [TextStyle] of the datagrid.
  @protected
  double computeHeaderCellHeight(GridColumn column, TextStyle textStyle) {
    return _measureCellHeight(
        column,
        grid_helper.getHeaderIndex(_dataGridStateDetails!()),
        column.columnName,
        textStyle);
  }

  /// Calculates the height of the cell based on the [DataGridCell.value].
  /// You can override this method to perform the custom calculation for hight.
  ///
  /// If you want to calculate the width based on different [TextStyle], you can
  /// override this method and call the super method with the required [TextStyle].
  /// Set the custom [ColumnSizer] to [SfDataGrid.columnSizer] property.
  ///
  /// ``` dart
  ///class CustomColumnSizer extends ColumnSizer {
  /// @override
  ///  double computeCellHeight(GridColumn column, DataGridRow row, Object cellValue,
  ///      TextStyle textStyle) {
  ///   TextStyle style = textStyle;
  ///   if (column.columnName == 'Name')
  ///    style = TextStyle(fontSize: 20, fontStyle: FontStyle.italic);
  ///  return super.computeCellWidth(column, row, cellValue, style);
  /// }
  ///}
  ///```
  ///
  /// The auto size is calculated based on default [TextStyle] of the datagrid.
  @protected
  double computeCellHeight(GridColumn column, DataGridRow row,
      Object? cellValue, TextStyle textStyle) {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    final int rowIndex = grid_helper.resolveToRowIndex(dataGridConfiguration,
        effectiveRows(dataGridConfiguration.source).indexOf(row));
    return _measureCellHeight(column, rowIndex, cellValue, textStyle);
  }

  double _getAutoFitRowHeight(int rowIndex,
      {bool canIncludeHiddenColumns = false,
      List<String> excludedColumns = const <String>[]}) {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    double autoFitHeight = 0.0;
    if (dataGridConfiguration.stackedHeaderRows.isNotEmpty &&
        rowIndex <= dataGridConfiguration.stackedHeaderRows.length - 1) {
      return dataGridConfiguration.headerRowHeight;
    }
    if (grid_helper.isFooterWidgetRow(rowIndex, dataGridConfiguration)) {
      return dataGridConfiguration.footerHeight;
    }

    if (grid_helper.isTableSummaryIndex(dataGridConfiguration, rowIndex)) {
      return dataGridConfiguration.rowHeight;
    }

    for (int index = 0; index < dataGridConfiguration.columns.length; index++) {
      final GridColumn column = dataGridConfiguration.columns[index];
      if ((!column.visible && !canIncludeHiddenColumns) ||
          excludedColumns.contains(column.columnName)) {
        continue;
      }

      autoFitHeight = max(_getRowHeight(column, rowIndex), autoFitHeight);
    }
    return autoFitHeight;
  }

  double _getRowHeight(GridColumn column, int rowIndex) {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    if (rowIndex == grid_helper.getHeaderIndex(dataGridConfiguration)) {
      return computeHeaderCellHeight(
          column, _getDefaultTextStyle(dataGridConfiguration, true));
    } else {
      final DataGridRow row =
          grid_helper.getDataGridRow(dataGridConfiguration, rowIndex);
      return computeCellHeight(column, row, _getCellValue(row, column),
          _getDefaultTextStyle(dataGridConfiguration, false));
    }
  }

  double _measureCellWidth(
      Object? cellValue, GridColumn column, DataGridRow dataGridRow) {
    return computeCellWidth(column, dataGridRow, cellValue,
        _getDefaultTextStyle(_dataGridStateDetails!(), false));
  }

  double _measureCellHeight(
      GridColumn column, int rowIndex, Object? cellValue, TextStyle textStyle) {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    final int columnIndex = dataGridConfiguration.columns.indexOf(column);
    double columnWidth = !column.visible || column.width == 0.0
        ? dataGridConfiguration.defaultColumnWidth
        : dataGridConfiguration.container.columnWidths[columnIndex];

    final double strokeWidth = _getGridLineStrokeWidth(
            rowIndex: rowIndex, dataGridConfiguration: dataGridConfiguration)
        .width;

    final double horizontalPadding = column.autoFitPadding.horizontal;

    // Removed the padding and gridline stroke width from the column width to
    // measure the accurate height for the cell content.
    columnWidth -= _getSortIconWidth(column) +
        _getFilterIconWidth(column) +
        horizontalPadding +
        strokeWidth;

    return _calculateTextSize(
      column: column,
      value: cellValue,
      width: columnWidth,
      textStyle: textStyle,
      rowIndex: rowIndex,
    ).height.roundToDouble();
  }

  TextStyle _getDefaultTextStyle(
      DataGridConfiguration dataGridConfiguration, bool isHeader) {
    if (isHeader) {
      return TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color:
              dataGridConfiguration.colorScheme!.onSurface.withOpacity(0.87));
    } else {
      return TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color:
              dataGridConfiguration.colorScheme!.onSurface.withOpacity(0.87));
    }
  }

  Size _getGridLineStrokeWidth(
      {required int rowIndex,
      required DataGridConfiguration dataGridConfiguration}) {
    final double strokeWidth =
        dataGridConfiguration.dataGridThemeHelper!.gridLineStrokeWidth;

    final GridLinesVisibility gridLinesVisibility =
        rowIndex <= grid_helper.getHeaderIndex(dataGridConfiguration)
            ? dataGridConfiguration.headerGridLinesVisibility
            : dataGridConfiguration.gridLinesVisibility;

    switch (gridLinesVisibility) {
      case GridLinesVisibility.none:
        return Size.zero;
      case GridLinesVisibility.both:
        return Size(strokeWidth, strokeWidth);
      case GridLinesVisibility.vertical:
        return Size(strokeWidth, 0);
      case GridLinesVisibility.horizontal:
        return Size(0, strokeWidth);
    }
  }

  Size _calculateTextSize({
    required Object? value,
    required int rowIndex,
    required double width,
    required GridColumn column,
    required TextStyle textStyle,
  }) {
    late Size textSize;

    // TextPainter's maxWidth should not be less than or equal to its minWidth.
    // So, We have restricted the behavior by providing a default width to 10.0
    // when it reached the limit While resizing the column.
    width = max(width, 10.0);
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();

    final Size strokeWidthSize = _getGridLineStrokeWidth(
        rowIndex: rowIndex, dataGridConfiguration: dataGridConfiguration);

    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: value?.toString() ?? '', style: textStyle),
        textScaleFactor: dataGridConfiguration.textScaleFactor,
        textDirection: dataGridConfiguration.textDirection)
      ..layout(maxWidth: width);

    textSize = Size(
        textPainter.size.width +
            strokeWidthSize.width +
            column.autoFitPadding.horizontal,
        textPainter.size.height +
            strokeWidthSize.height +
            column.autoFitPadding.vertical);

    return textSize;
  }
}

/// Helps to call `initialRefresh` method in the `columnSizer`.
void initialRefresh(ColumnSizer columnSizer, double availableWidth) {
  columnSizer._initialRefresh(availableWidth);
}

/// Calls the `refresh` method to refresh all the column's width.
void refreshColumnSizer(ColumnSizer columnSizer, double availableWidth) {
  columnSizer._refresh(availableWidth);
}

/// Resets the auto fit calculation column widths.
void resetAutoCalculation(ColumnSizer columnSizer) {
  columnSizer._resetAutoCalculation();
}

/// Updates the column sizer's state whether its loaded or not initially.
void updateColumnSizerLoadedInitiallyFlag(
    ColumnSizer columnSizer, bool isLoaded) {
  columnSizer._isColumnSizerLoadedInitially = isLoaded;
}

/// Returns the width of a sorting icon.
double getSortIconWidth(ColumnSizer columnSizer, GridColumn column) {
  return columnSizer._getSortIconWidth(column);
}

/// Returns the width of a filter icon.
double getFilterIconWidth(ColumnSizer columnSizer, GridColumn column) {
  return columnSizer._getFilterIconWidth(column);
}

/// Returns the auto fit row height of the given row based on index.
double getAutoFitRowHeight(ColumnSizer columnSizer, int rowIndex,
    {bool canIncludeHiddenColumns = false,
    List<String> excludedColumns = const <String>[]}) {
  return columnSizer._getAutoFitRowHeight(rowIndex,
      canIncludeHiddenColumns: canIncludeHiddenColumns,
      excludedColumns: excludedColumns);
}

/// Sets `dataGridConfiguration` to the [ColumnSizer].
void setStateDetailsInColumnSizer(
    ColumnSizer columnSizer, DataGridStateDetails dataGridCellDetails) {
  columnSizer._dataGridStateDetails = dataGridCellDetails;
}

/// Checks whether the column sizer is loaded initially or not.
bool isColumnSizerLoadedInitially(ColumnSizer columnSizer) {
  return columnSizer._isColumnSizerLoadedInitially;
}

/// Process column resizing operation in [SfDataGrid].
class ColumnResizeController {
  /// Creates the [ColumnResizeController] for the [SfDataGrid].
  ColumnResizeController({required this.dataGridStateDetails});

  /// Holds the [DataGridStateDetails].
  final DataGridStateDetails dataGridStateDetails;

  /// Holds the buffer value for enable column resizing based on the
  /// target platform.
  double? _hitTestPrecision;

  /// Checks whether any column is currently resizing or not.
  bool isResizing = false;

  /// Decides whether the cursor will have to change
  /// [SystemMouseCursors.resizeColumn] or not.
  bool canSwitchResizeColumnCursor = false;

  /// Determines whether the resizing indicator is enable or not.
  bool isResizeIndicatorVisible = false;

  /// Sets the resizing column's right border position to the x position of
  /// the resizing indicator.
  double indicatorPosition = 0.0;

  /// Maintains the resizing cell from tapped position.
  DataCellBase? resizingDataCell;

  /// Holds the current resizing line information.
  VisibleLineInfo? _resizingLine;

  /// Maintain the temporary value to update the width of the column.
  double _resizingColumnWidth = 0.0;

  /// Holds the current resizing grid column.
  GridColumn? _currentResizingColumn;

  // * Properties for mobile platform

  /// Checks whether the column resizing is enable by the long press or not in
  /// the mobile platform.
  bool _canStartResizeInMobile = false;

  /// Checks whether the long press event is completed or not in the
  /// current state.
  /// Helps to activate the `_canStartResizingInMobile` property.
  bool _isLongPressEnabled = false;

  /// Holds the row index of the current resizing header cell.
  int rowIndex = 0;

  /// Holds the spanned value of the current resizing header cell.
  int rowSpan = 0;

  bool _isHeaderRow(DataRowBase dataRow) =>
      dataRow.rowType == RowType.headerRow ||
      dataRow.rowType == RowType.stackedHeaderRow;

  VisibleLineInfo? _getHitTestResult(double dx,
      {bool isPressed = false, bool canAllowBuffer = true}) {
    if (!isResizing) {
      final DataGridConfiguration dataGridConfiguration =
          dataGridStateDetails();

      // Resolve the local dx position.
      dx = getXPosition(dataGridConfiguration, dx);

      _resizingLine = _getResizingLine(dx, canAllowBuffer);

      if (_resizingLine != null &&
          _resizingLine!.lineIndex >=
              grid_helper.resolveToStartColumnIndex(dataGridConfiguration)) {
        // To ensure the resizing line for the stacked header row.
        if (dataGridConfiguration.stackedHeaderRows.isNotEmpty) {
          if (!_canAllowResizing(dx, resizingDataCell,
              canAllowBuffer: canAllowBuffer)) {
            return null;
          }
        }

        if (!isPressed) {
          return _resizingLine;
        }
        // Issue:
        // FLUT-6123 - The column resizing indicator is showing over the footer frozen column in the Android Platform.
        //
        // Fix:
        // An issue occurred due to not considering the column which is corner clipped by the frozen columns.
        // Now, we have restricted the clipped columns to disable resizing for the columns.
        if (_resizingLine!.isClippedCorner) {
          return null;
        }
        _ensureDataCell(dx, resizingDataCell);
        _onResizingStart();
        return _resizingLine;
      } else {
        return null;
      }
    }
    return null;
  }

  void _onResizingStart() {
    if (_resizingLine != null && !isResizeIndicatorVisible) {
      final DataGridConfiguration dataGridConfiguration =
          dataGridStateDetails();
      _currentResizingColumn =
          dataGridConfiguration.columns[_resizingLine!.lineIndex];
      if (_raiseColumnResizeStart()) {
        isResizeIndicatorVisible = true;
        indicatorPosition = _getIndicatorPosition(_resizingLine!,
            dataGridConfiguration.textDirection == TextDirection.ltr,
            isDefault: true);

        _resizingColumnWidth = _resizingLine!.size;

        // Resets the swiping offset.
        dataGridConfiguration.container.resetSwipeOffset();
      }
    }
  }

  void _onResizing(double currentColumnWidth, double indicatorXPosition) {
    if (_resizingLine == null || !isResizeIndicatorVisible) {
      return;
    }

    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();

    isResizing = true;

    // Need to update the resizing line to get the line's updated details after
    // resizing it.
    _resizingLine = dataGridConfiguration.container.scrollColumns
        .getVisibleLineAtLineIndex(_resizingLine!.lineIndex,
            isRightToLeft:
                dataGridConfiguration.textDirection == TextDirection.rtl);

    if (dataGridConfiguration.columnResizeMode == ColumnResizeMode.onResize) {
      dataGridConfiguration.container.isDirty = true;
      if (!_raiseColumnResizeUpdate(currentColumnWidth)) {
        return;
      }
      // Issue:
      // FLUT-6123 - The column resizing Indicator position is applied improperly
      // when setting width limit to a particular column in `onColumnsResizeUpdate` callback.
      //
      // Fix:
      // The position changed because of update the indicator position before the `onColumnResizeUpdate` callback.
      // We have resolved the issue by updating the indicator position after the `onColumnResizeUpdate` callback.
      indicatorPosition = indicatorXPosition;
    } else {
      // Sets indicator position.
      indicatorPosition = indicatorXPosition;
      // Rebuild to update the resizing indicator alone.
      _rebuild();
    }
  }

  // * Helper methods

  bool _canAllowResizing(double downX, DataCellBase? dataColumn,
      {bool canAllowBuffer = true}) {
    if (dataColumn != null &&
        _resizingLine != null &&
        dataColumn.dataRow!.rowType == RowType.stackedHeaderRow &&
        dataColumn.columnSpan > 0) {
      final DataGridConfiguration dataGridConfiguration =
          dataGridStateDetails();
      late int cellLeft, cellRight, lineIndex;

      final DataCellBase? dataCell = dataColumn.dataRow!.visibleColumns
          .firstWhereOrNull((DataCellBase dataCell) {
        cellLeft = dataCell.columnIndex;
        cellRight = dataCell.columnIndex + dataCell.columnSpan;
        lineIndex = _resizingLine!.lineIndex;

        return cellLeft == lineIndex ||
            cellRight == lineIndex ||
            (lineIndex > cellLeft && lineIndex < cellRight);
      });

      if (dataCell != null) {
        final bool isLTR =
            dataGridConfiguration.textDirection == TextDirection.ltr;
        cellLeft = dataCell.columnIndex;
        cellRight = cellLeft + dataCell.columnSpan;
        lineIndex = _resizingLine!.lineIndex;

        final double origin =
            isLTR ? _resizingLine!.clippedOrigin : _resizingLine!.corner;
        final double corner =
            isLTR ? _resizingLine!.corner : _resizingLine!.clippedOrigin;

        if (canAllowBuffer) {
          if ((cellLeft == lineIndex &&
                  (corner - downX).abs() <= _hitTestPrecision!) ||
              (cellRight == lineIndex &&
                  (origin - downX).abs() <= _hitTestPrecision!) ||
              (lineIndex > cellLeft && lineIndex < cellRight)) {
            return false;
          }
        } else {
          _resizingLine = dataGridConfiguration.container.scrollColumns
              .getVisibleLineAtLineIndex(cellRight, isRightToLeft: !isLTR);
          return _resizingLine != null;
        }
      }
    }
    return true;
  }

  void _ensureDataCell(double x, DataCellBase? dataCell) {
    if (isResizing || isResizeIndicatorVisible || dataCell == null) {
      return;
    }

    DataCellBase? nearDataCell;
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    final bool isLTR = dataGridConfiguration.textDirection == TextDirection.ltr;

    final VisibleLineInfo? visibleLine = dataGridConfiguration
        .container.scrollColumns
        .getVisibleLineAtLineIndex(dataCell.columnIndex, isRightToLeft: !isLTR);
    if (visibleLine != null) {
      final bool canCheckNearCell = !(visibleLine.isLastLine &&
          visibleLine.isClippedCorner &&
          visibleLine.isClippedOrigin);
      final double origin =
          isLTR ? visibleLine.clippedOrigin : visibleLine.corner;
      final double corner =
          isLTR ? visibleLine.corner : visibleLine.clippedOrigin;

      if (canCheckNearCell) {
        if (_hitTestPrecision! > (corner - x).abs()) {
          nearDataCell = _getDataCell(dataGridConfiguration, dataCell.rowIndex,
              dataCell.columnIndex + 1);
        } else if (_hitTestPrecision! > (origin - x).abs()) {
          nearDataCell = _getDataCell(dataGridConfiguration, dataCell.rowIndex,
              dataCell.columnIndex - 1);
        }
      }

      if (nearDataCell != null && nearDataCell.rowSpan > dataCell.rowSpan) {
        resizingDataCell = nearDataCell;
        rowIndex = nearDataCell.rowIndex;
        rowSpan = nearDataCell.rowSpan;
      }
    }
  }

  DataCellBase? _getDataCell(DataGridConfiguration dataGridConfiguration,
      int rowIndex, int columnIndex) {
    final DataRowBase? dataRow = dataGridConfiguration
        .container.rowGenerator.items
        .firstWhereOrNull((DataRowBase element) =>
            rowIndex >= 0 && element.rowIndex == rowIndex);
    if (dataRow == null || dataRow.visibleColumns.isEmpty) {
      return null;
    }

    return dataRow.visibleColumns.firstWhereOrNull((DataCellBase dataCell) =>
        columnIndex >= 0 && dataCell.columnIndex == columnIndex);
  }

  double _getIndicatorPosition(VisibleLineInfo line, bool isLTR,
      {bool isDefault = false,
      ScrollController? scrollController,
      double? currentColumnWidth}) {
    late double indicatorLeft;
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    if (isDefault) {
      indicatorLeft = isLTR ? line.corner : line.clippedOrigin;
    } else {
      // Maintains the indicator on the same position when scrolling happens from the
      // `extentBefore` side.
      if (dataGridConfiguration.columnResizeMode == ColumnResizeMode.onResize &&
          ((line.isFooter && scrollController!.position.maxScrollExtent > 0) ||
              (scrollController!.position.extentBefore > 0 &&
                  scrollController.position.extentAfter == 0))) {
        indicatorLeft = isLTR ? line.corner : line.clippedOrigin;
      } else {
        indicatorLeft = isLTR
            ? (line.origin + currentColumnWidth!)
            : (line.corner + line.scrollOffset - currentColumnWidth!);
      }
    }

    // To remove the half of stroke width to show the indicator to the
    // center of grid line.
    indicatorLeft -= dataGridConfiguration
            .dataGridThemeHelper!.columnResizeIndicatorStrokeWidth /
        2;

    return indicatorLeft;
  }

  VisibleLineInfo? _getResizingLine(double dx, bool canAllowBuffer) {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    final bool isLTR = dataGridConfiguration.textDirection == TextDirection.ltr;
    bool canAllowResizing(VisibleLineInfo? line) {
      if (line != null) {
        final double origin = isLTR ? line.corner : line.clippedOrigin;
        return _hitTestPrecision! > (dx - origin).abs();
      }
      return false;
    }

    VisibleLineInfo? resizeLine = _getVisibleLineAtPoint(dx, !isLTR);

    if (canAllowBuffer) {
      if (canAllowResizing(resizeLine)) {
        return resizeLine;
      } else {
        // Gets the near line based on hitTestPrecision.
        resizeLine = _getVisibleLineAtPoint(dx, !isLTR, checkNearLine: true);
        return canAllowResizing(resizeLine) ? resizeLine : null;
      }
    } else {
      return resizeLine;
    }
  }

  VisibleLineInfo? _getVisibleLineAtPoint(double position, bool isRTL,
      {bool checkNearLine = false}) {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    if (checkNearLine) {
      return dataGridConfiguration.container.scrollColumns.getLineNearCorner(
          position, _hitTestPrecision!, CornerSide.both,
          isRightToLeft: isRTL);
    } else {
      return dataGridConfiguration.container.scrollColumns
          .getVisibleLineAtPoint(position, true, isRTL);
    }
  }

  /// Resolves the point of the current local position to get the visibleLine.
  double getXPosition(
      DataGridConfiguration dataGridConfiguration, double localPosition) {
    final ScrollController scrollController =
        dataGridConfiguration.horizontalScrollController!;
    if (dataGridConfiguration.textDirection == TextDirection.ltr) {
      return localPosition - scrollController.offset;
    } else {
      return localPosition -
          (scrollController.position.maxScrollExtent - scrollController.offset);
    }
  }

  /// Sets the current tapped data cell to the column resizing cell.
  void setDataCell(DataCellBase dataCell) {
    if (_isHeaderRow(dataCell.dataRow!)) {
      if (dataGridStateDetails().allowColumnsResizing &&
          !isResizing &&
          !isResizeIndicatorVisible) {
        resizingDataCell = dataCell;
        rowIndex = dataCell.rowIndex;
        rowSpan = dataCell.rowSpan;
      }
    }
  }

  /// Sets the `hitTestPrecision` to the column resizing based on the current
  /// platform.
  void setHitTestPrecision() {
    _hitTestPrecision ??= dataGridStateDetails().isDesktop ? 10.0 : kTouchSlop;
  }

  // * Column Resizing callbacks

  bool _raiseColumnResizeStart() {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    if (dataGridConfiguration.onColumnResizeStart != null) {
      return dataGridConfiguration.onColumnResizeStart!(
          ColumnResizeStartDetails(
              column: _currentResizingColumn!, width: _resizingColumnWidth));
    }
    return true;
  }

  bool _raiseColumnResizeUpdate(double currentColumnWidth) {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    if (dataGridConfiguration.onColumnResizeUpdate != null) {
      return dataGridConfiguration.onColumnResizeUpdate!(
          ColumnResizeUpdateDetails(
              column: _currentResizingColumn!, width: currentColumnWidth));
    }
    return true;
  }

  void _raiseColumnResizeEnd(double currentColumnWidth) {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    if (dataGridConfiguration.onColumnResizeEnd != null) {
      dataGridConfiguration.onColumnResizeEnd!(ColumnResizeEndDetails(
          column: _currentResizingColumn!, width: currentColumnWidth));
    }
  }

  // *  Pointer Events

  /// Handles the pointer down event for the column resizing.
  void onPointerDown(PointerDownEvent event, DataRowBase dataRow) {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    if (dataGridConfiguration.isDesktop || _canStartResizeInMobile) {
      if (_isHeaderRow(dataRow)) {
        // Clears the editing before start resizing a column.
        if (dataGridConfiguration.currentCell.isEditing) {
          dataGridConfiguration.currentCell.onCellSubmit(dataGridConfiguration);
        }

        final VisibleLineInfo? resizingLine =
            _getHitTestResult(event.localPosition.dx, isPressed: true);

        _canStartResizeInMobile = false;

        if (resizingLine != null && isResizeIndicatorVisible) {
          if (dataGridConfiguration.isDesktop) {
            // Rebuild to activate the indicator to the view after pressed the
            // resizing column in desktop and web.
            _rebuild();
          }
        } else {
          // To disable resizing indicator when taping the other area of the
          // header and stacked header rows after enabled the indicator by long press.
          if (isResizeIndicatorVisible) {
            _resetColumnResize(canResetDataCell: false);
            _rebuild();
          }
        }
      } else {
        // To disable resizing indicator when taping the data row after enabled
        // the indicator by long press.
        if (isResizeIndicatorVisible) {
          _resetColumnResize();
          _rebuild();
        }
      }
    }
  }

  /// Handles the pointer move event for the column resizing.
  void onPointerMove(PointerMoveEvent event, DataRowBase dataRow) {
    if (_isHeaderRow(dataRow)) {
      final DataGridConfiguration dataGridConfiguration =
          dataGridStateDetails();
      // To restricts the update of column width without calling the pointer up
      // event after activating the indicator by long press start.
      if (!dataGridConfiguration.isDesktop && _isLongPressEnabled) {
        return;
      }

      if (_resizingLine != null && isResizeIndicatorVisible) {
        final ScrollController scrollController =
            dataGridConfiguration.horizontalScrollController!;
        final bool isLTR =
            dataGridConfiguration.textDirection == TextDirection.ltr;
        final double currentColumnWidth = _resizingColumnWidth;

        // Updates the column width based on drag delta.
        _resizingColumnWidth +=
            isLTR ? event.localDelta.dx : -event.localDelta.dx;

        // To restricts the width of current resizing column from its minimum and
        // maximum width.
        _resizingColumnWidth = dataGridConfiguration.columnSizer
            ._checkWidthConstraints(_currentResizingColumn!,
                _resizingColumnWidth, currentColumnWidth);

        // To avoid resizing of column width after reached zero;
        _resizingColumnWidth = max(0.0, _resizingColumnWidth);

        final double indicatorPosition = _getIndicatorPosition(
            _resizingLine!, isLTR,
            scrollController: scrollController,
            currentColumnWidth: _resizingColumnWidth);

        _onResizing(_resizingColumnWidth, indicatorPosition);
      }
    }
  }

  /// Handles the pointer up event for the column resizing.
  void onPointerUp(PointerUpEvent event, DataRowBase dataRow) {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    if (!dataGridConfiguration.isDesktop && _isLongPressEnabled) {
      _canStartResizeInMobile = true;
      _isLongPressEnabled = false;
    }

    if (!_canStartResizeInMobile && isResizeIndicatorVisible) {
      if (dataGridConfiguration.columnResizeMode ==
          ColumnResizeMode.onResizeEnd) {
        _raiseColumnResizeUpdate(_resizingColumnWidth);
      }

      _raiseColumnResizeEnd(_resizingColumnWidth);
      _resetColumnResize();
      _rebuild();
    }
  }

  /// Handles the pointer enter event for the column resizing.
  void onPointerEnter(PointerEnterEvent event, DataRowBase dataRow) {
    _ensureCursorVisibility(event.localPosition, dataRow);
  }

  /// Handles the pointer hover event for the column resizing.
  void onPointerHover(PointerHoverEvent event, DataRowBase dataRow) {
    _ensureCursorVisibility(event.localPosition, dataRow);
  }

  /// Handles the pointer exit event for the column resizing.
  void onPointerExit(PointerExitEvent event, DataRowBase dataRow) {
    _ensureCursorVisibility(event.localPosition, dataRow);
  }

  /// Activates the column resizing in mobile platform by long press.
  void onLongPressStart(LongPressStartDetails details, DataRowBase dataRow) {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    if (dataGridConfiguration.allowColumnsResizing &&
        !dataGridConfiguration.isDesktop) {
      if (_isHeaderRow(dataRow)) {
        final VisibleLineInfo? resizingLine = _getHitTestResult(
            details.localPosition.dx,
            isPressed: true,
            canAllowBuffer: false);

        if (resizingLine != null && isResizeIndicatorVisible) {
          _isLongPressEnabled = true;
          // Rebuild to enable the resizing indicator.
          _rebuild();
        }
      }
    }
  }

  void _ensureCursorVisibility(Offset localPosition, DataRowBase dataRow) {
    // To skip updating the cursor visibility when a column is resizing.
    if (isResizing) {
      return;
    }

    if (!_isHeaderRow(dataRow)) {
      canSwitchResizeColumnCursor = false;
      return;
    }

    canSwitchResizeColumnCursor = _getHitTestResult(localPosition.dx) != null;
  }

  void _resetColumnResize({bool canResetDataCell = true}) {
    if (canResetDataCell) {
      resizingDataCell = null;
    }
    isResizing = false;
    _resizingLine = null;
    _currentResizingColumn = null;
    isResizeIndicatorVisible = false;
  }

  void _rebuild() {
    dataGridStateDetails().container.isDirty = true;
    notifyDataGridPropertyChangeListeners(dataGridStateDetails().source,
        propertyName: 'columnResizing');
  }
}

/// Controls how the filtering should be applied in [SfDataGrid].
@immutable
class FilterCondition {
  /// Creates the [FilterCondition] for [SfDataGrid].
  const FilterCondition(
      {required this.type,
      required this.value,
      this.isCaseSensitive = false,
      this.filterOperator = FilterOperator.or,
      this.filterBehavior = FilterBehavior.strongDataType});

  /// The type of the filter should be applied for filter condition.
  final FilterType type;

  /// The value which should be compared for filtering.
  final Object? value;

  /// Decides whether the filtering should be considered based on case sensitive.
  final bool isCaseSensitive;

  /// The type of the logical operator.
  final FilterOperator filterOperator;

  /// The behavior of the filtering for the filter condition.
  final FilterBehavior filterBehavior;

  @override
  bool operator ==(Object other) {
    return other is FilterCondition &&
        type == other.type &&
        value == other.value &&
        isCaseSensitive == other.isCaseSensitive &&
        filterOperator == other.filterOperator &&
        filterBehavior == other.filterBehavior;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      type,
      value,
      isCaseSensitive,
      filterOperator,
      filterBehavior
    ];
    return Object.hashAll(values);
  }
}

/// Provides the base functionalities to process the filtering in [SfDataGrid].
class DataGridFilterHelper {
  /// Creates the [DataGridFilterHelper] for [SfDataGrid].
  DataGridFilterHelper(this._dataGridStateDetails) {
    checkboxFilterHelper = DataGridCheckboxFilterHelper();
    advancedFilterHelper = DataGridAdvancedFilterHelper(_dataGridStateDetails);
  }

  /// Checks whether the column is already filtered and needs to use the
  /// previous source without current filter conditions or not.
  bool canUsePreviousSource = false;

  /// Checks whether the UI view filtering is applied or not.
  bool isViewFilterAppiled = false;

  /// This flag is used to check whether the filtering popup menu is currently
  /// showing or not in the view.
  bool isFilterPopupMenuShowing = false;

  /// Determines how the filter menu should be opened
  FilteredFrom filterFrom = FilteredFrom.none;

  final DataGridStateDetails _dataGridStateDetails;

  late int _checkedItemsCount, _unCheckedItemsCount;

  /// Holds the instance of a [DataGridCheckboxFilterHelper] class.
  late DataGridCheckboxFilterHelper checkboxFilterHelper;

  /// Holds the instance of a [DataGridAdvancedFilterHelper] class.
  late DataGridAdvancedFilterHelper advancedFilterHelper;

  /// Provides the height of the popup menu tile.
  double get tileHeight => _dataGridStateDetails().isDesktop ? 40.0 : 52.0;

  /// Provides the icon color.
  Color get iconColor =>
      _dataGridStateDetails().colorScheme!.onSurface.withOpacity(0.6);

  /// Provides the disable icon color.
  Color get disableIconColor =>
      _dataGridStateDetails().colorScheme!.onSurface.withOpacity(0.38);

  /// Provides the broder color.
  Color get borderColor =>
      _dataGridStateDetails().colorScheme!.onSurface.withOpacity(0.12);

  /// Provides the background color.
  Color get backgroundColor =>
      _dataGridStateDetails().colorScheme!.onSurface.withOpacity(0.001);

  /// Provides the text color.
  Color get textColor =>
      _dataGridStateDetails().colorScheme!.onSurface.withOpacity(0.89);

  /// Provides the primary color.
  Color get primaryColor => _dataGridStateDetails().colorScheme!.primary;

  /// Provides the text style to the tiles.
  TextStyle get textStyle => TextStyle(
      fontSize: 14.0,
      color: textColor,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.normal);

  /// Provides the text style to the disabled tiles.
  TextStyle get disableTextStyle => TextStyle(
      fontSize: 14.0,
      color: disableIconColor,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.normal);

  /// Apply filter to the effective rows based on `filterConditions`.
  void applyFilter() {
    if (_dataGridStateDetails().source.filterConditions.isNotEmpty) {
      if (isViewFilterAppiled) {
        _refreshViewFilter();
      } else {
        _refreshFilter();
      }
    }
  }

  /// Creates filter conditions based on the UI filtering.
  void createFilterConditions(bool isCheckboxFilter, GridColumn column) {
    // Creates filter conditions if it's a checkbox filter.
    if (isCheckboxFilter) {
      _checkedItemsCount = checkboxFilterHelper.items
          .where((FilterElement element) => element.isSelected)
          .length;
      _unCheckedItemsCount =
          checkboxFilterHelper.items.length - _checkedItemsCount;

      _createCheckboxFilterConditions(column);
    } else {
      _createAdvancedFilterConditions(column);
    }
  }

  /// Applies filtering based on the filter conditions in orders.
  void _refreshViewFilter() {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    final Map<String, List<FilterCondition>> filterConditions =
        dataGridConfiguration.source.filterConditions;

    if (filterConditions.isNotEmpty) {
      for (final String columnName in filterConditions.keys) {
        final Map<String, List<FilterCondition>> currentFilterCondition =
            <String, List<FilterCondition>>{
          columnName: filterConditions[columnName]!
        };

        final List<DataGridRow> filteredRows = _getFilterRows(
            dataGridConfiguration.source.effectiveRows, currentFilterCondition);

        refreshEffectiveRows(dataGridConfiguration.source, filteredRows);
      }
    }
  }

  void _createCheckboxFilterConditions(GridColumn column) {
    final DataGridSource source = _dataGridStateDetails().source;
    if (_unCheckedItemsCount == 0 &&
        checkboxFilterHelper._searchedItems.isEmpty) {
      if (source.filterConditions.isNotEmpty) {
        removeFilterConditions(source, column.columnName);
      }
    } else {
      final bool useSelected = !(_checkedItemsCount > _unCheckedItemsCount &&
          _unCheckedItemsCount > 0);
      final List<FilterCondition> conditions = checkboxFilterHelper.items
          .where((FilterElement element) => element.isSelected == useSelected)
          .map<FilterCondition>((FilterElement value) {
        final FilterType filterType =
            useSelected ? FilterType.equals : FilterType.notEqual;
        final FilterOperator filterOperator =
            useSelected ? FilterOperator.or : FilterOperator.and;
        final String? filterValue =
            value.value == '(Blanks)' ? null : value.value.toString();

        return FilterCondition(
            type: filterType,
            isCaseSensitive: true,
            value: filterValue,
            filterBehavior: FilterBehavior.stringDataType,
            filterOperator: filterOperator);
      }).toList();

      addFilterConditions(source, column.columnName, conditions);
    }

    if (source.filterConditions.isEmpty) {
      isViewFilterAppiled = false;
      setFilterFrom(column, FilteredFrom.none);
    } else {
      setFilterFrom(column, FilteredFrom.checkboxFilter);
    }

    if (checkboxFilterHelper._searchedItems.isNotEmpty) {
      checkboxFilterHelper._searchedItems.clear();
    }

    _applyViewFilter(column);
  }

  /// Sets the given value to the column's `filterFrom` property.
  void setFilterFrom(GridColumn column, FilteredFrom filteredfrom) {
    filterFrom = column._filterFrom = filteredfrom;
  }

  /// Gets the column's `filterFrom` property.
  FilteredFrom getFilterForm(GridColumn column) {
    return column._filterFrom;
  }

  /// Format the given cell value to the string data type to display.
  String getDisplayValue(Object? value) {
    if (value != null) {
      switch (advancedFilterHelper.advancedFilterType) {
        case AdvancedFilterType.text:
        case AdvancedFilterType.numeric:
          return value is! String ? value.toString() : value;
        case AdvancedFilterType.date:
          final DateTime date = value as DateTime;
          return date.toString().split(' ').first;
      }
    }
    return '';
  }

  /// Format the given string value to the actual cell value with same data type.
  Object? getActualValue(Object? value) {
    if (value != null) {
      switch (advancedFilterHelper.advancedFilterType) {
        case AdvancedFilterType.text:
          return value is! String ? value.toString() : value;
        case AdvancedFilterType.numeric:
          return value is! num ? num.tryParse(value.toString()) : value;
        case AdvancedFilterType.date:
          if (value is! DateTime) {
            // To convert a given string to the DateTime format.
            final List<String> values = value.toString().split('-');
            if (values.length > 2 &&
                values.every((String element) => element.isNotEmpty)) {
              // To validate the day and month.
              if (int.parse(values[1]) > 12 || int.parse(values[2]) > 31) {
                return null;
              }
              return DateTime.tryParse(value.toString());
            }
            return null;
          }
          return value;
      }
    } else {
      return value;
    }
  }

  void _debugCheckDataType(DataGridConfiguration dataGridConfiguration) {
    Object? getFirstCellValue(List<DataGridRow> rows, String columnName) {
      Object? cellValue;
      for (final DataGridRow row in rows) {
        cellValue = _getCellValue(row, columnName);
        if (cellValue != null) {
          break;
        }
      }
      return cellValue;
    }

    void throwAssertFailure(String message) {
      throw FlutterError.fromParts(<DiagnosticsNode>[ErrorSummary(message)]);
    }

    final DataGridSource source = dataGridConfiguration.source;
    if (source.filterConditions.isNotEmpty) {
      for (final String columnName in source.filterConditions.keys) {
        final GridColumn? column = dataGridConfiguration.columns
            .firstWhereOrNull(
                (GridColumn column) => column.columnName == columnName);
        if (column == null) {
          throwAssertFailure(
              "The $columnName doesn't exist in the SfDataGrid.columns collection");
          continue;
        }

        final Object? cellValue =
            getFirstCellValue(source.effectiveRows, columnName);
        for (final FilterCondition condition
            in source.filterConditions[columnName]!) {
          assert(() {
            if (condition.filterBehavior == FilterBehavior.strongDataType) {
              if (cellValue?.runtimeType != condition.value?.runtimeType) {
                throwAssertFailure(
                    '${condition.value?.runtimeType} and ${cellValue.runtimeType} are not the same data type');
              } else if (condition.type == FilterType.contains ||
                  condition.type == FilterType.doesNotContain ||
                  condition.type == FilterType.beginsWith ||
                  condition.type == FilterType.doesNotBeginWith ||
                  condition.type == FilterType.endsWith ||
                  condition.type == FilterType.doesNotEndsWith) {
                throwAssertFailure(
                    'FilterBehaviour and FilterType are not correct');
              } else if (condition.type == FilterType.greaterThan ||
                  condition.type == FilterType.greaterThanOrEqual ||
                  condition.type == FilterType.lessThan ||
                  condition.type == FilterType.lessThanOrEqual) {
                if (cellValue is String) {
                  final String filterType =
                      condition.type.toString().split('.').last;
                  throwAssertFailure(
                      "The filter type $filterType can't check with the String type");
                }
              }
            } else {
              if (condition.type == FilterType.greaterThan ||
                  condition.type == FilterType.greaterThanOrEqual ||
                  condition.type == FilterType.lessThan ||
                  condition.type == FilterType.lessThanOrEqual) {
                throwAssertFailure(
                    'FilterBehaviour and FilterType are not correct');
              }
            }
            return true;
          }());
        }
      }
    }
  }

  void _refreshFilter() {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    // Checks whether the filter value and cell value have the same data type or not.
    // If not, it throws an assert failure.
    _debugCheckDataType(dataGridConfiguration);

    if (dataGridConfiguration.source.filterConditions.isNotEmpty) {
      final List<DataGridRow> rows = dataGridConfiguration.source.effectiveRows;
      final List<DataGridRow> filteredRows =
          _getFilterRows(rows, dataGridConfiguration.source.filterConditions);
      refreshEffectiveRows(dataGridConfiguration.source, filteredRows);
    }
  }

  void _applyViewFilter(GridColumn column) {
    final DataGridSource source = _dataGridStateDetails().source;

    if (source.filterConditions.containsKey(column.columnName)) {
      if (!_invokeFilterChangingCallback(
          column, source.filterConditions[column.columnName]!)) {
        removeFilterConditions(source, column.columnName);
        if (source.filterConditions.isEmpty) {
          isViewFilterAppiled = false;
        }
        return;
      }

      final Map<String, List<FilterCondition>> currentFilterCondition =
          <String, List<FilterCondition>>{
        column.columnName: source.filterConditions[column.columnName]!
      };

      final List<DataGridRow> dataGridRows = canUsePreviousSource
          ? _getPreviousFilteredRows(column.columnName)
          : source.effectiveRows;

      final List<DataGridRow> filteredRows =
          _getFilterRows(dataGridRows, currentFilterCondition);

      if (canUsePreviousSource) {
        canUsePreviousSource = false;
      }

      isViewFilterAppiled = true;
      refreshEffectiveRows(source, filteredRows);
      notifyDataGridPropertyChangeListeners(source, propertyName: 'Filtering');
      _invokeFilterChangedCallback(
          column, source.filterConditions[column.columnName]!);
    } else {
      updateDataSource(source);
      notifyDataGridPropertyChangeListeners(source, propertyName: 'Filtering');
    }
  }

  // Gets rows based on current filtered conditions.
  List<DataGridRow> _getPreviousFilteredRows(String columnName) {
    List<DataGridRow>? items;
    final DataGridSource source = _dataGridStateDetails().source;
    final List<FilterCondition>? conditions =
        source.filterConditions[columnName];

    if (conditions != null && conditions.isNotEmpty) {
      if (conditions == source.filterConditions.values.last) {
        removeFilterConditions(source, columnName);
        items = source.filterConditions.isEmpty
            ? source.rows
            : _getFilterRows(source.rows, source.filterConditions);
        canUsePreviousSource = true;
        addFilterConditions(source, columnName, conditions);
      }
    }

    return items ?? source.effectiveRows;
  }

  List<FilterElement> _getCellValues(
      GridColumn column, List<DataGridRow> items) {
    bool hasBlankValues = false;
    bool isSelected(Object? value) {
      final List<FilterCondition>? currentConditions =
          _dataGridStateDetails().source.filterConditions[column.columnName];
      if (currentConditions != null && currentConditions.isNotEmpty) {
        final bool isEquals = currentConditions.first.type == FilterType.equals;
        final FilterCondition? condition = currentConditions.firstWhereOrNull(
            (FilterCondition element) =>
                element.value?.toString() == value?.toString());
        return isEquals ? condition != null : condition == null;
      }
      return true;
    }

    final List<Object> cellValues = <Object>[];
    final List<FilterElement> filterElements = <FilterElement>[];
    for (final DataGridRow row in items) {
      final DataGridCell? cell = row.getCells().firstWhereOrNull(
          (DataGridCell element) => element.columnName == column.columnName);
      if (cell != null) {
        if (cell.value != null) {
          cellValues.add(cell.value);
        } else if (!hasBlankValues) {
          hasBlankValues = true;
        }
      }
    }

    if (hasBlankValues) {
      filterElements
          .add(FilterElement(value: '(Blanks)', isSelected: isSelected(null)));
    }

    if (cellValues.isNotEmpty) {
      final Object cellValue = cellValues.first;
      final bool convertToString =
          !(cellValue is num || cellValue is DateTime || cellValue is String);

      // Sort the items to display in the ascending order.
      cellValues.sort((Object a, Object b) {
        final dynamic value1 = convertToString ? a.toString() : a;
        final dynamic value2 = convertToString ? b.toString() : b;

        return value1.compareTo(value2);
      });

      filterElements.addAll(cellValues
          .toSet()
          .map<FilterElement>(
              (Object e) => FilterElement(value: e, isSelected: isSelected(e)))
          .toList());
    }

    return filterElements;
  }

  /// Helps to end edit the current cell.
  void endEdit() {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    if (dataGridConfiguration.currentCell.isEditing) {
      dataGridConfiguration.currentCell
          .onCellSubmit(dataGridConfiguration, canRefresh: false);
    }
  }

  /// Sets all the cell values to the check box filter.
  void setDataGridSource(GridColumn column) {
    final List<DataGridRow> items = _getPreviousFilteredRows(column.columnName);
    final List<FilterElement> distinctCollection =
        _getCellValues(column, items);

    checkboxFilterHelper._previousDataGridSource = <FilterElement>[];

    if (distinctCollection.isNotEmpty) {
      checkboxFilterHelper.filterCheckboxItems = distinctCollection;
    }

    if (filterFrom == FilteredFrom.checkboxFilter) {
      _setPreviousDataGridSource();
    }

    checkboxFilterHelper.items = distinctCollection.toList();
    advancedFilterHelper.items = distinctCollection.toList();

    if (advancedFilterHelper.items.isNotEmpty) {
      bool isNullOrEmpty(String value) => value == '(Blanks)' || value == '';
      // Remove null and empty values from the items collection since it's not
      // applicable for the AdvancedFilter.
      advancedFilterHelper.items.removeWhere(
          (FilterElement element) => isNullOrEmpty(element.value.toString()));
    }

    checkboxFilterHelper.ensureSelectAllCheckboxState();
  }

  List<DataGridRow> _getFilterRows(
      List<DataGridRow> rows, Map<String, List<FilterCondition>> conditions) {
    return rows
        .where((DataGridRow row) => _filterRow(row, conditions))
        .toList();
  }

  void _setPreviousDataGridSource() {
    final bool useSelected = !(_checkedItemsCount > _unCheckedItemsCount &&
        _unCheckedItemsCount > 0);
    final List<FilterElement> items = checkboxFilterHelper.filterCheckboxItems
        .where((FilterElement i) => useSelected)
        .toList();
    checkboxFilterHelper._previousDataGridSource.addAll(items);
  }

  /// Handles the filter form's sort buttons callback.
  void onSortButtonClick(GridColumn column, DataGridSortDirection direction) {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    endEdit();
    if (dataGridConfiguration.source.sortedColumns.isNotEmpty) {
      dataGridConfiguration.source.sortedColumns.clear();
    }

    dataGridConfiguration.source.sortedColumns.add(
        SortColumnDetails(name: column.columnName, sortDirection: direction));
    dataGridConfiguration.source.sort();
  }

  /// Handles the filter form's clear filter button callback.
  void onClearFilterButtonClick(GridColumn column) {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    endEdit();
    setFilterFrom(column, FilteredFrom.none);
    removeFilterConditions(dataGridConfiguration.source, column.columnName);

    if (dataGridConfiguration.source.filterConditions.isEmpty) {
      isViewFilterAppiled = false;
    }

    updateDataSource(dataGridConfiguration.source);
    notifyDataGridPropertyChangeListeners(dataGridConfiguration.source,
        propertyName: 'Filtering');
  }

  bool _invokeFilterChangingCallback(
      GridColumn column, List<FilterCondition> filterConditions) {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    if (dataGridConfiguration.onFilterChanging != null) {
      final DataGridFilterChangeDetails details = DataGridFilterChangeDetails(
          column: column,
          filterConditions:
              List<FilterCondition>.unmodifiable(filterConditions));
      return dataGridConfiguration.onFilterChanging!(details);
    }
    return true;
  }

  void _invokeFilterChangedCallback(
      GridColumn column, List<FilterCondition> filterConditions) {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    if (dataGridConfiguration.onFilterChanged != null) {
      final DataGridFilterChangeDetails details = DataGridFilterChangeDetails(
          column: column,
          filterConditions:
              List<FilterCondition>.unmodifiable(filterConditions));
      dataGridConfiguration.onFilterChanged!(details);
    }
  }

  Object? _getCellValue(DataGridRow row, String columnName) {
    final GridColumn? column = _dataGridStateDetails().columns.firstWhereOrNull(
        (GridColumn column) => column.columnName == columnName);
    if (column != null) {
      final DataGridCell? cellValue = row.getCells().firstWhereOrNull(
          (DataGridCell element) => element.columnName == column.columnName);
      if (cellValue != null && cellValue.value != null) {
        return cellValue.value;
      }
    }
    return null;
  }

  bool _filterRow(
      DataGridRow row, Map<String, List<FilterCondition>> filterConditions) {
    bool? isEqual;
    for (final String columnName in filterConditions.keys) {
      for (final FilterCondition condition in filterConditions[columnName]!) {
        final Object? cellValue = _getCellValue(row, columnName);

        /// Holds the current filter type result.
        bool comparerValue = false;
        switch (condition.type) {
          case FilterType.equals:
            comparerValue = grid_helper.compareEquals(condition, cellValue);
            break;
          case FilterType.notEqual:
            comparerValue = !grid_helper.compareEquals(condition, cellValue);
            break;
          case FilterType.contains:
            comparerValue = grid_helper.compareContains(condition, cellValue);
            break;
          case FilterType.doesNotContain:
            comparerValue = !grid_helper.compareContains(condition, cellValue);
            break;
          case FilterType.beginsWith:
            comparerValue = grid_helper.compareBeginsWith(condition, cellValue);
            break;
          case FilterType.doesNotBeginWith:
            comparerValue =
                !grid_helper.compareBeginsWith(condition, cellValue);
            break;
          case FilterType.endsWith:
            comparerValue = grid_helper.compareEndsWith(condition, cellValue);
            break;
          case FilterType.doesNotEndsWith:
            comparerValue = !grid_helper.compareEndsWith(condition, cellValue);
            break;
          case FilterType.greaterThan:
            comparerValue =
                grid_helper.compareGreaterThan(condition, cellValue);
            break;
          case FilterType.greaterThanOrEqual:
            comparerValue =
                grid_helper.compareGreaterThan(condition, cellValue, true);
            break;
          case FilterType.lessThan:
            comparerValue = grid_helper.compareLessThan(condition, cellValue);
            break;
          case FilterType.lessThanOrEqual:
            comparerValue =
                grid_helper.compareLessThan(condition, cellValue, true);
            break;
        }
        isEqual = grid_helper.compare(
            isEqual, comparerValue, condition.filterOperator);
      }
    }
    return isEqual != null && isEqual;
  }

  void _createAdvancedFilterConditions(GridColumn column) {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    final SfLocalizations localizations = dataGridConfiguration.localizations;
    final FilterOperator filterOperator = advancedFilterHelper.isOrPredicate
        ? FilterOperator.or
        : FilterOperator.and;

    final List<FilterCondition> filterConditions =
        dataGridConfiguration.source.filterConditions[column.columnName] ??
            <FilterCondition>[];

    final Object? filterValue1 = advancedFilterHelper.filterValue1;
    final Object? filterValue2 = advancedFilterHelper.filterValue2;
    final String? filterType1 = advancedFilterHelper.filterType1;
    final String? filterType2 = advancedFilterHelper.filterType2;
    final FilterType type1 =
        grid_helper.getFilterType(dataGridConfiguration, filterType1 ?? '');
    final FilterType type2 =
        grid_helper.getFilterType(dataGridConfiguration, filterType2 ?? '');

    if (filterConditions.isNotEmpty) {
      filterConditions.clear();
    }

    bool canCreateFilterCondition(
        Object? filterValue, String? filterType, bool isFirstCondition) {
      void setFilterValue(String? value) {
        if (isFirstCondition) {
          advancedFilterHelper.filterValue1 = value;
        } else {
          advancedFilterHelper.filterValue2 = value;
        }
      }

      if (filterValue != null && filterType != null) {
        if (filterValue == '') {
          setFilterValue(null);
        }
        return true;
      } else if (filterValue == null && filterType != null) {
        if (filterType == localizations.nullDataGridFilteringLabel ||
            filterType == localizations.notNullDataGridFilteringLabel) {
          setFilterValue(null);
          return true;
        } else if (filterType == localizations.emptyDataGridFilteringLabel ||
            filterType == localizations.notEmptyDataGridFilteringLabel) {
          setFilterValue('');
          return true;
        }
      }
      return false;
    }

    switch (advancedFilterHelper.advancedFilterType) {
      case AdvancedFilterType.text:
        {
          // Condition 1
          if (canCreateFilterCondition(filterValue1, filterType1, true)) {
            final FilterCondition condition = FilterCondition(
                type: type1,
                filterOperator: filterOperator,
                value: advancedFilterHelper.filterValue1,
                filterBehavior: FilterBehavior.stringDataType,
                isCaseSensitive: advancedFilterHelper.isCaseSensitive1);
            filterConditions.add(condition);
          }

          // Condition 2
          if (canCreateFilterCondition(filterValue2, filterType2, false)) {
            final FilterCondition condition = FilterCondition(
                type: type2,
                filterOperator: filterOperator,
                value: advancedFilterHelper.filterValue2,
                filterBehavior: FilterBehavior.stringDataType,
                isCaseSensitive: advancedFilterHelper.isCaseSensitive2);
            filterConditions.add(condition);
          }
        }
        break;
      case AdvancedFilterType.numeric:
        {
          // Condition 1
          if (canCreateFilterCondition(filterValue1, filterType1, true)) {
            final FilterCondition condition = FilterCondition(
                type: type1,
                filterOperator: filterOperator,
                value: advancedFilterHelper.filterValue1);
            filterConditions.add(condition);
          }

          // Condition 2
          if (canCreateFilterCondition(filterValue2, filterType2, false)) {
            final FilterCondition condition = FilterCondition(
                type: type2,
                filterOperator: filterOperator,
                value: advancedFilterHelper.filterValue2);
            filterConditions.add(condition);
          }
        }
        break;
      case AdvancedFilterType.date:
        {
          // Condition 1
          if (canCreateFilterCondition(filterValue1, filterType1, true)) {
            final FilterCondition condition = FilterCondition(
                type: type1,
                filterOperator: filterOperator,
                value: advancedFilterHelper.filterValue1);
            filterConditions.add(condition);
          }

          // Condition 2
          if (canCreateFilterCondition(filterValue2, filterType2, false)) {
            final FilterCondition condition = FilterCondition(
                type: type2,
                filterOperator: filterOperator,
                value: advancedFilterHelper.filterValue2);
            filterConditions.add(condition);
          }
        }
        break;
    }

    if (filterConditions.isNotEmpty) {
      setFilterFrom(column, FilteredFrom.advancedFilter);
      addFilterConditions(
          dataGridConfiguration.source, column.columnName, filterConditions);
      _applyViewFilter(column);
    }
  }
}

/// A class [DataGridCheckboxFilterHelper] that holds the helper properties
/// for the checkbox filter.
class DataGridCheckboxFilterHelper {
  /// Holds all the cell values of corresponding filter column as a
  /// `FilterElement` collection.
  List<FilterElement> items = <FilterElement>[];

  /// Holds the searched check box items.
  List<FilterElement> _searchedItems = <FilterElement>[];

  /// Holds the check box filter items.
  List<FilterElement> filterCheckboxItems = <FilterElement>[];

  /// Maintain the previous item source for using it when searched text field
  /// is empty.
  List<FilterElement> _previousDataGridSource = <FilterElement>[];

  /// A `TextEditingController` of the search box.
  final TextEditingController textController = TextEditingController();

  /// A `FocusNode` of the search box.
  final FocusNode searchboxFocusNode = FocusNode();

  /// Checks whether the selectAll checkbox is checked or not.
  late bool? isSelectAllChecked;

  /// Checks whether the selectAll checkbox is in tri-state or not.
  late bool isSelectAllInTriState;

  /// Ensures the `selectAll` checkbox state.
  void ensureSelectAllCheckboxState() {
    final List<FilterElement> unCheckedItems =
        items.where((FilterElement item) => !item.isSelected).toList();

    if (unCheckedItems.isEmpty || unCheckedItems.length == items.length) {
      isSelectAllInTriState = false;
      isSelectAllChecked = unCheckedItems.isEmpty;
    } else {
      isSelectAllInTriState = true;
      isSelectAllChecked = null;
    }
  }

  /// Handles the search box's text changed callback.
  void onSearchTextFieldTextChanged(String searchText) {
    if (filterCheckboxItems.isEmpty) {
      return;
    }

    if (searchText.isEmpty) {
      _searchedItems = <FilterElement>[];
      if (_previousDataGridSource.isNotEmpty) {
        final int checkedCount = _previousDataGridSource
            .where((FilterElement element) => element.isSelected)
            .length;
        final bool isSelected = checkedCount > 0;
        for (final FilterElement item in filterCheckboxItems) {
          final FilterElement? filterElement = _previousDataGridSource
              .firstWhereOrNull((FilterElement i) => item.value == i.value);
          item.isSelected =
              filterElement != null ? filterElement.isSelected : !isSelected;
        }
      }
      items = filterCheckboxItems;
      ensureSelectAllCheckboxState();
      return;
    }

    _searchedItems = filterCheckboxItems
        .where((FilterElement element) => element.value
            .toString()
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();

    for (final FilterElement element in _searchedItems) {
      element.isSelected = true;
    }

    items = _searchedItems;
    ensureSelectAllCheckboxState();
  }
}

/// A class [DataGridAdvancedFilterHelper] that holds the helper properties
/// for the advance filter.
class DataGridAdvancedFilterHelper {
  /// Creates `DataGridAdvanceFilterHelper` for `SfDataGrid`.
  DataGridAdvancedFilterHelper(this._dataGridStateDetails);

  final DataGridStateDetails _dataGridStateDetails;

  /// Holds the filter type dropdown items.
  List<String> filterTypeItems = <String>[];

  /// Holds all the cell values of a corresponding filter column as a
  /// `FilterElement` collection.
  List<FilterElement> items = <FilterElement>[];

  /// Defines the advance filter type.
  AdvancedFilterType advancedFilterType = AdvancedFilterType.text;

  /// Defines the filter types.
  String? filterType1, filterType2;

  /// Defines the filter values
  Object? filterValue1, filterValue2;

  /// Defines the first drop down button's case sensitive option.
  bool isCaseSensitive1 = false;

  /// Defines the second  drop down button's case sensitive option.
  bool isCaseSensitive2 = false;

  /// Checkes whether the `OR` radio button is enabled or not.
  bool isOrPredicate = true;

  /// Holds the list of filter types that used to disable filter value's drop
  /// down button. If a filterType contains any of these item, need to disable
  /// the filter value dropdown button.
  List<String> disableFilterTypes = <String>[];

  /// Holds the list of filter types that used to display the text field instead
  /// of dropdown button in the Advanced filter menu.
  List<String> textFieldFilterTypes = <String>[];

  /// A [TextEditingController] for the first text field in the Advanced filter.
  TextEditingController firstValueTextController = TextEditingController();

  /// A [TextEditingController] for the second text field in the Advanced filter.
  TextEditingController secondValueTextController = TextEditingController();

  /// Initializes the localized resource values to the localization required
  /// internal properties.
  void initProperties() {
    final SfLocalizations localizations = _dataGridStateDetails().localizations;
    filterType1 = localizations.equalsDataGridFilteringLabel;
    filterType2 = localizations.equalsDataGridFilteringLabel;

    disableFilterTypes = <String>[
      localizations.nullDataGridFilteringLabel,
      localizations.notNullDataGridFilteringLabel,
      localizations.emptyDataGridFilteringLabel,
      localizations.notEmptyDataGridFilteringLabel
    ];

    textFieldFilterTypes = <String>[
      localizations.beginsWithDataGridFilteringLabel,
      localizations.endsWithDataGridFilteringLabel,
      localizations.doesNotBeginWithDataGridFilteringLabel,
      localizations.doesNotEndWithDataGridFilteringLabel,
      localizations.containsDataGridFilteringLabel,
      localizations.doesNotContainDataGridFilteringLabel,
      localizations.beforeDataGridFilteringLabel,
      localizations.beforeOrEqualDataGridFilteringLabel,
      localizations.afterDataGridFilteringLabel,
      localizations.afterOrEqualDataGridFilteringLabel,
      localizations.lessThanDataGridFilteringLabel,
      localizations.lessThanOrEqualDataGridFilteringLabel,
      localizations.greaterThanDataGridFilteringLabel,
      localizations.greaterThanOrEqualDataGridFilteringLabel,
    ];
  }

  /// Generates the filter type dropdown items.
  void generateFilterTypeItems(GridColumn column) {
    if (filterTypeItems.isNotEmpty) {
      filterTypeItems.clear();
    }

    final List<String> items = <String>[];
    final SfLocalizations localizations = _dataGridStateDetails().localizations;
    switch (advancedFilterType) {
      case AdvancedFilterType.text:
        items.add(localizations.equalsDataGridFilteringLabel);
        items.add(localizations.doesNotEqualDataGridFilteringLabel);
        items.add(localizations.beginsWithDataGridFilteringLabel);
        items.add(localizations.doesNotBeginWithDataGridFilteringLabel);
        items.add(localizations.endsWithDataGridFilteringLabel);
        items.add(localizations.doesNotEndWithDataGridFilteringLabel);
        items.add(localizations.containsDataGridFilteringLabel);
        items.add(localizations.doesNotContainDataGridFilteringLabel);
        items.add(localizations.emptyDataGridFilteringLabel);
        items.add(localizations.notEmptyDataGridFilteringLabel);
        items.add(localizations.nullDataGridFilteringLabel);
        items.add(localizations.notNullDataGridFilteringLabel);
        break;
      case AdvancedFilterType.numeric:
        items.add(localizations.equalsDataGridFilteringLabel);
        items.add(localizations.doesNotEqualDataGridFilteringLabel);
        items.add(localizations.lessThanDataGridFilteringLabel);
        items.add(localizations.lessThanOrEqualDataGridFilteringLabel);
        items.add(localizations.greaterThanDataGridFilteringLabel);
        items.add(localizations.greaterThanOrEqualDataGridFilteringLabel);
        items.add(localizations.nullDataGridFilteringLabel);
        items.add(localizations.notNullDataGridFilteringLabel);
        break;
      case AdvancedFilterType.date:
        items.add(localizations.equalsDataGridFilteringLabel);
        items.add(localizations.doesNotEqualDataGridFilteringLabel);
        items.add(localizations.beforeDataGridFilteringLabel);
        items.add(localizations.beforeOrEqualDataGridFilteringLabel);
        items.add(localizations.afterDataGridFilteringLabel);
        items.add(localizations.afterOrEqualDataGridFilteringLabel);
        items.add(localizations.nullDataGridFilteringLabel);
        items.add(localizations.notNullDataGridFilteringLabel);
        break;
    }

    filterTypeItems = items;
  }

  /// Sets the advanced filter type based on the column type.
  void setAdvancedFilterType(
      DataGridConfiguration dataGridConfiguration, GridColumn column) {
    Object? value;
    for (final DataGridRow row in dataGridConfiguration.source.rows) {
      final DataGridCell? cellValue = row.getCells().firstWhereOrNull(
          (DataGridCell element) => element.columnName == column.columnName);
      if (cellValue != null && cellValue.value != null) {
        value = cellValue.value;
        break;
      }
    }

    if (value != null && value is num) {
      advancedFilterType = AdvancedFilterType.numeric;
    } else if (value != null && value is DateTime) {
      advancedFilterType = AdvancedFilterType.date;
    } else {
      advancedFilterType = AdvancedFilterType.text;
    }
  }

  /// Sets the advanced filter values.
  void setAdvancedFilterValues(DataGridConfiguration dataGridConfiguration,
      List<FilterCondition> filterConditions, DataGridFilterHelper helper) {
    Object? getValue(Object? value, String? filterType) {
      if (items.any((FilterElement element) => element.value == value) ||
          (filterType != null && textFieldFilterTypes.contains(filterType))) {
        return value;
      }
      return null;
    }

    if (filterConditions.isNotEmpty) {
      final FilterCondition condition = filterConditions.first;
      filterType1 = grid_helper.getFilterName(
          dataGridConfiguration, condition.type, condition.value);
      filterValue1 = getValue(condition.value, filterType1);
      isCaseSensitive1 = condition.isCaseSensitive;
      isOrPredicate = condition.filterOperator == FilterOperator.or;
      if (filterConditions.length == 1) {
        filterType2 =
            dataGridConfiguration.localizations.equalsDataGridFilteringLabel;
        filterValue2 = null;
        isCaseSensitive2 = false;
      }
    }
    if (filterConditions.length == 2) {
      final FilterCondition condition = filterConditions.last;
      filterType2 = grid_helper.getFilterName(
          dataGridConfiguration, condition.type, condition.value);
      filterValue2 = getValue(condition.value, filterType2);
      isCaseSensitive2 = condition.isCaseSensitive;
      isOrPredicate = condition.filterOperator == FilterOperator.or;
    }

    firstValueTextController.text = dataGridConfiguration.dataGridFilterHelper
        .getDisplayValue(filterValue1);
    secondValueTextController.text = dataGridConfiguration.dataGridFilterHelper
        .getDisplayValue(filterValue2);
  }

  /// Resets the advanced filter values.
  void resetAdvancedFiterValues(DataGridConfiguration dataGridConfiguration) {
    filterType1 = filterType2 =
        dataGridConfiguration.localizations.equalsDataGridFilteringLabel;
    filterValue1 = filterValue2 = null;
    isCaseSensitive1 = isCaseSensitive2 = false;
    isOrPredicate = true;
    firstValueTextController.clear();
    secondValueTextController.clear();
  }
}

/// A class [FilterElement] that helps to maintain the cell values with its
/// checkbox state for the filtering support.
class FilterElement {
  /// Creates [FilterElement] for the `SfDataGrid`.
  FilterElement({required this.value, required this.isSelected});

  /// Defines the value of the cell.
  Object value;

  /// Defines the check box state of the cell.
  bool isSelected;
}
