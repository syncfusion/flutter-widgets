import 'dart:async';

import 'package:flutter/material.dart';

import '../../../charts.dart';
import '../../common/rendering_details.dart';
import '../../common/state_properties.dart';
import '../../common/user_interaction/tooltip.dart';
import '../../common/user_interaction/tooltip_rendering_details.dart';
import '../base/pyramid_plot_area.dart';
import '../renderer/data_label_renderer.dart';
import 'chart_base.dart';

/// Represents the pyramid state properties.
class PyramidStateProperties extends StateProperties {
  /// Creates an instance of pyramid state properties.
  PyramidStateProperties(
      {required this.renderingDetails, required this.chartState})
      : super(renderingDetails, chartState) {
    renderingDetails.didSizeChange = false;
  }

  /// Specifies the pyramid chart.
  @override
  SfPyramidChart get chart => chartState.widget;

  /// Specifies the pyramid chart state.
  @override
  final SfPyramidChartState chartState;

  /// Specifies the rendering details value.
  @override
  final RenderingDetails renderingDetails;

  /// Specifies the pyramid data label renderer.
  PyramidDataLabelRenderer? renderDataLabel;

  /// Specifies the tooltip point index value
  int? tooltipPointIndex;

  /// Specifies the series type.
  late String seriesType;

  /// Specifies the list of data points
  late List<PointInfo<dynamic>> dataPoints;

  /// Specifies the list of render points.
  List<PointInfo<dynamic>>? renderPoints;

  /// Specifies the data label rects.
  late List<Rect> labelRects = <Rect>[];

  /// Specifies the outside rendered label rects
  late List<Rect> outsideRects = <Rect>[];

  /// Specifies the pyramid chart base.
  late PyramidChartBase chartSeries;

  /// Specifies the pyramid plot area.
  late PyramidPlotArea chartPlotArea;

  /// Specifies whether the text direction of chart widget is RTL or LTR.
  late bool isRtl;

  /// Specifies whether the legend is refreshed
  bool legendRefresh = false;

  /// Method called when animation is completed.
  bool get animationCompleted {
    return renderingDetails.animationController.status !=
        AnimationStatus.forward;
  }

  /// Method to redraw the chart.
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

  /// Tooltip timer.
  Timer? tooltipTimer;

  /// To check the tooltip orientation changes.
  bool isTooltipOrientationChanged = false;

  /// To check if tooltip has been hidden or not.
  bool isTooltipHidden = false;
}
