part of datagrid;

@protected
class _SfDataGridHelper {
  /// Get the visible line based on view size and scroll offset.
  /// Based on the [TextDirection] it will return visible lines info.
  static _VisibleLinesCollection getVisibleLines(
      _DataGridSettings _dataGridSettings) {
    if (_dataGridSettings.textDirection == TextDirection.rtl) {
      _dataGridSettings.container.scrollColumns.markDirty();
    }

    return _dataGridSettings.container.scrollColumns
        .getVisibleLines(_dataGridSettings.textDirection == TextDirection.rtl);
  }

  /// Helps to scroll the [SfDataGrid] vertically.
  /// [canAnimate]: decide to apply animation on scrolling or not.
  static Future<void> scrollVertical(
      _DataGridSettings dataGridSettings, double verticalOffset,
      [bool canAnimate = false]) async {
    final ScrollController? verticalController =
        dataGridSettings.verticalScrollController;

    if (verticalController == null || !verticalController.hasClients) {
      return;
    }

    verticalOffset =
        verticalOffset > verticalController.position.maxScrollExtent
            ? verticalController.position.maxScrollExtent
            : verticalOffset;
    verticalOffset = verticalOffset.isNegative || verticalOffset == 0.0
        ? verticalController.position.minScrollExtent
        : verticalOffset;

    if (canAnimate) {
      await dataGridSettings.verticalScrollController!.animateTo(verticalOffset,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.fastOutSlowIn);
    } else {
      dataGridSettings.verticalScrollController!.jumpTo(verticalOffset);
    }
    dataGridSettings.container.updateScrollBars();
  }

  /// Helps to scroll the [SfDataGrid] horizontally.
  /// [canAnimate]: decide to apply animation on scrolling or not.
  static Future<void> scrollHorizontal(
      _DataGridSettings dataGridSettings, double horizontalOffset,
      [bool canAnimate = false]) async {
    final ScrollController? horizontalController =
        dataGridSettings.horizontalScrollController;

    if (horizontalController == null || !horizontalController.hasClients) {
      return;
    }

    horizontalOffset =
        horizontalOffset > horizontalController.position.maxScrollExtent
            ? horizontalController.position.maxScrollExtent
            : horizontalOffset;
    horizontalOffset = horizontalOffset.isNegative || horizontalOffset == 0.0
        ? horizontalController.position.minScrollExtent
        : horizontalOffset;

    if (canAnimate) {
      await dataGridSettings.horizontalScrollController!.animateTo(
          horizontalOffset,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.fastOutSlowIn);
    } else {
      dataGridSettings.horizontalScrollController!.jumpTo(horizontalOffset);
    }
    dataGridSettings.container.updateScrollBars();
  }

  /// Decide to enable swipe in [SfDataGrid]
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

  /// Decide the swipe direction based on [TextDirection].
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

  /// Helps to get the [DataGridRow] based on respective rowIndex.
  static DataGridRow getDataGridRow(
      _DataGridSettings dataGridSettings, int rowIndex) {
    final int recordIndex =
        _GridIndexResolver.resolveToRecordIndex(dataGridSettings, rowIndex);
    return dataGridSettings.source._effectiveRows[recordIndex];
  }

  /// Helps to get the [DataGridRowAdapter] based on respective [DataGridRow].
  static DataGridRowAdapter? getDataGridRowAdapter(
      _DataGridSettings dataGridSettings, DataGridRow dataGridRow) {
    DataGridRowAdapter buildBlankRow(DataGridRow dataGridRow) {
      return DataGridRowAdapter(
          cells: dataGridSettings.columns
              .map<Widget>(
                  (GridColumn dataCell) => SizedBox.fromSize(size: Size.zero))
              .toList());
    }

    return dataGridSettings.source.buildRow(dataGridRow) ??
        buildBlankRow(dataGridRow);
  }

  /// Check the length of two list.
  /// If its not satisfies it throw a exception.
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

  /// Return the cumulative distance of frozen top rows. The cumulative distance
  /// covered the header, stacked header and freeze pane
  static double getCumulativeFrozenRowsHeight(
      _DataGridSettings dataGridSettings) {
    final int topFrozenRowsLength = dataGridSettings.container.frozenRows;
    double cumulativeFrozenRowsHeight = 0.0;
    for (int index = 0; index < topFrozenRowsLength; index++) {
      cumulativeFrozenRowsHeight +=
          dataGridSettings.container.rowHeights[index];
    }
    return cumulativeFrozenRowsHeight;
  }

  /// Return the cumulative distance of frozen bottom rows.
  static double getCumulativeFooterFrozenRowsHeight(
      _DataGridSettings dataGridSettings) {
    final int bottomFrozenRowsLength =
        dataGridSettings.container.footerFrozenRows;
    double cumulativeFooterFrozenRowsHeight = 0.0;
    for (int index = 0; index < bottomFrozenRowsLength; index++) {
      final int rowIndex = dataGridSettings.container.rowCount - index;
      cumulativeFooterFrozenRowsHeight +=
          dataGridSettings.container.rowHeights[rowIndex];
    }
    return cumulativeFooterFrozenRowsHeight;
  }

  /// Return the cumulative distance of frozen column on left side. The
  /// cumulative distance covered the row header, indent cell, freeze pane
  static double getCumulativeFrozenColumnsWidth(
      _DataGridSettings dataGridSettings) {
    final int leftStaticColumnCount = dataGridSettings.container.frozenColumns;
    double cumulativeFrozenColumnWidth = 0.0;
    for (int index = 0; index < leftStaticColumnCount; index++) {
      cumulativeFrozenColumnWidth +=
          dataGridSettings.container.columnWidths[index];
    }
    return cumulativeFrozenColumnWidth;
  }

