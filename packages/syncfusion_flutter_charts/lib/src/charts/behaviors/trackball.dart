import 'dart:async';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../axis/axis.dart';
import '../axis/category_axis.dart';
import '../axis/datetime_category_axis.dart';
import '../axis/logarithmic_axis.dart';
import '../base.dart';
import '../common/callbacks.dart';
import '../common/chart_point.dart';
import '../common/interactive_tooltip.dart';
import '../common/marker.dart';
import '../indicators/technical_indicator.dart';
import '../interactions/behavior.dart';
import '../series/bar_series.dart';
import '../series/chart_series.dart';
import '../utils/constants.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';

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
  }) {
    _fetchImage();
  }

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

  /// Hold trackball target position.
  Offset? _position;
  Offset? _dividerStartOffset;
  Offset? _dividerEndOffset;
  Timer? _trackballHideTimer;
  SfChartThemeData? _chartThemeData;
  ThemeData? _themeData;
  Rect _plotAreaBounds = Rect.zero;
  Image? _trackballImage;
  bool _isTransposed = false;
  bool _isLeft = false;
  bool _isRight = false;
  bool _isTop = false;

  List<ChartPointInfo> chartPointInfo = <ChartPointInfo>[];
  final List<Offset> _visiblePoints = <Offset>[];
  final List<_TooltipLabels> _tooltipLabels = <_TooltipLabels>[];
  final List<ChartMarker> _lineMarkers = <ChartMarker>[];
  final List<ChartMarker> _tooltipMarkers = <ChartMarker>[];
  final List<Path> _tooltipPaths = <Path>[];

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
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }

    assert(x != null);
    assert(!y.isNaN);
    if (coordinateUnit == 'point') {
      _position = rawValueToPixelPoint(
          x, y, parent.xAxis, parent.yAxis, parent.isTransposed);
    } else if (coordinateUnit == 'pixel') {
      if (x is num) {
        _position = Offset(x.toDouble(), y);
      } else {
        _position = Offset(
            rawValueToPixelPoint(
                    x, y, parent.xAxis, parent.yAxis, parent.isTransposed)
                .dx,
            y);
      }
    }

    _show();
  }

  /// Displays the trackball at the specified point index.
  ///
  /// * pointIndex - index of the point for which the trackball must be shown
  void showByIndex(int pointIndex) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent != null &&
        parent.plotArea != null &&
        parent.plotArea!.firstChild != null) {
      final CartesianSeriesRenderer renderer =
          parent.plotArea!.firstChild! as CartesianSeriesRenderer;
      final List<num> visibleIndexes = renderer.visibleIndexes;
      if (visibleIndexes.isNotEmpty &&
          visibleIndexes.first <= pointIndex &&
          pointIndex <= visibleIndexes.last) {
        show(renderer.xRawValues[pointIndex], 0);
      }
    }
  }

  /// Hides the trackball if it is displayed.
  void hide() {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    _position = null;
    if (builder != null) {
      parent?.trackballBuilder!(<TrackballDetails>[]);
    }
    _resetDataHolders();
    parent?.invalidate();
  }

  /// To customize the necessary pointer events in behaviors.
  /// (e.g., CrosshairBehavior, TrackballBehavior, ZoomingBehavior).
  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerMoveEvent) {
      _handlePointerMove(event);
    } else if (event is PointerHoverEvent) {
      _handlePointerHover(event);
    } else if (event is PointerCancelEvent) {
      _hideTrackball(immediately: true);
    } else if (event is PointerUpEvent) {
      _hideTrackball();
    }
  }

  void _handlePointerMove(PointerMoveEvent details) {
    if (activationMode == ActivationMode.singleTap) {
      _showTrackball(parentBox!.globalToLocal(details.position));
    }
  }

  void _handlePointerHover(PointerHoverEvent details) {
    if (activationMode == ActivationMode.singleTap) {
      _showTrackball(parentBox!.globalToLocal(details.position));
    }
  }

  /// Called when a pointer or mouse enter on the screen.
  @override
  void handlePointerEnter(PointerEnterEvent details) {
    if (activationMode == ActivationMode.singleTap) {
      _showTrackball(parentBox!.globalToLocal(details.position));
    }
  }

  /// Called when a pointer or mouse exit on the screen.
  @override
  void handlePointerExit(PointerExitEvent details) {
    _hideTrackball(immediately: true);
  }

  /// Called when a long press gesture by a primary button has been
  /// recognized in behavior.
  @override
  void handleLongPressStart(LongPressStartDetails details) {
    if (activationMode == ActivationMode.longPress) {
      _showTrackball(parentBox!.globalToLocal(details.globalPosition));
    }
  }

  /// Called when moving after the long press gesture by a primary button is
  /// recognized in behavior.
  @override
  void handleLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    if (activationMode == ActivationMode.longPress) {
      _showTrackball(parentBox!.globalToLocal(details.globalPosition));
    }
  }

  /// Called when the pointer stops contacting the screen after a long-press
  /// by a primary button in behavior.
  @override
  void handleLongPressEnd(LongPressEndDetails details) {
    _hideTrackball();
  }

  /// Called when the pointer tap has contacted the screen in behavior.
  @override
  void handleTapDown(TapDownDetails details) {
    if (activationMode == ActivationMode.singleTap) {
      _showTrackball(parentBox!.globalToLocal(details.globalPosition));
    }
  }

  /// Called when pointer has stopped contacting screen in behavior.
  @override
  void handleTapUp(TapUpDetails details) {
    _hideTrackball();
  }

  /// Called when pointer tap has contacted the screen double time in behavior.
  @override
  void handleDoubleTap(Offset position) {
    if (activationMode == ActivationMode.doubleTap) {
      _showTrackball(parentBox!.globalToLocal(position));
      _hideTrackball(doubleTapHideDelay: 200);
    }
  }

  void _showTrackball(Offset localPosition) {
    if (enable) {
      show(localPosition.dx, localPosition.dy, 'pixel');
    }
  }

  void _hideTrackball({int doubleTapHideDelay = 0, bool immediately = false}) {
    if (immediately) {
      hide();
    } else if (!shouldAlwaysShow) {
      final int hideDelayDuration =
          hideDelay > 0 ? hideDelay.toInt() : doubleTapHideDelay;
      _trackballHideTimer?.cancel();
      _trackballHideTimer =
          Timer(Duration(milliseconds: hideDelayDuration), () {
        _trackballHideTimer = null;
        hide();
      });
    }
  }

  void _fetchImage() {
    if (markerSettings != null &&
        markerSettings!.markerVisibility == TrackballVisibilityMode.visible &&
        markerSettings!.shape == DataMarkerType.image &&
        markerSettings!.image != null) {
      fetchImage(markerSettings!.image).then((Image? value) {
        _trackballImage = value;
        (parentBox as RenderBehaviorArea?)?.invalidate();
      });
    } else {
      _trackballImage = null;
    }
  }

  void _show() {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (_position == null || parent == null) {
      return;
    }

    _generateAllPoints(parent, _position!);
    parent.invalidate();
    if (builder != null) {
      final List<TrackballDetails> details = <TrackballDetails>[];
      final List<CartesianChartPoint> chartPoints = <CartesianChartPoint>[];
      final List<int> currentPointIndices = <int>[];
      final List<int> visibleSeriesIndices = <int>[];
      final List<dynamic> visibleSeriesList = <dynamic>[];
      final int length = chartPointInfo.length;
      if (tooltipDisplayMode == TrackballDisplayMode.groupAllPoints) {
        for (int i = 0; i < length; i++) {
          final ChartPointInfo pointInfo = chartPointInfo[i];
          chartPoints.add(pointInfo.chartPoint!);
          currentPointIndices.add(pointInfo.dataPointIndex!);
          visibleSeriesIndices.add(pointInfo.seriesIndex!);
          visibleSeriesList.add(pointInfo.series!);
        }

        final TrackballGroupingModeInfo groupingModeInfo =
            TrackballGroupingModeInfo(chartPoints, currentPointIndices,
                visibleSeriesIndices, visibleSeriesList);
        details.add(TrackballDetails(null, null, null, null, groupingModeInfo));
      } else {
        for (int i = 0; i < length; i++) {
          final ChartPointInfo pointInfo = chartPointInfo[i];
          details.add(TrackballDetails(pointInfo.chartPoint, pointInfo.series!,
              pointInfo.dataPointIndex, pointInfo.seriesIndex));
        }
      }
      parent.trackballBuilder!(details);
      chartPoints.clear();
      currentPointIndices.clear();
      visibleSeriesIndices.clear();
      visibleSeriesList.clear();
    }
  }

  void _resetDataHolders() {
    chartPointInfo.clear();
    _visiblePoints.clear();
    _tooltipLabels.clear();
    _lineMarkers.clear();
    _tooltipMarkers.clear();
    _tooltipPaths.clear();
    _dividerStartOffset = null;
    _dividerEndOffset = null;
    _isTransposed = false;
    _isLeft = false;
    _isRight = false;
    _isTop = false;
  }

  void _generateAllPoints(RenderBehaviorArea parent, Offset position) {
    final RenderChartPlotArea? chartPlotArea = parent.plotArea;
    if (chartPlotArea == null) {
      return;
    }

    _resetDataHolders();
    double leastX = 0.0;
    final bool isRtl = parent.textDirection == TextDirection.rtl;
    final bool isGroupMode =
        tooltipDisplayMode == TrackballDisplayMode.groupAllPoints;
    _chartThemeData = parent.chartThemeData!;
    _themeData = parent.themeData;
    _plotAreaBounds = parent.paintBounds;
    _isTransposed = parent.isTransposed;

    chartPlotArea.visitChildren((RenderObject child) {
      if (child is CartesianSeriesRenderer &&
          child.controller.isVisible &&
          child.dataSource != null &&
          child.dataSource!.isNotEmpty &&
          child.animationController != null &&
          !child.animationController!.isAnimating) {
        final List<int> nearestPointIndexes =
            _findNearestChartPointIndexes(child, position);
        for (final int nearestPointIndex in nearestPointIndexes) {
          final ChartSegment segment = child.segmentAt(nearestPointIndex);
          final TrackballInfo? trackballInfo =
              segment.trackballInfo(position, nearestPointIndex);

          if (trackballInfo != null) {
            final ChartTrackballInfo trackInfo =
                trackballInfo as ChartTrackballInfo;
            if (trackInfo.pointIndex >= 0) {
              final Offset trackPosition = trackInfo.position!;
              double xPos = trackPosition.dx;
              double yPos = trackPosition.dy;
              final double touchXPos = position.dx;
              if (trackInfo.seriesIndex == 0 ||
                  ((leastX - touchXPos).abs() > (xPos - touchXPos).abs())) {
                leastX = xPos;
              }

              final Rect rect = _plotAreaBounds
                  .intersect(Rect.fromLTWH(xPos - 1, yPos - 1, 2, 2));
              if (_plotAreaBounds.contains(trackPosition) ||
                  _plotAreaBounds.overlaps(rect)) {
                _visiblePoints.add(Offset(xPos, yPos));
                _addChartPointInfo(trackInfo, xPos, yPos);
                if (isGroupMode && leastX >= _plotAreaBounds.left) {
                  if (_isTransposed) {
                    yPos = leastX;
                  } else {
                    xPos = leastX;
                  }
                }
              }

              _updateLeastX(leastX, child.dataCount);
              if (child is BarSeriesRenderer ? _isTransposed : _isTransposed) {
                yPos = leastX;
              } else {
                xPos = leastX;
              }
            }
          }
        }
      }
    });

    if (parent.indicatorArea != null) {
      parent.indicatorArea!.visitChildren((RenderObject child) {
        if (child is IndicatorRenderer && child.effectiveIsVisible) {
          final List<TrackballInfo>? trackballInfo =
              child.trackballInfo(position);
          if (trackballInfo != null &&
              trackballInfo.isNotEmpty &&
              child.animationFactor == 1) {
            for (final TrackballInfo trackInfo in trackballInfo) {
              final ChartTrackballInfo info = trackInfo as ChartTrackballInfo;
              final CartesianChartPoint chartPoint = info.point;
              final bool pointIsNaN =
                  (chartPoint.xValue != null && chartPoint.xValue!.isNaN) ||
                      (chartPoint.y != null && chartPoint.y!.isNaN);
              if (trackInfo.pointIndex >= 0 && !pointIsNaN) {
                final Offset indicatorPosition = info.position!;
                double xPos = indicatorPosition.dx;
                double yPos = indicatorPosition.dy;
                final double touchXPos = position.dx;
                if ((leastX - touchXPos).abs() > (xPos - touchXPos).abs()) {
                  leastX = xPos;
                }

                if (_isTransposed &&
                    (leastX - touchXPos).abs() > (yPos - touchXPos).abs()) {
                  leastX = yPos;
                }

                final Rect rect = _plotAreaBounds
                    .intersect(Rect.fromLTWH(xPos - 1, yPos - 1, 2, 2));
                if (_plotAreaBounds.contains(indicatorPosition) ||
                    _plotAreaBounds.overlaps(rect)) {
                  _visiblePoints.add(Offset(xPos, yPos));
                  _addChartPointInfo(info, xPos, yPos);
                  if (isGroupMode && leastX >= _plotAreaBounds.left) {
                    if (_isTransposed) {
                      yPos = leastX;
                    } else {
                      xPos = leastX;
                    }
                  }
                }
              }
            }
          }
          _updateLeastX(leastX, child.dataCount);
        }
      });
    }

    _validateLeastPointInfoWithLeastX(leastX);
    _sortTrackballPoints(_isTransposed);
    _triggerTrackballRenderCallback(parent);
    _applyTooltipDisplayMode(
        _chartThemeData!, _themeData!, leastX, position, isRtl);
  }

  void _sortTrackballPoints(bool isTranposed) {
    if (_visiblePoints.isNotEmpty) {
      isTranposed
          ? _visiblePoints.sort((Offset a, Offset b) => a.dx.compareTo(b.dx))
          : _visiblePoints.sort((Offset a, Offset b) => a.dy.compareTo(b.dy));
    }
    if (chartPointInfo.isNotEmpty) {
      if (tooltipDisplayMode != TrackballDisplayMode.groupAllPoints) {
        isTranposed
            ? chartPointInfo.sort((ChartPointInfo a, ChartPointInfo b) =>
                a.xPosition!.compareTo(b.xPosition!))
            : tooltipDisplayMode == TrackballDisplayMode.floatAllPoints
                ? chartPointInfo.sort((ChartPointInfo a, ChartPointInfo b) =>
                    a.yPosition!.compareTo(b.yPosition!))
                : chartPointInfo.sort((ChartPointInfo a, ChartPointInfo b) =>
                    b.yPosition!.compareTo(a.yPosition!));
      }
    }
  }

  void _triggerTrackballRenderCallback(RenderBehaviorArea parent) {
    if (parent.onTrackballPositionChanging != null) {
      final int length = chartPointInfo.length - 1;
      for (int i = length; i >= 0; i--) {
        final ChartPointInfo pointInfo = chartPointInfo[i];
        final TrackballArgs trackballArgs = TrackballArgs();
        trackballArgs.chartPointInfo = pointInfo;
        parent.onTrackballPositionChanging!(trackballArgs);
        chartPointInfo[i].label = trackballArgs.chartPointInfo.label;
        chartPointInfo[i].header = trackballArgs.chartPointInfo.header;
        if (builder == null && pointInfo.label == null ||
            pointInfo.label == '') {
          chartPointInfo.removeAt(i);
          _visiblePoints.removeAt(i);
        }
      }
    }
  }

  List<int> _findNearestChartPointIndexes(
      CartesianSeriesRenderer series, Offset position) {
    final List<int> indexes = <int>[];
    final int dataCount = series.dataCount;
    final RenderChartAxis xAxis = series.xAxis!;
    final RenderChartAxis yAxis = series.yAxis!;
    final Rect bounds = series.paintBounds;
    num xValue = xAxis.pixelToPoint(bounds, position.dx, position.dy);
    num yValue = yAxis.pixelToPoint(bounds, position.dx, position.dy);

    if (series.canFindLinearVisibleIndexes &&
        ((xAxis is RenderCategoryAxis && xAxis.arrangeByIndex) ||
            xAxis is RenderDateTimeCategoryAxis)) {
      final DoubleRange range = xAxis.visibleRange!;
      final int index = xValue.round();
      if (index <= range.maximum &&
          index >= range.minimum &&
          index < dataCount &&
          index >= 0) {
        indexes.add(index);
      }
      return indexes;
    } else {
      if (xAxis is RenderLogarithmicAxis) {
        xValue = xAxis.toPow(xValue);
      }
      if (yAxis is RenderLogarithmicAxis) {
        yValue = yAxis.toPow(yValue);
      }

      if (series.canFindLinearVisibleIndexes) {
        final int binaryIndex =
            binarySearch(series.xValues, xValue.toDouble(), 0, dataCount - 1);
        if (binaryIndex >= 0) {
          indexes.add(binaryIndex);
        }
      } else {
        double delta = 0;
        num nearPointX = series.xValues[0];
        num nearPointY = series.yAxis!.visibleRange!.minimum;
        for (int i = 0; i < dataCount; i++) {
          final num touchXValue = xValue;
          final num touchYValue = yValue;
          final double curX = series.xValues[i].toDouble();
          final double curY = series.trackballYValue(i).toDouble();
          if (delta == touchXValue - curX) {
            if ((touchYValue - curY).abs() > (touchYValue - nearPointY).abs()) {
              indexes.clear();
            }
            indexes.add(i);
          } else if ((touchXValue - curX).abs() <=
              (touchXValue - nearPointX).abs()) {
            nearPointX = curX;
            nearPointY = curY;
            delta = touchXValue - curX;
            indexes.clear();
            indexes.add(i);
          }
        }
      }
      return indexes;
    }
  }

  void _addChartPointInfo(
      ChartTrackballInfo trackballInfo, double xPos, double yPos) {
    final ChartPointInfo pointInfo = ChartPointInfo(
      label: trackballInfo.text,
      header: trackballInfo.header,
      color: trackballInfo.color,
      series: trackballInfo.series,
      seriesName: trackballInfo.name,
      seriesIndex: trackballInfo.seriesIndex,
      chartPoint: trackballInfo.point,
      dataPointIndex: trackballInfo.pointIndex,
      xPosition: xPos,
      yPosition: yPos,
      markerXPos: xPos,
      markerYPos: yPos,
      lowYPosition: trackballInfo.lowYPos,
      highXPosition: trackballInfo.highXPos,
      highYPosition: trackballInfo.highYPos,
      openXPosition: trackballInfo.openXPos,
      openYPosition: trackballInfo.openYPos,
      closeXPosition: trackballInfo.closeXPos,
      closeYPosition: trackballInfo.closeYPos,
      minYPosition: trackballInfo.minYPos,
      maxYPosition: trackballInfo.maxYPos,
      maxXPosition: trackballInfo.maxXPos,
      lowerXPosition: trackballInfo.lowerXPos,
      lowerYPosition: trackballInfo.lowerYPos,
      upperXPosition: trackballInfo.upperXPos,
      upperYPosition: trackballInfo.upperYPos,
    );
    chartPointInfo.add(pointInfo);
  }

  void _updateLeastX(double leastX, int dataCount) {
    if (chartPointInfo.isNotEmpty &&
        chartPointInfo[0].dataPointIndex! < dataCount) {
      leastX = chartPointInfo[0].xPosition!;
    }
  }

  void _validateLeastPointInfoWithLeastX(double leastX) {
    final int length = chartPointInfo.length;
    if (length > 1) {
      final ChartPointInfo firstPoint = chartPointInfo[0];
      final bool isFloatAllPoints =
          tooltipDisplayMode == TrackballDisplayMode.floatAllPoints;
      for (int i = 0; i < length; i++) {
        final ChartPointInfo currentPoint = chartPointInfo[i];
        if (firstPoint.chartPoint!.xValue! !=
            currentPoint.chartPoint!.xValue!) {
          final List<ChartPointInfo> leastPointInfo = <ChartPointInfo>[];
          for (final ChartPointInfo pointInfo in chartPointInfo) {
            final double xPos = pointInfo.xPosition!;
            if (xPos == leastX) {
              leastPointInfo.add(pointInfo);
              final int leastLength = leastPointInfo.length;
              if (!(isFloatAllPoints &&
                  leastLength > 1 &&
                  (pointInfo.series is IndicatorRenderer ||
                      pointInfo.seriesIndex !=
                          leastPointInfo[leastLength - 2].seriesIndex))) {
                _visiblePoints.clear();
              }

              _visiblePoints.add(Offset(xPos, pointInfo.yPosition!));
            }
          }
          chartPointInfo.clear();
          chartPointInfo = leastPointInfo;
          break;
        }
      }
    }
  }

  void _validateNearestChartPointInfo(double leastX, Offset position) {
    final double touchXPos = position.dx;
    final double touchYPos = position.dy;
    int length = chartPointInfo.length;
    if (length > 1) {
      ChartPointInfo? pointInfo;
      final ChartPointInfo firstPoint = chartPointInfo[0];
      final double firstX = firstPoint.xPosition!;
      if (leastX != firstX && !_isTransposed) {
        chartPointInfo.remove(firstPoint);
      }
      pointInfo = firstPoint;
      length = chartPointInfo.length;
      for (int i = 1; i < length; i++) {
        final ChartPointInfo nextPoint = chartPointInfo[i];
        final double nextX = nextPoint.xPosition!;
        final double nextY = nextPoint.yPosition!;
        final bool isXYPositioned = !_isTransposed
            ? (((pointInfo!.yPosition! - touchYPos).abs() >
                    (nextY - touchYPos).abs()) &&
                pointInfo.xPosition! == nextX)
            : (((pointInfo!.xPosition! - touchXPos).abs() >
                    (nextX - touchXPos).abs()) &&
                pointInfo.yPosition! == nextY);
        if (isXYPositioned) {
          pointInfo = chartPointInfo[i];
        }
      }

      if (pointInfo != null) {
        chartPointInfo
          ..clear()
          ..add(pointInfo);
      }
    }
  }

  void _applyTooltipDisplayMode(
    SfChartThemeData chartThemeData,
    ThemeData themeData,
    double leastX,
    Offset position,
    bool isRtl,
  ) {
    if (chartPointInfo.isEmpty) {
      return;
    }

    // It applicable for template tooltip.
    if (tooltipDisplayMode == TrackballDisplayMode.nearestPoint) {
      _validateNearestChartPointInfo(leastX, position);
    }

    if (builder == null) {
      final bool markerIsVisible = markerSettings != null &&
          markerSettings!.markerVisibility == TrackballVisibilityMode.visible;

      if (tooltipSettings.enable) {
        final TextStyle labelStyle = _createLabelStyle(
            FontWeight.normal, _chartThemeData!.trackballTextStyle!);
        final bool markerAutoVisibility = markerSettings != null &&
            markerSettings!.markerVisibility == TrackballVisibilityMode.auto;
        switch (tooltipDisplayMode) {
          case TrackballDisplayMode.nearestPoint:
            _applyNearestPointDisplayMode(
                labelStyle, markerIsVisible, markerAutoVisibility, isRtl);
            break;

          case TrackballDisplayMode.floatAllPoints:
            _applyFloatAllPointsDisplayMode(
                labelStyle, markerIsVisible, markerAutoVisibility, isRtl);
            break;

          case TrackballDisplayMode.groupAllPoints:
            _applyGroupAllPointDisplayMode(
                labelStyle, markerIsVisible, markerAutoVisibility, isRtl);
            break;

          case TrackballDisplayMode.none:
            break;
        }
      }

      if (markerIsVisible) {
        _computeLineMarkers(themeData, _lineMarkers);
      }
    }
  }

  void _applyNearestPointDisplayMode(
    TextStyle labelStyle,
    bool markerIsVisible,
    bool markerAutoVisibility,
    bool isRtl,
  ) {
    final double arrowLength = tooltipSettings.arrowLength;
    final double arrowWidth = tooltipSettings.arrowWidth;
    double borderRadius = tooltipSettings.borderRadius;
    for (final ChartPointInfo pointInfo in chartPointInfo) {
      final Size labelSize = _labelSize(pointInfo.label!, labelStyle);
      final dynamic series = pointInfo.series;
      double width = labelSize.width;
      if (width < defaultTooltipWidth) {
        width = defaultTooltipWidth;
        borderRadius = borderRadius > 5 ? 5 : borderRadius;
      }
      borderRadius = borderRadius > 15 ? 15 : borderRadius;
      final double padding = (markerAutoVisibility
              ? series is IndicatorRenderer ||
                  (series != null && series.markerSettings.isVisible)
              : markerIsVisible)
          ? (markerSettings!.width / 2) + defaultTrackballPadding
          : defaultTrackballPadding;

      _computeNearestTooltip(pointInfo, labelStyle, width, labelSize.height,
          padding, arrowWidth, arrowLength, borderRadius, isRtl);
    }
  }

  void _computeNearestTooltip(
    ChartPointInfo pointInfo,
    TextStyle labelStyle,
    double width,
    double height,
    double padding,
    double arrowWidth,
    double arrowLength,
    double borderRadius,
    bool isRtl,
  ) {
    final double xPosition = pointInfo.xPosition!;
    final double yPosition = pointInfo.yPosition!;
    final Rect tooltipRect = _tooltipRect(xPosition, yPosition, width, height);
    final double labelRectWidth = tooltipRect.width;
    final double labelRectHeight = tooltipRect.height;
    final Offset alignPosition = _alignPosition(
        xPosition,
        yPosition,
        labelRectWidth,
        labelRectHeight,
        arrowLength,
        arrowWidth,
        padding,
        isRtl);
    final RRect tooltipRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          alignPosition.dx, alignPosition.dy, labelRectWidth, labelRectHeight),
      Radius.circular(borderRadius),
    );

    final Path nosePath = _nosePath(_tooltipDirection(), tooltipRRect,
        Offset(xPosition, yPosition), arrowLength, arrowWidth);
    final Path nearestTooltipPath = Path()
      ..addRRect(tooltipRRect)
      ..addPath(nosePath, Offset.zero);
    _tooltipPaths.add(nearestTooltipPath);

    if (tooltipSettings.canShowMarker) {
      final Offset markerPosition = _markerPosition(
          tooltipRRect, width, height, defaultTrackballPadding, isRtl);
      _computeTooltipMarkers(pointInfo, markerPosition);
    }

    if (pointInfo.label != null) {
      _computeTooltipLabels(
          pointInfo.label!, width, height, labelStyle, tooltipRRect, isRtl);
    }
  }

  void _applyFloatAllPointsDisplayMode(
    TextStyle labelStyle,
    bool markerIsVisible,
    bool markerAutoVisibility,
    bool isRtl,
  ) {
    final double arrowLength = tooltipSettings.arrowLength;
    final double arrowWidth = tooltipSettings.arrowWidth;
    double borderRadius = tooltipSettings.borderRadius;
    final _TooltipPositions floatTooltipPosition =
        _computeTooltipPositionForFloatAllPoints(labelStyle, borderRadius);

    final int length = chartPointInfo.length;
    for (int i = 0; i < length; i++) {
      final ChartPointInfo pointInfo = chartPointInfo[i];
      final dynamic series = pointInfo.series;
      final Size labelSize = _labelSize(pointInfo.label!, labelStyle);
      double width = labelSize.width;
      if (width < defaultTooltipWidth) {
        width = defaultTooltipWidth;
        borderRadius = borderRadius > 5 ? 5 : borderRadius;
      }
      borderRadius = borderRadius > 15 ? 15 : borderRadius;
      final double padding = (markerAutoVisibility
              ? series is IndicatorRenderer ||
                  (series != null && series.markerSettings.isVisible)
              : markerIsVisible)
          ? (markerSettings!.width / 2) + defaultTrackballPadding
          : defaultTrackballPadding;

      final num tooltipTop = floatTooltipPosition.tooltipTop[i];
      final num tooltipBottom = floatTooltipPosition.tooltipBottom[i];
      if (_isTransposed
          ? tooltipTop >= _plotAreaBounds.left &&
              tooltipBottom <= _plotAreaBounds.right
          : tooltipTop >= _plotAreaBounds.top &&
              tooltipBottom <= _plotAreaBounds.bottom) {
        _computeFloatAllPointTooltip(
            i,
            pointInfo,
            width,
            labelSize.height,
            padding,
            arrowWidth,
            arrowLength,
            borderRadius,
            labelStyle,
            floatTooltipPosition,
            isRtl);
      }
    }
  }

  void _computeFloatAllPointTooltip(
    int index,
    ChartPointInfo pointInfo,
    double width,
    double height,
    double padding,
    double arrowWidth,
    double arrowLength,
    double borderRadius,
    TextStyle labelStyle,
    _TooltipPositions tooltipPosition,
    bool isRtl,
  ) {
    final double xPosition = pointInfo.xPosition!;
    final double yPosition = pointInfo.yPosition!;
    final Rect tooltipRect = _tooltipRect(xPosition, yPosition, width, height);
    final double labelRectWidth = tooltipRect.width;
    final double labelRectHeight = tooltipRect.height;
    final Offset alignPosition = _alignPosition(
        xPosition,
        yPosition,
        labelRectWidth,
        labelRectHeight,
        arrowLength,
        arrowWidth,
        padding,
        isRtl);

    final double topValue = tooltipPosition.tooltipTop[index].toDouble();
    final RRect tooltipRRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
            _isTransposed ? topValue : alignPosition.dx,
            _isTransposed ? alignPosition.dy : topValue,
            labelRectWidth,
            labelRectHeight),
        Radius.circular(borderRadius));

    final Path nosePath = _nosePath(_tooltipDirection(), tooltipRRect,
        Offset(xPosition, yPosition), arrowLength, arrowWidth);
    final Path nearestTooltipPath = Path()
      ..addRRect(tooltipRRect)
      ..addPath(nosePath, Offset.zero);
    _tooltipPaths.add(nearestTooltipPath);

    if (tooltipSettings.canShowMarker) {
      final Offset markerPosition = _markerPosition(
          tooltipRRect, width, height, defaultTrackballPadding, isRtl);
      _computeTooltipMarkers(pointInfo, markerPosition);
    }

    if (pointInfo.label != null) {
      _computeTooltipLabels(
          pointInfo.label!, width, height, labelStyle, tooltipRRect, isRtl);
    }
  }

  _TooltipPositions _computeTooltipPositionForFloatAllPoints(
      TextStyle labelStyle, double borderRadius) {
    final List<num> tooltipTop = <num>[];
    final List<num> tooltipBottom = <num>[];
    final List<RenderChartAxis> xAxesInfo = <RenderChartAxis>[];
    final List<RenderChartAxis> yAxesInfo = <RenderChartAxis>[];
    final num tooltipPaddingForFloatPoint = _isTransposed ? 8 : 5;
    final int length = chartPointInfo.length;
    for (int i = 0; i < length; i++) {
      final ChartPointInfo pointInfo = chartPointInfo[i];
      final dynamic series = pointInfo.series;
      final String label = pointInfo.label!;
      final Size labelSize = _labelSize(label, labelStyle);
      final double height = labelSize.height;
      double width = labelSize.width;
      if (width < defaultTooltipWidth) {
        width = defaultTooltipWidth;
      }

      if (label != '' && _visiblePoints.isNotEmpty) {
        final Offset visiblePoint = _visiblePoints[i];
        final double closeX = visiblePoint.dx;
        final double closeY = visiblePoint.dy;
        tooltipTop.add(_isTransposed
            ? closeX - tooltipPaddingForFloatPoint - (width / 2)
            : closeY - tooltipPaddingForFloatPoint - height / 2);
        tooltipBottom.add(_isTransposed
            ? (closeX + tooltipPaddingForFloatPoint + (width / 2)) +
                (tooltipSettings.canShowMarker ? trackballTooltipMarkerSize : 0)
            : closeY + tooltipPaddingForFloatPoint + height / 2);
        if (series != null && series.xAxis != null) {
          xAxesInfo.add(series.xAxis!);
        }
        if (series != null && series.yAxis != null) {
          yAxesInfo.add(series.yAxis!);
        }
      }
    }

    if (tooltipTop.isNotEmpty && tooltipBottom.isNotEmpty) {
      return _smartTooltipPositions(tooltipTop, tooltipBottom, xAxesInfo,
          yAxesInfo, chartPointInfo, tooltipPaddingForFloatPoint);
    }
    return _TooltipPositions(tooltipTop, tooltipBottom);
  }

  /// Method to place the collided tooltips properly
  _TooltipPositions _smartTooltipPositions(
      List<num> tooltipTop,
      List<num> tooltipBottom,
      List<RenderChartAxis> xAxesInfo,
      List<RenderChartAxis> yAxesInfo,
      List<ChartPointInfo> chartPointInfo,
      [num tooltipPaddingForFloatPoint = 0]) {
    final List<num> visibleLocation = <num>[];
    num totalHeight = 0;
    final int length = chartPointInfo.length;
    for (int i = 0; i < length; i++) {
      final ChartPointInfo pointInfo = chartPointInfo[i];
      _isTransposed
          ? visibleLocation.add(pointInfo.xPosition!)
          : visibleLocation.add(pointInfo.yPosition!);
      totalHeight +=
          tooltipBottom[i] - tooltipTop[i] + tooltipPaddingForFloatPoint;
    }

    _TooltipPositions smartTooltipPosition = _continuousOverlappingPoints(
        tooltipTop,
        tooltipBottom,
        visibleLocation,
        tooltipPaddingForFloatPoint);
    if (!_isTransposed
        ? totalHeight < (_plotAreaBounds.bottom - _plotAreaBounds.top)
        : totalHeight < (_plotAreaBounds.right - _plotAreaBounds.left)) {
      smartTooltipPosition = _verticalArrangements(smartTooltipPosition,
          xAxesInfo, yAxesInfo, tooltipPaddingForFloatPoint);
    }
    return smartTooltipPosition;
  }

  _TooltipPositions _verticalArrangements(
    _TooltipPositions tooltipPosition,
    List<RenderChartAxis> xAxesInfo,
    List<RenderChartAxis> yAxesInfo,
    num tooltipPaddingForFloatPoint,
  ) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return tooltipPosition;
    }
    num? startPos;
    num? chartHeight;
    num secWidth;
    num width;
    final int tooltipTopLength = tooltipPosition.tooltipTop.length;
    RenderChartAxis yAxis;
    for (int i = tooltipTopLength - 1; i >= 0; i--) {
      yAxis = yAxesInfo[i];
      RenderChartAxis? child = parent.cartesianAxes!.firstChild;
      while (child != null) {
        if (yAxis == child) {
          if (_isTransposed) {
            chartHeight = _plotAreaBounds.right;
            startPos = _plotAreaBounds.left;
          } else {
            chartHeight = _plotAreaBounds.bottom - _plotAreaBounds.top;
            startPos = _plotAreaBounds.top;
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
                tooltipPosition.tooltipTop[j + 1] - tooltipPaddingForFloatPoint;
            tooltipPosition.tooltipTop[j] =
                tooltipPosition.tooltipBottom[j] - secWidth;
          }
        }
      }
    }

    for (int i = 0; i < tooltipTopLength; i++) {
      yAxis = yAxesInfo[i];
      RenderChartAxis? child = parent.cartesianAxes!.firstChild;
      while (child != null) {
        if (yAxis == child) {
          if (_isTransposed) {
            chartHeight = _plotAreaBounds.right;
            startPos = _plotAreaBounds.left;
          } else {
            chartHeight = _plotAreaBounds.bottom - _plotAreaBounds.top;
            startPos = _plotAreaBounds.top;
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
        for (int j = i + 1; j <= (tooltipTopLength - 1); j++) {
          secWidth =
              tooltipPosition.tooltipBottom[j] - tooltipPosition.tooltipTop[j];
          if (tooltipPosition.tooltipTop[j] <
                  tooltipPosition.tooltipBottom[j - 1] &&
              (tooltipPosition.tooltipTop[j - 1] > startPos &&
                  tooltipPosition.tooltipBottom[j - 1] < chartHeight!)) {
            tooltipPosition.tooltipTop[j] =
                tooltipPosition.tooltipBottom[j - 1] +
                    tooltipPaddingForFloatPoint;
            tooltipPosition.tooltipBottom[j] =
                tooltipPosition.tooltipTop[j] + secWidth;
          }
        }
      }
    }
    return tooltipPosition;
  }

  // Method to identify the colliding trackball tooltips and
  // return the new tooltip positions
  _TooltipPositions _continuousOverlappingPoints(List<num> tooltipTop,
      List<num> tooltipBottom, List<num> visibleLocation, num tooltipPadding) {
    num temp;
    num count = 0;
    num start = 0;
    num halfHeight;
    num midPos;
    num tempTooltipHeight;
    num temp1TooltipHeight;
    int startPoint = 0, i, j, k;
    final num endPoint = tooltipBottom.length - 1;
    final num firstTop = tooltipTop[0];
    num tooltipHeight = (tooltipBottom[0] - firstTop) + tooltipPadding;
    temp = firstTop + tooltipHeight;
    start = firstTop;
    for (i = 0; i < endPoint; i++) {
      // To identify that tooltip collides or not.
      if (temp >= tooltipTop[i + 1]) {
        tooltipHeight =
            tooltipBottom[i + 1] - tooltipTop[i + 1] + tooltipPadding;
        temp += tooltipHeight;
        count++;
        // This condition executes when the tooltip count is half of the total
        // number of tooltips.
        if (count - 1 == endPoint - 1 || i == endPoint - 1) {
          halfHeight = (temp - start) / 2;
          midPos = (visibleLocation[startPoint] + visibleLocation[i + 1]) / 2;
          tempTooltipHeight =
              tooltipBottom[startPoint] - tooltipTop[startPoint];
          tooltipTop[startPoint] = midPos - halfHeight;
          tooltipBottom[startPoint] =
              tooltipTop[startPoint] + tempTooltipHeight;
          for (k = startPoint; k > 0; k--) {
            if (tooltipTop[k] <= tooltipBottom[k - 1] + tooltipPadding) {
              temp1TooltipHeight = tooltipBottom[k - 1] - tooltipTop[k - 1];
              tooltipTop[k - 1] =
                  tooltipTop[k] - temp1TooltipHeight - tooltipPadding;
              tooltipBottom[k - 1] = tooltipTop[k - 1] + temp1TooltipHeight;
            } else {
              break;
            }
          }
          // To set tool tip positions based on the half height and
          // other tooltip height.
          for (j = startPoint + 1; j <= startPoint + count; j++) {
            tempTooltipHeight = tooltipBottom[j] - tooltipTop[j];
            tooltipTop[j] = tooltipBottom[j - 1] + tooltipPadding;
            tooltipBottom[j] = tooltipTop[j] + tempTooltipHeight;
          }
        }
      } else {
        count = i > 0 ? count : 0;
        // This executes when any of the middle tooltip collides.
        if (count > 0) {
          halfHeight = (temp - start) / 2;
          midPos = (visibleLocation[startPoint] + visibleLocation[i]) / 2;
          tempTooltipHeight =
              tooltipBottom[startPoint] - tooltipTop[startPoint];
          tooltipTop[startPoint] = midPos - halfHeight;
          tooltipBottom[startPoint] =
              tooltipTop[startPoint] + tempTooltipHeight;
          for (k = startPoint; k > 0; k--) {
            if (tooltipTop[k] <= tooltipBottom[k - 1] + tooltipPadding) {
              temp1TooltipHeight = tooltipBottom[k - 1] - tooltipTop[k - 1];
              tooltipTop[k - 1] =
                  tooltipTop[k] - temp1TooltipHeight - tooltipPadding;
              tooltipBottom[k - 1] = tooltipTop[k - 1] + temp1TooltipHeight;
            } else {
              break;
            }
          }

          // To set tool tip positions based on the half height and
          // other tooltip height.
          for (j = startPoint + 1; j <= startPoint + count; j++) {
            tempTooltipHeight = tooltipBottom[j] - tooltipTop[j];
            tooltipTop[j] = tooltipBottom[j - 1] + tooltipPadding;
            tooltipBottom[j] = tooltipTop[j] + tempTooltipHeight;
          }
          count = 0;
        }
        tooltipHeight =
            (tooltipBottom[i + 1] - tooltipTop[i + 1]) + tooltipPadding;
        temp = tooltipTop[i + 1] + tooltipHeight;
        start = tooltipTop[i + 1];
        startPoint = i + 1;
      }
    }
    return _TooltipPositions(tooltipTop, tooltipBottom);
  }

  void _applyGroupAllPointDisplayMode(TextStyle labelStyle,
      bool markerIsVisible, bool markerAutoVisibility, bool isRtl) {
    double borderRadius = tooltipSettings.borderRadius;
    final ChartPointInfo pointInfo = chartPointInfo[0];
    final double xPosition = pointInfo.xPosition!;
    final double yPosition = pointInfo.yPosition!;
    final dynamic series = pointInfo.series;
    final Size totalLabelSize = _labelSizeForGroupAllPoints(labelStyle);
    final double height = totalLabelSize.height;
    double width = totalLabelSize.width;
    if (width < defaultTooltipWidth) {
      width = defaultTooltipWidth;
      borderRadius = borderRadius > 5 ? 5 : borderRadius;
    }
    borderRadius = borderRadius > 15 ? 15 : borderRadius;
    final double padding = (markerAutoVisibility
            ? series is IndicatorRenderer ||
                (series != null && series.markerSettings.isVisible)
            : markerIsVisible)
        ? (markerSettings!.width / 2) + defaultTrackballPadding
        : defaultTrackballPadding;

    final Rect tooltipRect = _tooltipRect(xPosition, yPosition, width, height);
    final double labelRectWidth = tooltipRect.width;
    final double labelRectHeight = tooltipRect.height;
    final Offset defaultPosition = _defaultGroupPosition(xPosition, yPosition);
    final Offset alignPosition = _alignPosition(
      defaultPosition.dx,
      defaultPosition.dy,
      labelRectWidth,
      labelRectHeight,
      tooltipSettings.arrowLength,
      tooltipSettings.arrowWidth,
      padding,
      isRtl,
      true,
    );

    final RRect tooltipRRect = _validateRect(
      Rect.fromLTWH(
          alignPosition.dx, alignPosition.dy, labelRectWidth, labelRectHeight),
      _plotAreaBounds,
      borderRadius,
    );

    if (tooltipRRect != RRect.zero) {
      _tooltipPaths.add(Path()..addRRect(tooltipRRect));
      _computeGroupTooltipLabels(
          alignPosition, tooltipRRect, totalLabelSize, labelStyle, isRtl);
    }
  }

  void _computeGroupTooltipLabels(Offset alignPosition, RRect tooltipRRect,
      Size totalLabelSize, TextStyle textStyle, bool isRtl) {
    bool hasIndicator = false;
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent != null && parent.indicatorArea != null) {
      hasIndicator = true;
    }

    final bool canShowMarker = tooltipSettings.canShowMarker;
    final double markerSize = canShowMarker ? trackballTooltipMarkerSize : 0;
    const double halfMarkerSize = trackballTooltipMarkerSize / 2;
    // It specifies for marker position calculation.
    double totalLabelHeight = tooltipRRect.top + defaultTrackballPadding;
    // It specifies for label position calculation with label style.
    double eachTextHeight = 0;

    final String? header = chartPointInfo[0].header;
    if (header != null && header != '') {
      const double headerPadding = defaultTooltipWidth;
      final TextStyle boldStyle = _createLabelStyle(FontWeight.bold, textStyle);
      final Size headerSize = measureText(header, boldStyle);
      final double headerHeight = headerSize.height;
      totalLabelHeight += headerHeight;
      eachTextHeight += headerHeight;

      _tooltipLabels.add(_TooltipLabels(
        header,
        boldStyle,
        Offset(tooltipRRect.left + tooltipRRect.width / 2,
                tooltipRRect.top + headerHeight / 2 + headerPadding / 2)
            .translate(-headerSize.width / 2, -headerSize.height / 2),
      ));

      // Divider offset calculation.
      _dividerStartOffset = Offset(tooltipRRect.left + headerPadding,
          tooltipRRect.top + headerHeight + headerPadding);
      _dividerEndOffset = Offset(tooltipRRect.right - headerPadding,
          tooltipRRect.top + headerHeight + headerPadding);
    }

    // Empty text size consideration between the header and series text.
    final Size emptyTextSize = measureText('', textStyle);
    final double emptyTextHeight = emptyTextSize.height;
    totalLabelHeight += emptyTextHeight;
    eachTextHeight += emptyTextHeight;

    final bool hasFormat = tooltipSettings.format != null;
    double padding = defaultTrackballPadding;
    if (isRtl && !canShowMarker) {
      if (hasFormat) {
        padding += halfMarkerSize;
      } else {
        padding = halfMarkerSize;
      }
    } else if (!isRtl && !canShowMarker && !hasFormat) {
      padding += padding;
    }

    final double rectLeftWithPadding = tooltipRRect.left + padding;
    final double rectRightWithPadding = tooltipRRect.right - padding;
    final double markerX = isRtl
        ? rectRightWithPadding - halfMarkerSize
        : rectLeftWithPadding + halfMarkerSize;
    final double x = isRtl
        ? rectRightWithPadding - markerSize
        : rectLeftWithPadding + markerSize;
    final double y = tooltipRRect.top + defaultTrackballPadding;
    final int length = chartPointInfo.length;
    for (int i = 0; i < length; i++) {
      final ChartPointInfo pointInfo = chartPointInfo[i];
      final String text = pointInfo.label!;
      final Size actualLabelSize = measureText(text, textStyle);
      final double actualLabelHeight = actualLabelSize.height;
      totalLabelHeight += actualLabelHeight;
      // Apply gap between xYDataSeries and SBS series types.
      if (!hasFormat && text.contains('\n')) {
        totalLabelHeight += defaultTrackballPadding;
      }

      // Marker position calculation.
      if (canShowMarker) {
        Offset markerPosition;
        if (text.contains('\n') && hasIndicator) {
          markerPosition = Offset(markerX,
              totalLabelHeight - actualLabelHeight + defaultTrackballPadding);
        } else {
          markerPosition =
              Offset(markerX, totalLabelHeight - actualLabelHeight / 2);
        }

        _computeTooltipMarkers(pointInfo, markerPosition);
      }

      // Label style and position calculation.
      final double dy = y + eachTextHeight;
      if (hasFormat) {
        final double dx = canShowMarker ? x : x + defaultTrackballPadding;
        _computeFormatTooltipLabels(dx, dy, text, textStyle, isRtl);
      } else {
        _computeDefaultTooltipLabels(x, dy, text, textStyle, isRtl);
        // Apply gap between xYDataSeries and SBS series types.
        if (text.contains('\n')) {
          eachTextHeight += defaultTrackballPadding;
        }
      }
      eachTextHeight += actualLabelHeight;
    }
  }

  Size _labelSize(String text, TextStyle textStyle) {
    if (text != '') {
      if (text.contains('<b>') && text.contains('</b>')) {
        text = text.replaceAll('<b>', '').replaceAll('</b>', '');
        return measureText(text, _createLabelStyle(FontWeight.bold, textStyle));
      }
    }
    return measureText(text, textStyle);
  }

  Size _labelSizeForGroupAllPoints(TextStyle textStyle) {
    double width = 0;
    double height = 0;
    final bool hasFormat = tooltipSettings.format != null;
    final TextStyle boldStyle = _createLabelStyle(FontWeight.bold, textStyle);
    TextStyle labelStyle = boldStyle;
    if (hasFormat) {
      final String format = tooltipSettings.format!;
      if ((!format.contains('<b>') || !format.contains('</b>')) &&
          (format.contains(':') && format.split(':').length != 2)) {
        labelStyle = textStyle;
      }
    }

    // Header text size.
    final String? header = chartPointInfo[0].header;
    if (header != null) {
      final Size headerSize = _labelSize(header, boldStyle);
      if (headerSize.width > width) {
        width = headerSize.width;
      }
      height += headerSize.height;
    }

    // Empty text size consideration.
    final Size emptyTextSize = measureText('', labelStyle);
    if (emptyTextSize.width > width) {
      width = emptyTextSize.width;
    }
    height += emptyTextSize.height;

    final int length = chartPointInfo.length;
    for (int i = 0; i < length; i++) {
      final String? label = chartPointInfo[i].label;
      if (label != null) {
        final Size labelSize = _labelSize(label, labelStyle);
        if (labelSize.width > width) {
          width = labelSize.width;
        }
        height += labelSize.height;
        // Apply gap between xYDataSeries and SBS series types.
        if (!hasFormat && label.contains('\n')) {
          height += defaultTrackballPadding;
        }
      }
    }
    return Size(width, height);
  }

  Offset _defaultGroupPosition(double xPosition, double yPosition) {
    double xPos = xPosition;
    double yPos = yPosition;
    if (_isTransposed) {
      switch (tooltipAlignment) {
        case ChartAlignment.near:
          xPos = _plotAreaBounds.top;
          break;

        case ChartAlignment.center:
          xPos = _plotAreaBounds.center.dx;
          break;

        case ChartAlignment.far:
          xPos = _plotAreaBounds.bottom;
          break;
      }
    } else {
      switch (tooltipAlignment) {
        case ChartAlignment.near:
          yPos = _plotAreaBounds.top;
          break;

        case ChartAlignment.center:
          yPos = _plotAreaBounds.center.dy;
          break;

        case ChartAlignment.far:
          yPos = _plotAreaBounds.bottom;
          break;
      }
    }
    return Offset(xPos, yPos);
  }

  Offset _markerPosition(RRect tooltipRRect, double labelWidth,
      double labelHeight, double markerPadding, bool isRtl) {
    final double padding = labelWidth / 2 + markerPadding;
    return Offset(
      (tooltipRRect.left + tooltipRRect.width / 2) +
          (isRtl ? padding : -padding),
      tooltipRRect.top + tooltipRRect.height / 2,
    );
  }

  Rect _tooltipRect(double x, double y, double width, double height) {
    if (tooltipSettings.canShowMarker) {
      return Rect.fromLTWH(
          x,
          y,
          width + (trackballTooltipMarkerSize + trackballTooltipPadding),
          height + defaultTooltipWidth);
    } else {
      return Rect.fromLTWH(x, y, width + trackballTooltipMarkerSize,
          height + defaultTooltipWidth);
    }
  }

  Offset _alignPosition(
      double xPosition,
      double yPosition,
      double rectWidth,
      double rectHeight,
      double arrowLength,
      double arrowWidth,
      double padding,
      bool isRtl,
      [bool isGroupMode = false]) {
    double xPos = xPosition;
    double yPos = yPosition;
    if (yPosition > arrowLength + rectHeight) {
      _isTop = true;
      _isRight = false;
      if (_isTransposed) {
        final double totalWidth = _plotAreaBounds.left + _plotAreaBounds.width;
        final double halfRectWidth = rectWidth / 2;
        xPos = xPosition - halfRectWidth;
        if (xPos < _plotAreaBounds.left) {
          xPos = _plotAreaBounds.left;
        } else if ((xPosition + halfRectWidth) > totalWidth) {
          xPos = totalWidth - rectWidth;
        }

        yPos = (yPosition - rectHeight) - padding;
        yPos = yPos - arrowLength;
        if (yPos + rectHeight >= _plotAreaBounds.bottom) {
          yPos = _plotAreaBounds.bottom - rectHeight;
        }
      } else {
        yPos = yPosition - rectHeight / 2;
        if (!isRtl) {
          if (xPos + rectWidth + padding + arrowLength >
              _plotAreaBounds.right) {
            xPos = isGroupMode
                ? xPos - rectWidth - groupAllPadding
                : xPos - rectWidth - padding - arrowLength;
            _isLeft = true;
          } else {
            xPos = isGroupMode
                ? xPosition + groupAllPadding
                : xPosition + padding + arrowLength;
            _isLeft = false;
            _isRight = true;
          }
        } else {
          xPos = isGroupMode
              ? xPos - rectWidth - groupAllPadding
              : xPos - rectWidth - padding - arrowLength;
          if (xPos < _plotAreaBounds.left) {
            xPos = isGroupMode
                ? xPosition + groupAllPadding
                : xPosition + padding + arrowLength;
            _isRight = true;
          } else {
            _isLeft = true;
          }
        }
        if (yPos + rectHeight >= _plotAreaBounds.bottom) {
          yPos = _plotAreaBounds.bottom - rectHeight;
        }
      }
    } else {
      _isTop = false;
      if (_isTransposed) {
        final double totalWidth = _plotAreaBounds.left + _plotAreaBounds.width;
        final double halfRectWidth = rectWidth / 2;
        xPos = xPosition - halfRectWidth;
        if (xPos < _plotAreaBounds.left) {
          xPos = _plotAreaBounds.left;
        } else if ((xPosition + halfRectWidth) > totalWidth) {
          xPos = totalWidth - rectWidth;
        }

        yPos = (yPosition + arrowLength) + padding;
      } else {
        if (isGroupMode) {
          xPos = xPosition - rectWidth / 2;
          yPos = yPosition - rectHeight / 2;
        } else {
          yPos = (yPosition + arrowLength / 2) + padding;
        }

        if (!isRtl) {
          if ((isGroupMode
                  ? (xPos + (rectWidth / 2) + groupAllPadding)
                  : xPos + rectWidth + padding + arrowLength) >
              _plotAreaBounds.right) {
            xPos = isGroupMode
                ? (xPos - (rectWidth / 2) - groupAllPadding)
                : xPos - rectWidth - padding - arrowLength;
            _isLeft = true;
          } else {
            xPos = isGroupMode
                ? xPosition + groupAllPadding
                : xPosition + padding + arrowLength;
            _isRight = true;
          }
        } else {
          if (xPosition - rectWidth - padding - arrowLength >
              _plotAreaBounds.left) {
            xPos = isGroupMode
                ? (xPos - (rectWidth / 2) - groupAllPadding)
                : xPos - rectWidth - padding - arrowLength;
            _isLeft = true;
          } else {
            xPos = isGroupMode
                ? xPosition + groupAllPadding
                : xPosition + padding + arrowLength;
            _isRight = true;
          }
        }

        if (isGroupMode) {
          if ((yPos + rectHeight) >= _plotAreaBounds.bottom) {
            yPos = _plotAreaBounds.bottom / 2 - rectHeight / 2;
          }

          if (yPos <= _plotAreaBounds.top) {
            yPos = _plotAreaBounds.top;
          }
        }
      }
    }

    return Offset(xPos, yPos);
  }

  RRect _validateRect(
      Rect tooltipRRect, Rect plotAreaBounds, double borderRadius) {
    if (tooltipRRect == Rect.zero ||
        tooltipRRect.width >= plotAreaBounds.width ||
        tooltipRRect.height >= plotAreaBounds.height) {
      return RRect.zero;
    }

    double rectLeft = tooltipRRect.left;
    double rectRight = tooltipRRect.right;
    if (tooltipRRect.left < plotAreaBounds.left) {
      final double left = plotAreaBounds.left - tooltipRRect.left;
      rectLeft += left;
      rectRight += left;
    } else if (tooltipRRect.right > plotAreaBounds.right) {
      final double right = tooltipRRect.right - plotAreaBounds.right;
      rectLeft -= right;
      rectRight -= right;
    }

    RRect alignedRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(rectLeft, tooltipRRect.top, rectRight, tooltipRRect.bottom),
      Radius.circular(borderRadius),
    );

    if (alignedRect.left < plotAreaBounds.left ||
        alignedRect.right > plotAreaBounds.right) {
      alignedRect = RRect.zero;
    }
    return alignedRect;
  }

  Path _nosePath(String tooltipPosition, RRect tooltipRect, Offset position,
      double arrowLength, double arrowWidth) {
    final Path nosePath = Path();
    final double tooltipLeft = tooltipRect.left;
    final double tooltipRight = tooltipRect.right;
    final double tooltipTop = tooltipRect.top;
    final double tooltipBottom = tooltipRect.bottom;
    final double rectHalfWidth = tooltipRect.width / 2;
    final double rectHalfHeight = tooltipRect.height / 2;
    switch (tooltipPosition) {
      case 'Left':
        nosePath.moveTo(tooltipRight, tooltipTop + rectHalfHeight - arrowWidth);
        nosePath.lineTo(
            tooltipRight, tooltipBottom - rectHalfHeight + arrowWidth);
        nosePath.lineTo(tooltipRight + arrowLength, position.dy);
        nosePath.close();
        return nosePath;

      case 'Right':
        nosePath.moveTo(tooltipLeft, tooltipTop + rectHalfHeight - arrowWidth);
        nosePath.lineTo(
            tooltipLeft, tooltipBottom - rectHalfHeight + arrowWidth);
        nosePath.lineTo(tooltipLeft - arrowLength, position.dy);
        nosePath.close();
        return nosePath;

      case 'Top':
        nosePath.moveTo(position.dx, tooltipBottom + arrowLength);
        nosePath.lineTo(
            (tooltipRight - rectHalfWidth) + arrowWidth, tooltipBottom);
        nosePath.lineTo(
            (tooltipLeft + rectHalfWidth) - arrowWidth, tooltipBottom);
        nosePath.close();
        return nosePath;

      case 'Bottom':
        nosePath.moveTo(position.dx, tooltipTop - arrowLength);
        nosePath.lineTo(
            (tooltipRight - rectHalfWidth) + arrowWidth, tooltipTop);
        nosePath.lineTo((tooltipLeft + rectHalfWidth) - arrowWidth, tooltipTop);
        nosePath.close();
        return nosePath;
    }
    return nosePath;
  }

  String _tooltipDirection() {
    if (_isRight) {
      return 'Right';
    } else if (_isLeft) {
      return 'Left';
    } else if (_isTop) {
      return 'Top';
    } else {
      return 'Bottom';
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

  void _computeTooltipMarkers(ChartPointInfo pointInfo, Offset markerPosition) {
    final Color color = pointInfo.color!;
    final ChartMarker marker = ChartMarker()
      ..x = markerPosition.dx
      ..y = markerPosition.dy
      ..index = pointInfo.dataPointIndex!
      ..height = tooltipMarkerSize
      ..width = tooltipMarkerSize
      ..borderColor = color
      ..borderWidth = 1
      ..color = color;
    if (markerSettings != null) {
      marker.merge(
        borderColor: markerSettings!.borderColor ?? color,
        color: markerSettings!.color ?? color,
        image: markerSettings!.image,
        type: markerSettings!.shape,
      );
    }
    marker.position =
        Offset(marker.x - marker.width / 2, marker.y - marker.height / 2);
    marker.shader = _markerShader(
        pointInfo, marker.position & Size(marker.height, marker.width));
    _tooltipMarkers.add(marker);
  }

  Shader? _markerShader(ChartPointInfo pointInfo, Rect bounds) {
    final dynamic series = pointInfo.series;
    if (series is CartesianSeriesRenderer) {
      if (series.onCreateShader != null) {
        final ShaderDetails details = ShaderDetails(bounds, 'marker');
        return series.onCreateShader!(details);
      } else if (series.gradient != null) {
        return series.gradient!.createShader(bounds);
      }
    }
    return null;
  }

  void _computeLineMarkers(ThemeData themeData, List<ChartMarker> source) {
    final Color themeFillColor = themeData.colorScheme.surface;
    final int length = chartPointInfo.length;
    for (int i = 0; i < length; i++) {
      final ChartPointInfo pointInfo = chartPointInfo[i];
      final Color color = pointInfo.color!;
      final ChartMarker marker = ChartMarker()
        ..x = pointInfo.markerXPos!
        ..y = pointInfo.markerYPos!
        ..index = pointInfo.dataPointIndex!
        ..borderColor = color
        ..color = themeFillColor;
      if (markerSettings != null) {
        marker.merge(
          borderColor: markerSettings!.borderColor ?? color,
          borderWidth: markerSettings!.borderWidth,
          color: markerSettings!.color ?? themeFillColor,
          height: markerSettings!.height,
          width: markerSettings!.width,
          image: markerSettings!.image,
          type: markerSettings!.shape,
        );
      }
      marker.position =
          Offset(marker.x - marker.width / 2, marker.y - marker.height / 2);
      source.add(marker);
    }
  }

  void _computeTooltipLabels(
    String text,
    double width,
    double height,
    TextStyle textStyle,
    RRect tooltipRRect,
    bool isRtl,
  ) {
    final bool canShowMarker = tooltipSettings.canShowMarker;
    final double markerSize = canShowMarker ? trackballTooltipMarkerSize : 0;
    final double padding = canShowMarker ? 0 : defaultTrackballPadding;
    final double markerSizeWithPadding = defaultTrackballPadding + markerSize;
    final double x = isRtl
        ? tooltipRRect.right - markerSizeWithPadding - padding
        : tooltipRRect.left + markerSizeWithPadding + padding;
    final double y = tooltipRRect.top + defaultTrackballPadding;
    if (tooltipSettings.format != null) {
      _computeFormatTooltipLabels(x, y, text, textStyle, isRtl);
    } else {
      // It represents for SBS type series.
      if (text.contains('\n') || text.contains(':')) {
        _computeDefaultTooltipLabels(x, y, text, textStyle, isRtl);
      } else {
        // It represents for xYDataSeries.
        final TextStyle boldStyle =
            _createLabelStyle(FontWeight.bold, textStyle);
        final Offset offset =
            Offset(isRtl ? x - measureText(text, boldStyle).width : x, y);
        _tooltipLabels.add(_TooltipLabels(text, boldStyle, offset));
      }
    }
  }

  void _computeDefaultTooltipLabels(
      double x, double y, String text, TextStyle textStyle, bool isRtl) {
    final TextStyle boldStyle = _createLabelStyle(FontWeight.bold, textStyle);
    double eachTextHeight = 0;
    final List<String> labels = text.split('\n');
    final int labelsLength = labels.length;
    for (int i = 0; i < labelsLength; i++) {
      final String label = labels[i];
      double dx = x;
      final double dy = y + eachTextHeight;
      if (label.contains(':')) {
        final List<String> parts = label.split(':');
        if (parts.length == 2) {
          final String leftText = '${parts[0]}:';
          final Size leftSize = measureText(leftText, textStyle);
          final String rightText = isRtl ? ' ${parts[1]}' : parts[1];
          final Size rightSize = measureText(rightText, textStyle);
          eachTextHeight += isRtl ? rightSize.height : leftSize.height;
          if (isRtl) {
            dx -= rightSize.width;
            _tooltipLabels
                .add(_TooltipLabels(rightText, textStyle, Offset(dx, dy)));
            dx -= leftSize.width;
            _tooltipLabels
                .add(_TooltipLabels(leftText, boldStyle, Offset(dx, dy)));
          } else {
            _tooltipLabels
                .add(_TooltipLabels(leftText, textStyle, Offset(dx, dy)));
            dx += leftSize.width;
            _tooltipLabels
                .add(_TooltipLabels(rightText, boldStyle, Offset(dx, dy)));
          }
        }
      } else {
        final Size labelSize = measureText(label, boldStyle);
        if (isRtl) {
          dx -= labelSize.width;
        }
        _tooltipLabels.add(_TooltipLabels(label, boldStyle, Offset(dx, dy)));
        eachTextHeight += labelSize.height;
      }
    }
  }

  void _computeFormatTooltipLabels(
      double x, double y, String text, TextStyle textStyle, bool isRtl) {
    if (text.contains('\n')) {
      _multiLineLabelFormat(x, y, text, textStyle, isRtl);
    } else {
      // If the text contains a single colon and is not already formatted with
      // bold tags, apply the default labelStyle. Otherwise, use the single line
      // label format.
      if (text.split(':').length == 2 &&
          (!(text.contains('<b>') && text.contains('</b>')))) {
        _computeDefaultTooltipLabels(x, y, text, textStyle, isRtl);
      } else {
        _singleLineLabelFormat(x, y, text, textStyle, isRtl);
      }
    }
  }

  void _multiLineLabelFormat(
      double x, double y, String label, TextStyle textStyle, bool isRtl) {
    double dy = y;
    final List<String> multiLines = label.split('\n');
    for (final String text in multiLines) {
      // If the text contains a single colon and is not already formatted with
      // bold tags, apply the default labelStyle. Otherwise, use the single line
      // label format.
      if (text.split(':').length == 2 &&
          (!(text.contains('<b>') && text.contains('</b>')))) {
        _computeDefaultTooltipLabels(x, dy, text, textStyle, isRtl);
      } else {
        _singleLineLabelFormat(x, dy, text, textStyle, isRtl);
      }
      final Size textSize = measureText(text, textStyle);
      dy += textSize.height;
    }
  }

  void _singleLineLabelFormat(
      double x, double y, String label, TextStyle textStyle, bool isRtl) {
    final TextStyle boldStyle = _createLabelStyle(FontWeight.bold, textStyle);
    double dx = x;
    if (label.contains('<b>') && label.contains('</b>')) {
      if (isRtl) {
        final List<String> boldParts = label.split('</b>');
        final int length = boldParts.length;
        final int boldPartsStart = length - 1;
        for (int i = boldPartsStart; i >= 0; --i) {
          final String text = boldParts[i];
          if (text == '') {
            continue;
          }

          if (text.contains('<b>') || text.contains('</b>')) {
            final List<String> parts = text.split('<b>');
            final int length = parts.length;
            final int partsStart = length - 1;
            for (int j = partsStart; j >= 0; --j) {
              final String part = parts[j];
              if (part == '') {
                continue;
              }

              final TextStyle currentStyle =
                  j == partsStart ? boldStyle : textStyle;
              final Size textSize = measureText(part, currentStyle);
              dx -= textSize.width;
              _tooltipLabels
                  .add(_TooltipLabels(part, currentStyle, Offset(dx, y)));
            }
          } else {
            dx -= measureText(text, textStyle).width;
            _tooltipLabels.add(_TooltipLabels(text, textStyle, Offset(dx, y)));
          }
        }
      } else {
        final List<String> boldParts = label.split('<b>');
        final int length = boldParts.length;
        for (int i = 0; i < length; i++) {
          final String text = boldParts[i];
          if (text == '') {
            continue;
          }

          if (text.contains('<b>') || text.contains('</b>')) {
            final List<String> parts = text.split('</b>');
            final int length = parts.length;
            for (int j = 0; j < length; j++) {
              final String part = parts[j];
              if (part == '') {
                continue;
              }

              final TextStyle currentStyle = j == 0 ? boldStyle : textStyle;
              final Size textSize = measureText(part, currentStyle);
              _tooltipLabels
                  .add(_TooltipLabels(part, currentStyle, Offset(dx, y)));
              dx += textSize.width;
            }
          } else {
            _tooltipLabels.add(_TooltipLabels(text, textStyle, Offset(dx, y)));
            dx += measureText(text, textStyle).width;
          }
        }
      }
    } else {
      final TextStyle style = !label.contains(':') ? boldStyle : textStyle;
      final Size labelSize = measureText(label, style);
      dx = isRtl ? x - labelSize.width : x;
      _tooltipLabels.add(_TooltipLabels(label, style, Offset(dx, y)));
    }
  }

  /// Override this method to customize the trackball tooltip labels
  /// and it's positions and line rendering.
  @override
  void onPaint(PaintingContext context, Offset offset,
      SfChartThemeData chartThemeData, ThemeData themeData) {
    _drawTrackballLine(context, offset, chartThemeData, themeData);
    // Draw line marker.
    _drawMarkers(context, chartThemeData, _lineMarkers);
    _drawLabel(context, offset, chartThemeData, themeData);
  }

  void _drawTrackballLine(PaintingContext context, Offset offset,
      SfChartThemeData chartThemeData, ThemeData themeData) {
    if (chartPointInfo.isNotEmpty && lineType != TrackballLineType.none) {
      final Paint paint = Paint()
        ..isAntiAlias = true
        ..color = (lineColor ?? chartThemeData.crosshairLineColor)!
        ..strokeWidth = lineWidth
        ..style = PaintingStyle.stroke;

      _drawLine(
          context, offset, chartThemeData, themeData, lineDashArray, paint);
    }
  }

  void _drawLine(
    PaintingContext context,
    Offset offset,
    SfChartThemeData chartThemeData,
    ThemeData themeData,
    List<double>? dashArray,
    Paint paint,
  ) {
    if (parentBox == null) {
      return;
    }

    final Rect plotAreaBounds = parentBox!.paintBounds;
    final Path path = Path();
    if (_isTransposed) {
      final double y = chartPointInfo[0].yPosition!;
      path
        ..moveTo(plotAreaBounds.left, y)
        ..lineTo(plotAreaBounds.right, y);
    } else {
      final double x = chartPointInfo[0].xPosition!;
      path
        ..moveTo(x, plotAreaBounds.top)
        ..lineTo(x, plotAreaBounds.bottom);
    }
    drawDashes(context.canvas, dashArray, paint, path: path);
  }

  void _drawLabel(PaintingContext context, Offset offset,
      SfChartThemeData chartThemeData, ThemeData themeData) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }

    final bool isRtl = parent.textDirection == TextDirection.rtl;
    if (tooltipDisplayMode != TrackballDisplayMode.none) {
      // Draw tooltip rectangle.
      if (_tooltipPaths.isNotEmpty) {
        final Color themeBackgroundColor =
            chartThemeData.crosshairBackgroundColor!;
        final Paint fillPaint = Paint()
          ..color = tooltipSettings.color ?? themeBackgroundColor
          ..isAntiAlias = true
          ..style = PaintingStyle.fill;
        final Paint strokePaint = Paint()
          ..color = tooltipSettings.borderColor ?? themeBackgroundColor
          ..strokeWidth = tooltipSettings.borderWidth
          ..strokeCap = StrokeCap.butt
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke;
        final int length = _tooltipPaths.length;
        for (int i = 0; i < length; i++) {
          final Path path = _tooltipPaths[i];
          context.canvas.drawPath(path, strokePaint);
          context.canvas.drawPath(path, fillPaint);
        }
      }

      // Draw tooltip marker.
      _drawMarkers(context, chartThemeData, _tooltipMarkers);

      // Draw divider.
      if (tooltipDisplayMode == TrackballDisplayMode.groupAllPoints &&
          _dividerStartOffset != null &&
          _dividerEndOffset != null) {
        context.canvas.drawLine(
          _dividerStartOffset!,
          _dividerEndOffset!,
          Paint()
            ..color = chartThemeData.tooltipSeparatorColor!
            ..strokeWidth = 1
            ..style = PaintingStyle.stroke
            ..isAntiAlias = true,
        );
      }

      // Draw tooltip labels.
      if (_tooltipLabels.isNotEmpty) {
        final int length = _tooltipLabels.length;
        for (int i = 0; i < length; i++) {
          final _TooltipLabels label = _tooltipLabels[i];
          _drawText(
              context.canvas, label.text, label.position, label.style, isRtl);
        }
      }
    }
  }

  void _drawMarkers(PaintingContext context, SfChartThemeData chartThemeData,
      List<ChartMarker> markers) {
    if (markers.isNotEmpty) {
      final Paint fillPaint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.fill;
      final Paint strokePaint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.stroke;
      for (final ChartMarker marker in markers) {
        fillPaint
          ..color = marker.color!
          ..shader = marker.shader;
        strokePaint
          ..color = marker.borderColor!
          ..strokeWidth = marker.borderWidth;
        _drawMarker(
          context.canvas,
          marker.position,
          Size(marker.width, marker.height),
          marker.type,
          fillPaint,
          strokePaint,
        );
      }
    }
  }

  void _drawMarker(Canvas canvas, Offset position, Size size,
      DataMarkerType type, Paint fillPaint, Paint strokePaint) {
    if (position.isNaN) {
      return;
    }

    if (type == DataMarkerType.image) {
      if (_trackballImage != null) {
        paintImage(
            canvas: canvas, rect: position & size, image: _trackballImage!);
      }
    } else if (type != DataMarkerType.none) {
      paint(
        canvas: canvas,
        rect: position & size,
        shapeType: toShapeMarkerType(type),
        paint: fillPaint,
        borderPaint: strokePaint,
      );
    }
  }

  void _drawText(Canvas canvas, String text, Offset position, TextStyle style,
      bool isRtl) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textAlign: isRtl ? TextAlign.right : TextAlign.left,
      maxLines: getMaxLinesContent(text),
      textDirection: TextDirection.ltr,
    );
    textPainter
      ..layout()
      ..paint(canvas, position);
  }
}

