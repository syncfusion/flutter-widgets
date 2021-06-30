part of charts;

/// `onDataLabelTapped` event for all series.
void _dataLabelTapEvent(dynamic chart, DataLabelSettings dataLabelSettings,
    int pointIndex, dynamic point, Offset position, int seriesIndex) {
  DataLabelTapDetails datalabelArgs;
  datalabelArgs = DataLabelTapDetails(
      seriesIndex,
      pointIndex,
      chart is SfCartesianChart ? point.label : point.text,
      dataLabelSettings,
      chart is SfCartesianChart ? point.overallDataPointIndex : pointIndex);
  datalabelArgs.position = position;
  chart.onDataLabelTapped(datalabelArgs);
  position = datalabelArgs.position;
}

///To get saturation color
Color _getSaturationColor(Color color) {
  Color saturationColor;
  final num contrast =
      ((color.red * 299 + color.green * 587 + color.blue * 114) / 1000).round();
  saturationColor = contrast >= 128 ? Colors.black : Colors.white;
  return saturationColor;
}

/// To get point from data and return point data
CartesianChartPoint<dynamic> _getPointFromData(
    CartesianSeriesRenderer seriesRenderer, int pointIndex) {
  final XyDataSeries<dynamic, dynamic> series =
      seriesRenderer._series as XyDataSeries<dynamic, dynamic>;
  final ChartIndexedValueMapper<dynamic>? xValue = series.xValueMapper;
  final ChartIndexedValueMapper<dynamic>? yValue = series.yValueMapper;
  final dynamic xVal = xValue!(pointIndex);
  final dynamic yVal = (seriesRenderer._seriesType.contains('range') ||
          seriesRenderer._seriesType.contains('hilo') ||
          seriesRenderer._seriesType == 'candle')
      ? null
      : yValue!(pointIndex);

  final CartesianChartPoint<dynamic> point =
      CartesianChartPoint<dynamic>(xVal, yVal);
  if (seriesRenderer._seriesType.contains('range') ||
      seriesRenderer._seriesType.contains('hilo') ||
      seriesRenderer._seriesType == 'candle') {
    final ChartIndexedValueMapper<num>? highValue = series.highValueMapper;
    final ChartIndexedValueMapper<num>? lowValue = series.lowValueMapper;
    point.high = highValue!(pointIndex);
    point.low = lowValue!(pointIndex);
  }
  if (series is _FinancialSeriesBase) {
    if (seriesRenderer._seriesType == 'hiloopenclose' ||
        seriesRenderer._seriesType == 'candle') {
      final ChartIndexedValueMapper<num>? openValue = series.openValueMapper;
      final ChartIndexedValueMapper<num>? closeValue = series.closeValueMapper;
      point.open = openValue!(pointIndex);
      point.close = closeValue!(pointIndex);
    }
  }
  return point;
}

/// To return textstyle
TextStyle _getTextStyle(
    {TextStyle? textStyle,
    Color? fontColor,
    double? fontSize,
    FontStyle? fontStyle,
    String? fontFamily,
    FontWeight? fontWeight,
    Paint? background,
    bool? takeFontColorValue}) {
  if (textStyle != null) {
    return TextStyle(
      color: textStyle.color != null &&
              (takeFontColorValue == null || !takeFontColorValue)
          ? textStyle.color
          : fontColor,
      fontWeight: textStyle.fontWeight ?? fontWeight,
      fontSize: textStyle.fontSize ?? fontSize,
      fontStyle: textStyle.fontStyle ?? fontStyle,
      fontFamily: textStyle.fontFamily ?? fontFamily,
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
      fontFamilyFallback: textStyle.fontFamilyFallback,
    );
  } else {
    return TextStyle(
      color: fontColor,
      fontWeight: fontWeight,
      fontSize: fontSize,
      fontStyle: fontStyle,
      fontFamily: fontFamily,
    );
  }
}

