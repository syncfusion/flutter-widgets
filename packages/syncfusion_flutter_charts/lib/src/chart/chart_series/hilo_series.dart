part of charts;

/// Renders the Hilo series.
///
///HiLo series illustrates the price movements in stock using the high and low values.
///
///To render a HiLo chart, create an instance of HiloSeries, and add it to the series collection property of [SfCartesianChart].
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=uSsKhlRzC2Q}
class HiloSeries<T, D> extends _FinancialSeriesBase<T, D> {
  /// Creating an argument constructor of HiloSeries class.
  HiloSeries({
    ValueKey<String>? key,
    ChartSeriesRendererFactory<T, D>? onCreateRenderer,
    required List<T> dataSource,
    required ChartValueMapper<T, D> xValueMapper,
    required ChartValueMapper<T, num> lowValueMapper,
    required ChartValueMapper<T, num> highValueMapper,
    ChartValueMapper<T, dynamic>? sortFieldValueMapper,
    ChartValueMapper<T, Color>? pointColorMapper,
    ChartValueMapper<T, String>? dataLabelMapper,
    SortingOrder? sortingOrder,
    String? xAxisName,
    String? yAxisName,
    String? name,
    Color? color,
    MarkerSettings? markerSettings,
    EmptyPointSettings? emptyPointSettings,
    DataLabelSettings? dataLabelSettings,
    bool? isVisible,
    bool? enableTooltip,
    double? animationDuration,
    double? borderWidth,
    SelectionBehavior? selectionBehavior,
    bool? isVisibleInLegend,
    LegendIconType? legendIconType,
    String? legendItemText,
    List<double>? dashArray,
    double? opacity,
    double? spacing,
    List<int>? initialSelectedDataIndexes,
    bool? showIndicationForSameValues,
    List<Trendline>? trendlines,
    SeriesRendererCreatedCallback? onRendererCreated,
    ChartPointInteractionCallback? onPointTap,
    ChartPointInteractionCallback? onPointDoubleTap,
    ChartPointInteractionCallback? onPointLongPress,
  }) : super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            name: name,
            dashArray: dashArray,
            spacing: spacing,
            xValueMapper: xValueMapper,
            lowValueMapper: lowValueMapper,
            highValueMapper: highValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            color: color,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            markerSettings: markerSettings,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            emptyPointSettings: emptyPointSettings,
            enableTooltip: enableTooltip,
            animationDuration: animationDuration,
            borderWidth: borderWidth ?? 2,
            selectionBehavior: selectionBehavior,
            legendItemText: legendItemText,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            opacity: opacity,
            onRendererCreated: onRendererCreated,
            onPointTap: onPointTap,
            onPointDoubleTap: onPointDoubleTap,
            onPointLongPress: onPointLongPress,
            showIndicationForSameValues: showIndicationForSameValues ?? false,
            initialSelectedDataIndexes: initialSelectedDataIndexes,
            trendlines: trendlines);

  /// Create the hilo series renderer.
  HiloSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    HiloSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as HiloSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return HiloSeriesRenderer();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is HiloSeries &&
        other.key == key &&
        other.onCreateRenderer == onCreateRenderer &&
        other.dataSource == dataSource &&
        other.xValueMapper == xValueMapper &&
        other.lowValueMapper == lowValueMapper &&
        other.highValueMapper == highValueMapper &&
        other.sortFieldValueMapper == sortFieldValueMapper &&
        other.pointColorMapper == pointColorMapper &&
        other.dataLabelMapper == dataLabelMapper &&
        other.sortingOrder == sortingOrder &&
        other.xAxisName == xAxisName &&
        other.yAxisName == yAxisName &&
        other.name == name &&
        other.bearColor == bearColor &&
        other.bullColor == bullColor &&
        other.emptyPointSettings == emptyPointSettings &&
        other.dataLabelSettings == dataLabelSettings &&
        other.trendlines == trendlines &&
        other.isVisible == isVisible &&
        other.enableTooltip == enableTooltip &&
        other.dashArray == dashArray &&
        other.animationDuration == animationDuration &&
        other.borderWidth == borderWidth &&
        other.selectionBehavior == selectionBehavior &&
        other.isVisibleInLegend == isVisibleInLegend &&
        other.legendIconType == legendIconType &&
        other.legendItemText == legendItemText &&
        other.opacity == opacity &&
        other.spacing == spacing &&
        other.showIndicationForSameValues == showIndicationForSameValues &&
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
      lowValueMapper,
      highValueMapper,
      sortFieldValueMapper,
      pointColorMapper,
      dataLabelMapper,
      sortingOrder,
      xAxisName,
      yAxisName,
      name,
      bearColor,
      bullColor,
      emptyPointSettings,
      dataLabelSettings,
      isVisible,
      enableTooltip,
      animationDuration,
      borderWidth,
      selectionBehavior,
      isVisibleInLegend,
      legendIconType,
      legendItemText,
      dashArray,
      opacity,
      spacing,
      onRendererCreated,
      initialSelectedDataIndexes,
      showIndicationForSameValues,
      trendlines,
      onPointTap,
      onPointDoubleTap,
      onPointLongPress
    ];
    return hashList(values);
  }
}

