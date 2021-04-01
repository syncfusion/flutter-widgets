part of charts;

/// Renders the stacked area series.
///
///A stacked area chart is the extension of a basic area chart to display
///the evolution of the value of several groups on the same graphic.
///
/// The values of each group are displayed on top of each other.
///
/// To render a stacked area chart, create an instance of StackedAreaSeries, and add it to the series collection property of [SfCartesianChart].
///
///Provides options to customize the [color], [opacity], [borderWidth], [borderColor] of the stacked area segments.
class StackedAreaSeries<T, D> extends _StackedSeriesBase<T, D> {
  /// Creating an argument constructor of StackedAreaSeries class.
  StackedAreaSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      required List<T> dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic>? sortFieldValueMapper,
      ChartValueMapper<T, Color>? pointColorMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      SortingOrder? sortingOrder,
      String? xAxisName,
      String? yAxisName,
      String? name,
      String? groupName,
      List<Trendline>? trendlines,
      Color? color,
      MarkerSettings? markerSettings,
      EmptyPointSettings? emptyPointSettings,
      DataLabelSettings? dataLabelSettings,
      bool? isVisible,
      bool? enableTooltip,
      List<double>? dashArray,
      double? animationDuration,
      Color? borderColor,
      double? borderWidth,
      LinearGradient? gradient,
      LinearGradient? borderGradient,
      // ignore: deprecated_member_use_from_same_package
      SelectionSettings? selectionSettings,
      SelectionBehavior? selectionBehavior,
      bool? isVisibleInLegend,
      LegendIconType? legendIconType,
      String? legendItemText,
      double? opacity,
      SeriesRendererCreatedCallback? onRendererCreated,
      this.borderDrawMode = BorderDrawMode.top})
      : super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            name: name,
            color: color,
            trendlines: trendlines,
            markerSettings: markerSettings,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            emptyPointSettings: emptyPointSettings,
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
            groupName: groupName,
            onRendererCreated: onRendererCreated,
            opacity: opacity);

  ///Border type of stacked area series.
  ///
  ///Defaults to `BorderDrawMode.top`.
  ///
  ///Also refer [BorderDrawMode]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <AreaSeries<SalesData, num>>[
  ///                AreaSeries<SalesData, num>(
  ///                  borderDrawMode: BorderDrawMode.all,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final BorderDrawMode borderDrawMode;

  /// Create the stacked area series renderer.
  StackedAreaSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    StackedAreaSeriesRenderer stackedAreaSeriesRenderer;
    if (onCreateRenderer != null) {
      stackedAreaSeriesRenderer =
          onCreateRenderer!(series) as StackedAreaSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(stackedAreaSeriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return stackedAreaSeriesRenderer;
    }
    return StackedAreaSeriesRenderer();
  }
}

/// Creates series renderer for Stacked area series
class StackedAreaSeriesRenderer extends _StackedSeriesRenderer {
  /// Calling the default constructor of StackedAreaSeriesRenderer class.
  StackedAreaSeriesRenderer();

  /// Stacked area segment is created here.
  // ignore: unused_element
  ChartSegment _createSegments(
      int seriesIndex, SfCartesianChart chart, double animateFactor,
      [List<Offset>? _points]) {
    final StackedAreaSegment segment = createSegment();
    final List<CartesianSeriesRenderer> _oldSeriesRenderers =
        _chartState!._oldSeriesRenderers;
    _isRectSeries = false;
    // ignore: unnecessary_null_comparison
    if (segment != null) {
      segment._seriesRenderer = this;
      segment._series = _series as XyDataSeries;
      segment._seriesIndex = seriesIndex;
      if (_points != null) segment.points = _points;
      segment.animationFactor = animateFactor;
      if (_chartState!._widgetNeedUpdate &&
          _xAxisRenderer!._zoomFactor == 1 &&
          _yAxisRenderer!._zoomFactor == 1 &&
          // ignore: unnecessary_null_comparison
          _oldSeriesRenderers != null &&
          _oldSeriesRenderers.isNotEmpty &&
          _oldSeriesRenderers.length - 1 >= segment._seriesIndex &&
          _oldSeriesRenderers[segment._seriesIndex]._seriesName ==
              segment._seriesRenderer._seriesName) {
        segment._oldSeriesRenderer = _oldSeriesRenderers[segment._seriesIndex];
        segment._oldSegmentIndex = 0;
      }
      customizeSegment(segment);
      segment._chart = chart;
      segment.strokePaint = segment.getStrokePaint();
      segment.fillPaint = segment.getFillPaint();
      _segments.add(segment);
    }
    return segment;
  }

  /// To render stacked area series segments
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
  StackedAreaSegment createSegment() => StackedAreaSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    segment._color = segment._seriesRenderer._seriesColor;
    segment._strokeColor = segment._series.borderColor;
    segment._strokeWidth = segment._series.borderWidth;
  }

  /// Draws marker with different shape and color of the appropriate data point in the series.
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
