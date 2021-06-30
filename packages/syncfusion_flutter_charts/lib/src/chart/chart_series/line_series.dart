part of charts;

/// Renders the line series.
///
/// This class holds the properties of line series. To render a Line chart,
/// create an instance of [LineSeries], and add it to the series collection
/// property of [SfCartesianChart]. A line chart requires two fields (X and Y)
/// to plot a point.
///
/// Provide the options for color, opacity, border color, and border width to customize the appearance.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=zhcxdh4-Jt8}
class LineSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of LineSeries class.
  LineSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      required List<T> dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic>? sortFieldValueMapper,
      ChartValueMapper<T, Color>? pointColorMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      String? xAxisName,
      String? yAxisName,
      Color? color,
      double? width,
      MarkerSettings? markerSettings,
      EmptyPointSettings? emptyPointSettings,
      DataLabelSettings? dataLabelSettings,
      List<Trendline>? trendlines,
      bool? isVisible,
      String? name,
      bool? enableTooltip,
      List<double>? dashArray,
      double? animationDuration,
      SelectionBehavior? selectionBehavior,
      bool? isVisibleInLegend,
      LegendIconType? legendIconType,
      SortingOrder? sortingOrder,
      String? legendItemText,
      double? opacity,
      List<int>? initialSelectedDataIndexes,
      SeriesRendererCreatedCallback? onRendererCreated,
      ChartPointInteractionCallback? onPointTap,
      ChartPointInteractionCallback? onPointDoubleTap,
      ChartPointInteractionCallback? onPointLongPress})
      : super(
            key: key,
            onRendererCreated: onRendererCreated,
            onCreateRenderer: onCreateRenderer,
            onPointTap: onPointTap,
            onPointDoubleTap: onPointDoubleTap,
            onPointLongPress: onPointLongPress,
            name: name,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            color: color,
            width: width ?? 2,
            markerSettings: markerSettings,
            emptyPointSettings: emptyPointSettings,
            trendlines: trendlines,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            enableTooltip: enableTooltip,
            dashArray: dashArray,
            animationDuration: animationDuration,
            selectionBehavior: selectionBehavior,
            legendItemText: legendItemText,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            opacity: opacity,
            initialSelectedDataIndexes: initialSelectedDataIndexes);

  /// Create the line series renderer.
  LineSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    LineSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as LineSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return LineSeriesRenderer();
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is LineSeries &&
        other.key == key &&
        other.onCreateRenderer == onCreateRenderer &&
        other.dataSource == dataSource &&
        other.xValueMapper == xValueMapper &&
        other.yValueMapper == yValueMapper &&
        other.sortFieldValueMapper == sortFieldValueMapper &&
        other.dataLabelMapper == dataLabelMapper &&
        other.pointColorMapper == pointColorMapper &&
        other.sortingOrder == sortingOrder &&
        other.xAxisName == xAxisName &&
        other.yAxisName == yAxisName &&
        other.name == name &&
        other.color == color &&
        other.width == width &&
        other.markerSettings == markerSettings &&
        other.emptyPointSettings == emptyPointSettings &&
        other.dataLabelSettings == dataLabelSettings &&
        other.trendlines == trendlines &&
        other.isVisible == isVisible &&
        other.enableTooltip == enableTooltip &&
        other.dashArray == dashArray &&
        other.animationDuration == animationDuration &&
        other.gradient == gradient &&
        other.selectionBehavior == selectionBehavior &&
        other.isVisibleInLegend == isVisibleInLegend &&
        other.legendIconType == legendIconType &&
        other.legendItemText == legendItemText &&
        other.opacity == opacity &&
        other.onRendererCreated == onRendererCreated &&
        other.onPointTap == onPointTap &&
        other.onPointDoubleTap == onPointDoubleTap &&
        other.onPointLongPress == onPointLongPress &&
        other.initialSelectedDataIndexes == initialSelectedDataIndexes;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    final List<Object?> values = <Object?>[
      key,
      onCreateRenderer,
      dataSource,
      xValueMapper,
      yValueMapper,
      sortFieldValueMapper,
      dataLabelMapper,
      pointColorMapper,
      sortingOrder,
      xAxisName,
      yAxisName,
      name,
      color,
      width,
      markerSettings,
      emptyPointSettings,
      dataLabelSettings,
      trendlines,
      isVisible,
      enableTooltip,
      dashArray,
      animationDuration,
      gradient,
      selectionBehavior,
      isVisibleInLegend,
      legendIconType,
      legendItemText,
      opacity,
      onRendererCreated,
      initialSelectedDataIndexes,
      onPointTap,
      onPointDoubleTap,
      onPointLongPress
    ];
    return hashList(values);
  }
}

