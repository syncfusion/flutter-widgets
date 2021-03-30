part of datagrid;

class _ColumnSizer {
  _ColumnSizer() {
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
    final hasAnySizerColumn = dataGridSettings.columns.any((column) =>
        (column.columnWidthMode != ColumnWidthMode.none) ||
        (column.width != double.nan) ||
        !column.visible);

    final paddedEditableLineSizeHostBase =
        dataGridSettings.container.columnWidths;
    final _LineSizeCollection? lineSizeCollection =
        paddedEditableLineSizeHostBase is _LineSizeCollection
            ? paddedEditableLineSizeHostBase
            : null;

    if (lineSizeCollection == null) {
      return;
    }

    lineSizeCollection.suspendUpdates();
    _ensureColumnVisibility();

    if (dataGridSettings.columnWidthMode != ColumnWidthMode.none ||
        hasAnySizerColumn) {
      _sizerColumnWidth(availableWidth);
    }
    dataGridSettings.container.updateScrollBars();
    lineSizeCollection.resumeUpdates();
  }

  void _ensureColumnVisibility() {
    final dataGridSettings = _dataGridStateDetails();
    for (final column in dataGridSettings.columns) {
      final index = _GridIndexResolver.resolveToScrollColumnIndex(
          dataGridSettings, dataGridSettings.columns.indexOf(column));
      if (column.visible) {
        dataGridSettings.container.columnWidths.setHidden(index, index, false);
      } else {
        dataGridSettings.container.columnWidths.setHidden(index, index, true);
      }
    }
    // Columns will be auto sized only if Columns doesn't have explicit width
    // defined.
    _sizerColumnWidth(0.0);
  }

  void _sizerColumnWidth(double viewPortWidth) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    double totalColumnSize = 0.0;
    final List<GridColumn> calculatedColumns = [];

    _autoFillColumn = _getColumnToFill();

    // Hide Hidden columns
    final hiddenColumns =
        dataGridSettings.columns.where((column) => !column.visible);
    for (final column in hiddenColumns) {
      final index = _GridIndexResolver.resolveToScrollColumnIndex(
          dataGridSettings, dataGridSettings.columns.indexOf(column));
      dataGridSettings.container.columnWidths.setHidden(index, index, true);
      calculatedColumns.add(column);
    }

    // Set width based on Column.Width
    final widthColumns = dataGridSettings.columns
        .skipWhile((column) => !column.visible)
        .where((column) => !(column.width).isNaN);
    for (final column in widthColumns) {
      totalColumnSize += _setColumnWidth(column, column.width);
      calculatedColumns.add(column);
    }

    final List<GridColumn> lastColumnFill = dataGridSettings.columns
        .skipWhile((column) => calculatedColumns.contains(column))
        .where((col) =>
            (col.columnWidthMode == ColumnWidthMode.lastColumnFill) &&
            !_isLastFillColum(col))
        .toList();

    final List<GridColumn> autoColumns = lastColumnFill;

