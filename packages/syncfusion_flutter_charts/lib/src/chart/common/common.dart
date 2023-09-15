import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as dart_ui;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../common/event_args.dart';
import '../../common/rendering_details.dart';
import '../../common/utils/enum.dart';
import '../../common/utils/helper.dart';
import '../../common/utils/typedef.dart';
import '../axis/axis.dart';
import '../axis/datetime_axis.dart' show DateTimeAxisDetails;
import '../base/chart_base.dart';
import '../chart_segment/chart_segment.dart';
import '../chart_segment/scatter_segment.dart';
import '../chart_series/error_bar_series.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/stacked_series_base.dart';
import '../chart_series/waterfall_series.dart';
import '../chart_series/xy_data_series.dart';
import '../common/cartesian_state_properties.dart';
import '../common/data_label.dart';
import '../common/renderer.dart';
import '../series_painter/box_and_whisker_painter.dart';
import '../series_painter/stacked_line_painter.dart';
import '../user_interaction/trackball.dart';
import '../utils/enum.dart'
    show ErrorBarType, RenderingMode, Direction, DateTimeIntervalType;
import '../utils/helper.dart';
import 'marker.dart';
import 'segment_properties.dart';

export 'package:syncfusion_flutter_core/core.dart'
    show DataMarkerType, TooltipAlignment;

/// Represents the custom paint style class.
class CustomPaintStyle {
  /// Creates an instance of custom paint class.
  CustomPaintStyle(this.strokeWidth, this.color, this.paintStyle);

  /// Specifies the color value.
  Color color;

  /// Specifies the value of stroke width.
  double strokeWidth;

  /// Specifies the value of painting style.
  PaintingStyle paintStyle;
}

/// Represents the axis size class.
class AxisSize {
  /// Creates an instance of axis size class.
  AxisSize(this.axisRenderer, this.size);

  /// Holds the value of size.
  double size;

  /// Holds the value of axis renderer.
  ChartAxisRenderer axisRenderer;
}

/// Represents the painter key.
class PainterKey {
  /// Creates an instance for painter key.
  PainterKey(
      {required this.index,
      required this.name,
      required this.isRenderCompleted});

  /// Represents the value of index.
  final int index;

  /// Specifies the key name.
  final String name;

  /// Specifies whether the rendering is completed.
  bool isRenderCompleted;
}

/// Represents the class of stacked values.
class StackedValues {
  /// Creates the instance of stacked values.
  StackedValues(this.startValues, this.endValues);

  /// Represents the start value.
  List<double> startValues;

  /// Represents the end values.
  List<double> endValues;
}

/// Represents the cluster stacked item info class.
class ClusterStackedItemInfo {
  /// Creates an instance of cluster stacked info.
  ClusterStackedItemInfo(this.stackName, this.stackedItemInfo);

  /// Holds the stack name value.
  String stackName;

  /// Holds the list of stacked item info.
  List<StackedItemInfo> stackedItemInfo;
}

/// Represents the stacked item info class.
class StackedItemInfo {
  /// Creates an instance of stacked item info.
  StackedItemInfo(this.seriesIndex, this.seriesRenderer);

  /// Specifies the value of series index.
  int seriesIndex;

  /// Specifies the value of stacked series renderer.
  StackedSeriesRenderer seriesRenderer;
}

/// To get Cartesian type data label saturation color.
Color getDataLabelSaturationColor(
    CartesianChartPoint<dynamic> currentPoint,
    SeriesRendererDetails seriesRendererDetails,
    CartesianStateProperties stateProperties,
    DataLabelSettingsRenderer dataLabelSettingsRenderer) {
  final SfCartesianChart chart = stateProperties.chart;
  Color color;
  final DataLabelSettings dataLabel =
      seriesRendererDetails.series.dataLabelSettings;
  final RenderingDetails renderingDetails = stateProperties.renderingDetails;
  final ChartDataLabelAlignment labelPosition =
      (seriesRendererDetails.seriesType == 'rangecolumn' &&
              (dataLabel.labelAlignment == ChartDataLabelAlignment.bottom ||
                  dataLabel.labelAlignment == ChartDataLabelAlignment.middle))
          ? ChartDataLabelAlignment.auto
          : dataLabel.labelAlignment;
  final ChartAlignment alignment = dataLabel.alignment;
  final String seriesType = seriesRendererDetails.seriesType == 'line' ||
          seriesRendererDetails.seriesType == 'stackedline' ||
          seriesRendererDetails.seriesType == 'stackedline100' ||
          seriesRendererDetails.seriesType == 'spline' ||
          seriesRendererDetails.seriesType == 'stepline'
      ? 'Line'
      : seriesRendererDetails.isRectSeries == true
          ? 'Column'
          : seriesRendererDetails.seriesType == 'bubble' ||
                  seriesRendererDetails.seriesType == 'scatter'
              ? 'Circle'
              : seriesRendererDetails.seriesType.contains('area') == true
                  ? 'area'
                  : 'Default';
  if (dataLabel.useSeriesColor || dataLabelSettingsRenderer.color != null) {
    color = dataLabelSettingsRenderer.color ??
        (currentPoint.pointColorMapper ?? seriesRendererDetails.seriesColor!);
  } else {
    switch (seriesType) {
      case 'Line':
        color = _getOuterDataLabelColor(dataLabelSettingsRenderer,
            chart.plotAreaBackgroundColor, renderingDetails.chartTheme);
        break;
      case 'Column':
        color = (!currentPoint.dataLabelSaturationRegionInside &&
                (labelPosition == ChartDataLabelAlignment.outer ||
                    (labelPosition == ChartDataLabelAlignment.top &&
                        alignment == ChartAlignment.far) ||
                    seriesRendererDetails.seriesType == 'rangecolumn' &&
                        (labelPosition == ChartDataLabelAlignment.top &&
                            alignment == ChartAlignment.near) ||
                    (labelPosition == ChartDataLabelAlignment.auto &&
                        (seriesRendererDetails.seriesType.contains('100') ==
                                false &&
                            seriesRendererDetails.seriesType != 'stackedbar' &&
                            seriesRendererDetails.seriesType !=
                                'stackedcolumn'))))
            ? _getOuterDataLabelColor(dataLabelSettingsRenderer,
                chart.plotAreaBackgroundColor, renderingDetails.chartTheme)
            : _getInnerDataLabelColor(currentPoint, seriesRendererDetails,
                renderingDetails.chartTheme);
        break;
      case 'Circle':
        color = (labelPosition == ChartDataLabelAlignment.middle &&
                    alignment == ChartAlignment.center ||
                labelPosition == ChartDataLabelAlignment.bottom &&
                    alignment == ChartAlignment.far ||
                labelPosition == ChartDataLabelAlignment.top &&
                    alignment == ChartAlignment.near ||
                labelPosition == ChartDataLabelAlignment.outer &&
                    alignment == ChartAlignment.near)
            ? _getInnerDataLabelColor(currentPoint, seriesRendererDetails,
                renderingDetails.chartTheme)
            : _getOuterDataLabelColor(dataLabelSettingsRenderer,
                chart.plotAreaBackgroundColor, renderingDetails.chartTheme);
        break;

      case 'area':

        /// This color was changed because of text theme support. This method was called before
        /// assigning the label position value, Due to calling the saturation method before the label position
        /// So, We have used line case code for area case.
        color = _getOuterDataLabelColor(dataLabelSettingsRenderer,
            chart.plotAreaBackgroundColor, renderingDetails.chartTheme);
        break;

      default:
        color = Colors.white;
    }
  }
  return getSaturationColor(color);
}

/// Get the data label color of open-close series
Color getOpenCloseDataLabelColor(CartesianChartPoint<dynamic> currentPoint,
    SeriesRendererDetails seriesRendererDetails, SfCartesianChart chart) {
  final int index = seriesRendererDetails.seriesType.contains('candle')
      ? seriesRendererDetails.visibleDataPoints!.indexOf(currentPoint)
      : seriesRendererDetails.dataPoints.indexOf(currentPoint);
  final Color color = seriesRendererDetails.segments[index].fillPaint!.style ==
          PaintingStyle.fill
      ? SegmentHelper.getSegmentProperties(
              seriesRendererDetails.segments[index])
          .color!
      : const Color.fromRGBO(255, 255, 255, 1);
  return getSaturationColor(color);
}

/// To get outer data label color
Color _getOuterDataLabelColor(
        DataLabelSettingsRenderer dataLabelSettingsRenderer,
        Color? backgroundColor,
        SfChartThemeData theme) =>
    dataLabelSettingsRenderer.color ??
    backgroundColor ??
    (theme.brightness == Brightness.light
        ? const Color.fromRGBO(255, 255, 255, 1)
        : Colors.black);

///To get inner data label
Color _getInnerDataLabelColor(CartesianChartPoint<dynamic> currentPoint,
    SeriesRendererDetails seriesRendererDetails, SfChartThemeData theme) {
  final DataLabelSettingsRenderer dataLabelSettingsRenderer =
      seriesRendererDetails.dataLabelSettingsRenderer;
  Color innerColor;
  Color? seriesColor = seriesRendererDetails.series.color;
  if (seriesRendererDetails.seriesType == 'waterfall') {
    seriesColor = getWaterfallSeriesColor(
        seriesRendererDetails.series as WaterfallSeries<dynamic, dynamic>,
        currentPoint,
        seriesColor);
  }
  // ignore: prefer_if_null_operators
  innerColor = dataLabelSettingsRenderer.color != null
      ? dataLabelSettingsRenderer.color!
      // ignore: prefer_if_null_operators
      : currentPoint.pointColorMapper != null
          // ignore: prefer_if_null_operators
          ? currentPoint.pointColorMapper!
          // ignore: prefer_if_null_operators
          : seriesColor != null
              ? seriesColor
              // ignore: prefer_if_null_operators
              : seriesRendererDetails.seriesColor != null
                  ? seriesRendererDetails.seriesColor!
                  : theme.brightness == Brightness.light
                      ? const Color.fromRGBO(255, 255, 255, 1)
                      : Colors.black;
  return innerColor;
}

