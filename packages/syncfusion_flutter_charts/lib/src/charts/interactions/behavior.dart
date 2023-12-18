import 'dart:async';
import 'dart:math';
import 'dart:ui' as dart_ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../sparkline/utils/helper.dart';
import '../axis/axis.dart';
import '../axis/category_axis.dart';
import '../axis/datetime_axis.dart';
import '../axis/datetime_category_axis.dart';
import '../axis/logarithmic_axis.dart';
import '../axis/numeric_axis.dart';
import '../base.dart';
import '../common/callbacks.dart';
import '../common/chart_point.dart';
import '../common/core_tooltip.dart';
import '../common/interactive_tooltip.dart';
import '../common/marker.dart';
import '../indicators/technical_indicator.dart';
import '../series/bar_series.dart';
import '../series/box_and_whisker_series.dart';
import '../series/bubble_series.dart';
import '../series/candle_series.dart';
import '../series/chart_series.dart';
import '../series/column_series.dart';
import '../series/hilo_open_close_series.dart';
import '../series/hilo_series.dart';
import '../series/histogram_series.dart';
import '../series/range_column_series.dart';
import '../series/scatter_series.dart';
import '../series/spline_series.dart';
import '../series/waterfall_series.dart';
import '../utils/constants.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import 'tooltip.dart';
import 'trackball.dart';

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
  bool _performZoomThroughTouch = false;
  TooltipInfo? _previousTooltipInfo;

  RenderCartesianAxes? cartesianAxes;
  RenderIndicatorArea? indicatorArea;
  RenderChartPlotArea? plotArea;
  RenderLoadingIndicator? _loadingIndicator;

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
      _performZoomThroughTouch = value != null &&
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
  }

  @override
  void remove(RenderBox child) {
    super.remove(child);
    if (child is RenderLoadingIndicator) {
      _loadingIndicator = null;
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
    bool isHit = false;
    if (size.contains(position)) {
      if (_loadingIndicator != null) {
        final StackParentData childParentData =
            _loadingIndicator!.parentData! as StackParentData;
        isHit = result.addWithPaintOffset(
          offset: childParentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            return _loadingIndicator!.hitTest(result, position: transformed);
          },
        );
      }

      return isHit || _crosshairEnabled || _trackballEnabled || _zoomingEnabled;
    }
    return false;
  }

  void handlePointerEnter(PointerEnterEvent details) {
    if (_crosshairEnabled &&
        crosshairBehavior!.activationMode == ActivationMode.singleTap) {
      _showCrosshair(globalToLocal(details.position));
    }
    if (_trackballEnabled &&
        trackballBehavior!.activationMode == ActivationMode.singleTap) {
      _showTrackball(globalToLocal(details.position));
    }
  }

  void handlePointerDown(PointerDownEvent details) {
    if (zoomPanBehavior != null) {
      zoomPanBehavior!._startPinchZooming(details);
    }
    _loadingIndicator?.handlePointerDown(details);
  }

  void handlePointerMove(PointerMoveEvent details) {
    if (crosshairBehavior?.activationMode == ActivationMode.singleTap) {
      _showCrosshair(globalToLocal(details.position));
    }
    if (trackballBehavior?.activationMode == ActivationMode.singleTap) {
      _showTrackball(globalToLocal(details.position));
    }
    if (zoomPanBehavior != null && zoomPanBehavior!.enablePinching) {
      _performPinchZoomUpdate(details);
    }
  }

  void handlePointerHover(PointerHoverEvent details) {
    if (_crosshairEnabled &&
        crosshairBehavior!.activationMode == ActivationMode.singleTap) {
      _showCrosshair(globalToLocal(details.position));
    }
    if (_trackballEnabled &&
        trackballBehavior!.activationMode == ActivationMode.singleTap) {
      _showTrackball(globalToLocal(details.position));
    }
  }

  void handlePointerUp(PointerUpEvent details) {
    if (trackballBehavior?.activationMode != ActivationMode.doubleTap) {
      _hideTrackball();
    }
    if (_performZoomThroughTouch) {
      zoomPanBehavior!._endPinchZooming(details);
    }
  }

  void handlePointerCancel(PointerCancelEvent details) {
    _hideCrosshair(immediately: true);
    _hideTrackball(immediately: true);
  }

  void handlePointerExit(PointerExitEvent details) {
    _hideCrosshair(immediately: true);
    _hideTrackball(immediately: true);
  }

  void handleLongPressStart(LongPressStartDetails details) {
    if (crosshairBehavior?.activationMode == ActivationMode.longPress) {
      _showCrosshair(globalToLocal(details.globalPosition));
    }
    if (trackballBehavior?.activationMode == ActivationMode.longPress) {
      _showTrackball(globalToLocal(details.globalPosition));
    }
    if (zoomPanBehavior != null && zoomPanBehavior!.enableSelectionZooming) {
      hideInteractiveTooltip();
      zoomPanBehavior!._longPressStart(globalToLocal(details.globalPosition));
    }
  }

  void handleLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    if (crosshairBehavior?.activationMode == ActivationMode.longPress) {
      _showCrosshair(globalToLocal(details.globalPosition));
    }
    if (trackballBehavior?.activationMode == ActivationMode.longPress) {
      _showTrackball(globalToLocal(details.globalPosition));
    }
    if (zoomPanBehavior != null && zoomPanBehavior!.enableSelectionZooming) {
      final Offset position = globalToLocal(details.globalPosition);
      zoomPanBehavior!._doSelectionZooming(position.dx, position.dy);
      markNeedsPaint();
    }
  }

  void handleLongPressEnd(LongPressEndDetails details) {
    _hideCrosshair();
    _hideTrackball();
    if (zoomPanBehavior != null && zoomPanBehavior!.enableSelectionZooming) {
      zoomPanBehavior!._longPressEnd();
      markNeedsPaint();
    }
  }

  void handleTapDown(TapDownDetails details) {
    if (crosshairBehavior?.activationMode == ActivationMode.singleTap) {
      _showCrosshair(globalToLocal(details.globalPosition));
    }
    if (trackballBehavior?.activationMode == ActivationMode.singleTap) {
      _showTrackball(globalToLocal(details.globalPosition));
    }
  }

  void handleTapUp(TapUpDetails details) {
    _hideCrosshair();
    _hideTrackball();
  }

  void handleDoubleTap(Offset position) {
    final Offset localPosition = globalToLocal(position);
    if (crosshairBehavior?.activationMode == ActivationMode.doubleTap) {
      _showCrosshair(localPosition);
      _hideCrosshair(doubleTapHideDelay: 200);
    }
    if (trackballBehavior?.activationMode == ActivationMode.doubleTap) {
      _showTrackball(localPosition);
      _hideTrackball(doubleTapHideDelay: 200);
    }
    if (zoomPanBehavior != null && zoomPanBehavior!.enableDoubleTapZooming) {
      hideInteractiveTooltip();
      zoomPanBehavior!._doubleTap(localPosition, paintBounds);
    }
  }

  void handleScaleStart(ScaleStartDetails details) {
    zoomPanBehavior?._startPanning();
    _loadingIndicator?.handleScaleStart(details);
  }

  void handleScaleUpdate(ScaleUpdateDetails details) {
    _performPanning(details);
    _loadingIndicator?.handleScaleUpdate(details);
  }

  void handleScaleEnd(ScaleEndDetails details) {
    zoomPanBehavior?._endPanning();
    _loadingIndicator?.handleScaleEnd(details);
  }

  void handlePanZoomUpdate(PointerEvent details) {
    if (zoomPanBehavior != null &&
        attached &&
        zoomPanBehavior!.enableMouseWheelZooming) {
      hideInteractiveTooltip();
      final Offset localPosition = globalToLocal(details.position);
      if (details is PointerScrollEvent) {
        zoomPanBehavior!._performMouseWheelZooming(
            details, localPosition.dx, localPosition.dy, paintBounds);
      } else {
        zoomPanBehavior!._performMouseWheelZooming(
            details, localPosition.dx, localPosition.dy, paintBounds);
      }
    }
  }

  void _performPinchZoomUpdate(PointerMoveEvent event) {
    if (_performZoomThroughTouch && zoomPanBehavior!.enablePinching) {
      hideInteractiveTooltip();
      zoomPanBehavior!._zoom(event);
    }
  }

  void _performPanning(ScaleUpdateDetails details) {
    if (zoomPanBehavior != null && zoomPanBehavior!.enablePanning) {
      zoomPanBehavior!._pan(globalToLocal(details.focalPoint), paintBounds);
    }
  }

  void _showCrosshair(Offset localPosition) {
    crosshairBehavior?.show(localPosition.dx, localPosition.dy, 'pixel');
  }

  void _hideCrosshair({int doubleTapHideDelay = 0, bool immediately = false}) {
    if (crosshairBehavior != null) {
      if (immediately) {
        crosshairBehavior!.hide();
      } else if (!crosshairBehavior!.shouldAlwaysShow) {
        final int hideDelay = crosshairBehavior!.hideDelay > 0
            ? crosshairBehavior!.hideDelay.toInt()
            : doubleTapHideDelay;
        _crosshairHideTimer?.cancel();
        _crosshairHideTimer = Timer(Duration(milliseconds: hideDelay), () {
          _crosshairHideTimer = null;
          crosshairBehavior!.hide();
        });
      }
    }
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

  void _showTrackball(Offset position) {
    trackballBehavior?.show(position.dx, position.dy, 'pixel');
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
    zoomPanBehavior?._onPaint(context);
    crosshairBehavior?._onPaint(
      context,
      (crosshairBehavior!._position ?? Offset.zero) + offset,
      this,
      chartThemeData!,
      cartesianAxes,
    );
    trackballBehavior?._onPaint(
      context,
      (trackballBehavior!.position ?? Offset.zero) + offset,
      chartThemeData!,
    );
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
    _performZoomThroughTouch = false;
    super.dispose();
  }
}

/// Customizes the zooming options.
///
/// Customize the various zooming actions such as tap zooming, selection
/// zooming, zoom pinch. In selection zooming, you can long-press and drag to
/// select a range on the chart to be zoomed in and also you can customize the
/// selection zooming rectangle using `selectionRectBorderWidth`,
/// `selectionRectBorderColor` and `selectionRectColor` properties.
///
/// Pinch zooming can be performed by moving two fingers over the chart.
/// Default mode is [ZoomMode.xy]. Zooming will be stopped after reaching
/// `maximumZoomLevel`.
///
/// _Note:_ This is only applicable for `SfCartesianChart`.
class ZoomPanBehavior extends ChartBehavior {
  /// Creating an argument constructor of ZoomPanBehavior class.
  ZoomPanBehavior({
    this.enablePinching = false,
    this.enableDoubleTapZooming = false,
    this.enablePanning = false,
    this.enableSelectionZooming = false,
    this.enableMouseWheelZooming = false,
    this.zoomMode = ZoomMode.xy,
    this.maximumZoomLevel = 0.01,
    this.selectionRectBorderWidth = 1,
    this.selectionRectBorderColor,
    this.selectionRectColor,
  });

  /// Enables or disables the pinch zooming.
  ///
  /// Pinching can be performed by moving two fingers over the chart.
  /// You can zoom the chart through pinch gesture in touch enabled devices.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     enablePinching: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final bool enablePinching;

  /// Enables or disables the double tap zooming.
  ///
  /// Zooming will enable when you tap double time in plot area.
  /// After reaching the maximum zoom level, zooming will be stopped.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     enableDoubleTapZooming: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final bool enableDoubleTapZooming;

  /// Enables or disables the panning.
  ///
  /// Panning can be performed on a zoomed axis.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     enablePanning: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final bool enablePanning;

  /// Enables or disables the selection zooming.
  ///
  /// Selection zooming can be performed by long-press and then dragging.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     enableSelectionZooming: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final bool enableSelectionZooming;

  /// Enables or disables the mouseWheelZooming.
  ///
  /// Mouse wheel zooming can be performed by rolling the mouse wheel up or
  /// down. The place where the cursor is hovering gets zoomed in or out
  /// according to the mouse wheel rolling up or down.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     enableMouseWheelZooming: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final bool enableMouseWheelZooming;

  /// By default, both the x and y-axes in the chart can be zoomed.
  ///
  /// It can be changed by setting value to this property.
  ///
  /// Defaults to `ZoomMode.xy`.
  ///
  /// Also refer [ZoomMode].
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     zoomMode: ZoomMode.x
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final ZoomMode zoomMode;

  /// Maximum zoom level.
  ///
  /// Zooming will be stopped after reached this value and ranges from 0 to 1.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     maximumZoomLevel: 0.8
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final double maximumZoomLevel;

  /// Border width of the selection zooming rectangle.
  ///
  /// Used to change the stroke width of the selection rectangle.
  ///
  /// Defaults to `1`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     enableSelectionZooming: true,
  ///     selectionRectBorderWidth: 2
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final double selectionRectBorderWidth;

  /// Border color of the selection zooming rectangle.
  ///
  /// It used to change the stroke color of the selection rectangle.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     enableSelectionZooming: true,
  ///     selectionRectBorderColor: Colors.red
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final Color? selectionRectBorderColor;

  /// Color of the selection zooming rectangle.
  ///
  /// It used to change the background color of the selection rectangle.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior = ZoomPanBehavior(
  ///     enableSelectionZooming: true,
  ///     selectionRectColor: Colors.yellow
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior
  ///   );
  /// }
  /// ```
  final Color? selectionRectColor;

  late bool _isZoomIn, _isZoomOut;
  Path? _rectPath;

  bool? _isPinching = false;
  Offset? _previousMovedPosition;
  Offset? _zoomStartPosition;
  List<PointerEvent> _touchStartPositions = <PointerEvent>[];
  List<PointerEvent> _touchMovePositions = <PointerEvent>[];
  List<ZoomAxisRange> _zoomAxes = <ZoomAxisRange>[];

