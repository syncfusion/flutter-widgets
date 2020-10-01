part of datagrid;

/// A widget which displays in the cells.
class GridCell extends StatefulWidget {
  /// Creates the [GridCell] for [SfDataGrid] widget.
  const GridCell({
    @required Key key,
    this.dataCell,
    this.padding,
    this.backgroundColor,
    this.isDirty,
    this.child,
    this.alignment,
  }) : super(key: key);

  /// Holds the information required to display the cell.
  final DataCellBase dataCell;

  /// The [child] contained by the [GridCell].
  final Widget child;

  /// Empty space to inscribe inside the [GridCell].
  final EdgeInsets padding;

  /// The color to paint behind the [child].
  final Color backgroundColor;

  /// Decides whether the [GridCell] should be refreshed when [SfDataGrid] is
  /// rebuild.
  final bool isDirty;

  /// Align the [child] within the GridCell.
  final Alignment alignment;

  @override
  State<StatefulWidget> createState() => _GridCellState();
}

class _GridCellState extends State<GridCell> {
  PointerDeviceKind _kind;

  void _handleOnTapDown(TapDownDetails details) {
    _kind = details?.kind;
  }

  Widget _wrapInsideGestureDetector() {
    final dataCell = widget.dataCell;
    final _DataGridSettings dataGridSettings =
        dataCell?._dataRow?._dataGridStateDetails();
    return GestureDetector(
      onTapUp: (details) {
        _handleOnTapUp(
            tapUpDetails: details,
            dataGridSettings: dataGridSettings,
            dataCell: dataCell,
            kind: _kind);
      },
      onTapDown: _handleOnTapDown,
      onDoubleTap: dataGridSettings.onCellDoubleTap != null
          ? () {
              _handleOnDoubleTap(dataCell: dataCell);
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
        key: widget.key,
        backgroundColor: widget.backgroundColor,
        alignment: widget.alignment,
        padding: widget.padding,
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

/// A widget which loads any widget in the cells.
///
/// This widget is typically used for [GridWidgetColumn].
class GridWidgetCell extends GridCell {
  /// Creates the [GridWidgetCell] for [SfDataGrid] widget.
  const GridWidgetCell({
    @required Key key,
    DataCellBase dataCell,
    EdgeInsets padding,
    Color backgroundColor,
    bool isDirty,
    Widget child,
  }) : super(
            key: key,
            dataCell: dataCell,
            padding: padding,
            backgroundColor: backgroundColor,
            isDirty: isDirty,
            child: child);

  @override
  State<StatefulWidget> createState() => _GridWidgetCellState();
}

class _GridWidgetCellState extends State<GridWidgetCell> {
  PointerDeviceKind _kind;

  void _handleOnTapDown(TapDownDetails details) {
    _kind = details?.kind;
  }

  Widget _wrapInsideGestureDetector(BuildContext context) {
    final dataCell = widget.dataCell;
    final _DataGridSettings dataGridSettings =
        dataCell?._dataRow?._dataGridStateDetails();
    return GestureDetector(
      onTapUp: (details) {
        _handleOnTapUp(
            tapUpDetails: details,
            dataGridSettings: dataGridSettings,
            dataCell: dataCell,
            kind: _kind);
      },
      onTapDown: _handleOnTapDown,
      onDoubleTap: dataGridSettings.onCellDoubleTap != null
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
      child: _wrapInsideContainer(context),
    );
  }

  Widget _wrapInsideContainer(BuildContext context) {
    final _DataGridSettings dataGridSettings =
        widget.dataCell?._dataRow?._dataGridStateDetails();
    Widget child;
    if (dataGridSettings != null && dataGridSettings.cellBuilder != null) {
      final recordIndex = _GridIndexResolver.resolveToRecordIndex(
          dataGridSettings, widget.dataCell.rowIndex);
      child = dataGridSettings.cellBuilder(
          context, widget.dataCell.gridColumn, recordIndex);
    }

    return Container(
        key: widget.key,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(border: _getCellBorder(widget.dataCell)),
        child: _wrapInsideCellContainer(
          child: child,
          dataCell: widget.dataCell,
          key: widget.key,
          backgroundColor: widget.backgroundColor,
          alignment: widget.alignment,
          padding: widget.padding,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = _wrapInsideGestureDetector(context);

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
      {@required Key key, this.dataCell, this.isDirty, this.child})
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
  _RenderGridCell({RenderBox child, DataCellBase dataCell, bool isDirty})
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

    dataCell?._isDirty = false;
  }

  Rect columnRect = Rect.zero;

  Rect cellClipRect;

  Rect _measureColumnRect(double rowHeight) {
    if (dataCell._dataRow.isVisible && dataCell.isVisible) {
      final DataRow dataRow = dataCell._dataRow;
      final _DataGridSettings _dataGridSettings =
          dataRow._dataGridStateDetails();
      final _VisualContainerHelper container = _dataGridSettings.container;
      final _VisibleLineInfo lineInfo =
          dataRow._getColumnVisibleLineInfo(dataCell.columnIndex);
      final double lineSize =
          dataCell._dataRow._getColumnSize(dataCell.columnIndex, false);

      var origin = lineInfo != null ? lineInfo.origin : 0.0;
      origin += container.horizontalOffset;

      //To overcome grid common RightToLeft clipping line creation problem
      // instead of handling in grid common source.
      if (_dataGridSettings.textDirection == TextDirection.rtl &&
          lineInfo != null &&
          lineInfo.visibleIndex ==
              _SfDataGridHelper.getVisibleLines(dataRow._dataGridStateDetails())
                  .firstBodyVisibleIndex) {
        origin += lineInfo.scrollOffset;
      }

      // Clipping the column when frozen column applied
      cellClipRect = _getCellClipRect(_dataGridSettings, lineInfo, rowHeight);

      columnRect = Rect.fromLTWH(origin, 0, lineSize, rowHeight);
      origin = null;
    } else {
      columnRect = Rect.zero;
    }

    return columnRect;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    if (child == null) {
      return false;
    }

    final BoxParentData childParentData = child.parentData;
    final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (result, transformed) =>
            child.hitTest(result, position: transformed));
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
      child.layout(
          BoxConstraints.tightFor(
              width: constraints.maxWidth, height: constraints.maxHeight),
          parentUsesSize: true);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      context.paintChild(child, offset);
    }

    super.paint(context, offset);
  }
}

BorderDirectional _getCellBorder(DataCellBase dataCell) {
  final _DataGridSettings dataGridSettings =
      dataCell._dataRow._dataGridStateDetails();
  final Color borderColor = dataGridSettings.dataGridThemeData?.gridLineColor;
  final borderWidth = dataGridSettings.dataGridThemeData?.gridLineStrokeWidth;

  final bool canDrawHorizontalBorder =
      dataGridSettings.gridLinesVisibility == GridLinesVisibility.horizontal ||
          dataGridSettings.gridLinesVisibility == GridLinesVisibility.both;

  final bool canDrawVerticalBorder =
      dataGridSettings.gridLinesVisibility == GridLinesVisibility.vertical ||
          dataGridSettings.gridLinesVisibility == GridLinesVisibility.both;

  // Frozen column and row checking
  final bool canDrawBottomFrozenBorder =
      dataGridSettings.frozenRowsCount.isFinite &&
          dataGridSettings.frozenRowsCount > 0 &&
          _GridIndexResolver.getLastFrozenRowIndex(dataGridSettings) ==
              dataCell.rowIndex;

  final bool canDrawTopFrozenBorder =
      dataGridSettings.footerFrozenRowsCount.isFinite &&
          dataGridSettings.footerFrozenRowsCount > 0 &&
          _GridIndexResolver.getStartFooterFrozenRowIndex(dataGridSettings) ==
              dataCell.rowIndex;

  final bool canDrawRightFrozenBorder =
      dataGridSettings.frozenColumnsCount.isFinite &&
          dataGridSettings.frozenColumnsCount > 0 &&
          _GridIndexResolver.getLastFrozenColumnIndex(dataGridSettings) ==
              dataCell.columnIndex;

  final bool canDrawLeftFrozenBorder = dataGridSettings
          .footerFrozenColumnsCount.isFinite &&
      dataGridSettings.footerFrozenColumnsCount > 0 &&
      _GridIndexResolver.getStartFooterFrozenColumnIndex(dataGridSettings) ==
          dataCell.columnIndex;

  final Color frozenPaneLineColor =
      dataGridSettings.dataGridThemeData?.frozenPaneLineColor;

  final double frozenPaneLineWidth =
      dataGridSettings.dataGridThemeData?.frozenPaneLineWidth;

  BorderSide _getLeftBorder() {
    if ((dataCell.columnIndex == 0 && canDrawVerticalBorder) ||
        canDrawLeftFrozenBorder) {
      if (canDrawLeftFrozenBorder) {
        return BorderSide(
            width: frozenPaneLineWidth, color: frozenPaneLineColor);
      } else {
        return BorderSide(width: borderWidth, color: borderColor);
      }
    } else {
      return BorderSide.none;
    }
  }

  BorderSide _getTopBorder() {
    if ((dataCell.rowIndex == 0 && canDrawHorizontalBorder) ||
        canDrawTopFrozenBorder) {
      if (canDrawTopFrozenBorder) {
        return BorderSide(
            width: frozenPaneLineWidth, color: frozenPaneLineColor);
      } else {
        return BorderSide(width: borderWidth, color: borderColor);
      }
    } else {
      return BorderSide.none;
    }
  }

  BorderSide _getRightBorder() {
    if (canDrawVerticalBorder || canDrawRightFrozenBorder) {
      if (canDrawRightFrozenBorder) {
        return BorderSide(
            width: frozenPaneLineWidth, color: frozenPaneLineColor);
      } else {
        return BorderSide(width: borderWidth, color: borderColor);
      }
    } else {
      return BorderSide.none;
    }
  }

  BorderSide _getBottomBorder() {
    if (canDrawHorizontalBorder || canDrawBottomFrozenBorder) {
      if (canDrawBottomFrozenBorder) {
        return BorderSide(
            width: frozenPaneLineWidth, color: frozenPaneLineColor);
      } else {
        return BorderSide(width: borderWidth, color: borderColor);
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
    {@required DataCell dataCell,
    @required Key key,
    @required EdgeInsets padding,
    @required Alignment alignment,
    @required Color backgroundColor,
    @required Widget child}) {
  final dataGridSettings = dataCell._dataRow._dataGridStateDetails();
  if (dataGridSettings == null) {
    return child;
  }

  final color = dataGridSettings.dataGridThemeData.currentCellStyle.borderColor;
  final borderWidth =
      dataGridSettings.dataGridThemeData.currentCellStyle.borderWidth ?? 1.0;

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

  return LayoutBuilder(
      builder: (context, constraint) => Container(
          key: key,
          width: constraint.maxWidth,
          height: constraint.maxHeight,
          padding: _getPadding(dataCell, padding),
          alignment: alignment,
          clipBehavior: Clip.antiAlias,
          decoration:
              BoxDecoration(color: backgroundColor, border: getBorder()),
          child: child));
}

EdgeInsets _getPadding(DataCellBase dataCell, EdgeInsets padding) {
  final dataGridSettings = dataCell._dataRow?._dataGridStateDetails();

  if (dataGridSettings == null) {
    return const EdgeInsets.all(0.0);
  }

  final themeData = dataGridSettings.dataGridThemeData;
  final currentCellBorderWidth = themeData.currentCellStyle.borderWidth ?? 1.0;

  padding = padding != null
      ? padding -
          EdgeInsets.all(dataCell.isCurrentCell ? currentCellBorderWidth : 0.0)
      : padding;
  return padding != null && padding.isNonNegative ? padding : EdgeInsets.zero;
}

Rect _getCellClipRect(_DataGridSettings _dataGridSettings,
    _VisibleLineInfo lineInfo, double rowHeight) {
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

// Gesture Events

void _handleOnTapUp(
    {TapUpDetails tapUpDetails,
    DataCellBase dataCell,
    _DataGridSettings dataGridSettings,
    PointerDeviceKind kind}) {
  if (dataGridSettings == null || dataCell == null) {
    return;
  }
  if (dataGridSettings.onCellTap != null) {
    final DataGridCellTapDetails details = DataGridCellTapDetails(
        rowColumnIndex: RowColumnIndex(dataCell.rowIndex, dataCell.columnIndex),
        column: dataCell.gridColumn,
        globalPosition: tapUpDetails?.globalPosition,
        localPosition: tapUpDetails?.localPosition,
        kind: kind);
    dataGridSettings.onCellTap(details);
  }

  dataGridSettings.dataGridFocusNode.requestFocus();
  dataCell._onTouchUp();
}

void _handleOnDoubleTap(
    {DataCellBase dataCell, _DataGridSettings dataGridSettings}) {
  if (dataGridSettings == null || dataCell == null) {
    return;
  }

  if (dataGridSettings.onCellDoubleTap != null) {
    final DataGridCellDoubleTapDetails details = DataGridCellDoubleTapDetails(
        rowColumnIndex: RowColumnIndex(dataCell.rowIndex, dataCell.columnIndex),
        column: dataCell.gridColumn);
    dataGridSettings.onCellDoubleTap(details);
  }

  dataGridSettings.dataGridFocusNode.requestFocus();
  dataCell._onTouchUp();
}

void _handleOnLongPressEnd(
    {LongPressEndDetails longPressEndDetails,
    DataCellBase dataCell,
    _DataGridSettings dataGridSettings}) {
  if (dataGridSettings == null || dataCell == null) {
    return;
  }

  if (dataGridSettings.onCellLongPress != null) {
    final DataGridCellLongPressDetails details = DataGridCellLongPressDetails(
        rowColumnIndex: RowColumnIndex(dataCell.rowIndex, dataCell.columnIndex),
        column: dataCell.gridColumn,
        globalPosition: longPressEndDetails?.globalPosition,
        localPosition: longPressEndDetails?.localPosition,
        velocity: longPressEndDetails?.velocity);
    dataGridSettings.onCellLongPress(details);
  }
}

void _handleOnSecondaryTapUp(
    {TapUpDetails tapUpDetails,
    DataCellBase dataCell,
    _DataGridSettings dataGridSettings,
    PointerDeviceKind kind}) {
  if (dataGridSettings == null || dataCell == null) {
    return;
  }
  if (dataGridSettings.onCellSecondaryTap != null) {
    final DataGridCellTapDetails details = DataGridCellTapDetails(
        rowColumnIndex: RowColumnIndex(dataCell.rowIndex, dataCell.columnIndex),
        column: dataCell.gridColumn,
        globalPosition: tapUpDetails?.globalPosition,
        localPosition: tapUpDetails?.localPosition,
        kind: kind);
    dataGridSettings.onCellSecondaryTap(details);
  }
}
