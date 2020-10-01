part of charts;

class _TrackballPainter extends CustomPainter {
  _TrackballPainter({this.chartState, this.valueNotifier})
      : chart = chartState._chart,
        super(repaint: valueNotifier);
  final SfCartesianChartState chartState;
  final SfCartesianChart chart;
  Timer timer;
  ValueNotifier<int> valueNotifier;
  double pointerLength;
  double pointerWidth;
  double nosePointY = 0;
  double nosePointX = 0;
  double totalWidth = 0;
  double x;
  double y;
  double xPos;
  double yPos;
  bool isTop = false;
  double borderRadius;
  Path backgroundPath = Path();
  bool canResetPath = false;
  bool isLeft = false;
  bool isRight = false;
  bool enable;
  double groupAllPadding = 10;
  List<String> stringValue = <String>[];
  Rect boundaryRect = const Rect.fromLTWH(0, 0, 0, 0);
  double leftPadding = 0;
  double topPadding = 0;
  bool isHorizontalOrientation = false;
  bool isRectSeries = false;
  TextStyle labelStyle;
  List<_ChartPointInfo> chartPointInfo = <_ChartPointInfo>[];
  bool divider = true;
  final List<Path> _markerShapes = <Path>[];
  List<num> _tooltipTop = <num>[];
  List<num> _tooltipBottom = <num>[];
  List<num> _visibleLocation = <num>[];
  final List<ChartAxisRenderer> _xAxesInfo = <ChartAxisRenderer>[];
  final List<ChartAxisRenderer> _yAxesInfo = <ChartAxisRenderer>[];
  List<_ClosestPoints> _visiblePoints = <_ClosestPoints>[];
  _TooltipPositions _tooltipPosition;
  num _padding = 5;
  final num _tooltipPadding = 5;
  bool _isTrackLineDrawn = false;

  @override
  void paint(Canvas canvas, Size size) =>
      chartState._trackballBehaviorRenderer.onPaint(canvas);

  Paint _getLinePainter(Paint trackballLinePaint) => trackballLinePaint;

  /// To draw the trackball for all series
  void _drawTrackball(Canvas canvas) {
    borderRadius = chart.trackballBehavior.tooltipSettings.borderRadius;
    pointerLength = chart.trackballBehavior.tooltipSettings.arrowLength;
    pointerWidth = chart.trackballBehavior.tooltipSettings.arrowWidth;
    isLeft = false;
    isRight = false;
    double height = 0, width = 0;
    boundaryRect = chartState._chartAxis._axisClipRect;
    totalWidth = boundaryRect.left + boundaryRect.width;
    labelStyle = TextStyle(
        color: chart.trackballBehavior.tooltipSettings.textStyle.color ??
            chartState._chartTheme.crosshairLabelColor,
        fontSize: chart.trackballBehavior.tooltipSettings.textStyle.fontSize,
        fontFamily:
            chart.trackballBehavior.tooltipSettings.textStyle.fontFamily,
        fontStyle: chart.trackballBehavior.tooltipSettings.textStyle.fontStyle,
        fontWeight:
            chart.trackballBehavior.tooltipSettings.textStyle.fontWeight,
        inherit: chart.trackballBehavior.tooltipSettings.textStyle.inherit,
        backgroundColor:
            chart.trackballBehavior.tooltipSettings.textStyle.backgroundColor,
        letterSpacing:
            chart.trackballBehavior.tooltipSettings.textStyle.letterSpacing,
        wordSpacing:
            chart.trackballBehavior.tooltipSettings.textStyle.wordSpacing,
        textBaseline:
            chart.trackballBehavior.tooltipSettings.textStyle.textBaseline,
        height: chart.trackballBehavior.tooltipSettings.textStyle.height,
        locale: chart.trackballBehavior.tooltipSettings.textStyle.locale,
        foreground:
            chart.trackballBehavior.tooltipSettings.textStyle.foreground,
        background:
            chart.trackballBehavior.tooltipSettings.textStyle.background,
        shadows: chart.trackballBehavior.tooltipSettings.textStyle.shadows,
        fontFeatures:
            chart.trackballBehavior.tooltipSettings.textStyle.fontFeatures,
        decoration:
            chart.trackballBehavior.tooltipSettings.textStyle.decoration,
        decorationColor:
            chart.trackballBehavior.tooltipSettings.textStyle.decorationColor,
        decorationStyle:
            chart.trackballBehavior.tooltipSettings.textStyle.decorationStyle,
        decorationThickness: chart
            .trackballBehavior.tooltipSettings.textStyle.decorationThickness,
        debugLabel:
            chart.trackballBehavior.tooltipSettings.textStyle.debugLabel,
        fontFamilyFallback: chart
            .trackballBehavior.tooltipSettings.textStyle.fontFamilyFallback);
    for (int index = 0; index < chartPointInfo.length; index++) {
      if (((chartPointInfo[index]
                      .seriesRenderer
                      ._seriesType
                      .contains('column') ||
                  chartPointInfo[index].seriesRenderer._seriesType ==
                      'candle' ||
                  chartPointInfo[index]
                      .seriesRenderer
                      ._seriesType
                      .contains('boxandwhisker') ||
                  chartPointInfo[index]
                      .seriesRenderer
                      ._seriesType
                      .contains('hilo')) &&
              !chart.isTransposed) ||
          (chartPointInfo[index].seriesRenderer._seriesType.contains('bar') &&
              chart.isTransposed)) {
        isHorizontalOrientation = true;
      }
      isRectSeries = false;
      if ((chartPointInfo[index]
                  .seriesRenderer
                  ._seriesType
                  .contains('column') ||
              chartPointInfo[index].seriesRenderer._seriesType == 'candle' ||
              chartPointInfo[index]
                  .seriesRenderer
                  ._seriesType
                  .contains('hilo') ||
              chartPointInfo[index]
                      .seriesRenderer
                      ._seriesType
                      .contains('boxandwhisker') &&
                  chart.isTransposed) ||
          (chartPointInfo[index].seriesRenderer._seriesType.contains('bar') &&
              !chart.isTransposed)) {
        isRectSeries = true;
      }
      if (!canResetPath &&
          chart.trackballBehavior.lineType != TrackballLineType.none) {
        final Paint trackballLinePaint = Paint();
        trackballLinePaint.color = chart.trackballBehavior.lineColor ??
            chartState._chartTheme.crosshairLineColor;
        trackballLinePaint.strokeWidth = chart.trackballBehavior.lineWidth;
        trackballLinePaint.style = PaintingStyle.stroke;
        chart.trackballBehavior.lineWidth == 0
            ? trackballLinePaint.color = Colors.transparent
            : trackballLinePaint.color = trackballLinePaint.color;
        chartState._trackballBehaviorRenderer._drawLine(
            canvas,
            chartState._trackballBehaviorRenderer
                ._linePainter(trackballLinePaint),
            index);
      }
      final Size size = _getTooltipSize(height, width, index);
      height = size.height;
      width = size.width;
      if (width < 10) {
        width = 10; // minimum width for tooltip to render
        borderRadius = borderRadius > 5 ? 5 : borderRadius;
      }
      borderRadius = borderRadius > 15 ? 15 : borderRadius;
      // Padding added for avoid tooltip and the data point are too close and
      // extra padding based on trackball marker and width
      _padding = (chart.trackballBehavior.markerSettings != null &&
                  chart.trackballBehavior.markerSettings.markerVisibility ==
                      TrackballVisibilityMode.auto
              ? (chartPointInfo[index]
                  .seriesRenderer
                  ._series
                  .markerSettings
                  .isVisible)
              : chart.trackballBehavior.markerSettings != null &&
                  chart.trackballBehavior.markerSettings.markerVisibility ==
                      TrackballVisibilityMode.visible)
          ? (chart.trackballBehavior.markerSettings.width / 2) + 5
          : _padding;
      if (x != null &&
          y != null &&
          chart.trackballBehavior.tooltipSettings.enable) {
        if (chart.trackballBehavior.tooltipDisplayMode ==
                TrackballDisplayMode.groupAllPoints &&
            ((chartPointInfo[index].header != null &&
                    chartPointInfo[index].header != '') ||
                (chartPointInfo[index].label != null &&
                    chartPointInfo[index].label != ''))) {
          _calculateTrackballRect(canvas, width, height, index);
        } else {
          if (!canResetPath &&
              chartPointInfo[index].label != null &&
              chartPointInfo[index].label != '') {
            _tooltipTop.add(chartState._requireInvertedAxis
                ? _visiblePoints[index].closestPointX -
                    _tooltipPadding -
                    width / 2
                : _visiblePoints[index].closestPointY -
                    _tooltipPadding -
                    height / 2);
            _tooltipBottom.add(chartState._requireInvertedAxis
                ? _visiblePoints[index].closestPointX +
                    _tooltipPadding +
                    width / 2
                : _visiblePoints[index].closestPointY +
                    _tooltipPadding +
                    height / 2);
            _xAxesInfo.add(chartPointInfo[index].seriesRenderer._xAxisRenderer);
            _yAxesInfo.add(chartPointInfo[index].seriesRenderer._yAxisRenderer);
          }
        }
      }

      if (chart.trackballBehavior.tooltipDisplayMode ==
          TrackballDisplayMode.groupAllPoints) {
        break;
      }
    }

    if (_tooltipTop != null && _tooltipTop.isNotEmpty) {
      _tooltipPosition = _smartTooltipPositions(
          _tooltipTop,
          _tooltipBottom,
          _xAxesInfo,
          _yAxesInfo,
          chartPointInfo,
          chartState._requireInvertedAxis);
    }

    for (int index = 0; index < chartPointInfo.length; index++) {
      if (chart.trackballBehavior.markerSettings != null &&
          (chart.trackballBehavior.markerSettings.markerVisibility ==
                  TrackballVisibilityMode.auto
              ? (chartPointInfo[index]
                  .seriesRenderer
                  ._series
                  .markerSettings
                  .isVisible)
              : chart.trackballBehavior.markerSettings.markerVisibility ==
                  TrackballVisibilityMode.visible)) {
        final MarkerSettings markerSettings =
            chart.trackballBehavior.markerSettings;

        final DataMarkerType markerType = markerSettings.shape;
        final Size size = Size(markerSettings.width, markerSettings.height);
        chartPointInfo[index].seriesRenderer._isMarkerRenderEvent = true;
        _markerShapes.add(_getMarkerShapesPath(
            markerType,
            Offset(
                chartPointInfo[index].xPosition,
                chartPointInfo[index]
                            .seriesRenderer
                            ._seriesType
                            .contains('range') ||
                        chartPointInfo[index]
                            .seriesRenderer
                            ._seriesType
                            .contains('hilo') ||
                        chartPointInfo[index].seriesRenderer._seriesType ==
                            'candle'
                    ? chartPointInfo[index].highYPosition
                    : chartPointInfo[index].seriesRenderer._seriesType ==
                            'boxandwhisker'
                        ? chartPointInfo[index].maxYPosition
                        : chartPointInfo[index].yPosition),
            size,
            chartPointInfo[index].seriesRenderer,
            null,
            chart.trackballBehavior));
      }

      if (_markerShapes != null &&
          _markerShapes.isNotEmpty &&
          _markerShapes.length > index) {
        _renderTrackballMarker(chartPointInfo[index].seriesRenderer, canvas,
            chart.trackballBehavior, index);
      }

      final Size size = _getTooltipSize(height, width, index);
      height = size.height;
      width = size.width;
      if (width < 10) {
        width = 10; // minimum width for tooltip to render
        borderRadius = borderRadius > 5 ? 5 : borderRadius;
      }
      // Padding added for avoid tooltip and the data point are too close and
      // extra padding based on trackball marker and width
      _padding = (chart.trackballBehavior.markerSettings != null &&
                  chart.trackballBehavior.markerSettings.markerVisibility ==
                      TrackballVisibilityMode.auto
              ? (chartPointInfo[index]
                  .seriesRenderer
                  ._series
                  .markerSettings
                  .isVisible)
              : chart.trackballBehavior.markerSettings != null &&
                  chart.trackballBehavior.markerSettings.markerVisibility ==
                      TrackballVisibilityMode.visible)
          ? (chart.trackballBehavior.markerSettings.width / 2) + 5
          : _padding;
      if (chart.trackballBehavior.tooltipDisplayMode !=
              TrackballDisplayMode.groupAllPoints &&
          chartPointInfo[index].label != null &&
          chartPointInfo[index].label != '') {
        _calculateTrackballRect(
            canvas, width, height, index, chartPointInfo, _tooltipPosition);
        if (index == chartPointInfo.length - 1) {
          _tooltipTop.clear();
          _tooltipBottom.clear();
          _tooltipPosition.tooltipTop.clear();
          _tooltipPosition.tooltipBottom.clear();
          _xAxesInfo.clear();
          _yAxesInfo.clear();
        }
      }
    }
  }

