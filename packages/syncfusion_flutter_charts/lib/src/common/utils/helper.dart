import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/legend_internal.dart'
    hide LegendPosition;
import 'package:syncfusion_flutter_core/legend_internal.dart' as legend_common;
import 'package:syncfusion_flutter_core/theme.dart';

import '../../chart/axis/axis.dart';
import '../../chart/base/chart_base.dart';
import '../../chart/chart_series/financial_series_base.dart';
import '../../chart/chart_series/series.dart';
import '../../chart/chart_series/series_renderer_properties.dart';
import '../../chart/chart_series/xy_data_series.dart';
import '../../chart/common/cartesian_state_properties.dart';
import '../../chart/common/data_label.dart';
import '../../chart/technical_indicators/technical_indicator.dart';
import '../../chart/utils/enum.dart';
import '../../chart/utils/helper.dart';
import '../../circular_chart/base/circular_base.dart';
import '../../circular_chart/renderer/common.dart';
import '../../funnel_chart/base/funnel_base.dart';
import '../../pyramid_chart/base/pyramid_base.dart';
import '../../pyramid_chart/utils/common.dart';
import '../../pyramid_chart/utils/helper.dart';
import '../common.dart';
import '../event_args.dart';
import '../legend/legend.dart';
import '../legend/renderer.dart';
import '../rendering_details.dart';
import '../state_properties.dart';
import '../utils/enum.dart';
import 'typedef.dart';

/// `onDataLabelTapped` event for all series.
void dataLabelTapEvent(dynamic chart, DataLabelSettings dataLabelSettings,
    int pointIndex, dynamic point, Offset position, int seriesIndex) {
  DataLabelTapDetails datalabelArgs;
  datalabelArgs = DataLabelTapDetails(
      seriesIndex,
      pointIndex,
      chart is SfCartesianChart
          ? point.dataLabelRegion.contains(position)
              ? point.label
              : point.dataLabelRegion2.contains(position)
                  ? point.label2
                  : point.dataLabelRegion3.contains(position)
                      ? point.label3
                      : point.dataLabelRegion4.contains(position)
                          ? point.label4
                          : point.label5
          : point.text,
      dataLabelSettings,
      chart is SfCartesianChart ? point.overallDataPointIndex : pointIndex);
  datalabelArgs.position = position;
  chart.onDataLabelTapped(datalabelArgs);
  position = datalabelArgs.position;
}

/// To get saturation color.
Color getSaturationColor(Color color) {
  Color saturationColor;
  final num contrast =
      ((color.red * 299 + color.green * 587 + color.blue * 114) / 1000).round();
  saturationColor = contrast >= 128 ? Colors.black : Colors.white;
  return saturationColor;
}

/// To get point from data and return point data.
CartesianChartPoint<dynamic> getPointFromData(
    SeriesRendererDetails seriesRendererDetails, int pointIndex) {
  final XyDataSeries<dynamic, dynamic> series =
      seriesRendererDetails.series as XyDataSeries<dynamic, dynamic>;
  final ChartIndexedValueMapper<dynamic>? xValue = series.xValueMapper;
  final ChartIndexedValueMapper<dynamic>? yValue = series.yValueMapper;
  final dynamic xVal = xValue!(pointIndex);
  final dynamic yVal = (seriesRendererDetails.seriesType.contains('range') ||
          seriesRendererDetails.seriesType.contains('hilo') ||
          seriesRendererDetails.seriesType == 'candle')
      ? null
      : yValue!(pointIndex);

  final CartesianChartPoint<dynamic> point =
      CartesianChartPoint<dynamic>(xVal, yVal);
  if (seriesRendererDetails.seriesType.contains('range') ||
      seriesRendererDetails.seriesType.contains('hilo') ||
      seriesRendererDetails.seriesType == 'candle') {
    final ChartIndexedValueMapper<num>? highValue = series.highValueMapper;
    final ChartIndexedValueMapper<num>? lowValue = series.lowValueMapper;
    point.high = highValue!(pointIndex);
    point.low = lowValue!(pointIndex);
  }
  if (series is FinancialSeriesBase) {
    if (seriesRendererDetails.seriesType == 'hiloopenclose' ||
        seriesRendererDetails.seriesType == 'candle') {
      final ChartIndexedValueMapper<num>? openValue = series.openValueMapper;
      final ChartIndexedValueMapper<num>? closeValue = series.closeValueMapper;
      point.open = openValue!(pointIndex);
      point.close = closeValue!(pointIndex);
    }
  }
  return point;
}

/// To calculate dash array path for series.
Path? dashPath(
  Path? source, {
  required CircularIntervalList<double> dashArray,
}) {
  if (source == null) {
    return null;
  }
  const double intialValue = 0.0;
  final Path path = Path();
  for (final PathMetric measurePath in source.computeMetrics()) {
    double distance = intialValue;
    bool draw = true;
    while (distance < measurePath.length) {
      final double length = dashArray.next;
      if (draw) {
        path.addPath(
            measurePath.extractPath(distance, distance + length), Offset.zero);
      }
      distance += length;
      draw = !draw;
    }
  }
  return path;
}

