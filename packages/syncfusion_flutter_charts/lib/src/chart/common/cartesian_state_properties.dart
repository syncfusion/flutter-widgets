import 'dart:async';
import 'dart:ui' as dart_ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../charts.dart';
import '../../common/rendering_details.dart';
import '../../common/state_properties.dart';
import '../../common/user_interaction/tooltip.dart';
import '../axis/axis.dart';
import '../axis/axis_panel.dart';
import '../axis/axis_renderer.dart';
import '../base/chart_base.dart';
import '../base/series_base.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../common/common.dart';
import '../common/interactive_tooltip.dart';
import '../common/renderer.dart';
import '../technical_indicators/technical_indicator.dart';
import '../user_interaction/trackball.dart';
import '../user_interaction/trackball_marker_setting_renderer.dart';
import '../user_interaction/zooming_panning.dart';

/// Represents the Cartesian state properties class
class CartesianStateProperties extends StateProperties {
  /// Creates an instance of Cartesian state properties
  CartesianStateProperties(
      {required this.renderingDetails, required this.chartState})
      : super(renderingDetails, chartState);

  /// Holds the Cartesian chart state
  @override
  final SfCartesianChartState chartState;

  /// Specifies the chart rendering details
  @override
  late RenderingDetails renderingDetails;

  /// Holds the animation controller along with their listener for all series and trendlines
  late Map<AnimationController, VoidCallback> controllerList;

  /// Holds the value of repaint notifiers
  late Map<String, ValueNotifier<int>> repaintNotifiers;

  /// Holds the value of  zoom axis renderer state
  late List<ChartAxisRenderer> zoomedAxisRendererStates;

  /// Holds the value of old axis renderer
  late List<ChartAxisRenderer> oldAxisRenderers;

  /// Specifies whether the zoom is in progress
  late bool zoomProgress;

  /// Specifies the list of zoom axes
  late List<ZoomAxisRange> zoomAxes;

  /// Specifies the value of selected segments
  late List<ChartSegment> selectedSegments;

  /// Specifies the list of unselected segments
  late List<ChartSegment> unselectedSegments;

  /// Holds the list of data label region
  late List<Rect> renderDatalabelRegions;

  /// Holds the list of annotation region
  late List<Rect> annotationRegions;

  /// Specifies whether the legend is refreshed
  bool legendRefresh = false;

  /// Holds the data label renderer
  DataLabelRenderer? renderDataLabel;

  /// Holds the value axis renderer outside
  late CartesianAxisWidget renderOutsideAxis;

  /// Holds the value axis renderer inside
  late CartesianAxisWidget renderInsideAxis;

  ///Holds the list of old series renderers
  late List<CartesianSeriesRenderer> oldSeriesRenderers;

  /// Holds the list of old series keys
  late List<ValueKey<String>?> oldSeriesKeys;

  /// Holds the  list of segments
  late List<ChartSegment> segments;

  /// Holds the list of old visible series
  late List<bool?> oldSeriesVisible;

  /// Specifies the zoom state
  bool? zoomedState;

  /// Holds the touch state position
  late List<PointerEvent> touchStartPositions;

  /// Holds the touch move position
  late List<PointerEvent> touchMovePositions;

  ///Specifies whether the double tap or mouse hover is enabled
  late bool enableDoubleTap, enableMouseHover;

  /// Specifies whether legend is toggled
  bool legendToggling = false;

  /// Specifies the value of background image
  dart_ui.Image? backgroundImage;

  /// Specifies the value of legend icon image
  dart_ui.Image? legendIconImage;

  /// Specifies whether the trendline is toggled
  bool isTrendlineToggled = false;

  /// Specifies the list of painter keys
  late List<PainterKey> painterKeys;

  /// Specifies whether the trigger is loaded
  late bool triggerLoaded;

  /// Specifies the range change by slider value
  //ignore: preferfinalfields
  bool rangeChangeBySlider = false;

  /// Specifies the value of range changed by chart
  //ignore: preferfinalfields
  bool rangeChangedByChart = false;

  /// Specifies whether the range is selected by slider
  //ignore: preferfinalfields
  bool isRangeSelectionSlider = false;

  /// Specifies whether the series is loaded
  bool? isSeriesLoaded;

