import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'axis/axis.dart';
import 'axis/category_axis.dart';
import 'behaviors/crosshair.dart';
import 'behaviors/trackball.dart';
import 'behaviors/zooming.dart';
import 'common/annotation.dart';
import 'common/callbacks.dart';
import 'common/core_legend.dart';
import 'common/legend.dart';
import 'indicators/accumulation_distribution_indicator.dart';
import 'indicators/atr_indicator.dart';
import 'indicators/bollinger_bands_indicator.dart';
import 'indicators/ema_indicator.dart';
import 'indicators/macd_indicator.dart';
import 'indicators/momentum_indicator.dart';
import 'indicators/roc_indicator.dart';
import 'indicators/rsi_indicator.dart';
import 'indicators/sma_indicator.dart';
import 'indicators/stochastic_indicator.dart';
import 'indicators/technical_indicator.dart';
import 'indicators/tma_indicator.dart';
import 'indicators/wma_indicator.dart';
import 'interactions/behavior.dart';
import 'interactions/selection.dart';
import 'interactions/tooltip.dart';
import 'series/chart_series.dart';
import 'utils/constants.dart';
import 'utils/enum.dart';
import 'utils/helper.dart';
import 'utils/typedef.dart';

class ChartAreaParentData
    extends ContainerBoxParentData<ChartAreaUpdateMixin> {}

class ChartArea extends MultiChildRenderObjectWidget {
  const ChartArea({
    super.key,
    required this.legendKey,
    required this.legendItems,
    this.onChartTouchInteractionDown,
    this.onChartTouchInteractionMove,
    this.onChartTouchInteractionUp,
    required super.children,
  });

  final GlobalKey? legendKey;
  final List<LegendItem> legendItems;
  final ChartTouchInteractionCallback? onChartTouchInteractionDown;
  final ChartTouchInteractionCallback? onChartTouchInteractionMove;
  final ChartTouchInteractionCallback? onChartTouchInteractionUp;

  @override
  ChartAreaRenderObjectElement createElement() {
    return ChartAreaRenderObjectElement(this);
  }

  @override
  RenderChartArea createRenderObject(BuildContext context) {
    return RenderChartArea(
        gestureSettings: MediaQuery.of(context).gestureSettings)
      ..legendKey = legendKey
      ..legendItems = legendItems
      ..onChartTouchInteractionDown = onChartTouchInteractionDown
      ..onChartTouchInteractionMove = onChartTouchInteractionMove
      ..onChartTouchInteractionUp = onChartTouchInteractionUp;
  }

  @override
  void updateRenderObject(BuildContext context, RenderChartArea renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..legendKey = legendKey
      ..legendItems = legendItems
      ..onChartTouchInteractionDown = onChartTouchInteractionDown
      ..onChartTouchInteractionMove = onChartTouchInteractionMove
      ..onChartTouchInteractionUp = onChartTouchInteractionUp;
  }
}

class ChartAreaRenderObjectElement extends MultiChildRenderObjectElement {
  ChartAreaRenderObjectElement(super.widget);

  late RenderChartArea chartArea;
  bool _hasUpdateScheduled = false;

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot); // Chart build phase ends here.
    chartArea = renderObject as RenderChartArea;
    chartArea._scheduleUpdate = _scheduleUpdate;
    chartArea._update();
    _hasUpdateScheduled = false;
  }

  @override
  void update(MultiChildRenderObjectWidget newWidget) {
    super.update(newWidget);
    chartArea._update();
    _hasUpdateScheduled = false;
  }

  @override
  void rebuild({bool force = false}) {
    super.rebuild(force: force);
    if (_hasUpdateScheduled) {
      chartArea._update();
    }
    _hasUpdateScheduled = false;
  }

  void _scheduleUpdate() {
    if (!_hasUpdateScheduled && !dirty) {
      markNeedsBuild();
      _hasUpdateScheduled = true;
    }
  }
}

mixin ChartAreaUpdateMixin on RenderBox {
  VoidCallback? _onScheduleUpdate;
  VoidCallback? _onScheduleLegendUpdate;

  void markNeedsUpdate() {
    _onScheduleUpdate?.call();
  }

  void markNeedsLegendUpdate() {
    _onScheduleLegendUpdate?.call();
  }

  @override
  void adoptChild(RenderObject child) {
    if (child is ChartAreaUpdateMixin) {
      child._onScheduleUpdate = _onScheduleUpdate;
      child._onScheduleLegendUpdate = _onScheduleLegendUpdate;
    }
    super.adoptChild(child);
  }

  @override
  void dropChild(RenderObject child) {
    if (child is ChartAreaUpdateMixin) {
      child._onScheduleUpdate = null;
      child._onScheduleLegendUpdate = null;
    }
    super.dropChild(child);
  }

  void update() {
    performUpdate();
  }

  @protected
  void performUpdate() {
    visitChildren((RenderObject child) {
      if (child is ChartAreaUpdateMixin) {
        child.update();
      }
    });
  }

  @override
  void performLayout() {
    super.performLayout();
    performPostLayout();
  }

  @protected
  void performPostLayout() {
    visitChildren((RenderObject child) {
      if (child is ChartAreaUpdateMixin) {
        child.performPostLayout();
      }
    });
  }
}