  /// Holds the value of zooming rect.
  Rect _zoomingRect = Rect.zero;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is ZoomPanBehavior &&
        other.enablePinching == enablePinching &&
        other.enableDoubleTapZooming == enableDoubleTapZooming &&
        other.enablePanning == enablePanning &&
        other.enableSelectionZooming == enableSelectionZooming &&
        other.enableMouseWheelZooming == enableMouseWheelZooming &&
        other.zoomMode == zoomMode &&
        other.maximumZoomLevel == maximumZoomLevel &&
        other.selectionRectBorderWidth == selectionRectBorderWidth &&
        other.selectionRectBorderColor == selectionRectBorderColor &&
        other.selectionRectColor == selectionRectColor;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    final List<Object?> values = <Object?>[
      enablePinching,
      enableDoubleTapZooming,
      enablePanning,
      enableSelectionZooming,
      enableMouseWheelZooming,
      zoomMode,
      maximumZoomLevel,
      selectionRectBorderWidth,
      selectionRectBorderColor,
      selectionRectColor
    ];
    return Object.hashAll(values);
  }

  // TODO(VijayakumarM): Avoid exposing it in public.
  void _zoom(PointerMoveEvent event) {
    Rect? pinchRect;
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }
    final RenderCartesianAxes? axes = parent.cartesianAxes;
    if (axes == null) {
      return;
    }
    final Rect clipRect = parent.paintBounds;
    num selectionMin, selectionMax, rangeMin, rangeMax, value, axisTrans;
    double currentFactor, currentPosition, maxZoomFactor, currentZoomFactor;
    int count = 0;
    if (enablePinching == true && _touchStartPositions.length == 2) {
      _isPinching = true;
      final int pointerID = event.pointer;
      bool addPointer = true;
      for (int i = 0; i < _touchMovePositions.length; i++) {
        if (_touchMovePositions[i].pointer == pointerID) {
          addPointer = false;
        }
      }
      if (_touchMovePositions.length < 2 && addPointer) {
        _touchMovePositions.add(event);
      }
      if (_touchMovePositions.length == 2) {
        if (_touchMovePositions[0].pointer == event.pointer) {
          _touchMovePositions[0] = event;
        }
        if (_touchMovePositions[1].pointer == event.pointer) {
          _touchMovePositions[1] = event;
        }
        Offset touchStart0, touchEnd0, touchStart1, touchEnd1;
        _calculateZoomAxesRange(axes);
        final Rect containerRect = Offset.zero & clipRect.size;
        touchStart0 = _touchStartPositions[0].position - containerRect.topLeft;
        touchEnd0 = _touchMovePositions[0].position - containerRect.topLeft;
        touchStart1 = _touchStartPositions[1].position - containerRect.topLeft;
        touchEnd1 = _touchMovePositions[1].position - containerRect.topLeft;
        final double scaleX = (touchEnd0.dx - touchEnd1.dx).abs() /
            (touchStart0.dx - touchStart1.dx).abs();
        final double scaleY = (touchEnd0.dy - touchEnd1.dy).abs() /
            (touchStart0.dy - touchStart1.dy).abs();
        final double clipX = ((clipRect.left - touchEnd0.dx) / scaleX) +
            min(touchStart0.dx, touchStart1.dx);
        final double clipY = ((clipRect.top - touchEnd0.dy) / scaleY) +
            min(touchStart0.dy, touchStart1.dy);
        pinchRect = Rect.fromLTWH(
            clipX, clipY, clipRect.width / scaleX, clipRect.height / scaleY);
      }
    }
    axes.visitChildren((RenderObject child) {
      if (child is RenderChartAxis && pinchRect != null) {
        child.zoomingInProgress = true;
        if ((child.isVertical && zoomMode != ZoomMode.x) ||
            (!child.isVertical && zoomMode != ZoomMode.y)) {
          if (!child.isVertical) {
            value = pinchRect.left - clipRect.left;
            axisTrans = clipRect.width / _zoomAxes[count].delta!;
            rangeMin = value / axisTrans + _zoomAxes[count].min!;
            value = pinchRect.left + pinchRect.width - clipRect.left;
            rangeMax = value / axisTrans + _zoomAxes[count].min!;
          } else {
            value = pinchRect.top - clipRect.top;
            axisTrans = clipRect.height / _zoomAxes[count].delta!;
            rangeMin = (value * -1 + clipRect.height) / axisTrans +
                _zoomAxes[count].min!;
            value = pinchRect.top + pinchRect.height - clipRect.top;
            rangeMax = (value * -1 + clipRect.height) / axisTrans +
                _zoomAxes[count].min!;
          }
          selectionMin = min(rangeMin, rangeMax);
          selectionMax = max(rangeMin, rangeMax);
          currentPosition = (selectionMin - _zoomAxes[count].actualMin!) /
              _zoomAxes[count].actualDelta!;
          currentFactor =
              (selectionMax - selectionMin) / _zoomAxes[count].actualDelta!;
          child.controller.zoomPosition =
              currentPosition < 0 ? 0 : currentPosition;
          currentZoomFactor = currentFactor > 1 ? 1 : currentFactor;
          maxZoomFactor = maximumZoomLevel;
          child.controller.zoomFactor = currentZoomFactor < maxZoomFactor
              ? maxZoomFactor
              : currentZoomFactor;
        }
        if (parent.onZooming != null) {
          _bindZoomEvent(child, parent.onZooming!);
        }
      }
      count++;
    });
  }

  void _pan(Offset currentPosition, Rect plotAreaBound) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }
    final RenderCartesianAxes? axes = parent.cartesianAxes;
    if (axes == null) {
      return;
    }
    double currentZoomPosition;
    num currentScale, value;
    if (_previousMovedPosition != null) {
      axes.visitChildren((RenderObject child) {
        if (child is RenderChartAxis) {
          child.zoomingInProgress = true;
          if ((child.isVertical && zoomMode != ZoomMode.x) ||
              (!child.isVertical && zoomMode != ZoomMode.y)) {
            currentZoomPosition = child.controller.zoomPosition;
            currentScale =
                max(1 / _minMax(child.controller.zoomFactor, 0, 1), 1);
            if (child.isVertical) {
              value = (_previousMovedPosition!.dy - currentPosition.dy) /
                  plotAreaBound.height /
                  currentScale;
              currentZoomPosition = _minMax(
                  child.isInversed
                      ? child.controller.zoomPosition + value
                      : child.controller.zoomPosition - value,
                  0,
                  1 - child.controller.zoomFactor);
              child.controller.zoomPosition = currentZoomPosition;
            } else {
              value = (_previousMovedPosition!.dx - currentPosition.dx) /
                  plotAreaBound.width /
                  currentScale;
              currentZoomPosition = _minMax(
                  child.isInversed
                      ? child.controller.zoomPosition - value
                      : child.controller.zoomPosition + value,
                  0,
                  1 - child.controller.zoomFactor);
              child.controller.zoomPosition = currentZoomPosition;
            }
          }
          if (parent.onZooming != null) {
            _bindZoomEvent(child, parent.onZooming!);
          }
        }
      });
    }
    _previousMovedPosition = currentPosition;
  }

  void _doubleTap(Offset position, Rect plotAreaBounds) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }
    final RenderCartesianAxes? axes = parent.cartesianAxes;
    if (axes == null) {
      return;
    }
    axes.visitChildren((RenderObject child) {
      if (child is RenderChartAxis) {
        child.zoomingInProgress = true;
        if (parent.onZoomStart != null) {
          _bindZoomEvent(child, parent.onZoomStart!);
        }
        if ((child.isVertical && zoomMode != ZoomMode.x) ||
            (!child.isVertical && zoomMode != ZoomMode.y)) {
          double zoomFactor = child.controller.zoomFactor;
          final double cumulative = max(
              max(1 / _minMax(child.controller.zoomFactor, 0, 1), 1) + (0.25),
              1);
          if (cumulative >= 1) {
            double origin = child.isVertical
                ? 1 - (position.dy / plotAreaBounds.height)
                : position.dx / plotAreaBounds.width;
            origin = origin > 1
                ? 1
                : origin < 0
                    ? 0
                    : origin;
            zoomFactor = cumulative == 1 ? 1 : _minMax(1 / cumulative, 0, 1);
            final double zoomPosition = (cumulative == 1)
                ? 0
                : child.controller.zoomPosition +
                    ((child.controller.zoomFactor - zoomFactor) * origin);
            if (child.controller.zoomPosition != zoomPosition ||
                child.controller.zoomFactor != zoomFactor) {
              zoomFactor = (zoomPosition + zoomFactor) > 1
                  ? (1 - zoomPosition)
                  : zoomFactor;
            }

            child.controller.zoomPosition = zoomPosition;
            child.controller.zoomFactor = zoomFactor;
          }
          final double maxZoomFactor = maximumZoomLevel;
          if (zoomFactor < maxZoomFactor) {
            child.controller.zoomFactor = maxZoomFactor;
            child.controller.zoomPosition = 0.0;
            zoomFactor = maxZoomFactor;
          }
        }
        if (parent.onZoomEnd != null) {
          _bindZoomEvent(child, parent.onZoomEnd!);
        }
      }
    });
  }

  /// Below method is for mouse wheel Zooming.
  void _performMouseWheelZooming(
      PointerEvent event, double mouseX, double mouseY, Rect plotAreaBounds) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }
    final RenderCartesianAxes? axes = parent.cartesianAxes;
    if (axes == null) {
      return;
    }
    double direction = 0.0;
    if (event is PointerScrollEvent) {
      direction = (event.scrollDelta.dy / 120) > 0 ? -1 : 1;
    } else if (event is PointerPanZoomUpdateEvent) {
      direction = event.panDelta.dy == 0
          ? 0
          : (event.panDelta.dy / 120) > 0
              ? 1
              : -1;
    }
    double origin = 0.5;
    double cumulative, zoomFactor, zoomPosition, maxZoomFactor;
    axes.visitChildren((RenderObject child) {
      if (child is RenderChartAxis) {
        if (parent.onZoomStart != null) {
          _bindZoomEvent(child, parent.onZoomStart!);
        }
        if ((child.isVertical && zoomMode != ZoomMode.x) ||
            (!child.isVertical && zoomMode != ZoomMode.y)) {
          cumulative = max(
              max(1 / _minMax(child.controller.zoomFactor, 0, 1), 1) +
                  (0.25 * direction),
              1);
          if (cumulative >= 1) {
            origin = child.isVertical
                ? 1 - (mouseY / plotAreaBounds.height)
                : mouseX / plotAreaBounds.width;
            origin = origin > 1
                ? 1
                : origin < 0
                    ? 0
                    : origin;
            zoomFactor = ((cumulative == 1) ? 1 : _minMax(1 / cumulative, 0, 1))
                .toDouble();
            zoomPosition = (cumulative == 1)
                ? 0
                : child.controller.zoomPosition +
                    ((child.controller.zoomFactor - zoomFactor) * origin);
            if (child.controller.zoomPosition != zoomPosition ||
                child.controller.zoomFactor != zoomFactor) {
              zoomFactor = (zoomPosition + zoomFactor) > 1
                  ? (1 - zoomPosition)
                  : zoomFactor;
            }
            child.controller.zoomPosition = zoomPosition < 0
                ? 0
                : zoomPosition > 1
                    ? 1
                    : zoomPosition;
            child.controller.zoomFactor = zoomFactor < 0
                ? 0
                : zoomFactor > 1
                    ? 1
                    : zoomFactor;
            maxZoomFactor = maximumZoomLevel;
            if (zoomFactor < maxZoomFactor) {
              child.controller.zoomFactor = maxZoomFactor;
              zoomFactor = maxZoomFactor;
            }
            if (parent.onZoomEnd != null) {
              _bindZoomEvent(child, parent.onZoomEnd!);
            }
            if (child.controller.zoomFactor.toInt() == 1 &&
                child.controller.zoomPosition.toInt() == 0 &&
                parent.onZoomReset != null) {
              _bindZoomEvent(child, parent.onZoomReset!);
            }
          }
        }
      }
    });
  }

  /// Below method for drawing selection rectangle.
  void _doSelectionZooming(double currentX, double currentY) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }
    if (_isPinching != true && _zoomStartPosition != null) {
      final Offset start = _zoomStartPosition!;
      final Rect clipRect = parent.paintBounds;
      final Offset startPosition = Offset(
          (start.dx < clipRect.left) ? clipRect.left : start.dx,
          (start.dy < clipRect.top) ? clipRect.top : start.dy);
      final Offset currentMousePosition = Offset(
          (currentX > clipRect.right)
              ? clipRect.right
              : ((currentX < clipRect.left) ? clipRect.left : currentX),
          (currentY > clipRect.bottom)
              ? clipRect.bottom
              : ((currentY < clipRect.top) ? clipRect.top : currentY));
      _rectPath = Path();
      if (zoomMode == ZoomMode.x) {
        _rectPath!.moveTo(startPosition.dx, clipRect.top);
        _rectPath!.lineTo(startPosition.dx, clipRect.bottom);
        _rectPath!.lineTo(currentMousePosition.dx, clipRect.bottom);
        _rectPath!.lineTo(currentMousePosition.dx, clipRect.top);
        _rectPath!.close();
      } else if (zoomMode == ZoomMode.y) {
        _rectPath!.moveTo(clipRect.left, startPosition.dy);
        _rectPath!.lineTo(clipRect.left, currentMousePosition.dy);
        _rectPath!.lineTo(clipRect.right, currentMousePosition.dy);
        _rectPath!.lineTo(clipRect.right, startPosition.dy);
        _rectPath!.close();
      } else {
        _rectPath!.moveTo(startPosition.dx, startPosition.dy);
        _rectPath!.lineTo(startPosition.dx, currentMousePosition.dy);
        _rectPath!.lineTo(currentMousePosition.dx, currentMousePosition.dy);
        _rectPath!.lineTo(currentMousePosition.dx, startPosition.dy);
        _rectPath!.close();
      }
      _zoomingRect = _rectPath!.getBounds();
    }
  }

  /// Increases the magnification of the plot area.
  void zoomIn() {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }

    parent.hideInteractiveTooltip();
    final RenderCartesianAxes? cartesianAxes = parent.cartesianAxes;
    if (cartesianAxes == null) {
      return;
    }
    _isZoomIn = true;
    _isZoomOut = false;
    // TODO(YuvarajG): Need to have variable to notify zooming inprogress
    // _stateProperties.zoomProgress = true;
    bool? needZoom;
    RenderChartAxis? child = cartesianAxes.firstChild;
    while (child != null) {
      if ((child.isVertical && zoomMode != ZoomMode.x) ||
          (!child.isVertical && zoomMode != ZoomMode.y)) {
        if (child.controller.zoomFactor <= 1.0 &&
            child.controller.zoomFactor > 0.0) {
          if (child.controller.zoomFactor - 0.1 < 0) {
            needZoom = false;
            break;
          } else {
            _updateZoomFactorAndZoomPosition(child);
            needZoom = true;
          }
        }
        if (parent.onZooming != null) {
          _bindZoomEvent(child, parent.onZooming!);
        }
      }
      final CartesianAxesParentData childParentData =
          child.parentData! as CartesianAxesParentData;
      child = childParentData.nextSibling;
    }
    if (needZoom ?? false) {
      (parentBox as RenderBehaviorArea?)?.invalidate();
    }
  }

  /// Decreases the magnification of the plot area.
  void zoomOut() {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }

    parent.hideInteractiveTooltip();
    final RenderCartesianAxes? cartesianAxes = parent.cartesianAxes;
    if (cartesianAxes == null) {
      return;
    }
    _isZoomIn = false;
    _isZoomOut = true;
    // TODO(YuvarajG): Need to have variable to notify zooming inprogress
    // _stateProperties.zoomProgress = true;
    RenderChartAxis? child = cartesianAxes.firstChild;
    while (child != null) {
      if ((child.isVertical && zoomMode != ZoomMode.x) ||
          (!child.isVertical && zoomMode != ZoomMode.y)) {
        if (child.controller.zoomFactor < 1.0 &&
            child.controller.zoomFactor > 0.0) {
          _updateZoomFactorAndZoomPosition(child);
          child.controller.zoomFactor = child.controller.zoomFactor > 1.0
              ? 1.0
              : (child.controller.zoomFactor < 0.0
                  ? 0.0
                  : child.controller.zoomFactor);
        }
        if (parent.onZooming != null) {
          _bindZoomEvent(child, parent.onZooming!);
        }
      }
      final CartesianAxesParentData childParentData =
          child.parentData! as CartesianAxesParentData;
      child = childParentData.nextSibling;
    }
    (parentBox as RenderBehaviorArea?)?.invalidate();
  }

  /// Changes the zoom level using zoom factor.
  ///
  /// Here, you can pass the zoom factor of an axis to magnify the plot
  /// area. The value ranges from 0 to 1.
  void zoomByFactor(double zoomFactor) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }

    parent.hideInteractiveTooltip();
    final RenderCartesianAxes? cartesianAxes = parent.cartesianAxes;
    if (cartesianAxes == null) {
      return;
    }
    _isZoomIn = false;
    _isZoomOut = true;
    // TODO(YuvarajG): Need to have variable to notify zooming inprogress
    // _stateProperties.zoomProgress = true;
    RenderChartAxis? child = cartesianAxes.firstChild;
    if (zoomFactor.clamp(0.0, 1.0) == zoomFactor) {
      while (child != null) {
        if ((child.isVertical && zoomMode != ZoomMode.x) ||
            (!child.isVertical && zoomMode != ZoomMode.y)) {
          child.controller.zoomFactor = zoomFactor;
          if (parent.onZooming != null) {
            _bindZoomEvent(child, parent.onZooming!);
          }
        }
        final CartesianAxesParentData childParentData =
            child.parentData! as CartesianAxesParentData;
        child = childParentData.nextSibling;
      }
      (parentBox as RenderBehaviorArea?)?.invalidate();
    }
  }

  /// Zooms the chart for a given rectangle value.
  ///
  /// Here, you can pass the rectangle with the left, right, top, and bottom
  /// values, using which the selection zooming will be performed.
  void zoomByRect(Rect rect) {
    _drawSelectionZoomRect(rect);
  }

  /// Change the zoom level of an appropriate axis.
  ///
  /// Here, you need to pass axis, zoom factor, zoom position of the zoom level
  /// that needs to be modified.
  void zoomToSingleAxis(
      ChartAxis axis, double zoomPosition, double zoomFactor) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }

    parent.hideInteractiveTooltip();
    final RenderChartAxis? axisDetails = axis.name != null
        ? parent.axisFromName(axis.name)
        : parent.axisFromObject(axis);

    if (axisDetails != null) {
      axisDetails.controller.zoomFactor = zoomFactor;
      axisDetails.controller.zoomPosition = zoomPosition;
    }
    parent.invalidate();
  }

  /// Pans the plot area for given left, right, top, and bottom directions.
  ///
  /// To perform this action, the plot area needs to be in zoomed state.
  void panToDirection(String direction) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }

    parent.hideInteractiveTooltip();
    final RenderCartesianAxes? cartesianAxes = parent.cartesianAxes;
    if (cartesianAxes == null) {
      return;
    }
    direction = direction.toLowerCase();
    RenderChartAxis? child = cartesianAxes.firstChild;
    while (child != null) {
      if (child.isVertical) {
        if (direction == 'bottom') {
          child.controller.zoomPosition = (child.controller.zoomPosition > 0 &&
                  child.controller.zoomPosition <= 1.0)
              ? child.controller.zoomPosition - 0.1
              : child.controller.zoomPosition;
          child.controller.zoomPosition = child.controller.zoomPosition < 0.0
              ? 0.0
              : child.controller.zoomPosition;
        }
        if (direction == 'top') {
          child.controller.zoomPosition = (child.controller.zoomPosition >= 0 &&
                  child.controller.zoomPosition < 1)
              ? child.controller.zoomPosition + 0.1
              : child.controller.zoomPosition;
          child.controller.zoomPosition = child.controller.zoomPosition > 1.0
              ? 1.0
              : child.controller.zoomPosition;
        }
      } else {
        if (direction == 'left') {
          child.controller.zoomPosition = (child.controller.zoomPosition > 0 &&
                  child.controller.zoomPosition <= 1.0)
              ? child.controller.zoomPosition - 0.1
              : child.controller.zoomPosition;
          child.controller.zoomPosition = child.controller.zoomPosition < 0.0
              ? 0.0
              : child.controller.zoomPosition;
        }
        if (direction == 'right') {
          child.controller.zoomPosition = (child.controller.zoomPosition >= 0 &&
                  child.controller.zoomPosition < 1)
              ? child.controller.zoomPosition + 0.1
              : child.controller.zoomPosition;
          child.controller.zoomPosition = child.controller.zoomPosition > 1.0
              ? 1.0
              : child.controller.zoomPosition;
        }
      }
      if (parent.onZooming != null) {
        _bindZoomEvent(child, parent.onZooming!);
      }
      final CartesianAxesParentData childParentData =
          child.parentData! as CartesianAxesParentData;
      child = childParentData.nextSibling;
    }
    parent.invalidate();
  }

  /// Returns the plot area back to its original position after zooming.
  void reset() {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }

    parent.hideInteractiveTooltip();
    final RenderCartesianAxes? cartesianAxes = parent.cartesianAxes;
    if (cartesianAxes == null) {
      return;
    }
    RenderChartAxis? child = cartesianAxes.firstChild;
    while (child != null) {
      child.controller.zoomFactor = 1.0;
      child.controller.zoomPosition = 0.0;
      if (parent.onZoomReset != null) {
        _bindZoomEvent(child, parent.onZoomReset!);
      }
      final CartesianAxesParentData childParentData =
          child.parentData! as CartesianAxesParentData;
      child = childParentData.nextSibling;
    }
    parent.invalidate();
  }

  ZoomPanArgs _bindZoomEvent(
      RenderChartAxis axis, ChartZoomingCallback zoomEventType) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    final ZoomPanArgs zoomPanArgs = ZoomPanArgs(
        axis,
        axis.controller.previousZoomPosition,
        axis.controller.previousZoomFactor);
    zoomPanArgs.currentZoomFactor = axis.controller.zoomFactor;
    zoomPanArgs.currentZoomPosition = axis.controller.zoomPosition;
    if (parent == null) {
      return zoomPanArgs;
    }
    zoomEventType == parent.onZoomStart
        ? parent.onZoomStart!(zoomPanArgs)
        : zoomEventType == parent.onZoomEnd
            ? parent.onZoomEnd!(zoomPanArgs)
            : zoomEventType == parent.onZooming
                ? parent.onZooming!(zoomPanArgs)
                : parent.onZoomReset!(zoomPanArgs);
    return zoomPanArgs;
  }

  /// Below method for zooming selected portion.
  void _drawSelectionZoomRect(Rect zoomRect) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }

    parent.hideInteractiveTooltip();
    final RenderCartesianAxes? axes = parent.cartesianAxes;
    if (axes == null) {
      return;
    }
    axes.visitChildren((RenderObject child) {
      if (child is RenderChartAxis) {
        if (parent.onZoomStart != null) {
          _bindZoomEvent(child, parent.onZoomStart!);
        }
        if (child.isVertical) {
          if (zoomMode != ZoomMode.x) {
            child.controller.zoomPosition += (1 -
                    ((zoomRect.height +
                                (zoomRect.top - child.paintBounds.top)) /
                            (child.paintBounds.height))
                        .abs()) *
                child.controller.zoomFactor;
            child.controller.zoomFactor *=
                zoomRect.height / child.paintBounds.height;

            child.controller.zoomFactor =
                child.controller.zoomFactor >= maximumZoomLevel
                    ? child.controller.zoomFactor
                    : maximumZoomLevel;
          }
        } else {
          if (zoomMode != ZoomMode.y) {
            child.controller.zoomPosition +=
                ((zoomRect.left - child.paintBounds.left) /
                            (child.paintBounds.width))
                        .abs() *
                    child.controller.zoomFactor;
            child.controller.zoomFactor *=
                zoomRect.width / child.paintBounds.width;
            child.controller.zoomFactor =
                child.controller.zoomFactor >= maximumZoomLevel
                    ? child.controller.zoomFactor
                    : maximumZoomLevel;
          }
        }
        if (parent.onZoomEnd != null) {
          _bindZoomEvent(child, parent.onZoomEnd!);
        }
      }
    });
    zoomRect = Rect.zero;
    _rectPath = Path();
  }

  double _minMax(double value, double min, double max) {
    return value > max ? max : (value < min ? min : value);
  }

  void _onPaint(PaintingContext context) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }
    final RenderCartesianAxes? cartesianAxes = parent.cartesianAxes;
    if (cartesianAxes == null) {
      return;
    }
    if (_zoomingRect != Rect.zero && _rectPath != null) {
      Color? fillColor = selectionRectColor;
      if (fillColor != null &&
          fillColor != Colors.transparent &&
          fillColor.opacity == 1) {
        fillColor = fillColor.withOpacity(0.3);
      }
      final Paint fillPaint = Paint()
        ..color = fillColor ?? cartesianAxes.chartThemeData.selectionRectColor
        ..style = PaintingStyle.fill;
      context.canvas.drawRect(_zoomingRect, fillPaint);
      final Paint strokePaint = Paint()
        ..isAntiAlias = true
        ..color = selectionRectBorderColor ??
            cartesianAxes.chartThemeData.selectionRectBorderColor
        ..strokeWidth = selectionRectBorderWidth
        ..style = PaintingStyle.stroke;

      if (strokePaint.color != Colors.transparent &&
          strokePaint.strokeWidth > 0) {
        final List<double> dashArray = <double>[5, 5];
        drawDashes(context.canvas, dashArray, strokePaint, path: _rectPath);
      }

      final Offset plotAreaOffset =
          (parent.parentData! as BoxParentData).offset;
      //Selection zooming tooltip rendering
      _drawTooltipConnector(
          cartesianAxes,
          _zoomingRect.topLeft,
          _zoomingRect.bottomRight,
          context.canvas,
          parent.paintBounds,
          plotAreaOffset);
    }
  }

  void _calculateZoomAxesRange(RenderCartesianAxes axes) {
    ZoomAxisRange range;
    axes.visitChildren((RenderObject child) {
      range = ZoomAxisRange();
      if (child is RenderChartAxis) {
        if (child.actualRange != null) {
          range.actualMin = child.actualRange!.minimum.toDouble();
          range.actualDelta = child.actualRange!.delta.toDouble();
        }
        range.min = child.visibleRange!.minimum.toDouble();
        range.delta = child.visibleRange!.delta.toDouble();
        _zoomAxes.add(range);
      }
    });
  }

  /// Returns the tooltip label on zooming.
  String _tooltipValue(
      Offset position, RenderChartAxis axis, Rect plotAreaBounds) {
    final num value = axis.isVertical
        ? axis.pixelToPoint(axis.paintBounds, position.dx, position.dy)
        : axis.pixelToPoint(axis.paintBounds, position.dx - plotAreaBounds.left,
            position.dy - plotAreaBounds.top);

    dynamic result = _interactiveTooltipLabel(value, axis);
    if (axis.interactiveTooltip.format != null) {
      final String stringValue =
          axis.interactiveTooltip.format!.replaceAll('{value}', result);
      result = stringValue;
    }
    return result.toString();
  }

  /// Validate the rect by comparing small and large rect.
  Rect _validateRect(Rect largeRect, Rect smallRect, String axisPosition) =>
      Rect.fromLTRB(
          axisPosition == 'left'
              ? (smallRect.left - (largeRect.width - smallRect.width))
              : smallRect.left,
          smallRect.top,
          axisPosition == 'right'
              ? (smallRect.right + (largeRect.width - smallRect.width))
              : smallRect.right,
          smallRect.bottom);

  /// Calculate the interactive tooltip rect, based on the zoomed axis position.
  Rect _calculateRect(RenderChartAxis axis, Offset position, Size labelSize) {
    const double paddingForRect = 10;
    final Rect axisBound =
        (axis.parentData! as BoxParentData).offset & axis.size;
    final double arrowLength = axis.interactiveTooltip.arrowLength;
    double left, top;
    final double width = labelSize.width + paddingForRect;
    final double height = labelSize.height + paddingForRect;

    if (axis.isVertical) {
      top = position.dy - height / 2;
      if (axis.opposedPosition) {
        left = axisBound.left + arrowLength;
      } else {
        left = axisBound.left - width - arrowLength;
      }
    } else {
      left = position.dx - width / 2;
      if (axis.opposedPosition) {
        top = axisBound.top - height - arrowLength;
      } else {
        top = axisBound.top + arrowLength;
      }
    }
    return Rect.fromLTWH(left, top, width, height);
  }

  /// To draw tooltip connector.
  void _drawTooltipConnector(
      RenderCartesianAxes axes,
      Offset startPosition,
      Offset endPosition,
      Canvas canvas,
      Rect plotAreaBounds,
      Offset plotAreaOffset) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    RRect? startTooltipRect, endTooltipRect;
    String startValue, endValue;
    Size startLabelSize, endLabelSize;
    Rect startLabelRect, endLabelRect;
    TextStyle textStyle =
        parent!.chartThemeData!.selectionZoomingTooltipTextStyle!;
    final Paint labelFillPaint = Paint()
      ..color = axes.chartThemeData.crosshairBackgroundColor
      ..isAntiAlias = true;

    final Paint labelStrokePaint = Paint()
      ..color = axes.chartThemeData.crosshairBackgroundColor
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;

    axes.visitChildren((RenderObject child) {
      if (child is RenderChartAxis) {
        if (child.interactiveTooltip.enable) {
          textStyle = textStyle.merge(child.interactiveTooltip.textStyle);
          labelFillPaint.color = child.interactiveTooltip.color ??
              axes.chartThemeData.crosshairBackgroundColor;
          labelStrokePaint.color = child.interactiveTooltip.borderColor ??
              axes.chartThemeData.crosshairBackgroundColor;
          labelStrokePaint.strokeWidth = child.interactiveTooltip.borderWidth;
          final Paint connectorLinePaint = Paint()
            ..color = child.interactiveTooltip.connectorLineColor ??
                axes.chartThemeData.selectionTooltipConnectorLineColor
            ..strokeWidth = child.interactiveTooltip.connectorLineWidth
            ..style = PaintingStyle.stroke;

          final Path startLabelPath = Path();
          final Path endLabelPath = Path();
          startValue = _tooltipValue(startPosition, child, plotAreaBounds);
          endValue = _tooltipValue(endPosition, child, plotAreaBounds);

          if (startValue.isNotEmpty && endValue.isNotEmpty) {
            startLabelSize = measureText(startValue, textStyle);
            endLabelSize = measureText(endValue, textStyle);
            startLabelRect =
                _calculateRect(child, startPosition, startLabelSize);
            endLabelRect = _calculateRect(child, endPosition, endLabelSize);
            if (child.isVertical &&
                startLabelRect.width != endLabelRect.width) {
              final String axisPosition =
                  child.opposedPosition ? 'right' : 'left';
              (startLabelRect.width > endLabelRect.width)
                  ? endLabelRect =
                      _validateRect(startLabelRect, endLabelRect, axisPosition)
                  : startLabelRect =
                      _validateRect(endLabelRect, startLabelRect, axisPosition);
            }
            startTooltipRect = _drawTooltip(
                canvas,
                labelFillPaint,
                labelStrokePaint,
                startLabelPath,
                startPosition,
                startLabelRect,
                startTooltipRect,
                startValue,
                startLabelSize,
                plotAreaBounds,
                textStyle,
                child,
                plotAreaOffset);
            endTooltipRect = _drawTooltip(
                canvas,
                labelFillPaint,
                labelStrokePaint,
                endLabelPath,
                endPosition,
                endLabelRect,
                endTooltipRect,
                endValue,
                endLabelSize,
                plotAreaBounds,
                textStyle,
                child,
                plotAreaOffset);
            _drawConnector(canvas, connectorLinePaint, startTooltipRect!,
                endTooltipRect!, startPosition, endPosition, child);
          }
        }
      }
    });
  }

  /// To draw connectors.
  void _drawConnector(
      Canvas canvas,
      Paint connectorLinePaint,
      RRect startTooltipRect,
      RRect endTooltipRect,
      Offset startPosition,
      Offset endPosition,
      RenderChartAxis axis) {
    final InteractiveTooltip tooltip = axis.interactiveTooltip;
    if (!axis.isVertical && !axis.opposedPosition) {
      startPosition =
          Offset(startPosition.dx, startTooltipRect.top - tooltip.arrowLength);
      endPosition =
          Offset(endPosition.dx, endTooltipRect.top - tooltip.arrowLength);
    } else if (!axis.isVertical && axis.opposedPosition) {
      startPosition = Offset(
          startPosition.dx, startTooltipRect.bottom + tooltip.arrowLength);
      endPosition =
          Offset(endPosition.dx, endTooltipRect.bottom + tooltip.arrowLength);
    } else if (axis.isVertical && !axis.opposedPosition) {
      startPosition = Offset(
          startTooltipRect.right + tooltip.arrowLength, startPosition.dy);
      endPosition =
          Offset(endTooltipRect.right + tooltip.arrowLength, endPosition.dy);
    } else {
      startPosition =
          Offset(startTooltipRect.left - tooltip.arrowLength, startPosition.dy);
      endPosition =
          Offset(endTooltipRect.left - tooltip.arrowLength, endPosition.dy);
    }
    drawDashedPath(canvas, connectorLinePaint, startPosition, endPosition,
        tooltip.connectorLineDashArray);
  }

  /// To draw tooltip.
  RRect _drawTooltip(
      Canvas canvas,
      Paint fillPaint,
      Paint strokePaint,
      Path path,
      Offset position,
      Rect labelRect,
      RRect? rect,
      String value,
      Size labelSize,
      Rect plotAreaBound,
      TextStyle textStyle,
      RenderChartAxis axis,
      Offset plotAreaOffset) {
    final Offset parentDataOffset = (axis.parentData! as BoxParentData).offset;
    final Offset axisOffset =
        parentDataOffset.translate(-plotAreaOffset.dx, -plotAreaOffset.dy);
    final Rect axisRect = axisOffset & axis.size;
    labelRect = _validateRectBounds(labelRect, axisRect);
    labelRect = axis.isVertical
        ? _validateRectYPosition(labelRect, plotAreaBound)
        : _validateRectXPosition(labelRect, plotAreaBound);
    path.reset();
    rect = RRect.fromRectAndRadius(
        labelRect, Radius.circular(axis.interactiveTooltip.borderRadius));
    path.addRRect(rect);
    _calculateNeckPositions(
        canvas, fillPaint, strokePaint, path, position, rect, axis);
    drawText(
      canvas,
      value,
      Offset((rect.left + rect.width / 2) - labelSize.width / 2,
          (rect.top + rect.height / 2) - labelSize.height / 2),
      textStyle,
    );
    return rect;
  }

  /// To calculate tooltip neck positions.
  void _calculateNeckPositions(
      Canvas canvas,
      Paint fillPaint,
      Paint strokePaint,
      Path path,
      Offset position,
      RRect rect,
      RenderChartAxis axis) {
    final InteractiveTooltip tooltip = axis.interactiveTooltip;
    double x1, x2, x3, x4, y1, y2, y3, y4;
    if (!axis.isVertical && !axis.opposedPosition) {
      x1 = position.dx;
      y1 = rect.top - tooltip.arrowLength;
      x2 = (rect.right - rect.width / 2) + tooltip.arrowWidth;
      y2 = rect.top;
      x3 = (rect.left + rect.width / 2) - tooltip.arrowWidth;
      y3 = rect.top;
      x4 = position.dx;
      y4 = rect.top - tooltip.arrowLength;
    } else if (!axis.isVertical && axis.opposedPosition) {
      x1 = position.dx;
      y1 = rect.bottom + tooltip.arrowLength;
      x2 = (rect.right - rect.width / 2) + tooltip.arrowWidth;
      y2 = rect.bottom;
      x3 = (rect.left + rect.width / 2) - tooltip.arrowWidth;
      y3 = rect.bottom;
      x4 = position.dx;
      y4 = rect.bottom + tooltip.arrowLength;
    } else if (axis.isVertical && !axis.opposedPosition) {
      x1 = rect.right;
      y1 = rect.top + rect.height / 2 - tooltip.arrowWidth;
      x2 = rect.right;
      y2 = rect.bottom - rect.height / 2 + tooltip.arrowWidth;
      x3 = rect.right + tooltip.arrowLength;
      y3 = position.dy;
      x4 = rect.right + tooltip.arrowLength;
      y4 = position.dy;
    } else {
      x1 = rect.left;
      y1 = rect.top + rect.height / 2 - tooltip.arrowWidth;
      x2 = rect.left;
      y2 = rect.bottom - rect.height / 2 + tooltip.arrowWidth;
      x3 = rect.left - tooltip.arrowLength;
      y3 = position.dy;
      x4 = rect.left - tooltip.arrowLength;
      y4 = position.dy;
    }
    _drawTooltipArrowhead(
        canvas, path, fillPaint, strokePaint, x1, y1, x2, y2, x3, y3, x4, y4);
  }

  /// Below method is for zoomIn and zoomOut public methods.
  void _updateZoomFactorAndZoomPosition(RenderChartAxis axis) {
    final Rect axisClipRect = axis.paintBounds;
    double? zoomFactor, zoomPosition;
    final num direction = _isZoomIn
        ? 1
        : _isZoomOut
            ? -1
            : 1;
    final num cumulative = max(
        max(1 / _minMax(axis.controller.zoomFactor, 0, 1), 1) +
            (0.1 * direction),
        1);
    if (cumulative >= 1) {
      num origin = axis.isVertical
          ? 1 -
              ((axisClipRect.top + axisClipRect.height / 2) /
                  axisClipRect.height)
          : (axisClipRect.left + axisClipRect.width / 2) / axisClipRect.width;
      origin = origin > 1
          ? 1
          : origin < 0
              ? 0
              : origin;
      zoomFactor =
          ((cumulative == 1) ? 1 : _minMax(1 / cumulative, 0, 1)).toDouble();
      zoomPosition = (cumulative == 1)
          ? 0
          : axis.controller.zoomPosition +
              ((axis.controller.zoomFactor - zoomFactor) * origin);
      if (axis.controller.zoomPosition != zoomPosition ||
          axis.controller.zoomFactor != zoomFactor) {
        zoomFactor =
            (zoomPosition + zoomFactor) > 1 ? (1 - zoomPosition) : zoomFactor;
      }

      axis.controller.zoomPosition = zoomPosition;
      axis.controller.zoomFactor = zoomFactor;
    }
  }

  void _startPinchZooming(PointerEvent event) {
    if (_touchStartPositions.length < 2) {
      _touchStartPositions.add(event);
    }

    if (_touchStartPositions.length == 2) {
      final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
      if (parent != null &&
          parent.onZoomStart != null &&
          parent.cartesianAxes != null) {
        parent.hideInteractiveTooltip();
        final RenderCartesianAxes axes = parent.cartesianAxes!;

        axes.visitChildren((RenderObject child) {
          if (child is RenderChartAxis) {
            _bindZoomEvent(child, parent.onZoomStart!);
          }
        });
      }
    }
  }

  void _endPinchZooming(PointerUpEvent event) {
    if (_touchStartPositions.length == 2 && _touchMovePositions.length == 2) {
      final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
      if (parent != null && parent.cartesianAxes != null) {
        final RenderCartesianAxes axes = parent.cartesianAxes!;

        axes.visitChildren((RenderObject child) {
          if (child is RenderChartAxis) {
            if (parent.onZoomEnd != null) {
              _bindZoomEvent(child, parent.onZoomEnd!);
            }
            child.zoomingInProgress = false;
          }
        });
      }
    }

    _zoomAxes = <ZoomAxisRange>[];
    _touchMovePositions = <PointerEvent>[];
    _touchStartPositions = <PointerEvent>[];
    _isPinching = false;
  }

  void _startPanning() {
    _previousMovedPosition = null;
  }

  void _endPanning() {
    _previousMovedPosition = null;

    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent != null && parent.cartesianAxes != null) {
      final RenderCartesianAxes axes = parent.cartesianAxes!;

      axes.visitChildren((RenderObject child) {
        if (child is RenderChartAxis) {
          child.zoomingInProgress = false;
        }
      });
    }
  }

  void _longPressStart(Offset position) {
    if (_zoomStartPosition != position) {
      _zoomStartPosition = position;
    }
  }

  void _longPressEnd() {
    if (_zoomStartPosition != null && _zoomingRect.width != 0) {
      _drawSelectionZoomRect(_zoomingRect);
    }
    _zoomStartPosition = null;
    _zoomingRect = Rect.zero;
  }
}

/// This method will validate whether the tooltip exceeds the screen or not.
Rect _validateRectBounds(Rect tooltipRect, Rect boundary) {
  Rect validatedRect = tooltipRect;
  double difference = 0;

  /// Padding between the corners.
  const double padding = 0.5;

  // Move the tooltip if it's outside of the boundary.
  if (tooltipRect.left < boundary.left) {
    difference = (boundary.left - tooltipRect.left) + padding;
    validatedRect = validatedRect.translate(difference, 0);
  }
  if (tooltipRect.right > boundary.right) {
    difference = (tooltipRect.right - boundary.right) + padding;
    validatedRect = validatedRect.translate(-difference, 0);
  }
  if (tooltipRect.top < boundary.top) {
    difference = (boundary.top - tooltipRect.top) + padding;
    validatedRect = validatedRect.translate(0, difference);
  }

  if (tooltipRect.bottom > boundary.bottom) {
    difference = (tooltipRect.bottom - boundary.bottom) + padding;
    validatedRect = validatedRect.translate(0, -difference);
  }
  return validatedRect;
}

