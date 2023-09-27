import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../chart/common/data_label.dart';
import '../../chart/utils/enum.dart';
import '../../common/utils/helper.dart';
import '../base/circular_base.dart';
import '../base/circular_state_properties.dart';
import 'chart_point.dart';
import 'circular_series.dart';
import 'radial_bar_series.dart';
import 'renderer_extension.dart';

/// Represents the region.
///
class Region {
  /// Creates the instance for region.
  ///
  Region(this.start, this.end, this.startAngle, this.endAngle, this.seriesIndex,
      this.pointIndex, this.center, this.innerRadius, this.outerRadius);

  /// Specifies the series index.
  int seriesIndex;

  /// Specifies the point index.
  int pointIndex;

  /// Specifies the start angle.
  num startAngle;

  /// Specifies the start value.
  num start;

  /// Specifies the end value.
  num end;

  /// Specifies the end angle.
  num endAngle;

  ///Specifies the center value.
  Offset? center;

  /// Specifies the value of inner radius.
  num? innerRadius;

  /// Specifies the value of outer radius.
  num outerRadius;
}

/// Represents the style options.
///
class StyleOptions {
  /// Creates the instance of style options.
  ///
  StyleOptions({this.fill, this.strokeWidth, this.strokeColor, this.opacity});

  /// Specifies the value of fill.
  Color? fill;

  /// Specifies the value of stroke color.
  Color? strokeColor;

  /// Specifies the value of opacity.
  double? opacity;

  /// Specifies the value of stroke width.
  num? strokeWidth;
}

/// Represents the circular chart interaction.
///
class ChartInteraction {
  /// Creates the instance for circular chart interaction.
  ///
  ChartInteraction(this.seriesIndex, this.pointIndex, this.series, this.point,
      [this.region]);

  /// Specifies the value of series index.
  int? seriesIndex;

  /// Specifies the value of point index.
  int? pointIndex;

  /// Specifies the value of series.
  dynamic series;

  /// Specifies the point value.
  dynamic point;

  /// Specifies the value of region.
  Region? region;
}

/// To get circular series data label saturation color.
Color getCircularDataLabelColor(
    ChartPoint<dynamic> currentPoint,
    CircularSeriesRendererExtension seriesRenderer,
    CircularStateProperties stateProperties) {
  Color color;
  final DataLabelSettings dataLabel = seriesRenderer.series.dataLabelSettings;
  final DataLabelSettingsRenderer dataLabelSettingsRenderer =
      seriesRenderer.dataLabelSettingsRenderer;
  final String seriesType = seriesRenderer.seriesType == 'pie'
      ? 'Pie'
      : seriesRenderer.seriesType == 'doughnut'
          ? 'Doughnut'
          : seriesRenderer.seriesType == 'radialbar'
              ? 'RadialBar'
              : 'Default';
  switch (seriesType) {
    case 'Pie':
    case 'Doughnut':
      color = (currentPoint.renderPosition == ChartDataLabelPosition.inside &&
              !currentPoint.saturationRegionOutside)
          ? getInnerColor(dataLabelSettingsRenderer.color, currentPoint.fill,
              stateProperties.renderingDetails.chartTheme)
          : getOuterColor(
              dataLabelSettingsRenderer.color,
              dataLabel.useSeriesColor
                  ? currentPoint.fill
                  : (stateProperties.chart.backgroundColor ??
                      stateProperties
                          .renderingDetails.chartTheme.plotAreaBackgroundColor),
              stateProperties.renderingDetails.chartTheme);
      break;
    case 'RadialBar':
      final RadialBarSeries<dynamic, dynamic> radialBar =
          seriesRenderer.series as RadialBarSeries<dynamic, dynamic>;
      color = radialBar.trackColor;
      break;
    default:
      color = Colors.white;
  }
  return getSaturationColor(color);
}

/// To get inner data label color.
Color getInnerColor(
        Color? dataLabelColor, Color? pointColor, SfChartThemeData theme) =>
    // ignore: prefer_if_null_operators
    dataLabelColor != null
        ? dataLabelColor
        // ignore: prefer_if_null_operators
        : pointColor != null
            ? pointColor
            : theme.brightness == Brightness.light
                ? const Color.fromRGBO(255, 255, 255, 1)
                : Colors.black;

/// To get outer data label color.
Color getOuterColor(
        Color? dataLabelColor, Color backgroundColor, SfChartThemeData theme) =>
    // ignore: prefer_if_null_operators
    dataLabelColor != null
        ? dataLabelColor
        : backgroundColor != Colors.transparent
            ? backgroundColor
            : theme.brightness == Brightness.light
                ? const Color.fromRGBO(255, 255, 255, 1)
                : Colors.black;

/// To check whether any point is selected.
bool checkIsAnyPointSelect(CircularSeriesRendererExtension seriesRenderer,
    ChartPoint<dynamic>? point, SfCircularChart chart) {
  bool isAnyPointSelected = false;
  final CircularSeries<dynamic, dynamic> series = seriesRenderer.series;
  if (series.initialSelectedDataIndexes.isNotEmpty) {
    int data;
    for (int i = 0; i < series.initialSelectedDataIndexes.length; i++) {
      data = series.initialSelectedDataIndexes[i];
      for (int j = 0; j < seriesRenderer.renderPoints!.length; j++) {
        if (j == data) {
          isAnyPointSelected = true;
          break;
        }
      }
    }
  }
  return isAnyPointSelected;
}

