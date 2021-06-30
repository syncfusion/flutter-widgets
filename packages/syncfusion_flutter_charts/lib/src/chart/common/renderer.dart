part of charts;

// ignore: must_be_immutable
class _DataLabelRenderer extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _DataLabelRenderer({required this.cartesianChartState, required this.show});

  final SfCartesianChartState cartesianChartState;

  bool show;

  _DataLabelRendererState? state;

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    state = _DataLabelRendererState();
    return state!;
  }
}

class _DataLabelRendererState extends State<_DataLabelRenderer>
    with SingleTickerProviderStateMixin {
  // List<AnimationController> animationControllersList;

  /// Animation controller for series
  late AnimationController animationController;

  /// Repaint notifier for crosshair container
  late ValueNotifier<int> dataLabelRepaintNotifier;

  @override
  void initState() {
    dataLabelRepaintNotifier = ValueNotifier<int>(0);
    animationController = AnimationController(vsync: this)
      ..addListener(repaintDataLabelElements);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.state = this;
    animationController.duration = Duration(
        milliseconds:
            widget.cartesianChartState._renderingDetails.initialRender!
                ? 500
                : 0);
    final Animation<double> dataLabelAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.1, 0.8, curve: Curves.decelerate),
    ));

    animationController.forward(from: 0.0);
    return Container(
        child: CustomPaint(
            painter: _DataLabelPainter(
                cartesianChartState: widget.cartesianChartState,
                animation: dataLabelAnimation,
                state: this,
                animationController: animationController,
                notifier: dataLabelRepaintNotifier)));
  }

  @override
  void dispose() {
    // if (animationController != null) {
    animationController.removeListener(repaintDataLabelElements);
    animationController.dispose();
    //   animationController = null;
    // }
    super.dispose();
  }

  /// To repaint data label elements
  void repaintDataLabelElements() {
    dataLabelRepaintNotifier.value++;
  }

  void render() {
    setState(() {
      widget.show = true;
    });
  }
}

class _DataLabelPainter extends CustomPainter {
  _DataLabelPainter(
      {required this.cartesianChartState,
      required this.state,
      required this.animationController,
      required this.animation,
      required ValueNotifier<num> notifier})
      : super(repaint: notifier);

  final SfCartesianChartState cartesianChartState;

  final _DataLabelRendererState state;

  final AnimationController animationController;

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(cartesianChartState._chartAxis._axisClipRect);
    cartesianChartState._renderDatalabelRegions = <Rect>[];
    final List<CartesianSeriesRenderer> visibleSeriesRenderers =
        cartesianChartState._chartSeries.visibleSeriesRenderers;
    for (int i = 0; i < visibleSeriesRenderers.length; i++) {
      final CartesianSeriesRenderer seriesRenderer =
          cartesianChartState._chartSeries.visibleSeriesRenderers[i];
      DataLabelSettingsRenderer dataLabelSettingsRenderer;
      if (seriesRenderer._series.dataLabelSettings.isVisible &&
          (seriesRenderer._animationCompleted ||
              seriesRenderer._series.animationDuration == 0 ||
              !cartesianChartState._renderingDetails.initialRender!) &&
          (!seriesRenderer._needAnimateSeriesElements ||
              (cartesianChartState._seriesDurationFactor <
                      seriesRenderer._animationController.value ||
                  seriesRenderer._series.animationDuration == 0) ||
              (seriesRenderer._animationController.status ==
                  AnimationStatus.dismissed)) &&
          seriesRenderer._series.dataLabelSettings.builder == null) {
        seriesRenderer._dataLabelSettingsRenderer =
            DataLabelSettingsRenderer(seriesRenderer._series.dataLabelSettings);
        if (seriesRenderer._visibleDataPoints != null &&
            seriesRenderer._visibleDataPoints!.isNotEmpty) {
          for (int j = 0; j < seriesRenderer._visibleDataPoints!.length; j++) {
            if (seriesRenderer._visible! &&
                // ignore: unnecessary_null_comparison
                seriesRenderer._series.dataLabelSettings != null) {
              dataLabelSettingsRenderer =
                  seriesRenderer._dataLabelSettingsRenderer;
              dataLabelSettingsRenderer._renderDataLabel(
                  cartesianChartState,
                  seriesRenderer,
                  seriesRenderer._visibleDataPoints![j],
                  animation,
                  canvas,
                  j,
                  dataLabelSettingsRenderer);
            }
          }
        }
        if (animation.value >= 1) {
          seriesRenderer._needAnimateSeriesElements = false;
        }
      }
    }
  }

  @override
  bool shouldRepaint(_DataLabelPainter oldDelegate) => true;
}

