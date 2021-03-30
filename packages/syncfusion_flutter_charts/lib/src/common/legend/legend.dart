part of charts;

class _ChartLegend {
  _ChartLegend(this._chartState);
  dynamic get chart => _chartState._chart;
  final dynamic _chartState;
  Legend? legend;
  List<_LegendRenderContext>? legendCollections;
  late int rowCount;
  late int columnCount;
  Size legendSize = const Size(0, 0);
  Size chartSize = const Size(0, 0);
  bool shouldRenderLegend = false;
  late ValueNotifier<int> legendRepaintNotifier;
  late bool isNeedScrollable;

  /// To calculate legend bounds
  void _calculateLegendBounds(Size size) {
    legend = chart.legend;
    final LegendRenderer legendRenderer = _chartState._legendRenderer;
    shouldRenderLegend = false;
    assert(
        legend != null && legend!.width != null
            ? !legend!.width!.contains(RegExp(r'[a-z]')) &&
                !legend!.width!.contains(RegExp(r'[A-Z]'))
            : true,
        'Legend width must be number or percentage value, it should not contain any alphabets in the string.');
    assert(
        legend != null && legend!.height != null
            ? !legend!.height!.contains(RegExp(r'[a-z]')) &&
                !legend!.height!.contains(RegExp(r'[A-Z]'))
            : true,
        'Legend height must be number or percentage value, it should not contain any alphabets in the string.');
    if (legend != null && legend!.isVisible!) {
      legendCollections = <_LegendRenderContext>[];
      _calculateSeriesLegends();
      assert(legend!.itemPadding != null ? legend!.itemPadding >= 0 : true,
          'The padding between the legend and chart area should not be less than 0.');
      if (legendCollections!.isNotEmpty ||
          _chartState._legendWidgetContext.isNotEmpty) {
        num legendHeight = 0,
            legendWidth = 0,
            titleHeight = 0,
            textHeight = 0,
            textWidth = 0,
            maxTextHeight = 0,
            maxTextWidth = 0,
            maxLegendWidth = 0,
            maxLegendHeight = 0,
            currentWidth = 0,
            currentHeight = 0;
        num? maxRenderWidth, maxRenderHeight;
        Size titleSize;
        const num titleSpace = 10;
        final num padding = legend!.itemPadding;
        _chartState._chartLegend.isNeedScrollable = false;
        final bool isBottomOrTop =
            legendRenderer._legendPosition == LegendPosition.bottom ||
                legendRenderer._legendPosition == LegendPosition.top;
        legendRenderer._orientation =
            (legend!.orientation == LegendItemOrientation.auto)
                ? (isBottomOrTop
                    ? LegendItemOrientation.horizontal
                    : LegendItemOrientation.vertical)
                : legend!.orientation;

        maxRenderHeight = legend!.height != null
            ? _percentageToValue(legend!.height, size.height)
            : isBottomOrTop
                ? _percentageToValue('30%', size.height)
                : size.height;

        maxRenderWidth = legend!.width != null
            ? _percentageToValue(legend!.width, size.width)
            : isBottomOrTop
                ? size.width
                : _percentageToValue('30%', size.width);

        if (legend!.title.text != null && legend!.title.text!.isNotEmpty) {
          titleSize = measureText(legend!.title.text!, legend!.title.textStyle);
          titleHeight = titleSize.height + titleSpace;
        }

        final bool isTemplate = legend!.legendItemBuilder != null;
        final int length = isTemplate
            ? _chartState._legendWidgetContext.length
            : legendCollections!.length;
        late _MeasureWidgetContext legendContext;
        late _LegendRenderContext legendRenderContext;
        String legendText;
        Size textSize;
        assert(legend!.iconWidth != null ? legend!.iconWidth >= 0 : true,
            'The icon width of legend should not be less than 0.');
        assert(legend!.iconHeight != null ? legend!.iconHeight >= 0 : true,
            'The icon height of legend should not be less than 0.');
        assert(legend!.padding != null ? legend!.padding >= 0 : true,
            'The padding between legend text and legend icon should not be less than 0.');
        for (int i = 0; i < length; i++) {
          if (isTemplate) {
            legendContext = _chartState._legendWidgetContext[i];
            currentWidth = legendContext.size!.width + padding;
            currentHeight = legendContext.size!.height + padding;
          } else {
            legendRenderContext = legendCollections![i];
            legendText = legendRenderContext.text;
            textSize = measureText(legendText, legend!.textStyle);
            legendRenderContext.textSize = textSize;
            textHeight = textSize.height;
            textWidth = textSize.width;
            maxTextHeight = max(textHeight, maxTextHeight);
            maxTextWidth = max(textWidth, maxTextWidth);
            currentWidth =
                padding + legend!.iconWidth + legend!.padding + textWidth;
            currentHeight = padding + max(maxTextHeight, legend!.iconHeight);
            legendRenderContext.size =
                Size(currentWidth.toDouble(), currentHeight.toDouble());
          }
          if (i == 0) {
            maxRenderWidth = legend!.width == null && !isBottomOrTop
                ? max(maxRenderWidth!, currentWidth)
                : maxRenderWidth;
            maxRenderHeight = (titleHeight -
                    (legend!.height == null && isBottomOrTop
                        ? max(maxRenderHeight!, currentHeight)
                        : maxRenderHeight!))
                .abs();
          }
          shouldRenderLegend = true;
          bool needRender = false;
          if (legendRenderer._orientation == LegendItemOrientation.horizontal) {
            if (legend!.overflowMode == LegendItemOverflowMode.wrap) {
              if ((legendWidth + currentWidth) > maxRenderWidth!) {
                legendWidth = currentWidth;
                if (legendHeight + currentHeight > maxRenderHeight!) {
                  _chartState._chartLegend.isNeedScrollable = true;
                } else {
                  legendHeight = legendHeight + currentHeight;
                }
                maxTextHeight = textHeight;
              } else {
                legendWidth += currentWidth;
                legendHeight = max(legendHeight, currentHeight);
              }
            } else if (legend!.overflowMode == LegendItemOverflowMode.scroll ||
                legend!.overflowMode == LegendItemOverflowMode.none) {
              if (maxLegendWidth + currentWidth <= maxRenderWidth!) {
                legendWidth += currentWidth;
                legendHeight = currentHeight > maxRenderHeight!
                    ? maxRenderHeight
                    : max(legendHeight, currentHeight);
                needRender = true;
              } else {
                needRender = false;
              }
            }
          } else {
            if (legend!.overflowMode == LegendItemOverflowMode.wrap) {
              if ((legendHeight + currentHeight) > maxRenderHeight!) {
                legendHeight = currentHeight;
                if (legendWidth + currentWidth > maxRenderWidth!) {
                  _chartState._chartLegend.isNeedScrollable = true;
                } else {
                  legendWidth = legendWidth + currentWidth;
                }
              } else {
                legendHeight += currentHeight;
                legendWidth = max(legendWidth, currentWidth);
              }
            } else if (legend!.overflowMode == LegendItemOverflowMode.scroll ||
                legend!.overflowMode == LegendItemOverflowMode.none) {
              if (maxLegendHeight + currentHeight <= maxRenderHeight!) {
                legendHeight += currentHeight;
                legendWidth = currentWidth > maxRenderWidth!
                    ? maxRenderWidth
                    : max(legendWidth, currentWidth);
                needRender = true;
              } else {
                needRender = false;
              }
            }
          }
          if (isTemplate) {
            legendContext.isRender = needRender;
          } else {
            legendRenderContext.isRender = needRender;
          }
          maxLegendWidth = max(maxLegendWidth, legendWidth);
          maxLegendHeight = max(maxLegendHeight, legendHeight);
        }
        legendSize = Size((maxLegendWidth + padding).toDouble(),
            maxLegendHeight + titleHeight.toDouble());
      }
    }
  }