  // Method to place the collided tooltips properly
  _TooltipPositions _smartTooltipPositions(
      List<num> tooltipTop,
      List<num> tooltipBottom,
      List<ChartAxisRenderer> _xAxesInfo,
      List<ChartAxisRenderer> _yAxesInfo,
      List<_ChartPointInfo> chartPointInfo,
      bool requireInvertedAxis) {
    num tooltipWidth = 0;
    _TooltipPositions tooltipPosition;
    for (int i = 0; i < chartPointInfo.length; i++) {
      if (requireInvertedAxis) {
        _visibleLocation.add(chartPointInfo[i].xPosition);
      } else {
        _visibleLocation.add((chartPointInfo[i]
                    .seriesRenderer
                    ._seriesType
                    .contains('range') ||
                chartPointInfo[i].seriesRenderer._seriesType.contains('hilo') ||
                chartPointInfo[i].seriesRenderer._seriesType == 'candle')
            ? chartPointInfo[i].highYPosition
            : chartPointInfo[i].seriesRenderer._seriesType == 'boxandwhisker'
                ? chartPointInfo[i].maxYPosition
                : chartPointInfo[i].yPosition);
      }

      tooltipWidth += tooltipBottom[i] - tooltipTop[i] + _tooltipPadding;
    }
    tooltipPosition = _continuousOverlappingPoints(
        tooltipTop, tooltipBottom, _visibleLocation);

    if (tooltipWidth <
        (chartState._chartAxis._axisClipRect.bottom -
            chartState._chartAxis._axisClipRect.top)) {
      tooltipPosition =
          _verticalArrangements(tooltipPosition, _xAxesInfo, _yAxesInfo);
    }

    return tooltipPosition;
  }

  _TooltipPositions _verticalArrangements(_TooltipPositions tooltipPPosition,
      List<ChartAxisRenderer> _xAxesInfo, List<ChartAxisRenderer> _yAxesInfo) {
    final _TooltipPositions tooltipPosition = tooltipPPosition;
    num chartHeight, startPos;
    final bool isTransposed = chartState._requireInvertedAxis;
    dynamic secWidth, width;
    final num length = tooltipPosition.tooltipTop.length;
    ChartAxisRenderer yAxisRenderer;
    final Rect axisClipRect = chartState._chartAxis._axisClipRect;
    final num axesLength =
        chartState._chartAxis._axisRenderersCollection.length;
    for (int i = length - 1; i >= 0; i--) {
      yAxisRenderer = _yAxesInfo[i];
      for (int k = 0; k < axesLength; k++) {
        if (yAxisRenderer ==
            chartState._chartAxis._axisRenderersCollection[k]) {
          if (isTransposed) {
            chartHeight = axisClipRect.right;
            startPos = axisClipRect.left;
          } else {
            chartHeight = axisClipRect.bottom - axisClipRect.top;
            startPos = axisClipRect.top;
          }
        }
      }
      width = tooltipPosition.tooltipBottom[i] - tooltipPosition.tooltipTop[i];
      if (chartHeight < tooltipPosition.tooltipBottom[i]) {
        tooltipPosition.tooltipBottom[i] = chartHeight - 2;
        tooltipPosition.tooltipTop[i] =
            tooltipPosition.tooltipBottom[i] - width;
        for (int j = i - 1; j >= 0; j--) {
          secWidth =
              tooltipPosition.tooltipBottom[j] - tooltipPosition.tooltipTop[j];
          if (tooltipPosition.tooltipBottom[j] >
                  tooltipPosition.tooltipTop[j + 1] &&
              (tooltipPosition.tooltipTop[j + 1] > startPos &&
                  tooltipPosition.tooltipBottom[j + 1] < chartHeight)) {
            tooltipPosition.tooltipBottom[j] =
                tooltipPosition.tooltipTop[j + 1] - _tooltipPadding;
            tooltipPosition.tooltipTop[j] =
                tooltipPosition.tooltipBottom[j] - secWidth;
          }
        }
      }
    }

    for (int i = 0; i < length; i++) {
      yAxisRenderer = _yAxesInfo[i];
      for (int k = 0; k < axesLength; k++) {
        if (yAxisRenderer ==
            chartState._chartAxis._axisRenderersCollection[k]) {
          if (isTransposed) {
            chartHeight = axisClipRect.right;
            startPos = axisClipRect.left;
          } else {
            chartHeight = axisClipRect.bottom - axisClipRect.top;
            startPos = axisClipRect.top;
          }
        }
      }
      width = tooltipPosition.tooltipBottom[i] - tooltipPosition.tooltipTop[i];
      if (tooltipPosition.tooltipTop[i] < startPos) {
        tooltipPosition.tooltipTop[i] = startPos + 1;
        tooltipPosition.tooltipBottom[i] =
            tooltipPosition.tooltipTop[i] + width;
        for (int j = i + 1; j <= (length - 1); j++) {
          secWidth =
              tooltipPosition.tooltipBottom[j] - tooltipPosition.tooltipTop[j];
          if (tooltipPosition.tooltipTop[j] <
                  tooltipPosition.tooltipBottom[j - 1] &&
              (tooltipPosition.tooltipTop[j - 1] > startPos &&
                  tooltipPosition.tooltipBottom[j - 1] < chartHeight)) {
            tooltipPosition.tooltipTop[j] =
                tooltipPosition.tooltipBottom[j - 1] + _tooltipPadding;
            tooltipPosition.tooltipBottom[j] =
                tooltipPosition.tooltipTop[j] + secWidth;
          }
        }
      }
    }
    return tooltipPosition;
  }

  // Method to identify the colliding trackball tooltips and return the new tooltip positions
  _TooltipPositions _continuousOverlappingPoints(List<num> tooltipTop,
      List<num> tooltipBottom, List<num> visibleLocation) {
    num temp,
        count = 0,
        start = 0,
        startPoint = 0,
        halfHeight,
        midPos,
        tempTooltipHeight,
        temp1TooltipHeight;
    int i, j, k;
    final num endPoint = tooltipBottom.length - 1;
    num tooltipHeight = (tooltipBottom[0] - tooltipTop[0]) + _tooltipPadding;
    temp = tooltipTop[0] + tooltipHeight;
    start = tooltipTop[0];
    for (i = 0; i < endPoint; i++) {
      // To identify that tooltip collides or not
      if (temp >= tooltipTop[i + 1]) {
        tooltipHeight =
            tooltipBottom[i + 1] - tooltipTop[i + 1] + _tooltipPadding;
        temp += tooltipHeight;
        count++;

        // This condition executes when the tooltip count is half of the total number of tooltips
        if (count - 1 == endPoint - 1 || i == endPoint - 1) {
          halfHeight = (temp - start) / 2;
          midPos = (visibleLocation[startPoint] + visibleLocation[i + 1]) / 2;
          tempTooltipHeight =
              tooltipBottom[startPoint] - tooltipTop[startPoint];
          tooltipTop[startPoint] = midPos - halfHeight;
          tooltipBottom[startPoint] =
              tooltipTop[startPoint] + tempTooltipHeight;
          for (k = startPoint; k > 0; k--) {
            if (tooltipTop[k] <= tooltipBottom[k - 1] + _tooltipPadding) {
              temp1TooltipHeight = tooltipBottom[k - 1] - tooltipTop[k - 1];
              tooltipTop[k - 1] =
                  tooltipTop[k] - temp1TooltipHeight - _tooltipPadding;
              tooltipBottom[k - 1] = tooltipTop[k - 1] + temp1TooltipHeight;
            } else {
              break;
            }
          }

          // To set tool tip positions based on the half height and other tooltip height
          for (j = startPoint + 1; j <= startPoint + count; j++) {
            tempTooltipHeight = tooltipBottom[j] - tooltipTop[j];
            tooltipTop[j] = tooltipBottom[j - 1] + _tooltipPadding;
            tooltipBottom[j] = tooltipTop[j] + tempTooltipHeight;
          }
        }
      } else {
        count = i > 0 ? count : 0;

        // This exectutes when any of the middle tooltip collides
        if (count > 0) {
          halfHeight = (temp - start) / 2;
          midPos = (visibleLocation[startPoint] + visibleLocation[i]) / 2;
          tempTooltipHeight =
              tooltipBottom[startPoint] - tooltipTop[startPoint];
          tooltipTop[startPoint] = midPos - halfHeight;
          tooltipBottom[startPoint] =
              tooltipTop[startPoint] + tempTooltipHeight;
          for (k = startPoint; k > 0; k--) {
            if (tooltipTop[k] <= tooltipBottom[k - 1] + _tooltipPadding) {
              temp1TooltipHeight = tooltipBottom[k - 1] - tooltipTop[k - 1];
              tooltipTop[k - 1] =
                  tooltipTop[k] - temp1TooltipHeight - _tooltipPadding;
              tooltipBottom[k - 1] = tooltipTop[k - 1] + temp1TooltipHeight;
            } else {
              break;
            }
          }

          // To set tool tip positions based on the half height and other tooltip height
          for (j = startPoint + 1; j <= startPoint + count; j++) {
            tempTooltipHeight = tooltipBottom[j] - tooltipTop[j];
            tooltipTop[j] = tooltipBottom[j - 1] + _tooltipPadding;
            tooltipBottom[j] = tooltipTop[j] + tempTooltipHeight;
          }
          count = 0;
        }
        tooltipHeight =
            (tooltipBottom[i + 1] - tooltipTop[i + 1]) + _tooltipPadding;
        temp = tooltipTop[i + 1] + tooltipHeight;
        start = tooltipTop[i + 1];
        startPoint = i + 1;
      }
    }
    return _TooltipPositions(tooltipTop, tooltipBottom);
  }