Widget? _getElements(
    dynamic _chartState, Widget chartWidget, BoxConstraints constraints) {
  final dynamic chart = _chartState._chart;
  final _ChartLegend chartLegend = _chartState._renderingDetails.chartLegend;
  final LegendPosition legendPosition =
      _chartState._renderingDetails.legendRenderer._legendPosition;
  double legendHeight, legendWidth, chartHeight, chartWidth;
  Widget? element;

  if (chartLegend.shouldRenderLegend && chart.legend.isResponsive == true) {
    chartHeight = constraints.maxHeight - chartLegend.legendSize.height;
    chartWidth = constraints.maxWidth - chartLegend.legendSize.width;
    chartLegend.shouldRenderLegend = (legendPosition == LegendPosition.bottom ||
            legendPosition == LegendPosition.top)
        ? (chartHeight > chartLegend.legendSize.height)
        : (chartWidth > chartLegend.legendSize.width);
  }
  if (!chartLegend.shouldRenderLegend) {
    element = Container(
        child: chartWidget,
        width: constraints.maxWidth,
        height: constraints.maxHeight);
  } else {
    legendHeight = chartLegend.legendSize.height;
    legendWidth = chartLegend.legendSize.width;
    chartHeight = chartLegend.chartSize.height - legendHeight;
    chartWidth = chartLegend.chartSize.width - legendWidth;
    final Widget legendBorderWidget =
        CustomPaint(painter: _ChartLegendStylePainter(chartState: _chartState));
    final Widget legendWidget = Container(
        height: legendHeight,
        width: legendWidth,
        decoration: BoxDecoration(color: chart.legend.backgroundColor),
        child: _LegendContainer(chartState: _chartState));
    switch (legendPosition) {
      case LegendPosition.bottom:
      case LegendPosition.top:
        element = _getBottomAndTopLegend(
            _chartState,
            chartWidget,
            constraints,
            legendWidget,
            legendBorderWidget,
            legendHeight,
            legendWidth,
            chartHeight);
        break;
      case LegendPosition.right:
      case LegendPosition.left:
        element = _getLeftAndRightLegend(
            _chartState,
            chartWidget,
            constraints,
            legendWidget,
            legendBorderWidget,
            legendHeight,
            legendWidth,
            chartWidth);
        break;
      case LegendPosition.auto:
        break;
    }
  }
  return element!;
}

Widget _getBottomAndTopLegend(
    dynamic _chartState,
    Widget chartWidget,
    BoxConstraints constraints,
    Widget legendWidget,
    Widget legendBorderWidget,
    double legendHeight,
    double legendWidth,
    double chartHeight) {
  Widget element;
  final dynamic chart = _chartState._chart;
  const double legendPadding = 5;
  const double padding = 10;
  final bool needPadding = chart is SfCircularChart ||
      chart is SfPyramidChart ||
      chart is SfFunnelChart;
  final _ChartLegend chartLegend = _chartState._renderingDetails.chartLegend;
  final LegendPosition legendPosition =
      _chartState._renderingDetails.legendRenderer._legendPosition;
  final double legendLeft = (chartLegend.chartSize.width < legendWidth)
      ? 0
      : ((chart.legend.alignment == ChartAlignment.near)
          ? 0
          : (chart.legend.alignment == ChartAlignment.center)
              ? chartLegend.chartSize.width / 2 -
                  chartLegend.legendSize.width / 2
              : chartLegend.chartSize.width - chartLegend.legendSize.width);
  bool needRender = true;
  final EdgeInsets margin;
  if (chartLegend.legend?.offset != null) {
    if (chart.legend.offset.dx.isNegative == true) {
      if (legendLeft + chart.legend.offset.dx < 0) {
        needRender = false;
      } else {
        if (legendLeft + chart.legend.offset.dx > chartLegend.chartSize.width) {
          needRender = false;
        }
      }
    }
    if (legendPosition == LegendPosition.top) {
      if (chart.legend.offset.dy.isNegative == true) {
        if (legendPadding + chart.legend.offset.dy < 0) {
          needRender = false;
        }
      } else {
        if (legendPadding + chart.legend.offset.dy >
            chartLegend.chartSize.height) {
          needRender = false;
        }
      }
    } else if (legendPosition == LegendPosition.bottom) {
      if (chart.legend.offset.dy.isNegative == true) {
        if (chartHeight + legendPadding + chart.legend.offset.dy < 0) {
          needRender = false;
        }
      } else {
        if (chartHeight +
                legendPadding +
                chart.legend.offset.dy +
                legendHeight / 2 >
            chartLegend.chartSize.height) {
          needRender = false;
        }
      }
    }
  }
  if (chartLegend.legend?.offset == null) {
    margin = (legendPosition == LegendPosition.top)
        ? EdgeInsets.fromLTRB(
            legendLeft + (needPadding ? padding : 0), legendPadding, 0, 0)
        : EdgeInsets.fromLTRB(legendLeft, chartHeight + legendPadding, 0, 0);
  } else {
    if (needRender) {
      margin = (legendPosition == LegendPosition.top)
          ? EdgeInsets.fromLTRB(
              legendLeft + (needPadding ? padding : 0) + chart.legend.offset.dx,
              legendPadding + chart.legend.offset.dy,
              0,
              0)
          : EdgeInsets.fromLTRB(legendLeft + chart.legend.offset.dx,
              chartHeight + legendPadding + chart.legend.offset.dy, 0, 0);
    } else {
      margin = const EdgeInsets.all(0);
    }
  }
  legendWidget = Container(
    child: Stack(children: <Widget>[
      Container(
          margin: margin,
          height: legendHeight,
          width: legendWidth,
          child: legendBorderWidget),
      Container(
          margin: margin,
          height: legendHeight,
          width: legendWidth,
          child: legendWidget)
    ]),
  );
  if (legendPosition == LegendPosition.top) {
    if (chartLegend.legend?.offset == null) {
      element = Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Stack(
            children: <Widget>[
              legendWidget,
              Container(
                margin: EdgeInsets.fromLTRB(
                    needPadding ? padding : 0, legendHeight + padding, 0, 0),
                height: chartHeight,
                width: chartLegend.chartSize.width,
                child: chartWidget,
              )
            ],
          ));
    } else {
      if (needRender) {
        element = Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Stack(
              children: <Widget>[
                chartWidget,
                legendWidget,
              ],
            ));
      } else {
        element = Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: chartWidget,
        );
      }
    }
  } else {
    if (chartLegend.legend?.offset == null) {
      element = Container(
          margin: EdgeInsets.fromLTRB(
              needPadding ? padding : 0, needPadding ? padding : 0, 0, 0),
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Stack(
            children: <Widget>[
              Container(
                height: chartHeight,
                width: chartLegend.chartSize.width,
                child: chartWidget,
              ),
              legendWidget,
            ],
          ));
    } else {
      if (needRender) {
        element = Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Stack(
              children: <Widget>[
                chartWidget,
                legendWidget,
              ],
            ));
      } else {
        element = Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: chartWidget,
        );
      }
    }
  }
  return element;
}