class RenderChartArea extends RenderBox
    with
        ContainerRenderObjectMixin<ChartAreaUpdateMixin, ChartAreaParentData>,
        RenderBoxContainerDefaultsMixin<ChartAreaUpdateMixin,
            ChartAreaParentData>
    implements
        MouseTrackerAnnotation {
  RenderChartArea({
    DeviceGestureSettings? gestureSettings,
  }) {
    final GestureArenaTeam team = GestureArenaTeam();

    _tapGestureRecognizer = TapGestureRecognizer()
      ..team = team
      ..onTapDown = _handleTapDown
      ..onTapUp = _handleTapUp
      ..gestureSettings = gestureSettings;

    _doubleTapGestureRecognizer = DoubleTapGestureRecognizer()
      ..onDoubleTapDown = _handleDoubleTapDown
      ..onDoubleTap = _handleDoubleTap
      ..onDoubleTapCancel = _handleDoubleTapCancel
      ..gestureSettings = gestureSettings;

    _longPressGestureRecognizer = LongPressGestureRecognizer()
      ..team = team
      ..onLongPressStart = _handleLongPressStart
      ..onLongPressMoveUpdate = _handleLongPressMoveUpdate
      ..onLongPressEnd = _handleLongPressEnd
      ..gestureSettings = gestureSettings;

    _scaleGestureRecognizer = ScaleGestureRecognizer()
      ..onStart = _handleScaleStart
      ..onUpdate = _handleScaleUpdate
      ..onEnd = _handleScaleEnd
      ..gestureSettings = gestureSettings;

    _horizontalDragGestureRecognizer = HorizontalDragGestureRecognizer()
      ..team = team
      ..onStart = _handleHorizontalDragStart
      ..onUpdate = _handleHorizontalDragUpdate
      ..onEnd = _handleHorizontalDragEnd
      ..gestureSettings = gestureSettings;

    _verticalDragGestureRecognizer = VerticalDragGestureRecognizer()
      ..team = team
      ..onStart = _handleVerticalDragStart
      ..onUpdate = _handleVerticalDragUpdate
      ..onEnd = _handleVerticalDragEnd
      ..gestureSettings = gestureSettings;
  }

  GlobalKey? legendKey;
  List<LegendItem>? legendItems;
  RenderChartPlotArea? _plotArea;
  RenderIndicatorArea? _indicatorArea;

  bool _needsLegendUpdate = true;
  bool _validForMouseTracker = false;
  bool _isScaled = false;
  bool _isPanned = false;
  late VoidCallback? _scheduleUpdate;

  TapGestureRecognizer? _tapGestureRecognizer;
  DoubleTapGestureRecognizer? _doubleTapGestureRecognizer;
  LongPressGestureRecognizer? _longPressGestureRecognizer;
  ScaleGestureRecognizer? _scaleGestureRecognizer;
  HorizontalDragGestureRecognizer? _horizontalDragGestureRecognizer;
  VerticalDragGestureRecognizer? _verticalDragGestureRecognizer;

  RenderCartesianAxes? _cartesianAxes;
  RenderBehaviorArea? _behaviorArea;

  ChartTouchInteractionCallback? onChartTouchInteractionDown;
  ChartTouchInteractionCallback? onChartTouchInteractionMove;
  ChartTouchInteractionCallback? onChartTouchInteractionUp;

  Offset? _doubleTapPosition;
  int _pointerCount = 0;

  @override
  bool get isRepaintBoundary => true;

  @override
  bool get validForMouseTracker => _validForMouseTracker;

  @override
  MouseCursor get cursor => SystemMouseCursors.basic;

  @override
  PointerEnterEventListener? get onEnter => _handlePointerEnter;

  @override
  PointerExitEventListener? get onExit => _handlePointerExit;

  void scheduleUpdateFrame() {
    _scheduleUpdate!();
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! ChartAreaParentData) {
      child.parentData = ChartAreaParentData();
    }
  }

  @override
  void insert(ChartAreaUpdateMixin child, {ChartAreaUpdateMixin? after}) {
    child._onScheduleUpdate = scheduleUpdateFrame;
    child._onScheduleLegendUpdate = markNeedsLegendUpdate;
    super.insert(child, after: after);
  }

  @override
  void remove(ChartAreaUpdateMixin child) {
    child._onScheduleUpdate = null;
    child._onScheduleLegendUpdate = null;
    super.remove(child);
  }

  @override
  void attach(PipelineOwner owner) {
    _validForMouseTracker = true;
    super.attach(owner);
  }

  @override
  void detach() {
    _validForMouseTracker = false;
    super.detach();
  }

  void markNeedsLegendUpdate() {
    _needsLegendUpdate = true;
    _collectAndUpdateLegend();
  }

  void _update() {
    visitChildren((RenderObject child) {
      if (child is ChartAreaUpdateMixin) {
        child.update();
        if (child is RenderChartPlotArea) {
          _plotArea = child;
        }
        if (child is RenderBehaviorArea && _plotArea != null) {
          _plotArea!.behaviorArea = child;
          child.plotArea = _plotArea;
        }
      }
    });

    _collectAndUpdateLegend();
  }

  void _collectAndUpdateLegend() {
    if (_needsLegendUpdate && _plotArea != null) {
      legendItems!.clear();
      List<LegendItem>? items = _plotArea?._buildLegendItems();
      if (items != null) {
        legendItems!.addAll(items);
      }
      items = _indicatorArea?._buildLegendItems();
      if (items != null) {
        legendItems!.addAll(items);
      }
      (legendKey?.currentState as LegendLayoutState?)?.update(legendItems!);
      _needsLegendUpdate = false;
    }
  }

  @override
  void performLayout() {
    RenderBox? child = firstChild;
    while (child != null) {
      final ChartAreaParentData childParentData =
          child.parentData! as ChartAreaParentData;
      child.layout(constraints);
      child = childParentData.nextSibling;
    }

    size = constraints.biggest;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    bool isHit = false;
    if (size.contains(position)) {
      RenderBox? child = lastChild;
      while (child != null) {
        final ChartAreaParentData childParentData =
            child.parentData! as ChartAreaParentData;
        final bool isChildHit = result.addWithPaintOffset(
          offset: childParentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            return child!.hitTest(result, position: transformed);
          },
        );
        isHit = isHit || isChildHit;
        child = childParentData.previousSibling;
      }

      isHit = isHit ||
          onChartTouchInteractionDown != null ||
          onChartTouchInteractionMove != null ||
          onChartTouchInteractionUp != null;

      if (isHit) {
        result.add(BoxHitTestEntry(this, position));
      }
    }

    return isHit;
  }

  @override
  @nonVirtual
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event.kind == PointerDeviceKind.mouse) {
      isHover = true;
    }

    if (event is PointerDownEvent) {
      _pointerCount++;
      _tapGestureRecognizer?.addPointer(event);
      _doubleTapGestureRecognizer?.addPointer(event);
      _longPressGestureRecognizer?.addPointer(event);
      _horizontalDragGestureRecognizer?.addPointer(event);
      _verticalDragGestureRecognizer?.addPointer(event);
      _scaleGestureRecognizer?.addPointer(event);
      _handlePointerDown(event);
    } else if (event is PointerMoveEvent) {
      if (_pointerCount != 1) {
        _horizontalDragGestureRecognizer?.rejectGesture(event.pointer);
        _verticalDragGestureRecognizer?.rejectGesture(event.pointer);
        _scaleGestureRecognizer?.acceptGesture(event.pointer);
      }
      _handlePointerMove(event);
    } else if (event is PointerHoverEvent) {
      if (defaultTargetPlatform != TargetPlatform.iOS &&
          defaultTargetPlatform != TargetPlatform.android) {
        _handlePointerHover(event);
      }
    } else if (event is PointerUpEvent) {
      _pointerCount = 0;
      _handlePointerUp(event);
    }

    if (_isBehaviorAreaHit(event.position)) {
      _behaviorArea?.handleEvent(event, entry);
    }
  }

  bool _isCartesianAxesHit(Offset globalPosition) {
    if (_cartesianAxes != null) {
      return true;
    }
    return false;
  }

  bool _isPlotAreaHit(Offset globalPosition) {
    if (_plotArea != null && attached) {
      final Offset localPosition = _plotArea!.globalToLocal(globalPosition);
      return _plotArea!.size.contains(localPosition);
    }
    return false;
  }

  bool _isBehaviorAreaHit(Offset globalPosition) {
    if (_behaviorArea != null) {
      return true;
    }
    return false;
  }

  @protected
  void _handlePointerEnter(PointerEnterEvent details) {
    if (_isBehaviorAreaHit(details.position)) {
      _behaviorArea!.handlePointerEnter(details);
    }
  }

  @protected
  void _handlePointerDown(PointerDownEvent details) {
    onChartTouchInteractionDown?.call(ChartTouchInteractionArgs()
      ..position = globalToLocal(details.position));
    if (_isPlotAreaHit(details.position)) {
      _plotArea?.visitChildren((RenderObject child) {
        if (child is ChartSeriesRenderer) {
          child.handlePointerDown(details);
        }
      });
    }
  }

  @protected
  void _handlePointerMove(PointerMoveEvent details) {
    onChartTouchInteractionMove?.call(ChartTouchInteractionArgs()
      ..position = globalToLocal(details.position));
  }

  @protected
  void _handlePointerHover(PointerHoverEvent details) {
    if (_isCartesianAxesHit(details.position)) {
      _cartesianAxes?.visitChildren((RenderObject child) {
        if (child is RenderChartAxis) {
          child.handlePointerHover(details);
        }
      });
    }
    if (_isPlotAreaHit(details.position)) {
      _plotArea!.isTooltipActivated = false;
      RenderBox? child = _plotArea?.lastChild;
      while (child != null) {
        final StackParentData childParentData =
            child.parentData! as StackParentData;
        if (child is ChartSeriesRenderer) {
          child.handlePointerHover(details);
        }
        child = childParentData.previousSibling;
      }
    }
  }

  @protected
  void _handlePointerUp(PointerUpEvent details) {
    onChartTouchInteractionUp?.call(ChartTouchInteractionArgs()
      ..position = globalToLocal(details.position));
    if (_isPlotAreaHit(details.position)) {
      _plotArea?.visitChildren((RenderObject child) {
        if (child is ChartSeriesRenderer) {
          child.handlePointerUp(details);
        }
      });
    }
  }

  @protected
  void _handlePointerExit(PointerExitEvent details) {
    if (_isBehaviorAreaHit(details.position)) {
      _behaviorArea?.handlePointerExit(details);
    }
  }

  @protected
  void _handleLongPressStart(LongPressStartDetails details) {
    if (_isPlotAreaHit(details.globalPosition)) {
      _plotArea!.isTooltipActivated = false;
      RenderBox? child = _plotArea?.lastChild;
      while (child != null) {
        final StackParentData childParentData =
            child.parentData! as StackParentData;
        if (child is ChartSeriesRenderer) {
          child.handleLongPressStart(details);
        }
        child = childParentData.previousSibling;
      }
    }
    if (_isBehaviorAreaHit(details.globalPosition)) {
      _behaviorArea?.handleLongPressStart(details);
    }
  }

  @protected
  void _handleLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    if (_isBehaviorAreaHit(details.globalPosition)) {
      _behaviorArea?.handleLongPressMoveUpdate(details);
    }
  }

  @protected
  void _handleLongPressEnd(LongPressEndDetails details) {
    if (_isBehaviorAreaHit(details.globalPosition)) {
      _behaviorArea?.handleLongPressEnd(details);
    }
  }

  @protected
  void _handleTapDown(TapDownDetails details) {
    if (_isBehaviorAreaHit(details.globalPosition)) {
      _behaviorArea?.handleTapDown(details);
    }
  }

  @protected
  void _handleTapUp(TapUpDetails details) {
    if (_isCartesianAxesHit(details.globalPosition)) {
      _cartesianAxes?.visitChildren((RenderObject child) {
        if (child is RenderChartAxis) {
          child.handleTapUp(details);
        }
      });
    }
    if (_isPlotAreaHit(details.globalPosition)) {
      _plotArea!.isTooltipActivated = false;
      RenderBox? child = _plotArea?.lastChild;
      while (child != null) {
        final StackParentData childParentData =
            child.parentData! as StackParentData;
        if (child is ChartSeriesRenderer) {
          child.handleTapUp(details);
        }
        child = childParentData.previousSibling;
      }
    }
    if (_isBehaviorAreaHit(details.globalPosition)) {
      _behaviorArea?.handleTapUp(details);
    }
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapPosition = details.globalPosition;
  }

  @protected
  void _handleDoubleTap() {
    if (_doubleTapPosition == null) {
      return;
    }
    if (_isPlotAreaHit(_doubleTapPosition!)) {
      _plotArea!.isTooltipActivated = false;
      RenderBox? child = _plotArea?.lastChild;
      while (child != null) {
        final StackParentData childParentData =
            child.parentData! as StackParentData;
        if (child is ChartSeriesRenderer) {
          child.handleDoubleTap(_doubleTapPosition!);
        }
        child = childParentData.previousSibling;
      }
    }
    if (_isBehaviorAreaHit(_doubleTapPosition!)) {
      _behaviorArea?.handleDoubleTap(_doubleTapPosition!);
    }
    _doubleTapPosition = null;
  }

  void _handleDoubleTapCancel() {
    _doubleTapPosition = null;
  }

  @protected
  void _handleScaleStart(ScaleStartDetails details) {
    if (_isBehaviorAreaHit(details.focalPoint)) {
      _isScaled = true;
      _behaviorArea?.handleScaleStart(details);
    }
  }

  @protected
  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (_isPlotAreaHit(details.focalPoint)) {
      _plotArea?.visitChildren((RenderObject child) {
        if (child is ChartSeriesRenderer) {
          child.handleScaleUpdate(details);
        }
      });
    }
    if (_isBehaviorAreaHit(details.focalPoint)) {
      _isScaled = true;
      _behaviorArea?.handleScaleUpdate(details);
    }
  }

  @protected
  void _handleScaleEnd(ScaleEndDetails details) {
    if (_isScaled) {
      _isScaled = false;
      _behaviorArea?.handleScaleEnd(details);
    }
  }

  @protected
  void _handleHorizontalDragStart(DragStartDetails details) {
    if (_isBehaviorAreaHit(details.globalPosition)) {
      _isPanned = true;
      _behaviorArea!.handleHorizontalDragStart(details);
    }
  }

  @protected
  void _handleHorizontalDragUpdate(DragUpdateDetails details) {
    if (_isBehaviorAreaHit(details.globalPosition)) {
      _isPanned = true;
      _behaviorArea!.handleHorizontalDragUpdate(details);
    }
  }

  @protected
  void _handleHorizontalDragEnd(DragEndDetails details) {
    if (_isPanned) {
      _isPanned = false;
      _behaviorArea!.handleHorizontalDragEnd(details);
    }
  }

  @protected
  void _handleVerticalDragStart(DragStartDetails details) {
    if (_isBehaviorAreaHit(details.globalPosition)) {
      _isPanned = true;
      _behaviorArea!.handleVerticalDragStart(details);
    }
  }

  @protected
  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    if (_isBehaviorAreaHit(details.globalPosition)) {
      _isPanned = true;
      _behaviorArea!.handleVerticalDragUpdate(details);
    }
  }

  @protected
  void _handleVerticalDragEnd(DragEndDetails details) {
    if (_isPanned) {
      _isPanned = false;
      _behaviorArea!.handleVerticalDragEnd(details);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  void dispose() {
    legendItems?.clear();

    _tapGestureRecognizer?.dispose();
    _doubleTapGestureRecognizer?.dispose();
    _longPressGestureRecognizer?.dispose();
    _scaleGestureRecognizer?.dispose();
    super.dispose();
  }
}

class CartesianChartArea extends ChartArea {
  const CartesianChartArea({
    super.key,
    required super.legendKey,
    required super.legendItems,
    this.plotAreaBackgroundImage,
    this.plotAreaBackgroundColor,
    super.onChartTouchInteractionDown,
    super.onChartTouchInteractionMove,
    super.onChartTouchInteractionUp,
    required super.children,
  });

  final ImageProvider? plotAreaBackgroundImage;
  final Color? plotAreaBackgroundColor;

  @override
  RenderCartesianChartArea createRenderObject(BuildContext context) {
    return RenderCartesianChartArea(
        gestureSettings: MediaQuery.of(context).gestureSettings)
      ..legendKey = legendKey
      ..legendItems = legendItems
      ..plotAreaBackgroundImage = plotAreaBackgroundImage
      ..plotAreaBackgroundColor = plotAreaBackgroundColor
      ..onChartTouchInteractionDown = onChartTouchInteractionDown
      ..onChartTouchInteractionMove = onChartTouchInteractionMove
      ..onChartTouchInteractionUp = onChartTouchInteractionUp;
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderCartesianChartArea renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject.plotAreaBackgroundImage = plotAreaBackgroundImage;
    renderObject.plotAreaBackgroundColor = plotAreaBackgroundColor;
  }
}

class RenderCartesianChartArea extends RenderChartArea {
  RenderCartesianChartArea({
    super.gestureSettings,
  });

  RenderAnnotationArea? _annotationArea;
  Image? _plotAreaImage;

  RenderCartesianAxes? get cartesianAxes => _cartesianAxes;

  ImageProvider? get plotAreaBackgroundImage => _plotAreaBackgroundImage;
  ImageProvider? _plotAreaBackgroundImage;
  set plotAreaBackgroundImage(ImageProvider? value) {
    if (_plotAreaBackgroundImage != value) {
      _plotAreaBackgroundImage = value;
      _fetchImage();
    }
  }

  Color? get plotAreaBackgroundColor => _plotAreaBackgroundColor;
  Color? _plotAreaBackgroundColor;
  set plotAreaBackgroundColor(Color? value) {
    if (plotAreaBackgroundColor != value) {
      _plotAreaBackgroundColor = value;
      markNeedsPaint();
    }
  }

  @override
  void _update() {
    if (_cartesianAxes != null) {
      _cartesianAxes!.update();
    }

    if (_plotArea != null) {
      _plotArea!.update();
      if (_behaviorArea != null) {
        _behaviorArea!.update();
        _plotArea!.behaviorArea = _behaviorArea;
      }
    }

    if (_indicatorArea != null) {
      _indicatorArea!.update();
    }

    if (_annotationArea != null) {
      _annotationArea!.update();
    }

    markNeedsLegendUpdate();
  }

  @override
  void insert(ChartAreaUpdateMixin child, {ChartAreaUpdateMixin? after}) {
    if (child is RenderCartesianChartPlotArea) {
      _plotArea = child;
    }

    if (child is RenderCartesianAxes) {
      _cartesianAxes = child;
      (_plotArea as RenderCartesianChartPlotArea?)?._cartesianAxes = child;
    }

    if (child is RenderBehaviorArea) {
      _behaviorArea = child;
      _behaviorArea!.cartesianAxes = _cartesianAxes;
      _behaviorArea!.indicatorArea = _indicatorArea;
      _behaviorArea!.plotArea = _plotArea;
      _cartesianAxes?.behaviorArea = _behaviorArea;
    }

    if (child is RenderIndicatorArea) {
      _indicatorArea = child;
    }

    if (child is RenderAnnotationArea) {
      _annotationArea = child;
    }

    super.insert(child, after: after);
  }

  @override
  void remove(ChartAreaUpdateMixin child) {
    if (child is RenderCartesianAxes) {
      _cartesianAxes = null;
    }

    if (child is RenderCartesianChartPlotArea) {
      _plotArea = null;
      child._cartesianAxes = null;
    }

    if (child is RenderBehaviorArea) {
      _behaviorArea = null;
      child.cartesianAxes = null;
      child.plotArea = null;
      _cartesianAxes?.behaviorArea = null;
    }

    if (child is RenderIndicatorArea) {
      _indicatorArea = null;
    }

    if (child is RenderAnnotationArea) {
      _annotationArea = null;
    }

    super.remove(child);
  }

  @override
  void performLayout() {
    assert(_cartesianAxes != null);
    if (_cartesianAxes != null) {
      _cartesianAxes?.layout(constraints, parentUsesSize: true);
    }

    assert(_cartesianAxes!._plotAreaConstraints != null);
    assert(_plotArea != null);
    if (_plotArea != null) {
      final Offset plotAreaOffset = _cartesianAxes!.plotAreaOffset;
      final BoxConstraints plotAreaConstraints =
          _cartesianAxes!._plotAreaConstraints!;

      ChartAreaParentData childParentData =
          _plotArea!.parentData! as ChartAreaParentData;
      childParentData.offset = plotAreaOffset;
      _plotArea!.layout(plotAreaConstraints, parentUsesSize: true);

      if (_behaviorArea != null && _behaviorArea!.parentData != null) {
        childParentData = _behaviorArea!.parentData! as ChartAreaParentData;
        childParentData.offset = plotAreaOffset;
        _behaviorArea!.layout(plotAreaConstraints);
      }

      if (_indicatorArea != null) {
        final ChartAreaParentData indicatorParentData =
            _indicatorArea!.parentData! as ChartAreaParentData;
        indicatorParentData.offset = _cartesianAxes!.plotAreaOffset;
        _indicatorArea!.layout(_cartesianAxes!._plotAreaConstraints!);
      }

      if (_annotationArea != null) {
        _annotationArea!._plotAreaOffset = plotAreaOffset;
        _annotationArea!._plotAreaBounds = plotAreaOffset & _plotArea!.size;
        _annotationArea!.layout(constraints);
      }
    }

    size = constraints.biggest;
  }

  void _fetchImage() {
    if (plotAreaBackgroundImage != null) {
      fetchImage(plotAreaBackgroundImage).then((Image? value) {
        _plotAreaImage = value;
        markNeedsPaint();
      });
    } else {
      _plotAreaImage = null;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // The plot area image and background should be drawn in the chart area,
    // as it is meant to be positioned below the axis grid lines.
    if (_plotArea != null) {
      final Offset paintOffset =
          (_plotArea!.parentData! as BoxParentData).offset;
      final Rect rect = (offset + paintOffset) & _plotArea!.size;
      if (_plotAreaImage != null) {
        paintImage(
          canvas: context.canvas,
          rect: rect,
          image: _plotAreaImage!,
          fit: BoxFit.fill,
        );
      }

      if (plotAreaBackgroundColor != null) {
        context.canvas.drawRect(
          rect,
          Paint()
            ..isAntiAlias = true
            ..color = plotAreaBackgroundColor!,
        );
      }
    }

    if (_cartesianAxes != null) {
      _cartesianAxes!._isGridLinePaint = true;
      context.paintChild(_cartesianAxes!,
          (_cartesianAxes!.parentData! as BoxParentData).offset + offset);
    }

    defaultPaint(context, offset);
  }

  @override
  void dispose() {
    _plotAreaImage?.dispose();
    super.dispose();
  }
}

class ChartPlotArea extends MultiChildRenderObjectWidget {
  const ChartPlotArea({
    super.key,
    required this.vsync,
    required this.localizations,
    required this.legendKey,
    required this.backgroundColor,
    this.borderColor,
    required this.borderWidth,
    this.enableAxisAnimation = false,
    required this.legend,
    required this.onLegendItemRender,
    required this.onLegendTapped,
    this.onDataLabelRender,
    this.onMarkerRender,
    this.onTooltipRender,
    this.onDataLabelTapped,
    required this.palette,
    required this.selectionMode,
    required this.selectionGesture,
    required this.enableMultiSelection,
    this.tooltipBehavior,
    this.onSelectionChanged,
    required this.chartThemeData,
    required this.themeData,
    required super.children,
  });

  final TickerProvider vsync;
  final SfLocalizations? localizations;
  final GlobalKey? legendKey;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final bool enableAxisAnimation;
  final Legend legend;
  final ChartLegendRenderCallback? onLegendItemRender;
  final ChartLegendTapCallback? onLegendTapped;
  final ChartDataLabelRenderCallback? onDataLabelRender;
  final ChartMarkerRenderCallback? onMarkerRender;
  final ChartTooltipCallback? onTooltipRender;
  final DataLabelTapCallback? onDataLabelTapped;
  final List<Color> palette;
  final SelectionType selectionMode;
  final ActivationMode selectionGesture;
  final bool enableMultiSelection;
  final TooltipBehavior? tooltipBehavior;
  final ChartSelectionCallback? onSelectionChanged;
  final SfChartThemeData chartThemeData;
  final ThemeData themeData;

  @override
  RenderChartPlotArea createRenderObject(BuildContext context) {
    final RenderChartPlotArea plotArea = RenderChartPlotArea();
    plotArea
      ..vsync = vsync
      ..backgroundColor = backgroundColor
      ..borderColor = borderColor
      ..borderWidth = borderWidth
      ..enableAxisAnimation = enableAxisAnimation
      ..legend = legend
      ..onLegendItemRender = onLegendItemRender
      ..onLegendTapped = onLegendTapped
      ..onDataLabelRender = onDataLabelRender
      ..onMarkerRender = onMarkerRender
      ..onTooltipRender = onTooltipRender
      ..onDataLabelTapped = onDataLabelTapped
      ..palette = palette
      ..selectionMode = selectionMode
      ..selectionGesture = selectionGesture
      ..enableMultiSelection = enableMultiSelection
      ..tooltipBehavior = tooltipBehavior
      ..onSelectionChanged = onSelectionChanged
      ..chartThemeData = chartThemeData
      ..themeData = themeData;
    return plotArea;
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderChartPlotArea renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..backgroundColor = backgroundColor
      ..borderColor = borderColor
      ..borderWidth = borderWidth
      ..enableAxisAnimation = enableAxisAnimation
      ..legend = legend
      ..onLegendItemRender = onLegendItemRender
      ..onLegendTapped = onLegendTapped
      ..onDataLabelRender = onDataLabelRender
      ..onDataLabelTapped = onDataLabelTapped
      ..onMarkerRender = onMarkerRender
      ..onTooltipRender = onTooltipRender
      ..palette = palette
      ..selectionMode = selectionMode
      ..selectionGesture = selectionGesture
      ..enableMultiSelection = enableMultiSelection
      ..tooltipBehavior = tooltipBehavior
      ..onSelectionChanged = onSelectionChanged
      ..chartThemeData = chartThemeData
      ..themeData = themeData;
  }
}

class RenderChartPlotArea extends RenderStack with ChartAreaUpdateMixin {
  RenderChartPlotArea({
    super.textDirection = TextDirection.ltr,
  });

  GlobalKey? legendKey;
  Legend? legend;

  ChartLegendRenderCallback? onLegendItemRender;
  ChartLegendTapCallback? onLegendTapped;
  ChartDataLabelRenderCallback? onDataLabelRender;
  ChartTooltipCallback? onTooltipRender;
  ChartMarkerRenderCallback? onMarkerRender;
  SeriesRender render = SeriesRender.normal;

  DataLabelTapCallback? onDataLabelTapped;
  ChartSelectionCallback? onSelectionChanged;

  late final SelectionController selectionController =
      SelectionController(this);
  RenderBehaviorArea? behaviorArea;
  SfLocalizations? localizations;

  Function(Offset)? onTouchDown;
  Function(Offset)? onTouchMove;
  Function(Offset)? onTouchUp;

  /// The [TickerProvider] for the [AnimationController] that
  /// runs the animation.
  TickerProvider? get vsync => _vsync;
  TickerProvider? _vsync;
  set vsync(TickerProvider? value) {
    if (_vsync != value) {
      _vsync = value;
    }
  }

  Color? get backgroundColor => _backgroundColor;
  Color? _backgroundColor;
  set backgroundColor(Color? value) {
    if (_backgroundColor != value) {
      _backgroundColor = value;
      markNeedsPaint();
    }
  }

  Color? get borderColor => _borderColor;
  Color? _borderColor;
  set borderColor(Color? value) {
    if (_borderColor != value) {
      _borderColor = value;
      markNeedsPaint();
    }
  }

  double get borderWidth => _borderWidth;
  double _borderWidth = 1;
  set borderWidth(double value) {
    if (_borderWidth != value) {
      _borderWidth = value;
      markNeedsPaint();
    }
  }

  bool get enableAxisAnimation => _enableAxisAnimation;
  bool _enableAxisAnimation = false;
  set enableAxisAnimation(bool value) {
    if (_enableAxisAnimation != value) {
      _enableAxisAnimation = value;
    }
  }

  List<Color>? get palette => _palette;
  List<Color>? _palette;
  set palette(List<Color>? value) {
    if (_palette != value) {
      _palette = value;
    }
  }

  SelectionType get selectionMode => _selectionMode;
  SelectionType _selectionMode = SelectionType.point;
  set selectionMode(SelectionType value) {
    if (_selectionMode != value) {
      selectionController.resetSelection();
      _selectionMode = value;
    }
  }

  ActivationMode get selectionGesture => _selectionGesture;
  ActivationMode _selectionGesture = ActivationMode.singleTap;
  set selectionGesture(ActivationMode value) {
    if (_selectionGesture != value) {
      _selectionGesture = value;
    }
  }

  bool get enableMultiSelection => _enableMultipleSelection;
  bool _enableMultipleSelection = false;
  set enableMultiSelection(bool value) {
    if (_enableMultipleSelection != value) {
      _enableMultipleSelection = value;
      selectionController.enableMultiSelection = value;
    }
  }

  TooltipBehavior? get tooltipBehavior => _tooltipBehavior;
  TooltipBehavior? _tooltipBehavior;
  set tooltipBehavior(TooltipBehavior? value) {
    if (_tooltipBehavior != value) {
      _tooltipBehavior = value;
    }
  }

  TrackballBehavior? get trackballBehavior => _trackballBehavior;
  TrackballBehavior? _trackballBehavior;
  set trackballBehavior(TrackballBehavior? value) {
    if (_trackballBehavior != value) {
      _trackballBehavior = value;
    }
  }

  SfChartThemeData? get chartThemeData => _chartThemeData;
  SfChartThemeData? _chartThemeData;
  set chartThemeData(SfChartThemeData? value) {
    if (_chartThemeData != value) {
      _chartThemeData = value;
    }
  }

  ThemeData? get themeData => _themeData;
  ThemeData? _themeData;
  set themeData(ThemeData? value) {
    if (_themeData != value) {
      _themeData = value;
    }
  }

  // Imagine three series, each with the same data point. Example: [1, 20].
  // First click on the data point, should shown 3rd series tooltip.
  // On the second click on the same data point, check 3rd series tooltip is
  // already in visible or not. If the 3rd series tooltip is visible, keep it
  // displayed and avoid 1st and 2nd series tooltip method calling.
  // And, it specifies for hover, singleTap, doubleTap and longPress methods.
  bool isTooltipActivated = false;

  List<LegendItem>? _buildLegendItems() {
    int index = 0;
    final List<LegendItem> legendItems = <LegendItem>[];
    visitChildren((RenderObject child) {
      final LegendItemProvider provider = child as LegendItemProvider;
      final List<LegendItem>? items = provider.buildLegendItems(index);
      if (items != null) {
        legendItems.addAll(items);
      }
      index++;
    });

    return legendItems;
  }

  @override
  void performUpdate() {
    int index = 0;
    visitChildren((RenderObject child) {
      if (child is ChartSeriesRenderer) {
        child
          ..index = index++
          ..chartThemeData = _chartThemeData
          ..palette = _palette!;
      }
    });

    super.performUpdate();
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    bool isHit = false;
    RenderBox? child = lastChild;
    while (child != null) {
      final StackParentData childParentData =
          child.parentData! as StackParentData;
      final bool isChildHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          return child!.hitTest(result, position: transformed);
        },
      );
      isHit = isHit || isChildHit;
      child = childParentData.previousSibling;
    }

    return isHit;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Rect bounds =
        Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
    if (backgroundColor != null) {
      context.canvas.drawRect(
        bounds,
        Paint()
          ..isAntiAlias = true
          ..color = backgroundColor!,
      );
    }

    if (_borderColor != null &&
        _borderColor != Colors.transparent &&
        _borderWidth > 0) {
      context.canvas.drawRect(
        bounds,
        Paint()
          ..isAntiAlias = true
          ..color = _borderColor!
          ..strokeWidth = _borderWidth
          ..style = PaintingStyle.stroke,
      );
    }
    super.paint(context, offset);
  }
}