  // To render the trackball marker
  void _renderTrackballMarker(CartesianSeriesRenderer seriesRenderer,
      Canvas canvas, TrackballBehavior trackballBehavior, int index) {
    final CartesianChartPoint<dynamic> point =
        seriesRenderer._dataPoints[index];
    final TrackballMarkerSettings markerSettings =
        trackballBehavior.markerSettings;
    if (markerSettings.shape == DataMarkerType.image) {
      _drawImageMarker(null, canvas, chartPointInfo[index].markerXPos,
          chartPointInfo[index].markerYPos, markerSettings, chartState);
    }
    final Paint strokePaint = Paint()
      ..color = trackballBehavior.markerSettings.borderWidth == 0
          ? Colors.transparent
          : ((point.pointColorMapper != null)
              ? point.pointColorMapper
              : markerSettings.borderColor ?? seriesRenderer._seriesColor)
      ..strokeWidth = markerSettings.borderWidth
      ..style = PaintingStyle.stroke;

    final Paint fillPaint = Paint()
      ..color = markerSettings.color ??
          (chartState._chartTheme.brightness == Brightness.light
              ? Colors.white
              : Colors.black)
      ..style = PaintingStyle.fill;
    canvas.drawPath(_markerShapes[index], strokePaint);
    canvas.drawPath(_markerShapes[index], fillPaint);
  }

  bool headerText = false;
  bool xFormat = false;
  bool isColon = true;

  /// To get tooltip size
  Size _getTooltipSize(double height, double width, int index) {
    final Offset position = Offset(
        chartPointInfo[index].xPosition, chartPointInfo[index].yPosition);
    stringValue = <String>[];
    final String format = chartPointInfo[index]
        .seriesRenderer
        ._chart
        .trackballBehavior
        .tooltipSettings
        .format;
    if (format != null &&
        format.contains('point.x') &&
        !format.contains('point.y')) {
      xFormat = true;
    }
    if (format != null &&
        format.contains('point.x') &&
        format.contains('point.y') &&
        !format.contains(':')) {
      isColon = false;
    }
    if (chartPointInfo[index].header != null &&
        chartPointInfo[index].header != '') {
      stringValue.add(chartPointInfo[index].header);
    }
    if (chart.trackballBehavior.tooltipDisplayMode ==
        TrackballDisplayMode.groupAllPoints) {
      String str1 = '';
      for (int i = 0; i < chartPointInfo.length; i++) {
        if (chartPointInfo[i].header != null &&
            chartPointInfo[i].header.contains(':')) {
          headerText = true;
        }
        bool isHeader =
            chartPointInfo[i].header != null && chartPointInfo[i].header != '';
        bool isLabel =
            chartPointInfo[i].label != null && chartPointInfo[i].label != '';
        if (chartPointInfo[i].seriesRenderer._isIndicator) {
          isHeader = chartPointInfo[0].header != null &&
              chartPointInfo[0].header != '';
          isLabel =
              chartPointInfo[0].label != null && chartPointInfo[0].label != '';
        }
        divider = isHeader && isLabel;
        final String str = (i == 0 && isHeader) ? '\n' : '';
        final String seriesType = chartPointInfo[i].seriesRenderer._seriesType;
        if (chartPointInfo[i].seriesRenderer._isIndicator &&
            chartPointInfo[i]
                .seriesRenderer
                ._series
                .name
                .contains('rangearea')) {
          str1 = i == 0 ? '\n' : '';
          continue;
        } else if ((seriesType.contains('hilo') ||
                seriesType.contains('candle') ||
                seriesType.contains('range') ||
                seriesType.contains('boxandwhisker')) &&
            chartPointInfo[i]
                    .seriesRenderer
                    ._chart
                    .trackballBehavior
                    .tooltipSettings
                    .format ==
                null &&
            isLabel) {
          stringValue.add(((chartPointInfo[index].header == null ||
                      chartPointInfo[index].header == '')
                  ? ''
                  : '\n') +
              '${chartPointInfo[i].seriesRenderer._seriesName}\n${chartPointInfo[i].label}');
        } else if (chartPointInfo[i].seriesRenderer._series.name != null) {
          if (chartPointInfo[i]
                  .seriesRenderer
                  ._chart
                  .trackballBehavior
                  .tooltipSettings
                  .format !=
              null) {
            if (isHeader && isLabel && i == 0) {
              stringValue.add('');
            }
            if (isLabel) {
              stringValue.add(chartPointInfo[i].label);
            }
          } else if (isLabel &&
              chartPointInfo[i].label.contains(':') &&
              (chartPointInfo[i].header == null ||
                  chartPointInfo[i].header == '')) {
            stringValue.add(chartPointInfo[i].label);
            divider = false;
          } else {
            if (isLabel) {
              stringValue.add(str1 +
                  str +
                  chartPointInfo[i].seriesRenderer._series.name +
                  ': ' +
                  chartPointInfo[i].label);
            }
            divider = (chartPointInfo[0].header != null &&
                    chartPointInfo[0].header != '') &&
                isLabel;
          }
          if (str1 != '') {
            str1 = '';
          }
        } else {
          if (isLabel) {
            if (isHeader && i == 0) {
              stringValue.add('');
            }
            stringValue.add(chartPointInfo[i].label);
          }
        }
      }
      for (int i = 0; i < stringValue.length; i++) {
        String measureString = stringValue[i];
        if (measureString.contains('<b>') && measureString.contains('</b>')) {
          measureString =
              measureString.replaceAll('<b>', '').replaceAll('</b>', '');
        }
        if (_measureText(measureString, labelStyle).width > width) {
          width = _measureText(measureString, labelStyle).width;
        }
        height += _measureText(measureString, labelStyle).height;
      }
      x = position.dx;
      if (chart.trackballBehavior.tooltipAlignment == ChartAlignment.center) {
        y = chartState._chartAxis._axisClipRect.center.dy;
      } else if (chart.trackballBehavior.tooltipAlignment ==
          ChartAlignment.near) {
        y = chartState._chartAxis._axisClipRect.top;
      } else {
        y = chartState._chartAxis._axisClipRect.bottom;
      }
    } else {
      stringValue = <String>[];
      if (chartPointInfo[index].label != null &&
          chartPointInfo[index].label != '') {
        stringValue.add(chartPointInfo[index].label);
      }
      String measureString = stringValue.isNotEmpty ? stringValue[0] : null;
      if (measureString != null &&
          measureString.contains('<b>') &&
          measureString.contains('</b>')) {
        measureString =
            measureString.replaceAll('<b>', '').replaceAll('</b>', '');
      }
      final Size size = _measureText(measureString, labelStyle);
      width = size.width;
      height = size.height;

      if (chartPointInfo[index].seriesRenderer._seriesType.contains('column') ||
          chartPointInfo[index].seriesRenderer._seriesType.contains('bar') ||
          chartPointInfo[index].seriesRenderer._seriesType == 'candle' ||
          chartPointInfo[index]
              .seriesRenderer
              ._seriesType
              .contains('boxandwhisker') ||
          chartPointInfo[index].seriesRenderer._seriesType.contains('hilo')) {
        x = chartPointInfo[index].chartDataPoint.markerPoint.x;
        y = chartPointInfo[index].chartDataPoint.markerPoint.y;
      } else if (chartPointInfo[index].seriesRenderer._seriesType ==
          'rangearea') {
        x = chartPointInfo[index].chartDataPoint.markerPoint.x;
        y = (chartPointInfo[index].chartDataPoint.markerPoint.y +
                chartPointInfo[index].chartDataPoint.markerPoint2.y) /
            2;
      } else {
        x = position.dx;
        y = position.dy;
      }
    }
    return Size(width, height);
  }