class TrackballBuilderOpacityWidget extends Opacity {
  const TrackballBuilderOpacityWidget({
    super.key,
    super.child,
    required super.opacity,
  });

  @override
  RenderOpacity createRenderObject(BuildContext context) {
    return TrackballOpacityRenderBox(
      opacity: opacity,
      alwaysIncludeSemantics: alwaysIncludeSemantics,
    );
  }
}

class TrackballOpacityRenderBox extends RenderOpacity {
  TrackballOpacityRenderBox({
    super.opacity = 1.0,
    super.alwaysIncludeSemantics = false,
    super.child,
  });
}

class TrackballBuilderRenderObjectWidget extends SingleChildRenderObjectWidget {
  const TrackballBuilderRenderObjectWidget(
      {Key? key,
      this.index,
      required this.xPos,
      required this.yPos,
      required this.builder,
      required this.chartPointInfo,
      required this.trackballBehavior,
      required Widget child})
      : super(key: key, child: child);

  final int? index;
  final double xPos;
  final double yPos;
  final Widget builder;
  final List<ChartPointInfo>? chartPointInfo;
  final TrackballBehavior trackballBehavior;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return TrackballBuilderRenderBox(
      index,
      xPos,
      yPos,
      builder,
      chartPointInfo,
      trackballBehavior,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant TrackballBuilderRenderBox renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..index = index
      ..xPos = xPos
      ..yPos = yPos
      ..builder = builder
      ..chartPointInfo = chartPointInfo
      ..trackballBehavior = trackballBehavior;
  }
}

