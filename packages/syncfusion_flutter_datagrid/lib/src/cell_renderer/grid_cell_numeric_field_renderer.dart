part of datagrid;

/// A cell renderer which displays the numeric value in the cell.
///
/// This renderer is typically used for [GridNumericColumn].
class GridCellNumericTextFieldRenderer<T1, T2>
    extends GridVirtualizingCellRendererBase<Text, TextField> {
  /// Creates the [GridCellNumericTextFieldRenderer] for [SfDataGrid] widget.
  GridCellNumericTextFieldRenderer(_DataGridStateDetails dataGridStateDetails) {
    _dataGridStateDetails = dataGridStateDetails;
  }

  @override
  void setCellStyle(DataCellBase dataCell) {
    if (dataCell != null) {
      final _DataGridSettings dataGridSettings = _dataGridStateDetails();
      final currentRowIndex = _GridIndexResolver.resolveToRecordIndex(
          dataGridSettings, dataCell.rowIndex);
      // Need to skip if the rowIndex is < 0
      // It's applicable for when un-ensured row-columns comes for ensuring.
      if (currentRowIndex < 0) {
        return;
      }

      final cellValue = dataGridSettings.source
          .getCellValue(currentRowIndex, dataCell.gridColumn.mappingName);
      final numericValue = _getNumericValue(cellValue);
      dataCell
        ..cellValue = cellValue
        .._displayText = numericValue != null && !numericValue.isNaN
            ? dataCell.gridColumn.getFormattedValue(cellValue)
            : null;
      super.setCellStyle(dataCell);
    }
  }

  double _getNumericValue(Object cellValue) {
    if (cellValue == null) {
      return double.nan;
    }

    return double.tryParse(cellValue.toString());
  }
}