/// To animate column and bar series
void animateRectSeries(
    Canvas canvas,
    CartesianSeriesRenderer seriesRenderer,
    Paint fillPaint,
    RRect segmentRect,
    num yPoint,
    double animationFactor,
    Rect? oldSegmentRect,
    num? oldYValue,
    bool? oldSeriesVisible) {
  final SeriesRendererDetails seriesRendererDetails =
      SeriesHelper.getSeriesRendererDetails(seriesRenderer);
  final bool comparePrev =
      seriesRendererDetails.stateProperties.renderingDetails.widgetNeedUpdate ==
              true &&
          oldYValue != null &&
          seriesRendererDetails.reAnimate == false &&
          oldSegmentRect != null;
  final bool isLargePrev = oldYValue != null && oldYValue > yPoint;
  final bool isSingleSeries =
      seriesRendererDetails.stateProperties.renderingDetails.isLegendToggled ==
              true &&
          _checkSingleSeries(seriesRendererDetails);
  ((seriesRendererDetails.seriesType == 'column' &&
              seriesRendererDetails.chart.isTransposed == true) ||
          (seriesRendererDetails.seriesType == 'bar' &&
              seriesRendererDetails.chart.isTransposed == false) ||
          (seriesRendererDetails.seriesType == 'histogram' &&
              seriesRendererDetails.chart.isTransposed == true))
      ? _animateTransposedRectSeries(
          canvas,
          seriesRendererDetails,
          fillPaint,
          segmentRect,
          yPoint,
          animationFactor,
          oldSegmentRect,
          oldSeriesVisible,
          comparePrev,
          isLargePrev,
          isSingleSeries,
          oldYValue)
      : _animateNormalRectSeries(
          canvas,
          seriesRendererDetails,
          fillPaint,
          segmentRect,
          yPoint,
          animationFactor,
          oldSegmentRect,
          oldSeriesVisible,
          comparePrev,
          isLargePrev,
          isSingleSeries,
          oldYValue);
}

/// To animate transposed bar and column series
void _animateTransposedRectSeries(
    Canvas canvas,
    SeriesRendererDetails seriesRendererDetails,
    Paint fillPaint,
    RRect segmentRect,
    num yPoint,
    double animationFactor,
    Rect? oldSegmentRect,
    bool? oldSeriesVisible,
    bool comparePrev,
    bool isLargePrev,
    bool isSingleSeries,
    num? oldYValue) {
  double width = segmentRect.width;
  final double height = segmentRect.height;
  final double top = segmentRect.top;
  double left = segmentRect.left, right = segmentRect.right;
  Rect? rect;
  const num defaultCrossesAtValue = 0;
  final num crossesAt = getCrossesAtValue(seriesRendererDetails.renderer,
          seriesRendererDetails.stateProperties) ??
      defaultCrossesAtValue;
  seriesRendererDetails.needAnimateSeriesElements =
      seriesRendererDetails.needAnimateSeriesElements == true ||
          segmentRect.outerRect != oldSegmentRect;
  if (seriesRendererDetails.stateProperties.renderingDetails.isLegendToggled ==
          false ||
      seriesRendererDetails.reAnimate == true) {
    width = segmentRect.width *
        ((!comparePrev &&
                seriesRendererDetails.reAnimate == false &&
                seriesRendererDetails
                        .stateProperties.renderingDetails.initialRender! ==
                    false &&
                oldSegmentRect == null &&
                seriesRendererDetails.series.key != null &&
                seriesRendererDetails.stateProperties.oldSeriesKeys
                        .contains(seriesRendererDetails.series.key) ==
                    true)
            ? 1
            : animationFactor);
    if (seriesRendererDetails.yAxisDetails!.axis.isInversed == false) {
      if (comparePrev) {
        if (yPoint < crossesAt) {
          left = isLargePrev
              ? oldSegmentRect!.left -
                  (animationFactor * (oldSegmentRect.left - segmentRect.left))
              : oldSegmentRect!.left +
                  (animationFactor * (segmentRect.left - oldSegmentRect.left));
          right = segmentRect.right;
          width = right - left;
        } else if (yPoint == crossesAt) {
          if (oldYValue != crossesAt) {
            if (oldYValue! < crossesAt) {
              left = oldSegmentRect!.left +
                  (animationFactor * (segmentRect.left - oldSegmentRect.left));
              right = segmentRect.right;
              width = right - left;
            } else {
              right = oldSegmentRect!.right +
                  (animationFactor *
                      (segmentRect.right - oldSegmentRect.right));
              width = right - segmentRect.left;
            }
          }
        } else {
          right = isLargePrev
              ? oldSegmentRect!.right +
                  (animationFactor * (segmentRect.right - oldSegmentRect.right))
              : oldSegmentRect!.right -
                  (animationFactor *
                      (oldSegmentRect.right - segmentRect.right));
          width = right - segmentRect.left;
        }
      } else {
        right = yPoint < crossesAt
            ? segmentRect.right
            : (segmentRect.right - segmentRect.width) + width;
      }
    } else {
      if (comparePrev) {
        if (yPoint < crossesAt) {
          right = isLargePrev
              ? oldSegmentRect!.right +
                  (animationFactor * (segmentRect.right - oldSegmentRect.right))
              : oldSegmentRect!.right -
                  (animationFactor *
                      (oldSegmentRect.right - segmentRect.right));
          width = right - segmentRect.left;
        } else if (yPoint == crossesAt) {
          if (oldYValue != crossesAt) {
            if (oldYValue! < crossesAt) {
              right = oldSegmentRect!.right -
                  (animationFactor *
                      (oldSegmentRect.right - segmentRect.right));
              width = right - segmentRect.left;
            } else {
              left = oldSegmentRect!.left -
                  (animationFactor * (oldSegmentRect.left - segmentRect.left));
              right = segmentRect.right;
              width = right - left;
            }
          }
        } else {
          left = isLargePrev
              ? oldSegmentRect!.left -
                  (animationFactor * (oldSegmentRect.left - segmentRect.left))
              : oldSegmentRect!.left +
                  (animationFactor * (segmentRect.left - oldSegmentRect.left));
          right = segmentRect.right;
          width = right - left;
        }
      } else {
        right = yPoint < crossesAt
            ? (segmentRect.right - segmentRect.width) + width
            : segmentRect.right;
      }
    }
    rect = Rect.fromLTWH(right - width, top, width, height);
  } else if (seriesRendererDetails
              .stateProperties.renderingDetails.isLegendToggled ==
          true &&
      oldSegmentRect != null) {
    rect = _performTransposedLegendToggleAnimation(
        seriesRendererDetails,
        segmentRect,
        oldSegmentRect,
        oldSeriesVisible,
        isSingleSeries,
        animationFactor);
  }

  canvas.drawRRect(
      RRect.fromRectAndCorners(rect ?? segmentRect.middleRect,
          bottomLeft: segmentRect.blRadius,
          bottomRight: segmentRect.brRadius,
          topLeft: segmentRect.tlRadius,
          topRight: segmentRect.trRadius),
      fillPaint);
}

/// To perform legend toggled animation on transposed chart
Rect _performTransposedLegendToggleAnimation(
    SeriesRendererDetails seriesRendererDetails,
    RRect segmentRect,
    Rect? oldSegmentRect,
    bool? oldSeriesVisible,
    bool isSingleSeries,
    double animationFactor) {
  final CartesianSeries<dynamic, dynamic> series = seriesRendererDetails.series;
  num bottom;
  double height = segmentRect.height;
  double top = segmentRect.top;
  double right = segmentRect.right;
  final double width = segmentRect.width;
  if (oldSeriesVisible != null && oldSeriesVisible) {
    bottom = oldSegmentRect!.bottom > segmentRect.bottom
        ? oldSegmentRect.bottom +
            (animationFactor * (segmentRect.bottom - oldSegmentRect.bottom))
        : oldSegmentRect.bottom -
            (animationFactor * (oldSegmentRect.bottom - segmentRect.bottom));
    top = oldSegmentRect.top > segmentRect.top
        ? oldSegmentRect.top -
            (animationFactor * (oldSegmentRect.top - segmentRect.top))
        : oldSegmentRect.top +
            (animationFactor * (segmentRect.top - oldSegmentRect.top));
    height = bottom - top;
  } else {
    if (series == seriesRendererDetails.chart.series[0] && !isSingleSeries) {
      if (seriesRendererDetails.xAxisDetails!.axis.isInversed) {
        top = segmentRect.top;
        height = segmentRect.height * animationFactor;
      } else {
        bottom = segmentRect.bottom;
        top = bottom - (segmentRect.height * animationFactor);
        height = bottom - top;
      }
    } else if (series ==
            seriesRendererDetails
                .chart.series[seriesRendererDetails.chart.series.length - 1] &&
        !isSingleSeries) {
      if (seriesRendererDetails.xAxisDetails!.axis.isInversed) {
        bottom = segmentRect.bottom;
        top = bottom - (segmentRect.height * animationFactor);
        height = bottom - top;
      } else {
        top = segmentRect.top;
        height = segmentRect.height * animationFactor;
      }
    } else {
      height = segmentRect.height * animationFactor;
      top = segmentRect.center.dy - height / 2;
    }
  }
  right = segmentRect.right;
  return Rect.fromLTWH(right - width, top, width, height);
}