  /// To calculate legends in chart
  void _calculateLegends(
      SfCartesianChart chart, int index, CartesianSeriesRenderer seriesRenderer,
      [Trendline? trendline, int? trendlineIndex]) {
    LegendRenderArgs? legendEventArgs;
    bool isTrendlineadded = false;
    TrendlineRenderer? trendlineRenderer;
    final CartesianSeries<dynamic, dynamic> series = seriesRenderer._series;
    if (trendline != null) {
      isTrendlineadded = true;
      trendlineRenderer = seriesRenderer._trendlineRenderer[trendlineIndex!];
    }
    seriesRenderer._seriesName = seriesRenderer._seriesName ?? 'series $index';
    if (series.isVisibleInLegend &&
        (seriesRenderer._seriesName != null || series.legendItemText != null)) {
      if (chart.onLegendItemRender != null) {
        legendEventArgs = LegendRenderArgs(index);
        legendEventArgs.text = series.legendItemText ??
            (isTrendlineadded
                ? trendlineRenderer!._name!
                : seriesRenderer._seriesName!);
        legendEventArgs.legendIconType = isTrendlineadded
            ? trendline!.legendIconType
            : series.legendIconType;
        legendEventArgs.color =
            isTrendlineadded ? trendline!.color : series.color;
        chart.onLegendItemRender!(legendEventArgs);
      }
      final _LegendRenderContext legendRenderContext = _LegendRenderContext(
          seriesRenderer: seriesRenderer,
          trendline: trendline,
          seriesIndex: index,
          trendlineIndex: isTrendlineadded ? trendlineIndex : null,
          isSelect: _chartState._isTrendlineToggled
              ? (isTrendlineadded ? !trendlineRenderer!._visible : true)
              : !series.isVisible,
          text: legendEventArgs?.text ??
              series.legendItemText ??
              (isTrendlineadded
                  ? trendlineRenderer!._name!
                  : seriesRenderer._seriesName!),
          iconColor: legendEventArgs?.color ??
              (isTrendlineadded ? trendline!.color : series.color),
          isTrendline: isTrendlineadded,
          iconType: legendEventArgs?.legendIconType ??
              (isTrendlineadded
                  ? trendline!.legendIconType
                  : series.legendIconType));
      legendCollections!.add(legendRenderContext);
      if (!seriesRenderer._visible! &&
          series.isVisibleInLegend &&
          (_chartState._widgetNeedUpdate || _chartState._initialRender) &&
          (seriesRenderer._oldSeries == null ||
              (!series.isVisible && seriesRenderer._oldSeries!.isVisible))) {
        legendRenderContext.isSelect = true;
        if (!_chartState._legendToggleStates.contains(legendRenderContext)) {
          _chartState._legendToggleStates.add(legendRenderContext);
        }
      } else if (_chartState._widgetNeedUpdate &&
          (seriesRenderer._oldSeries != null &&
              (series.isVisible &&
                  !_chartState._legendToggling &&
                  seriesRenderer._visible!))) {
        final List<CartesianSeriesRenderer> visibleSeriesRenderers =
            _chartState._chartSeries.visibleSeriesRenderers;
        final String legendItemText =
            visibleSeriesRenderers[index]._series.legendItemText ??
                series.name ??
                'Series $index';
        final int seriesIndex = visibleSeriesRenderers.indexOf(seriesRenderer);
        final legendToggle = <_LegendRenderContext>[]
          //ignore: prefer_spread_collections
          ..addAll(_chartState._legendToggleStates);
        for (final legendContext in _chartState._legendToggleStates) {
          if (seriesIndex == legendContext.seriesIndex &&
              legendContext.text == legendItemText) {
            legendToggle.remove(legendContext);
          }
        }
        _chartState._legendToggleStates = legendToggle;
      }
    }
  }

