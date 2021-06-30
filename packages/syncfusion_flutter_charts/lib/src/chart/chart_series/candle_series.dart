part of charts;

/// This class holds the properties of the candle series.
///
/// To render a candle chart, create an instance of [CandleSeries], and add it to the `series` collection property of [SfCartesianChart].
/// The candle chart represents the hollow rectangle with the open, close, high and low value in the given data.
///
///  It has the [bearColor] and [bullColor] properties to change the appearance of the candle series.
///
/// Provides options for color, opacity, border color, and border width
/// to customize the appearance.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=g5cniDExpRw}
@immutable
class CandleSeries<T, D> extends _FinancialSeriesBase<T, D> {
  /// Creating an argument constructor of CandleSeries class.
  CandleSeries({
    ValueKey<String>? key,
    ChartSeriesRendererFactory<T, D>? onCreateRenderer,
    required List<T> dataSource,
    required ChartValueMapper<T, D> xValueMapper,
    required ChartValueMapper<T, num> lowValueMapper,
    required ChartValueMapper<T, num> highValueMapper,
    required ChartValueMapper<T, num> openValueMapper,
    required ChartValueMapper<T, num> closeValueMapper,
    ChartValueMapper<T, dynamic>? sortFieldValueMapper,
    ChartValueMapper<T, Color>? pointColorMapper,
    ChartValueMapper<T, String>? dataLabelMapper,
    SortingOrder? sortingOrder,
    String? xAxisName,
    String? yAxisName,
    String? name,
    Color? bearColor,
    Color? bullColor,
    bool? enableSolidCandles,
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
    SeriesRendererCreatedCallback? onRendererCreated,
    ChartPointInteractionCallback? onPointTap,
    ChartPointInteractionCallback? onPointDoubleTap,
    ChartPointInteractionCallback? onPointLongPress,
    List<int>? initialSelectedDataIndexes,
    bool? showIndicationForSameValues,
    List<Trendline>? trendlines,
  }) : super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            name: name,
            onRendererCreated: onRendererCreated,
            onPointTap: onPointTap,
            onPointDoubleTap: onPointDoubleTap,
            onPointLongPress: onPointLongPress,
            dashArray: dashArray,
            xValueMapper: xValueMapper,
            lowValueMapper: lowValueMapper,
            highValueMapper: highValueMapper,
            // ignore: unnecessary_null_comparison
            openValueMapper: openValueMapper != null
                ? (int index) => openValueMapper(dataSource[index], index)
                : null,
            // ignore: unnecessary_null_comparison
            closeValueMapper: closeValueMapper != null
                ? (int index) => closeValueMapper(dataSource[index], index)
                : null,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
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
            bearColor: bearColor ?? Colors.red,
            bullColor: bullColor ?? Colors.green,
            enableSolidCandles: enableSolidCandles ?? false,
            initialSelectedDataIndexes: initialSelectedDataIndexes,
            showIndicationForSameValues: showIndicationForSameValues ?? false,
            trendlines: trendlines);

  /// Create the candle series renderer.
  CandleSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    CandleSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as CandleSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return CandleSeriesRenderer();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is CandleSeries &&
        other.key == key &&
        other.onCreateRenderer == onCreateRenderer &&
        other.dataSource == dataSource &&
        other.xValueMapper == xValueMapper &&
        other.lowValueMapper == lowValueMapper &&
        other.highValueMapper == highValueMapper &&
        other.openValueMapper == openValueMapper &&
        other.closeValueMapper == closeValueMapper &&
        other.sortFieldValueMapper == sortFieldValueMapper &&
        other.pointColorMapper == pointColorMapper &&
        other.dataLabelMapper == dataLabelMapper &&
        other.sortingOrder == sortingOrder &&
        other.xAxisName == xAxisName &&
        other.yAxisName == yAxisName &&
        other.name == name &&
        other.bearColor == bearColor &&
        other.bullColor == bullColor &&
        other.enableSolidCandles == enableSolidCandles &&
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
      openValueMapper,
      closeValueMapper,
      sortFieldValueMapper,
      pointColorMapper,
      dataLabelMapper,
      sortingOrder,
      xAxisName,
      yAxisName,
      name,
      bearColor,
      bullColor,
      enableSolidCandles,
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

/// Creates series renderer for Candle series
class CandleSeriesRenderer extends _FinancialSerieBaseRenderer {
  /// Calling the default constructor of CandleSeriesRenderer class.
  CandleSeriesRenderer();

