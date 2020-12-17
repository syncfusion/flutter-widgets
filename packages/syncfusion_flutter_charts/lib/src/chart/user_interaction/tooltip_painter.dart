part of charts;

// ignore: must_be_immutable
class _ChartTooltipRenderer extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _ChartTooltipRenderer({this.chartState}) : chartWidget = chartState._chart;

  final dynamic chartWidget;

  final dynamic chartState;

  _ChartTooltipRendererState state;

  @override
  State<StatefulWidget> createState() {
    return _ChartTooltipRendererState();
  }
}

class _ChartTooltipRendererState extends State<_ChartTooltipRenderer>
    with SingleTickerProviderStateMixin {
  /// Animation controller for series
  AnimationController animationController;

  /// Repaint notifier for crosshair container
  ValueNotifier<int> tooltipRepaintNotifier;

  bool show;

  //ignore: prefer_final_fields
  bool _needMarker = true;

  @override
  void initState() {
    show = false;
    tooltipRepaintNotifier = ValueNotifier<int>(0);
    animationController = AnimationController(vsync: this)
      ..addListener(_repaintTooltipElements);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.state = this;
    animationController.duration = Duration(
        milliseconds: widget.chartWidget.tooltipBehavior.animationDuration);
    final Animation<double> tooltipAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.1, 0.8, curve: Curves.easeOutBack),
    ));
    animationController.forward(from: 0.0);
    final _TooltipPainter tooltipPainter = _TooltipPainter(
        tooltipAnimation: tooltipAnimation,
        chartTooltipState: this,
        notifier: tooltipRepaintNotifier,
        animationController: animationController);
    tooltipPainter._chart = widget.chartWidget;
    tooltipPainter.tooltip = widget.chartWidget.tooltipBehavior;
    tooltipPainter._chartState = widget.chartState;
    tooltipPainter._chartState._tooltipBehaviorRenderer._painter =
        tooltipPainter;
    return Container(
        child: RepaintBoundary(child: CustomPaint(painter: tooltipPainter)));
  }

  @override
  void dispose() {
    _disposeAnimationController(animationController, _repaintTooltipElements);
    super.dispose();
  }

  void _repaintTooltipElements() {
    tooltipRepaintNotifier.value++;
  }

  /// To show tooltip with position offsets
  void _showTooltip(double x, double y) {
    if (x != null &&
        y != null &&
        widget.chartState._tooltipBehaviorRenderer._painter != null) {
      show = true;
      widget.chartState._tooltipBehaviorRenderer._isHovering
          ? widget.chartState._tooltipBehaviorRenderer._painter
              .showMouseTooltip(x, y)
          : widget.chartState._tooltipBehaviorRenderer._painter.show(x, y);
    }
  }
}

/// Holds the tooltip series and point index
///
/// This class is used to provide the [seriesIndex] and [pointIndex] for the Tooltip.
class TooltipValue {
  /// Creating an argument constructor of TooltipValue class.
  TooltipValue(this.seriesIndex, this.pointIndex, [this.outlierIndex]);

  ///Index of the series.
  int seriesIndex;

  ///Index of data points.
  int pointIndex;

  ///Index of outlier points.
  int outlierIndex;
}

class _TooltipPainter extends CustomPainter {
  _TooltipPainter(
      {this.chartTooltipState,
      this.animationController,
      this.tooltipAnimation,
      ValueNotifier<num> notifier})
      : super(repaint: notifier);
  double pointerLength = 10;
  double nosePointY = 0;
  double nosePointX = 0;
  double totalWidth = 0;
  double x;
  double y;
  double xPos;
  double yPos;
  ValueNotifier<int> valueNotifier;
  bool isTop = false;
  double borderRadius = 5;
  Path arrowPath = Path();
  bool canResetPath = false;
  Timer timer;
  bool isLeft = false;
  bool isRight = false;
  Animation<double> tooltipAnimation;
  dynamic _chart;
  bool enable;
  num padding = 0;
  String stringValue;
  num markerPointY;
  List<String> textValues = <String>[];
  List<CartesianSeriesRenderer> seriesRendererCollection =
      <CartesianSeriesRenderer>[];
  String header;
  Rect boundaryRect = const Rect.fromLTWH(0, 0, 0, 0);
  Rect _tooltipRect;
  dynamic tooltip;
  dynamic _chartState;
  dynamic currentSeries, dataPoint;
  num pointIndex;
  double markerSize;
  Color markerColor;
  CartesianSeriesRenderer seriesRenderer;
  TooltipValue prevTooltipValue;
  TooltipValue currentTooltipValue;

  final _ChartTooltipRendererState chartTooltipState;

  final AnimationController animationController;

  bool mouseTooltip = false;

  /// To render chart tooltip
  // ignore:unused_element
  void _renderTooltipView(Offset position) {
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        _chartState._tooltipBehaviorRenderer;
    if (tooltipBehaviorRenderer._painter._chart is SfCartesianChart) {
      _renderCartesianChartTooltip(position);
    } else if (tooltipBehaviorRenderer._painter._chart is SfCircularChart) {
      _renderCircularChartTooltip(position);
    } else {
      _renderTriangularChartTooltip(position);
    }
  }