/// To return top and bottom position legend widget
Widget _getLeftAndRightLegend(
    dynamic _chartState,
    Widget chartWidget,
    BoxConstraints constraints,
    Widget legendWidget,
    Widget legendBorderWidget,
    double legendHeight,
    double legendWidth,
    double chartWidth) {
  Widget element;
  const double legendPadding = 5;
  const double padding = 10;
  final dynamic chart = _chartState._chart;
  bool needRender = true;
  final bool needPadding = chart is SfCircularChart ||
      chart is SfPyramidChart ||
      chart is SfFunnelChart;
  final _ChartLegend chartLegend = _chartState._renderingDetails.chartLegend;
  final LegendPosition legendPosition =
      _chartState._renderingDetails.legendRenderer._legendPosition;
  final double legendTop = (chartLegend.chartSize.height < legendHeight)
      ? 0
      : ((chart.legend.alignment == ChartAlignment.near)
          ? 0
          : (chart.legend.alignment == ChartAlignment.center)
              ? chartLegend.chartSize.height / 2 -
                  chartLegend.legendSize.height / 2
              : chartLegend.chartSize.height - chartLegend.legendSize.height);
  final EdgeInsets margin;

  if (chartLegend.legend?.offset != null) {
    if (legendPosition == LegendPosition.left) {
      if (chart.legend.offset.dx.isNegative == true) {
        if (legendPadding / 2 + chart.legend.offset.dx < legendPadding) {
          needRender = false;
        }
      } else {
        if (chart.legend.offset.dx > chartWidth == true) {
          needRender = false;
        }
      }
    } else if (legendPosition == LegendPosition.right) {
      if (chart.legend.offset.dx.isNegative == true) {
        if (chartWidth + legendPadding + chart.legend.offset.dx < 0) {
          needRender = false;
        }
      } else {
        if (chartWidth + chart.legend.offset.dx - legendPadding > chartWidth) {
          needRender = false;
        }
      }
    }

    if (chart.legend.offset.dy.isNegative == true) {
      if (legendTop + chart.legend.offset.dy < 0) {
        needRender = false;
      }
    } else {
      if (chart.legend.offset.dy + legendTop > chartLegend.chartSize.height ==
          true) {
        needRender = false;
      }
    }
  }
  if (chartLegend.legend?.offset == null) {
    margin = (legendPosition == LegendPosition.left)
        ? EdgeInsets.fromLTRB(legendPadding / 2, legendTop, 0, 0)
        : EdgeInsets.fromLTRB(chartWidth + legendPadding, legendTop, 0, 0);
  } else {
    if (needRender) {
      margin = (legendPosition == LegendPosition.left)
          ? EdgeInsets.fromLTRB(legendPadding / 2 + chart.legend.offset.dx,
              legendTop + chart.legend.offset.dy, 0, 0)
          : EdgeInsets.fromLTRB(
              chartWidth + legendPadding + chart.legend.offset.dx,
              legendTop + chart.legend.offset.dy,
              0,
              0);
    } else {
      margin = const EdgeInsets.all(0);
    }
  }
  legendWidget = Container(
    child: Stack(children: <Widget>[
      Container(
        margin: margin,
        height: legendHeight,
        width: legendWidth,
        child: legendBorderWidget,
      ),
      Container(
        margin: margin,
        height: legendHeight,
        width: legendWidth,
        child: legendWidget,
      )
    ]),
  );
  if (legendPosition == LegendPosition.left) {
    if (chartLegend.legend?.offset == null) {
      element = Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Stack(
            children: <Widget>[
              legendWidget,
              Container(
                margin: EdgeInsets.fromLTRB(
                    legendWidth + (needPadding ? padding : 0),
                    needPadding ? chart.margin.top : 0,
                    0,
                    0),
                height: chartLegend.chartSize.height,
                width: chartWidth,
                child: chartWidget,
              )
            ],
          ));
    } else {
      if (needRender) {
        element = Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Stack(
              children: <Widget>[
                chartWidget,
                legendWidget,
              ],
            ));
      } else {
        element = Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: chartWidget,
        );
      }
    }
  } else {
    if (chartLegend.legend?.offset == null) {
      element = Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Stack(
            children: <Widget>[
              Container(
                margin:
                    EdgeInsets.only(top: needPadding ? chart.margin.top : 0),
                height: chartLegend.chartSize.height,
                width: chartWidth,
                child: chartWidget,
              ),
              legendWidget
            ],
          ));
    } else {
      if (needRender) {
        element = Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Stack(
              children: <Widget>[
                chartWidget,
                legendWidget,
              ],
            ));
      } else {
        element = Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: chartWidget,
        );
      }
    }
  }
  return element;
}