  /// Return the cumulative distance of frozen right side columns.
  static double getCumulativeFooterFrozenColumnsWidth(
      _DataGridSettings dataGridSettings) {
    final int rightStaticColumnCount =
        dataGridSettings.container.footerFrozenColumns;
    double cumulativeFooterFrozenColumnWidth = 0.0;
    for (int index = 0; index < rightStaticColumnCount; index++) {
      final int columnIndex = dataGridSettings.container.columnCount - index;
      cumulativeFooterFrozenColumnWidth +=
          dataGridSettings.container.columnWidths[columnIndex];
    }
    return cumulativeFooterFrozenColumnWidth;
  }

  /// Resolve the cumulative horizontal offset with frozen rows.
  static double resolveVerticalScrollOffset(
      _DataGridSettings dataGridSettings, double verticalOffset) {
    final double leftStaticOffset =
        _SfDataGridHelper.getCumulativeFrozenRowsHeight(dataGridSettings);
    final double rightStaticOffset =
        _SfDataGridHelper.getCumulativeFooterFrozenRowsHeight(dataGridSettings);
    final double bottomOffset =
        dataGridSettings.container.extentHeight - rightStaticOffset;
    if (verticalOffset >= bottomOffset) {
      return dataGridSettings
          .verticalScrollController!.position.maxScrollExtent;
    }

    if (verticalOffset <= leftStaticOffset) {
      return dataGridSettings
          .verticalScrollController!.position.minScrollExtent;
    }

    for (int i = 0; i < dataGridSettings.container.frozenRows; i++) {
      verticalOffset -= dataGridSettings.container.rowHeights[i];
    }

    return verticalOffset;
  }

  /// Resolve the cumulative horizontal offset with frozen column.
  static double resolveHorizontalScrollOffset(
      _DataGridSettings dataGridSettings, double horizontalOffset) {
    final double topStaticOffset =
        _SfDataGridHelper.getCumulativeFrozenColumnsWidth(dataGridSettings);
    final double bottomStaticOffset =
        _SfDataGridHelper.getCumulativeFooterFrozenColumnsWidth(
            dataGridSettings);
    final double rightOffset =
        dataGridSettings.container.extentWidth - bottomStaticOffset;
    if (horizontalOffset >= rightOffset) {
      return dataGridSettings
          .horizontalScrollController!.position.maxScrollExtent;
    }

    if (horizontalOffset <= topStaticOffset) {
      return dataGridSettings
          .horizontalScrollController!.position.minScrollExtent;
    }

    for (int i = 0; i < dataGridSettings.container.frozenColumns; i++) {
      horizontalOffset -= dataGridSettings.container.columnWidths[i];
    }

    return horizontalOffset;
  }

  /// Get the vertical offset with reduction of frozen rows
  static double getVerticalOffset(
      _DataGridSettings dataGridSettings, int rowIndex) {
    if (rowIndex < 0) {
      return dataGridSettings.container.verticalOffset;
    }

    final double cumulativeOffset =
        _SelectionHelper.getVerticalCumulativeDistance(
            dataGridSettings, rowIndex);

    return resolveVerticalScrollOffset(dataGridSettings, cumulativeOffset);
  }

  /// Get the vertical offset with reduction of frozen columns
  static double getHorizontalOffset(
      _DataGridSettings dataGridSettings, int columnIndex) {
    if (columnIndex < 0) {
      return dataGridSettings.container.horizontalOffset;
    }

    final double cumulativeOffset =
        _SelectionHelper.getHorizontalCumulativeDistance(
            dataGridSettings, columnIndex);

    return resolveHorizontalScrollOffset(dataGridSettings, cumulativeOffset);
  }

  /// Resolve the scroll offset to [DataGridScrollPosition].
  /// It's helps to get the position of rows and column scroll into desired
  /// DataGridScrollPosition.
  static double resolveScrollOffsetToPosition(
      DataGridScrollPosition position,
      _ScrollAxisBase scrollAxisBase,
      double measuredScrollOffset,
      double viewDimension,
      double headerExtent,
      double bottomExtent,
      double defaultDimension,
      double defaultScrollOffset,
      int index) {
    if (position == DataGridScrollPosition.center) {
      measuredScrollOffset = measuredScrollOffset -
          ((viewDimension - bottomExtent - headerExtent) / 2) +
          (defaultDimension / 2);
    } else if (position == DataGridScrollPosition.end) {
      measuredScrollOffset = measuredScrollOffset -
          (viewDimension - bottomExtent - headerExtent) +
          defaultDimension;
    } else if (position == DataGridScrollPosition.makeVisible) {
      final _VisibleLinesCollection visibleLines =
          scrollAxisBase.getVisibleLines();
      final int startIndex =
          visibleLines[visibleLines.firstBodyVisibleIndex].lineIndex;
      final int endIndex =
          visibleLines[visibleLines.lastBodyVisibleIndex].lineIndex;
      if (index > startIndex && index < endIndex) {
        measuredScrollOffset = defaultScrollOffset;
      }
      if (defaultScrollOffset - measuredScrollOffset < 0) {
        measuredScrollOffset = measuredScrollOffset -
            (viewDimension - bottomExtent - headerExtent) +
            defaultDimension;
      }
    }

    return measuredScrollOffset;
  }
}