class CartesianChartPlotArea extends ChartPlotArea {
  const CartesianChartPlotArea({
    super.key,
    required super.vsync,
    required super.localizations,
    required super.legendKey,
    required this.isTransposed,
    required super.backgroundColor,
    required super.borderColor,
    required super.borderWidth,
    required super.enableAxisAnimation,
    required this.enableSideBySideSeriesPlacement,
    required super.legend,
    required super.onLegendItemRender,
    required super.onLegendTapped,
    required super.onDataLabelRender,
    required super.onMarkerRender,
    required super.onTooltipRender,
    required super.onDataLabelTapped,
    required super.palette,
    required super.selectionMode,
    required super.selectionGesture,
    required super.enableMultiSelection,
    super.tooltipBehavior,
    this.crosshairBehavior,
    this.trackballBehavior,
    this.zoomPanBehavior,
    super.onSelectionChanged,
    required super.chartThemeData,
    required super.themeData,
    required super.children,
  });

  final bool isTransposed;
  final bool enableSideBySideSeriesPlacement;
  final CrosshairBehavior? crosshairBehavior;
  final TrackballBehavior? trackballBehavior;
  final ZoomPanBehavior? zoomPanBehavior;

  @override
  RenderCartesianChartPlotArea createRenderObject(BuildContext context) {
    return RenderCartesianChartPlotArea()
      ..vsync = vsync
      ..legendKey = legendKey
      ..backgroundColor = backgroundColor
      ..borderColor = borderColor
      ..borderWidth = borderWidth
      ..legend = legend
      ..onLegendItemRender = onLegendItemRender
      ..onLegendTapped = onLegendTapped
      ..onDataLabelRender = onDataLabelRender
      ..onDataLabelTapped = onDataLabelTapped
      ..onTooltipRender = onTooltipRender
      ..onMarkerRender = onMarkerRender
      ..palette = palette
      ..selectionMode = selectionMode
      ..selectionGesture = selectionGesture
      ..enableMultiSelection = enableMultiSelection
      ..tooltipBehavior = tooltipBehavior
      ..chartThemeData = chartThemeData
      ..themeData = themeData
      ..isTransposed = isTransposed
      ..enableSideBySideSeriesPlacement = enableSideBySideSeriesPlacement
      ..crosshairBehavior = crosshairBehavior
      ..trackballBehavior = trackballBehavior
      ..zoomPanBehavior = zoomPanBehavior
      ..onSelectionChanged = onSelectionChanged;
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderCartesianChartPlotArea renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..isTransposed = isTransposed
      ..enableSideBySideSeriesPlacement = enableSideBySideSeriesPlacement
      ..crosshairBehavior = crosshairBehavior
      ..trackballBehavior = trackballBehavior
      ..zoomPanBehavior = zoomPanBehavior;
  }
}