  /// Specifies whether update is needed
  late bool isNeedUpdate;

  /// Specifies the list of series renderer
  late List<CartesianSeriesRenderer> seriesRenderers;

  /// Holds the information of AxisBase class
  late ChartAxisPanel chartAxis;

  /// Holds the information of SeriesBase class
  late ChartSeriesPanel chartSeries;

  /// Holds the information of ContainerArea class
  /// ignore: unusedfield
  late ContainerArea containerArea;

  /// Whether to check chart axis is inverted or not
  late bool requireInvertedAxis;

  /// To check if axis trimmed text is tapped
  //ignore: preferfinalfields
  bool requireAxisTooltip = false;

  /// To check the trackball orientation changes.
  bool isTrackballOrientationChanged = false;

  /// To check the crosshair orientation changes.
  bool isCrosshairOrientationChanged = false;

  /// Trackball timer.
  Timer? trackballTimer;

  /// Tooltip timer.
  Timer? tooltipTimer;

  /// To check the tooltip orientation changes.
  bool isTooltipOrientationChanged = false;

  /// To check if tooltip has been hidden or not.
  bool isTooltipHidden = false;

  /// Specifies the list of chart point info
  //ignore: preferfinalfields
  List<ChartPointInfo> chartPointInfo = <ChartPointInfo>[];

  /// Holds the zoom pan behavior renderer
  late ZoomPanBehaviorRenderer zoomPanBehaviorRenderer;

  /// Holds the trackball behavior renderer
  late TrackballBehaviorRenderer trackballBehaviorRenderer;

  /// Holds the cross hair behavior renderer
  late CrosshairBehaviorRenderer crosshairBehaviorRenderer;

  /// Holds the technical indicator renderer
  late List<TechnicalIndicatorsRenderer> technicalIndicatorRenderer;

  /// Holds the trackball marker setting renderer
  late TrackballMarkerSettingsRenderer trackballMarkerSettingsRenderer;

  //Here, we are using get keyword in order to get the proper & updated instance of chart widget
  //When we initialize chart widget as a property to other classes like ChartSeries, the chart widget is not updated properly and by using get we can rectify this.
  @override
  SfCartesianChart get chart => chartState.widget;

  /// Setting series animation duration factor
  double seriesDurationFactor = 0.85;

  /// Setting trendline animation duration factor
  double trendlineDurationFactor = 0.85;

  /// holds the count for total no of series that should be animated
  late int totalAnimatingSeries;

  /// holds the no of animation completed series
  late int animationCompleteCount;

  /// Specifies the value of selection args
  SelectionArgs? selectionArgs;

  /// Specifies whether the touch is up
  bool isTouchUp = false;

  /// Holds the value of load more state setter
  late StateSetter loadMoreViewStateSetter;

  /// Represents the swipe direction
  late ChartSwipeDirection swipeDirection;

  /// Specifies the value of offset
  Offset? startOffset, currentPosition;

  /// Specifies whether redrawn is due to zoom and pan
  late bool isRedrawByZoomPan;

  /// Holds the value of pointer device kind
  late PointerDeviceKind pointerDeviceKind;

  ///To check the load more widget is in progress or not
  late bool isLoadMoreIndicator;

  /// Specifies whether to set the range controller
  bool canSetRangeController = false;

  /// Specifies the shader for series
  Shader? shader;

  /// Specifies total number of rectangle series in chart
  int? sideBySideSeriesCount;

  /// Specifies total number of rectangle indicator series in chart
  int? sideBySideIndicatorCount;

  /// Repaint notifier for plotBand
  late ValueNotifier<int> plotBandRepaintNotifier;

  /// Method to set the painter key
  void setPainterKey(int index, String name, bool renderComplete) {
    int value = 0;
    for (int i = 0; i < painterKeys.length; i++) {
      final PainterKey painterKey = painterKeys[i];
      if (painterKey.isRenderCompleted) {
        value++;
      } else if (painterKey.index == index &&
          painterKey.name == name &&
          !painterKey.isRenderCompleted) {
        painterKey.isRenderCompleted = renderComplete;
        value++;
      }
      if (value >= painterKeys.length && !triggerLoaded) {
        triggerLoaded = true;
      }
    }
  }