/// Represents the circular chart segment.
abstract class CircularChartSegment {
  /// To get point color of current point.
  Color? getPointColor(
      CircularSeriesRendererExtension seriesRenderer,
      ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      Color color,
      double opacity);

  /// To get opacity of current point.
  double getOpacity(
      CircularSeriesRendererExtension seriesRenderer,
      ChartPoint<dynamic>? point,
      int pointIndex,
      int seriesIndex,
      double opacity);

  /// To get Stroke color of current point.
  Color getPointStrokeColor(
      CircularSeriesRendererExtension seriesRenderer,
      ChartPoint<dynamic>? point,
      int pointIndex,
      int seriesIndex,
      Color strokeColor);

  /// To get Stroke width of current point.
  num getPointStrokeWidth(
      CircularSeriesRendererExtension seriesRenderer,
      ChartPoint<dynamic>? point,
      int pointIndex,
      int seriesIndex,
      num strokeWidth);
}

/// Represents the label segment.
abstract class LabelSegment {
  /// To get label text content.
  String getLabelContent(
      CircularSeriesRendererExtension seriesRenderer,
      ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      String content);

  /// To get text style of current point.
  TextStyle getDataLabelStyle(
      CircularSeriesRendererExtension seriesRenderer,
      ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      TextStyle style,
      SfCircularChartState chartState);

  /// To get data label color.
  Color? getDataLabelColor(CircularSeriesRendererExtension seriesRenderer,
      ChartPoint<dynamic> point, int pointIndex, int seriesIndex, Color? color);

  /// To get the data label stroke color.
  Color getDataLabelStrokeColor(
      CircularSeriesRendererExtension seriesRenderer,
      ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      Color strokeColor);

  /// To get label stroke width.
  double getDataLabelStrokeWidth(
      CircularSeriesRendererExtension seriesRenderer,
      ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      double strokeWidth);
}

/// Represents the chart series renderer.
class ChartSeriesRender with CircularChartSegment, LabelSegment {
  /// Creates an instance for chart series renderer.
  ChartSeriesRender();

  /// Creates an instance for chart series renderer.
  @override
  Color? getPointColor(
          CircularSeriesRendererExtension seriesRenderer,
          ChartPoint<dynamic> point,
          int pointIndex,
          int seriesIndex,
          Color color,
          double opacity) =>
      color.withOpacity(opacity);

  /// To get point stroke color.
  @override
  Color getPointStrokeColor(
          CircularSeriesRendererExtension seriesRenderer,
          ChartPoint<dynamic>? point,
          int pointIndex,
          int seriesIndex,
          Color strokeColor) =>
      strokeColor;

  /// To get point stroke width.
  @override
  num getPointStrokeWidth(
          CircularSeriesRendererExtension seriesRenderer,
          ChartPoint<dynamic>? point,
          int pointIndex,
          int seriesIndex,
          num strokeWidth) =>
      strokeWidth;

  /// To return label text.
  @override
  String getLabelContent(
          CircularSeriesRendererExtension seriesRenderer,
          ChartPoint<dynamic> point,
          int pointIndex,
          int seriesIndex,
          String content) =>
      content;

  /// To return text style of label.
  @override
  TextStyle getDataLabelStyle(
      CircularSeriesRendererExtension seriesRenderer,
      ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      TextStyle style,
      SfCircularChartState chartState) {
    final DataLabelSettings dataLabel = seriesRenderer.series.dataLabelSettings;
    final TextStyle textStyle = style.copyWith(
        color: _isCustomTextColor(
                dataLabel.textStyle,
                seriesRenderer.stateProperties.renderingDetails.chartTheme
                    .dataLabelTextStyle)
            ? dataLabel.textStyle?.color
            : getCircularDataLabelColor(
                point, seriesRenderer, seriesRenderer.stateProperties));
    return textStyle;
  }

  bool _isCustomTextColor(TextStyle? textStyle, TextStyle? themeStyle) {
    return textStyle?.color != null || themeStyle?.color != null;
  }

  /// To return label color.
  @override
  Color? getDataLabelColor(
          CircularSeriesRendererExtension seriesRenderer,
          ChartPoint<dynamic> point,
          int pointIndex,
          int seriesIndex,
          Color? color) =>
      color;

  /// To return label stroke color.
  @override
  Color getDataLabelStrokeColor(
          CircularSeriesRendererExtension seriesRenderer,
          ChartPoint<dynamic> point,
          int pointIndex,
          int seriesIndex,
          Color? strokeColor) =>
      strokeColor ?? point.fill;

  /// To return label stroke width.
  @override
  double getDataLabelStrokeWidth(
          CircularSeriesRendererExtension seriesRenderer,
          ChartPoint<dynamic> point,
          int pointIndex,
          int seriesIndex,
          double strokeWidth) =>
      strokeWidth;

  /// To return opacity of current point.
  @override
  double getOpacity(
          CircularSeriesRendererExtension seriesRenderer,
          ChartPoint<dynamic>? point,
          int pointIndex,
          int seriesIndex,
          double opacity) =>
      opacity;
}