/// Render the annotation widget in the respective position.
class TrackballBuilderRenderBox extends RenderShiftedBox {
  /// Creates an instance of trackball template render box.
  TrackballBuilderRenderBox(this.index, this.xPos, this.yPos, this._builder,
      this.chartPointInfo, this.trackballBehavior,
      [RenderBox? child])
      : super(child);

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
  late Rect plotAreaBounds;

  /// Specifies the value of padding.
  num padding = 10;

  /// Specifies the value of trackball behavior.
  TrackballBehavior trackballBehavior;

  /// Specifies whether to group all the points.
  bool isGroupAllPoints = false;

  /// Specifies whether it is the nearest point.
  bool isNearestPoint = false;

  /// Specifies whether tooltip is present at right.
  bool isRight = false;

  /// Specifies whether tooltip is present at bottom.
  bool isBottom = false;

  /// Specifies whether the template is present inside the bounds.
  bool isTemplateInBounds = true;
  // Offset arrowOffset;

  /// Holds the tooltip position.
  _TooltipPositions? _tooltipPosition;

  /// Holds the value of box parent data.
  late BoxParentData childParentData;

  /// Gets and sets the builder widget.
  Widget get builder => _builder;
  Widget _builder;
  set builder(Widget value) {
    if (_builder != value) {
      _builder = value;
      markNeedsLayout();
    }
  }

