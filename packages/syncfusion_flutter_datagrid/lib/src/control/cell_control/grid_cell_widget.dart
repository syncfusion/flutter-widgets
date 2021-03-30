part of datagrid;

/// A widget which displays in the cells.
class GridCell extends StatefulWidget {
  /// Creates the [GridCell] for [SfDataGrid] widget.
  const GridCell({
    required Key key,
    required this.dataCell,
    required this.isDirty,
    required this.backgroundColor,
    required this.child,
  }) : super(key: key);

  /// Holds the information required to display the cell.
  final DataCellBase dataCell;

  /// The [child] contained by the [GridCell].
  final Widget child;

  /// The color to paint behind the [child].
  final Color backgroundColor;

  /// Decides whether the [GridCell] should be refreshed when [SfDataGrid] is
  /// rebuild.
  final bool isDirty;

  @override
  State<StatefulWidget> createState() => _GridCellState();
}

class _GridCellState extends State<GridCell> {
  late PointerDeviceKind _kind;

  void _handleOnTapDown(TapDownDetails details) {
    _kind = details.kind!;
  }

  Widget _wrapInsideGestureDetector() {
    final dataCell = widget.dataCell;
    final _DataGridSettings? dataGridSettings =
        dataCell._dataRow!._dataGridStateDetails!();
    return GestureDetector(
      onTapUp: (details) {
        _handleOnTapUp(
            tapUpDetails: details,
            dataGridSettings: dataGridSettings!,
            dataCell: dataCell,
            kind: _kind);
      },
      onTapDown: _handleOnTapDown,
      onDoubleTap: dataGridSettings!.onCellDoubleTap != null
          ? () {
              _handleOnDoubleTap(
                  dataCell: dataCell, dataGridSettings: dataGridSettings);
            }
          : null,
      onLongPressEnd: (details) {
        _handleOnLongPressEnd(
            longPressEndDetails: details,
            dataGridSettings: dataGridSettings,
            dataCell: dataCell);
      },
      onSecondaryTapUp: (details) {
        _handleOnSecondaryTapUp(
            tapUpDetails: details,
            dataGridSettings: dataGridSettings,
            dataCell: dataCell,
            kind: _kind);
      },
      onSecondaryTapDown: _handleOnTapDown,
      child: _wrapInsideContainer(),
    );
  }

  Widget _wrapInsideContainer() => Container(
      key: widget.key,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(border: _getCellBorder(widget.dataCell)),
      alignment: Alignment.center,
      child: _wrapInsideCellContainer(
        child: widget.child,
        dataCell: widget.dataCell,
        key: widget.key!,
        backgroundColor: widget.backgroundColor,
      ));

  @override
  Widget build(BuildContext context) {
    final Widget child = Semantics(
      label: widget.dataCell.cellValue.toString(),
      child: _wrapInsideGestureDetector(),
    );

    return _GridCellRenderObjectWidget(
      key: widget.key,
      dataCell: widget.dataCell,
      isDirty: widget.isDirty,
      child: child,
    );
  }
}

class _GridCellRenderObjectWidget extends SingleChildRenderObjectWidget {
  _GridCellRenderObjectWidget(
      {required Key? key,
      required this.dataCell,
      required this.isDirty,
      required this.child})
      : super(key: key, child: RepaintBoundary.wrap(child, 0));

  @override
  final Widget child;
  final DataCellBase dataCell;
  final bool isDirty;

  @override
  _RenderGridCell createRenderObject(BuildContext context) => _RenderGridCell(
        dataCell: dataCell,
        isDirty: isDirty,
      );

  @override
  void updateRenderObject(BuildContext context, _RenderGridCell renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..isDirty = isDirty
      ..dataCell = dataCell;
  }
}