/// To return textstyle.
TextStyle getTextStyle(
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

/// Method to get the elements.
Widget? getElements(StateProperties stateProperties, Widget chartWidget,
    BoxConstraints constraints) {
  final dynamic chart = stateProperties.chart;
  final ChartLegend chartLegend = stateProperties.renderingDetails.chartLegend;
  final LegendPosition legendPosition =
      stateProperties.renderingDetails.legendRenderer.legendPosition;
  final LegendRenderer legendRenderer =
      stateProperties.renderingDetails.legendRenderer;
  final Legend legend = chart.legend;
  final List<MeasureWidgetContext> legendWidgetContext =
      stateProperties.renderingDetails.legendWidgetContext;

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
    element = SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: chartWidget);
  } else {
    legendHeight = chartLegend.legendSize.height;
    legendWidth = chartLegend.legendSize.width;
    chartHeight = chartLegend.chartSize.height - legendHeight;
    chartWidth = chartLegend.chartSize.width - legendWidth;

    // To determine the toggled indices of the legend items.
    final List<int> toggledIndices = chartLegend.toggledIndices;
    if (chart is SfCartesianChart) {
      toggledIndices.clear();
      if (legend.legendItemBuilder == null) {
        final List<LegendRenderContext> legendCollections =
            stateProperties.renderingDetails.chartLegend.legendCollections!;
        for (int i = 0; i < legendCollections.length; i++) {
          final LegendRenderContext context = legendCollections[i];
          context.isSelect = (context.trendline != null)
              ? context.seriesRenderer
                      .trendlineRenderer[context.trendlineIndex!]!.visible ==
                  false
              : context.seriesRenderer is TechnicalIndicators<dynamic, dynamic>
                  ? !context.indicatorRenderer!.visible!
                  : context.seriesRenderer.visible == false;
          if (context.isSelect) {
            toggledIndices.add(i);
          }
        }
      } else {
        final List<MeasureWidgetContext> legendToggles =
            stateProperties.renderingDetails.legendToggleTemplateStates;
        for (final MeasureWidgetContext currentItem in legendWidgetContext) {
          for (int i = 0; i < legendToggles.length; i++) {
            final MeasureWidgetContext item = legendToggles[i];
            if (currentItem.seriesIndex == item.seriesIndex &&
                currentItem.pointIndex == item.pointIndex) {
              toggledIndices.add(legendWidgetContext.indexOf(currentItem));
              break;
            }
          }
        }
      }
      toggledIndices.sort();
    }

    if (legend.legendItemBuilder != null) {
      element = SfLegend.builder(
          title: getLegendTitleWidget(legend, stateProperties.renderingDetails),
          itemCount: legendWidgetContext.length,
          toggledIndices: chartLegend.toggledIndices,
          color: chartLegend.legend!.backgroundColor,
          border: getLegendBorder(
              chartLegend.legend!.borderColor, chartLegend.legend!.borderWidth),
          position: getEffectiveChartLegendPosition(legendPosition),
          direction: getEffectiveChartLegendOrientation(
              chartLegend.legend!, legendRenderer),
          scrollDirection: getEffectiveChartLegendOrientation(
              chartLegend.legend!, legendRenderer),
          alignment: getEffectiveLegendAlignment(chartLegend.legend!.alignment),
          itemBuilder: (BuildContext context, int index) {
            if (legendWidgetContext.isNotEmpty) {
              final MeasureWidgetContext legendRenderContext =
                  legendWidgetContext[index];
              return legendRenderContext.widget!;
            }
            return Container();
          },
          overflowMode: getEffectiveLegendItemOverflowMode(
              chartLegend.legend!.overflowMode, chartLegend),
          width: legendWidth,
          height: legendHeight,
          spacing: chartLegend.legend!.padding,
          itemSpacing: 0,
          itemRunSpacing: 0,
          padding: EdgeInsets.zero,
          margin: getEffectiveLegendMargin(chartLegend, legendPosition),
          toggledItemColor:
              stateProperties.renderingDetails.chartTheme.brightness ==
                      Brightness.light
                  ? Colors.white.withOpacity(0.5)
                  : Colors.grey[850]!.withOpacity(0.5),
          onToggledIndicesChanged:
              (List<int> toggledIndices, int toggledIndex) {
            if (chart is SfCartesianChart) {
              cartesianToggle(
                  toggledIndex, stateProperties as CartesianStateProperties);
            } else {
              circularAndTriangularToggle(toggledIndex, stateProperties);
              chartLegend.toggledIndices = toggledIndices;
            }
          },
          child: chartWidget);
    } else {
      element = SfLegend(
          title: getLegendTitleWidget(legend, stateProperties.renderingDetails),
          toggledIndices: chartLegend.toggledIndices,
          items: chartLegend.legendItems,
          offset: legend.offset,
          width: legendWidth,
          height: legendHeight,
          shouldAlwaysShowScrollbar: legend.shouldAlwaysShowScrollbar,
          onItemRenderer: (ItemRendererDetails args) {
            args.text = chartLegend.legendItems[args.index].text;
            if (chartLegend.legendItems[args.index].shader == null ||
                chartLegend.legendItems[args.index].iconStrokeWidth != null) {
              args.color = chartLegend.legendItems[args.index].color;
            }
            args.iconType = chartLegend.legendItems[args.index].iconType!;
          },
          color: chartLegend.legend!.backgroundColor,
          border: getLegendBorder(
              chartLegend.legend!.borderColor, chartLegend.legend!.borderWidth),
          position: getEffectiveChartLegendPosition(legendPosition),
          direction: getEffectiveChartLegendOrientation(
              chartLegend.legend!, legendRenderer),
          scrollDirection: getEffectiveChartLegendOrientation(
              chartLegend.legend!, legendRenderer),
          alignment: getEffectiveLegendAlignment(chartLegend.legend!.alignment),
          overflowMode: getEffectiveLegendItemOverflowMode(
              chartLegend.legend!.overflowMode, chartLegend),
          iconSize: Size(
              chartLegend.legend!.iconWidth, chartLegend.legend!.iconHeight),
          iconBorder: getLegendIconBorder(chartLegend.legend!.iconBorderColor,
              chartLegend.legend!.iconBorderWidth),
          textStyle:
              stateProperties.renderingDetails.chartTheme.legendTextStyle,
          spacing: legend.padding,
          itemSpacing: legend.itemPadding,
          itemRunSpacing: legend.itemPadding,
          padding: getEffectiveLegendPadding(
              chartLegend, legendRenderer, legendPosition),
          margin: getEffectiveLegendMargin(chartLegend, legendPosition),
          toggledIconColor: const Color.fromRGBO(211, 211, 211, 1),
          toggledTextOpacity: 0.2,
          onToggledIndicesChanged:
              (List<int> toggledIndices, int toggledIndex) {
            if (chart is SfCartesianChart) {
              cartesianToggle(
                  toggledIndex, stateProperties as CartesianStateProperties);
            } else {
              circularAndTriangularToggle(toggledIndex, stateProperties);
              chartLegend.toggledIndices = toggledIndices;
            }
          },
          child: chartWidget);
    }
  }
  return element;
}

