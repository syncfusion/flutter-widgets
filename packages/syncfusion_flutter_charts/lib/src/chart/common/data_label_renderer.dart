part of charts;

/// Calculating data label position and updating the label region for current data point
void _calculateDataLabelPosition(
    CartesianSeriesRenderer seriesRenderer,
    CartesianChartPoint<dynamic> point,
    int index,
    SfCartesianChartState _chartState,
    DataLabelSettingsRenderer dataLabelSettingsRenderer,
    Animation<double> dataLabelAnimation,
    [Size? templateSize,
    Offset? templateLocation]) {
  final SfCartesianChart chart = _chartState._chart;
  final CartesianSeries<dynamic, dynamic> series = seriesRenderer._series;
  if (dataLabelSettingsRenderer._angle.isNegative) {
    final int angle = dataLabelSettingsRenderer._angle + 360;
    dataLabelSettingsRenderer._angle = angle;
  }
  final DataLabelSettings dataLabel = series.dataLabelSettings;
  Size? textSize, textSize2, textSize3, textSize4, textSize5;
  double? value1, value2;
  const int boxPlotPadding = 8;
  final Rect rect = _calculatePlotOffset(
      _chartState._chartAxis._axisClipRect,
      Offset(seriesRenderer._xAxisRenderer!._axis.plotOffset,
          seriesRenderer._yAxisRenderer!._axis.plotOffset));
  if (seriesRenderer._seriesType.contains('hilo') ||
      seriesRenderer._seriesType.contains('candle')) {
    value1 = ((point.open != null &&
                point.close != null &&
                (point.close < point.open) == true)
            ? point.close
            : point.open)
        ?.toDouble();
    value2 = ((point.open != null &&
                point.close != null &&
                (point.close > point.open) == true)
            ? point.close
            : point.open)
        ?.toDouble();
  }
  final bool transposed = _chartState._requireInvertedAxis;
  final bool inversed = seriesRenderer._yAxisRenderer!._axis.isInversed;
  final Rect clipRect = _calculatePlotOffset(
      _chartState._chartAxis._axisClipRect,
      Offset(seriesRenderer._xAxisRenderer!._axis.plotOffset,
          seriesRenderer._yAxisRenderer!._axis.plotOffset));
  final bool isRangeSeries = seriesRenderer._seriesType.contains('range') ||
      seriesRenderer._seriesType.contains('hilo') ||
      seriesRenderer._seriesType.contains('candle');
  final bool isBoxSeries = seriesRenderer._seriesType.contains('boxandwhisker');
  if (isBoxSeries) {
    value1 = (point.upperQuartile != null &&
            point.lowerQuartile != null &&
            point.upperQuartile! < point.lowerQuartile!)
        ? point.upperQuartile!
        : point.lowerQuartile!;
    value2 = (point.upperQuartile != null &&
            point.lowerQuartile != null &&
            point.upperQuartile! > point.lowerQuartile!)
        ? point.upperQuartile!
        : point.lowerQuartile!;
  }
  // ignore: prefer_final_locals
  List<String> labelList = <String>[];
  // ignore: prefer_final_locals
  String label = point.dataLabelMapper ??
      point.label ??
      _getLabelText(
          isRangeSeries
              ? (!inversed ? point.high : point.low)
              : isBoxSeries
                  ? (!inversed ? point.maximum : point.minimum)
                  : ((dataLabel.showCumulativeValues &&
                          point.cumulativeValue != null)
                      ? point.cumulativeValue
                      : point.yValue),
          seriesRenderer);
  if (isRangeSeries) {
    point.label2 = point.dataLabelMapper ??
        point.label2 ??
        _getLabelText(!inversed ? point.low : point.high, seriesRenderer);
    if (seriesRenderer._seriesType == 'hiloopenclose' ||
        seriesRenderer._seriesType.contains('candle')) {
      point.label3 = point.dataLabelMapper ??
          point.label3 ??
          _getLabelText(
              (point.open > point.close) == true
                  ? !inversed
                      ? point.close
                      : point.open
                  : !inversed
                      ? point.open
                      : point.close,
              seriesRenderer);
      point.label4 = point.dataLabelMapper ??
          point.label4 ??
          _getLabelText(
              (point.open > point.close) == true
                  ? !inversed
                      ? point.open
                      : point.close
                  : !inversed
                      ? point.close
                      : point.open,
              seriesRenderer);
    }
  } else if (isBoxSeries) {
    point.label2 = point.dataLabelMapper ??
        point.label2 ??
        _getLabelText(
            !inversed ? point.minimum : point.maximum, seriesRenderer);
    point.label3 = point.dataLabelMapper ??
        point.label3 ??
        _getLabelText(
            point.lowerQuartile! > point.upperQuartile!
                ? !inversed
                    ? point.upperQuartile
                    : point.lowerQuartile
                : !inversed
                    ? point.lowerQuartile
                    : point.upperQuartile,
            seriesRenderer);
    point.label4 = point.dataLabelMapper ??
        point.label4 ??
        _getLabelText(
            point.lowerQuartile! > point.upperQuartile!
                ? !inversed
                    ? point.lowerQuartile
                    : point.upperQuartile
                : !inversed
                    ? point.upperQuartile
                    : point.lowerQuartile,
            seriesRenderer);
    point.label5 = point.dataLabelMapper ??
        point.label5 ??
        _getLabelText(point.median, seriesRenderer);
  }
  DataLabelRenderArgs dataLabelArgs;
  TextStyle? dataLabelStyle = dataLabelSettingsRenderer._textStyle;
  //ignore: prefer_conditional_assignment
  if (dataLabelSettingsRenderer._originalStyle == null) {
    dataLabelSettingsRenderer._originalStyle = dataLabel.textStyle;
  }
  dataLabelStyle = dataLabelSettingsRenderer._originalStyle;
  if (chart.onDataLabelRender != null &&
      !seriesRenderer._visibleDataPoints![index].labelRenderEvent) {
    labelList.add(label);
    if (isRangeSeries) {
      labelList.add(point.label2!);
      if (seriesRenderer._seriesType == 'hiloopenclose' ||
          seriesRenderer._seriesType.contains('candle')) {
        labelList.add(point.label3!);
        labelList.add(point.label4!);
      }
    } else if (isBoxSeries) {
      labelList.add(point.label2!);
      labelList.add(point.label3!);
      labelList.add(point.label4!);
      labelList.add(point.label5!);
    }
    seriesRenderer._visibleDataPoints![index].labelRenderEvent = true;
    for (int i = 0; i < labelList.length; i++) {
      dataLabelArgs = DataLabelRenderArgs(
          seriesRenderer._series,
          seriesRenderer._dataPoints,
          index,
          seriesRenderer._visibleDataPoints![index].overallDataPointIndex);
      dataLabelArgs.text = labelList[i];
      dataLabelArgs.textStyle = dataLabelStyle!;
      dataLabelArgs.color = seriesRenderer._series.dataLabelSettings.color;
      chart.onDataLabelRender!(dataLabelArgs);
      labelList[i] = dataLabelArgs.text;
      index = dataLabelArgs.pointIndex!;
      point._dataLabelStyle = dataLabelArgs.textStyle;
      point._dataLabelColor = dataLabelArgs.color;
      dataLabelSettingsRenderer._offset = dataLabelArgs.offset;
    }
  }
  dataLabelSettingsRenderer._textStyle = dataLabelStyle;
  if (chart.onDataLabelRender != null) {
    dataLabelSettingsRenderer._color = point._dataLabelColor;
    dataLabelSettingsRenderer._textStyle = point._dataLabelStyle;
    dataLabelStyle = dataLabelSettingsRenderer._textStyle!;
  }
  // ignore: unnecessary_null_comparison
  if (point != null &&
      point.isVisible &&
      point.isGap != true &&
      (point.y != 0 || dataLabel.showZeroValue)) {
    final double markerPointX = dataLabel.builder == null
        ? seriesRenderer._seriesType.contains('hilo') ||
                seriesRenderer._seriesType == 'candle' ||
                isBoxSeries
            ? seriesRenderer._chartState!._requireInvertedAxis
                ? point.region!.centerRight.dx
                : point.region!.topCenter.dx
            : point.markerPoint!.x
        : templateLocation!.dx;
    final double markerPointY = dataLabel.builder == null
        ? seriesRenderer._seriesType.contains('hilo') ||
                seriesRenderer._seriesType == 'candle' ||
                isBoxSeries
            ? seriesRenderer._chartState!._requireInvertedAxis
                ? point.region!.centerRight.dy
                : point.region!.topCenter.dy
            : point.markerPoint!.y
        : templateLocation!.dy;
    final _ChartLocation markerPoint2 = _calculatePoint(
        point.xValue,
        seriesRenderer._yAxisRenderer!._axis.isInversed ? value2 : value1,
        seriesRenderer._xAxisRenderer!,
        seriesRenderer._yAxisRenderer!,
        _chartState._requireInvertedAxis,
        series,
        rect);
    final _ChartLocation markerPoint3 = _calculatePoint(
        point.xValue,
        seriesRenderer._yAxisRenderer!._axis.isInversed ? value1 : value2,
        seriesRenderer._xAxisRenderer!,
        seriesRenderer._yAxisRenderer!,
        _chartState._requireInvertedAxis,
        series,
        rect);
    final TextStyle font = (dataLabelSettingsRenderer._textStyle == null)
        ? const TextStyle(
            fontFamily: 'Roboto',
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal,
            fontSize: 12)
        : dataLabelStyle!;
    point.label = labelList.isNotEmpty ? labelList[0] : label;
    if (label.isNotEmpty) {
      _ChartLocation? chartLocation,
          chartLocation2,
          chartLocation3,
          chartLocation4,
          chartLocation5;
      textSize =
          dataLabel.builder == null ? measureText(label, font) : templateSize!;
      chartLocation = _ChartLocation(markerPointX, markerPointY);
      if (isRangeSeries || isBoxSeries) {
        point.label2 = labelList.isNotEmpty ? labelList[1] : point.label2;
        textSize2 = dataLabel.builder == null
            ? measureText(point.label2!, font)
            : templateSize!;
        chartLocation2 = _ChartLocation(
            dataLabel.builder == null
                ? seriesRenderer._seriesType.contains('hilo') ||
                        seriesRenderer._seriesType == 'candle' ||
                        isBoxSeries
                    ? seriesRenderer._chartState!._requireInvertedAxis
                        ? point.region!.centerLeft.dx
                        : point.region!.bottomCenter.dx
                    : point.markerPoint2!.x
                : templateLocation!.dx,
            dataLabel.builder == null
                ? seriesRenderer._seriesType.contains('hilo') ||
                        seriesRenderer._seriesType == 'candle' ||
                        isBoxSeries
                    ? seriesRenderer._chartState!._requireInvertedAxis
                        ? point.region!.centerLeft.dy
                        : point.region!.bottomCenter.dy
                    : point.markerPoint2!.y
                : templateLocation!.dy);
        if (isBoxSeries) {
          if (!seriesRenderer._chartState!._requireInvertedAxis) {
            chartLocation.y = chartLocation.y - boxPlotPadding;
            chartLocation2.y = chartLocation2.y + boxPlotPadding;
          } else {
            chartLocation.x = chartLocation.x + boxPlotPadding;
            chartLocation2.x = chartLocation2.x - boxPlotPadding;
          }
        }
      }
      final List<_ChartLocation?> alignedLabelLocations =
          _getAlignedLabelLocations(_chartState, seriesRenderer, point,
              dataLabel, chartLocation, chartLocation2, textSize);
      chartLocation = alignedLabelLocations[0];
      chartLocation2 = alignedLabelLocations[1];
      if (!seriesRenderer._seriesType.contains('column') &&
          !seriesRenderer._seriesType.contains('waterfall') &&
          !seriesRenderer._seriesType.contains('bar') &&
          !seriesRenderer._seriesType.contains('histogram') &&
          !seriesRenderer._seriesType.contains('rangearea') &&
          !seriesRenderer._seriesType.contains('hilo') &&
          !seriesRenderer._seriesType.contains('candle') &&
          !isBoxSeries) {
        chartLocation!.y = _calculatePathPosition(
            chartLocation.y,
            dataLabel.labelAlignment,
            textSize,
            dataLabel.borderWidth,
            seriesRenderer,
            index,
            transposed,
            chartLocation,
            _chartState,
            point,
            Size(
                series.markerSettings.isVisible
                    ? series.markerSettings.width / 2
                    : 0,
                series.markerSettings.isVisible
                    ? series.markerSettings.height / 2
                    : 0));
      } else {
        final List<_ChartLocation?> _locations = _getLabelLocations(
            index,
            _chartState,
            seriesRenderer,
            point,
            dataLabel,
            chartLocation,
            chartLocation2,
            textSize,
            textSize2);
        chartLocation = _locations[0];
        chartLocation2 = _locations[1];
      }
      if (seriesRenderer._seriesType == 'hiloopenclose' ||
          seriesRenderer._seriesType.contains('candle') ||
          isBoxSeries) {
        if (!isBoxSeries) {
          point.label3 = labelList.isNotEmpty ? labelList[2] : point.label3;
          point.label4 = labelList.isNotEmpty ? labelList[3] : point.label4;
          // point.label3 = point.dataLabelMapper ??
          //     _getLabelText(
          //         (point.open > point.close) == true
          //             ? !inversed
          //                 ? point.close
          //                 : point.open
          //             : !inversed
          //                 ? point.open
          //                 : point.close,
          //         seriesRenderer);
          // point.label4 = point.dataLabelMapper ??
          //     _getLabelText(
          //         (point.open > point.close) == true
          //             ? !inversed
          //                 ? point.open
          //                 : point.close
          //             : !inversed
          //                 ? point.close
          //                 : point.open,
          //         seriesRenderer);
        } else {
          point.label3 = labelList.isNotEmpty ? labelList[2] : point.label3;
          point.label4 = labelList.isNotEmpty ? labelList[3] : point.label4;
          point.label5 = labelList.isNotEmpty ? labelList[4] : point.label5;
          // point.label3 = point.dataLabelMapper ??
          //     _getLabelText(
          //         point.lowerQuartile! > point.upperQuartile!
          //             ? !inversed
          //                 ? point.upperQuartile
          //                 : point.lowerQuartile
          //             : !inversed
          //                 ? point.lowerQuartile
          //                 : point.upperQuartile,
          //         seriesRenderer);
          // point.label4 = point.dataLabelMapper ??
          //     _getLabelText(
          //         point.lowerQuartile! > point.upperQuartile!
          //             ? !inversed
          //                 ? point.lowerQuartile
          //                 : point.upperQuartile
          //             : !inversed
          //                 ? point.upperQuartile
          //                 : point.lowerQuartile,
          //         seriesRenderer);
          // point.label5 = point.dataLabelMapper ??
          //     _getLabelText(point.median, seriesRenderer);
        }
        textSize3 = dataLabel.builder == null
            ? measureText(point.label3!, font)
            : templateSize;
        if (seriesRenderer._seriesType.contains('hilo')) {
          chartLocation3 = (point.open > point.close) == true
              ? _ChartLocation(point.centerClosePoint!.x + textSize3!.width,
                  point.closePoint!.y)
              : _ChartLocation(point.centerOpenPoint!.x - textSize3!.width,
                  point.openPoint!.y);
        } else if (seriesRenderer._seriesType == 'candle' &&
            seriesRenderer._chartState!._requireInvertedAxis) {
          chartLocation3 = (point.open > point.close) == true
              ? _ChartLocation(point.closePoint!.x, markerPoint2.y + 1)
              : _ChartLocation(point.openPoint!.x, markerPoint2.y + 1);
        } else if (isBoxSeries) {
          chartLocation3 = (seriesRenderer._chartState!._requireInvertedAxis)
              ? _ChartLocation(point.lowerQuartilePoint!.x + boxPlotPadding,
                  markerPoint2.y + 1)
              : _ChartLocation(
                  point.region!.topCenter.dx, markerPoint2.y - boxPlotPadding);
        } else {
          chartLocation3 =
              _ChartLocation(point.region!.topCenter.dx, markerPoint2.y);
        }
        textSize4 = dataLabel.builder == null
            ? measureText(point.label4!, font)
            : templateSize;
        if (seriesRenderer._seriesType.contains('hilo')) {
          chartLocation4 = (point.open > point.close) == true
              ? _ChartLocation(point.centerOpenPoint!.x - textSize4!.width,
                  point.openPoint!.y)
              : _ChartLocation(point.centerClosePoint!.x + textSize4!.width,
                  point.closePoint!.y);
        } else if (seriesRenderer._seriesType == 'candle' &&
            seriesRenderer._chartState!._requireInvertedAxis) {
          chartLocation4 = (point.open > point.close) == true
              ? _ChartLocation(point.openPoint!.x, markerPoint3.y + 1)
              : _ChartLocation(point.closePoint!.x, markerPoint3.y + 1);
        } else if (isBoxSeries) {
          chartLocation4 = (seriesRenderer._chartState!._requireInvertedAxis)
              ? _ChartLocation(point.upperQuartilePoint!.x - boxPlotPadding,
                  markerPoint3.y + 1)
              : _ChartLocation(point.region!.bottomCenter.dx,
                  markerPoint3.y + boxPlotPadding);
        } else {
          chartLocation4 =
              _ChartLocation(point.region!.bottomCenter.dx, markerPoint3.y + 1);
        }
        if (isBoxSeries) {
          textSize5 = measureText(point.label5!, font);
          chartLocation5 = (!seriesRenderer._chartState!._requireInvertedAxis)
              ? _ChartLocation(
                  point.centerMedianPoint!.x, point.centerMedianPoint!.y)
              : _ChartLocation(
                  point.centerMedianPoint!.x, point.centerMedianPoint!.y);
        }
        final List<_ChartLocation?> alignedLabelLocations2 =
            _getAlignedLabelLocations(_chartState, seriesRenderer, point,
                dataLabel, chartLocation3, chartLocation4, textSize3!);
        chartLocation3 = alignedLabelLocations2[0];
        chartLocation4 = alignedLabelLocations2[1];
        final List<_ChartLocation?> _locations = _getLabelLocations(
            index,
            _chartState,
            seriesRenderer,
            point,
            dataLabel,
            chartLocation3,
            chartLocation4,
            textSize3,
            textSize4!);
        chartLocation3 = _locations[0];
        chartLocation4 = _locations[1];
      }
      _calculateDataLabelRegion(
          point,
          dataLabel,
          _chartState,
          chartLocation!,
          chartLocation2,
          isRangeSeries,
          clipRect,
          textSize,
          textSize2,
          chartLocation3,
          chartLocation4,
          chartLocation5,
          textSize3,
          textSize4,
          textSize5,
          seriesRenderer,
          index);
    }
  }
}

