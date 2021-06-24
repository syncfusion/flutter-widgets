part of charts;

class _TrackballPainter extends CustomPainter {
  _TrackballPainter({required this.chartState, required this.valueNotifier})
      : chart = chartState._chart,
        super(repaint: valueNotifier);
  final SfCartesianChartState chartState;
  final SfCartesianChart chart;
  Timer? timer;
  ValueNotifier<int> valueNotifier;
  late double pointerLength;
  late double pointerWidth;
  double nosePointY = 0;
  double nosePointX = 0;
  double totalWidth = 0;
  double? x;
  double? y;
  double? xPos;
  double? yPos;
  bool isTop = false;
  late double borderRadius;
  Path backgroundPath = Path();
  bool canResetPath = true;
  bool isLeft = false;
  bool isRight = false;
  double groupAllPadding = 10;
  List<_TrackballElement> stringValue = <_TrackballElement>[];
  Rect boundaryRect = const Rect.fromLTWH(0, 0, 0, 0);
  double leftPadding = 0;
  double topPadding = 0;
  bool isHorizontalOrientation = false;
  bool isRectSeries = false;
  late TextStyle labelStyle;
  bool divider = true;
  List<Path>? _markerShapes;
  //ignore: prefer_final_fields
  List<num> _tooltipTop = <num>[];
  //ignore: prefer_final_fields
  List<num> _tooltipBottom = <num>[];
  final List<ChartAxisRenderer> _xAxesInfo = <ChartAxisRenderer>[];
  final List<ChartAxisRenderer> _yAxesInfo = <ChartAxisRenderer>[];
  late List<_ChartPointInfo> chartPointInfo;
  late List<_ClosestPoints> _visiblePoints;
  _TooltipPositions? _tooltipPosition;
  num _padding = 5;
  late num _tooltipPadding;
  bool isRangeSeries = false;
  bool isBoxSeries = false;
  late Rect labelRect;
  late num markerSize, markerPadding;
  bool isGroupMode = false;
  late double lastMarkerResultHeight;
  _ChartLocation? _minLocation, _maxLocation;

  @override
  void paint(Canvas canvas, Size size) =>
      chartState._trackballBehaviorRenderer.onPaint(canvas);

  Paint _getLinePainter(Paint trackballLinePaint) => trackballLinePaint;

