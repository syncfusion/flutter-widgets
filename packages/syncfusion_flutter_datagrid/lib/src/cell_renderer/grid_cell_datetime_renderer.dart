part of datagrid;

/// A cell renderer which displays the [DateTime] value in the cell.
///
/// This renderer is typically used for [GridDateTimeColumn].
class GridCellDateTimeRenderer<T1, T2>
    extends GridVirtualizingCellRendererBase<Text, Widget> {
  /// Creates the [GridCellDateTimeRenderer] for [SfDataGrid] widget.
  GridCellDateTimeRenderer(_DataGridStateDetails dataGridStateDetails) {
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
      final dateTimeValue = _getDateTimeValue(cellValue);
      dataCell
        ..cellValue = cellValue
        .._displayText = dateTimeValue != null
            ? dataCell.gridColumn.getFormattedValue(dateTimeValue)
            : null;
      super.setCellStyle(dataCell);
    }
  }

  DateTime _getDateTimeValue(Object cellValue) {
    if (cellValue == null) {
      return null;
    }
    return DateTime.tryParse(cellValue.toString());
  }
}