    for (final column in autoColumns) {
      if ((column._autoWidth).isNaN) {
        final columnWidth =
            dataGridSettings.container.columnWidths.defaultLineSize;
        totalColumnSize += columnWidth;
        _setAutoWidth(column, columnWidth);
      } else {
        totalColumnSize += _setColumnWidth(column, column._autoWidth);
      }
      calculatedColumns.add(column);
    }
    _setWidthBasedOnGrid(totalColumnSize, calculatedColumns, viewPortWidth);
    _autoFillColumn = null;
  }

  GridColumn? _getColumnToFill() {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    final GridColumn? column = dataGridSettings.columns.lastWhereOrNull((c) =>
        c.visible &&
        (c.width).isNaN &&
        (c.columnWidthMode == ColumnWidthMode.lastColumnFill));
    if (column != null) {
      return column;
    } else {
      if (dataGridSettings.columnWidthMode == ColumnWidthMode.lastColumnFill) {
        final GridColumn? lastColumn = dataGridSettings.columns
            .lastWhereOrNull((c) => c.visible && (c.width).isNaN);
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

  void _setWidthBasedOnGrid(double totalColumnSize,
      List<GridColumn> calculatedColumns, double viewPortWidth) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    for (final column in dataGridSettings.columns) {
      if (calculatedColumns.contains(column)) {
        continue;
      }

      if (column.columnWidthMode == ColumnWidthMode.fill ||
          _isLastFillColum(column)) {
        continue;
      }

      switch (dataGridSettings.columnWidthMode) {
        case ColumnWidthMode.lastColumnFill:
          if ((column.width).isNaN) {
            totalColumnSize += _setColumnWidth(column,
                dataGridSettings.container.columnWidths.defaultLineSize);
            calculatedColumns.add(column);
          } else {
            totalColumnSize += _setColumnWidth(column, column.width);
            calculatedColumns.add(column);
          }
          break;
        case ColumnWidthMode.none:
          if (column.visible) {
            totalColumnSize += _setColumnWidth(column,
                dataGridSettings.container.columnWidths.defaultLineSize);
            calculatedColumns.add(column);
          }
          break;
        default:
          break;
      }
    }

    final List<GridColumn> remainingColumns = [];

    for (final column in dataGridSettings.columns) {
      if (!calculatedColumns.contains(column)) {
        remainingColumns.add(column);
      }
    }

    final double remainingColumnWidths = viewPortWidth - totalColumnSize;

    if (remainingColumnWidths > 0 &&
        (totalColumnSize != 0 ||
            (totalColumnSize == 0 && remainingColumns.length == 1) ||
            (dataGridSettings.columns.any(
                    (col) => col.columnWidthMode == ColumnWidthMode.fill) ||
                dataGridSettings.columnWidthMode == ColumnWidthMode.fill))) {
      _setFillWidth(remainingColumnWidths, remainingColumns);
    } else {
      _setRemainingColumnsWidth(remainingColumns);
    }
  }

  void _setFillWidth(
      double remainingColumnWidth, List<GridColumn> remainingColumns) {
    final removedColumns = [];
    final columns = remainingColumns.toList();
    var totalRemainingFillValue = remainingColumnWidth;

    double removedWidth = 0;
    GridColumn? fillColumn;
    bool isRemoved;
    while (columns.isNotEmpty) {
      isRemoved = false;
      removedWidth = 0;
      final double fillWidth =
          (totalRemainingFillValue / columns.length).floorToDouble();
      final column = columns.first;
      if (column == _autoFillColumn &&
          (column.columnWidthMode == ColumnWidthMode.lastColumnFill ||
              (_dataGridStateDetails().columnWidthMode ==
                  ColumnWidthMode.lastColumnFill))) {
        columns.remove(column);
        fillColumn = column;
        continue;
      }
      final double computedWidth = _setColumnWidth(column, fillWidth);
      if (fillWidth != computedWidth && fillWidth > 0) {
        isRemoved = true;
        columns.remove(column);
        for (final removedColumn in removedColumns) {
          if (!columns.contains(removedColumn)) {
            removedWidth += removedColumn._actualWidth;
            columns.add(removedColumn);
          }
        }
        removedColumns.clear();
        totalRemainingFillValue += removedWidth;
      }
      column._actualWidth = computedWidth;
      totalRemainingFillValue = totalRemainingFillValue - computedWidth;
      if (!isRemoved) {
        columns.remove(column);
        if (!removedColumns.contains(column)) {
          removedColumns.add(column);
        }
      }
    }

    if (fillColumn != null) {
      double columnWidth = 0;
      if ((fillColumn._autoWidth).isNaN) {
        columnWidth = 0.0;
        _setAutoWidth(fillColumn, columnWidth);
      } else {
        columnWidth = fillColumn._autoWidth;
      }

      if (totalRemainingFillValue < columnWidth) {
        _setColumnWidth(fillColumn, columnWidth);
      } else {
        _setColumnWidth(fillColumn, totalRemainingFillValue);
      }
    }
  }

  void _setRemainingColumnsWidth(List<GridColumn> remainingColumns) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    for (final column in remainingColumns) {
      if (_isLastFillColum(column)) {
        _setNoneWidth(
            column, dataGridSettings.container.columnWidths.defaultLineSize);
      } else if (!_isFillColumn(column)) {
        _setNoneWidth(
            column, dataGridSettings.container.columnWidths.defaultLineSize);
      }
    }
  }

  bool _isFillColumn(GridColumn column) => !column.width.isNaN
      ? false
      : column.columnWidthMode == ColumnWidthMode.none
          ? _dataGridStateDetails().columnWidthMode == ColumnWidthMode.fill
          : column.columnWidthMode == ColumnWidthMode.fill;

  double _setNoneWidth(GridColumn column, double width) =>
      _setColumnWidth(column, width);

  bool _isLastFillColum(GridColumn column) {
    if (column == _autoFillColumn) {
      return true;
    }

    return false;
  }

  void _setAutoWidth(GridColumn? column, double width) {
    if (column != null) {
      column._autoWidth = width;
    }
  }

  void _resetAutoCalculation() {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    for (final column in dataGridSettings.columns) {
      column._autoWidth = double.nan;
    }
  }

  double _getSortIconWidth(GridColumn column) {
    final dataGridSettings = _dataGridStateDetails();
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

  double _setColumnWidth(GridColumn column, double columnWidth) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    final columnIndex = dataGridSettings.columns.indexOf(column);
    final width = _getColumnWidth(column, columnWidth);
    column._actualWidth = width;
    dataGridSettings.container.columnWidths[columnIndex] = column._actualWidth;
    return width;
  }

  double _getColumnWidth(GridColumn column, double columnWidth) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    final columnIndex = dataGridSettings.columns.indexOf(column);
    if (column.width < column._actualWidth) {
      return columnWidth;
    }

    final width = dataGridSettings.container.columnWidths[columnIndex];

    final resultWidth = _checkWidthConstraints(column, columnWidth, width);
    return resultWidth;
  }

  double _checkWidthConstraints(
      GridColumn column, double width, double columnWidth) {
    if (!(column.minimumWidth).isNaN || !(column.maximumWidth).isNaN) {
      if (!(column.maximumWidth).isNaN) {
        if (!width.isNaN && column.maximumWidth > width) {
          columnWidth = width;
        } else {
          columnWidth = column.maximumWidth;
        }
      }

      if (!(column.minimumWidth).isNaN) {
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
}