class RenderCartesianChartPlotArea extends RenderChartPlotArea {
  late num _primaryAxisAdjacentDataPointsMinDiff;
  RenderCartesianAxes? _cartesianAxes;
  Map<int, List<AxisDependent>>? sbsDetails;
  bool isLegendToggled = false;

  bool get isTransposed => _isTransposed;
  bool _isTransposed = false;
  set isTransposed(bool value) {
    if (_isTransposed != value) {
      _isTransposed = value;
      visitChildren((RenderObject child) {
        if (child is AxisDependent) {
          final AxisDependent axisDependent = child as AxisDependent;
          axisDependent.isTransposed = isTransposed;
        }
      });
      markNeedsLayout();
    }
  }

  bool get enableSideBySideSeriesPlacement => _enableSideBySideSeriesPlacement;
  bool _enableSideBySideSeriesPlacement = true;
  set enableSideBySideSeriesPlacement(bool value) {
    if (_enableSideBySideSeriesPlacement != value) {
      _enableSideBySideSeriesPlacement = value;
      markNeedsUpdate();
    }
  }

  CrosshairBehavior? get crosshairBehavior => _crosshairBehavior;
  CrosshairBehavior? _crosshairBehavior;
  set crosshairBehavior(CrosshairBehavior? value) {
    if (_crosshairBehavior != value) {
      _crosshairBehavior = value;
    }
  }

  ZoomPanBehavior? get zoomPanBehavior => _zoomPanBehavior;
  ZoomPanBehavior? _zoomPanBehavior;
  set zoomPanBehavior(ZoomPanBehavior? value) {
    if (_zoomPanBehavior != value) {
      _zoomPanBehavior = value;
    }
  }

  SelectionBehavior? get selectionBehavior => _selectionBehavior;
  SelectionBehavior? _selectionBehavior;
  set selectionBehavior(SelectionBehavior? value) {
    if (_selectionBehavior != value) {
      _selectionBehavior = value;
    }
  }

  @override
  void remove(RenderBox child) {
    if (child is CartesianSeriesRenderer) {
      if (child.xAxis != null && child.xAxis!.dependents.contains(child)) {
        child.xAxis!.dependents.remove(child);
      }
      if (child.yAxis != null && child.yAxis!.dependents.contains(child)) {
        child.yAxis!.dependents.remove(child);
      }
    }
    super.remove(child);
  }

  void _resetSbsInfo() {
    if (sbsDetails != null) {
      sbsDetails!.clear();
    } else {
      sbsDetails = <int, List<AxisDependent>>{};
    }

    visitChildren((RenderObject child) {
      if (child is ClusterSeriesMixin) {
        final ClusterSeriesMixin cluster = child as ClusterSeriesMixin;
        cluster._clusterIndex = -1;
        if (child is SbsSeriesMixin) {
          child.sbsInfo = DoubleRange.zero();
        }
      }
    });
  }

  void _groupClusterSeries() {
    int index = 0;
    _resetSbsInfo();
    visitChildren((RenderObject child) {
      if (child is! ClusterSeriesMixin) {
        return;
      }

      final AxisDependent? series = child as AxisDependent?;
      if (series == null ||
          series.xAxis == null ||
          !(series as CartesianSeriesRenderer).controller.isVisible) {
        return;
      }

      final Map<String, int> groupingKeys = <String, int>{};
      for (final AxisDependent xDependent in series.xAxis!.dependents) {
        final bool isSeries = xDependent is CartesianSeriesRenderer;
        if ((isSeries && !xDependent.controller.isVisible) ||
            xDependent is ClusterSeriesMixin &&
                (xDependent as ClusterSeriesMixin)._clusterIndex != -1) {
          continue;
        }

        if (xDependent is StackingSeriesMixin) {
          if (xDependent.yAxis == null) {
            continue;
          }

          for (final AxisDependent yDependent in xDependent.yAxis!.dependents) {
            if (yDependent is! CartesianSeriesRenderer ||
                !yDependent.controller.isVisible) {
              continue;
            }
            if (xDependent.xAxis!.dependents.contains(yDependent)) {
              if (yDependent is StackingSeriesMixin) {
                final StackingSeriesMixin stacked =
                    yDependent as StackingSeriesMixin;
                final String groupName = stacked.groupName;
                final int size = sbsDetails!.isNotEmpty &&
                        groupingKeys.isNotEmpty &&
                        groupingKeys.containsKey(groupName)
                    ? sbsDetails![groupingKeys[groupName]]!.length
                    : 0;
                bool isSameType = false;
                StackingSeriesMixin? previous;
                if (size > 0) {
                  previous = sbsDetails![groupingKeys[groupName]]![size - 1]
                      as StackingSeriesMixin?;
                  isSameType = previous != null &&
                      previous.yAxis!.dependents.contains(yDependent) &&
                      previous.runtimeType == yDependent.runtimeType;
                }

                if (groupingKeys.containsKey(groupName) && isSameType) {
                  sbsDetails![groupingKeys[groupName]]!.add(yDependent);
                  if (stacked is ClusterSeriesMixin) {
                    (stacked as ClusterSeriesMixin)._clusterIndex =
                        groupingKeys[groupName]!;
                  }
                } else {
                  groupingKeys.update(
                    groupName,
                    (int value) => index,
                    ifAbsent: () => index,
                  );

                  sbsDetails!.update(
                    index,
                    (List<AxisDependent> values) {
                      values.add(yDependent);
                      return values;
                    },
                    ifAbsent: () {
                      return <AxisDependent>[yDependent];
                    },
                  );

                  series.xAxis!.sbsSeriesCount = index + 1;
                  if (yDependent is ClusterSeriesMixin) {
                    (yDependent as ClusterSeriesMixin)._clusterIndex = index;
                  }
                  index++;
                }
              }
            }
          }
        } else if (xDependent is SbsSeriesMixin) {
          sbsDetails!.update(
            index,
            (List<AxisDependent> values) {
              values.add(xDependent);
              return values;
            },
            ifAbsent: () {
              return <AxisDependent>[xDependent];
            },
          );

          if (xDependent is ClusterSeriesMixin) {
            (xDependent as ClusterSeriesMixin)._clusterIndex = index;
          }
          series.xAxis!.sbsSeriesCount = index + 1;
          index++;
        }
      }

      _computeSbsInfo();
      index = 0;
    });
  }

  double _calculateSbsTotalWidth<T, D>() {
    double totalWidth = 0;
    num minDiff = double.infinity;
    for (final List<AxisDependent> rendererGroup in sbsDetails!.values) {
      double maxWidth = 0;
      for (final AxisDependent renderer in rendererGroup) {
        SbsSeriesMixin<T, D>? sbs;
        if (renderer is SbsSeriesMixin<T, D>) {
          sbs = renderer;
        }

        if (sbs != null) {
          maxWidth = maxWidth > sbs.width ? maxWidth : sbs.width;
          minDiff = min(sbs.primaryAxisAdjacentDataPointsMinDiff, minDiff);
        }
      }

      totalWidth += maxWidth;
    }

    _primaryAxisAdjacentDataPointsMinDiff = minDiff.isInfinite ? 1 : minDiff;
    return totalWidth;
  }

  double _calculateSbsMaxWidth<T, D>(List<AxisDependent> rendererGroup) {
    double maxWidth = 0;
    for (final AxisDependent renderer in rendererGroup) {
      SbsSeriesMixin<T, D>? sbs;
      if (renderer is SbsSeriesMixin<T, D>) {
        sbs = renderer;
      }

      if (sbs != null) {
        maxWidth = maxWidth > sbs.width ? maxWidth : sbs.width;
      }
    }

    return maxWidth;
  }

  void _computeSbsInfo<T, D>() {
    if (sbsDetails != null && sbsDetails!.isNotEmpty) {
      final double totalWidth = _calculateSbsTotalWidth() / sbsDetails!.length;
      double startPosition = 0;
      double end = 0;
      for (final List<AxisDependent> rendererGroup in sbsDetails!.values) {
        final double sbsMaxWidth = _calculateSbsMaxWidth(rendererGroup);
        for (final AxisDependent renderer in rendererGroup) {
          SbsSeriesMixin<T, D>? sbs;
          if (renderer is SbsSeriesMixin<T, D>) {
            sbs = renderer;
          }

          if (sbs == null || !sbs.controller.isVisible) {
            continue;
          }

          final double width = sbs.width;
          if (!enableSideBySideSeriesPlacement) {
            final double range =
                (width * _primaryAxisAdjacentDataPointsMinDiff) / 2;
            sbs.sbsInfo = DoubleRange(-range, range);
            continue;
          }

          if (sbs.xAxis == null) {
            sbs.sbsInfo = DoubleRange(0, 1);
          }

          final int seriesCount =
              sbs.xAxis != null ? sbs.xAxis!.sbsSeriesCount : 0;
          if ((sbs as ClusterSeriesMixin)._clusterIndex == 0) {
            startPosition =
                -_primaryAxisAdjacentDataPointsMinDiff * (totalWidth / 2);
          }

          final double space = (sbsMaxWidth - width) / seriesCount;
          double start = startPosition +
              ((space * _primaryAxisAdjacentDataPointsMinDiff) / 2);

          end = start +
              ((width / seriesCount) * _primaryAxisAdjacentDataPointsMinDiff);
          final double delta = end - start;
          final double spacing = sbs.spacing * delta;

          start += spacing / 2;
          end -= spacing / 2;

          sbs.sbsInfo = DoubleRange(start, end);
          end += spacing / 2;
        }

        startPosition = end;
      }
    }
  }

  @override
  void performUpdate() {
    visitChildren((RenderObject child) {
      if (child is ChartAreaUpdateMixin) {
        child.update();
      }
    });

    visitChildren((RenderObject child) {
      final AxisDependent? axisDependent = child as AxisDependent?;
      if (axisDependent != null) {
        final RenderChartAxis? axis = axisDependent.xAxis;
        if (axis is RenderCategoryAxis && !axis.arrangeByIndex) {
          axis.update();
        }
      }
    });

    _groupClusterSeries();
    _computeSbsInfo();
    int index = -1;
    visitChildren((RenderObject child) {
      if (child is CartesianSeriesRenderer) {
        child
          ..index = index++
          ..chartThemeData = _chartThemeData
          ..paletteColor = _palette![index % _palette!.length]
          ..isTransposed = isTransposed;
      }
    });
    super.performUpdate();
    markNeedsLayout();
  }

  @override
  void performLayout() {
    super.performLayout();
    if (_cartesianAxes != null && parentData != null) {
      _cartesianAxes!.plotAreaBounds =
          (parentData! as BoxParentData).offset & size;
    }

    // Once all cartesian series layouts are completed, use this method to
    // handle the collisions of data labels across multiple series.
    visitChildren((RenderObject child) {
      if (child is CartesianSeriesRenderer &&
          child.controller.isVisible &&
          child.dataLabelSettings.isVisible &&
          child.dataLabelSettings.labelIntersectAction !=
              LabelIntersectAction.none &&
          child.dataLabelContainer != null) {
        child.dataLabelContainer!.handleMultiSeriesDataLabelCollisions();
      }
    });
  }

  bool _hasDataLabel() {
    RenderBox? child = firstChild;
    while (child != null) {
      if (child is CartesianSeriesRenderer) {
        if (child.dataLabelSettings.isVisible) {
          return true;
        }
      }
      child = childAfter(child);
    }
    return false;
  }

