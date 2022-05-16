import 'package:flutter/material.dart';
import '../../../charts.dart';
import '../../chart/chart_series/series.dart';
import '../../chart/technical_indicators/technical_indicator.dart';

/// Represents the legend render context chart.
class LegendRenderContext {
  /// Creates an instance of legend render context.
  LegendRenderContext(
      {this.size,
      required this.text,
      this.textSize,
      required this.iconColor,
      required this.iconType,
      this.point,
      required this.isSelect,
      this.trendline,
      required this.seriesIndex,
      this.trendlineIndex,
      this.seriesRenderer,
      this.isTrendline,
      this.indicatorRenderer})
      : series = seriesRenderer is TechnicalIndicators<dynamic, dynamic>
            ? seriesRenderer
            : seriesRenderer is CartesianSeriesRenderer
                ? SeriesHelper.getSeriesRendererDetails(seriesRenderer).series
                : seriesRenderer.series;

  /// Specifies the value of text.
  String text;

  /// Holds the value of icon color.
  Color? iconColor;

  /// Holds the value of text size.
  Size? textSize;

  /// Holds the value legend icon type.
  LegendIconType iconType;

  /// Specifies the size value.
  Size? size;

  /// Specifies the value of template size.
  Size? templateSize;

  /// Specifies the value of series.
  dynamic series;

  /// Holds the series renderer value.
  dynamic seriesRenderer;

  /// Holds the indicator renderer.
  TechnicalIndicatorsRenderer? indicatorRenderer;

  /// Holds the value if trendline.
  Trendline? trendline;

  /// Holds the value of point.
  dynamic point;

  /// Specifies the series index value.
  int seriesIndex;

  /// Specifies the value of trendline index.
  int? trendlineIndex;

  /// Specifies whether the legend is selected.
  bool isSelect;

  /// Specifies whether the legend is rendered.
  bool isRender = false;

  /// Specifies whether it is trendline legend.
  bool? isTrendline = false;
}
