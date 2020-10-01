part of datagrid;

class _VirtualizingCellsWidget extends StatefulWidget {
  const _VirtualizingCellsWidget(
      {@required Key key, @required this.dataRow, this.isDirty})
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
        .map<Widget>((dataCell) => dataCell._columnElement)
        .toList(growable: false);

    return _VirtualizingCellsRenderObjectWidget(
      key: widget.key,
      dataRow: widget.dataRow,
      isDirty: widget.isDirty,
      children: List.from(children),
    );
  }
}

class _VirtualizingCellsRenderObjectWidget
    extends MultiChildRenderObjectWidget {
  _VirtualizingCellsRenderObjectWidget(
      {@required Key key, this.dataRow, this.isDirty, this.children})
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

  double width = 0;
  double height = 0;
  Rect cellClipRect;

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
      {List<RenderBox> children, DataRowBase dataRow, bool isDirty})
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

    dataRow?._isDirty = false;
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

  Rect rowClipRect;

  Rect _measureRowRect(double width) {
    if (dataRow.isVisible) {
      final _DataGridSettings dataGridSettings =
          dataRow._dataGridStateDetails();
      final _VisualContainerHelper container = dataGridSettings.container;

      final _VisibleLineInfo lineInfo =
          container.scrollRows.getVisibleLineAtLineIndex(dataRow.rowIndex);

      final double lineSize = lineInfo != null ? lineInfo.size : 0.0;
      var origin = (lineInfo != null) ? lineInfo.origin : 0.0;

      origin += container.verticalOffset;

      if (dataRow.rowIndex >
          _GridIndexResolver.getHeaderIndex(dataGridSettings)) {
        origin -= dataGridSettings.headerRowHeight;
      }

      // Clipping the column when frozen row applied
      if (lineInfo != null &&
          (lineInfo.isClippedBody && lineInfo.isClippedOrigin)) {
        final double top =
            lineInfo.size - lineInfo.clippedSize - lineInfo.clippedCornerExtent;
        rowClipRect = Rect.fromLTWH(0, top, width, lineSize);
      } else {
        rowClipRect = null;
      }

      rowRect = Rect.fromLTWH(0, origin, width, lineSize);
      return rowRect;
    } else {
      return Rect.zero;
    }
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
    final _DataGridSettings dataGridSettings = dataRow._dataGridStateDetails();
    final rect = _getRowRect(dataGridSettings, offset);
    var backgroundColor = Colors.transparent;
    if (dataGridSettings != null &&
        dataGridSettings.gridPaint != null &&
        dataRow != null) {
      dataGridSettings.gridPaint.style = PaintingStyle.fill;

      if (dataRow.rowRegion == RowRegion.header &&
          dataRow.rowType == RowType.headerRow) {
        backgroundColor =
            dataGridSettings.dataGridThemeData.headerStyle.backgroundColor;
      } else {
        backgroundColor = dataRow.isSelectedRow
            ? dataRow.rowStyle != null &&
                    dataRow._stylePreference ==
                        StylePreference.styleAndSelection
                ? DataGridCellStyle.lerp(
                        dataGridSettings.dataGridThemeData.selectionStyle,
                        dataRow.rowStyle,
                        0.5)
                    .backgroundColor
                : dataGridSettings
                    .dataGridThemeData.selectionStyle.backgroundColor
            : dataRow.rowStyle != null
                ? dataRow.rowStyle.backgroundColor ??
                    dataGridSettings.dataGridThemeData.cellStyle.backgroundColor
                : dataGridSettings.dataGridThemeData.cellStyle.backgroundColor;
      }

      dataGridSettings.gridPaint?.color = backgroundColor;
      context.canvas.drawRect(rect, dataGridSettings.gridPaint);
    }
  }

  void _drawCurrentRowBorder(PaintingContext context, Offset offset) {
    if (!kIsWeb) {
      return;
    }

    final _DataGridSettings dataGridSettings = dataRow._dataGridStateDetails();

    if (dataGridSettings.boxPainter != null &&
        dataGridSettings.selectionMode == SelectionMode.multiple &&
        dataGridSettings.navigationMode == GridNavigationMode.row &&
        dataGridSettings.currentCell.rowIndex == dataRow.rowIndex) {
      bool needToSetMaxConstraint() =>
          dataGridSettings.container.extentWidth < dataGridSettings.viewWidth &&
          dataGridSettings.textDirection == TextDirection.rtl;

      final double stokeWidth = 1;
      final origin = (stokeWidth / 2 +
              dataGridSettings.dataGridThemeData.gridLineStrokeWidth)
          .ceil();

      final Rect rowRect = _getRowRect(dataGridSettings, offset);
      final maxWidth = needToSetMaxConstraint()
          ? rowRect.width - rowRect.left
          : rowRect.right - rowRect.left;

      final isHorizontalGridLinesEnabled =
          dataGridSettings.gridLinesVisibility == GridLinesVisibility.both ||
              dataGridSettings.gridLinesVisibility ==
                  GridLinesVisibility.horizontal;

      dataGridSettings.boxPainter.paint(
          context.canvas,
          Offset(rowRect.left + origin, rowRect.top + (origin / 2)),
          dataGridSettings.configuration.copyWith(
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

  @override
  bool get isRepaintBoundary => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    _RenderGridCell child = lastChild;
    while (child != null) {
      final _VirtualizingCellWidgetParentData childParentData =
          child.parentData;
      final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          if (child.cellClipRect != null &&
              !child.cellClipRect.contains(transformed)) {
            return false;
          }

          return child.hitTest(result, position: transformed);
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
  void performLayout() {
    void _layout({RenderBox child, double width, double height}) {
      child.layout(BoxConstraints.tightFor(width: width, height: height),
          parentUsesSize: true);
    }

    RenderBox child = firstChild;
    while (child != null) {
      final _VirtualizingCellWidgetParentData _parentData = child.parentData;
      final _RenderGridCell gridCell = child;
      if (dataRow.isVisible && gridCell.dataCell.isVisible) {
        size = constraints
            .constrain(Size(constraints.maxWidth, constraints.maxHeight));
        final Rect columnRect =
            gridCell._measureColumnRect(constraints.maxHeight);
        _parentData
          ..width = columnRect.width
          ..height = columnRect.height
          ..cellClipRect = gridCell.cellClipRect;
        _layout(
            child: child,
            width: _parentData.width,
            height: constraints.maxHeight);
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

    RenderBox child = firstChild;
    while (child != null) {
      final _VirtualizingCellWidgetParentData childParentData =
          child.parentData;
      if (childParentData.width != 0.0 && childParentData.height != 0.0) {
        if (childParentData.cellClipRect != null) {
          context.pushClipRect(
            needsCompositing,
            childParentData.offset + offset,
            childParentData.cellClipRect,
            (context, offset) {
              context.paintChild(child, offset);
            },
            clipBehavior: Clip.antiAlias,
          );
        } else {
          context.paintChild(child, childParentData.offset + offset);
        }
      }
      child = childParentData.nextSibling;
    }

    _drawCurrentRowBorder(context, offset);
  }
}

class _HeaderCellsWidget extends _VirtualizingCellsWidget {
  const _HeaderCellsWidget(
      {@required key, @required DataRowBase dataRow, bool isDirty})
      : super(key: key, dataRow: dataRow, isDirty: isDirty);
}