  bool _hasTrendline() {
    RenderBox? child = firstChild;
    while (child != null) {
      if (child is CartesianSeriesRenderer) {
        if (child.trendlines != null && child.trendlines!.isNotEmpty) {
          return true;
        }
      }
      child = childAfter(child);
    }
    return false;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    render = SeriesRender.normal;
    super.paint(context, offset);
    if (_hasDataLabel()) {
      render = SeriesRender.dataLabel;
      RenderBox? child = firstChild;
      while (child != null) {
        final StackParentData childParentData =
            child.parentData! as StackParentData;
        context.paintChild(child, childParentData.offset + offset);
        child = childParentData.nextSibling;
      }
    }

    if (_hasTrendline()) {
      render = SeriesRender.trendline;
      RenderBox? child = firstChild;
      while (child != null) {
        final StackParentData childParentData =
            child.parentData! as StackParentData;
        context.paintChild(child, childParentData.offset + offset);
        child = childParentData.nextSibling;
      }
    }
    render = SeriesRender.normal;
  }
}

enum SeriesRender { normal, dataLabel, trendline }

/// Represents the side by side and stacking series i.e. the series which
/// are grouped together.
mixin ClusterSeriesMixin {
  int _clusterIndex = -1;
}

class CartesianAxes extends MultiChildRenderObjectWidget {
  const CartesianAxes({
    super.key,
    required this.vsync,
    required this.enableAxisAnimation,
    required this.isTransposed,
    required this.onAxisLabelTapped,
    required this.onActualRangeChanged,
    required this.indicators,
    required this.chartThemeData,
    super.children,
  });

  final TickerProvider vsync;
  final bool enableAxisAnimation;
  final bool isTransposed;
  final ChartAxisLabelTapCallback? onAxisLabelTapped;
  final ChartActualRangeChangedCallback? onActualRangeChanged;
  final List<TechnicalIndicator> indicators;
  final SfChartThemeData chartThemeData;

  @override
  RenderCartesianAxes createRenderObject(BuildContext context) {
    return RenderCartesianAxes(
      vsync: vsync,
      enableAxisAnimation: enableAxisAnimation,
      isTransposed: isTransposed,
      chartThemeData: chartThemeData,
    )
      ..onAxisLabelTapped = onAxisLabelTapped
      ..indicators = indicators
      ..onActualRangeChanged = onActualRangeChanged;
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderCartesianAxes renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..vsync = vsync
      ..enableAxisAnimation = enableAxisAnimation
      ..isTransposed = isTransposed
      ..onAxisLabelTapped = onAxisLabelTapped
      ..onActualRangeChanged = onActualRangeChanged
      ..indicators = indicators
      ..chartThemeData = chartThemeData;
  }
}

class RenderCartesianAxes extends RenderBox
    with
        ContainerRenderObjectMixin<RenderChartAxis, CartesianAxesParentData>,
        RenderBoxContainerDefaultsMixin<RenderChartAxis,
            CartesianAxesParentData>,
        ChartAreaUpdateMixin {
  RenderCartesianAxes({
    required TickerProvider vsync,
    required bool enableAxisAnimation,
    required bool isTransposed,
    required SfChartThemeData chartThemeData,
  })  : _vsync = vsync,
        _enableAxisAnimation = enableAxisAnimation,
        _isTransposed = isTransposed,
        _chartThemeData = chartThemeData;
  RenderBehaviorArea? behaviorArea;
  BoxConstraints? _plotAreaConstraints;
  Offset plotAreaOffset = Offset.zero;
  Rect plotAreaBounds = Rect.zero;
  bool _isGridLinePaint = false;

  final Map<String?, RenderChartAxis> axes = <String?, RenderChartAxis>{};
  final List<RenderChartAxis> _xAxes = <RenderChartAxis>[];
  final List<RenderChartAxis> _yAxes = <RenderChartAxis>[];

  ChartAxisLabelTapCallback? onAxisLabelTapped;
  ChartActualRangeChangedCallback? onActualRangeChanged;

  bool get enableAxisAnimation => _enableAxisAnimation;
  bool _enableAxisAnimation = false;
  set enableAxisAnimation(bool value) {
    if (_enableAxisAnimation != value) {
      _enableAxisAnimation = value;
    }
  }

  /// The [TickerProvider] for the [AnimationController] that
  /// runs the animation.
  TickerProvider get vsync => _vsync;
  TickerProvider _vsync;
  set vsync(TickerProvider value) {
    if (_vsync != value) {
      _vsync = value;
    }
  }

  bool get isTransposed => _isTransposed;
  bool _isTransposed;
  set isTransposed(bool value) {
    if (_isTransposed != value) {
      _isTransposed = value;
      markNeedsUpdate();
    }
  }

  List<TechnicalIndicator> get indicators => _indicators;
  List<TechnicalIndicator> _indicators = <TechnicalIndicator>[];
  set indicators(List<TechnicalIndicator> value) {
    if (_indicators != value) {
      _indicators = value;
      markNeedsUpdate();
    }
  }

  SfChartThemeData get chartThemeData => _chartThemeData;
  SfChartThemeData _chartThemeData;
  set chartThemeData(SfChartThemeData value) {
    if (_chartThemeData != value) {
      _chartThemeData = value;
      markNeedsUpdate();
    }
  }

  @override
  void remove(RenderChartAxis child) {
    super.remove(child);

    if (_xAxes.contains(child)) {
      _xAxes.remove(child);
    }

    if (_yAxes.contains(child)) {
      _yAxes.remove(child);
    }

    if (axes.containsValue(child)) {
      axes.removeWhere((String? key, RenderChartAxis value) => value == child);
    }
  }

  @override
  void performUpdate() {
    if (firstChild == null) {
      return;
    }

    final CartesianAxesParentData firstChildParentData =
        firstChild!.parentData! as CartesianAxesParentData;
    final String primaryXAxisName = firstChild!.name ?? primaryXAxisDefaultName;
    firstChild!.name = primaryXAxisName;

    assert(firstChildParentData.nextSibling != null);
    final RenderChartAxis primaryYAxis = firstChildParentData.nextSibling!;
    final String primaryYAxisName =
        primaryYAxis.name ?? primaryYAxisDefaultName;
    primaryYAxis.name = primaryYAxisName;

    visitChildren((RenderObject child) {
      if (child is RenderChartAxis) {
        assert(axes[child.name] == null || axes[child.name] == child);
        axes[child.name] = child;
      }
    });

    final RenderCartesianChartArea? chartArea =
        parent as RenderCartesianChartArea?;
    assert(chartArea != null);
    if (chartArea != null) {
      assert(chartArea._plotArea != null);
      if (chartArea._plotArea!.childCount > 0) {
        chartArea._plotArea!.visitChildren((RenderObject child) {
          final AxisDependent? axisDependent = child as AxisDependent?;
          if (axisDependent != null) {
            RenderChartAxis? axis =
                axes[axisDependent.xAxisName ?? primaryXAxisName];
            axisDependent.xAxis = axis;

            axis = axes[axisDependent.yAxisName ?? primaryYAxisName];
            axisDependent.yAxis = axis;
          }
        });
      } else {
        firstChild!.isXAxis = true;
        firstChildParentData.nextSibling!.isXAxis = false;
      }

      if (chartArea._indicatorArea != null) {
        chartArea._indicatorArea!.visitChildren((RenderObject child) {
          if (child is IndicatorRenderer) {
            child.xAxis = axes[child.xAxisName ?? primaryXAxisName];
            child.yAxis = axes[child.yAxisName ?? primaryYAxisName];
          }
        });
      }
    }

    visitChildren((RenderObject child) {
      final RenderChartAxis axis = child as RenderChartAxis;
      axis.isTransposed = isTransposed;
      axis.chartThemeData = chartThemeData;
      if (axis.isXAxis) {
        if (!_xAxes.contains(axis)) {
          _xAxes.add(axis);
        }
        if (_yAxes.contains(axis)) {
          _yAxes.remove(axis);
        }
      } else {
        if (!_yAxes.contains(axis)) {
          _yAxes.add(axis);
        }
        if (_xAxes.contains(axis)) {
          _xAxes.remove(axis);
        }
      }
    });

    visitChildren((RenderObject child) {
      if (child is RenderChartAxis) {
        child.associatedAxis = _associatedAxis(child);
      }
    });

    for (final RenderChartAxis axis in _xAxes) {
      axis.update();
    }

    for (final RenderChartAxis axis in _yAxes) {
      axis.update();
    }
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! CartesianAxesParentData) {
      child.parentData = CartesianAxesParentData();
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    bool isHit = false;
    RenderBox? child = lastChild;
    while (child != null) {
      final CartesianAxesParentData childParentData =
          child.parentData! as CartesianAxesParentData;
      final bool isChildHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          return child!.hitTest(result, position: transformed);
        },
      );
      isHit = isHit || isChildHit;
      child = childParentData.previousSibling;
    }

    return isHit;
  }

  @override
  void performLayout() {
    double topAxesHeight = 0;
    double bottomAxesHeight = 0;
    double horizontalAxesHeight = 0;

    double leftAxesWidth = 0;
    double rightAxesWidth = 0;
    double verticalAxesWidth = 0;

    List<RenderChartAxis> horizontalAxes = _xAxes;
    List<RenderChartAxis> verticalAxes = _yAxes;
    if (isTransposed) {
      horizontalAxes = _yAxes;
      verticalAxes = _xAxes;
    }

    void measureHorizontalAxes(BoxConstraints constraints) {
      topAxesHeight = 0;
      bottomAxesHeight = 0;
      for (final RenderChartAxis axis in horizontalAxes) {
        axis.layout(constraints, parentUsesSize: true);
        if (axis.crossesAt == null || !axis.placeLabelsNearAxisLine) {
          if (axis.opposedPosition) {
            topAxesHeight += axis.size.height;
          } else {
            bottomAxesHeight += axis.size.height;
          }
        }
      }
      horizontalAxesHeight = topAxesHeight + bottomAxesHeight;
    }

    void measureVerticalAxes(BoxConstraints constraints) {
      leftAxesWidth = 0;
      rightAxesWidth = 0;
      for (final RenderChartAxis axis in verticalAxes) {
        axis.layout(constraints, parentUsesSize: true);
        if (axis.crossesAt == null || !axis.placeLabelsNearAxisLine) {
          if (axis.opposedPosition) {
            rightAxesWidth += axis.size.width;
          } else {
            leftAxesWidth += axis.size.width;
          }
        }
      }
      verticalAxesWidth = leftAxesWidth + rightAxesWidth;
    }

    BoxConstraints verticalAxisConstraints = BoxConstraints(
      maxWidth: constraints.maxWidth,
      maxHeight: constraints.maxHeight,
    );
    measureVerticalAxes(verticalAxisConstraints);

    final BoxConstraints horizontalAxisConstraints = BoxConstraints(
      maxWidth: constraints.maxWidth - verticalAxesWidth,
      maxHeight: constraints.maxHeight,
    );
    measureHorizontalAxes(horizontalAxisConstraints);

    if (verticalAxisConstraints.maxHeight > 0 && horizontalAxesHeight == 0) {
      // HACK: If there is no horizontal axes is visible,
      // then set a very small height to relayout the vertical axes
      // to avoid mutated renderbox exception.
      horizontalAxesHeight = 0.00000001;
    }

    verticalAxisConstraints = BoxConstraints(
      maxWidth: constraints.maxWidth,
      maxHeight: constraints.maxHeight - horizontalAxesHeight,
    );
    measureVerticalAxes(verticalAxisConstraints);

    final Rect plotAreaBounds = Rect.fromLTWH(
      leftAxesWidth,
      topAxesHeight,
      horizontalAxisConstraints.maxWidth,
      verticalAxisConstraints.maxHeight,
    );
    plotAreaOffset = plotAreaBounds.topLeft;
    _plotAreaConstraints = BoxConstraints(
      maxWidth: plotAreaBounds.width,
      maxHeight: plotAreaBounds.height,
    );

    _arrangeVerticalAxes(plotAreaBounds, verticalAxes);
    _arrangeHorizontalAxes(plotAreaBounds, horizontalAxes);
    size = constraints.biggest;
    performPostLayout();
  }

  void _arrangeVerticalAxes(
      Rect plotAreaBounds, List<RenderChartAxis> verticalAxes) {
    Offset leftAxisPosition = plotAreaBounds.topLeft;
    Offset rightAxisPosition = plotAreaBounds.topRight;
    for (final RenderChartAxis axis in verticalAxes) {
      final double? crossing = _crossValue(axis);
      final CartesianAxesParentData childParentData =
          axis.parentData! as CartesianAxesParentData;
      if (axis.opposedPosition) {
        axis.invertElementsOrder = false;
        if (crossing != null) {
          if (crossing + axis.size.width > plotAreaBounds.right) {
            axis.invertElementsOrder = true;
            childParentData.offset =
                Offset(crossing - axis.size.width, plotAreaBounds.top);
          } else {
            childParentData.offset = Offset(crossing, plotAreaBounds.top);
          }
        } else {
          childParentData.offset = rightAxisPosition;
          rightAxisPosition = rightAxisPosition.translate(axis.size.width, 0);
        }
      } else {
        axis.invertElementsOrder = true;
        if (crossing != null) {
          final double y = crossing - axis.size.width;
          if (y < plotAreaBounds.left) {
            axis.invertElementsOrder = false;
            childParentData.offset = Offset(crossing, plotAreaBounds.top);
          } else {
            childParentData.offset = Offset(y, plotAreaBounds.top);
          }
        } else {
          childParentData.offset =
              leftAxisPosition.translate(-axis.size.width, 0);
          leftAxisPosition = childParentData.offset;
        }
      }
    }
  }

  void _arrangeHorizontalAxes(
      Rect plotAreaBounds, List<RenderChartAxis> horizontalAxes) {
    Offset topAxisPosition = plotAreaBounds.topLeft;
    Offset bottomAxisPosition = plotAreaBounds.bottomLeft;
    for (final RenderChartAxis axis in horizontalAxes) {
      final double? crossing = _crossValue(axis);
      final CartesianAxesParentData childParentData =
          axis.parentData! as CartesianAxesParentData;
      if (axis.opposedPosition) {
        axis.invertElementsOrder = true;
        if (crossing != null) {
          final double y = crossing - axis.size.height;
          if (y < plotAreaBounds.top) {
            axis.invertElementsOrder = false;
            childParentData.offset = Offset(plotAreaBounds.left, crossing);
          } else {
            childParentData.offset = Offset(plotAreaBounds.left, y);
          }
        } else {
          childParentData.offset =
              topAxisPosition.translate(0, -axis.size.height);
          topAxisPosition = childParentData.offset;
        }
      } else {
        axis.invertElementsOrder = false;
        if (crossing != null) {
          if (crossing + axis.size.height > plotAreaBounds.bottom) {
            axis.invertElementsOrder = true;
            childParentData.offset =
                Offset(plotAreaBounds.left, crossing - axis.size.height);
          } else {
            childParentData.offset = Offset(plotAreaBounds.left, crossing);
          }
        } else {
          childParentData.offset = bottomAxisPosition;
          bottomAxisPosition =
              bottomAxisPosition.translate(0, axis.size.height);
        }
      }
    }
  }

  double? _crossValue(RenderChartAxis axis) {
    if (axis.placeLabelsNearAxisLine &&
        axis.crossesAt != null &&
        axis.associatedAxis != null) {
      return axis.associatedAxis!
          .pointToPixel(axis.associatedAxis!.actualValue(axis.crossesAt));
    }

    return null;
  }

  RenderChartAxis? _associatedAxis(RenderChartAxis axis) {
    if (axis.associatedAxisName != null) {
      final RenderChartAxis? associatedAxis = axes[axis.associatedAxisName];
      if (associatedAxis != null &&
          ((associatedAxis.isVertical && axis.isVertical) ||
              (!associatedAxis.isVertical && !axis.isVertical))) {
        return axis.isXAxis ? _yAxes.first : _xAxes.first;
      } else {
        return associatedAxis;
      }
    }

    return axis.isXAxis ? _yAxes.first : _xAxes.first;
  }

  void _paintUnderSeries(PaintingContext context, Offset offset) {
    RenderChartAxis? child = firstChild;
    while (child != null) {
      child.renderType = AxisRender.gridLines;
      context.paintChild(
          child, (child.parentData! as BoxParentData).offset + offset);
      child = childAfter(child);
    }

    _paintPlotBands(context, offset);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_isGridLinePaint) {
      _paintUnderSeries(context, offset);
    } else {
      defaultPaint(context, offset);
      _paintPlotBands(context, offset, onSeries: true);
    }
    _isGridLinePaint = false;
  }

  void _paintPlotBands(PaintingContext context, Offset offset,
      {bool onSeries = false}) {
    RenderChartAxis? child = firstChild;
    while (child != null) {
      child.renderType =
          onSeries ? AxisRender.overPlotBand : AxisRender.underPlotBand;
      context.paintChild(
          child, (child.parentData! as BoxParentData).offset + offset);
      child = childAfter(child);
    }
  }
}