///Calculating the label location based on alignment value
List<_ChartLocation?> _getAlignedLabelLocations(
    SfCartesianChartState _chartState,
    CartesianSeriesRenderer seriesRenderer,
    CartesianChartPoint<dynamic> point,
    DataLabelSettings dataLabel,
    _ChartLocation chartLocation,
    _ChartLocation? chartLocation2,
    Size textSize) {
  final SfCartesianChart chart = _chartState._chart;
  final XyDataSeries<dynamic, dynamic> series =
      seriesRenderer._series as XyDataSeries<dynamic, dynamic>;
  final bool transposed = _chartState._requireInvertedAxis;
  final bool isRangeSeries = seriesRenderer._seriesType.contains('range') ||
      seriesRenderer._seriesType.contains('hilo') ||
      seriesRenderer._seriesType.contains('candle');
  final bool isBoxSeries = seriesRenderer._seriesType.contains('boxandwhisker');
  final double alignmentValue = textSize.height +
      (series.markerSettings.isVisible
          ? ((series.markerSettings.borderWidth * 2) +
              series.markerSettings.height)
          : 0);
  if ((seriesRenderer._seriesType.contains('bar') && !chart.isTransposed) ||
      (seriesRenderer._seriesType.contains('column') && chart.isTransposed) ||
      (seriesRenderer._seriesType.contains('waterfall') &&
          chart.isTransposed) ||
      seriesRenderer._seriesType.contains('hilo') ||
      seriesRenderer._seriesType.contains('candle') ||
      isBoxSeries) {
    chartLocation.x = (dataLabel.labelAlignment == ChartDataLabelAlignment.auto)
        ? chartLocation.x
        : _calculateAlignment(
            alignmentValue,
            chartLocation.x,
            dataLabel.alignment,
            (isRangeSeries
                    ? point.high
                    : isBoxSeries
                        ? point.maximum
                        : point.yValue) <
                0,
            transposed);
    if (isRangeSeries || isBoxSeries) {
      chartLocation2!.x =
          (dataLabel.labelAlignment == ChartDataLabelAlignment.auto)
              ? chartLocation2.x
              : _calculateAlignment(
                  alignmentValue,
                  chartLocation2.x,
                  dataLabel.alignment,
                  (isRangeSeries
                          ? point.low
                          : isBoxSeries
                              ? point.minimum
                              : point.yValue) <
                      0,
                  transposed);
    }
  } else {
    chartLocation.y = (dataLabel.labelAlignment == ChartDataLabelAlignment.auto)
        ? chartLocation.y
        : _calculateAlignment(
            alignmentValue,
            chartLocation.y,
            dataLabel.alignment,
            (isRangeSeries
                    ? point.high
                    : isBoxSeries
                        ? point.maximum
                        : point.yValue) <
                0,
            transposed);
    if (isRangeSeries || isBoxSeries) {
      chartLocation2!.y =
          (dataLabel.labelAlignment == ChartDataLabelAlignment.auto)
              ? chartLocation2.y
              : _calculateAlignment(
                  alignmentValue,
                  chartLocation2.y,
                  dataLabel.alignment,
                  (isRangeSeries
                          ? point.low
                          : isBoxSeries
                              ? point.minimum
                              : point.yValue) <
                      0,
                  transposed);
    }
  }
  return <_ChartLocation?>[chartLocation, chartLocation2];
}

