part of charts;

/// Renders the waterfall series.
///
/// To render a waterfall chart, create an instance of WaterfallSeries and add to the series collection property of [SfCartesianChart].
///
/// WaterfallSeries is similar to range column series,
/// in range column high and low value should be there, but in waterfall
/// we have find the endValue and originValue of each data point.
class WaterfallSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of WaterfallSeries class.
  WaterfallSeries(
      {ValueKey<String> key,
      ChartSeriesRendererFactory<T, D> onCreateRenderer,
      @required List<T> dataSource,
      @required ChartValueMapper<T, D> xValueMapper,
      @required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, bool> intermediateSumPredicate,
      ChartValueMapper<T, bool> totalSumPredicate,
      Color negativePointsColor,
      Color intermediateSumColor,
      Color totalSumColor,
      ChartValueMapper<T, dynamic> sortFieldValueMapper,
      ChartValueMapper<T, Color> pointColorMapper,
      ChartValueMapper<T, String> dataLabelMapper,
      SortingOrder sortingOrder,
      WaterfallConnectorLineSettings connectorLineSettings,
      String xAxisName,
      String yAxisName,
      String name,
      Color color,
      double width,
      double spacing,
      MarkerSettings markerSettings,
      DataLabelSettings dataLabelSettings,
      bool isVisible,
      LinearGradient gradient,
      LinearGradient borderGradient,
      BorderRadius borderRadius,
      bool enableTooltip,
      double animationDuration,
      Color borderColor,
      List<Trendline> trendlines,
      double borderWidth,
      // ignore: deprecated_member_use_from_same_package
      SelectionSettings selectionSettings,
      SelectionBehavior selectionBehavior,
      bool isVisibleInLegend,
      LegendIconType legendIconType,
      String legendItemText,
      double opacity,
      List<double> dashArray,
      SeriesRendererCreatedCallback onRendererCreated,
      List<int> initialSelectedDataIndexes})
      : spacing = spacing ?? 0,
        negativePointsColor = negativePointsColor,
        intermediateSumColor = intermediateSumColor,
        totalSumColor = totalSumColor,
        connectorLineSettings =
            connectorLineSettings ?? WaterfallConnectorLineSettings(),
        borderRadius = borderRadius ?? const BorderRadius.all(Radius.zero),
        super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            name: name,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            intermediateSumPredicate: intermediateSumPredicate,
            totalSumPredicate: totalSumPredicate,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            trendlines: trendlines,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            color: color,
            width: width ?? 0.7,
            markerSettings: markerSettings,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            gradient: gradient,
            borderGradient: borderGradient,
            enableTooltip: enableTooltip,
            animationDuration: animationDuration,
            borderColor: borderColor,
            borderWidth: borderWidth,
            selectionSettings: selectionSettings,
            selectionBehavior: selectionBehavior,
            legendItemText: legendItemText,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            opacity: opacity,
            dashArray: dashArray,
            onRendererCreated: onRendererCreated,
            initialSelectedDataIndexes: initialSelectedDataIndexes);

  ///Color of the negative data points in the series.
  ///
  ///If no color is specified, then the negative data points will be rendered with the
  /// series default color.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <WaterfallSeries<SalesData, num>>[
  ///                WaterfallSeries<SalesData, num>(
  ///                  negativePointsColor: Colors.red,
  ///                ),
  ///              ],
  ///        )
  ///     );
  ///}
  ///```
  final Color negativePointsColor;

  ///Color of the intermediate sum points in the series.
  ///
  ///If no color is specified, then the intermediate sum points will be rendered with the
  /// series default color.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <WaterfallSeries<SalesData, num>>[
  ///                WaterfallSeries<SalesData, num>(
  ///                  intermediateSumColor: Colors.red,
  ///                ),
  ///              ],
  ///        )
  ///     );
  ///}
  ///```
  final Color intermediateSumColor;

  ///Color of the total sum points in the series.
  ///
  ///If no color is specified, then the total sum points will be rendered with the
  /// series default color.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <WaterfallSeries<SalesData, num>>[
  ///                WaterfallSeries<SalesData, num>(
  ///                  totalSumColor: Colors.red,
  ///                ),
  ///              ],
  ///        )
  ///     );
  ///}
  ///```
  final Color totalSumColor;

  ///Options to customize the waterfall chart connector line.
  ///
  ///Data points in waterfall chart are connected using the connector line. Provides the options to
  /// change the width, color and dash array of the connector line to customize the appearance.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <WaterfallSeries<SalesData, num>>[
  ///                WaterfallSeries<SalesData, num>(
  ///                  connectorLineSettings: WaterfallConnectorLineSettings(
  ///                    width: 2,
  ///                    color: Colors.black,
  ///                    dashArray: [2,3]
  ///                  ),
  ///                ),
  ///              ],
  ///        )
  ///     );
  ///}
  ///```
  final WaterfallConnectorLineSettings connectorLineSettings;

  ///Spacing between the data points in waterfall chart.
  ///
  ///The value ranges from 0 to 1, where 1 represents 100% and 0 represents 0% of the available space.
  ///
  ///Spacing affects the width of the bars in waterfall. For example, setting 20% spacing and 100% width
  /// renders the bars with 80% of total width.
  ///
  ///Also refer [CartesianSeries.width].
  ///
  ///Defaults to `0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <WaterfallSeries<SalesData, num>>[
  ///                WaterfallSeries<SalesData, num>(
  ///                  spacing: 0,
  ///                ),
  ///              ],
  ///        )
  ///    );
  ///}
  ///```
  final double spacing;

  ///Customizes the corners of the waterfall.
  ///
  ///Each corner can be customized with a desired value or with a single value.
  ///
  ///Defaults to `zero`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <WaterfallSeries<SalesData, num>>[
  ///                WaterfallSeries<SalesData, num>(
  ///                  borderRadius: BorderRadius.circular(5),
  ///                ),
  ///              ],
  ///        )
  ///     );
  ///}
  ///```
  final BorderRadius borderRadius;

  /// Create the waterfall series renderer.
  WaterfallSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    WaterfallSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer(series);
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return WaterfallSeriesRenderer();
  }
}