  /// Method to check whether the animation is completed
  // ignore: unused_element
  bool get animationCompleted {
    SeriesRendererDetails seriesRendererDetails;
    for (final CartesianSeriesRenderer seriesRenderer in seriesRenderers) {
      seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(seriesRenderer);
      if (seriesRendererDetails.animationController.status ==
          AnimationStatus.forward) {
        return false;
      }
    }
    return true;
  }

  /// Method to repaint the trendlines
  void repaintTrendlines() {
    repaintNotifiers['trendline']!.value++;
  }

  /// Method to forward the animation
  void forwardAnimation(SeriesRendererDetails seriesRendererDetails) {
    final int totalAnimationDuration =
        seriesRendererDetails.series.animationDuration.toInt() +
            seriesRendererDetails.series.animationDelay!.toInt();
    seriesRendererDetails.animationController.duration =
        Duration(milliseconds: totalAnimationDuration);
    const double maxSeriesInterval = 0.8;
    double minSeriesInterval = 0.1;
    minSeriesInterval = seriesRendererDetails.series.animationDelay!.toInt() /
            totalAnimationDuration *
            (maxSeriesInterval - minSeriesInterval) +
        minSeriesInterval;
    seriesRendererDetails.seriesAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: seriesRendererDetails.animationController,
      curve: Interval(minSeriesInterval, maxSeriesInterval,
          curve: Curves.decelerate),
    ));
    seriesRendererDetails.seriesElementAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: seriesRendererDetails.animationController,
      curve: const Interval(0.85, 1.0, curve: Curves.decelerate),
    ));
    seriesRendererDetails.animationController.forward(from: 0.0);
  }

  /// Method to redraw by change
  void redrawByRangeChange() {
    oldAxisRenderers = chartAxis.axisRenderersCollection;
    if (chartState.mounted) {
      // ignore: invalid_use_of_protected_member
      chartState.setState(() {
        /// check the "mounted" property of this object and  to ensure the object is still in the tree.
        /// When we do the range change by using the slider or other way, chart will be rebuilding again.
      });
    }
  }

  /// Redraw method for chart axis
  void redraw() {
    oldAxisRenderers = chartAxis.axisRenderersCollection;
    TooltipHelper.getRenderingDetails(renderingDetails.tooltipBehaviorRenderer)
        .timer
        ?.cancel();
    if (TrackballHelper.getRenderingDetails(trackballBehaviorRenderer)
            .trackballPainter
            ?.timer !=
        null) {
      TrackballHelper.getRenderingDetails(trackballBehaviorRenderer)
          .trackballPainter
          ?.timer!
          .cancel();
    }
    if (renderingDetails.isLegendToggled) {
      segments = <ChartSegment>[];
      oldSeriesVisible =
          List<bool?>.filled(chartSeries.visibleSeriesRenderers.length, null);
      for (int i = 0; i < chartSeries.visibleSeriesRenderers.length; i++) {
        final CartesianSeriesRenderer seriesRenderer =
            chartSeries.visibleSeriesRenderers[i];
        final SeriesRendererDetails seriesRendererDetails =
            SeriesHelper.getSeriesRendererDetails(seriesRenderer);
        if (seriesRenderer is ColumnSeriesRenderer ||
            seriesRenderer is BarSeriesRenderer) {
          for (int j = 0; j < seriesRendererDetails.segments.length; j++) {
            segments.add(seriesRendererDetails.segments[j]);
          }
        }
      }
    }
    // ignore: unnecessary_null_comparison
    if (zoomedAxisRendererStates != null &&
        zoomedAxisRendererStates.isNotEmpty) {
      zoomedState = false;
      for (final ChartAxisRenderer axisRenderer in zoomedAxisRendererStates) {
        zoomedState =
            AxisHelper.getAxisRendererDetails(axisRenderer).zoomFactor != 1;
        if (zoomedState!) {
          break;
        }
      }
    }

    renderingDetails.widgetNeedUpdate = false;

    if (chartState.mounted) {
      // ignore: invalid_use_of_protected_member
      chartState.setState(() {
        /// check the "mounted" property of this object and  to ensure the object is still in the tree.
        /// The chart will be rebuilding again, When we do the legend toggle, zoom/pan the chart.
      });
    }
  }
}
