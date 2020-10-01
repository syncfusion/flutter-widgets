part of charts;

///Signature for callback reporting that a data label is tapped.
///
///Also refer [onDataLabelTapped] event and [DataLabelTapDetails] class.
typedef DataLabelTapCallback = void Function(DataLabelTapDetails onTapArgs);

/// [onDataLabelTapped] event for all series.
void _dataLabelTapEvent(dynamic chart, DataLabelSettings dataLabelSettings,
    int pointIndex, dynamic point, Offset position) {
  DataLabelTapDetails datalabelArgs;
  datalabelArgs = DataLabelTapDetails(0, pointIndex,
      chart is SfCartesianChart ? point.label : point.text, dataLabelSettings);
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
  final XyDataSeries<dynamic, dynamic> series = seriesRenderer._series;
  final ChartIndexedValueMapper<dynamic> xValue = series.xValueMapper;
  final ChartIndexedValueMapper<dynamic> yValue = series.yValueMapper;
  final dynamic xVal = xValue(pointIndex);
  final dynamic yVal = (seriesRenderer._seriesType.contains('range') ||
          seriesRenderer._seriesType.contains('hilo') ||
          seriesRenderer._seriesType == 'candle')
      ? null
      : yValue(pointIndex);

  final CartesianChartPoint<dynamic> point =
      CartesianChartPoint<dynamic>(xVal, yVal);
  if (seriesRenderer._seriesType.contains('range') ||
      seriesRenderer._seriesType.contains('hilo') ||
      seriesRenderer._seriesType == 'candle') {
    final ChartIndexedValueMapper<num> highValue = series.highValueMapper;
    final ChartIndexedValueMapper<num> lowValue = series.lowValueMapper;
    point.high = highValue(pointIndex);
    point.low = lowValue(pointIndex);
  }
  if (series is _FinancialSeriesBase) {
    if (seriesRenderer._seriesType == 'hiloopenclose' ||
        seriesRenderer._seriesType == 'candle') {
      final ChartIndexedValueMapper<num> openValue = series.openValueMapper;
      final ChartIndexedValueMapper<num> closeValue = series.closeValueMapper;
      point.open = openValue(pointIndex);
      point.close = closeValue(pointIndex);
    }
  }
  return point;
}

/// To return textstyle
TextStyle _getTextStyle(
    {TextStyle textStyle,
    Color fontColor,
    double fontSize,
    FontStyle fontStyle,
    String fontFamily,
    FontWeight fontWeight,
    Paint background,
    bool takeFontColorValue}) {
  if (textStyle != null) {
    return TextStyle(
      color: textStyle.color != null &&
              (takeFontColorValue == null ? true : !takeFontColorValue)
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

Widget _getElements(
    dynamic _chartState, Widget chartWidget, BoxConstraints constraints) {
  final dynamic chart = _chartState._chart;
  final LegendPosition legendPosition =
      _chartState._legendRenderer._legendPosition;
  double legendHeight, legendWidth, chartHeight, chartWidth;
  Widget element;
  if (_chartState._chartLegend.shouldRenderLegend &&
      chart.legend.isResponsive) {
    chartHeight =
        constraints.maxHeight - _chartState._chartLegend.legendSize.height;
    chartWidth =
        constraints.maxWidth - _chartState._chartLegend.legendSize.width;
    _chartState._chartLegend.shouldRenderLegend =
        (legendPosition == LegendPosition.bottom ||
                legendPosition == LegendPosition.top)
            ? (chartHeight > _chartState._chartLegend.legendSize.height)
            : (chartWidth > _chartState._chartLegend.legendSize.width);
  }
  if (!_chartState._chartLegend.shouldRenderLegend) {
    element = Container(
        child: chartWidget,
        width: constraints.maxWidth,
        height: constraints.maxHeight);
  } else {
    legendHeight = _chartState._chartLegend.legendSize.height;
    legendWidth = _chartState._chartLegend.legendSize.width;
    chartHeight = _chartState._chartLegend.chartSize.height - legendHeight;
    chartWidth = _chartState._chartLegend.chartSize.width - legendWidth;
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
  return element;
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
  final LegendPosition legendPosition =
      _chartState._legendRenderer._legendPosition;
  final double legendLeft =
      (_chartState._chartLegend.chartSize.width < legendWidth)
          ? 0
          : ((chart.legend.alignment == ChartAlignment.near)
              ? 0
              : (chart.legend.alignment == ChartAlignment.center)
                  ? _chartState._chartLegend.chartSize.width / 2 -
                      _chartState._chartLegend.legendSize.width / 2
                  : _chartState._chartLegend.chartSize.width -
                      _chartState._chartLegend.legendSize.width);
  final EdgeInsets margin = (legendPosition == LegendPosition.top)
      ? EdgeInsets.fromLTRB(
          legendLeft + (needPadding ? padding : 0), legendPadding, 0, 0)
      : EdgeInsets.fromLTRB(legendLeft, chartHeight + legendPadding, 0, 0);
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
              width: _chartState._chartLegend.chartSize.width,
              child: chartWidget,
            )
          ],
        ));
  } else {
    element = Container(
        margin: EdgeInsets.fromLTRB(
            needPadding ? padding : 0, needPadding ? padding : 0, 0, 0),
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        child: Stack(
          children: <Widget>[
            Container(
              height: chartHeight,
              width: _chartState._chartLegend.chartSize.width,
              child: chartWidget,
            ),
            legendWidget
          ],
        ));
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
  final bool needPadding = chart is SfCircularChart ||
      chart is SfPyramidChart ||
      chart is SfFunnelChart;
  final LegendPosition legendPosition =
      _chartState._legendRenderer._legendPosition;
  final double legendTop =
      (_chartState._chartLegend.chartSize.height < legendHeight)
          ? 0
          : ((chart.legend.alignment == ChartAlignment.near)
              ? 0
              : (chart.legend.alignment == ChartAlignment.center)
                  ? _chartState._chartLegend.chartSize.height / 2 -
                      _chartState._chartLegend.legendSize.height / 2
                  : _chartState._chartLegend.chartSize.height -
                      _chartState._chartLegend.legendSize.height);
  final EdgeInsets margin = (legendPosition == LegendPosition.left)
      ? EdgeInsets.fromLTRB(legendPadding / 2, legendTop, 0, 0)
      : EdgeInsets.fromLTRB(chartWidth + legendPadding, legendTop, 0, 0);
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
              height: _chartState._chartLegend.chartSize.height,
              width: chartWidth,
              child: chartWidget,
            )
          ],
        ));
  } else {
    element = Container(
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: needPadding ? chart.margin.top : 0),
              height: _chartState._chartLegend.chartSize.height,
              width: chartWidth,
              child: chartWidget,
            ),
            legendWidget
          ],
        ));
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
  final Widget currentWidget;
  final double opacityValue;
  final Key currentKey;
  final int seriesIndex;
  final int pointIndex;
  final String type;
  @override
  Widget build(BuildContext context) {
    final List<_MeasureWidgetContext> templates =
        chartState._legendWidgetContext;
    templates.add(_MeasureWidgetContext(
        widget: currentWidget,
        key: currentKey,
        context: context,
        seriesIndex: seriesIndex,
        pointIndex: pointIndex));
    return Container(
        key: currentKey,
        child: Opacity(opacity: opacityValue, child: currentWidget));
  }
}