///calculating the label loaction based on dataLabel position value
///(for range and rect series only)
List<_ChartLocation?> _getLabelLocations(
    int index,
    SfCartesianChartState _chartState,
    CartesianSeriesRenderer seriesRenderer,
    CartesianChartPoint<dynamic> point,
    DataLabelSettings dataLabel,
    _ChartLocation? chartLocation,
    _ChartLocation? chartLocation2,
    Size textSize,
    Size? textSize2) {
  final bool transposed = _chartState._requireInvertedAxis;
  final EdgeInsets margin = dataLabel.margin;
  final bool isRangeSeries = seriesRenderer._seriesType.contains('range') ||
      seriesRenderer._seriesType.contains('hilo') ||
      seriesRenderer._seriesType.contains('candle');
  final bool isBoxSeries = seriesRenderer._seriesType.contains('boxandwhisker');
  final bool inversed = seriesRenderer._yAxisRenderer!._axis.isInversed;
  final num value = isRangeSeries
      ? point.high
      : isBoxSeries
          ? point.maximum
          : point.yValue;
  final bool minus = (value < 0 && !inversed) || (!(value < 0) && inversed);
  if (!_chartState._requireInvertedAxis) {
    chartLocation!.y = !isBoxSeries
        ? _calculateRectPosition(
            chartLocation.y,
            point.region!,
            minus,
            isRangeSeries
                ? ((dataLabel.labelAlignment == ChartDataLabelAlignment.outer ||
                        dataLabel.labelAlignment == ChartDataLabelAlignment.top)
                    ? dataLabel.labelAlignment
                    : ChartDataLabelAlignment.auto)
                : dataLabel.labelAlignment,
            seriesRenderer,
            textSize,
            dataLabel.borderWidth,
            index,
            chartLocation,
            _chartState,
            transposed,
            margin)
        : chartLocation.y;
  } else {
    chartLocation!.x = !isBoxSeries
        ? _calculateRectPosition(
            chartLocation.x,
            point.region!,
            minus,
            seriesRenderer._seriesType.contains('hilo') ||
                    seriesRenderer._seriesType.contains('candle') ||
                    isBoxSeries
                ? ChartDataLabelAlignment.auto
                : isRangeSeries
                    ? ((dataLabel.labelAlignment ==
                                ChartDataLabelAlignment.outer ||
                            dataLabel.labelAlignment ==
                                ChartDataLabelAlignment.top)
                        ? dataLabel.labelAlignment
                        : ChartDataLabelAlignment.auto)
                    : dataLabel.labelAlignment,
            seriesRenderer,
            textSize,
            dataLabel.borderWidth,
            index,
            chartLocation,
            _chartState,
            transposed,
            margin)
        : chartLocation.x;
  }
  chartLocation2 = isRangeSeries
      ? _getSecondLabelLocation(index, _chartState, seriesRenderer, point,
          dataLabel, chartLocation, chartLocation2!, textSize)
      : chartLocation2;
  return <_ChartLocation?>[chartLocation, chartLocation2];
}

///Finding range series second label location
_ChartLocation _getSecondLabelLocation(
    int index,
    SfCartesianChartState _chartState,
    CartesianSeriesRenderer seriesRenderer,
    CartesianChartPoint<dynamic> point,
    DataLabelSettings dataLabel,
    _ChartLocation chartLocation,
    _ChartLocation chartLocation2,
    Size textSize) {
  final bool inversed = seriesRenderer._yAxisRenderer!._axis.isInversed;
  final bool transposed = _chartState._requireInvertedAxis;
  final EdgeInsets margin = dataLabel.margin;
  bool minus;

  minus = (seriesRenderer._seriesType == 'boxandwhisker')
      ? (point.minimum! < 0 && !inversed) || (!(point.minimum! < 0) && inversed)
      : ((point.low < 0) == true && !inversed) ||
          ((point.low < 0) == false && inversed);

  if (!_chartState._requireInvertedAxis) {
    chartLocation2.y = _calculateRectPosition(
        chartLocation2.y,
        point.region!,
        minus,
        dataLabel.labelAlignment == ChartDataLabelAlignment.top
            ? ChartDataLabelAlignment.auto
            : ChartDataLabelAlignment.top,
        seriesRenderer,
        textSize,
        dataLabel.borderWidth,
        index,
        chartLocation,
        _chartState,
        transposed,
        margin);
  } else {
    chartLocation2.x = _calculateRectPosition(
        chartLocation2.x,
        point.region!,
        minus,
        dataLabel.labelAlignment == ChartDataLabelAlignment.top
            ? ChartDataLabelAlignment.auto
            : ChartDataLabelAlignment.top,
        seriesRenderer,
        textSize,
        dataLabel.borderWidth,
        index,
        chartLocation,
        _chartState,
        transposed,
        margin);
  }
  return chartLocation2;
}

