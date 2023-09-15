import 'dart:async';

import 'package:flutter/material.dart';

import '../../../charts.dart';
import '../../common/rendering_details.dart';
import '../../common/state_properties.dart';
import '../../common/user_interaction/tooltip.dart';
import '../../common/user_interaction/tooltip_rendering_details.dart';
import '../renderer/data_label_renderer.dart';
import '../renderer/renderer_extension.dart';
import 'circular_area.dart';
import 'series_base.dart';

/// Specifies the circular state properties.
class CircularStateProperties extends StateProperties {
  /// Creates an instance of circular chart properties.
  CircularStateProperties(
      {required RenderingDetails renderingDetails, required this.chartState})
      : super(renderingDetails, chartState) {
    renderingDetails.didSizeChange = false;
  }

  /// Specifies the circular chart.
  @override
  SfCircularChart get chart => chartState.widget;

  /// Specifies the circular chart state.
  @override
  final SfCircularChartState chartState;

  /// Specifies the center location
  late Offset centerLocation;

  /// Specifies the annotation region.
  late List<Rect> annotationRegions;

  /// Specifies the data label renderer.
  CircularDataLabelRenderer? renderDataLabel;

  /// Specifies the previous series renderer.
  CircularSeriesRendererExtension? prevSeriesRenderer;

  /// Specifies the previous chart points.
  List<ChartPoint<dynamic>?>? oldPoints;

  /// Holds the information of the series base class.
  late CircularSeriesBase chartSeries;

  /// Specifies the  circular chart area.
  late CircularArea circularArea;

  /// Specifies whether move the label from center.
  late bool needToMoveFromCenter;

  /// Specifies whether to explode the segments.
  late bool needExplodeAll;

  /// Gets or sets the value for is toggled
  late bool isToggled;

  /// Specifies whether the tooltip needs to render for data label or not.
  bool? requireDataLabelTooltip;

  /// Specifies whether the text direction of chart widget is RTL or LTR.
  late bool isRtl;

  /// Specifies whether the legend is refreshed
  bool legendRefresh = false;

  /// To redraw chart elements.
  void redraw() {
    renderingDetails.initialRender = false;
    if (renderingDetails.isLegendToggled) {
      isToggled = true;
      prevSeriesRenderer = chartSeries.visibleSeriesRenderers[0];
      oldPoints = List<ChartPoint<dynamic>?>.filled(
          prevSeriesRenderer!.renderPoints!.length, null);
      for (int i = 0; i < prevSeriesRenderer!.renderPoints!.length; i++) {
        oldPoints![i] = prevSeriesRenderer!.renderPoints![i];
      }
    }
    final TooltipRenderingDetails tooltipRenderingDetails =
        TooltipHelper.getRenderingDetails(
            renderingDetails.tooltipBehaviorRenderer);
    if (tooltipRenderingDetails.chartTooltipState != null) {
      tooltipRenderingDetails.show = false;
    }
    // ignore: invalid_use_of_protected_member
    chartState.setState(() {
      /// The chart will be rebuilding again, When we do the legend toggle, zoom/pan the chart.
    });
  }

  /// Method when called, once animation completed.
  bool get animationCompleted {
    return renderingDetails.animationController.status !=
        AnimationStatus.forward;
  }

  /// Tooltip timer.
  Timer? tooltipTimer;

  /// To check the tooltip orientation changes.
  bool isTooltipOrientationChanged = false;

  /// To check if tooltip has been hidden or not.
  bool isTooltipHidden = false;
}