/// find rect type series region
void _calculateRectSeriesRegion(
    CartesianChartPoint<dynamic> point,
    int pointIndex,
    CartesianSeriesRenderer seriesRenderer,
    SfCartesianChartState _chartState) {
  final ChartAxisRenderer xAxisRenderer = seriesRenderer._xAxisRenderer!;
  final ChartAxisRenderer yAxisRenderer = seriesRenderer._yAxisRenderer!;
  final num? crossesAt = _getCrossesAtValue(seriesRenderer, _chartState);
  final num sideBySideMinimumVal = seriesRenderer._sideBySideInfo!.minimum;

  final num sideBySideMaximumVal = seriesRenderer._sideBySideInfo!.maximum;

  final num origin =
      crossesAt ?? math.max(yAxisRenderer._visibleRange!.minimum, 0);

  /// Get the rectangle based on points
  final Rect rect = (seriesRenderer._seriesType.contains('stackedcolumn') ||
              seriesRenderer._seriesType.contains('stackedbar')) &&
          seriesRenderer is _StackedSeriesRenderer
      ? _calculateRectangle(
          point.xValue + sideBySideMinimumVal,
          seriesRenderer._stackingValues[0].endValues[pointIndex],
          point.xValue + sideBySideMaximumVal,
          crossesAt ??
              seriesRenderer._stackingValues[0].startValues[pointIndex],
          seriesRenderer,
          _chartState)
      : _calculateRectangle(
          point.xValue + sideBySideMinimumVal,
          seriesRenderer._seriesType == 'rangecolumn'
              ? point.high
              : seriesRenderer._seriesType == 'boxandwhisker'
                  ? point.maximum
                  : seriesRenderer._seriesType == 'waterfall'
                      ? point.endValue
                      : point.yValue,
          point.xValue + sideBySideMaximumVal,
          seriesRenderer._seriesType == 'rangecolumn'
              ? point.low
              : seriesRenderer._seriesType == 'boxandwhisker'
                  ? point.minimum
                  : seriesRenderer._seriesType == 'waterfall'
                      ? point.originValue
                      : origin,
          seriesRenderer,
          _chartState);

  point.region = rect;
  final dynamic series = seriesRenderer._series;

  ///Get shadow rect region
  if (seriesRenderer._seriesType != 'stackedcolumn100' &&
      seriesRenderer._seriesType != 'stackedbar100' &&
      seriesRenderer._seriesType != 'waterfall' &&
      series.isTrackVisible == true) {
    final Rect shadowPointRect = _calculateShadowRectangle(
        point.xValue + sideBySideMinimumVal,
        seriesRenderer._seriesType == 'rangecolumn' ? point.high : point.yValue,
        point.xValue + sideBySideMaximumVal,
        seriesRenderer._seriesType == 'rangecolumn' ? point.high : origin,
        seriesRenderer,
        _chartState,
        Offset(xAxisRenderer._axis.plotOffset, yAxisRenderer._axis.plotOffset));

    point.trackerRectRegion = shadowPointRect;
  }
  if (seriesRenderer._seriesType == 'rangecolumn' ||
      seriesRenderer._seriesType.contains('hilo') ||
      seriesRenderer._seriesType.contains('candle') ||
      seriesRenderer._seriesType.contains('boxandwhisker')) {
    point.markerPoint = _chartState._requireInvertedAxis != true
        ? _ChartLocation(rect.topCenter.dx, rect.topCenter.dy)
        : _ChartLocation(rect.centerRight.dx, rect.centerRight.dy);
    point.markerPoint2 = _chartState._requireInvertedAxis != true
        ? _ChartLocation(rect.bottomCenter.dx, rect.bottomCenter.dy)
        : _ChartLocation(rect.centerLeft.dx, rect.centerLeft.dy);
  } else {
    point.markerPoint = _chartState._requireInvertedAxis != true
        ? (yAxisRenderer._axis.isInversed
            ? (point.yValue.isNegative == true
                ? _ChartLocation(rect.topCenter.dx, rect.topCenter.dy)
                : _ChartLocation(rect.bottomCenter.dx, rect.bottomCenter.dy))
            : (point.yValue.isNegative == true
                ? _ChartLocation(rect.bottomCenter.dx, rect.bottomCenter.dy)
                : _ChartLocation(rect.topCenter.dx, rect.topCenter.dy)))
        : (yAxisRenderer._axis.isInversed
            ? (point.yValue.isNegative == true
                ? _ChartLocation(rect.centerRight.dx, rect.centerRight.dy)
                : _ChartLocation(rect.centerLeft.dx, rect.centerLeft.dy))
            : (point.yValue.isNegative == true
                ? _ChartLocation(rect.centerLeft.dx, rect.centerLeft.dy)
                : _ChartLocation(rect.centerRight.dx, rect.centerRight.dy)));
  }
  if (seriesRenderer._seriesType == 'waterfall') {
    /// The below values are used to find the chart location of the connector lines of each data point.
    point.originValueLeftPoint = _calculatePoint(
        point.xValue + sideBySideMinimumVal,
        point.originValue,
        xAxisRenderer,
        yAxisRenderer,
        _chartState._requireInvertedAxis,
        seriesRenderer._series,
        _calculatePlotOffset(
            _chartState._chartAxis._axisClipRect,
            Offset(xAxisRenderer._axis.plotOffset,
                yAxisRenderer._axis.plotOffset)));
    point.originValueRightPoint = _calculatePoint(
        point.xValue + sideBySideMaximumVal,
        point.originValue,
        xAxisRenderer,
        yAxisRenderer,
        _chartState._requireInvertedAxis,
        seriesRenderer._series,
        _calculatePlotOffset(
            _chartState._chartAxis._axisClipRect,
            Offset(xAxisRenderer._axis.plotOffset,
                yAxisRenderer._axis.plotOffset)));
    point.endValueLeftPoint = _calculatePoint(
        point.xValue + sideBySideMinimumVal,
        point.endValue,
        xAxisRenderer,
        yAxisRenderer,
        _chartState._requireInvertedAxis,
        seriesRenderer._series,
        _calculatePlotOffset(
            _chartState._chartAxis._axisClipRect,
            Offset(xAxisRenderer._axis.plotOffset,
                yAxisRenderer._axis.plotOffset)));
    point.endValueRightPoint = _calculatePoint(
        point.xValue + sideBySideMaximumVal,
        point.endValue,
        xAxisRenderer,
        yAxisRenderer,
        _chartState._requireInvertedAxis,
        seriesRenderer._series,
        _calculatePlotOffset(
            _chartState._chartAxis._axisClipRect,
            Offset(xAxisRenderer._axis.plotOffset,
                yAxisRenderer._axis.plotOffset)));
  }
}

