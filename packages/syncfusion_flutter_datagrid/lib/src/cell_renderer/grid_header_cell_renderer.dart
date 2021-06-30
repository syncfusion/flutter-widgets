part of datagrid;

/// A cell renderer which displays the header text in the columns.
class GridHeaderCellRenderer
    extends GridVirtualizingCellRendererBase<Container, GridHeaderCell> {
  /// Creates the [GridHeaderCellRenderer] for [SfDataGrid] widget.
  GridHeaderCellRenderer(_DataGridStateDetails dataGridStateDetails) {
    _dataGridStateDetails = dataGridStateDetails;
  }

  @override
  void onInitializeDisplayWidget(DataCellBase dataCell) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    final Widget child = dataCell.gridColumn!.label;
    dataCell._columnElement = GridHeaderCell(
      key: dataCell._key!,
      dataCell: dataCell,
      child: DefaultTextStyle(
          key: dataCell._key, style: dataCell._textStyle!, child: child),
      backgroundColor: Colors.transparent,
      isDirty: dataGridSettings.container._isDirty ||
          dataCell._isDirty ||
          dataCell._dataRow!._isDirty,
    );
  }

  @override
  void setCellStyle(DataCellBase dataCell) {
    final SfDataGridThemeData themeData =
        _dataGridStateDetails().dataGridThemeData!;
    TextStyle getDefaultHeaderTextStyle() {
      return themeData.brightness == Brightness.light
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
    }

    dataCell._textStyle = getDefaultHeaderTextStyle();
  }
}
