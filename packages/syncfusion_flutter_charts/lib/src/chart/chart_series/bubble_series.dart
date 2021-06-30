part of charts;

/// This class holds the properties of the bubble series.
///
/// To render a bubble chart, create an instance of [BubbleSeries], and add it to the series collection property of [SfCartesianChart].
/// A bubble chart requires three fields (X, Y, and Size) to plot a point. Here, [sizeValueMapper] is used to map the size of each bubble segment from the data source.
///
/// Provide the options for color, opacity, border color, and border width to customize the appearance.
///
@immutable
class BubbleSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of BubbleSeries class.
  BubbleSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      required List<T> dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic>? sortFieldValueMapper,
      ChartValueMapper<T, num>? sizeValueMapper,
      ChartValueMapper<T, Color>? pointColorMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      String? xAxisName,
      String? yAxisName,
      Color? color,
      MarkerSettings? markerSettings,
      List<Trendline>? trendlines,
      this.minimumRadius = 3,
      this.maximumRadius = 10,
      EmptyPointSettings? emptyPointSettings,
      DataLabelSettings? dataLabelSettings,
      bool? isVisible,
      String? name,
      bool? enableTooltip,
      List<double>? dashArray,
      double? animationDuration,
      Color? borderColor,
      double? borderWidth,
      LinearGradient? gradient,
      LinearGradient? borderGradient,
      SelectionBehavior? selectionBehavior,
      bool? isVisibleInLegend,
      LegendIconType? legendIconType,
      SortingOrder? sortingOrder,
      String? legendItemText,
      double? opacity,
      SeriesRendererCreatedCallback? onRendererCreated,
      ChartPointInteractionCallback? onPointTap,
      ChartPointInteractionCallback? onPointDoubleTap,
      ChartPointInteractionCallback? onPointLongPress,
      List<int>? initialSelectedDataIndexes})
      : super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            name: name,
            onRendererCreated: onRendererCreated,
            onPointTap: onPointTap,
            onPointDoubleTap: onPointDoubleTap,
            onPointLongPress: onPointLongPress,
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
      seriesRenderer = onCreateRenderer!(series) as BubbleSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return BubbleSeriesRenderer();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is BubbleSeries &&
        other.key == key &&
        other.onCreateRenderer == onCreateRenderer &&
        other.dataSource == dataSource &&
        other.xValueMapper == xValueMapper &&
        other.yValueMapper == yValueMapper &&
        other.sortFieldValueMapper == sortFieldValueMapper &&
        other.pointColorMapper == pointColorMapper &&
        other.dataLabelMapper == dataLabelMapper &&
        other.sortingOrder == sortingOrder &&
        other.xAxisName == xAxisName &&
        other.yAxisName == yAxisName &&
        other.name == name &&
        other.color == color &&
        other.markerSettings == markerSettings &&
        other.emptyPointSettings == emptyPointSettings &&
        other.dataLabelSettings == dataLabelSettings &&
        other.trendlines == trendlines &&
        other.isVisible == isVisible &&
        other.enableTooltip == enableTooltip &&
        other.dashArray == dashArray &&
        other.animationDuration == animationDuration &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.gradient == gradient &&
        other.borderGradient == borderGradient &&
        other.selectionBehavior == selectionBehavior &&
        other.isVisibleInLegend == isVisibleInLegend &&
        other.legendIconType == legendIconType &&
        other.legendItemText == legendItemText &&
        other.opacity == opacity &&
        other.maximumRadius == maximumRadius &&
        other.minimumRadius == minimumRadius &&
        other.initialSelectedDataIndexes == other.initialSelectedDataIndexes &&
        other.onRendererCreated == onRendererCreated &&
        other.onPointTap == onPointTap &&
        other.onPointDoubleTap == onPointDoubleTap &&
        other.onPointLongPress == onPointLongPress;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      key,
      onCreateRenderer,
      dataSource,
      xValueMapper,
      yValueMapper,
      sortFieldValueMapper,
      pointColorMapper,
      dataLabelMapper,
      sortingOrder,
      xAxisName,
      yAxisName,
      name,
      color,
      markerSettings,
      emptyPointSettings,
      dataLabelSettings,
      trendlines,
      isVisible,
      enableTooltip,
      dashArray,
      animationDuration,
      borderColor,
      borderWidth,
      gradient,
      borderGradient,
      selectionBehavior,
      isVisibleInLegend,
      legendIconType,
      legendItemText,
      opacity,
      maximumRadius,
      minimumRadius,
      initialSelectedDataIndexes,
      onRendererCreated,
      onPointTap,
      onPointDoubleTap,
      onPointLongPress
    ];
    return hashList(values);
  }
}