/// calculate scatter, bubble series datapoints region
void _calculatePointSeriesRegion(
    CartesianChartPoint<dynamic> point,
    int pointIndex,
    CartesianSeriesRenderer seriesRenderer,
    SfCartesianChartState _chartState,
    Rect rect) {
  final ChartAxisRenderer xAxisRenderer = seriesRenderer._xAxisRenderer!;
  final ChartAxisRenderer yAxisRenderer = seriesRenderer._yAxisRenderer!;
  final CartesianSeries<dynamic, dynamic> series = seriesRenderer._series;
  final _ChartLocation currentPoint = _calculatePoint(
      point.xValue,
      point.yValue,
      xAxisRenderer,
      yAxisRenderer,
      _chartState._requireInvertedAxis,
      seriesRenderer._series,
      rect);
  point.markerPoint = currentPoint;
  if (seriesRenderer._seriesType == 'scatter') {
    point.region = Rect.fromLTRB(
        currentPoint.x - series.markerSettings.width,
        currentPoint.y - series.markerSettings.width,
        currentPoint.x + series.markerSettings.width,
        currentPoint.y + series.markerSettings.width);
  } else {
    final BubbleSeries<dynamic, dynamic> bubbleSeries =
        series as BubbleSeries<dynamic, dynamic>;
    num bubbleRadius = 0, sizeRange = 0, radiusRange, bubbleSize;
    if (seriesRenderer is BubbleSeriesRenderer) {
      sizeRange = seriesRenderer._maxSize! - seriesRenderer._minSize!;
    }
    bubbleSize = ((point.bubbleSize) ?? 4).toDouble();
    if (bubbleSeries.sizeValueMapper == null) {
      // ignore: unnecessary_null_comparison
      bubbleSeries.minimumRadius != null
          ? bubbleRadius = bubbleSeries.minimumRadius
          : bubbleRadius = bubbleSeries.maximumRadius;
    } else {
      // ignore: unnecessary_null_comparison
      if ((bubbleSeries.maximumRadius != null) &&
          // ignore: unnecessary_null_comparison
          (bubbleSeries.minimumRadius != null)) {
        if (sizeRange == 0) {
          bubbleRadius = bubbleSeries.maximumRadius;
        } else {
          radiusRange =
              (bubbleSeries.maximumRadius - bubbleSeries.minimumRadius) * 2;
          if (seriesRenderer is BubbleSeriesRenderer) {
            bubbleRadius =
                (((bubbleSize.abs() - seriesRenderer._minSize!) * radiusRange) /
                        sizeRange) +
                    bubbleSeries.minimumRadius;
          }
        }
      }
    }
    point.region = Rect.fromLTRB(
        currentPoint.x - 2 * bubbleRadius,
        currentPoint.y - 2 * bubbleRadius,
        currentPoint.x + 2 * bubbleRadius,
        currentPoint.y + 2 * bubbleRadius);
  }
}

