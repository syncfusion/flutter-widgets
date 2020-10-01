part of charts;

/// This class holds the properties of the bubble series.
///
/// To render a bubble chart, create an instance of [BubbleSeries], and add it to the series collection property of [SfCartesianChart].
/// A bubble chart requires three fields (X, Y, and Size) to plot a point. Here, [sizeValueMapper] is used to map the size of each bubble segment from the data source.
///
/// Provide the options for color, opacity, border color, and border width to customize the appearance.
///
class BubbleSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of BubbleSeries class.
  BubbleSeries(
      {ValueKey<String> key,
      ChartSeriesRendererFactory<T, D> onCreateRenderer,
      @required List<T> dataSource,
      @required ChartValueMapper<T, D> xValueMapper,
      @required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic> sortFieldValueMapper,
      ChartValueMapper<T, num> sizeValueMapper,
      ChartValueMapper<T, Color> pointColorMapper,
      ChartValueMapper<T, String> dataLabelMapper,
      String xAxisName,
      String yAxisName,
      Color color,
      MarkerSettings markerSettings,
      List<Trendline> trendlines,
      num minimumRadius,
      num maximumRadius,
      EmptyPointSettings emptyPointSettings,
      DataLabelSettings dataLabelSettings,
      bool isVisible,
      String name,
      bool enableTooltip,
      List<double> dashArray,
      double animationDuration,
      Color borderColor,
      double borderWidth,
      LinearGradient gradient,
      LinearGradient borderGradient,
      // ignore: deprecated_member_use_from_same_package
      SelectionSettings selectionSettings,
      SelectionBehavior selectionBehavior,
      bool isVisibleInLegend,
      LegendIconType legendIconType,
      SortingOrder sortingOrder,
      String legendItemText,
      double opacity,
      SeriesRendererCreatedCallback onRendererCreated,
      List<int> initialSelectedDataIndexes})
      : minimumRadius = minimumRadius ?? 3,
        maximumRadius = maximumRadius ?? 10,
        super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            name: name,
            onRendererCreated: onRendererCreated,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            sizeValueMapper: sizeValueMapper,
            dataSource: dataSource,
            trendlines: trendlines,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            color: color,
            markerSettings: markerSettings,
            emptyPointSettings: emptyPointSettings,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            enableTooltip: enableTooltip,
            dashArray: dashArray,
            animationDuration: animationDuration,
            borderColor: borderColor,
            borderWidth: borderWidth,
            gradient: gradient,
            borderGradient: borderGradient,
            selectionSettings: selectionSettings,
            selectionBehavior: selectionBehavior,
            legendItemText: legendItemText,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            opacity: opacity,
            initialSelectedDataIndexes: initialSelectedDataIndexes);

  ///Maximum radius value of the bubble in the series.
  ///
  ///Defaults to `10`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <BubbleSeries<BubbleColors, num>>[
  ///                BubbleSeries<BubbleColors, num>(
  ///                  maximumRadius: 9
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final num maximumRadius;

  ///Minimum radius value of the bubble in the series.
  ///
  ///Defaults to `3`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <BubbleSeries<BubbleColors, num>>[
  ///                BubbleSeries<BubbleColors, num>(
  ///                  minimumRadius: 2
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final num minimumRadius;

  /// Create the bubble series renderer.
  BubbleSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    BubbleSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer(series);
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return BubbleSeriesRenderer();
  }
}

/// Creates series renderer for Bubble series
class BubbleSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of BubbleSeriesRenderer class.
  BubbleSeriesRenderer();

  // Store the maximum size //
  num _maxSize;

  // Store the minimum size //
  num _minSize;

  /// To add bubble segments to segment list
  ChartSegment _createSegments(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, num animateFactor) {
    final BubbleSegment segment = createSegment();
    final List<CartesianSeriesRenderer> oldSeriesRenderers =
        _chartState._oldSeriesRenderers;
    _isRectSeries = false;
    if (segment != null) {
      segment._seriesIndex = seriesIndex;
      segment.currentSegmentIndex = pointIndex;
      segment.points
          .add(Offset(currentPoint.markerPoint.x, currentPoint.markerPoint.y));
      segment._seriesIndex = seriesIndex;
      segment._series = _series;
      segment.animationFactor = animateFactor;
      segment._currentPoint = currentPoint;
      segment._seriesRenderer = this;
      if (_chartState._widgetNeedUpdate &&
          oldSeriesRenderers != null &&
          oldSeriesRenderers.isNotEmpty &&
          oldSeriesRenderers.length - 1 >= segment._seriesIndex &&
          oldSeriesRenderers[segment._seriesIndex]._seriesName ==
              segment._seriesRenderer._seriesName) {
        segment._oldSeriesRenderer = oldSeriesRenderers[segment._seriesIndex];
        segment._oldPoint =
            (segment._oldSeriesRenderer._dataPoints.length - 1 >= pointIndex)
                ? segment._oldSeriesRenderer._dataPoints[pointIndex]
                : null;
      }
      segment.calculateSegmentPoints();
      customizeSegment(segment);
      segment.strokePaint = segment.getStrokePaint();
      segment.fillPaint = segment.getFillPaint();
      _segments.add(segment);
    }
    return segment;
  }

  /// To draw bubble segments
  //ignore: unused_element
  void _drawSegment(Canvas canvas, ChartSegment segment) {
    if (segment._seriesRenderer._isSelectionEnable) {
      final SelectionBehaviorRenderer selectionBehaviorRenderer =
          segment._seriesRenderer._selectionBehaviorRenderer;
      selectionBehaviorRenderer._selectionRenderer._checkWithSelectionState(
          _segments[segment.currentSegmentIndex], _chart);
    }
    segment.onPaint(canvas);
  }

  /// Creates a segment for a data point in the series.
  @override
  ChartSegment createSegment() => BubbleSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final BubbleSegment bubbleSegment = segment;
    bubbleSegment._color = bubbleSegment._seriesRenderer._seriesColor;
    bubbleSegment._strokeColor = bubbleSegment._series.borderColor ??
        bubbleSegment._seriesRenderer._seriesColor;
    bubbleSegment._strokeWidth = bubbleSegment._series.borderWidth;
    bubbleSegment.strokePaint = bubbleSegment.getStrokePaint();
    bubbleSegment.fillPaint = bubbleSegment.getFillPaint();
  }

  ///Draws marker with different shape and color of the appropriate data point in the series.
  @override
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY,
      [CartesianSeriesRenderer seriesRenderer]) {
    canvas.drawPath(seriesRenderer._markerShapes[index], fillPaint);
    canvas.drawPath(seriesRenderer._markerShapes[index], strokePaint);
  }

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      _drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}
