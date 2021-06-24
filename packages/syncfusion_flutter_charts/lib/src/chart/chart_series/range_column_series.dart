part of charts;

/// Renders the range column series.
///
/// To render a range column chart, create an instance of RangeColumnSeries and add to the series collection property of [SfCartesianChart].
///
/// RangeColumnSeries is similar to column series but requires two Y values for a point,
/// your data should contain high and low values.
/// High and low value specify the maximum and minimum range of the point.
///
/// * [highValueMapper] - Field in the data source, which is considered as high value for the data points.
/// * [lowValueMapper] - Field in the data source, which is considered as low value for the data points.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=uSsKhlRzC2Q}
@immutable
class RangeColumnSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of RangeColumnSeries class.
  RangeColumnSeries(
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
      this.isTrackVisible = false,
      String? xAxisName,
      String? yAxisName,
      String? name,
      Color? color,
      double? width,
      this.spacing = 0,
      MarkerSettings? markerSettings,
      EmptyPointSettings? emptyPointSettings,
      DataLabelSettings? dataLabelSettings,
      bool? isVisible,
      LinearGradient? gradient,
      LinearGradient? borderGradient,
      this.borderRadius = const BorderRadius.all(Radius.zero),
      bool? enableTooltip,
      double? animationDuration,
      this.trackColor = Colors.grey,
      this.trackBorderColor = Colors.transparent,
      this.trackBorderWidth = 1,
      this.trackPadding = 0,
      Color? borderColor,
      List<Trendline>? trendlines,
      double? borderWidth,
      SelectionBehavior? selectionBehavior,
      bool? isVisibleInLegend,
      LegendIconType? legendIconType,
      String? legendItemText,
      double? opacity,
      List<double>? dashArray,
      SeriesRendererCreatedCallback? onRendererCreated,
      ChartPointInteractionCallback? onPointTap,
      ChartPointInteractionCallback? onPointDoubleTap,
      ChartPointInteractionCallback? onPointLongPress,
      List<int>? initialSelectedDataIndexes})
      : super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            name: name,
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
            color: color,
            width: width ?? 0.7,
            markerSettings: markerSettings,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            gradient: gradient,
            borderGradient: borderGradient,
            emptyPointSettings: emptyPointSettings,
            enableTooltip: enableTooltip,
            animationDuration: animationDuration,
            borderColor: borderColor,
            borderWidth: borderWidth,
            selectionBehavior: selectionBehavior,
            legendItemText: legendItemText,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            opacity: opacity,
            dashArray: dashArray,
            onRendererCreated: onRendererCreated,
            onPointTap: onPointTap,
            onPointDoubleTap: onPointDoubleTap,
            onPointLongPress: onPointLongPress,
            initialSelectedDataIndexes: initialSelectedDataIndexes);

  ///Color of the track.
  ///
  ///Defaults to `grey`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <RangeColumnSeries<SalesData, num>>[
  ///                RangeColumnSeries<SalesData, num>(
  ///                  isTrackVisible: true,
  ///                  trackColor: Colors.red
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color trackColor;

  ///Color of the track border.
  ///
  ///Defaults to `transparent`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <RangeColumnSeries<SalesData, num>>[
  ///                RangeColumnSeries<SalesData, num>(
  ///                  isTrackVisible: true,
  ///                  trackBorderColor: Colors.red
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color trackBorderColor;

  ///Width of the track border.
  ///
  ///Defaults to `1`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <RangeColumnSeries<SalesData, num>>[
  ///                RangeColumnSeries<SalesData, num>(
  ///                  isTrackVisible: true,
  ///                  trackBorderColor: Colors.red ,
  ///                  trackBorderWidth: 2
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double trackBorderWidth;

  ///Padding of the track.
  ///
  ///Defaults to `0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <RangeColumnSeries<SalesData, num>>[
  ///                RangeColumnSeries<SalesData, num>(
  ///                  isTrackVisible: true,
  ///                  trackPadding: 2
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double trackPadding;

  ///Spacing between the columns.
  ///
  ///The value ranges from 0 to 1. 1 represents 100% and 0 represents 0% of the available space.
  ///
  ///Spacing also affects the width of the range column. For example, setting 20% spacing
  ///and 100% width renders the column with 80% of total width.
  ///
  ///Defaults to `0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <RangeColumnSeries<SalesData, num>>[
  ///                RangeColumnSeries<SalesData, num>(
  ///                  spacing: 0,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double spacing;

  ///Renders range column with track.
  ///
  /// Track is a rectangular bar rendered from the start to the end of the axis. Range Column Series will be rendered
  /// above the track.
  ///
  ///Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <RangeColumnSeries<SalesData, num>>[
  ///                RangeColumnSeries<SalesData, num>(
  ///                  isTrackVisible: true,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final bool isTrackVisible;

  ///Customizes the corners of the range column.
  ///
  /// Each corner can be customized with a desired value or with a single value.
  ///
  ///Defaults to `zero`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <RangeColumnSeries<SalesData, num>>[
  ///                RangeColumnSeries<SalesData, num>(
  ///                  borderRadius: BorderRadius.circular(5),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final BorderRadius borderRadius;

  /// Create the range column series renderer.
  RangeColumnSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    RangeColumnSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as RangeColumnSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return RangeColumnSeriesRenderer();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is RangeColumnSeries &&
        other.key == key &&
        other.onCreateRenderer == onCreateRenderer &&
        other.dataSource == dataSource &&
        other.xValueMapper == xValueMapper &&
        other.highValueMapper == highValueMapper &&
        other.lowValueMapper == lowValueMapper &&
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
        other.trackColor == trackColor &&
        other.trackBorderColor == trackBorderColor &&
        other.trackBorderWidth == trackBorderWidth &&
        other.trackPadding == trackPadding &&
        other.spacing == spacing &&
        other.borderRadius == borderRadius &&
        other.isTrackVisible == isTrackVisible &&
        other.onRendererCreated == onRendererCreated &&
        other.onPointTap == onPointTap &&
        other.onPointDoubleTap == onPointDoubleTap &&
        other.onPointLongPress == onPointLongPress &&
        other.initialSelectedDataIndexes == initialSelectedDataIndexes;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      key,
      onCreateRenderer,
      dataSource,
      xValueMapper,
      highValueMapper,
      lowValueMapper,
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
      trackColor,
      trackBorderColor,
      trackBorderWidth,
      trackPadding,
      spacing,
      borderRadius,
      isTrackVisible,
      onRendererCreated,
      initialSelectedDataIndexes,
      onPointTap,
      onPointDoubleTap,
      onPointLongPress
    ];
    return hashList(values);
  }
}