/// Gets the x position of validated rect.
Rect _validateRectYPosition(Rect labelRect, Rect axisClipRect) {
  Rect validatedRect = labelRect;
  if (labelRect.bottom >= axisClipRect.bottom) {
    validatedRect = Rect.fromLTRB(
        labelRect.left,
        labelRect.top - (labelRect.bottom - axisClipRect.bottom),
        labelRect.right,
        axisClipRect.bottom);
  } else if (labelRect.top <= axisClipRect.top) {
    validatedRect = Rect.fromLTRB(labelRect.left, axisClipRect.top,
        labelRect.right, labelRect.bottom + (axisClipRect.top - labelRect.top));
  }
  return validatedRect;
}

/// Gets the x position of validated rect.
Rect _validateRectXPosition(Rect labelRect, Rect axisClipRect) {
  Rect validatedRect = labelRect;
  if (labelRect.right >= axisClipRect.right) {
    validatedRect = Rect.fromLTRB(
        labelRect.left - (labelRect.right - axisClipRect.right),
        labelRect.top,
        axisClipRect.right,
        labelRect.bottom);
  } else if (labelRect.left <= axisClipRect.left) {
    validatedRect = Rect.fromLTRB(
        axisClipRect.left,
        labelRect.top,
        labelRect.right + (axisClipRect.left - labelRect.left),
        labelRect.bottom);
  }
  return validatedRect;
}

/// Draw tooltip arrow head.
void _drawTooltipArrowhead(
    Canvas canvas,
    Path backgroundPath,
    Paint fillPaint,
    Paint strokePaint,
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
    double x4,
    double y4) {
  backgroundPath.moveTo(x1, y1);
  backgroundPath.lineTo(x2, y2);
  backgroundPath.lineTo(x3, y3);
  backgroundPath.lineTo(x4, y4);
  backgroundPath.lineTo(x1, y1);
  fillPaint.isAntiAlias = true;
  canvas.drawPath(backgroundPath, strokePaint);
  canvas.drawPath(backgroundPath, fillPaint);
}

/// To get interactive tooltip label.
dynamic _interactiveTooltipLabel(dynamic value, RenderChartAxis axis) {
  if (axis.visibleLabels.isEmpty) {
    return '';
  }

  final int labelsLength = axis.visibleLabels.length;
  if (axis is RenderCategoryAxis) {
    value = value < 0 ? 0 : value;
    value = axis
        .visibleLabels[value.round() >= labelsLength
            ? (value.round() > labelsLength ? labelsLength - 1 : value - 1)
            : value.round()]
        .text;
  } else if (axis is RenderDateTimeCategoryAxis) {
    value = value < 0 ? 0 : value;
    value = axis
        .visibleLabels[value.round() >= labelsLength
            ? (value.round() > labelsLength ? labelsLength - 1 : value - 1)
            : value.round()]
        .text;
  } else if (axis is RenderDateTimeAxis) {
    final num interval = axis.visibleRange!.minimum.ceil();
    final num previousInterval = (axis.visibleLabels.isNotEmpty)
        ? axis.visibleLabels[labelsLength - 1].value
        : interval;
    final DateFormat dateFormat = axis.dateFormat ??
        _dateTimeLabelFormat(axis, interval.toInt(), previousInterval.toInt());
    value =
        dateFormat.format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));
  } else {
    value = axis is RenderLogarithmicAxis ? pow(10, value) : value;
    value = _labelValue(value, axis, axis.interactiveTooltip.decimalPlaces);
  }
  return value;
}

/// To get the label format of the date-time axis.
DateFormat _dateTimeLabelFormat(RenderChartAxis axis,
    [int? interval, int? prevInterval]) {
  DateFormat? format;
  final bool notDoubleInterval =
      (axis.interval != null && axis.interval! % 1 == 0) ||
          axis.interval == null;
  DateTimeIntervalType? actualIntervalType;
  num? minimum;
  if (axis is RenderDateTimeAxis) {
    actualIntervalType = axis.visibleIntervalType;
    minimum = axis.visibleRange!.minimum;
  } else if (axis is RenderDateTimeCategoryAxis) {
    minimum = axis.visibleRange!.minimum;
    actualIntervalType = axis.visibleIntervalType;
  }
  switch (actualIntervalType) {
    case DateTimeIntervalType.years:
      format = notDoubleInterval ? DateFormat.y() : DateFormat.MMMd();
      break;
    case DateTimeIntervalType.months:
      format = (minimum == interval || interval == prevInterval)
          ? _firstLabelFormat(actualIntervalType)
          : _dateTimeFormat(actualIntervalType, interval, prevInterval);

      break;
    case DateTimeIntervalType.days:
      format = (minimum == interval || interval == prevInterval)
          ? _firstLabelFormat(actualIntervalType)
          : _dateTimeFormat(actualIntervalType, interval, prevInterval);
      break;
    case DateTimeIntervalType.hours:
      format = DateFormat.j();
      break;
    case DateTimeIntervalType.minutes:
      format = DateFormat.Hm();
      break;
    case DateTimeIntervalType.seconds:
      format = DateFormat.ms();
      break;
    case DateTimeIntervalType.milliseconds:
      final DateFormat dateFormat = DateFormat('ss.SSS');
      format = dateFormat;
      break;
    case DateTimeIntervalType.auto:
      break;
    // ignore: no_default_cases
    default:
      break;
  }
  return format!;
}

/// Gets the the actual label value for tooltip and data label etc.
String _labelValue(dynamic value, dynamic axis, [int? showDigits]) {
  if (value.toString().split('.').length > 1) {
    final String str = value.toString();
    final List list = str.split('.');
    value = double.parse(value.toStringAsFixed(showDigits ?? 3));
    value = (list[1] == '0' ||
            list[1] == '00' ||
            list[1] == '000' ||
            list[1] == '0000' ||
            list[1] == '00000' ||
            list[1] == '000000' ||
            list[1] == '0000000')
        ? value.round()
        : value;
  }
  final dynamic text = axis is NumericAxis && axis.numberFormat != null
      ? axis.numberFormat!.format(value)
      : value;
  return ((axis.labelFormat != null && axis.labelFormat != '')
      ? axis.labelFormat.replaceAll(RegExp('{value}'), text.toString())
      : text.toString()) as String;
}

/// Calculate the dateTime format.
DateFormat? _dateTimeFormat(DateTimeIntervalType? actualIntervalType,
    int? interval, int? prevInterval) {
  final DateTime minimum = DateTime.fromMillisecondsSinceEpoch(interval!);
  final DateTime maximum = DateTime.fromMillisecondsSinceEpoch(prevInterval!);
  DateFormat? format;
  final bool isIntervalDecimal = interval % 1 == 0;
  if (actualIntervalType == DateTimeIntervalType.months) {
    format = minimum.year == maximum.year
        ? (isIntervalDecimal ? DateFormat.MMM() : DateFormat.MMMd())
        : DateFormat('yyy MMM');
  } else if (actualIntervalType == DateTimeIntervalType.days) {
    format = minimum.month != maximum.month
        ? (isIntervalDecimal ? DateFormat.MMMd() : DateFormat.MEd())
        : DateFormat.d();
  }

  return format;
}

/// Returns the first label format for date time values.
DateFormat? _firstLabelFormat(DateTimeIntervalType? actualIntervalType) {
  DateFormat? format;

  if (actualIntervalType == DateTimeIntervalType.months) {
    format = DateFormat('yyy MMM');
  } else if (actualIntervalType == DateTimeIntervalType.days) {
    format = DateFormat.MMMd();
  } else if (actualIntervalType == DateTimeIntervalType.minutes) {
    format = DateFormat.Hm();
  }

  return format;
}

/// Represents the zoom axis range class.
class ZoomAxisRange {
  /// Creates an instance of zoom axis range class.
  ZoomAxisRange({this.actualMin, this.actualDelta, this.min, this.delta});

  /// Holds the value of actual minimum, actual delta, minimum and delta value.
  double? actualMin, actualDelta, min, delta;
}

/// Customizes the trackball.
///
/// Trackball feature displays the tooltip for the data points that are closer
/// to the point where you touch on the chart area.
/// This feature can be enabled using enable property of [TrackballBehavior].
///
/// Provides options to customize the [activationMode], [tooltipDisplayMode],
/// [lineType] and [tooltipSettings].
class TrackballBehavior extends ChartBehavior {
  /// Creating an argument constructor of TrackballBehavior class.
  TrackballBehavior({
    this.activationMode = ActivationMode.longPress,
    this.lineType = TrackballLineType.vertical,
    this.tooltipDisplayMode = TrackballDisplayMode.floatAllPoints,
    this.tooltipAlignment = ChartAlignment.center,
    this.tooltipSettings = const InteractiveTooltip(),
    this.markerSettings,
    this.lineDashArray,
    this.enable = false,
    this.lineColor,
    this.lineWidth = 1,
    this.shouldAlwaysShow = false,
    this.builder,
    this.hideDelay = 0,
  });

  /// Toggles the visibility of the trackball.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(enable: true);
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  /// ```
  final bool enable;