class _RenderGridCell extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  _RenderGridCell(
      {RenderBox? child, required DataCellBase dataCell, required bool isDirty})
      : _dataCell = dataCell,
        _isDirty = isDirty {
    this.child = child;
  }

  DataCellBase get dataCell => _dataCell;
  DataCellBase _dataCell;

  set dataCell(DataCellBase newDataColumn) {
    if (_dataCell == newDataColumn) {
      return;
    }

    _dataCell = newDataColumn;
    markNeedsLayout();
    markNeedsPaint();
  }

  bool get isDirty => _isDirty;
  bool _isDirty = false;

  set isDirty(bool newValue) {
    _isDirty = newValue;
    if (_isDirty) {
      markNeedsLayout();
      markNeedsPaint();
    }

    dataCell._isDirty = false;
  }

  Rect? columnRect = Rect.zero;

  Rect? cellClipRect;

  Rect? _measureColumnRect(double rowHeight) {
    if (dataCell._dataRow != null &&
        dataCell._dataRow!.isVisible &&
        dataCell.isVisible) {
      final DataRowBase dataRow = dataCell._dataRow!;
      final _DataGridSettings _dataGridSettings =
          dataRow._dataGridStateDetails!();
      final double lineWidth = dataRow._getColumnWidth(
          dataCell.columnIndex, dataCell.columnIndex + dataCell._columnSpan);
      final double lineHeight = dataRow._getRowHeight(
          dataCell.rowIndex - dataCell._rowSpan, dataCell.rowIndex);

      if (dataRow.rowType == RowType.stackedHeaderRow) {
        columnRect =
            _getStackedHeaderCellRect(_dataGridSettings, lineWidth, lineHeight);
      } else {
        final _VisibleLineInfo? lineInfo =
            dataRow._getColumnVisibleLineInfo(dataCell.columnIndex);
        final double origin = lineInfo != null ? lineInfo.origin : 0.0;
        columnRect = _getCellRect(
            _dataGridSettings, lineInfo, origin, lineWidth, lineHeight);
      }
    } else {
      columnRect = Rect.zero;
    }

    return columnRect;
  }

  Rect? _getCellRect(
      _DataGridSettings dataGridSettings,
      _VisibleLineInfo? lineInfo,
      double origin,
      double lineWidth,
      double lineHeight) {
    final DataRowBase dataRow = dataCell._dataRow!;
    final int rowIndex = dataCell.rowIndex;
    final int rowSpan = dataCell._rowSpan;

    origin += dataGridSettings.container.horizontalOffset;

    // To overcome grid common RightToLeft clipping line creation problem
    // instead of handling in grid common source.
    if (dataGridSettings.textDirection == TextDirection.rtl &&
        lineInfo != null &&
        lineInfo.visibleIndex ==
            _SfDataGridHelper.getVisibleLines(dataRow._dataGridStateDetails!())
                .firstBodyVisibleIndex) {
      origin += lineInfo.scrollOffset;
    }

    if (dataCell._cellType != CellType.stackedHeaderCell) {
      // Clipping the column when frozen column applied
      cellClipRect = _getCellClipRect(dataGridSettings, lineInfo, lineHeight);
    }

    final topPosition = (rowSpan > 0)
        ? -dataRow._getRowHeight(rowIndex - rowSpan, rowIndex - 1)
        : 0.0;

    columnRect = Rect.fromLTWH(origin, topPosition, lineWidth, lineHeight);
    return columnRect;
  }

  Rect? _getStackedHeaderCellRect(
      _DataGridSettings dataGridSettings, double lineWidth, double lineHeight) {
    final DataRowBase dataRow = dataCell._dataRow!;
    final int cellStartIndex = dataCell.columnIndex;
    final int columnSpan = dataCell._columnSpan;
    final int cellEndIndex = cellStartIndex + columnSpan;
    final int frozenColumns = dataGridSettings.container.frozenColumns;
    final int frozenColumnsCount = dataGridSettings.frozenColumnsCount;
    final int footerFrozenColumns =
        dataGridSettings.container.footerFrozenColumns;
    final int footerFrozenColumnsCount =
        dataGridSettings.footerFrozenColumnsCount;
    final int columnsLength = dataGridSettings.columns.length;
    final _ScrollAxisBase scrollColumns =
        dataGridSettings.container.scrollColumns;
    Rect? columnRect = Rect.zero;
    double? origin;
    _VisibleLineInfo? lineInfo;

    if (frozenColumns > cellStartIndex && frozenColumns <= cellEndIndex) {
      if (dataGridSettings.textDirection == TextDirection.ltr) {
        for (int index = cellEndIndex;
            index >= frozenColumnsCount - 1;
            index--) {
          lineInfo = scrollColumns.getVisibleLineAtLineIndex(index);
          if (lineInfo != null) {
            final _VisibleLineInfo? startLineInfo =
                scrollColumns.getVisibleLineAtLineIndex(cellStartIndex);
            origin = startLineInfo?.origin;
            lineWidth = _getClippedWidth(
                dataGridSettings, cellStartIndex, cellEndIndex);
            break;
          }
        }
      } else {
        for (int index = cellEndIndex; index >= cellStartIndex; index--) {
          lineInfo = scrollColumns.getVisibleLineAtLineIndex(index);
          if (lineInfo != null) {
            origin = lineInfo.origin < 0 ? 0.0 : lineInfo.origin;
            lineWidth = _getClippedWidth(
                dataGridSettings, cellStartIndex, cellEndIndex);
            if (lineInfo.origin < 0) {
              lineWidth += lineInfo.origin;
            }
            break;
          }
        }
      }
    } else if (footerFrozenColumns > 0 &&
        columnsLength - footerFrozenColumnsCount <= cellEndIndex) {
      int span = 0;
      if (dataGridSettings.textDirection == TextDirection.ltr) {
        for (int index = cellStartIndex; index <= cellEndIndex; index++) {
          lineInfo = scrollColumns.getVisibleLineAtLineIndex(index);
          if (lineInfo != null) {
            if (index == columnsLength - footerFrozenColumns) {
              origin = lineInfo.origin;
              lineWidth =
                  dataRow._getColumnWidth(cellStartIndex + span, cellEndIndex);
              break;
            } else {
              origin = lineInfo.clippedOrigin;
              lineWidth = _getClippedWidth(
                  dataGridSettings, cellStartIndex, cellEndIndex);
              break;
            }
          }
          span += 1;
        }
      } else {
        var span = 0;
        for (int index = cellStartIndex; index <= cellEndIndex; index++) {
          lineInfo = scrollColumns.getVisibleLineAtLineIndex(index);
          if (lineInfo != null) {
            final _VisibleLineInfo? line =
                scrollColumns.getVisibleLineAtLineIndex(cellEndIndex);
            if (line != null) {
              if (index == columnsLength - footerFrozenColumnsCount) {
                origin = line.origin;
                lineWidth = dataRow._getColumnWidth(
                    cellStartIndex + span, cellEndIndex);
                break;
              } else {
                origin = line.clippedOrigin - lineInfo.scrollOffset;
                lineWidth = _getClippedWidth(
                    dataGridSettings, cellStartIndex, cellEndIndex);
                break;
              }
            }
          }
          span += 1;
        }
      }
    } else {
      var span = dataCell._columnSpan;
      if (dataGridSettings.textDirection == TextDirection.ltr) {
        for (int index = cellStartIndex; index <= cellEndIndex; index++) {
          lineInfo = dataRow._getColumnVisibleLineInfo(index);
          if (lineInfo != null) {
            origin = lineInfo.origin +
                dataRow._getColumnWidth(index, index + span) -
                dataRow._getColumnWidth(cellStartIndex, cellEndIndex);

            cellClipRect = _getSpannedCellClipRect(
                dataGridSettings, dataRow, dataCell, lineHeight, lineWidth);
            break;
          }
          span -= 1;
        }
      } else {
        for (int index = cellEndIndex; index >= cellStartIndex; index--) {
          lineInfo = dataRow._getColumnVisibleLineInfo(index);
          if (lineInfo != null) {
            origin = lineInfo.origin +
                dataRow._getColumnWidth(index - span, index) -
                dataRow._getColumnWidth(cellStartIndex, cellEndIndex);

            cellClipRect = _getSpannedCellClipRect(
                dataGridSettings, dataRow, dataCell, lineHeight, lineWidth);
            break;
          }
          span -= 1;
        }
      }
    }

    if (lineInfo != null) {
      columnRect = _getCellRect(
          dataGridSettings, lineInfo, origin!, lineWidth, lineHeight);
    }
    return columnRect;
  }

  double _getClippedWidth(
      _DataGridSettings dataGridSettings, int startIndex, int endIndex) {
    double clippedWidth = 0;
    for (int index = startIndex; index <= endIndex; index++) {
      final newline = dataCell._dataRow!._getColumnVisibleLineInfo(index);
      if (newline != null) {
        if (dataGridSettings.textDirection == TextDirection.ltr) {
          clippedWidth +=
              newline.isClipped ? newline.clippedSize : newline.size;
        } else {
          clippedWidth += newline.isClipped
              ? newline.clippedCornerExtent > 0
                  ? newline.clippedCornerExtent
                  : newline.clippedSize
              : newline.size;
        }
      }
    }
    return clippedWidth;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    if (child == null) {
      return false;
    }

    final BoxParentData childParentData = child!.parentData as BoxParentData;
    final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (result, transformed) =>
            child!.hitTest(result, position: transformed));
    if (isHit) {
      return true;
    } else {
      return false;
    }
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool get isRepaintBoundary => true;

  @override
  void performLayout() {
    size = constraints
        .constrain(Size(constraints.maxWidth, constraints.maxHeight));

    if (child != null) {
      child!.layout(
          BoxConstraints.tightFor(
              width: constraints.maxWidth, height: constraints.maxHeight),
          parentUsesSize: true);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      context.paintChild(child!, offset);
    }

    super.paint(context, offset);
  }
}

