part of charts;

/// Renders the HiloOpenClose series.
///
/// HiLoOpenClose series is used to represent the low, high, open and closing values over time.
///
///To render a HiloOpenClose chart, create an instance of HiloOpenCloseSeries,
/// and add it to the series collection property of [SfCartesianChart].
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=g5cniDExpRw}
class HiloOpenCloseSeries<T, D> extends _FinancialSeriesBase<T, D> {
  /// Creating an argument constructor of HiloOpenCloseSeries class.
  HiloOpenCloseSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      required List<T> dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      required ChartValueMapper<T, num> lowValueMapper,
      required ChartValueMapper<T, num> highValueMapper,
      required ChartValueMapper<T, num> openValueMapper,
      required ChartValueMapper<T, num> closeValueMapper,
      ChartValueMapper<T, num>? volumeValueMapper,
      ChartValueMapper<T, dynamic>? sortFieldValueMapper,
      ChartValueMapper<T, Color>? pointColorMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      SortingOrder? sortingOrder,
      String? xAxisName,
      String? yAxisName,
      String? name,
      Color? bearColor,
      Color? bullColor,
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
      ChartPointInteractionCallback? onPointLongPress})
      : super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            name: name,
            dashArray: dashArray,
            spacing: spacing,
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
            // ignore: unnecessary_null_comparison
            volumeValueMapper: volumeValueMapper != null
                ? (int index) => volumeValueMapper(dataSource[index], index)
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
            initialSelectedDataIndexes: initialSelectedDataIndexes,
            onRendererCreated: onRendererCreated,
            onPointTap: onPointTap,
            onPointDoubleTap: onPointDoubleTap,
            onPointLongPress: onPointLongPress,
            showIndicationForSameValues: showIndicationForSameValues ?? false,
            trendlines: trendlines);

  /// Create the hilo open close series renderer.
  HiloOpenCloseSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    HiloOpenCloseSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as HiloOpenCloseSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return HiloOpenCloseSeriesRenderer();
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is HiloOpenCloseSeries &&
        other.key == key &&
        other.onCreateRenderer == onCreateRenderer &&
        other.dataSource == dataSource &&
        other.xValueMapper == xValueMapper &&
        other.lowValueMapper == lowValueMapper &&
        other.highValueMapper == highValueMapper &&
        other.openValueMapper == openValueMapper &&
        other.closeValueMapper == closeValueMapper &&
        other.volumeValueMapper == volumeValueMapper &&
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
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
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
      volumeValueMapper,
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

/// Creates series renderer for Hilo open close series
class HiloOpenCloseSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of HiloOpenCloseSeriesRenderer class.
  HiloOpenCloseSeriesRenderer();

  // Store the rect position //
  late num _rectPosition;

  // Store the rect count //
  late num _rectCount;

  late HiloOpenCloseSeries<dynamic, dynamic> _hiloOpenCloseSeries;

  late HiloOpenCloseSegment _segment;

  List<CartesianSeriesRenderer>? _oldSeriesRenderers;

  /// HiloOpenClose _segment is created here
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
      //stores the points for rendering Hilo open close segment, High, low, open, close
      _segment.points
        ..add(Offset(currentPoint.markerPoint!.x, _segment._highPoint.y))
        ..add(Offset(currentPoint.markerPoint!.x, _segment._lowPoint.y))
        ..add(Offset(_segment._openX, _segment._openY))
        ..add(Offset(_segment._closeX, _segment._closeY));
      customizeSegment(_segment);
      _segment.strokePaint = _segment.getStrokePaint();
      _segment.fillPaint = _segment.getFillPaint();
      _segments.add(_segment);
    }
    return _segment;
  }

  /// To render hilo open close series segments
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

  @override
  HiloOpenCloseSegment createSegment() => HiloOpenCloseSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment _segment) {
    _hiloOpenCloseSeries = _series as HiloOpenCloseSeries<dynamic, dynamic>;
    _segment._color = _segment._seriesRenderer._seriesColor;
    _segment._strokeColor = _segment is HiloOpenCloseSegment && _segment._isBull
        ? _hiloOpenCloseSeries.bullColor
        : _hiloOpenCloseSeries.bearColor;
    _segment._strokeWidth = _segment._series.borderWidth;
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