  /// Width of the track line.
  ///
  /// Defaults to `1`.
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(
  ///     enable: true,
  ///     lineWidth: 5
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  /// ```
  final double lineWidth;

  /// Color of the track line.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(
  ///     enable: true,
  ///     lineColor: Colors.red
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  /// ```
  final Color? lineColor;

  /// Dashes of the track line.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(
  ///     enable: true,
  ///     lineDashArray: [10,10]
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  /// ```
  final List<double>? lineDashArray;

  /// Gesture for activating the trackball.
  ///
  /// Trackball can be activated in tap, double tap and long press.
  ///
  /// Defaults to `ActivationMode.longPress`.
  ///
  /// Also refer [ActivationMode].
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(
  ///     enable: true,
  ///     activationMode: ActivationMode.doubleTap
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  /// ```
  final ActivationMode activationMode;

  /// Alignment of the trackball tooltip.
  ///
  /// The trackball tooltip can be aligned at the top, bottom, and center
  /// position of the chart.
  ///
  /// _Note:_ This is applicable only when the `tooltipDisplayMode` property
  /// is set to `TrackballDisplayMode.groupAllPoints`.
  ///
  /// Defaults to `ChartAlignment.center`
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(
  ///     enable: true,
  ///     tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
  ///     tooltipAlignment: ChartAlignment.far
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  /// ```
  final ChartAlignment tooltipAlignment;

  /// Type of trackball line. By default, vertical line will be displayed.
  ///
  /// You can change this by specifying values to this property.
  ///
  /// Defaults to `TrackballLineType.vertical`.
  ///
  /// Also refer [TrackballLineType]
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(
  ///     enable: true,
  ///     lineType: TrackballLineType.vertical
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  /// ```
  final TrackballLineType lineType;

  /// Display mode of tooltip.
  ///
  /// By default, tooltip of all the series under the current point index value
  /// will be shown.
  ///
  /// Defaults to `TrackballDisplayMode.floatAllPoints`.
  ///
  /// Also refer [TrackballDisplayMode].
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(
  ///     enable: true,
  ///     tooltipDisplayMode: TrackballDisplayMode.groupAllPoints
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  /// ```
  final TrackballDisplayMode tooltipDisplayMode;

  /// Shows or hides the trackball.
  ///
  /// By default, the trackball will be hidden on touch. To avoid this,
  /// set this property to true.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(
  ///     enable: true,
  ///     shouldAlwaysShow: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  /// ```
  final bool shouldAlwaysShow;

  /// Customizes the trackball tooltip.
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(
  ///     enable: true,
  ///     canShowMarker: false
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  /// ```
  final InteractiveTooltip tooltipSettings;

  /// Giving disappear delay for trackball.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(
  ///     enable: true,
  ///     hideDelay: 2000
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior,
  ///   );
  /// }
  /// ```
  final double hideDelay;

  /// Builder of the trackball tooltip.
  ///
  /// Add any custom widget as the trackball template.
  ///
  /// If the trackball display mode is `groupAllPoints` or `nearestPoint`
  /// it will called once and if it is
  /// `floatAllPoints`, it will be called for each point.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(
  ///     enable: true,
  ///     builder: (BuildContext context, TrackballDetails trackballDetails) {
  ///       return Container(
  ///         width: 70,
  ///         decoration:
  ///           const BoxDecoration(color: Color.fromRGBO(66, 244, 164, 1)),
  ///         child: Text('${trackballDetails.point?.cumulative}')
  ///       );
  ///     }
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  /// ```
  final ChartTrackballBuilder? builder;

  /// Hold crosshair target position.
  Offset? get position => _position;
  Offset? _position;

  late ChartTrackballInfo? tooltipInfo;

  bool _isTransposed = false;

  /// Represents the value of border radius.
  late double _borderRadius;

  /// Represents the value of background path.
  final Path _backgroundPath = Path();

  /// Specifies whether the divider is needed or not.
  bool _divider = true;

  /// Specifies whether the trackball header text is to be rendered or not.
  bool _headerText = false;

  /// Specifies the value for formatting x value.
  bool _xFormat = false;

  /// Specifies whether the labelFormat contains colon or not.
  bool _isColon = true;

  /// Specifies the text style for label.
  late TextStyle _labelStyle;

  /// Specifies the list of string values for the trackball.
  List<TrackballElement> _stringValue = <TrackballElement>[];

  List<ChartPointInfo> chartPointInfo = <ChartPointInfo>[];

  /// Specifies the list of marker shaper paths.
  final List<Path> _markerShapes = <Path>[];

  List<num> _tooltipTop = <num>[];

  /// Specifies the list of tooltip bottom values.
  List<num> _tooltipBottom = <num>[];

  final List<RenderChartAxis> xAxesInfo = <RenderChartAxis>[];

  final List<RenderChartAxis> yAxesInfo = <RenderChartAxis>[];

  bool _isGroupMode = false;

  late List<ClosestPoints> visiblePoints;

  TooltipPositions? tooltipPosition;

  num _padding = 5;

  late num _tooltipPadding;

  late SfChartThemeData? _chartTheme;

  /// Represents the value of pointer length.
  late double _pointerLength;

  /// Represents the value of pointer width.
  late double _pointerWidth;

  /// Specifies the value of nose point y value.
  double _nosePointY = 0;

  /// Specifies the value of nose point x value.
  double _nosePointX = 0;

  /// Specifies the value of total width.
  double _totalWidth = 0;

  /// Represents the value of x value.
  late double? _x;

  /// Represents the value of y value.
  late double? _y;

  /// Represents the value of x position.
  late double? _xPos;

  /// Represents the value of y position.
  late double? _yPos;

  /// Represents the value of isTop.
  bool _isTop = false;

  /// Represents the value of is left.
  bool _isLeft = false;

  /// Represents the value of is right.
  bool _isRight = false;

  /// Represents the boundary rect for trackball.
  Rect boundaryRect = Rect.zero;

  /// Specifies whether the series is rect type or not.
  bool _isRectSeries = false;

  /// Represents the value of last marker result height.
  double _lastMarkerResultHeight = 0.0;

  /// Represents the rect value of label.
  late Rect _labelRect;

  late double _markerSize, _markerPadding;

  bool _isRangeSeries = false;

  /// Specifies whether it is box series
  bool _isBoxSeries = false;

  /// Specifies whether the trackball has template
  final bool _isTrackballTemplate = false;

  /// Represents the value for canResetPath for trackball.
  bool _canResetPath = true;

  List<num> _visibleLocation = <num>[];

  bool _isRtl = false;

  dart_ui.Image? _image;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is TrackballBehavior &&
        other.activationMode == activationMode &&
        other.lineType == lineType &&
        other.tooltipDisplayMode == tooltipDisplayMode &&
        other.tooltipAlignment == tooltipAlignment &&
        other.tooltipSettings == tooltipSettings &&
        other.lineDashArray == lineDashArray &&
        other.markerSettings == markerSettings &&
        other.enable == enable &&
        other.lineColor == lineColor &&
        other.lineWidth == lineWidth &&
        other.shouldAlwaysShow == shouldAlwaysShow &&
        other.builder == builder &&
        other.hideDelay == hideDelay;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      activationMode,
      lineType,
      tooltipDisplayMode,
      tooltipAlignment,
      tooltipSettings,
      markerSettings,
      lineDashArray,
      enable,
      lineColor,
      lineWidth,
      shouldAlwaysShow,
      builder,
      hideDelay
    ];
    return Object.hashAll(values);
  }

  /// Options to customize the markers that are displayed when trackball is
  /// enabled.
  ///
  /// Trackball markers are used to provide information about the exact point
  /// location, when the trackball is visible. You can add a shape to adorn each
  /// data point. Trackball markers can be enabled by using the
  /// `markerVisibility` property in [TrackballMarkerSettings].
  ///
  /// Provides the options like color, border width, border color and shape of
  /// the marker to customize the appearance.
  final TrackballMarkerSettings? markerSettings;

  /// Displays the trackball at the specified x and y-positions.
  ///
  /// *x and y - x & y pixels/values at which the trackball needs to be shown.
  ///
  /// coordinateUnit - specify the type of x and y values given.
  ///
  /// `pixel` or `point` for logical pixel and chart data point respectively.
  ///
  /// Defaults to `point`.
  void show(dynamic x, double y, [String coordinateUnit = 'point']) {
    assert(x != null);
    assert(!y.isNaN);
    if (coordinateUnit == 'point') {
      final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
      if (parent != null) {
        _position = rawValueToPixelPoint(
            x, y, parent.xAxis, parent.yAxis, parent.isTransposed);
      }
    } else if (coordinateUnit == 'pixel') {
      _position = Offset(x, y);
    }
    if (builder == null) {
      _generateAllPoints(position!);
      (parentBox as RenderBehaviorArea?)?.invalidate();
    } else {
      final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
      if (parent == null) {
        return;
      }
      if (_position == null) {
        return;
      }
      _generateAllPoints(_position!);
      List<CartesianChartPoint> points = <CartesianChartPoint>[];
      List<int> currentPointIndices = <int>[];
      List<int> visibleSeriesIndices = <int>[];
      List<dynamic> visibleSeriesList = <dynamic>[];
      TrackballGroupingModeInfo groupingModeInfo;

      for (int index = 0; index < chartPointInfo.length; index++) {
        final CartesianChartPoint dataPoint =
            chartPointInfo[index].chartDataPoint!;
        if (tooltipDisplayMode == TrackballDisplayMode.groupAllPoints) {
          points.add(dataPoint);
          currentPointIndices.add(chartPointInfo[index].dataPointIndex!);
          visibleSeriesIndices.add(chartPointInfo[index].seriesIndex);
          visibleSeriesList.add(chartPointInfo[index].series!);
        }
      }
      groupingModeInfo = TrackballGroupingModeInfo(
          points, currentPointIndices, visibleSeriesIndices, visibleSeriesList);
      final List<TrackballDetails> details = <TrackballDetails>[];
      for (int i = 0; i < chartPointInfo.length; i++) {
        if (tooltipDisplayMode == TrackballDisplayMode.groupAllPoints) {
          details
              .add(TrackballDetails(null, null, null, null, groupingModeInfo));
          break;
        } else {
          details.add(TrackballDetails(
            chartPointInfo[i].chartDataPoint,
            chartPointInfo[i].series!,
            chartPointInfo[i].dataPointIndex,
            chartPointInfo[i].seriesIndex,
          ));
        }
      }
      parent.trackballBuilder!(details);
      points = <CartesianChartPoint>[];
      currentPointIndices = <int>[];
      visibleSeriesIndices = <int>[];
      visibleSeriesList = <CartesianSeries>[];
    }
  }

  /// Displays the trackball at the specified point index.
  ///
  /// * pointIndex - index of the point for which the trackball must be shown
  void showByIndex(int pointIndex) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    final CartesianSeriesRenderer? child =
        parent!.plotArea!.firstChild! as CartesianSeriesRenderer?;
    if (child != null) {
      final List<num> visibleIndexes = child.visibleIndexes;
      if (visibleIndexes.first <= pointIndex &&
          pointIndex <= visibleIndexes.last) {
        show(child.xRawValues[pointIndex], 0);
      }
    }
  }

  /// Hides the trackball if it is displayed.
  void hide() {
    _position = null;
    if (builder != null) {
      (parentBox as RenderBehaviorArea?)
          ?.trackballBuilder!(<TrackballDetails>[]);
      chartPointInfo.clear();
    }
    (parentBox as RenderBehaviorArea?)?.invalidate();
  }

  void _onPaint(
      PaintingContext context, Offset offset, SfChartThemeData chartThemeData) {
    if (position == null) {
      return;
    }
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;

    if (parent == null) {
      return;
    }
    _canResetPath = false;
    _isRtl = parent.textDirection == TextDirection.rtl;
    _chartTheme = chartThemeData;
    _borderRadius = tooltipSettings.borderRadius;
    _pointerLength = tooltipSettings.arrowLength;
    _pointerWidth = tooltipSettings.arrowWidth;
    _isGroupMode = tooltipDisplayMode == TrackballDisplayMode.groupAllPoints;
    _isLeft = false;
    _isRight = false;
    double height = 0, width = 0;
    _totalWidth = boundaryRect.left + boundaryRect.width;
    _labelStyle = parent.chartThemeData!.trackballTextStyle!;

    _isTransposed = chartPointInfo.isNotEmpty &&
        chartPointInfo[0].series != null &&
        chartPointInfo[0].series!.isTransposed;
    _tooltipPadding = _isTransposed ? 8 : 5;
    ChartPointInfo? trackLinePoint =
        chartPointInfo.isNotEmpty ? chartPointInfo[0] : null;
    if (!_canResetPath &&
        trackLinePoint != null &&
        lineType != TrackballLineType.none) {
      final Paint trackballLinePaint = Paint();
      trackballLinePaint.color = lineColor ?? _chartTheme!.crosshairLineColor;
      trackballLinePaint.strokeWidth = lineWidth;
      trackballLinePaint.style = PaintingStyle.stroke;
      trackballLinePaint.isAntiAlias = true;
      lineWidth == 0
          ? trackballLinePaint.color = Colors.transparent
          : trackballLinePaint.color = trackballLinePaint.color;
      _drawTrackBallLine(context.canvas, trackballLinePaint, 0);
    }
    if (builder == null) {
      for (int index = 0; index < chartPointInfo.length; index++) {
        final dynamic series = chartPointInfo[index].series;

        final ChartPointInfo next = chartPointInfo[index];
        final ChartPointInfo pres = trackLinePoint!;
        final Offset pos = position!;
        if (_isTransposed
            ? ((pos.dy - pres.yPosition!).abs() >=
                (pos.dy - next.yPosition!).abs())
            : ((pos.dx - pres.xPosition!).abs() >=
                (pos.dx - next.xPosition!).abs())) {
          trackLinePoint = chartPointInfo[index];
        }
        final bool isRectTypeSeries = series != null &&
            (series is ColumnSeriesRenderer ||
                series is CandleSeriesRenderer ||
                series is BoxAndWhiskerSeriesRenderer ||
                series is HiloSeriesRenderer ||
                series is HiloOpenCloseSeriesRenderer);
        _isRectSeries = false;
        if ((isRectTypeSeries && _isTransposed) ||
            (series is BarSeriesRenderer && !_isTransposed)) {
          _isRectSeries = true;
        }

        final Size size = _tooltipSize(height, width, index);
        height = size.height;
        width = size.width;
        if (width < 10) {
          width = 10; // minimum width for tooltip to render
          _borderRadius = _borderRadius > 5 ? 5 : _borderRadius;
        }
        _borderRadius = _borderRadius > 15 ? 15 : _borderRadius;
        // Padding added for avoid tooltip and the data point are too close and
        // extra padding based on trackball marker and width
        _padding = (markerSettings != null &&
                    markerSettings!.markerVisibility ==
                        TrackballVisibilityMode.auto
                ? (series != null && series.markerSettings.isVisible == true)
                : markerSettings != null &&
                    markerSettings!.markerVisibility ==
                        TrackballVisibilityMode.visible)
            ? (markerSettings!.width / 2) + 5
            : _padding;
        if (_x != null && _y != null && tooltipSettings.enable) {
          if (_isGroupMode &&
              ((chartPointInfo[index].header != null &&
                      chartPointInfo[index].header != '') ||
                  (chartPointInfo[index].label != null &&
                      chartPointInfo[index].label != ''))) {
            for (int markerIndex = 0;
                markerIndex < chartPointInfo.length;
                markerIndex++) {
              _renderEachMarkers(context.canvas, markerIndex);
            }
            _calculateTrackballRect(
                context, width, height, index, chartPointInfo);
          } else {
            if (!_canResetPath &&
                chartPointInfo[index].label != null &&
                chartPointInfo[index].label != '') {
              _tooltipTop.add(_isTransposed
                  ? visiblePoints[index].closestPointX -
                      _tooltipPadding -
                      (width / 2)
                  : visiblePoints[index].closestPointY -
                      _tooltipPadding -
                      height / 2);
              _tooltipBottom.add(_isTransposed
                  ? (visiblePoints[index].closestPointX +
                          _tooltipPadding +
                          (width / 2)) +
                      (tooltipSettings.canShowMarker ? 20 : 0)
                  : visiblePoints[index].closestPointY +
                      _tooltipPadding +
                      height / 2);
              if (series != null && series.xAxis != null) {
                xAxesInfo.add(series.xAxis!);
              }
              if (series != null && series.yAxis != null) {
                yAxesInfo.add(series.yAxis!);
              }
            }
          }
        }

        if (_isGroupMode) {
          break;
        }
      }

// ignore: unnecessary_null_comparison
      if (_tooltipTop != null && _tooltipTop.isNotEmpty) {
        tooltipPosition = _smartTooltipPositions(_tooltipTop, _tooltipBottom,
            xAxesInfo, yAxesInfo, chartPointInfo, _isTransposed, true);
      }

      for (int index = 0; index < chartPointInfo.length; index++) {
        if (!_isGroupMode) {
          _renderEachMarkers(context.canvas, index);
        }

        // Padding added for avoid tooltip and the data point are too close and
        // extra padding based on trackball marker and width
        _padding = (markerSettings != null &&
                    markerSettings!.markerVisibility ==
                        TrackballVisibilityMode.auto
                ? (chartPointInfo[index].series!.markerSettings.isVisible ==
                    true)
                : markerSettings != null &&
                    markerSettings!.markerVisibility ==
                        TrackballVisibilityMode.visible)
            ? (markerSettings!.width / 2) + 5
            : _padding;
        if (tooltipSettings.enable &&
            !_isGroupMode &&
            chartPointInfo[index].label != null &&
            chartPointInfo[index].label != '') {
          final Size size = _tooltipSize(height, width, index);
          height = size.height;
          width = size.width;
          if (width < 10) {
            width = 10; // minimum width for tooltip to render
            _borderRadius = _borderRadius > 5 ? 5 : _borderRadius;
          }
          _calculateTrackballRect(
              context, width, height, index, chartPointInfo, tooltipPosition);
          if (index == chartPointInfo.length - 1) {
            _tooltipTop.clear();
            _tooltipBottom.clear();
            tooltipPosition!.tooltipTop.clear();
            tooltipPosition!.tooltipBottom.clear();
            xAxesInfo.clear();
            yAxesInfo.clear();
          }
        }
      }
    }
  }

  void _generateAllPoints(Offset position) {
    chartPointInfo = <ChartPointInfo>[];
    visiblePoints = <ClosestPoints>[];
    _markerShapes.clear();
    RenderChartAxis xAxis, yAxis;
    bool invertedAxis = false;
    _tooltipTop = <num>[];
    _tooltipBottom = <num>[];
    _visibleLocation = <num>[];
    double? xPos = 0,
        yPos = 0,
        leastX = 0,
        openXPos,
        openYPos,
        closeXPos,
        closeYPos,
        highXPos,
        lowerXPos,
        lowerYPos,
        upperXPos,
        upperYPos,
        lowYPos,
        highYPos,
        minYPos,
        maxYPos,
        maxXPos;
    int seriesIndex = 0, index;
    CartesianChartPoint chartDataPoint;
    String labelValue;
    num? xValue, yValue, minimumValue, maximumValue, highValue, lowValue;
    Rect axisClipRect;
    ChartLocation highLocation, maxLocation;
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;

    if (parent == null) {
      return;
    }

    final RenderChartPlotArea? cartesianPlotArea = parent.plotArea;

    if (cartesianPlotArea == null) {
      return;
    }
    boundaryRect = parent.paintBounds;
    final Rect seriesBounds = boundaryRect;

    cartesianPlotArea.visitChildren((RenderObject child) {
      if (child is CartesianSeriesRenderer) {
        _isRangeSeries = child is RangeSeriesRendererBase ||
            (child is HiloSeriesRenderer ||
                child is HiloOpenCloseSeriesRenderer) ||
            child is CandleSeriesRenderer;
        _isBoxSeries = child is BoxAndWhiskerSeriesRenderer;
        _isRectSeries = (child is ColumnSeriesRenderer ||
                child is RangeColumnSeriesRenderer) ||
            (child is StackedSeriesRenderer) ||
            child is BarSeriesRenderer ||
            child is HistogramSeriesRenderer ||
            child is WaterfallSeriesRenderer;
        xAxis = child.xAxis!;
        yAxis = child.yAxis!;
        invertedAxis = child.isTransposed;
        if (child.controller.isVisible &&
            child.dataSource != null &&
            child.dataSource!.isNotEmpty) {
          final List<ChartSegment> nearestSegments = child.contains(position);
          for (final ChartSegment segment in nearestSegments) {
            final TrackballInfo? trackballInfo =
                segment.trackballInfo(position);
            if (trackballInfo != null) {
              final ChartTrackballInfo pointInfo =
                  trackballInfo as ChartTrackballInfo;
              index = segment.currentSegmentIndex;
              if (index >= 0) {
                chartDataPoint = pointInfo.point;
                xValue = chartDataPoint.xValue;
                if (child is! BoxAndWhiskerSeriesRenderer) {
                  yValue = chartDataPoint.y;
                }
                minimumValue = chartDataPoint.minimum;
                maximumValue = chartDataPoint.maximum;
                highValue = chartDataPoint.high;
                lowValue = chartDataPoint.low;
                axisClipRect = Rect.fromLTWH(
                    child.paintBounds.left +
                        (!_isTransposed ? xAxis.plotOffset : 0),
                    child.paintBounds.top +
                        (_isTransposed ? xAxis.plotOffset : 0),
                    child.paintBounds.width -
                        (!_isTransposed ? 2 * xAxis.plotOffset : 0),
                    child.paintBounds.height -
                        (_isTransposed ? 2 * yAxis.plotOffset : 0));

                xPos = _calculatePoint(xValue!, yValue, xAxis, yAxis,
                        invertedAxis, child, axisClipRect)
                    .x;
                if (!xPos!.isNaN) {
                  if (seriesIndex == 0 ||
                      ((leastX! - position.dx).abs() >
                          (xPos! - position.dx).abs())) {
                    leastX = xPos;
                  }
                  labelValue = _trackballLabelText(
                    pointInfo,
                    pointInfo.point,
                    child,
                  );
                  yPos = child is StackedSeriesRenderer
                      ? _calculatePoint(
                              xValue!,
                              child.topValues[pointInfo.pointIndex],
                              xAxis,
                              yAxis,
                              invertedAxis,
                              child,
                              axisClipRect)
                          .y
                      : _calculatePoint(xValue!, yValue, xAxis, yAxis,
                              invertedAxis, child, axisClipRect)
                          .y;
                  if (_isRangeSeries) {
                    lowYPos = _calculatePoint(xValue!, lowValue, xAxis, yAxis,
                            invertedAxis, child, axisClipRect)
                        .y;
                    highLocation = _calculatePoint(xValue!, highValue, xAxis,
                        yAxis, invertedAxis, child, axisClipRect);
                    highYPos = highLocation.y;
                    highXPos = highLocation.x;
                  } else if (child is BoxAndWhiskerSeriesRenderer) {
                    minYPos = _calculatePoint(xValue!, minimumValue, xAxis,
                            yAxis, invertedAxis, child, axisClipRect)
                        .y;
                    maxLocation = _calculatePoint(xValue!, maximumValue, xAxis,
                        yAxis, invertedAxis, child, axisClipRect);
                    maxXPos = maxLocation.x;
                    maxYPos = maxLocation.y;
                  }
                  final Rect rect = seriesBounds.intersect(Rect.fromLTWH(
                      xPos! - 1,
                      _isRangeSeries
                          ? highYPos! - 1
                          : _isBoxSeries
                              ? maxYPos! - 1
                              : yPos! - 1,
                      2,
                      2));
                  if (seriesBounds.contains(Offset(
                          xPos!,
                          _isRangeSeries
                              ? highYPos!
                              : _isBoxSeries
                                  ? maxYPos!
                                  : yPos!)) ||
                      seriesBounds.overlaps(rect)) {
                    visiblePoints.add(ClosestPoints(
                        closestPointX: !_isRangeSeries
                            ? xPos!
                            : _isBoxSeries
                                ? maxXPos!
                                : highXPos!,
                        closestPointY: _isRangeSeries
                            ? highYPos!
                            : _isBoxSeries
                                ? maxYPos!
                                : yPos!));
                    _addChartPointInfo(
                        child,
                        xPos!,
                        yPos!,
                        index,
                        labelValue,
                        seriesIndex,
                        lowYPos,
                        highXPos,
                        highYPos,
                        openXPos,
                        openYPos,
                        closeXPos,
                        closeYPos,
                        minYPos,
                        maxXPos,
                        maxYPos,
                        lowerXPos,
                        lowerYPos,
                        upperXPos,
                        upperYPos,
                        chartDataPoint);
                    if (tooltipDisplayMode ==
                            TrackballDisplayMode.groupAllPoints &&
                        leastX! >= seriesBounds.left) {
                      invertedAxis ? yPos = leastX : xPos = leastX;
                    }
                  }
                }
              }
            }
          }
          seriesIndex++;
        }
        _validateNearestXValue(leastX!, child, position.dx, position.dy);
        _validatePointsWithSeries(leastX!);
      }
    });

    if (parent.indicatorArea != null) {
      parent.indicatorArea!.visitChildren((RenderObject child) {
        if (child is IndicatorRenderer && child.effectiveIsVisible) {
          final List<TrackballInfo>? trackballInfo =
              child.trackballInfo(position);
          if (trackballInfo != null && trackballInfo.isNotEmpty) {
            for (final TrackballInfo? info in trackballInfo) {
              visiblePoints.add(ClosestPoints(
                  closestPointX: info!.position!.dx,
                  closestPointY: info.position!.dy));
              double? indicatorXPos = _calculatePoint(
                      (info as ChartTrackballInfo<dynamic, dynamic>)
                          .point
                          .xValue!,
                      info.point.y,
                      child.xAxis!,
                      child.yAxis!,
                      invertedAxis,
                      child,
                      child.paintBounds)
                  .x;
              if ((leastX! - position.dx).abs() >
                  (indicatorXPos - position.dx).abs()) {
                leastX = indicatorXPos;
              }

              double indicatorYPos = _calculatePoint(
                      info.point.xValue!,
                      info.point.y,
                      child.xAxis!,
                      child.yAxis!,
                      invertedAxis,
                      child,
                      child.paintBounds)
                  .y;

              if (invertedAxis &&
                  (leastX! - position.dx).abs() >
                      (indicatorYPos - position.dx).abs()) {
                leastX = indicatorYPos;
              }

              final String labelValue = _trackballLabelText(
                info,
                info.point,
                child,
              );
              if (info.pointIndex > -1) {
                _addChartPointInfo(
                  child,
                  indicatorXPos,
                  indicatorYPos,
                  info.pointIndex,
                  labelValue,
                  seriesIndex,
                  lowYPos,
                  highXPos,
                  highYPos,
                  openXPos,
                  openYPos,
                  closeXPos,
                  closeYPos,
                  minYPos,
                  maxXPos,
                  maxYPos,
                  lowerXPos,
                  lowerYPos,
                  upperXPos,
                  upperYPos,
                  info.point,
                  info.name,
                  info.color,
                );
                if (tooltipDisplayMode == TrackballDisplayMode.groupAllPoints &&
                    leastX! >= seriesBounds.left &&
                    leastX != null) {
                  invertedAxis
                      ? indicatorYPos = leastX!
                      : indicatorXPos = leastX;
                }
              }
            }
          }
        }
        _validateNearestXValue(leastX!, child, position.dx, position.dy);
        _validatePointsWithSeries(leastX!);
      });
    }

    if (visiblePoints.isNotEmpty) {
      invertedAxis
          ? visiblePoints.sort((ClosestPoints a, ClosestPoints b) =>
              a.closestPointX.compareTo(b.closestPointX))
          : visiblePoints.sort((ClosestPoints a, ClosestPoints b) =>
              a.closestPointY.compareTo(b.closestPointY));
    }
    if (chartPointInfo.isNotEmpty) {
      if (tooltipDisplayMode != TrackballDisplayMode.groupAllPoints) {
        invertedAxis
            ? chartPointInfo.sort((ChartPointInfo a, ChartPointInfo b) =>
                a.xPosition!.compareTo(b.xPosition!))
            : tooltipDisplayMode == TrackballDisplayMode.floatAllPoints
                ? chartPointInfo.sort((ChartPointInfo a, ChartPointInfo b) =>
                    a.yPosition!.compareTo(b.yPosition!))
                : chartPointInfo.sort((ChartPointInfo a, ChartPointInfo b) =>
                    b.yPosition!.compareTo(a.yPosition!));
      }
      if (tooltipDisplayMode == TrackballDisplayMode.nearestPoint ||
          (_isRectSeries == true &&
              tooltipDisplayMode != TrackballDisplayMode.groupAllPoints)) {
        _validateNearestPointForAllSeries(
            leastX!, chartPointInfo, position.dx, position.dy);
      }
    }
    _triggerTrackballRenderCallback();
  }

  /// Event for trackball render
  void _triggerTrackballRenderCallback() {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }
    if (parent.onTrackballPositionChanging != null) {
      int index;
      for (index = chartPointInfo.length - 1; index >= 0; index--) {
        TrackballArgs chartPoint;
        chartPoint = TrackballArgs();
        chartPoint.chartPointInfo = chartPointInfo[index];
        parent.onTrackballPositionChanging!(chartPoint);
        chartPointInfo[index].label = chartPoint.chartPointInfo.label;
        chartPointInfo[index].header = chartPoint.chartPointInfo.header;
        if (!_isTrackballTemplate && chartPointInfo[index].label == null ||
            chartPointInfo[index].label == '') {
          chartPointInfo.removeAt(index);
          visiblePoints.removeAt(index);
        }
      }
    }
  }

  /// To validate the nearest point in all series for trackball
  void _validateNearestPointForAllSeries(double leastX,
      List<ChartPointInfo> trackballInfo, double touchXPos, double touchYPos) {
    double xPos = 0, yPos;
    final List<ChartPointInfo> tempTrackballInfo =
        List<ChartPointInfo>.from(trackballInfo);
    ChartPointInfo pointInfo;
    num? yValue;
    num xValue;
    Rect axisClipRect;
    RenderChartAxis xAxisDetails, yAxisDetails;
    int i;
    // late List<CartesianChartPoint> data;
    for (i = 0; i < tempTrackballInfo.length; i++) {
      pointInfo = tempTrackballInfo[i];
      xAxisDetails = pointInfo.series!.xAxis!;
      yAxisDetails = pointInfo.series!.yAxis!;
      xValue = pointInfo.series!.xValues[pointInfo.dataPointIndex!];
      if (pointInfo.series is! BoxAndWhiskerSeriesRenderer) {
        yValue = pointInfo.chartDataPoint!.y;
      }
      axisClipRect = pointInfo.series!.paintBounds;
      final ChartLocation chartPointOffset = _calculatePoint(
          xValue,
          yValue,
          xAxisDetails,
          yAxisDetails,
          pointInfo.series!.isTransposed,
          pointInfo.series,
          axisClipRect);

      xPos = chartPointOffset.x;
      yPos = chartPointOffset.y;
      if (tooltipDisplayMode != TrackballDisplayMode.floatAllPoints) {
        final bool isTransposed = pointInfo.series!.isTransposed;
        if (leastX != xPos && !isTransposed) {
          trackballInfo.remove(pointInfo);
        }
        yPos = touchYPos;
        xPos = touchXPos;
        if (tooltipDisplayMode != TrackballDisplayMode.floatAllPoints) {
          ChartPointInfo point = trackballInfo[0];
          for (i = 1; i < trackballInfo.length; i++) {
            final bool isXYPositioned = !isTransposed
                ? (((point.yPosition! - yPos).abs() >
                        (trackballInfo[i].yPosition! - yPos).abs()) &&
                    point.xPosition == trackballInfo[i].xPosition)
                : (((point.xPosition! - xPos).abs() >
                        (trackballInfo[i].xPosition! - xPos).abs()) &&
                    point.yPosition == trackballInfo[i].yPosition);
            if (isXYPositioned) {
              point = trackballInfo[i];
            }
          }
          trackballInfo
            ..clear()
            ..add(point);
        }
      }
    }
  }

  /// To find the nearest x value to render a trackball
  void _validateNearestXValue(
      double leastX, dynamic series, double touchXPos, double touchYPos) {
    final List<ChartPointInfo> leastPointInfo = <ChartPointInfo>[];
    final bool invertedAxis = series.isTransposed;
    double nearPointX =
        invertedAxis ? series.paintBounds.top : series.paintBounds.left;
    final double touchXValue = invertedAxis ? touchYPos : touchXPos;
    double delta = 0, curX;
    num xValue;
    num? yValue;
    CartesianChartPoint dataPoint;
    RenderChartAxis xAxisDetails, yAxisDetails;
    ChartLocation curXLocation;
    for (final ChartPointInfo pointInfo in chartPointInfo) {
      if (pointInfo.dataPointIndex! < series.dataCount) {
        dataPoint = pointInfo.chartDataPoint!;
        xAxisDetails = pointInfo.series!.xAxis!;
        yAxisDetails = pointInfo.series!.yAxis!;
        xValue = dataPoint.xValue!;
        if (series is BoxAndWhiskerSeriesRenderer) {
          yValue = dataPoint.y;
        }
        series = pointInfo.series;
        curXLocation = _calculatePoint(xValue, yValue, xAxisDetails,
            yAxisDetails, invertedAxis, series, series.paintBounds);
        curX = invertedAxis ? curXLocation.y : curXLocation.x;

        if (delta == touchXValue - curX) {
          leastPointInfo.add(pointInfo);
        } else if ((touchXValue - curX).abs() <=
            (touchXValue - nearPointX).abs()) {
          nearPointX = curX;
          delta = touchXValue - curX;
          leastPointInfo.clear();
          leastPointInfo.add(pointInfo);
        }
      }
      if (chartPointInfo.isNotEmpty && series is CartesianSeriesRenderer) {
        if (chartPointInfo[0].dataPointIndex! < series.dataCount) {
          leastX = _findLeastX(chartPointInfo[0], series);
        }
      }

      if (pointInfo.series! is BarSeriesRenderer
          ? invertedAxis
          : invertedAxis) {
        _yPos = leastX;
      } else {
        _xPos = leastX;
      }
    }
  }

  void _validatePointsWithSeries(double leastX) {
    final List<num> xValueList = <num>[];
    for (final ChartPointInfo pointInfo in chartPointInfo) {
      xValueList.add(pointInfo.chartDataPoint!.xValue!);
    }
    dynamic series;
    bool isRangeTypeSeries;
    if (xValueList.isNotEmpty) {
      for (int count = 0; count < xValueList.length; count++) {
        if (xValueList[0] != xValueList[count]) {
          final List<ChartPointInfo> leastPointInfo = <ChartPointInfo>[];
          for (final ChartPointInfo pointInfo in chartPointInfo) {
            if (pointInfo.xPosition == leastX) {
              leastPointInfo.add(pointInfo);
              if (!(tooltipDisplayMode == TrackballDisplayMode.floatAllPoints &&
                  leastPointInfo.length > 1 &&
                  (pointInfo.series is IndicatorRenderer ||
                      pointInfo.seriesIndex !=
                          leastPointInfo[leastPointInfo.length - 2]
                              .seriesIndex))) {
                visiblePoints.clear();
              }
              series = pointInfo.series;
              isRangeTypeSeries = series is RangeSeriesRendererBase ||
                  series is HiloOpenCloseSeriesRenderer ||
                  series is HiloSeriesRenderer ||
                  series is CandleSeriesRenderer;
              visiblePoints.add(ClosestPoints(
                  closestPointX: isRangeTypeSeries
                      ? pointInfo.highXPosition!
                      : series is BoxAndWhiskerSeriesRenderer
                          ? pointInfo.maxXPosition!
                          : pointInfo.xPosition!,
                  closestPointY: isRangeTypeSeries
                      ? pointInfo.highYPosition!
                      : series is BoxAndWhiskerSeriesRenderer
                          ? pointInfo.maxYPosition!
                          : pointInfo.yPosition!));
            }
          }
          chartPointInfo.clear();
          chartPointInfo = leastPointInfo;
        }
      }
    }
  }

  /// To get the lowest x value to render trackball
  double _findLeastX(ChartPointInfo pointInfo, dynamic series) {
    return _calculatePoint(pointInfo.chartDataPoint!.xValue!, 0, series.xAxis!,
            series.yAxis!, series.isTransposed, series, series.paintBounds)
        .x;
  }

  /// Get the location of point.
  ChartLocation _calculatePoint(num x, num? y, RenderChartAxis xAxis,
      RenderChartAxis yAxis, bool isInverted, dynamic series, Rect rect) {
    x = xAxis is RenderLogarithmicAxis
        ? _calculateLogBaseValue(x > 0 ? x : 0, xAxis.logBase)
        : x;
    y = yAxis is RenderLogarithmicAxis
        ? y != null
            ? _calculateLogBaseValue(y > 0 ? y : 0, yAxis.logBase)
            : 0
        : y;
    x = _valueToCoefficient(x.isInfinite ? 0 : x, xAxis);
    y = _valueToCoefficient(
        y != null
            ? y.isInfinite
                ? 0
                : y
            : y,
        yAxis);
    final num xLength = isInverted ? rect.height : rect.width;
    final num yLength = isInverted ? rect.width : rect.height;
    final double locationX =
        rect.left + (isInverted ? (y * yLength) : (x * xLength));
    final double locationY =
        rect.top + (isInverted ? (1 - x) * xLength : (1 - y) * yLength);
    return ChartLocation(locationX, locationY);
  }

  /// Find the position of point.
  num _valueToCoefficient(num? value, RenderChartAxis axisRendererDetails) {
    num result = 0;
    if (axisRendererDetails.visibleRange != null && value != null) {
      final DoubleRange range = axisRendererDetails.visibleRange!;
      // ignore: unnecessary_null_comparison
      if (range != null) {
        result = (value - range.minimum) / (range.delta);
        result = axisRendererDetails.isInversed ? (1 - result) : result;
      }
    }
    return result;
  }

  /// To get and return label text of the trackball
  String _trackballLabelText(
      ChartTrackballInfo info, ChartPoint dataPoint, dynamic series) {
    String labelValue;
    final int digits = tooltipSettings.decimalPlaces;
    final dynamic currentSeries = series;
    final RenderChartAxis? yAxis = currentSeries.yAxis;
    if (tooltipSettings.format != null) {
      dynamic x;
      final RenderChartAxis? xAxis = currentSeries.xAxis;
      if (currentSeries.xAxis is RenderDateTimeAxis && xAxis != null) {
        final num interval = xAxis.visibleRange!.minimum.ceil();
        final num prevInterval = (xAxis.visibleLabels.isNotEmpty)
            ? xAxis.visibleLabels[xAxis.visibleLabels.length - 1].value
            : interval;
        final DateFormat dateFormat = (xAxis as RenderDateTimeAxis)
                .dateFormat ??
            _dateTimeLabelFormat(xAxis, interval.toInt(), prevInterval.toInt());
        x = dateFormat.format(info.point.x as DateTime);
      } else if (xAxis is RenderCategoryAxis) {
        x = dataPoint.x;
      } else if (xAxis is RenderDateTimeCategoryAxis) {
        final num interval = xAxis.visibleRange!.minimum.ceil();
        final num prevInterval = (xAxis.visibleLabels.isNotEmpty)
            ? xAxis.visibleLabels[xAxis.visibleLabels.length - 1].value
            : interval;
        final DateFormat dateFormat = (xAxis as DateTimeCategoryAxis)
                .dateFormat ??
            _dateTimeLabelFormat(xAxis, interval.toInt(), prevInterval.toInt());
        x = dateFormat.format(DateTime.fromMillisecondsSinceEpoch(
            dataPoint.x.millisecondsSinceEpoch));
      }
      // ignore: lines_longer_than_80_chars
      labelValue = (currentSeries is HiloOpenCloseSeriesRenderer || currentSeries is HiloSeriesRenderer) ||
              (currentSeries is RangeSeriesRendererBase) ||
              currentSeries is CandleSeriesRenderer ||
              currentSeries is BoxAndWhiskerSeriesRenderer
          ? currentSeries is BoxAndWhiskerSeriesRenderer
              ? (tooltipSettings.format!
                  .replaceAll('point.x', (x ?? info.point.x).toString())
                  .replaceAll('point.minimum', info.point.minimum.toString())
                  .replaceAll('point.maximum', info.point.maximum.toString())
                  .replaceAll('point.lowerQuartile',
                      info.point.lowerQuartile.toString())
                  .replaceAll('point.upperQuartile',
                      info.point.upperQuartile.toString())
                  .replaceAll('{', '')
                  .replaceAll('}', '')
                  .replaceAll('series.name', currentSeries.name))
              : currentSeries is HiloSeriesRenderer ||
                      series is RangeSeriesRendererBase
                  ? (tooltipSettings.format!
                      .replaceAll('point.x', (x ?? info.point.x).toString())
                      .replaceAll('point.high', info.point.high.toString())
                      .replaceAll('point.low', info.point.low.toString())
                      .replaceAll('{', '')
                      .replaceAll('}', '')
                      .replaceAll('series.name', currentSeries.name))
                  : (tooltipSettings.format!
                      .replaceAll('point.x', (x ?? info.point.x).toString())
                      .replaceAll('point.high', info.point.high.toString())
                      .replaceAll('point.low', info.point.low.toString())
                      .replaceAll('point.open', info.point.open.toString())
                      .replaceAll('point.close', info.point.close.toString())
                      .replaceAll('{', '')
                      .replaceAll('}', '')
                      .replaceAll('series.name', currentSeries.name))
          : currentSeries is BubbleSeriesRenderer
              ? (tooltipSettings.format!
                  .replaceAll('point.x', (x ?? info.point.x).toString())
                  .replaceAll('point.y',
                      _labelValue(info.point.y!, currentSeries.yAxis, digits))
                  .replaceAll('{', '')
                  .replaceAll('}', '')
                  .replaceAll('series.name', currentSeries.name)
                  .replaceAll('point.size', info.point.bubbleSize.toString()))
              : series is StackedSeriesRenderer
                  ? (tooltipSettings.format!
                      .replaceAll('point.x', (x ?? info.point.x).toString())
                      .replaceAll('point.y', _labelValue(info.point.y!, currentSeries.yAxis, digits))
                      .replaceAll('{', '')
                      .replaceAll('}', '')
                      .replaceAll('series.name', currentSeries.name)
                      .replaceAll('point.cumulativeValue', info.point.cumulative.toString()))
                  : (tooltipSettings.format!.replaceAll('point.x', (x ?? info.point.x).toString()).replaceAll('point.y', _labelValue(info.point.y!, yAxis, digits)).replaceAll('{', '').replaceAll('}', '').replaceAll('series.name', currentSeries.name));
    } else {
      labelValue = (series is! RangeSeriesRendererBase) &&
              series is! CandleSeriesRenderer &&
              (series is! HiloOpenCloseSeriesRenderer &&
                  series is! HiloSeriesRenderer) &&
              series is! BoxAndWhiskerSeriesRenderer
          ? _labelValue(info.point.y!, yAxis, digits)
          : series is HiloOpenCloseSeriesRenderer ||
                  series is CandleSeriesRenderer ||
                  series is BoxAndWhiskerSeriesRenderer
              ? series is BoxAndWhiskerSeriesRenderer
                  // ignore: lines_longer_than_80_chars
                  ? 'Maximum : ${_labelValue(info.point.maximum!, yAxis)}\n'
                      'Minimum : ${_labelValue(info.point.minimum!, yAxis)}\n'
                      'LowerQuartile :'
                      ' ${_labelValue(info.point.lowerQuartile!, yAxis)}\n'
                      'UpperQuartile :'
                      ' ${_labelValue(info.point.upperQuartile!, yAxis)}'
                  : 'High : ${_labelValue(info.point.high!, yAxis)}\n'
                      'Low : ${_labelValue(info.point.low!, yAxis)}\n'
                      'Open : ${_labelValue(info.point.open!, yAxis)}\n'
                      'Close : ${_labelValue(info.point.close!, yAxis)}'
              : 'High : ${_labelValue(info.point.high!, yAxis)}\n'
                  'Low : ${_labelValue(info.point.low!, yAxis)}';
    }
    return labelValue;
  }

  /// To add chart point info
  void _addChartPointInfo(
    dynamic series,
    double xPos,
    double yPos,
    int dataPointIndex,
    String? label,
    int seriesIndex, [
    double? lowYPos,
    double? highXPos,
    double? highYPos,
    double? openXPos,
    double? openYPos,
    double? closeXPos,
    double? closeYPos,
    double? minYPos,
    double? maxXPos,
    double? maxYPos,
    double? lowerXPos,
    double? lowerYPos,
    double? upperXPos,
    double? upperYPos,
    CartesianChartPoint<dynamic>? point,
    String? name,
    Color? color,
  ]) {
    final ChartPointInfo pointInfo = ChartPointInfo();

    pointInfo.seriesName = name;
    pointInfo.series = series;
    pointInfo.markerXPos = xPos;
    pointInfo.markerYPos = yPos;
    pointInfo.xPosition = xPos;
    pointInfo.yPosition = yPos;
    pointInfo.seriesIndex = seriesIndex;

    if ((series is HiloOpenCloseSeriesRenderer ||
            series is HiloSeriesRenderer) ||
        (series is RangeSeriesRendererBase) ||
        series is SplineRangeAreaSeriesRenderer ||
        series is CandleSeriesRenderer) {
      pointInfo.lowYPosition = lowYPos;
      pointInfo.highXPosition = highXPos;
      pointInfo.highYPosition = highYPos;
      if (series is HiloOpenCloseSeriesRenderer ||
          series is CandleSeriesRenderer) {
        pointInfo.openXPosition = openXPos;
        pointInfo.openYPosition = openYPos;
        pointInfo.closeXPosition = closeXPos;
        pointInfo.closeYPosition = closeYPos;
      }
    } else if (series is BoxAndWhiskerSeriesRenderer) {
      pointInfo.minYPosition = minYPos;
      pointInfo.maxYPosition = maxYPos;
      pointInfo.maxXPosition = maxXPos;
      pointInfo.lowerXPosition = lowerXPos;
      pointInfo.lowerYPosition = lowerYPos;
      pointInfo.upperXPosition = upperXPos;
      pointInfo.upperYPosition = upperYPos;
    }

    if (series.dataSource != null &&
        series.dataSource!.length > dataPointIndex) {
      pointInfo.color = series is! CartesianSeriesRenderer
          ? color
          : series.color ?? series.segments[dataPointIndex].fillPaint.color;
    } else if (series.dataSource != null && series.dataSource!.length > 1) {
      pointInfo.color = series is! CartesianSeriesRenderer
          ? color
          : series.color ?? series.segments[dataPointIndex].fillPaint.color;
    } else if (color != null) {
      pointInfo.color = color;
    }
    pointInfo.chartDataPoint = point;
    pointInfo.dataPointIndex = dataPointIndex;
    if (!_isTrackballTemplate) {
      pointInfo.label = label;
      pointInfo.header = _findHeaderText(point!, series.xAxis!);
    }
    chartPointInfo.add(pointInfo);
  }

  void _renderEachMarkers(Canvas canvas, int markerIndex) {
    _trackballMarker(markerIndex);
    if (_markerShapes.isNotEmpty && _markerShapes.length > markerIndex) {
      _renderTrackballMarker(canvas, markerIndex);
    }
  }

  /// To render the trackball marker for both tooltip and template
  void _trackballMarker(int index) {
    if (markerSettings != null &&
        (markerSettings!.markerVisibility == TrackballVisibilityMode.auto
            ? (chartPointInfo[index].series != null &&
                chartPointInfo[index].series!.markerSettings.isVisible == true)
            : markerSettings!.markerVisibility ==
                TrackballVisibilityMode.visible)) {
      final DataMarkerType markerType = markerSettings!.shape;
      final Size size = Size(markerSettings!.width, markerSettings!.height);
      final dynamic series = chartPointInfo[index].series;
      _markerShapes.add(_markerShapesPath(
          markerType,
          Offset(
              chartPointInfo[index].xPosition!,
              (series != null && (series is RangeSeriesRendererBase) ||
                      (series is HiloOpenCloseSeriesRenderer ||
                          series is HiloSeriesRenderer) ||
                      series is CandleSeriesRenderer)
                  ? chartPointInfo[index].highYPosition!
                  : series is BoxAndWhiskerSeriesRenderer
                      ? chartPointInfo[index].maxYPosition!
                      : chartPointInfo[index].yPosition!),
          size,
          chartPointInfo[index].series));
    }
  }

  /// To render the trackball marker
  void _renderTrackballMarker(Canvas canvas, int index) {
    final Paint strokePaint = Paint()
      ..color = markerSettings!.borderWidth == 0
          ? Colors.transparent
          : markerSettings!.borderColor ?? chartPointInfo[index].color!
      ..strokeWidth = markerSettings!.borderWidth
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    final Paint fillPaint = Paint()
      ..color = markerSettings!.color ??
          (_chartTheme!.brightness == Brightness.light
              ? Colors.white
              : Colors.black)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    if (index < _markerShapes.length) {
      canvas.drawPath(_markerShapes[index], strokePaint);
      canvas.drawPath(_markerShapes[index], fillPaint);
    }
  }

  /// Method to place the collided tooltips properly
  TooltipPositions _smartTooltipPositions(
      List<num> tooltipTop,
      List<num> tooltipBottom,
      List<RenderChartAxis> xAxesInfo,
      List<RenderChartAxis> yAxesInfo,
      List<ChartPointInfo> chartPointInfo,
      bool requireInvertedAxis,
      [bool? isPainterTooltip]) {
    _tooltipPadding = _isTransposed ? 8 : 5;
    num tooltipWidth = 0;
    TooltipPositions tooltipPosition;
    for (int i = 0; i < chartPointInfo.length; i++) {
      final dynamic series = chartPointInfo[i].series;
      requireInvertedAxis
          ? _visibleLocation.add(chartPointInfo[i].xPosition!)
          : _visibleLocation.add(((series is RangeSeriesRendererBase) ||
                  (series is HiloOpenCloseSeriesRenderer ||
                      series is HiloSeriesRenderer) ||
                  series is CandleSeriesRenderer)
              ? chartPointInfo[i].highYPosition!
              : series is BoxAndWhiskerSeriesRenderer
                  ? chartPointInfo[i].maxYPosition!
                  : chartPointInfo[i].yPosition!);

      tooltipWidth += tooltipBottom[i] - tooltipTop[i] + _tooltipPadding;
    }
    tooltipPosition = _continuousOverlappingPoints(
        tooltipTop, tooltipBottom, _visibleLocation);

    if (!requireInvertedAxis
        ? tooltipWidth < (boundaryRect.bottom - boundaryRect.top)
        : tooltipWidth < (boundaryRect.right - boundaryRect.left)) {
      tooltipPosition =
          _verticalArrangements(tooltipPosition, xAxesInfo, yAxesInfo);
    }
    return tooltipPosition;
  }

  TooltipPositions _verticalArrangements(TooltipPositions tooltipPosition,
      List<RenderChartAxis> xAxesInfo, List<RenderChartAxis> yAxesInfo) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return tooltipPosition;
    }
    num? startPos, chartHeight;
    num secWidth, width;
    final int length = tooltipPosition.tooltipTop.length;
    RenderChartAxis yAxis;
    for (int i = length - 1; i >= 0; i--) {
      yAxis = yAxesInfo[i];
      RenderChartAxis? child = parent.cartesianAxes!.firstChild;
      while (child != null) {
        if (yAxis == child) {
          if (_isTransposed) {
            chartHeight = boundaryRect.right;
            startPos = boundaryRect.left;
          } else {
            chartHeight = boundaryRect.bottom - boundaryRect.top;
            startPos = boundaryRect.top;
          }
        }

        final CartesianAxesParentData childParentData =
            child.parentData! as CartesianAxesParentData;
        child = childParentData.nextSibling;
      }
      width = tooltipPosition.tooltipBottom[i] - tooltipPosition.tooltipTop[i];
      if (chartHeight != null &&
          chartHeight < tooltipPosition.tooltipBottom[i]) {
        tooltipPosition.tooltipBottom[i] = chartHeight - 2;
        tooltipPosition.tooltipTop[i] =
            tooltipPosition.tooltipBottom[i] - width;
        for (int j = i - 1; j >= 0; j--) {
          secWidth =
              tooltipPosition.tooltipBottom[j] - tooltipPosition.tooltipTop[j];
          if (tooltipPosition.tooltipBottom[j] >
                  tooltipPosition.tooltipTop[j + 1] &&
              (tooltipPosition.tooltipTop[j + 1] > startPos! &&
                  tooltipPosition.tooltipBottom[j + 1] < chartHeight)) {
            tooltipPosition.tooltipBottom[j] =
                tooltipPosition.tooltipTop[j + 1] - _tooltipPadding;
            tooltipPosition.tooltipTop[j] =
                tooltipPosition.tooltipBottom[j] - secWidth;
          }
        }
      }
    }
    for (int i = 0; i < length; i++) {
      yAxis = yAxesInfo[i];

      RenderChartAxis? child = parent.cartesianAxes!.firstChild;
      while (child != null) {
        if (yAxis == child) {
          if (_isTransposed) {
            chartHeight = boundaryRect.right;
            startPos = boundaryRect.left;
          } else {
            chartHeight = boundaryRect.bottom - boundaryRect.top;
            startPos = boundaryRect.top;
          }
        }

        final CartesianAxesParentData childParentData =
            child.parentData! as CartesianAxesParentData;
        child = childParentData.nextSibling;
      }
      width = tooltipPosition.tooltipBottom[i] - tooltipPosition.tooltipTop[i];
      if (startPos != null && tooltipPosition.tooltipTop[i] < startPos) {
        tooltipPosition.tooltipTop[i] = startPos + 1;
        tooltipPosition.tooltipBottom[i] =
            tooltipPosition.tooltipTop[i] + width;
        for (int j = i + 1; j <= (length - 1); j++) {
          secWidth =
              tooltipPosition.tooltipBottom[j] - tooltipPosition.tooltipTop[j];
          if (tooltipPosition.tooltipTop[j] <
                  tooltipPosition.tooltipBottom[j - 1] &&
              (tooltipPosition.tooltipTop[j - 1] > startPos &&
                  tooltipPosition.tooltipBottom[j - 1] < chartHeight!)) {
            tooltipPosition.tooltipTop[j] =
                tooltipPosition.tooltipBottom[j - 1] + _tooltipPadding;
            tooltipPosition.tooltipBottom[j] =
                tooltipPosition.tooltipTop[j] + secWidth;
          }
        }
      }
    }
    return tooltipPosition;
  }

