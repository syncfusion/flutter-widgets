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
  void setCellStyle(DataCellBase? dataCell) {
    if (dataCell != null) {
      final _DataGridSettings dataGridSettings = _dataGridStateDetails();
      dataCell._textStyle = _getCellTextStyle(dataGridSettings, dataCell);
      super.setCellStyle(dataCell);
    }
  }

  TextStyle _getCellTextStyle(
      _DataGridSettings dataGridSettings, DataCellBase dataCell) {
    final DataRowBase? dataRow = dataCell._dataRow;
    if (dataRow != null && dataRow.isSelectedRow) {
      return dataGridSettings.dataGridThemeData!.brightness == Brightness.light
          ? TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: const Color.fromRGBO(0, 0, 0, 0.87))
          : TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: const Color.fromRGBO(255, 255, 255, 1));
    } else {
      return dataGridSettings.dataGridThemeData!.brightness == Brightness.light
          ? TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.black87)
          : TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color.fromRGBO(255, 255, 255, 1));
    }
  }
}