  /// To find the rect location of the trackball
  void _calculateTrackballRect(
      Canvas canvas, double width, double height, int index,
      [List<_ChartPointInfo> chartPointInfo,
      _TooltipPositions tooltipPosition]) {
    Rect labelRect = Rect.fromLTWH(x, y, width + 15, height + 10);

    final Rect backgroundRect = Rect.fromLTWH(boundaryRect.left + 25,
        boundaryRect.top, boundaryRect.width - 50, boundaryRect.height);
    final Rect leftRect = Rect.fromLTWH(boundaryRect.left - 5, boundaryRect.top,
        backgroundRect.left - (boundaryRect.left - 5), boundaryRect.height);
    final Rect rightRect = Rect.fromLTWH(backgroundRect.right, boundaryRect.top,
        (boundaryRect.right + 5) - backgroundRect.right, boundaryRect.height);

    if (leftRect.contains(Offset(x, y))) {
      isLeft = true;
      isRight = false;
    } else if (rightRect.contains(Offset(x, y))) {
      isLeft = false;
      isRight = true;
    }

    if (y > pointerLength + labelRect.height) {
      _calculateTooltipSize(labelRect, chartPointInfo, tooltipPosition, index);
    } else {
      isTop = false;
      if (isHorizontalOrientation) {
        xPos = x - (labelRect.width / 2);
        yPos = (y + pointerLength) + _padding;
        nosePointX = labelRect.left;
        nosePointY = labelRect.top + _padding;
        final double tooltipRightEnd = x + (labelRect.width / 2);
        xPos = xPos < boundaryRect.left
            ? boundaryRect.left
            : tooltipRightEnd > totalWidth
                ? totalWidth - labelRect.width
                : xPos;
      } else {
        if (chart.trackballBehavior.tooltipDisplayMode ==
            TrackballDisplayMode.groupAllPoints) {
          xPos = x - labelRect.width / 2;
          yPos = y;
        } else {
          xPos = x + _padding + pointerLength;
          yPos = (y + pointerLength / 2) + _padding;
        }
        nosePointX = labelRect.left;
        nosePointY = labelRect.top;
        final double tooltipRightEnd = x + labelRect.width;
        if (xPos < boundaryRect.left) {
          xPos = (chart.trackballBehavior.tooltipDisplayMode ==
                  TrackballDisplayMode.groupAllPoints)
              ? boundaryRect.left + groupAllPadding
              : boundaryRect.left;
        } else if (tooltipRightEnd > totalWidth) {
          xPos = (chart.trackballBehavior.tooltipDisplayMode ==
                  TrackballDisplayMode.groupAllPoints)
              ? (xPos - (labelRect.width / 2) - groupAllPadding)
              : ((xPos - labelRect.width - (2 * _padding)) - 2 * pointerLength);

          isRight = true;
        } else {
          xPos = (chart.trackballBehavior.tooltipDisplayMode ==
                      TrackballDisplayMode.groupAllPoints &&
                  chart.trackballBehavior.tooltipAlignment ==
                      ChartAlignment.near)
              ? x + _padding + pointerLength
              : xPos;
        }
      }
    }
    if (chart.trackballBehavior.tooltipDisplayMode !=
        TrackballDisplayMode.groupAllPoints) {
      if (xPos <= boundaryRect.left + 5) {
        xPos = xPos + 10;
      } else if (xPos + labelRect.width >= totalWidth - 5) {
        xPos = xPos - 10;
      }
    }
    labelRect = chart.trackballBehavior.tooltipDisplayMode ==
                TrackballDisplayMode.groupAllPoints ||
            chart.trackballBehavior.tooltipDisplayMode ==
                TrackballDisplayMode.nearestPoint ||
            isHorizontalOrientation ||
            isRectSeries
        ? Rect.fromLTWH(xPos, yPos, labelRect.width, labelRect.height)
        : Rect.fromLTWH(xPos, tooltipPosition.tooltipTop[index],
            labelRect.width, labelRect.height);
    if (chart.trackballBehavior.tooltipDisplayMode ==
        TrackballDisplayMode.groupAllPoints) {
      _drawTooltipBackground(
          canvas,
          labelRect,
          nosePointX,
          nosePointY,
          borderRadius,
          isTop,
          backgroundPath,
          isLeft,
          isRight,
          index,
          null,
          null);
    } else {
      if (chartState._requireInvertedAxis
          ? tooltipPosition.tooltipTop[index] >= boundaryRect.left &&
              tooltipPosition.tooltipBottom[index] <= boundaryRect.right
          : tooltipPosition.tooltipTop[index] >= boundaryRect.top &&
              tooltipPosition.tooltipBottom[index] <= boundaryRect.bottom) {
        _drawTooltipBackground(
            canvas,
            labelRect,
            nosePointX,
            nosePointY,
            borderRadius,
            isTop,
            backgroundPath,
            isLeft,
            isRight,
            index,
            chartPointInfo[index].xPosition,
            (chartPointInfo[index]
                        .seriesRenderer
                        ._seriesType
                        .contains('range') ||
                    chartPointInfo[index]
                        .seriesRenderer
                        ._seriesType
                        .contains('hilo') ||
                    chartPointInfo[index].seriesRenderer._seriesType ==
                        'candle')
                ? chartPointInfo[index].highYPosition
                : chartPointInfo[index].seriesRenderer._seriesType ==
                        'boxandwhisker'
                    ? chartPointInfo[index].maxYPosition
                    : chartPointInfo[index].yPosition);
      }
    }
  }

  /// To find the trackball tooltip size
  void _calculateTooltipSize(
      Rect labelRect,
      List<_ChartPointInfo> chartPointInfo,
      _TooltipPositions tooltipPositions,
      int index) {
    isTop = true;
    if (isHorizontalOrientation) {
      xPos = x - (labelRect.width / 2);
      yPos = (y - labelRect.height) - _padding;
      nosePointY = labelRect.top - _padding;
      nosePointX = labelRect.left;
      final double tooltipRightEnd = x + (labelRect.width / 2);
      xPos = xPos < boundaryRect.left
          ? boundaryRect.left
          : tooltipRightEnd > totalWidth ? totalWidth - labelRect.width : xPos;
      yPos = yPos - pointerLength;
      if (yPos + labelRect.height >= boundaryRect.bottom) {
        yPos = boundaryRect.bottom - labelRect.height;
      }
    } else {
      xPos = x + _padding + pointerLength;
      yPos = (y - labelRect.height / 2);
      nosePointY = yPos;
      nosePointX = labelRect.left;
      final double tooltipRightEnd = xPos + (labelRect.width);
      if (xPos < boundaryRect.left) {
        xPos = (chart.trackballBehavior.tooltipDisplayMode ==
                    TrackballDisplayMode.groupAllPoints &&
                chart.trackballBehavior.tooltipAlignment == ChartAlignment.far)
            ? boundaryRect.left + groupAllPadding
            : boundaryRect.left;
      } else if (tooltipRightEnd > totalWidth) {
        xPos = (chart.trackballBehavior.tooltipDisplayMode ==
                    TrackballDisplayMode.groupAllPoints &&
                chart.trackballBehavior.tooltipAlignment == ChartAlignment.far)
            ? xPos - labelRect.width - (2 * _padding) - groupAllPadding
            : ((xPos - labelRect.width - (2 * _padding)) - 2 * pointerLength);

        isRight = true;
      }
      if (yPos + labelRect.height >= boundaryRect.bottom) {
        yPos = boundaryRect.bottom - labelRect.height;
      }
    }
  }

  /// To draw the line for the trackball
  void _drawTrackBallLine(Canvas canvas, Paint paint, int index) {
    final Path dashArrayPath = Path();
    if (chart.trackballBehavior.lineType == TrackballLineType.vertical) {
      if (isRectSeries || chart.isTransposed) {
        _isTrackLineDrawn = true;
        dashArrayPath.moveTo(chartState._trackballBehaviorRenderer._position.dx,
            chartState._chartAxis._axisClipRect.top);
        dashArrayPath.lineTo(chartState._trackballBehaviorRenderer._position.dx,
            chartState._chartAxis._axisClipRect.bottom);
      } else {
        if (!_isTrackLineDrawn) {
          dashArrayPath.moveTo(chartPointInfo[index].xPosition,
              chartState._chartAxis._axisClipRect.top);
          dashArrayPath.lineTo(chartPointInfo[index].xPosition,
              chartState._chartAxis._axisClipRect.bottom);
        }
      }
    } else {
      if (isRectSeries || chart.isTransposed) {
        _isTrackLineDrawn = true;
        dashArrayPath.moveTo(chartState._chartAxis._axisClipRect.left,
            chartPointInfo[index].yPosition);
        dashArrayPath.lineTo(chartState._chartAxis._axisClipRect.right,
            chartPointInfo[index].yPosition);
      } else {
        if (!_isTrackLineDrawn) {
          dashArrayPath.moveTo(chartState._chartAxis._axisClipRect.left,
              chartState._trackballBehaviorRenderer._position.dy);
          dashArrayPath.lineTo(chartState._chartAxis._axisClipRect.right,
              chartState._trackballBehaviorRenderer._position.dy);
        }
      }
    }
    chart.trackballBehavior.lineDashArray != null
        ? _drawDashedLine(
            canvas, chart.trackballBehavior.lineDashArray, paint, dashArrayPath)
        : canvas.drawPath(dashArrayPath, paint);
  }

  /// To draw background of trackball tool tip
  void _drawTooltipBackground(
      Canvas canvas,
      Rect labelRect,
      double xPos,
      double yPos,
      double borderRadius,
      bool isTop,
      Path backgroundPath,
      bool isLeft,
      bool isRight,
      int index,
      num xPosition,
      num yPosition) {
    final double startArrow = pointerLength;
    final double endArrow = pointerLength;
    if (isTop) {
      _drawTooltip(
          canvas,
          labelRect,
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
          index,
          xPosition,
          yPosition);
    } else {
      _drawTooltip(
          canvas,
          labelRect,
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
          index,
          xPosition,
          yPosition);
    }
  }

  /// To draw the tooltip on the trackball
  void _drawTooltip(
      Canvas canvas,
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
      int index,
      num xPosition,
      num yPosition) {
    backgroundPath.reset();
    if (!canResetPath &&
        chart.trackballBehavior.tooltipDisplayMode !=
            TrackballDisplayMode.none) {
      if (chart.trackballBehavior.tooltipDisplayMode !=
          TrackballDisplayMode.groupAllPoints) {
        if (isHorizontalOrientation) {
          if (isLeft) {
            startX = rectF.left + borderRadius;
            endX = startX + pointerWidth;
          } else if (isRight) {
            endX = rectF.right - borderRadius;
            startX = endX - pointerWidth;
          }
          backgroundPath.moveTo(
              (rectF.left + rectF.width / 2) - pointerWidth, startY);
          backgroundPath.lineTo(xPos, yPos);
          backgroundPath.lineTo(
              (rectF.right - rectF.width / 2) + pointerWidth, endY);
        } else {
          if (isRight) {
            backgroundPath.moveTo(
                rectF.right, rectF.top + rectF.height / 2 - pointerWidth);
            backgroundPath.lineTo(
                rectF.right, rectF.bottom - rectF.height / 2 + pointerWidth);
            backgroundPath.lineTo(rectF.right + pointerLength, yPosition);
            backgroundPath.lineTo(rectF.right + pointerLength, yPosition);
            backgroundPath.lineTo(
                rectF.right, rectF.top + rectF.height / 2 - pointerWidth);
          } else {
            backgroundPath.moveTo(
                rectF.left, rectF.top + rectF.height / 2 - pointerWidth);
            backgroundPath.lineTo(
                rectF.left, rectF.bottom - rectF.height / 2 + pointerWidth);
            backgroundPath.lineTo(rectF.left - pointerLength, yPosition);
            backgroundPath.lineTo(rectF.left - pointerLength, yPosition);
            backgroundPath.lineTo(
                rectF.left, rectF.top + rectF.height / 2 - pointerWidth);
          }
        }
      }
      _drawRectandText(canvas, backgroundPath, rectF, index);
      xPos = null;
      yPos = null;
    }
  }