/// To get effective legend position for SfLegend.
legend_common.LegendPosition getEffectiveChartLegendPosition(
    LegendPosition position) {
  switch (position) {
    case LegendPosition.top:
      return legend_common.LegendPosition.top;
    case LegendPosition.bottom:
      return legend_common.LegendPosition.bottom;
    case LegendPosition.left:
      return legend_common.LegendPosition.left;
    case LegendPosition.right:
      return legend_common.LegendPosition.right;
    // ignore: no_default_cases
    default:
      return legend_common.LegendPosition.bottom;
  }
}

/// To get effective legend orientation for SfLegend.
Axis getEffectiveChartLegendOrientation(
    Legend legend, LegendRenderer renderer) {
  final LegendItemOrientation legendOrientation = renderer.orientation;
  if (legend.orientation == LegendItemOrientation.auto) {
    if (legendOrientation == LegendItemOrientation.horizontal) {
      return Axis.horizontal;
    } else {
      return Axis.vertical;
    }
  } else {
    if (legend.orientation == LegendItemOrientation.horizontal) {
      return Axis.horizontal;
    } else {
      return Axis.vertical;
    }
  }
}

/// To get effective legend alignment for SfLegend.
LegendAlignment getEffectiveLegendAlignment(ChartAlignment alignment) {
  LegendAlignment legendAlignment;
  switch (alignment) {
    case ChartAlignment.near:
      legendAlignment = LegendAlignment.near;
      break;
    case ChartAlignment.far:
      legendAlignment = LegendAlignment.far;
      break;
    case ChartAlignment.center:
      legendAlignment = LegendAlignment.center;
      break;
  }
  return legendAlignment;
}

/// To get effective legend items overflow mode for SfLegend.
LegendOverflowMode getEffectiveLegendItemOverflowMode(
    LegendItemOverflowMode overflowMode, ChartLegend chartLegend) {
  LegendOverflowMode mode;
  switch (overflowMode) {
    case LegendItemOverflowMode.wrap:
      if (chartLegend.isNeedScrollable) {
        mode = LegendOverflowMode.wrapScroll;
      } else {
        mode = LegendOverflowMode.wrap;
      }
      break;
    case LegendItemOverflowMode.scroll:
      mode = LegendOverflowMode.scroll;
      break;
    case LegendItemOverflowMode.none:
      mode = LegendOverflowMode.none;
      break;
  }
  return mode;
}

/// To get border for SfLegend container.
BorderSide? getLegendBorder(Color borderColor, double borderWidth) {
  // ignore: unnecessary_null_comparison
  if (borderColor != null && borderWidth > 0) {
    return BorderSide(color: borderColor, width: borderWidth);
  }

  return null;
}

/// To get icon border for legendItemsin SfLegend.
BorderSide? getLegendIconBorder(Color iconBorderColor, double iconBorderWidth) {
  // ignore: unnecessary_null_comparison
  if (iconBorderColor != null && iconBorderWidth > 0) {
    return BorderSide(color: iconBorderColor, width: iconBorderWidth);
  }

  return null;
}

