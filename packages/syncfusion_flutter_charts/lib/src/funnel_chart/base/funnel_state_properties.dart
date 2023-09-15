import 'dart:async';

import 'package:flutter/material.dart';

import '../../../charts.dart';
import '../../common/rendering_details.dart';
import '../../common/state_properties.dart';
import '../../common/user_interaction/tooltip.dart';
import '../../common/user_interaction/tooltip_rendering_details.dart';
import '../base/funnel_plot_area.dart';
import '../base/series_base.dart';
import '../renderer/data_label_renderer.dart';

/// Specifies the funnel state properties.
class FunnelStateProperties extends StateProperties {
  /// Creates an instance of funnel chart properties.
  FunnelStateProperties(
      {required this.renderingDetails, required this.chartState})
      : super(renderingDetails, chartState) {
    renderingDetails.didSizeChange = false;
  }

  /// Specifies the funnel chart.
  @override
  SfFunnelChart get chart => chartState.widget;

  /// Specifies the funnel chart state.
  @override
  final SfFunnelChartState chartState;

  /// Specifies the rendering details value.
  @override
  final RenderingDetails renderingDetails;

  /// Specifies the funnel data label renderer.
  FunnelDataLabelRenderer? renderDataLabel;

  /// Specifies the tooltip point index.
  int? tooltipPointIndex;

  /// Specifies the series type.
  late String seriesType;

  ///  Specifies the data points.
  late List<PointInfo<dynamic>> dataPoints;

  /// Specifies the render points
  late List<PointInfo<dynamic>> renderPoints;

  /// Specifies the data label rects.
  late List<Rect> labelRects = <Rect>[];

  /// Specifies the outside render labels.
  late List<Rect> outsideRects = <Rect>[];

  /// Specifies the funnel series.
  late FunnelChartBase chartSeries;

  /// Specifies the funnel plot area.
  late FunnelPlotArea funnelplotArea;

  /// Specifies whether the text direction of chart widget is RTL or LTR.
  late bool isRtl;

  /// Specifies whether the legend is refreshed
  bool legendRefresh = false;

  /// To redraw chart elements.
  void redraw() {
    renderingDetails.initialRender = false;
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