  // Method to identify the colliding trackball tooltips and return the new tooltip positions
  TooltipPositions _continuousOverlappingPoints(List<num> tooltipTop,
      List<num> tooltipBottom, List<num> visibleLocation) {
    num temp,
        count = 0,
        start = 0,
        halfHeight,
        midPos,
        tempTooltipHeight,
        temp1TooltipHeight;
    int startPoint = 0, i, j, k;
    final num endPoint = tooltipBottom.length - 1;
    num tooltipHeight = (tooltipBottom[0] - tooltipTop[0]) + _tooltipPadding;
    temp = tooltipTop[0] + tooltipHeight;
    start = tooltipTop[0];
    for (i = 0; i < endPoint; i++) {
      // To identify that tooltip collides or not
      if (temp >= tooltipTop[i + 1]) {
        tooltipHeight =
            tooltipBottom[i + 1] - tooltipTop[i + 1] + _tooltipPadding;
        temp += tooltipHeight;
        count++;
        // This condition executes when the tooltip count is half of the total number of tooltips
        if (count - 1 == endPoint - 1 || i == endPoint - 1) {
          halfHeight = (temp - start) / 2;
          midPos = (visibleLocation[startPoint] + visibleLocation[i + 1]) / 2;
          tempTooltipHeight =
              tooltipBottom[startPoint] - tooltipTop[startPoint];
          tooltipTop[startPoint] = midPos - halfHeight;
          tooltipBottom[startPoint] =
              tooltipTop[startPoint] + tempTooltipHeight;
          for (k = startPoint; k > 0; k--) {
            if (tooltipTop[k] <= tooltipBottom[k - 1] + _tooltipPadding) {
              temp1TooltipHeight = tooltipBottom[k - 1] - tooltipTop[k - 1];
              tooltipTop[k - 1] =
                  tooltipTop[k] - temp1TooltipHeight - _tooltipPadding;
              tooltipBottom[k - 1] = tooltipTop[k - 1] + temp1TooltipHeight;
            } else {
              break;
            }
          }
          // To set tool tip positions based on the half height and other tooltip height
          for (j = startPoint + 1; j <= startPoint + count; j++) {
            tempTooltipHeight = tooltipBottom[j] - tooltipTop[j];
            tooltipTop[j] = tooltipBottom[j - 1] + _tooltipPadding;
            tooltipBottom[j] = tooltipTop[j] + tempTooltipHeight;
          }
        }
      } else {
        count = i > 0 ? count : 0;
        // This executes when any of the middle tooltip collides
        if (count > 0) {
          halfHeight = (temp - start) / 2;
          midPos = (visibleLocation[startPoint] + visibleLocation[i]) / 2;
          tempTooltipHeight =
              tooltipBottom[startPoint] - tooltipTop[startPoint];
          tooltipTop[startPoint] = midPos - halfHeight;
          tooltipBottom[startPoint] =
              tooltipTop[startPoint] + tempTooltipHeight;
          for (k = startPoint; k > 0; k--) {
            if (tooltipTop[k] <= tooltipBottom[k - 1] + _tooltipPadding) {
              temp1TooltipHeight = tooltipBottom[k - 1] - tooltipTop[k - 1];
              tooltipTop[k - 1] =
                  tooltipTop[k] - temp1TooltipHeight - _tooltipPadding;
              tooltipBottom[k - 1] = tooltipTop[k - 1] + temp1TooltipHeight;
            } else {
              break;
            }
          }

          // To set tool tip positions based on the half height and other tooltip height
          for (j = startPoint + 1; j <= startPoint + count; j++) {
            tempTooltipHeight = tooltipBottom[j] - tooltipTop[j];
            tooltipTop[j] = tooltipBottom[j - 1] + _tooltipPadding;
            tooltipBottom[j] = tooltipTop[j] + tempTooltipHeight;
          }
          count = 0;
        }
        tooltipHeight =
            (tooltipBottom[i + 1] - tooltipTop[i + 1]) + _tooltipPadding;
        temp = tooltipTop[i + 1] + tooltipHeight;
        start = tooltipTop[i + 1];
        startPoint = i + 1;
      }
    }
    return TooltipPositions(tooltipTop, tooltipBottom);
  }

  /// To get tooltip size.
  Size _tooltipSize(double height, double width, int index) {
    final Offset position = Offset(
        chartPointInfo[index].xPosition!, chartPointInfo[index].yPosition!);
    _stringValue = <TrackballElement>[];
    final String? format = tooltipSettings.format;
    if (format != null &&
        format.contains('point.x') &&
        !format.contains('point.y')) {
      _xFormat = true;
    }
    if (format != null &&
        format.contains('point.x') &&
        format.contains('point.y') &&
        !format.contains(':')) {
      _isColon = false;
    }
    if (chartPointInfo[index].header != null &&
        chartPointInfo[index].header != '') {
      _stringValue.add(TrackballElement(chartPointInfo[index].header!, null));
    }
    if (_isGroupMode) {
      String str1 = '';
      for (int i = 0; i < chartPointInfo.length; i++) {
        // pos = position;
        final dynamic series = chartPointInfo[i].series;
        if (chartPointInfo[i].header != null &&
            chartPointInfo[i].header!.contains(':')) {
          _headerText = true;
        }
        final bool isHeader =
            chartPointInfo[i].header != null && chartPointInfo[i].header != '';
        final bool isLabel =
            chartPointInfo[i].label != null && chartPointInfo[i].label != '';
        _divider = isHeader && isLabel;
        if (series.runtimeType.toString().contains('rangearea') == true) {
          if (i == 0) {
            _stringValue.add(TrackballElement('', null));
          } else {
            str1 = '';
          }
          continue;
        } else if (((series is HiloOpenCloseSeriesRenderer ||
                    series is HiloSeriesRenderer) ||
                series is CandleSeriesRenderer ||
                (series is RangeSeriesRendererBase) ||
                series is BoxAndWhiskerSeriesRenderer) &&
            tooltipSettings.format == null &&
            isLabel) {
          _stringValue.add(TrackballElement(
              '${(chartPointInfo[index].header == null || chartPointInfo[index].header == '') ? '' : i == 0 ? '\n' : ''}${series!.name}\n${chartPointInfo[i].label}',
              series));
        } else if (series is IndicatorRenderer ||
            series!.name != series.localizedName()) {
          if (tooltipSettings.format != null) {
            if (isHeader && isLabel && i == 0) {
              _stringValue.add(TrackballElement('', null));
            }
            if (isLabel) {
              _stringValue.add(TrackballElement(
                  chartPointInfo[i].label!, chartPointInfo[i].series));
            }
          } else if (isLabel &&
              chartPointInfo[i].label!.contains(':') &&
              (chartPointInfo[i].header == null ||
                  chartPointInfo[i].header == '')) {
            _stringValue.add(TrackballElement(
                chartPointInfo[i].label!, chartPointInfo[i].series));
            _divider = false;
          } else {
            if (isHeader && isLabel && i == 0) {
              _stringValue.add(TrackballElement('', null));
            }
            if (isLabel && series != null) {
              if (series is IndicatorRenderer) {
                _stringValue.add(TrackballElement(
                    '$str1${chartPointInfo[i].seriesName}: ${chartPointInfo[i].label!}',
                    chartPointInfo[i].series));
              } else {
                _stringValue.add(TrackballElement(
                    '$str1${chartPointInfo[i].series!.name}: ${chartPointInfo[i].label!}',
                    chartPointInfo[i].series));
              }
            }
            _divider = (chartPointInfo[0].header != null &&
                    chartPointInfo[0].header != '') &&
                isLabel;
          }
          if (str1 != '') {
            str1 = '';
          }
        } else {
          if (isLabel) {
            if (isHeader && i == 0) {
              _stringValue.add(TrackballElement('', null));
            }
            _stringValue.add(TrackballElement(
                chartPointInfo[i].label!, chartPointInfo[i].series));
          }
        }
      }
      for (int i = 0; i < _stringValue.length; i++) {
        String measureString = _stringValue[i].label;
        if (measureString.contains('<b>') && measureString.contains('</b>')) {
          measureString =
              measureString.replaceAll('<b>', '').replaceAll('</b>', '');
        }
        if (measureText(measureString, _labelStyle).width > width) {
          width = measureText(measureString, _labelStyle).width;
        }
        height += measureText(measureString, _labelStyle).height;
      }
      if (_isTransposed) {
        _y = position.dy;
        _x = (tooltipAlignment == ChartAlignment.center)
            ? boundaryRect.center.dx
            : (tooltipAlignment == ChartAlignment.near)
                ? boundaryRect.top
                : boundaryRect.bottom;
      } else {
        _x = position.dx;
        _y = (tooltipAlignment == ChartAlignment.center)
            ? boundaryRect.center.dy
            : (tooltipAlignment == ChartAlignment.near)
                ? boundaryRect.top
                : boundaryRect.bottom;
      }
    } else {
      final dynamic series = chartPointInfo[index].series;
      _stringValue = <TrackballElement>[];
      if (chartPointInfo[index].label != null &&
          chartPointInfo[index].label != '') {
        _stringValue.add(TrackballElement(
            chartPointInfo[index].label!, chartPointInfo[index].series));
      }

      String? measureString =
          _stringValue.isNotEmpty ? _stringValue[0].label : null;
      if (measureString != null &&
          measureString.contains('<b>') &&
          measureString.contains('</b>')) {
        measureString =
            measureString.replaceAll('<b>', '').replaceAll('</b>', '');
      }
      final Size size = measureText(measureString!, _labelStyle);
      width = size.width;
      height = size.height;

      if (series is ColumnSeriesRenderer ||
          series is BarSeriesRenderer ||
          series is CandleSeriesRenderer ||
          series is BoxAndWhiskerSeriesRenderer ||
          (series is HiloOpenCloseSeriesRenderer ||
              series is HiloSeriesRenderer)) {
        _x = position.dx;
        _y = position.dy;
      } else {
        _x = position.dx;
        _y = position.dy;
      }
    }
    return Size(width, height);
  }

  /// To get header text of trackball
  String _findHeaderText(CartesianChartPoint point, RenderChartAxis axis) {
    String headerText;
    String? date;
    if (axis is RenderDateTimeAxis) {
      final RenderDateTimeAxis xAxis = axis;
      final num interval = axis.visibleRange!.minimum.ceil();
      final num xValue = point.xValue!;
      final num prevInterval = (axis.visibleLabels.isNotEmpty)
          ? axis.visibleLabels[axis.visibleLabels.length - 1].value
          : interval;
      final DateFormat dateFormat = xAxis.dateFormat ??
          _dateTimeLabelFormat(axis, interval.toInt(), prevInterval.toInt());
      date = dateFormat
          .format(DateTime.fromMillisecondsSinceEpoch(xValue.floor()));
    }
    headerText = axis is RenderCategoryAxis
        ? point.x.toString()
        : axis is RenderDateTimeAxis
            ? date ?? ''
            : (axis is RenderDateTimeCategoryAxis
                ? _formattedLabel(
                    '${point.x.microsecondsSinceEpoch}', axis.dateFormat!)
                : _labelValue(
                    point.x, axis, axis.interactiveTooltip.decimalPlaces));
    return headerText;
  }

  String _formattedLabel(String label, DateFormat dateFormat) {
    return dateFormat
        .format(DateTime.fromMicrosecondsSinceEpoch(int.parse(label)));
  }

  /// To find the rect location of the trackball.
  void _calculateTrackballRect(
      PaintingContext context, double width, double height, int index,
      [List<ChartPointInfo>? chartPointInfo,
      TooltipPositions? tooltipPosition]) {
    final dynamic series = chartPointInfo![index].series;
    const double widthPadding = 17;
    _markerSize = 10;
    if (!tooltipSettings.canShowMarker) {
      _labelRect = Rect.fromLTWH(_x!, _y!, width + 15, height + 10);
    } else {
      _labelRect = Rect.fromLTWH(
          _x!, _y!, width + (2 * _markerSize) + widthPadding, height + 10);
    }

    if (_y! > _pointerLength + _labelRect.height) {
      _calculateTooltipSize(_labelRect, chartPointInfo, index);
    } else {
      _isTop = false;
      if (series is BarSeriesRenderer ? _isTransposed : _isTransposed) {
        _xPos = _x! - (_labelRect.width / 2);
        _yPos = (_y! + _pointerLength) + _padding;
        _nosePointX = _labelRect.left;
        _nosePointY = _labelRect.top + _padding;
        final double tooltipRightEnd = _x! + (_labelRect.width / 2);
        _xPos = _xPos! < boundaryRect.left
            ? boundaryRect.left
            : tooltipRightEnd > _totalWidth
                ? _totalWidth - _labelRect.width
                : _xPos;
      } else {
        if (_isGroupMode) {
          _xPos = _x! - _labelRect.width / 2;
          _yPos = _y! - _labelRect.height / 2;
        } else {
          _xPos = _x;
          _yPos = (_y! + _pointerLength / 2) + _padding;
        }
        _nosePointX = _labelRect.left;
        _nosePointY = _labelRect.top;
        if (!_isRtl) {
          if ((_isGroupMode
                  ? (_xPos! + (_labelRect.width / 2) + groupAllPadding)
                  : _xPos! + _labelRect.width + _padding + _pointerLength) >
              boundaryRect.right) {
            _xPos = _isGroupMode
                ? (_xPos! - (_labelRect.width / 2) - groupAllPadding)
                : _xPos! - _labelRect.width - _padding - _pointerLength;
            _isLeft = true;
          } else {
            _xPos = _isGroupMode
                ? _x! + groupAllPadding
                : _x! + _padding + _pointerLength;
          }
        } else {
          if (_x! - _labelRect.width - _padding - _pointerLength >
              boundaryRect.left) {
            _xPos = _isGroupMode
                ? (_xPos! - (_labelRect.width / 2) - groupAllPadding)
                : _xPos! - _labelRect.width - _padding - _pointerLength;
            _isLeft = true;
          } else {
            _xPos = _isGroupMode
                ? _x! + groupAllPadding
                : _x! + _padding + _pointerLength;
            _isRight = true;
          }
        }

        if (_isGroupMode &&
            (_yPos! + _labelRect.height) >= boundaryRect.bottom) {
          _yPos = boundaryRect.bottom / 2 - _labelRect.height / 2;
        }

        if (_isGroupMode && _yPos! <= boundaryRect.top) {
          _yPos = boundaryRect.top;
        }
      }
    }

    _labelRect =
        _isGroupMode || tooltipDisplayMode == TrackballDisplayMode.nearestPoint
            ? Rect.fromLTWH(_xPos!, _yPos!, _labelRect.width, _labelRect.height)
            : Rect.fromLTWH(
                _isTransposed
                    ? tooltipPosition!.tooltipTop[index].toDouble()
                    : _xPos!,
                !_isTransposed
                    ? tooltipPosition!.tooltipTop[index].toDouble()
                    : _yPos!,
                _labelRect.width,
                _labelRect.height);
    if (_isGroupMode) {
      _drawTooltipBackground(
          context,
          _labelRect,
          _nosePointX,
          _nosePointY,
          _borderRadius,
          _isTop,
          _backgroundPath,
          _isLeft,
          _isRight,
          index,
          null,
          null);
    } else {
      if (_isTransposed
          ? tooltipPosition!.tooltipTop[index] >= boundaryRect.left &&
              tooltipPosition.tooltipBottom[index] <= boundaryRect.right
          : tooltipPosition!.tooltipTop[index] >= boundaryRect.top &&
              tooltipPosition.tooltipBottom[index] <= boundaryRect.bottom) {
        _drawTooltipBackground(
            context,
            _labelRect,
            _nosePointX,
            _nosePointY,
            _borderRadius,
            _isTop,
            _backgroundPath,
            _isLeft,
            _isRight,
            index,
            (series is RangeSeriesRendererBase) ||
                    (series is HiloOpenCloseSeriesRenderer ||
                        series is HiloSeriesRenderer) ||
                    series is CandleSeriesRenderer
                ? chartPointInfo[index].highXPosition
                : series is BoxAndWhiskerSeriesRenderer
                    ? chartPointInfo[index].maxXPosition
                    : chartPointInfo[index].xPosition,
            (series is RangeSeriesRendererBase) ||
                    (series is HiloOpenCloseSeriesRenderer ||
                        series is HiloSeriesRenderer) ||
                    series is CandleSeriesRenderer
                ? chartPointInfo[index].highYPosition
                : series is BoxAndWhiskerSeriesRenderer
                    ? chartPointInfo[index].maxYPosition
                    : chartPointInfo[index].yPosition);
      }
    }
  }

  /// To find the trackball tooltip size.
  void _calculateTooltipSize(
      Rect labelRect, List<ChartPointInfo>? chartPointInfo, int index) {
    _isTop = true;
    _isRight = false;
    if (chartPointInfo![index].series != null &&
            chartPointInfo[index].series is BarSeriesRenderer
        ? _isTransposed
        : _isTransposed) {
      _xPos = _x! - (labelRect.width / 2);
      _yPos = (_y! - labelRect.height) - _padding;
      _nosePointY = labelRect.top - _padding;
      _nosePointX = labelRect.left;
      final double tooltipRightEnd = _x! + (labelRect.width / 2);
      _xPos = _xPos! < boundaryRect.left
          ? boundaryRect.left
          : tooltipRightEnd > _totalWidth
              ? _totalWidth - labelRect.width
              : _xPos;
      _yPos = _yPos! - _pointerLength;
      if (_yPos! + labelRect.height >= boundaryRect.bottom) {
        _yPos = boundaryRect.bottom - labelRect.height;
      }
    } else {
      _xPos = _x;
      _yPos = _y! - labelRect.height / 2;
      _nosePointY = _yPos!;
      _nosePointX = labelRect.left;
      if (!_isRtl) {
        if (_xPos! + labelRect.width + _padding + _pointerLength >
            boundaryRect.right) {
          _xPos = _isGroupMode
              ? _xPos! - labelRect.width - groupAllPadding
              : _xPos! - labelRect.width - _padding - _pointerLength;
          _isLeft = true;
        } else {
          _xPos = _isGroupMode
              ? _x! + groupAllPadding
              : _x! + _padding + _pointerLength;
          _isLeft = false;
          _isRight = true;
        }
      } else {
        _xPos = _isGroupMode
            ? _xPos! - labelRect.width - groupAllPadding
            : _xPos! - labelRect.width - _padding - _pointerLength;
        if (_xPos! < boundaryRect.left) {
          _xPos = _isGroupMode
              ? _x! + groupAllPadding
              : _x! + _padding + _pointerLength;
          _isRight = true;
        } else {
          _isLeft = true;
        }
      }
      if (_yPos! + labelRect.height >= boundaryRect.bottom) {
        _yPos = boundaryRect.bottom - labelRect.height;
      }
    }
  }