BorderDirectional _getCellBorder(DataCellBase dataCell) {
  final _DataGridSettings dataGridSettings =
      dataCell._dataRow!._dataGridStateDetails!();
  final Color borderColor = dataGridSettings.dataGridThemeData!.gridLineColor;
  final borderWidth = dataGridSettings.dataGridThemeData!.gridLineStrokeWidth;

  final rowIndex = (dataCell._rowSpan > 0)
      ? dataCell.rowIndex - dataCell._rowSpan
      : dataCell.rowIndex;
  final columnIndex = dataCell.columnIndex;
  final isStackedHeaderCell = dataCell._cellType == CellType.stackedHeaderCell;
  final isHeaderCell = dataCell._cellType == CellType.headerCell;

  final bool canDrawHeaderHorizontalBorder =
      ((dataGridSettings.headerGridLinesVisibility ==
                  GridLinesVisibility.horizontal ||
              dataGridSettings.headerGridLinesVisibility ==
                  GridLinesVisibility.both) &&
          (isHeaderCell || isStackedHeaderCell));

  final bool canDrawHeaderVerticalBorder =
      ((dataGridSettings.headerGridLinesVisibility ==
                  GridLinesVisibility.vertical ||
              dataGridSettings.headerGridLinesVisibility ==
                  GridLinesVisibility.both) &&
          (isHeaderCell || isStackedHeaderCell));

  final bool canDrawHorizontalBorder = ((dataGridSettings.gridLinesVisibility ==
              GridLinesVisibility.horizontal ||
          dataGridSettings.gridLinesVisibility == GridLinesVisibility.both) &&
      !isHeaderCell &&
      !isStackedHeaderCell);

  final bool canDrawVerticalBorder = ((dataGridSettings.gridLinesVisibility ==
              GridLinesVisibility.vertical ||
          dataGridSettings.gridLinesVisibility == GridLinesVisibility.both) &&
      !isStackedHeaderCell &&
      !isHeaderCell);

  // Frozen column and row checking
  final bool canDrawBottomFrozenBorder = dataGridSettings
          .frozenRowsCount.isFinite &&
      dataGridSettings.frozenRowsCount > 0 &&
      _GridIndexResolver.getLastFrozenRowIndex(dataGridSettings) == rowIndex;

  final bool canDrawTopFrozenBorder =
      dataGridSettings.footerFrozenRowsCount.isFinite &&
          dataGridSettings.footerFrozenRowsCount > 0 &&
          _GridIndexResolver.getStartFooterFrozenRowIndex(dataGridSettings) ==
              rowIndex;

  final bool canDrawRightFrozenBorder =
      dataGridSettings.frozenColumnsCount.isFinite &&
          dataGridSettings.frozenColumnsCount > 0 &&
          _GridIndexResolver.getLastFrozenColumnIndex(dataGridSettings) ==
              columnIndex;

  final bool canDrawLeftFrozenBorder = dataGridSettings
          .footerFrozenColumnsCount.isFinite &&
      dataGridSettings.footerFrozenColumnsCount > 0 &&
      _GridIndexResolver.getStartFooterFrozenColumnIndex(dataGridSettings) ==
          columnIndex;

  final bool isFrozenPaneElevationApplied =
      (dataGridSettings.dataGridThemeData!.frozenPaneElevation > 0.0);

  final Color frozenPaneLineColor =
      dataGridSettings.dataGridThemeData!.frozenPaneLineColor;

  final double frozenPaneLineWidth =
      dataGridSettings.dataGridThemeData!.frozenPaneLineWidth;

  BorderSide _getLeftBorder() {
    if ((columnIndex == 0 &&
            (canDrawVerticalBorder || canDrawHeaderVerticalBorder)) ||
        canDrawLeftFrozenBorder) {
      if (canDrawLeftFrozenBorder &&
          !isStackedHeaderCell &&
          !isFrozenPaneElevationApplied) {
        return BorderSide(
            width: frozenPaneLineWidth, color: frozenPaneLineColor);
      } else if ((canDrawVerticalBorder || canDrawHeaderVerticalBorder) &&
          !canDrawLeftFrozenBorder) {
        return BorderSide(width: borderWidth, color: borderColor);
      } else {
        return BorderSide.none;
      }
    } else {
      return BorderSide.none;
    }
  }

  BorderSide _getTopBorder() {
    if ((rowIndex == 0 &&
            (canDrawHorizontalBorder || canDrawHeaderHorizontalBorder)) ||
        canDrawTopFrozenBorder) {
      if (canDrawTopFrozenBorder &&
          !isStackedHeaderCell &&
          !isFrozenPaneElevationApplied) {
        return BorderSide(
            width: frozenPaneLineWidth, color: frozenPaneLineColor);
      } else if (!canDrawTopFrozenBorder) {
        return BorderSide(width: borderWidth, color: borderColor);
      } else {
        return BorderSide.none;
      }
    } else {
      return BorderSide.none;
    }
  }

  BorderSide _getRightBorder() {
    if (canDrawVerticalBorder ||
        canDrawHeaderVerticalBorder ||
        canDrawRightFrozenBorder) {
      if (canDrawRightFrozenBorder &&
          !isStackedHeaderCell &&
          !isFrozenPaneElevationApplied) {
        return BorderSide(
            width: frozenPaneLineWidth, color: frozenPaneLineColor);
      } else if ((canDrawVerticalBorder || canDrawHeaderVerticalBorder) &&
          !canDrawRightFrozenBorder) {
        return BorderSide(width: borderWidth, color: borderColor);
      } else {
        return BorderSide.none;
      }
    } else {
      return BorderSide.none;
    }
  }

  BorderSide _getBottomBorder() {
    if (canDrawHorizontalBorder ||
        canDrawHeaderHorizontalBorder ||
        canDrawBottomFrozenBorder) {
      if (canDrawBottomFrozenBorder &&
          !isStackedHeaderCell &&
          !isFrozenPaneElevationApplied) {
        return BorderSide(
            width: frozenPaneLineWidth, color: frozenPaneLineColor);
      } else if (!canDrawBottomFrozenBorder) {
        return BorderSide(width: borderWidth, color: borderColor);
      } else {
        return BorderSide.none;
      }
    } else {
      return BorderSide.none;
    }
  }

  return BorderDirectional(
    start: _getLeftBorder(),
    top: _getTopBorder(),
    end: _getRightBorder(),
    bottom: _getBottomBorder(),
  );
}