/// Rect animation for bar and column series
void _animateNormalRectSeries(
    Canvas canvas,
    SeriesRendererDetails seriesRendererDetails,
    Paint fillPaint,
    RRect segmentRect,
    num yPoint,
    double animationFactor,
    Rect? oldSegmentRect,
    bool? oldSeriesVisible,
    bool comparePrev,
    bool isLargePrev,
    bool isSingleSeries,
    num? oldYValue) {
  double height = segmentRect.height;
  final double width = segmentRect.width;
  final double left = segmentRect.left;
  double top = segmentRect.top, bottom;
  Rect? rect;
  const num defaultCrossesAtValue = 0;
  final num crossesAt = getCrossesAtValue(seriesRendererDetails.renderer,
          seriesRendererDetails.stateProperties) ??
      defaultCrossesAtValue;
  seriesRendererDetails.needAnimateSeriesElements =
      seriesRendererDetails.needAnimateSeriesElements == true ||
          segmentRect.outerRect != oldSegmentRect;
  if (seriesRendererDetails.stateProperties.renderingDetails.isLegendToggled ==
          false ||
      seriesRendererDetails.reAnimate == true) {
    height = segmentRect.height *
        ((!comparePrev &&
                seriesRendererDetails.reAnimate == false &&
                seriesRendererDetails
                        .stateProperties.renderingDetails.initialRender! ==
                    false &&
                oldSegmentRect == null &&
                seriesRendererDetails.series.key != null &&
                seriesRendererDetails.stateProperties.oldSeriesKeys
                        .contains(seriesRendererDetails.series.key) ==
                    true)
            ? 1
            : animationFactor);
    if (seriesRendererDetails.yAxisDetails!.axis.isInversed == false) {
      if (comparePrev) {
        if (yPoint < crossesAt) {
          bottom = isLargePrev
              ? oldSegmentRect!.bottom -
                  (animationFactor *
                      (oldSegmentRect.bottom - segmentRect.bottom))
              : oldSegmentRect!.bottom +
                  (animationFactor *
                      (segmentRect.bottom - oldSegmentRect.bottom));
          height = bottom - top;
        } else if (yPoint == crossesAt) {
          if (oldYValue! != crossesAt) {
            if (oldYValue < crossesAt) {
              bottom = oldSegmentRect!.bottom +
                  (animationFactor *
                      (segmentRect.bottom - oldSegmentRect.bottom));
              height = bottom - top;
            } else {
              top = oldSegmentRect!.top +
                  (animationFactor * (segmentRect.top - oldSegmentRect.top));
              height = segmentRect.bottom - top;
            }
          }
        } else {
          top = isLargePrev
              ? oldSegmentRect!.top +
                  (animationFactor * (segmentRect.top - oldSegmentRect.top))
              : oldSegmentRect!.top -
                  (animationFactor * (oldSegmentRect.top - segmentRect.top));
          height = segmentRect.bottom - top;
        }
      } else {
        top = yPoint < crossesAt
            ? segmentRect.top
            : (segmentRect.top + segmentRect.height) - height;
      }
    } else {
      if (comparePrev) {
        if (yPoint < crossesAt) {
          top = isLargePrev
              ? oldSegmentRect!.top +
                  (animationFactor * (segmentRect.top - oldSegmentRect.top))
              : oldSegmentRect!.top -
                  (animationFactor * (oldSegmentRect.top - segmentRect.top));
          height = segmentRect.bottom - top;
        } else if (yPoint == crossesAt) {
          if (oldYValue! != crossesAt) {
            if (oldYValue < crossesAt) {
              top = oldSegmentRect!.top -
                  (animationFactor * (oldSegmentRect.top - segmentRect.top));
              height = segmentRect.bottom - top;
            } else {
              bottom = oldSegmentRect!.bottom -
                  (animationFactor *
                      (oldSegmentRect.bottom - segmentRect.bottom));
              height = bottom - top;
            }
          }
        } else {
          bottom = isLargePrev
              ? oldSegmentRect!.bottom -
                  (animationFactor *
                      (oldSegmentRect.bottom - segmentRect.bottom))
              : oldSegmentRect!.bottom +
                  (animationFactor *
                      (segmentRect.bottom - oldSegmentRect.bottom));
          height = bottom - top;
        }
      } else {
        top = yPoint < crossesAt
            ? (segmentRect.top + segmentRect.height) - height
            : segmentRect.top;
      }
    }
    rect = Rect.fromLTWH(left, top, width, height);
  } else if (seriesRendererDetails
              .stateProperties.renderingDetails.isLegendToggled ==
          true &&
      oldSegmentRect != null &&
      oldSeriesVisible != null) {
    rect = _performLegendToggleAnimation(seriesRendererDetails, segmentRect,
        oldSegmentRect, oldSeriesVisible, isSingleSeries, animationFactor);
  }
  canvas.drawRRect(
      RRect.fromRectAndCorners(rect ?? segmentRect.middleRect,
          bottomLeft: segmentRect.blRadius,
          bottomRight: segmentRect.brRadius,
          topLeft: segmentRect.tlRadius,
          topRight: segmentRect.trRadius),
      fillPaint);
}

/// Perform legend toggle animation
Rect _performLegendToggleAnimation(
    SeriesRendererDetails seriesRendererDetails,
    RRect segmentRect,
    Rect oldSegmentRect,
    bool oldSeriesVisible,
    bool isSingleSeries,
    double animationFactor) {
  num right;
  final CartesianSeries<dynamic, dynamic> series = seriesRendererDetails.series;
  final double height = segmentRect.height;
  double width = segmentRect.width;
  double left = segmentRect.left;
  final double top = segmentRect.top;
  if (oldSeriesVisible) {
    right = oldSegmentRect.right > segmentRect.right
        ? oldSegmentRect.right +
            (animationFactor * (segmentRect.right - oldSegmentRect.right))
        : oldSegmentRect.right -
            (animationFactor * (oldSegmentRect.right - segmentRect.right));
    left = oldSegmentRect.left > segmentRect.left
        ? oldSegmentRect.left -
            (animationFactor * (oldSegmentRect.left - segmentRect.left))
        : oldSegmentRect.left +
            (animationFactor * (segmentRect.left - oldSegmentRect.left));
    width = right - left;
  } else {
    if (series == seriesRendererDetails.chart.series[0] && !isSingleSeries) {
      if (seriesRendererDetails.xAxisDetails!.axis.isInversed) {
        right = segmentRect.right;
        left = right - (segmentRect.width * animationFactor);
        width = right - left;
      } else {
        left = segmentRect.left;
        width = segmentRect.width * animationFactor;
      }
    } else if (series ==
            seriesRendererDetails
                .chart.series[seriesRendererDetails.chart.series.length - 1] &&
        !isSingleSeries) {
      if (seriesRendererDetails.xAxisDetails!.axis.isInversed) {
        left = segmentRect.left;
        width = segmentRect.width * animationFactor;
      } else {
        right = segmentRect.right;
        left = right - (segmentRect.width * animationFactor);
        width = right - left;
      }
    } else {
      width = segmentRect.width * animationFactor;
      left = segmentRect.center.dx - width / 2;
    }
  }
  return Rect.fromLTWH(left, top, width, height);
}

/// To animation rect for stacked column series
void animateStackedRectSeries(
    Canvas canvas,
    RRect segmentRect,
    Paint fillPaint,
    SeriesRendererDetails seriesRendererDetails,
    double animationFactor,
    CartesianChartPoint<dynamic> currentPoint,
    CartesianStateProperties stateProperties) {
  int index, seriesIndex;
  List<CartesianSeriesRenderer> seriesCollection;
  Rect? prevRegion;
  final StackedSeriesBase<dynamic, dynamic> series =
      seriesRendererDetails.series as StackedSeriesBase<dynamic, dynamic>;
  index = seriesRendererDetails.dataPoints.indexOf(currentPoint);
  seriesCollection = findSeriesCollection(stateProperties);
  seriesIndex = seriesCollection.indexOf(seriesRendererDetails.renderer);
  bool isStackLine = false;
  if (seriesIndex != 0) {
    if (seriesRendererDetails.stateProperties.chartSeries
                .visibleSeriesRenderers[seriesIndex - 1]
            is StackedLineSeriesRenderer ||
        seriesRendererDetails.stateProperties.chartSeries
                .visibleSeriesRenderers[seriesIndex - 1]
            is StackedLine100SeriesRenderer) {
      isStackLine = true;
    }
    if (!isStackLine) {
      for (int j = 0;
          j < stateProperties.chartSeries.clusterStackedItemInfo.length;
          j++) {
        final ClusterStackedItemInfo clusterStackedItemInfo =
            stateProperties.chartSeries.clusterStackedItemInfo[j];
        if (clusterStackedItemInfo.stackName == series.groupName) {
          if (clusterStackedItemInfo.stackedItemInfo.length >= 2) {
            for (int k = 0;
                k < clusterStackedItemInfo.stackedItemInfo.length;
                k++) {
              final StackedItemInfo stackedItemInfo =
                  clusterStackedItemInfo.stackedItemInfo[k];
              if (stackedItemInfo.seriesIndex == seriesIndex &&
                  k != 0 &&
                  index <
                      SeriesHelper.getSeriesRendererDetails(
                              clusterStackedItemInfo
                                  .stackedItemInfo[k - 1].seriesRenderer)
                          .dataPoints
                          .length) {
                prevRegion = _getPrevRegion(
                    currentPoint.yValue, clusterStackedItemInfo, index, k);
              }
            }
          }
        }
      }
    }
  }
  _drawAnimatedStackedRect(canvas, segmentRect, fillPaint,
      seriesRendererDetails, animationFactor, currentPoint, index, prevRegion);
}

/// To draw the animated rect for stacked series
void _drawAnimatedStackedRect(
    Canvas canvas,
    RRect segmentRect,
    Paint fillPaint,
    SeriesRendererDetails seriesRendererDetails,
    double animationFactor,
    CartesianChartPoint<dynamic> currentPoint,
    int index,
    Rect? prevRegion) {
  double top = segmentRect.top, height = segmentRect.height;
  double right = segmentRect.right, width = segmentRect.width;
  final double height1 = segmentRect.height, top1 = segmentRect.top;
  const num defaultCrossesAtValue = 0;
  final num crossesAt = getCrossesAtValue(seriesRendererDetails.renderer,
          seriesRendererDetails.stateProperties) ??
      defaultCrossesAtValue;
  height = segmentRect.height * animationFactor;
  width = segmentRect.width * animationFactor;
  if ((seriesRendererDetails.seriesType.contains('stackedcolumn') == true) &&
          seriesRendererDetails.chart.isTransposed != true ||
      (seriesRendererDetails.seriesType.contains('stackedbar') == true) &&
          seriesRendererDetails.chart.isTransposed == true) {
    seriesRendererDetails.yAxisDetails!.axis.isInversed != true
        ? (seriesRendererDetails.dataPoints[index].y > crossesAt) == true
            ? prevRegion == null
                ? top = (segmentRect.top + segmentRect.height) - height
                : top = prevRegion.top - height
            : prevRegion == null
                ? top = segmentRect.top
                : top = prevRegion.bottom
        : (seriesRendererDetails.dataPoints[index].y > crossesAt) == true
            ? prevRegion == null
                ? top = segmentRect.top
                : top = prevRegion.bottom
            : prevRegion == null
                ? top = (segmentRect.top + segmentRect.height) - height
                : top = prevRegion.top - height;

    segmentRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(segmentRect.left, top, segmentRect.width, height),
        bottomLeft: segmentRect.blRadius,
        bottomRight: segmentRect.brRadius,
        topLeft: segmentRect.tlRadius,
        topRight: segmentRect.trRadius);
    currentPoint.region =
        Rect.fromLTWH(segmentRect.left, top, segmentRect.width, height);
    canvas.drawRRect(segmentRect, fillPaint);
  } else if ((seriesRendererDetails.seriesType.contains('stackedcolumn') ==
              true) &&
          seriesRendererDetails.chart.isTransposed == true ||
      (seriesRendererDetails.seriesType.contains('stackedbar') == true) &&
          seriesRendererDetails.chart.isTransposed != true) {
    seriesRendererDetails.yAxisDetails!.axis.isInversed != true
        ? (seriesRendererDetails.dataPoints[index].y > crossesAt) == true
            ? prevRegion == null
                ? right = (segmentRect.right - segmentRect.width) + width
                : right = prevRegion.right + width
            : prevRegion == null
                ? right = segmentRect.right
                : right = prevRegion.left
        : (seriesRendererDetails.dataPoints[index].y > crossesAt) == true
            ? prevRegion == null
                ? right = segmentRect.right
                : right = prevRegion.left
            : prevRegion == null
                ? right = (segmentRect.right - segmentRect.width) + width
                : right = prevRegion.right + width;

    segmentRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(right - width, top1, width, height1),
        bottomLeft: segmentRect.blRadius,
        bottomRight: segmentRect.brRadius,
        topLeft: segmentRect.tlRadius,
        topRight: segmentRect.trRadius);
    currentPoint.region =
        Rect.fromLTWH(segmentRect.left, top, right - segmentRect.left, height);
    canvas.drawRRect(segmentRect, fillPaint);
  }
}