///Setting datalabel region
void _calculateDataLabelRegion(
    CartesianChartPoint<dynamic> point,
    DataLabelSettings dataLabel,
    SfCartesianChartState _chartState,
    _ChartLocation chartLocation,
    _ChartLocation? chartLocation2,
    bool isRangeSeries,
    Rect clipRect,
    Size textSize,
    Size? textSize2,
    _ChartLocation? chartLocation3,
    _ChartLocation? chartLocation4,
    _ChartLocation? chartLocation5,
    Size? textSize3,
    Size? textSize4,
    Size? textSize5,
    CartesianSeriesRenderer seriesRenderer,
    int index) {
  final DataLabelSettingsRenderer dataLabelSettingsRenderer =
      seriesRenderer._dataLabelSettingsRenderer;
  Rect? rect, rect2, rect3, rect4, rect5;
  final EdgeInsets margin = dataLabel.margin;
  final bool isBoxSeries = seriesRenderer._seriesType.contains('boxandwhisker');
  rect = _calculateLabelRect(chartLocation, textSize, margin,
      dataLabelSettingsRenderer._color != null || dataLabel.useSeriesColor);
  // if angle is given label will
  rect = ((index == 0 || index == seriesRenderer._dataPoints.length - 1) &&
          (dataLabelSettingsRenderer._angle / 90) % 2 == 1 &&
          !_chartState._requireInvertedAxis)
      ? rect
      : (dataLabelSettingsRenderer._angle / 90) % 2 == 1
          ? rect
          : _validateRect(rect, clipRect);
  if (isRangeSeries || isBoxSeries) {
    rect2 = _calculateLabelRect(chartLocation2!, textSize2!, margin,
        dataLabelSettingsRenderer._color != null || dataLabel.useSeriesColor);
    rect2 = _validateRect(rect2, clipRect);
  }
  if ((seriesRenderer._seriesType.contains('candle') ||
          seriesRenderer._seriesType.contains('hilo') ||
          isBoxSeries) &&
      (chartLocation3 != null ||
          chartLocation4 != null ||
          chartLocation5 != null)) {
    rect3 = _calculateLabelRect(chartLocation3!, textSize3!, margin,
        dataLabelSettingsRenderer._color != null || dataLabel.useSeriesColor);
    rect3 = _validateRect(rect3, clipRect);

    rect4 = _calculateLabelRect(chartLocation4!, textSize4!, margin,
        dataLabelSettingsRenderer._color != null || dataLabel.useSeriesColor);
    rect4 = _validateRect(rect4, clipRect);

    if (isBoxSeries) {
      rect5 = _calculateLabelRect(chartLocation5!, textSize5!, margin,
          dataLabelSettingsRenderer._color != null || dataLabel.useSeriesColor);
      rect5 = _validateRect(rect5, clipRect);
    }
  }
  if (dataLabelSettingsRenderer._color != null ||
      dataLabel.useSeriesColor ||
      // ignore: unnecessary_null_comparison
      (dataLabel.borderColor != null && dataLabel.borderWidth > 0)) {
    final RRect fillRect =
        _calculatePaddedFillRect(rect, dataLabel.borderRadius, margin);
    point.labelLocation = _ChartLocation(
        fillRect.center.dx - textSize.width / 2,
        fillRect.center.dy - textSize.height / 2);
    point.dataLabelRegion = Rect.fromLTWH(point.labelLocation!.x,
        point.labelLocation!.y, textSize.width, textSize.height);
    if (margin == const EdgeInsets.all(0)) {
      point.labelFillRect = fillRect;
    } else {
      final Rect rect = fillRect.middleRect;
      if (seriesRenderer._seriesType == 'candle' &&
          _chartState._requireInvertedAxis &&
          (point.close > point.high) == true) {
        point.labelLocation = _ChartLocation(
            rect.left - rect.width - textSize.width,
            rect.top + rect.height / 2 - textSize.height / 2);
      } else if (isBoxSeries &&
          _chartState._requireInvertedAxis &&
          point.upperQuartile! > point.maximum!) {
        point.labelLocation = _ChartLocation(
            rect.left - rect.width - textSize.width,
            rect.top + rect.height / 2 - textSize.height / 2);
      } else if (seriesRenderer._seriesType == 'candle' &&
          !_chartState._requireInvertedAxis &&
          (point.close > point.high) == true) {
        point.labelLocation = _ChartLocation(
            rect.left + rect.width / 2 - textSize.width / 2,
            rect.top + rect.height + textSize.height);
      } else if (isBoxSeries &&
          !_chartState._requireInvertedAxis &&
          point.upperQuartile! > point.maximum!) {
        point.labelLocation = _ChartLocation(
            rect.left + rect.width / 2 - textSize.width / 2,
            rect.top + rect.height + textSize.height);
      } else {
        point.labelLocation = _ChartLocation(
            rect.left + rect.width / 2 - textSize.width / 2,
            rect.top + rect.height / 2 - textSize.height / 2);
      }
      point.dataLabelRegion = Rect.fromLTWH(point.labelLocation!.x,
          point.labelLocation!.y, textSize.width, textSize.height);
      point.labelFillRect = _rectToRrect(rect, dataLabel.borderRadius);
    }
    if (isRangeSeries || isBoxSeries) {
      final RRect fillRect2 =
          _calculatePaddedFillRect(rect2!, dataLabel.borderRadius, margin);
      point.labelLocation2 = _ChartLocation(
          fillRect2.center.dx - textSize2!.width / 2,
          fillRect2.center.dy - textSize2.height / 2);
      point.dataLabelRegion2 = Rect.fromLTWH(point.labelLocation2!.x,
          point.labelLocation2!.y, textSize2.width, textSize2.height);
      if (margin == const EdgeInsets.all(0)) {
        point.labelFillRect2 = fillRect2;
      } else {
        final Rect rect2 = fillRect2.middleRect;
        point.labelLocation2 = _ChartLocation(
            rect2.left + rect2.width / 2 - textSize2.width / 2,
            rect2.top + rect2.height / 2 - textSize2.height / 2);
        point.dataLabelRegion2 = Rect.fromLTWH(point.labelLocation2!.x,
            point.labelLocation2!.y, textSize2.width, textSize2.height);
        point.labelFillRect2 = _rectToRrect(rect2, dataLabel.borderRadius);
      }
    }
    if (seriesRenderer._seriesType.contains('candle') ||
        seriesRenderer._seriesType.contains('hilo') ||
        isBoxSeries && (rect3 != null || rect4 != null || rect5 != null)) {
      final RRect fillRect3 =
          _calculatePaddedFillRect(rect3!, dataLabel.borderRadius, margin);
      point.labelLocation3 = _ChartLocation(
          fillRect3.center.dx - textSize3!.width / 2,
          fillRect3.center.dy - textSize3.height / 2);
      point.dataLabelRegion3 = Rect.fromLTWH(point.labelLocation3!.x,
          point.labelLocation3!.y, textSize3.width, textSize3.height);
      if (margin == const EdgeInsets.all(0)) {
        point.labelFillRect3 = fillRect3;
      } else {
        final Rect rect3 = fillRect3.middleRect;
        point.labelLocation3 = _ChartLocation(
            rect3.left + rect3.width / 2 - textSize3.width / 2,
            rect3.top + rect3.height / 2 - textSize3.height / 2);
        point.dataLabelRegion3 = Rect.fromLTWH(point.labelLocation3!.x,
            point.labelLocation3!.y, textSize3.width, textSize3.height);
        point.labelFillRect3 = _rectToRrect(rect3, dataLabel.borderRadius);
      }
      final RRect fillRect4 =
          _calculatePaddedFillRect(rect4!, dataLabel.borderRadius, margin);
      point.labelLocation4 = _ChartLocation(
          fillRect4.center.dx - textSize4!.width / 2,
          fillRect4.center.dy - textSize4.height / 2);
      point.dataLabelRegion4 = Rect.fromLTWH(point.labelLocation4!.x,
          point.labelLocation4!.y, textSize4.width, textSize4.height);
      if (margin == const EdgeInsets.all(0)) {
        point.labelFillRect4 = fillRect4;
      } else {
        final Rect rect4 = fillRect4.middleRect;
        point.labelLocation4 = _ChartLocation(
            rect4.left + rect4.width / 2 - textSize4.width / 2,
            rect4.top + rect4.height / 2 - textSize4.height / 2);
        point.dataLabelRegion4 = Rect.fromLTWH(point.labelLocation4!.x,
            point.labelLocation4!.y, textSize4.width, textSize4.height);
        point.labelFillRect4 = _rectToRrect(rect4, dataLabel.borderRadius);
      }
      if (isBoxSeries) {
        final RRect fillRect5 =
            _calculatePaddedFillRect(rect5!, dataLabel.borderRadius, margin);
        point.labelLocation5 = _ChartLocation(
            fillRect5.center.dx - textSize5!.width / 2,
            fillRect5.center.dy - textSize5.height / 2);
        point.dataLabelRegion5 = Rect.fromLTWH(point.labelLocation5!.x,
            point.labelLocation5!.y, textSize5.width, textSize5.height);
        if (margin == const EdgeInsets.all(0)) {
          point.labelFillRect5 = fillRect5;
        } else {
          final Rect rect5 = fillRect5.middleRect;
          point.labelLocation5 = _ChartLocation(
              rect5.left + rect5.width / 2 - textSize5.width / 2,
              rect5.top + rect5.height / 2 - textSize5.height / 2);
          point.dataLabelRegion5 = Rect.fromLTWH(point.labelLocation5!.x,
              point.labelLocation5!.y, textSize5.width, textSize5.height);
          point.labelFillRect5 = _rectToRrect(rect5, dataLabel.borderRadius);
        }
      }
    }
  } else {
    if (seriesRenderer._seriesType == 'candle' &&
        _chartState._requireInvertedAxis &&
        (point.close > point.high) == true) {
      point.labelLocation = _ChartLocation(
          rect.left - rect.width - textSize.width - 2,
          rect.top + rect.height / 2 - textSize.height / 2);
    } else if (isBoxSeries &&
        _chartState._requireInvertedAxis &&
        point.upperQuartile! > point.maximum!) {
      point.labelLocation = _ChartLocation(
          rect.left - rect.width - textSize.width - 2,
          rect.top + rect.height / 2 - textSize.height / 2);
    } else if (seriesRenderer._seriesType == 'candle' &&
        !_chartState._requireInvertedAxis &&
        (point.close > point.high) == true) {
      point.labelLocation = _ChartLocation(
          rect.left + rect.width / 2 - textSize.width / 2,
          rect.top + rect.height + textSize.height / 2);
    } else if (isBoxSeries &&
        !_chartState._requireInvertedAxis &&
        point.upperQuartile! > point.maximum!) {
      point.labelLocation = _ChartLocation(
          rect.left + rect.width / 2 - textSize.width / 2,
          rect.top + rect.height + textSize.height / 2);
    } else {
      point.labelLocation = _ChartLocation(
          rect.left + rect.width / 2 - textSize.width / 2,
          rect.top + rect.height / 2 - textSize.height / 2);
    }
    point.dataLabelRegion = Rect.fromLTWH(point.labelLocation!.x,
        point.labelLocation!.y, textSize.width, textSize.height);
    if (isRangeSeries || isBoxSeries) {
      if (seriesRenderer._seriesType == 'candle' &&
          _chartState._requireInvertedAxis &&
          (point.close > point.high) == true) {
        point.labelLocation2 = _ChartLocation(
            rect2!.left + rect2.width + textSize2!.width + 2,
            rect2.top + rect2.height / 2 - textSize2.height / 2);
      } else if (isBoxSeries &&
          _chartState._requireInvertedAxis &&
          point.upperQuartile! > point.maximum!) {
        point.labelLocation2 = _ChartLocation(
            rect2!.left + rect2.width + textSize2!.width + 2,
            rect2.top + rect2.height / 2 - textSize2.height / 2);
      } else if (seriesRenderer._seriesType == 'candle' &&
          !_chartState._requireInvertedAxis &&
          (point.close > point.high) == true) {
        point.labelLocation2 = _ChartLocation(
            rect2!.left + rect2.width / 2 - textSize2!.width / 2,
            rect2.top - rect2.height - textSize2.height);
      } else if (isBoxSeries &&
          !_chartState._requireInvertedAxis &&
          point.upperQuartile! > point.maximum!) {
        point.labelLocation2 = _ChartLocation(
            rect2!.left + rect2.width / 2 - textSize2!.width / 2,
            rect2.top - rect2.height - textSize2.height);
      } else {
        point.labelLocation2 = _ChartLocation(
            rect2!.left + rect2.width / 2 - textSize2!.width / 2,
            rect2.top + rect2.height / 2 - textSize2.height / 2);
      }
      point.dataLabelRegion2 = Rect.fromLTWH(point.labelLocation2!.x,
          point.labelLocation2!.y, textSize2.width, textSize2.height);
    }
    if ((seriesRenderer._seriesType.contains('candle') ||
            seriesRenderer._seriesType.contains('hilo') ||
            isBoxSeries) &&
        (rect3 != null || rect4 != null)) {
      point.labelLocation3 = _ChartLocation(
          rect3!.left + rect3.width / 2 - textSize3!.width / 2,
          rect3.top + rect3.height / 2 - textSize3.height / 2);
      point.dataLabelRegion3 = Rect.fromLTWH(point.labelLocation3!.x,
          point.labelLocation3!.y, textSize3.width, textSize3.height);
      point.labelLocation4 = _ChartLocation(
          rect4!.left + rect4.width / 2 - textSize4!.width / 2,
          rect4.top + rect4.height / 2 - textSize4.height / 2);
      point.dataLabelRegion4 = Rect.fromLTWH(point.labelLocation4!.x,
          point.labelLocation4!.y, textSize4.width, textSize4.height);
      if (rect5 != null) {
        point.labelLocation5 = _ChartLocation(
            rect5.left + rect5.width / 2 - textSize5!.width / 2,
            rect5.top + rect5.height / 2 - textSize5.height / 2);
        point.dataLabelRegion5 = Rect.fromLTWH(point.labelLocation5!.x,
            point.labelLocation5!.y, textSize5.width, textSize5.height);
      }
    }
  }
}

