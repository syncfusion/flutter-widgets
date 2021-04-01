part of charts;

/// Renders the range area series.
///
/// To render a range area chart, create an instance of RangeAreaSeries and add to the series collection property of [SfCartesianChart].
/// RangeAreaSeries is similar to Areaseries requires two Y values for a point, data should contain high and low values.
///
/// High and low value specify the maximum and minimum range of the point.
///
/// [highValueMapper] - Field in the data source, which is considered as high value for the data points.
/// [lowValueMapper] - Field in the data source, which is considered as low value for the data points.
class RangeAreaSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of RangeAreaSeries class.
  RangeAreaSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      required List<T> dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      required ChartValueMapper<T, num> highValueMapper,
      required ChartValueMapper<T, num> lowValueMapper,
      ChartValueMapper<T, dynamic>? sortFieldValueMapper,
      ChartValueMapper<T, Color>? pointColorMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      SortingOrder? sortingOrder,
      String? xAxisName,
      List<Trendline>? trendlines,
      String? yAxisName,
      String? name,
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
      this.borderDrawMode = RangeAreaBorderMode.all,
      SeriesRendererCreatedCallback? onRendererCreated})
      : super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            xValueMapper: xValueMapper,
            highValueMapper: highValueMapper,
            lowValueMapper: lowValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            trendlines: trendlines,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            name: name,
            color: color,
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
            onRendererCreated: onRendererCreated,
            opacity: opacity);

  ///Border type of area series.
  ///
  ///Defaults to BorderDrawMode.top
  ///
  ///Also refer [BorderDrawMode]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <RangeAreaSeries<SalesData, num>>[
  ///                RangeAreaSeries<SalesData, num>(
  ///                  borderDrawMode: RangeAreaBorderMode.all,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final RangeAreaBorderMode borderDrawMode;

  /// Create the range area series renderer.
  RangeAreaSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    RangeAreaSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as RangeAreaSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return RangeAreaSeriesRenderer();
  }
}

/// Creates series renderer for Range area series
class RangeAreaSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of RangeAreaSeriesRenderer class.
  RangeAreaSeriesRenderer();

  /// Range Area segment is created here
  ChartSegment _createSegments(
      int seriesIndex, SfCartesianChart chart, double animateFactor,
      [List<Offset>? _points]) {
    final RangeAreaSegment segment = createSegment();
    _isRectSeries = false;
    // ignore: unnecessary_null_comparison
    if (segment != null) {
      segment._seriesIndex = seriesIndex;
      segment.animationFactor = animateFactor;
      segment._seriesRenderer = this;
      segment._series = _series as XyDataSeries;
      if (_points != null) segment.points = _points;
      customizeSegment(segment);
      segment._chart = chart;
      segment.strokePaint = segment.getStrokePaint();
      segment.fillPaint = segment.getFillPaint();
      segment._oldSegmentIndex = 0;
      _segments.add(segment);
    }
    return segment;
  }

  /// To render range area series segments
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
  RangeAreaSegment createSegment() => RangeAreaSegment();

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
    canvas.drawPath(seriesRenderer._markerShapes2[index]!, fillPaint);
    canvas.drawPath(seriesRenderer._markerShapes[index]!, strokePaint);
    canvas.drawPath(seriesRenderer._markerShapes2[index]!, strokePaint);
  }

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      _drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}