Widget _wrapInsideCellContainer(
    {required DataCellBase dataCell,
    required Key key,
    required Color backgroundColor,
    required Widget child}) {
  final _DataGridSettings? dataGridSettings =
      dataCell._dataRow!._dataGridStateDetails!();
  if (dataGridSettings == null) {
    return child;
  }

  final color =
      dataGridSettings.dataGridThemeData!.currentCellStyle.borderColor;
  final borderWidth =
      dataGridSettings.dataGridThemeData!.currentCellStyle.borderWidth;

  Border getBorder() {
    final isCurrentCell = dataCell.isCurrentCell;
    return Border(
      bottom: isCurrentCell
          ? BorderSide(color: color, width: borderWidth)
          : BorderSide.none,
      left: isCurrentCell
          ? BorderSide(color: color, width: borderWidth)
          : BorderSide.none,
      top: isCurrentCell
          ? BorderSide(color: color, width: borderWidth)
          : BorderSide.none,
      right: isCurrentCell
          ? BorderSide(color: color, width: borderWidth)
          : BorderSide.none,
    );
  }

  double getCellHeight(DataCellBase dataCell, double defaultHeight) {
    double height;
    if (dataCell._rowSpan > 0) {
      height = dataCell._dataRow!._getRowHeight(
          dataCell.rowIndex - dataCell._rowSpan, dataCell.rowIndex);
    } else {
      height = defaultHeight;
    }
    return height;
  }

  double getCellWidth(DataCellBase dataCell, double defaultWidth) {
    double width;
    if (dataCell._columnSpan > 0) {
      width = dataCell._dataRow!._getColumnWidth(
          dataCell.columnIndex, dataCell.columnIndex + dataCell._columnSpan);
    } else {
      width = defaultWidth;
    }
    return width;
  }

  Widget getChild(BoxConstraints constraint) {
    final double width = getCellWidth(dataCell, constraint.maxWidth);
    final double height = getCellHeight(dataCell, constraint.maxHeight);

    if (dataCell.isCurrentCell) {
      return Stack(
        children: [
          Container(width: width, height: height, child: child),
          Positioned(
              left: 0,
              top: 0,
              width: width,
              height: height,
              child: IgnorePointer(
                ignoring: true,
                child: Container(
                    key: key,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: backgroundColor, border: getBorder())),
              )),
        ],
      );
    } else {
      return Container(width: width, height: height, child: child);
    }
  }

  return LayoutBuilder(builder: (context, constraint) {
    return getChild(constraint);
  });
}