/// To find the position of a series to render
double _calculatePathPosition(
    double labelLocation,
    ChartDataLabelAlignment position,
    Size size,
    double borderWidth,
    CartesianSeriesRenderer seriesRenderer,
    int index,
    bool inverted,
    _ChartLocation point,
    SfCartesianChartState _chartState,
    CartesianChartPoint<dynamic> currentPoint,
    Size markerSize) {
  final XyDataSeries<dynamic, dynamic> series =
      seriesRenderer._series as XyDataSeries<dynamic, dynamic>;
  const double padding = 5;
  final bool needFill = series.dataLabelSettings.color != null ||
      series.dataLabelSettings.color != Colors.transparent ||
      series.dataLabelSettings.useSeriesColor;
  final num fillSpace = needFill ? padding : 0;
  if (seriesRenderer._seriesType.contains('area') &&
      !seriesRenderer._seriesType.contains('rangearea') &&
      seriesRenderer._yAxisRenderer!._axis.isInversed) {
    position = position == ChartDataLabelAlignment.top
        ? ChartDataLabelAlignment.bottom
        : (position == ChartDataLabelAlignment.bottom
            ? ChartDataLabelAlignment.top
            : position);
  }
  position = (_chartState._chartSeries.visibleSeriesRenderers.length == 1 &&
          (seriesRenderer._seriesType == 'stackedarea100' ||
              seriesRenderer._seriesType == 'stackedline100') &&
          position == ChartDataLabelAlignment.auto)
      ? ChartDataLabelAlignment.bottom
      : position;
  switch (position) {
    case ChartDataLabelAlignment.top:
    case ChartDataLabelAlignment.outer:
      labelLocation = labelLocation -
          markerSize.height -
          borderWidth -
          (size.height / 2) -
          padding -
          fillSpace;
      break;
    case ChartDataLabelAlignment.bottom:
      labelLocation = labelLocation +
          markerSize.height +
          borderWidth +
          (size.height / 2) +
          padding +
          fillSpace;
      break;
    case ChartDataLabelAlignment.auto:
      labelLocation = _calculatePathActualPosition(
          seriesRenderer,
          size,
          index,
          inverted,
          borderWidth,
          point,
          _chartState,
          currentPoint,
          seriesRenderer._yAxisRenderer!._axis.isInversed);
      break;
    case ChartDataLabelAlignment.middle:
      break;
  }
  return labelLocation;
}

///Below method is for dataLabel alignment calculation
double _calculateAlignment(double value, double labelLocation,
    ChartAlignment alignment, bool isMinus, bool inverted) {
  switch (alignment) {
    case ChartAlignment.far:
      labelLocation = !inverted
          ? (isMinus ? labelLocation + value : labelLocation - value)
          : (isMinus ? labelLocation - value : labelLocation + value);
      break;
    case ChartAlignment.near:
      labelLocation = !inverted
          ? (isMinus ? labelLocation - value : labelLocation + value)
          : (isMinus ? labelLocation + value : labelLocation - value);
      break;
    case ChartAlignment.center:
      labelLocation = labelLocation;
      break;
  }
  return labelLocation;
}

///Calculate label position for non rect series
double _calculatePathActualPosition(
    CartesianSeriesRenderer seriesRenderer,
    Size size,
    int index,
    bool inverted,
    double borderWidth,
    _ChartLocation point,
    SfCartesianChartState _chartState,
    CartesianChartPoint<dynamic> currentPoint,
    bool inversed) {
  final XyDataSeries<dynamic, dynamic> series =
      seriesRenderer._series as XyDataSeries<dynamic, dynamic>;
  late double yLocation;
  bool isBottom, isOverLap = true;
  Rect labelRect;
  int positionIndex;
  final ChartDataLabelAlignment position =
      _getActualPathDataLabelAlignment(seriesRenderer, index, inversed);
  isBottom = position == ChartDataLabelAlignment.bottom;
  final List<String?> dataLabelPosition = List<String?>.filled(5, null);
  dataLabelPosition[0] = 'DataLabelPosition.Outer';
  dataLabelPosition[1] = 'DataLabelPosition.Top';
  dataLabelPosition[2] = 'DataLabelPosition.Bottom';
  dataLabelPosition[3] = 'DataLabelPosition.Middle';
  dataLabelPosition[4] = 'DataLabelPosition.Auto';
  positionIndex = dataLabelPosition.indexOf(position.toString()).toInt();
  while (isOverLap && positionIndex < 4) {
    yLocation = _calculatePathPosition(
        point.y.toDouble(),
        position,
        size,
        borderWidth,
        seriesRenderer,
        index,
        inverted,
        point,
        _chartState,
        currentPoint,
        Size(
            series.markerSettings.width / 2, series.markerSettings.height / 2));
    labelRect = _calculateLabelRect(
        _ChartLocation(point.x, yLocation),
        size,
        series.dataLabelSettings.margin,
        series.dataLabelSettings.color != null ||
            series.dataLabelSettings.useSeriesColor);
    isOverLap = labelRect.top < 0 ||
        ((labelRect.top + labelRect.height) >
            _chartState._chartAxis._axisClipRect.height) ||
        _findingCollision(labelRect, _chartState._renderDatalabelRegions);
    positionIndex = isBottom ? positionIndex - 1 : positionIndex + 1;
    isBottom = false;
  }
  return yLocation;
}

/// Finding the label position for non rect series
ChartDataLabelAlignment _getActualPathDataLabelAlignment(
    CartesianSeriesRenderer seriesRenderer, int index, bool inversed) {
  final List<CartesianChartPoint<dynamic>> points = seriesRenderer._dataPoints;
  final num yValue = points[index].yValue;
  final CartesianChartPoint<dynamic>? _nextPoint =
      points.length - 1 > index ? points[index + 1] : null;
  final CartesianChartPoint<dynamic>? previousPoint =
      index > 0 ? points[index - 1] : null;
  ChartDataLabelAlignment position;
  if (seriesRenderer._seriesType == 'bubble' || index == points.length - 1) {
    position = ChartDataLabelAlignment.top;
  } else {
    if (index == 0) {
      position = (!_nextPoint!.isVisible ||
              yValue > _nextPoint.yValue ||
              (yValue < _nextPoint.yValue && inversed))
          ? ChartDataLabelAlignment.top
          : ChartDataLabelAlignment.bottom;
    } else if (index == points.length - 1) {
      position = (!previousPoint!.isVisible ||
              yValue > previousPoint.yValue ||
              (yValue < previousPoint.yValue && inversed))
          ? ChartDataLabelAlignment.top
          : ChartDataLabelAlignment.bottom;
    } else {
      if (!_nextPoint!.isVisible && !previousPoint!.isVisible) {
        position = ChartDataLabelAlignment.top;
      } else if (!_nextPoint.isVisible) {
        position = ((_nextPoint.yValue > yValue) == true ||
                (previousPoint!.yValue > yValue) == true)
            ? ChartDataLabelAlignment.bottom
            : ChartDataLabelAlignment.top;
      } else {
        final num slope = (_nextPoint.yValue - previousPoint!.yValue) / 2;
        final num intersectY =
            (slope * index) + (_nextPoint.yValue - (slope * (index + 1)));
        position = !inversed
            ? intersectY < yValue
                ? ChartDataLabelAlignment.top
                : ChartDataLabelAlignment.bottom
            : intersectY < yValue
                ? ChartDataLabelAlignment.bottom
                : ChartDataLabelAlignment.top;
      }
    }
  }
  return position;
}

/// To get the data label position
ChartDataLabelAlignment _getPosition(int position) {
  late ChartDataLabelAlignment dataLabelPosition;
  switch (position) {
    case 0:
      dataLabelPosition = ChartDataLabelAlignment.outer;
      break;
    case 1:
      dataLabelPosition = ChartDataLabelAlignment.top;
      break;
    case 2:
      dataLabelPosition = ChartDataLabelAlignment.bottom;
      break;
    case 3:
      dataLabelPosition = ChartDataLabelAlignment.middle;
      break;
    case 4:
      dataLabelPosition = ChartDataLabelAlignment.auto;
      break;
  }
  return dataLabelPosition;
}

/// getting label rect
Rect _calculateLabelRect(
    _ChartLocation location, Size textSize, EdgeInsets margin, bool needRect) {
  return needRect
      ? Rect.fromLTWH(
          location.x - (textSize.width / 2) - margin.left,
          location.y - (textSize.height / 2) - margin.top,
          textSize.width + margin.left + margin.right,
          textSize.height + margin.top + margin.bottom)
      : Rect.fromLTWH(location.x - (textSize.width / 2),
          location.y - (textSize.height / 2), textSize.width, textSize.height);
}