class CartesianAxesParentData extends ContainerBoxParentData<RenderChartAxis> {}

class CircularChartPlotArea extends ChartPlotArea {
  const CircularChartPlotArea({
    super.key,
    required super.vsync,
    required super.localizations,
    required super.legendKey,
    required super.backgroundColor,
    super.borderColor,
    required super.borderWidth,
    required super.legend,
    required super.onLegendItemRender,
    required super.onLegendTapped,
    required super.onDataLabelRender,
    required super.onTooltipRender,
    required super.onDataLabelTapped,
    required super.palette,
    required super.selectionMode,
    required super.selectionGesture,
    required super.enableMultiSelection,
    required super.tooltipBehavior,
    required super.chartThemeData,
    required super.themeData,
    required this.centerX,
    required this.centerY,
    this.onCreateShader,
    super.onSelectionChanged,
    required super.children,
  });

  final String centerX;
  final String centerY;
  final CircularShaderCallback? onCreateShader;

  @override
  RenderCircularChartPlotArea createRenderObject(BuildContext context) {
    final RenderCircularChartPlotArea plotArea = RenderCircularChartPlotArea();
    plotArea
      ..vsync = vsync
      ..legendKey = legendKey
      ..backgroundColor = backgroundColor
      ..borderColor = borderColor
      ..borderWidth = borderWidth
      ..legend = legend
      ..onLegendItemRender = onLegendItemRender
      ..onLegendTapped = onLegendTapped
      ..onDataLabelRender = onDataLabelRender
      ..onDataLabelTapped = onDataLabelTapped
      ..onTooltipRender = onTooltipRender
      ..palette = palette
      ..selectionMode = selectionMode
      ..selectionGesture = selectionGesture
      ..enableMultiSelection = enableMultiSelection
      ..tooltipBehavior = tooltipBehavior
      ..chartThemeData = chartThemeData
      ..themeData = themeData
      ..centerX = centerX
      ..centerY = centerY
      ..onCreateShader = onCreateShader
      ..onSelectionChanged = onSelectionChanged;
    return plotArea;
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderCircularChartPlotArea renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..centerX = centerX
      ..centerY = centerY
      ..onCreateShader = onCreateShader;
  }
}

class RenderCircularChartPlotArea extends RenderChartPlotArea {
  String get centerX => _centerX;
  String _centerX = '50%';
  set centerX(String value) {
    if (_centerX != value) {
      _centerX = value;
      markNeedsLayout();
    }
  }

  String get centerY => _centerY;
  String _centerY = '50%';
  set centerY(String value) {
    if (_centerY != value) {
      _centerY = value;
      markNeedsLayout();
    }
  }

  CircularShaderCallback? onCreateShader;

  @override
  void performUpdate() {
    int index = 0;
    visitChildren((RenderObject child) {
      if (child is CircularSeriesRenderer) {
        child
          ..index = index++
          ..chartThemeData = _chartThemeData
          ..palette = _palette!
          ..centerX = centerX
          ..centerY = centerY
          ..onCreateShader = onCreateShader;
      }
    });
    super.performUpdate();
  }
}

class IndicatorStack extends StatefulWidget {
  const IndicatorStack({
    super.key,
    required this.vsync,
    required this.indicators,
    required this.isTransposed,
    required this.onLegendTapped,
    required this.onLegendItemRender,
    this.trackballBehavior,
    this.textDirection,
  });

  final TickerProvider vsync;
  final List<TechnicalIndicator> indicators;
  final bool isTransposed;
  final ChartLegendTapCallback? onLegendTapped;
  final ChartLegendRenderCallback? onLegendItemRender;
  final TrackballBehavior? trackballBehavior;
  final TextDirection? textDirection;

  @override
  State<IndicatorStack> createState() => _IndicatorStackState();
}

class _IndicatorStackState extends State<IndicatorStack> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    final int length = widget.indicators.length;
    for (int i = 0; i < length; i++) {
      late Widget current;
      final TechnicalIndicator indicator = widget.indicators[i];
      switch (indicator.toString()) {
        case 'AD':
          current = ADIndicatorWidget(
            vsync: widget.vsync,
            indicator: indicator,
            index: i,
            isTransposed: widget.isTransposed,
            onLegendTapped: widget.onLegendTapped,
            onLegendItemRender: widget.onLegendItemRender,
          );
          break;

        case 'ATR':
          current = AtrIndicatorWidget(
            vsync: widget.vsync,
            indicator: indicator,
            index: i,
            isTransposed: widget.isTransposed,
            onLegendTapped: widget.onLegendTapped,
            onLegendItemRender: widget.onLegendItemRender,
          );
          break;

        case 'Bollinger':
          current = BollingerIndicatorWidget(
            vsync: widget.vsync,
            indicator: indicator,
            index: i,
            isTransposed: widget.isTransposed,
            onLegendTapped: widget.onLegendTapped,
            onLegendItemRender: widget.onLegendItemRender,
          );
          break;

        case 'EMA':
          current = EmaIndicatorWidget(
            vsync: widget.vsync,
            indicator: indicator,
            index: i,
            isTransposed: widget.isTransposed,
            onLegendTapped: widget.onLegendTapped,
            onLegendItemRender: widget.onLegendItemRender,
          );
          break;

        case 'MACD':
          current = MacdIndicatorWidget(
            vsync: widget.vsync,
            indicator: indicator,
            index: i,
            isTransposed: widget.isTransposed,
            onLegendTapped: widget.onLegendTapped,
            onLegendItemRender: widget.onLegendItemRender,
          );
          break;

        case 'Momentum':
          current = MomentumIndicatorWidget(
            vsync: widget.vsync,
            indicator: indicator,
            index: i,
            isTransposed: widget.isTransposed,
            onLegendTapped: widget.onLegendTapped,
            onLegendItemRender: widget.onLegendItemRender,
          );
          break;

        case 'RSI':
          current = RsiIndicatorWidget(
            vsync: widget.vsync,
            indicator: indicator,
            index: i,
            isTransposed: widget.isTransposed,
            onLegendTapped: widget.onLegendTapped,
            onLegendItemRender: widget.onLegendItemRender,
          );
          break;

        case 'SMA':
          current = SmaIndicatorWidget(
            vsync: widget.vsync,
            indicator: indicator,
            index: i,
            isTransposed: widget.isTransposed,
            onLegendTapped: widget.onLegendTapped,
            onLegendItemRender: widget.onLegendItemRender,
          );
          break;

        case 'Stochastic':
          current = StochasticIndicatorWidget(
            vsync: widget.vsync,
            indicator: indicator,
            index: i,
            isTransposed: widget.isTransposed,
            onLegendTapped: widget.onLegendTapped,
            onLegendItemRender: widget.onLegendItemRender,
          );
          break;

        case 'TMA':
          current = TmaIndicatorWidget(
            vsync: widget.vsync,
            indicator: indicator,
            index: i,
            isTransposed: widget.isTransposed,
            onLegendTapped: widget.onLegendTapped,
            onLegendItemRender: widget.onLegendItemRender,
          );
          break;

        case 'ROC':
          current = RocIndicatorWidget(
            vsync: widget.vsync,
            indicator: indicator,
            index: i,
            isTransposed: widget.isTransposed,
            onLegendTapped: widget.onLegendTapped,
            onLegendItemRender: widget.onLegendItemRender,
          );
          break;

        case 'WMA':
          current = WmaIndicatorWidget(
            vsync: widget.vsync,
            indicator: indicator,
            index: i,
            isTransposed: widget.isTransposed,
            onLegendTapped: widget.onLegendTapped,
            onLegendItemRender: widget.onLegendItemRender,
          );
          break;
      }
      children.add(current);
    }

    return IndicatorArea(
      indicators: widget.indicators,
      trackballBehavior: widget.trackballBehavior,
      textDirection: widget.textDirection,
      children: children,
    );
  }
}

class IndicatorArea extends MultiChildRenderObjectWidget {
  const IndicatorArea({
    super.key,
    required this.indicators,
    this.trackballBehavior,
    this.textDirection,
    super.children,
  });

  final List<TechnicalIndicator> indicators;
  final TrackballBehavior? trackballBehavior;
  final TextDirection? textDirection;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderIndicatorArea()
      ..indicators = indicators
      ..trackballBehavior = trackballBehavior
      ..textDirection = textDirection;
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderIndicatorArea renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..indicators = indicators
      ..trackballBehavior = trackballBehavior
      ..textDirection = textDirection;
  }
}

class RenderIndicatorArea extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, ChartAreaParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, ChartAreaParentData>,
        ChartAreaUpdateMixin {
  RenderCartesianChartArea? chartArea;
  TrackballBehavior? trackballBehavior;
  late TextDirection? textDirection;
  late List<TechnicalIndicator> indicators;
  final Map<String?, AxisDependent> series = <String?, AxisDependent>{};

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! ChartAreaParentData) {
      child.parentData = ChartAreaParentData();
    }
  }

  @override
  void performUpdate() {
    if (indicators.isNotEmpty) {
      final RenderCartesianChartArea? chartArea =
          parent as RenderCartesianChartArea?;
      if (chartArea != null) {
        chartArea._plotArea!.visitChildren((RenderObject child) {
          if (child is CartesianSeriesRenderer) {
            series[child.name] = child;
          }
        });
      }
    }
    super.performUpdate();
  }

  List<LegendItem>? _buildLegendItems() {
    int index = 0;
    final List<LegendItem> legendItems = <LegendItem>[];
    visitChildren((RenderObject child) {
      final LegendItemProvider provider = child as LegendItemProvider;
      final List<LegendItem>? items = provider.buildLegendItems(index);
      if (items != null) {
        legendItems.addAll(items);
      }
      index++;
    });

    return legendItems;
  }

  @override
  void performLayout() {
    RenderBox? child = firstChild;
    while (child != null) {
      child.layout(constraints);
      child = childAfter(child);
    }
    size = constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}