Rect? _getCellClipRect(_DataGridSettings _dataGridSettings,
    _VisibleLineInfo? lineInfo, double rowHeight) {
  // FLUT-1971 Need to check whether the lineInfo is null or not. Because it
  // will be null when load empty to the columns collection.
  if (lineInfo == null) {
    return null;
  }
  if (lineInfo.isClippedBody &&
      lineInfo.isClippedOrigin &&
      lineInfo.isClippedCorner) {
    final double left = _dataGridSettings.textDirection == TextDirection.ltr
        ? lineInfo.size - lineInfo.clippedSize - lineInfo.clippedCornerExtent
        : lineInfo.clippedSize;
    final double right = _dataGridSettings.textDirection == TextDirection.ltr
        ? lineInfo.clippedSize
        : lineInfo.clippedCornerExtent;

    return Rect.fromLTWH(left, 0.0, right, rowHeight);
  } else if (lineInfo.isClippedBody && lineInfo.isClippedOrigin) {
    final double left = _dataGridSettings.textDirection == TextDirection.ltr
        ? lineInfo.size - lineInfo.clippedSize - lineInfo.clippedCornerExtent
        : 0.0;
    final double right = _dataGridSettings.textDirection == TextDirection.ltr
        ? lineInfo.size
        : lineInfo.size - lineInfo.scrollOffset;

    return Rect.fromLTWH(left, 0.0, right, rowHeight);
  } else if (lineInfo.isClippedBody && lineInfo.isClippedCorner) {
    final double left = _dataGridSettings.textDirection == TextDirection.ltr
        ? 0.0
        : lineInfo.size - (lineInfo.size - lineInfo.clippedSize);
    final double right = _dataGridSettings.textDirection == TextDirection.ltr
        ? lineInfo.clippedSize
        : lineInfo.size;

    return Rect.fromLTWH(left, 0.0, right, rowHeight);
  } else {
    return null;
  }
}

