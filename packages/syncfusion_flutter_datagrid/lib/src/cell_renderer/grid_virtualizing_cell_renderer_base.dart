part of datagrid;

/// A base class for cell renderer classes which displays widget in a cell.
abstract class GridVirtualizingCellRendererBase<T1 extends Widget,
    T2 extends Widget> extends GridCellRendererBase {
  /// Creates the [GridVirtualizingCellRendererBase] for [SfDataGrid] widget.
  GridVirtualizingCellRendererBase();

  /// Initializes the column element of a [DataCell]
  ///
  /// object with the given widget and required values.
  void onInitializeDisplayWidget(DataCellBase dataCell, T1 widget) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    if (dataCell != null) {
      var label = Text(
          dataCell._displayText != null
              ? dataCell._displayText.toString()
              : ' ',
          style: dataCell._cellStyle?.textStyle ??
              dataGridSettings.dataGridThemeData.cellStyle.textStyle,
          key: dataCell._key,
          maxLines: dataCell.gridColumn.maxLines,
          softWrap: dataCell.gridColumn.softWrap,
          overflow: dataCell.gridColumn.overflow);

      dataCell._columnElement = GridCell(
        key: dataCell._key,
        dataCell: dataCell,
        alignment: dataCell.gridColumn.textAlignment,
        padding: dataCell.gridColumn.padding,
        backgroundColor: dataCell._cellStyle?.backgroundColor ??
            dataGridSettings.dataGridThemeData.cellStyle.backgroundColor,
        isDirty: dataGridSettings.container._isDirty || dataCell._isDirty,
        child: ExcludeSemantics(child: label),
      );

      label = null;
    }
  }

  @override
  Widget onPrepareWidgets(DataCellBase dataCell) {
    onInitializeDisplayWidget(dataCell, null);
    return dataCell._columnElement;
  }

  @override
  void setCellStyle(DataCellBase dataCell) {
    if (dataCell._cellType != CellType.gridCell || dataCell == null) {
      return;
    }

    final queryCellStyle = _getQueryCellStyle(dataCell);
    final queryRowStyle = _getQueryRowStyle(dataCell);
    final cellTextStyle = _getCellTextStyle(dataCell);
    final cellBackgroundColor = _getCellBackgroundColor(dataCell);

    dataCell._cellStyle = DataGridCellStyle(
        backgroundColor: queryCellStyle?.backgroundColor ??
            queryRowStyle?.backgroundColor ??
            cellBackgroundColor,
        textStyle: queryCellStyle?.textStyle ??
            queryRowStyle?.textStyle ??
            cellTextStyle);
  }

  DataGridCellStyle _getSelectionStyle() {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    return dataGridSettings.dataGridThemeData?.selectionStyle;
  }

  TextStyle _getCellTextStyle(DataCellBase dataCell) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();

    if (dataCell._dataRow != null && dataCell._dataRow.isSelectedRow) {
      return _getSelectionStyle().textStyle;
    } else {
      return dataCell.gridColumn.cellStyle?.textStyle ??
          dataGridSettings.dataGridThemeData?.cellStyle?.textStyle;
    }
  }

  Color _getCellBackgroundColor(DataCellBase dataCell) {
    if (dataCell._dataRow != null && dataCell._dataRow.isSelectedRow) {
      // Uncomment the below code if the mentioned report has resolved
      // from framework side
      // https://github.com/flutter/flutter/issues/29702
      // return this._getSelectionStyle().backgroundColor;
      return Colors.transparent;
    } else {
      return dataCell.gridColumn.cellStyle?.backgroundColor ??
          // Uncomment the below code if the mentioned report has resolved
          // from framework side.
          // https://github.com/flutter/flutter/issues/29702
          // dataGridSettings.dataGridThemeData?.cellStyle?.backgroundColor;
          Colors.transparent;
    }
  }

  DataGridCellStyle _getQueryCellStyle(DataCellBase dataCell) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    DataGridCellStyle dataGridCellStyle;

    if (dataGridSettings.onQueryCellStyle != null) {
      final queryCellStyleArgs = QueryCellStyleArgs(
        rowIndex: dataCell.rowIndex,
        columnIndex: dataCell.columnIndex,
        cellValue: dataCell.cellValue,
        column: dataCell.gridColumn,
        displayText: dataCell._displayText,
      );

      final cellStyle = dataGridSettings.onQueryCellStyle(queryCellStyleArgs);
      dataCell._displayText = queryCellStyleArgs.displayText;
      if (cellStyle != null) {
        if (queryCellStyleArgs.stylePreference == StylePreference.selection &&
            dataCell._dataRow.isSelectedRow) {
          dataGridCellStyle = _getSelectionStyle();
        } else {
          dataGridCellStyle = dataCell._dataRow.isSelectedRow
              ? DataGridCellStyle.lerp(_getSelectionStyle(), cellStyle, 0.5)
              : cellStyle;
        }
      }
    }

    return dataGridCellStyle;
  }

  DataGridCellStyle _getQueryRowStyle(DataCellBase dataCell) {
    final DataRowBase dataRow = dataCell._dataRow;
    DataGridCellStyle dataGridCellStyle;
    if (dataRow.rowStyle != null) {
      if (dataRow._stylePreference == StylePreference.selection &&
          dataRow.isSelectedRow) {
        dataGridCellStyle = DataGridCellStyle(
            backgroundColor: Colors.transparent,
            textStyle: _getSelectionStyle().textStyle);

        // Uncomment the below code if the mentioned report has resolved
        // from framework side
        // https://github.com/flutter/flutter/issues/29702
        // dataGridCellStyle = this._getSelectionStyle();

      } else {
        dataGridCellStyle = DataGridCellStyle(
            backgroundColor: Colors.transparent,
            textStyle: dataRow.rowStyle.textStyle);

        // Uncomment the below code if the mentioned report has resolved
        // from framework side
        // https://github.com/flutter/flutter/issues/29702
        // dataGridCellStyle = dataCell._dataRow.isSelectedRow ?
        // DataGridCellStyle.lerp(_getSelectionStyle(), dataRow.rowStyle, 0.5)
        // : dataRow.rowStyle;
      }
    }

    return dataGridCellStyle;
  }
}
