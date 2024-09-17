import 'package:flutter/foundation.dart';
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

  void handleDataLabelCollision(CartesianSeriesRenderer series) {
    (child as RenderChartElementStack?)?.handleDataLabelCollision(series);
  }
}

class ChartElementLayoutBuilder<T, D>
    extends CustomConstrainedLayoutBuilder<BoxConstraints> {
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
        CustomRenderConstrainedLayoutBuilder<BoxConstraints, RenderBox>,
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

  void handleDataLabelCollision(CartesianSeriesRenderer series) {
    (child as RenderChartFadeTransition?)?.handleDataLabelCollision(series);
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

  // To handle multiple series data collision, we need to check the data label
  // collision for all the series after data label layout.
  void handleDataLabelCollision(CartesianSeriesRenderer series) {}
}

abstract class CustomConstrainedLayoutBuilder<
    ConstraintType extends Constraints> extends RenderObjectWidget {
  const CustomConstrainedLayoutBuilder({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, ConstraintType constraints)
      builder;

  @override
  RenderObjectElement createElement() =>
      CustomLayoutBuilderElement<ConstraintType>(this);

  @protected
  bool updateShouldRebuild(
          covariant CustomConstrainedLayoutBuilder<ConstraintType> oldWidget) =>
      true;
}

class CustomLayoutBuilderElement<ConstraintType extends Constraints>
    extends RenderObjectElement {
  CustomLayoutBuilderElement(
      CustomConstrainedLayoutBuilder<ConstraintType> super.widget);

  @override
  CustomRenderConstrainedLayoutBuilder<ConstraintType, RenderObject>
      get renderObject => super.renderObject
          as CustomRenderConstrainedLayoutBuilder<ConstraintType, RenderObject>;

  Element? _child;

  @override
  void visitChildren(ElementVisitor visitor) {
    if (_child != null) {
      visitor(_child!);
    }
  }

  @override
  void forgetChild(Element child) {
    assert(child == _child);
    _child = null;
    super.forgetChild(child);
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    renderObject.updateCallback(_layout);
  }

  @override
  void update(CustomConstrainedLayoutBuilder<ConstraintType> newWidget) {
    assert(widget != newWidget);
    final CustomConstrainedLayoutBuilder<ConstraintType> oldWidget =
        widget as CustomConstrainedLayoutBuilder<ConstraintType>;
    super.update(newWidget);
    assert(widget == newWidget);

    renderObject.updateCallback(_layout);
    if (newWidget.updateShouldRebuild(oldWidget)) {
      renderObject.markNeedsBuild();
    }
  }

  @override
  void performRebuild() {
    renderObject.markNeedsBuild();
    super.performRebuild();
  }

  @override
  void unmount() {
    renderObject.updateCallback(null);
    super.unmount();
  }

  void _layout(ConstraintType constraints) {
    @pragma('vm:notify-debugger-on-exception')
    void layoutCallback() {
      Widget built;
      try {
        built = (widget as CustomConstrainedLayoutBuilder<ConstraintType>)
            .builder(this, constraints);
        debugWidgetBuilderValue(widget, built);
      } catch (e, stack) {
        built = ErrorWidget.builder(
          _reportException(
            ErrorDescription('building $widget'),
            e,
            stack,
            informationCollector: () => <DiagnosticsNode>[
              if (kDebugMode) DiagnosticsDebugCreator(DebugCreator(this)),
            ],
          ),
        );
      }
      try {
        _child = updateChild(_child, built, null);
        assert(_child != null);
      } catch (e, stack) {
        built = ErrorWidget.builder(
          _reportException(
            ErrorDescription('building $widget'),
            e,
            stack,
            informationCollector: () => <DiagnosticsNode>[
              if (kDebugMode) DiagnosticsDebugCreator(DebugCreator(this)),
            ],
          ),
        );
        _child = updateChild(null, built, slot);
      }
    }

    owner!.buildScope(this, layoutCallback);
  }

  @override
  void insertRenderObjectChild(RenderObject child, Object? slot) {
    final RenderObjectWithChildMixin<RenderObject> renderObject =
        this.renderObject;
    assert(slot == null);
    assert(renderObject.debugValidateChild(child));
    renderObject.child = child;
    assert(renderObject == this.renderObject);
  }

  @override
  void moveRenderObjectChild(
      RenderObject child, Object? oldSlot, Object? newSlot) {
    assert(false);
  }

  @override
  void removeRenderObjectChild(RenderObject child, Object? slot) {
    final CustomRenderConstrainedLayoutBuilder<ConstraintType, RenderObject>
        renderObject = this.renderObject;
    assert(renderObject.child == child);
    renderObject.child = null;
    assert(renderObject == this.renderObject);
  }
}

mixin CustomRenderConstrainedLayoutBuilder<ConstraintType extends Constraints,
    ChildType extends RenderObject> on RenderObjectWithChildMixin<ChildType> {
  LayoutCallback<ConstraintType>? _callback;

  void updateCallback(LayoutCallback<ConstraintType>? value) {
    if (value == _callback) {
      return;
    }
    _callback = value;
    markNeedsLayout();
  }

  bool _needsBuild = true;

  void markNeedsBuild() {
    _needsBuild = true;
    markNeedsLayout();
  }

  Constraints? _previousConstraints;

  void rebuildIfNecessary() {
    assert(_callback != null);
    if (_needsBuild || constraints != _previousConstraints) {
      _previousConstraints = constraints;
      _needsBuild = false;
      invokeLayoutCallback(_callback!);
    }
  }
}

class CustomLayoutBuilder
    extends CustomConstrainedLayoutBuilder<BoxConstraints> {
  const CustomLayoutBuilder({
    super.key,
    required super.builder,
  });

  @override
  RenderObject createRenderObject(BuildContext context) =>
      CustomRenderLayoutBuilder();
}

class CustomRenderLayoutBuilder extends RenderBox
    with
        RenderObjectWithChildMixin<RenderBox>,
        CustomRenderConstrainedLayoutBuilder<BoxConstraints, RenderBox> {
  @override
  double computeMinIntrinsicWidth(double height) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    assert(debugCannotComputeDryLayout(
      reason:
          'Calculating the dry layout would require running the layout callback '
          'speculatively, which might mutate the live render object tree.',
    ));
    return Size.zero;
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    rebuildIfNecessary();
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(child!.size);
    } else {
      size = constraints.biggest;
    }
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    if (child != null) {
      return child!.getDistanceToActualBaseline(baseline);
    }
    return super.computeDistanceToActualBaseline(baseline);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return child?.hitTest(result, position: position) ?? false;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      context.paintChild(child!, offset);
    }
  }

  bool _debugThrowIfNotCheckingIntrinsics() {
    assert(() {
      if (!RenderObject.debugCheckingIntrinsics) {
        throw FlutterError(
          'LayoutBuilder does not support returning intrinsic dimensions.\n'
          'Calculating the intrinsic dimensions would require running the layout '
          'callback speculatively, which might mutate the live render object tree.',
        );
      }
      return true;
    }());

    return true;
  }
}

FlutterErrorDetails _reportException(
  DiagnosticsNode context,
  Object exception,
  StackTrace stack, {
  InformationCollector? informationCollector,
}) {
  final FlutterErrorDetails details = FlutterErrorDetails(
    exception: exception,
    stack: stack,
    library: 'widgets library',
    context: context,
    informationCollector: informationCollector,
  );
  FlutterError.reportError(details);
  return details;
}