/// Below method is for Rendering data label
void _drawDataLabel(
    Canvas canvas,
    CartesianSeriesRenderer seriesRenderer,
    SfCartesianChartState _chartState,
    DataLabelSettings dataLabel,
    CartesianChartPoint<dynamic> point,
    int index,
    Animation<double> dataLabelAnimation,
    DataLabelSettingsRenderer dataLabelSettingsRenderer) {
  double x = 0;
  double y = 0;
  if (dataLabelSettingsRenderer._offset != null) {
    x = dataLabelSettingsRenderer._offset!.dx;
    y = dataLabelSettingsRenderer._offset!.dy;
  }
  final double opacity =
      // ignore: unnecessary_null_comparison
      seriesRenderer._needAnimateSeriesElements && dataLabelAnimation != null
          ? dataLabelAnimation.value
          : 1;
  TextStyle? dataLabelStyle;
  final String? label = point.label;
  dataLabelStyle = dataLabelSettingsRenderer._textStyle;
  if (label != null &&
      // ignore: unnecessary_null_comparison
      point != null &&
      point.isVisible &&
      point.isGap != true &&
      _isLabelWithinRange(seriesRenderer, point)) {
    final TextStyle font = (dataLabelStyle == null)
        ? const TextStyle(
            fontFamily: 'Roboto',
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal,
            fontSize: 12)
        : dataLabelStyle;
    final Color fontColor = font.color ??
        _getDataLabelSaturationColor(
            point, seriesRenderer, _chartState, dataLabelSettingsRenderer);
    final Rect labelRect = (point.labelFillRect != null)
        ? Rect.fromLTWH(point.labelFillRect!.left, point.labelFillRect!.top,
            point.labelFillRect!.width, point.labelFillRect!.height)
        : Rect.fromLTWH(point.labelLocation!.x, point.labelLocation!.y,
            point.dataLabelRegion!.width, point.dataLabelRegion!.height);
    final bool isDatalabelCollide = (_chartState._requireInvertedAxis ||
            (dataLabelSettingsRenderer._angle / 90) % 2 != 1) &&
        _findingCollision(labelRect, _chartState._renderDatalabelRegions);
    if (!(label.isNotEmpty && isDatalabelCollide)
        // ignore: unnecessary_null_comparison
        ||
        dataLabel.labelIntersectAction == null) {
      final TextStyle _textStyle = TextStyle(
          color: fontColor.withOpacity(opacity),
          fontSize: font.fontSize,
          fontFamily: font.fontFamily,
          fontStyle: font.fontStyle,
          fontWeight: font.fontWeight,
          inherit: font.inherit,
          backgroundColor: font.backgroundColor,
          letterSpacing: font.letterSpacing,
          wordSpacing: font.wordSpacing,
          textBaseline: font.textBaseline,
          height: font.height,
          locale: font.locale,
          foreground: font.foreground,
          background: font.background,
          shadows: font.shadows,
          fontFeatures: font.fontFeatures,
          decoration: font.decoration,
          decorationColor: font.decorationColor,
          decorationStyle: font.decorationStyle,
          decorationThickness: font.decorationThickness,
          debugLabel: font.debugLabel,
          fontFamilyFallback: font.fontFamilyFallback);
      _drawDataLabelRectAndText(canvas, seriesRenderer, index, dataLabel, point,
          _textStyle, opacity, label, x, y, _chartState, _chartState._chart);
      _chartState._renderDatalabelRegions.add(labelRect);
    }
  }
}

void _triggerDataLabelEvent(SfCartesianChart chart,
    List<CartesianSeriesRenderer> visibleSeriesRenderer, Offset position) {
  for (int seriesIndex = 0;
      seriesIndex < visibleSeriesRenderer.length;
      seriesIndex++) {
    final CartesianSeriesRenderer seriesRenderer =
        visibleSeriesRenderer[seriesIndex];
    final List<CartesianChartPoint<dynamic>>? dataPoints =
        seriesRenderer._visibleDataPoints;
    for (int pointIndex = 0; pointIndex < dataPoints!.length; pointIndex++) {
      if (seriesRenderer._series.dataLabelSettings.isVisible &&
          dataPoints[pointIndex].dataLabelRegion != null &&
          dataPoints[pointIndex].dataLabelRegion!.contains(position)) {
        final CartesianChartPoint<dynamic> point = dataPoints[pointIndex];
        final Offset position =
            Offset(point.labelLocation!.x, point.labelLocation!.y);
        _dataLabelTapEvent(chart, seriesRenderer._series.dataLabelSettings,
            pointIndex, point, position, seriesIndex);
        break;
      }
    }
  }
}