/// This recursive function returns the previous region of the cluster stacked info for animation purposes
Rect? _getPrevRegion(num yValue, ClusterStackedItemInfo clusterStackedItemInfo,
    int index, int k) {
  Rect? prevRegion;
  final SeriesRendererDetails seriesRendererDetails =
      SeriesHelper.getSeriesRendererDetails(
          clusterStackedItemInfo.stackedItemInfo[k - 1].seriesRenderer);
  if (((yValue > 0) == true &&
          (seriesRendererDetails.dataPoints[index].yValue > 0) == true) ||
      ((yValue < 0 == true) &&
          (seriesRendererDetails.dataPoints[index].yValue < 0 == true))) {
    prevRegion = seriesRendererDetails.dataPoints[index].region;
  } else {
    if (k > 1) {
      prevRegion = _getPrevRegion(yValue, clusterStackedItemInfo, index, k - 1);
    }
  }
  return prevRegion;
}

/// To check the series count
bool _checkSingleSeries(SeriesRendererDetails seriesRendererDetails) {
  int count = 0;
  SeriesRendererDetails seriesDetails;
  for (final CartesianSeriesRenderer seriesRenderer in seriesRendererDetails
      .stateProperties.chartSeries.visibleSeriesRenderers) {
    seriesDetails = SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    if (seriesDetails.visible! == true &&
        (seriesDetails.seriesType == 'column' ||
            seriesDetails.seriesType == 'bar')) {
      count++;
    }
  }
  return count == 1;
}

/// to animate dynamic update in line, spline, stepLine series
void animateLineTypeSeries(
    Canvas canvas,
    SeriesRendererDetails seriesRendererDetails,
    Paint strokePaint,
    double animationFactor,
    double newX1,
    double newY1,
    double newX2,
    double newY2,
    double? oldX1,
    double? oldY1,
    double? oldX2,
    double? oldY2,
    [double? newX3,
    double? newY3,
    double? oldX3,
    double? oldY3,
    double? newX4,
    double? newY4,
    double? oldX4,
    double? oldY4]) {
  double x1 = newX1;
  double y1 = newY1;
  double x2 = newX2;
  double y2 = newY2;
  double? x3 = newX3;
  double? y3 = newY3;
  double? x4 = newX4;
  double? y4 = newY4;
  y1 =
      getAnimateValue(animationFactor, y1, oldY1, newY1, seriesRendererDetails);
  y2 =
      getAnimateValue(animationFactor, y2, oldY2, newY2, seriesRendererDetails);
  y3 = y3 != null
      ? getAnimateValue(
          animationFactor, y3, oldY3, newY3, seriesRendererDetails)
      : y3;
  y4 = y4 != null
      ? getAnimateValue(
          animationFactor, y4, oldY4, newY4, seriesRendererDetails)
      : y4;
  x1 =
      getAnimateValue(animationFactor, x1, oldX1, newX1, seriesRendererDetails);
  x2 =
      getAnimateValue(animationFactor, x2, oldX2, newX2, seriesRendererDetails);
  x3 = x3 != null
      ? getAnimateValue(
          animationFactor, x3, oldX3, newX3, seriesRendererDetails)
      : x3;
  x4 = x4 != null
      ? getAnimateValue(
          animationFactor, x4, oldX4, newX4, seriesRendererDetails)
      : x4;

  final Path path = Path();
  path.moveTo(x1, y1);
  if (seriesRendererDetails.seriesType == 'stepline') {
    path.lineTo(x3!, y3!);
  }
  seriesRendererDetails.seriesType == 'spline'
      ? path.cubicTo(x3!, y3!, x4!, y4!, x2, y2)
      : path.lineTo(x2, y2);
  drawDashedLine(
      canvas, seriesRendererDetails.series.dashArray, strokePaint, path);
}

/// Method to animate to point
void animateToPoint(
    Canvas canvas,
    SeriesRendererDetails seriesRendererDetails,
    Paint strokePaint,
    double animationFactor,
    double x1,
    double y1,
    double x2,
    double y2,
    double? prevX,
    double? prevY) {
  final Path path = Path();
  prevX ??= x1;
  prevY ??= y1;
  final double newX1 = prevX + (x1 - prevX) * animationFactor;
  final double newY1 = prevY + (y1 - prevY) * animationFactor;
  path.moveTo(newX1, newY1);
  path.lineTo(newX1 + (x2 - newX1) * animationFactor,
      newY1 + (y2 - newY1) * animationFactor);
  drawDashedLine(
      canvas, seriesRendererDetails.series.dashArray, strokePaint, path);
}

/// To get value of animation based on animation factor
double getAnimateValue(
    double animationFactor, double? value, double? oldvalue, double? newValue,
    [SeriesRendererDetails? seriesRendererDetails]) {
  if (seriesRendererDetails != null) {
    seriesRendererDetails.needAnimateSeriesElements =
        seriesRendererDetails.needAnimateSeriesElements == true ||
            oldvalue != newValue;
  }
  return ((oldvalue != null && newValue != null && !oldvalue.isNaN)
      ? ((oldvalue > newValue)
          ? oldvalue - ((oldvalue - newValue) * animationFactor)
          : oldvalue + ((newValue - oldvalue) * animationFactor))
      : value)!;
}

/// To animate scatter series
void animateScatterSeries(
    SeriesRendererDetails seriesRendererDetails,
    CartesianChartPoint<dynamic> point,
    CartesianChartPoint<dynamic>? oldPoint,
    double animationFactor,
    Canvas canvas,
    Paint fillPaint,
    Paint strokePaint,
    int index,
    ScatterSegment segment) {
  final CartesianSeries<dynamic, dynamic> series = seriesRendererDetails.series;
  final MarkerDetails? pointMarkerDetails =
      CartesianPointHelper.getMarkerDetails(point);
  double width = pointMarkerDetails != null
          ? pointMarkerDetails.size!.width
          : series.markerSettings.width,
      height = pointMarkerDetails != null
          ? pointMarkerDetails.size!.height
          : series.markerSettings.height;
  DataMarkerType markerType = pointMarkerDetails != null
      ? pointMarkerDetails.markerType!
      : series.markerSettings.shape;
  if (pointMarkerDetails != null) {
    fillPaint.color = pointMarkerDetails.color!;
  }

  double x = point.markerPoint!.x;
  double y = point.markerPoint!.y;
  if (seriesRendererDetails.stateProperties.renderingDetails.widgetNeedUpdate ==
          true &&
      oldPoint != null &&
      seriesRendererDetails.reAnimate == false &&
      oldPoint.markerPoint != null) {
    x = getAnimateValue(
        animationFactor, x, oldPoint.markerPoint!.x, x, seriesRendererDetails);
    y = getAnimateValue(
        animationFactor, y, oldPoint.markerPoint!.y, y, seriesRendererDetails);
    segment.animationFactor = 1;
  }
  final bool isMarkerEventTriggered =
      CartesianPointHelper.getIsMarkerEventTriggered(point);
  if (seriesRendererDetails.chart.onMarkerRender != null &&
      ((seriesRendererDetails.animationController.value == 0.0 &&
              !isMarkerEventTriggered &&
              seriesRendererDetails.animationController.status ==
                  AnimationStatus.forward) ||
          (seriesRendererDetails.animationController.duration!.inMilliseconds ==
                  0 &&
              !isMarkerEventTriggered))) {
    final MarkerRenderArgs markerRenderArgs = triggerMarkerRenderEvent(
        seriesRendererDetails,
        Size(width, height),
        markerType,
        index,
        seriesRendererDetails.seriesAnimation,
        segment)!;
    CartesianPointHelper.setIsMarkerEventTriggered(point, true);
    width = markerRenderArgs.markerWidth;
    height = markerRenderArgs.markerHeight;
    markerType = markerRenderArgs.shape;

    final Size size =
        Size(markerRenderArgs.markerHeight, markerRenderArgs.markerWidth);
    CartesianPointHelper.setMarkerDetails(
        point,
        MarkerDetails(
            markerType: markerType,
            borderColor: markerRenderArgs.borderColor,
            color: markerRenderArgs.color,
            borderWidth: markerRenderArgs.borderWidth,
            size: size));
  }
  final SegmentProperties segmentProperties =
      SegmentHelper.getSegmentProperties(segment);

  segmentProperties.seriesRenderer.drawDataMarker(index, canvas, fillPaint,
      strokePaint, x, y, segmentProperties.seriesRenderer);
}

/// To animate bubble series
void animateBubbleSeries(
    Canvas canvas,
    double newX,
    double newY,
    double? oldX,
    double? oldY,
    double? oldSize,
    double animationFactor,
    double radius,
    Paint strokePaint,
    Paint fillPaint,
    CartesianSeriesRenderer seriesRenderer) {
  final SeriesRendererDetails seriesRendererDetails =
      SeriesHelper.getSeriesRendererDetails(seriesRenderer);
  double x = newX;
  double y = newY;
  double size = radius;
  x = getAnimateValue(animationFactor, x, oldX, newX, seriesRendererDetails);
  y = getAnimateValue(animationFactor, y, oldY, newY, seriesRendererDetails);
  size = getAnimateValue(
      animationFactor, size, oldSize, radius, seriesRendererDetails);
  canvas.drawCircle(Offset(x, y), size, fillPaint);
  canvas.drawCircle(Offset(x, y), size, strokePaint);
}

