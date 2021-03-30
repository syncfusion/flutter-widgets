part of datagrid;

class _VirtualizingCellsWidget extends StatefulWidget {
  const _VirtualizingCellsWidget(
      {required Key key, required this.dataRow, required this.isDirty})
      : super(key: key);

  final DataRowBase dataRow;
  final bool isDirty;

  @override
  State<StatefulWidget> createState() => _VirtualizingCellsWidgetState();
}

class _VirtualizingCellsWidgetState extends State<_VirtualizingCellsWidget> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> children = widget.dataRow._visibleColumns
        .map<Widget>((dataCell) => dataCell._columnElement!)
        .toList(growable: false);

    return _VirtualizingCellsRenderObjectWidget(
      key: widget.key!,
      dataRow: widget.dataRow,
      isDirty: widget.isDirty,
      children: List.from(children),
    );
  }
}

class _VirtualizingCellsRenderObjectWidget
    extends MultiChildRenderObjectWidget {
  _VirtualizingCellsRenderObjectWidget(
      {required Key key,
      required this.dataRow,
      required this.isDirty,
      required this.children})
      : super(key: key, children: RepaintBoundary.wrapAll(List.from(children)));

  @override
  final List<Widget> children;
  final DataRowBase dataRow;
  final bool isDirty;

  @override
  _RenderVirtualizingCellsWidget createRenderObject(BuildContext context) =>
      _RenderVirtualizingCellsWidget(dataRow: dataRow, isDirty: isDirty);

  @override
  void updateRenderObject(
      BuildContext context, _RenderVirtualizingCellsWidget renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..dataRow = dataRow
      ..isDirty = isDirty;
  }
}

class _VirtualizingCellWidgetParentData
    extends ContainerBoxParentData<RenderBox> {
  _VirtualizingCellWidgetParentData();

  double width = 0.0;
  double height = 0.0;
  Rect? cellClipRect;

  void reset() {
    width = 0.0;
    height = 0.0;
    offset = Offset.zero;
    cellClipRect = null;
  }
}