///Draw the datalabel text and datalabel rect
void _drawDataLabelRectAndText(
    Canvas canvas,
    CartesianSeriesRenderer seriesRenderer,
    int index,
    DataLabelSettings dataLabel,
    CartesianChartPoint<dynamic> point,
    TextStyle _textStyle,
    double opacity,
    String label,
    double x,
    double y,
    SfCartesianChartState _chartState,
    [SfCartesianChart? chart]) {
  final DataLabelSettingsRenderer dataLabelSettingsRenderer =
      seriesRenderer._dataLabelSettingsRenderer;
  final String? label2 = point.dataLabelMapper ?? point.label2;
  final String? label3 = point.dataLabelMapper ?? point.label3;
  final String? label4 = point.dataLabelMapper ?? point.label4;
  final String? label5 = point.dataLabelMapper ?? point.label5;
  final bool isRangeSeries = seriesRenderer._seriesType.contains('range') ||
      seriesRenderer._seriesType.contains('hilo') ||
      seriesRenderer._seriesType.contains('candle');
  final bool isBoxSeries = seriesRenderer._seriesType.contains('boxandwhisker');
  double padding = 0.0;
  // ignore: unnecessary_null_comparison
  if (dataLabelSettingsRenderer._angle != null &&
      dataLabelSettingsRenderer._angle > 0) {
    final Rect rect = rotatedTextSize(
        Size(point.dataLabelRegion!.width, point.dataLabelRegion!.height),
        dataLabelSettingsRenderer._angle);
    if (_chartState._chartAxis._axisClipRect.top >
        point.dataLabelRegion!.center.dy + rect.top) {
      padding = (point.dataLabelRegion!.center.dy + rect.top) -
          _chartState._chartAxis._axisClipRect.top;
    } else if (_chartState._chartAxis._axisClipRect.bottom <
        point.dataLabelRegion!.center.dy + rect.bottom) {
      padding = (point.dataLabelRegion!.center.dy + rect.bottom) -
          _chartState._chartAxis._axisClipRect.bottom;
    }
  }
  if (dataLabelSettingsRenderer._color != null ||
      dataLabel.useSeriesColor ||
      // ignore: unnecessary_null_comparison
      (dataLabel.borderColor != null && dataLabel.borderWidth > 0)) {
    final RRect fillRect = point.labelFillRect!;
    final Path path = Path();
    path.addRRect(fillRect);
    final RRect? fillRect2 = point.labelFillRect2;
    final Path path2 = Path();
    if (isRangeSeries || isBoxSeries) {
      path2.addRRect(fillRect2!);
    }
    final RRect? fillRect3 = point.labelFillRect3;
    final Path path3 = Path();
    final RRect? fillRect4 = point.labelFillRect4;
    final Path path4 = Path();
    final RRect? fillRect5 = point.labelFillRect5;
    final Path path5 = Path();
    if (seriesRenderer._seriesType.contains('hilo') ||
        seriesRenderer._seriesType.contains('candle') ||
        isBoxSeries) {
      path3.addRRect(fillRect3!);
      path4.addRRect(fillRect4!);
      if (isBoxSeries) {
        path5.addRRect(fillRect5!);
      }
    }
    // ignore: unnecessary_null_comparison
    if (dataLabel.borderColor != null && dataLabel.borderWidth > 0) {
      final Paint strokePaint = Paint()
        ..color = dataLabel.borderColor.withOpacity(
            (opacity - (1 - dataLabel.opacity)) < 0
                ? 0
                : opacity - (1 - dataLabel.opacity))
        ..strokeWidth = dataLabel.borderWidth
        ..style = PaintingStyle.stroke;
      dataLabel.borderWidth == 0
          ? strokePaint.color = Colors.transparent
          : strokePaint.color = strokePaint.color;
      canvas.save();
      canvas.translate(point.dataLabelRegion!.center.dx + x,
          point.dataLabelRegion!.center.dy - padding);
      // ignore: unnecessary_null_comparison
      if (dataLabelSettingsRenderer._angle != null &&
          dataLabelSettingsRenderer._angle > 0) {
        canvas.rotate((dataLabelSettingsRenderer._angle * math.pi) / 180);
      }
      canvas.translate(-point.dataLabelRegion!.center.dx,
          -point.dataLabelRegion!.center.dy - y);
      if (point.label!.isNotEmpty) {
        canvas.drawPath(path, strokePaint);
      }
      canvas.restore();
      if (isRangeSeries || isBoxSeries) {
        if (point.label2!.isNotEmpty) {
          canvas.drawPath(path2, strokePaint);
        }
        if (seriesRenderer._seriesType == 'hiloopenclose' ||
            seriesRenderer._seriesType.contains('candle') ||
            isBoxSeries) {
          if (point.label3!.isNotEmpty) {
            canvas.drawPath(path3, strokePaint);
          }
          if (point.label4!.isNotEmpty) {
            canvas.drawPath(path4, strokePaint);
          }
        }
        if (isBoxSeries) {
          if (point.label5!.isNotEmpty) {
            canvas.drawPath(path5, strokePaint);
          }
        }
      }
    }
    if (dataLabelSettingsRenderer._color != null || dataLabel.useSeriesColor) {
      Color? seriesColor = seriesRenderer._seriesColor!;
      if (seriesRenderer._seriesType == 'waterfall') {
        seriesColor = _getWaterfallSeriesColor(
            seriesRenderer._series as WaterfallSeries<dynamic, dynamic>,
            point,
            seriesColor);
      }
      final Paint paint = Paint()
        ..color = dataLabelSettingsRenderer._color != Colors.transparent
            ? ((dataLabelSettingsRenderer._color ??
                    (point.pointColorMapper ?? seriesColor!))
                .withOpacity((opacity - (1 - dataLabel.opacity)) < 0
                    ? 0
                    : opacity - (1 - dataLabel.opacity)))
            : Colors.transparent
        ..style = PaintingStyle.fill;
      canvas.save();
      canvas.translate(point.dataLabelRegion!.center.dx + x,
          point.dataLabelRegion!.center.dy - padding);
      // ignore: unnecessary_null_comparison
      if (dataLabelSettingsRenderer._angle != null &&
          dataLabelSettingsRenderer._angle > 0) {
        canvas.rotate((dataLabelSettingsRenderer._angle * math.pi) / 180);
      }
      canvas.translate(-point.dataLabelRegion!.center.dx,
          -point.dataLabelRegion!.center.dy - y);
      if (point.label!.isNotEmpty) {
        canvas.drawPath(path, paint);
      }
      canvas.restore();
      if (isRangeSeries || isBoxSeries) {
        if (point.label2!.isNotEmpty) {
          canvas.drawPath(path2, paint);
        }
        if (seriesRenderer._seriesType == 'hiloopenclose' ||
            seriesRenderer._seriesType.contains('candle') ||
            isBoxSeries) {
          if (point.label3!.isNotEmpty) {
            canvas.drawPath(path3, paint);
          }
          if (point.label4!.isNotEmpty) {
            canvas.drawPath(path4, paint);
          }
        }
        if (isBoxSeries) {
          if (point.label5!.isNotEmpty) {
            canvas.drawPath(path5, paint);
          }
        }
      }
    }
  }

  seriesRenderer.drawDataLabel(
      index,
      canvas,
      label,
      dataLabelSettingsRenderer._angle != 0
          ? point.dataLabelRegion!.center.dx + x
          : point.labelLocation!.x + x,
      dataLabelSettingsRenderer._angle != 0
          ? point.dataLabelRegion!.center.dy - y - padding
          : point.labelLocation!.y - y,
      dataLabelSettingsRenderer._angle,
      _textStyle);

  if (isRangeSeries || isBoxSeries) {
    if (_withInRange(isBoxSeries ? point.minimum : point.low,
        seriesRenderer._yAxisRenderer!._visibleRange!)) {
      seriesRenderer.drawDataLabel(
          index,
          canvas,
          label2!,
          point.labelLocation2!.x + x,
          point.labelLocation2!.y - y,
          dataLabelSettingsRenderer._angle,
          _textStyle);
    }
    if (seriesRenderer._seriesType == 'hiloopenclose' &&
        (label3 != null &&
                label4 != null &&
                (point.labelLocation3!.y - point.labelLocation4!.y).round() >=
                    8 ||
            (point.labelLocation4!.x - point.labelLocation3!.x).round() >=
                15)) {
      seriesRenderer.drawDataLabel(
          index,
          canvas,
          label3!,
          point.labelLocation3!.x + x,
          point.labelLocation3!.y + y,
          dataLabelSettingsRenderer._angle,
          _textStyle);
      seriesRenderer.drawDataLabel(
          index,
          canvas,
          label4!,
          point.labelLocation4!.x + x,
          point.labelLocation3!.y + y,
          dataLabelSettingsRenderer._angle,
          _textStyle);
    } else if (label3 != null &&
        label4 != null &&
        ((point.labelLocation3!.y - point.labelLocation4!.y).round() >= 8 ||
            (point.labelLocation4!.x - point.labelLocation3!.x).round() >=
                15)) {
      final Color fontColor =
          _getOpenCloseDataLabelColor(point, seriesRenderer, chart!);
      final TextStyle _textStyleOpenClose = TextStyle(
          color: fontColor.withOpacity(opacity),
          fontSize: _textStyle.fontSize,
          fontFamily: _textStyle.fontFamily,
          fontStyle: _textStyle.fontStyle,
          fontWeight: _textStyle.fontWeight,
          inherit: _textStyle.inherit,
          backgroundColor: _textStyle.backgroundColor,
          letterSpacing: _textStyle.letterSpacing,
          wordSpacing: _textStyle.wordSpacing,
          textBaseline: _textStyle.textBaseline,
          height: _textStyle.height,
          locale: _textStyle.locale,
          foreground: _textStyle.foreground,
          background: _textStyle.background,
          shadows: _textStyle.shadows,
          fontFeatures: _textStyle.fontFeatures,
          decoration: _textStyle.decoration,
          decorationColor: _textStyle.decorationColor,
          decorationStyle: _textStyle.decorationStyle,
          decorationThickness: _textStyle.decorationThickness,
          debugLabel: _textStyle.debugLabel,
          fontFamilyFallback: _textStyle.fontFamilyFallback);
      if ((point.labelLocation2!.y - point.labelLocation3!.y).abs() >= 8 ||
          (point.labelLocation2!.x - point.labelLocation3!.x).abs() >= 8) {
        seriesRenderer.drawDataLabel(
            index,
            canvas,
            label3,
            point.labelLocation3!.x + x,
            point.labelLocation3!.y + y,
            dataLabelSettingsRenderer._angle,
            _textStyleOpenClose);
      }
      if ((point.labelLocation!.y - point.labelLocation4!.y).abs() >= 8 ||
          (point.labelLocation!.x - point.labelLocation4!.x).abs() >= 8) {
        seriesRenderer.drawDataLabel(
            index,
            canvas,
            label4,
            point.labelLocation4!.x + x,
            point.labelLocation4!.y + y,
            dataLabelSettingsRenderer._angle,
            _textStyleOpenClose);
      }
      if (label5 != null && point.labelLocation5 != null) {
        seriesRenderer.drawDataLabel(
            index,
            canvas,
            label5,
            point.labelLocation5!.x + x,
            point.labelLocation5!.y + y,
            dataLabelSettingsRenderer._angle,
            _textStyleOpenClose);
      }

      if (isBoxSeries) {
        if (point.outliers!.isNotEmpty) {
          final List<_ChartLocation> outliersLocation = <_ChartLocation>[];
          final List<Size> outliersTextSize = <Size>[];
          final List<Rect> outliersRect = <Rect>[];
          const int outlierPadding = 12;
          for (int outlierIndex = 0;
              outlierIndex < point.outliers!.length;
              outlierIndex++) {
            point.outliersLabel.add(point.dataLabelMapper ??
                _getLabelText(point.outliers![outlierIndex], seriesRenderer));
            outliersTextSize.add(measureText(
                point.outliersLabel[outlierIndex],
                dataLabelSettingsRenderer._textStyle == null
                    ? const TextStyle(
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontSize: 12)
                    : dataLabelSettingsRenderer._originalStyle!));
            outliersLocation.add(_ChartLocation(
                point.outliersPoint[outlierIndex].x,
                point.outliersPoint[outlierIndex].y + outlierPadding));
            // ignore: unnecessary_null_comparison
            if (outliersLocation[outlierIndex] != null) {
              outliersRect.add(_calculateLabelRect(
                  outliersLocation[outlierIndex],
                  outliersTextSize[outlierIndex],
                  dataLabel.margin,
                  dataLabelSettingsRenderer._color != null ||
                      dataLabel.useSeriesColor));
              outliersRect[outlierIndex] = _validateRect(
                  outliersRect[outlierIndex],
                  _calculatePlotOffset(
                      _chartState._chartAxis._axisClipRect,
                      Offset(seriesRenderer._xAxisRenderer!._axis.plotOffset,
                          seriesRenderer._yAxisRenderer!._axis.plotOffset)));
            }
            if (dataLabelSettingsRenderer._color != null ||
                dataLabel.useSeriesColor ||
                // ignore: unnecessary_null_comparison
                (dataLabel.borderColor != null && dataLabel.borderWidth > 0)) {
              // ignore: unnecessary_null_comparison
              if (outliersRect[outlierIndex] != null) {
                final RRect outliersFillRect = _calculatePaddedFillRect(
                    outliersRect[outlierIndex],
                    dataLabel.borderRadius,
                    dataLabel.margin);
                if (dataLabel.margin == const EdgeInsets.all(0)) {
                  point.outliersFillRect.add(outliersFillRect);
                } else {
                  final Rect outliersRect = outliersFillRect.middleRect;
                  point.outliersLocation.add(_ChartLocation(
                      outliersRect.left +
                          outliersRect.width / 2 -
                          outliersTextSize[outlierIndex].width / 2,
                      outliersRect.top +
                          outliersRect.height / 2 -
                          outliersTextSize[outlierIndex].height / 2));
                  point.outliersDataLabelRegion.add(Rect.fromLTWH(
                      point.outliersLocation[outlierIndex].x,
                      point.outliersLocation[outlierIndex].y,
                      outliersTextSize[outlierIndex].width,
                      outliersTextSize[outlierIndex].height));
                  point.outliersFillRect
                      .add(_rectToRrect(outliersRect, dataLabel.borderRadius));
                }
                final RRect fillOutlierRect =
                    point.outliersFillRect[outlierIndex];
                final Path outlierPath = Path();
                outlierPath.addRRect(fillOutlierRect);
                final Paint paint = Paint()
                  ..color = (dataLabelSettingsRenderer._color ??
                          (point.pointColorMapper ??
                              seriesRenderer._seriesColor!))
                      .withOpacity((opacity - (1 - dataLabel.opacity)) < 0
                          ? 0
                          : opacity - (1 - dataLabel.opacity))
                  ..style = PaintingStyle.fill;
                canvas.drawPath(outlierPath, paint);
                final Paint strokePaint = Paint()
                  ..color = dataLabel.borderColor.withOpacity(
                      (opacity - (1 - dataLabel.opacity)) < 0
                          ? 0
                          : opacity - (1 - dataLabel.opacity))
                  ..strokeWidth = dataLabel.borderWidth
                  ..style = PaintingStyle.stroke;
                dataLabel.borderWidth == 0
                    ? strokePaint.color = Colors.transparent
                    : strokePaint.color = strokePaint.color;
                canvas.drawPath(outlierPath, strokePaint);
              }
            } else {
              // ignore: unnecessary_null_comparison
              if (outliersRect[outlierIndex] != null) {
                point.outliersLocation.add(_ChartLocation(
                    outliersRect[outlierIndex].left +
                        outliersRect[outlierIndex].width / 2 -
                        outliersTextSize[outlierIndex].width / 2,
                    outliersRect[outlierIndex].top +
                        outliersRect[outlierIndex].height / 2 -
                        outliersTextSize[outlierIndex].height / 2));
                point.outliersDataLabelRegion.add(Rect.fromLTWH(
                    point.outliersLocation[outlierIndex].x,
                    point.outliersLocation[outlierIndex].y,
                    outliersTextSize[outlierIndex].width,
                    outliersTextSize[outlierIndex].height));
              }
            }
            final String outlierLabel =
                point.dataLabelMapper ?? point.outliersLabel[outlierIndex];
            seriesRenderer.drawDataLabel(
                index,
                canvas,
                outlierLabel,
                point.outliersLocation[outlierIndex].x + x,
                point.outliersLocation[outlierIndex].y + y,
                dataLabelSettingsRenderer._angle,
                _textStyle);
          }
        }
      }
    }
  }
}

/// Following method returns the data label text
String _getLabelText(
    dynamic labelValue, CartesianSeriesRenderer seriesRenderer) {
  if (labelValue.toString().split('.').length > 1) {
    final String str = labelValue.toString();
    final List<String> list = str.split('.');
    labelValue = double.parse(labelValue.toStringAsFixed(6));
    if (list[1] == '0' ||
        list[1] == '00' ||
        list[1] == '000' ||
        list[1] == '0000' ||
        list[1] == '00000' ||
        list[1] == '000000') {
      labelValue = labelValue.round();
    }
  }
  final dynamic yAxis = seriesRenderer._yAxisRenderer!._axis;
  if (yAxis is NumericAxis || yAxis is LogarithmicAxis) {
    final dynamic value = yAxis?.numberFormat != null
        ? yAxis.numberFormat.format(labelValue)
        : labelValue;
    return ((yAxis.labelFormat != null && yAxis.labelFormat != '')
        ? yAxis.labelFormat.replaceAll(RegExp('{value}'), value.toString())
        : value.toString()) as String;
  } else {
    return labelValue.toString();
  }
}