  /// To calculate series legends
  void _calculateSeriesLegends() {
    LegendRenderArgs? legendEventArgs;
    if (chart.legend.legendItemBuilder == null) {
      if (chart is SfCartesianChart) {
        for (int i = 0;
            i < _chartState._chartSeries.visibleSeriesRenderers.length;
            i++) {
          final CartesianSeriesRenderer seriesRenderer =
              _chartState._chartSeries.visibleSeriesRenderers[i];
          if (!seriesRenderer._isIndicator) {
            _calculateLegends(chart, i, seriesRenderer);
          }
          if (seriesRenderer is CartesianSeriesRenderer) {
            final CartesianSeriesRenderer xYSeriesRenderer = seriesRenderer;
            if (xYSeriesRenderer._series != null &&
                xYSeriesRenderer._series.trendlines != null) {
              for (int j = 0;
                  j < xYSeriesRenderer._series.trendlines!.length;
                  j++) {
                final Trendline trendline =
                    xYSeriesRenderer._series.trendlines![j];
                if (trendline.isVisibleInLegend) {
                  _chartState._chartLegend._calculateLegends(
                      chart, i, xYSeriesRenderer, trendline, j);
                }
              }
            }
          }
        }
        if (chart.indicators.isNotEmpty) {
          _calculateIndicatorLegends();
        }
      } else if (_chartState._chartSeries.visibleSeriesRenderers.isNotEmpty) {
        final dynamic seriesRenderer =
            _chartState._chartSeries.visibleSeriesRenderers[0];
        for (int j = 0; j < seriesRenderer._renderPoints.length; j++) {
          final dynamic chartPoint = seriesRenderer._renderPoints[j];
          if (chart.onLegendItemRender != null) {
            legendEventArgs = LegendRenderArgs(0, j);
            legendEventArgs.text = chartPoint.x;
            legendEventArgs.legendIconType =
                seriesRenderer._series.legendIconType;
            legendEventArgs.color = chartPoint.fill;
            chart.onLegendItemRender(legendEventArgs);
          }

          legendCollections!.add(_LegendRenderContext(
              seriesRenderer: seriesRenderer,
              seriesIndex: j,
              isSelect: false,
              point: chartPoint,
              text: legendEventArgs?.text ?? chartPoint.x,
              iconColor: legendEventArgs?.color ?? chartPoint.fill,
              iconType: legendEventArgs?.legendIconType ??
                  seriesRenderer._series.legendIconType));
        }
      }
    }
  }

