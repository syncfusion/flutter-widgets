part of charts;

/// This class has the properties of the column series.
///
/// To render a column chart, create an instance of [ColumnSeries], and add it to the series collection property of [SfCartesianChart].
/// The column series is a rectangular column with heights or lengths proportional to the values that they represent. It has the spacing
/// property to separate the column.
///
/// Provide the options of color, opacity, border color, and border width to customize the appearance.
///
class ColumnSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of ColumnSeries class.
  ColumnSeries({
    ValueKey<String>? key,
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
    List<Trendline>? trendlines,
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
    double? borderWidth,
    SelectionBehavior? selectionBehavior,
    bool? isVisibleInLegend,
    LegendIconType? legendIconType,
    String? legendItemText,
    double? opacity,
    List<double>? dashArray,
    SeriesRendererCreatedCallback? onRendererCreated,
    List<int>? initialSelectedDataIndexes,
    ChartPointInteractionCallback? onPointTap,
    ChartPointInteractionCallback? onPointDoubleTap,
    ChartPointInteractionCallback? onPointLongPress,
  }) : super(
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
            yAxisName: yAxisName,
            trendlines: trendlines,
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
            initialSelectedDataIndexes: initialSelectedDataIndexes,
            onPointTap: onPointTap,
            onPointDoubleTap: onPointDoubleTap,
            onPointLongPress: onPointLongPress);

  ///Color of the track.
  ///
  ///Defaults to `grey`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <ColumnSeries<SalesData, num>>[
  ///                ColumnSeries<SalesData, num>(
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
  ///            series: <ColumnSeries<SalesData, num>>[
  ///                ColumnSeries<SalesData, num>(
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
  ///            series: <ColumnSeries<SalesData, num>>[
  ///                ColumnSeries<SalesData, num>(
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
  ///Defaults to `0`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <ColumnSeries<SalesData, num>>[
  ///                ColumnSeries<SalesData, num>(
  ///                  isTrackVisible: true,
  ///                  trackPadding: 2
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double trackPadding;

  ///Spacing between the columns. The value ranges from 0 to 1.
  ///1 represents 100% and 0 represents 0% of the available space.
  ///
  ///Spacing also affects the width of the column. For example, setting 20% spacing
  ///and 100% width renders the column with 80% of total width.
  ///
  ///Defaults to `0`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <ColumnSeries<SalesData, num>>[
  ///                ColumnSeries<SalesData, num>(
  ///                  spacing: 0,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double spacing;

  ///Renders column with track.
  ///
  ///Track is a rectangular bar rendered from the start to the end of the axis. Column series will be rendered above the track.
  ///
  ///Defaults to `false`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <ColumnSeries<SalesData, num>>[
  ///                ColumnSeries<SalesData, num>(
  ///                  isTrackVisible: true,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final bool isTrackVisible;

  ///Customizes the corners of the column.
  ///
  /// Each corner can be customized with a desired value or with a single value.
  ///
  ///Defaults to `Radius.zero`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <ColumnSeries<SalesData, num>>[
  ///                ColumnSeries<SalesData, num>(
  ///                  borderRadius: BorderRadius.circular(5),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final BorderRadius borderRadius;

  /// Create the column series renderer.
  ColumnSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    ColumnSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as ColumnSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return ColumnSeriesRenderer();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is ColumnSeries &&
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
        other.initialSelectedDataIndexes == initialSelectedDataIndexes &&
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
      trackColor,
      trackBorderColor,
      trackBorderWidth,
      trackPadding,
      spacing,
      borderRadius,
      isTrackVisible,
      initialSelectedDataIndexes,
      onRendererCreated,
      onPointTap,
      onPointDoubleTap,
      onPointLongPress
    ];
    return hashList(values);
  }
}

/// Creates series renderer for Column series
class ColumnSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of ColumnSeriesRenderer class.
  ColumnSeriesRenderer();

  // Store the rect position //
  late num _rectPosition;

  // Store the rect count //
  late num _rectCount;

  /// To add column segments in segments list
  ChartSegment _createSegments(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, double animateFactor) {
    final ColumnSegment segment = createSegment() as ColumnSegment;
    final List<CartesianSeriesRenderer> oldSeriesRenderers =
        _chartState!._oldSeriesRenderers;
    final ColumnSeries<dynamic, dynamic> _columnSeries =
        _series as ColumnSeries<dynamic, dynamic>;
    segment._seriesRenderer = this;
    segment._series = _columnSeries;
    segment._chart = _chart;
    segment._chartState = _chartState!;
    segment._seriesIndex = seriesIndex;
    segment.currentSegmentIndex = pointIndex;
    segment.points
        .add(Offset(currentPoint.markerPoint!.x, currentPoint.markerPoint!.y));
    segment.animationFactor = animateFactor;
    segment._currentPoint = currentPoint;
    if (_renderingDetails!.widgetNeedUpdate &&
        _chartState!._zoomPanBehaviorRenderer._isPinching != true &&
        !_renderingDetails!.isLegendToggled &&
        // ignore: unnecessary_null_comparison
        oldSeriesRenderers != null &&
        oldSeriesRenderers.isNotEmpty &&
        oldSeriesRenderers.length - 1 >= segment._seriesIndex &&
        oldSeriesRenderers[segment._seriesIndex]._seriesName ==
            segment._seriesRenderer._seriesName) {
      segment._oldSeriesRenderer = oldSeriesRenderers[segment._seriesIndex];
      segment._oldPoint = (segment._oldSeriesRenderer!._segments.isNotEmpty &&
              segment._oldSeriesRenderer!._segments[0] is ColumnSegment &&
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
      ColumnSegment oldSegment;
      for (int i = 0; i < _chartState!._segments.length; i++) {
        oldSegment = _chartState!._segments[i] as ColumnSegment;
        if (oldSegment.currentSegmentIndex == segment.currentSegmentIndex &&
            oldSegment._seriesIndex == segment._seriesIndex) {
          segment._oldRegion = oldSegment.segmentRect.outerRect;
        }
      }
    }
    segment._path =
        _findingRectSeriesDashedBorder(currentPoint, _columnSeries.borderWidth);
    // ignore: unnecessary_null_comparison
    if (_columnSeries.borderRadius != null) {
      segment.segmentRect =
          _getRRectFromRect(currentPoint.region!, _columnSeries.borderRadius);

      //Tracker rect
      if (_columnSeries.isTrackVisible) {
        segment._trackRect = _getRRectFromRect(
            currentPoint.trackerRectRegion!, _columnSeries.borderRadius);
      }
    }
    segment._segmentRect = segment.segmentRect;
    customizeSegment(segment);
    _segments.add(segment);
    return segment;
  }

  /// To draw column series segments
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
  ChartSegment createSegment() => ColumnSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final ColumnSegment columnSegment = segment as ColumnSegment;
    columnSegment._color = columnSegment._currentPoint!.pointColorMapper ??
        segment._seriesRenderer._seriesColor;
    columnSegment._strokeColor = segment._series.borderColor;
    columnSegment._strokeWidth = segment._series.borderWidth;
    columnSegment.strokePaint = columnSegment.getStrokePaint();
    columnSegment.fillPaint = columnSegment.getFillPaint();
    columnSegment._trackerFillPaint = columnSegment._getTrackerFillPaint();
    columnSegment._trackerStrokePaint = columnSegment._getTrackerStrokePaint();
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