///calculate data point region for path series like line, area, etc.,
void _calculatePathSeriesRegion(
    CartesianChartPoint<dynamic> point,
    int pointIndex,
    CartesianSeriesRenderer seriesRenderer,
    SfCartesianChartState _chartState,
    Rect rect,
    double markerHeight,
    double markerWidth,
    [_VisibleRange? sideBySideInfo,
    CartesianChartPoint<dynamic>? _nextPoint,
    num? midX,
    num? midY]) {
  final ChartAxisRenderer xAxisRenderer = seriesRenderer._xAxisRenderer!;
  final ChartAxisRenderer yAxisRenderer = seriesRenderer._yAxisRenderer!;
  final num? sideBySideMinimumVal = seriesRenderer._sideBySideInfo?.minimum;

  final num? sideBySideMaximumVal = seriesRenderer._sideBySideInfo?.maximum;
  if (seriesRenderer._seriesType != 'rangearea' &&
      seriesRenderer._seriesType != 'splinerangearea' &&
      (!seriesRenderer._seriesType.contains('hilo')) &&
      (!seriesRenderer._seriesType.contains('candle')) &&
      !seriesRenderer._seriesType.contains('boxandwhisker')) {
    if (seriesRenderer._seriesType == 'spline' &&
        pointIndex <= seriesRenderer._dataPoints.length - 2) {
      point.controlPoint = seriesRenderer._drawControlPoints[pointIndex];
      point.startControl = _calculatePoint(
          point.controlPoint![0].dx,
          point.controlPoint![0].dy,
          xAxisRenderer,
          yAxisRenderer,
          _chartState._requireInvertedAxis,
          seriesRenderer._series,
          rect);
      point.endControl = _calculatePoint(
          point.controlPoint![1].dx,
          point.controlPoint![1].dy,
          xAxisRenderer,
          yAxisRenderer,
          _chartState._requireInvertedAxis,
          seriesRenderer._series,
          rect);
    }
    if (seriesRenderer._seriesType == 'splinearea' &&
        pointIndex != 0 &&
        pointIndex <= seriesRenderer._dataPoints.length - 1) {
      point.controlPoint = seriesRenderer._drawControlPoints[pointIndex - 1];
      point.startControl = _calculatePoint(
          point.controlPoint![0].dx,
          point.controlPoint![0].dy,
          xAxisRenderer,
          yAxisRenderer,
          _chartState._requireInvertedAxis,
          seriesRenderer._series,
          rect);
      point.endControl = _calculatePoint(
          point.controlPoint![1].dx,
          point.controlPoint![1].dy,
          xAxisRenderer,
          yAxisRenderer,
          _chartState._requireInvertedAxis,
          seriesRenderer._series,
          rect);
    }

    if (seriesRenderer._seriesType == 'stepline') {
      point.currentPoint = _calculatePoint(
          point.xValue,
          point.yValue,
          seriesRenderer._xAxisRenderer!,
          seriesRenderer._yAxisRenderer!,
          seriesRenderer._chartState!._requireInvertedAxis,
          seriesRenderer._series,
          rect);
      if (_nextPoint != null) {
        point._nextPoint = _calculatePoint(
            _nextPoint.xValue,
            _nextPoint.yValue,
            seriesRenderer._xAxisRenderer!,
            seriesRenderer._yAxisRenderer!,
            seriesRenderer._chartState!._requireInvertedAxis,
            seriesRenderer._series,
            rect);
      }
      if (midX != null && midY != null) {
        point._midPoint = _calculatePoint(
            midX,
            midY,
            seriesRenderer._xAxisRenderer!,
            seriesRenderer._yAxisRenderer!,
            seriesRenderer._chartState!._requireInvertedAxis,
            seriesRenderer._series,
            rect);
      }
    }
    final _ChartLocation currentPoint =
        (seriesRenderer._seriesType == 'stackedarea' ||
                    seriesRenderer._seriesType == 'stackedarea100' ||
                    seriesRenderer._seriesType == 'stackedline' ||
                    seriesRenderer._seriesType == 'stackedline100') &&
                seriesRenderer is _StackedSeriesRenderer
            ? _calculatePoint(
                point.xValue,
                seriesRenderer._stackingValues[0].endValues[pointIndex],
                xAxisRenderer,
                yAxisRenderer,
                _chartState._requireInvertedAxis,
                seriesRenderer._series,
                rect)
            : _calculatePoint(
                point.xValue,
                point.yValue,
                xAxisRenderer,
                yAxisRenderer,
                _chartState._requireInvertedAxis,
                seriesRenderer._series,
                rect);

    point.region = Rect.fromLTWH(currentPoint.x - markerWidth,
        currentPoint.y - markerHeight, 2 * markerWidth, 2 * markerHeight);
    point.markerPoint = currentPoint;
  } else {
    num? value1, value2;
    value1 = (point.low != null &&
            point.high != null &&
            (point.low < point.high) == true)
        ? point.high
        : point.low;
    value2 = (point.low != null &&
            point.high != null &&
            (point.low > point.high) == true)
        ? point.high
        : point.low;
    if (seriesRenderer._seriesType == 'boxandwhisker') {
      value1 = (point.minimum != null &&
              point.maximum != null &&
              point.minimum! < point.maximum!)
          ? point.maximum
          : point.minimum;
      value2 = (point.minimum != null &&
              point.maximum != null &&
              point.minimum! > point.maximum!)
          ? point.maximum
          : point.minimum;
    }
    point.markerPoint = _calculatePoint(
        point.xValue,
        yAxisRenderer._axis.isInversed ? value2 : value1,
        xAxisRenderer,
        yAxisRenderer,
        _chartState._requireInvertedAxis,
        seriesRenderer._series,
        rect);
    point.markerPoint2 = _calculatePoint(
        point.xValue,
        yAxisRenderer._axis.isInversed ? value1 : value2,
        xAxisRenderer,
        yAxisRenderer,
        _chartState._requireInvertedAxis,
        seriesRenderer._series,
        rect);
    if (seriesRenderer._seriesType == 'splinerangearea' &&
        pointIndex != 0 &&
        pointIndex <= seriesRenderer._dataPoints.length - 1) {
      point.controlPointshigh = seriesRenderer._drawHighControlPoints[
          seriesRenderer._dataPoints.indexOf(point) - 1];

      point.highStartControl = _calculatePoint(
          point.controlPointshigh![0].dx,
          point.controlPointshigh![0].dy,
          xAxisRenderer,
          yAxisRenderer,
          _chartState._requireInvertedAxis,
          seriesRenderer._series,
          rect);

      point.highEndControl = _calculatePoint(
          point.controlPointshigh![1].dx,
          point.controlPointshigh![1].dy,
          xAxisRenderer,
          yAxisRenderer,
          _chartState._requireInvertedAxis,
          seriesRenderer._series,
          rect);
    }
    if (seriesRenderer._seriesType == 'splinerangearea' &&
        pointIndex >= 0 &&
        pointIndex <= seriesRenderer._dataPoints.length - 2) {
      point.controlPointslow = seriesRenderer
          ._drawLowControlPoints[seriesRenderer._dataPoints.indexOf(point)];

      point.lowStartControl = _calculatePoint(
          point.controlPointslow![0].dx,
          point.controlPointslow![0].dy,
          xAxisRenderer,
          yAxisRenderer,
          seriesRenderer._chartState!._requireInvertedAxis,
          seriesRenderer._series,
          rect);

      point.lowEndControl = _calculatePoint(
          point.controlPointslow![1].dx,
          point.controlPointslow![1].dy,
          xAxisRenderer,
          yAxisRenderer,
          seriesRenderer._chartState!._requireInvertedAxis,
          seriesRenderer._series,
          rect);
    }

    if (seriesRenderer._seriesType == 'hilo' &&
        point.low != null &&
        point.high != null) {
      point.lowPoint = _calculatePoint(
          point.xValue,
          point.low,
          seriesRenderer._xAxisRenderer!,
          seriesRenderer._yAxisRenderer!,
          _chartState._requireInvertedAxis,
          seriesRenderer._series,
          rect);
      point.highPoint = _calculatePoint(
          point.xValue,
          point.high,
          seriesRenderer._xAxisRenderer!,
          seriesRenderer._yAxisRenderer!,
          _chartState._requireInvertedAxis,
          seriesRenderer._series,
          rect);
    } else if ((seriesRenderer._seriesType == 'hiloopenclose' ||
            seriesRenderer._seriesType == 'candle') &&
        point.open != null &&
        point.close != null &&
        point.low != null &&
        point.high != null) {
      final num center = (point.xValue + sideBySideMinimumVal) +
          (((point.xValue + sideBySideMaximumVal) -
                  (point.xValue + sideBySideMinimumVal)) /
              2);
      point.openPoint = _calculatePoint(
          point.xValue + sideBySideMinimumVal,
          point.open,
          seriesRenderer._xAxisRenderer!,
          seriesRenderer._yAxisRenderer!,
          _chartState._requireInvertedAxis,
          seriesRenderer._series,
          rect);

      point.closePoint = _calculatePoint(
          point.xValue + sideBySideMaximumVal,
          point.close,
          seriesRenderer._xAxisRenderer!,
          seriesRenderer._yAxisRenderer!,
          _chartState._requireInvertedAxis,
          seriesRenderer._series,
          rect);
      if (seriesRenderer._series.dataLabelSettings.isVisible) {
        point.centerOpenPoint = _calculatePoint(
            point.xValue,
            point.open,
            seriesRenderer._xAxisRenderer!,
            seriesRenderer._yAxisRenderer!,
            _chartState._requireInvertedAxis,
            seriesRenderer._series,
            rect);

        point.centerClosePoint = _calculatePoint(
            point.xValue,
            point.close,
            seriesRenderer._xAxisRenderer!,
            seriesRenderer._yAxisRenderer!,
            _chartState._requireInvertedAxis,
            seriesRenderer._series,
            rect);
      }

      point.centerHighPoint = _calculatePoint(
          center,
          point.high,
          seriesRenderer._xAxisRenderer!,
          seriesRenderer._yAxisRenderer!,
          _chartState._requireInvertedAxis,
          seriesRenderer._series,
          rect);

      point.centerLowPoint = _calculatePoint(
          center,
          point.low,
          seriesRenderer._xAxisRenderer!,
          seriesRenderer._yAxisRenderer!,
          _chartState._requireInvertedAxis,
          seriesRenderer._series,
          rect);

      point.lowPoint = _calculatePoint(
          point.xValue + sideBySideMinimumVal,
          point.low,
          seriesRenderer._xAxisRenderer!,
          seriesRenderer._yAxisRenderer!,
          _chartState._requireInvertedAxis,
          seriesRenderer._series,
          rect);
      point.highPoint = _calculatePoint(
          point.xValue + sideBySideMaximumVal,
          point.high,
          seriesRenderer._xAxisRenderer!,
          seriesRenderer._yAxisRenderer!,
          _chartState._requireInvertedAxis,
          seriesRenderer._series,
          rect);
    }

    if (seriesRenderer._seriesType.contains('boxandwhisker') &&
        point.minimum != null &&
        point.maximum != null &&
        point.upperQuartile != null &&
        point.lowerQuartile != null &&
        point.median != null) {
      final num center = (point.xValue + sideBySideMinimumVal) +
          (((point.xValue + sideBySideMaximumVal) -
                  (point.xValue + sideBySideMinimumVal)) /
              2);
      point.centerMeanPoint = _calculatePoint(
          center,
          point.mean,
          seriesRenderer._xAxisRenderer!,
          seriesRenderer._yAxisRenderer!,
          seriesRenderer._chartState!._requireInvertedAxis,
          seriesRenderer._series,
          rect);

      point.minimumPoint = _calculatePoint(
          point.xValue + sideBySideMinimumVal,
          point.minimum,
          seriesRenderer._xAxisRenderer!,
          seriesRenderer._yAxisRenderer!,
          seriesRenderer._chartState!._requireInvertedAxis,
          seriesRenderer._series,
          rect);

      point.maximumPoint = _calculatePoint(
          point.xValue + sideBySideMaximumVal,
          point.maximum,
          seriesRenderer._xAxisRenderer!,
          seriesRenderer._yAxisRenderer!,
          seriesRenderer._chartState!._requireInvertedAxis,
          seriesRenderer._series,
          rect);

      point.centerMinimumPoint = _calculatePoint(
          center,
          point.minimum,
          seriesRenderer._xAxisRenderer!,
          seriesRenderer._yAxisRenderer!,
          seriesRenderer._chartState!._requireInvertedAxis,
          seriesRenderer._series,
          rect);

      point.centerMaximumPoint = _calculatePoint(
          center,
          point.maximum,
          seriesRenderer._xAxisRenderer!,
          seriesRenderer._yAxisRenderer!,
          seriesRenderer._chartState!._requireInvertedAxis,
          seriesRenderer._series,
          rect);

      point.lowerQuartilePoint = _calculatePoint(
          point.xValue + sideBySideMinimumVal,
          point.lowerQuartile,
          seriesRenderer._xAxisRenderer!,
          seriesRenderer._yAxisRenderer!,
          seriesRenderer._chartState!._requireInvertedAxis,
          seriesRenderer._series,
          rect);

      point.upperQuartilePoint = _calculatePoint(
          point.xValue + sideBySideMaximumVal,
          point.upperQuartile,
          seriesRenderer._xAxisRenderer!,
          seriesRenderer._yAxisRenderer!,
          seriesRenderer._chartState!._requireInvertedAxis,
          seriesRenderer._series,
          rect);

      point.medianPoint = _calculatePoint(
          point.xValue + sideBySideMinimumVal,
          point.median,
          seriesRenderer._xAxisRenderer!,
          seriesRenderer._yAxisRenderer!,
          seriesRenderer._chartState!._requireInvertedAxis,
          seriesRenderer._series,
          rect);

      point.centerMedianPoint = _calculatePoint(
          center,
          point.median,
          seriesRenderer._xAxisRenderer!,
          seriesRenderer._yAxisRenderer!,
          seriesRenderer._chartState!._requireInvertedAxis,
          seriesRenderer._series,
          rect);
    }
    point.region = seriesRenderer._seriesType.contains('hilo') ||
            seriesRenderer._seriesType.contains('candle') ||
            seriesRenderer._seriesType.contains('boxandwhisker')
        ? !_chartState._requireInvertedAxis
            ? Rect.fromLTWH(
                point.markerPoint!.x,
                point.markerPoint!.y,
                seriesRenderer._series.borderWidth,
                point.markerPoint2!.y - point.markerPoint!.y)
            : Rect.fromLTWH(
                point.markerPoint2!.x,
                point.markerPoint2!.y,
                (point.markerPoint!.x - point.markerPoint2!.x).abs(),
                seriesRenderer._series.borderWidth)
        : Rect.fromLTRB(
            point.markerPoint!.x - markerWidth,
            point.markerPoint!.y - markerHeight,
            point.markerPoint!.x + markerWidth,
            point.markerPoint2!.y);
    if (seriesRenderer._seriesType.contains('boxandwhisker')) {
      point.boxRectRegion = _calculateRectangle(
          point.xValue + sideBySideMinimumVal,
          point.upperQuartile!,
          point.xValue + sideBySideMaximumVal,
          point.lowerQuartile!,
          seriesRenderer,
          _chartState);
    }
  }
}