class _MeasureWidgetSize extends StatelessWidget {
  const _MeasureWidgetSize(
      {this.chartState,
      this.currentWidget,
      this.opacityValue,
      this.currentKey,
      this.seriesIndex,
      this.pointIndex,
      this.type});
  final dynamic chartState;
  final Widget? currentWidget;
  final double? opacityValue;
  final Key? currentKey;
  final int? seriesIndex;
  final int? pointIndex;
  final String? type;
  @override
  Widget build(BuildContext context) {
    final List<_MeasureWidgetContext> templates =
        chartState._renderingDetails.legendWidgetContext;
    templates.add(_MeasureWidgetContext(
        widget: currentWidget,
        key: currentKey,
        context: context,
        seriesIndex: seriesIndex,
        pointIndex: pointIndex));
    return Container(
        key: currentKey,
        child: Opacity(opacity: opacityValue!, child: currentWidget));
  }
}

/// To return legend template toggled state
bool _legendToggleTemplateState(
    _MeasureWidgetContext currentItem, dynamic _chartState, String checkType) {
  bool needSelect = false;
  final List<_MeasureWidgetContext> legendToggles =
      _chartState._renderingDetails.legendToggleTemplateStates;
  if (legendToggles.isNotEmpty) {
    for (int i = 0; i < legendToggles.length; i++) {
      final _MeasureWidgetContext item = legendToggles[i];
      if (currentItem.seriesIndex == item.seriesIndex &&
          currentItem.pointIndex == item.pointIndex) {
        if (checkType != 'isSelect') {
          needSelect = true;
          legendToggles.removeAt(i);
        }
        break;
      }
    }
  }
  if (!needSelect) {
    needSelect = false;
    if (checkType != 'isSelect') {
      legendToggles.add(currentItem);
    }
  }
  return needSelect;
}