class AnnotationParentData extends StackParentData {
  bool isVisible = true;
}

class AnnotationArea extends MultiChildRenderObjectWidget {
  const AnnotationArea({
    super.key,
    this.annotations,
    this.isTransposed = false,
    super.children,
  });

  final List<CartesianChartAnnotation>? annotations;
  final bool isTransposed;

  @override
  RenderAnnotationArea createRenderObject(BuildContext context) {
    return RenderAnnotationArea()
      ..annotations = annotations
      ..isTransposed = isTransposed;
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderAnnotationArea renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..annotations = annotations
      ..isTransposed = isTransposed;
  }
}

class RenderAnnotationArea extends RenderStack with ChartAreaUpdateMixin {
  // Below mentioned things must be considered while rendering the annotations:
  //  - Renders on the position based on coordinate Unit.
  //  - Coordinate unit has logical pixels, points and percentage.
  //  - Can align annotations horizontally and vertically.
  //  - Can render with in the chart area and plot area using annotation region.
  //    => With chart area, need to consider zooming, panning, visible indexes.
  //    => With plot area, annotation must be hidden if it exceeds plot area.
  //  - While hiding the annotation, need to consider the case that annotation
  //    should hide only when it exceeds the plot area fully.
  //  - While hiding the annotation with in plot area, need to check whether the
  //    annotation exceeds the plot area bounds or not.
  //  - Multiple annotations can be given.
  //  - Five types of axis must be considered to access x and y values.
  //  - Need to access axis for transposed case and to transform values.
  //  - Need to layout with chart area constraints and need to position
  //    based on annotation region.
  //  - Both string and numeric values can be given as percentage values.
  //  - Consider visible index while rendering the annotations.

  Offset _plotAreaOffset = Offset.zero;
  Rect _plotAreaBounds = Rect.zero;

  List<CartesianChartAnnotation>? get annotations => _annotations;
  List<CartesianChartAnnotation>? _annotations;
  set annotations(List<CartesianChartAnnotation>? value) {
    if (_annotations != value) {
      _annotations = value;
      markNeedsLayout();
    }
  }

  bool get isTransposed => _isTransposed;
  bool _isTransposed = false;
  set isTransposed(bool value) {
    if (_isTransposed != value) {
      _isTransposed = value;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child is! AnnotationParentData) {
      child.parentData = AnnotationParentData();
    }
  }

  @override
  void update() {
    super.update();
    markNeedsLayout();
  }

  @override
  void performLayout() {
    size = constraints.biggest;

    RenderBox? child = firstChild;
    int index = 0;
    while (child != null) {
      final AnnotationParentData? childParentData =
          child.parentData as AnnotationParentData?;
      final CartesianChartAnnotation annotation = _annotations![index];
      late Offset offset;
      switch (annotation.coordinateUnit) {
        case CoordinateUnit.point:
          offset = _offsetFromRawPoints(annotation);
          break;

        case CoordinateUnit.logicalPixel:
          offset = _offsetFromLogicalPixels(annotation);
          break;

        case CoordinateUnit.percentage:
          offset = _offsetFromPercentage(annotation);
          break;
      }

      child.layout(constraints, parentUsesSize: true);
      final Size childSize = child.size;
      final double x = _horizontalAlignment(
          annotation.horizontalAlignment, offset.dx, childSize);
      final double y = _verticalAlignment(
          annotation.verticalAlignment, offset.dy, childSize);
      if (childParentData != null) {
        childParentData.offset = Offset(x, y);
        childParentData.isVisible = _isVisible(
            annotation, _isBeyondRegion(annotation, x, y, childSize));
        child = childParentData.nextSibling;
      }

      index++;
    }
  }

  Offset _offsetFromRawPoints(CartesianChartAnnotation annotation) {
    final RenderChartAxis? xAxis = _xAxis(annotation);
    final RenderChartAxis? yAxis = _yAxis(annotation);
    if (xAxis != null && yAxis != null) {
      final Offset position = rawValueToPixelPoint(
          annotation.x, annotation.y, xAxis, yAxis, isTransposed);
      return Offset(
          position.dx + _plotAreaOffset.dx, position.dy + _plotAreaOffset.dy);
    }
    return Offset.zero;
  }

  Offset _offsetFromLogicalPixels(CartesianChartAnnotation annotation) {
    final num x = annotation.x;
    final num y = annotation.y;
    return Offset(x.toDouble(), y.toDouble());
  }

  Offset _offsetFromPercentage(CartesianChartAnnotation annotation) {
    assert(annotation.x is String);
    assert(annotation.y is String);
    final double xFactor = factorFromValue(annotation.x);
    final double yFactor = factorFromValue(annotation.y);
    double width = 0.0;
    double height = 0.0;
    if (annotation.region == AnnotationRegion.plotArea) {
      final RenderChartAxis? xAxis = _xAxis(annotation);
      if (xAxis != null) {
        width = _plotAreaBounds.size.width;
      }

      final RenderChartAxis? yAxis = _yAxis(annotation);
      if (yAxis != null) {
        height = _plotAreaBounds.size.height;
      }
    } else {
      width = size.width;
      height = size.height;
    }

    return Offset(width * xFactor, height * yFactor) +
        (annotation.region == AnnotationRegion.plotArea
            ? _plotAreaOffset
            : Offset.zero);
  }

  RenderChartAxis? _xAxis(CartesianChartAnnotation annotation) {
    RenderChartAxis? xAxis;
    final RenderCartesianChartArea? chartArea =
        parent as RenderCartesianChartArea?;
    if (chartArea != null) {
      final Map<String?, RenderChartAxis>? axes =
          chartArea._cartesianAxes?.axes;
      final List<RenderChartAxis>? xAxes = chartArea._cartesianAxes?._xAxes;
      if (axes != null &&
          axes.isNotEmpty &&
          xAxes != null &&
          xAxes.isNotEmpty) {
        if (annotation.xAxisName != null) {
          xAxis = axes[annotation.xAxisName];
        }
        xAxis ??= xAxes.first;
      }
    }

    return xAxis;
  }

  RenderChartAxis? _yAxis(CartesianChartAnnotation annotation) {
    RenderChartAxis? yAxis;
    final RenderCartesianChartArea? chartArea =
        parent as RenderCartesianChartArea?;
    if (chartArea != null) {
      final Map<String?, RenderChartAxis>? axes =
          chartArea._cartesianAxes?.axes;
      final List<RenderChartAxis>? yAxes = chartArea._cartesianAxes?._yAxes;
      if (axes != null &&
          axes.isNotEmpty &&
          yAxes != null &&
          yAxes.isNotEmpty) {
        if (annotation.yAxisName != null) {
          yAxis = axes[annotation.yAxisName];
        }
        yAxis ??= yAxes.first;
      }
    }

    return yAxis;
  }

  double _horizontalAlignment(
      ChartAlignment horizontalAlignment, double xPosition, Size childSize) {
    final double size = childSize.width;
    switch (horizontalAlignment) {
      case ChartAlignment.near:
        return xPosition;
      case ChartAlignment.center:
        return xPosition - size / 2;
      case ChartAlignment.far:
        return xPosition - size;
    }
  }

  double _verticalAlignment(
      ChartAlignment verticalAlignment, double yPosition, Size childSize) {
    final double size = childSize.height;
    switch (verticalAlignment) {
      case ChartAlignment.near:
        return yPosition;
      case ChartAlignment.center:
        return yPosition - size / 2;
      case ChartAlignment.far:
        return yPosition - size;
    }
  }

  bool _isBeyondRegion(
      CartesianChartAnnotation annotation, double x, double y, Size size) {
    final Rect childBounds = Rect.fromLTWH(x, y, size.width, size.height);
    switch (annotation.region) {
      case AnnotationRegion.chart:
        return _isBeyond(childBounds, paintBounds);

      case AnnotationRegion.plotArea:
        return _isBeyond(childBounds, _plotAreaBounds);
    }
  }

  bool _isBeyond(Rect current, Rect source) {
    return current.left < source.left ||
        current.right > source.right ||
        current.top < source.top ||
        current.bottom > source.bottom;
  }

  bool _isVisible(CartesianChartAnnotation annotation, bool isBeyondRegion) {
    if (annotation.clip == ChartClipBehavior.hide) {
      return !isBeyondRegion;
    }
    return true;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    int index = 0;
    while (child != null) {
      context.canvas.save();
      final CartesianChartAnnotation annotation = _annotations![index];
      if (annotation.clip == ChartClipBehavior.clip) {
        context.canvas.clipRect(annotation.region == AnnotationRegion.chart
            ? paintBounds
            : _plotAreaBounds);
      }

      final AnnotationParentData childParentData =
          child.parentData! as AnnotationParentData;
      if (childParentData.isVisible) {
        context.paintChild(child, childParentData.offset + offset);
      }
      child = childParentData.nextSibling;
      context.canvas.restore();

      index++;
    }
  }
}

class CircularAnnotationArea extends MultiChildRenderObjectWidget {
  const CircularAnnotationArea({
    super.key,
    this.annotations,
    super.children,
  });

  final List<CircularChartAnnotation>? annotations;

  @override
  RenderCircularAnnotationArea createRenderObject(BuildContext context) {
    return RenderCircularAnnotationArea()..annotations = annotations;
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderCircularAnnotationArea renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject.annotations = annotations;
  }
}