/// To animates range column series
void animateRangeColumn(
    Canvas canvas,
    SeriesRendererDetails seriesRendererDetails,
    Paint fillPaint,
    RRect segmentRect,
    Rect? oldSegmentRect,
    double animationFactor) {
  double height = segmentRect.height;
  double width = segmentRect.width;
  double left = segmentRect.left;
  double top = segmentRect.top;
  if (oldSegmentRect == null || seriesRendererDetails.reAnimate == true) {
    if (seriesRendererDetails.chart.isTransposed == false) {
      height = segmentRect.height * animationFactor;
      top = segmentRect.center.dy - height / 2;
    } else {
      width = segmentRect.width * animationFactor;
      left = segmentRect.center.dx - width / 2;
    }
  } else {
    if (seriesRendererDetails.chart.isTransposed == false) {
      height = getAnimateValue(animationFactor, height, oldSegmentRect.height,
          segmentRect.height, seriesRendererDetails);
      top = getAnimateValue(animationFactor, top, oldSegmentRect.top,
          segmentRect.top, seriesRendererDetails);
    } else {
      width = getAnimateValue(animationFactor, width, oldSegmentRect.width,
          segmentRect.width, seriesRendererDetails);
      left = getAnimateValue(animationFactor, left, oldSegmentRect.left,
          segmentRect.left, seriesRendererDetails);
    }
  }
  canvas.drawRRect(
      RRect.fromRectAndCorners(Rect.fromLTWH(left, top, width, height),
          bottomLeft: segmentRect.blRadius,
          bottomRight: segmentRect.brRadius,
          topLeft: segmentRect.tlRadius,
          topRight: segmentRect.trRadius),
      fillPaint);
}

/// To animate linear type animation
void performLinearAnimation(CartesianStateProperties stateProperties,
    ChartAxis axis, Canvas canvas, double animationFactor) {
  stateProperties.chart.isTransposed
      ? canvas.clipRect(Rect.fromLTRB(
          0,
          axis.isInversed
              ? 0
              : (1 - animationFactor) *
                  stateProperties.chartAxis.axisClipRect.bottom,
          stateProperties.chartAxis.axisClipRect.left +
              stateProperties.chartAxis.axisClipRect.width,
          axis.isInversed
              ? animationFactor *
                  (stateProperties.chartAxis.axisClipRect.top +
                      stateProperties.chartAxis.axisClipRect.height)
              : stateProperties.chartAxis.axisClipRect.top +
                  stateProperties.chartAxis.axisClipRect.height))
      : canvas.clipRect(Rect.fromLTRB(
          axis.isInversed
              ? (1 - animationFactor) *
                  (stateProperties.chartAxis.axisClipRect.right)
              : 0,
          0,
          axis.isInversed
              ? stateProperties.chartAxis.axisClipRect.left +
                  stateProperties.chartAxis.axisClipRect.width
              : animationFactor *
                  (stateProperties.chartAxis.axisClipRect.left +
                      stateProperties.chartAxis.axisClipRect.width),
          stateProperties.chartAxis.axisClipRect.top +
              stateProperties.chartAxis.axisClipRect.height));
}

/// To animate Hilo series
void animateHiloSeres(
    bool transposed,
    ChartLocation newLow,
    ChartLocation newHigh,
    ChartLocation? oldLow,
    ChartLocation? oldHigh,
    double animationFactor,
    Paint paint,
    Canvas canvas,
    CartesianSeriesRenderer seriesRenderer) {
  final SeriesRendererDetails seriesRendererDetails =
      SeriesHelper.getSeriesRendererDetails(seriesRenderer);
  if (transposed) {
    double lowX = newLow.x;
    double highX = newHigh.x;
    double y = newLow.y;
    y = getAnimateValue(
        animationFactor, y, oldLow?.y, newLow.y, seriesRendererDetails);
    lowX = getAnimateValue(
        animationFactor, lowX, oldLow?.x, newLow.x, seriesRendererDetails);
    highX = getAnimateValue(
        animationFactor, highX, oldHigh?.x, newHigh.x, seriesRendererDetails);
    canvas.drawLine(Offset(lowX, y), Offset(highX, y), paint);
  } else {
    double low = newLow.y;
    double high = newHigh.y;
    double x = newLow.x;
    x = getAnimateValue(
        animationFactor, x, oldLow?.x, newLow.x, seriesRendererDetails);
    low = getAnimateValue(
        animationFactor, low, oldLow?.y, newLow.y, seriesRendererDetails);
    high = getAnimateValue(
        animationFactor, high, oldHigh?.y, newHigh.y, seriesRendererDetails);
    canvas.drawLine(Offset(x, low), Offset(x, high), paint);
  }
}

/// To animate the Hilo open-close series
void animateHiloOpenCloseSeries(
    bool transposed,
    double newLow,
    double newHigh,
    double? oldLow,
    double? oldHigh,
    double newOpenX,
    double newOpenY,
    double newCloseX,
    double newCloseY,
    double newCenterLow,
    double newCenterHigh,
    double? oldOpenX,
    double? oldOpenY,
    double? oldCloseX,
    double? oldCloseY,
    double? oldCenterLow,
    double? oldCenterHigh,
    double animationFactor,
    Paint paint,
    Canvas canvas,
    SeriesRendererDetails seriesRendererDetails) {
  double low = newLow;
  double high = newHigh;
  double openX = newOpenX;
  double openY = newOpenY;
  double closeX = newCloseX;
  double closeY = newCloseY;
  double centerHigh = newCenterHigh;
  double centerLow = newCenterLow;
  low = getAnimateValue(
      animationFactor, low, oldLow, newLow, seriesRendererDetails);
  high = getAnimateValue(
      animationFactor, high, oldHigh, newHigh, seriesRendererDetails);
  openX = getAnimateValue(
      animationFactor, openX, oldOpenX, newOpenX, seriesRendererDetails);
  openY = getAnimateValue(
      animationFactor, openY, oldOpenY, newOpenY, seriesRendererDetails);
  closeX = getAnimateValue(
      animationFactor, closeX, oldCloseX, newCloseX, seriesRendererDetails);
  closeY = getAnimateValue(
      animationFactor, closeY, oldCloseY, newCloseY, seriesRendererDetails);
  centerHigh = getAnimateValue(animationFactor, centerHigh, oldCenterHigh,
      newCenterHigh, seriesRendererDetails);
  centerLow = getAnimateValue(animationFactor, centerLow, oldCenterLow,
      newCenterLow, seriesRendererDetails);
  if (transposed) {
    canvas.drawLine(Offset(low, centerLow), Offset(high, centerHigh), paint);
    canvas.drawLine(Offset(openX, openY), Offset(openX, centerHigh), paint);
    canvas.drawLine(Offset(closeX, centerLow), Offset(closeX, closeY), paint);
  } else {
    canvas.drawLine(Offset(centerHigh, low), Offset(centerLow, high), paint);
    canvas.drawLine(Offset(openX, openY), Offset(centerHigh, openY), paint);
    canvas.drawLine(Offset(centerLow, closeY), Offset(closeX, closeY), paint);
  }
}