  /// To draw the trackball for all series
  void _drawTrackball(Canvas canvas) {
    final _RenderingDetails renderingDetails = chartState._renderingDetails;
    if (!_isSeriesAnimating()) {
      chartPointInfo = chartState._trackballBehaviorRenderer._chartPointInfo;
      _markerShapes = chartState._trackballBehaviorRenderer._markerShapes;
      _visiblePoints = chartState._trackballBehaviorRenderer._visiblePoints;
      isRangeSeries = chartState._trackballBehaviorRenderer._isRangeSeries;
      isBoxSeries = chartState._trackballBehaviorRenderer._isBoxSeries;
      _tooltipPadding = chartState._requireInvertedAxis ? 8 : 5;
      borderRadius = chart.trackballBehavior.tooltipSettings.borderRadius;
      pointerLength = chart.trackballBehavior.tooltipSettings.arrowLength;
      pointerWidth = chart.trackballBehavior.tooltipSettings.arrowWidth;
      isGroupMode = chart.trackballBehavior.tooltipDisplayMode ==
          TrackballDisplayMode.groupAllPoints;

      isLeft = false;
      isRight = false;
      double height = 0, width = 0;
      boundaryRect = chartState._chartAxis._axisClipRect;
      totalWidth = boundaryRect.left + boundaryRect.width;
      labelStyle = TextStyle(
          color: chart.trackballBehavior.tooltipSettings.textStyle.color ??
              renderingDetails.chartTheme.crosshairLabelColor,
          fontSize: chart.trackballBehavior.tooltipSettings.textStyle.fontSize,
          fontFamily:
              chart.trackballBehavior.tooltipSettings.textStyle.fontFamily,
          fontStyle:
              chart.trackballBehavior.tooltipSettings.textStyle.fontStyle,
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
      _ChartPointInfo? trackLinePoint =
          chartPointInfo.isNotEmpty ? chartPointInfo[0] : null;
      for (int index = 0; index < chartPointInfo.length; index++) {
        final _ChartPointInfo next = chartPointInfo[index];
        final _ChartPointInfo pres = trackLinePoint!;
        final Offset pos = chartState._trackballBehaviorRenderer._tapPosition;
        if (chartState._requireInvertedAxis
            ? ((pos.dy - pres.yPosition!).abs() >=
                (pos.dy - next.yPosition!).abs())
            : ((pos.dx - pres.xPosition!).abs() >=
                (pos.dx - next.xPosition!).abs())) {
          trackLinePoint = chartPointInfo[index];
        }
        if (((chartPointInfo[index]
                        .seriesRenderer!
                        ._seriesType
                        .contains('column') ||
                    chartPointInfo[index].seriesRenderer!._seriesType ==
                        'candle' ||
                    chartPointInfo[index]
                        .seriesRenderer!
                        ._seriesType
                        .contains('boxandwhisker') ||
                    chartPointInfo[index]
                        .seriesRenderer!
                        ._seriesType
                        .contains('hilo')) &&
                !chartState._requireInvertedAxis) ||
            (chartPointInfo[index]
                    .seriesRenderer!
                    ._seriesType
                    .contains('bar') &&
                chartState._requireInvertedAxis)) {
          isHorizontalOrientation = true;
        }
        isRectSeries = false;
        if ((chartPointInfo[index]
                    .seriesRenderer!
                    ._seriesType
                    .contains('column') ||
                chartPointInfo[index].seriesRenderer!._seriesType == 'candle' ||
                chartPointInfo[index]
                    .seriesRenderer!
                    ._seriesType
                    .contains('hilo') ||
                chartPointInfo[index]
                        .seriesRenderer!
                        ._seriesType
                        .contains('boxandwhisker') &&
                    chartState._requireInvertedAxis) ||
            (chartPointInfo[index]
                    .seriesRenderer!
                    ._seriesType
                    .contains('bar') &&
                !chartState._requireInvertedAxis)) {
          isRectSeries = true;
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
                    chart.trackballBehavior.markerSettings!.markerVisibility ==
                        TrackballVisibilityMode.auto
                ? (chartPointInfo[index]
                    .seriesRenderer!
                    ._series
                    .markerSettings
                    .isVisible)
                : chart.trackballBehavior.markerSettings != null &&
                    chart.trackballBehavior.markerSettings!.markerVisibility ==
                        TrackballVisibilityMode.visible)
            ? (chart.trackballBehavior.markerSettings!.width / 2) + 5
            : _padding;
        if (x != null &&
            y != null &&
            chart.trackballBehavior.tooltipSettings.enable) {
          if (isGroupMode &&
              ((chartPointInfo[index].header != null &&
                      chartPointInfo[index].header != '') ||
                  (chartPointInfo[index].label != null &&
                      chartPointInfo[index].label != ''))) {
            _calculateTrackballRect(
                canvas, width, height, index, chartPointInfo);
          } else {
            if (!canResetPath &&
                chartPointInfo[index].label != null &&
                chartPointInfo[index].label != '') {
              _tooltipTop.add(chartState._requireInvertedAxis
                  ? _visiblePoints[index].closestPointX -
                      _tooltipPadding -
                      (width / 2)
                  : _visiblePoints[index].closestPointY -
                      _tooltipPadding -
                      height / 2);
              _tooltipBottom.add(chartState._requireInvertedAxis
                  ? (_visiblePoints[index].closestPointX +
                          _tooltipPadding +
                          (width / 2)) +
                      (chart.trackballBehavior.tooltipSettings.canShowMarker
                          ? 20
                          : 0)
                  : _visiblePoints[index].closestPointY +
                      _tooltipPadding +
                      height / 2);
              _xAxesInfo
                  .add(chartPointInfo[index].seriesRenderer!._xAxisRenderer!);
              _yAxesInfo
                  .add(chartPointInfo[index].seriesRenderer!._yAxisRenderer!);
            }
          }
        }

        if (isGroupMode) {
          break;
        }
      }

      if (!canResetPath &&
          trackLinePoint != null &&
          chart.trackballBehavior.lineType != TrackballLineType.none) {
        final Paint trackballLinePaint = Paint();
        trackballLinePaint.color = chart.trackballBehavior.lineColor ??
            renderingDetails.chartTheme.crosshairLineColor;
        trackballLinePaint.strokeWidth = chart.trackballBehavior.lineWidth;
        trackballLinePaint.style = PaintingStyle.stroke;
        chart.trackballBehavior.lineWidth == 0
            ? trackballLinePaint.color = Colors.transparent
            : trackballLinePaint.color = trackballLinePaint.color;
        chartState._trackballBehaviorRenderer._drawLine(
            canvas,
            chartState._trackballBehaviorRenderer
                ._linePainter(trackballLinePaint),
            chartPointInfo.indexOf(trackLinePoint));
      }
// ignore: unnecessary_null_comparison
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
            _markerShapes!.isNotEmpty &&
            _markerShapes!.length > index) {
          chartState._trackballBehaviorRenderer._renderTrackballMarker(
              chartPointInfo[index].seriesRenderer!,
              canvas,
              chart.trackballBehavior,
              index);
        }

        // Padding added for avoid tooltip and the data point are too close and
        // extra padding based on trackball marker and width
        _padding = (chart.trackballBehavior.markerSettings != null &&
                    chart.trackballBehavior.markerSettings!.markerVisibility ==
                        TrackballVisibilityMode.auto
                ? (chartPointInfo[index]
                    .seriesRenderer!
                    ._series
                    .markerSettings
                    .isVisible)
                : chart.trackballBehavior.markerSettings != null &&
                    chart.trackballBehavior.markerSettings!.markerVisibility ==
                        TrackballVisibilityMode.visible)
            ? (chart.trackballBehavior.markerSettings!.width / 2) + 5
            : _padding;
        if (chart.trackballBehavior.tooltipSettings.enable &&
            !isGroupMode &&
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
              canvas, width, height, index, chartPointInfo, _tooltipPosition!);
          if (index == chartPointInfo.length - 1) {
            _tooltipTop.clear();
            _tooltipBottom.clear();
            _tooltipPosition!.tooltipTop.clear();
            _tooltipPosition!.tooltipBottom.clear();
            _xAxesInfo.clear();
            _yAxesInfo.clear();
          }
        }
      }
    }
  }

  bool _isSeriesAnimating() {
    for (int i = 0;
        i < chartState._chartSeries.visibleSeriesRenderers.length;
        i++) {
      final CartesianSeriesRenderer seriesRenderer =
          chartState._chartSeries.visibleSeriesRenderers[i];
      if (!(seriesRenderer._animationCompleted ||
              seriesRenderer._series.animationDuration == 0 ||
              !chartState._renderingDetails.initialRender!) &&
          seriesRenderer._series.isVisible) {
        return true;
      }
    }
    return false;
  }

  bool headerText = false;
  bool xFormat = false;
  bool isColon = true;

  /// To get tooltip size
  Size _getTooltipSize(double height, double width, int index) {
    final Offset position = Offset(
        chartPointInfo[index].xPosition!, chartPointInfo[index].yPosition!);
    Offset pos;
    SfCartesianChartState? _chartState;
    ChartAxisRenderer? xAxisRenderer, yAxisRenderer;
    CartesianSeriesRenderer? seriesRender;
    num? _minX, _maxX;
    stringValue = <_TrackballElement>[];
    final String? format = chartPointInfo[index]
        .seriesRenderer!
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
      stringValue.add(_TrackballElement(chartPointInfo[index].header!, null));
    }
    if (isGroupMode) {
      String str1 = '';
      for (int i = 0; i < chartPointInfo.length; i++) {
        pos = chartState._trackballBehaviorRenderer._tapPosition;
        _chartState = chartPointInfo[i].seriesRenderer?._chartState;
        xAxisRenderer = chartPointInfo[i].seriesRenderer?._xAxisRenderer;
        seriesRender = chartPointInfo[i].seriesRenderer;
        yAxisRenderer = chartPointInfo[i].seriesRenderer?._yAxisRenderer;
        _minX = seriesRender?._minimumX;
        _maxX = seriesRender?._maximumX;
        _minLocation = _calculatePoint(
            _minX!,
            seriesRender?._minimumY!,
            xAxisRenderer!,
            yAxisRenderer!,
            _chartState!._requireInvertedAxis,
            chartPointInfo[index].series,
            _chartState._chartAxis._axisClipRect);
        _maxLocation = _calculatePoint(
            _maxX!,
            seriesRender?._maximumY!,
            xAxisRenderer,
            yAxisRenderer,
            _chartState._requireInvertedAxis,
            chartPointInfo[index].series,
            _chartState._chartAxis._axisClipRect);
        if (chartPointInfo[i].header != null &&
            chartPointInfo[i].header!.contains(':')) {
          headerText = true;
        }
        bool isHeader =
            chartPointInfo[i].header != null && chartPointInfo[i].header != '';
        bool isLabel =
            chartPointInfo[i].label != null && chartPointInfo[i].label != '';
        if (chartPointInfo[i].seriesRenderer!._isIndicator) {
          isHeader = chartPointInfo[0].header != null &&
              chartPointInfo[0].header != '';
          isLabel =
              chartPointInfo[0].label != null && chartPointInfo[0].label != '';
        }
        divider = isHeader && isLabel;
        final String seriesType = chartPointInfo[i].seriesRenderer!._seriesType;
        if (chartPointInfo[i].seriesRenderer!._isIndicator &&
            chartPointInfo[i]
                .seriesRenderer!
                ._series
                .name!
                .contains('rangearea')) {
          if (i == 0) {
            stringValue.add(_TrackballElement('', null));
          } else {
            str1 = '';
          }
          continue;
        } else if ((seriesType.contains('hilo') ||
                seriesType.contains('candle') ||
                seriesType.contains('range') ||
                seriesType == 'boxandwhisker') &&
            chartPointInfo[i]
                    .seriesRenderer!
                    ._chart
                    .trackballBehavior
                    .tooltipSettings
                    .format ==
                null &&
            isLabel) {
          stringValue.add(_TrackballElement(
              ((chartPointInfo[index].header == null ||
                          chartPointInfo[index].header == '')
                      ? ''
                      : i == 0
                          ? '\n'
                          : '') +
                  '${chartPointInfo[i].seriesRenderer!._seriesName}\n${chartPointInfo[i].label}',
              chartPointInfo[i].seriesRenderer!));
        } else if (chartPointInfo[i].seriesRenderer!._series.name != null) {
          if (chartPointInfo[i]
                  .seriesRenderer!
                  ._chart
                  .trackballBehavior
                  .tooltipSettings
                  .format !=
              null) {
            if (isHeader && isLabel && i == 0) {
              stringValue.add(_TrackballElement('', null));
            }
            if (isLabel) {
              stringValue.add(_TrackballElement(
                  chartPointInfo[i].label!, chartPointInfo[i].seriesRenderer!));
            }
          } else if (isLabel &&
              chartPointInfo[i].label!.contains(':') &&
              (chartPointInfo[i].header == null ||
                  chartPointInfo[i].header == '')) {
            stringValue.add(_TrackballElement(
                chartPointInfo[i].label!, chartPointInfo[i].seriesRenderer!));
            divider = false;
          } else {
            if (isHeader && isLabel && i == 0) {
              stringValue.add(_TrackballElement('', null));
            }
            if (isLabel) {
              //ignore: avoid_bool_literals_in_conditional_expressions
              if (chartPointInfo[i].seriesRenderer!._isIndicator
                  ? pos.dx >= _minLocation!.x && pos.dx <= _maxLocation!.x
                  : true) {
                stringValue.add(_TrackballElement(
                    str1 +
                        chartPointInfo[i].seriesRenderer!._series.name! +
                        ': ' +
                        chartPointInfo[i].label!,
                    chartPointInfo[i].seriesRenderer!));
              }
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
              stringValue.add(_TrackballElement('', null));
            }
            stringValue.add(_TrackballElement(
                chartPointInfo[i].label!, chartPointInfo[i].seriesRenderer!));
          }
        }
      }
      for (int i = 0; i < stringValue.length; i++) {
        String measureString = stringValue[i].label;
        if (measureString.contains('<b>') && measureString.contains('</b>')) {
          measureString =
              measureString.replaceAll('<b>', '').replaceAll('</b>', '');
        }
        if (measureText(measureString, labelStyle).width > width) {
          width = measureText(measureString, labelStyle).width;
        }
        height += measureText(measureString, labelStyle).height;
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
      stringValue = <_TrackballElement>[];
      if (chartPointInfo[index].label != null &&
          chartPointInfo[index].label != '') {
        stringValue.add(_TrackballElement(chartPointInfo[index].label!,
            chartPointInfo[index].seriesRenderer!));
      }

      String? measureString =
          stringValue.isNotEmpty ? stringValue[0].label : null;
      if (measureString != null &&
          measureString.contains('<b>') &&
          measureString.contains('</b>')) {
        measureString =
            measureString.replaceAll('<b>', '').replaceAll('</b>', '');
      }
      final Size size = measureText(measureString!, labelStyle);
      width = size.width;
      height = size.height;

      if (chartPointInfo[index]
              .seriesRenderer!
              ._seriesType
              .contains('column') ||
          chartPointInfo[index].seriesRenderer!._seriesType.contains('bar') ||
          chartPointInfo[index].seriesRenderer!._seriesType == 'candle' ||
          chartPointInfo[index]
              .seriesRenderer!
              ._seriesType
              .contains('boxandwhisker') ||
          chartPointInfo[index].seriesRenderer!._seriesType.contains('hilo')) {
        x = position.dx;
        y = position.dy;
      } else if (chartPointInfo[index].seriesRenderer!._seriesType ==
          'rangearea') {
        x = chartPointInfo[index].chartDataPoint!.markerPoint!.x;
        y = (chartPointInfo[index].chartDataPoint!.markerPoint!.y +
                chartPointInfo[index].chartDataPoint!.markerPoint2!.y) /
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
      [List<_ChartPointInfo>? chartPointInfo,
      _TooltipPositions? tooltipPosition]) {
    final String seriesType =
        chartPointInfo![index].seriesRenderer!._seriesType;
    const double widthPadding = 17;
    markerSize = 10;
    Rect leftRect, rightRect;
    if (!chart.trackballBehavior.tooltipSettings.canShowMarker) {
      labelRect = Rect.fromLTWH(x!, y!, width + 15, height + 10);
      final Rect backgroundRect = Rect.fromLTWH(boundaryRect.left + 25,
          boundaryRect.top, boundaryRect.width - 50, boundaryRect.height);
      leftRect = Rect.fromLTWH(boundaryRect.left - 5, boundaryRect.top,
          backgroundRect.left - (boundaryRect.left - 5), boundaryRect.height);
      rightRect = Rect.fromLTWH(backgroundRect.right, boundaryRect.top,
          (boundaryRect.right + 5) - backgroundRect.right, boundaryRect.height);
    } else {
      labelRect = Rect.fromLTWH(
          x!, y!, width + (2 * markerSize) + widthPadding, height + 10);
      final Rect backgroundRect = Rect.fromLTWH(boundaryRect.left + 20,
          boundaryRect.top, boundaryRect.width - 40, boundaryRect.height);
      leftRect = Rect.fromLTWH(
          boundaryRect.left - 5,
          boundaryRect.top - 20,
          backgroundRect.left - (boundaryRect.left - 5),
          boundaryRect.height + 40);
      rightRect = Rect.fromLTWH(
          backgroundRect.right,
          boundaryRect.top - 20,
          (boundaryRect.right + 5) + backgroundRect.right,
          boundaryRect.height + 40);
    }

    if (leftRect.contains(Offset(x!, y!))) {
      isLeft = true;
      isRight = false;
    } else if (rightRect.contains(Offset(x!, y!))) {
      isLeft = false;
      isRight = true;
    }

    if (y! > pointerLength + labelRect.height) {
      _calculateTooltipSize(labelRect, chartPointInfo, tooltipPosition, index);
    } else {
      isTop = false;
      if (seriesType.contains('bar')
          ? chartState._requireInvertedAxis
          : chartState._requireInvertedAxis) {
        xPos = x! - (labelRect.width / 2);
        yPos = (y! + pointerLength) + _padding;
        nosePointX = labelRect.left;
        nosePointY = labelRect.top + _padding;
        final double tooltipRightEnd = x! + (labelRect.width / 2);
        xPos = xPos! < boundaryRect.left
            ? boundaryRect.left
            : tooltipRightEnd > totalWidth
                ? totalWidth - labelRect.width
                : xPos;
      } else {
        if (isGroupMode) {
          xPos = x! - labelRect.width / 2;
          yPos = y;
        } else {
          xPos = x!;
          yPos = (y! + pointerLength / 2) + _padding;
        }
        nosePointX = labelRect.left;
        nosePointY = labelRect.top;

        //ignore: prefer_final_locals
        num? leftSideAvailableSize = xPos! - boundaryRect.left;
        //ignore: prefer_final_locals
        num? rightSideAvailableSize = boundaryRect.width - xPos!;

        if (leftSideAvailableSize > rightSideAvailableSize) {
          xPos = isGroupMode
              ? (xPos! - (labelRect.width / 2) - groupAllPadding)
              : xPos! - labelRect.width - _padding - pointerLength;

          isRight = true;
        } else {
          xPos = isGroupMode
              ? x! + groupAllPadding
              : x! + _padding + pointerLength;
        }
        if (isGroupMode && (yPos! + labelRect.height) >= boundaryRect.bottom) {
          yPos = boundaryRect.bottom - labelRect.height;
        }

        if (isGroupMode && yPos! <= boundaryRect.top) {
          yPos = boundaryRect.top;
        }
      }
    }

    labelRect = isGroupMode ||
            chart.trackballBehavior.tooltipDisplayMode ==
                TrackballDisplayMode.nearestPoint
        ? Rect.fromLTWH(xPos!, yPos!, labelRect.width, labelRect.height)
        : Rect.fromLTWH(
            chartState._requireInvertedAxis
                ? tooltipPosition!.tooltipTop[index].toDouble()
                : xPos!,
            !chartState._requireInvertedAxis
                ? tooltipPosition!.tooltipTop[index].toDouble()
                : yPos!,
            labelRect.width,
            labelRect.height);
    if (isGroupMode) {
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
          ? tooltipPosition!.tooltipTop[index] >= boundaryRect.left &&
              tooltipPosition.tooltipBottom[index] <= boundaryRect.right
          : tooltipPosition!.tooltipTop[index] >= boundaryRect.top &&
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
            seriesType.contains('range') ||
                    seriesType.contains('hilo') ||
                    seriesType == 'candle'
                ? chartPointInfo[index].highXPosition
                : seriesType.contains('box')
                    ? chartPointInfo[index].maxXPosition
                    : chartPointInfo[index].xPosition,
            seriesType.contains('range') ||
                    seriesType.contains('hilo') ||
                    seriesType == 'candle'
                ? chartPointInfo[index].highYPosition
                : seriesType.contains('box')
                    ? chartPointInfo[index].maxYPosition
                    : chartPointInfo[index].yPosition);
      }
    }
  }

  /// To find the trackball tooltip size
  void _calculateTooltipSize(
      Rect labelRect,
      List<_ChartPointInfo>? chartPointInfo,
      _TooltipPositions? tooltipPositions,
      int index) {
    isTop = true;
    isRight = false;
    if (chartPointInfo![index].seriesRenderer!._seriesType.contains('bar')
        ? chartState._requireInvertedAxis
        : chartState._requireInvertedAxis) {
      xPos = x! - (labelRect.width / 2);
      yPos = (y! - labelRect.height) - _padding;
      nosePointY = labelRect.top - _padding;
      nosePointX = labelRect.left;
      final double tooltipRightEnd = x! + (labelRect.width / 2);
      xPos = xPos! < boundaryRect.left
          ? boundaryRect.left
          : tooltipRightEnd > totalWidth
              ? totalWidth - labelRect.width
              : xPos;
      yPos = yPos! - pointerLength;
      if (yPos! + labelRect.height >= boundaryRect.bottom) {
        yPos = boundaryRect.bottom - labelRect.height;
      }
    } else {
      xPos = x!;
      yPos = y! - labelRect.height / 2;
      nosePointY = yPos!;
      nosePointX = labelRect.left;
      //ignore: prefer_final_locals
      num? leftSideAvailableSize = xPos! - boundaryRect.left;
      //ignore: prefer_final_locals
      num? rightSideAvailableSize = boundaryRect.width - xPos!;

      if (leftSideAvailableSize > rightSideAvailableSize) {
        xPos = isGroupMode
            ? xPos! - labelRect.width - groupAllPadding
            : xPos! - labelRect.width - _padding - pointerLength;

        isRight = true;
      } else {
        xPos =
            isGroupMode ? x! + groupAllPadding : x! + _padding + pointerLength;
      }
      if (yPos! + labelRect.height >= boundaryRect.bottom) {
        yPos = boundaryRect.bottom - labelRect.height;
      }
    }
  }

  /// To draw the line for the trackball
  void _drawTrackBallLine(Canvas canvas, Paint paint, int index) {
    final Path dashArrayPath = Path();
    if (chartPointInfo[index].seriesRenderer!._seriesType.contains('bar')
        ? chartState._requireInvertedAxis
        : chartState._requireInvertedAxis) {
      dashArrayPath.moveTo(boundaryRect.left, chartPointInfo[index].yPosition!);
      dashArrayPath.lineTo(
          boundaryRect.right, chartPointInfo[index].yPosition!);
    } else {
      dashArrayPath.moveTo(chartPointInfo[index].xPosition!, boundaryRect.top);
      dashArrayPath.lineTo(
          chartPointInfo[index].xPosition!, boundaryRect.bottom);
    }
    chart.trackballBehavior.lineDashArray != null
        ? _drawDashedLine(canvas, chart.trackballBehavior.lineDashArray!, paint,
            dashArrayPath)
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
      double? xPosition,
      double? yPosition) {
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
      double? xPos,
      double? yPos,
      double startX,
      double startY,
      double endX,
      double endY,
      double borderRadius,
      Path backgroundPath,
      bool isLeft,
      bool isRight,
      int index,
      double? xPosition,
      double? yPosition) {
    backgroundPath.reset();
    if (!canResetPath &&
        chart.trackballBehavior.tooltipDisplayMode !=
            TrackballDisplayMode.none) {
      if (!isGroupMode && !(xPosition == null || yPosition == null)) {
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
    final _RenderingDetails renderingDetails = chartState._renderingDetails;
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
          renderingDetails.chartTheme.crosshairBackgroundColor
      ..isAntiAlias = false
      ..style = PaintingStyle.fill;

    final Paint stokePaint = Paint()
      ..color = chart.trackballBehavior.tooltipSettings.borderColor ??
          renderingDetails.chartTheme.crosshairBackgroundColor
      ..strokeWidth = chart.trackballBehavior.tooltipSettings.borderWidth
      ..strokeCap = StrokeCap.butt
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    canvas.drawPath(backgroundPath, stokePaint);
    canvas.drawPath(backgroundPath, fillPaint);
    final Paint dividerPaint = Paint();
    dividerPaint.color = renderingDetails.chartTheme.tooltipSeparatorColor;
    dividerPaint.strokeWidth = 1;
    dividerPaint.style = PaintingStyle.stroke;
    if (isGroupMode && divider) {
      final Size headerResult = measureText(stringValue[0].label, labelStyle);
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
      labelSize = measureText(stringValue[i].label, labelStyle);
      totalHeight += labelSize.height;
    }

    eachTextHeight =
        (tooltipRect.top + tooltipRect.height / 2) - totalHeight / 2;

    for (int i = 0; i < stringValue.length; i++) {
      markerPadding = 0;
      if (chart.trackballBehavior.tooltipSettings.canShowMarker) {
        if (isGroupMode && i == 0) {
          markerPadding = 0;
        } else {
          markerPadding = 10 - markerSize + 5;
        }
      }

      const double animationFactor = 1;
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
      labelSize = measureText(stringValue[i].label, labelStyle);
      eachTextHeight += labelSize.height;
      if (!stringValue[i].label.contains(':') &&
          !stringValue[i].label.contains('<b>') &&
          !stringValue[i].label.contains('</b>')) {
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

        _drawTooltipMarker(
            stringValue[i].label,
            canvas,
            tooltipRect,
            animationFactor,
            labelSize,
            chartPointInfo[index].seriesRenderer!,
            i,
            null,
            null,
            eachTextHeight,
            index);
        _drawText(
            canvas,
            stringValue[i].label,
            Offset(
                markerPadding +
                    (tooltipRect.left + tooltipRect.width / 2) -
                    labelSize.width / 2,
                eachTextHeight - labelSize.height),
            labelStyle,
            0);
      } else {
        // ignore: unnecessary_null_comparison
        if (stringValue[i].label != null) {
          final List<String> str = stringValue[i].label.split('\n');
          double padding = 0;
          if (str.length > 1) {
            for (int j = 0; j < str.length; j++) {
              final List<String> str1 = str[j].split(':');
              if (str1.length > 1) {
                for (int k = 0; k < str1.length; k++) {
                  final double width =
                      k > 0 ? measureText(str1[k - 1], labelStyle).width : 0;
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
                  if (k == 0) {
                    _drawTooltipMarker(
                        str1[k],
                        canvas,
                        tooltipRect,
                        animationFactor,
                        labelSize,
                        chartPointInfo[index].seriesRenderer!,
                        i,
                        null,
                        width,
                        eachTextHeight,
                        index);
                  }
                  _drawText(
                      canvas,
                      str1[k],
                      Offset(
                          (((!isGroupMode &&
                                          chart.trackballBehavior
                                              .tooltipSettings.canShowMarker)
                                      ? (tooltipRect.left +
                                          tooltipRect.width / 2 -
                                          labelSize.width / 2)
                                      : (tooltipRect.left + 4)) +
                                  markerPadding) +
                              width,
                          (eachTextHeight - labelSize.height) + padding),
                      labelStyle,
                      0);
                  padding = k > 0
                      ? padding +
                          (labelStyle.fontSize! + (labelStyle.fontSize! * 0.15))
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
                _drawTooltipMarker(
                    str1[str1.length - 1],
                    canvas,
                    tooltipRect,
                    animationFactor,
                    labelSize,
                    chartPointInfo[index].seriesRenderer!,
                    i,
                    null,
                    null,
                    eachTextHeight,
                    index,
                    measureText(str1[str1.length - 1], labelStyle));
                markerPadding =
                    chart.trackballBehavior.tooltipSettings.canShowMarker
                        ? markerPadding +
                            (j == 0 && !isGroupMode
                                ? 13
                                : j == 0 && isGroupMode
                                    ? 7
                                    : 0)
                        : 0;
                _drawText(
                    canvas,
                    str1[str1.length - 1],
                    Offset(markerPadding + tooltipRect.left + 4,
                        eachTextHeight - labelSize.height + padding),
                    labelStyle,
                    0);
                padding = padding +
                    (labelStyle.fontSize! + (labelStyle.fontSize! * 0.15));
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
                  j > 0 ? measureText(str1[j - 1], labelStyle).width : 0;
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
              if (j == 0) {
                _drawTooltipMarker(
                    str1[j],
                    canvas,
                    tooltipRect,
                    animationFactor,
                    labelSize,
                    chartPointInfo[index].seriesRenderer!,
                    i,
                    previousWidth,
                    width,
                    eachTextHeight,
                    index);
              }

              markerPadding =
                  chart.trackballBehavior.tooltipSettings.canShowMarker
                      ? markerPadding +
                          (j == 0 && !isGroupMode
                              ? 13
                              : j == 0 && isGroupMode
                                  ? 7
                                  : 0)
                      : 0;
              _drawText(
                  canvas,
                  colon + str1[j],
                  Offset(
                      markerPadding +
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

  /// draw marker inside the trackball tooltip
  void _drawTooltipMarker(
      String labelValue,
      Canvas canvas,
      RRect tooltipRect,
      double animationFactor,
      Size tooltipMarkerResult,
      CartesianSeriesRenderer? seriesRenderer,
      int i,
      double? previousWidth,
      double? width,
      double eachTextHeight,
      int index,
      [Size? headerSize]) {
    final Size tooltipStringResult = tooltipMarkerResult;
    markerSize = 5;
    Offset markerPoint;
    if (chart.trackballBehavior.tooltipSettings.canShowMarker) {
      if (!isGroupMode) {
        if (seriesRenderer!._seriesType.contains('hilo') ||
            seriesRenderer._seriesType.contains('candle') ||
            seriesRenderer._seriesType.contains('boxandwhisker')) {
          markerPoint = Offset(
              tooltipRect.left +
                  tooltipRect.width / 2 -
                  tooltipStringResult.width / 2 -
                  markerSize,
              (eachTextHeight - tooltipStringResult.height / 2) + 0.0);
          _renderMarker(
              markerPoint, seriesRenderer, animationFactor, canvas, index);
        } else {
          markerPoint = Offset(
              (tooltipRect.left +
                      tooltipRect.width / 2 -
                      tooltipStringResult.width / 2) -
                  markerSize,
              ((tooltipRect.top + tooltipRect.height) -
                      tooltipStringResult.height / 2) -
                  markerSize);
        }
        _renderMarker(
            markerPoint, seriesRenderer, animationFactor, canvas, index);
      } else {
        if (i > 0 && labelValue != '') {
          seriesRenderer = stringValue[i].seriesRenderer!;
          // ignore: unnecessary_null_comparison
          if (seriesRenderer != null &&
              seriesRenderer._series.name != null &&
              seriesRenderer._chart.trackballBehavior.tooltipSettings.format ==
                  null) {
            if (previousWidth != null && width != null) {
              markerPoint = Offset(
                  (tooltipRect.left + 10) +
                      (previousWidth > width ? previousWidth : width),
                  eachTextHeight - tooltipMarkerResult.height / 2);
              _renderMarker(
                  markerPoint, seriesRenderer, animationFactor, canvas, index);
            } else if (stringValue[i].needRender) {
              markerPoint = Offset(
                  tooltipRect.left + 10,
                  (headerSize!.height * 2 +
                          tooltipRect.top +
                          markerSize +
                          headerSize.height / 2) +
                      (i == 1
                          ? 0
                          : lastMarkerResultHeight - headerSize.height));
              lastMarkerResultHeight = tooltipMarkerResult.height;
              stringValue[i].needRender = false;
              _renderMarker(
                  markerPoint, seriesRenderer, animationFactor, canvas, index);
            }
          } else {
            markerPoint = Offset(
                ((tooltipRect.left + tooltipRect.width / 2) -
                        tooltipMarkerResult.width / 2) -
                    markerSize,
                eachTextHeight - tooltipMarkerResult.height / 2);
            _renderMarker(
                markerPoint, seriesRenderer, animationFactor, canvas, index);
          }
        }
      }
    }
  }

  // To render marker for the chart tooltip
  void _renderMarker(
      Offset markerPoint,
      CartesianSeriesRenderer _seriesRenderer,
      double animationFactor,
      Canvas canvas,
      int index) {
    _seriesRenderer._isMarkerRenderEvent = true;
    final MarkerSettings markerSettings =
        chart.trackballBehavior.markerSettings == null
            ? _seriesRenderer._series.markerSettings
            : chart.trackballBehavior.markerSettings!;
    final Path markerPath = _getMarkerShapesPath(
        markerSettings.shape,
        markerPoint,
        Size((2 * markerSize) * animationFactor,
            (2 * markerSize) * animationFactor),
        _seriesRenderer);

    Color? _seriesColor;
    if (_seriesRenderer._seriesType.contains('candle')) {
      final CandleSeriesRenderer seriesRenderer =
          _seriesRenderer as CandleSeriesRenderer;
      _seriesColor =
          (seriesRenderer._segments[chartPointInfo[index].dataPointIndex!]
                      as CandleSegment)
                  ._isBull
              ? seriesRenderer._candleSeries.bullColor
              : seriesRenderer._candleSeries.bearColor;
    } else if (_seriesRenderer._seriesType.contains('hiloopenclose')) {
      final HiloOpenCloseSeriesRenderer seriesRenderer =
          _seriesRenderer as HiloOpenCloseSeriesRenderer;
      _seriesColor =
          (seriesRenderer._segments[chartPointInfo[index].dataPointIndex!]
                      as HiloOpenCloseSegment)
                  ._isBull
              ? seriesRenderer._hiloOpenCloseSeries.bullColor
              : seriesRenderer._hiloOpenCloseSeries.bearColor;
    } else {
      _seriesColor = (chartPointInfo[index].dataPointIndex! <
                  _seriesRenderer._dataPoints.length
              ? _seriesRenderer
                  ._dataPoints[chartPointInfo[index].dataPointIndex!]
                  .pointColorMapper
              : null) ??
          _seriesRenderer._seriesColor;
    }

    Paint markerPaint = Paint();
    markerPaint.color = markerSettings.color ?? _seriesColor ?? Colors.white;
    if (_seriesRenderer._series.gradient != null) {
      markerPaint = _getLinearGradientPaint(
          _seriesRenderer._series.gradient!,
          _getMarkerShapesPath(
                  markerSettings.shape,
                  Offset(markerPoint.dx, markerPoint.dy),
                  Size((2 * markerSize) * animationFactor,
                      (2 * markerSize) * animationFactor),
                  _seriesRenderer)
              .getBounds(),
          _seriesRenderer._chartState!._requireInvertedAxis);
    }
    canvas.drawPath(markerPath, markerPaint);
    Paint markerBorderPaint = Paint();
    markerBorderPaint.color = markerSettings.borderColor ??
        _seriesColor ??
        _seriesRenderer._renderingDetails!.chartTheme.tooltipLabelColor;
    markerBorderPaint.strokeWidth = 1;
    markerBorderPaint.style = PaintingStyle.stroke;

    if (_seriesRenderer._series.gradient != null) {
      markerBorderPaint = _getLinearGradientPaint(
          _seriesRenderer._series.gradient!,
          _getMarkerShapesPath(
                  markerSettings.shape,
                  Offset(markerPoint.dx, markerPoint.dy),
                  Size((2 * markerSize) * animationFactor,
                      (2 * markerSize) * animationFactor),
                  _seriesRenderer)
              .getBounds(),
          _seriesRenderer._chartState!._requireInvertedAxis);
    }
    canvas.drawPath(markerPath, markerBorderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  /// Return value as string
  String getFormattedValue(num value) => value.toString();
}

/// Class to store the about the details of the closest points
class _ClosestPoints {
  /// Creates the parameterized constructor for class _ClosestPoints
  const _ClosestPoints(
      {required this.closestPointX, required this.closestPointY});

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

/// Class to store the string values with their corresponding series renderer
class _TrackballElement {
  /// Creates the parameterized constructor for the class _TrackballElement
  _TrackballElement(this.label, this.seriesRenderer);

  final String label;

  final CartesianSeriesRenderer? seriesRenderer;

  bool needRender = true;
}
