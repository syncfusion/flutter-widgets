part of datagrid;

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

  GridColumn? _autoFillColumn;
  bool _isColumnSizerLoadedInitially = false;

  static const double _sortIconWidth = 20.0;
  static const double _sortNumberWidth = 18.0;

  late _DataGridStateDetails _dataGridStateDetails;

  void _initialRefresh(double availableWidth) {
    final _LineSizeCollection lineSizeCollection =
        _dataGridStateDetails().container.columnWidths as _LineSizeCollection;
    lineSizeCollection.suspendUpdates();
    _refresh(availableWidth);
    lineSizeCollection.resumeUpdates();
  }

  void _refresh(double availableWidth) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    final bool hasAnySizerColumn = dataGridSettings.columns.any(
        (GridColumn column) =>
            (column.columnWidthMode != ColumnWidthMode.none) ||
            (column.width != double.nan) ||
            !column.visible);

    final _PaddedEditableLineSizeHostBase paddedEditableLineSizeHostBase =
        dataGridSettings.container.columnWidths;
    final _LineSizeCollection? lineSizeCollection =
        paddedEditableLineSizeHostBase is _LineSizeCollection
            ? paddedEditableLineSizeHostBase
            : null;

    if (lineSizeCollection == null) {
      return;
    }

    lineSizeCollection.suspendUpdates();
    _ensureColumnVisibility(dataGridSettings);

    if (dataGridSettings.columnWidthMode != ColumnWidthMode.none ||
        hasAnySizerColumn) {
      _sizerColumnWidth(dataGridSettings, availableWidth);
    }
    dataGridSettings.container.updateScrollBars();
    lineSizeCollection.resumeUpdates();
  }

  void _ensureColumnVisibility(_DataGridSettings dataGridSettings) {
    for (final GridColumn column in dataGridSettings.columns) {
      final int index = dataGridSettings.columns.indexOf(column);
      dataGridSettings.container.columnWidths
          .setHidden(index, index, !column.visible);
    }
    // Columns will be auto sized only if Columns doesn't have explicit width
    // defined.
    _sizerColumnWidth(dataGridSettings, 0.0);
  }

  void _sizerColumnWidth(
      _DataGridSettings dataGridSettings, double viewPortWidth) {
    double totalColumnSize = 0.0;
    final List<GridColumn> calculatedColumns = <GridColumn>[];

    _autoFillColumn = _getColumnToFill(dataGridSettings);

    // Hide Hidden columns
    final List<GridColumn> hiddenColumns = dataGridSettings.columns
        .where((GridColumn column) => !column.visible)
        .toList();
    for (final GridColumn column in hiddenColumns) {
      final int index = _GridIndexResolver.resolveToScrollColumnIndex(
          dataGridSettings, dataGridSettings.columns.indexOf(column));
      dataGridSettings.container.columnWidths.setHidden(index, index, true);
      calculatedColumns.add(column);
    }

    // Set width based on Column.Width
    final List<GridColumn> widthColumns = dataGridSettings.columns
        .skipWhile((GridColumn column) => !column.visible)
        .where((GridColumn column) => !(column.width).isNaN)
        .toList();
    for (final GridColumn column in widthColumns) {
      totalColumnSize +=
          _setColumnWidth(dataGridSettings, column, column.width);
      calculatedColumns.add(column);
    }

    // Set width based on fitByCellValue mode
    final List<GridColumn> fitByCellValueColumns = dataGridSettings.columns
        .skipWhile((GridColumn column) => !column.visible)
        .where((GridColumn column) =>
            column.columnWidthMode == ColumnWidthMode.fitByCellValue &&
            column.width.isNaN)
        .toList();
    for (final GridColumn column in fitByCellValueColumns) {
      if (column._autoWidth.isNaN) {
        final double columnWidth = _getWidthBasedOnColumn(
            dataGridSettings, column, ColumnWidthMode.fitByCellValue);
        totalColumnSize += columnWidth;
        _setAutoWidth(column, columnWidth);
      } else {
        totalColumnSize +=
            _setColumnWidth(dataGridSettings, column, column._autoWidth);
      }
      calculatedColumns.add(column);
    }

    // Set width based on fitByColumnName mode
    final List<GridColumn> fitByColumnNameColumns = dataGridSettings.columns
        .skipWhile((GridColumn column) => !column.visible)
        .where((GridColumn column) =>
            column.columnWidthMode == ColumnWidthMode.fitByColumnName &&
            column.width.isNaN)
        .toList();
    for (final GridColumn column in fitByColumnNameColumns) {
      totalColumnSize += _getWidthBasedOnColumn(
          dataGridSettings, column, ColumnWidthMode.fitByColumnName);
      calculatedColumns.add(column);
    }

    // Set width based on auto and lastColumnFill
    List<GridColumn> autoColumns = dataGridSettings.columns
        .where((GridColumn column) =>
            column.columnWidthMode == ColumnWidthMode.auto &&
            column.visible &&
            column.width.isNaN)
        .toList();

    final List<GridColumn> lastColumnFill = dataGridSettings.columns
        .skipWhile((GridColumn column) => calculatedColumns.contains(column))
        .where((GridColumn col) =>
            col.columnWidthMode == ColumnWidthMode.lastColumnFill &&
            !_isLastFillColum(col))
        .toList();

    autoColumns = (autoColumns + lastColumnFill).toSet().toList();

    for (final GridColumn column in autoColumns) {
      if (column._autoWidth.isNaN) {
        final double columnWidth = _getWidthBasedOnColumn(
            dataGridSettings, column, ColumnWidthMode.auto);
        totalColumnSize += columnWidth;
        _setAutoWidth(column, columnWidth);
      } else {
        totalColumnSize +=
            _setColumnWidth(dataGridSettings, column, column._autoWidth);
      }
      calculatedColumns.add(column);
    }
    _setWidthBasedOnGrid(
        dataGridSettings, totalColumnSize, calculatedColumns, viewPortWidth);
    _autoFillColumn = null;
  }

  GridColumn? _getColumnToFill(_DataGridSettings dataGridSettings) {
    final GridColumn? column = dataGridSettings.columns.lastWhereOrNull(
        (GridColumn c) =>
            c.visible &&
            c.width.isNaN &&
            c.columnWidthMode == ColumnWidthMode.lastColumnFill);
    if (column != null) {
      return column;
    } else {
      if (dataGridSettings.columnWidthMode == ColumnWidthMode.lastColumnFill) {
        final GridColumn? lastColumn = dataGridSettings.columns
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
      _DataGridSettings dataGridSettings,
      double totalColumnSize,
      List<GridColumn> calculatedColumns,
      double viewPortWidth) {
    for (final GridColumn column in dataGridSettings.columns) {
      if (calculatedColumns.contains(column) ||
          column.columnWidthMode == ColumnWidthMode.fill ||
          _isLastFillColum(column)) {
        continue;
      }

      switch (dataGridSettings.columnWidthMode) {
        case ColumnWidthMode.fitByCellValue:
          if (column._autoWidth.isNaN) {
            final double columnWidth = _getWidthBasedOnColumn(
                dataGridSettings, column, ColumnWidthMode.fitByCellValue);
            totalColumnSize += columnWidth;
            _setAutoWidth(column, columnWidth);
          } else {
            totalColumnSize +=
                _setColumnWidth(dataGridSettings, column, column._autoWidth);
          }
          calculatedColumns.add(column);
          break;
        case ColumnWidthMode.fitByColumnName:
          totalColumnSize += _getWidthBasedOnColumn(
              dataGridSettings, column, ColumnWidthMode.fitByColumnName);
          calculatedColumns.add(column);
          break;
        case ColumnWidthMode.auto:
        case ColumnWidthMode.lastColumnFill:
          if (column._autoWidth.isNaN) {
            final double columnWidth = _getWidthBasedOnColumn(
                dataGridSettings, column, ColumnWidthMode.auto);
            totalColumnSize += columnWidth;
            _setAutoWidth(column, columnWidth);
          } else {
            totalColumnSize +=
                _setColumnWidth(dataGridSettings, column, column._autoWidth);
          }
          calculatedColumns.add(column);
          break;
        case ColumnWidthMode.none:
          if (column.visible) {
            totalColumnSize += _setColumnWidth(dataGridSettings, column,
                dataGridSettings.container.columnWidths.defaultLineSize);
            calculatedColumns.add(column);
          }
          break;
        default:
          break;
      }
    }

    final List<GridColumn> remainingColumns = <GridColumn>[];

    for (final GridColumn column in dataGridSettings.columns) {
      if (!calculatedColumns.contains(column)) {
        remainingColumns.add(column);
      }
    }

    final double remainingColumnWidths = viewPortWidth - totalColumnSize;

    if (remainingColumnWidths > 0 &&
        (totalColumnSize != 0 ||
            (totalColumnSize == 0 && remainingColumns.length == 1) ||
            (dataGridSettings.columns.any((GridColumn col) =>
                    col.columnWidthMode == ColumnWidthMode.fill) ||
                dataGridSettings.columnWidthMode == ColumnWidthMode.fill))) {
      _setFillWidth(dataGridSettings, remainingColumnWidths, remainingColumns);
    } else {
      _setRemainingColumnsWidth(dataGridSettings, remainingColumns);
    }
  }

  double _getWidthBasedOnColumn(_DataGridSettings dataGridSettings,
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
    return _setColumnWidth(dataGridSettings, column, width);
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
    final double width =
        _getHeaderCellWidth(column) + _getSortIconWidth(column);
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
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();

    if (dataGridSettings.source.rows.isEmpty) {
      return double.nan;
    }

    switch (dataGridSettings.columnWidthCalculationRange) {
      case ColumnWidthCalculationRange.allRows:
        startRowIndex = 0;
        endRowIndex = dataGridSettings.source.rows.length - 1;
        break;
      case ColumnWidthCalculationRange.visibleRows:
        final _VisibleLinesCollection visibleLines =
            dataGridSettings.container.scrollRows.getVisibleLines(
                dataGridSettings.textDirection == TextDirection.rtl);
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
        column, _getDefaultTextStyle(_dataGridStateDetails(), true));
  }

  double _getCellWidth(GridColumn column, int rowIndex) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    if (_GridIndexResolver.isFooterWidgetRow(rowIndex, dataGridSettings)) {
      return 0.0;
    }

    late DataGridRow dataGridRow;
    switch (dataGridSettings.columnWidthCalculationRange) {
      case ColumnWidthCalculationRange.allRows:
        dataGridRow = dataGridSettings.source._effectiveRows[rowIndex];
        break;
      case ColumnWidthCalculationRange.visibleRows:
        dataGridRow =
            _SfDataGridHelper.getDataGridRow(dataGridSettings, rowIndex);
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

  void _setFillWidth(_DataGridSettings dataGridSettings,
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
              dataGridSettings.columnWidthMode ==
                  ColumnWidthMode.lastColumnFill)) {
        columns.remove(column);
        fillColumn = column;
        continue;
      }

      final double computedWidth =
          _setColumnWidth(dataGridSettings, column, fillWidth);
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

      _setColumnWidth(dataGridSettings, fillColumn,
          max(totalRemainingFillValue, columnWidth));
    }
  }

  void _setRemainingColumnsWidth(
      _DataGridSettings dataGridSettings, List<GridColumn> remainingColumns) {
    for (final GridColumn column in remainingColumns) {
      if (_isLastFillColum(column) ||
          !_isFillColumn(dataGridSettings, column)) {
        _setColumnWidth(dataGridSettings, column,
            dataGridSettings.container.columnWidths.defaultLineSize);
      }
    }
  }

  bool _isFillColumn(_DataGridSettings dataGridSettings, GridColumn column) {
    if (!column.width.isNaN) {
      return false;
    } else {
      return column.columnWidthMode == ColumnWidthMode.none
          ? dataGridSettings.columnWidthMode == ColumnWidthMode.fill
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
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    for (final GridColumn column in dataGridSettings.columns) {
      column._autoWidth = double.nan;
    }
  }

  double _getSortIconWidth(GridColumn column) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    double width = 0.0;
    if (column.allowSorting && dataGridSettings.allowSorting) {
      width += _sortIconWidth;
      if (dataGridSettings.allowMultiColumnSorting &&
          dataGridSettings.showSortNumbers) {
        width += _sortNumberWidth;
      }
    }
    return width;
  }

  double _setColumnWidth(_DataGridSettings dataGridSettings, GridColumn column,
      double columnWidth) {
    final int columnIndex = dataGridSettings.columns.indexOf(column);
    final double width = _getColumnWidth(column, columnWidth);
    column._actualWidth = width;
    dataGridSettings.container.columnWidths[columnIndex] = column._actualWidth;
    return width;
  }

  double _getColumnWidth(GridColumn column, double columnWidth) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    final int columnIndex = dataGridSettings.columns.indexOf(column);
    if (column.width < column._actualWidth) {
      return columnWidth;
    }

    final double width = dataGridSettings.container.columnWidths[columnIndex];
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
      rowIndex: _GridIndexResolver.getHeaderIndex(_dataGridStateDetails()),
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
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    final int rowIndex = _GridIndexResolver.resolveToRowIndex(
        dataGridSettings, dataGridSettings.source._effectiveRows.indexOf(row));

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
        _GridIndexResolver.getHeaderIndex(_dataGridStateDetails()),
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
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    final int rowIndex = _GridIndexResolver.resolveToRowIndex(
        dataGridSettings, dataGridSettings.source._effectiveRows.indexOf(row));
    return _measureCellHeight(column, rowIndex, cellValue, textStyle);
  }

  double _getAutoFitRowHeight(int rowIndex,
      {bool canIncludeHiddenColumns = false,
      List<String> excludedColumns = const <String>[]}) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    double autoFitHeight = 0.0;
    if (dataGridSettings.stackedHeaderRows.isNotEmpty &&
        rowIndex <= dataGridSettings.stackedHeaderRows.length - 1) {
      return dataGridSettings.headerRowHeight;
    }

    for (int index = 0; index < dataGridSettings.columns.length; index++) {
      final GridColumn column = dataGridSettings.columns[index];
      if ((!column.visible && !canIncludeHiddenColumns) ||
          excludedColumns.contains(column.columnName)) {
        continue;
      }

      autoFitHeight = max(_getRowHeight(column, rowIndex), autoFitHeight);
    }
    return autoFitHeight;
  }

  double _getRowHeight(GridColumn column, int rowIndex) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    if (rowIndex == _GridIndexResolver.getHeaderIndex(dataGridSettings)) {
      return computeHeaderCellHeight(
          column, _getDefaultTextStyle(dataGridSettings, true));
    } else {
      final DataGridRow row =
          _SfDataGridHelper.getDataGridRow(dataGridSettings, rowIndex);
      return computeCellHeight(column, row, _getCellValue(row, column),
          _getDefaultTextStyle(dataGridSettings, false));
    }
  }

  double _measureCellWidth(
      Object? cellValue, GridColumn column, DataGridRow dataGridRow) {
    return computeCellWidth(column, dataGridRow, cellValue,
        _getDefaultTextStyle(_dataGridStateDetails(), false));
  }

  double _measureCellHeight(
      GridColumn column, int rowIndex, Object? cellValue, TextStyle textStyle) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    final int columnIndex = dataGridSettings.columns.indexOf(column);
    double columnWidth = !column.visible || column.width == 0.0
        ? dataGridSettings.defaultColumnWidth
        : dataGridSettings.container.columnWidths[columnIndex];

    final double strokeWidth = _getGridLineStrokeWidth(
            rowIndex: rowIndex, dataGridSettings: dataGridSettings)
        .width;

    final double horizontalPadding = column.autoFitPadding.horizontal;

    // Removed the padding and gridline stroke width from the column width to
    // measure the accurate height for the cell content.
    columnWidth -= _getSortIconWidth(column) + horizontalPadding + strokeWidth;

    return _calculateTextSize(
      column: column,
      value: cellValue,
      width: columnWidth,
      textStyle: textStyle,
      rowIndex: rowIndex,
    ).height.roundToDouble();
  }

  TextStyle _getDefaultTextStyle(
      _DataGridSettings dataGridSettings, bool isHeader) {
    final bool isLight =
        dataGridSettings.dataGridThemeData!.brightness == Brightness.light;
    if (isHeader) {
      return isLight
          ? const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.black87)
          : const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color.fromRGBO(255, 255, 255, 1));
    } else {
      return isLight
          ? const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.black87)
          : const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color.fromRGBO(255, 255, 255, 1));
    }
  }

  Size _getGridLineStrokeWidth(
      {required int rowIndex, required _DataGridSettings dataGridSettings}) {
    final double strokeWidth =
        dataGridSettings.dataGridThemeData!.gridLineStrokeWidth;

    final GridLinesVisibility gridLinesVisibility =
        rowIndex <= _GridIndexResolver.getHeaderIndex(dataGridSettings)
            ? dataGridSettings.headerGridLinesVisibility
            : dataGridSettings.gridLinesVisibility;

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

    final _DataGridSettings dataGridSettings = _dataGridStateDetails();

    final Size strokeWidthSize = _getGridLineStrokeWidth(
        rowIndex: rowIndex, dataGridSettings: dataGridSettings);

    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: value?.toString() ?? '', style: textStyle),
        textScaleFactor: dataGridSettings.textScaleFactor,
        textDirection: dataGridSettings.textDirection)
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
