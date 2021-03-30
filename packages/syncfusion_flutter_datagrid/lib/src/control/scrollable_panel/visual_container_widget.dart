part of datagrid;

class _VisualContainer extends StatefulWidget {
  const _VisualContainer(
      {required Key key,
      required this.rowGenerator,
      required this.containerSize,
      required this.isDirty,
      required this.dataGridSettings})
      : super(key: key);

  final Size containerSize;
  final _RowGenerator rowGenerator;
  final bool isDirty;
  final _DataGridSettings dataGridSettings;

  @override
  State<StatefulWidget> createState() => _VisualContainerState();
}

class _VisualContainerState extends State<_VisualContainer> {
  void _addSwipeBackgroundWidget(List<Widget> children) {
    final dataGridSettings = widget.dataGridSettings;
    if (dataGridSettings.allowSwiping &&
        dataGridSettings.swipingOffset.abs() > 0.0) {
      final swipeRow = widget.rowGenerator.items
          .where((row) =>
              row.rowRegion == RowRegion.body || row.rowType == RowType.dataRow)
          .firstWhereOrNull((row) => row._isSwipingRow);
      if (swipeRow != null) {
        final swipeDirection = _SfDataGridHelper.getSwipeDirection(
            dataGridSettings, dataGridSettings.swipingOffset);

        switch (swipeDirection) {
          case DataGridRowSwipeDirection.startToEnd:
            if (dataGridSettings.startSwipeActionsBuilder != null) {
              final Widget? startSwipeWidget = dataGridSettings
                  .startSwipeActionsBuilder!(context, swipeRow._dataGridRow!);
              children.add(startSwipeWidget ?? Container());
            }
            break;
          case DataGridRowSwipeDirection.endToStart:
            if (dataGridSettings.endSwipeActionsBuilder != null) {
              final Widget? endSwipeWidget = dataGridSettings
                  .endSwipeActionsBuilder!(context, swipeRow._dataGridRow!);
              children.add(endSwipeWidget ?? Container());
            }
            break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = widget.rowGenerator.items
        .where((row) =>
            row.rowRegion == RowRegion.body || row.rowType == RowType.dataRow)
        .map<Widget>((dataRow) => _VirtualizingCellsWidget(
              key: dataRow._key!,
              dataRow: dataRow,
              isDirty: widget.isDirty || dataRow._isDirty,
            ))
        .toList();

    _addSwipeBackgroundWidget(children);

    return _VisualContainerRenderObjectWidget(
      key: widget.key,
      containerSize: widget.containerSize,
      isDirty: widget.isDirty,
      children: children,
      dataGridSettings: widget.dataGridSettings,
    );
  }
}

class _VisualContainerRenderObjectWidget extends MultiChildRenderObjectWidget {
  _VisualContainerRenderObjectWidget(
      {required Key? key,
      required this.containerSize,
      required this.isDirty,
      required this.children,
      required this.dataGridSettings})
      : super(key: key, children: RepaintBoundary.wrapAll(List.from(children)));

  @override
  final List<Widget> children;
  final Size containerSize;
  final bool isDirty;
  final _DataGridSettings dataGridSettings;

  @override
  _RenderVisualContainer createRenderObject(BuildContext context) =>
      _RenderVisualContainer(
          containerSize: containerSize,
          isDirty: isDirty,
          dataGridSettings: dataGridSettings);

  @override
  void updateRenderObject(
      BuildContext context, _RenderVisualContainer renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..containerSize = containerSize
      ..isDirty = isDirty
      .._dataGridSettings = dataGridSettings;
  }
}

class _VisualContainerParentData extends ContainerBoxParentData<RenderBox> {
  _VisualContainerParentData();

  double width = 0.0;
  double height = 0.0;
  Rect? rowClipRect;

  void reset() {
    width = 0.0;
    height = 0.0;
    offset = Offset.zero;
    rowClipRect = null;
  }
}

class _RenderVisualContainer extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _VisualContainerParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _VisualContainerParentData> {
  _RenderVisualContainer(
      {List<RenderBox>? children,
      Size containerSize = Size.zero,
      bool isDirty = false,
      _DataGridSettings? dataGridSettings})
      : _containerSize = containerSize,
        _dataGridSettings = dataGridSettings!,
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
  }

  Size get containerSize => _containerSize;
  Size _containerSize = Size.zero;

  set containerSize(Size newContainerSize) {
    if (_containerSize == newContainerSize) {
      return;
    }
    _containerSize = newContainerSize;
    markNeedsLayout();
    markNeedsPaint();
  }

  late _DataGridSettings _dataGridSettings;

  _RenderVirtualizingCellsWidget? _swipeWholeRowElement;

  @override
  bool get isRepaintBoundary => true;

  @override
  void setupParentData(RenderObject child) {
    super.setupParentData(child);
    if (child.parentData is! _VisualContainerParentData) {
      child.parentData = _VisualContainerParentData();
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = lastChild;
    while (child != null) {
      final _VisualContainerParentData childParentData =
          child.parentData as _VisualContainerParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          // Need to ensure whether the child type is _RenderVirtualizingCellsWidget
          // or not before accessing it. Because swiping widget's render object won't be
          // _RenderVirtualizingCellsWidget.
          final RenderBox? wholeRowElement = child;
          if (wholeRowElement != null &&
              wholeRowElement is _RenderVirtualizingCellsWidget &&
              wholeRowElement.rowClipRect != null &&
              !wholeRowElement.rowClipRect!.contains(transformed)) {
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

  Offset _getSwipingChildOffset(Rect swipeRowRect) {
    double dxPosition = 0.0;
    final viewWidth = _dataGridSettings.viewWidth;
    final maxSwipeOffset = _dataGridSettings.swipeMaxOffset;
    final extentWidth = _dataGridSettings.container.extentWidth;

    if (_dataGridSettings.textDirection == TextDirection.rtl &&
        viewWidth > extentWidth) {
      dxPosition = (_dataGridSettings.swipingOffset >= 0)
          ? viewWidth - extentWidth
          : viewWidth - maxSwipeOffset;
    } else {
      dxPosition = (_dataGridSettings.swipingOffset >= 0)
          ? 0.0
          : extentWidth - maxSwipeOffset;
    }

    return Offset(dxPosition, swipeRowRect.top);
  }

  @override
  void performLayout() {
    size =
        constraints.constrain(Size(containerSize.width, containerSize.height));

    void layout(
        {required RenderBox child,
        required double width,
        required double height}) {
      child.layout(BoxConstraints.tightFor(width: width, height: height),
          parentUsesSize: true);
    }

    RenderBox? child = firstChild;
    while (child != null) {
      final _VisualContainerParentData parentData =
          child.parentData as _VisualContainerParentData;
      // Need to ensure whether the child type is _RenderVirtualizingCellsWidget
      // or not before accessing it. Because swiping widget's render object won't be
      // _RenderVirtualizingCellsWidget.
      final RenderBox? wholeRowElement = child;
      if (wholeRowElement != null &&
          wholeRowElement is _RenderVirtualizingCellsWidget) {
        if (wholeRowElement.dataRow.isVisible) {
          final Rect rowRect = wholeRowElement._measureRowRect(size.width);

          parentData
            ..width = rowRect.width
            ..height = rowRect.height
            ..rowClipRect = wholeRowElement.rowClipRect
            ..offset = Offset(
                (wholeRowElement.dataRow._isSwipingRow &&
                        _dataGridSettings.swipingOffset != 0.0 &&
                        _dataGridSettings.swipingAnimation != null)
                    ? rowRect.left + _dataGridSettings.swipingAnimation!.value
                    : rowRect.left,
                rowRect.top);

          if (wholeRowElement.dataRow._isSwipingRow &&
              _dataGridSettings.swipingOffset.abs() > 0.0) {
            _swipeWholeRowElement = wholeRowElement;
          }

          layout(
              child: child, width: parentData.width, height: parentData.height);
        } else {
          child.layout(const BoxConstraints.tightFor(width: 0.0, height: 0.0));
          parentData.reset();
        }
      } else {
        // We added the swiping widget to the last position of chidren collection.
        // So, we can get it diretly from lastChild property.
        final RenderBox? swipingWidget = lastChild;
        if (swipingWidget != null && _swipeWholeRowElement != null) {
          final swipeRowRect =
              _swipeWholeRowElement!._measureRowRect(size.width);

          parentData
            ..width = _dataGridSettings.swipeMaxOffset
            ..height = swipeRowRect.height
            ..offset = _getSwipingChildOffset(swipeRowRect);

          layout(
              child: swipingWidget,
              width: parentData.width,
              height: parentData.height);
        }
      }

      child = parentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    while (child != null) {
      final _VisualContainerParentData childParentData =
          child.parentData as _VisualContainerParentData;
      final RenderBox? wholeRowElement = child;
      if (wholeRowElement != null &&
          wholeRowElement is _RenderVirtualizingCellsWidget) {
        if (childParentData.width != 0.0 && childParentData.height != 0.0) {
          if (childParentData.rowClipRect != null) {
            if (wholeRowElement.dataRow._isSwipingRow &&
                _dataGridSettings.swipingOffset.abs() > 0.0) {
              // We added the swiping widget to the last position of chidren collection.
              // So, we can get it diretly from lastChild property.
              final RenderBox? swipeWidget = lastChild;
              if (swipeWidget != null) {
                final _VisualContainerParentData childParentData =
                    swipeWidget.parentData as _VisualContainerParentData;
                context.paintChild(
                    swipeWidget, childParentData.offset + offset);
              }
            }

            context.pushClipRect(
              needsCompositing,
              childParentData.offset + offset,
              childParentData.rowClipRect!,
              (context, offset) {
                context.paintChild(child!, offset);
              },
              clipBehavior: Clip.antiAlias,
            );
          } else {
            context.paintChild(child, childParentData.offset + offset);
          }
        }
      }
      child = childParentData.nextSibling;
    }
  }
}
