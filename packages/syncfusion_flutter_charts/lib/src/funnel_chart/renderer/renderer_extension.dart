import 'package:flutter/material.dart';
import '../../chart/common/data_label.dart';
import '../../common/user_interaction/selection_behavior.dart';
import '../../pyramid_chart/utils/common.dart';
import '../base/funnel_state_properties.dart';
import 'funnel_series.dart';

/// Creates a series renderer extension for Funnel series.
class FunnelSeriesRendererExtension extends FunnelSeriesRenderer {
  /// Calling the default constructor of FunnelSeriesRendererBase class.
  FunnelSeriesRendererExtension() {
    seriesType = 'funnel';
  }

  /// Specifies the funnel series.
  late FunnelSeries<dynamic, dynamic> series;

  /// Specifies the funnel series.
  late String seriesType;

  /// Specifies the data points.
  late List<PointInfo<dynamic>> dataPoints;

  /// Specifies the render points.
  late List<PointInfo<dynamic>> renderPoints;

  /// Specifies the value of sum of points.
  late num sumOfPoints;

  /// Specifies the triangular size.
  late Size triangleSize;

  /// Specifies the funnel neck size.
  late Size neckSize;

  /// Specifies the distance explode.
  late num explodeDistance;

  /// Specifies the maximum data label region.
  late Rect maximumDataLabelRegion;

  /// Specifies the funnel series controller.
  FunnelSeriesController? controller;

  /// Specifies the funnel state properties.
  late FunnelStateProperties stateProperties;

  /// Specifies the repaint notifier.
  late ValueNotifier<int> repaintNotifier;

  /// Specifies the data label setting renderer.
  late DataLabelSettingsRenderer dataLabelSettingsRenderer;

  /// Specifies the selection behavior renderer.
  late SelectionBehaviorRenderer selectionBehaviorRenderer;

  /// Specifies the value of selection behavior.
  late SelectionBehavior selectionBehavior;

  /// Specifies whether the selection is enables.
  bool isSelectionEnable = false;

  /// Specifies whether to repaint the chart.
  bool needsRepaint = true;
}