class RenderCircularAnnotationArea extends RenderStack
    with ChartAreaUpdateMixin {
  List<CircularChartAnnotation>? get annotations => _annotations;
  List<CircularChartAnnotation>? _annotations;
  set annotations(List<CircularChartAnnotation>? value) {
    if (_annotations != value) {
      _annotations = value;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child is! AnnotationParentData) {
      child.parentData = AnnotationParentData();
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;
    final double minSize = (min(size.width, size.height)) / 2;
    RenderBox? child = firstChild;
    int index = 0;
    while (child != null) {
      final AnnotationParentData? childParentData =
          child.parentData as AnnotationParentData?;
      final CircularChartAnnotation annotation = _annotations![index];

      final double radius = percentToValue(annotation.radius, minSize)!;
      final Offset angle = calculateOffset(annotation.angle.toDouble(), radius,
          Offset(size.width / 2, size.height / 2));
      final Offset offset = Offset(angle.dx, angle.dy);
      final double width = percentToValue(annotations![index].width, minSize)!;
      final double height =
          percentToValue(annotations![index].height, minSize)!;

      if (height > 0 && width > 0) {
        final BoxConstraints childConstraints = BoxConstraints(
            minHeight: height,
            minWidth: width,
            maxHeight: height,
            maxWidth: width);
        child.layout(childConstraints, parentUsesSize: true);
      } else {
        child.layout(constraints, parentUsesSize: true);
      }

      final Size childSize = child.size;
      final double x = _horizontalAlignment(
          annotation.horizontalAlignment, offset.dx, childSize);
      final double y = _verticalAlignment(
          annotation.verticalAlignment, offset.dy, childSize);
      if (childParentData != null) {
        childParentData.offset = Offset(x, y);
        child = childParentData.nextSibling;
      }
      index++;
    }
  }

  double _horizontalAlignment(
      ChartAlignment horizontalAlignment, double xPosition, Size childSize) {
    final double size = childSize.width;
    switch (horizontalAlignment) {
      case ChartAlignment.near:
        return xPosition;
      case ChartAlignment.center:
        return xPosition - size / 2;
      case ChartAlignment.far:
        return xPosition - size;
    }
  }

  double _verticalAlignment(
      ChartAlignment verticalAlignment, double yPosition, Size childSize) {
    final double size = childSize.height;
    switch (verticalAlignment) {
      case ChartAlignment.near:
        return yPosition;
      case ChartAlignment.center:
        return yPosition - size / 2;
      case ChartAlignment.far:
        return yPosition - size;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    while (child != null) {
      final AnnotationParentData childParentData =
          child.parentData! as AnnotationParentData;
      context.paintChild(child, childParentData.offset + offset);
      child = childParentData.nextSibling;
    }
  }
}

class LoadingIndicator extends ConstrainedLayoutBuilder<BoxConstraints> {
  const LoadingIndicator({
    super.key,
    required this.isTransposed,
    required this.isInversed,
    required this.onSwipe,
    required super.builder,
  });

  final bool isTransposed;
  final bool isInversed;
  final ChartPlotAreaSwipeCallback onSwipe;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderLoadingIndicator()
      ..isTransposed = isTransposed
      ..isInversed = isInversed
      ..onSwipe = onSwipe;
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderLoadingIndicator renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..isTransposed = isTransposed
      ..isInversed = isInversed
      ..onSwipe = onSwipe;
  }
}

class RenderLoadingIndicator extends RenderProxyBox
    with RenderConstrainedLayoutBuilder<BoxConstraints, RenderBox> {
  bool _isDesktop = false;
  Offset _startPosition = Offset.zero;
  Offset _endPosition = Offset.zero;

  late ChartPlotAreaSwipeCallback onSwipe;

  bool get isTransposed => _isTransposed;
  bool _isTransposed = false;
  set isTransposed(bool value) {
    if (_isTransposed != value) {
      _isTransposed = value;
      markNeedsLayout();
    }
  }

  bool get isInversed => _isInversed;
  bool _isInversed = false;
  set isInversed(bool value) {
    if (_isInversed != value) {
      _isInversed = value;
      markNeedsLayout();
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return true;
  }

  void handlePointerDown(PointerDownEvent details) {
    _isDesktop = details.kind == PointerDeviceKind.mouse;
  }

  void handleScaleStart(ScaleStartDetails details) {
    _startPosition = globalToLocal(details.focalPoint);
  }

  void handleScaleUpdate(ScaleUpdateDetails details) {
    _endPosition = globalToLocal(details.focalPoint);
  }

  void handleScaleEnd(ScaleEndDetails details) {
    _handlePlotAreaSwipe(details.velocity);
  }

  void handleDragStart(DragStartDetails details) {
    _startPosition = globalToLocal(details.globalPosition);
  }

  void handleDragUpdate(DragUpdateDetails details) {
    _endPosition = globalToLocal(details.globalPosition);
  }

  void handleDragEnd(DragEndDetails details) {
    _handlePlotAreaSwipe(details.velocity);
  }

  void _handlePlotAreaSwipe(Velocity swipeVelocity) {
    final double minsSwipeVelocity = _isDesktop ? 0.0 : 240.0;
    final double velocity = isTransposed
        ? swipeVelocity.pixelsPerSecond.dy
        : swipeVelocity.pixelsPerSecond.dx;
    if (velocity.abs() < minsSwipeVelocity) {
      _startPosition = Offset.zero;
      _endPosition = Offset.zero;
      return;
    }

    ChartSwipeDirection direction;
    if (isTransposed) {
      direction = _isDesktop
          ? _endPosition.dy > _startPosition.dy
              ? ChartSwipeDirection.end
              : ChartSwipeDirection.start
          : velocity > 0
              ? ChartSwipeDirection.start
              : ChartSwipeDirection.end;
    } else {
      direction = _isDesktop
          ? _endPosition.dx > _startPosition.dx
              ? ChartSwipeDirection.start
              : ChartSwipeDirection.end
          : velocity > 0
              ? ChartSwipeDirection.start
              : ChartSwipeDirection.end;
    }

    if (isInversed) {
      direction = direction == ChartSwipeDirection.start
          ? ChartSwipeDirection.end
          : ChartSwipeDirection.start;
    }

    final bool verticallyDragging =
        (_endPosition.dy - _startPosition.dy).abs() >
            (_endPosition.dx - _startPosition.dx).abs();

    if ((verticallyDragging && !isTransposed) ||
        (!verticallyDragging && isTransposed)) {
      return;
    }

    onSwipe(direction);

    _startPosition = Offset.zero;
    _endPosition = Offset.zero;

    bool buildLoadMoreIndicator = false;
    final List<RenderChartAxis> axes =
        (parent! as RenderBehaviorArea).cartesianAxes!.axes.values.toList();

    for (int axisIndex = 0; axisIndex < axes.length; axisIndex++) {
      final RenderChartAxis axis = axes[axisIndex];
      final DoubleRange visibleRange = axis.visibleRange!;
      final DoubleRange actualRange = axis.actualRange!;

      if (((!verticallyDragging && axis.isXAxis) ||
              (verticallyDragging && !axis.isXAxis)) &&
          ((actualRange.minimum.round() == visibleRange.minimum.round() &&
                  direction == ChartSwipeDirection.start) ||
              (actualRange.maximum.round() == visibleRange.maximum.round() &&
                  direction == ChartSwipeDirection.end))) {
        buildLoadMoreIndicator = true;
        break;
      }
    }
    if (buildLoadMoreIndicator) {
      markNeedsBuild();
    }
  }

  @override
  void performLayout() {
    rebuildIfNecessary();
    child?.layout(constraints);
    size = constraints.biggest;
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
}

class ChartBehavior {
  RenderBox? get parentBox => _parentBox;
  RenderBox? _parentBox;
  set parentBox(RenderBox? value) {
    if (_parentBox != value) {
      _parentBox = value;
    }
  }

  /// To customize the necessary pointer events in behaviors.
  /// (e.g., CrosshairBehavior, TrackballBehavior, ZoomingBehavior).
  @protected
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {}

  /// Called when a long press gesture by a primary button has been
  /// recognized in behavior.
  @protected
  void handleLongPressStart(LongPressStartDetails details) {}

  /// Called when moving after the long press gesture by a primary button
  /// is recognized in behavior.
  @protected
  void handleLongPressMoveUpdate(LongPressMoveUpdateDetails details) {}

  /// Called when the pointer stops contacting the screen after a long-press by
  /// a primary button in behavior.
  @protected
  void handleLongPressEnd(LongPressEndDetails details) {}

  /// Called when the pointer tap has contacted the screen in behavior.
  @protected
  void handleTapDown(TapDownDetails details) {}

  /// Called when pointer has stopped contacting screen in behavior.
  @protected
  void handleTapUp(TapUpDetails details) {}

  /// Called when pointer tap has contacted the screen double time.
  @protected
  void handleDoubleTap(Offset position) {}

  /// Called when the pointers in contact with the screen
  /// and initial scale of 1.0.
  @protected
  void handleScaleStart(ScaleStartDetails details) {}

  /// Called when the pointers in contact with the screen have indicated
  /// a new scale.
  @protected
  void handleScaleUpdate(ScaleUpdateDetails details) {}

  /// Called when the pointers are no longer in contact with the screen.
  @protected
  void handleScaleEnd(ScaleEndDetails details) {}

  /// Called when a pointer or mouse enter on the screen.
  @protected
  void handlePointerEnter(PointerEnterEvent details) {}

  /// Called when a pointer or mouse exit on the screen.
  @protected
  void handlePointerExit(PointerExitEvent details) {}

  /// Called to customize each behaviors with given context at the given offset.
  @protected
  void onPaint(PaintingContext context, Offset offset,
      SfChartThemeData chartThemeData, ThemeData themeData) {}
}

typedef SelectionCallback = void Function(int seriesIndex, int pointIndex);

class SelectionController {
  SelectionController(this.parentBox);

  final RenderChartPlotArea parentBox;
  final List<SelectionCallback> _selectionListeners = <SelectionCallback>[];
  final List<SelectionCallback> _deselectionListeners = <SelectionCallback>[];

  final Map<int, List<int>> selectedDataPoints = <int, List<int>>{};

  bool get hasSelection => _hasSelectedIndexes;
  bool _hasSelectedIndexes = false;

  bool get enableMultiSelection => _enableMultipleSelection;
  bool _enableMultipleSelection = false;
  set enableMultiSelection(bool value) {
    if (_enableMultipleSelection != value) {
      _enableMultipleSelection = value;
      resetSelection();
    }
  }

  void updateSelectionParent(SelectionBehavior selectionBehavior) {
    selectionBehavior._parentBox = parentBox;
  }

  void resetSelection() {
    _hasSelectedIndexes = false;
    selectedDataPoints
        .forEach((int previousSelectedSeriesIndex, List<int> values) {
      final int length = values.length;
      for (int i = 0; i < length; i++) {
        _notifyDeselectionListeners(previousSelectedSeriesIndex, values[i]);
      }
      values.clear();
    });
    selectedDataPoints.clear();
  }

  void updateSelection<T, D>(
    ChartSeriesRenderer<T, D> series,
    int seriesIndex,
    int segmentPointIndex,
    bool togglingEnabled, {
    SelectionType? selectionType,
    bool forceSelection = false,
    bool forceDeselection = false,
  }) {
    if (series is ContinuousSeriesMixin &&
        selectionType == SelectionType.point) {
      return;
    }

    int deselectedSeriesIndex = -1;
    int deselectedPointIndex = -1;
    int selectedSeriesIndex = -1;
    int selectedPointIndex = -1;

    if (selectionType == SelectionType.cluster) {
      seriesIndex = 0;
    }
    if (selectionType == SelectionType.series) {
      segmentPointIndex = 0;
    }

    if (enableMultiSelection) {
      if (forceSelection) {
        final bool existingSelected =
            selectedDataPoints[seriesIndex]?.contains(segmentPointIndex) ??
                false;
        if (existingSelected) {
          return;
        }
      }
      if (forceDeselection) {
        _notifyDeselectionListeners(seriesIndex, segmentPointIndex);
      }

      if (selectedDataPoints.containsKey(seriesIndex)) {
        final List<int> points = selectedDataPoints[seriesIndex]!;
        if (points.contains(segmentPointIndex)) {
          if (togglingEnabled) {
            points.remove(segmentPointIndex);
            deselectedSeriesIndex = seriesIndex;
            deselectedPointIndex = segmentPointIndex;
          }
        } else {
          points.add(segmentPointIndex);
          selectedSeriesIndex = seriesIndex;
          selectedPointIndex = segmentPointIndex;
        }
      } else {
        selectedDataPoints[seriesIndex] = <int>[segmentPointIndex];
        selectedSeriesIndex = seriesIndex;
        selectedPointIndex = segmentPointIndex;
      }
    } else {
      if (selectedDataPoints.containsKey(seriesIndex)) {
        final List<int> points = selectedDataPoints[seriesIndex]!;
        if (points.contains(segmentPointIndex)) {
          if (togglingEnabled) {
            points.remove(segmentPointIndex);
            deselectedSeriesIndex = seriesIndex;
            deselectedPointIndex = segmentPointIndex;
          }
        } else {
          deselectedSeriesIndex = seriesIndex;
          deselectedPointIndex = points[0];
          points.clear();
          points.add(segmentPointIndex);
          selectedSeriesIndex = seriesIndex;
          selectedPointIndex = segmentPointIndex;
        }
      } else {
        selectedDataPoints
            .forEach((int previousSelectedSeriesIndex, List<int> values) {
          if (values.isNotEmpty) {
            deselectedSeriesIndex = previousSelectedSeriesIndex;
            deselectedPointIndex = values[0];
            values.clear();
          }
        });
        selectedDataPoints.clear();

        selectedDataPoints[seriesIndex] = <int>[segmentPointIndex];
        selectedSeriesIndex = seriesIndex;
        selectedPointIndex = segmentPointIndex;
      }
    }

    _removeEmptyKeys();
    _hasSelectedIndexes = selectedDataPoints.isNotEmpty;
    if (deselectedSeriesIndex != -1 && deselectedPointIndex != -1) {
      _notifyDeselectionListeners(deselectedSeriesIndex, deselectedPointIndex);
    }

    if (selectedSeriesIndex != -1 && selectedPointIndex != -1) {
      _notifySelectionListeners(selectionType);
    }
  }

  void _removeEmptyKeys() {
    final List<int> keysToRemove = <int>[];
    selectedDataPoints.forEach((int key, List<int> values) {
      if (values.isEmpty) {
        keysToRemove.add(key);
      }
    });

    for (int i = 0; i < keysToRemove.length; i++) {
      final int key = keysToRemove[i];
      selectedDataPoints.remove(key);
    }
  }

  void addSelectionListener(SelectionCallback listener) {
    _selectionListeners.add(listener);
  }

  void removeSelectionListener(SelectionCallback listener) {
    _selectionListeners.remove(listener);
  }

  void addDeselectionListener(SelectionCallback listener) {
    _deselectionListeners.add(listener);
  }

  void removeDeselectionListener(SelectionCallback listener) {
    _deselectionListeners.remove(listener);
  }

  void _notifySelectionListeners([SelectionType? selectionType]) {
    if (selectionType == SelectionType.cluster) {
      if (selectedDataPoints.isNotEmpty) {
        selectedDataPoints.forEach((int seriesIndex, List<int> pointIndexes) {
          for (final int pointIndex in pointIndexes) {
            for (final SelectionCallback listener in _selectionListeners) {
              listener(seriesIndex, pointIndex);
            }
          }
        });
      }
    } else {
      selectedDataPoints.forEach((int seriesIndex, List<int> pointIndexes) {
        if (pointIndexes.isNotEmpty) {
          for (final int pointIndex in pointIndexes) {
            for (final SelectionCallback listener in _selectionListeners) {
              listener(seriesIndex, pointIndex);
            }
          }
        }
      });
    }
  }

  void _notifyDeselectionListeners(int seriesIndex, int segmentPointIndex) {
    for (final SelectionCallback listener in _deselectionListeners) {
      listener(seriesIndex, segmentPointIndex);
    }
  }

  void dispose() {
    _selectionListeners.clear();
  }

  void reset() {
    selectedDataPoints.clear();
    _notifySelectionListeners();
  }
}