/// To add legend toggle states in legend toggles list
void _legendToggleState(_LegendRenderContext currentItem, dynamic _chartState) {
  bool needSelect = false;
  final List<_LegendRenderContext> legendToggles =
      _chartState._renderingDetails.legendToggleStates;
  if (legendToggles.isNotEmpty) {
    for (int i = 0; i < legendToggles.length; i++) {
      final _LegendRenderContext item = legendToggles[i];
      if (currentItem.seriesIndex == item.seriesIndex) {
        needSelect = true;
        legendToggles.removeAt(i);
        break;
      }
    }
  }
  if (!needSelect) {
    needSelect = false;
    legendToggles.add(currentItem);
  }
}

/// To add cartesian legend toggle states
void _cartesianLegendToggleState(
    _LegendRenderContext currentItem, dynamic _chartState) {
  bool needSelect = false;
  final List<_LegendRenderContext> legendToggles =
      _chartState._renderingDetails.legendToggleStates;
  if (currentItem.trendline == null ||
      _chartState._chartSeries.visibleSeriesRenderers[currentItem.seriesIndex]
              ._visible ==
          true) {
    if (legendToggles.isNotEmpty) {
      for (int i = 0; i < legendToggles.length; i++) {
        final _LegendRenderContext item = legendToggles[i];
        if (currentItem.trendline != null &&
            currentItem.text == item.text &&
            (currentItem.seriesIndex == item.seriesIndex &&
                currentItem.trendlineIndex == item.trendlineIndex)) {
          needSelect = true;
          legendToggles.removeAt(i);
          break;
        } else if (currentItem.trendline == null &&
            currentItem.seriesIndex == item.seriesIndex &&
            currentItem.text == item.text) {
          needSelect = true;
          legendToggles.removeAt(i);
          break;
        }
      }
    }
    if (!needSelect) {
      if (!(currentItem.seriesRenderer is TechnicalIndicators
          ? !currentItem.indicatorRenderer!._visible!
          : currentItem.seriesRenderer._visible == false &&
              _chartState._isTrendlineToggled == false)) {
        needSelect = false;
        final CartesianSeriesRenderer seriesRenderer = _chartState
            ._chartSeries.visibleSeriesRenderers[currentItem.seriesIndex];
        if (currentItem.trendlineIndex != null) {
          seriesRenderer._minimumX = 1 / 0;
          seriesRenderer._minimumY = 1 / 0;
          seriesRenderer._maximumX = -1 / 0;
          seriesRenderer._maximumY = -1 / 0;
        }
        _chartState._chartSeries
            .visibleSeriesRenderers[currentItem.seriesIndex] = seriesRenderer;
        if (!legendToggles.contains(currentItem)) {
          legendToggles.add(currentItem);
        }
      }
    }
  }
}

/// For checking whether elements collide
bool _findingCollision(Rect rect, List<Rect> regions, [Rect? pathRect]) {
  bool isCollide = false;
  if (pathRect != null &&
      (pathRect.left < rect.left &&
          pathRect.width > rect.width &&
          pathRect.top < rect.top &&
          pathRect.height > rect.height)) {
    isCollide = false;
  } else if (pathRect != null) {
    isCollide = true;
  }
  for (int i = 0; i < regions.length; i++) {
    final Rect regionRect = regions[i];
    if ((rect.left < regionRect.left + regionRect.width &&
            rect.left + rect.width > regionRect.left) &&
        (rect.top < regionRect.top + regionRect.height &&
            rect.top + rect.height > regionRect.top)) {
      isCollide = true;
      break;
    }
  }
  return isCollide;
}

/// To get equivalent value for the percentage
num _getValueByPercentage(num value1, num value2) {
  return value1.isNegative
      ? (num.tryParse('-' +
          (num.tryParse(value1.toString().replaceAll(RegExp('-'), ''))! %
                  value2)
              .toString()))!
      : (value1 % value2);
}

