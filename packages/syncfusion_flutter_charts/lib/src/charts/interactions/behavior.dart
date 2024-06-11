import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../axis/axis.dart';
import '../base.dart';
import '../behaviors/crosshair.dart';
import '../behaviors/trackball.dart';
import '../behaviors/zooming.dart';
import '../common/callbacks.dart';
import '../common/core_tooltip.dart';
import '../series/chart_series.dart';
import '../utils/constants.dart';
import '../utils/enum.dart';
import '../utils/typedef.dart';
import 'tooltip.dart';

class BehaviorArea extends MultiChildRenderObjectWidget {
  const BehaviorArea({
    super.key,
    required this.tooltipKey,
    this.primaryXAxisName = primaryXAxisDefaultName,
    this.primaryYAxisName = primaryYAxisDefaultName,
    this.isTransposed = false,
    this.tooltipBehavior,
    this.crosshairBehavior,
    this.zoomPanBehavior,
    this.trackballBehavior,
    this.onZooming,
    this.onZoomStart,
    this.onZoomEnd,
    this.onZoomReset,
    this.onTrackballPositionChanging,
    this.onCrosshairPositionChanging,
    this.onTooltipRender,
    required this.chartThemeData,
    required this.themeData,
    super.children,
    this.trackballBuilder,
    this.textDirection,
  });

  final GlobalKey? tooltipKey;
  final String primaryXAxisName;
  final String primaryYAxisName;
  final bool isTransposed;
  final TooltipBehavior? tooltipBehavior;
  final CrosshairBehavior? crosshairBehavior;
  final ZoomPanBehavior? zoomPanBehavior;
  final TrackballBehavior? trackballBehavior;
  final SfChartThemeData chartThemeData;
  final ThemeData? themeData;
  final ChartZoomingCallback? onZooming;
  final ChartZoomingCallback? onZoomStart;
  final ChartZoomingCallback? onZoomEnd;
  final ChartZoomingCallback? onZoomReset;
  final ChartTrackballCallback? onTrackballPositionChanging;
  final ChartCrosshairCallback? onCrosshairPositionChanging;
  final ChartTooltipCallback? onTooltipRender;
  final Function(List<TrackballDetails> details)? trackballBuilder;
  final TextDirection? textDirection;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderBehaviorArea()
      .._tooltipKey = tooltipKey
      ..primaryXAxisName = primaryXAxisName
      ..primaryYAxisName = primaryYAxisName
      ..isTransposed = isTransposed
      ..tooltipBehavior = tooltipBehavior
      ..crosshairBehavior = crosshairBehavior
      ..zoomPanBehavior = zoomPanBehavior
      ..trackballBehavior = trackballBehavior
      ..onZooming = onZooming
      ..onZoomStart = onZoomStart
      ..onZoomEnd = onZoomEnd
      ..onZoomReset = onZoomReset
      ..onTrackballPositionChanging = onTrackballPositionChanging
      ..onCrosshairPositionChanging = onCrosshairPositionChanging
      ..trackballBuilder = trackballBuilder
      ..onTooltipRender = onTooltipRender
      ..chartThemeData = chartThemeData
      ..themeData = themeData
      ..textDirection = textDirection;
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderBehaviorArea renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      .._tooltipKey = tooltipKey
      ..primaryXAxisName = primaryXAxisName
      ..primaryYAxisName = primaryYAxisName
      ..isTransposed = isTransposed
      ..tooltipBehavior = tooltipBehavior
      ..crosshairBehavior = crosshairBehavior
      ..zoomPanBehavior = zoomPanBehavior
      ..trackballBehavior = trackballBehavior
      ..onZooming = onZooming
      ..onZoomStart = onZoomStart
      ..onZoomEnd = onZoomEnd
      ..onZoomReset = onZoomReset
      ..onTrackballPositionChanging = onTrackballPositionChanging
      ..onCrosshairPositionChanging = onCrosshairPositionChanging
      ..trackballBuilder = trackballBuilder
      ..onTooltipRender = onTooltipRender
      ..chartThemeData = chartThemeData
      ..themeData = themeData
      ..textDirection = textDirection;
  }
}