class _RenderVirtualizingCellsWidget extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox,
            _VirtualizingCellWidgetParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox,
            _VirtualizingCellWidgetParentData> {
  _RenderVirtualizingCellsWidget(
      {List<RenderBox>? children,
      required DataRowBase dataRow,
      bool isDirty = false})
      : _dataRow = dataRow,
        _isDirty = isDirty {
    addAll(children);
  }

  bool get isDirty => _isDirty;
  bool _isDirty = false;

  set isDirty(bool newValue) {
    _isDirty = newValue;
    if (_isDirty) {
      markNeedsLayout();
      markNeedsPaint();
    }

    dataRow._isDirty = false;
  }

  DataRowBase get dataRow => _dataRow;
  DataRowBase _dataRow;

  set dataRow(DataRowBase newValue) {
    if (_dataRow == newValue) {
      return;
    }

    _dataRow = newValue;
    markNeedsLayout();
    markNeedsPaint();
  }

  Rect rowRect = Rect.zero;

  Rect? rowClipRect;

  DataGridRowSwipeDirection? swipeDirection;

  Rect _measureRowRect(double width) {
    if (dataRow.isVisible) {
      final _DataGridSettings dataGridSettings =
          dataRow._dataGridStateDetails!();
      final _VisualContainerHelper container = dataGridSettings.container;

      final _VisibleLineInfo? lineInfo =
          container.scrollRows.getVisibleLineAtLineIndex(dataRow.rowIndex);

      final double lineSize = lineInfo != null ? lineInfo.size : 0.0;
      var origin = (lineInfo != null) ? lineInfo.origin : 0.0;

      origin += container.verticalOffset;

      if (dataRow.rowIndex >
          _GridIndexResolver.getHeaderIndex(dataGridSettings)) {
        final double headerRowsHeight = container.scrollRows
            .rangeToRegionPoints(
                0, dataGridSettings.headerLineCount - 1, true)[1]
            .length;
        origin -= headerRowsHeight;
      }

      // Clipping the column when frozen row applied
      if (lineInfo != null &&
          (lineInfo.isClippedBody && lineInfo.isClippedOrigin)) {
        final double top =
            lineInfo.size - lineInfo.clippedSize - lineInfo.clippedCornerExtent;
        if (dataGridSettings.allowSwiping && dataRow._isSwipingRow) {
          rowClipRect = _getSwipingRowClipRect(
              dataGridSettings: dataGridSettings, top: top, height: lineSize);
        } else {
          rowClipRect = Rect.fromLTWH(0, top, width, lineSize);
        }
      } else if (dataGridSettings.allowSwiping && dataRow._isSwipingRow) {
        rowClipRect = _getSwipingRowClipRect(
            dataGridSettings: dataGridSettings, top: 0.0, height: lineSize);
      } else {
        rowClipRect = null;
      }

      rowRect = Rect.fromLTWH(0, origin, width, lineSize);
      return rowRect;
    } else {
      return Rect.zero;
    }
  }

  Rect? _getSwipingRowClipRect(
      {required _DataGridSettings dataGridSettings,
      required double top,
      required double height}) {
    if (dataGridSettings.swipingAnimation == null) {
      return null;
    }
    double leftPosition = 0.0;
    final viewWidth = dataGridSettings.viewWidth;
    final extentWidth = dataGridSettings.container.extentWidth;
    final swipingDelta = dataGridSettings.swipingOffset >= 0
        ? dataGridSettings.swipingAnimation!.value
        : -dataGridSettings.swipingAnimation!.value;

    if (dataGridSettings.textDirection == TextDirection.rtl &&
        viewWidth > extentWidth) {
      leftPosition = dataGridSettings.swipingOffset >= 0
          ? viewWidth - extentWidth
          : (viewWidth - extentWidth) + swipingDelta;
    } else {
      leftPosition = dataGridSettings.swipingOffset >= 0 ? 0 : swipingDelta;
    }
    return Rect.fromLTWH(leftPosition, top, extentWidth - swipingDelta, height);
  }

  Rect _getRowRect(_DataGridSettings dataGridSettings, Offset offset) {
    bool needToSetMaxConstraint() =>
        dataGridSettings.container.extentWidth < dataGridSettings.viewWidth &&
        dataGridSettings.textDirection == TextDirection.rtl;

    final rect = Rect.fromLTWH(
        needToSetMaxConstraint()
            ? constraints.maxWidth -
                min(dataGridSettings.container.extentWidth,
                    dataGridSettings.viewWidth) -
                (offset.dx + dataGridSettings.container.horizontalOffset)
            : offset.dx + dataGridSettings.container.horizontalOffset,
        offset.dy,
        needToSetMaxConstraint()
            ? constraints.maxWidth
            : min(dataGridSettings.container.extentWidth,
                dataGridSettings.viewWidth),
        constraints.maxHeight);

    return rect;
  }

  void _drawRowBackground(PaintingContext context, Offset offset) {
    final _DataGridSettings dataGridSettings = dataRow._dataGridStateDetails!();
    final rect = _getRowRect(dataGridSettings, offset);
    var backgroundColor = Colors.transparent;

    Color getDefaultHeaderBackgroundColor() {
      return dataGridSettings.dataGridThemeData!.brightness == Brightness.light
          ? Color.fromRGBO(255, 255, 255, 1)
          : Color.fromRGBO(33, 33, 33, 1);
    }

    void drawSpannedRowBackgroundColor(Color backgroundColor) {
      final bool isRowSpanned =
          dataRow._visibleColumns.any((dataCell) => dataCell._rowSpan > 0);

      if (isRowSpanned) {
        RenderBox? child = lastChild;
        while (child != null && child is _RenderGridCell) {
          final _VirtualizingCellWidgetParentData childParentData =
              child.parentData as _VirtualizingCellWidgetParentData;
          final dataCell = child.dataCell;
          final lineInfo =
              dataRow._getColumnVisibleLineInfo(dataCell.columnIndex);
          if (dataCell._rowSpan > 0 && lineInfo != null) {
            final columnRect = child.columnRect;
            final cellClipRect = child.cellClipRect;
            final height = dataRow._getRowHeight(
                dataCell.rowIndex - dataCell._rowSpan, dataCell.rowIndex);
            Rect cellRect = Rect.zero;
            if (cellClipRect != null) {
              double left = columnRect!.left;
              double width = cellClipRect.width;
              if (cellClipRect.left > 0 && columnRect.width <= width) {
                left += cellClipRect.left;
                width = columnRect.width - cellClipRect.left;
              } else if (cellClipRect.left > 0 && width < columnRect.width) {
                left += cellClipRect.left;
              }

              cellRect = Rect.fromLTWH(left, columnRect.top, width, height);
            } else {
              cellRect = Rect.fromLTWH(
                  columnRect!.left, columnRect.top, columnRect.width, height);
            }
            dataGridSettings.gridPaint?.color = backgroundColor;
            context.canvas.drawRect(cellRect, dataGridSettings.gridPaint!);
          }
          child = childParentData.previousSibling;
        }
      }
    }

    if (dataGridSettings.gridPaint != null) {
      dataGridSettings.gridPaint!.style = PaintingStyle.fill;

      if (dataRow.rowRegion == RowRegion.header &&
          dataRow.rowType == RowType.headerRow) {
        backgroundColor = dataGridSettings.dataGridThemeData!.headerColor;
        drawSpannedRowBackgroundColor(backgroundColor);
      } else if (dataRow.rowRegion == RowRegion.header &&
          dataRow.rowType == RowType.stackedHeaderRow) {
        backgroundColor = getDefaultHeaderBackgroundColor();
        drawSpannedRowBackgroundColor(backgroundColor);
      } else {
        /// Need to check the rowStyle Please look the previous version and
        /// selection preference
        backgroundColor = dataRow.isSelectedRow
            ? dataGridSettings.dataGridThemeData!.selectionColor
            : dataRow._dataGridRowAdapter!.color;
      }

      // Default theme color are common for both the HeaderBackgroundColor and
      // CellBackgroundColor, so we have checked commonly at outside of the
      // condition
      if (backgroundColor == Colors.transparent) {
        backgroundColor = getDefaultHeaderBackgroundColor();
      }

      dataGridSettings.gridPaint?.color = backgroundColor;
      context.canvas.drawRect(rect, dataGridSettings.gridPaint!);
    }
  }

  void _drawCurrentRowBorder(PaintingContext context, Offset offset) {
    final _DataGridSettings dataGridSettings = dataRow._dataGridStateDetails!();

    if (dataGridSettings.boxPainter != null &&
        dataGridSettings.selectionMode == SelectionMode.multiple &&
        dataGridSettings.navigationMode == GridNavigationMode.row &&
        dataGridSettings.currentCell.rowIndex == dataRow.rowIndex) {
      bool needToSetMaxConstraint() =>
          dataGridSettings.container.extentWidth < dataGridSettings.viewWidth &&
          dataGridSettings.textDirection == TextDirection.rtl;

      final double stokeWidth = 1;
      final origin = (stokeWidth / 2 +
              dataGridSettings.dataGridThemeData!.gridLineStrokeWidth)
          .ceil();

      final Rect rowRect = _getRowRect(dataGridSettings, offset);
      final maxWidth = needToSetMaxConstraint()
          ? rowRect.width - rowRect.left
          : rowRect.right - rowRect.left;

      final isHorizontalGridLinesEnabled =
          dataGridSettings.gridLinesVisibility == GridLinesVisibility.both ||
              dataGridSettings.gridLinesVisibility ==
                  GridLinesVisibility.horizontal;

      dataGridSettings.boxPainter!.paint(
          context.canvas,
          Offset(rowRect.left + origin, rowRect.top + (origin / 2)),
          dataGridSettings.configuration!.copyWith(
              size: Size(
                  maxWidth - (origin * 2),
                  constraints.maxHeight -
                      (origin * (isHorizontalGridLinesEnabled ? 1.5 : 1)))));
    }
  }

  @override
  void setupParentData(RenderObject child) {
    super.setupParentData(child);
    if (child.parentData != null &&
        child.parentData != _VirtualizingCellWidgetParentData()) {
      child.parentData = _VirtualizingCellWidgetParentData();
    }
  }

  void _handleSwipingListener() {
    final _DataGridSettings dataGridSettings = dataRow._dataGridStateDetails!();
    dataGridSettings.source
        ._notifyDataGridPropertyChangeListeners(propertyName: 'Swiping');
  }

  @override
  void attach(PipelineOwner owner) {
    final _DataGridSettings dataGridSettings = dataRow._dataGridStateDetails!();
    dataGridSettings.swipingAnimationController
        ?.addListener(_handleSwipingListener);
    super.attach(owner);
  }

  @override
  void detach() {
    final _DataGridSettings dataGridSettings = dataRow._dataGridStateDetails!();
    dataGridSettings.swipingAnimationController
        ?.removeListener(_handleSwipingListener);

    super.detach();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = lastChild;
    while (child != null) {
      final _VirtualizingCellWidgetParentData childParentData =
          child.parentData as _VirtualizingCellWidgetParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          if (child is _RenderGridCell &&
              child.cellClipRect != null &&
              !child.cellClipRect!.contains(transformed)) {
            return false;
          }

          return child!.hitTest(result, position: transformed);
        },
      );

      if (isHit) {
        return true;
      }
      child = childParentData.previousSibling;
    }
    return false;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    final bool isRowSpanned =
        dataRow._visibleColumns.any((dataCell) => dataCell._rowSpan > 0);

    if (isRowSpanned) {
      RenderBox? child = lastChild;
      while (child != null) {
        final _VirtualizingCellWidgetParentData childParentData =
            child.parentData as _VirtualizingCellWidgetParentData;
        if (child is _RenderGridCell &&
            child.columnRect != null &&
            child.columnRect!.contains(position)) {
          return super.hitTest(result,
              position: Offset(position.dx.abs(), position.dy.abs()));
        }
        child = childParentData.previousSibling;
      }
    }

    return super.hitTest(result, position: position);
  }

  void _updateSwipingAnimation(_DataGridSettings dataGridSettings) {
    dataGridSettings.swipingAnimation = Tween<double>(
            begin: 0.0,
            end: dataGridSettings.swipingOffset.sign >= 0
                ? dataGridSettings.swipeMaxOffset
                : -dataGridSettings.swipeMaxOffset)
        .animate(dataGridSettings.swipingAnimationController!);
  }

  void _handleSwipeStart(
      PointerDownEvent event, _DataGridSettings dataGridSettings) {
    dataGridSettings.isSwipingApplied =
        (dataGridSettings.swipingOffset.abs() > 0) ? true : false;

    final swipedRow = dataGridSettings.rowGenerator.items.firstWhereOrNull(
        (row) => row._isSwipingRow && dataGridSettings.swipingOffset.abs() > 0);

    if (swipedRow != null && swipedRow.rowIndex != dataRow.rowIndex) {
      swipedRow._isSwipingRow = false;
      dataGridSettings.swipingOffset = 0;
    }

    dataGridSettings.source
        ._notifyDataGridPropertyChangeListeners(propertyName: 'Swiping');
  }

  void _handleSwipeUpdate(
      PointerMoveEvent event, _DataGridSettings dataGridSettings) {
    bool canStartSwiping = true;
    bool canUpdateSwiping = true;
    final oldSwipingDelta = dataGridSettings.swipingOffset;
    final currentSwipingDelta =
        dataGridSettings.swipingOffset + event.localDelta.dx;
    final rowIndex = _GridIndexResolver.resolveToRecordIndex(
        dataGridSettings, dataRow.rowIndex);
    final rowSwipeDirection = _SfDataGridHelper.getSwipeDirection(
        dataGridSettings, currentSwipingDelta);

    if (dataGridSettings.onSwipeStart != null) {
      final swipeStartDetails = DataGridSwipeStartDetails(
          rowIndex: rowIndex, swipeDirection: rowSwipeDirection);
      canStartSwiping = dataGridSettings.onSwipeStart!(swipeStartDetails);
    }

    swipeDirection = currentSwipingDelta < 0
        ? DataGridRowSwipeDirection.endToStart
        : DataGridRowSwipeDirection.startToEnd;

    if (dataGridSettings.swipingOffset.abs() == 0 ||
        dataGridSettings.swipingOffset.abs() ==
            dataGridSettings.swipeMaxOffset) {
      dataGridSettings.isSwipingApplied = false;
    } else {
      dataGridSettings.isSwipingApplied = true;
    }

    if (canStartSwiping &&
        dataGridSettings.allowSwiping &&
        (event.localDelta.dx.abs() > event.localDelta.dy.abs()) &&
        _SfDataGridHelper.canSwipeRow(
            dataGridSettings, swipeDirection!, event.localDelta.dx)) {
      if (dataGridSettings.onSwipeUpdate != null) {
        final swipeUpdateDetails = DataGridSwipeUpdateDetails(
            rowIndex: rowIndex,
            swipeDirection: rowSwipeDirection,
            swipeOffset: currentSwipingDelta);
        canUpdateSwiping = dataGridSettings.onSwipeUpdate!(swipeUpdateDetails);
      }

      if (canUpdateSwiping) {
        if (dataGridSettings.swipingAnimationController!.isAnimating) {
          return;
        }
        if (currentSwipingDelta >= 0 &&
            swipeDirection == DataGridRowSwipeDirection.startToEnd &&
            currentSwipingDelta >= dataGridSettings.swipeMaxOffset) {
          dataGridSettings.swipingOffset = dataGridSettings.swipeMaxOffset;
        } else if (currentSwipingDelta < 0 &&
            swipeDirection == DataGridRowSwipeDirection.endToStart &&
            -currentSwipingDelta >= dataGridSettings.swipeMaxOffset) {
          dataGridSettings.swipingOffset = -dataGridSettings.swipeMaxOffset;
        } else {
          if (rowSwipeDirection == DataGridRowSwipeDirection.startToEnd
              ? dataGridSettings.startSwipeActionsBuilder != null
              : dataGridSettings.endSwipeActionsBuilder != null) {
            dataGridSettings.swipingOffset += event.localDelta.dx;
          }
        }
        dataRow._isSwipingRow = true;
        if (oldSwipingDelta.sign != currentSwipingDelta.sign) {
          _updateSwipingAnimation(dataGridSettings);
        }
        if (!dataGridSettings.swipingAnimationController!.isAnimating) {
          dataGridSettings.swipingAnimationController!.value =
              dataGridSettings.swipingOffset.abs() /
                  dataGridSettings.swipeMaxOffset;
        }
        dataGridSettings.source
            ._notifyDataGridPropertyChangeListeners(propertyName: 'Swiping');
      }
    }
  }

  void _handleSwipeEnd(
      PointerUpEvent event, _DataGridSettings dataGridSettings) {
    void _onSwipeEnd() {
      if (dataGridSettings.onSwipeEnd != null) {
        final rowSwipeDirection = _SfDataGridHelper.getSwipeDirection(
            dataGridSettings, dataGridSettings.swipingOffset);
        final rowIndex = _GridIndexResolver.resolveToRecordIndex(
            dataGridSettings, dataRow.rowIndex);
        final swipeEndDetails = DataGridSwipeEndDetails(
            rowIndex: rowIndex, swipeDirection: rowSwipeDirection);
        dataGridSettings.onSwipeEnd!(swipeEndDetails);
      }
    }

    if (dataRow._isSwipingRow) {
      if (dataGridSettings.swipingAnimationController!.isAnimating) {
        return;
      }
      if (dataGridSettings.swipingOffset >= 0 &&
          swipeDirection == DataGridRowSwipeDirection.startToEnd &&
          dataGridSettings.swipingOffset >
              dataGridSettings.swipeMaxOffset / 2) {
        dataGridSettings.swipingOffset = dataGridSettings.swipeMaxOffset;
        dataGridSettings.swipingAnimationController!
            .forward()
            .then((value) => _onSwipeEnd());
      } else if (dataGridSettings.swipingOffset < 0 &&
          swipeDirection == DataGridRowSwipeDirection.endToStart &&
          -dataGridSettings.swipingOffset >
              dataGridSettings.swipeMaxOffset / 2) {
        dataGridSettings.swipingOffset = -dataGridSettings.swipeMaxOffset;
        dataGridSettings.swipingAnimationController!
            .forward()
            .then((value) => _onSwipeEnd());
      } else {
        dataGridSettings.swipingAnimationController!.reverse().then((value) {
          dataGridSettings.swipingOffset = 0;
          dataRow._isSwipingRow = false;
          _onSwipeEnd();
          dataGridSettings.source
              ._notifyDataGridPropertyChangeListeners(propertyName: 'Swiping');
        });
      }

      dataGridSettings.isSwipingApplied = false;
      dataGridSettings.source
          ._notifyDataGridPropertyChangeListeners(propertyName: 'Swiping');
    }
  }

  void _handleSwiping(PointerEvent event) {
    final _DataGridSettings dataGridSettings = dataRow._dataGridStateDetails!();
    if (dataGridSettings.allowSwiping) {
      if (event is PointerDownEvent) {
        _handleSwipeStart(event, dataGridSettings);
      }
      if (event is PointerMoveEvent) {
        _handleSwipeUpdate(event, dataGridSettings);
      }
      if (event is PointerUpEvent) {
        _handleSwipeEnd(event, dataGridSettings);
      }
    }
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    _handleSwiping(event);
    super.handleEvent(event, entry);
  }

  @override
  void performLayout() {
    void _layout(
        {required RenderBox child,
        required double width,
        required double height}) {
      child.layout(BoxConstraints.tightFor(width: width, height: height),
          parentUsesSize: true);
    }

    RenderBox? child = firstChild;
    while (child != null) {
      final _VirtualizingCellWidgetParentData _parentData =
          child.parentData as _VirtualizingCellWidgetParentData;
      if (dataRow.isVisible &&
          child is _RenderGridCell &&
          child.dataCell.isVisible) {
        final Rect columnRect =
            child._measureColumnRect(constraints.maxHeight)!;
        size = constraints.constrain(Size(columnRect.width, columnRect.height));
        _parentData
          ..width = columnRect.width
          ..height = columnRect.height
          ..cellClipRect = child.cellClipRect;
        _layout(
            child: child, width: _parentData.width, height: _parentData.height);
        _parentData.offset = Offset(columnRect.left, columnRect.top);
      } else {
        size = constraints.constrain(Size.zero);
        child.layout(const BoxConstraints.tightFor(width: 0, height: 0));
        _parentData.reset();
      }
      child = _parentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Remove the below method if the mentioned report has resolved
    // form framework side
    // https://github.com/flutter/flutter/issues/29702
    _drawRowBackground(context, offset);

    RenderBox? child = firstChild;
    while (child != null) {
      final _VirtualizingCellWidgetParentData childParentData =
          child.parentData as _VirtualizingCellWidgetParentData;
      if (childParentData.width != 0.0 && childParentData.height != 0.0) {
        if (childParentData.cellClipRect != null) {
          context.pushClipRect(
            needsCompositing,
            childParentData.offset + offset,
            childParentData.cellClipRect!,
            (context, offset) {
              context.paintChild(child!, offset);
            },
            clipBehavior: Clip.antiAlias,
          );
        } else {
          context.paintChild(child, childParentData.offset + offset);
        }
      }
      child = childParentData.nextSibling;
    }
    final _DataGridSettings dataGridSettings = dataRow._dataGridStateDetails!();
    if (dataGridSettings._isDesktop) {
      _drawCurrentRowBorder(context, offset);
    }
  }
}

class _HeaderCellsWidget extends _VirtualizingCellsWidget {
  const _HeaderCellsWidget(
      {required Key key, required DataRowBase dataRow, bool isDirty = false})
      : super(key: key, dataRow: dataRow, isDirty: isDirty);
}
