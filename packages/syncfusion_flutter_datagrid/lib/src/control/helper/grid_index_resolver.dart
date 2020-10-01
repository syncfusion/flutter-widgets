part of datagrid;

@protected
class _GridIndexResolver {
  static int getHeaderIndex(_DataGridSettings dataGridSettings) {
    if (dataGridSettings == null) {
      return 0;
    }

    final headerIndex = dataGridSettings.headerLineCount - 1;
    return headerIndex < 0 ? 0 : headerIndex;
  }

  static int resolveToGridVisibleColumnIndex(
      _DataGridSettings dataGridSettings, int columnIndex) {
    if (dataGridSettings == null) {
      return -1;
    }

    final indentColumnCount = 0;
    return columnIndex - indentColumnCount;
  }

  static int resolveToRowIndex(
      _DataGridSettings dataGridSettings, int rowIndex) {
    if (dataGridSettings == null ||
        dataGridSettings.container == null ||
        rowIndex < 0) {
      return -1;
    }

    rowIndex = rowIndex +
        _GridIndexResolver.resolveStartIndexBasedOnPosition(dataGridSettings);
    if (rowIndex >= 0 &&
        rowIndex <=
            dataGridSettings.container.rowCount -
                dataGridSettings.headerLineCount) {
      return rowIndex;
    } else {
      return -1;
    }
  }

  static int resolveStartIndexBasedOnPosition(
      _DataGridSettings dataGridSettings) {
    return dataGridSettings != null ? dataGridSettings.headerLineCount : 0;
  }

  static int resolveToRecordIndex(
      _DataGridSettings dataGridSettings, int rowIndex) {
    if (dataGridSettings == null ||
        dataGridSettings.container == null ||
        rowIndex < 0) {
      return -1;
    }

    if (rowIndex == 0) {
      return 0;
    }

    rowIndex = rowIndex -
        _GridIndexResolver.resolveStartIndexBasedOnPosition(dataGridSettings);
    if (rowIndex >= 0 &&
        rowIndex <= dataGridSettings.source._effectiveDataSource.length - 1) {
      return rowIndex;
    } else {
      return -1;
    }
  }

  static int resolveToStartColumnIndex(_DataGridSettings dataGridSettings) => 0;

  static RowColumnIndex resolveToRowColumnIndex(
      _DataGridSettings dataGridSettings, RowColumnIndex rowColumnIndex) {
    final rowIndex = _GridIndexResolver.resolveToRecordIndex(
        dataGridSettings, rowColumnIndex.rowIndex);
    final columnIndex = _GridIndexResolver.resolveToGridVisibleColumnIndex(
        dataGridSettings, rowColumnIndex.columnIndex);
    return RowColumnIndex(rowIndex, columnIndex);
  }

  static int resolveToScrollColumnIndex(
          _DataGridSettings dataGridSettings, int gridColumnIndex) =>
      gridColumnIndex;

  static int getLastFrozenColumnIndex(_DataGridSettings dataGridSettings) {
    if (dataGridSettings.frozenColumnsCount <= 0) {
      return -1;
    }

    final int startScrollColumnIndex =
        _GridIndexResolver.resolveToScrollColumnIndex(
            dataGridSettings, dataGridSettings.container.frozenColumns);
    return startScrollColumnIndex.isFinite ? startScrollColumnIndex - 1 : -1;
  }

  static int getStartFooterFrozenColumnIndex(
      _DataGridSettings dataGridSettings) {
    final columnsCount = dataGridSettings.container.columnCount;
    if (columnsCount <= 0 || dataGridSettings.footerFrozenColumnsCount <= 0) {
      return -1;
    }

    return columnsCount - dataGridSettings.container.footerFrozenColumns;
  }

  static int getLastFrozenRowIndex(_DataGridSettings dataGridSettings) {
    if (dataGridSettings.frozenRowsCount <= 0) {
      return -1;
    }

    final rowIndex = dataGridSettings.container.frozenRows -
        (dataGridSettings.headerLineCount * 2);
    return _GridIndexResolver.resolveToRowIndex(dataGridSettings, rowIndex);
  }

  static int getStartFooterFrozenRowIndex(_DataGridSettings dataGridSettings) {
    final rowCount = dataGridSettings.container.rowCount;
    if (rowCount <= 0 || dataGridSettings.footerFrozenRowsCount <= 0) {
      return -1;
    }

    final rowIndex = rowCount -
        dataGridSettings.container.footerFrozenRows -
        dataGridSettings.headerLineCount;
    return _GridIndexResolver.resolveToRowIndex(dataGridSettings, rowIndex);
  }
}
