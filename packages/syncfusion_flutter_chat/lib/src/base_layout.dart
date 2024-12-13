import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class _LayoutParentData extends ContainerBoxParentData<RenderBox> {}

class LayoutHandler extends MultiChildRenderObjectWidget {
  const LayoutHandler({super.key, required super.children});

  @override
  RenderBox createRenderObject(BuildContext context) {
    return _RenderLayoutHandler();
  }
}

class _RenderLayoutHandler extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _LayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _LayoutParentData> {
  final LayerHandle<ClipRectLayer> _clipRectLayer =
      LayerHandle<ClipRectLayer>();

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! _LayoutParentData) {
      child.parentData = _LayoutParentData();
    }
    super.setupParentData(child);
  }

  @override
  void performLayout() {
    const Size minConstraints = Size(300.0, 300.0);
    final double boxWidth = constraints.maxWidth.isFinite
        ? constraints.maxWidth
        : minConstraints.width;
    final double boxHeight = constraints.maxHeight.isFinite
        ? constraints.maxHeight
        : minConstraints.height;

    double availableHeight = boxHeight;
    RenderBox? child = lastChild;
    while (child != null) {
      child.layout(
        BoxConstraints.loose(Size(boxWidth, availableHeight)),
        parentUsesSize: true,
      );
      availableHeight -= child.size.height;
      child = (child.parentData! as _LayoutParentData).previousSibling;
    }

    child = firstChild;
    Offset effectiveOffset = Offset.zero;
    while (child != null) {
      final _LayoutParentData childParentData =
          child.parentData! as _LayoutParentData;
      childParentData.offset = effectiveOffset;
      effectiveOffset += Offset(0.0, child.size.height);
      child = childParentData.nextSibling;
    }

    size = Size(boxWidth, boxHeight);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _clipRectLayer.layer = context.pushClipRect(
      needsCompositing,
      offset,
      Offset.zero & size,
      defaultPaint,
      clipBehavior: Clip.antiAlias,
      oldLayer: _clipRectLayer.layer,
    );
  }

  @override
  void dispose() {
    _clipRectLayer.layer = null;
    super.dispose();
  }
}