  /// To draw the line for the trackball.
  void _drawTrackBallLine(Canvas canvas, Paint paint, int index) {
    final Path dashArrayPath = Path();
    if (chartPointInfo[index].series is BarSeriesRenderer
        ? _isTransposed
        : _isTransposed) {
      dashArrayPath.moveTo(boundaryRect.left, chartPointInfo[index].yPosition!);
      dashArrayPath.lineTo(
          boundaryRect.right, chartPointInfo[index].yPosition!);
    } else {
      dashArrayPath.moveTo(chartPointInfo[index].xPosition!, boundaryRect.top);
      dashArrayPath.lineTo(
          chartPointInfo[index].xPosition!, boundaryRect.bottom);
    }
    lineDashArray != null
        ? drawDashes(canvas, lineDashArray, paint, path: dashArrayPath)
        : drawDashes(canvas, null, paint, path: dashArrayPath);
  }

  /// To draw background of trackball tooltip.
  void _drawTooltipBackground(
      PaintingContext context,
      Rect labelRect,
      double xPos,
      double yPos,
      double borderRadius,
      bool isTop,
      Path backgroundPath,
      bool isLeft,
      bool isRight,
      int index,
      double? xPosition,
      double? yPosition) {
    final double startArrow = _pointerLength;
    final double endArrow = _pointerLength;
    if (isTop) {
      _drawTooltip(
          context,
          labelRect,
          xPos,
          yPos,
          xPos - startArrow,
          (yPos - startArrow) - 1,
          xPos + endArrow,
          (yPos - endArrow) - 1,
          borderRadius,
          backgroundPath,
          isLeft,
          isRight,
          index,
          xPosition,
          yPosition);
    } else {
      _drawTooltip(
          context,
          labelRect,
          xPos,
          yPos,
          xPos - startArrow,
          (yPos + startArrow) + 1,
          xPos + endArrow,
          (yPos + endArrow) + 1,
          borderRadius,
          backgroundPath,
          isLeft,
          isRight,
          index,
          xPosition,
          yPosition);
    }
  }

  /// To draw the tooltip on the trackball.
  void _drawTooltip(
      PaintingContext context,
      Rect tooltipRect,
      double? xPos,
      double? yPos,
      double startX,
      double startY,
      double endX,
      double endY,
      double borderRadius,
      Path backgroundPath,
      bool isLeft,
      bool isRight,
      int index,
      double? xPosition,
      double? yPosition) {
    backgroundPath.reset();
    if (!_canResetPath && tooltipDisplayMode != TrackballDisplayMode.none) {
      if (!_isGroupMode &&
          !(xPosition == null || yPosition == null) &&
          parentBox != null &&
          (tooltipRect.left > boundaryRect.left &&
              tooltipRect.right < boundaryRect.right &&
              tooltipRect.top > boundaryRect.top &&
              tooltipRect.bottom < boundaryRect.bottom)) {
        if (_isTransposed) {
          if (isLeft) {
            startX = tooltipRect.left + borderRadius;
            endX = startX + _pointerWidth;
          } else if (isRight) {
            endX = tooltipRect.right - borderRadius;
            startX = endX - _pointerWidth;
          }

          backgroundPath.moveTo(
              (tooltipRect.left + tooltipRect.width / 2) - _pointerWidth,
              startY);
          backgroundPath.lineTo(xPosition, yPosition);
          backgroundPath.lineTo(
              (tooltipRect.right - tooltipRect.width / 2) + _pointerWidth,
              endY);
        } else {
          if (isLeft) {
            backgroundPath.moveTo(tooltipRect.right - 1,
                tooltipRect.top + tooltipRect.height / 2 - _pointerWidth);
            backgroundPath.lineTo(tooltipRect.right - 1,
                tooltipRect.bottom - tooltipRect.height / 2 + _pointerWidth);
            backgroundPath.lineTo(
                tooltipRect.right + _pointerLength, yPosition);
            backgroundPath.lineTo(tooltipRect.right - 1,
                tooltipRect.top + tooltipRect.height / 2 - _pointerWidth);
          } else {
            backgroundPath.moveTo(tooltipRect.left + 1,
                tooltipRect.top + tooltipRect.height / 2 - _pointerWidth);
            backgroundPath.lineTo(tooltipRect.left + 1,
                tooltipRect.bottom - tooltipRect.height / 2 + _pointerWidth);
            backgroundPath.lineTo(tooltipRect.left - _pointerLength, yPosition);
            backgroundPath.lineTo(tooltipRect.left + 1,
                tooltipRect.top + tooltipRect.height / 2 - _pointerWidth);
          }
        }
      }

      double rectLeft = tooltipRect.left;
      double rectRight = tooltipRect.right;

      if (tooltipRect.width < boundaryRect.width &&
          tooltipRect.height < boundaryRect.height) {
        if (tooltipRect.left < boundaryRect.left) {
          rectLeft = rectLeft + (boundaryRect.left - tooltipRect.left);
          rectRight = rectRight + (boundaryRect.left - tooltipRect.left);
        } else if (tooltipRect.right > boundaryRect.right) {
          rectLeft = rectLeft - (tooltipRect.right - boundaryRect.right);
          rectRight = rectRight - (tooltipRect.right - boundaryRect.right);
        }
        tooltipRect = Rect.fromLTRB(
            rectLeft, tooltipRect.top, rectRight, tooltipRect.bottom);
        if ((tooltipRect.left < boundaryRect.left) ||
            tooltipRect.right > boundaryRect.right) {
          tooltipRect = Rect.zero;
        }

        if (tooltipRect != Rect.zero) {
          _drawRectAndText(context, backgroundPath, tooltipRect, index);
        }
      } else {
        tooltipRect = Rect.zero;
      }

      xPos = null;
      yPos = null;
    }
  }

  TextStyle _createLabelStyle(FontWeight fontWeight, TextStyle labelStyle) {
    return TextStyle(
        fontWeight: fontWeight,
        color: labelStyle.color,
        fontSize: labelStyle.fontSize,
        fontFamily: labelStyle.fontFamily,
        fontStyle: labelStyle.fontStyle,
        inherit: labelStyle.inherit,
        backgroundColor: labelStyle.backgroundColor,
        letterSpacing: labelStyle.letterSpacing,
        wordSpacing: labelStyle.wordSpacing,
        textBaseline: labelStyle.textBaseline,
        height: labelStyle.height,
        locale: labelStyle.locale,
        foreground: labelStyle.foreground,
        background: labelStyle.background,
        shadows: labelStyle.shadows,
        fontFeatures: labelStyle.fontFeatures,
        decoration: labelStyle.decoration,
        decorationColor: labelStyle.decorationColor,
        decorationStyle: labelStyle.decorationStyle,
        decorationThickness: labelStyle.decorationThickness,
        debugLabel: labelStyle.debugLabel,
        fontFamilyFallback: labelStyle.fontFamilyFallback);
  }

  double _multiLineTextOffset(RRect tooltipRect, String text, int index,
      double totalLabelWidth, TextStyle style,
      [double? previousWidth]) {
    final double textOffsetX =
        tooltipRect.left + tooltipRect.width / 2 + totalLabelWidth / 2;
    final Size currentTextSize = measureText(text, style);
    return textOffsetX -
        currentTextSize.width -
        (index == 0 ? 0 : previousWidth!);
  }

  /// Draw trackball tooltip rect and text.
  void _drawRectAndText(
      PaintingContext context, Path backgroundPath, Rect rect, int index,
      // ignore: unused_element
      [Path? arrowPath]) {
    const double textOffsetPadding = 4;
    final RRect tooltipRect = RRect.fromRectAndCorners(
      rect,
      bottomLeft: Radius.circular(_borderRadius),
      bottomRight: Radius.circular(_borderRadius),
      topLeft: Radius.circular(_borderRadius),
      topRight: Radius.circular(_borderRadius),
    );
    const double padding = 10;

    final Paint fillPaint = Paint()
      ..color = tooltipSettings.color ?? _chartTheme!.crosshairBackgroundColor
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    if (tooltipSettings.borderWidth > 0 && builder == null) {
      final Paint strokePaint = Paint()
        ..color =
            tooltipSettings.borderColor ?? _chartTheme!.crosshairBackgroundColor
        ..strokeWidth = tooltipSettings.borderWidth
        ..strokeCap = StrokeCap.butt
        ..isAntiAlias = true
        ..style = PaintingStyle.stroke;
      context.canvas.drawPath(backgroundPath, strokePaint);
      context.canvas.drawRRect(tooltipRect, strokePaint);
    }
    if (builder == null) {
      context.canvas.drawRRect(tooltipRect, fillPaint);
      context.canvas.drawPath(backgroundPath, fillPaint);
      final Paint dividerPaint = Paint();
      dividerPaint.color = _chartTheme!.tooltipSeparatorColor;
      dividerPaint.strokeWidth = 1;
      dividerPaint.style = PaintingStyle.stroke;
      dividerPaint.isAntiAlias = true;
      if (_isGroupMode && _divider) {
        final Size headerResult =
            measureText(_stringValue[0].label, _labelStyle);
        context.canvas.drawLine(
            Offset(tooltipRect.left + padding,
                tooltipRect.top + headerResult.height + padding),
            Offset(tooltipRect.right - padding,
                tooltipRect.top + headerResult.height + padding),
            dividerPaint);
      }
    }
    double eachTextHeight = 0;
    Size labelSize;
    double totalHeight = 0;
    final bool isRtl = _isRtl;
    int markerIndex = 0;

    for (int i = 0; i < _stringValue.length; i++) {
      labelSize = measureText(_stringValue[i].label, _labelStyle);
      totalHeight += labelSize.height;
    }

    eachTextHeight =
        (tooltipRect.top + tooltipRect.height / 2) - totalHeight / 2;

    for (int i = 0; i < _stringValue.length; i++) {
      _markerPadding = 0;
      if (tooltipSettings.canShowMarker) {
        if (_isGroupMode && i == 0) {
          _markerPadding = 0;
        } else {
          _markerPadding = 10 - _markerSize + 5;
        }
      }
      const double animationFactor = 1;
      _labelStyle = _createLabelStyle(FontWeight.normal, _labelStyle);
      labelSize = measureText(_stringValue[i].label, _labelStyle);
      eachTextHeight += labelSize.height;
      if (!_stringValue[i].label.contains(':') &&
          !_stringValue[i].label.contains('<b>') &&
          !_stringValue[i].label.contains('</b>')) {
        _labelStyle = _createLabelStyle(FontWeight.bold, _labelStyle);
        _drawTooltipMarker(
            _stringValue[i].label,
            context,
            tooltipRect,
            animationFactor,
            labelSize,
            _stringValue[i].seriesRenderer ?? chartPointInfo[index].series!,
            i,
            null,
            null,
            eachTextHeight,
            _isGroupMode ? markerIndex : index);
        drawText(
            context.canvas,
            _stringValue[i].label,
            Offset(
                (tooltipRect.left + tooltipRect.width / 2) -
                    labelSize.width / 2 +
                    (isRtl ? -_markerPadding : _markerPadding),
                eachTextHeight - labelSize.height),
            _labelStyle);
      } else {
        // ignore: unnecessary_null_comparison
        if (_stringValue[i].label != null) {
          final List<String> str = _stringValue[i].label.split('\n');
          double padding = 0;
          if (str.length > 1) {
            for (int j = 0; j < str.length; j++) {
              final List<String> str1 = str[j].split(':');
              if (str1.length > 1) {
                for (int k = 0; k < str1.length; k++) {
                  double width = 0.0;
                  if (isRtl) {
                    str1[k] = k == 0 ? ': ${str1[k]}'.trim() : '${str1[k]} ';
                    width = measureText(str1[0], _labelStyle).width;
                  } else {
                    width =
                        k > 0 ? measureText(str1[k - 1], _labelStyle).width : 0;
                    str1[k] = k == 1 ? ':${str1[k]}' : str1[k];
                  }
                  _labelStyle = _createLabelStyle(
                      k > 0 ? FontWeight.bold : FontWeight.normal, _labelStyle);

                  if (k == 0) {
                    _drawTooltipMarker(
                        str1[k],
                        context,
                        tooltipRect,
                        animationFactor,
                        labelSize,
                        _stringValue[i].seriesRenderer,
                        i,
                        null,
                        width,
                        eachTextHeight,
                        _isGroupMode ? markerIndex : index);
                  }
                  drawText(
                      context.canvas,
                      str1[k],
                      isRtl
                          ? Offset(
                              _multiLineTextOffset(
                                    tooltipRect,
                                    str1[k],
                                    k,
                                    labelSize.width,
                                    _labelStyle,
                                    width,
                                  ) -
                                  ((!_isGroupMode &&
                                          tooltipSettings.canShowMarker)
                                      ? _markerPadding
                                      : textOffsetPadding),
                              (eachTextHeight - labelSize.height) + padding)
                          : Offset(
                              (((!_isGroupMode && tooltipSettings.canShowMarker)
                                          ? (tooltipRect.left +
                                              tooltipRect.width / 2 -
                                              labelSize.width / 2)
                                          : (tooltipRect.left +
                                              textOffsetPadding)) +
                                      _markerPadding) +
                                  width,
                              (eachTextHeight - labelSize.height) + padding),
                      _labelStyle);

                  padding = k > 0
                      ? padding +
                          (_labelStyle.fontSize! +
                              (_labelStyle.fontSize! * 0.15))
                      : padding;
                }
              } else {
                _labelStyle = _createLabelStyle(FontWeight.bold, _labelStyle);

                _drawTooltipMarker(
                    str1[str1.length - 1],
                    context,
                    tooltipRect,
                    animationFactor,
                    labelSize,
                    _stringValue[i].seriesRenderer,
                    i,
                    null,
                    null,
                    eachTextHeight,
                    _isGroupMode ? markerIndex : index,
                    measureText(str1[str1.length - 1], _labelStyle));
                _markerPadding = tooltipSettings.canShowMarker
                    ? _markerPadding +
                        (j == 0 && !_isGroupMode
                            ? 13
                            : j == 0 && _isGroupMode
                                ? 7
                                : 0)
                    : 0;
                drawText(
                    context.canvas,
                    str1[str1.length - 1],
                    isRtl
                        ? Offset(
                            tooltipRect.right -
                                measureText(str1[str1.length - 1], _labelStyle)
                                    .width -
                                _markerPadding -
                                textOffsetPadding,
                            eachTextHeight - labelSize.height + padding)
                        : Offset(
                            _markerPadding +
                                tooltipRect.left +
                                textOffsetPadding,
                            eachTextHeight - labelSize.height + padding),
                    _labelStyle);
                padding = padding +
                    (_labelStyle.fontSize! + (_labelStyle.fontSize! * 0.15));
              }
            }
          } else {
            final bool hasFormat = tooltipSettings.format != null;
            List<String> str1 = str[str.length - 1].split(':');
            final List<String> boldString = <String>[];
            if (str[str.length - 1].contains('<b>')) {
              str1 = <String>[];
              final List<String> boldSplit = str[str.length - 1].split('</b>');
              for (int i = 0; i < boldSplit.length; i++) {
                if (boldSplit[i] != '') {
                  boldString.add(boldSplit[i].substring(
                      boldSplit[i].indexOf('<b>') + 3, boldSplit[i].length));
                  final List<String> str2 = boldSplit[i].split('<b>');
                  for (int s = 0; s < str2.length; s++) {
                    str1.add(str2[s]);
                  }
                }
              }
            } else if (str1.length > 2 ||
                _xFormat ||
                !_isColon ||
                _headerText) {
              str1 = <String>[];
              str1.add(str[str.length - 1]);
            }
            double previousWidth = 0.0;
            for (int j = 0; j < str1.length; j++) {
              bool isBold = false;
              for (int i = 0; i < boldString.length; i++) {
                if (str1[j] == boldString[i]) {
                  isBold = true;
                  break;
                }
              }
              final double width =
                  j > 0 ? measureText(str1[j - 1], _labelStyle).width : 0;
              previousWidth += width;
              String colon = boldString.isNotEmpty
                  ? ''
                  : j > 0
                      ? ' :'
                      : '';
              if (isRtl & !hasFormat) {
                colon = boldString.isNotEmpty
                    ? ''
                    : j > 0
                        ? ' : '
                        : '';
              }
              _labelStyle = _createLabelStyle(
                  ((_headerText && boldString.isEmpty) || _xFormat || isBold)
                      ? FontWeight.bold
                      : j > 0
                          ? boldString.isNotEmpty
                              ? FontWeight.normal
                              : FontWeight.bold
                          : FontWeight.normal,
                  _labelStyle);

              if (j == 0) {
                _drawTooltipMarker(
                    str1[j],
                    context,
                    tooltipRect,
                    animationFactor,
                    labelSize,
                    _stringValue[i].seriesRenderer,
                    i,
                    previousWidth,
                    width,
                    eachTextHeight,
                    _isGroupMode ? markerIndex : index);
              }
              _markerPadding = tooltipSettings.canShowMarker
                  ? _markerPadding +
                      (j == 0 && !_isGroupMode
                          ? 13
                          : j == 0 && _isGroupMode
                              ? 7
                              : 0)
                  : 0;
              final Offset textEndPoint = Offset(
                  isRtl
                      ? tooltipRect.right - textOffsetPadding - _markerPadding
                      : _markerPadding +
                          (tooltipRect.left + textOffsetPadding) +
                          (previousWidth > width ? previousWidth : width),
                  eachTextHeight - labelSize.height);

              if (!isRtl || (isRtl && !hasFormat)) {
                drawText(
                    context.canvas,
                    isRtl ? str1[j] + colon : colon + str1[j],
                    isRtl
                        ? Offset(
                            textEndPoint.dx -
                                (previousWidth > width
                                    ? previousWidth
                                    : width) -
                                measureText(str1[j] + colon, _labelStyle).width,
                            textEndPoint.dy)
                        : textEndPoint,
                    _labelStyle);
              } else {
                _drawTextWithFormat(context, str1, _labelStyle, textEndPoint);
                break;
              }
              _headerText = false;
            }
          }
        }
      }
      if (_isGroupMode && i != 0 && _stringValue[i].label != '') {
        markerIndex++;
      }
    }
  }

  void _drawTextWithFormat(PaintingContext context, List<String> textCollection,
      TextStyle labelStyle, Offset textEndPoint) {
    final String arrangedText = _rtlStringWithColon(textCollection);
    final List<String> strings = arrangedText.split(':');
    double previousWidth = 0.0;
    for (int textCount = 0; textCount < strings.length; textCount++) {
      final bool containsBackSpace = strings[textCount].endsWith(' ');
      final bool containsFrontSpace = strings[textCount].startsWith(' ');
      strings[textCount] = strings[textCount].trim();
      if (containsFrontSpace) {
        strings[textCount] = '${strings[textCount]} ';
      }
      if (containsBackSpace) {
        strings[textCount] = ' ${strings[textCount]}';
      }
      final String currentText =
          textCount > 0 ? '${strings[textCount]}:' : (strings[textCount]);
      final Size currentTextSize = measureText(currentText, labelStyle);
      previousWidth += currentTextSize.width;
      drawText(context.canvas, currentText,
          Offset(textEndPoint.dx - previousWidth, textEndPoint.dy), labelStyle);
    }
  }

  String _rtlStringWithColon(List<String> textCollection) {
    String string = '';
    for (int i = textCollection.length - 1; i >= 0; i--) {
      final bool containsBackSpace = textCollection[i].endsWith(' ');
      final bool containsFrontSpace = textCollection[i].startsWith(' ');
      textCollection[i] = textCollection[i].trim();
      if (containsFrontSpace) {
        textCollection[i] = '${textCollection[i]} ';
      }
      if (containsBackSpace) {
        textCollection[i] = ' ${textCollection[i]}';
      }
      string = string +
          (i == textCollection.length - 1
              ? textCollection[i]
              : ':${textCollection[i]}');
    }
    return string;
  }

  /// Draw marker inside the trackball tooltip.
  void _drawTooltipMarker(
      String labelValue,
      PaintingContext context,
      RRect tooltipRect,
      double animationFactor,
      Size tooltipMarkerResult,
      dynamic seriesRenderer,
      int i,
      double? previousWidth,
      double? width,
      double eachTextHeight,
      int index,
      [Size? headerSize]) {
    final Size tooltipStringResult = tooltipMarkerResult;
    _markerSize = 5;
    Offset markerPoint;
    final bool isRtl = _isRtl;
    if (tooltipSettings.canShowMarker) {
      if (!_isGroupMode) {
        if (seriesRenderer is HiloOpenCloseSeriesRenderer ||
            seriesRenderer is HiloSeriesRenderer ||
            seriesRenderer is CandleSeriesRenderer ||
            seriesRenderer is BoxAndWhiskerSeriesRenderer) {
          final double markerStartPoint = _isRtl
              ? tooltipStringResult.width / 2 + _markerSize
              : -tooltipMarkerResult.width / 2 - _markerSize;
          markerPoint = Offset(
              tooltipRect.left + tooltipRect.width / 2 + markerStartPoint,
              (eachTextHeight - tooltipStringResult.height / 2) + 0.0);
          _renderMarker(markerPoint, seriesRenderer, animationFactor,
              context.canvas, index);
        } else {
          final double markerStartPoint = isRtl
              ? tooltipStringResult.width / 2 + _markerSize
              : -tooltipMarkerResult.width / 2 - _markerSize;
          markerPoint = Offset(
              tooltipRect.left + tooltipRect.width / 2 + markerStartPoint,
              ((tooltipRect.top + tooltipRect.height) -
                      tooltipStringResult.height / 2) -
                  _markerSize);
        }
        _renderMarker(markerPoint, seriesRenderer, animationFactor,
            context.canvas, index);
      } else {
        if (i > 0 && labelValue != '') {
          if (tooltipSettings.format == null &&
              (seriesRenderer is IndicatorRenderer ||
                  seriesRenderer.name != seriesRenderer.localizedName())) {
            if (previousWidth != null && width != null) {
              final double markerStartPoint =
                  isRtl ? (tooltipRect.right - 10) : (tooltipRect.left + 10);
              markerPoint = Offset(
                  markerStartPoint +
                      (previousWidth > width ? previousWidth : width),
                  eachTextHeight - tooltipMarkerResult.height / 2);
              _renderMarker(markerPoint, seriesRenderer, animationFactor,
                  context.canvas, index);
            } else if (_stringValue[i].label != '' && headerSize != null) {
              markerPoint = Offset(
                  isRtl ? tooltipRect.right - 10 : tooltipRect.left + 10,
                  (headerSize.height * 2 +
                          tooltipRect.top +
                          _markerSize +
                          headerSize.height / 2) +
                      (i == 1
                          ? 0
                          : _lastMarkerResultHeight - headerSize.height));
              _lastMarkerResultHeight = tooltipMarkerResult.height;
              _stringValue[i].needRender = false;
              _renderMarker(markerPoint, seriesRenderer, animationFactor,
                  context.canvas, index);
            }
          } else {
            final double tooltipCenter =
                tooltipRect.left + tooltipRect.width / 2;
            final double markerStartPoint = isRtl
                ? _stringValue[i].label.contains(':')
                    ? tooltipRect.right - _markerPadding / 2 - _markerSize
                    : tooltipCenter +
                        (tooltipStringResult.width / 2 + _markerSize)
                : _stringValue[i].label.contains(':')
                    ? tooltipRect.left + _markerPadding / 2 + _markerSize
                    : tooltipCenter +
                        (-tooltipMarkerResult.width / 2 - _markerSize);
            markerPoint = Offset(markerStartPoint,
                eachTextHeight - tooltipMarkerResult.height / 2);
            _renderMarker(markerPoint, seriesRenderer, animationFactor,
                context.canvas, index);
          }
        }
      }
    }
  }

  // To render marker for the chart tooltip.
  void _renderMarker(Offset markerPoint, dynamic seriesRenderer,
      double animationFactor, Canvas canvas, int index) {
    final MarkerSettings settings = markerSettings == null &&
            seriesRenderer is CartesianSeriesRenderer<dynamic, dynamic>
        ? seriesRenderer.markerSettings
        : markerSettings ?? const TrackballMarkerSettings();
    final Path markerPath = _markerShapesPath(
        settings.shape,
        markerPoint,
        Size((2 * _markerSize) * animationFactor,
            (2 * _markerSize) * animationFactor),
        seriesRenderer,
        index);

    if (settings.shape == DataMarkerType.image) {
      _drawImageMarker(seriesRenderer, canvas, markerPoint.dx, markerPoint.dy);
    }

    Color? seriesColor;
    if (seriesRenderer is CandleSeriesRenderer) {
      seriesColor = seriesRenderer.color ??
          (seriesRenderer.enableSolidCandles
              ? seriesRenderer
                  .segments[chartPointInfo[0].dataPointIndex!].fillPaint.color
              : seriesRenderer.segments[chartPointInfo[0].dataPointIndex!]
                  .strokePaint.color);
    } else {
      seriesColor = seriesRenderer is CartesianSeriesRenderer<dynamic, dynamic>
          ? seriesRenderer.color ??
              seriesRenderer
                  .segments[chartPointInfo[0].dataPointIndex!].fillPaint.color
          : chartPointInfo[index].color!;
    }

    Paint markerPaint = Paint();
    markerPaint.color =
        chartPointInfo[index].color ?? settings.color ?? seriesColor;
    markerPaint.isAntiAlias = true;
    if (seriesRenderer is CartesianSeriesRenderer &&
        seriesRenderer.gradient != null) {
      markerPaint = _linearGradientPaint(
          seriesRenderer.gradient!,
          _markerShapesPath(
                  settings.shape,
                  Offset(markerPoint.dx, markerPoint.dy),
                  Size((2 * _markerSize) * animationFactor,
                      (2 * _markerSize) * animationFactor),
                  seriesRenderer)
              .getBounds(),
          seriesRenderer.xAxis!.isInversed);
    }
    canvas.drawPath(markerPath, markerPaint);
    Paint markerBorderPaint = Paint();
    markerBorderPaint.color =
        chartPointInfo[index].color ?? settings.borderColor ?? seriesColor;
    markerBorderPaint.strokeWidth = 1;
    markerBorderPaint.style = PaintingStyle.stroke;
    markerBorderPaint.isAntiAlias = true;

    if (seriesRenderer is CartesianSeriesRenderer &&
        seriesRenderer.gradient != null) {
      markerBorderPaint = _linearGradientPaint(
          seriesRenderer.gradient!,
          _markerShapesPath(
                  settings.shape,
                  Offset(markerPoint.dx, markerPoint.dy),
                  Size((2 * _markerSize) * animationFactor,
                      (2 * _markerSize) * animationFactor),
                  seriesRenderer)
              .getBounds(),
          seriesRenderer.xAxis!.isInversed);
    }
    canvas.drawPath(markerPath, markerBorderPaint);
  }

