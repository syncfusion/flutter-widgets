part of datagrid;

/// A cell renderer which displays the String value in the cell.
///
/// This renderer is typically used for [GridTextColumn].
class GridCellTextFieldRenderer<T1, T2>
    extends GridVirtualizingCellRendererBase<Text, TextField> {
  /// Creates the [GridCellTextFieldRenderer] for [SfDataGrid] widget.
  GridCellTextFieldRenderer(_DataGridStateDetails dataGridStateDetails) {
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

      dataCell
        .._displayText = dataGridSettings.source
            .getCellValue(currentRowIndex, dataCell.gridColumn.mappingName)
            ?.toString()
        ..cellValue = dataCell._displayText;
      super.setCellStyle(dataCell);
    }
  }
}