/// Creates series renderer for Range column series
class RangeColumnSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of RangeColumnSeriesRenderer class.
  RangeColumnSeriesRenderer();

  // Store the rect position //
  late num _rectPosition;

  // Store the rect count //
  late num _rectCount;

  /// To add range column segments in segments list
  ChartSegment _createSegments(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, double animateFactor) {
    _isRectSeries = true;
    final RangeColumnSegment segment = createSegment();
    final List<CartesianSeriesRenderer>? oldSeriesRenderers =
        _chartState!._oldSeriesRenderers;
    final RangeColumnSeries<dynamic, dynamic> _rangeColumnSeries =
        _series as RangeColumnSeries<dynamic, dynamic>;
    final BorderRadius borderRadius = _rangeColumnSeries.borderRadius;
    segment._seriesIndex = seriesIndex;
    segment.currentSegmentIndex = pointIndex;
    segment.points
        .add(Offset(currentPoint.markerPoint!.x, currentPoint.markerPoint!.y));
    segment.points.add(
        Offset(currentPoint.markerPoint2!.x, currentPoint.markerPoint2!.y));
    segment._seriesRenderer = this;
    segment._series = _rangeColumnSeries;
    segment._chart = _chart;
    segment._chartState = _chartState!;
    segment.animationFactor = animateFactor;
    segment._currentPoint = currentPoint;
    if (_renderingDetails!.widgetNeedUpdate &&
        _chartState!._zoomPanBehaviorRenderer._isPinching != true &&
        !_renderingDetails!.isLegendToggled &&
        oldSeriesRenderers != null &&
        oldSeriesRenderers.isNotEmpty &&
        oldSeriesRenderers.length - 1 >= segment._seriesIndex &&
        oldSeriesRenderers[segment._seriesIndex]._seriesName ==
            segment._seriesRenderer._seriesName) {
      segment._oldSeriesRenderer = oldSeriesRenderers[segment._seriesIndex];
      segment._oldPoint = (segment._oldSeriesRenderer!._segments.isNotEmpty &&
              segment._oldSeriesRenderer!._segments[0] is RangeColumnSegment &&
              segment._oldSeriesRenderer!._dataPoints.length - 1 >= pointIndex)
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
    } else if (_renderingDetails!.isLegendToggled &&
        // ignore: unnecessary_null_comparison
        _chartState!._segments != null &&
        _chartState!._segments.isNotEmpty) {
      segment._oldSeriesVisible =
          _chartState!._oldSeriesVisible[segment._seriesIndex];
      RangeColumnSegment oldSegment;
      for (int i = 0; i < _chartState!._segments.length; i++) {
        oldSegment = _chartState!._segments[i] as RangeColumnSegment;
        if (oldSegment.currentSegmentIndex == segment.currentSegmentIndex &&
            oldSegment._seriesIndex == segment._seriesIndex) {
          segment._oldRegion = oldSegment.segmentRect.outerRect;
        }
      }
    }
    segment._path = _findingRectSeriesDashedBorder(
        currentPoint, _rangeColumnSeries.borderWidth);
    // ignore: unnecessary_null_comparison
    if (borderRadius != null) {
      segment.segmentRect =
          _getRRectFromRect(currentPoint.region!, borderRadius);

      //Tracker rect
      if (_rangeColumnSeries.isTrackVisible) {
        segment._trackRect =
            _getRRectFromRect(currentPoint.trackerRectRegion!, borderRadius);
      }
    }
    segment._segmentRect = segment.segmentRect;
    customizeSegment(segment);
    _segments.add(segment);
    return segment;
  }

  /// To render range column series segments
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
  RangeColumnSegment createSegment() => RangeColumnSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final RangeColumnSegment rangeColumnSegment = segment as RangeColumnSegment;
    rangeColumnSegment._color = segment._seriesRenderer._seriesColor;
    rangeColumnSegment._strokeColor = segment._series.borderColor;
    rangeColumnSegment._strokeWidth = segment._series.borderWidth;
    rangeColumnSegment.strokePaint = rangeColumnSegment.getStrokePaint();
    rangeColumnSegment.fillPaint = rangeColumnSegment.getFillPaint();
    rangeColumnSegment._trackerFillPaint =
        rangeColumnSegment._getTrackerFillPaint();
    rangeColumnSegment._trackerStrokePaint =
        rangeColumnSegment._getTrackerStrokePaint();
  }

  ///Draws marker with different shape and color of the appropriate data point in the series.
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
