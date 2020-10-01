part of datagrid;

class _VisualContainer extends StatefulWidget {
  const _VisualContainer(
      {Key key, this.rowGenerator, this.containerSize, this.isDirty})
      : super(key: key);

  final Size containerSize;
  final _RowGenerator rowGenerator;
  final bool isDirty;

  @override
  State<StatefulWidget> createState() => _VisualContainerState();
}

class _VisualContainerState extends State<_VisualContainer> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> children = widget.rowGenerator.items
        .where((row) =>
            row.rowRegion == RowRegion.body || row.rowType == RowType.dataRow)
        .map<Widget>((dataRow) => _VirtualizingCellsWidget(
              key: dataRow._key,
              dataRow: dataRow,
              isDirty: widget.isDirty || dataRow._isDirty,
            ))
        .toList(growable: false);

    return _VisualContainerRenderObjectWidget(
      key: widget.key,
      containerSize: widget.containerSize,
      isDirty: widget.isDirty,
      children: children,
    );
  }
}

class _VisualContainerRenderObjectWidget extends MultiChildRenderObjectWidget {
  _VisualContainerRenderObjectWidget(
      {Key key, this.containerSize, this.isDirty, this.children})
      : super(key: key, children: RepaintBoundary.wrapAll(List.from(children)));

  @override
  final List<Widget> children;
  final Size containerSize;
  final bool isDirty;

  @override
  _RenderVisualContainer createRenderObject(BuildContext context) =>
      _RenderVisualContainer(containerSize: containerSize, isDirty: isDirty);

  @override
  void updateRenderObject(
      BuildContext context, _RenderVisualContainer renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..containerSize = containerSize
      ..isDirty = isDirty;
  }
}

class _VisualContainerParentData extends ContainerBoxParentData<RenderBox> {
  _VisualContainerParentData();

  double width;
  double height;
  Rect rowClipRect;

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
      {List<RenderBox> children, Size containerSize, bool isDirty})
      : _containerSize = containerSize,
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
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    _RenderVirtualizingCellsWidget child = lastChild;
    while (child != null) {
      final _VisualContainerParentData childParentData = child.parentData;
      final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          if (child.rowClipRect != null &&
              !child.rowClipRect.contains(transformed)) {
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
    size =
        constraints.constrain(Size(containerSize.width, containerSize.height));

    void _layout({RenderBox child, double width, double height}) {
      child.layout(BoxConstraints.tightFor(width: width, height: height),
          parentUsesSize: true);
    }

    RenderBox child = firstChild;
    while (child != null) {
      final _VisualContainerParentData _parentData = child.parentData;
      final _RenderVirtualizingCellsWidget wholeRowElement = child;
      if (wholeRowElement.dataRow.isVisible) {
        final Rect rowRect = wholeRowElement._measureRowRect(size.width);
        _parentData
          ..width = rowRect.width
          ..height = rowRect.height
          ..rowClipRect = wholeRowElement.rowClipRect;
        _layout(
            child: child, width: _parentData.width, height: _parentData.height);
        _parentData.offset = Offset(rowRect.left, rowRect.top);
      } else {
        child.layout(const BoxConstraints.tightFor(width: 0.0, height: 0.0));
        _parentData.reset();
      }

      child = _parentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox child = firstChild;
    while (child != null) {
      final _VisualContainerParentData childParentData = child.parentData;
      if (childParentData.width != 0.0 && childParentData.height != 0.0) {
        if (childParentData.rowClipRect != null) {
          context.pushClipRect(
            needsCompositing,
            childParentData.offset + offset,
            childParentData.rowClipRect,
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
  }
}