  /// To render a chart tooltip for cartesian series
  void _renderCartesianChartTooltip(Offset position) {
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        _chartState._tooltipBehaviorRenderer;
    tooltipBehaviorRenderer._painter.boundaryRect =
        _chartState._chartAxis._axisClipRect;
    bool isContains = false;
    if (_chartState._chartAxis._axisClipRect.contains(position)) {
      Offset tooltipPosition;
      double touchPadding;
      Offset padding;
      bool isTrendLine;
      dynamic dataRect;
      dynamic dataValues;
      bool outlierTooltip = false;
      int outlierTooltipIndex = -1;
      for (int i = 0;
          i < _chartState._chartSeries.visibleSeriesRenderers.length;
          i++) {
        seriesRenderer = _chartState._chartSeries.visibleSeriesRenderers[i];
        final CartesianSeries<dynamic, dynamic> series = seriesRenderer._series;
        if (seriesRenderer._visible &&
            series.enableTooltip &&
            seriesRenderer._regionalData != null) {
          int count = 0;
          seriesRenderer._regionalData
              .forEach((dynamic regionRect, dynamic values) {
            isTrendLine = values[values.length - 1].contains('true');
            touchPadding = ((seriesRenderer._seriesType == 'bubble' ||
                        seriesRenderer._seriesType == 'scatter' ||
                        seriesRenderer._seriesType.contains('column') ||
                        seriesRenderer._seriesType.contains('bar') ||
                        seriesRenderer._seriesType == 'histogram') &&
                    !isTrendLine)
                ? 0
                : _chartState._tooltipBehaviorRenderer._isHovering
                    ? 0
                    : 15; // regional padding to detect smooth touch
            final Rect region = regionRect[0];
            final List<Rect> outlierRegion = regionRect[5];
            final double left = region.left - touchPadding;
            final double right = region.right + touchPadding;
            final double top = region.top - touchPadding;
            final double bottom = region.bottom + touchPadding;
            Rect paddedRegion = Rect.fromLTRB(left, top, right, bottom);
            if (outlierRegion != null) {
              for (int rectIndex = 0;
                  rectIndex < outlierRegion.length;
                  rectIndex++) {
                if (outlierRegion[rectIndex].contains(position)) {
                  paddedRegion = outlierRegion[rectIndex];
                  outlierTooltipIndex = rectIndex;
                  outlierTooltip = true;
                }
              }
            }
            if (paddedRegion.contains(position) &&
                (isTrendLine ? regionRect[4].isVisible : true)) {
              if (seriesRenderer._seriesType != 'boxandwhisker'
                  ? !region.contains(position)
                  : (paddedRegion.contains(position) ||
                      !region.contains(position))) {
                tooltipBehaviorRenderer._painter.boundaryRect =
                    _chartState._containerRect;
              }
              tooltipBehaviorRenderer._painter.prevTooltipValue =
                  TooltipValue(i, count, outlierTooltipIndex);
              currentSeries = seriesRenderer;
              pointIndex = _chart is SfCartesianChart
                  ? regionRect[4].visiblePointIndex
                  : count;
              dataPoint = regionRect[4];
              Color seriesColor = seriesRenderer._seriesColor;
              if (seriesRenderer._seriesType == 'waterfall') {
                seriesColor = _getWaterfallSeriesColor(seriesRenderer._series,
                    seriesRenderer._dataPoints[pointIndex], seriesColor);
              }
              markerColor = regionRect[2] ??
                  seriesRenderer._series.markerSettings.borderColor ??
                  seriesColor;
              tooltipPosition = (outlierTooltipIndex >= 0)
                  ? regionRect[6][outlierTooltipIndex]
                  : regionRect[1];
              final List<Offset> paddingData = !(seriesRenderer._isRectSeries &&
                      tooltipBehaviorRenderer
                              ._tooltipBehavior.tooltipPosition !=
                          TooltipPosition.auto)
                  ? _getTooltipPaddingData(seriesRenderer, isTrendLine, region,
                      paddedRegion, tooltipPosition)
                  : <Offset>[const Offset(2, 2), tooltipPosition];
              padding = paddingData[0];
              tooltipPosition = paddingData[1];
              dataValues = values;
              dataRect = regionRect;
              isContains = mouseTooltip = true;
            }
            count++;
          });
        }
      }
      if (isContains) {
        seriesRenderer = currentSeries ?? seriesRenderer;
        if (tooltipBehaviorRenderer._painter.prevTooltipValue != null &&
            tooltipBehaviorRenderer._painter.currentTooltipValue != null &&
            (tooltipBehaviorRenderer._painter.prevTooltipValue.pointIndex !=
                    tooltipBehaviorRenderer
                        ._painter.currentTooltipValue.pointIndex ||
                tooltipBehaviorRenderer._painter.prevTooltipValue.seriesIndex !=
                    tooltipBehaviorRenderer
                        ._painter.currentTooltipValue.seriesIndex)) {
          tooltipBehaviorRenderer._painter.currentTooltipValue = null;
        } else if (seriesRenderer._seriesType == 'boxandwhisker' &&
            tooltipBehaviorRenderer._painter.currentTooltipValue != null &&
            tooltipBehaviorRenderer._painter.prevTooltipValue.outlierIndex !=
                tooltipBehaviorRenderer
                    ._painter.currentTooltipValue.outlierIndex) {
          tooltipBehaviorRenderer._painter.currentTooltipValue = null;
        }
        if (currentSeries._isRectSeries &&
            tooltip.tooltipPosition == TooltipPosition.pointer) {
          tooltipPosition = position;
        }
        tooltipBehaviorRenderer._painter.padding = padding.dy;
        String header = tooltip.header;
        header = (header == null)
            ? (tooltip.shared
                ? dataValues[0]
                : (isTrendLine
                    ? dataValues[dataValues.length - 2]
                    : currentSeries._series.name ?? currentSeries._seriesName))
            : header;
        tooltipBehaviorRenderer._painter.header = header;
        tooltipBehaviorRenderer._painter.stringValue = '';
        if (tooltip.shared) {
          textValues = <String>[];
          seriesRendererCollection = <CartesianSeriesRenderer>[];
          for (int j = 0;
              j < _chartState._chartSeries.visibleSeriesRenderers.length;
              j++) {
            final CartesianSeriesRenderer seriesRenderer =
                _chartState._chartSeries.visibleSeriesRenderers[j];
            if (seriesRenderer._visible &&
                seriesRenderer._series.enableTooltip) {
              final int index = seriesRenderer._xValues.indexOf(dataRect[4].x);
              if (index > -1) {
                final String text =
                    (tooltipBehaviorRenderer._painter.stringValue != ''
                            ? '\n'
                            : '') +
                        _calculateCartesianTooltipText(
                            seriesRenderer,
                            seriesRenderer._dataPoints[index],
                            dataValues,
                            tooltipPosition,
                            outlierTooltip,
                            outlierTooltipIndex);
                tooltipBehaviorRenderer._painter.stringValue += text;
                textValues.add(text);
                seriesRendererCollection.add(seriesRenderer);
              }
            }
          }
        } else {
          tooltipBehaviorRenderer._painter.stringValue =
              _calculateCartesianTooltipText(
                  currentSeries,
                  dataRect[4],
                  dataValues,
                  tooltipPosition,
                  outlierTooltip,
                  outlierTooltipIndex);
        }
        tooltipBehaviorRenderer._painter._calculateLocation(tooltipPosition);
      } else {
        if (!_chartState._tooltipBehaviorRenderer._isHovering) {
          tooltipBehaviorRenderer._painter.prevTooltipValue =
              tooltipBehaviorRenderer._painter.currentTooltipValue = null;
          tooltip.hide();
        } else {
          mouseTooltip = isContains;
        }
      }
    }
  }