Rect? _getSpannedCellClipRect(
    _DataGridSettings dataGridSettings,
    DataRowBase dataRow,
    DataCellBase dataCell,
    double cellHeight,
    double cellWidth) {
  Rect? clipRect;
  var firstVisibleStackedColumnIndex = dataCell.columnIndex;
  double lastCellClippedSize = 0.0;
  var isLastCellClippedCorner = false;
  var isLastCellClippedBody = false;

  double getClippedWidth(DataCellBase dataCell, DataRowBase dataRow,
      {bool columnsNotInViewWidth = false, bool allCellsClippedWidth = false}) {
    final startIndex = dataCell.columnIndex;
    final endIndex = dataCell.columnIndex + dataCell._columnSpan;
    double clippedWidth = 0;
    for (int index = startIndex; index <= endIndex; index++) {
      final newline = dataRow._getColumnVisibleLineInfo(index);
      if (columnsNotInViewWidth) {
        if (newline == null) {
          clippedWidth +=
              dataGridSettings.container.scrollColumns.getLineSize(index);
        } else {
          firstVisibleStackedColumnIndex = index;
          break;
        }
      }
      if (allCellsClippedWidth) {
        if (newline != null) {
          if (dataGridSettings.textDirection == TextDirection.ltr) {
            clippedWidth +=
                newline.isClipped ? newline.clippedSize : newline.size;
          } else {
            clippedWidth += newline.isClipped
                ? newline.clippedCornerExtent > 0
                    ? newline.clippedCornerExtent
                    : newline.clippedSize
                : newline.size;
          }
          lastCellClippedSize = newline.clippedSize;
          isLastCellClippedCorner = newline.isClippedCorner;
          isLastCellClippedBody = newline.isClippedBody;
        }
      }
    }
    return clippedWidth;
  }

  if (dataGridSettings.frozenColumnsCount < 0 ||
      dataGridSettings.footerFrozenColumnsCount < 0) {
    return null;
  }

  if (dataCell._renderer != null) {
    final columnsNotInViewWidth =
        getClippedWidth(dataCell, dataRow, columnsNotInViewWidth: true);
    final clippedWidth =
        getClippedWidth(dataCell, dataRow, allCellsClippedWidth: true);
    final visibleLineInfo =
        dataRow._getColumnVisibleLineInfo(firstVisibleStackedColumnIndex);

    if (visibleLineInfo != null) {
      if (visibleLineInfo.isClippedOrigin && visibleLineInfo.isClippedCorner) {
        final clippedOrigin = columnsNotInViewWidth +
            visibleLineInfo.size -
            (visibleLineInfo.clippedSize + visibleLineInfo.clippedCornerExtent);

        final double left = dataGridSettings.textDirection == TextDirection.ltr
            ? clippedOrigin
            : visibleLineInfo.clippedSize;
        final double right = dataGridSettings.textDirection == TextDirection.ltr
            ? clippedWidth
            : visibleLineInfo.clippedCornerExtent;

        clipRect = Rect.fromLTWH(left, 0.0, right, cellHeight);
      } else if (visibleLineInfo.isClippedOrigin) {
        final clippedOriginLTR = columnsNotInViewWidth +
            visibleLineInfo.size -
            visibleLineInfo.clippedSize;
        final clippedOriginRTL =
            (isLastCellClippedCorner && isLastCellClippedBody)
                ? lastCellClippedSize
                : 0.0;

        final double left = dataGridSettings.textDirection == TextDirection.ltr
            ? clippedOriginLTR
            : clippedOriginRTL;
        final double right = dataGridSettings.textDirection == TextDirection.ltr
            ? clippedWidth
            : cellWidth -
                (columnsNotInViewWidth + visibleLineInfo.scrollOffset);

        clipRect = Rect.fromLTWH(left, 0.0, right, cellHeight);
      } else if (isLastCellClippedCorner && isLastCellClippedBody) {
        final double left = dataGridSettings.textDirection == TextDirection.ltr
            ? columnsNotInViewWidth
            : dataCell.columnIndex < firstVisibleStackedColumnIndex
                ? 0.0
                : cellWidth - clippedWidth;
        final double right = dataGridSettings.textDirection == TextDirection.ltr
            ? clippedWidth
            : cellWidth;

        clipRect = Rect.fromLTWH(left, 0.0, right, cellHeight);
      } else {
        if (clippedWidth < cellWidth) {
          double left;
          if (dataCell.columnIndex < firstVisibleStackedColumnIndex) {
            left = dataGridSettings.textDirection == TextDirection.ltr
                ? cellWidth - clippedWidth
                : 0.0;
          } else {
            left = dataGridSettings.textDirection == TextDirection.ltr
                ? 0.0
                : cellWidth - clippedWidth;
          }

          clipRect = Rect.fromLTWH(left, 0.0, clippedWidth, cellHeight);
        } else if (clipRect != null) {
          clipRect = null;
        }
      }
    }
  }
  return clipRect;
}

