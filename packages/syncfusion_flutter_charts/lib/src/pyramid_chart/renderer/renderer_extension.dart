import 'package:flutter/material.dart';
import '../../chart/common/data_label.dart';
import '../../common/user_interaction/selection_behavior.dart';
import '../base/pyramid_state_properties.dart';
import '../utils/common.dart';
import 'pyramid_series.dart';
import 'series_controller.dart';

/// Creates series renderer for Pyramid series.
class PyramidSeriesRendererExtension extends PyramidSeriesRenderer {
  /// Calling the default constructor of PyramidSeriesRenderer class.
  PyramidSeriesRendererExtension() {
    seriesType = 'pyramid';
  }

  /// Specifies the pyramid series.
  late PyramidSeries<dynamic, dynamic> series;

  /// Specifies the series type.
  late String seriesType;

  /// Represents the list of data points.
  late List<PointInfo<dynamic>> dataPoints;

  /// Represents the list of render points.
  List<PointInfo<dynamic>>? renderPoints;

  /// Gets or sets the value of the sum of points.
  late num sumOfPoints;

  /// Specifies the triangle size value.
  late Size triangleSize;

  /// Specifies the explode distance value.
  late num explodeDistance;

  /// Specifies the maximum data label region.
  late Rect maximumDataLabelRegion;

  /// Specifies the value of series controller.
  PyramidSeriesController? controller;

  /// Specifies the state properties.
  late PyramidStateProperties stateProperties;

  /// Specifies the repaint notifier of the series.
  late ValueNotifier<int> repaintNotifier;

  /// Represents the data label setting renderer.
  late DataLabelSettingsRenderer dataLabelSettingsRenderer;

  /// Represents the selection behavior renderer.
  late SelectionBehaviorRenderer selectionBehaviorRenderer;

  /// Specifies the selection behavior.
  late SelectionBehavior selectionBehavior;

  /// Specifies whether the selection is enabled.
  // ignore: prefer_final_fields
  bool isSelectionEnable = false;

  /// Specifies whether to repaint the chart.
  bool needsRepaint = true;
}