  /// It returns the tooltip text of cartesian series
  String _calculateCartesianTooltipText(
      CartesianSeriesRenderer seriesRenderer,
      CartesianChartPoint<dynamic> point,
      dynamic values,
      Offset tooltipPosition,
      bool outlierTooltip,
      int outlierTooltipIndex) {
    final bool isTrendLine = values[values.length - 1].contains('true');
    String resultantString;
    final ChartAxisRenderer axisRenderer = seriesRenderer._yAxisRenderer;
    final int digits = seriesRenderer._chart.tooltipBehavior.decimalPlaces;
    String minimumValue,
        maximumValue,
        lowerQuartileValue,
        upperQuartileValue,
        medianValue,
        meanValue,
        outlierValue,
        highValue,
        lowValue,
        openValue,
        closeValue,
        cumulativeValue,
        boxPlotString;
    if (seriesRenderer._seriesType == 'boxandwhisker') {
      minimumValue = _getLabelValue(point.minimum, axisRenderer._axis, digits);
      maximumValue = _getLabelValue(point.maximum, axisRenderer._axis, digits);
      lowerQuartileValue =
          _getLabelValue(point.lowerQuartile, axisRenderer._axis, digits);
      upperQuartileValue =
          _getLabelValue(point.upperQuartile, axisRenderer._axis, digits);
      medianValue = _getLabelValue(point.median, axisRenderer._axis, digits);
      meanValue = _getLabelValue(point.mean, axisRenderer._axis, digits);
      outlierValue = (point.outliers.isNotEmpty && outlierTooltipIndex >= 0)
          ? _getLabelValue(
              point.outliers[outlierTooltipIndex], axisRenderer._axis, digits)
          : null;
      boxPlotString = '\nMinimum : ' +
          minimumValue +
          '\nMaximum : ' +
          maximumValue +
          '\nMedian : ' +
          medianValue +
          '\nMean : ' +
          meanValue +
          '\nLQ : ' +
          lowerQuartileValue +
          '\nHQ : ' +
          upperQuartileValue;
    } else if (seriesRenderer._seriesType.contains('range') ||
        seriesRenderer._seriesType == 'hilo' ||
        seriesRenderer._seriesType == 'hiloopenclose' ||
        seriesRenderer._seriesType == 'candle') {
      highValue = _getLabelValue(point.high, axisRenderer._axis, digits);
      lowValue = _getLabelValue(point.low, axisRenderer._axis, digits);
      if (seriesRenderer._seriesType == 'candle' ||
          seriesRenderer._seriesType == 'hiloopenclose') {
        openValue = _getLabelValue(point.open, axisRenderer._axis, digits);
        closeValue = _getLabelValue(point.close, axisRenderer._axis, digits);
      }
    } else if (seriesRenderer._seriesType.contains('stacked')) {
      cumulativeValue =
          _getLabelValue(point.cumulativeValue, axisRenderer._axis, digits);
    }
    if (tooltip.format != null) {
      resultantString = (seriesRenderer._seriesType.contains('range') || seriesRenderer._seriesType == 'hilo') &&
              !isTrendLine
          ? (tooltip.format
              .replaceAll('point.x', values[0])
              .replaceAll('point.high', highValue)
              .replaceAll('point.low', lowValue)
              .replaceAll('seriesRenderer._series.name',
                  seriesRenderer._series.name ?? seriesRenderer._seriesName))
          : (seriesRenderer._seriesType.contains('hiloopenclose') || seriesRenderer._seriesType.contains('candle')) &&
                  !isTrendLine
              ? (tooltip.format
                  .replaceAll('point.x', values[0])
                  .replaceAll('point.high', highValue)
                  .replaceAll('point.low', lowValue)
                  .replaceAll('point.open', openValue)
                  .replaceAll('point.close', closeValue)
                  .replaceAll(
                      'seriesRenderer._series.name',
                      seriesRenderer._series.name ??
                          seriesRenderer._seriesName))
              : (seriesRenderer._seriesType.contains('boxandwhisker')) &&
                      !isTrendLine
                  ? (tooltip.format
                      .replaceAll('point.x', values[0])
                      .replaceAll('point.minimum', minimumValue)
                      .replaceAll('point.maximum', maximumValue)
                      .replaceAll('point.lowerQuartile', lowerQuartileValue)
                      .replaceAll('point.upperQuartile', upperQuartileValue)
                      .replaceAll('point.mean', meanValue)
                      .replaceAll('point.median', medianValue)
                      .replaceAll(
                          'seriesRenderer._series.name',
                          seriesRenderer._series.name ??
                              seriesRenderer._seriesName))
                  : (tooltip.format
                      .replaceAll('point.x', values[0])
                      .replaceAll('point.y', _getLabelValue(point.y, axisRenderer._axis, digits))
                      .replaceAll('series.name', seriesRenderer._series.name ?? seriesRenderer._seriesName)
                      .replaceAll('point.size', _getLabelValue(point.bubbleSize, axisRenderer._axis, digits)));
      if (seriesRenderer._seriesType.contains('stacked')) {
        resultantString = resultantString.replaceAll(
            'point.cumulativeValue', cumulativeValue);
      }
    } else {
      resultantString = (tooltip.shared
              ? seriesRenderer._series.name ?? seriesRenderer._seriesName
              : values[0]) +
          (((seriesRenderer._seriesType.contains('range') ||
                      seriesRenderer._seriesType == 'hilo') &&
                  !isTrendLine)
              ? ('\nHigh : ' + highValue + '\nLow : ' + lowValue)
              : (seriesRenderer._seriesType == 'hiloopenclose' ||
                      seriesRenderer._seriesType == 'candle'
                  ? ('\nHigh : ' +
                      highValue +
                      '\nLow : ' +
                      lowValue +
                      '\nOpen : ' +
                      openValue +
                      '\nClose : ' +
                      closeValue)
                  : seriesRenderer._seriesType == 'boxandwhisker'
                      ? outlierValue != null
                          ? ('\nOutliers : ' + outlierValue)
                          : boxPlotString
                      : ' : ' +
                          _getLabelValue(point.y, axisRenderer._axis, digits)));
    }
    return resultantString;
  }

  /// To render a chart tooltip for circular series
  void _renderCircularChartTooltip(Offset position) {
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        _chartState._tooltipBehaviorRenderer;
    final SfCircularChart chart = tooltipBehaviorRenderer._painter._chart;
    tooltipBehaviorRenderer._painter.boundaryRect =
        _chartState._chartContainerRect;
    bool isContains = false;
    final _Region pointRegion = _getCircularPointRegion(
        chart, position, _chartState._chartSeries.visibleSeriesRenderers[0]);
    if (pointRegion != null &&
        _chartState._chartSeries.visibleSeriesRenderers[pointRegion.seriesIndex]
            ._series.enableTooltip) {
      tooltipBehaviorRenderer._painter.prevTooltipValue =
          TooltipValue(pointRegion.seriesIndex, pointRegion.pointIndex);
      if (tooltipBehaviorRenderer._painter.prevTooltipValue != null &&
          tooltipBehaviorRenderer._painter.currentTooltipValue != null &&
          tooltipBehaviorRenderer._painter.prevTooltipValue.pointIndex !=
              tooltipBehaviorRenderer._painter.currentTooltipValue.pointIndex) {
        tooltipBehaviorRenderer._painter.currentTooltipValue = null;
      }
      final ChartPoint<dynamic> chartPoint = _chartState
          ._chartSeries
          .visibleSeriesRenderers[pointRegion.seriesIndex]
          ._renderPoints[pointRegion.pointIndex];
      final Offset location =
          chart.tooltipBehavior.tooltipPosition == TooltipPosition.pointer
              ? position
              : _degreeToPoint(
                  chartPoint.midAngle,
                  (chartPoint.innerRadius + chartPoint.outerRadius) / 2,
                  chartPoint.center);
      currentSeries = pointRegion.seriesIndex;
      pointIndex = pointRegion.pointIndex;
      dataPoint = _chartState
          ._chartSeries.visibleSeriesRenderers[0]._dataPoints[pointIndex];
      final int digits = chart.tooltipBehavior.decimalPlaces;
      String header = chart.tooltipBehavior.header;
      header = (header == null)
          // ignore: prefer_if_null_operators
          ? _chartState
                      ._chartSeries
                      .visibleSeriesRenderers[pointRegion.seriesIndex]
                      ._series
                      .name !=
                  null
              ? _chartState._chartSeries
                  .visibleSeriesRenderers[pointRegion.seriesIndex]._series.name
              : null
          : header;
      _chartState._tooltipBehaviorRenderer._painter.header = header;
      if (chart.tooltipBehavior.format != null) {
        final String resultantString = chart.tooltipBehavior.format
            .replaceAll('point.x', chartPoint.x.toString())
            .replaceAll('point.y', _getDecimalLabelValue(chartPoint.y, digits))
            .replaceAll(
                'series.name',
                _chartState
                        ._chartSeries
                        .visibleSeriesRenderers[pointRegion.seriesIndex]
                        ._series
                        .name ??
                    'series.name');
        _chartState._tooltipBehaviorRenderer._painter.stringValue =
            resultantString;
        _chartState._tooltipBehaviorRenderer._painter
            ._calculateLocation(location);
      } else {
        _chartState._tooltipBehaviorRenderer._painter.stringValue =
            (chartPoint.x.toString() +
                ' : ' +
                _getDecimalLabelValue(chartPoint.y, digits));
        _chartState._tooltipBehaviorRenderer._painter
            ._calculateLocation(location);
      }
      isContains = true;
    } else {
      chart.tooltipBehavior.hide();
      isContains = false;
    }
    mouseTooltip = isContains;
    if (!isContains) {
      tooltipBehaviorRenderer._painter.prevTooltipValue =
          tooltipBehaviorRenderer._painter.currentTooltipValue = null;
    }
  }