// Gesture Events

void _handleOnTapUp(
    {required TapUpDetails tapUpDetails,
    required DataCellBase dataCell,
    required _DataGridSettings dataGridSettings,
    required PointerDeviceKind kind}) {
  if (dataGridSettings.onCellTap != null) {
    final DataGridCellTapDetails details = DataGridCellTapDetails(
        rowColumnIndex: RowColumnIndex(dataCell.rowIndex, dataCell.columnIndex),
        column: dataCell.gridColumn!,
        globalPosition: tapUpDetails.globalPosition,
        localPosition: tapUpDetails.localPosition,
        kind: kind);
    dataGridSettings.onCellTap!(details);
  }

  dataGridSettings.dataGridFocusNode?.requestFocus();
  dataCell._onTouchUp();
}

void _handleOnDoubleTap(
    {required DataCellBase dataCell,
    required _DataGridSettings dataGridSettings}) {
  if (dataGridSettings.onCellDoubleTap != null) {
    final DataGridCellDoubleTapDetails details = DataGridCellDoubleTapDetails(
        rowColumnIndex: RowColumnIndex(dataCell.rowIndex, dataCell.columnIndex),
        column: dataCell.gridColumn!);
    dataGridSettings.onCellDoubleTap!(details);
  }

  dataGridSettings.dataGridFocusNode?.requestFocus();
  dataCell._onTouchUp();
}