/// To get legend title widget for SfLegend.
Widget? getLegendTitleWidget(Legend legend, RenderingDetails renderingDetails) {
  final LegendTitle legendTitle = legend.title;
  if (legendTitle.text != null && legendTitle.text!.isNotEmpty) {
    final ChartAlignment titleAlign = legendTitle.alignment;
    final num titleHeight = measureText(legend.title.text!,
                renderingDetails.chartTheme.legendTitleTextStyle!)
            .height +
        10;
    renderingDetails.chartLegend.titleHeight = titleHeight.toDouble();
    return Container(
        height: titleHeight.toDouble(),
        width: renderingDetails.chartLegend.legendSize.width,
        alignment: titleAlign == ChartAlignment.center
            ? Alignment.center
            : titleAlign == ChartAlignment.near
                ? Alignment.centerLeft
                : Alignment.centerRight,
        // ignore: avoid_unnecessary_containers
        child: Container(
          child: Text(legend.title.text!,
              overflow: TextOverflow.ellipsis,
              style: renderingDetails.chartTheme.legendTitleTextStyle!),
        ));
  } else {
    return null;
  }
}

/// To get outer padding or margin for legend container.
EdgeInsetsGeometry getEffectiveLegendMargin(
    ChartLegend chartLegend, LegendPosition legendPosition) {
  final dynamic chart = chartLegend.chart;
  final EdgeInsets margin;
  final bool needPadding = chart is SfCircularChart ||
      chart is SfPyramidChart ||
      chart is SfFunnelChart;
  final ChartAlignment legendAlignment = chartLegend.legend!.alignment;
  const double legendMargin = 5;

  if (legendPosition == LegendPosition.top) {
    margin = EdgeInsets.fromLTRB(
        needPadding && legendAlignment == ChartAlignment.near
            ? legendMargin * 2
            : 0,
        legendMargin,
        needPadding && legendAlignment == ChartAlignment.far
            ? legendMargin * 2
            : 0,
        legendMargin);
  } else if (legendPosition == LegendPosition.bottom) {
    margin = EdgeInsets.fromLTRB(
        needPadding && legendAlignment == ChartAlignment.near
            ? legendMargin * 2
            : 0,
        legendMargin,
        needPadding && legendAlignment == ChartAlignment.far
            ? legendMargin * 2
            : 0,
        needPadding ? legendMargin : 0);
  } else if (legendPosition == LegendPosition.right) {
    margin = EdgeInsets.fromLTRB(legendMargin, 0,
        needPadding ? 3 * legendMargin : 0, needPadding ? 3 * legendMargin : 0);
  } else if (legendPosition == LegendPosition.left) {
    margin = EdgeInsets.fromLTRB(needPadding ? legendMargin / 2 : 0, 0, 0,
        needPadding ? 3 * legendMargin : 0);
  } else {
    margin = EdgeInsets.zero;
  }

  return margin;
}

/// To get internal padding for legend container.
EdgeInsetsGeometry getEffectiveLegendPadding(ChartLegend chartLegend,
    LegendRenderer legendRenderer, LegendPosition legendPosition) {
  final dynamic chart = chartLegend.chart;
  final Legend legend = chartLegend.legend!;
  final LegendItemOrientation legendOrientation = legendRenderer.orientation;
  final LegendItemOverflowMode overflowMode = legend.overflowMode;
  final EdgeInsetsGeometry padding;
  final double legendPadding = legend.itemPadding;
  final bool needPadding = chart is SfCircularChart ||
      chart is SfPyramidChart ||
      chart is SfFunnelChart;
  final bool needTitle =
      legend.title.text != null && legend.title.text!.isNotEmpty;

  if (legendPosition == LegendPosition.top ||
      legendPosition == LegendPosition.bottom) {
    if (legendOrientation == LegendItemOrientation.horizontal) {
      if (overflowMode == LegendItemOverflowMode.wrap) {
        padding = !chartLegend.isNeedScrollable
            ? EdgeInsets.fromLTRB(legendPadding, 0, 0, 0)
            : EdgeInsets.fromLTRB(
                legendPadding, legendPadding / 2, 0, legendPadding / 2);
      } else if (overflowMode == LegendItemOverflowMode.scroll) {
        padding = EdgeInsets.fromLTRB(legendPadding, 0, 0, 0);
      } else {
        padding = EdgeInsets.fromLTRB(
            legendPadding,
            needPadding && needTitle ? (legendPadding / 2) : 0,
            needPadding && needTitle ? legendPadding : 0,
            needPadding && needTitle ? (legendPadding / 2) : 0);
      }
    } else {
      if (overflowMode == LegendItemOverflowMode.wrap) {
        padding = !chartLegend.isNeedScrollable
            ? EdgeInsets.fromLTRB(0, legendPadding / 2, 0, 0)
            : EdgeInsets.fromLTRB(legendPadding, legendPadding / 2, 0, 0);
      } else if (overflowMode == LegendItemOverflowMode.scroll) {
        padding = EdgeInsets.fromLTRB(legendPadding / 2, legendPadding / 2,
            needTitle ? (legendPadding / 2) : 0, legendPadding / 2);
      } else {
        padding = EdgeInsets.fromLTRB(needTitle ? legendPadding : 0,
            legendPadding / 2, needTitle ? legendPadding : 0, 0);
      }
    }
  } else if (legendPosition == LegendPosition.right ||
      legendPosition == LegendPosition.left) {
    if (legendOrientation == LegendItemOrientation.horizontal) {
      if (overflowMode == LegendItemOverflowMode.wrap) {
        padding = !chartLegend.isNeedScrollable
            ? EdgeInsets.fromLTRB(
                needTitle ? 0 : legendPadding,
                needTitle ? (legendPadding / 2) : 0,
                0,
                needTitle ? (legendPadding / 2) : 0)
            : EdgeInsets.fromLTRB(
                needTitle ? (legendPadding / 2) : legendPadding,
                legendPadding / 2,
                0,
                legendPadding / 2);
      } else if (overflowMode == LegendItemOverflowMode.scroll) {
        padding = EdgeInsets.fromLTRB(
            legendPadding,
            needTitle ? (legendPadding / 2) : 0,
            0,
            needTitle ? (legendPadding / 2) : 0);
      } else {
        padding = EdgeInsets.fromLTRB(
            legendPadding,
            needTitle ? (legendPadding / 2) : 0,
            needTitle ? legendPadding : 0,
            0);
      }
    } else {
      if (overflowMode == LegendItemOverflowMode.wrap) {
        padding = !chartLegend.isNeedScrollable
            ? EdgeInsets.fromLTRB(needPadding ? (legendPadding / 2) : 0,
                legendPadding / 2, 0, needTitle ? (legendPadding / 2) : 0)
            : EdgeInsets.fromLTRB(legendPadding, legendPadding / 2, 0,
                needTitle ? (legendPadding / 2) : 0);
      } else if (overflowMode == LegendItemOverflowMode.scroll) {
        padding = EdgeInsets.fromLTRB(legendPadding / 2, legendPadding / 2,
            legendPadding / 2, legendPadding / 2);
      } else {
        padding = EdgeInsets.fromLTRB(
            0, legendPadding / 2, 0, needTitle ? legendPadding / 2 : 0);
      }
    }
  } else {
    padding = EdgeInsets.zero;
  }
  return padding;
}