  /// To render a chart tooltip for triangular series
  void _renderTriangularChartTooltip(Offset position) {
    final dynamic chart = _chart;
    final dynamic chartState = _chartState;
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        chartState._tooltipBehaviorRenderer;
    chartState._tooltipBehaviorRenderer._painter.boundaryRect =
        chartState._chartContainerRect;
    bool isContains = false;
    const num seriesIndex = 0;
    pointIndex =
        _chartState._tooltipPointIndex ?? _chartState._currentActive.pointIndex;
    dataPoint = _chartState
        ._chartSeries.visibleSeriesRenderers[0]._dataPoints[pointIndex];
    _chartState._tooltipPointIndex = null;
    final int digits = chart.tooltipBehavior.decimalPlaces;
    if (chart.tooltipBehavior.enable) {
      tooltipBehaviorRenderer._painter.prevTooltipValue =
          TooltipValue(seriesIndex, pointIndex);
      if (tooltipBehaviorRenderer._painter.prevTooltipValue != null &&
          tooltipBehaviorRenderer._painter.currentTooltipValue != null &&
          tooltipBehaviorRenderer._painter.prevTooltipValue.pointIndex !=
              tooltipBehaviorRenderer._painter.currentTooltipValue.pointIndex) {
        tooltipBehaviorRenderer._painter.currentTooltipValue = null;
      }
      final PointInfo<dynamic> chartPoint = _chartState._chartSeries
          .visibleSeriesRenderers[seriesIndex]._renderPoints[pointIndex];
      final Offset location = chart.tooltipBehavior.tooltipPosition ==
                  TooltipPosition.pointer &&
              _chartState._chartSeries.visibleSeriesRenderers[seriesIndex]
                  ._series.explode
          ? chartPoint.symbolLocation
          : chart.tooltipBehavior.tooltipPosition == TooltipPosition.pointer &&
                  !_chartState._chartSeries.visibleSeriesRenderers[seriesIndex]
                      ._series.explode
              ? position
              : chartPoint.symbolLocation;
      currentSeries = seriesIndex;
      pointIndex = pointIndex;
      String header = chart.tooltipBehavior.header;
      header = (header == null)
          // ignore: prefer_if_null_operators
          ? _chartState._chartSeries.visibleSeriesRenderers[seriesIndex]._series
                      .name !=
                  null
              ? _chartState
                  ._chartSeries.visibleSeriesRenderers[seriesIndex]._series.name
              : null
          : header;
      _chartState._tooltipBehaviorRenderer._painter.header = header;
      if (chart.tooltipBehavior.format != null) {
        final String resultantString = chart.tooltipBehavior.format
            .replaceAll('point.x', chartPoint.x.toString())
            .replaceAll('point.y', _getDecimalLabelValue(chartPoint.y, digits))
            .replaceAll(
                'series.name',
                _chartState._chartSeries.visibleSeriesRenderers[seriesIndex]
                        ._series.name ??
                    'series.name');
        _chartState._tooltipBehaviorRenderer._painter.stringValue =
            resultantString;
        _chartState._tooltipBehaviorRenderer._painter
            ._calculateLocation(location);
      } else {
        _chartState._tooltipBehaviorRenderer._painter.stringValue =
            chartPoint.x.toString() +
                ' : ' +
                _getDecimalLabelValue(chartPoint.y, digits);
        _chartState._tooltipBehaviorRenderer._painter
            ._calculateLocation(location);
      }
      isContains = true;
    } else {
      chart.tooltipBehavior.hide();
      isContains = false;
    }
    mouseTooltip = isContains;
    if (!isContains) {
      chartState._tooltipBehaviorRenderer._painter._painter.prevTooltipValue =
          chartState._tooltipBehaviorRenderer._painter._painter
              .currentTooltipValue = null;
    }
  }

  /// To get the location of chart tooltip
  void _calculateLocation(Offset position) {
    x = position?.dx;
    y = position?.dy;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (chartTooltipState.show) {
      if (_chart is SfCartesianChart && _chartState is SfCartesianChartState) {
        _chartState._tooltipBehaviorRenderer.onPaint(canvas);
      } else if (_chart is SfCircularChart &&
          _chartState is SfCircularChartState) {
        _chartState._tooltipBehaviorRenderer.onPaint(canvas);
      } else if (_chart is SfPyramidChart &&
          _chartState is SfPyramidChartState) {
        _chartState._tooltipBehaviorRenderer.onPaint(canvas);
      } else if (_chart is SfFunnelChart && _chartState is SfFunnelChartState) {
        _chartState._tooltipBehaviorRenderer.onPaint(canvas);
      }
    }
  }

  /// To render tooltip
  void _renderTooltip(Canvas canvas) {
    isLeft = false;
    isRight = false;
    double height = 0, width = 0, headerTextWidth = 0, headerTextHeight = 0;
    TooltipArgs tooltipArgs;
    Size textSize, headerSize;
    markerSize = 0;

    if (x != null &&
        y != null &&
        stringValue != null &&
        (!(_chart is SfCartesianChart) || !_chartState._requireAxisTooltip)) {
      final int seriesIndex = _chart is SfCartesianChart
          ? currentSeries._segments[0]._seriesIndex
          : currentSeries;
      if (_chart.onTooltipRender != null && !dataPoint.isTooltipRenderEvent) {
        dataPoint.isTooltipRenderEvent = true;
        tooltipArgs = TooltipArgs(
            _chart is SfCartesianChart
                ? currentSeries._segments[0]._seriesIndex
                : currentSeries,
            _chartState
                ._chartSeries.visibleSeriesRenderers[seriesIndex]._dataPoints,
            pointIndex,
            _chart is SfCartesianChart
                ? _chartState._chartSeries.visibleSeriesRenderers[seriesIndex]
                    ._visibleDataPoints[pointIndex].overallDataPointIndex
                : pointIndex);
        tooltipArgs.text = stringValue;
        tooltipArgs.header = header;
        tooltipArgs.locationX = x;
        tooltipArgs.locationY = y;
        _chart.onTooltipRender(tooltipArgs);
        stringValue = tooltipArgs.text;
        header = tooltipArgs.header;
        x = tooltipArgs.locationX;
        y = tooltipArgs.locationY;
      }
      if (tooltipAnimation.status == AnimationStatus.completed) {
        dataPoint?.isTooltipRenderEvent = false;
      }
    }

    totalWidth = boundaryRect.left.toDouble() + boundaryRect.width.toDouble();
    final TextStyle textStyle =
        _getTooltiptextStyle(tooltip.textStyle, false, true);
    textSize = _measureText(stringValue, textStyle);
    width = textSize.width;
    height = textSize.height;
    if (header != null && header.isNotEmpty) {
      final TextStyle headerTextStyle =
          _getTooltiptextStyle(tooltip.textStyle, true, true);
      headerSize = _measureText(header, headerTextStyle);
      headerTextWidth = headerSize.width;
      headerTextHeight = headerSize.height + 10;
      width = width > headerTextWidth ? width : headerTextWidth;
    }

    if (width < 10) {
      width = 10; // minimum width for tooltip to render
      borderRadius = borderRadius > 5 ? 5 : borderRadius;
    }
    if (borderRadius > 15) {
      borderRadius = 15;
    }

    if (x != null &&
        y != null &&
        padding != null &&
        (stringValue != '' && stringValue != null ||
            header != '' && header != null)) {
      _calculateBackgroundRect(canvas, height, width, headerTextHeight);
    }
  }