void _handleOnLongPressEnd(
    {required LongPressEndDetails longPressEndDetails,
    required DataCellBase dataCell,
    required _DataGridSettings dataGridSettings}) {
  if (dataGridSettings.onCellLongPress != null) {
    final DataGridCellLongPressDetails details = DataGridCellLongPressDetails(
        rowColumnIndex: RowColumnIndex(dataCell.rowIndex, dataCell.columnIndex),
        column: dataCell.gridColumn!,
        globalPosition: longPressEndDetails.globalPosition,
        localPosition: longPressEndDetails.localPosition,
        velocity: longPressEndDetails.velocity);
    dataGridSettings.onCellLongPress!(details);
  }
}

void _handleOnSecondaryTapUp(
    {required TapUpDetails tapUpDetails,
    required DataCellBase dataCell,
    required _DataGridSettings dataGridSettings,
    required PointerDeviceKind kind}) {
  if (dataGridSettings.onCellSecondaryTap != null) {
    final DataGridCellTapDetails details = DataGridCellTapDetails(
        rowColumnIndex: RowColumnIndex(dataCell.rowIndex, dataCell.columnIndex),
        column: dataCell.gridColumn!,
        globalPosition: tapUpDetails.globalPosition,
        localPosition: tapUpDetails.localPosition,
        kind: kind);
    dataGridSettings.onCellSecondaryTap!(details);
  }
}
