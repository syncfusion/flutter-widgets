import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/legend_internal.dart'
    hide LegendPosition;

import '../../chart/base/chart_base.dart';
import '../../chart/chart_series/series.dart';
import '../../chart/chart_series/series_renderer_properties.dart';
import '../../chart/common/cartesian_state_properties.dart';
import '../../chart/technical_indicators/technical_indicator.dart';
import '../../chart/trendlines/trendlines.dart';
import '../../chart/utils/helper.dart';
import '../../circular_chart/renderer/chart_point.dart';
import '../../circular_chart/renderer/circular_series.dart';
import '../../circular_chart/renderer/renderer_extension.dart';
import '../common.dart';
import '../event_args.dart';
import '../rendering_details.dart';
import '../state_properties.dart';
import '../utils/enum.dart';
import '../utils/typedef.dart';
import 'renderer.dart';

/// Represents the chart legend class.
class ChartLegend {
  /// Creates an instance of chart legend.
  ChartLegend(this.stateProperties);

  /// Specifies the value of state properties.
  final StateProperties stateProperties;

  /// Holds the chart.
  dynamic get chart => stateProperties.chart;

  /// Specifies the value of legend.
  Legend? legend;

  /// Specifies the list of legend renderer context.
  List<LegendRenderContext>? legendCollections;

  /// Specifies the list of legend items for SfLegend widget.
  late List<LegendItem> legendItems;

  /// Specifies the value of row count.
  late int rowCount;

  /// Specifies the value of column count.
  late int columnCount;

  /// Specifies the legend size value.
  Size legendSize = Size.zero;

  /// Specifies the value of chart size.
  Size chartSize = Size.zero;

  /// Specifies whether to render the legend.
  bool shouldRenderLegend = false;

  /// Specifies whether the legend is scrollable.
  late bool isNeedScrollable;

  /// Specifies the legend's title height value.
  double titleHeight = 0.0;

  /// Specifies the list of toggled legend indices for SfLegend.
  List<int> toggledIndices = <int>[];

  /// Specifies the sum of points for circular chart types.
  num sumOfPoints = 0;

  /// Specifies the toggled item color for Sflegend.
  Color toggledItemColor = const Color.fromRGBO(211, 211, 211, 1);

