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
    final List<Widget> children = <Widget>[];

    if (widget.dataRow.rowType == RowType.footerRow) {
      if (widget.dataRow._footerView != null) {
        children.add(widget.dataRow._footerView!);
      }
    } else {
      children.addAll(widget.dataRow._visibleColumns
          .map<Widget>((DataCellBase dataCell) => dataCell._columnElement!)
          .toList(growable: false));
    }

    return _VirtualizingCellsRenderObjectWidget(
      key: widget.key!,
      dataRow: widget.dataRow,
      isDirty: widget.isDirty,
      children: List<Widget>.from(children),
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
      : super(
            key: key,
            children: RepaintBoundary.wrapAll(List<Widget>.from(children)));

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
            _VirtualizingCellWidgetParentData>
    implements
        MouseTrackerAnnotation {
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

  // It's helps to find the difference of dy action between on [PointerDownEvent]
  // and [PointerMoveEvent] event.
  double dy = 0.0;

  Rect _measureRowRect(double width) {
    if (dataRow.isVisible) {
      final _DataGridSettings dataGridSettings =
          dataRow._dataGridStateDetails!();
      final _VisualContainerHelper container = dataGridSettings.container;

      final _VisibleLineInfo? lineInfo =
          container.scrollRows.getVisibleLineAtLineIndex(dataRow.rowIndex);

      final double lineSize = lineInfo != null ? lineInfo.size : 0.0;
      double origin = (lineInfo != null) ? lineInfo.origin : 0.0;

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
    final double viewWidth = dataGridSettings.viewWidth;
    final double extentWidth = dataGridSettings.container.extentWidth;
    final double swipingDelta = dataGridSettings.swipingOffset >= 0
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

  Rect _getRowRect(_DataGridSettings dataGridSettings, Offset offset,
      {bool isHoveredLayer = false}) {
    bool needToSetMaxConstraint() =>
        dataGridSettings.container.extentWidth < dataGridSettings.viewWidth &&
        dataGridSettings.textDirection == TextDirection.rtl;

    final Rect rect = Rect.fromLTWH(
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
        (isHoveredLayer &&
                dataRow._isHoveredRow &&
                (dataGridSettings.gridLinesVisibility ==
                        GridLinesVisibility.horizontal ||
                    dataGridSettings.gridLinesVisibility ==
                        GridLinesVisibility.both))
            ? constraints.maxHeight -
                dataGridSettings.dataGridThemeData!.gridLineStrokeWidth
            : constraints.maxHeight);

    return rect;
  }

  void _drawRowBackground(_DataGridSettings dataGridSettings,
      PaintingContext context, Offset offset) {
    final Rect rect = _getRowRect(dataGridSettings, offset);
    Color? backgroundColor;

    Color getDefaultRowBackgroundColor() {
      return dataGridSettings.dataGridThemeData!.brightness == Brightness.light
          ? const Color.fromRGBO(255, 255, 255, 1)
          : const Color.fromRGBO(33, 33, 33, 1);
    }

    void drawSpannedRowBackgroundColor(Color backgroundColor) {
      final bool isRowSpanned = dataRow._visibleColumns
          .any((DataCellBase dataCell) => dataCell._rowSpan > 0);

      if (isRowSpanned) {
        RenderBox? child = lastChild;
        while (child != null && child is _RenderGridCell) {
          final _VirtualizingCellWidgetParentData childParentData =
              child.parentData! as _VirtualizingCellWidgetParentData;
          final DataCellBase dataCell = child.dataCell;
          final _VisibleLineInfo? lineInfo =
              dataRow._getColumnVisibleLineInfo(dataCell.columnIndex);
          if (dataCell._rowSpan > 0 && lineInfo != null) {
            final Rect? columnRect = child.columnRect;
            final Rect? cellClipRect = child.cellClipRect;
            final double height = dataRow._getRowHeight(
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
              dataRow.rowType == RowType.headerRow ||
          dataRow.rowType == RowType.stackedHeaderRow) {
        backgroundColor = dataGridSettings.dataGridThemeData!.headerColor;
        drawSpannedRowBackgroundColor(backgroundColor);
      } else if (dataRow.rowType == RowType.footerRow) {
        backgroundColor = getDefaultRowBackgroundColor();
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
      backgroundColor ??= getDefaultRowBackgroundColor();

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

      const double stokeWidth = 1;
      final int origin = (stokeWidth / 2 +
              dataGridSettings.dataGridThemeData!.gridLineStrokeWidth)
          .ceil();

      final Rect rowRect = _getRowRect(dataGridSettings, offset);
      final double maxWidth = needToSetMaxConstraint()
          ? rowRect.width - rowRect.left
          : rowRect.right - rowRect.left;

      final bool isHorizontalGridLinesEnabled =
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
          child.parentData! as _VirtualizingCellWidgetParentData;
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
    final bool isRowSpanned = dataRow._visibleColumns
        .any((DataCellBase dataCell) => dataCell._rowSpan > 0);

    if (isRowSpanned) {
      RenderBox? child = lastChild;
      while (child != null) {
        final _VirtualizingCellWidgetParentData childParentData =
            child.parentData! as _VirtualizingCellWidgetParentData;
        if (child is _RenderGridCell &&
            child.columnRect != null &&
            child.columnRect!.contains(position)) {
          // Need to resolve the position when dataCell has row span.
          if (child.dataCell._rowSpan > 0) {
            final DataCellBase dataCell = child.dataCell;
            final double cellActualHeight = dataCell._dataRow!
                ._getRowHeight(dataCell.rowIndex, dataCell.rowIndex);
            final double cellTotalHeight = dataCell._dataRow!._getRowHeight(
                dataCell.rowIndex - dataCell._rowSpan, dataCell.rowIndex);

            final double resolvedXPosition = child.globalToLocal(position).dx;
            final double resolvedYPosition =
                cellTotalHeight + (position.dy - cellActualHeight);

            return child.hitTest(result,
                position: Offset(resolvedXPosition, resolvedYPosition));
          }
          return super.hitTest(result, position: position);
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
    // Need to reset the swiping and scrolling state to default when pointer
    // up and touch again
    dataGridSettings.isSwipingApplied = false;
    dataGridSettings.scrollingState = ScrollDirection.idle;
    swipeDirection = null;

    // Need to check whether tap action placed on another [DataGridRow]
    // instead of swiped [DataGridRow].
    //
    // If its tapped on the same swiped [DataGridRow], we don't do anything.
    // If it's tapped on different [DataGridRow] or scrolled, we need to end
    // the swiping.
    final DataRowBase? swipedRow = dataGridSettings.rowGenerator.items
        .firstWhereOrNull((DataRowBase row) =>
            row._isSwipingRow && dataGridSettings.swipingOffset.abs() > 0);

    if (swipedRow != null && swipedRow.rowIndex != dataRow.rowIndex) {
      dataGridSettings.container
          .resetSwipeOffset(swipedRow: swipedRow, canUpdate: true);
      dataGridSettings.swipingOffset = event.localDelta.dx;
      dy = event.localDelta.dy;
    }
  }

  void _handleSwipeUpdate(
      PointerMoveEvent event, _DataGridSettings dataGridSettings) {
    final double currentSwipingDelta =
        dataGridSettings.swipingOffset + event.localDelta.dx;
    dy = dy - event.localDelta.dy;

    // If it's fling or scrolled, we have to ignore the swiping action
    if (!dataGridSettings.isSwipingApplied &&
        (dataGridSettings.scrollingState == ScrollDirection.forward ||
            dy.abs() > 3)) {
      dataGridSettings.isSwipingApplied = false;
      return;
    }

    final ScrollController horizontalController =
        dataGridSettings.horizontalScrollController!;

    /// Swipe must to happen when it's reach the max and min scroll extend.
    if (currentSwipingDelta > 2) {
      if (dataGridSettings.container.horizontalOffset ==
              horizontalController.position.minScrollExtent &&
          swipeDirection == null) {
        swipeDirection = _SfDataGridHelper.getSwipeDirection(
            dataGridSettings, currentSwipingDelta);
        // Resricted the continuous swiping of both directions by dragging.
      } else if (swipeDirection == DataGridRowSwipeDirection.endToStart) {
        swipeDirection = null;
      }
    } else if (currentSwipingDelta < -2) {
      if (dataGridSettings.container.horizontalOffset ==
              horizontalController.position.maxScrollExtent &&
          swipeDirection == null) {
        swipeDirection = _SfDataGridHelper.getSwipeDirection(
            dataGridSettings, currentSwipingDelta);
        // Resricted the continuous swiping of both directions by dragging.
      } else if (swipeDirection == DataGridRowSwipeDirection.startToEnd) {
        swipeDirection = null;
      }
    }

    if (swipeDirection != null &&
        _SfDataGridHelper.canSwipeRow(
            dataGridSettings, swipeDirection!, currentSwipingDelta)) {
      bool canStartSwiping = true;
      final double oldSwipingDelta = dataGridSettings.swipingOffset;
      final int rowIndex = _GridIndexResolver.resolveToRecordIndex(
          dataGridSettings, dataRow.rowIndex);

      // Need to skip the [onSwipeStart] callback when swiping is applied.
      if (dataGridSettings.onSwipeStart != null &&
          !dataGridSettings.isSwipingApplied) {
        final DataGridSwipeStartDetails swipeStartDetails =
            DataGridSwipeStartDetails(
                rowIndex: rowIndex, swipeDirection: swipeDirection!);
        canStartSwiping = dataGridSettings.onSwipeStart!(swipeStartDetails);
      }

      if (canStartSwiping) {
        dataGridSettings.isSwipingApplied = true;
        if (dataGridSettings.onSwipeUpdate != null) {
          final DataGridSwipeUpdateDetails swipeUpdateDetails =
              DataGridSwipeUpdateDetails(
                  rowIndex: rowIndex,
                  swipeDirection: swipeDirection!,
                  swipeOffset: currentSwipingDelta);
          canStartSwiping = dataGridSettings.onSwipeUpdate!(swipeUpdateDetails);
        }

        if (!canStartSwiping) {
          return;
        }

        if (dataGridSettings.swipingAnimationController!.isAnimating) {
          return;
        }

        if (currentSwipingDelta >= dataGridSettings.swipeMaxOffset) {
          dataGridSettings.swipingOffset = dataGridSettings.swipeMaxOffset;
        } else {
          dataGridSettings.swipingOffset += event.localDelta.dx;
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
      } else {
        dataGridSettings.container.resetSwipeOffset(canUpdate: true);
      }
    }
  }

  void _handleSwipeEnd(
      PointerUpEvent event, _DataGridSettings dataGridSettings) {
    void _onSwipeEnd() {
      if (dataGridSettings.onSwipeEnd != null) {
        final int rowIndex = _GridIndexResolver.resolveToRecordIndex(
            dataGridSettings, dataRow.rowIndex);
        final DataGridRowSwipeDirection swipeDirection =
            _SfDataGridHelper.getSwipeDirection(
                dataGridSettings, dataGridSettings.swipingOffset);
        final DataGridSwipeEndDetails swipeEndDetails = DataGridSwipeEndDetails(
            rowIndex: rowIndex, swipeDirection: swipeDirection);
        dataGridSettings.onSwipeEnd!(swipeEndDetails);
      }
    }

    if (dataRow._isSwipingRow) {
      if (dataGridSettings.swipingAnimationController!.isAnimating) {
        return;
      }

      dataGridSettings.isSwipingApplied = false;
      if (dataGridSettings.swipingOffset.abs() >
          dataGridSettings.swipeMaxOffset / 2) {
        dataGridSettings.swipingOffset = dataGridSettings.swipingOffset >= 0
            ? dataGridSettings.swipeMaxOffset
            : -dataGridSettings.swipeMaxOffset;
        dataGridSettings.swipingAnimationController!
            .forward()
            .then((_) => _onSwipeEnd());
      } else {
        if (dataGridSettings.swipingOffset.abs() <
            dataGridSettings.swipeMaxOffset) {
          dataGridSettings.swipingAnimationController!.reverse().then((_) {
            _onSwipeEnd();
            dataGridSettings.container.resetSwipeOffset(swipedRow: dataRow);
          });
        }
      }
    }

    dy = 0.0;
    dataGridSettings.scrollingState = ScrollDirection.idle;
  }

  void _handleSwiping(PointerEvent event) {
    final _DataGridSettings dataGridSettings = dataRow._dataGridStateDetails!();
    if (dataGridSettings.allowSwiping && dataRow.rowType == RowType.dataRow) {
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
    super.handleEvent(event, entry);
    _handleSwiping(event);
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
          child.parentData! as _VirtualizingCellWidgetParentData;
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
        if (dataRow.rowType == RowType.footerRow) {
          final _DataGridSettings dataGridSettings =
              dataRow._dataGridStateDetails!();
          final Rect cellRect = Rect.fromLTWH(
              dataGridSettings.container.horizontalOffset,
              0.0,
              dataGridSettings.viewWidth,
              dataGridSettings.footerHeight);

          size = constraints.constrain(Size(cellRect.width, cellRect.height));
          _parentData
            ..width = cellRect.width
            ..height = cellRect.height
            ..offset = Offset(cellRect.left, cellRect.top);
          _layout(
              child: child,
              width: _parentData.width,
              height: _parentData.height);
        } else {
          size = constraints.constrain(Size.zero);
          child.layout(const BoxConstraints.tightFor(width: 0, height: 0));
          _parentData.reset();
        }
      }
      child = _parentData.nextSibling;
    }
  }

  void _drawRowHoverBackground(_DataGridSettings dataGridSettings,
      PaintingContext context, Offset offset) {
    if (dataGridSettings._isDesktop &&
        dataGridSettings.highlightRowOnHover &&
        dataRow._isHoveredRow) {
      dataGridSettings.gridPaint?.color =
          dataGridSettings.dataGridThemeData!.rowHoverColor;
      context.canvas.drawRect(
          _getRowRect(dataGridSettings, offset, isHoveredLayer: true),
          dataGridSettings.gridPaint!);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final _DataGridSettings dataGridSettings = dataRow._dataGridStateDetails!();

    // Remove the below method if the mentioned report has resolved
    // form framework side
    // https://github.com/flutter/flutter/issues/29702
    _drawRowBackground(dataGridSettings, context, offset);

    _drawRowHoverBackground(dataGridSettings, context, offset);

    RenderBox? child = firstChild;
    while (child != null) {
      final _VirtualizingCellWidgetParentData childParentData =
          child.parentData! as _VirtualizingCellWidgetParentData;
      if (childParentData.width != 0.0 && childParentData.height != 0.0) {
        if (childParentData.cellClipRect != null) {
          context.pushClipRect(
            needsCompositing,
            childParentData.offset + offset,
            childParentData.cellClipRect!,
            (PaintingContext context, Offset offset) {
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
    if (dataGridSettings._isDesktop) {
      _drawCurrentRowBorder(context, offset);
    }
  }

  @override
  MouseCursor get cursor => MouseCursor.defer;

  @override
  PointerEnterEventListener? get onEnter {
    final _DataGridSettings dataGridSettings = dataRow._dataGridStateDetails!();
    if (dataGridSettings.highlightRowOnHover &&
        dataGridSettings._isDesktop &&
        dataRow.rowType == RowType.dataRow) {
      dataRow._isHoveredRow = true;

      final TextStyle rowStyle =
          dataGridSettings.dataGridThemeData!.brightness == Brightness.light
              ? const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black87)
              : const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color.fromRGBO(255, 255, 255, 1));
      if (dataGridSettings.dataGridThemeData!.rowHoverTextStyle != rowStyle) {
        dataRow._rowIndexChanged();
        dataGridSettings.source._notifyDataGridPropertyChangeListeners(
            propertyName: 'hoverOnCell');
      }
      markNeedsPaint();
    }
  }

  @override
  PointerExitEventListener? get onExit {
    final _DataGridSettings dataGridSettings = dataRow._dataGridStateDetails!();
    if (dataGridSettings.highlightRowOnHover &&
        dataGridSettings._isDesktop &&
        dataRow.rowType == RowType.dataRow) {
      dataRow._isHoveredRow = false;

      final TextStyle rowStyle =
          dataGridSettings.dataGridThemeData!.brightness == Brightness.light
              ? const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black87)
              : const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color.fromRGBO(255, 255, 255, 1));
      if (dataGridSettings.dataGridThemeData!.rowHoverTextStyle != rowStyle) {
        dataRow._rowIndexChanged();
        dataGridSettings.source._notifyDataGridPropertyChangeListeners(
            propertyName: 'hoverOnCell');
      }
      markNeedsPaint();
    }
  }

  @override
  bool get validForMouseTracker {
    final _DataGridSettings dataGridSettings = dataRow._dataGridStateDetails!();
    if (dataGridSettings.highlightRowOnHover &&
        dataRow.rowType == RowType.dataRow) {
      return true;
    }
    return false;
  }
}

class _HeaderCellsWidget extends _VirtualizingCellsWidget {
  const _HeaderCellsWidget(
      {required Key key, required DataRowBase dataRow, bool isDirty = false})
      : super(key: key, dataRow: dataRow, isDirty: isDirty);
}