/// Method to handle cartesian series legend toggling for SfLegend.
void cartesianToggle(int index, CartesianStateProperties stateProperties) {
  LegendTapArgs legendTapArgs;
  MeasureWidgetContext measureWidgetContext;
  LegendRenderContext legendRenderContext;
  final SfCartesianChart chart = stateProperties.chart;
  stateProperties.isTooltipHidden = true;
  if (chart.onLegendTapped != null) {
    if (chart.legend.legendItemBuilder != null) {
      measureWidgetContext =
          stateProperties.renderingDetails.legendWidgetContext[index];
      legendTapArgs = LegendTapArgs(
          stateProperties.chartSeries
              .visibleSeriesRenderers[measureWidgetContext.seriesIndex!],
          measureWidgetContext.seriesIndex!,
          0);
    } else {
      legendRenderContext = stateProperties
          .renderingDetails.chartLegend.legendCollections![index];
      legendTapArgs = LegendTapArgs(
          legendRenderContext.series, legendRenderContext.seriesIndex, 0);
    }
    chart.onLegendTapped!(legendTapArgs);
  }
  if (chart.legend.toggleSeriesVisibility == true) {
    if (chart.legend.legendItemBuilder != null) {
      legendToggleTemplateState(
          stateProperties.renderingDetails.legendWidgetContext[index],
          stateProperties,
          '');
    } else {
      cartesianLegendToggleState(
          stateProperties
              .renderingDetails.chartLegend.legendCollections![index],
          stateProperties);
    }
    stateProperties.renderingDetails.isLegendToggled = true;
    stateProperties.legendToggling = true;
    stateProperties.redraw();
  }
}

/// Method to handle Circular and triangular series legend toggling for SfLegend.
void circularAndTriangularToggle(int index, dynamic stateProperties) {
  LegendTapArgs legendTapArgs;
  const int seriesIndex = 0;
  final dynamic chart = stateProperties.chart;
  final ChartLegend chartLegend = stateProperties.renderingDetails.chartLegend;
  stateProperties.isTooltipHidden = true;
  if (chart.onLegendTapped != null) {
    if (chart != null) {
      legendTapArgs = LegendTapArgs(chart.series, seriesIndex, index);
    } else {
      legendTapArgs =
          LegendTapArgs(chart._series[seriesIndex], seriesIndex, index);
    }
    chart.onLegendTapped(legendTapArgs);
  }
  if (chart.legend.toggleSeriesVisibility == true) {
    if (chart.legend.legendItemBuilder != null) {
      final MeasureWidgetContext legendWidgetContext =
          stateProperties.renderingDetails.legendWidgetContext[index];
      legendToggleTemplateState(legendWidgetContext, stateProperties, '');
    } else {
      legendToggleState(chartLegend.legendCollections![index], stateProperties);
    }
    stateProperties.renderingDetails.isLegendToggled = true;
    stateProperties.redraw();
  }
}

/// Represents the value of measure widget size.
class MeasureWidgetSize extends StatelessWidget {
  /// Creates an instance of measure widget size.
  const MeasureWidgetSize(
      {required this.stateProperties,
      this.currentWidget,
      this.opacityValue,
      this.currentKey,
      this.seriesIndex,
      this.pointIndex,
      this.type});