/// To animate the box and whisker series
void animateBoxSeries(
    bool showMean,
    Offset meanPosition,
    Offset transposedMeanPosition,
    Size size,
    double max,
    bool transposed,
    double lowerQuartile1,
    double upperQuartile1,
    double newMin,
    double newMax,
    double? oldMin,
    double? oldMax,
    double newLowerQuartileX,
    double newLowerQuartileY,
    double newUpperQuartileX,
    double newUpperQuartileY,
    double newCenterMin,
    double newCenterMax,
    double? oldLowerQuartileX,
    double? oldLowerQuartileY,
    double? oldUpperQuartileX,
    double? oldUpperQuartileY,
    double? oldCenterMin,
    double? oldCenterMax,
    double medianX,
    double medianY,
    double animationFactor,
    Paint fillPaint,
    Paint strokePaint,
    Canvas canvas,
    SeriesRendererDetails seriesRendererDetails) {
  final double lowerQuartile = lowerQuartile1;
  final double upperQuartile = upperQuartile1;
  double minY = newMin;
  double maxY = newMax;
  double lowerQuartileX = newLowerQuartileX;
  double lowerQuartileY = newLowerQuartileY;
  double upperQuartileX = newUpperQuartileX;
  double upperQuartileY = newUpperQuartileY;
  double centerMax = newCenterMax;
  double centerMin = newCenterMin;
  minY = getAnimateValue(
      animationFactor, minY, oldMin, newMin, seriesRendererDetails);
  maxY = getAnimateValue(
      animationFactor, maxY, oldMax, newMax, seriesRendererDetails);
  lowerQuartileX = getAnimateValue(animationFactor, lowerQuartileX,
      oldLowerQuartileX, newLowerQuartileX, seriesRendererDetails);
  lowerQuartileY = getAnimateValue(animationFactor, lowerQuartileY,
      oldLowerQuartileY, newLowerQuartileY, seriesRendererDetails);
  upperQuartileX = getAnimateValue(animationFactor, upperQuartileX,
      oldUpperQuartileX, newUpperQuartileX, seriesRendererDetails);
  upperQuartileY = getAnimateValue(animationFactor, upperQuartileY,
      oldUpperQuartileY, newUpperQuartileY, seriesRendererDetails);
  centerMax = getAnimateValue(animationFactor, centerMax, oldCenterMax,
      newCenterMax, seriesRendererDetails);
  centerMin = getAnimateValue(animationFactor, centerMin, oldCenterMin,
      newCenterMin, seriesRendererDetails);
  final Path path = Path();
  if (!transposed && lowerQuartile > upperQuartile) {
    final double temp = upperQuartileY;
    upperQuartileY = lowerQuartileY;
    lowerQuartileY = temp;
  }
  if (transposed) {
    path.moveTo(centerMax, upperQuartileY);
    path.lineTo(centerMax, lowerQuartileY);
    path.moveTo(centerMax, maxY);
    (centerMax < upperQuartileX)
        ? path.lineTo(upperQuartileX, maxY)
        : path.lineTo(upperQuartileX, maxY);
    path.moveTo(medianX, upperQuartileY);
    path.lineTo(medianX, lowerQuartileY);
    path.moveTo(centerMin, maxY);
    (centerMin > lowerQuartileX)
        ? path.lineTo(lowerQuartileX, maxY)
        : path.lineTo(lowerQuartileX, maxY);
    path.moveTo(centerMin, upperQuartileY);
    path.lineTo(centerMin, lowerQuartileY);
    if (showMean) {
      _drawMeanValuePath(
          seriesRendererDetails,
          animationFactor,
          transposedMeanPosition.dy,
          transposedMeanPosition.dx,
          size,
          strokePaint,
          canvas);
    }
    if (lowerQuartileX == upperQuartileX) {
      canvas.drawLine(Offset(lowerQuartileX, lowerQuartileY),
          Offset(upperQuartileX, upperQuartileY), fillPaint);
    } else {
      path.moveTo(upperQuartileX, upperQuartileY);
      path.lineTo(upperQuartileX, lowerQuartileY);
      path.lineTo(lowerQuartileX, lowerQuartileY);
      path.lineTo(lowerQuartileX, upperQuartileY);
      path.lineTo(upperQuartileX, upperQuartileY);
      path.close();
    }
  } else {
    if (lowerQuartile > upperQuartile) {
      final double temp = upperQuartileY;
      upperQuartileY = lowerQuartileY;
      lowerQuartileY = temp;
    }
    canvas.drawLine(Offset(lowerQuartileX, maxY), Offset(upperQuartileX, maxY),
        strokePaint);
    canvas.drawLine(Offset(centerMax, upperQuartileY), Offset(centerMax, maxY),
        strokePaint);
    canvas.drawLine(Offset(lowerQuartileX, medianY),
        Offset(upperQuartileX, medianY), strokePaint);
    canvas.drawLine(Offset(centerMin, lowerQuartileY), Offset(centerMin, minY),
        strokePaint);
    canvas.drawLine(Offset(lowerQuartileX, minY), Offset(upperQuartileX, minY),
        strokePaint);
    if (showMean) {
      _drawMeanValuePath(seriesRendererDetails, animationFactor,
          meanPosition.dx, meanPosition.dy, size, strokePaint, canvas);
    }
    if (lowerQuartileY == upperQuartileY) {
      canvas.drawLine(Offset(lowerQuartileX, lowerQuartileY),
          Offset(upperQuartileX, upperQuartileY), fillPaint);
    } else {
      path.moveTo(lowerQuartileX, lowerQuartileY);
      path.lineTo(upperQuartileX, lowerQuartileY);
      path.lineTo(upperQuartileX, upperQuartileY);
      path.lineTo(lowerQuartileX, upperQuartileY);
      path.lineTo(lowerQuartileX, lowerQuartileY);
      path.close();
    }
  }
  if (seriesRendererDetails.dashArray![0] != 0 &&
      seriesRendererDetails.dashArray![1] != 0 &&
      seriesRendererDetails.series.animationDuration <= 0) {
    canvas.drawPath(path, fillPaint);
    drawDashedLine(canvas, seriesRendererDetails.dashArray!, strokePaint, path);
  } else {
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }
  if (fillPaint.style == PaintingStyle.fill) {
    if (transposed) {
      canvas.drawLine(Offset(centerMax, upperQuartileY),
          Offset(centerMax, lowerQuartileY), strokePaint);
      canvas.drawLine(
          Offset(centerMax, maxY), Offset(upperQuartileX, maxY), strokePaint);
      canvas.drawLine(Offset(medianX, upperQuartileY),
          Offset(medianX, lowerQuartileY), strokePaint);
      canvas.drawLine(
          Offset(centerMin, maxY), Offset(lowerQuartileX, maxY), strokePaint);
      canvas.drawLine(Offset(centerMin, upperQuartileY),
          Offset(centerMin, lowerQuartileY), strokePaint);
      if (showMean) {
        _drawMeanValuePath(
            seriesRendererDetails,
            animationFactor,
            transposedMeanPosition.dy,
            transposedMeanPosition.dx,
            size,
            strokePaint,
            canvas);
      }
    } else {
      canvas.drawLine(Offset(lowerQuartileX, maxY),
          Offset(upperQuartileX, maxY), strokePaint);
      canvas.drawLine(Offset(centerMax, upperQuartileY),
          Offset(centerMax, maxY), strokePaint);
      canvas.drawLine(Offset(lowerQuartileX, medianY),
          Offset(upperQuartileX, medianY), strokePaint);
      canvas.drawLine(Offset(centerMin, lowerQuartileY),
          Offset(centerMin, minY), strokePaint);
      canvas.drawLine(Offset(lowerQuartileX, minY),
          Offset(upperQuartileX, minY), strokePaint);
      if (showMean) {
        _drawMeanValuePath(seriesRendererDetails, animationFactor,
            meanPosition.dx, meanPosition.dy, size, strokePaint, canvas);
      }
    }
  }
}

/// To draw the path of mean value in box plot series.
void _drawMeanValuePath(
    SeriesRendererDetails seriesRendererDetails,
    double animationFactor,
    num x,
    num y,
    Size size,
    Paint strokePaint,
    Canvas canvas) {
  if (seriesRendererDetails.series.animationDuration <= 0 ||
      animationFactor >=
          seriesRendererDetails.stateProperties.seriesDurationFactor) {
    canvas.drawLine(Offset(x + size.width / 2, y - size.height / 2),
        Offset(x - size.width / 2, y + size.height / 2), strokePaint);
    canvas.drawLine(Offset(x + size.width / 2, y + size.height / 2),
        Offset(x - size.width / 2, y - size.height / 2), strokePaint);
  }
}

/// To animate the candle series
void animateCandleSeries(
    bool showSameValue,
    double high,
    bool transposed,
    double open1,
    double close1,
    double newLow,
    double newHigh,
    double? oldLow,
    double? oldHigh,
    double newOpenX,
    double newOpenY,
    double newCloseX,
    double newCloseY,
    double newCenterLow,
    double newCenterHigh,
    double? oldOpenX,
    double? oldOpenY,
    double? oldCloseX,
    double? oldCloseY,
    double? oldCenterLow,
    double? oldCenterHigh,
    double animationFactor,
    Paint paint,
    Canvas canvas,
    SeriesRendererDetails seriesRendererDetails) {
  final double open = open1;
  final double close = close1;
  double lowY = newLow;
  double highY = newHigh;
  double openX = newOpenX;
  double openY = newOpenY;
  double closeX = newCloseX;
  double closeY = newCloseY;
  double centerHigh = newCenterHigh;
  double centerLow = newCenterLow;
  lowY = getAnimateValue(
      animationFactor, lowY, oldLow, newLow, seriesRendererDetails);
  highY = getAnimateValue(
      animationFactor, highY, oldHigh, newHigh, seriesRendererDetails);
  openX = getAnimateValue(
      animationFactor, openX, oldOpenX, newOpenX, seriesRendererDetails);
  openY = getAnimateValue(
      animationFactor, openY, oldOpenY, newOpenY, seriesRendererDetails);
  closeX = getAnimateValue(
      animationFactor, closeX, oldCloseX, newCloseX, seriesRendererDetails);
  closeY = getAnimateValue(
      animationFactor, closeY, oldCloseY, newCloseY, seriesRendererDetails);
  centerHigh = getAnimateValue(animationFactor, centerHigh, oldCenterHigh,
      newCenterHigh, seriesRendererDetails);
  centerLow = getAnimateValue(animationFactor, centerLow, oldCenterLow,
      newCenterLow, seriesRendererDetails);
  final Path path = Path();
  if (!transposed && open > close) {
    final double temp = closeY;
    closeY = openY;
    openY = temp;
  }

  if (transposed) {
    if (showSameValue) {
      canvas.drawLine(
          Offset(centerHigh, highY), Offset(centerLow, highY), paint);
    } else {
      path.moveTo(centerHigh, highY);
      (centerHigh < closeX)
          ? path.lineTo(closeX, highY)
          : path.lineTo(closeX, highY);
      path.moveTo(centerLow, highY);
      (centerLow > openX)
          ? path.lineTo(openX, highY)
          : path.lineTo(openX, highY);
    }
    if (openX == closeX) {
      canvas.drawLine(Offset(openX, openY), Offset(closeX, closeY), paint);
    } else {
      path.moveTo(closeX, closeY);
      path.lineTo(closeX, openY);
      path.lineTo(openX, openY);
      path.lineTo(openX, closeY);
      path.lineTo(closeX, closeY);
      path.close();
    }
  } else {
    if (open > close) {
      final double temp = closeY;
      closeY = openY;
      openY = temp;
    }
    if (showSameValue) {
      canvas.drawLine(
          Offset(centerHigh, high), Offset(centerHigh, lowY), paint);
    } else {
      canvas.drawLine(
          Offset(centerHigh, closeY), Offset(centerHigh, highY), paint);
      canvas.drawLine(Offset(centerLow, openY), Offset(centerLow, lowY), paint);
    }
    if (openY == closeY) {
      canvas.drawLine(Offset(openX, openY), Offset(closeX, closeY), paint);
    } else {
      path.moveTo(openX, openY);
      path.lineTo(closeX, openY);
      path.lineTo(closeX, closeY);
      path.lineTo(openX, closeY);
      path.lineTo(openX, openY);
      path.close();
    }
  }

  (seriesRendererDetails.dashArray![0] != 0 &&
          seriesRendererDetails.dashArray![1] != 0 &&
          paint.style != PaintingStyle.fill &&
          seriesRendererDetails.series.animationDuration <= 0)
      ? drawDashedLine(canvas, seriesRendererDetails.dashArray!, paint, path)
      : canvas.drawPath(path, paint);
  if (paint.style == PaintingStyle.fill) {
    if (transposed) {
      if (showSameValue) {
        canvas.drawLine(
            Offset(centerHigh, highY), Offset(centerLow, highY), paint);
      } else {
        canvas.drawLine(
            Offset(centerHigh, highY), Offset(closeX, highY), paint);
        canvas.drawLine(Offset(centerLow, highY), Offset(openX, highY), paint);
      }
    } else {
      if (showSameValue) {
        canvas.drawLine(
            Offset(centerHigh, high), Offset(centerHigh, lowY), paint);
      } else {
        canvas.drawLine(
            Offset(centerHigh, closeY), Offset(centerHigh, highY), paint);
        canvas.drawLine(
            Offset(centerLow, openY), Offset(centerLow, lowY), paint);
      }
    }
  }
}

