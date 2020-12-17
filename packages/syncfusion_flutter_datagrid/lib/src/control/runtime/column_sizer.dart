part of datagrid;

/// Handles the sizing for all the columns in the [SfDataGrid].
///
/// You can override any available methods in this class to calculate the
/// column width based on your requirement and set the instance to the
/// [SfDataGrid.columnSizer].
///
/// ``` dart
/// class CustomGridColumnSizer extends ColumnSizer {
///   // Calculate width for column when ColumnWidthMode is auto.
///   @override
///   double calculateAllCellsWidth(GridColumn column, [bool isAuto = false]) {
///     return super.calculateAllCellsWidth(column, isAuto);
///   }
///
///   // Calculate width for column when ColumnWidthMode is header.
///   @override
///   double calculateColumnHeaderWidth(GridColumn column, [bool setWidth = true]) {
///     return super.calculateColumnHeaderWidth(column, setWidth);
///   }
///
///   // Calculate width for column when ColumnWidthMode is cells.
///   @override
///   double calculateAllCellsExceptHeaderWidth(GridColumn column,
///       [bool setWidth = true]) {
///     return super.calculateAllCellsExceptHeaderWidth(column, setWidth);
///   }
/// }
///
/// final CustomGridColumnSizer _customGridColumnSizer = CustomGridColumnSizer();
///
/// @override
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfDataGrid(
///       source: _employeeDataSource,
///       columnSizer: _customGridColumnSizer,
///       columnWidthMode: ColumnWidthMode.auto,
///       columns: [
///         GridNumericColumn(mappingName: 'id', headerText: 'ID'),
///         GridTextColumn(mappingName: 'name', headerText: 'Name'),
///         GridTextColumn(mappingName: 'designation', headerText: 'Designation'),
///         GridNumericColumn(mappingName: 'salary', headerText: 'Salary')
///      ],
///     ),
///   );
/// }
/// ```
class ColumnSizer {
  /// Creates the [ColumnSizer] for [SfDataGrid] widget.
  ColumnSizer() {
    _isColumnSizerLoadedInitially = false;
  }

  int _textLength = 0;
  double _previousColumnWidth = 0.0;
  GridColumn _autoFillColumn;
  bool _isColumnSizerLoadedInitially;

  static const double _sortIconWidth = 20.0;
  static const double _sortNumberWidth = 18.0;

  _DataGridStateDetails _dataGridStateDetails;

  void _initialRefresh(double availableWidth) {
    final _LineSizeCollection lineSizeCollection =
        _dataGridStateDetails().container.columnWidths;
    lineSizeCollection.suspendUpdates();
    _refresh(availableWidth);
    lineSizeCollection.resumeUpdates();
  }

  void _refresh(double availableWidth) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    final sizerColumns = dataGridSettings.columns
        .where((column) => column.columnWidthMode != ColumnWidthMode.none);

    if (dataGridSettings.columnWidthMode != null || sizerColumns.isNotEmpty) {
      _sizerColumnWidth(availableWidth);
    }
    dataGridSettings.container.updateScrollBars();
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

    // Set width based on widget column
    final widgetColumns = dataGridSettings.columns
        .skipWhile((column) =>
            !column.visible ||
            !(column.columnWidthMode == ColumnWidthMode.auto ||
                column.columnWidthMode == ColumnWidthMode.cells))
        .where((column) => column._cellType == 'Widget' && column.width.isNaN);
    for (final column in widgetColumns) {
      totalColumnSize +=
          _setColumnWidth(column, dataGridSettings.defaultColumnWidth);
      calculatedColumns.add(column);
    }

    // Set width based on cells
    final cellColumns = dataGridSettings.columns
        .skipWhile((column) => !column.visible)
        .where((column) =>
            column.columnWidthMode == ColumnWidthMode.cells &&
            column.width.isNaN &&
            !widgetColumns.contains(column));
    for (final column in cellColumns) {
      if (column._autoWidth.isNaN) {
        final columnWidth =
            _getWidthBasedOnColumn(column, ColumnWidthMode.cells);
        totalColumnSize += columnWidth;
        _setAutoWidth(column, columnWidth);
      } else {
        totalColumnSize += _setColumnWidth(column, column._autoWidth);
      }
      calculatedColumns.add(column);
    }

    // Set width based on header
    final headerColumns = dataGridSettings.columns
        .skipWhile((column) => !column.visible)
        .where((column) =>
            column.columnWidthMode == ColumnWidthMode.header &&
            column.width.isNaN);
    for (final column in headerColumns) {
      totalColumnSize += _getWidthBasedOnColumn(column, ColumnWidthMode.header);
      calculatedColumns.add(column);
    }

    // Set width based on auto and lastColumnFill
    List<GridColumn> autoColumns = dataGridSettings.columns
        .where((column) =>
            column.columnWidthMode == ColumnWidthMode.auto &&
            !(!column.visible || widgetColumns.contains(column)) &&
            (column.width).isNaN)
        .toList();
    final List<GridColumn> lastColumnFill = dataGridSettings.columns
        .skipWhile((column) => calculatedColumns.contains(column))
        .where((col) =>
            (col.columnWidthMode == ColumnWidthMode.lastColumnFill) &&
            !_isLastFillColum(col))
        .toList();
    autoColumns = (autoColumns + lastColumnFill).toSet().toList();

    for (final column in autoColumns) {
      if ((column._autoWidth).isNaN) {
        final columnWidth =
            _getWidthBasedOnColumn(column, ColumnWidthMode.auto);
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

  GridColumn _getColumnToFill() {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    final column = dataGridSettings.columns.lastWhere(
        (c) =>
            c.visible &&
            (c.width).isNaN &&
            (c.columnWidthMode == ColumnWidthMode.lastColumnFill),
        orElse: () => null);
    if (column != null) {
      return column;
    } else {
      if (dataGridSettings.columnWidthMode == ColumnWidthMode.lastColumnFill) {
        final lastColumn = dataGridSettings.columns
            .lastWhere((c) => c.visible && (c.width).isNaN, orElse: () => null);
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

      if (column._cellType == 'Widget') {
        if (dataGridSettings.columnWidthMode == ColumnWidthMode.auto ||
            dataGridSettings.columnWidthMode == ColumnWidthMode.cells) {
          totalColumnSize +=
              _setColumnWidth(column, dataGridSettings.defaultColumnWidth);
          calculatedColumns.add(column);
          continue;
        }
      }

      if (column.columnWidthMode == ColumnWidthMode.fill ||
          _isLastFillColum(column)) {
        continue;
      }

      switch (dataGridSettings.columnWidthMode) {
        case ColumnWidthMode.cells:
          if (column._autoWidth.isNaN) {
            final columnWidth =
                _getWidthBasedOnColumn(column, ColumnWidthMode.cells);
            totalColumnSize += columnWidth;
            _setAutoWidth(column, columnWidth);
          } else {
            totalColumnSize += _setColumnWidth(column, column._autoWidth);
          }
          calculatedColumns.add(column);
          break;
        case ColumnWidthMode.header:
          totalColumnSize +=
              _getWidthBasedOnColumn(column, ColumnWidthMode.header);
          calculatedColumns.add(column);
          break;
        case ColumnWidthMode.auto:
        case ColumnWidthMode.lastColumnFill:
          if ((column._autoWidth).isNaN) {
            final columnWidth =
                _getWidthBasedOnColumn(column, ColumnWidthMode.auto);
            totalColumnSize += columnWidth;
            _setAutoWidth(column, columnWidth);
          } else {
            totalColumnSize += _setColumnWidth(column, column._autoWidth);
          }
          calculatedColumns.add(column);
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
    GridColumn fillColumn;
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
        columnWidth = _getWidthBasedOnColumn(fillColumn, ColumnWidthMode.auto);
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
        if (column.columnWidthMode == ColumnWidthMode.lastColumnFill ||
            (dataGridSettings.columnWidthMode ==
                ColumnWidthMode.lastColumnFill)) {
          _getWidthBasedOnColumn(column, ColumnWidthMode.auto);
        } else {
          _setNoneWidth(
              column, dataGridSettings.container.columnWidths.defaultLineSize);
        }
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

  void _setAutoWidth(GridColumn column, double width) {
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

  double _getWidthBasedOnColumn(
      GridColumn column, ColumnWidthMode columnWidthMode) {
    double width;
    switch (columnWidthMode) {
      case ColumnWidthMode.cells:
        width = calculateAllCellsExceptHeaderWidth(column);
        return _setColumnWidth(column, width);
      case ColumnWidthMode.header:
        width = calculateColumnHeaderWidth(column);
        return _setColumnWidth(column, width);
      case ColumnWidthMode.auto:
        width = calculateAllCellsWidth(column, isAuto: true);
        return _setColumnWidth(column, width);
      default:
        break;
    }
    return 0.0;
  }

  /// Calculates the width for the column to fit the content including the
  /// header cell when [SfDataGrid.columnWidthMode] is [ColumnWidthMode.auto].
  double calculateAllCellsWidth(GridColumn column, {bool isAuto = false}) {
    final double headerWidth =
        calculateColumnHeaderWidth(column, setWidth: false);
    final double cellWidth =
        calculateAllCellsExceptHeaderWidth(column, setWidth: false);
    double width;
    if (cellWidth > headerWidth) {
      width = cellWidth;
    } else {
      width = headerWidth;
    }

    if (isAuto) {
      return width;
    }
    return _getColumnWidth(column, width);
  }

  /// Calculates the width for the column based on the header text when
  /// [SfDataGrid.columnWidthMode] is [ColumnWidthMode.header].
  double calculateColumnHeaderWidth(GridColumn column, {bool setWidth = true}) {
    double width = _getHeaderCellWidth(column).roundToDouble();
    if (setWidth) {
      column._actualWidth = width;
    }
    width += _getSortIconWidth(column);
    return width;
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

  /// Calculates the width for the column to fit the content in cells except
  /// header cell when [SfDataGrid.columnWidthMode] is [ColumnWidthMode.cells].
  double calculateAllCellsExceptHeaderWidth(GridColumn column,
      {bool setWidth = true}) {
    if (setWidth) {
      column._actualWidth = _getCellWidth(column);
      return column._actualWidth;
    } else {
      return _getCellWidth(column);
    }
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

  double _getCellWidth(GridColumn column) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    double resultWidth = 0;
    final recordCount = dataGridSettings.source._effectiveDataSource.length;
    if (recordCount == 0) {
      return double.nan;
    }

    _textLength = 0;
    _previousColumnWidth = 0;
    int stringLength = 0;
    final isInDefaultMode = dataGridSettings.columnWidthCalculationMode ==
        ColumnWidthCalculationMode.textSize;
    Object index;
    int firstVisibleIndex, lastVisibleIndex;

    if (dataGridSettings.columnWidthCalculationRange ==
        ColumnWidthCalculationRange.visibleRows) {
      final visibleLines =
          dataGridSettings.container.scrollRows.getVisibleLines();
      firstVisibleIndex =
          visibleLines.firstBodyVisibleIndex <= visibleLines.length - 1
              ? visibleLines[visibleLines.firstBodyVisibleIndex].lineIndex
              : 0;
      lastVisibleIndex =
          dataGridSettings.container.scrollRows.lastBodyVisibleLineIndex;
    } else {
      firstVisibleIndex = 0;
      lastVisibleIndex =
          dataGridSettings.source._effectiveDataSource.length - 1;
    }

    for (int rowIndex = firstVisibleIndex;
        rowIndex <= lastVisibleIndex;
        rowIndex++) {
      if (isInDefaultMode) {
        final textWidth = getCellWidth(column, rowIndex);
        if (textWidth.toString().isEmpty) {
          continue;
        }

        if (resultWidth < textWidth) {
          resultWidth = textWidth;
        }
      } else {
        final currentRowIndex = (dataGridSettings.columnWidthCalculationRange ==
                ColumnWidthCalculationRange.visibleRows)
            ? _GridIndexResolver.resolveToRecordIndex(
                dataGridSettings, rowIndex)
            : rowIndex;
        final String text = _getDisplayText(currentRowIndex, column);
        if (text.length >= stringLength) {
          stringLength = text.length;
          index = rowIndex;
        }
      }
    }

    if (!isInDefaultMode) {
      final textWidth = getCellWidth(column, index);
      resultWidth = textWidth;
    }

    _textLength = 0;
    _previousColumnWidth = 0;
    return resultWidth;
  }

  /// Gets the width of the cell to calculate the width of the specified column.
  double getCellWidth(GridColumn column, int rowIndex) {
    double textWidth = 0.0;
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    final currentRowIndex = (dataGridSettings.columnWidthCalculationRange ==
            ColumnWidthCalculationRange.visibleRows)
        ? _GridIndexResolver.resolveToRecordIndex(dataGridSettings, rowIndex)
        : rowIndex;
    final formattedText = _getDisplayText(currentRowIndex, column);
    if (formattedText != null && formattedText.length >= _textLength ||
        _previousColumnWidth >= column._actualWidth) {
      textWidth = _measureTextWidth(formattedText, column, rowIndex);
      _textLength = formattedText.length;
      _previousColumnWidth = column._actualWidth;
    }

    return textWidth.roundToDouble();
  }

  /// Gets the height of the cell to calculate the width of the specified
  /// column.
  double getCellHeight(GridColumn column, int rowIndex) {
    double textHeight = 0.0;
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    if (rowIndex == _GridIndexResolver.getHeaderIndex(dataGridSettings)) {
      final text = column.headerText ?? column.mappingName;
      textHeight = _measureTextHeight(text, column, rowIndex);
      return textHeight.roundToDouble();
    } else {
      final currentRowIndex =
          _GridIndexResolver.resolveToRecordIndex(dataGridSettings, rowIndex);
      final formattedText = _getDisplayText(currentRowIndex, column);
      if (formattedText != null && formattedText.length >= _textLength ||
          _previousColumnWidth >= column._actualWidth) {
        textHeight = _measureTextHeight(formattedText, column, rowIndex);
        _textLength = formattedText.length;
        _previousColumnWidth = column._actualWidth;
      }

      return textHeight.roundToDouble();
    }
  }

  /// Gets the row height to fit the row based on the content.
  ///
  /// The following code snippet shows how to use [getAutoRowHeight] method,
  ///
  /// ``` dart
  /// final ColumnSizer _columnSizer = ColumnSizer();
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///  return Scaffold(
  ///       body: SfDataGrid(
  ///           source: _employeeDatasource,
  ///           columnSizer: _columnSizer,
  ///           onQueryRowHeight: (rowIndex) {
  ///             double height = _columnSizer.getAutoRowHeight(rowIndex);
  ///             return height;
  ///           },
  ///           columns: <GridColumn>[
  ///         GridTextColumn(mappingName: 'id')
  ///           ..softWrap = true
  ///           ..overflow = TextOverflow.clip
  ///           ..headerText = 'ID',
  ///         GridTextColumn(mappingName: 'contactName')
  ///           ..softWrap = true
  ///           ..overflow = TextOverflow.clip
  ///           ..headerText = 'Contact Name',
  ///         GridTextColumn(mappingName: 'companyName')
  ///           ..softWrap = true
  ///           ..overflow = TextOverflow.clip
  ///           ..headerText = 'Company Name',
  ///         GridTextColumn(mappingName: 'city')
  ///           ..softWrap = true
  ///           ..overflow = TextOverflow.clip
  ///           ..headerText = 'City',
  ///         GridTextColumn(mappingName: 'address')
  ///           ..softWrap = true
  ///           ..overflow = TextOverflow.clip
  ///           ..headerText = 'Address',
  ///         GridTextColumn(mappingName: 'designation')
  ///          ..softWrap = true
  ///           ..overflow = TextOverflow.clip
  ///           ..headerText = 'Designation',
  ///         GridTextColumn(mappingName: 'country')
  ///           ..softWrap = true
  ///           ..overflow = TextOverflow.clip
  ///           ..headerText = 'Country',
  ///       ]));
  /// }
  /// ```
  double getAutoRowHeight(int rowIndex,
      {bool canIncludeHiddenColumns = false, List<String> excludedColumns}) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    double resultHeight = -1;
    GridColumn gridColumn;
    int stringLength = 0;
    final isInDefaultMode = dataGridSettings.columnWidthCalculationMode ==
        ColumnWidthCalculationMode.textSize;
    if (dataGridSettings.stackedHeaderRows.isNotEmpty &&
        rowIndex <= dataGridSettings.stackedHeaderRows.length - 1) {
      return dataGridSettings.headerRowHeight;
    }

    for (int columnIndex = 0;
        columnIndex < dataGridSettings.columns.length;
        columnIndex++) {
      final column = dataGridSettings.columns[columnIndex];
      if (!column.visible && !canIncludeHiddenColumns) {
        continue;
      }

      if (excludedColumns != null) {
        if (excludedColumns.contains(column.mappingName)) {
          continue;
        }
      }

      final recordCount = dataGridSettings.source._effectiveDataSource.length;
      if (recordCount == 0) {
        return double.nan;
      }

      if (isInDefaultMode) {
        final textHeight = getCellHeight(column, rowIndex);
        if (textHeight.toString().isEmpty) {
          continue;
        }

        if (resultHeight < textHeight) {
          resultHeight = textHeight;
        }
      } else {
        final text = _getDisplayText(rowIndex, column);
        if (text != null && text.length >= stringLength) {
          stringLength = text.length;
          gridColumn = column;
        }
      }
    }

    if (!isInDefaultMode) {
      final textHeight = getCellHeight(gridColumn, rowIndex);
      resultHeight = textHeight;
    }
    _textLength = 0;
    _previousColumnWidth = 0;
    return resultHeight;
  }

  double _getHeaderCellWidth(GridColumn column) {
    final rowCount = _dataGridStateDetails().headerLineCount;
    double resultWidth = 0;
    for (int rowIndex = 0; rowIndex < rowCount; rowIndex++) {
      final text = column.headerText ?? column.mappingName;
      if (text.isEmpty || text == null) {
        return 0;
      }

      final textWidth = _measureTextWidth(text, column, rowIndex);
      final width = textWidth;
      if (resultWidth < width) {
        resultWidth = width;
      }
    }
    return resultWidth;
  }

  String _getDisplayText(int rowIndex, GridColumn column) {
    final text = _dataGridStateDetails()
        .source
        .getCellValue(rowIndex, column.mappingName);
    final String formattedText =
        text != null ? column.getFormattedValue(text) : null;
    if (formattedText != null) {
      return formattedText;
    }
    return '';
  }

  TextStyle _getCellTextStyle(int rowIndex, GridColumn column) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    TextStyle cellTextStyle;
    if (rowIndex == _GridIndexResolver.getHeaderIndex(dataGridSettings)) {
      cellTextStyle = column.headerStyle?.textStyle ??
          dataGridSettings.dataGridThemeData.headerStyle?.textStyle;
    } else {
      cellTextStyle = column.cellStyle?.textStyle ??
          dataGridSettings.dataGridThemeData.cellStyle?.textStyle;
    }
    return cellTextStyle;
  }

  EdgeInsetsGeometry _getPadding(int rowIndex, GridColumn column) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();

    if (rowIndex == _GridIndexResolver.getHeaderIndex(dataGridSettings)) {
      if (column.headerPadding != null) {
        return column.headerPadding;
      } else {
        final visualDensityPadding =
            dataGridSettings.visualDensity.vertical * 2;
        return EdgeInsets.all(16) +
            EdgeInsets.fromLTRB(
                0.0, visualDensityPadding, 0.0, visualDensityPadding);
      }
    } else {
      if (column.padding != null) {
        return column.padding;
      } else {
        final visualDensityPadding =
            dataGridSettings.visualDensity.vertical * 2;
        return EdgeInsets.all(16) +
            EdgeInsets.fromLTRB(
                0.0, visualDensityPadding, 0.0, visualDensityPadding);
      }
    }
  }

  double _measureTextWidth(
      String displayText, GridColumn column, int rowIndex) {
    final cellTextStyle = _getCellTextStyle(rowIndex, column);
    return _calculateTextSize(
            column, displayText, cellTextStyle, double.infinity, rowIndex)
        .width;
  }

  double _measureTextHeight(
      String displayText, GridColumn column, int rowIndex) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    final cellTextStyle = _getCellTextStyle(rowIndex, column);
    final columnIndex = dataGridSettings.columns.indexOf(column);
    final int scrollColumnIndex = _GridIndexResolver.resolveToScrollColumnIndex(
        dataGridSettings, columnIndex);
    final double columnWidth = !(column.visible) || column.width == 0.0
        ? dataGridSettings.defaultColumnWidth
        : dataGridSettings.container.columnWidths[scrollColumnIndex];
    final gridLinesVisibility = dataGridSettings.gridLinesVisibility;
    final Size gridLineStrokeWidthSize =
        _getGridLineStrokeWidthSize(gridLinesVisibility, rowIndex, columnIndex);

    final padding = _getPadding(rowIndex, column);
    // Removing padding and stroke width values also to the column hight calculation
    final double actualColumnWidth = columnWidth -
        _getSortIconWidth(column) -
        (padding.horizontal + gridLineStrokeWidthSize.width);
    return _calculateTextSize(
            column, displayText, cellTextStyle, actualColumnWidth, rowIndex)
        .height;
  }

  Size _getGridLineStrokeWidthSize(
      GridLinesVisibility gridLinesVisibility, int rowIndex, int columnIndex) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    Size gridLineStrokeWidthSize = Size.zero;
    double gridLineStrokeWidth =
        dataGridSettings.dataGridThemeData?.gridLineStrokeWidth;
    if (gridLinesVisibility == GridLinesVisibility.both) {
      if (columnIndex == 0 && rowIndex == 0) {
        // Adding border line stroke also to the column width calculation
        gridLineStrokeWidth *= 2;
        gridLineStrokeWidthSize = Size(
            gridLineStrokeWidthSize.width + gridLineStrokeWidth,
            gridLineStrokeWidthSize.height + gridLineStrokeWidth);
      }
      if (rowIndex == 0 && columnIndex > 0) {
        gridLineStrokeWidthSize = Size(
            gridLineStrokeWidthSize.width + gridLineStrokeWidth,
            gridLineStrokeWidthSize.height + (2 * gridLineStrokeWidth));
      }
      if (columnIndex == 0 && rowIndex > 0) {
        gridLineStrokeWidthSize = Size(
            gridLineStrokeWidthSize.width + (2 * gridLineStrokeWidth),
            gridLineStrokeWidthSize.height + gridLineStrokeWidth);
      }
      if (columnIndex > 0 && rowIndex > 0) {
        gridLineStrokeWidthSize = Size(
            gridLineStrokeWidthSize.width + gridLineStrokeWidth,
            gridLineStrokeWidthSize.height + gridLineStrokeWidth);
      }
    } else if (gridLinesVisibility == GridLinesVisibility.vertical) {
      if (columnIndex == 0) {
        // Adding border line stroke also to the column width calculation
        gridLineStrokeWidth *= 2;
      }

      gridLineStrokeWidthSize = Size(
          gridLineStrokeWidthSize.width + gridLineStrokeWidth,
          gridLineStrokeWidthSize.height);
    } else if (gridLinesVisibility == GridLinesVisibility.horizontal) {
      if (rowIndex == 0) {
        // Adding border line stroke also to the column width calculation
        gridLineStrokeWidth *= 2;
      }

      gridLineStrokeWidthSize = Size(gridLineStrokeWidthSize.width,
          gridLineStrokeWidthSize.height + gridLineStrokeWidth);
    }
    return gridLineStrokeWidthSize;
  }

  Size _calculateTextSize(GridColumn column, String text, TextStyle style,
      double width, int rowIndex) {
    Size textSize = Size.zero;
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    final columnIndex = dataGridSettings.columns.indexOf(column);
    final gridLinesVisibility = dataGridSettings.gridLinesVisibility;
    final gridLineStrokeWidthSize =
        _getGridLineStrokeWidthSize(gridLinesVisibility, rowIndex, columnIndex);
    final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: style,
        ),
        maxLines: column.maxLines,
        textScaleFactor: dataGridSettings.textScaleFactor,
        textDirection: TextDirection.ltr)
      ..layout(maxWidth: width);
    textSize = textPainter.size;
    final padding = _getPadding(rowIndex, column);
    if (padding != null) {
      textSize = Size(textSize.width + padding.horizontal,
          textSize.height + padding.vertical);
    }
    return Size(textSize.width + gridLineStrokeWidthSize.width,
        textSize.height + gridLineStrokeWidthSize.height);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColumnSizer && runtimeType == other.runtimeType;

  @override
  int get hashCode {
    final List<Object> _hashList = [this];
    return hashList(_hashList);
  }
}