Widget _renderChartTitle(dynamic _chartState) {
  Widget titleWidget;
  final dynamic widget = _chartState._chart;
  if (widget.title.text != null && widget.title.text.isNotEmpty == true) {
    final SfChartThemeData chartTheme =
        _chartState._renderingDetails.chartTheme;
    final Color color =
        widget.title.textStyle.color ?? chartTheme.titleTextColor;
    final double fontSize = widget.title.textStyle.fontSize;
    final String fontFamily = widget.title.textStyle.fontFamily;
    final FontStyle fontStyle = widget.title.textStyle.fontStyle;
    final FontWeight fontWeight = widget.title.textStyle.fontWeight;
    titleWidget = Container(
      margin: EdgeInsets.fromLTRB(widget.margin.left, widget.margin.top,
          widget.margin.right, widget.margin.bottom),
      child: Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          decoration: BoxDecoration(
              color: widget.title.backgroundColor ??
                  chartTheme.titleBackgroundColor,
              border: Border.all(
                  color: widget.title.borderColor ?? chartTheme.titleTextColor,
                  width: widget.title.borderWidth)),
          child: Text(widget.title.text,
              style: TextStyle(
                  color: color,
                  fontSize: fontSize,
                  fontFamily: fontFamily,
                  fontStyle: fontStyle,
                  fontWeight: fontWeight),
              textScaleFactor: 1.2,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center)),
      alignment: (widget.title.alignment == ChartAlignment.near)
          ? Alignment.topLeft
          : (widget.title.alignment == ChartAlignment.far)
              ? Alignment.topRight
              : (widget.title.alignment == ChartAlignment.center)
                  ? Alignment.topCenter
                  : Alignment.topCenter,
    );
  } else {
    titleWidget = Container();
  }
  return titleWidget;
}

/// To get the legend template widgets
List<Widget> _bindLegendTemplateWidgets(dynamic widgetState) {
  Widget legendWidget;
  final dynamic widget = widgetState._chart;
  final List<Widget> templates = <Widget>[];
  widgetState._renderingDetails.chartWidgets = <Widget>[];

  if (widget.legend.isVisible == true &&
      widget.legend.legendItemBuilder != null) {
    for (int i = 0;
        i < widgetState._chartSeries.visibleSeriesRenderers.length;
        i++) {
      final dynamic seriesRenderer =
          widgetState._chartSeries.visibleSeriesRenderers[i];
      for (int j = 0; j < seriesRenderer._renderPoints.length; j++) {
        legendWidget = widget.legend.legendItemBuilder(
            seriesRenderer._renderPoints[j].x,
            seriesRenderer,
            seriesRenderer._renderPoints[j],
            j);
        templates.add(_MeasureWidgetSize(
            chartState: widgetState,
            type: 'Legend',
            seriesIndex: i,
            pointIndex: j,
            currentKey: GlobalKey(),
            currentWidget: legendWidget,
            opacityValue: 0.0));
      }
    }
  }
  return templates;
}

/// To check whether indexes are valid
bool _validIndex(int? _pointIndex, int? _seriesIndex, dynamic chart) {
  return _seriesIndex != null &&
      _pointIndex != null &&
      _seriesIndex >= 0 &&
      _seriesIndex < chart.series.length &&
      _pointIndex >= 0 &&
      _pointIndex < chart.series[_seriesIndex].dataSource.length;
}

//this method removes the given listener from the animation controller and then dsiposes it.
void _disposeAnimationController(
    AnimationController? animationController, VoidCallback listener) {
  if (animationController != null) {
    animationController.removeListener(listener);
    animationController.dispose();
    animationController = null;
  }
}