/// To get nearest chart points from the touch point
List<CartesianChartPoint<dynamic>>? getNearestChartPoints(
    double pointX,
    double pointY,
    ChartAxisRenderer actualXAxisRenderer,
    ChartAxisRenderer actualYAxisRenderer,
    SeriesRendererDetails seriesRendererDetails,
    [List<CartesianChartPoint<dynamic>>? firstNearestDataPoints]) {
  final ChartAxisRendererDetails actualXAxisDetails =
      AxisHelper.getAxisRendererDetails(actualXAxisRenderer);
  final ChartAxisRendererDetails actualYAxisDetails =
      AxisHelper.getAxisRendererDetails(actualYAxisRenderer);
  final List<CartesianChartPoint<dynamic>> dataPointList =
      <CartesianChartPoint<dynamic>>[];
  List<CartesianChartPoint<dynamic>> dataList =
      <CartesianChartPoint<dynamic>>[];
  final List<num> xValues = <num>[];
  final List<num> yValues = <num>[];

  firstNearestDataPoints != null
      ? dataList = firstNearestDataPoints
      : dataList = seriesRendererDetails.visibleDataPoints != null
          ? seriesRendererDetails.visibleDataPoints!
          : <CartesianChartPoint<dynamic>>[];

  for (int i = 0; i < dataList.length; i++) {
    xValues.add(dataList[i].xValue);
    (seriesRendererDetails.renderer is BoxAndWhiskerSeriesRenderer)
        ? yValues.add((dataList[i].maximum! + dataList[i].minimum!) / 2)
        : yValues.add(
            dataList[i].yValue ?? (dataList[i].high + dataList[i].low) / 2);
  }
  if (dataList.isNotEmpty) {
    num nearPointX = dataList[0].xValue;
    num nearPointY = actualYAxisDetails.visibleRange!.minimum;

    final Rect rect = calculatePlotOffset(
        seriesRendererDetails.stateProperties.chartAxis.axisClipRect,
        Offset(seriesRendererDetails.xAxisDetails!.axis.plotOffset,
            seriesRendererDetails.yAxisDetails!.axis.plotOffset));

    final num touchXValue = pointToXValue(
        seriesRendererDetails.stateProperties.requireInvertedAxis,
        actualXAxisRenderer,
        actualXAxisDetails.axis.isVisible
            ? actualXAxisDetails.bounds
            : seriesRendererDetails.stateProperties.chartAxis.axisClipRect,
        pointX - rect.left,
        pointY - rect.top);
    final num touchYValue = pointToYValue(
        seriesRendererDetails.stateProperties.requireInvertedAxis,
        actualYAxisRenderer,
        actualYAxisDetails.axis.isVisible
            ? actualYAxisDetails.bounds
            : seriesRendererDetails.stateProperties.chartAxis.axisClipRect,
        pointX - rect.left,
        pointY - rect.top);
    double delta = 0;
    for (int i = 0; i < dataList.length; i++) {
      final double currX = xValues[i].toDouble();
      final double currY = yValues[i].toDouble();
      if (delta == touchXValue - currX) {
        final CartesianChartPoint<dynamic> dataPoint = dataList[i];
        if (dataPoint.isDrop != true && dataPoint.isGap != true) {
          if ((touchYValue - currY).abs() > (touchYValue - nearPointY).abs()) {
            dataPointList.clear();
          }
          dataPointList.add(dataPoint);
        }
      } else if ((touchXValue - currX).abs() <=
          (touchXValue - nearPointX).abs()) {
        nearPointX = currX;
        nearPointY = currY;
        delta = touchXValue - currX;
        final CartesianChartPoint<dynamic> dataPoint = dataList[i];
        dataPointList.clear();
        if (dataPoint.isDrop != true && dataPoint.isGap != true) {
          dataPointList.add(dataPoint);
        }
      }
    }
  }
  return dataPointList;
}

/// Return the arguments for zoom event
ZoomPanArgs bindZoomEvent(SfCartesianChart chart,
    ChartAxisRendererDetails axisDetails, ChartZoomingCallback zoomEventType) {
  final ZoomPanArgs zoomPanArgs = ZoomPanArgs(axisDetails.axis,
      axisDetails.previousZoomPosition, axisDetails.previousZoomFactor);
  zoomPanArgs.currentZoomFactor = axisDetails.zoomFactor;
  zoomPanArgs.currentZoomPosition = axisDetails.zoomPosition;
  zoomEventType == chart.onZoomStart
      ? chart.onZoomStart!(zoomPanArgs)
      : zoomEventType == chart.onZoomEnd
          ? chart.onZoomEnd!(zoomPanArgs)
          : zoomEventType == chart.onZooming
              ? chart.onZooming!(zoomPanArgs)
              : chart.onZoomReset!(zoomPanArgs);

  return zoomPanArgs;
}

/// Method to returning path for dashed border in rect type series
Path findingRectSeriesDashedBorder(
    CartesianChartPoint<dynamic> currentPoint, double borderWidth) {
  Path path;
  Offset topLeft, topRight, bottomRight, bottomLeft;
  double width;
  topLeft = currentPoint.region!.topLeft;
  topRight = currentPoint.region!.topRight;
  bottomLeft = currentPoint.region!.bottomLeft;
  bottomRight = currentPoint.region!.bottomRight;
  width = borderWidth / 2;
  path = Path();
  path.moveTo(topLeft.dx + width, topLeft.dy + width);
  path.lineTo(topRight.dx - width, topRight.dy + width);
  path.lineTo(bottomRight.dx - width, bottomRight.dy - width);
  path.lineTo(bottomLeft.dx + width, bottomLeft.dy - width);
  path.lineTo(topLeft.dx + width, topLeft.dy + width);
  path.close();
  return path;
}

/// below method is for getting image from the image provider
Future<dart_ui.Image> _getImageInfo(ImageProvider imageProvider) async {
  final Completer<ImageInfo> completer = Completer<ImageInfo>();
  imageProvider
      .resolve(ImageConfiguration.empty)
      .addListener(ImageStreamListener((ImageInfo info, bool _) {
    completer.complete(info);
    // return completer.future;
  }));
  final ImageInfo imageInfo = await completer.future;
  return imageInfo.image;
}

/// Method to calculate the image value
//ignore: avoid_void_async
void calculateImage(CartesianStateProperties stateProperties,
    [SeriesRendererDetails? seriesRendererDetails,
    TrackballBehavior? trackballBehavior]) async {
  final SfCartesianChart chart = stateProperties.chart;
  // ignore: unnecessary_null_comparison
  if (chart != null && seriesRendererDetails == null) {
    if (chart.plotAreaBackgroundImage != null) {
      stateProperties.backgroundImage =
          await _getImageInfo(chart.plotAreaBackgroundImage!);
      stateProperties.renderOutsideAxis.state.axisRepaintNotifier.value++;
    }
  } else if (trackballBehavior != null &&
      trackballBehavior.markerSettings!.image != null) {
    stateProperties.trackballMarkerSettingsRenderer.image =
        await _getImageInfo(trackballBehavior.markerSettings!.image!);
    stateProperties.repaintNotifiers['trackball']!.value++;
  } else {
    final CartesianSeries<dynamic, dynamic> series =
        seriesRendererDetails!.series;
    if (series.markerSettings.image != null) {
      seriesRendererDetails.markerSettingsRenderer!.image =
          await _getImageInfo(series.markerSettings.image!);
      if (!seriesRendererDetails.markerSettingsRenderer!.isImageDrawn) {
        seriesRendererDetails.repaintNotifier.value++;
        seriesRendererDetails.markerSettingsRenderer!.isImageDrawn = true;
      }
    }
  }
}

/// Set the shader for series types.
void setShader(SegmentProperties segmentProperties, Paint paint) =>
    paint.shader = segmentProperties.stateProperties.shader ?? paint.shader;

/// Used to calculate the error values of standard error type error bar.
ChartErrorValues _getStandardErrorValues(
    SeriesRendererDetails seriesRendererDetails,
    ErrorBarSeries<dynamic, dynamic> series,
    ChartErrorValues chartErrorValues,
    ErrorBarMean mean,
    int dataPointsLength) {
  final num errorX = (chartErrorValues.errorX! * mean.horizontalSquareRoot!) /
      math.sqrt(dataPointsLength);
  final num errorY = (chartErrorValues.errorY! * mean.verticalSquareRoot!) /
      math.sqrt(dataPointsLength);
  return ChartErrorValues(errorX: errorX, errorY: errorY);
}

/// Used to calculate the error values of standard deviation type error bar.
ChartErrorValues _getStandardDeviationValues(
    SeriesRendererDetails seriesRendererDetails,
    ErrorBarSeries<dynamic, dynamic> series,
    ChartErrorValues chartErrorValues,
    ErrorBarMean mean,
    int dataPointsLength) {
  num errorY = chartErrorValues.errorY!, errorX = chartErrorValues.errorX!;
  errorY = (series.mode == RenderingMode.horizontal)
      ? errorY
      : errorY * (mean.verticalSquareRoot! + mean.verticalMean!);
  errorX = (series.mode == RenderingMode.vertical)
      ? errorX
      : errorX * (mean.horizontalSquareRoot! + mean.horizontalMean!);
  return ChartErrorValues(errorX: errorX, errorY: errorY);
}

/// Returns the error values of error bar.
ChartErrorValues _getErrorValues(SeriesRendererDetails seriesRendererDetails,
    ErrorBarSeries<dynamic, dynamic> series, num actualXValue, num actualYValue,
    {ErrorBarMean? mean, int? dataPointsLength}) {
  final RenderingMode? mode = series.mode;
  num errorX = 0.0,
      errorY = 0.0,
      customNegativeErrorX = 0.0,
      customNegativeErrorY = 0.0;
  ChartErrorValues? chartErrorValues;
  if (series.type != ErrorBarType.custom) {
    errorY = (mode == RenderingMode.horizontal)
        ? errorY
        : series.verticalErrorValue!;
    errorX = (mode == RenderingMode.vertical)
        ? errorX
        : series.horizontalErrorValue!;
    chartErrorValues = ChartErrorValues(errorX: errorX, errorY: errorY);
    if (series.type == ErrorBarType.standardError) {
      chartErrorValues = _getStandardErrorValues(seriesRendererDetails, series,
          chartErrorValues, mean!, dataPointsLength!);
    }
    // Updating the error values for standard deviation type
    if (series.type == ErrorBarType.standardDeviation) {
      chartErrorValues = _getStandardDeviationValues(seriesRendererDetails,
          series, chartErrorValues, mean!, dataPointsLength!);
    }
    // Updating the error values for percentage type
    if (series.type == ErrorBarType.percentage) {
      errorY = (mode == RenderingMode.horizontal)
          ? errorY
          : (errorY / 100) * actualYValue;
      errorX = (mode == RenderingMode.vertical)
          ? errorX
          : (errorX / 100) * actualXValue;
      chartErrorValues = ChartErrorValues(errorX: errorX, errorY: errorY);
    }
  }
  // Updating the error values for custom type
  else if (series.type == ErrorBarType.custom) {
    errorY = (mode == RenderingMode.horizontal)
        ? errorY
        : series.verticalPositiveErrorValue!;
    customNegativeErrorY = (mode == RenderingMode.horizontal)
        ? customNegativeErrorY
        : series.verticalNegativeErrorValue!;
    errorX = (mode == RenderingMode.vertical)
        ? errorX
        : series.horizontalPositiveErrorValue!;
    customNegativeErrorX = (mode == RenderingMode.vertical)
        ? customNegativeErrorX
        : series.horizontalNegativeErrorValue!;
    chartErrorValues = ChartErrorValues(
        errorX: errorX,
        errorY: errorY,
        customNegativeX: customNegativeErrorX,
        customNegativeY: customNegativeErrorY);
  }
  return chartErrorValues!;
}