  /// Paint the image marker.
  void _drawImageMarker(
      dynamic series, Canvas canvas, double pointX, double pointY) {
    if (_image != null) {
      final double imageWidth = 2 * markerSettings!.width;
      final double imageHeight = 2 * markerSettings!.height;
      final Rect positionRect = Rect.fromLTWH(pointX - imageWidth / 2,
          pointY - imageHeight / 2, imageWidth, imageHeight);
      paintImage(
          canvas: canvas, rect: positionRect, image: _image!, fit: BoxFit.fill);
    }
  }

  /// Get gradient fill colors.
  Paint _linearGradientPaint(
      LinearGradient gradientFill, Rect region, bool isInvertedAxis) {
    Paint gradientPaint;
    gradientPaint = Paint()
      ..shader = gradientFill.createShader(region)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    return gradientPaint;
  }

  /// Returns the path of marker shapes.
  Path _markerShapesPath(DataMarkerType markerType, Offset position, Size size,
      [dynamic seriesRenderer,
      int? index,
      // ignore: unused_element
      CurvedAnimation? animationController,
      ChartSegment? segment]) {
    final Path path = Path();
    final Rect rect = segment != null && segment is ScatterSegment
        ? Rect.fromLTWH(
            position.dx - ((segment.animationFactor * size.width) / 2),
            position.dy - ((segment.animationFactor * size.height) / 2),
            segment.animationFactor * size.width,
            segment.animationFactor * size.height)
        : Rect.fromLTWH(position.dx - size.width / 2,
            position.dy - size.height / 2, size.width, size.height);
    switch (markerType) {
      case DataMarkerType.circle:
        {
          getShapesPath(
              path: path, rect: rect, shapeType: ShapeMarkerType.circle);
        }
        break;
      case DataMarkerType.rectangle:
        {
          getShapesPath(
              path: path, rect: rect, shapeType: ShapeMarkerType.rectangle);
        }
        break;
      case DataMarkerType.image:
        {
          if (seriesRenderer != null) {
            _loadMarkerImage(seriesRenderer);
          }
        }
        break;
      case DataMarkerType.pentagon:
        {
          getShapesPath(
              path: path, rect: rect, shapeType: ShapeMarkerType.pentagon);
        }
        break;
      case DataMarkerType.verticalLine:
        {
          getShapesPath(
              path: path, rect: rect, shapeType: ShapeMarkerType.verticalLine);
        }
        break;
      case DataMarkerType.invertedTriangle:
        {
          getShapesPath(
              path: path,
              rect: rect,
              shapeType: ShapeMarkerType.invertedTriangle);
        }
        break;
      case DataMarkerType.horizontalLine:
        {
          getShapesPath(
              path: path,
              rect: rect,
              shapeType: ShapeMarkerType.horizontalLine);
        }
        break;
      case DataMarkerType.diamond:
        {
          getShapesPath(
              path: path, rect: rect, shapeType: ShapeMarkerType.diamond);
        }
        break;
      case DataMarkerType.triangle:
        {
          getShapesPath(
              path: path, rect: rect, shapeType: ShapeMarkerType.triangle);
        }
        break;
      case DataMarkerType.none:
        break;
    }
    return path;
  }

  // ignore: avoid_void_async
  void _loadMarkerImage(CartesianSeriesRenderer series) async {
    if ((markerSettings != null &&
            markerSettings!.shape == DataMarkerType.image &&
            markerSettings!.image != null) ||
        // ignore: unnecessary_null_comparison
        (series.markerSettings != null &&
            (series.markerSettings.isVisible ||
                series is ScatterSeriesRenderer) &&
            series.markerSettings.shape == DataMarkerType.image &&
            series.markerSettings.image != null)) {
      _calculateImage();
    }
  }

  /// below method is for getting image from the image provider
  Future<dart_ui.Image> _imageInfo(ImageProvider imageProvider) async {
    final Completer<ImageInfo> completer = Completer<ImageInfo>();
    imageProvider
        .resolve(ImageConfiguration.empty)
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info);
      // return completer.future;
    }));
    final ImageInfo imageInfo = await completer.future;
    return imageInfo.image;
  }

  /// Method to calculate the image value
//ignore: avoid_void_async
  void _calculateImage() async {
    if (markerSettings!.image != null) {
      _image = await _imageInfo(markerSettings!.image!);
      if (parentBox != null) {
        (parentBox! as RenderBehaviorArea).invalidate();
      }
    }
  }

  /// To get the label format of the date-time axis.
  DateFormat _dateTimeLabelFormat(RenderChartAxis axis,
      [int? interval, int? prevInterval]) {
    DateFormat? format;
    final bool notDoubleInterval =
        (axis.interval != null && axis.interval! % 1 == 0) ||
            axis.interval == null;
    DateTimeIntervalType? actualIntervalType;
    num? minimum;
    minimum = axis.visibleRange!.minimum;
    actualIntervalType = (axis as RenderDateTimeAxis).visibleIntervalType;
    switch (actualIntervalType) {
      case DateTimeIntervalType.years:
        format = notDoubleInterval ? DateFormat.y() : DateFormat.MMMd();
        break;
      case DateTimeIntervalType.months:
        format = (minimum == interval || interval == prevInterval)
            ? _firstLabelFormat(actualIntervalType)
            : _dateTimeFormat(actualIntervalType, interval, prevInterval);

        break;
      case DateTimeIntervalType.days:
        format = (minimum == interval || interval == prevInterval)
            ? _firstLabelFormat(actualIntervalType)
            : _dateTimeFormat(actualIntervalType, interval, prevInterval);
        break;
      case DateTimeIntervalType.hours:
        format = DateFormat.j();
        break;
      case DateTimeIntervalType.minutes:
        format = DateFormat.Hm();
        break;
      case DateTimeIntervalType.seconds:
        format = DateFormat.ms();
        break;
      case DateTimeIntervalType.milliseconds:
        final DateFormat dateFormat = DateFormat('ss.SSS');
        format = dateFormat;
        break;
      case DateTimeIntervalType.auto:
        break;
      // ignore: no_default_cases
      default:
        break;
    }
    return format!;
  }

  /// Gets the the actual label value for tooltip and data label etc.
  String _labelValue(num value, dynamic axis, [int? showDigits]) {
    if (value.toString().split('.').length > 1) {
      final String str = value.toString();
      final List list = str.split('.');
      value = double.parse(value.toStringAsFixed(showDigits ?? 3));
      value = (list[1] == '0' ||
              list[1] == '00' ||
              list[1] == '000' ||
              list[1] == '0000' ||
              list[1] == '00000' ||
              list[1] == '000000' ||
              list[1] == '0000000')
          ? value.round()
          : value;
    }
    final dynamic text = axis is RenderNumericAxis && axis.numberFormat != null
        ? axis.numberFormat!.format(value)
        : value;
    return ((axis.labelFormat != null && axis.labelFormat != '')
        ? axis.labelFormat.replaceAll(RegExp('{value}'), text.toString())
        : text.toString()) as String;
  }

  /// Calculate the dateTime format.
  DateFormat? _dateTimeFormat(DateTimeIntervalType? actualIntervalType,
      int? interval, int? prevInterval) {
    final DateTime minimum = DateTime.fromMillisecondsSinceEpoch(interval!);
    final DateTime maximum = DateTime.fromMillisecondsSinceEpoch(prevInterval!);
    DateFormat? format;
    final bool isIntervalDecimal = interval % 1 == 0;
    if (actualIntervalType == DateTimeIntervalType.months) {
      format = minimum.year == maximum.year
          ? (isIntervalDecimal ? DateFormat.MMM() : DateFormat.MMMd())
          : DateFormat('yyy MMM');
    } else if (actualIntervalType == DateTimeIntervalType.days) {
      format = minimum.month != maximum.month
          ? (isIntervalDecimal ? DateFormat.MMMd() : DateFormat.MEd())
          : DateFormat.d();
    }

    return format;
  }

  /// Returns the first label format for date time values.
  DateFormat? _firstLabelFormat(DateTimeIntervalType? actualIntervalType) {
    DateFormat? format;

    if (actualIntervalType == DateTimeIntervalType.months) {
      format = DateFormat('yyy MMM');
    } else if (actualIntervalType == DateTimeIntervalType.days) {
      format = DateFormat.MMMd();
    } else if (actualIntervalType == DateTimeIntervalType.minutes) {
      format = DateFormat.Hm();
    }

    return format;
  }

  /// Find logarithmic values.
  num _calculateLogBaseValue(num value, num base) => log(value) / log(base);
}

/// Render the annotation widget in the respective position.
class TrackballTemplateRenderBox extends RenderShiftedBox {
  /// Creates an instance of trackball template render box.
  TrackballTemplateRenderBox(
      this._template, this.xPos, this.yPos, this.trackballBehavior,
      [this.chartPointInfo, this.index, RenderBox? child])
      : super(child);

  Widget _template;

  /// Holds the value of x and y position.
  double xPos, yPos;

  /// Specifies the list of chart point info.
  List<ChartPointInfo>? chartPointInfo;

  /// Holds the value of index.
  int? index;

  /// Holds the value of pointer length and pointer width respectively.
  late double pointerLength, pointerWidth;

  /// Holds the value of trackball template rect.
  Rect? trackballTemplateRect;

  /// Holds the value of boundary rect.
  late Rect boundaryRect;

  /// Specifies the value of padding.
  num padding = 10;

  /// Specifies the value of trackball behavior.
  TrackballBehavior trackballBehavior;

  /// Specifies whether to group all the points.
  bool isGroupAllPoints = false;

  /// Specifies whether it is the nearest point.
  bool isNearestPoint = false;

  /// Gets the template widget.
  Widget get template => _template;

  /// Specifies whether tooltip is present at right.
  bool isRight = false;

  /// Specifies whether tooltip is present at bottom.
  bool isBottom = false;

  /// Specifies whether the template is present inside the bounds.
  bool isTemplateInBounds = true;
  // Offset arrowOffset;

  /// Holds the tooltip position.
  TooltipPositions? tooltipPosition;

  /// Holds the value of box parent data.
  late BoxParentData childParentData;

  /// Sets the template value.
  set template(Widget value) {
    if (_template != value) {
      _template = value;
      markNeedsLayout();
    }
  }

  bool isTransposed = false;

  @override
  void performLayout() {
    isTransposed = chartPointInfo != null &&
        chartPointInfo!.isNotEmpty &&
        chartPointInfo![0].series!.isTransposed;
    isGroupAllPoints = trackballBehavior.tooltipDisplayMode ==
        TrackballDisplayMode.groupAllPoints;
    isNearestPoint = trackballBehavior.tooltipDisplayMode ==
        TrackballDisplayMode.nearestPoint;
    final List<num>? tooltipTop = <num>[];
    final List<num> tooltipBottom = <num>[];
    final List<ClosestPoints> visiblePoints = trackballBehavior.visiblePoints;
    final List<RenderChartAxis> xAxesInfo = trackballBehavior.xAxesInfo;
    final List<RenderChartAxis> yAxesInfo = trackballBehavior.yAxesInfo;
    boundaryRect = trackballBehavior.boundaryRect;
    final num totalWidth = boundaryRect.left + boundaryRect.width;
    tooltipPosition = trackballBehavior.tooltipPosition;
    final bool isTrackballMarkerEnabled =
        trackballBehavior.markerSettings != null;
    final BoxConstraints constraints = this.constraints;
    pointerLength = trackballBehavior.tooltipSettings.arrowLength;
    pointerWidth = trackballBehavior.tooltipSettings.arrowWidth;
    double left, top;
    Offset? offset;
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(Size(child!.size.width, child!.size.height));
      if (child!.parentData is BoxParentData) {
        childParentData = child!.parentData as BoxParentData;

        if (isGroupAllPoints) {
          if (trackballBehavior.tooltipAlignment == ChartAlignment.center) {
            yPos = boundaryRect.center.dy - size.height / 2;
          } else if (trackballBehavior.tooltipAlignment ==
              ChartAlignment.near) {
            yPos = boundaryRect.top;
          } else {
            yPos = boundaryRect.bottom;
          }

          if (yPos + size.height > boundaryRect.bottom &&
              trackballBehavior.tooltipAlignment == ChartAlignment.far) {
            yPos = boundaryRect.bottom - size.height;
          }
        }
        if (chartPointInfo != null && !isGroupAllPoints) {
          for (int index = 0; index < chartPointInfo!.length; index++) {
            tooltipTop!.add(isTransposed
                ? visiblePoints[index].closestPointX - (size.width / 2)
                : visiblePoints[index].closestPointY - size.height / 2);
            tooltipBottom.add(isTransposed
                ? visiblePoints[index].closestPointX + (size.width / 2)
                : visiblePoints[index].closestPointY + size.height / 2);
            xAxesInfo.add(chartPointInfo![index].series!.xAxis!);
            yAxesInfo.add(chartPointInfo![index].series!.yAxis!);
          }
        }
        if (tooltipTop != null && tooltipTop.isNotEmpty) {
          tooltipPosition = trackballBehavior._smartTooltipPositions(
              tooltipTop,
              tooltipBottom,
              xAxesInfo,
              yAxesInfo,
              chartPointInfo!,
              isTransposed);
        }

        if (!isGroupAllPoints) {
          left = (isTransposed
                  ? tooltipPosition!.tooltipTop[index!]
                  : xPos +
                      padding +
                      (isTrackballMarkerEnabled
                          ? trackballBehavior.markerSettings!.width / 2
                          : 0))
              .toDouble();
          top = (isTransposed
                  ? yPos +
                      pointerLength +
                      (isTrackballMarkerEnabled
                          ? trackballBehavior.markerSettings!.width / 2
                          : 0)
                  : tooltipPosition!.tooltipTop[index!])
              .toDouble();

          if (isNearestPoint) {
            left = isTransposed
                ? xPos + size.width / 2
                : xPos +
                    padding +
                    (isTrackballMarkerEnabled
                        ? trackballBehavior.markerSettings!.width / 2
                        : 0);
            top = isTransposed
                ? yPos +
                    padding +
                    (isTrackballMarkerEnabled
                        ? trackballBehavior.markerSettings!.width / 2
                        : 0)
                : yPos - size.height / 2;
          }

          if (!isTransposed) {
            if (left + size.width > totalWidth) {
              isRight = true;
              left = xPos -
                  size.width -
                  pointerLength -
                  (isTrackballMarkerEnabled
                      ? (trackballBehavior.markerSettings!.width / 2)
                      : 0);
            } else {
              isRight = false;
            }
          } else {
            if (top + size.height > boundaryRect.bottom) {
              isBottom = true;
              top = yPos -
                  pointerLength -
                  size.height -
                  (isTrackballMarkerEnabled
                      ? (trackballBehavior.markerSettings!.height)
                      : 0);
            } else {
              isBottom = false;
            }
          }
          trackballTemplateRect =
              Rect.fromLTWH(left, top, size.width, size.height);
          double xPlotOffset = visiblePoints.first.closestPointX -
              trackballTemplateRect!.width / 2;
          final double rightTemplateEnd =
              xPlotOffset + trackballTemplateRect!.width;
          final double leftTemplateEnd = xPlotOffset;

          if (_isTemplateWithinBounds(
              boundaryRect, trackballTemplateRect!, offset)) {
            isTemplateInBounds = true;
            childParentData.offset = Offset(left, top);
          } else if (boundaryRect.width > trackballTemplateRect!.width &&
              boundaryRect.height > trackballTemplateRect!.height) {
            isTemplateInBounds = true;
            if (rightTemplateEnd > boundaryRect.right) {
              xPlotOffset =
                  xPlotOffset - (rightTemplateEnd - boundaryRect.right);
              if (xPlotOffset < boundaryRect.left) {
                xPlotOffset = xPlotOffset + (boundaryRect.left - xPlotOffset);
                if (xPlotOffset + trackballTemplateRect!.width >
                    boundaryRect.right) {
                  xPlotOffset = xPlotOffset -
                      (totalWidth +
                          trackballTemplateRect!.width -
                          boundaryRect.right);
                }
                if (xPlotOffset < boundaryRect.left ||
                    xPlotOffset > boundaryRect.right) {
                  isTemplateInBounds = false;
                }
              }
            } else if (leftTemplateEnd < boundaryRect.left) {
              xPlotOffset = xPlotOffset + (boundaryRect.left - leftTemplateEnd);
              if (xPlotOffset + trackballTemplateRect!.width >
                  boundaryRect.right) {
                xPlotOffset = xPlotOffset -
                    (totalWidth +
                        trackballTemplateRect!.width -
                        boundaryRect.right);
                if (xPlotOffset < boundaryRect.left) {
                  xPlotOffset = xPlotOffset + (boundaryRect.left - xPlotOffset);
                }
                if (xPlotOffset < boundaryRect.left ||
                    xPlotOffset + trackballTemplateRect!.width >
                        boundaryRect.right) {
                  isTemplateInBounds = false;
                }
              }
            }
            childParentData.offset = Offset(xPlotOffset, yPos);
          } else {
            child!.layout(constraints.copyWith(maxWidth: 0),
                parentUsesSize: true);
            isTemplateInBounds = false;
          }
        } else {
          if (xPos + size.width > totalWidth) {
            xPos = xPos -
                size.width -
                2 * padding -
                (isTrackballMarkerEnabled
                    ? trackballBehavior.markerSettings!.width / 2
                    : 0);
          }

          trackballTemplateRect =
              Rect.fromLTWH(xPos, yPos, size.width, size.height);
          double xPlotOffset = visiblePoints.first.closestPointX -
              trackballTemplateRect!.width / 2;
          final double rightTemplateEnd =
              xPlotOffset + trackballTemplateRect!.width;
          final double leftTemplateEnd = xPlotOffset;

          if (_isTemplateWithinBounds(
                  boundaryRect, trackballTemplateRect!, offset) &&
              (boundaryRect.right > trackballTemplateRect!.right &&
                  boundaryRect.left < trackballTemplateRect!.left)) {
            isTemplateInBounds = true;
            childParentData.offset = Offset(
                xPos +
                    (trackballTemplateRect!.right + padding > boundaryRect.right
                        ? trackballTemplateRect!.right +
                            padding -
                            boundaryRect.right
                        : padding) +
                    (isTrackballMarkerEnabled
                        ? trackballBehavior.markerSettings!.width / 2
                        : 0),
                yPos);
          } else if (boundaryRect.width > trackballTemplateRect!.width &&
              boundaryRect.height > trackballTemplateRect!.height) {
            isTemplateInBounds = true;
            if (rightTemplateEnd > boundaryRect.right) {
              xPlotOffset =
                  xPlotOffset - (rightTemplateEnd - boundaryRect.right);
              if (xPlotOffset < boundaryRect.left) {
                xPlotOffset = xPlotOffset + (boundaryRect.left - xPlotOffset);
                if (xPlotOffset + trackballTemplateRect!.width >
                    boundaryRect.right) {
                  xPlotOffset = xPlotOffset -
                      (totalWidth +
                          trackballTemplateRect!.width -
                          boundaryRect.right);
                }
                if (xPlotOffset < boundaryRect.left ||
                    xPlotOffset > boundaryRect.right) {
                  isTemplateInBounds = false;
                }
              }
            } else if (leftTemplateEnd < boundaryRect.left) {
              xPlotOffset = xPlotOffset + (boundaryRect.left - leftTemplateEnd);
              if (xPlotOffset + trackballTemplateRect!.width >
                  boundaryRect.right) {
                xPlotOffset = xPlotOffset -
                    (xPlotOffset +
                        trackballTemplateRect!.width -
                        boundaryRect.right);
                if (xPlotOffset < boundaryRect.left) {
                  xPlotOffset = xPlotOffset + (boundaryRect.left - xPlotOffset);
                }
                if (xPlotOffset < boundaryRect.left ||
                    xPlotOffset > boundaryRect.right) {
                  isTemplateInBounds = false;
                }
              }
            }
            childParentData.offset = Offset(xPlotOffset, yPos);
          } else {
            child!.layout(constraints.copyWith(maxWidth: 0),
                parentUsesSize: true);
            isTemplateInBounds = false;
          }
        }
      }
    } else {
      size = Size.zero;
    }
    if (!isGroupAllPoints && index == chartPointInfo!.length - 1) {
      tooltipTop?.clear();
      tooltipBottom.clear();
      yAxesInfo.clear();
      xAxesInfo.clear();
    }
  }

  /// To check template is within bounds.
  bool _isTemplateWithinBounds(Rect bounds, Rect templateRect, Offset? offset) {
    final Rect rect = Rect.fromLTWH(
        padding + templateRect.left,
        (3 * padding) + templateRect.top,
        templateRect.width,
        templateRect.height);
    final Rect axisBounds = Rect.fromLTWH(padding + bounds.left,
        (3 * padding) + bounds.top, bounds.width, bounds.height);
    return rect.left >= axisBounds.left &&
        rect.left + rect.width <= axisBounds.left + axisBounds.width &&
        rect.top >= axisBounds.top &&
        rect.bottom <= axisBounds.top + axisBounds.height;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (isGroupAllPoints) {
      for (int i = 0; i < chartPointInfo!.length; i++) {
        trackballBehavior._renderEachMarkers(context.canvas, i);
      }
    } else {
      trackballBehavior._renderEachMarkers(context.canvas, index!);
    }
    final bool isTemplateWithInBoundsInTransposedChart =
        _isTemplateWithinBounds(boundaryRect, trackballTemplateRect!, offset);
    if ((!isTransposed && isTemplateInBounds) ||
        (isTransposed && isTemplateWithInBoundsInTransposedChart)) {
      super.paint(context, offset);
    }

    if (!isGroupAllPoints) {
      final Rect templateRect = Rect.fromLTWH(
          offset.dx + trackballTemplateRect!.left,
          offset.dy + trackballTemplateRect!.top,
          trackballTemplateRect!.width,
          trackballTemplateRect!.height);
      final Paint fillPaint = Paint()
        ..color = trackballBehavior.tooltipSettings.color ??
            (chartPointInfo![index!].series is IndicatorRenderer
                ? chartPointInfo![index!].color
                : (chartPointInfo![index!].series!.color) ??
                    trackballBehavior._chartTheme!.crosshairBackgroundColor)
        ..isAntiAlias = true
        ..style = PaintingStyle.fill;
      final Paint strokePaint = Paint()
        ..color = trackballBehavior.tooltipSettings.borderColor ??
            (chartPointInfo![index!].series is IndicatorRenderer
                ? chartPointInfo![index!].color
                : (chartPointInfo![index!].series!.color) ??
                    trackballBehavior._chartTheme!.crosshairBackgroundColor)
        ..strokeWidth = trackballBehavior.tooltipSettings.borderWidth
        ..strokeCap = StrokeCap.butt
        ..isAntiAlias = true
        ..style = PaintingStyle.stroke;
      final Path path = Path();
      if (trackballTemplateRect!.left > boundaryRect.left &&
          trackballTemplateRect!.right < boundaryRect.right) {
        if (!isTransposed) {
          if (!isRight) {
            path.moveTo(templateRect.left,
                templateRect.top + templateRect.height / 2 - pointerWidth);
            path.lineTo(templateRect.left,
                templateRect.bottom - templateRect.height / 2 + pointerWidth);
            path.lineTo(templateRect.left - pointerLength, yPos + offset.dy);
            path.lineTo(templateRect.left,
                templateRect.top + templateRect.height / 2 - pointerWidth);
          } else {
            path.moveTo(templateRect.right,
                templateRect.top + templateRect.height / 2 - pointerWidth);
            path.lineTo(templateRect.right,
                templateRect.bottom - templateRect.height / 2 + pointerWidth);
            path.lineTo(templateRect.right + pointerLength, yPos + offset.dy);
            path.lineTo(templateRect.right,
                templateRect.top + templateRect.height / 2 - pointerWidth);
          }
        } else if (isTemplateInBounds &&
            isTemplateWithInBoundsInTransposedChart) {
          if (!isBottom) {
            path.moveTo(
                templateRect.left + templateRect.width / 2 + pointerWidth,
                templateRect.top);
            path.lineTo(
                templateRect.right - templateRect.width / 2 - pointerWidth,
                templateRect.top);
            path.lineTo(xPos + offset.dx, yPos + offset.dy);
          } else {
            path.moveTo(
                templateRect.left + templateRect.width / 2 + pointerWidth,
                templateRect.bottom);
            path.lineTo(
                templateRect.right - templateRect.width / 2 - pointerWidth,
                templateRect.bottom);
            path.lineTo(xPos + offset.dx, yPos + offset.dy);
          }
        }

        if (isTemplateInBounds) {
          context.canvas.drawPath(path, fillPaint);
          context.canvas.drawPath(path, strokePaint);
        }
      }
    }
  }
}

/// This class has the properties of the crosshair behavior.
///
/// Crosshair behavior has the activation mode and line type property to set
/// the behavior of the crosshair. It also has the property to customize
/// the appearance.
///
/// Provide options for activation mode, line type, line color, line width,
/// hide delay for customizing the behavior of the crosshair.
class CrosshairBehavior extends ChartBehavior {
  /// Creating an argument constructor of [CrosshairBehavior] class.
  CrosshairBehavior({
    this.activationMode = ActivationMode.longPress,
    this.lineType = CrosshairLineType.both,
    this.lineDashArray,
    this.enable = false,
    this.lineColor,
    this.lineWidth = 1,
    this.shouldAlwaysShow = false,
    this.hideDelay = 0,
  });

  /// Toggles the visibility of the crosshair.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late CrosshairBehavior _crosshairBehavior;
  ///
  /// void initState() {
  ///   _crosshairBehavior = CrosshairBehavior(enable: true);
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     crosshairBehavior: _crosshairBehavior
  ///   );
  /// }
  /// ```
  final bool enable;

  /// Width of the crosshair line.
  ///
  /// Defaults to `1`.
  ///
  /// ```dart
  /// late CrosshairBehavior _crosshairBehavior;
  ///
  /// void initState() {
  ///   _crosshairBehavior = CrosshairBehavior(
  ///     enable: true,
  ///     lineWidth: 5
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     crosshairBehavior: _crosshairBehavior
  ///   );
  /// }
  /// ```
  final double lineWidth;

  /// Color of the crosshair line.
  ///
  /// Color will be applied based on the brightness
  /// property of the app.
  ///
  /// ```dart
  /// late CrosshairBehavior _crosshairBehavior;
  ///
  /// void initState() {
  ///   _crosshairBehavior = CrosshairBehavior(
  ///      enable: true,lineColor: Colors.red
  ///    );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     crosshairBehavior: _crosshairBehavior
  ///   );
  /// }
  /// ```
  final Color? lineColor;

  /// Dashes of the crosshair line.
  ///
  /// Any number of values can be provided in the list.
  /// Odd value is considered as rendering size and even value is
  /// considered as gap.
  ///
  /// Defaults to `[0,0]`.
  ///
  /// ```dart
  /// late CrosshairBehavior _crosshairBehavior;
  ///
  /// void initState() {
  ///   _crosshairBehavior = CrosshairBehavior(
  ///     enable: true,
  ///     lineDashArray: [10,10]
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     crosshairBehavior: _crosshairBehavior
  ///   );
  /// }
  /// ```
  final List<double>? lineDashArray;

  /// Gesture for activating the crosshair.
  ///
  /// Crosshair can be activated in tap, double tap
  /// and long press.
  ///
  /// Defaults to `ActivationMode.longPress`.
  ///
  /// Also refer [ActivationMode].
  ///
  /// ```dart
  /// late CrosshairBehavior _crosshairBehavior;
  ///
  /// void initState() {
  ///   _crosshairBehavior = CrosshairBehavior(
  ///     enable: true,
  ///     activationMode: ActivationMode.doubleTap
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     crosshairBehavior: _crosshairBehavior
  ///   );
  /// }
  /// ```
  final ActivationMode activationMode;