/// Creates series renderer for Bubble series
class BubbleSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of BubbleSeriesRenderer class.
  BubbleSeriesRenderer();

  // Store the maximum size //
  double? _maxSize;

  // Store the minimum size //
  double? _minSize;

  /// To add bubble segments to segment list
  ChartSegment _createSegments(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, double animateFactor) {
    final BubbleSegment segment = createSegment();
    final List<CartesianSeriesRenderer> oldSeriesRenderers =
        _chartState!._oldSeriesRenderers;
    _isRectSeries = false;
    segment._seriesIndex = seriesIndex;
    segment.currentSegmentIndex = pointIndex;
    segment.points
        .add(Offset(currentPoint.markerPoint!.x, currentPoint.markerPoint!.y));
    segment._seriesIndex = seriesIndex;
    segment._series = _series as XyDataSeries<dynamic, dynamic>;
    segment.animationFactor = animateFactor;
    segment._currentPoint = currentPoint;
    segment._seriesRenderer = this;
    if (_renderingDetails!.widgetNeedUpdate &&
        oldSeriesRenderers.isNotEmpty &&
        oldSeriesRenderers.length - 1 >= segment._seriesIndex &&
        oldSeriesRenderers[segment._seriesIndex]._seriesName ==
            segment._seriesRenderer._seriesName) {
      segment._oldSeriesRenderer = oldSeriesRenderers[segment._seriesIndex];
      segment._oldPoint =
          (segment._oldSeriesRenderer!._dataPoints.length - 1 >= pointIndex)
              ? segment._oldSeriesRenderer!._dataPoints[pointIndex]
              : null;
      segment._oldSegmentIndex = _getOldSegmentIndex(segment);
      if ((_chartState!._selectedSegments.length - 1 >= pointIndex) &&
          _chartState?._selectedSegments[pointIndex]._oldSegmentIndex == null) {
        final ChartSegment selectedSegment =
            _chartState?._selectedSegments[pointIndex] as ChartSegment;
        selectedSegment._oldSeriesRenderer =
            oldSeriesRenderers[selectedSegment._seriesIndex];
        selectedSegment._seriesRenderer = this;
        selectedSegment._oldSegmentIndex = _getOldSegmentIndex(selectedSegment);
      }
    }
    segment.calculateSegmentPoints();
    customizeSegment(segment);
    segment.strokePaint = segment.getStrokePaint();
    segment.fillPaint = segment.getFillPaint();
    _segments.add(segment);
    return segment;
  }

  /// To draw bubble segments
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
  BubbleSegment createSegment() => BubbleSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final BubbleSegment bubbleSegment = segment as BubbleSegment;
    bubbleSegment._color = bubbleSegment._seriesRenderer._seriesColor;
    bubbleSegment._strokeColor = bubbleSegment._series.borderColor; // ??
    // bubbleSegment._seriesRenderer._seriesColor;
    bubbleSegment._strokeWidth = bubbleSegment._series.borderWidth;
    bubbleSegment.strokePaint = bubbleSegment.getStrokePaint();
    bubbleSegment.fillPaint = bubbleSegment.getFillPaint();
  }

  ///Draws marker with different shape and color of the appropriate data point in the series.
  @override
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY,
      [CartesianSeriesRenderer? seriesRenderer]) {
    if (seriesRenderer != null) {
      canvas.drawPath(seriesRenderer._markerShapes[index]!, fillPaint);
      canvas.drawPath(seriesRenderer._markerShapes[index]!, strokePaint);
    }
  }

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      _drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}