  /// To calculate indicator legends
  void _calculateIndicatorLegends() {
    LegendRenderArgs? legendEventArgs;
    final List<String> textCollection = <String>[];
    TechnicalIndicatorsRenderer? technicalIndicatorsRenderer;
    for (int i = 0; i < chart.indicators.length; i++) {
      final TechnicalIndicators<dynamic, dynamic> indicator =
          chart.indicators[i];
      technicalIndicatorsRenderer = _chartState._technicalIndicatorRenderer[i];
      _chartState._chartSeries
          ?._setIndicatorType(indicator, technicalIndicatorsRenderer);
      textCollection.add(technicalIndicatorsRenderer!._indicatorType);
    }
    //ignore: prefer_collection_literals
    final Map<String, int> _map = Map<String, int>();
    //ignore: avoid_function_literals_in_foreach_calls
    textCollection.forEach((dynamic str) =>
        _map[str] = !_map.containsKey(str) ? (1) : (_map[str]! + 1));

    final List<String> indicatorTextCollection = <String>[];
    for (int i = 0; i < chart.indicators.length; i++) {
      final TechnicalIndicators<dynamic, dynamic> indicator =
          chart.indicators[i];
      final int count = indicatorTextCollection
              .contains(technicalIndicatorsRenderer?._indicatorType)
          ? _chartState._chartSeries?._getIndicatorId(indicatorTextCollection,
              technicalIndicatorsRenderer?._indicatorType)
          : 0;
      indicatorTextCollection.add(technicalIndicatorsRenderer!._indicatorType);
      technicalIndicatorsRenderer._name = indicator.name ??
          (technicalIndicatorsRenderer._indicatorType +
              (_map[technicalIndicatorsRenderer._indicatorType] == 1
                  ? ''
                  : ' ' + count.toString()));
      if (indicator.isVisible && indicator.isVisibleInLegend) {
        if (chart.onLegendItemRender != null) {
          legendEventArgs = LegendRenderArgs(i);
          legendEventArgs.text =
              indicator.legendItemText ?? technicalIndicatorsRenderer._name;
          legendEventArgs.legendIconType = indicator.legendIconType;
          legendEventArgs.color = indicator.signalLineColor;
          chart.onLegendItemRender(legendEventArgs);
        }
        final _LegendRenderContext legendRenderContext = _LegendRenderContext(
            seriesRenderer: indicator,
            indicatorRenderer: _chartState._technicalIndicatorRenderer[i],
            seriesIndex:
                _chartState._chartSeries.visibleSeriesRenderers.length + i,
            isSelect: !indicator.isVisible,
            text: legendEventArgs?.text ??
                indicator.legendItemText ??
                technicalIndicatorsRenderer._name,
            iconColor: legendEventArgs?.color ?? indicator.signalLineColor,
            iconType:
                legendEventArgs?.legendIconType ?? indicator.legendIconType);
        legendCollections!.add(legendRenderContext);
        if (!indicator.isVisible &&
            indicator.isVisibleInLegend &&
            _chartState._initialRender) {
          legendRenderContext.isSelect = true;
          _chartState._legendToggleStates.add(legendRenderContext);
        }
      }
    }
  }
}

class _LegendContainer extends StatelessWidget {
  _LegendContainer({this.chartState}) : chart = chartState._chart;

  final dynamic chart;
  final dynamic chartState;