  /// calculate tooltip rect and arrow head
  void _calculateBackgroundRect(
      Canvas canvas, double height, double width, double headerTextHeight) {
    double widthPadding = 15;
    Rect boundaryRect;
    if (_chart is SfCartesianChart &&
        tooltip.canShowMarker != null &&
        tooltip.canShowMarker &&
        chartTooltipState._needMarker) {
      markerSize = 5;
      widthPadding = 17;
    }
    if (_chart is SfCartesianChart &&
        (!_chartState._requireAxisTooltip &&
            (currentTooltipValue != null &&
                currentTooltipValue.seriesIndex != null))) {
      boundaryRect = _chartState._chartAxis._axisClipRect;
    } else if ((_chart is SfCartesianChart) &&
        (_chartState._requireAxisTooltip ||
            (currentTooltipValue != null &&
                currentTooltipValue.seriesIndex == null))) {
      boundaryRect = _chartState._containerRect;
    } else {
      if (_chart is SfCartesianChart) {
        return;
      } else {
        boundaryRect = _chartState._chartAreaRect;
      }
    }

    Rect rect = Rect.fromLTWH(x, y, width + (2 * markerSize) + widthPadding,
        height + headerTextHeight + 10);
    final Rect newRect = Rect.fromLTWH(boundaryRect.left + 20, boundaryRect.top,
        boundaryRect.width - 40, boundaryRect.height);
    final Rect leftRect = Rect.fromLTWH(
        boundaryRect.left - 5,
        boundaryRect.top - 20,
        newRect.left - (boundaryRect.left - 5),
        boundaryRect.height + 40);
    final Rect rightRect = Rect.fromLTWH(newRect.right, boundaryRect.top - 20,
        (boundaryRect.right + 5) + newRect.right, boundaryRect.height + 40);

    if (leftRect.contains(Offset(x, y))) {
      isLeft = true;
      isRight = false;
    } else if (rightRect.contains(Offset(x, y))) {
      isLeft = false;
      isRight = true;
    }

    if (y > pointerLength + rect.height && y > boundaryRect.top) {
      if (_chart is SfCartesianChart && !_chartState._requireAxisTooltip) {
        if (currentSeries._seriesType == 'bubble') {
          padding = 2;
        }
      }
      isTop = true;
      xPos = x - (rect.width / 2);
      yPos = (y - rect.height) - padding;
      nosePointY = rect.top - padding;
      nosePointX = rect.left;
      final double tooltipRightEnd = x + (rect.width / 2);
      if (_chart is SfCartesianChart && _chartState._requireAxisTooltip) {
        xPos = xPos < boundaryRect.left ? boundaryRect.left : xPos;
      } else {
        xPos = xPos < boundaryRect.left
            ? boundaryRect.left
            : tooltipRightEnd > totalWidth
                ? totalWidth - rect.width
                : xPos;
      }
      yPos = yPos - (pointerLength / 2);
    } else {
      isTop = false;
      xPos = x - (rect.width / 2);
      yPos =
          ((y >= boundaryRect.top ? y : boundaryRect.top) + pointerLength / 2) +
              padding;
      nosePointX = rect.left;
      nosePointY = (y >= boundaryRect.top ? y : boundaryRect.top) + padding;
      final double tooltipRightEnd = x + (rect.width / 2);
      if (_chart is SfCartesianChart && _chartState._requireAxisTooltip) {
        xPos = xPos < boundaryRect.left ? boundaryRect.left : xPos;
      } else {
        xPos = xPos < boundaryRect.left
            ? boundaryRect.left
            : tooltipRightEnd > totalWidth
                ? totalWidth - rect.width
                : xPos;
      }
    }
    if (xPos <= boundaryRect.left + 5) {
      xPos = xPos + 5;
    } else if (xPos + rect.width >= totalWidth - 5) {
      xPos = xPos - 5;
    }
    rect = Rect.fromLTWH(xPos, yPos, rect.width, rect.height);
    if (boundaryRect.right < rect.right &&
        _chart is SfCartesianChart &&
        _chartState._requireAxisTooltip) {
      const padding = 5;
      rect = Rect.fromLTRB(boundaryRect.right - width - padding, rect.top,
          boundaryRect.right + padding, rect.bottom);
    }
    _drawTooltipBackground(canvas, rect, nosePointX, nosePointY, borderRadius,
        isTop, arrowPath, isLeft, isRight, tooltipAnimation);
  }

  /// To draw the tooltip background
  void _drawTooltipBackground(
      Canvas canvas,
      Rect rectF,
      double xPos,
      double yPos,
      double borderRadius,
      bool isTop,
      Path backgroundPath,
      bool isLeft,
      bool isRight,
      Animation<double> tooltipAnimation) {
    final double startArrow = pointerLength / 2;
    final double endArrow = pointerLength / 2;
    if (isTop) {
      _drawTooltip(
          canvas,
          isTop,
          rectF,
          xPos,
          yPos,
          xPos - startArrow,
          yPos - startArrow,
          xPos + endArrow,
          yPos - endArrow,
          borderRadius,
          backgroundPath,
          isLeft,
          isRight,
          tooltipAnimation);
    } else {
      _drawTooltip(
          canvas,
          isTop,
          rectF,
          xPos,
          yPos,
          xPos - startArrow,
          yPos + startArrow,
          xPos + endArrow,
          yPos + endArrow,
          borderRadius,
          backgroundPath,
          isLeft,
          isRight,
          tooltipAnimation);
    }
  }

  void _drawTooltip(
      Canvas canvas,
      bool isTop,
      Rect rectF,
      double xPos,
      double yPos,
      double startX,
      double startY,
      double endX,
      double endY,
      double borderRadius,
      Path backgroundPath,
      bool isLeft,
      bool isRight,
      Animation<double> tooltipAnimation) {
    double animationFactor = 0;
    if (tooltipAnimation == null) {
      animationFactor = 1;
    } else {
      animationFactor = tooltipAnimation.value;
    }
    backgroundPath.reset();
    if (!canResetPath) {
      if (isLeft) {
        startX = rectF.left + (2 * borderRadius);
        endX = startX + pointerLength;
      } else if (isRight) {
        startX = endX - pointerLength;
        endX = rectF.right - (2 * borderRadius);
      }

      final Rect rect = Rect.fromLTWH(
          rectF.width / 2 + (rectF.left - rectF.width / 2 * animationFactor),
          rectF.height / 2 + (rectF.top - rectF.height / 2 * animationFactor),
          rectF.width * animationFactor,
          rectF.height * animationFactor);

      _tooltipRect = rect;

      final RRect tooltipRect = RRect.fromRectAndCorners(
        rect,
        bottomLeft: Radius.circular(borderRadius),
        bottomRight: Radius.circular(borderRadius),
        topLeft: Radius.circular(borderRadius),
        topRight: Radius.circular(borderRadius),
      );
      _drawTooltipPath(canvas, tooltipRect, rect, backgroundPath, isTop, isLeft,
          isRight, startX, endX, animationFactor, xPos, yPos);
      final TextStyle textStyle = _getTooltiptextStyle(
          tooltip.textStyle, false, false, animationFactor);
      final Size result = _measureText(stringValue, textStyle);
      _drawTooltipText(canvas, tooltipRect, textStyle, result, animationFactor);
      if (_chart is SfCartesianChart &&
          tooltip.canShowMarker &&
          chartTooltipState._needMarker) {
        _drawTooltipMarker(
            canvas, tooltipRect, textStyle, animationFactor, result);
      }
      xPos = null;
      yPos = null;
    }
  }

