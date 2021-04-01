part of charts;

///Renders the FastLineSeries.
///
///FastLineSeries is a line chart, but it loads faster than LineSeries.
///
/// You can use this when there are large number of points to be loaded in a chart. To render a fast line chart,
///  create an instance of FastLineSeries, and add it to the series collection property of [SfCartesianChart].
///
/// The following properties are used to customize the appearance of fast line segment:
///
/// * color – Changes the color of the line.
/// * opacity - Controls the transparency of the chart series.
/// * width – Changes the stroke width of the line.
class FastLineSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of FastLineSeries class.
  FastLineSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      required List<T> dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic>? sortFieldValueMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      String? xAxisName,
      String? yAxisName,
      Color? color,
      double? width,
      List<double>? dashArray,
      LinearGradient? gradient,
      MarkerSettings? markerSettings,
      EmptyPointSettings? emptyPointSettings,
      List<Trendline>? trendlines,
      DataLabelSettings? dataLabelSettings,
      SortingOrder? sortingOrder,
      bool? isVisible,
      String? name,
      bool? enableTooltip,
      double? animationDuration,
      // ignore: deprecated_member_use_from_same_package
      SelectionSettings? selectionSettings,
      SelectionBehavior? selectionBehavior,
      bool? isVisibleInLegend,
      LegendIconType? legendIconType,
      String? legendItemText,
      double? opacity,
      SeriesRendererCreatedCallback? onRendererCreated})
      : super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            name: name,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            trendlines: trendlines,
            color: color,
            width: width ?? 2,
            gradient: gradient,
            dashArray: dashArray,
            markerSettings: markerSettings,
            emptyPointSettings: emptyPointSettings,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            enableTooltip: enableTooltip,
            animationDuration: animationDuration,
            selectionSettings: selectionSettings,
            selectionBehavior: selectionBehavior,
            legendItemText: legendItemText,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            onRendererCreated: onRendererCreated,
            opacity: opacity);

  /// Create the fastline series renderer.
  FastLineSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    FastLineSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as FastLineSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return FastLineSeriesRenderer();
  }
}

/// Creates series renderer for Fastline series
class FastLineSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of FastLineSeriesRenderer class.
  FastLineSeriesRenderer();

  //ignore: prefer_final_fields
  List<CartesianChartPoint<dynamic>> _overallDataPoints =
      <CartesianChartPoint<dynamic>>[];

  ///Adds the segment to the segments list
  ChartSegment _createSegments(
      int seriesIndex, SfCartesianChart chart, double animateFactor,
      [List<Offset>? _points]) {
    final FastLineSegment segment = createSegment();
    segment._series = _series as XyDataSeries;
    segment._seriesIndex = seriesIndex;
    segment._seriesRenderer = this;
    segment.animationFactor = animateFactor;
    if (_points != null) segment.points = _points;
    segment._oldSegmentIndex = 0;
    customizeSegment(segment);
    segment._chart = chart;
    _segments.add(segment);
    return segment;
  }

  ///Renders the segment.
  //ignore: unused_element
  void _drawSegment(Canvas canvas, ChartSegment segment) {
    if (segment._seriesRenderer._isSelectionEnable) {
      final SelectionBehaviorRenderer? selectionBehaviorRenderer =
          segment._seriesRenderer._selectionBehaviorRenderer;
      selectionBehaviorRenderer?._selectionRenderer
          ?._checkWithSelectionState(_segments[0], _chart);
    }
    segment.onPaint(canvas);
  }

  /// Creates a segment for a data point in the series.
  @override
  FastLineSegment createSegment() => FastLineSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final FastLineSegment fastLineSegment = segment as FastLineSegment;
    fastLineSegment._color = fastLineSegment._seriesRenderer._seriesColor;
    fastLineSegment._strokeColor = fastLineSegment._seriesRenderer._seriesColor;
    fastLineSegment._strokeWidth = fastLineSegment._series.width;
    fastLineSegment.strokePaint = fastLineSegment.getStrokePaint();
    fastLineSegment.fillPaint = fastLineSegment.getFillPaint();
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