/// Calculating rect position for dataLabel
double _calculateRectPosition(
    double labelLocation,
    Rect rect,
    bool isMinus,
    ChartDataLabelAlignment position,
    CartesianSeriesRenderer seriesRenderer,
    Size textSize,
    double borderWidth,
    int index,
    _ChartLocation point,
    SfCartesianChartState _chartState,
    bool inverted,
    EdgeInsets margin) {
  final XyDataSeries<dynamic, dynamic> series =
      seriesRenderer._series as XyDataSeries<dynamic, dynamic>;
  double padding;
  padding = seriesRenderer._seriesType.contains('hilo') ||
          seriesRenderer._seriesType.contains('candle') ||
          seriesRenderer._seriesType.contains('rangecolumn') ||
          seriesRenderer._seriesType.contains('boxandwhisker')
      ? 2
      : 5;
  final bool needFill = series.dataLabelSettings.color != null ||
      series.dataLabelSettings.color != Colors.transparent ||
      series.dataLabelSettings.useSeriesColor;
  final double textLength = !inverted ? textSize.height : textSize.width;
  final double extraSpace =
      borderWidth + textLength / 2 + padding + (needFill ? padding : 0);
  if (seriesRenderer._seriesType.contains('stack')) {
    position = position == ChartDataLabelAlignment.outer
        ? ChartDataLabelAlignment.top
        : position;
  }

  /// Locating the data label based on position
  switch (position) {
    case ChartDataLabelAlignment.bottom:
      labelLocation = !inverted
          ? (isMinus
              ? (labelLocation - rect.height + extraSpace)
              : (labelLocation + rect.height - extraSpace))
          : (isMinus
              ? (labelLocation + rect.width - extraSpace)
              : (labelLocation - rect.width + extraSpace));
      break;
    case ChartDataLabelAlignment.middle:
      labelLocation = !inverted
          ? (isMinus
              ? labelLocation - (rect.height / 2)
              : labelLocation + (rect.height / 2))
          : (isMinus
              ? labelLocation + (rect.width / 2)
              : labelLocation - (rect.width / 2));
      break;
    case ChartDataLabelAlignment.auto:
      labelLocation = _calculateRectActualPosition(
          labelLocation,
          rect,
          isMinus,
          seriesRenderer,
          textSize,
          index,
          point,
          inverted,
          borderWidth,
          _chartState,
          margin);
      break;
    case ChartDataLabelAlignment.top:
    case ChartDataLabelAlignment.outer:
      labelLocation = _calculateTopAndOuterPosition(
          textSize,
          labelLocation,
          rect,
          position,
          seriesRenderer,
          index,
          extraSpace,
          isMinus,
          point,
          inverted,
          borderWidth);
      break;
  }
  return labelLocation;
}

/// Calculating the label location if position is given as auto
double _calculateRectActualPosition(
    double labelLocation,
    Rect rect,
    bool minus,
    CartesianSeriesRenderer seriesRenderer,
    Size textSize,
    int index,
    _ChartLocation point,
    bool inverted,
    double borderWidth,
    SfCartesianChartState _chartState,
    EdgeInsets margin) {
  late double location;
  Rect labelRect;
  bool isOverLap = true;
  int position = 0;
  final XyDataSeries<dynamic, dynamic> series =
      seriesRenderer._series as XyDataSeries<dynamic, dynamic>;
  final int finalPosition =
      seriesRenderer._seriesType.contains('range') ? 2 : 4;
  while (isOverLap && position < finalPosition) {
    location = _calculateRectPosition(
        labelLocation,
        rect,
        minus,
        _getPosition(position),
        seriesRenderer,
        textSize,
        borderWidth,
        index,
        point,
        _chartState,
        inverted,
        margin);
    if (!inverted) {
      labelRect = _calculateLabelRect(
          _ChartLocation(point.x, location),
          textSize,
          margin,
          series.dataLabelSettings.color != null ||
              series.dataLabelSettings.useSeriesColor);
      isOverLap = labelRect.top < 0 ||
          labelRect.top > _chartState._chartAxis._axisClipRect.height ||
          ((series.dataLabelSettings.angle / 90) % 2 != 1 &&
              _findingCollision(
                  labelRect, _chartState._renderDatalabelRegions));
    } else {
      labelRect = _calculateLabelRect(
          _ChartLocation(location, point.y),
          textSize,
          margin,
          series.dataLabelSettings.color != null ||
              series.dataLabelSettings.useSeriesColor);
      isOverLap = labelRect.left < 0 ||
          labelRect.left + labelRect.width >
              _chartState._chartAxis._axisClipRect.right ||
          (series.dataLabelSettings.angle % 180 != 0 &&
              _findingCollision(
                  labelRect, _chartState._renderDatalabelRegions));
    }
    seriesRenderer._dataPoints[index].dataLabelSaturationRegionInside =
        isOverLap ||
            seriesRenderer._dataPoints[index].dataLabelSaturationRegionInside;
    position++;
  }
  return location;
}

///calculation for top and outer position of datalabel for rect series
double _calculateTopAndOuterPosition(
    Size textSize,
    double location,
    Rect rect,
    ChartDataLabelAlignment position,
    CartesianSeriesRenderer seriesRenderer,
    int index,
    double extraSpace,
    bool isMinus,
    _ChartLocation point,
    bool inverted,
    double borderWidth) {
  final XyDataSeries<dynamic, dynamic> series =
      seriesRenderer._series as XyDataSeries<dynamic, dynamic>;
  final num markerHeight =
      series.markerSettings.isVisible ? series.markerSettings.height / 2 : 0;
  if (((isMinus && !seriesRenderer._seriesType.contains('range')) &&
          position == ChartDataLabelAlignment.top) ||
      ((!isMinus || seriesRenderer._seriesType.contains('range')) &&
          position == ChartDataLabelAlignment.outer)) {
    location = !inverted
        ? location - extraSpace - markerHeight
        : location + extraSpace + markerHeight;
  } else {
    location = !inverted
        ? location + extraSpace + markerHeight
        : location - extraSpace - markerHeight;
  }
  return location;
}

/// Add padding for fill rect (if datalabel fill color is given)
RRect _calculatePaddedFillRect(Rect rect, double radius, EdgeInsets margin) {
  rect = Rect.fromLTRB(rect.left - margin.left, rect.top - margin.top,
      rect.right + margin.right, rect.bottom + margin.bottom);

  return _rectToRrect(rect, radius);
}

/// Converting rect into rounded rect
RRect _rectToRrect(Rect rect, double radius) => RRect.fromRectAndCorners(rect,
    topLeft: Radius.elliptical(radius, radius),
    topRight: Radius.elliptical(radius, radius),
    bottomLeft: Radius.elliptical(radius, radius),
    bottomRight: Radius.elliptical(radius, radius));

/// Checking the condition whether data Label has been exist in the clip rect
Rect _validateRect(Rect rect, Rect clipRect) {
  /// please don't add padding here
  double left, top;
  left = rect.left < clipRect.left ? clipRect.left : rect.left;
  top = double.parse(rect.top.toStringAsFixed(2)) < clipRect.top
      ? clipRect.top
      : rect.top;
  left -= ((double.parse(left.toStringAsFixed(2)) + rect.width) >
          clipRect.right)
      ? (double.parse(left.toStringAsFixed(2)) + rect.width) - clipRect.right
      : 0;
  top -= (double.parse(top.toStringAsFixed(2)) + rect.height) > clipRect.bottom
      ? (double.parse(top.toStringAsFixed(2)) + rect.height) - clipRect.bottom
      : 0;
  left = left < clipRect.left ? clipRect.left : left;
  rect = Rect.fromLTWH(left, top, rect.width, rect.height);
  return rect;
}

/// It returns a boolean value that labels within range or not
bool _isLabelWithinRange(CartesianSeriesRenderer seriesRenderer,
    CartesianChartPoint<dynamic> point) {
  bool withInRange = true;
  final bool isBoxSeries = seriesRenderer._seriesType.contains('boxandwhisker');
  if (seriesRenderer._yAxisRenderer is! LogarithmicAxisRenderer) {
    withInRange = _withInRange(
            point.xValue, seriesRenderer._xAxisRenderer!._visibleRange!) &&
        (seriesRenderer._seriesType.contains('range') ||
                seriesRenderer._seriesType == 'hilo'
            ? (isBoxSeries && point.minimum != null && point.maximum != null) ||
                (!isBoxSeries && point.low != null && point.high != null) &&
                    (_withInRange(isBoxSeries ? point.minimum : point.low,
                            seriesRenderer._yAxisRenderer!._visibleRange!) ||
                        _withInRange(isBoxSeries ? point.maximum : point.high,
                            seriesRenderer._yAxisRenderer!._visibleRange!))
            : seriesRenderer._seriesType == 'hiloopenclose' ||
                    seriesRenderer._seriesType.contains('candle') ||
                    isBoxSeries
                ? (_withInRange(isBoxSeries ? point.minimum : point.low,
                        seriesRenderer._yAxisRenderer!._visibleRange!) &&
                    _withInRange(isBoxSeries ? point.maximum : point.high,
                        seriesRenderer._yAxisRenderer!._visibleRange!) &&
                    _withInRange(isBoxSeries ? point.lowerQuartile : point.open,
                        seriesRenderer._yAxisRenderer!._visibleRange!) &&
                    _withInRange(
                        isBoxSeries ? point.upperQuartile : point.close,
                        seriesRenderer._yAxisRenderer!._visibleRange!))
                : _withInRange(
                    seriesRenderer._seriesType.contains('100')
                        ? point.cumulativeValue
                        : seriesRenderer._seriesType == 'waterfall'
                            ? point.endValue ?? 0
                            : point.yValue,
                    seriesRenderer._yAxisRenderer!._visibleRange!));
  }
  return withInRange;
}