  @override
  Widget build(BuildContext context) {
    final List<_LegendRenderContext> legendCollections =
        chartState._chartLegend.legendCollections;
    final List<Widget> legendWidgets = <Widget>[];
    final Legend legend = chart.legend;
    num titleHeight = 0;
    chartState._chartLegend.legendRepaintNotifier = ValueNotifier<int>(0);
    if (legend.legendItemBuilder != null) {
      for (int i = 0; i < chartState._legendWidgetContext.length; i++) {
        final _MeasureWidgetContext legendRenderContext =
            chartState._legendWidgetContext[i];
        if (legend.overflowMode == LegendItemOverflowMode.none
            ? legendRenderContext.isRender
            : true) {
          legendWidgets.add(_RenderLegend(
              index: i,
              template: legendRenderContext.widget!,
              size: legendRenderContext.size!,
              chartState: chartState));
        }
      }
    } else {
      for (int i = 0; i < legendCollections.length; i++) {
        final _LegendRenderContext legendRenderContext = legendCollections[i];
        if (legend.overflowMode == LegendItemOverflowMode.none
            ? legendRenderContext.isRender
            : true) {
          legendWidgets.add(_RenderLegend(
              index: i,
              size: legendRenderContext.size!,
              chartState: chartState));
        }
      }
    }

    final bool needLegendTitle =
        legend.title.text != null && legend.title.text!.isNotEmpty;

    if (needLegendTitle) {
      titleHeight =
          measureText(legend.title.text!, legend.title.textStyle).height + 10;
    }
    return _getWidget(legendWidgets, needLegendTitle, titleHeight);
  }

  Widget _getWidget(
      List<Widget> legendWidgets, bool needLegendTitle, num titleHeight) {
    Widget widget;
    final Legend legend = chart.legend;
    final LegendRenderer legedRenderer = chartState._legendRenderer;
    final double legendHeight = chartState._chartLegend.legendSize.height;
    if (chartState._chartLegend.isNeedScrollable) {
      widget = Container(
          height: needLegendTitle
              ? (legendHeight - titleHeight).abs()
              : legendHeight,
          child: SingleChildScrollView(
              scrollDirection:
                  legedRenderer._orientation == LegendItemOrientation.horizontal
                      ? Axis.vertical
                      : Axis.horizontal,
              child: legedRenderer._orientation ==
                      LegendItemOrientation.horizontal
                  ? Wrap(direction: Axis.horizontal, children: legendWidgets)
                  : Wrap(direction: Axis.vertical, children: legendWidgets)));
    } else if (legend.overflowMode == LegendItemOverflowMode.scroll) {
      widget = Container(
          height: needLegendTitle
              ? (legendHeight - titleHeight).abs()
              : legendHeight,
          child: SingleChildScrollView(
              scrollDirection:
                  legedRenderer._orientation == LegendItemOrientation.horizontal
                      ? Axis.horizontal
                      : Axis.vertical,
              child:
                  legedRenderer._orientation == LegendItemOrientation.horizontal
                      ? Row(children: legendWidgets)
                      : Column(children: legendWidgets)));
    } else if (legend.overflowMode == LegendItemOverflowMode.none) {
      widget = Container(
          height: needLegendTitle
              ? (legendHeight - titleHeight).abs()
              : legendHeight,
          child: legedRenderer._orientation == LegendItemOrientation.horizontal
              ? Row(children: legendWidgets)
              : Column(children: legendWidgets));
    } else {
      widget = Container(
          height: needLegendTitle
              ? (legendHeight - titleHeight).abs()
              : legendHeight,
          width: chartState._chartLegend.legendSize.width,
          child: Wrap(
              direction:
                  legedRenderer._orientation == LegendItemOrientation.horizontal
                      ? Axis.horizontal
                      : Axis.vertical,
              children: legendWidgets));
    }
    if (needLegendTitle) {
      final ChartAlignment titleAlign = legend.title.alignment;
      final Color color = chart.legend.title.textStyle.color ??
          chartState._chartTheme.legendTitleColor;
      final double fontSize = chart.legend.title.textStyle.fontSize;
      final String fontFamily = chart.legend.title.textStyle.fontFamily;
      final FontStyle fontStyle = chart.legend.title.textStyle.fontStyle;
      final FontWeight? fontWeight = chart.legend.title.textStyle.fontWeight;
      widget = Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
            Container(
                height: titleHeight.toDouble(),
                alignment: titleAlign == ChartAlignment.center
                    ? Alignment.center
                    : titleAlign == ChartAlignment.near
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                child: Container(
                  child: Text(legend.title.text!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: color,
                          fontSize: fontSize,
                          fontFamily: fontFamily,
                          fontStyle: fontStyle,
                          fontWeight: fontWeight)),
                )),
            widget
          ]));
    }
    return widget;
  }
}