  bool isTransposed = false;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    if (child != null && child!.parentData != null) {
      final BoxParentData childParentData = child!.parentData! as BoxParentData;
      return result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          return child!.hitTest(result, position: transformed);
        },
      );
    }
    return false;
  }

  @override
  void performLayout() {
    size = constraints.biggest;
    isTransposed = chartPointInfo != null &&
        chartPointInfo!.isNotEmpty &&
        chartPointInfo![0].series!.isTransposed;
    final TrackballDisplayMode tooltipDisplayMode =
        trackballBehavior.tooltipDisplayMode;
    isGroupAllPoints =
        tooltipDisplayMode == TrackballDisplayMode.groupAllPoints;
    isNearestPoint = tooltipDisplayMode == TrackballDisplayMode.nearestPoint;

    final List<num>? tooltipTop = <num>[];
    final List<num> tooltipBottom = <num>[];
    final List<RenderChartAxis> xAxesInfo = <RenderChartAxis>[];
    final List<RenderChartAxis> yAxesInfo = <RenderChartAxis>[];
    final bool isTrackballMarkerEnabled =
        trackballBehavior.markerSettings != null;

    final List<Offset> visiblePoints = trackballBehavior._visiblePoints;
    pointerLength = trackballBehavior.tooltipSettings.arrowLength;
    pointerWidth = trackballBehavior.tooltipSettings.arrowWidth;
    plotAreaBounds = trackballBehavior._plotAreaBounds;
    final double boundaryLeft = plotAreaBounds.left;
    final double boundaryRight = plotAreaBounds.right;
    final num totalWidth = boundaryLeft + plotAreaBounds.width;
    double left;
    double top;
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      if (child!.parentData is BoxParentData) {
        childParentData = child!.parentData as BoxParentData;
        final double sizeFullWidth = child!.size.width;
        final double sizeFullHeight = child!.size.height;
        final double sizeHalfWidth = sizeFullWidth / 2;
        final double sizeHalfHeight = sizeFullHeight / 2;

        if (isGroupAllPoints) {
          final ChartAlignment tooltipAlignment =
              trackballBehavior.tooltipAlignment;
          if (tooltipAlignment == ChartAlignment.center) {
            yPos = plotAreaBounds.center.dy - sizeHalfHeight;
          } else if (tooltipAlignment == ChartAlignment.near) {
            yPos = plotAreaBounds.top;
          } else {
            yPos = plotAreaBounds.bottom;
          }

          if (yPos + sizeFullHeight > plotAreaBounds.bottom &&
              tooltipAlignment == ChartAlignment.far) {
            yPos = plotAreaBounds.bottom - sizeFullHeight;
          }
        }

        final double markerHalfWidth = isTrackballMarkerEnabled
            ? trackballBehavior.markerSettings!.width / 2
            : 0;

        if (chartPointInfo != null &&
            chartPointInfo!.isNotEmpty &&
            !isGroupAllPoints) {
          final int length = chartPointInfo!.length;
          for (int i = 0; i < length; i++) {
            final dynamic series = chartPointInfo![i].series!;
            final Offset visiblePoint = visiblePoints[i];
            final double closestPointX = visiblePoint.dx;
            final double closestPointY = visiblePoint.dy;
            tooltipTop!.add(isTransposed
                ? closestPointX - sizeHalfWidth
                : closestPointY - sizeHalfHeight);
            tooltipBottom.add(isTransposed
                ? closestPointX + sizeHalfWidth
                : closestPointY + sizeHalfHeight);
            xAxesInfo.add(series.xAxis!);
            yAxesInfo.add(series.yAxis!);
          }

          if (tooltipTop != null && tooltipTop.isNotEmpty) {
            _tooltipPosition = trackballBehavior._smartTooltipPositions(
                tooltipTop,
                tooltipBottom,
                xAxesInfo,
                yAxesInfo,
                chartPointInfo!,
                isTransposed ? 8 : 5);
          }

          if (isNearestPoint) {
            left = isTransposed
                ? xPos + sizeHalfWidth
                : xPos + padding + markerHalfWidth;
            top = isTransposed
                ? yPos + padding + markerHalfWidth
                : yPos - sizeHalfHeight;
          } else {
            left = (isTransposed
                    ? _tooltipPosition!.tooltipTop[index!]
                    : xPos + padding + markerHalfWidth)
                .toDouble();
            top = (isTransposed
                    ? yPos + pointerLength + markerHalfWidth
                    : _tooltipPosition!.tooltipTop[index!])
                .toDouble();
          }

          if (!isTransposed) {
            if (left + sizeFullWidth > totalWidth) {
              isRight = true;
              left = xPos - sizeFullWidth - pointerLength - markerHalfWidth;
            } else {
              isRight = false;
            }
          } else {
            if (top + sizeFullHeight > plotAreaBounds.bottom) {
              isBottom = true;
              top = yPos - sizeFullHeight - pointerLength - markerHalfWidth;
            } else {
              isBottom = false;
            }
          }

          trackballTemplateRect =
              Rect.fromLTWH(left, top, sizeFullWidth, sizeFullHeight);
          double xPlotOffset =
              visiblePoints.first.dx - trackballTemplateRect!.width / 2;
          final double rightTemplateEnd =
              xPlotOffset + trackballTemplateRect!.width;
          final double leftTemplateEnd = xPlotOffset;

          if (_isTemplateWithinBounds(plotAreaBounds, trackballTemplateRect!)) {
            isTemplateInBounds = true;
            childParentData.offset = Offset(left, top);
          } else if (plotAreaBounds.width > trackballTemplateRect!.width &&
              plotAreaBounds.height > trackballTemplateRect!.height) {
            isTemplateInBounds = true;
            if (rightTemplateEnd > boundaryRight) {
              xPlotOffset = xPlotOffset - (rightTemplateEnd - boundaryRight);
              if (xPlotOffset < boundaryLeft) {
                xPlotOffset = xPlotOffset + (boundaryLeft - xPlotOffset);
                if (xPlotOffset + trackballTemplateRect!.width >
                    boundaryRight) {
                  xPlotOffset = xPlotOffset -
                      (totalWidth +
                          trackballTemplateRect!.width -
                          boundaryRight);
                }
                if (xPlotOffset < boundaryLeft || xPlotOffset > boundaryRight) {
                  isTemplateInBounds = false;
                }
              }
            } else if (leftTemplateEnd < boundaryLeft) {
              xPlotOffset = xPlotOffset + (boundaryLeft - leftTemplateEnd);
              if (xPlotOffset + trackballTemplateRect!.width > boundaryRight) {
                xPlotOffset = xPlotOffset -
                    (totalWidth + trackballTemplateRect!.width - boundaryRight);
                if (xPlotOffset < boundaryLeft) {
                  xPlotOffset = xPlotOffset + (boundaryLeft - xPlotOffset);
                }
                if (xPlotOffset < boundaryLeft ||
                    xPlotOffset + trackballTemplateRect!.width >
                        boundaryRight) {
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
          if (visiblePoints.isNotEmpty) {
            if (xPos + sizeFullWidth > totalWidth) {
              xPos = xPos - sizeFullWidth - 2 * padding - markerHalfWidth;
            }

            trackballTemplateRect =
                Rect.fromLTWH(xPos, yPos, sizeFullWidth, sizeFullHeight);
            double xPlotOffset =
                visiblePoints.first.dx - trackballTemplateRect!.width / 2;
            final double rightTemplateEnd =
                xPlotOffset + trackballTemplateRect!.width;
            final double leftTemplateEnd = xPlotOffset;

            if (_isTemplateWithinBounds(
                    plotAreaBounds, trackballTemplateRect!) &&
                (boundaryRight > trackballTemplateRect!.right &&
                    boundaryLeft < trackballTemplateRect!.left)) {
              isTemplateInBounds = true;
              childParentData.offset = Offset(
                  xPos +
                      (trackballTemplateRect!.right + padding > boundaryRight
                          ? trackballTemplateRect!.right +
                              padding -
                              boundaryRight
                          : padding) +
                      markerHalfWidth,
                  yPos);
            } else if (plotAreaBounds.width > trackballTemplateRect!.width &&
                plotAreaBounds.height > trackballTemplateRect!.height) {
              isTemplateInBounds = true;
              if (rightTemplateEnd > boundaryRight) {
                xPlotOffset = xPlotOffset - (rightTemplateEnd - boundaryRight);
                if (xPlotOffset < boundaryLeft) {
                  xPlotOffset = xPlotOffset + (boundaryLeft - xPlotOffset);
                  if (xPlotOffset + trackballTemplateRect!.width >
                      boundaryRight) {
                    xPlotOffset = xPlotOffset -
                        (totalWidth +
                            trackballTemplateRect!.width -
                            boundaryRight);
                  }
                  if (xPlotOffset < boundaryLeft ||
                      xPlotOffset > boundaryRight) {
                    isTemplateInBounds = false;
                  }
                }
              } else if (leftTemplateEnd < boundaryLeft) {
                xPlotOffset = xPlotOffset + (boundaryLeft - leftTemplateEnd);
                if (xPlotOffset + trackballTemplateRect!.width >
                    boundaryRight) {
                  xPlotOffset = xPlotOffset -
                      (xPlotOffset +
                          trackballTemplateRect!.width -
                          boundaryRight);
                  if (xPlotOffset < boundaryLeft) {
                    xPlotOffset = xPlotOffset + (boundaryLeft - xPlotOffset);
                  }
                  if (xPlotOffset < boundaryLeft ||
                      xPlotOffset > boundaryRight) {
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
      }
    }
    if (!isGroupAllPoints && index == chartPointInfo!.length - 1) {
      tooltipTop?.clear();
      tooltipBottom.clear();
      yAxesInfo.clear();
      xAxesInfo.clear();
    }
  }

  /// To check template is within bounds.
  bool _isTemplateWithinBounds(Rect plotAreaBounds, Rect templateRect) {
    final double triplePadding = (3 * padding).toDouble();
    final Rect rect = Rect.fromLTWH(
        padding + templateRect.left,
        triplePadding + templateRect.top,
        templateRect.width,
        templateRect.height);
    final Rect axisBounds = Rect.fromLTWH(
        padding + plotAreaBounds.left,
        triplePadding + plotAreaBounds.top,
        plotAreaBounds.width,
        plotAreaBounds.height);
    return rect.left >= axisBounds.left &&
        rect.left + rect.width <= axisBounds.left + axisBounds.width &&
        rect.top >= axisBounds.top &&
        rect.bottom <= axisBounds.top + axisBounds.height;
  }

  void _calculateMarkerPositions(PaintingContext context,
      SfChartThemeData chartThemeData, ThemeData themeData) {
    final TrackballMarkerSettings? markerSettings =
        trackballBehavior.markerSettings;
    if ((chartPointInfo != null && chartPointInfo!.isEmpty) ||
        markerSettings == null ||
        markerSettings.markerVisibility == TrackballVisibilityMode.hidden) {
      return;
    }

    final List<ChartMarker> markers = <ChartMarker>[];
    trackballBehavior._computeLineMarkers(themeData, markers);
    trackballBehavior._drawMarkers(context, chartThemeData, markers);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final SfChartThemeData chartThemeData = trackballBehavior._chartThemeData!;
    final ThemeData themeData = trackballBehavior._themeData!;
    _calculateMarkerPositions(context, chartThemeData, themeData);

    final bool isTemplateWithInBoundsInTransposedChart =
        _isTemplateWithinBounds(plotAreaBounds, trackballTemplateRect!);
    if ((!isTransposed && isTemplateInBounds) ||
        (isTransposed && isTemplateWithInBoundsInTransposedChart)) {
      super.paint(context, offset);
    }

    if (!isGroupAllPoints) {
      final Color chartThemeBackgroundColor =
          chartThemeData.crosshairBackgroundColor!;
      final ChartPointInfo pointInfo = chartPointInfo![index!];
      final Color color = pointInfo.series is IndicatorRenderer
          ? pointInfo.color
          : (pointInfo.series!.color) ?? chartThemeBackgroundColor;
      final InteractiveTooltip tooltipSettings =
          trackballBehavior.tooltipSettings;
      final Paint fillPaint = Paint()
        ..color = tooltipSettings.color ?? color
        ..isAntiAlias = true
        ..style = PaintingStyle.fill;
      final Paint strokePaint = Paint()
        ..color = tooltipSettings.borderColor ?? color
        ..strokeWidth = tooltipSettings.borderWidth
        ..strokeCap = StrokeCap.butt
        ..isAntiAlias = true
        ..style = PaintingStyle.stroke;

      if (trackballTemplateRect!.left > plotAreaBounds.left &&
          trackballTemplateRect!.right < plotAreaBounds.right) {
        final RRect templateRRect = RRect.fromRectAndRadius(
            Rect.fromLTWH(
                offset.dx + trackballTemplateRect!.left,
                offset.dy + trackballTemplateRect!.top,
                trackballTemplateRect!.width,
                trackballTemplateRect!.height),
            Radius.zero);

        String nosePosition = '';
        if (!isTransposed) {
          if (!isRight) {
            nosePosition = 'Right';
          } else {
            nosePosition = 'Left';
          }
        } else if (isTemplateInBounds &&
            isTemplateWithInBoundsInTransposedChart) {
          if (!isBottom) {
            nosePosition = 'Bottom';
          } else {
            nosePosition = 'Top';
          }
        }

        final Path nosePath = trackballBehavior._nosePath(nosePosition,
            templateRRect, Offset(xPos, yPos), pointerLength, pointerWidth);

        if (isTemplateInBounds) {
          context.canvas.drawPath(nosePath, fillPaint);
          context.canvas.drawPath(nosePath, strokePaint);
        }
      }
    }
  }
}

/// Options to customize the markers that are displayed when
/// trackball is enabled.
///
/// Trackball markers are used to provide information about the exact
/// point location, when the trackball is visible. You can add a shape to adorn
/// each data point. Trackball markers can be enabled by using the
/// [markerVisibility] property in [TrackballMarkerSettings].
/// Provides the options like color, border width, border color and shape of the
/// marker to customize the appearance.
class TrackballMarkerSettings extends MarkerSettings {
  /// Creating an argument constructor of TrackballMarkerSettings class.
  const TrackballMarkerSettings({
    this.markerVisibility = TrackballVisibilityMode.auto,
    super.height,
    super.width,
    super.color,
    super.shape,
    super.borderWidth,
    super.borderColor,
    super.image,
  });

  /// Whether marker should be visible or not when trackball is enabled.
  ///
  /// The below values are applicable for this:
  /// * TrackballVisibilityMode.auto - If the [isVisible] property in the series
  /// `markerSettings` is set to true, then the trackball marker will also be
  /// displayed for that particular series, else it will not be displayed.
  /// * TrackballVisibilityMode.visible - Makes the trackball marker visible
  /// for all the series,
  /// irrespective of considering the [isVisible] property's value in the
  /// `markerSettings`.
  /// * TrackballVisibilityMode.hidden - Hides the trackball marker for all
  /// the series.
  ///
  /// Defaults to `TrackballVisibilityMode.auto`.
  ///
  /// Also refer [TrackballVisibilityMode].
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(
  ///     enable: true,
  ///     markerSettings: TrackballMarkerSettings(
  ///       markerVisibility:  TrackballVisibilityMode.visible,
  ///       width: 10
  ///     )
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  ///```
  final TrackballVisibilityMode markerVisibility;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is TrackballMarkerSettings &&
        other.markerVisibility == markerVisibility &&
        other.height == height &&
        other.width == width &&
        other.color == color &&
        other.shape == shape &&
        other.borderWidth == borderWidth &&
        other.borderColor == borderColor &&
        other.image == image;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      markerVisibility,
      height,
      width,
      color,
      shape,
      borderWidth,
      borderColor,
      image
    ];
    return Object.hashAll(values);
  }
}

class TrackballInfo {
  TrackballInfo({
    required this.position,
    this.name,
    this.color,
  });

  /// Local position of the tooltip.
  final Offset? position;

  /// Specifies the series name.
  final String? name;

  /// Specifies the series color.
  final Color? color;
}

class ChartTrackballInfo<T, D> extends TrackballInfo {
  ChartTrackballInfo({
    required super.position,
    required this.point,
    required this.series,
    required this.seriesIndex,
    required this.segmentIndex,
    required this.pointIndex,
    this.header,
    this.text,
    this.lowYPos,
    this.highXPos,
    this.highYPos,
    this.openXPos,
    this.openYPos,
    this.closeXPos,
    this.closeYPos,
    this.minYPos,
    this.maxXPos,
    this.maxYPos,
    this.lowerXPos,
    this.lowerYPos,
    this.upperXPos,
    this.upperYPos,
    super.name,
    super.color,
  });

  final CartesianChartPoint<D> point;
  final dynamic series;
  final int seriesIndex;
  final int segmentIndex;
  final int pointIndex;
  final String? header;
  final String? text;

  double? lowYPos;
  double? highXPos;
  double? highYPos;
  double? openXPos;
  double? openYPos;
  double? closeXPos;
  double? closeYPos;
  double? minYPos;
  double? maxXPos;
  double? maxYPos;
  double? lowerXPos;
  double? lowerYPos;
  double? upperXPos;
  double? upperYPos;
}

/// Class to store trackball tooltip start and end positions.
class _TooltipPositions {
  /// Creates the parameterized constructor for the class TooltipPositions.
  const _TooltipPositions(this.tooltipTop, this.tooltipBottom);

  /// Specifies the tooltip top value.
  final List<num> tooltipTop;

  /// Specifies the tooltip bottom value.
  final List<num> tooltipBottom;
}

/// Class to store trackball tooltip label, label style and positions.
class _TooltipLabels {
  /// Creates the parameterized constructor for the class _TooltipLabels.
  _TooltipLabels(this.text, this.style, this.position);

  /// Specifies the tooltip label value.
  final String text;

  /// Specifies the tooltip label style value.
  final TextStyle style;

  /// Specifies the tooltip label position value.
  final Offset position;
}