class RenderBehaviorArea extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, StackParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, StackParentData>,
        ChartAreaUpdateMixin {
  GlobalKey? _tooltipKey;

  Timer? _crosshairHideTimer;
  Timer? _trackballHideTimer;

  bool _crosshairEnabled = false;
  bool _trackballEnabled = false;
  bool _zoomingEnabled = false;
  bool performZoomThroughTouch = false;
  TooltipInfo? _previousTooltipInfo;

  RenderCartesianAxes? cartesianAxes;
  RenderIndicatorArea? indicatorArea;
  RenderChartPlotArea? plotArea;
  RenderLoadingIndicator? _loadingIndicator;
  TooltipOpacityRenderBox? _tooltip;
  TrackballOpacityRenderBox? _trackball;

  ChartZoomingCallback? onZooming;
  ChartZoomingCallback? onZoomStart;
  ChartZoomingCallback? onZoomEnd;
  ChartZoomingCallback? onZoomReset;
  TextDirection? textDirection;

  Function(List<TrackballDetails>)? trackballBuilder;
  ChartTrackballCallback? onTrackballPositionChanging;
  ChartCrosshairCallback? onCrosshairPositionChanging;
  ChartTooltipCallback? onTooltipRender;

  String get primaryXAxisName => _primaryXAxisName;
  String _primaryXAxisName = primaryXAxisDefaultName;
  set primaryXAxisName(String value) {
    if (_primaryXAxisName != value) {
      _primaryXAxisName = value;
      markNeedsPaint();
    }
  }

  String get primaryYAxisName => _primaryYAxisName;
  String _primaryYAxisName = primaryYAxisDefaultName;
  set primaryYAxisName(String value) {
    if (_primaryYAxisName != value) {
      _primaryYAxisName = value;
      markNeedsPaint();
    }
  }

  bool get isTransposed => _isTransposed;
  bool _isTransposed = false;
  set isTransposed(bool value) {
    if (_isTransposed != value) {
      _isTransposed = value;
      markNeedsPaint();
    }
  }

  TooltipBehavior? get tooltipBehavior => _tooltipBehavior;
  TooltipBehavior? _tooltipBehavior;
  set tooltipBehavior(TooltipBehavior? value) {
    if (_tooltipBehavior != value) {
      if (value != null) {
        value.parentBox = this;
      }
      _tooltipBehavior = value;
    }
  }

  CrosshairBehavior? get crosshairBehavior => _crosshairBehavior;
  CrosshairBehavior? _crosshairBehavior;
  set crosshairBehavior(CrosshairBehavior? value) {
    if (_crosshairBehavior != value) {
      if (value != null) {
        value.parentBox = this;
      }
      _crosshairBehavior = value;
      _crosshairEnabled = value != null && value.enable;
    }
  }

  ZoomPanBehavior? get zoomPanBehavior => _zoomPanBehavior;
  ZoomPanBehavior? _zoomPanBehavior;
  set zoomPanBehavior(ZoomPanBehavior? value) {
    if (_zoomPanBehavior != value) {
      if (value != null) {
        value.parentBox = this;
      }
      _zoomPanBehavior = value;
      _zoomingEnabled = value != null &&
          (value.enablePinching ||
              value.enablePanning ||
              value.enableMouseWheelZooming ||
              value.enableDoubleTapZooming ||
              value.enableSelectionZooming);
      performZoomThroughTouch = value != null &&
          (value.enablePinching || value.enableSelectionZooming);
    }
  }

  TrackballBehavior? get trackballBehavior => _trackballBehavior;
  TrackballBehavior? _trackballBehavior;
  set trackballBehavior(TrackballBehavior? value) {
    if (_trackballBehavior != value) {
      if (value != null) {
        value.parentBox = this;
      }
      _trackballBehavior = value;
      _trackballEnabled = value != null && value.enable;
    }
  }

  SfChartThemeData? get chartThemeData => _chartThemeData;
  SfChartThemeData? _chartThemeData;
  set chartThemeData(SfChartThemeData? value) {
    _chartThemeData = value;
    markNeedsPaint();
  }

  ThemeData? get themeData => _themeData;
  ThemeData? _themeData;
  set themeData(ThemeData? value) {
    _themeData = value;
    markNeedsPaint();
  }

  RenderChartAxis? get xAxis => cartesianAxes?.axes[primaryXAxisName];

  RenderChartAxis? get yAxis => cartesianAxes?.axes[primaryYAxisName];

  @override
  bool get isRepaintBoundary => true;

  @override
  void attach(PipelineOwner owner) {
    crosshairBehavior?.parentBox = this;
    trackballBehavior?.parentBox = this;
    zoomPanBehavior?.parentBox = this;
    tooltipBehavior?.parentBox = this;

    plotArea?.visitChildren((RenderObject child) {
      if (child is ChartSeriesRenderer) {
        child.selectionBehavior?.parentBox = this;
      }
    });
    super.attach(owner);
  }

  @override
  void detach() {
    crosshairBehavior?.parentBox = null;
    trackballBehavior?.parentBox = null;
    zoomPanBehavior?.parentBox = null;
    tooltipBehavior?.parentBox = null;

    plotArea?.visitChildren((RenderObject child) {
      if (child is ChartSeriesRenderer) {
        child.selectionBehavior?.parentBox = null;
      }
    });
    super.detach();
  }

  @override
  void insert(RenderBox child, {RenderBox? after}) {
    super.insert(child, after: after);
    if (child is RenderLoadingIndicator) {
      _loadingIndicator = child;
    }
    if (child is TooltipOpacityRenderBox) {
      _tooltip = child;
    }
    if (child is TrackballOpacityRenderBox) {
      _trackball = child;
    }
  }

  @override
  void remove(RenderBox child) {
    super.remove(child);
    if (child is RenderLoadingIndicator) {
      _loadingIndicator = null;
    }
    if (child is TooltipOpacityRenderBox) {
      _tooltip = null;
    }
    if (child is TrackballOpacityRenderBox) {
      _trackball = null;
    }
  }

  @override
  void setupParentData(RenderObject child) {
    if (child is! StackParentData) {
      child.parentData = StackParentData();
    }
  }

  RenderChartAxis? axisFromName(String? name) {
    return cartesianAxes?.axes[name];
  }

  RenderChartAxis? axisFromObject(ChartAxis axis) {
    RenderChartAxis? renderChartAxis;
    cartesianAxes?.axes.forEach((String? key, RenderChartAxis value) {
      if (value.widget == axis) {
        renderChartAxis = value;
      }
    });

    return renderChartAxis;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    bool isLoadingIndicatorHit = false;
    bool isTooltipHit = false;
    bool isTrackballHit = false;
    if (size.contains(position)) {
      if (_loadingIndicator != null) {
        final StackParentData childParentData =
            _loadingIndicator!.parentData! as StackParentData;
        isLoadingIndicatorHit = result.addWithPaintOffset(
          offset: childParentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            return _loadingIndicator!.hitTest(result, position: transformed);
          },
        );
      }

      if (_tooltip != null) {
        final StackParentData childParentData =
            _tooltip!.parentData! as StackParentData;
        isTooltipHit = result.addWithPaintOffset(
          offset: childParentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            return _tooltip!.hitTest(result, position: transformed);
          },
        );
      }

      if (_trackball != null) {
        final StackParentData childParentData =
            _trackball!.parentData! as StackParentData;
        isTrackballHit = result.addWithPaintOffset(
          offset: childParentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            return _trackball!.hitTest(result, position: transformed);
          },
        );
      }

      return isLoadingIndicatorHit ||
          isTooltipHit ||
          isTrackballHit ||
          _crosshairEnabled ||
          _trackballEnabled ||
          _zoomingEnabled;
    }
    return false;
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    crosshairBehavior?.handleEvent(event, entry);
    trackballBehavior?.handleEvent(event, entry);
    zoomPanBehavior?.handleEvent(event, entry);

    if (event is PointerDownEvent) {
      _loadingIndicator?.handlePointerDown(event);
    }
  }

  void handlePointerEnter(PointerEnterEvent details) {
    crosshairBehavior?.handlePointerEnter(details);
    trackballBehavior?.handlePointerEnter(details);
  }

  void handlePointerExit(PointerExitEvent details) {
    crosshairBehavior?.handlePointerExit(details);
    trackballBehavior?.handlePointerExit(details);
  }

  void handleLongPressStart(LongPressStartDetails details) {
    crosshairBehavior?.handleLongPressStart(details);
    trackballBehavior?.handleLongPressStart(details);
    zoomPanBehavior?.handleLongPressStart(details);
  }

  void handleLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    crosshairBehavior?.handleLongPressMoveUpdate(details);
    trackballBehavior?.handleLongPressMoveUpdate(details);
    zoomPanBehavior?.handleLongPressMoveUpdate(details);
  }

  void handleLongPressEnd(LongPressEndDetails details) {
    crosshairBehavior?.handleLongPressEnd(details);
    trackballBehavior?.handleLongPressEnd(details);
    zoomPanBehavior?.handleLongPressEnd(details);
  }

  void handleTapDown(TapDownDetails details) {
    crosshairBehavior?.handleTapDown(details);
    trackballBehavior?.handleTapDown(details);
  }

  void handleTapUp(TapUpDetails details) {
    crosshairBehavior?.handleTapUp(details);
    trackballBehavior?.handleTapUp(details);
  }

  void handleDoubleTap(Offset position) {
    crosshairBehavior?.handleDoubleTap(position);
    trackballBehavior?.handleDoubleTap(position);
    zoomPanBehavior?.handleDoubleTap(position);
  }

  void handleScaleStart(ScaleStartDetails details) {
    zoomPanBehavior?.handleScaleStart(details);
    _loadingIndicator?.handleScaleStart(details);
  }

  void handleScaleUpdate(ScaleUpdateDetails details) {
    zoomPanBehavior?.handleScaleUpdate(details);
    _loadingIndicator?.handleScaleUpdate(details);
  }

  void handleScaleEnd(ScaleEndDetails details) {
    zoomPanBehavior?.handleScaleEnd(details);
    _loadingIndicator?.handleScaleEnd(details);
  }

  void handleHorizontalDragStart(DragStartDetails details) {
    zoomPanBehavior?.handleHorizontalDragStart(details);
    _loadingIndicator?.handleDragStart(details);
  }

  void handleHorizontalDragUpdate(DragUpdateDetails details) {
    zoomPanBehavior?.handleHorizontalDragUpdate(details);
    _loadingIndicator?.handleDragUpdate(details);
  }

  void handleHorizontalDragEnd(DragEndDetails details) {
    zoomPanBehavior?.handleHorizontalDragEnd(details);
    _loadingIndicator?.handleDragEnd(details);
  }

  void handleVerticalDragStart(DragStartDetails details) {
    zoomPanBehavior?.handleVerticalDragStart(details);
    _loadingIndicator?.handleDragStart(details);
  }

  void handleVerticalDragUpdate(DragUpdateDetails details) {
    zoomPanBehavior?.handleVerticalDragUpdate(details);
    _loadingIndicator?.handleDragUpdate(details);
  }

  void handleVerticalDragEnd(DragEndDetails details) {
    zoomPanBehavior?.handleVerticalDragEnd(details);
    _loadingIndicator?.handleDragEnd(details);
  }

  void raiseTooltip(TooltipInfo info,
      [PointerDeviceKind kind = PointerDeviceKind.touch]) {
    if (tooltipBehavior != null &&
        tooltipBehavior!.shared &&
        info is! TrendlineTooltipInfo) {
      final ChartTooltipInfo chartTooltipInfo = info as ChartTooltipInfo;
      tooltipBehavior!.showByIndex(
          chartTooltipInfo.seriesIndex, chartTooltipInfo.pointIndex);
    } else {
      showTooltip(info, kind);
    }
  }

  void showTooltip(TooltipInfo info,
      [PointerDeviceKind kind = PointerDeviceKind.touch]) {
    if (tooltipBehavior == null || !tooltipBehavior!.enable) {
      return;
    }

    final CoreTooltipState? state =
        _tooltipKey?.currentState as CoreTooltipState?;
    if (state == null) {
      return;
    }

    if (info is ChartTooltipInfo &&
        onTooltipRender != null &&
        _previousTooltipInfo != info) {
      final TooltipArgs tooltipRenderArgs = TooltipArgs(
          info.seriesIndex,
          info.renderer.chartPoints,
          info.renderer.viewportIndex(info.pointIndex),
          info.pointIndex)
        ..text = info.text
        ..header = tooltipBehavior!.header ?? info.header
        ..locationX = info.primaryPosition.dx
        ..locationY = info.primaryPosition.dy;
      onTooltipRender!(tooltipRenderArgs);
      assert(tooltipRenderArgs.locationX != null &&
          tooltipRenderArgs.locationY != null);
      info = info.copyWith(
        primaryPosition:
            Offset(tooltipRenderArgs.locationX!, tooltipRenderArgs.locationY!),
        text: tooltipRenderArgs.text,
        name: tooltipRenderArgs.header,
      );
      _previousTooltipInfo = info;
    }
    state.show(info, kind,
        immediately:
            tooltipBehavior!.tooltipPosition == TooltipPosition.pointer);
  }

  void hideTooltip({bool immediately = false}) {
    _previousTooltipInfo = null;
    (_tooltipKey?.currentState as CoreTooltipState?)
        ?.hide(immediately: immediately);
  }

  void hideInteractiveTooltip() {
    if (tooltipBehavior != null && tooltipBehavior!.enable) {
      hideTooltip(immediately: true);
    }
    if (trackballBehavior != null &&
        trackballBehavior!.enable &&
        !trackballBehavior!.shouldAlwaysShow) {
      _hideTrackball(immediately: true);
    }
  }

  void _hideTrackball({int doubleTapHideDelay = 0, bool immediately = false}) {
    if (trackballBehavior != null) {
      if (immediately) {
        trackballBehavior!.hide();
      } else if (!trackballBehavior!.shouldAlwaysShow) {
        final int hideDelay = trackballBehavior!.hideDelay > 0
            ? trackballBehavior!.hideDelay.toInt()
            : doubleTapHideDelay;
        _trackballHideTimer?.cancel();
        _trackballHideTimer = Timer(Duration(milliseconds: hideDelay), () {
          _trackballHideTimer = null;
          trackballBehavior!.hide();
        });
      }
    }
  }

  void invalidate() {
    markNeedsPaint();
  }

  @override
  void performLayout() {
    RenderBox? child = firstChild;
    while (child != null) {
      child.layout(constraints);
      final StackParentData childParentData =
          child.parentData! as StackParentData;
      child = childParentData.nextSibling;
    }
    size = constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    crosshairBehavior?.onPaint(context, offset, chartThemeData!, themeData!);
    trackballBehavior?.onPaint(context, offset, chartThemeData!, themeData!);
    zoomPanBehavior?.onPaint(context, offset, chartThemeData!, themeData!);
    defaultPaint(context, offset);
  }

  @override
  void dispose() {
    _previousTooltipInfo = null;
    _crosshairHideTimer?.cancel();
    _trackballHideTimer?.cancel();

    _crosshairEnabled = false;
    _trackballEnabled = false;
    _zoomingEnabled = false;
    performZoomThroughTouch = false;
    super.dispose();
  }
}