/// Creates series renderer for Line series
class LineSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of LineSeriesRenderer class.
  LineSeriesRenderer();

  late LineSegment _lineSegment, _segment;

  List<CartesianSeriesRenderer>? _oldSeriesRenderers;

  /// To add line segments to segments list
  ChartSegment _createSegments(
      CartesianChartPoint<dynamic> currentPoint,
      CartesianChartPoint<dynamic> _nextPoint,
      int pointIndex,
      int seriesIndex,
      double animateFactor) {
    _segment = createSegment();
    _oldSeriesRenderers = _chartState!._oldSeriesRenderers;
    _segment._series = _series as XyDataSeries<dynamic, dynamic>;
    _segment._seriesRenderer = this;
    _segment._seriesIndex = seriesIndex;
    _segment._currentPoint = currentPoint;
    _segment.currentSegmentIndex = pointIndex;
    _segment._nextPoint = _nextPoint;
    _segment._chart = _chart;
    _segment._chartState = _chartState!;
    _segment.animationFactor = animateFactor;
    _segment._pointColorMapper = currentPoint.pointColorMapper;
    if (_renderingDetails!.widgetNeedUpdate &&
        _oldSeriesRenderers != null &&
        _oldSeriesRenderers!.isNotEmpty &&
        _oldSeriesRenderers!.length - 1 >= _segment._seriesIndex &&
        _oldSeriesRenderers![_segment._seriesIndex]._seriesName ==
            _segment._seriesRenderer._seriesName) {
      _segment._oldSeriesRenderer = _oldSeriesRenderers![_segment._seriesIndex];
      _segment._oldSegmentIndex = _getOldSegmentIndex(_segment);
    }
    _segment.calculateSegmentPoints();
    _segment.points.add(Offset(_segment._x1, _segment._y1));
    _segment.points.add(Offset(_segment._x2, _segment._y2));
    customizeSegment(_segment);
    _segments.add(_segment);
    return _segment;
  }

  /// To render line series segments
  //ignore: unused_element
  void _drawSegment(Canvas canvas, ChartSegment _segment) {
    if (_segment._seriesRenderer._isSelectionEnable) {
      final SelectionBehaviorRenderer? selectionBehaviorRenderer =
          _segment._seriesRenderer._selectionBehaviorRenderer;
      selectionBehaviorRenderer?._selectionRenderer?._checkWithSelectionState(
          _segments[_segment.currentSegmentIndex!], _chart);
    }
    _segment.onPaint(canvas);
  }

  /// Creates a _segment for a data point in the series.
  @override
  LineSegment createSegment() => LineSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment _segment) {
    _lineSegment = _segment as LineSegment;
    _lineSegment._color = _lineSegment._pointColorMapper ??
        _lineSegment._series.color ??
        _lineSegment._seriesRenderer._seriesColor;
    _lineSegment._strokeColor = _lineSegment._pointColorMapper ??
        _lineSegment._series.color ??
        _lineSegment._seriesRenderer._seriesColor;
    _lineSegment._strokeWidth = _lineSegment._series.width;
    _lineSegment.strokePaint = _lineSegment.getStrokePaint();
    _lineSegment.fillPaint = _lineSegment.getFillPaint();
  }

  ///Draws marker with different shape and color of the appropriate data point in the series.
  @override
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY,
      [CartesianSeriesRenderer? seriesRenderer]) {
    canvas.drawPath(seriesRenderer!._markerShapes[index]!, fillPaint);
    canvas.drawPath(seriesRenderer._markerShapes[index]!, strokePaint);
  }

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      _drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}
