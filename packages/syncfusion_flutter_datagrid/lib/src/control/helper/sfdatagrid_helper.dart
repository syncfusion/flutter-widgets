part of datagrid;

@protected
class _SfDataGridHelper {
  static _VisibleLinesCollection getVisibleLines(
      _DataGridSettings _dataGridSettings) {
    if (_dataGridSettings.textDirection == TextDirection.rtl) {
      _dataGridSettings.container.scrollColumns.markDirty();
    }

    return _dataGridSettings.container.scrollColumns
        .getVisibleLines(_dataGridSettings.textDirection == TextDirection.rtl);
  }

  static void scrollVertical(
      _DataGridSettings dataGridSettings, double verticalOffset) {
    final ScrollController verticalController =
        dataGridSettings.verticalController;

    if (verticalController == null || !verticalController.hasClients) {
      return;
    }

    verticalOffset =
        verticalOffset > verticalController.position.maxScrollExtent
            ? verticalController.position.maxScrollExtent
            : verticalOffset;
    verticalOffset = verticalOffset.isNegative
        ? verticalController.position.minScrollExtent
        : verticalOffset;
    dataGridSettings.verticalController.jumpTo(verticalOffset);
    dataGridSettings.container.updateScrollBars();
  }

  static void scrollHorizontal(
      _DataGridSettings dataGridSettings, double horizontalOffset) {
    final ScrollController horizontalController =
        dataGridSettings.horizontalController;

    if (horizontalController == null || !horizontalController.hasClients) {
      return;
    }

    horizontalOffset =
        horizontalOffset > horizontalController.position.maxScrollExtent
            ? horizontalController.position.maxScrollExtent
            : horizontalOffset;
    horizontalOffset = horizontalOffset.isNegative
        ? horizontalController.position.minScrollExtent
        : horizontalOffset;
    dataGridSettings.horizontalController.jumpTo(horizontalOffset);
    dataGridSettings.container.updateScrollBars();
  }
}