  /// Type of crosshair line.
  ///
  /// By default, both vertical and horizontal lines will be
  /// displayed. You can change this by specifying values to this property.
  ///
  /// Defaults to `CrosshairLineType.both`.
  ///
  /// Also refer [CrosshairLineType].
  ///
  /// ```dart
  /// late CrosshairBehavior _crosshairBehavior;
  ///
  /// void initState() {
  ///   _crosshairBehavior = CrosshairBehavior(
  ///     enable: true,
  ///     lineType: CrosshairLineType.horizontal
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     crosshairBehavior: _crosshairBehavior
  ///   );
  /// }
  /// ```
  final CrosshairLineType lineType;

  /// Enables or disables the crosshair.
  ///
  /// By default, the crosshair will be hidden on touch.
  /// To avoid this, set this property to true.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late CrosshairBehavior _crosshairBehavior;
  ///
  /// void initState() {
  ///   _crosshairBehavior = CrosshairBehavior(
  ///     enable: true,
  ///     shouldAlwaysShow: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     crosshairBehavior: _crosshairBehavior
  ///   );
  /// }
  /// ```
  final bool shouldAlwaysShow;

  /// Time delay for hiding the crosshair.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// late CrosshairBehavior _crosshairBehavior;
  ///
  /// void initState() {
  ///   _crosshairBehavior = CrosshairBehavior(
  ///     enable: true,
  ///     hideDelay: 3000
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     crosshairBehavior: _crosshairBehavior
  ///   );
  /// }
  /// ```
  final double hideDelay;

  /// Hold crosshair target position.
  Offset? _position;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is CrosshairBehavior &&
        other.activationMode == activationMode &&
        other.lineType == lineType &&
        other.lineDashArray == lineDashArray &&
        other.enable == enable &&
        other.lineColor == lineColor &&
        other.lineWidth == lineWidth &&
        other.shouldAlwaysShow == shouldAlwaysShow &&
        other.hideDelay == hideDelay;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    final List<Object?> values = <Object?>[
      activationMode,
      lineType,
      lineDashArray,
      enable,
      lineColor,
      lineWidth,
      shouldAlwaysShow,
      hideDelay
    ];
    return Object.hashAll(values);
  }

  /// Displays the crosshair at the specified x and y-positions.
  ///
  /// x & y - x and y values/pixel where the crosshair needs to be shown.
  ///
  /// coordinateUnit - specify the type of x and y values given. `pixel` or
  /// `point` for logical pixel and chart data point respectively.
  ///
  /// Defaults to `point`.
  void show(dynamic x, double y, [String coordinateUnit = 'point']) {
    assert(x != null);
    assert(!y.isNaN);
    if (coordinateUnit == 'point') {
      final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
      if (parent != null) {
        _position = rawValueToPixelPoint(
            x, y, parent.xAxis, parent.yAxis, parent.isTransposed);
      }
    } else if (coordinateUnit == 'pixel') {
      _position = Offset(x.toDouble(), y);
    }
    (parentBox as RenderBehaviorArea?)?.invalidate();
  }

  /// Displays the crosshair at the specified point index.
  ///
  /// pointIndex - index of point at which the crosshair needs to be shown.
  void showByIndex(int pointIndex) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent != null && parent.plotArea != null) {
      final XyDataSeriesRenderer? seriesRenderer =
          parent.plotArea!.firstChild as XyDataSeriesRenderer?;
      if (seriesRenderer != null) {
        final List<num> visibleIndexes = seriesRenderer.visibleIndexes;
        if (visibleIndexes.first <= pointIndex &&
            pointIndex <= visibleIndexes.last) {
          show(seriesRenderer.xRawValues[pointIndex],
              seriesRenderer.yValues[pointIndex].toDouble());
        }
      }
    }
  }

  /// Hides the crosshair if it is displayed.
  void hide() {
    _position = null;
    (parentBox as RenderBehaviorArea?)?.invalidate();
  }

  void _onPaint(
    PaintingContext context,
    Offset offset,
    RenderBox parentBox,
    SfChartThemeData chartThemeData,
    RenderCartesianAxes? cartesianAxes,
  ) {
    if (_position == null) {
      return;
    }

    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }

    final RenderCartesianAxes? cartesianAxes = parent.cartesianAxes;
    if (cartesianAxes == null) {
      return;
    }

    final Rect plotAreaBounds = parent.paintBounds;
    if (plotAreaBounds.contains(offset)) {
      _drawLines(context, offset, lineType, parentBox, chartThemeData);

      final Paint fillPaint = Paint()..isAntiAlias = true;
      final Paint strokePaint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.stroke;

      final Offset plotAreaOffset =
          (parent.parentData! as BoxParentData).offset;
      RenderChartAxis? child = cartesianAxes.firstChild;
      while (child != null) {
        if (child.interactiveTooltip.enable) {
          final TextStyle textStyle = child.chartThemeData!.crosshairTextStyle!
              .merge(child.interactiveTooltip.textStyle);
          fillPaint.color = child.interactiveTooltip.color ??
              chartThemeData.crosshairBackgroundColor;
          strokePaint
            ..color = child.interactiveTooltip.borderColor ??
                chartThemeData.crosshairBackgroundColor
            ..strokeWidth = child.interactiveTooltip.borderWidth;

          if (child.isVertical) {
            if (child.opposedPosition) {
              _drawRightAxisTooltip(context.canvas, offset, strokePaint,
                  fillPaint, plotAreaBounds, child, textStyle, plotAreaOffset);
            } else {
              _drawLeftAxisTooltip(context.canvas, offset, strokePaint,
                  fillPaint, plotAreaBounds, child, textStyle, plotAreaOffset);
            }
          } else {
            if (child.opposedPosition) {
              _drawTopAxisTooltip(context.canvas, offset, strokePaint,
                  fillPaint, plotAreaBounds, child, textStyle, plotAreaOffset);
            } else {
              _drawBottomAxisTooltip(context.canvas, offset, strokePaint,
                  fillPaint, plotAreaBounds, child, textStyle, plotAreaOffset);
            }
          }
        }

        final CartesianAxesParentData childParentData =
            child.parentData! as CartesianAxesParentData;
        child = childParentData.nextSibling;
      }
    }
  }

  void _drawLines(
    PaintingContext context,
    Offset offset,
    CrosshairLineType lineType,
    RenderBox parentBox,
    SfChartThemeData chartThemeData,
  ) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..color = lineColor ?? chartThemeData.crosshairLineColor
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    final Rect bounds = parentBox.paintBounds;
    switch (lineType) {
      case CrosshairLineType.both:
        _drawLines(context, offset, CrosshairLineType.horizontal, parentBox,
            chartThemeData);
        _drawLines(context, offset, CrosshairLineType.vertical, parentBox,
            chartThemeData);
        break;

      case CrosshairLineType.horizontal:
        final Offset start = Offset(bounds.left, offset.dy);
        final Offset end = Offset(bounds.right, offset.dy);
        drawDashes(context.canvas, lineDashArray, paint,
            start: start, end: end);
        break;

      case CrosshairLineType.vertical:
        final Offset start = Offset(offset.dx, bounds.top);
        final Offset end = Offset(offset.dx, bounds.bottom);
        drawDashes(context.canvas, lineDashArray, paint,
            start: start, end: end);
        break;

      case CrosshairLineType.none:
        break;
    }
  }

  /// Draw left axis tooltip.
  void _drawLeftAxisTooltip(
      Canvas canvas,
      Offset position,
      Paint strokePaint,
      Paint fillPaint,
      Rect plotAreaBounds,
      RenderChartAxis? cartesianAxis,
      TextStyle textStyle,
      Offset plotAreaOffset) {
    final InteractiveTooltip interactiveTooltip =
        cartesianAxis!.interactiveTooltip;
    final Offset parentDataOffset =
        (cartesianAxis.parentData! as BoxParentData).offset;
    final Offset axisOffset =
        parentDataOffset.translate(-plotAreaOffset.dx, -plotAreaOffset.dy);
    final Rect axisRect = axisOffset & cartesianAxis.size;
    const int padding = 10;
    final Path backgroundPath = Path();
    final String label = _getYValue(cartesianAxis, position);

    _triggerCrosshairCallback(label, cartesianAxis);
    final Size labelSize = measureText(label, textStyle);
    Rect labelRect = Rect.fromLTWH(
        axisRect.right -
            (labelSize.width + padding) -
            interactiveTooltip.arrowLength,
        position.dy - (labelSize.height + padding) / 2,
        labelSize.width + padding,
        labelSize.height + padding);
    labelRect = _validateRectBounds(labelRect, axisRect);
    final Rect validatedRect =
        _validateRectYPosition(labelRect, plotAreaBounds);
    backgroundPath.reset();
    final RRect tooltipRect = RRect.fromRectAndRadius(
        validatedRect, Radius.circular(interactiveTooltip.borderRadius));
    backgroundPath.addRRect(tooltipRect);
    _drawTooltipArrowhead(
        canvas,
        backgroundPath,
        fillPaint,
        strokePaint,
        tooltipRect.right,
        tooltipRect.top +
            tooltipRect.height / 2 -
            interactiveTooltip.arrowWidth,
        tooltipRect.right,
        tooltipRect.bottom -
            tooltipRect.height / 2 +
            interactiveTooltip.arrowWidth,
        tooltipRect.right + interactiveTooltip.arrowLength,
        position.dy,
        tooltipRect.right + interactiveTooltip.arrowLength,
        position.dy);
    _drawTooltipText(canvas, label, textStyle, tooltipRect, labelSize);
  }

  /// Draw top axis tooltip.
  void _drawTopAxisTooltip(
      Canvas canvas,
      Offset position,
      Paint strokePaint,
      Paint fillPaint,
      Rect plotAreaBounds,
      RenderChartAxis? cartesianAxis,
      TextStyle textStyle,
      Offset plotAreaOffset) {
    final Offset parentDataOffset =
        (cartesianAxis!.parentData! as BoxParentData).offset;
    final Offset axisOffset =
        parentDataOffset.translate(-plotAreaOffset.dx, -plotAreaOffset.dy);
    final Rect axisRect = axisOffset & cartesianAxis.size;
    final InteractiveTooltip interactiveTooltip =
        cartesianAxis.interactiveTooltip;
    final Path backgroundPath = Path();
    const int padding = 10;
    final String label = _getXValue(cartesianAxis, position, plotAreaBounds);

    _triggerCrosshairCallback(label, cartesianAxis);
    final Size labelSize = measureText(label, textStyle);
    Rect labelRect = Rect.fromLTWH(
        position.dx - (labelSize.width / 2 + padding / 2),
        axisRect.bottom -
            (labelSize.height + padding) -
            interactiveTooltip.arrowLength,
        labelSize.width + padding,
        labelSize.height + padding);
    labelRect = _validateRectBounds(labelRect, axisRect);
    final Rect validatedRect =
        _validateRectXPosition(labelRect, plotAreaBounds);
    backgroundPath.reset();
    final RRect tooltipRect = RRect.fromRectAndRadius(
        validatedRect, Radius.circular(interactiveTooltip.borderRadius));
    backgroundPath.addRRect(tooltipRect);
    _drawTooltipArrowhead(
      canvas,
      backgroundPath,
      fillPaint,
      strokePaint,
      position.dx,
      tooltipRect.bottom + interactiveTooltip.arrowLength,
      (tooltipRect.right - tooltipRect.width / 2) +
          interactiveTooltip.arrowWidth,
      tooltipRect.bottom,
      (tooltipRect.left + tooltipRect.width / 2) -
          interactiveTooltip.arrowWidth,
      tooltipRect.bottom,
      position.dx,
      tooltipRect.bottom + interactiveTooltip.arrowLength,
    );
    _drawTooltipText(canvas, label, textStyle, tooltipRect, labelSize);
  }

  /// Draw right axis tooltip.
  void _drawRightAxisTooltip(
      Canvas canvas,
      Offset position,
      Paint strokePaint,
      Paint fillPaint,
      Rect plotAreaBounds,
      RenderChartAxis? cartesianAxis,
      TextStyle textStyle,
      Offset plotAreaOffset) {
    final Offset parentDataOffset =
        (cartesianAxis!.parentData! as BoxParentData).offset;
    final Offset axisOffset =
        parentDataOffset.translate(-plotAreaOffset.dx, -plotAreaOffset.dy);
    final Rect axisRect = axisOffset & cartesianAxis.size;
    final InteractiveTooltip interactiveTooltip =
        cartesianAxis.interactiveTooltip;
    const int padding = 10;
    final Path backgroundPath = Path();
    final String label = _getYValue(cartesianAxis, position);

    _triggerCrosshairCallback(label, cartesianAxis);
    final Size labelSize = measureText(label, textStyle);
    Rect labelRect = Rect.fromLTWH(
        axisRect.left + interactiveTooltip.arrowLength,
        position.dy - (labelSize.height / 2 + padding / 2),
        labelSize.width + padding,
        labelSize.height + padding);
    labelRect = _validateRectBounds(labelRect, axisRect);
    final Rect validatedRect =
        _validateRectYPosition(labelRect, plotAreaBounds);
    backgroundPath.reset();
    final RRect tooltipRect = RRect.fromRectAndRadius(
        validatedRect, Radius.circular(interactiveTooltip.borderRadius));
    backgroundPath.addRRect(tooltipRect);
    _drawTooltipArrowhead(
        canvas,
        backgroundPath,
        fillPaint,
        strokePaint,
        tooltipRect.left,
        tooltipRect.top +
            tooltipRect.height / 2 -
            interactiveTooltip.arrowWidth,
        tooltipRect.left,
        tooltipRect.bottom -
            tooltipRect.height / 2 +
            interactiveTooltip.arrowWidth,
        tooltipRect.left - interactiveTooltip.arrowLength,
        position.dy,
        tooltipRect.left - interactiveTooltip.arrowLength,
        position.dy);
    _drawTooltipText(canvas, label, textStyle, tooltipRect, labelSize);
  }

  void _drawBottomAxisTooltip(
      Canvas canvas,
      Offset position,
      Paint strokePaint,
      Paint fillPaint,
      Rect plotAreaBounds,
      RenderChartAxis? axis,
      TextStyle textStyle,
      Offset plotAreaOffset) {
    final InteractiveTooltip interactiveTooltip = axis!.interactiveTooltip;
    final Offset parentDataOffset = (axis.parentData! as BoxParentData).offset;
    final Offset axisOffset =
        parentDataOffset.translate(-plotAreaOffset.dx, -plotAreaOffset.dy);
    final Rect axisBounds = axisOffset & axis.size;

    const int padding = 10;
    final Path backgroundPath = Path();
    final String label = _getXValue(axis, position, plotAreaBounds);

    _triggerCrosshairCallback(label, axis);
    final Size labelSize = measureText(
      label,
      textStyle,
    );
    Rect labelRect = Rect.fromLTWH(
        position.dx - (labelSize.width / 2 + padding / 2),
        axisBounds.top + interactiveTooltip.arrowLength,
        labelSize.width + padding,
        labelSize.height + padding);
    labelRect = _validateRectBounds(labelRect, axisBounds);
    final Rect validatedRect =
        _validateRectXPosition(labelRect, plotAreaBounds);
    final RRect tooltipRect = RRect.fromRectAndRadius(
        validatedRect, Radius.circular(interactiveTooltip.borderRadius));
    backgroundPath.addRRect(tooltipRect);
    _drawTooltipArrowhead(
        canvas,
        backgroundPath,
        fillPaint,
        strokePaint,
        position.dx,
        tooltipRect.top - interactiveTooltip.arrowLength,
        (tooltipRect.right - tooltipRect.width / 2) +
            interactiveTooltip.arrowWidth,
        tooltipRect.top,
        (tooltipRect.left + tooltipRect.width / 2) -
            interactiveTooltip.arrowWidth,
        tooltipRect.top,
        position.dx,
        tooltipRect.top - interactiveTooltip.arrowLength);
    _drawTooltipText(canvas, label, textStyle, tooltipRect, labelSize);
  }

  void _drawTooltipText(Canvas canvas, String text, TextStyle textStyle,
      RRect tooltipRect, Size labelSize) {
    _drawText(canvas, text, _textPosition(tooltipRect, labelSize),
        textStyle.copyWith(color: textStyle.color ?? Colors.white), 0);
  }

  Offset _textPosition(RRect tooltipRect, Size labelSize) {
    return Offset(
        (tooltipRect.left + tooltipRect.width / 2) - labelSize.width / 2,
        (tooltipRect.top + tooltipRect.height / 2) - labelSize.height / 2);
  }

  void _drawText(Canvas canvas, String text, Offset point, TextStyle style,
      [int? angle, bool? isRtl]) {
    final int maxLines = getMaxLinesContent(text);
    final TextSpan span = TextSpan(text: text, style: style);
    final TextPainter tp = TextPainter(
        text: span,
        textDirection: (isRtl ?? false)
            ? dart_ui.TextDirection.rtl
            : dart_ui.TextDirection.ltr,
        textAlign: TextAlign.center,
        maxLines: maxLines);
    tp.layout();
    canvas.save();
    canvas.translate(point.dx, point.dy);
    Offset labelOffset = Offset.zero;
    if (angle != null && angle > 0) {
      canvas.rotate(degreeToRadian(angle));
      labelOffset = Offset(-tp.width / 2, -tp.height / 2);
    }
    tp.paint(canvas, labelOffset);
    canvas.restore();
  }

  Rect _validateRectBounds(Rect tooltipRect, Rect boundary) {
    /// Padding between the corners.
    const double padding = 0.5;
    Rect validatedRect = tooltipRect;
    double difference = 0;

    if (tooltipRect.left < boundary.left) {
      difference = (boundary.left - tooltipRect.left) + padding;
      validatedRect = validatedRect.translate(difference, 0);
    }
    if (tooltipRect.right > boundary.right) {
      difference = (tooltipRect.right - boundary.right) + padding;
      validatedRect = validatedRect.translate(-difference, 0);
    }
    if (tooltipRect.top < boundary.top) {
      difference = (boundary.top - tooltipRect.top) + padding;
      validatedRect = validatedRect.translate(0, difference);
    }

    if (tooltipRect.bottom > boundary.bottom) {
      difference = (tooltipRect.bottom - boundary.bottom) + padding;
      validatedRect = validatedRect.translate(0, -difference);
    }
    return validatedRect;
  }

  Rect _validateRectYPosition(Rect labelRect, Rect axisClipRect) {
    Rect validatedRect = labelRect;
    if (labelRect.bottom >= axisClipRect.bottom) {
      validatedRect = Rect.fromLTRB(
          labelRect.left,
          labelRect.top - (labelRect.bottom - axisClipRect.bottom),
          labelRect.right,
          axisClipRect.bottom);
    } else if (labelRect.top <= axisClipRect.top) {
      validatedRect = Rect.fromLTRB(
          labelRect.left,
          axisClipRect.top,
          labelRect.right,
          labelRect.bottom + (axisClipRect.top - labelRect.top));
    }
    return validatedRect;
  }

  /// Gets the x position of validated rect.
  Rect _validateRectXPosition(Rect labelRect, Rect axisClipRect) {
    Rect validatedRect = labelRect;
    if (labelRect.right >= axisClipRect.right) {
      validatedRect = Rect.fromLTRB(
          labelRect.left - (labelRect.right - axisClipRect.right),
          labelRect.top,
          axisClipRect.right,
          labelRect.bottom);
    } else if (labelRect.left <= axisClipRect.left) {
      validatedRect = Rect.fromLTRB(
          axisClipRect.left,
          labelRect.top,
          labelRect.right + (axisClipRect.left - labelRect.left),
          labelRect.bottom);
    }
    return validatedRect;
  }

  /// Draw tooltip arrow head.
  void _drawTooltipArrowhead(
      Canvas canvas,
      Path backgroundPath,
      Paint fillPaint,
      Paint strokePaint,
      double x1,
      double y1,
      double x2,
      double y2,
      double x3,
      double y3,
      double x4,
      double y4) {
    backgroundPath.moveTo(x1, y1);
    backgroundPath.lineTo(x2, y2);
    backgroundPath.lineTo(x3, y3);
    backgroundPath.lineTo(x4, y4);
    backgroundPath.lineTo(x1, y1);
    fillPaint.isAntiAlias = true;
    canvas.drawPath(backgroundPath, strokePaint);
    canvas.drawPath(backgroundPath, fillPaint);
  }

  void _triggerCrosshairCallback(String label, RenderChartAxis axis) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }
    if (parent.onCrosshairPositionChanging != null &&
        parent.chartThemeData != null) {
      final CrosshairRenderArgs crosshairEventArgs = CrosshairRenderArgs(
          axis.widget, label, axis.name, AxisOrientation.horizontal);
      crosshairEventArgs.text = label;
      crosshairEventArgs.lineColor =
          lineColor ?? parent.chartThemeData!.crosshairLineColor;
      parent.onCrosshairPositionChanging!(crosshairEventArgs);
      label = crosshairEventArgs.text;
    }
  }

  /// To find the x value of crosshair.
  String _getXValue(
      RenderChartAxis axis, Offset position, Rect plotAreaBounds) {
    final num value = axis.pixelToPoint(axis.paintBounds,
        position.dx - plotAreaBounds.left, position.dy - plotAreaBounds.top);
    String resultantString =
        _getInteractiveTooltipLabel(value, axis).toString();
    if (axis.interactiveTooltip.format != null) {
      final String stringValue = axis.interactiveTooltip.format!
          .replaceAll('{value}', resultantString);
      resultantString = stringValue;
    }
    return resultantString;
  }

  /// To find the y value of crosshair.
  String _getYValue(RenderChartAxis axis, Offset position) {
    final num value =
        axis.pixelToPoint(axis.paintBounds, position.dx, position.dy);
    String resultantString =
        _getInteractiveTooltipLabel(value, axis).toString();
    if (axis.interactiveTooltip.format != null) {
      final String stringValue = axis.interactiveTooltip.format!
          .replaceAll('{value}', resultantString);
      resultantString = stringValue;
    }
    return resultantString;
  }

  /// To get interactive tooltip label.
  dynamic _getInteractiveTooltipLabel(num value, RenderChartAxis axis) {
    if (axis is RenderCategoryAxis) {
      final num index = value < 0 ? 0 : value;
      return axis
          .visibleLabels[(index.round() >= axis.visibleLabels.length
                  ? (index.round() > axis.visibleLabels.length
                      ? axis.visibleLabels.length - 1
                      : index - 1)
                  : index)
              .round()]
          .text;
    } else if (axis is RenderDateTimeCategoryAxis) {
      final num index = value < 0 ? 0 : value;
      return axis
          .visibleLabels[(index.round() >= axis.visibleLabels.length
                  ? (index.round() > axis.visibleLabels.length
                      ? axis.visibleLabels.length - 1
                      : index - 1)
                  : index)
              .round()]
          .text;
    } else if (axis is RenderDateTimeAxis) {
      final num interval = axis.visibleRange!.minimum.ceil();
      final num previousInterval = (axis.visibleLabels.isNotEmpty)
          ? axis.visibleLabels[axis.visibleLabels.length - 1].value
          : interval;
      final DateFormat dateFormat = axis.dateFormat ??
          _dateTimeLabelFormat(
              axis, interval.toInt(), previousInterval.toInt());
      return dateFormat
          .format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));
    } else {
      value = axis is RenderLogarithmicAxis ? pow(10, value) : value;
      return _getLabelValue(value, axis, axis.interactiveTooltip.decimalPlaces);
    }
  }

  /// To get the label format of the date-time axis.
  DateFormat _dateTimeLabelFormat(RenderChartAxis axis,
      [int? interval, int? prevInterval]) {
    DateFormat? format;
    final bool notDoubleInterval =
        (axis.interval != null && axis.interval! % 1 == 0) ||
            axis.interval == null;
    DateTimeIntervalType? actualIntervalType;
    num? minimum;
    minimum = axis.visibleRange!.minimum;
    actualIntervalType = (axis as RenderDateTimeAxis).visibleIntervalType;
    switch (actualIntervalType) {
      case DateTimeIntervalType.years:
        format = notDoubleInterval ? DateFormat.y() : DateFormat.MMMd();
        break;
      case DateTimeIntervalType.months:
        format = (minimum == interval || interval == prevInterval)
            ? _firstLabelFormat(actualIntervalType)
            : _dateTimeFormat(actualIntervalType, interval, prevInterval);

        break;
      case DateTimeIntervalType.days:
        format = (minimum == interval || interval == prevInterval)
            ? _firstLabelFormat(actualIntervalType)
            : _dateTimeFormat(actualIntervalType, interval, prevInterval);
        break;
      case DateTimeIntervalType.hours:
        format = DateFormat.j();
        break;
      case DateTimeIntervalType.minutes:
        format = DateFormat.Hm();
        break;
      case DateTimeIntervalType.seconds:
        format = DateFormat.ms();
        break;
      case DateTimeIntervalType.milliseconds:
        final DateFormat dateFormat = DateFormat('ss.SSS');
        format = dateFormat;
        break;
      case DateTimeIntervalType.auto:
        break;
      // ignore: no_default_cases
      default:
        break;
    }
    return format!;
  }

  /// Gets the the actual label value for tooltip and data label etc.
  String _getLabelValue(num value, dynamic axis, [int? showDigits]) {
    if (value.toString().split('.').length > 1) {
      final String str = value.toString();
      final List list = str.split('.');
      value = double.parse(value.toStringAsFixed(showDigits ?? 3));
      value = (list[1] == '0' ||
              list[1] == '00' ||
              list[1] == '000' ||
              list[1] == '0000' ||
              list[1] == '00000' ||
              list[1] == '000000' ||
              list[1] == '0000000')
          ? value.round()
          : value;
    }
    final dynamic text = axis is RenderNumericAxis && axis.numberFormat != null
        ? axis.numberFormat!.format(value)
        : value;
    return ((axis.labelFormat != null && axis.labelFormat != '')
        ? axis.labelFormat.replaceAll(RegExp('{value}'), text.toString())
        : text.toString()) as String;
  }

  /// Calculate the dateTime format.
  DateFormat? _dateTimeFormat(DateTimeIntervalType? actualIntervalType,
      int? interval, int? prevInterval) {
    final DateTime minimum = DateTime.fromMillisecondsSinceEpoch(interval!);
    final DateTime maximum = DateTime.fromMillisecondsSinceEpoch(prevInterval!);
    DateFormat? format;
    final bool isIntervalDecimal = interval % 1 == 0;
    if (actualIntervalType == DateTimeIntervalType.months) {
      format = minimum.year == maximum.year
          ? (isIntervalDecimal ? DateFormat.MMM() : DateFormat.MMMd())
          : DateFormat('yyy MMM');
    } else if (actualIntervalType == DateTimeIntervalType.days) {
      format = minimum.month != maximum.month
          ? (isIntervalDecimal ? DateFormat.MMMd() : DateFormat.MEd())
          : DateFormat.d();
    }

    return format;
  }

  /// Returns the first label format for date time values.
  DateFormat? _firstLabelFormat(DateTimeIntervalType? actualIntervalType) {
    DateFormat? format;

    if (actualIntervalType == DateTimeIntervalType.months) {
      format = DateFormat('yyy MMM');
    } else if (actualIntervalType == DateTimeIntervalType.days) {
      format = DateFormat.MMMd();
    } else if (actualIntervalType == DateTimeIntervalType.minutes) {
      format = DateFormat.Hm();
    }

    return format;
  }
}