  /// draw the tooltip rect path
  void _drawTooltipPath(
      Canvas canvas,
      RRect tooltipRect,
      Rect rect,
      Path backgroundPath,
      bool isTop,
      bool isLeft,
      bool isRight,
      double startX,
      double endX,
      double animationFactor,
      double xPos,
      double yPos) {
    double factor = 0;
    assert(tooltip.elevation != null ? tooltip.elevation >= 0 : true,
        'The elevation of the tooltip for all series must not be less than 0.');
    if (isTop && isRight) {
      factor = rect.bottom;
      backgroundPath.moveTo(rect.right - 20, factor);
      backgroundPath.lineTo(xPos, yPos);
      backgroundPath.lineTo(rect.right, factor - borderRadius);
      backgroundPath.arcToPoint(Offset(rect.right - borderRadius, factor),
          radius: Radius.circular(borderRadius));
      backgroundPath.lineTo(rect.right - 20, factor);
    } else if (!isTop && isRight) {
      factor = rect.top;
      backgroundPath.moveTo(rect.right - 20, factor);
      backgroundPath.lineTo(xPos, yPos);
      backgroundPath.lineTo(rect.right, factor + borderRadius);
      backgroundPath.arcToPoint(Offset(rect.right - borderRadius, factor),
          radius: Radius.circular(borderRadius), clockwise: false);
      backgroundPath.lineTo(rect.right - 20, factor);
    } else if (isTop && isLeft) {
      factor = rect.bottom;
      backgroundPath.moveTo(rect.left + 20, factor);
      backgroundPath.lineTo(xPos, yPos);
      backgroundPath.lineTo(rect.left, factor - borderRadius);
      backgroundPath.arcToPoint(Offset(rect.left + borderRadius, factor),
          radius: Radius.circular(borderRadius), clockwise: false);
      backgroundPath.lineTo(rect.left + 20, factor);
    } else if (!isTop && isLeft) {
      factor = rect.top;
      backgroundPath.moveTo(rect.left + 20, factor);
      backgroundPath.lineTo(xPos, yPos);
      backgroundPath.lineTo(rect.left, factor + borderRadius);
      backgroundPath.arcToPoint(Offset(rect.left + borderRadius, factor),
          radius: Radius.circular(borderRadius));
      backgroundPath.lineTo(rect.left + 20, factor);
    } else {
      if (isTop) {
        factor = tooltipRect.bottom;
      } else {
        factor = tooltipRect.top;
      }
      backgroundPath.moveTo(startX - ((endX - startX) / 4), factor);
      backgroundPath.lineTo(xPos, yPos);
      backgroundPath.lineTo(endX + ((endX - startX) / 4), factor);
      backgroundPath.lineTo(startX + ((endX - startX) / 4), factor);
    }
    final Paint fillPaint = Paint()
      ..color = (tooltip.color ?? _chartState._chartTheme.tooltipColor)
          .withOpacity(tooltip.opacity)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    final Paint strokePaint = Paint()
      ..color = tooltip.borderColor == Colors.transparent
          ? Colors.transparent
          : tooltip.borderColor.withOpacity(tooltip.opacity)
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = tooltip.borderWidth;
    tooltip.borderWidth == 0
        ? strokePaint.color = Colors.transparent
        : strokePaint.color = strokePaint.color;

    final Path tooltipPath = Path();
    tooltipPath.addRRect(tooltipRect);
    if (tooltip.elevation > 0) {
      if (tooltipRect.width * animationFactor > tooltipRect.width * 0.85) {
        canvas.drawShadow(arrowPath, tooltip.shadowColor ?? fillPaint.color,
            tooltip.elevation, true);
      }
      canvas.drawShadow(tooltipPath, tooltip.shadowColor ?? fillPaint.color,
          tooltip.elevation, true);
    }

    if (tooltipRect.width * animationFactor > tooltipRect.width * 0.85) {
      canvas.drawPath(arrowPath, fillPaint);
      canvas.drawPath(arrowPath, strokePaint);
    }
    canvas.drawPath(tooltipPath, fillPaint);
    canvas.drawPath(tooltipPath, strokePaint);
  }

  /// draw marker inside the tooltip
  void _drawTooltipMarker(Canvas canvas, RRect tooltipRect, TextStyle textStyle,
      double animationFactor, Size tooltipMarkerResult) {
    final Size tooltipStringResult = tooltipMarkerResult;
    if (tooltip.shared) {
      Size result1 = const Size(0, 0);
      String str = '';
      for (int i = 0; i < textValues.length; i++) {
        str += textValues[i];
        final Size result = _measureText(str, textStyle);
        final Offset markerPoint = Offset(
            tooltipRect.left +
                tooltipRect.width / 2 -
                tooltipStringResult.width / 2,
            (markerPointY + result1.height) - markerSize);
        result1 = result;
        final CartesianSeriesRenderer _seriesRenderer =
            seriesRendererCollection[i];
        _renderMarker(markerPoint, _seriesRenderer, animationFactor, canvas);
      }
    } else {
      final Offset markerPoint = Offset(
          tooltipRect.left +
              tooltipRect.width / 2 -
              tooltipStringResult.width / 2,
          ((tooltipRect.top + tooltipRect.height) -
                  tooltipStringResult.height / 2) -
              markerSize);
      _renderMarker(markerPoint, seriesRenderer, animationFactor, canvas);
    }
  }

  /// To render marker for the chart tooltip
  void _renderMarker(
      Offset markerPoint,
      CartesianSeriesRenderer _seriesRenderer,
      double animationFactor,
      Canvas canvas) {
    _seriesRenderer._isMarkerRenderEvent = true;
    final Path markerPath = _getMarkerShapesPath(
        _seriesRenderer._series.markerSettings.shape,
        markerPoint,
        Size((2 * markerSize) * animationFactor,
            (2 * markerSize) * animationFactor),
        _seriesRenderer);

    if (_seriesRenderer._series.markerSettings.shape == DataMarkerType.image) {
      _drawImageMarker(_seriesRenderer, canvas, markerPoint.dx, markerPoint.dy);
    }

    Paint markerPaint = Paint();
    markerPaint.color = (!tooltip.shared
            ? markerColor
            : _seriesRenderer._series.markerSettings.borderColor ??
                _seriesRenderer._seriesColor ??
                _seriesRenderer._series.color)
        .withOpacity(tooltip.opacity);
    if (_seriesRenderer._series.gradient != null) {
      markerPaint = _getLinearGradientPaint(
          _seriesRenderer._series.gradient,
          _getMarkerShapesPath(
                  _seriesRenderer._series.markerSettings.shape,
                  Offset(markerPoint.dx, markerPoint.dy),
                  Size((2 * markerSize) * animationFactor,
                      (2 * markerSize) * animationFactor),
                  _seriesRenderer)
              .getBounds(),
          _seriesRenderer._chartState._requireInvertedAxis);
    }
    canvas.drawPath(markerPath, markerPaint);
    final Paint markerBorderPaint = Paint();
    markerBorderPaint.color = Colors.white.withOpacity(tooltip.opacity);
    markerBorderPaint.strokeWidth = 1;
    markerBorderPaint.style = PaintingStyle.stroke;
    canvas.drawPath(markerPath, markerBorderPaint);
  }

