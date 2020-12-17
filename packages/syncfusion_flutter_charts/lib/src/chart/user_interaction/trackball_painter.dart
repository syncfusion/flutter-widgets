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
  bool canResetPath = true;
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
  bool divider = true;
  List<Path> _markerShapes;
  //ignore: prefer_final_fields
  List<num> _tooltipTop = <num>[];
  //ignore: prefer_final_fields
  List<num> _tooltipBottom = <num>[];
  final List<ChartAxisRenderer> _xAxesInfo = <ChartAxisRenderer>[];
  final List<ChartAxisRenderer> _yAxesInfo = <ChartAxisRenderer>[];
  List<_ChartPointInfo> chartPointInfo;
  List<_ClosestPoints> _visiblePoints;
  _TooltipPositions _tooltipPosition;
  num _padding = 5;
  num _tooltipPadding;
  bool isRangeSeries;
  bool isBoxSeries;

  @override
  void paint(Canvas canvas, Size size) =>
      chartState._trackballBehaviorRenderer.onPaint(canvas);

  Paint _getLinePainter(Paint trackballLinePaint) => trackballLinePaint;

  /// To draw the trackball for all series
  void _drawTrackball(Canvas canvas) {
    chartPointInfo = chartState._trackballBehaviorRenderer._chartPointInfo;
    _markerShapes = chartState._trackballBehaviorRenderer._markerShapes;
    _visiblePoints = chartState._trackballBehaviorRenderer._visiblePoints;
    isRangeSeries = chartState._trackballBehaviorRenderer._isRangeSeries;
    isBoxSeries = chartState._trackballBehaviorRenderer._isBoxSeries;
    _tooltipPadding = chartState._requireInvertedAxis ? 8 : 5;
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
              !chartState._requireInvertedAxis) ||
          (chartPointInfo[index].seriesRenderer._seriesType.contains('bar') &&
              chartState._requireInvertedAxis)) {
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
                  chartState._requireInvertedAxis) ||
          (chartPointInfo[index].seriesRenderer._seriesType.contains('bar') &&
              !chartState._requireInvertedAxis)) {
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
          _calculateTrackballRect(canvas, width, height, index, chartPointInfo);
        } else {
          if (!canResetPath &&
              chartPointInfo[index].label != null &&
              chartPointInfo[index].label != '') {
            _tooltipTop.add(chartState._requireInvertedAxis
                ? _visiblePoints[index].closestPointX -
                    (_tooltipPadding) -
                    (width / 2)
                : _visiblePoints[index].closestPointY -
                    _tooltipPadding -
                    height / 2);
            _tooltipBottom.add(chartState._requireInvertedAxis
                ? _visiblePoints[index].closestPointX +
                    (_tooltipPadding) +
                    (width / 2)
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
      _tooltipPosition = chartState._trackballBehaviorRenderer
          ._smartTooltipPositions(
              _tooltipTop,
              _tooltipBottom,
              _xAxesInfo,
              _yAxesInfo,
              chartPointInfo,
              chartState._requireInvertedAxis,
              true);
    }

    for (int index = 0; index < chartPointInfo.length; index++) {
      chartState._trackballBehaviorRenderer._trackballMarker(index);

      if (_markerShapes != null &&
          _markerShapes.isNotEmpty &&
          _markerShapes.length > index) {
        chartState._trackballBehaviorRenderer._renderTrackballMarker(
            chartPointInfo[index].seriesRenderer,
            canvas,
            chart.trackballBehavior,
            index);
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
      if (chart.trackballBehavior.tooltipSettings.enable &&
          chart.trackballBehavior.tooltipDisplayMode !=
              TrackballDisplayMode.groupAllPoints &&
          chartPointInfo[index].label != null &&
          chartPointInfo[index].label != '') {
        final Size size = _getTooltipSize(height, width, index);
        height = size.height;
        width = size.width;
        if (width < 10) {
          width = 10; // minimum width for tooltip to render
          borderRadius = borderRadius > 5 ? 5 : borderRadius;
        }
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
                seriesType == 'boxandwhisker') &&
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
        y = boundaryRect.center.dy;
      } else if (chart.trackballBehavior.tooltipAlignment ==
          ChartAlignment.near) {
        y = boundaryRect.top;
      } else {
        y = boundaryRect.bottom;
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
        x = position.dx;
        y = position.dy;
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
      if (chartPointInfo[index].seriesRenderer._seriesType.contains('bar')
          ? chartState._requireInvertedAxis
          : chartState._requireInvertedAxis) {
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
            chart.axes.isNotEmpty
        ? Rect.fromLTWH(xPos, yPos, labelRect.width, labelRect.height)
        : Rect.fromLTWH(
            chartState._requireInvertedAxis
                ? tooltipPosition.tooltipTop[index]
                : xPos,
            !chartState._requireInvertedAxis
                ? tooltipPosition.tooltipTop[index]
                : yPos,
            labelRect.width,
            labelRect.height);
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
            isRangeSeries
                ? chartPointInfo[index].highXPosition
                : isBoxSeries
                    ? chartPointInfo[index].maxXPosition
                    : chartPointInfo[index].xPosition,
            isRangeSeries
                ? chartPointInfo[index].highYPosition
                : isBoxSeries
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
    if (chartPointInfo[index].seriesRenderer._seriesType.contains('bar')
        ? chartState._requireInvertedAxis
        : chartState._requireInvertedAxis) {
      xPos = x - (labelRect.width / 2);
      yPos = (y - labelRect.height) - _padding;
      nosePointY = labelRect.top - _padding;
      nosePointX = labelRect.left;
      final double tooltipRightEnd = x + (labelRect.width / 2);
      xPos = xPos < boundaryRect.left
          ? boundaryRect.left
          : tooltipRightEnd > totalWidth
              ? totalWidth - labelRect.width
              : xPos;
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
    if (chartPointInfo[index].seriesRenderer._seriesType.contains('bar')
        ? chartState._requireInvertedAxis
        : chartState._requireInvertedAxis) {
      dashArrayPath.moveTo(boundaryRect.left, chartPointInfo[index].yPosition);
      dashArrayPath.lineTo(boundaryRect.right, chartPointInfo[index].yPosition);
    } else {
      dashArrayPath.moveTo(chartPointInfo[index].xPosition, boundaryRect.top);
      dashArrayPath.lineTo(
          chartPointInfo[index].xPosition, boundaryRect.bottom);
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
        if (chartState._requireInvertedAxis) {
          if (isLeft) {
            startX = rectF.left + borderRadius;
            endX = startX + pointerWidth;
          } else if (isRight) {
            endX = rectF.right - borderRadius;
            startX = endX - pointerWidth;
          }
          backgroundPath.moveTo(
              (rectF.left + rectF.width / 2) - pointerWidth, startY);
          backgroundPath.lineTo(xPosition, yPosition);
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
              final String colon = boldString.isNotEmpty
                  ? ''
                  : j > 0
                      ? ' :'
                      : '';
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