/// Finding outliers region
void _calculateOutlierRegion(CartesianChartPoint<dynamic> point,
    _ChartLocation outlierPosition, num outlierWidth) {
  point.outlierRegion!.add(Rect.fromLTRB(
      outlierPosition.x - outlierWidth,
      outlierPosition.y - outlierWidth,
      outlierPosition.x + outlierWidth,
      outlierPosition.y + outlierWidth));
}

///Finding tooltip region
void _calculateTooltipRegion(
    CartesianChartPoint<dynamic> point,
    int seriesIndex,
    CartesianSeriesRenderer seriesRenderer,
    SfCartesianChartState _chartState,
    [Trendline? trendline,
    TrendlineRenderer? trendlineRenderer,
    int? trendlineIndex]) {
  final SfCartesianChart chart = _chartState._chart;
  final ChartAxisRenderer xAxisRenderer = seriesRenderer._xAxisRenderer!;
  final CartesianSeries<dynamic, dynamic> series = seriesRenderer._series;
  final num? crossesAt = _getCrossesAtValue(seriesRenderer, _chartState);
  // ignore: unnecessary_null_comparison
  if ((series.enableTooltip != null ||
          // ignore: unnecessary_null_comparison
          seriesRenderer._chart.trackballBehavior != null ||
          chart.onPointTapped != null ||
          seriesRenderer._series.onPointTap != null ||
          seriesRenderer._series.onPointDoubleTap != null ||
          seriesRenderer._series.onPointLongPress != null) &&
      (series.enableTooltip ||
          seriesRenderer._chart.trackballBehavior.enable ||
          chart.onPointTapped != null ||
          seriesRenderer._series.onPointTap != null ||
          seriesRenderer._series.onPointDoubleTap != null ||
          seriesRenderer._series.onPointLongPress != null) &&
      // ignore: unnecessary_null_comparison
      point != null &&
      !point.isGap &&
      !point.isDrop &&
      seriesRenderer._regionalData != null) {
    bool isTrendline = false;
    if (trendline != null) {
      isTrendline = true;
    }
    final List<String> regionData = <String>[];
    num binWidth = 0;
    String? date;
    final List<dynamic> regionRect = <dynamic>[];
    if (seriesRenderer is HistogramSeriesRenderer) {
      binWidth = seriesRenderer._histogramValues.binWidth!;
    }
    if (xAxisRenderer is DateTimeAxisRenderer) {
      final DateTimeAxis xAxis = xAxisRenderer._axis as DateTimeAxis;
      final DateFormat dateFormat =
          xAxis.dateFormat ?? _getDateTimeLabelFormat(xAxisRenderer);
      date = dateFormat
          .format(DateTime.fromMillisecondsSinceEpoch(point.xValue.floor()));
    } else if (xAxisRenderer is DateTimeCategoryAxisRenderer) {
      date = point.x is DateTime
          ? xAxisRenderer._dateFormat.format(point.x)
          : point.x.toString();
    }
    xAxisRenderer is CategoryAxisRenderer
        ? regionData.add(point.x.toString())
        : (xAxisRenderer is DateTimeAxisRenderer ||
                xAxisRenderer is DateTimeCategoryAxisRenderer)
            ? regionData.add(date!.toString())
            : seriesRenderer._seriesType != 'histogram'
                ? regionData.add(_getLabelValue(
                        point.xValue,
                        xAxisRenderer._axis,
                        chart.tooltipBehavior.decimalPlaces)
                    .toString())
                : regionData.add((_getLabelValue(
                            point.xValue - binWidth / 2,
                            xAxisRenderer._axis,
                            chart.tooltipBehavior.decimalPlaces)
                        .toString()) +
                    ' - ' +
                    (_getLabelValue(
                            point.xValue + binWidth / 2,
                            xAxisRenderer._axis,
                            chart.tooltipBehavior.decimalPlaces)
                        .toString()));

    if (seriesRenderer._seriesType.contains('range') && !isTrendline ||
        seriesRenderer._seriesType.contains('hilo') ||
        seriesRenderer._seriesType.contains('candle') ||
        seriesRenderer._seriesType.contains('boxandwhisker')) {
      if (seriesRenderer._seriesType != 'hiloopenclose' &&
          seriesRenderer._seriesType != 'candle' &&
          seriesRenderer._seriesType != 'boxandwhisker') {
        regionData.add(point.high.toString());
        regionData.add(point.low.toString());
      } else if (seriesRenderer._seriesType != 'boxandwhisker') {
        regionData.add(point.high.toString());
        regionData.add(point.low.toString());
        regionData.add(point.open.toString());
        regionData.add(point.close.toString());
      } else {
        regionData.add(point.minimum.toString());
        regionData.add(point.maximum.toString());
        regionData.add(point.lowerQuartile.toString());
        regionData.add(point.upperQuartile.toString());
        regionData.add(point.median.toString());
        regionData.add(point.mean.toString());
      }
    } else {
      regionData.add(point.yValue.toString());
    }
    regionData.add(isTrendline
        ? trendlineRenderer!._name ?? ''
        : series.name ?? 'series $seriesIndex');
    regionRect.add(seriesRenderer._seriesType.contains('boxandwhisker')
        ? point.boxRectRegion
        : point.region);
    regionRect.add((seriesRenderer._isRectSeries) ||
            seriesRenderer._seriesType.contains('hilo') ||
            seriesRenderer._seriesType.contains('candle') ||
            seriesRenderer._seriesType.contains('boxandwhisker')
        ? seriesRenderer._seriesType == 'column' ||
                seriesRenderer._seriesType.contains('stackedcolumn') ||
                seriesRenderer._seriesType == 'histogram'
            ? (point.yValue > (crossesAt ?? 0)) == true
                ? point.region!.topCenter
                : point.region!.bottomCenter
            : seriesRenderer._seriesType.contains('hilo') ||
                    seriesRenderer._seriesType.contains('candle') ||
                    seriesRenderer._seriesType.contains('boxandwhisker')
                ? point.region!.topCenter
                : point.region!.topCenter
        : (seriesRenderer._seriesType.contains('rangearea')
            ? (isTrendline
                ? Offset(point.markerPoint!.x, point.markerPoint!.y)
                : Offset(point.markerPoint!.x, point.markerPoint!.y))
            : point.region!.center));
    regionRect.add(
        isTrendline ? trendlineRenderer!._fillColor : point.pointColorMapper);
    regionRect.add(point.bubbleSize);
    regionRect.add(point);
    regionRect.add(point.outlierRegion);
    regionRect.add(point.outlierRegionPosition);
    if (seriesRenderer._seriesType.contains('stacked')) {
      regionData.add((point.cumulativeValue).toString());
    }
    regionData.add('$isTrendline');
    if (isTrendline) {
      regionRect.add(trendline);
    }
    seriesRenderer._regionalData![regionRect] = regionData;
    point.regionData = regionData;
  }
}