  /// draw trackball tooltip rect and text
  void _drawRectandText(
      Canvas canvas, Path backgroundPath, Rect rect, int index) {
    final RRect tooltipRect = RRect.fromRectAndCorners(
      rect,
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
    );
    const double padding = 10;
    backgroundPath.addRRect(tooltipRect);

    final Paint fillPaint = Paint()
      ..color = chart.trackballBehavior.tooltipSettings.color ??
          (chartPointInfo[index].seriesRenderer._series.color ??
              chartState._chartTheme.crosshairBackgroundColor)
      ..isAntiAlias = false
      ..style = PaintingStyle.fill;

    final Paint stokePaint = Paint()
      ..color = chart.trackballBehavior.tooltipSettings.borderColor ??
          (chartPointInfo[index].seriesRenderer._series.color ??
              chartState._chartTheme.crosshairBackgroundColor)
      ..strokeWidth = chart.trackballBehavior.tooltipSettings.borderWidth
      ..strokeCap = StrokeCap.butt
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    canvas.drawPath(backgroundPath, stokePaint);
    canvas.drawPath(backgroundPath, fillPaint);
    final Paint dividerPaint = Paint();
    dividerPaint.color = chartState._chartTheme.tooltipSeparatorColor;
    dividerPaint.strokeWidth = 1;
    dividerPaint.style = PaintingStyle.stroke;
    if (chart.trackballBehavior.tooltipDisplayMode ==
            TrackballDisplayMode.groupAllPoints &&
        divider) {
      final Size headerResult = _measureText(stringValue[0], labelStyle);
      canvas.drawLine(
          Offset(tooltipRect.left + padding,
              tooltipRect.top + headerResult.height + padding),
          Offset(tooltipRect.right - padding,
              tooltipRect.top + headerResult.height + padding),
          dividerPaint);
    }
    double eachTextHeight = 0;
    Size labelSize;
    double totalHeight = 0;

    for (int i = 0; i < stringValue.length; i++) {
      labelSize = _measureText(stringValue[i], labelStyle);
      totalHeight += labelSize.height;
    }

    eachTextHeight =
        (tooltipRect.top + tooltipRect.height / 2) - totalHeight / 2;

    for (int i = 0; i < stringValue.length; i++) {
      labelStyle = TextStyle(
          fontWeight: FontWeight.normal,
          color: labelStyle.color,
          fontSize: labelStyle.fontSize,
          fontFamily: labelStyle.fontFamily,
          fontStyle: labelStyle.fontStyle,
          inherit: labelStyle.inherit,
          backgroundColor: labelStyle.backgroundColor,
          letterSpacing: labelStyle.letterSpacing,
          wordSpacing: labelStyle.wordSpacing,
          textBaseline: labelStyle.textBaseline,
          height: labelStyle.height,
          locale: labelStyle.locale,
          foreground: labelStyle.foreground,
          background: labelStyle.background,
          shadows: labelStyle.shadows,
          fontFeatures: labelStyle.fontFeatures,
          decoration: labelStyle.decoration,
          decorationColor: labelStyle.decorationColor,
          decorationStyle: labelStyle.decorationStyle,
          decorationThickness: labelStyle.decorationThickness,
          debugLabel: labelStyle.debugLabel,
          fontFamilyFallback: labelStyle.fontFamilyFallback);
      labelSize = _measureText(stringValue[i], labelStyle);
      eachTextHeight += labelSize.height;
      if (!stringValue[i].contains(':') &&
          !stringValue[i].contains('<b>') &&
          !stringValue[i].contains('</b>')) {
        labelStyle = TextStyle(
            fontWeight: FontWeight.bold,
            color: labelStyle.color,
            fontSize: labelStyle.fontSize,
            fontFamily: labelStyle.fontFamily,
            fontStyle: labelStyle.fontStyle,
            inherit: labelStyle.inherit,
            backgroundColor: labelStyle.backgroundColor,
            letterSpacing: labelStyle.letterSpacing,
            wordSpacing: labelStyle.wordSpacing,
            textBaseline: labelStyle.textBaseline,
            height: labelStyle.height,
            locale: labelStyle.locale,
            foreground: labelStyle.foreground,
            background: labelStyle.background,
            shadows: labelStyle.shadows,
            fontFeatures: labelStyle.fontFeatures,
            decoration: labelStyle.decoration,
            decorationColor: labelStyle.decorationColor,
            decorationStyle: labelStyle.decorationStyle,
            decorationThickness: labelStyle.decorationThickness,
            debugLabel: labelStyle.debugLabel,
            fontFamilyFallback: labelStyle.fontFamilyFallback);
        _drawText(
            canvas,
            stringValue[i],
            Offset(
                (tooltipRect.left + tooltipRect.width / 2) -
                    labelSize.width / 2,
                eachTextHeight - labelSize.height),
            labelStyle,
            0);
      } else {
        if (stringValue[i] != null) {
          final List<String> str = stringValue[i].split('\n');
          double padding = 0;
          if (str.length > 1) {
            for (int j = 0; j < str.length; j++) {
              final List<String> str1 = str[j].split(':');
              if (str1.length > 1) {
                for (int k = 0; k < str1.length; k++) {
                  final double width =
                      k > 0 ? _measureText(str1[k - 1], labelStyle).width : 0;
                  str1[k] = k == 1 ? ':' + str1[k] : str1[k];
                  labelStyle = TextStyle(
                      fontWeight: k > 0 ? FontWeight.bold : FontWeight.normal,
                      color: labelStyle.color,
                      fontSize: labelStyle.fontSize,
                      fontFamily: labelStyle.fontFamily,
                      fontStyle: labelStyle.fontStyle,
                      inherit: labelStyle.inherit,
                      backgroundColor: labelStyle.backgroundColor,
                      letterSpacing: labelStyle.letterSpacing,
                      wordSpacing: labelStyle.wordSpacing,
                      textBaseline: labelStyle.textBaseline,
                      height: labelStyle.height,
                      locale: labelStyle.locale,
                      foreground: labelStyle.foreground,
                      background: labelStyle.background,
                      shadows: labelStyle.shadows,
                      fontFeatures: labelStyle.fontFeatures,
                      decoration: labelStyle.decoration,
                      decorationColor: labelStyle.decorationColor,
                      decorationStyle: labelStyle.decorationStyle,
                      decorationThickness: labelStyle.decorationThickness,
                      debugLabel: labelStyle.debugLabel,
                      fontFamilyFallback: labelStyle.fontFamilyFallback);
                  _drawText(
                      canvas,
                      str1[k],
                      Offset((tooltipRect.left + 4) + width,
                          (eachTextHeight - labelSize.height) + padding),
                      labelStyle,
                      0);
                  padding = k > 0
                      ? padding +
                          (labelStyle.fontSize + (labelStyle.fontSize * 0.15))
                      : padding;
                }
              } else {
                labelStyle = TextStyle(
                    fontWeight: FontWeight.bold,
                    color: labelStyle.color,
                    fontSize: labelStyle.fontSize,
                    fontFamily: labelStyle.fontFamily,
                    fontStyle: labelStyle.fontStyle,
                    inherit: labelStyle.inherit,
                    backgroundColor: labelStyle.backgroundColor,
                    letterSpacing: labelStyle.letterSpacing,
                    wordSpacing: labelStyle.wordSpacing,
                    textBaseline: labelStyle.textBaseline,
                    height: labelStyle.height,
                    locale: labelStyle.locale,
                    foreground: labelStyle.foreground,
                    background: labelStyle.background,
                    shadows: labelStyle.shadows,
                    fontFeatures: labelStyle.fontFeatures,
                    decoration: labelStyle.decoration,
                    decorationColor: labelStyle.decorationColor,
                    decorationStyle: labelStyle.decorationStyle,
                    decorationThickness: labelStyle.decorationThickness,
                    debugLabel: labelStyle.debugLabel,
                    fontFamilyFallback: labelStyle.fontFamilyFallback);
                _drawText(
                    canvas,
                    str1[str1.length - 1],
                    Offset(tooltipRect.left + 4,
                        eachTextHeight - labelSize.height + padding),
                    labelStyle,
                    0);
                padding = padding +
                    (labelStyle.fontSize + (labelStyle.fontSize * 0.15));
              }
            }
          } else {
            List<String> str1 = str[str.length - 1].split(':');
            final List<String> boldString = <String>[];
            if (str[str.length - 1].contains('<b>')) {
              str1 = <String>[];
              final List<String> boldSplit = str[str.length - 1].split('</b>');
              for (int i = 0; i < boldSplit.length; i++) {
                if (boldSplit[i] != '') {
                  boldString.add(boldSplit[i].substring(
                      boldSplit[i].indexOf('<b>') + 3, boldSplit[i].length));
                  final List<String> str2 = boldSplit[i].split('<b>');
                  for (int s = 0; s < str2.length; s++) {
                    str1.add(str2[s]);
                  }
                }
              }
            } else if (str1.length > 2 || xFormat || !isColon || headerText) {
              str1 = <String>[];
              str1.add(str[str.length - 1]);
            }
            double previousWidth = 0.0;
            for (int j = 0; j < str1.length; j++) {
              bool isBold = false;
              for (int i = 0; i < boldString.length; i++) {
                if (str1[j] == boldString[i]) {
                  isBold = true;
                  break;
                }
              }
              final double width =
                  j > 0 ? _measureText(str1[j - 1], labelStyle).width : 0;
              previousWidth += width;
              final String colon =
                  boldString.isNotEmpty ? '' : j > 0 ? ' :' : '';
              labelStyle = TextStyle(
                  fontWeight:
                      ((headerText && boldString.isEmpty) || xFormat || isBold)
                          ? FontWeight.bold
                          : j > 0
                              ? boldString.isNotEmpty
                                  ? FontWeight.normal
                                  : FontWeight.bold
                              : FontWeight.normal,
                  color: labelStyle.color,
                  fontSize: labelStyle.fontSize,
                  fontFamily: labelStyle.fontFamily,
                  fontStyle: labelStyle.fontStyle,
                  inherit: labelStyle.inherit,
                  backgroundColor: labelStyle.backgroundColor,
                  letterSpacing: labelStyle.letterSpacing,
                  wordSpacing: labelStyle.wordSpacing,
                  textBaseline: labelStyle.textBaseline,
                  height: labelStyle.height,
                  locale: labelStyle.locale,
                  foreground: labelStyle.foreground,
                  background: labelStyle.background,
                  shadows: labelStyle.shadows,
                  fontFeatures: labelStyle.fontFeatures,
                  decoration: labelStyle.decoration,
                  decorationColor: labelStyle.decorationColor,
                  decorationStyle: labelStyle.decorationStyle,
                  decorationThickness: labelStyle.decorationThickness,
                  debugLabel: labelStyle.debugLabel,
                  fontFamilyFallback: labelStyle.fontFamilyFallback);
              _drawText(
                  canvas,
                  colon + str1[j],
                  Offset(
                      (tooltipRect.left + 4) +
                          (previousWidth > width ? previousWidth : width),
                      eachTextHeight - labelSize.height),
                  labelStyle,
                  0);
              headerText = false;
            }
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  /// calculate trackball points
  void _generateAllPoints(Offset position) {
    chartPointInfo = <_ChartPointInfo>[];
    _visiblePoints = <_ClosestPoints>[];
    _tooltipTop = <num>[];
    _tooltipBottom = <num>[];
    _markerShapes?.clear();
    _visibleLocation = <num>[];
    final Rect seriesBounds = chartState._chartAxis._axisClipRect;
    if (position.dx >= seriesBounds.left &&
        position.dx <= seriesBounds.right &&
        position.dy >= seriesBounds.top &&
        position.dy <= seriesBounds.bottom) {
      chartState._trackballBehaviorRenderer._position = position;
      double xPos = 0,
          yPos = 0,
          leastX = 0,
          openXPos,
          openYPos,
          closeXPos,
          closeYPos,
          cummulativePos,
          lowerXPos,
          lowerYPos,
          upperXPos,
          upperYPos,
          lowYPos,
          highYPos,
          minYPos,
          maxYPos;
      int seriesIndex = 0;
      final List<ChartAxisRenderer> seriesAxisRenderers = <ChartAxisRenderer>[];
      for (final CartesianSeriesRenderer seriesRenderer
          in chartState._seriesRenderers) {
        final CartesianSeriesRenderer visibleSeriesRenderer = seriesRenderer;
        final ChartAxisRenderer chartAxisRenderer =
            visibleSeriesRenderer._xAxisRenderer;
        if (chartAxisRenderer == null) {
          continue;
        }
        if (!seriesAxisRenderers.contains(chartAxisRenderer)) {
          seriesAxisRenderers.add(chartAxisRenderer);
          for (final CartesianSeriesRenderer axisSeriesRenderer
              in chartAxisRenderer._seriesRenderers) {
            final CartesianSeriesRenderer cartesianSeriesRenderer =
                axisSeriesRenderer;
            if (axisSeriesRenderer._visible == false ||
                (axisSeriesRenderer._dataPoints.isEmpty &&
                    !axisSeriesRenderer._isRectSeries)) {
              continue;
            }
            if (cartesianSeriesRenderer._dataPoints.isNotEmpty) {
              final List<CartesianChartPoint<dynamic>> nearestDataPoints =
                  _getNearestChartPoints(
                      position.dx,
                      position.dy,
                      chartAxisRenderer,
                      visibleSeriesRenderer._yAxisRenderer,
                      cartesianSeriesRenderer);
              if (nearestDataPoints == null) {
                continue;
              }
              for (final CartesianChartPoint<dynamic> dataPoint
                  in nearestDataPoints) {
                num yValue;
                final int index =
                    axisSeriesRenderer._dataPoints.indexOf(dataPoint);
                final num xValue =
                    cartesianSeriesRenderer._dataPoints[index].xValue;
                if (cartesianSeriesRenderer._seriesType != 'boxandwhisker') {
                  yValue = cartesianSeriesRenderer._dataPoints[index].yValue;
                }
                final num minimumValue =
                    cartesianSeriesRenderer._dataPoints[index].minimum;
                final num maximumValue =
                    cartesianSeriesRenderer._dataPoints[index].maximum;
                final num lowerQuartileValue =
                    cartesianSeriesRenderer._dataPoints[index].lowerQuartile;
                final num upperQuartileValue =
                    cartesianSeriesRenderer._dataPoints[index].upperQuartile;
                final num meanValue =
                    cartesianSeriesRenderer._dataPoints[index].mean;
                final num highValue =
                    cartesianSeriesRenderer._dataPoints[index].high;
                final num lowValue =
                    cartesianSeriesRenderer._dataPoints[index].low;
                final num openValue =
                    cartesianSeriesRenderer._dataPoints[index].open;
                final num closeValue =
                    cartesianSeriesRenderer._dataPoints[index].close;
                final String seriesName =
                    cartesianSeriesRenderer._series.name ??
                        'Series $seriesIndex';
                final num bubbleSize =
                    cartesianSeriesRenderer._dataPoints[index].bubbleSize;
                final num cumulativeValue =
                    cartesianSeriesRenderer._dataPoints[index].cumulativeValue;
                final Rect axisClipRect = _calculatePlotOffset(
                    cartesianSeriesRenderer
                        ._chartState._chartAxis._axisClipRect,
                    Offset(
                        cartesianSeriesRenderer._xAxisRenderer._axis.plotOffset,
                        cartesianSeriesRenderer
                            ._yAxisRenderer._axis.plotOffset));
                xPos = _calculatePoint(
                        xValue,
                        yValue,
                        cartesianSeriesRenderer._xAxisRenderer,
                        cartesianSeriesRenderer._yAxisRenderer,
                        chartState._requireInvertedAxis,
                        cartesianSeriesRenderer._series,
                        axisClipRect)
                    .x;
                cummulativePos = _calculatePoint(
                        xValue,
                        cumulativeValue,
                        cartesianSeriesRenderer._xAxisRenderer,
                        cartesianSeriesRenderer._yAxisRenderer,
                        chartState._requireInvertedAxis,
                        cartesianSeriesRenderer._series,
                        axisClipRect)
                    .y;

                if (!xPos.toDouble().isNaN) {
                  if (seriesIndex == 0 ||
                      ((leastX - position.dx) > (leastX - xPos))) {
                    leastX = xPos;
                  }
                  final String labelValue = _getTrackballLabelText(
                      cartesianSeriesRenderer,
                      xValue,
                      yValue,
                      lowValue,
                      highValue,
                      openValue,
                      closeValue,
                      minimumValue,
                      maximumValue,
                      lowerQuartileValue,
                      upperQuartileValue,
                      meanValue,
                      seriesName,
                      bubbleSize,
                      cumulativeValue,
                      dataPoint);
                  yPos = cartesianSeriesRenderer._seriesType
                              .contains('stackedline') ||
                          cartesianSeriesRenderer._seriesType
                              .contains('stackedarea')
                      ? cummulativePos
                      : _calculatePoint(
                              xValue,
                              yValue,
                              cartesianSeriesRenderer._xAxisRenderer,
                              cartesianSeriesRenderer._yAxisRenderer,
                              chartState._requireInvertedAxis,
                              cartesianSeriesRenderer._series,
                              axisClipRect)
                          .y;
                  if (cartesianSeriesRenderer._seriesType.contains('range') ||
                      cartesianSeriesRenderer._seriesType.contains('hilo') ||
                      cartesianSeriesRenderer._seriesType == 'candle') {
                    lowYPos = _calculatePoint(
                            xValue,
                            lowValue,
                            cartesianSeriesRenderer._xAxisRenderer,
                            cartesianSeriesRenderer._yAxisRenderer,
                            chartState._requireInvertedAxis,
                            cartesianSeriesRenderer._series,
                            axisClipRect)
                        .y;

                    highYPos = _calculatePoint(
                            xValue,
                            highValue,
                            cartesianSeriesRenderer._xAxisRenderer,
                            cartesianSeriesRenderer._yAxisRenderer,
                            chartState._requireInvertedAxis,
                            cartesianSeriesRenderer._series,
                            axisClipRect)
                        .y;

                    if (cartesianSeriesRenderer._seriesType ==
                            'hiloopenclose' ||
                        cartesianSeriesRenderer._seriesType == 'candle') {
                      openXPos = dataPoint.openPoint.x;
                      openYPos = dataPoint.openPoint.y;
                      closeXPos = dataPoint.closePoint.x;
                      closeYPos = dataPoint.closePoint.y;
                    }
                  } else if (cartesianSeriesRenderer._seriesType
                      .contains('boxandwhisker')) {
                    minYPos = _calculatePoint(
                            xValue,
                            minimumValue,
                            cartesianSeriesRenderer._xAxisRenderer,
                            cartesianSeriesRenderer._yAxisRenderer,
                            chartState._requireInvertedAxis,
                            cartesianSeriesRenderer._series,
                            axisClipRect)
                        .y;

                    maxYPos = _calculatePoint(
                            xValue,
                            maximumValue,
                            cartesianSeriesRenderer._xAxisRenderer,
                            cartesianSeriesRenderer._yAxisRenderer,
                            chartState._requireInvertedAxis,
                            cartesianSeriesRenderer._series,
                            axisClipRect)
                        .y;

                    lowerXPos = dataPoint.lowerQuartilePoint.x;
                    lowerYPos = dataPoint.lowerQuartilePoint.y;
                    upperXPos = dataPoint.upperQuartilePoint.x;
                    upperYPos = dataPoint.upperQuartilePoint.y;
                  }

                  final Rect rect = seriesBounds
                      .intersect(Rect.fromLTWH(xPos - 1, yPos - 1, 2, 2));
                  if (seriesBounds.contains(Offset(xPos, yPos)) ||
                      seriesBounds.overlaps(rect)) {
                    !chartState._requireInvertedAxis
                        ? _visiblePoints.add(_ClosestPoints(
                            closestPointX: xPos,
                            closestPointY: (cartesianSeriesRenderer._seriesType
                                        .contains('range') ||
                                    cartesianSeriesRenderer._seriesType
                                        .contains('hilo') ||
                                    cartesianSeriesRenderer._seriesType ==
                                        'candle')
                                ? highYPos
                                : cartesianSeriesRenderer._seriesType ==
                                        'boxandwhisker'
                                    ? maxYPos
                                    : yPos))
                        : _visiblePoints.add(_ClosestPoints(
                            closestPointX: xPos + axisClipRect.bottom,
                            closestPointY: yPos + axisClipRect.right));
                    _addChartPointInfo(
                        cartesianSeriesRenderer,
                        xPos,
                        yPos,
                        index,
                        labelValue,
                        seriesIndex,
                        lowYPos,
                        highYPos,
                        openXPos,
                        openYPos,
                        closeXPos,
                        closeYPos,
                        minYPos,
                        maxYPos,
                        lowerXPos,
                        lowerYPos,
                        upperXPos,
                        upperYPos);
                    if (chart.trackballBehavior.tooltipDisplayMode ==
                            TrackballDisplayMode.groupAllPoints &&
                        leastX >= seriesBounds.left) {
                      chartState._requireInvertedAxis
                          ? yPos = leastX
                          : xPos = leastX;
                    }
                  }
                }
              }
              seriesIndex++;
            }
            _validateNearestXValue(
                leastX, cartesianSeriesRenderer, position.dx, position.dy);
          }

          if (_visiblePoints.isNotEmpty) {
            chartState._requireInvertedAxis
                ? _visiblePoints.sort((_ClosestPoints a, _ClosestPoints b) =>
                    a.closestPointX.compareTo(b.closestPointX))
                : _visiblePoints.sort((_ClosestPoints a, _ClosestPoints b) =>
                    a.closestPointY.compareTo(b.closestPointY));
          }

          if (chartPointInfo.isNotEmpty) {
            if (chart.trackballBehavior.tooltipDisplayMode !=
                TrackballDisplayMode.groupAllPoints) {
              chartState._requireInvertedAxis
                  ? chartPointInfo.sort(
                      (_ChartPointInfo a, _ChartPointInfo b) =>
                          a.xPosition.compareTo(b.xPosition))
                  : chartPointInfo.sort(
                      (_ChartPointInfo a, _ChartPointInfo b) =>
                          a.yPosition.compareTo(b.yPosition));
            }
            if (chart.trackballBehavior.tooltipDisplayMode ==
                    TrackballDisplayMode.nearestPoint ||
                (seriesRenderer._isRectSeries &&
                    chart.trackballBehavior.tooltipDisplayMode !=
                        TrackballDisplayMode.groupAllPoints)) {
              _validateNearestPointForAllSeries(
                  leastX, chartPointInfo, position.dx, position.dy);
            }
          }
        }
      }
      _triggerTrackballEvent();
    }
    chartPointInfo = _getValidPoints(chartPointInfo, position);
  }

  /// To get valid points of trackball
  List<_ChartPointInfo> _getValidPoints(
      List<_ChartPointInfo> points, Offset position) {
    final List<_ChartPointInfo> validPoints = <_ChartPointInfo>[];
    for (final _ChartPointInfo point in points) {
      if (validPoints.isEmpty) {
        validPoints.add(point);
      } else if (validPoints[0].seriesRenderer._xAxisRenderer ==
          point.seriesRenderer._xAxisRenderer) {
        if (!point.seriesRenderer._chartState._requireInvertedAxis) {
          if ((validPoints[0].xPosition - position.dx).abs() ==
              (point.xPosition - position.dx).abs()) {
            validPoints.add(point);
          }
        } else if ((validPoints[0].yPosition - position.dy).abs() ==
            (point.yPosition - position.dy).abs()) {
          validPoints.add(point);
        }
      } else if ((validPoints[0].xPosition - position.dx).abs() >
          (point.xPosition - position.dx).abs()) {
        validPoints.clear();
        validPoints.add(point);
      } else if ((validPoints[0].xPosition - position.dx).abs() ==
          (point.xPosition - position.dx).abs()) {
        if ((validPoints[0].yPosition - position.dy).abs() >
            (point.yPosition - position.dy).abs()) {
          validPoints.clear();
          validPoints.add(point);
        }
      }
    }
    return validPoints;
  }

  /// To get and return label text of the trackball
  String _getTrackballLabelText(
      CartesianSeriesRenderer cartesianSeriesRenderer,
      num xValue,
      num yValue,
      num lowValue,
      num highValue,
      num openValue,
      num closeValue,
      num minValue,
      num maxValue,
      num lowerQuartileValue,
      num upperQuartileValue,
      num meanValue,
      String seriesName,
      num bubbleSize,
      num cumulativeValue,
      CartesianChartPoint<dynamic> dataPoint) {
    String labelValue;
    final int digits = chart.trackballBehavior.tooltipSettings.decimalPlaces;
    if (chart.trackballBehavior.tooltipSettings.format != null) {
      dynamic x;
      final ChartAxisRenderer axisRenderer =
          cartesianSeriesRenderer._xAxisRenderer;
      if (axisRenderer is DateTimeAxisRenderer) {
        final DateTimeAxis _axis = axisRenderer._axis;
        final DateFormat dateFormat =
            _axis.dateFormat ?? axisRenderer._getLabelFormat(axisRenderer);
        x = dateFormat.format(DateTime.fromMillisecondsSinceEpoch(xValue));
      } else if (axisRenderer is CategoryAxisRenderer) {
        x = dataPoint.x;
      }
      labelValue = chart.trackballBehavior.tooltipSettings.format
          .replaceAll('point.x', (x ?? xValue).toString())
          .replaceAll(
              'point.y',
              _getLabelValue(
                  yValue, cartesianSeriesRenderer._yAxisRenderer._axis, digits))
          .replaceAll('point.high', highValue.toString())
          .replaceAll('point.low', lowValue.toString())
          .replaceAll('point.open', openValue.toString())
          .replaceAll('point.close', closeValue.toString())
          .replaceAll('point.minimum', minValue.toString())
          .replaceAll('point.maximum', maxValue.toString())
          .replaceAll('point.lowerQuartile', lowerQuartileValue.toString())
          .replaceAll('point.upperQuartile', upperQuartileValue.toString())
          .replaceAll('{', '')
          .replaceAll('}', '')
          .replaceAll('series.name', seriesName)
          .replaceAll('point.size', bubbleSize.toString())
          .replaceAll('point.cumulativeValue', cumulativeValue.toString());
    } else {
      labelValue = !cartesianSeriesRenderer._seriesType.contains('range') &&
              !cartesianSeriesRenderer._seriesType.contains('candle') &&
              !cartesianSeriesRenderer._seriesType.contains('hilo') &&
              !cartesianSeriesRenderer._seriesType.contains('boxandwhisker')
          ? _getLabelValue(
              yValue, cartesianSeriesRenderer._yAxisRenderer._axis, digits)
          : cartesianSeriesRenderer._seriesType == 'hiloopenclose' ||
                  cartesianSeriesRenderer._seriesType.contains('candle') ||
                  cartesianSeriesRenderer._seriesType.contains('boxandwhisker')
              ? cartesianSeriesRenderer._seriesType.contains('boxandwhisker')
                  ? 'Maximum : ' +
                      _getLabelValue(maxValue, cartesianSeriesRenderer._yAxisRenderer._axis)
                          .toString() +
                      '\n' +
                      'Minimum : ' +
                      _getLabelValue(minValue, cartesianSeriesRenderer._yAxisRenderer._axis)
                          .toString() +
                      '\n' +
                      'LowerQuartile : ' +
                      _getLabelValue(lowerQuartileValue, cartesianSeriesRenderer._yAxisRenderer._axis)
                          .toString() +
                      '\n' +
                      'UpperQuartile : ' +
                      _getLabelValue(upperQuartileValue, cartesianSeriesRenderer._yAxisRenderer._axis)
                          .toString()
                  : 'High : ' +
                      _getLabelValue(highValue, cartesianSeriesRenderer._yAxisRenderer._axis)
                          .toString() +
                      '\n' +
                      'Low : ' +
                      _getLabelValue(lowValue, cartesianSeriesRenderer._yAxisRenderer._axis)
                          .toString() +
                      '\n' +
                      'Open : ' +
                      _getLabelValue(openValue, cartesianSeriesRenderer._yAxisRenderer._axis)
                          .toString() +
                      '\n' +
                      'Close : ' +
                      _getLabelValue(closeValue, cartesianSeriesRenderer._yAxisRenderer._axis)
                          .toString()
              : 'High : ' +
                  _getLabelValue(highValue, cartesianSeriesRenderer._yAxisRenderer._axis)
                      .toString() +
                  '\n' +
                  'Low : ' +
                  _getLabelValue(lowValue, cartesianSeriesRenderer._yAxisRenderer._axis).toString();
    }
    return labelValue;
  }

  /// Event for trackball render
  void _triggerTrackballEvent() {
    if (chart.onTrackballPositionChanging != null) {
      chartState._chartPointInfo = chartState
          ._trackballBehaviorRenderer._trackballPainter.chartPointInfo;
      for (int index = 0; index < chartState._chartPointInfo.length; index++) {
        TrackballArgs chartPoint;
        chartPoint = TrackballArgs();
        chartPoint.chartPointInfo = chartState._chartPointInfo[index];
        chart.onTrackballPositionChanging(chartPoint);
        chartState._chartPointInfo[index].label =
            chartPoint.chartPointInfo.label;
        chartState._chartPointInfo[index].header =
            chartPoint.chartPointInfo.header;
      }
    }
  }

  /// To validate the nearest point in all series for trackball
  void _validateNearestPointForAllSeries(double leastX,
      List<_ChartPointInfo> trackballInfo, double touchXPos, double touchYPos) {
    double xPos = 0;
    final List<_ChartPointInfo> tempTrackballInfo =
        List<_ChartPointInfo>.from(trackballInfo);
    for (int i = 0; i < tempTrackballInfo.length; i++) {
      final _ChartPointInfo pointInfo = tempTrackballInfo[i];
      num yValue;
      final num xValue =
          pointInfo.seriesRenderer._dataPoints[pointInfo.dataPointIndex].xValue;
      if (pointInfo.seriesRenderer._seriesType != 'boxandwhisker') {
        yValue = pointInfo
            .seriesRenderer._dataPoints[pointInfo.dataPointIndex].yValue;
      }
      final Rect axisClipRect = _calculatePlotOffset(
          pointInfo.seriesRenderer._chartState._chartAxis._axisClipRect,
          Offset(pointInfo.seriesRenderer._xAxisRenderer._axis.plotOffset,
              pointInfo.seriesRenderer._yAxisRenderer._axis.plotOffset));

      xPos = _calculatePoint(
              xValue,
              yValue,
              pointInfo.seriesRenderer._xAxisRenderer,
              pointInfo.seriesRenderer._yAxisRenderer,
              chartState._requireInvertedAxis,
              pointInfo.seriesRenderer._series,
              axisClipRect)
          .x;
      trackballInfo = _getRectSeriesPointInfo(trackballInfo, pointInfo, xValue,
          yValue, touchXPos, leastX, axisClipRect);
      if (chart.trackballBehavior.tooltipDisplayMode !=
              TrackballDisplayMode.floatAllPoints &&
          (!pointInfo.seriesRenderer._chartState._requireInvertedAxis)) {
        if (leastX != xPos) {
          trackballInfo.remove(pointInfo);
        }
        final int pointInfoIndex = tempTrackballInfo.indexOf(pointInfo);
        final double yPos = touchYPos;
        if (pointInfoIndex < tempTrackballInfo.length - 1) {
          final _ChartPointInfo nextPointInfo =
              tempTrackballInfo[pointInfoIndex + 1];

          if (nextPointInfo.yPosition == pointInfo.yPosition ||
              (pointInfo.yPosition > yPos && pointInfoIndex == 0)) {
            continue;
          }
          if (!(yPos <
              (nextPointInfo.yPosition -
                  ((nextPointInfo.yPosition - pointInfo.yPosition) / 2)))) {
            trackballInfo.remove(pointInfo);
          } else if (pointInfoIndex != 0) {
            final _ChartPointInfo previousPointInfo =
                tempTrackballInfo[pointInfoIndex - 1];
            if (yPos <
                (pointInfo.yPosition -
                    ((pointInfo.yPosition - previousPointInfo.yPosition) /
                        2))) {
              trackballInfo.remove(pointInfo);
            }
          }
        } else {
          if (pointInfoIndex != 0 &&
              pointInfoIndex == tempTrackballInfo.length - 1) {
            final _ChartPointInfo previousPointInfo =
                tempTrackballInfo[pointInfoIndex - 1];
            if (yPos < previousPointInfo.yPosition) {
              trackballInfo.remove(pointInfo);
            }
            if (yPos <
                (pointInfo.yPosition -
                    ((pointInfo.yPosition - previousPointInfo.yPosition) /
                        2))) {
              trackballInfo.remove(pointInfo);
            }
          }
        }
      }
    }
  }

  /// It returns the trackball information for all series
  List<_ChartPointInfo> _getRectSeriesPointInfo(
      List<_ChartPointInfo> trackballInfo,
      _ChartPointInfo pointInfo,
      num xValue,
      num yValue,
      double touchXPos,
      double leastX,
      Rect axisClipRect) {
    if (pointInfo.seriesRenderer._isRectSeries &&
        chart.enableSideBySideSeriesPlacement &&
        chart.trackballBehavior.tooltipDisplayMode !=
            TrackballDisplayMode.groupAllPoints) {
      final bool isXAxisInverse = chartState._requireInvertedAxis;
      final _VisibleRange sideBySideInfo =
          _calculateSideBySideInfo(pointInfo.seriesRenderer, chartState);
      final double xStartValue = xValue + sideBySideInfo.minimum;
      final double xEndValue = xValue + sideBySideInfo.maximum;
      double xStart = _calculatePoint(
              xStartValue,
              yValue,
              pointInfo.seriesRenderer._xAxisRenderer,
              pointInfo.seriesRenderer._yAxisRenderer,
              chartState._requireInvertedAxis,
              pointInfo.seriesRenderer._series,
              axisClipRect)
          .x;
      double xEnd = _calculatePoint(
              xEndValue,
              yValue,
              pointInfo.seriesRenderer._xAxisRenderer,
              pointInfo.seriesRenderer._yAxisRenderer,
              chartState._requireInvertedAxis,
              pointInfo.seriesRenderer._series,
              axisClipRect)
          .x;
      bool isStartIndex = pointInfo.seriesRenderer._sideBySideIndex == 0;
      bool isEndIndex = pointInfo.seriesRenderer._sideBySideIndex ==
          pointInfo.seriesRenderer._chartState._chartSeries
                  .visibleSeriesRenderers.length -
              1;
      final double xPos = touchXPos;
      if (isXAxisInverse) {
        final double temp = xStart;
        xStart = xEnd;
        xEnd = temp;
        final bool isTemp = isEndIndex;
        isEndIndex = isStartIndex;
        isStartIndex = isTemp;
      } else if (pointInfo.seriesRenderer._chartState._zoomedState == true ||
          chart.trackballBehavior.tooltipDisplayMode !=
              TrackballDisplayMode.floatAllPoints) {
        if (xPos < leastX && isStartIndex) {
          if (!(xPos < xStart) && !(xPos < xEnd && xPos >= xStart)) {
            trackballInfo.remove(pointInfo);
          }
        } else if (xPos > leastX && isEndIndex) {
          if (!(xPos > xEnd && xPos > xStart) &&
              !(xPos < xEnd && xPos >= xStart)) {
            trackballInfo.remove(pointInfo);
          }
        } else if (!(xPos < xEnd && xPos >= xStart)) {
          trackballInfo.remove(pointInfo);
        }
      }
    }
    return trackballInfo;
  }

  /// To find the nearest x value to render a trackball
  void _validateNearestXValue(
      double leastX,
      CartesianSeriesRenderer seriesRenderer,
      double touchXPos,
      double touchYPos) {
    final List<_ChartPointInfo> leastPointInfo = <_ChartPointInfo>[];
    final Rect axisClipRect = _calculatePlotOffset(
        seriesRenderer._chartState._chartAxis._axisClipRect,
        Offset(seriesRenderer._xAxisRenderer._axis.plotOffset,
            seriesRenderer._yAxisRenderer._axis.plotOffset));

    double nearPointX = seriesRenderer._chartState._requireInvertedAxis
        ? axisClipRect.top
        : axisClipRect.left;
    final double touchXValue =
        seriesRenderer._chartState._requireInvertedAxis ? touchYPos : touchXPos;
    double delta = 0;
    for (final _ChartPointInfo pointInfo in chartPointInfo) {
      if (pointInfo.dataPointIndex < seriesRenderer._dataPoints.length) {
        num yValue;
        final num xValue =
            seriesRenderer._dataPoints[pointInfo.dataPointIndex].xValue;
        if (seriesRenderer._seriesType != 'boxandwhisker') {
          yValue = seriesRenderer._dataPoints[pointInfo.dataPointIndex].yValue;
        }
        final double currX = seriesRenderer._chartState._requireInvertedAxis
            ? _calculatePoint(
                    xValue,
                    yValue,
                    pointInfo.seriesRenderer._xAxisRenderer,
                    pointInfo.seriesRenderer._yAxisRenderer,
                    chartState._requireInvertedAxis,
                    pointInfo.seriesRenderer._series,
                    axisClipRect)
                .y
            : _calculatePoint(
                    xValue,
                    yValue,
                    pointInfo.seriesRenderer._xAxisRenderer,
                    pointInfo.seriesRenderer._yAxisRenderer,
                    chartState._requireInvertedAxis,
                    pointInfo.seriesRenderer._series,
                    axisClipRect)
                .x;

        if (delta == touchXValue - currX) {
          leastPointInfo.add(pointInfo);
        } else if ((touchXValue - currX).toDouble().abs() <=
            (touchXValue - nearPointX).toDouble().abs()) {
          nearPointX = currX;
          delta = touchXValue - currX;
          leastPointInfo.clear();
          leastPointInfo.add(pointInfo);
        }
      }
      if (chartPointInfo.isNotEmpty) {
        if (chartPointInfo[0].dataPointIndex <
            seriesRenderer._dataPoints.length) {
          leastX = _getLeastX(chartPointInfo[0], seriesRenderer, axisClipRect);
        }
      }

      if (chart.isTransposed) {
        yPos = leastX;
      } else {
        xPos = leastX;
      }
    }
  }

  /// To get the lowest X value to render trackball
  double _getLeastX(_ChartPointInfo pointInfo,
      CartesianSeriesRenderer seriesRenderer, Rect axisClipRect) {
    return _calculatePoint(
            seriesRenderer._dataPoints[pointInfo.dataPointIndex].xValue,
            0,
            seriesRenderer._xAxisRenderer,
            seriesRenderer._yAxisRenderer,
            chartState._requireInvertedAxis,
            seriesRenderer._series,
            axisClipRect)
        .x;
  }

  /// To add chart point info
  void _addChartPointInfo(CartesianSeriesRenderer seriesRenderer, double xPos,
      double yPos, int dataPointIndex, String label, num seriesIndex,
      [double lowYPos,
      double highYPos,
      double openXPos,
      double openYPos,
      double closeXPos,
      double closeYPos,
      double minYPos,
      double maxYPos,
      double lowerXPos,
      double lowerYPos,
      double upperXPos,
      double upperYPos]) {
    final _ChartPointInfo pointInfo = _ChartPointInfo();

    pointInfo.seriesRenderer = seriesRenderer;
    pointInfo.series = seriesRenderer._series;
    pointInfo.markerXPos = xPos;
    pointInfo.markerYPos = yPos;
    pointInfo.xPosition = xPos;
    pointInfo.yPosition = yPos;
    pointInfo.seriesIndex = seriesIndex;

    if (seriesRenderer._seriesType.contains('hilo') ||
        seriesRenderer._seriesType.contains('range') ||
        seriesRenderer._seriesType == 'candle') {
      pointInfo.lowYPosition = lowYPos;
      pointInfo.highYPosition = highYPos;
      if (seriesRenderer._seriesType == 'hiloopenclose' ||
          seriesRenderer._seriesType == 'candle') {
        pointInfo.openXPosition = openXPos;
        pointInfo.openYPosition = openYPos;
        pointInfo.closeXPosition = closeXPos;
        pointInfo.closeYPosition = closeYPos;
      }
    } else if (seriesRenderer._seriesType.contains('boxandwhisker')) {
      pointInfo.minYPosition = minYPos;
      pointInfo.maxYPosition = maxYPos;

      pointInfo.lowerXPosition = lowerXPos;
      pointInfo.lowerYPosition = lowerYPos;
      pointInfo.upperXPosition = upperXPos;
      pointInfo.upperYPosition = upperYPos;
    }

    if (seriesRenderer._segments.length > dataPointIndex) {
      pointInfo.color = seriesRenderer._segments[dataPointIndex]._color;
    } else if (seriesRenderer._segments.length > 1) {
      pointInfo.color =
          seriesRenderer._segments[seriesRenderer._segments.length - 1]._color;
    }
    pointInfo.chartDataPoint = seriesRenderer._dataPoints[dataPointIndex];
    pointInfo.dataPointIndex = dataPointIndex;
    pointInfo.label = label;
    pointInfo.header = getHeaderText(
        seriesRenderer._dataPoints[dataPointIndex], seriesRenderer);
    chartPointInfo.add(pointInfo);
  }

  /// To show track ball based on point index
  void showTrackball(
      List<CartesianSeriesRenderer> visibleSeriesRenderers, int pointIndex) {
    _ChartLocation position;
    final CartesianSeriesRenderer seriesRenderer = visibleSeriesRenderers[0];
    final Rect rect = seriesRenderer._chartState._chartAxis._axisClipRect;
    final List<CartesianChartPoint<dynamic>> _dataPoints =
        <CartesianChartPoint<dynamic>>[];
    for (int i = 0; i < seriesRenderer._dataPoints.length; i++) {
      if (seriesRenderer._dataPoints[i].isGap != true) {
        _dataPoints.add(seriesRenderer._dataPoints[i]);
      }
    }
    if (pointIndex != null &&
        pointIndex.abs() < seriesRenderer._dataPoints.length) {
      final int index = pointIndex;
      final num xValue = seriesRenderer._dataPoints[index].xValue;
      final num yValue =
          seriesRenderer._series is _FinancialSeriesBase<dynamic, dynamic> ||
                  seriesRenderer._seriesType.contains('range')
              ? seriesRenderer._dataPoints[index].high
              : seriesRenderer._dataPoints[index].yValue;
      position = _calculatePoint(
          xValue,
          yValue,
          seriesRenderer._xAxisRenderer,
          seriesRenderer._yAxisRenderer,
          seriesRenderer._chartState._requireInvertedAxis,
          seriesRenderer._series,
          rect);
      _generateAllPoints(Offset(position.x, position.y));
    }
  }

  /// To get header text of trackball
  String getHeaderText(CartesianChartPoint<dynamic> point,
      CartesianSeriesRenderer seriesRenderer) {
    final ChartAxisRenderer xAxisRenderer = seriesRenderer._xAxisRenderer;
    String headerText;
    String date;
    if (xAxisRenderer is DateTimeAxisRenderer) {
      final DateTimeAxis _xAxis = xAxisRenderer._axis;
      final DateFormat dateFormat =
          _xAxis.dateFormat ?? xAxisRenderer._getLabelFormat(xAxisRenderer);
      date = dateFormat
          .format(DateTime.fromMillisecondsSinceEpoch(point.xValue.floor()));
    }
    headerText = xAxisRenderer is CategoryAxisRenderer
        ? point.x.toString()
        : xAxisRenderer is DateTimeAxisRenderer
            ? date.toString()
            : _getLabelValue(point.xValue, xAxisRenderer._axis,
                    chart.tooltipBehavior.decimalPlaces)
                .toString();
    return headerText;
  }

  /// Return value as string
  String getFormattedValue(num value) => value.toString();
}

/// Class to store the about the details of the losest points
class _ClosestPoints {
  /// Creates the parameterized constructor for class _ClosestPoints
  const _ClosestPoints({this.closestPointX, this.closestPointY});

  final double closestPointX;

  final double closestPointY;
}

/// Class to store trackball tooltip start and end positions
class _TooltipPositions {
  /// Creates the parameterized constructor for the class _TooltipPositions
  const _TooltipPositions(this.tooltipTop, this.tooltipBottom);

  final List<num> tooltipTop;

  final List<num> tooltipBottom;
}
