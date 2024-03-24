import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../axis/axis.dart';
import '../series/chart_series.dart';
import '../utils/enum.dart';
import 'marker.dart';

mixin ChartElementParentDataMixin<T, D> {
  ChartSeriesRenderer<T, D>? renderer;

  List<D?>? xRawValues;

  List<num>? xValues;

  List<List<num>>? yLists;

  DoubleRange? sbsInfo;

  List<num>? stackedYValues;

  List<int>? sortedIndexes;

  CurvedAnimation? animation;
}

class ChartFadeTransition extends FadeTransition {
  const ChartFadeTransition({
    super.key,
    required super.opacity,
    super.child,
  });

  @override
  RenderChartFadeTransition createRenderObject(BuildContext context) {
    return RenderChartFadeTransition(
      opacity: opacity,
      alwaysIncludeSemantics: alwaysIncludeSemantics,
    );
  }
}

class RenderChartFadeTransition extends RenderAnimatedOpacity {
  RenderChartFadeTransition({
    required super.opacity,
    super.alwaysIncludeSemantics,
  });

  ChartMarker markerAt(int pointIndex) {
    if (child != null && child is RenderChartElementStack) {
      return (child! as RenderChartElementStack).markerAt(pointIndex);
    }
    return ChartMarker();
  }

  void refresh() {
    markNeedsLayout();
    (child as RenderChartElementStack?)?.refresh();
  }

  void handlePointerHover(Offset localPosition) {
    (child as RenderChartElementStack?)?.handlePointerHover(localPosition);
  }

  void handleTapUp(Offset localPosition) {
    (child as RenderChartElementStack?)?.handleTapUp(localPosition);
  }

  void handleMultiSeriesDataLabelCollisions() {
    (child as RenderChartElementStack?)?.handleMultiSeriesDataLabelCollisions();
  }
}

class ChartElementLayoutBuilder<T, D>
    extends ConstrainedLayoutBuilder<BoxConstraints> {
  const ChartElementLayoutBuilder({
    super.key,
    required this.state,
    required super.builder,
  });

  final ChartElementParentDataMixin<T, D> state;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderChartElementLayoutBuilder<T, D>()..state = state;
  }
}

class RenderChartElementLayoutBuilder<T, D> extends RenderBox
    with
        RenderObjectWithChildMixin<RenderBox>,
        RenderConstrainedLayoutBuilder<BoxConstraints, RenderBox>,
        ChartElementParentDataMixin<T, D> {
  late ChartElementParentDataMixin<T, D> state;

  @override
  bool get sizedByParent => true;

  ChartMarker markerAt(int pointIndex) {
    if (child != null && child is RenderChartFadeTransition) {
      return (child! as RenderChartFadeTransition).markerAt(pointIndex);
    }
    return ChartMarker();
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  void refresh() {
    markNeedsBuild();
    (child as RenderChartFadeTransition?)?.refresh();
  }

  @override
  void performLayout() {
    state
      ..renderer = renderer
      ..xRawValues = xRawValues
      ..xValues = xValues
      ..yLists = yLists
      ..stackedYValues = stackedYValues
      ..sortedIndexes = sortedIndexes
      ..sbsInfo = sbsInfo
      ..animation = animation;
    rebuildIfNecessary();
    child?.layout(constraints);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return child?.hitTest(result, position: position) ?? false;
  }

  void handlePointerHover(Offset localPosition) {
    (child as RenderChartFadeTransition?)?.handlePointerHover(localPosition);
  }

  void handleTapUp(Offset localPosition) {
    (child as RenderChartFadeTransition?)?.handleTapUp(localPosition);
  }

  void handleMultiSeriesDataLabelCollisions() {
    (child as RenderChartFadeTransition?)
        ?.handleMultiSeriesDataLabelCollisions();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      context.paintChild(child!, offset);
    }
  }
}

class ChartElementParentData extends ContainerBoxParentData<RenderBox> {
  num? x;
  num? y;
  int dataPointIndex = -1;
  ChartDataPointType position = ChartDataPointType.y;
  ChartDataLabelAlignment labelAlignment = ChartDataLabelAlignment.auto;
  Rect bounds = Rect.zero;
  Rect rotatedBounds = Rect.zero;
  bool isVisible = true;
}

class ChartElementStack extends MultiChildRenderObjectWidget {
  const ChartElementStack({
    super.key,
    super.children,
  });

  @override
  RenderChartElementStack createRenderObject(BuildContext context) {
    return RenderChartElementStack();
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderChartElementStack renderObject) {
    super.updateRenderObject(context, renderObject);
  }
}

class RenderChartElementStack extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, ChartElementParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, ChartElementParentData> {
  ChartMarker markerAt(int pointIndex) => ChartMarker();

  void refresh() {
    markNeedsLayout();
  }

  void handlePointerHover(Offset localPosition) {}

  void handleTapUp(Offset localPosition) {}

  // Once all cartesian series layouts are completed, use this method to
  // handle the collisions of data labels across multiple series.
  void handleMultiSeriesDataLabelCollisions() {}
}
