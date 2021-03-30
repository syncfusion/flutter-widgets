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

  static Future<void> scrollVertical(
      _DataGridSettings dataGridSettings, double verticalOffset,
      [bool canAnimate = false]) async {
    final ScrollController? verticalController =
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

    if (canAnimate) {
      await dataGridSettings.verticalController!.animateTo(verticalOffset,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.fastOutSlowIn);
    } else {
      dataGridSettings.verticalController!.jumpTo(verticalOffset);
    }
    dataGridSettings.container.updateScrollBars();
  }

  static Future<void> scrollHorizontal(
      _DataGridSettings dataGridSettings, double horizontalOffset,
      [bool canAnimate = false]) async {
    final ScrollController? horizontalController =
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

    if (canAnimate) {
      await dataGridSettings.horizontalController!.animateTo(horizontalOffset,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.fastOutSlowIn);
    } else {
      dataGridSettings.horizontalController!.jumpTo(horizontalOffset);
    }
    dataGridSettings.container.updateScrollBars();
  }

  static bool canSwipeRow(_DataGridSettings dataGridSettings,
      DataGridRowSwipeDirection swipeDirection, double swipeOffset) {
    if (dataGridSettings.container.horizontalOffset == 0) {
      if ((dataGridSettings.container.extentWidth >
              dataGridSettings.viewWidth) &&
          swipeDirection == DataGridRowSwipeDirection.endToStart &&
          swipeOffset <= 0) {
        return false;
      } else {
        return true;
      }
    } else if (dataGridSettings.container.horizontalOffset ==
        dataGridSettings.container.extentWidth - dataGridSettings.viewWidth) {
      if ((dataGridSettings.container.extentWidth >
              dataGridSettings.viewWidth) &&
          swipeDirection == DataGridRowSwipeDirection.startToEnd &&
          swipeOffset >= 0) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  static DataGridRowSwipeDirection getSwipeDirection(
      _DataGridSettings dataGridSettings, double swipingOffset) {
    return swipingOffset >= 0
        ? dataGridSettings.textDirection == TextDirection.ltr
            ? DataGridRowSwipeDirection.startToEnd
            : DataGridRowSwipeDirection.endToStart
        : dataGridSettings.textDirection == TextDirection.ltr
            ? DataGridRowSwipeDirection.endToStart
            : DataGridRowSwipeDirection.startToEnd;
  }

  static DataGridRow getDataGridRow(
      _DataGridSettings dataGridSettings, int rowIndex) {
    final recordIndex =
        _GridIndexResolver.resolveToRecordIndex(dataGridSettings, rowIndex);
    return dataGridSettings.source._effectiveRows[recordIndex];
  }

  static DataGridRowAdapter? getDataGridRowAdapter(
      _DataGridSettings dataGridSettings, DataGridRow dataGridRow) {
    DataGridRowAdapter buildBlankRow(DataGridRow dataGridRow) {
      return DataGridRowAdapter(
          cells: dataGridSettings.columns
              .map<Widget>((dataCell) => SizedBox.fromSize(size: Size.zero))
              .toList());
    }

    return dataGridSettings.source.buildRow(dataGridRow) ??
        buildBlankRow(dataGridRow);
  }

  static bool debugCheckTheLength(
      int columnLength, int cellLength, String message) {
    assert(() {
      if (columnLength != cellLength) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('$message: is not true'),
        ]);
      }
      return true;
    }());
    return true;
  }
}