void _calculatePointSeriesIndex(
    dynamic chart, dynamic _chartState, Offset? position,
    [_Region? pointRegion, ActivationMode? activationMode]) {
  if (chart is SfCartesianChart) {
    for (int i = 0;
        i < _chartState._chartSeries.visibleSeriesRenderers.length;
        i++) {
      final CartesianSeriesRenderer seriesRenderer =
          _chartState._chartSeries.visibleSeriesRenderers[i];
      final String _seriesType = seriesRenderer._seriesType;
      int? pointIndex;
      final double padding = (_seriesType == 'bubble') ||
              (_seriesType == 'scatter') ||
              (_seriesType == 'bar') ||
              (_seriesType == 'column' ||
                  _seriesType == 'rangecolumn' ||
                  _seriesType.contains('stackedcolumn') ||
                  _seriesType.contains('stackedbar') ||
                  _seriesType == 'waterfall')
          ? 0
          : 15;

      /// Regional padding to detect smooth touch
      seriesRenderer._regionalData!
          .forEach((dynamic regionRect, dynamic values) {
        final Rect region = regionRect[0];
        final double left = region.left - padding;
        final double right = region.right + padding;
        final double top = region.top - padding;
        final double bottom = region.bottom + padding;
        final Rect paddedRegion = Rect.fromLTRB(left, top, right, bottom);
        if (paddedRegion.contains(position!)) {
          pointIndex = regionRect[4].visiblePointIndex;
        }
      });

      if (pointIndex != null) {
        if ((seriesRenderer._series.onPointTap != null ||
                seriesRenderer._series.onPointDoubleTap != null ||
                seriesRenderer._series.onPointLongPress != null) &&
            activationMode != null) {
          ChartPointDetails pointInteractionDetails;
          pointInteractionDetails = ChartPointDetails(
              i,
              pointIndex!,
              seriesRenderer._dataPoints,
              seriesRenderer
                  ._visibleDataPoints![pointIndex!].overallDataPointIndex);
          activationMode == ActivationMode.singleTap
              ? seriesRenderer._series.onPointTap!(pointInteractionDetails)
              : activationMode == ActivationMode.doubleTap
                  ? seriesRenderer
                      ._series.onPointDoubleTap!(pointInteractionDetails)
                  : seriesRenderer
                      ._series.onPointLongPress!(pointInteractionDetails);
        } else {
          PointTapArgs pointTapArgs;
          pointTapArgs = PointTapArgs(
              i,
              pointIndex!,
              seriesRenderer._dataPoints,
              seriesRenderer
                  ._visibleDataPoints![pointIndex!].overallDataPointIndex);
          chart.onPointTapped!(pointTapArgs);
        }
      }
    }
  } else if (chart is SfCircularChart) {
    const int seriesIndex = 0;
    if ((chart.series[seriesIndex].onPointTap != null ||
            chart.series[seriesIndex].onPointDoubleTap != null ||
            chart.series[seriesIndex].onPointLongPress != null) &&
        activationMode != null) {
      ChartPointDetails pointInteractionDetails;
      pointInteractionDetails = ChartPointDetails(
          pointRegion?.seriesIndex,
          pointRegion?.pointIndex,
          _chartState
              ._chartSeries.visibleSeriesRenderers[seriesIndex]._dataPoints,
          pointRegion?.pointIndex);
      activationMode == ActivationMode.singleTap
          ? chart.series[seriesIndex].onPointTap!(pointInteractionDetails)
          : activationMode == ActivationMode.doubleTap
              ? chart.series[seriesIndex]
                  .onPointDoubleTap!(pointInteractionDetails)
              : chart.series[seriesIndex]
                  .onPointLongPress!(pointInteractionDetails);
    } else {
      PointTapArgs pointTapArgs;
      pointTapArgs = PointTapArgs(
          pointRegion?.seriesIndex,
          pointRegion?.pointIndex,
          _chartState
              ._chartSeries.visibleSeriesRenderers[seriesIndex]._dataPoints,
          pointRegion?.pointIndex);
      chart.onPointTapped!(pointTapArgs);
    }
  } else {
    int? index;
    const int seriesIndex = 0;
    for (int i = 0; i < _chartState._renderPoints!.length; i++) {
      if (_chartState._renderPoints![i].region != null &&
          _chartState._renderPoints![i].region!.contains(position) == true) {
        index = i;
        break;
      }
    }
    if (index != null) {
      if ((chart.series.onPointTap != null ||
              chart.series.onPointDoubleTap != null ||
              chart.series.onPointLongPress != null) &&
          activationMode != null) {
        ChartPointDetails pointInteractionDetails;
        pointInteractionDetails = ChartPointDetails(
            seriesIndex, index, _chartState._dataPoints, index);
        activationMode == ActivationMode.singleTap
            ? chart.series.onPointTap!(pointInteractionDetails)
            : activationMode == ActivationMode.doubleTap
                ? chart.series.onPointDoubleTap!(pointInteractionDetails)
                : chart.series.onPointLongPress!(pointInteractionDetails);
      } else {
        PointTapArgs pointTapArgs;
        pointTapArgs =
            PointTapArgs(seriesIndex, index, _chartState._dataPoints, index);
        chart.onPointTapped!(pointTapArgs);
      }
    }
  }
}