/// Creates series renderer for waterfall series
class WaterfallSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of WaterfallSeriesRenderer class.
  WaterfallSeriesRenderer();
  num _rectPosition;
  num _rectCount;

  WaterfallSeries<dynamic, dynamic> _waterfallSeries;

  /// To add waterfall segments in segments list
  ChartSegment _createSegments(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, num animateFactor) {
    final WaterfallSegment segment = createSegment();
    final List<CartesianSeriesRenderer> oldSeriesRenderers =
        _chartState._oldSeriesRenderers;
    _waterfallSeries = _series;
    final BorderRadius borderRadius = _waterfallSeries.borderRadius;
    segment._seriesIndex = seriesIndex;
    segment.currentSegmentIndex = pointIndex;
    segment.points
        .add(Offset(currentPoint.markerPoint.x, currentPoint.markerPoint.y));
    segment._seriesRenderer = this;
    segment._series = _waterfallSeries;
    segment._chart = _chart;
    segment._chartState = _chartState;
    segment.animationFactor = animateFactor;
    segment._currentPoint = currentPoint;
    if (_chartState._widgetNeedUpdate &&
        _chartState._zoomPanBehaviorRenderer._isPinching != true &&
        !_chartState._isLegendToggled &&
        oldSeriesRenderers != null &&
        oldSeriesRenderers.isNotEmpty &&
        oldSeriesRenderers.length - 1 >= segment._seriesIndex &&
        oldSeriesRenderers[segment._seriesIndex]._seriesName ==
            segment._seriesRenderer._seriesName) {
      segment._oldSeriesRenderer = oldSeriesRenderers[segment._seriesIndex];
      segment._oldPoint = (segment._oldSeriesRenderer._segments.isNotEmpty &&
              segment._oldSeriesRenderer._segments[0] is WaterfallSegment &&
              segment._oldSeriesRenderer._dataPoints.length - 1 >= pointIndex)
          ? segment._oldSeriesRenderer._dataPoints[pointIndex]
          : null;
    } else if (_chartState._isLegendToggled &&
        _chartState._segments != null &&
        _chartState._segments.isNotEmpty) {
      segment._oldSeriesVisible =
          _chartState._oldSeriesVisible[segment._seriesIndex];
      WaterfallSegment oldSegment;
      for (int i = 0; i < _chartState._segments.length; i++) {
        oldSegment = _chartState._segments[i];
        if (oldSegment.currentSegmentIndex == segment.currentSegmentIndex &&
            oldSegment._seriesIndex == segment._seriesIndex) {
          segment._oldRegion = oldSegment.segmentRect.outerRect;
        }
      }
    }
    segment._path = _findingRectSeriesDashedBorder(
        currentPoint, _waterfallSeries.borderWidth);
    if (borderRadius != null) {
      segment.segmentRect =
          _getRRectFromRect(currentPoint.region, borderRadius);
    }
    segment._segmentRect = segment.segmentRect;
    customizeSegment(segment);
    _segments.add(segment);
    return segment;
  }

  /// To render waterfall series segments
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
  ChartSegment createSegment() => WaterfallSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final WaterfallSegment waterfallSegment = segment;
    waterfallSegment._color = segment._seriesRenderer._seriesColor;
    waterfallSegment._negativePointsColor =
        _waterfallSeries.negativePointsColor;
    waterfallSegment._intermediateSumColor =
        _waterfallSeries.intermediateSumColor;
    waterfallSegment._totalSumColor = _waterfallSeries.totalSumColor;
    waterfallSegment._strokeColor = segment._series.borderColor;
    waterfallSegment._strokeWidth = segment._series.borderWidth;
    waterfallSegment.strokePaint = waterfallSegment.getStrokePaint();
    waterfallSegment.fillPaint = waterfallSegment.getFillPaint();
    waterfallSegment.connectorLineStrokePaint =
        waterfallSegment._getConnectorLineStrokePaint();
  }

  ///Draws the marker with different shapes and color of the appropriate data point in the series.
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

///Options to customize the waterfall chart connector line.
///
///Data points in waterfall chart are connected using the connector line and this class hold the
/// properties to customize it.
///
///It provides the options to change the width, color and dash array of the connector line to
/// customize the appearance.
///
class WaterfallConnectorLineSettings extends ConnectorLineSettings {
  /// Creating an argument constructor of WaterfallConnectorLineSettings class.
  WaterfallConnectorLineSettings(
      {double width, Color color, List<double> dashArray})
      : dashArray = dashArray ?? <double>[0, 0],
        super(color: color, width: width ?? 1);

  ///Dashes of the waterfall chart connector line.
  ///
  ///Any number of values can be provided in the list. Odd values are considered as rendering
  /// size and even values are considered as gap.
  ///
  ///Defaults to `null.`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           dataLabelSettings: DataLabelSettings(
  ///            connectorLineSettings: ConnectorLineSettings(
  ///             dashArray: [1, 2],
  ///           )
  ///          )
  ///        ));
  ///}
  ///```
  final List<double> dashArray;
}