  /// draw tooltip header, divider,text
  void _drawTooltipText(Canvas canvas, RRect tooltipRect, TextStyle textStyle,
      Size result, double animationFactor) {
    const double padding = 10;
    final num _maxLinesOfTooltipContent = _getMaxLinesContent(stringValue);
    if (header != null && header.isNotEmpty) {
      final TextStyle headerTextStyle =
          _getTooltiptextStyle(tooltip.textStyle, true, false, animationFactor);
      final Size headerResult = _measureText(header, headerTextStyle);
      final num _maxLinesOfHeader = _getMaxLinesContent(header);
      _drawText(
          tooltip,
          canvas,
          header,
          Offset(
              (tooltipRect.left + tooltipRect.width / 2) -
                  headerResult.width / 2,
              tooltipRect.top + padding / 2),
          headerTextStyle,
          _maxLinesOfHeader);

      final Paint dividerPaint = Paint();
      dividerPaint.color = _chartState._chartTheme.tooltipLabelColor
          .withOpacity(tooltip.opacity);
      dividerPaint.strokeWidth = 0.5 * animationFactor;
      dividerPaint.style = PaintingStyle.stroke;
      num lineOffset = 0;
      if (tooltip != null &&
          tooltip.format != null &&
          tooltip.format.isNotEmpty) {
        if (tooltip.textAlignment == ChartAlignment.near) {
          lineOffset = padding;
        } else if (tooltip.textAlignment == ChartAlignment.far) {
          lineOffset = -padding;
        }
      }
      if (animationFactor > 0.5) {
        canvas.drawLine(
            Offset(tooltipRect.left + padding - lineOffset,
                tooltipRect.top + headerResult.height + padding),
            Offset(tooltipRect.right - padding - lineOffset,
                tooltipRect.top + headerResult.height + padding),
            dividerPaint);
      }
      markerPointY = tooltipRect.top + headerResult.height + (padding * 2) + 6;
      _drawText(
          tooltip,
          canvas,
          stringValue,
          Offset(
              (tooltipRect.left + 2 * markerSize + tooltipRect.width / 2) -
                  result.width / 2,
              (tooltipRect.top + tooltipRect.height) - result.height - 5),
          textStyle,
          _maxLinesOfTooltipContent);
    } else {
      _drawText(
          tooltip,
          canvas,
          stringValue,
          Offset(
              (tooltipRect.left + 2 * markerSize + tooltipRect.width / 2) -
                  result.width / 2,
              (tooltipRect.top + tooltipRect.height / 2) - result.height / 2),
          textStyle,
          _maxLinesOfTooltipContent);
    }
  }

  /// Get the text style of tooltip.
  TextStyle _getTooltiptextStyle(
      TextStyle textStyle, bool isHeader, bool isMeasureText,
      [double animationFactor]) {
    /// Default size of tooltip text, if the user is not spcified the font size.
    const int textSize = 12;
    final TextStyle tooltipTextStyle = TextStyle(
        color: textStyle.color?.withOpacity(tooltip.opacity) ??
            _chartState._chartTheme.tooltipLabelColor,
        fontSize: isMeasureText
            ? textStyle.fontSize
            : (textStyle.fontSize ?? textSize) * animationFactor,
        fontWeight: isHeader ? FontWeight.bold : textStyle.fontWeight,
        fontFamily: textStyle.fontFamily,
        fontStyle: textStyle.fontStyle,
        inherit: textStyle.inherit,
        backgroundColor: textStyle.backgroundColor,
        letterSpacing: textStyle.letterSpacing,
        wordSpacing: textStyle.wordSpacing,
        textBaseline: textStyle.textBaseline,
        height: textStyle.height,
        locale: textStyle.locale,
        foreground: textStyle.foreground,
        background: textStyle.background,
        shadows: textStyle.shadows,
        fontFeatures: textStyle.fontFeatures,
        decoration: textStyle.decoration,
        decorationColor: textStyle.decorationColor,
        decorationStyle: textStyle.decorationStyle,
        decorationThickness: textStyle.decorationThickness,
        debugLabel: textStyle.debugLabel,
        fontFamilyFallback: textStyle.fontFamilyFallback);
    return tooltipTextStyle;
  }

  ///draw tooltip text
  void _drawText(dynamic tooltip, Canvas canvas, String text, Offset point,
      TextStyle style,
      [int maxLines, int rotation]) {
    TextAlign tooltipTextAlign = TextAlign.start;
    num pointX = point.dx;
    if (tooltip != null &&
        tooltip.format != null &&
        tooltip.format.isNotEmpty) {
      if (tooltip.textAlignment == ChartAlignment.near) {
        tooltipTextAlign = TextAlign.start;
        pointX =
            _chartState._tooltipBehaviorRenderer._painter._tooltipRect.left;
      } else if (tooltip.textAlignment == ChartAlignment.far) {
        tooltipTextAlign = TextAlign.end;
        pointX =
            _chartState._tooltipBehaviorRenderer._painter._tooltipRect.right -
                _measureText(text, style).width;
      }
    }

    final TextSpan span = TextSpan(text: text, style: style);

    final TextPainter tp = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
        textAlign: tooltipTextAlign,
        maxLines: maxLines ?? 1);
    tp.layout();
    canvas.save();
    canvas.translate(pointX, point.dy);
    if (rotation != null && rotation > 0) {
      canvas.rotate(_degreeToRadian(rotation));
    }
    tp.paint(canvas, const Offset(0.0, 0.0));
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  /// To show the chart tooltip
  void show(double x, double y) {
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        _chartState._tooltipBehaviorRenderer;
    if (tooltip.enable &&
        tooltipBehaviorRenderer._painter != null &&
        tooltipBehaviorRenderer._painter._chartState._animateCompleted) {
      tooltipBehaviorRenderer._painter.canResetPath = false;
      tooltipBehaviorRenderer._painter._renderTooltipView(Offset(x, y));
      final bool needAnimate = !(_chart is SfCartesianChart) &&
          (tooltipBehaviorRenderer._painter.currentTooltipValue?.pointIndex ==
              tooltipBehaviorRenderer._painter.prevTooltipValue?.pointIndex) &&
          _chartState._chartSeries.currentSeries.explode &&
          !(tooltip.tooltipPosition == TooltipPosition.pointer);
      chartTooltipState.animationController.duration = Duration(
          milliseconds:
              tooltipBehaviorRenderer._tooltipBehavior.animationDuration);
      if ((tooltipBehaviorRenderer._painter.prevTooltipValue != null &&
              tooltipBehaviorRenderer._painter.currentTooltipValue == null) ||
          needAnimate) {
        chartTooltipState.animationController.forward(from: 0.0);
        tooltipBehaviorRenderer._painter.currentTooltipValue =
            tooltipBehaviorRenderer._painter.prevTooltipValue;
      } else {
        if (tooltip.tooltipPosition == TooltipPosition.pointer &&
            (!(_chart is SfCartesianChart) || currentSeries._isRectSeries)) {
          chartTooltipState.animationController.forward(from: 0.0);
          tooltipBehaviorRenderer._painter.currentTooltipValue =
              tooltipBehaviorRenderer._painter.prevTooltipValue;
        }
      }
      if (tooltipBehaviorRenderer._painter.timer != null) {
        tooltipBehaviorRenderer._painter.timer.cancel();
      }
      assert(tooltip.duration != null ? tooltip.duration >= 0 : true,
          'The duration time for the tooltip must not be less than 0.');
      if (!tooltip.shouldAlwaysShow) {
        tooltipBehaviorRenderer._painter.timer =
            Timer(Duration(milliseconds: tooltip.duration.toInt()), () {
          chartTooltipState.show = false;
          tooltipBehaviorRenderer._painter.currentTooltipValue =
              tooltipBehaviorRenderer._painter.prevTooltipValue = null;
          chartTooltipState.tooltipRepaintNotifier.value++;
          tooltipBehaviorRenderer._painter.canResetPath = true;
        });
      }
    }
  }