/// Paint the image marker
void _drawImageMarker(CartesianSeriesRenderer? seriesRenderer, Canvas canvas,
    double pointX, double pointY,
    [TrackballMarkerSettings? trackballMarkerSettings,
    SfCartesianChartState? chartState]) {
  final MarkerSettingsRenderer? markerSettingsRenderer =
      seriesRenderer?._markerSettingsRenderer;

  if (seriesRenderer != null && markerSettingsRenderer!._image != null) {
    final double imageWidth = 2 * seriesRenderer._series.markerSettings.width;
    final double imageHeight = 2 * seriesRenderer._series.markerSettings.height;
    final Rect positionRect = Rect.fromLTWH(pointX - imageWidth / 2,
        pointY - imageHeight / 2, imageWidth, imageHeight);
    paintImage(
        canvas: canvas,
        rect: positionRect,
        image: markerSettingsRenderer._image!,
        fit: BoxFit.fill);
  }

  if (chartState?._trackballMarkerSettingsRenderer._image != null) {
    final double imageWidth = 2 * trackballMarkerSettings!.width;
    final double imageHeight = 2 * trackballMarkerSettings.height;
    final Rect positionRect = Rect.fromLTWH(pointX - imageWidth / 2,
        pointY - imageHeight / 2, imageWidth, imageHeight);
    paintImage(
        canvas: canvas,
        rect: positionRect,
        image: chartState!._trackballMarkerSettingsRenderer._image!,
        fit: BoxFit.fill);
  }
}

/// This method is for to calculate and rendering the length and Offsets of the dashed lines
void _drawDashedLine(
    Canvas canvas, List<double> dashArray, Paint paint, Path path) {
  bool even = false;
  for (int i = 1; i < dashArray.length; i = i + 2) {
    if (dashArray[i] == 0) {
      even = true;
    }
  }
  if (even == false) {
    paint.isAntiAlias = false;
    canvas.drawPath(
        _dashPath(
          path,
          dashArray: _CircularIntervalList<double>(dashArray),
        )!,
        paint);
  } else {
    canvas.drawPath(path, paint);
  }
}