/// To return legend template toggled state
bool _legendToggleTemplateState(
    _MeasureWidgetContext currentItem, dynamic _chartState, String checkType) {
  bool needSelect = false;
  final List<_MeasureWidgetContext> legendToggles =
      _chartState._legendToggleTemplateStates;
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
      _chartState._legendToggleStates;
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
      _chartState._legendToggleStates;
  if (currentItem.trendline == null ||
      _chartState._chartSeries.visibleSeriesRenderers[currentItem.seriesIndex]
          ._visible) {
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
          ? !currentItem.indicatorRenderer._visible
          : !currentItem.seriesRenderer._visible &&
              !_chartState._isTrendlineToggled)) {
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
bool _findingCollision(Rect rect, List<Rect> regions, [Rect pathRect]) {
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
  num value;
  value = value1.isNegative
      ? (num.tryParse('-' +
          (num.tryParse(value1.toString().replaceAll(RegExp('-'), '')) % value2)
              .toString()))
      : (value1 % value2);
  return value;
}

Widget _renderChartTitle(dynamic _chartState) {
  Widget titleWidget;
  final dynamic widget = _chartState._chart;
  if (widget.title.text != null && widget.title.text.isNotEmpty) {
    final Color color =
        widget.title.textStyle.color ?? _chartState._chartTheme.titleTextColor;
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
                  _chartState._chartTheme.titleBackgroundColor,
              border: Border.all(
                  color: widget.title.borderColor ??
                      _chartState._chartTheme.titleTextColor,
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
  widgetState._chartWidgets = <Widget>[];
  if (widget.legend.isVisible && widget.legend.legendItemBuilder != null) {
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
bool _validIndex(int _pointIndex, int _seriesIndex, dynamic chart) {
  return _seriesIndex != null &&
      _pointIndex != null &&
      _seriesIndex >= 0 &&
      _seriesIndex < chart.series.length &&
      _pointIndex >= 0 &&
      _pointIndex < chart.series[_seriesIndex].dataSource.length;
}

//this method removes the given listener from the animation controller and then dsiposes it.
void _disposeAnimationController(
    AnimationController animationController, VoidCallback listener) {
  if (animationController != null) {
    animationController.removeListener(listener);
    animationController.dispose();
    animationController = null;
  }
}