  /// This method shows the tooltip for any logical pixel outside point region
  //ignore: unused_element
  void _showChartAreaTooltip(Offset position, ChartAxisRenderer xAxisRenderer,
      ChartAxisRenderer yAxisRenderer, dynamic chart) {
    final ChartAxis xAxis = xAxisRenderer._axis, yAxis = yAxisRenderer._axis;
    if (tooltip.enable &&
        _chartState._tooltipBehaviorRenderer._painter != null &&
        _chartState
            ._tooltipBehaviorRenderer._painter._chartState._animateCompleted) {
      chartTooltipState.animationController.duration = Duration(
          milliseconds: _chartState
              ._tooltipBehaviorRenderer._tooltipBehavior.animationDuration);
      chartTooltipState.animationController.forward(from: 0.0);
      _chartState._tooltipBehaviorRenderer._painter.canResetPath = false;
      //render
      _chartState._tooltipBehaviorRenderer._painter.boundaryRect =
          _chartState._chartAxis._axisClipRect;
      if (_chartState._chartAxis._axisClipRect.contains(position)) {
        _chartState._tooltipBehaviorRenderer._painter.currentSeries =
            _chartState._chartSeries.visibleSeriesRenderers[0];
        _chartState._tooltipBehaviorRenderer._painter.currentSeries =
            _chartState._chartSeries.visibleSeriesRenderers[0];
        _chartState._tooltipBehaviorRenderer._painter.padding = 5;
        _chartState._tooltipBehaviorRenderer._painter.header = null;
        dynamic xValue = _pointToXValue(
            _chartState._requireInvertedAxis,
            xAxisRenderer,
            xAxisRenderer._bounds,
            position.dx -
                (_chartState._chartAxis._axisClipRect.left + xAxis.plotOffset),
            position.dy -
                (_chartState._chartAxis._axisClipRect.top + xAxis.plotOffset));
        dynamic yValue = _pointToYValue(
            _chartState._requireInvertedAxis,
            yAxisRenderer,
            yAxisRenderer._bounds,
            position.dx -
                (_chartState._chartAxis._axisClipRect.left + yAxis.plotOffset),
            position.dy -
                (_chartState._chartAxis._axisClipRect.top + yAxis.plotOffset));
        if (xAxisRenderer is DateTimeAxisRenderer) {
          final DateTimeAxis xAxis = xAxisRenderer._axis;
          xValue =
              (xAxis.dateFormat ?? xAxisRenderer._getLabelFormat(xAxisRenderer))
                  .format(DateTime.fromMillisecondsSinceEpoch(xValue.floor()));
        } else if (xAxisRenderer is CategoryAxisRenderer) {
          xValue = xAxisRenderer._visibleLabels[xValue.toInt()].text;
        } else if (xAxisRenderer is NumericAxisRenderer) {
          xValue = xValue.toStringAsFixed(2).contains('.00')
              ? xValue.floor()
              : xValue.toStringAsFixed(2);
        }

        if (yAxisRenderer is DateTimeAxisRenderer) {
          final DateTimeAxis yAxis = yAxisRenderer._axis;
          yValue =
              (yAxis.dateFormat ?? yAxisRenderer._getLabelFormat(yAxisRenderer))
                  .format(DateTime.fromMillisecondsSinceEpoch(yValue.floor()));
        } else if (yAxisRenderer is NumericAxisRenderer) {
          yValue = yValue.toStringAsFixed(2).contains('.00')
              ? yValue.floor()
              : yValue.toStringAsFixed(2);
        }
        _chartState._tooltipBehaviorRenderer._painter.stringValue =
            ' $xValue :  $yValue ';
        _chartState._tooltipBehaviorRenderer._painter
            ._calculateLocation(position);
      }
      if (_chartState._tooltipBehaviorRenderer._painter.timer != null) {
        _chartState._tooltipBehaviorRenderer._painter.timer.cancel();
      }
      if (!tooltip.shouldAlwaysShow) {
        _chartState._tooltipBehaviorRenderer._painter.timer =
            Timer(Duration(milliseconds: tooltip.duration.toInt()), () {
          chartTooltipState.show = false;
          chartTooltipState.tooltipRepaintNotifier.value++;
          _chartState._tooltipBehaviorRenderer._painter.canResetPath = true;
        });
      }
    }
  }

  /// To show the axis label tooltip for trimmed axes label texts.
  void _showAxisTooltip(Offset position, dynamic chart, String text) {
    final _TooltipPainter painter =
        _chartState._tooltipBehaviorRenderer._painter;
    if (painter != null) {
      painter.canResetPath = false;
      painter.header = '';
      painter.stringValue = text;
      painter._calculateLocation(position);
      chartTooltipState._needMarker = false;
      if ((painter.prevTooltipValue != null) &&
          (painter.prevTooltipValue.pointIndex ==
              painter.currentTooltipValue.pointIndex)) {
        chartTooltipState.animationController.duration =
            Duration(milliseconds: 0);
        chartTooltipState.animationController.forward(from: 0.0);
      } else {
        chartTooltipState.animationController.duration = Duration(
            milliseconds: _chartState
                ._tooltipBehaviorRenderer._tooltipBehavior.animationDuration);
        chartTooltipState.animationController.forward(from: 0.0);
      }

      if (painter.timer != null) {
        painter.timer.cancel();
      }
    }
    painter.timer = Timer(Duration(milliseconds: tooltip.duration.toInt()), () {
      chartTooltipState.show = false;
      chartTooltipState.tooltipRepaintNotifier.value++;
      painter.canResetPath = true;
    });
  }

  /// To hide the tooltip when the timer ends
  void hide() {
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        _chartState._tooltipBehaviorRenderer;
    if (tooltipBehaviorRenderer._painter.timer != null) {
      tooltipBehaviorRenderer._painter.timer.cancel();
    }

    tooltipBehaviorRenderer._painter.timer =
        Timer(Duration(milliseconds: tooltip.duration.toInt()), () {
      chartTooltipState.show = false;
      tooltipBehaviorRenderer._painter.currentTooltipValue =
          tooltipBehaviorRenderer._painter.prevTooltipValue = null;
      chartTooltipState.tooltipRepaintNotifier.value++;
      tooltipBehaviorRenderer._painter.canResetPath = true;
    });
  }

  /// To show tooltip on mouse pointer actions
  void showMouseTooltip(double x, double y) {
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        _chartState._tooltipBehaviorRenderer;
    if (tooltip.enable &&
        tooltipBehaviorRenderer._painter != null &&
        tooltipBehaviorRenderer._painter._chartState._animateCompleted) {
      tooltipBehaviorRenderer._painter.canResetPath = false;
      tooltipBehaviorRenderer._painter._renderTooltipView(Offset(x, y));
      if (tooltipBehaviorRenderer._painter.timer != null) {
        tooltipBehaviorRenderer._painter.timer.cancel();
      }
      if (tooltipBehaviorRenderer._painter.prevTooltipValue != null &&
          tooltipBehaviorRenderer._painter.currentTooltipValue == null) {
        chartTooltipState.animationController.duration = Duration(
            milliseconds:
                tooltipBehaviorRenderer._tooltipBehavior.animationDuration);
        chartTooltipState.animationController.forward(from: 0.0);
        tooltipBehaviorRenderer._painter.currentTooltipValue =
            tooltipBehaviorRenderer._painter.prevTooltipValue;
      } else if (tooltipBehaviorRenderer._painter.prevTooltipValue != null &&
          tooltipBehaviorRenderer._painter.currentTooltipValue != null &&
          tooltipBehaviorRenderer._tooltipBehavior.tooltipPosition !=
              TooltipPosition.auto &&
          (!(seriesRenderer is CartesianSeriesRenderer) ||
              seriesRenderer._isRectSeries) &&
          tooltipBehaviorRenderer._painter.currentTooltipValue.seriesIndex ==
              tooltipBehaviorRenderer._painter.prevTooltipValue.seriesIndex &&
          tooltipBehaviorRenderer._painter.currentTooltipValue.pointIndex ==
              tooltipBehaviorRenderer._painter.prevTooltipValue.pointIndex) {
        chartTooltipState.animationController.duration = Duration(seconds: 0);
        chartTooltipState.animationController.forward(from: 0.0);
      }
      if (!mouseTooltip) {
        hide();
      }
    }
  }
}