  // Store the rect position //
  @override
  late num _rectPosition;

  // Store the rect count //
  @override
  late num _rectCount;

  late CandleSegment _candleSegment, _segment;

  late CandleSeries<dynamic, dynamic> _candleSeries;

  late CandleSeriesRenderer _candelSereisRenderer;

  List<CartesianSeriesRenderer>? _oldSeriesRenderers;

  /// Range column _segment is created here
  ChartSegment _createSegments(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, double animateFactor) {
    _segment = createSegment();
    _oldSeriesRenderers = _chartState!._oldSeriesRenderers;
    _isRectSeries = false;
    // ignore: unnecessary_null_comparison
    if (_segment != null) {
      _segment._seriesIndex = seriesIndex;
      _segment.currentSegmentIndex = pointIndex;
      _segment._seriesRenderer = this;
      _segment._series = _series as XyDataSeries<dynamic, dynamic>;
      _segment.animationFactor = animateFactor;
      _segment._pointColorMapper = currentPoint.pointColorMapper;
      _segment._currentPoint = currentPoint;
      if (_renderingDetails!.widgetNeedUpdate &&
          !_renderingDetails!.isLegendToggled &&
          _oldSeriesRenderers != null &&
          _oldSeriesRenderers!.isNotEmpty &&
          _oldSeriesRenderers!.length - 1 >= _segment._seriesIndex &&
          _oldSeriesRenderers![_segment._seriesIndex]._seriesName ==
              _segment._seriesRenderer._seriesName) {
        _segment._oldSeriesRenderer =
            _oldSeriesRenderers![_segment._seriesIndex];
        _segment._oldSegmentIndex = _getOldSegmentIndex(_segment);
      }
      _segment.calculateSegmentPoints();
      //stores the points for rendering candle - high, low and rect points
      _segment.points
        ..add(Offset(currentPoint.markerPoint!.x, _segment._highPoint.y))
        ..add(Offset(currentPoint.markerPoint!.x, _segment._lowPoint.y))
        ..add(Offset(_segment._openX, _segment._topRectY))
        ..add(Offset(_segment._closeX, _segment._topRectY))
        ..add(Offset(_segment._closeX, _segment._bottomRectY))
        ..add(Offset(_segment._openX, _segment._bottomRectY));
      _candleSegment = _segment;
      customizeSegment(_segment);
      _segment.strokePaint = _segment.getStrokePaint();
      _segment.fillPaint = _segment.getFillPaint();
      _segments.add(_segment);
    }
    return _segment;
  }

  @override
  CandleSegment createSegment() => CandleSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment _segment) {
    _candleSeries = _series as CandleSeries<dynamic, dynamic>;
    _candelSereisRenderer = _segment._seriesRenderer as CandleSeriesRenderer;
    _candleSegment = _candelSereisRenderer._candleSegment;

    if (_candleSeries.enableSolidCandles!) {
      _candleSegment._isSolid = true;
      _candleSegment._color = _candleSegment._isBull
          ? _candleSeries.bullColor
          : _candleSeries.bearColor;
    } else {
      _candleSegment._isSolid = !_candleSegment._isBull;
      _candleSegment.currentSegmentIndex! - 1 >= 0 &&
              _candleSegment
                          ._seriesRenderer
                          ._dataPoints[_candleSegment.currentSegmentIndex! - 1]
                          .close >
                      _candleSegment
                          ._seriesRenderer
                          ._dataPoints[_candleSegment.currentSegmentIndex!]
                          .close ==
                  true
          ? _candleSegment._color = _candleSeries.bearColor
          : _candleSegment._color = _candleSeries.bullColor;
    }
    _segment._strokeWidth = _segment._series.borderWidth;
  }

  /// To draw candle series segments
  //ignore: unused_element
  void _drawSegment(Canvas canvas, ChartSegment _segment) {
    if (_segment._seriesRenderer._isSelectionEnable) {
      final SelectionBehaviorRenderer? selectionBehaviorRenderer =
          _segment._seriesRenderer._selectionBehaviorRenderer;
      selectionBehaviorRenderer?._selectionRenderer?._checkWithSelectionState(
          _segments[_segment.currentSegmentIndex!], _chart);
    }
    _segment.onPaint(canvas);
  }

  ///Draws marker with different shape and color of the appropriate data point in the series.
  @override
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY,
      [CartesianSeriesRenderer? seriesRenderer]) {}

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      _drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}
