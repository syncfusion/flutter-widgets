part of charts;

/// Renders the stacked line series.
///
/// A stacked line chart is a line chart in which lines do not overlap because they are cumulative at each point.
///
/// A stacked line chart displays series as a set of points connected by a line.
///
/// To render a stacked line chart, create an instance of StackedLineSeries, and add it to the series collection property of [SfCartesianChart].
/// Provides options to customise [color], [opacity], [width] of the Stacked Line segments.
class StackedLineSeries<T, D> extends _StackedSeriesBase<T, D> {
  /// Creating an argument constructor of StackedLineSeries class.
  StackedLineSeries(
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
      bool? isVisible,
      String? name,
      bool? enableTooltip,
      List<double>? dashArray,
      double? animationDuration,
      String? groupName,
      List<Trendline>? trendlines,
      // ignore: deprecated_member_use_from_same_package
      SelectionSettings? selectionSettings,
      SelectionBehavior? selectionBehavior,
      bool? isVisibleInLegend,
      LegendIconType? legendIconType,
      SortingOrder? sortingOrder,
      String? legendItemText,
      double? opacity,
      SeriesRendererCreatedCallback? onRendererCreated,
      List<int>? initialSelectedDataIndexes})
      : super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            name: name,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            trendlines: trendlines,
            yAxisName: yAxisName,
            color: color,
            width: width ?? 2,
            markerSettings: markerSettings,
            emptyPointSettings: emptyPointSettings,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            enableTooltip: enableTooltip,
            dashArray: dashArray,
            animationDuration: animationDuration,
            selectionSettings: selectionSettings,
            selectionBehavior: selectionBehavior,
            legendItemText: legendItemText,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            groupName: groupName,
            opacity: opacity,
            onRendererCreated: onRendererCreated,
            initialSelectedDataIndexes: initialSelectedDataIndexes);

  /// to create a Stacked line series renderer
  StackedLineSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    StackedLineSeriesRenderer stackedLineSeriesRenderer;
    if (onCreateRenderer != null) {
      stackedLineSeriesRenderer =
          onCreateRenderer!(series) as StackedLineSeriesRenderer;
      assert(stackedLineSeriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return stackedLineSeriesRenderer;
    }
    return StackedLineSeriesRenderer();
  }
}

/// Creates series renderer for Stacked line series
class StackedLineSeriesRenderer extends _StackedSeriesRenderer {
  /// Calling the default constructor of StackedLineSeriesRenderer class.
  StackedLineSeriesRenderer();

  ///Stacked line segment is created here
  // ignore: unused_element
  ChartSegment _createSegments(
      CartesianChartPoint<dynamic> currentPoint,
      CartesianChartPoint<dynamic> _nextPoint,
      int pointIndex,
      int seriesIndex,
      double animationFactor,
      double currentCummulativePos,
      double nextCummulativePos) {
    final StackedLineSegment segment = createSegment();
    final List<CartesianSeriesRenderer>? _oldSeriesRenderers =
        _chartState!._oldSeriesRenderers;
    _isRectSeries = false;
    if (segment != null) {
      segment._seriesRenderer = this;
      segment._series = _series as XyDataSeries;
      segment._seriesIndex = seriesIndex;
      segment._currentPoint = currentPoint;
      segment.currentSegmentIndex = pointIndex;
      segment._nextPoint = _nextPoint;
      segment._chart = _chart;
      segment._chartState = _chartState!;
      segment.animationFactor = animationFactor;
      segment._pointColorMapper = currentPoint.pointColorMapper;
      segment._currentCummulativePos = currentCummulativePos;
      segment._nextCummulativePos = nextCummulativePos;
      if (_chartState!._widgetNeedUpdate &&
          _xAxisRenderer!._zoomFactor == 1 &&
          _yAxisRenderer!._zoomFactor == 1 &&
          _oldSeriesRenderers != null &&
          _oldSeriesRenderers.isNotEmpty &&
          _oldSeriesRenderers.length - 1 >= segment._seriesIndex &&
          _oldSeriesRenderers[segment._seriesIndex]._seriesName ==
              segment._seriesRenderer._seriesName) {
        segment._oldSeriesRenderer = _oldSeriesRenderers[segment._seriesIndex];
        segment._oldSegmentIndex = _getOldSegmentIndex(segment);
      }
      segment.calculateSegmentPoints();
      segment.points.add(Offset(segment._x1, segment._y1));
      segment.points.add(Offset(segment._x2, segment._y2));
      customizeSegment(segment);
      segment.strokePaint = segment.getStrokePaint();
      segment.fillPaint = segment.getFillPaint();
      _segments.add(segment);
    }
    return segment;
  }

  /// To render stacked line series segments
  //ignore: unused_element
  void _drawSegment(Canvas canvas, ChartSegment segment) {
    if (segment._seriesRenderer._isSelectionEnable) {
      final SelectionBehaviorRenderer? selectionBehaviorRenderer =
          segment._seriesRenderer._selectionBehaviorRenderer;
      selectionBehaviorRenderer?._selectionRenderer?._checkWithSelectionState(
          _segments[segment.currentSegmentIndex!], _chart);
    }
    segment.onPaint(canvas);
  }

  /// Creates a segment for a data point in the series.
  @override
  StackedLineSegment createSegment() => StackedLineSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    segment._color = segment._seriesRenderer._seriesColor;
    segment._strokeColor = segment._seriesRenderer._seriesColor;
    segment._strokeWidth = segment._series.width;
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
