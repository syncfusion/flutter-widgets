part of charts;

/// This class holds the properties of the candle series.
///
/// To render a candle chart, create an instance of [CandleSeries], and add it to the [series] collection property of [SfCartesianChart].
/// The candle chart represents the hollow rectangle with the open, close, high and low value in the given data.
///
///  It has the [bearColor] and [bullColor] properties to change the appearance of the candle series.
///
/// Provides options for color, opacity, border color, and border width
/// to customize the appearance.
///
class CandleSeries<T, D> extends _FinancialSeriesBase<T, D> {
  /// Creating an argument constructor of CandleSeries class.
  CandleSeries({
    ValueKey<String> key,
    ChartSeriesRendererFactory<T, D> onCreateRenderer,
    @required List<T> dataSource,
    @required ChartValueMapper<T, D> xValueMapper,
    @required ChartValueMapper<T, num> lowValueMapper,
    @required ChartValueMapper<T, num> highValueMapper,
    @required ChartValueMapper<T, num> openValueMapper,
    @required ChartValueMapper<T, num> closeValueMapper,
    ChartValueMapper<T, dynamic> sortFieldValueMapper,
    ChartValueMapper<T, Color> pointColorMapper,
    ChartValueMapper<T, String> dataLabelMapper,
    SortingOrder sortingOrder,
    String xAxisName,
    String yAxisName,
    String name,
    Color bearColor,
    Color bullColor,
    bool enableSolidCandles,
    EmptyPointSettings emptyPointSettings,
    DataLabelSettings dataLabelSettings,
    bool isVisible,
    bool enableTooltip,
    double animationDuration,
    // Color borderColor,
    double borderWidth,
    // ignore: deprecated_member_use_from_same_package
    SelectionSettings selectionSettings,
    SelectionBehavior selectionBehavior,
    bool isVisibleInLegend,
    LegendIconType legendIconType,
    String legendItemText,
    List<double> dashArray,
    double opacity,
    SeriesRendererCreatedCallback onRendererCreated,
    List<int> initialSelectedDataIndexes,
    bool showIndicationForSameValues,
    List<Trendline> trendlines,
  }) : super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            name: name,
            onRendererCreated: onRendererCreated,
            dashArray: dashArray,
            xValueMapper: xValueMapper,
            lowValueMapper: lowValueMapper,
            highValueMapper: highValueMapper,
            openValueMapper: openValueMapper != null
                ? (int index) => openValueMapper(dataSource[index], index)
                : null,
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
            selectionSettings: selectionSettings,
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
      seriesRenderer = onCreateRenderer(series);
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return CandleSeriesRenderer();
  }
}

/// Creates series renderer for Candle series
class CandleSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of CandleSeriesRenderer class.
  CandleSeriesRenderer();

  // Store the rect position //
  num _rectPosition;

  // Store the rect count //
  num _rectCount;

  CandleSegment _candleSegment, _segment;

  CandleSeries<dynamic, dynamic> _candleSeries;

  CandleSeriesRenderer _candelSereisRenderer;

  List<CartesianSeriesRenderer> _oldSeriesRenderers;

  /// Range column _segment is created here
  ChartSegment _createSegments(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, num animateFactor) {
    _segment = createSegment();
    _oldSeriesRenderers = _chartState._oldSeriesRenderers;
    _isRectSeries = false;
    if (_segment != null) {
      _segment._seriesIndex = seriesIndex;
      _segment.currentSegmentIndex = pointIndex;
      _segment._seriesRenderer = this;
      _segment._series = _series;
      _segment.animationFactor = animateFactor;
      _segment._pointColorMapper = currentPoint.pointColorMapper;
      _segment._currentPoint = currentPoint;
      if (_chartState._widgetNeedUpdate &&
          !_chartState._isLegendToggled &&
          _oldSeriesRenderers != null &&
          _oldSeriesRenderers.isNotEmpty &&
          _oldSeriesRenderers.length - 1 >= _segment._seriesIndex &&
          _oldSeriesRenderers[_segment._seriesIndex]._seriesName ==
              _segment._seriesRenderer._seriesName) {
        _segment._oldSeriesRenderer =
            _oldSeriesRenderers[_segment._seriesIndex];
      }
      _segment.calculateSegmentPoints();
      //stores the points for rendering candle - high, low and rect points
      _segment.points
        ..add(Offset(currentPoint.markerPoint.x, _segment._highPoint.y))
        ..add(Offset(currentPoint.markerPoint.x, _segment._lowPoint.y))
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
  ChartSegment createSegment() => CandleSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment _segment) {
    _candleSeries = _series;
    _candelSereisRenderer = _segment._seriesRenderer;
    _candleSegment = _candelSereisRenderer._candleSegment;

    if (_candleSeries.enableSolidCandles) {
      _candleSegment._isSolid = true;
      _candleSegment._color = _candleSegment._isBull
          ? _candleSeries.bullColor
          : _candleSeries.bearColor;
    } else {
      _candleSegment._isSolid = !_candleSegment._isBull ? true : false;
      _candleSegment.currentSegmentIndex - 1 >= 0 &&
              _candleSegment
                      ._seriesRenderer
                      ._dataPoints[_candleSegment.currentSegmentIndex - 1]
                      .close >
                  _candleSegment._seriesRenderer
                      ._dataPoints[_candleSegment.currentSegmentIndex].close
          ? _candleSegment._color = _candleSeries.bearColor
          : _candleSegment._color = _candleSeries.bullColor;
    }
    _segment._strokeWidth = _segment._series.borderWidth;
  }

  /// To draw candle series segments
  //ignore: unused_element
  void _drawSegment(Canvas canvas, ChartSegment _segment) {
    if (_segment._seriesRenderer._isSelectionEnable) {
      final SelectionBehaviorRenderer selectionBehaviorRenderer =
          _segment._seriesRenderer._selectionBehaviorRenderer;
      selectionBehaviorRenderer._selectionRenderer._checkWithSelectionState(
          _segments[_segment.currentSegmentIndex], _chart);
    }
    _segment.onPaint(canvas);
  }

  ///Draws marker with different shape and color of the appropriate data point in the series.
  @override
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY,
      [CartesianSeriesRenderer seriesRenderer]) {}

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      _drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}