  /// To calculate legend bounds.
  void calculateLegendBounds(Size size) {
    legend = chart.legend;
    final LegendRenderer legendRenderer =
        stateProperties.renderingDetails.legendRenderer;
    final List<MeasureWidgetContext> legendWidgetContext =
        stateProperties.renderingDetails.legendWidgetContext;
    final ChartLegend chartLegend =
        stateProperties.renderingDetails.chartLegend;
    shouldRenderLegend = false;
    assert(
        !(legend != null && legend!.width != null) ||
            !legend!.width!.contains(RegExp(r'[a-z]')) &&
                !legend!.width!.contains(RegExp(r'[A-Z]')),
        'Legend width must be number or percentage value, it should not contain any alphabets in the string.');
    assert(
        !(legend != null && legend!.height != null) ||
            !legend!.height!.contains(RegExp(r'[a-z]')) &&
                !legend!.height!.contains(RegExp(r'[A-Z]')),
        'Legend height must be number or percentage value, it should not contain any alphabets in the string.');
    if (legend != null && legend!.isVisible!) {
      legendCollections = <LegendRenderContext>[];
      legendItems = <LegendItem>[];
      _calculateSeriesLegends();
      // ignore: unnecessary_null_comparison
      assert(!(legend!.itemPadding != null) || legend!.itemPadding >= 0,
          'The padding between the legend and chart area should not be less than 0.');
      if (legendCollections!.isNotEmpty || legendWidgetContext.isNotEmpty) {
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
        chartLegend.isNeedScrollable = false;
        final bool isBottomOrTop =
            legendRenderer.legendPosition == LegendPosition.bottom ||
                legendRenderer.legendPosition == LegendPosition.top;
        legendRenderer.orientation =
            (legend!.orientation == LegendItemOrientation.auto)
                ? (isBottomOrTop
                    ? LegendItemOrientation.horizontal
                    : LegendItemOrientation.vertical)
                : legend!.orientation;

        maxRenderHeight = legend!.height != null
            ? percentageToValue(legend!.height, size.height)
            : isBottomOrTop
                ? percentageToValue('30%', size.height)
                : size.height;

        maxRenderWidth = legend!.width != null
            ? percentageToValue(legend!.width, size.width)
            : isBottomOrTop
                ? size.width
                : percentageToValue('30%', size.width);

        // To reduce the container width based on offset.
        if (chartLegend.legend!.offset != null &&
            (chartLegend.legend!.offset?.dx.isNegative == false)) {
          maxRenderWidth = maxRenderWidth! -
              (chartLegend.legend!.offset?.dx as num) * 1.5 +
              padding;
        }

        if (legend!.title.text != null && legend!.title.text!.isNotEmpty) {
          titleSize = measureText(
              legend!.title.text!,
              stateProperties
                  .renderingDetails.chartTheme.legendTitleTextStyle!);
          titleHeight = titleSize.height + titleSpace;
        }

        final bool isTemplate = legend!.legendItemBuilder != null;
        final int length =
            isTemplate ? legendWidgetContext.length : legendCollections!.length;
        late MeasureWidgetContext legendContext;
        late LegendRenderContext legendRenderContext;
        String legendText;
        Size textSize;
        // ignore: unnecessary_null_comparison
        assert(!(legend!.iconWidth != null) || legend!.iconWidth >= 0,
            'The icon width of legend should not be less than 0.');
        // ignore: unnecessary_null_comparison
        assert(!(legend!.iconHeight != null) || legend!.iconHeight >= 0,
            'The icon height of legend should not be less than 0.');
        // ignore: unnecessary_null_comparison
        assert(!(legend!.padding != null) || legend!.padding >= 0,
            'The padding between legend text and legend icon should not be less than 0.');
        for (int i = 0; i < length; i++) {
          if (isTemplate) {
            legendContext = legendWidgetContext[i];
            currentWidth = legendContext.size!.width + padding;
            currentHeight = legendContext.size!.height + padding;
          } else {
            legendRenderContext = legendCollections![i];
            legendText = legendRenderContext.text;
            textSize = measureText(legendText,
                stateProperties.renderingDetails.chartTheme.legendTextStyle!);
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
          if (legendRenderer.orientation == LegendItemOrientation.horizontal) {
            if (legend!.overflowMode == LegendItemOverflowMode.wrap) {
              if ((legendWidth + currentWidth) > maxRenderWidth!) {
                legendWidth = currentWidth;
                if (legendHeight + currentHeight > maxRenderHeight!) {
                  chartLegend.isNeedScrollable = true;
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
                  chartLegend.isNeedScrollable = true;
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

  /// To calculate legends in chart.
  void _calculateLegends(SfCartesianChart chart, int index,
      SeriesRendererDetails seriesRendererDetails,
      [Trendline? trendline, int? trendlineIndex]) {
    LegendRenderArgs? legendEventArgs;
    bool isTrendlineadded = false;
    TrendlineRenderer? trendlineRenderer;
    final CartesianSeries<dynamic, dynamic> series =
        seriesRendererDetails.series;
    final CartesianStateProperties stateProperties =
        this.stateProperties as CartesianStateProperties;
    final RenderingDetails renderingDetails = stateProperties.renderingDetails;
    final List<Color> palette = stateProperties.chart.palette;
    if (trendline != null) {
      isTrendlineadded = true;
      trendlineRenderer =
          seriesRendererDetails.trendlineRenderer[trendlineIndex!];
    }
    seriesRendererDetails.seriesName =
        seriesRendererDetails.seriesName ?? 'series $index';
    if (series.isVisibleInLegend &&
        (seriesRendererDetails.seriesName != null ||
            series.legendItemText != null)) {
      if (chart.onLegendItemRender != null) {
        legendEventArgs = LegendRenderArgs(index);
        legendEventArgs.text = series.legendItemText ??
            (isTrendlineadded
                ? trendlineRenderer!.name!
                : seriesRendererDetails.seriesName!);
        legendEventArgs.legendIconType = isTrendlineadded
            ? trendline!.legendIconType
            : series.legendIconType;
        legendEventArgs.color =
            isTrendlineadded ? trendline!.color : series.color;
        chart.onLegendItemRender!(legendEventArgs);
      }
      final LegendRenderContext legendRenderContext = LegendRenderContext(
          seriesRenderer: seriesRendererDetails,
          trendline: trendline,
          seriesIndex: index,
          trendlineIndex: isTrendlineadded ? trendlineIndex : null,
          isSelect: stateProperties.isTrendlineToggled == true
              ? (!isTrendlineadded || !trendlineRenderer!.visible)
              : !series.isVisible,
          text: legendEventArgs?.text ??
              series.legendItemText ??
              (isTrendlineadded
                  ? trendlineRenderer!.name!
                  : seriesRendererDetails.seriesName!),
          iconColor: legendEventArgs?.color ??
              (isTrendlineadded ? trendline!.color : series.color),
          isTrendline: isTrendlineadded,
          iconType: legendEventArgs?.legendIconType ??
              (isTrendlineadded
                  ? trendline!.legendIconType
                  : series.legendIconType));
      legendCollections!.add(legendRenderContext);
      final Shader? cartesianShader =
          _getCartesianSeriesGradientShader(legendRenderContext, chart.legend);
      final LegendItem legendItem = LegendItem(
          text: legendRenderContext.text,
          color: cartesianShader == null
              ? (legendRenderContext.iconColor ?? palette[legendRenderContext.seriesIndex % palette.length])
                  .withOpacity(legend!.opacity)
              : const Color.fromRGBO(211, 211, 211, 1),
          shader: cartesianShader,
          imageProvider: legendRenderContext.iconType == LegendIconType.image &&
                  chart.legend.image != null
              ? chart.legend.image
              : (seriesRendererDetails.seriesType == 'scatter' &&
                      seriesRendererDetails.series.markerSettings.shape ==
                          DataMarkerType.image)
                  ? seriesRendererDetails.series.markerSettings.image
                  : null,
          iconType: legendRenderContext.iconType == LegendIconType.seriesType
              ? _getEffectiveLegendIconType(
                  legendRenderContext.iconType,
                  legendRenderContext,
                  legendRenderContext.seriesRenderer.seriesType)
              : _getEffectiveLegendIconType(legendRenderContext.iconType),
          iconStrokeWidth:
              legendRenderContext.iconType == LegendIconType.seriesType
                  ? (legendRenderContext.seriesRenderer.seriesType == 'line' ||
                          legendRenderContext.seriesRenderer.seriesType ==
                              'fastline' ||
                          legendRenderContext.seriesRenderer.seriesType.contains('stackedline') ==
                              true)
                      ? (chart.legend.iconBorderWidth > 0
                          ? chart.legend.iconBorderWidth
                          : 3)
                      : ((legendRenderContext.seriesRenderer.seriesType == 'candle' ||
                              legendRenderContext.seriesRenderer.seriesType ==
                                  'boxandWhisker' ||
                              legendRenderContext.seriesRenderer.seriesType.contains('hilo') ==
                                  true)
                          ? (chart.legend.iconBorderWidth > 0
                              ? chart.legend.iconBorderWidth
                              : 2)
                          : (legendRenderContext.seriesRenderer.seriesType == 'spline' ||
                                  legendRenderContext.seriesRenderer.seriesType ==
                                      'stepline')
                              ? (chart.legend.iconBorderWidth > 0
                                  ? chart.legend.iconBorderWidth
                                  : 1)
                              : null)
                  : ((legendRenderContext.iconType == LegendIconType.horizontalLine ||
                          legendRenderContext.iconType == LegendIconType.verticalLine)
                      ? (chart.legend.iconBorderWidth > 0 ? chart.legend.iconBorderWidth : 2)
                      : null),
          overlayMarkerType: _getOverlayMarkerType(legendRenderContext));
      legendItems.add(legendItem);
      if (seriesRendererDetails.visible! == false &&
          series.isVisibleInLegend &&
          (renderingDetails.widgetNeedUpdate ||
              renderingDetails.initialRender!) &&
          (seriesRendererDetails.oldSeries == null ||
              (!series.isVisible &&
                  seriesRendererDetails.oldSeries!.isVisible == true))) {
        legendRenderContext.isSelect = true;
        final List<LegendRenderContext> legendToggleStates =
            stateProperties.renderingDetails.legendToggleStates;
        if (legendToggleStates.isEmpty) {
          stateProperties.renderingDetails.legendToggleStates
              .add(legendRenderContext);
        } else {
          LegendRenderContext? legendContext;
          bool isSame = false;
          for (int i = 0; i < legendToggleStates.length; i++) {
            if (legendToggleStates[i] == legendRenderContext ||
                legendToggleStates[i].seriesIndex ==
                    legendRenderContext.seriesIndex) {
              isSame = true;
            } else if (!isSame) {
              legendContext = legendRenderContext;
            }
          }
          if (!isSame) {
            stateProperties.renderingDetails.legendToggleStates
                .add(legendContext!);
          }
        }
      } else if (renderingDetails.widgetNeedUpdate &&
          (seriesRendererDetails.oldSeries != null &&
              (series.isVisible &&
                  stateProperties.legendToggling == false &&
                  seriesRendererDetails.visible! == true))) {
        final List<CartesianSeriesRenderer> visibleSeriesRenderers =
            stateProperties.chartSeries.visibleSeriesRenderers;
        final String legendItemText =
            SeriesHelper.getSeriesRendererDetails(visibleSeriesRenderers[index])
                    .series
                    .legendItemText ??
                series.name ??
                'Series $index';
        final int seriesIndex =
            visibleSeriesRenderers.indexOf(seriesRendererDetails.renderer);
        final List<LegendRenderContext> legendToggle = <LegendRenderContext>[]
          //ignore: prefer_spread_collections
          ..addAll(stateProperties.renderingDetails.legendToggleStates);
        for (final LegendRenderContext legendContext
            in stateProperties.renderingDetails.legendToggleStates) {
          if (seriesIndex == legendContext.seriesIndex &&
              legendContext.text == legendItemText) {
            legendToggle.remove(legendContext);
          }
        }
        stateProperties.renderingDetails.legendToggleStates = legendToggle;
      }
    }
  }

  /// To calculate series legends.
  void _calculateSeriesLegends() {
    LegendRenderArgs? legendEventArgs;
    if (chart.legend.legendItemBuilder == null) {
      if (chart is SfCartesianChart) {
        final CartesianStateProperties stateProperties =
            this.stateProperties as CartesianStateProperties;
        for (int i = 0;
            i < stateProperties.chartSeries.visibleSeriesRenderers.length;
            i++) {
          final SeriesRendererDetails seriesRendererDetails =
              SeriesHelper.getSeriesRendererDetails(
                  stateProperties.chartSeries.visibleSeriesRenderers[i]);
          if (seriesRendererDetails.isIndicator == false) {
            _calculateLegends(chart, i, seriesRendererDetails);
          }
          // ignore: unnecessary_type_check
          if (seriesRendererDetails.renderer is CartesianSeriesRenderer) {
            final SeriesRendererDetails xYseriesRendererDetails =
                seriesRendererDetails;
            // ignore: unnecessary_null_comparison
            if (xYseriesRendererDetails.series != null &&
                xYseriesRendererDetails.series.trendlines != null) {
              for (int j = 0;
                  j < xYseriesRendererDetails.series.trendlines!.length;
                  j++) {
                final Trendline trendline =
                    xYseriesRendererDetails.series.trendlines![j];
                if (trendline.isVisibleInLegend) {
                  stateProperties.renderingDetails.chartLegend
                      ._calculateLegends(
                          chart, i, xYseriesRendererDetails, trendline, j);
                }
              }
            }
          }
        }
        if (chart.indicators.isNotEmpty == true) {
          _calculateIndicatorLegends();
        }
      } else {
        final dynamic stateProperties = this.stateProperties;
        if (stateProperties.chartSeries.visibleSeriesRenderers.isNotEmpty ==
            true) {
          final dynamic seriesRenderer =
              stateProperties.chartSeries.visibleSeriesRenderers[0];
          for (int j = 0; j < seriesRenderer.renderPoints.length; j++) {
            final dynamic chartPoint = seriesRenderer.renderPoints[j];
            if (chart.onLegendItemRender != null) {
              legendEventArgs = LegendRenderArgs(0, j);
              legendEventArgs.text = chartPoint.x;
              legendEventArgs.legendIconType =
                  seriesRenderer.series.legendIconType;
              legendEventArgs.color = chartPoint.fill;
              chart.onLegendItemRender(legendEventArgs);
            }

            final LegendRenderContext legendRenderContext = LegendRenderContext(
                seriesRenderer: seriesRenderer,
                seriesIndex: j,
                isSelect: false,
                point: chartPoint,
                text: legendEventArgs?.text ?? chartPoint.x,
                iconColor: legendEventArgs?.color ?? chartPoint.fill,
                iconType: legendEventArgs?.legendIconType ??
                    seriesRenderer.series.legendIconType);
            legendCollections!.add(legendRenderContext);

            double? degree;
            double? pointStartAngle;
            double? totalAngle;
            double? pointEndAngle;
            final bool isRadialBarSeries = legendRenderContext.iconType ==
                    LegendIconType.seriesType &&
                legendRenderContext.seriesRenderer.seriesType == 'radialbar';
            if (isRadialBarSeries) {
              pointStartAngle = -90;
              totalAngle = 360;
              _getSumOfPoints(seriesRenderer);
              degree =
                  legendRenderContext.seriesRenderer.renderPoints[j].y.abs() /
                      (legendRenderContext.series.maximumValue ?? sumOfPoints);
              degree = (degree! > 1 ? 1 : degree) * (totalAngle - 0.001);
              pointEndAngle = pointStartAngle + degree;
            }

            final Shader? circularShader =
                _getCircularSeriesShader(legendRenderContext, chart.legend);
            final LegendItem legendItem = LegendItem(
                text: legendRenderContext.text,
                shader: circularShader,
                color: circularShader == null
                    ? (legendRenderContext.iconColor)!
                        .withOpacity(legend!.opacity)
                    : const Color.fromRGBO(211, 211, 211, 1),
                imageProvider:
                    legendRenderContext.iconType == LegendIconType.image &&
                            chart.legend.image != null
                        ? chart.legend.image
                        : null,
                iconType: legendRenderContext.iconType == LegendIconType.seriesType
                    ? _getEffectiveLegendIconType(
                        legendRenderContext.iconType,
                        legendRenderContext,
                        legendRenderContext.seriesRenderer.seriesType)
                    : _getEffectiveLegendIconType(
                        legendRenderContext.iconType, legendRenderContext),
                iconStrokeWidth: ((legendRenderContext.iconType ==
                                LegendIconType.seriesType &&
                            (legendRenderContext.seriesRenderer.seriesType == 'radialbar' ||
                                legendRenderContext.seriesRenderer.seriesType ==
                                    'doughnut')) ||
                        legendRenderContext.iconType == LegendIconType.horizontalLine ||
                        legendRenderContext.iconType == LegendIconType.verticalLine)
                    ? (chart.legend.iconBorderWidth > 0 == true ? chart.legend.iconBorderWidth : 1)
                    : null,
                degree: degree,
                startAngle: pointStartAngle,
                endAngle: pointEndAngle);
            legendItems.add(legendItem);
          }
        }
      }
    }
  }

  /// To calculate indicator legends.
  void _calculateIndicatorLegends() {
    LegendRenderArgs? legendEventArgs;
    final List<String> textCollection = <String>[];
    TechnicalIndicatorsRenderer? technicalIndicatorsRenderer;
    final CartesianStateProperties stateProperties =
        this.stateProperties as CartesianStateProperties;
    for (int i = 0; i < chart.indicators.length; i++) {
      final TechnicalIndicators<dynamic, dynamic> indicator =
          chart.indicators[i];
      technicalIndicatorsRenderer =
          stateProperties.technicalIndicatorRenderer[i];
      stateProperties.chartSeries
          .setIndicatorType(indicator, technicalIndicatorsRenderer);
      textCollection.add(technicalIndicatorsRenderer.indicatorType);
    }
    //ignore: prefer_collection_literals
    final Map<String, int> map = Map<String, int>();
    //ignore: avoid_function_literals_in_foreach_calls
    textCollection.forEach((dynamic str) =>
        map[str] = !map.containsKey(str) ? (1) : (map[str]! + 1));

    final List<String> indicatorTextCollection = <String>[];
    for (int i = 0; i < chart.indicators.length; i++) {
      final TechnicalIndicators<dynamic, dynamic> indicator =
          chart.indicators[i];
      technicalIndicatorsRenderer =
          stateProperties.technicalIndicatorRenderer[i];
      final int count = indicatorTextCollection
              .contains(technicalIndicatorsRenderer.indicatorType)
          ? stateProperties.chartSeries.getIndicatorId(indicatorTextCollection,
              technicalIndicatorsRenderer.indicatorType)
          : 0;
      indicatorTextCollection.add(technicalIndicatorsRenderer.indicatorType);
      technicalIndicatorsRenderer.name = indicator.name ??
          (technicalIndicatorsRenderer.indicatorType +
              (map[technicalIndicatorsRenderer.indicatorType] == 1
                  ? ''
                  : ' $count'));
      if (indicator.isVisible && indicator.isVisibleInLegend) {
        if (chart.onLegendItemRender != null) {
          legendEventArgs = LegendRenderArgs(i);
          legendEventArgs.text =
              indicator.legendItemText ?? technicalIndicatorsRenderer.name;
          legendEventArgs.legendIconType = indicator.legendIconType;
          legendEventArgs.color = indicator.signalLineColor;
          chart.onLegendItemRender(legendEventArgs);
        }
        final LegendRenderContext legendRenderContext = LegendRenderContext(
            seriesRenderer: indicator,
            indicatorRenderer: stateProperties.technicalIndicatorRenderer[i],
            seriesIndex:
                stateProperties.chartSeries.visibleSeriesRenderers.length + i,
            isSelect: !indicator.isVisible,
            text: legendEventArgs?.text ??
                indicator.legendItemText ??
                technicalIndicatorsRenderer.name,
            isTrendline: false,
            iconColor: legendEventArgs?.color ?? indicator.signalLineColor,
            iconType:
                legendEventArgs?.legendIconType ?? indicator.legendIconType);
        legendCollections!.add(legendRenderContext);
        final LegendItem legendIndicatorItem = LegendItem(
            text: legendRenderContext.text,
            color: legendRenderContext.iconColor!.withOpacity(legend!.opacity),
            imageProvider: legendRenderContext.iconType == LegendIconType.image &&
                    chart.legend.image != null
                ? chart.legend.image
                : null,
            iconType: legendRenderContext.series.legendIconType ==
                    LegendIconType.seriesType
                ? ShapeMarkerType.horizontalLine
                : _getEffectiveLegendIconType(
                    legendRenderContext.iconType, legendRenderContext),
            iconStrokeWidth: ((legendRenderContext.series
                            is TechnicalIndicators &&
                        legendRenderContext.indicatorRenderer!.isIndicator) &&
                    (legendRenderContext.iconType == LegendIconType.seriesType ||
                        legendRenderContext.iconType ==
                            LegendIconType.horizontalLine ||
                        legendRenderContext.iconType ==
                            LegendIconType.verticalLine))
                ? (chart.legend.iconBorderWidth > 0 == true
                    ? chart.legend.iconBorderWidth
                    : 2)
                : null);
        legendItems.add(legendIndicatorItem);
        if (!indicator.isVisible &&
            indicator.isVisibleInLegend &&
            stateProperties.renderingDetails.initialRender! == true) {
          legendRenderContext.isSelect = true;
          stateProperties.renderingDetails.legendToggleStates
              .add(legendRenderContext);
        }
      }
    }
  }

  /// To find sum of points in radial bar series.
  void _getSumOfPoints(CircularSeriesRendererExtension seriesRenderer) {
    num sum = 0;
    for (final ChartPoint<dynamic> point in seriesRenderer.renderPoints!) {
      if (point.isVisible) {
        sum += point.y!.abs();
      }
    }
    sumOfPoints = sum;
  }

  /// To get the cartesian series gradient shader for SfLegend.
  Shader? _getCartesianSeriesGradientShader(
      LegendRenderContext legendRenderContext, Legend legend) {
    Shader? legendShader;
    Shader? cartesianShader;
    TrendlineRenderer? trendlineRenderer;

    final Size size = Size(legend.iconWidth, legend.iconHeight);
    final Rect pathRect = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: size.height);
    final Rect rectBounds = Offset.zero & size;
    final String seriesType = legendRenderContext.seriesRenderer.seriesType;
    final LinearGradient? gradientFill = legendRenderContext.series.gradient;
    final Shader toggledLegendShader =
        LinearGradient(colors: <Color>[toggledItemColor, toggledItemColor])
            .createShader(pathRect);

    if (legendRenderContext.trendline != null) {
      trendlineRenderer = legendRenderContext.seriesRenderer
          .trendlineRenderer[legendRenderContext.trendlineIndex!];
    }
    legendRenderContext.isSelect = (legendRenderContext.trendline != null)
        ? !trendlineRenderer!.visible
        : legendRenderContext.seriesRenderer
                is TechnicalIndicators<dynamic, dynamic>
            ? !legendRenderContext.indicatorRenderer!.visible!
            : legendRenderContext.seriesRenderer.visible == false;
    if (legendRenderContext.series is CartesianSeries &&
        legendRenderContext.series.onCreateShader != null &&
        !legendRenderContext.isSelect) {
      ShaderDetails shaderDetails;
      shaderDetails = ShaderDetails(pathRect, 'legend');
      legendShader = legendRenderContext.series.onCreateShader(shaderDetails);
    }

    // ignore: prefer_if_null_operators
    cartesianShader = legendShader == null
        ? (!seriesType.contains('line') ||
                    (seriesType.contains('splinearea') ||
                        seriesType.contains('splinerangearea'))) &&
                (legendRenderContext.series is CartesianSeries &&
                    legendRenderContext.series.gradient != null &&
                    !legendRenderContext.isTrendline!)
            ? !legendRenderContext.isSelect
                ? gradientFill!.createShader(rectBounds)
                : toggledLegendShader
            : null
        : !legendRenderContext.isSelect
            ? legendShader
            : toggledLegendShader;

    return cartesianShader;
  }

  /// To get the circular series shader for SfLegend.
  Shader? _getCircularSeriesShader(
      LegendRenderContext legendRenderContext, Legend legend) {
    Shader? legendShader;
    Shader? shader;
    ChartShaderMapper<dynamic>? pointShaderMapper;
    final Size size = Size(legend.iconWidth, legend.iconHeight);
    final Rect pathRect = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: size.height);
    final Shader toggledLegendShader =
        LinearGradient(colors: <Color>[toggledItemColor, toggledItemColor])
            .createShader(pathRect);
    legendRenderContext.isSelect = legendRenderContext.point.isVisible == false;
    if (legendRenderContext.series is CircularSeries &&
        stateProperties.chart.onCreateShader != null) {
      ChartShaderDetails chartShaderDetails;
      chartShaderDetails = ChartShaderDetails(pathRect, null, 'legend');
      legendShader = stateProperties.chart.onCreateShader(chartShaderDetails);
    }
    if (legendRenderContext.series is CircularSeries) {
      pointShaderMapper =
          PointHelper.getPointShaderMapper(legendRenderContext.point);
    }

    shader = legendRenderContext.series is CircularSeries &&
            (pointShaderMapper != null || legendShader != null)
        ? pointShaderMapper != null
            ? !legendRenderContext.isSelect
                ? pointShaderMapper(null, legendRenderContext.point?.index,
                    legendRenderContext.point?.fill, pathRect)
                : toggledLegendShader
            : !legendRenderContext.isSelect
                ? legendShader
                : toggledLegendShader
        : null;
    return shader;
  }

  /// To get overlayMarker type for line series type legend icons.
  ShapeMarkerType? _getOverlayMarkerType(
      LegendRenderContext? legendRenderContext) {
    ShapeMarkerType? overlayMarkerType;
    if (legendRenderContext!.iconType == LegendIconType.seriesType) {
      overlayMarkerType = (legendRenderContext.seriesRenderer.seriesType ==
                      'line' ||
                  legendRenderContext.seriesRenderer.seriesType == 'fastline' ||
                  legendRenderContext.seriesRenderer.seriesType
                          .contains('stackedline') ==
                      true) &&
              legendRenderContext.series.markerSettings.isVisible == true &&
              legendRenderContext.series.markerSettings.shape !=
                  DataMarkerType.image
          ? _getMarkerIconType(legendRenderContext.series.markerSettings.shape)
          : null;
    }
    return overlayMarkerType;
  }

  /// To get legend icon shape based on series marker shape.
  ShapeMarkerType _getMarkerIconType(DataMarkerType shape) {
    ShapeMarkerType? iconType;
    switch (shape) {
      case DataMarkerType.circle:
        iconType = ShapeMarkerType.circle;
        break;
      case DataMarkerType.rectangle:
        iconType = ShapeMarkerType.rectangle;
        break;
      case DataMarkerType.image:
        iconType = ShapeMarkerType.image;
        break;
      case DataMarkerType.pentagon:
        iconType = ShapeMarkerType.pentagon;
        break;
      case DataMarkerType.verticalLine:
        iconType = ShapeMarkerType.verticalLine;
        break;
      case DataMarkerType.invertedTriangle:
        iconType = ShapeMarkerType.invertedTriangle;
        break;
      case DataMarkerType.horizontalLine:
        iconType = ShapeMarkerType.horizontalLine;
        break;
      case DataMarkerType.diamond:
        iconType = ShapeMarkerType.diamond;
        break;
      case DataMarkerType.triangle:
        iconType = ShapeMarkerType.triangle;
        break;
      case DataMarkerType.none:
        break;
    }
    return iconType!;
  }

  /// To get the legend icon type for SfLegend.
  ShapeMarkerType _getEffectiveLegendIconType(LegendIconType iconType,
      [LegendRenderContext? legendRenderContext, String? seriesType]) {
    ShapeMarkerType legendIconType;
    switch (iconType) {
      case LegendIconType.circle:
        legendIconType = ShapeMarkerType.circle;
        break;
      case LegendIconType.rectangle:
        legendIconType = ShapeMarkerType.rectangle;
        break;
      case LegendIconType.pentagon:
        legendIconType = ShapeMarkerType.pentagon;
        break;
      case LegendIconType.verticalLine:
        legendIconType = ShapeMarkerType.verticalLine;
        break;
      case LegendIconType.horizontalLine:
        legendIconType = ShapeMarkerType.horizontalLine;
        break;
      case LegendIconType.diamond:
        legendIconType = ShapeMarkerType.diamond;
        break;
      case LegendIconType.triangle:
        legendIconType = ShapeMarkerType.triangle;
        break;
      case LegendIconType.invertedTriangle:
        legendIconType = ShapeMarkerType.invertedTriangle;
        break;
      case LegendIconType.image:
        legendIconType = ShapeMarkerType.image;
        break;
      case LegendIconType.seriesType:
        legendIconType =
            _getSeriesLegendIconType(seriesType!, legendRenderContext!);
        break;
    }
    return legendIconType;
  }

  /// To get effective series type legend icon for SfLegend.
  ShapeMarkerType _getSeriesLegendIconType(
      String seriesType, LegendRenderContext context) {
    switch (seriesType) {
      case 'line':
      case 'fastline':
      case 'stackedline':
      case 'stackedline100':
        return context.series.dashArray[0] != 0
            ? ShapeMarkerType.lineSeriesWithDashArray
            : ShapeMarkerType.lineSeries;
      case 'spline':
        return context.series.dashArray[0] != 0
            ? ShapeMarkerType.splineSeriesWithDashArray
            : ShapeMarkerType.splineSeries;
      case 'splinearea':
      case 'splinerangearea':
        return ShapeMarkerType.splineAreaSeries;
      case 'bar':
      case 'stackedbar':
      case 'stackedbar100':
        return ShapeMarkerType.barSeries;
      case 'column':
      case 'stackedcolumn':
      case 'stackedcolumn100':
      case 'rangecolumn':
      case 'histogram':
        return ShapeMarkerType.columnSeries;
      case 'area':
      case 'stackedarea':
      case 'rangearea':
      case 'stackedarea100':
        return ShapeMarkerType.areaSeries;
      case 'stepline':
        return context.series.dashArray[0] != 0
            ? ShapeMarkerType.stepLineSeriesWithDashArray
            : ShapeMarkerType.stepLineSeries;
      case 'scatter':
        return _getMarkerIconType(context.series.markerSettings.shape);
      case 'bubble':
        return ShapeMarkerType.bubbleSeries;
      case 'hilo':
        return ShapeMarkerType.hiloSeries;
      case 'hiloopenclose':
      case 'candle':
        return ShapeMarkerType.hiloOpenCloseSeries;
      case 'waterfall':
      case 'boxandwhisker':
        return ShapeMarkerType.waterfallSeries;
      case 'pie':
        return ShapeMarkerType.pieSeries;
      case 'doughnut':
        return ShapeMarkerType.doughnutSeries;
      case 'radialbar':
        return ShapeMarkerType.radialBarSeries;
      case 'steparea':
        return ShapeMarkerType.stepAreaSeries;
      case 'pyramid':
        return ShapeMarkerType.pyramidSeries;
      case 'funnel':
        return ShapeMarkerType.funnelSeries;
      case 'errorbar':
        return ShapeMarkerType.verticalLine;
      default:
        return ShapeMarkerType.circle;
    }
  }
}