  /// Holds the state properties value.
  final StateProperties stateProperties;

  /// Holds the value of current widget.
  final Widget? currentWidget;

  /// Holds the opacity value.
  final double? opacityValue;

  /// Holds the current key value.
  final Key? currentKey;

  /// Holds the series index value.
  final int? seriesIndex;

  /// Holds the point index value.
  final int? pointIndex;

  /// Holds the value of type.
  final String? type;
  @override
  Widget build(BuildContext context) {
    final List<MeasureWidgetContext> templates =
        stateProperties.renderingDetails.legendWidgetContext;
    templates.add(MeasureWidgetContext(
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

/// To return legend template toggled state.
bool legendToggleTemplateState(MeasureWidgetContext currentItem,
    StateProperties stateProperties, String checkType) {
  bool needSelect = false;
  final List<MeasureWidgetContext> legendToggles =
      stateProperties.renderingDetails.legendToggleTemplateStates;
  if (legendToggles.isNotEmpty) {
    for (int i = 0; i < legendToggles.length; i++) {
      final MeasureWidgetContext item = legendToggles[i];
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

/// To add legend toggle states in legend toggles list.
void legendToggleState(
    LegendRenderContext currentItem, StateProperties stateProperties) {
  bool needSelect = false;
  final List<LegendRenderContext> legendToggles =
      stateProperties.renderingDetails.legendToggleStates;
  if (legendToggles.isNotEmpty) {
    for (int i = 0; i < legendToggles.length; i++) {
      final LegendRenderContext item = legendToggles[i];
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

/// To add cartesian legend toggle states.
void cartesianLegendToggleState(
    LegendRenderContext currentItem, CartesianStateProperties stateProperties) {
  bool needSelect = false;
  final List<LegendRenderContext> legendToggles =
      stateProperties.renderingDetails.legendToggleStates;
  if (currentItem.trendline == null ||
      SeriesHelper.getSeriesRendererDetails(stateProperties
                  .chartSeries.visibleSeriesRenderers[currentItem.seriesIndex])
              .visible! ==
          true) {
    if (legendToggles.isNotEmpty) {
      for (int i = 0; i < legendToggles.length; i++) {
        final LegendRenderContext item = legendToggles[i];
        if (currentItem.trendline != null &&
            currentItem.trendline == item.trendline &&
            (currentItem.seriesIndex == item.seriesIndex &&
                currentItem.trendlineIndex == item.trendlineIndex)) {
          needSelect = true;
          legendToggles.removeAt(i);
          break;
        } else if (currentItem.trendline == null &&
                currentItem.seriesIndex == item.seriesIndex &&
                !item.isTrendline! &&
                item.seriesRenderer is! TechnicalIndicators
            ? currentItem.series == item.series
            : item.isTrendline!
                ? currentItem.trendlineIndex == item.trendlineIndex
                : currentItem.text == item.text &&
                    currentItem.seriesIndex == item.seriesIndex) {
          needSelect = true;
          legendToggles.removeAt(i);
          break;
        }
      }
    }
    if (!needSelect) {
      if (!(currentItem.seriesRenderer is TechnicalIndicators
          ? !(currentItem.indicatorRenderer!.visible! &&
              currentItem.indicatorRenderer!.technicalIndicatorRenderer.period >
                  0)
          : SeriesHelper.getSeriesRendererDetails(
                          currentItem.seriesRenderer.renderer)
                      .visible ==
                  false &&
              stateProperties.isTrendlineToggled == false)) {
        needSelect = false;
        final SeriesRendererDetails seriesRendererDetails =
            SeriesHelper.getSeriesRendererDetails(stateProperties
                .chartSeries.visibleSeriesRenderers[currentItem.seriesIndex]);
        if (currentItem.trendlineIndex != null) {
          seriesRendererDetails.minimumX = 1 / 0;
          seriesRendererDetails.minimumY = 1 / 0;
          seriesRendererDetails.maximumX = -1 / 0;
          seriesRendererDetails.maximumY = -1 / 0;
        }
        stateProperties
                .chartSeries.visibleSeriesRenderers[currentItem.seriesIndex] =
            seriesRendererDetails.renderer;
        if (!legendToggles.contains(currentItem)) {
          legendToggles.add(currentItem);
        }
      }
    }
  }
}

/// For checking whether elements collide.
bool findingCollision(Rect rect, List<Rect> regions, [Rect? pathRect]) {
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

/// To find the labels are intersect.
bool isOverlap(Rect currentRect, Rect rect) {
  return currentRect.left < rect.left + rect.width &&
      currentRect.left + currentRect.width > rect.left &&
      currentRect.top < (rect.top + rect.height) &&
      (currentRect.height + currentRect.top) > rect.top;
}

/// To trim the text by given width.
String getTrimmedText(String text, num labelsExtent, TextStyle labelStyle,
    {ChartAxisRenderer? axisRenderer, bool? isRtl}) {
  String label = text;
  ChartAxisRendererDetails? axisRendererDetails;
  axisRendererDetails = axisRenderer != null
      ? AxisHelper.getAxisRendererDetails(axisRenderer)
      : null;
  num size = axisRenderer != null
      ? measureText(text, labelStyle, axisRendererDetails!.labelRotation).width
      : measureText(label, labelStyle).width;
  if (size > labelsExtent) {
    final int textLength = text.length;
    if (isRtl ?? false) {
      for (int i = 0; i < textLength - 1; i++) {
        label = '...${text.substring(i + 1, textLength)}';
        size = axisRenderer != null
            ? measureText(label, labelStyle, axisRendererDetails!.labelRotation)
                .width
            : measureText(label, labelStyle).width;
        if (size <= labelsExtent) {
          return label == '...' ? '' : label;
        }
      }
    } else {
      for (int i = textLength - 1; i >= 0; --i) {
        label = '${text.substring(0, i)}...';
        size = axisRenderer != null
            ? measureText(label, labelStyle, axisRendererDetails!.labelRotation)
                .width
            : measureText(label, labelStyle).width;
        if (size <= labelsExtent) {
          return label == '...' ? '' : label;
        }
      }
    }
  }
  return label == '...' ? '' : label;
}

/// To get equivalent value for the percentage.
num getValueByPercentage(num value1, num value2) {
  return value1.isNegative
      ? num.tryParse(
          '-${num.tryParse(value1.toString().replaceAll(RegExp('-'), ''))! % value2}')!
      : (value1 % value2);
}

/// Method to render the chart title.
Widget renderChartTitle(StateProperties stateProperties) {
  Widget titleWidget;
  final dynamic widget = stateProperties.chart;
  if (widget.title.text != null && widget.title.text.isNotEmpty == true) {
    final SfChartThemeData chartTheme =
        stateProperties.renderingDetails.chartTheme;
    titleWidget = Container(
      margin: EdgeInsets.fromLTRB(widget.margin.left, widget.margin.top,
          widget.margin.right, widget.margin.bottom),
      alignment: (widget.title.alignment == ChartAlignment.near)
          ? Alignment.topLeft
          : (widget.title.alignment == ChartAlignment.far)
              ? Alignment.topRight
              : (widget.title.alignment == ChartAlignment.center)
                  ? Alignment.topCenter
                  : Alignment.topCenter,
      child: Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          decoration: BoxDecoration(
              color: widget.title.backgroundColor ??
                  chartTheme.titleBackgroundColor,
              border: Border.all(
                  color: widget.title.borderColor ?? chartTheme.titleTextColor,
                  width: widget.title.borderWidth)),
          child: Text(widget.title.text,
              style: chartTheme.titleTextStyle,
              textScaleFactor: 1.2,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center)),
    );
  } else {
    titleWidget = Container();
  }
  return titleWidget;
}

/// To get the legend template widgets.
List<Widget> bindLegendTemplateWidgets(dynamic stateProperties) {
  Widget legendWidget;
  final dynamic widget = stateProperties.chart;
  final List<Widget> templates = <Widget>[];
  stateProperties.renderingDetails.chartWidgets = <Widget>[];

  if (widget.legend.isVisible == true &&
      widget.legend.legendItemBuilder != null) {
    for (int i = 0;
        i < stateProperties.chartSeries.visibleSeriesRenderers.length;
        i++) {
      final dynamic seriesRenderer =
          stateProperties.chartSeries.visibleSeriesRenderers[i];
      for (int j = 0; j < seriesRenderer.renderPoints.length; j++) {
        legendWidget = widget.legend.legendItemBuilder(
            seriesRenderer.renderPoints[j].x,
            seriesRenderer,
            seriesRenderer.renderPoints[j],
            j);
        templates.add(MeasureWidgetSize(
            stateProperties: stateProperties,
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

/// To check whether indexes are valid.
bool validIndex(int? pointIndex, int? seriesIndex, dynamic chart) {
  return seriesIndex != null &&
      pointIndex != null &&
      seriesIndex >= 0 &&
      seriesIndex < chart.series.length &&
      pointIndex >= 0 &&
      pointIndex < chart.series[seriesIndex].dataSource.length;
}

/// This method removes the given listener from the animation controller and then dsiposes it.
void disposeAnimationController(
    AnimationController? animationController, VoidCallback listener) {
  if (animationController != null) {
    animationController.removeListener(listener);
    animationController.dispose();
    animationController = null;
  }
}

/// Method to calculate the series point index.
void calculatePointSeriesIndex(
    dynamic chart, dynamic stateProperties, Offset? position,
    [Region? pointRegion, ActivationMode? activationMode]) {
  if (chart is SfCartesianChart) {
    for (int i = 0;
        i < stateProperties.chartSeries.visibleSeriesRenderers.length;
        i++) {
      final SeriesRendererDetails seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(
              stateProperties.chartSeries.visibleSeriesRenderers[i]);
      int? pointIndex;
      seriesRendererDetails.regionalData!
          .forEach((dynamic regionRect, dynamic values) {
        final Rect region = regionRect[0];
        final double widthPadding =
            region.width < 8 ? (8 - region.width) / 2 : 0;
        final double heightPadding =
            region.height < 8 ? (8 - region.height) / 2 : 0;
        final double left = region.left - widthPadding;
        final double right = region.right + widthPadding;
        final double top = region.top - heightPadding;
        final double bottom = region.bottom + heightPadding;
        final Rect paddedRegion = Rect.fromLTRB(left, top, right, bottom);
        if (paddedRegion.contains(position!)) {
          pointIndex = regionRect[4].visiblePointIndex;
        }
      });
      if (pointIndex != null && seriesRendererDetails.visible! == true) {
        if ((seriesRendererDetails.series.onPointTap != null ||
                seriesRendererDetails.series.onPointDoubleTap != null ||
                seriesRendererDetails.series.onPointLongPress != null) &&
            activationMode != null) {
          ChartPointDetails pointInteractionDetails;
          pointInteractionDetails = ChartPointDetails(
              i,
              pointIndex!,
              seriesRendererDetails.dataPoints,
              seriesRendererDetails
                  .visibleDataPoints![pointIndex!].overallDataPointIndex);
          activationMode == ActivationMode.singleTap
              ? seriesRendererDetails
                  .series.onPointTap!(pointInteractionDetails)
              : activationMode == ActivationMode.doubleTap
                  ? seriesRendererDetails
                      .series.onPointDoubleTap!(pointInteractionDetails)
                  : seriesRendererDetails
                      .series.onPointLongPress!(pointInteractionDetails);
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
          stateProperties
              .chartSeries.visibleSeriesRenderers[seriesIndex].dataPoints,
          pointRegion?.pointIndex);
      activationMode == ActivationMode.singleTap
          ? chart.series[seriesIndex].onPointTap!(pointInteractionDetails)
          : activationMode == ActivationMode.doubleTap
              ? chart.series[seriesIndex]
                  .onPointDoubleTap!(pointInteractionDetails)
              : chart.series[seriesIndex]
                  .onPointLongPress!(pointInteractionDetails);
    }
  } else {
    int? index;
    const int seriesIndex = 0;
    for (int i = 0; i < stateProperties.renderPoints!.length; i++) {
      if (stateProperties.renderPoints![i].region != null &&
          stateProperties.renderPoints![i].region!.contains(position) == true) {
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
            seriesIndex, index, stateProperties.dataPoints, index);
        activationMode == ActivationMode.singleTap
            ? chart.series.onPointTap!(pointInteractionDetails)
            : activationMode == ActivationMode.doubleTap
                ? chart.series.onPointDoubleTap!(pointInteractionDetails)
                : chart.series.onPointLongPress!(pointInteractionDetails);
      }
    }
  }
}

/// Point to pixel.
/// Used dynamic as the seriesRenderer can either be funnel or pyramid type series renderer.
Offset pyramidFunnelPointToPixel(
    PointInfo<dynamic> point, dynamic seriesRenderer) {
  Offset location;
  if (point.region == null) {
    final dynamic x = point.x;
    final num y = point.y!;
    for (int i = 0; i < seriesRenderer.dataPoints.length; i++) {
      if (seriesRenderer.dataPoints[i].x == x &&
          seriesRenderer.dataPoints[i].y == y) {
        point = seriesRenderer.dataPoints[i];
      }
    }
  }
  if (seriesRenderer.series.dataLabelSettings.isVisible == false) {
    point.symbolLocation = Offset(point.region!.left + point.region!.width / 2,
        point.region!.top + point.region!.height / 2);
  }
  location = point.symbolLocation;
  location = Offset(location.dx, location.dy);
  return location;
}

/// Pixel to point.
PointInfo<dynamic> pyramidFunnelPixelToPoint(
    Offset position, dynamic seriesRenderer) {
  final dynamic chartState = seriesRenderer.stateProperties;
  const int seriesIndex = 0;

  late int? pointIndex;
  bool isPoint;
  for (int j = 0; j < seriesRenderer.renderPoints!.length; j++) {
    if (seriesRenderer.renderPoints![j].isVisible == true) {
      isPoint = isPointInPolygon(
          seriesRenderer.renderPoints![j].pathRegion, position);
      if (isPoint) {
        pointIndex = j;
        break;
      }
    }
  }
  final PointInfo<dynamic> chartPoint = chartState
      .chartSeries.visibleSeriesRenderers[seriesIndex].renderPoints[pointIndex];

  return chartPoint;
}

/// Add the ellipse with trimmed text.
String addEllipse(String text, int maxLength, String ellipse, {bool? isRtl}) {
  if (isRtl ?? false) {
    if (text.contains(ellipse)) {
      text = text.replaceAll(ellipse, '');
      text = text.substring(1, text.length);
    } else {
      text = text.substring(ellipse.length, text.length);
    }
    return ellipse + text;
  } else {
    maxLength--;
    final int length = maxLength - ellipse.length;
    final String trimText = text.substring(0, length);
    return trimText + ellipse;
  }
}

/// To check template is within bounds.
bool isTemplateWithinBounds(Rect bounds, Rect templateRect) =>
    templateRect.left >= bounds.left &&
    templateRect.left + templateRect.width <= bounds.left + bounds.width &&
    templateRect.top >= bounds.top &&
    templateRect.top + templateRect.height <= bounds.top + bounds.height;