/// Creates series renderer for Hilo series
class HiloSeriesRenderer extends _FinancialSerieBaseRenderer {
  /// Calling the default constructor of HiloSeriesRenderer class.
  HiloSeriesRenderer();

  // Store the rect position //
  @override
  late num _rectPosition;

  // Store the rect count //
  @override
  late num _rectCount;

  /// Hilo segment is created here
  ChartSegment _createSegments(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, double animateFactor) {
    _isRectSeries = false;
    final HiloSegment segment = createSegment();
    final List<CartesianSeriesRenderer> oldSeriesRenderers =
        _chartState!._oldSeriesRenderers;
    // ignore: unnecessary_null_comparison
    if (segment != null) {
      segment._seriesIndex = seriesIndex;
      segment.currentSegmentIndex = pointIndex;
      segment.points.add(
          Offset(currentPoint.markerPoint!.x, currentPoint.markerPoint!.y));
      segment.points.add(
          Offset(currentPoint.markerPoint2!.x, currentPoint.markerPoint2!.y));
      segment._series = _series as XyDataSeries<dynamic, dynamic>;
      segment._seriesRenderer = this;
      segment.animationFactor = animateFactor;
      segment._pointColorMapper = currentPoint.pointColorMapper;
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
        segment._oldSegmentIndex = _getOldSegmentIndex(segment);
      }
      segment.calculateSegmentPoints();
      customizeSegment(segment);
      segment.strokePaint = segment.getStrokePaint();
      segment.fillPaint = segment.getFillPaint();
      _segments.add(segment);
    }
    return segment;
  }

  /// To render hilo series segments.
  //ignore: unused_element
  void _drawSegment(Canvas canvas, ChartSegment segment) {
    if (segment._seriesRenderer._isSelectionEnable) {
      final SelectionBehaviorRenderer? selectionBehaviorRenderer =
          segment._seriesRenderer._selectionBehaviorRenderer;
      selectionBehaviorRenderer?._selectionRenderer?._checkWithSelectionState(
          _segments[segment.currentSegmentIndex!], _chart);
    }
    if (!((segment._currentPoint?.low == segment._currentPoint?.high) &&
        //ignore: always_specify_types
        !(_series as HiloSeries).showIndicationForSameValues)) {
      segment.onPaint(canvas);
    }
  }

  @override
  HiloSegment createSegment() => HiloSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    segment._color = segment._seriesRenderer._seriesColor;
    segment._strokeColor = segment._seriesRenderer._seriesColor;
    segment._strokeWidth = segment._series.borderWidth;
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
