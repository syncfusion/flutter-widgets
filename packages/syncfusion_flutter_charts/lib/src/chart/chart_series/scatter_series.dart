part of charts;

/// Renders the scatter series.
///
/// To render a scatter chart, create an instance of ScatterSeries, and add it to the series collection property of [SfCartesianChart].
///
/// The following properties, such as [color], [opacity], [borderWidth], [borderColor] can be used to customize  the appearance of the scatter segment.

@immutable
class ScatterSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of ScatterSeries class.
  ScatterSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      required List<T> dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic>? sortFieldValueMapper,
      ChartValueMapper<T, Color>? pointColorMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      String? xAxisName,
      String? yAxisName,
      String? name,
      Color? color,
      MarkerSettings? markerSettings,
      EmptyPointSettings? emptyPointSettings,
      bool? isVisible,
      DataLabelSettings? dataLabelSettings,
      bool? enableTooltip,
      List<Trendline>? trendlines,
      double? animationDuration,
      Color? borderColor,
      double? borderWidth,
      LinearGradient? gradient,
      LinearGradient? borderGradient,
      SelectionBehavior? selectionBehavior,
      bool? isVisibleInLegend,
      LegendIconType? legendIconType,
      SortingOrder? sortingOrder,
      String? legendItemText,
      double? opacity,
      SeriesRendererCreatedCallback? onRendererCreated,
      ChartPointInteractionCallback? onPointTap,
      ChartPointInteractionCallback? onPointDoubleTap,
      ChartPointInteractionCallback? onPointLongPress,
      List<int>? initialSelectedDataIndexes})
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
            markerSettings: markerSettings,
            dataLabelSettings: dataLabelSettings,
            emptyPointSettings: emptyPointSettings,
            enableTooltip: enableTooltip,
            isVisible: isVisible,
            animationDuration: animationDuration,
            borderColor: borderColor,
            borderWidth: borderWidth,
            trendlines: trendlines,
            gradient: gradient,
            borderGradient: borderGradient,
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
            initialSelectedDataIndexes: initialSelectedDataIndexes);

  /// Create the scatter series renderer.
  ScatterSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    ScatterSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as ScatterSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return ScatterSeriesRenderer();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is ScatterSeries &&
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
      onRendererCreated,
      initialSelectedDataIndexes,
      onPointTap,
      onPointDoubleTap,
      onPointLongPress
    ];
    return hashList(values);
  }
}

/// Creates series renderer for Scatter series
class ScatterSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of ScatterSeriesRenderer class.
  ScatterSeriesRenderer();

  // ignore:unused_field
  CartesianChartPoint<dynamic>? _point;

  final bool _isLineType = false;

  ScatterSegment? _segment;

  ///Adds the points to the segments .
  ChartSegment _createSegments(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, double animateFactor) {
    final ScatterSegment segment = createSegment();
    final List<CartesianSeriesRenderer> oldSeriesRenderers =
        _chartState!._oldSeriesRenderers;
    _isRectSeries = false;
    // ignore: unnecessary_null_comparison
    if (segment != null) {
      segment._seriesIndex = seriesIndex;
      segment.currentSegmentIndex = pointIndex;
      segment._seriesRenderer = this;
      segment._series = _series as XyDataSeries<dynamic, dynamic>;
      segment.animationFactor = animateFactor;
      segment._point = currentPoint;
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
                segment._oldSeriesRenderer!._segments[0] is ScatterSegment &&
                segment._oldSeriesRenderer!._dataPoints.length - 1 >=
                    pointIndex)
            ? segment._oldSeriesRenderer!._dataPoints[pointIndex]
            : null;
        segment._oldSegmentIndex = _getOldSegmentIndex(segment);
        if ((_chartState!._selectedSegments.length - 1 >= pointIndex) &&
            _chartState?._selectedSegments[pointIndex]._oldSegmentIndex ==
                null) {
          final ChartSegment selectedSegment =
              _chartState?._selectedSegments[pointIndex] as ChartSegment;
          selectedSegment._oldSeriesRenderer =
              oldSeriesRenderers[selectedSegment._seriesIndex];
          selectedSegment._seriesRenderer = this;
          selectedSegment._oldSegmentIndex =
              _getOldSegmentIndex(selectedSegment);
        }
      }
      final _ChartLocation location = _calculatePoint(
          currentPoint.xValue,
          currentPoint.yValue,
          _xAxisRenderer!,
          _yAxisRenderer!,
          _chartState!._requireInvertedAxis,
          _series,
          _chartState!._chartAxis._axisClipRect);
      segment.points.add(Offset(location.x, location.y));
      segment._segmentRect =
          RRect.fromRectAndRadius(currentPoint.region!, Radius.zero);
      customizeSegment(segment);
      _segments.add(segment);
      _segment = segment;
    }
    return segment;
  }

  /// To render scatter series segments
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
  ScatterSegment createSegment() => ScatterSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final ScatterSegment scatterSegment = segment as ScatterSegment;
    scatterSegment._color = scatterSegment._seriesRenderer._seriesColor;
    scatterSegment._strokeColor = scatterSegment._series.borderColor;
    scatterSegment._strokeWidth =
        ((scatterSegment._series.markerSettings.shape ==
                        DataMarkerType.verticalLine ||
                    scatterSegment._series.markerSettings.shape ==
                        DataMarkerType.horizontalLine) &&
                scatterSegment._series.borderWidth == 0)
            ? scatterSegment._series.markerSettings.borderWidth
            : scatterSegment._series.borderWidth;
    scatterSegment.strokePaint = scatterSegment.getStrokePaint();
    scatterSegment.fillPaint = scatterSegment.getFillPaint();
  }

  ///Draws marker with different shape and color of the appropriate data point in the series.
  @override
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY,
      [CartesianSeriesRenderer? seriesRenderer]) {
    final Size size =
        Size(_series.markerSettings.width, _series.markerSettings.height);
    final Path markerPath = _getMarkerShapesPath(
        _series.markerSettings.shape,
        Offset(pointX, pointY),
        size,
        seriesRenderer!,
        index,
        null,
        seriesRenderer._seriesElementAnimation,
        _segment);
    canvas.drawPath(markerPath, fillPaint);
    canvas.drawPath(markerPath, strokePaint);
  }

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      _drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}
