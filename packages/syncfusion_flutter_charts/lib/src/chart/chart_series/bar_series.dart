part of charts;

/// This class has the properties of the bar series.
///
/// To render a bar chart, create an instance of [BarSeries], and add it to the series collection property of [SfCartesianChart].
/// The bar series are rectangular bars with heights or lengths proportional to their represented values.It has the property of spacing to provide
/// spacing between bars.
///
/// Provides options for color, opacity, border color and border width to customize the appearance.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=MHQzCN_jD1Q}
@immutable
class BarSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of BarSeries class.
  BarSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      required List<T> dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      required ChartValueMapper<T, num> yValueMapper,
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
      List<Trendline>? trendlines,
      Color? borderColor,
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
            onRendererCreated: onRendererCreated,
            onPointTap: onPointTap,
            onPointDoubleTap: onPointDoubleTap,
            onPointLongPress: onPointLongPress,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            color: color,
            trendlines: trendlines,
            width: width ?? 0.7,
            markerSettings: markerSettings,
            dataLabelSettings: dataLabelSettings,
            emptyPointSettings: emptyPointSettings,
            isVisible: isVisible,
            gradient: gradient,
            borderGradient: borderGradient,
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
            initialSelectedDataIndexes: initialSelectedDataIndexes,
            dashArray: dashArray);

  ///Color of the track.
  ///
  ///Defaults to `grey`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
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
  ///Defaults to `transparent`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
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
  ///Defaults to `1`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  isTrackVisible: true,
  ///                  trackBorderColor: Colors.red,
  ///                  trackBorderWidth: 2
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double trackBorderWidth;

  ///Padding of the track.
  ///
  ///Defaults to `0`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  isTrackVisible: true,
  ///                  trackPadding: 2
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double trackPadding;

  ///Spacing between the bars. The value ranges from 0 to 1.
  ///
  ///1 represents 100% and
  ///0 represents 0% of the available space.
  ///
  ///Spacing also affects the height of the bar. For example, setting 20% spacing
  ///and 100% height renders the bar with 80% of total height.
  ///
  ///Defaults to `0`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  spacing: 0,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double spacing;

  ///Customizes the corners of the bar.
  ///
  /// Each corner can be customized with desired
  ///value or with a single value.
  ///
  ///Defaults to `Radius.zero`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  borderRadius: BorderRadius.all(Radius.circular(5)),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final BorderRadius borderRadius;

  ///Renders bars with track.
  ///
  /// Track is a rectangular bar rendered from the start to the
  ///end of the axis.
  ///
  ///Bar series will be rendered above the track.
  ///
  ///Defaults to `false`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  isTrackVisible: true
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final bool isTrackVisible;

  /// Create the bar series renderer.
  BarSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    BarSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as BarSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return BarSeriesRenderer();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is BarSeries &&
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

/// Creates series renderer for Bar series
class BarSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of BarSeriesRenderer class.
  BarSeriesRenderer();

  // Store the rect position //
  late num _rectPosition;

  // Store the rect count //
  late num _rectCount;

  /// To add bar segments to chart segments
  ChartSegment _createSegments(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, double animateFactor) {
    final BarSeries<dynamic, dynamic> _barSeries =
        _series as BarSeries<dynamic, dynamic>;
    final BarSegment segment = createSegment();
    final List<CartesianSeriesRenderer> oldSeriesRenderers =
        _chartState!._oldSeriesRenderers;
    segment._series = _barSeries;
    segment._chart = _chart;
    segment._chartState = _chartState!;
    segment._seriesRenderer = this;
    segment._seriesIndex = seriesIndex;
    segment.currentSegmentIndex = pointIndex;
    segment.points
        .add(Offset(currentPoint.markerPoint!.x, currentPoint.markerPoint!.y));
    segment.animationFactor = animateFactor;
    segment._currentPoint = currentPoint;
    if (_renderingDetails!.widgetNeedUpdate &&
        !_renderingDetails!.isLegendToggled &&
        // ignore: unnecessary_null_comparison
        oldSeriesRenderers != null &&
        oldSeriesRenderers.isNotEmpty &&
        oldSeriesRenderers.length - 1 >= segment._seriesIndex &&
        oldSeriesRenderers[segment._seriesIndex]._seriesName ==
            segment._seriesRenderer._seriesName) {
      segment._oldSeriesRenderer = oldSeriesRenderers[segment._seriesIndex];
      segment._oldPoint = (segment._oldSeriesRenderer!._segments.isNotEmpty &&
              segment._oldSeriesRenderer!._segments[0] is BarSegment &&
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
      for (int i = 0; i < _chartState!._segments.length; i++) {
        final BarSegment oldSegment = _chartState!._segments[i] as BarSegment;
        if (oldSegment.currentSegmentIndex == segment.currentSegmentIndex &&
            oldSegment._seriesIndex == segment._seriesIndex) {
          segment._oldRegion = oldSegment.segmentRect.outerRect;
        }
      }
    }
    segment._path =
        _findingRectSeriesDashedBorder(currentPoint, _barSeries.borderWidth);
    segment.segmentRect =
        _getRRectFromRect(currentPoint.region!, _barSeries.borderRadius);
    //Tracker rect
    if (_barSeries.isTrackVisible) {
      segment._trackBarRect = _getRRectFromRect(
          currentPoint.trackerRectRegion!, _barSeries.borderRadius);
    }
    segment._segmentRect = segment.segmentRect;
    customizeSegment(segment);
    _segments.add(segment);
    return segment;
  }

  /// To draw bar segement
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
  BarSegment createSegment() => BarSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final BarSegment barSegment = segment as BarSegment;
    barSegment._color = segment._seriesRenderer._seriesColor;
    barSegment._strokeColor = segment._series.borderColor;
    barSegment._strokeWidth = segment._series.borderWidth;
    barSegment.strokePaint = barSegment.getStrokePaint();
    barSegment.fillPaint = barSegment.getFillPaint();
    barSegment._trackerFillPaint = barSegment._getTrackerFillPaint();
    barSegment._trackerStrokePaint = barSegment._getTrackerStrokePaint();
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