/// Returns the calculated error bar values.
ErrorBarValues _getCalculatedErrorValues(
    SeriesRendererDetails seriesRendererDetails,
    ErrorBarSeries<dynamic, dynamic> series,
    ChartErrorValues chartErrorValues,
    num actualXValue,
    num actualYValue) {
  final bool isDirectionPlus = series.direction == Direction.plus;
  final bool isBothDirection = series.direction == Direction.both;
  final bool isDirectionMinus = series.direction == Direction.minus;
  final bool isCustomFixedType =
      series.type == ErrorBarType.fixed || series.type == ErrorBarType.custom;
  double? verticalPositiveErrorValue,
      horizontalPositiveErrorValue,
      verticalNegativeErrorValue,
      horizontalNegativeErrorValue;
  final ChartAxisRendererDetails xAxisDetails =
      seriesRendererDetails.xAxisDetails!;
  if (series.mode == RenderingMode.horizontal ||
      series.mode == RenderingMode.both) {
    if (isDirectionPlus || isBothDirection) {
      if (xAxisDetails is DateTimeAxisDetails && isCustomFixedType) {
        horizontalPositiveErrorValue = _updateDateTimeHorizontalErrorValue(
            seriesRendererDetails, actualXValue, chartErrorValues.errorX!);
      } else {
        horizontalPositiveErrorValue =
            actualXValue + chartErrorValues.errorX! as double;
      }
    }
    if (isDirectionMinus || isBothDirection) {
      if (xAxisDetails is DateTimeAxisDetails && isCustomFixedType) {
        horizontalNegativeErrorValue = _updateDateTimeHorizontalErrorValue(
            seriesRendererDetails,
            actualXValue,
            (series.type == ErrorBarType.custom)
                ? -chartErrorValues.customNegativeX!
                : -chartErrorValues.errorX!);
      } else {
        horizontalNegativeErrorValue = actualXValue -
            ((series.type == ErrorBarType.custom)
                ? chartErrorValues.customNegativeX!
                : chartErrorValues.errorX!) as double;
      }
    }
  }

  if (series.mode == RenderingMode.vertical ||
      series.mode == RenderingMode.both) {
    if (isDirectionPlus || isBothDirection) {
      verticalPositiveErrorValue =
          actualYValue + chartErrorValues.errorY! as double;
    }
    if (isDirectionMinus || isBothDirection) {
      verticalNegativeErrorValue = actualYValue -
          ((series.type == ErrorBarType.custom)
              ? chartErrorValues.customNegativeY!
              : chartErrorValues.errorY!) as double;
    }
  }
  return ErrorBarValues(
      horizontalPositiveErrorValue,
      horizontalNegativeErrorValue,
      verticalPositiveErrorValue,
      verticalNegativeErrorValue);
}

/// Set maximum and minimum values of axis in error bar series.
void updateErrorBarAxisRange(SeriesRendererDetails seriesRendererDetails,
    CartesianChartPoint<dynamic> point) {
  if (!point.isGap) {
    final ErrorBarSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as ErrorBarSeries<dynamic, dynamic>;
    // For standard error and standard deviation type error bars, all data
    // points are needed to calculate the error values. So this iteration is
    // executed.
    if (series.type == ErrorBarType.standardDeviation ||
        series.type == ErrorBarType.standardError) {
      final List<num> yValuesList = <num>[];
      final List<num> xValuesList = <num>[];
      num sumOfX = 0, sumOfY = 0;
      final int dataPointsLength = series.dataSource.length;
      num? verticalSquareRoot,
          horizontalSquareRoot,
          verticalMean,
          horizontalMean;
      for (int pointIndex = 0;
          pointIndex < series.dataSource.length;
          pointIndex++) {
        yValuesList.add(series.yValueMapper!(pointIndex) ?? 0);
        sumOfY += yValuesList[pointIndex];
        final dynamic xValue = series.xValueMapper!(pointIndex);
        if (xValue is DateTime) {
          xValuesList.add(xValue.millisecondsSinceEpoch);
        } else if (xValue is String) {
          xValuesList.add(pointIndex);
        } else {
          xValuesList.add(xValue);
        }
        sumOfX += xValuesList[pointIndex];
      }
      verticalMean = (series.mode == RenderingMode.horizontal)
          ? verticalMean
          : sumOfY / dataPointsLength;
      horizontalMean = (series.mode == RenderingMode.vertical)
          ? horizontalMean
          : sumOfX / dataPointsLength;
      for (int pointIndex = 0;
          pointIndex < series.dataSource.length;
          pointIndex++) {
        sumOfY = (series.mode == RenderingMode.horizontal)
            ? sumOfY
            : sumOfY + math.pow(yValuesList[pointIndex] - verticalMean!, 2);
        sumOfX = (series.mode == RenderingMode.vertical)
            ? sumOfX
            : sumOfX + math.pow(xValuesList[pointIndex] - horizontalMean!, 2);
      }
      verticalSquareRoot = math.sqrt(sumOfY / (dataPointsLength - 1));
      horizontalSquareRoot = math.sqrt(sumOfX / (dataPointsLength - 1));
      final ErrorBarMean mean = ErrorBarMean(
          verticalSquareRoot: verticalSquareRoot,
          horizontalSquareRoot: horizontalSquareRoot,
          verticalMean: verticalMean,
          horizontalMean: horizontalMean);
      final ChartErrorValues chartErrorValues = _getErrorValues(
          seriesRendererDetails, series, point.xValue, point.yValue,
          mean: mean, dataPointsLength: dataPointsLength);
      point.errorBarValues = _getCalculatedErrorValues(seriesRendererDetails,
          series, chartErrorValues, point.xValue, point.yValue);
    } else {
      final ChartErrorValues chartErrorValues = _getErrorValues(
          seriesRendererDetails, series, point.xValue, point.yValue);
      point.errorBarValues = _getCalculatedErrorValues(seriesRendererDetails,
          series, chartErrorValues, point.xValue, point.yValue);
    }
  }
  if (point.errorBarValues?.verticalNegativeErrorValue != null) {
    seriesRendererDetails.minimumY = findMinValue(
        seriesRendererDetails.minimumY ?? point.yValue,
        point.errorBarValues!.verticalNegativeErrorValue!);
  }
  if (point.errorBarValues?.verticalPositiveErrorValue != null) {
    seriesRendererDetails.maximumY = findMaxValue(
        seriesRendererDetails.maximumY ?? point.yValue,
        point.errorBarValues!.verticalPositiveErrorValue!);
  }
  if (point.errorBarValues?.horizontalPositiveErrorValue != null) {
    seriesRendererDetails.maximumX = findMaxValue(
        seriesRendererDetails.maximumX ?? point.xValue,
        point.errorBarValues!.horizontalPositiveErrorValue!);
  }
  if (point.errorBarValues?.horizontalNegativeErrorValue != null) {
    seriesRendererDetails.minimumX = findMinValue(
        seriesRendererDetails.minimumX ?? point.xValue,
        point.errorBarValues!.horizontalNegativeErrorValue!);
  }
}

/// To calculate the error values for DateTime axis
double _updateDateTimeHorizontalErrorValue(
    SeriesRendererDetails seriesRendererDetails,
    num actualXValue,
    num errorValue) {
  final ChartAxisRendererDetails xAxisDetails =
      seriesRendererDetails.xAxisDetails!;
  DateTime errorXValue =
      DateTime.fromMillisecondsSinceEpoch(actualXValue.toInt());
  final int errorX = errorValue.toInt();
  final DateTimeAxisDetails axisRendererDetails =
      AxisHelper.getAxisRendererDetails(xAxisDetails.axisRenderer)
          as DateTimeAxisDetails;
  final DateTimeIntervalType type =
      axisRendererDetails.dateTimeAxis.intervalType;
  switch (type) {
    case DateTimeIntervalType.years:
      errorXValue = DateTime(
          errorXValue.year + errorX, errorXValue.month, errorXValue.day);
      break;
    case DateTimeIntervalType.months:
      errorXValue = DateTime(
          errorXValue.year, errorXValue.month + errorX, errorXValue.day);
      break;
    case DateTimeIntervalType.days:
      errorXValue = DateTime(
          errorXValue.year, errorXValue.month, errorXValue.day + errorX);
      break;
    case DateTimeIntervalType.hours:
      errorXValue = errorXValue.add(Duration(hours: errorX));
      break;
    case DateTimeIntervalType.minutes:
      errorXValue = errorXValue.add(Duration(minutes: errorX));
      break;
    case DateTimeIntervalType.seconds:
      errorXValue = errorXValue.add(Duration(seconds: errorX));
      break;
    case DateTimeIntervalType.milliseconds:
      errorXValue = errorXValue.add(Duration(milliseconds: errorX));
      break;
    case DateTimeIntervalType.auto:
      errorXValue = errorXValue.add(Duration(milliseconds: errorX));
      break;
  }
  return errorXValue.millisecondsSinceEpoch.toDouble();
}

/// Returns the sampled data for fast line series
List<CartesianChartPoint<dynamic>> getSampledData(
        SeriesRendererDetails seriesRendererDetails) =>
    seriesRendererDetails.seriesType == 'fastline'
        ? seriesRendererDetails.sampledDataPoints
        : seriesRendererDetails.dataPoints;
