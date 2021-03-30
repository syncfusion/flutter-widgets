part of datagrid;

/// A cell renderer which displays the header text in the
/// stacked columns of the stacked header rows.
class _GridStackedHeaderCellRenderer
    extends GridVirtualizingCellRendererBase<Widget, Widget> {
  /// Creates the [GridStackedHeaderCellRenderer] for [SfDataGrid] widget.
  _GridStackedHeaderCellRenderer(_DataGridStateDetails dataGridStateDetails) {
    _dataGridStateDetails = dataGridStateDetails;
  }

  @override
  void onInitializeDisplayWidget(DataCellBase dataCell) {
    final dataGridSettings = _dataGridStateDetails();
    final isLight =
        dataGridSettings.dataGridThemeData!.brightness == Brightness.light;
    Widget? label = DefaultTextStyle(
        style: isLight
            ? TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black87)
            : TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color.fromRGBO(255, 255, 255, 1)),
        child: dataCell._stackedHeaderCell!.child);

    dataCell._columnElement = GridCell(
      key: dataCell._key!,
      dataCell: dataCell,
      backgroundColor: isLight
          ? Color.fromRGBO(255, 255, 255, 1)
          : Color.fromRGBO(33, 33, 33, 1),
      isDirty: dataGridSettings.container._isDirty || dataCell._isDirty,
      child: label,
    );

    label = null;
  }
}
