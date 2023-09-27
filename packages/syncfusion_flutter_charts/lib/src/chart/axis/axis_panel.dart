import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../axis/axis.dart';
import '../axis/category_axis.dart';
import '../axis/datetime_axis.dart';
import '../axis/datetime_category_axis.dart';
import '../axis/logarithmic_axis.dart';
import '../axis/numeric_axis.dart';
import '../base/chart_base.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
import '../common/cartesian_state_properties.dart';
import '../common/common.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';

/// Represents the chart axis panel
class ChartAxisPanel {
  /// Creates an instance of chart axis panel
  ChartAxisPanel(this.stateProperties) {
    innerPadding = 5;
    axisPadding = 5;
    axisLineLabelPadding = 5;
    axisLabelTitlePadding = 3;
    axisClipRect = Rect.zero;
    verticalAxisRenderers = <ChartAxisRenderer>[];
    horizontalAxisRenderers = <ChartAxisRenderer>[];
    needsRepaint = true;
  }

  /// Specifies the cartesian state properties
  final CartesianStateProperties stateProperties;

  /// Here, we are using get keyword inorder to get the proper & updated instance of chart widget
  //When we initialize chart widget as a property to other classes like ChartSeries, the chart widget is not updated properly and by using get we can rectify this.
  SfCartesianChart get chartWidget => stateProperties.chart;

  /// Specifies the value of primary XAxis renderer and primary YAxis renderer
  ChartAxisRenderer? primaryXAxisRenderer, primaryYAxisRenderer;

  /// Specifies the value of primary XAxis details and primary YAxis details
  late ChartAxisRendererDetails primaryXAxisDetails, primaryYAxisDetails;

  /// Specifies the value of left axis renderer
  List<ChartAxisRenderer> leftAxisRenderers = <ChartAxisRenderer>[];

  /// Specifies the value of right axis renderer
  List<ChartAxisRenderer> rightAxisRenderers = <ChartAxisRenderer>[];

  /// Specifies the value of top axis renderer
  List<ChartAxisRenderer> topAxisRenderers = <ChartAxisRenderer>[];

  /// Specifies the value of bottom axis renderer
  List<ChartAxisRenderer> bottomAxisRenderers = <ChartAxisRenderer>[];

  /// Specifies the left axes count value
  late List<AxisSize> leftAxesCount;

  /// Specifies the bottom axes count value
  late List<AxisSize> bottomAxesCount;

  /// Specifies the top axes count value
  late List<AxisSize> topAxesCount;

  /// Specifies the right axes count value
  late List<AxisSize> rightAxesCount;

  /// Specifies the bottom size value
  double bottomSize = 0;

  /// Specifies the top size value
  double topSize = 0;

  /// Specifies left size value
  double leftSize = 0;

  /// Specifies the right size value
  double rightSize = 0;

  /// Specifies the value of inner padding
  double innerPadding = 0;

  /// Specifies the axis padding value
  double axisPadding = 0;

  /// Specifies the padding between axis line and axis label
  double? axisLineLabelPadding;

  /// Specifies the padding between axis label and axis title
  double? axisLabelTitlePadding;

  /// Specifies the value of axis clip rect
  late Rect axisClipRect;

  /// Specifies the list of vertical axis renderers
  List<ChartAxisRenderer> verticalAxisRenderers = <ChartAxisRenderer>[];

  /// Specifies the list of horizontal axis renderers
  List<ChartAxisRenderer> horizontalAxisRenderers = <ChartAxisRenderer>[];

  /// Specifies the list of axes renderers
  List<ChartAxisRenderer> axisRenderersCollection = <ChartAxisRenderer>[];

  /// Whether to repaint axis or not
  late bool needsRepaint;

  /// To get the crossAt values of a specific axis
  void _getAxisCrossingValue(ChartAxisRenderer axisRenderer) {
    final ChartAxisRendererDetails axisDetails =
        AxisHelper.getAxisRendererDetails(axisRenderer);
    final ChartAxis axis = axisDetails.axis;
    if (axis.crossesAt != null) {
      if (axis.associatedAxisName != null) {
        for (int i = 0;
            i < stateProperties.chartAxis.axisRenderersCollection.length;
            i++) {
          if (axis.associatedAxisName ==
              AxisHelper.getAxisRendererDetails(
                      stateProperties.chartAxis.axisRenderersCollection[i])
                  .name) {
            axisDetails.crossAxisRenderer =
                stateProperties.chartAxis.axisRenderersCollection[i];
            _calculateCrossingValues(
                axisRenderer, axisDetails.crossAxisRenderer);
          }
        }
      } else {
        axisDetails.crossAxisRenderer = stateProperties.requireInvertedAxis
            ? (axisDetails.crossAxisRenderer =
                axisDetails.orientation == AxisOrientation.horizontal
                    ? stateProperties.chartAxis.primaryXAxisRenderer!
                    : stateProperties.chartAxis.primaryYAxisRenderer!)
            : (axisDetails.orientation == AxisOrientation.horizontal
                ? stateProperties.chartAxis.primaryYAxisRenderer!
                : stateProperties.chartAxis.primaryXAxisRenderer!);

        _calculateCrossingValues(axisRenderer, axisDetails.crossAxisRenderer);
      }
    }
  }

  ///To get the axis crossing value
  void _calculateCrossingValues(ChartAxisRenderer currentAxisRenderer,
      ChartAxisRenderer targetAxisRenderer) {
    final ChartAxisRendererDetails currentAxisDetails =
        AxisHelper.getAxisRendererDetails(currentAxisRenderer);
    final ChartAxisRendererDetails targetAxisDetails =
        AxisHelper.getAxisRendererDetails(targetAxisRenderer);
    dynamic value = currentAxisDetails.axis.crossesAt;
    value = value is String && num.tryParse(value) != null
        ? num.tryParse(value)
        : value;
    if (targetAxisDetails is DateTimeAxisDetails) {
      value = value is DateTime ? value.millisecondsSinceEpoch : value;
      targetAxisDetails.calculateRangeAndInterval(stateProperties, 'AxisCross');
    } else if (targetAxisDetails is CategoryAxisDetails) {
      value = value is num
          ? value.floor()
          : targetAxisDetails.labels.indexOf(value);
      targetAxisDetails.calculateRangeAndInterval(stateProperties, 'AxisCross');
    } else if (targetAxisDetails is DateTimeCategoryAxisDetails) {
      value = value is num
          ? value.floor()
          : (value is DateTime
              ? targetAxisDetails.labels
                  .indexOf('${value.microsecondsSinceEpoch}')
              : null);
      targetAxisDetails.calculateRangeAndInterval(stateProperties, 'AxisCross');
    } else if (targetAxisDetails is LogarithmicAxisDetails) {
      final LogarithmicAxis axis = targetAxisDetails.axis as LogarithmicAxis;
      value = calculateLogBaseValue(value, axis.logBase);
      targetAxisDetails.calculateRangeAndInterval(stateProperties, 'AxisCross');
    } else if (targetAxisDetails is NumericAxisDetails) {
      targetAxisDetails.calculateRangeAndInterval(stateProperties, 'AxisCross');
    }
    if (value.isNaN == false) {
      currentAxisDetails.crossValue =
          _updateCrossValue(value, targetAxisDetails.visibleRange!);
      currentAxisDetails.crossRange = targetAxisDetails.visibleRange;
    }
  }

  ///To measure the bounds of each axis
  void measureAxesBounds() {
    bottomSize = 0;
    topSize = 0;
    leftSize = 0;
    rightSize = 0;
    leftAxesCount = <AxisSize>[];
    bottomAxesCount = <AxisSize>[];
    topAxesCount = <AxisSize>[];
    rightAxesCount = <AxisSize>[];
    bottomAxisRenderers = <ChartAxisRenderer>[];
    rightAxisRenderers = <ChartAxisRenderer>[];
    topAxisRenderers = <ChartAxisRenderer>[];
    leftAxisRenderers = <ChartAxisRenderer>[];

    if (verticalAxisRenderers.isNotEmpty) {
      for (int axisIndex = 0;
          axisIndex < verticalAxisRenderers.length;
          axisIndex++) {
        final dynamic axisRenderer = verticalAxisRenderers[axisIndex];
        final dynamic axisDetails =
            AxisHelper.getAxisRendererDetails(axisRenderer);
        assert(
            !(axisDetails.axis.interval != null) ||
                (axisDetails.axis.interval! > 0) == true,
            'The vertical axis interval value must be greater than 0.');
        axisDetails.calculateRangeAndInterval(stateProperties);
        _getAxisCrossingValue(axisRenderer);
        _measureAxesSize(axisRenderer);
      }
      _calculateSeriesClipRect();
    }
    if (horizontalAxisRenderers.isNotEmpty) {
      for (int axisIndex = 0;
          axisIndex < horizontalAxisRenderers.length;
          axisIndex++) {
        final dynamic axisRenderer = horizontalAxisRenderers[axisIndex];
        final dynamic axisDetails =
            AxisHelper.getAxisRendererDetails(axisRenderer);
        _calculateLabelRotationAngle(axisDetails);
        assert(
            !(axisDetails.axis.interval != null) ||
                (axisDetails.axis.interval > 0) == true,
            'The horizontal axis interval value must be greater than 0.');
        axisDetails.calculateRangeAndInterval(stateProperties);
        _getAxisCrossingValue(axisRenderer);
        _measureAxesSize(axisRenderer);
      }
    }
    _calculateAxesRect();
  }

  ///Calculate the axes total size
  void _measureAxesSize(ChartAxisRenderer axisRenderer) {
    final ChartAxisRendererDetails axisDetails =
        AxisHelper.getAxisRendererDetails(axisRenderer);
    ChartAxisRendererDetails crossAxisRendererDetails;
    final ChartAxis axis = axisDetails.axis;
    final SfChartThemeData chartThemeData = axisDetails.chartThemeData;
    final TextStyle labelStyle = chartThemeData.axisLabelTextStyle!;
    final TextStyle titleStyle = chartThemeData.axisTitleTextStyle!;
    final bool isTitleEnabled =
        axis.title.text != null && axis.title.text!.isNotEmpty;
    double titleSize = 0;
    num multiLevelLabelSize = 0;
    axisDetails.totalSize = 0;
    if (axis.multiLevelLabels != null &&
        axis.multiLevelLabels!.isNotEmpty &&
        axisDetails.visibleRange != null) {
      if ((((axisDetails.visibleRange!.minimum! <=
                          axisDetails.minimumMultiLevelLabelValue! ==
                      true) &&
                  (axisDetails.minimumMultiLevelLabelValue! <=
                      axisDetails.visibleRange!.maximum!)) ||
              (axisDetails.visibleRange!.minimum! <=
                      axisDetails.maximumMultiLevelLabelValue! ==
                  true)) &&
          !(axisDetails.visibleRange!.minimum! <=
                      axisDetails.minimumMultiLevelLabelValue! ==
                  true &&
              axisDetails.visibleRange!.maximum! <=
                      axisDetails.minimumMultiLevelLabelValue! ==
                  true)) {
        axisDetails.isMultiLevelLabelEnabled = true;
      }
    }
    if (axis.borderWidth > 0 || (axisDetails.isMultiLevelLabelEnabled)) {
      const double axisLabelPadding = 10;
      double maximumLabelWidth = axisDetails.maximumLabelSize.width;
      double maximumLabelHeight = axisDetails.maximumLabelSize.height;
      if (axisDetails.orientation == AxisOrientation.horizontal) {
        maximumLabelHeight = maximumLabelHeight + axisLabelPadding;
      } else {
        maximumLabelWidth = maximumLabelWidth + axisLabelPadding;
      }
      axisDetails.maximumLabelSize =
          Size(maximumLabelWidth, maximumLabelHeight);
    }
    if (axis.isVisible) {
      if (isTitleEnabled) {
        titleSize =
            measureText(axis.title.text!, titleStyle).height + axisPadding;
        axisDetails.titleHeight = titleSize;
      }
      final Rect rect = stateProperties.renderingDetails.chartContainerRect;
      final int axisIndex = _getAxisIndex(axisRenderer);
      final double tickSize =
          (axisIndex == 0 && axis.tickPosition == TickPosition.inside)
              ? 0
              : math.max(
                      axis.majorTickLines.size,
                      axis.minorTicksPerInterval > 0
                          ? axis.minorTickLines.size
                          : 0) +
                  innerPadding;
      final double labelSize = (axisIndex == 0 &&
              axis.labelPosition == ChartDataLabelPosition.inside)
          ? 0
          : (labelStyle.fontSize == 0
                  ? 0
                  : (axisDetails.orientation == AxisOrientation.horizontal)
                      ? axisDetails.maximumLabelSize.height
                      : (axis.labelsExtent != null && axis.labelsExtent! > 0)
                          ? axis.labelsExtent
                          : axisDetails.maximumLabelSize.width)! +
              innerPadding;
      if (axisDetails.isMultiLevelLabelEnabled &&
          axis.labelPosition == ChartDataLabelPosition.outside) {
        multiLevelLabelSize =
            axisDetails.orientation == AxisOrientation.horizontal
                ? axisDetails.multiLevelLabelTotalSize.height
                : axisDetails.multiLevelLabelTotalSize.width;
        if (axisDetails.axis.multiLevelLabelStyle.borderType ==
                MultiLevelBorderType.squareBrace ||
            axisDetails.axis.multiLevelLabelStyle.borderType ==
                MultiLevelBorderType.curlyBrace) {
          const double bracePadding = 5;
          multiLevelLabelSize = multiLevelLabelSize + bracePadding;
        }
      }
      axisDetails.totalSize =
          titleSize + tickSize + labelSize + multiLevelLabelSize;
      if (axisDetails.orientation == AxisOrientation.horizontal) {
        if (!axis.opposedPosition) {
          axisDetails.totalSize += bottomAxisRenderers.isNotEmpty &&
                  labelStyle.fontSize! > 0 &&
                  (axis.labelPosition == ChartDataLabelPosition.outside ||
                      ((axis.majorTickLines.width > 0 ||
                              axis.minorTickLines.width > 0) &&
                          axis.tickPosition == TickPosition.outside) ||
                      (axis.title.text != null && axis.title.text != ''))
              ? axisPadding.toDouble()
              : 0;
          if (axisDetails.crossValue != null &&
              axisDetails.crossRange != null) {
            crossAxisRendererDetails = AxisHelper.getAxisRendererDetails(
                axisDetails.crossAxisRenderer);
            final num crossPosition = valueToCoefficient(
                    axisDetails.crossValue!, crossAxisRendererDetails) *
                rect.height;
            axisDetails.totalSize = crossPosition - axisDetails.totalSize < 0
                ? (crossPosition - axisDetails.totalSize).abs()
                : !axis.placeLabelsNearAxisLine
                    ? (isTitleEnabled ? labelSize + titleSize : labelSize)
                    : 0;
            if (axisDetails.isMultiLevelLabelEnabled &&
                axis.labelPosition == ChartDataLabelPosition.outside) {
              axisDetails.totalSize = !axis.placeLabelsNearAxisLine
                  ? axisDetails.totalSize + (multiLevelLabelSize.toDouble())
                  : axisDetails.totalSize;
            }
          }
          bottomSize += axisDetails.totalSize +
              (bottomAxesCount.isNotEmpty && bottomAxesCount.length > 1
                  ? axisPadding
                  : 0);
          bottomAxesCount.add(AxisSize(axisRenderer, axisDetails.totalSize));
        } else {
          axisDetails.totalSize += topAxisRenderers.isNotEmpty &&
                  labelStyle.fontSize! > 0 &&
                  (axis.labelPosition == ChartDataLabelPosition.outside ||
                      ((axis.majorTickLines.width > 0 ||
                              axis.minorTickLines.width > 0) &&
                          axis.tickPosition == TickPosition.outside) ||
                      (axis.title.text != null && axis.title.text != ''))
              ? axisPadding.toDouble()
              : 0;
          if (axisDetails.crossValue != null &&
              axisDetails.crossRange != null) {
            crossAxisRendererDetails = AxisHelper.getAxisRendererDetails(
                axisDetails.crossAxisRenderer);
            final num crossPosition = valueToCoefficient(
                    axisDetails.crossValue!, crossAxisRendererDetails) *
                rect.height;
            axisDetails.totalSize = crossPosition + axisDetails.totalSize >
                    rect.height
                ? ((crossPosition + axisDetails.totalSize) - rect.height).abs()
                : !axis.placeLabelsNearAxisLine
                    ? (isTitleEnabled ? labelSize + titleSize : labelSize)
                    : 0;
            if (axisDetails.isMultiLevelLabelEnabled &&
                axis.labelPosition == ChartDataLabelPosition.outside) {
              axisDetails.totalSize = !axis.placeLabelsNearAxisLine
                  ? axisDetails.totalSize + (multiLevelLabelSize.toDouble())
                  : axisDetails.totalSize;
            }
          }
          topSize += axisDetails.totalSize +
              (topAxesCount.isNotEmpty && topAxesCount.length > 1
                  ? axisPadding
                  : 0);
          topAxesCount.add(AxisSize(axisRenderer, axisDetails.totalSize));
        }
      } else if (axisDetails.orientation == AxisOrientation.vertical) {
        if (!axis.opposedPosition) {
          axisDetails.totalSize += leftAxisRenderers.isNotEmpty &&
                  labelStyle.fontSize! > 0 &&
                  (axis.labelPosition == ChartDataLabelPosition.outside ||
                      ((axis.majorTickLines.width > 0 ||
                              axis.minorTickLines.width > 0) &&
                          axis.tickPosition == TickPosition.outside) ||
                      (axis.title.text != null && axis.title.text != ''))
              ? axisPadding.toDouble()
              : 0;
          if (axisDetails.crossValue != null &&
              axisDetails.crossRange != null) {
            crossAxisRendererDetails = AxisHelper.getAxisRendererDetails(
                axisDetails.crossAxisRenderer);
            final num crossPosition = valueToCoefficient(
                    axisDetails.crossValue!, crossAxisRendererDetails) *
                rect.width;
            axisDetails.totalSize = crossPosition - axisDetails.totalSize < 0
                ? (crossPosition - axisDetails.totalSize).abs()
                : !axis.placeLabelsNearAxisLine
                    ? (isTitleEnabled ? labelSize + titleSize : labelSize)
                    : 0;
            if (axisDetails.isMultiLevelLabelEnabled &&
                axis.labelPosition == ChartDataLabelPosition.outside) {
              axisDetails.totalSize = !axis.placeLabelsNearAxisLine
                  ? axisDetails.totalSize + (multiLevelLabelSize.toDouble())
                  : axisDetails.totalSize;
            }
          }
          leftSize += axisDetails.totalSize +
              (leftAxesCount.isNotEmpty && leftAxesCount.length > 1
                  ? axisPadding
                  : 0);
          leftAxesCount.add(AxisSize(axisRenderer, axisDetails.totalSize));
        } else {
          axisDetails.totalSize += rightAxisRenderers.isNotEmpty &&
                  labelStyle.fontSize! > 0 &&
                  (axis.labelPosition == ChartDataLabelPosition.outside ||
                      ((axis.majorTickLines.width > 0 ||
                              axis.minorTickLines.width > 0) &&
                          axis.tickPosition == TickPosition.outside) ||
                      (axis.title.text != null && axis.title.text != ''))
              ? axisPadding.toDouble()
              : 0;
          if (axisDetails.crossValue != null &&
              axisDetails.crossRange != null) {
            crossAxisRendererDetails = AxisHelper.getAxisRendererDetails(
                axisDetails.crossAxisRenderer);
            final num crossPosition = valueToCoefficient(
                    axisDetails.crossValue!, crossAxisRendererDetails) *
                rect.width;
            axisDetails.totalSize = crossPosition + axisDetails.totalSize >
                    rect.width
                ? ((crossPosition + axisDetails.totalSize) - rect.width).abs()
                : !axis.placeLabelsNearAxisLine
                    ? (isTitleEnabled ? labelSize + titleSize : labelSize)
                    : 0;
            if (axisDetails.isMultiLevelLabelEnabled &&
                axis.labelPosition == ChartDataLabelPosition.outside) {
              axisDetails.totalSize = !axis.placeLabelsNearAxisLine
                  ? axisDetails.totalSize + (multiLevelLabelSize.toDouble())
                  : axisDetails.totalSize;
            }
          }
          rightSize += axisDetails.totalSize +
              (rightAxesCount.isNotEmpty && rightAxesCount.length > 1
                  ? axisPadding
                  : 0);
          rightAxesCount.add(AxisSize(axisRenderer, axisDetails.totalSize));
        }
      }
    }
  }

  /// To get the axis index
  int _getAxisIndex(ChartAxisRenderer axisRenderer) {
    int index;
    final ChartAxisRendererDetails axisDetails =
        AxisHelper.getAxisRendererDetails(axisRenderer);
    final ChartAxis axis = axisDetails.axis;
    if (axisDetails.orientation == AxisOrientation.horizontal) {
      if (!axis.opposedPosition) {
        bottomAxisRenderers.add(axisRenderer);
        index = bottomAxisRenderers.length;
      } else {
        topAxisRenderers.add(axisRenderer);
        index = topAxisRenderers.length;
      }
    } else if (axisDetails.orientation == AxisOrientation.vertical) {
      if (!axis.opposedPosition) {
        leftAxisRenderers.add(axisRenderer);
        index = leftAxisRenderers.length;
      } else {
        rightAxisRenderers.add(axisRenderer);
        index = rightAxisRenderers.length;
      }
    } else {
      index = 0;
    }
    return index - 1;
  }

  ///To find the axis label rotation angle
  void _calculateLabelRotationAngle(ChartAxisRendererDetails axisDetails) {
    int angle = axisDetails.labelRotation;
    if (angle < -360 || angle > 360) {
      angle %= 360;
    }
    if (angle.isNegative) {
      angle = angle + 360;
    }
    axisDetails.labelRotation = angle;
  }

  /// Calculate series clip rect size
  void _calculateSeriesClipRect() {
    final Rect containerRect =
        stateProperties.renderingDetails.chartContainerRect;
    final num padding = chartWidget.title.text.isNotEmpty ? 10 : 0;
    stateProperties.chartAxis.axisClipRect = Rect.fromLTWH(
        containerRect.left + leftSize,
        containerRect.top + topSize + padding,
        containerRect.width - leftSize - rightSize,
        containerRect.height - topSize - bottomSize - padding);
  }

  /// To return the crossAt value
  num _updateCrossValue(num value, VisibleRange range) {
    if (value < range.minimum) {
      value = range.minimum;
    }
    if (value > range.maximum) {
      value = range.maximum;
    }
    return value;
  }

  /// Return the axis offset value for x and y axis
  num? _getPrevAxisOffset(
      List<AxisSize> axesSize, Rect rect, int currentAxisIndex, String type) {
    num? prevAxisOffsetValue;
    if (currentAxisIndex > 0) {
      for (int i = currentAxisIndex - 1; i >= 0; i--) {
        final ChartAxisRenderer axisRenderer = axesSize[i].axisRenderer;
        final ChartAxisRendererDetails axisDetails =
            AxisHelper.getAxisRendererDetails(axisRenderer);
        final Rect bounds = axisDetails.bounds;
        final bool isLabelPositionInside =
            axisDetails.axis.labelPosition == ChartDataLabelPosition.inside;
        if (type == 'Left' &&
            ((axisDetails.labelOffset != null
                    ? axisDetails.labelOffset! -
                        axisDetails.maximumLabelSize.width
                    : bounds.left - bounds.width) <
                rect.left)) {
          prevAxisOffsetValue = axisDetails.labelOffset != null
              ? axisDetails.labelOffset! -
                  (!isLabelPositionInside
                      ? axisDetails.maximumLabelSize.width
                      : 0) -
                  (axisDetails.isMultiLevelLabelEnabled
                      ? axisDetails.multiLevelLabelTotalSize.width
                      : 0) -
                  ((axisDetails.titleOffset != null)
                      ? axisDetails.titleHeight!
                      : 0)
              : bounds.left - bounds.width;
          break;
        } else if (type == 'Bottom' &&
            ((axisDetails.labelOffset != null
                    ? axisDetails.labelOffset! +
                        axisDetails.maximumLabelSize.height
                    : bounds.top + bounds.height) >
                rect.top + rect.height)) {
          prevAxisOffsetValue = axisDetails.labelOffset != null
              ? axisDetails.labelOffset! +
                  (!isLabelPositionInside
                      ? axisDetails.maximumLabelSize.height
                      : 0) +
                  (axisDetails.isMultiLevelLabelEnabled
                      ? axisDetails.multiLevelLabelTotalSize.height
                      : 0) +
                  ((axisDetails.titleOffset != null)
                      ? axisDetails.titleHeight!
                      : 0)
              : bounds.top + bounds.height;
          break;
        } else if (type == 'Right' &&
            ((axisDetails.labelOffset != null
                    ? axisDetails.labelOffset! +
                        axisDetails.maximumLabelSize.width
                    : bounds.left + bounds.width) >
                rect.left + rect.width)) {
          prevAxisOffsetValue = axisDetails.labelOffset != null
              ? axisDetails.labelOffset! +
                  (!isLabelPositionInside
                      ? axisDetails.maximumLabelSize.width
                      : 0) +
                  (axisDetails.isMultiLevelLabelEnabled
                      ? axisDetails.multiLevelLabelTotalSize.width
                      : 0) +
                  ((axisDetails.titleOffset != null)
                      ? axisDetails.titleHeight!
                      : 0)
              : bounds.left + bounds.width;
          break;
        } else if (type == 'Top' &&
            ((axisDetails.labelOffset != null
                    ? axisDetails.labelOffset! -
                        axisDetails.maximumLabelSize.height
                    : bounds.top - bounds.height) <
                rect.top)) {
          prevAxisOffsetValue = axisDetails.labelOffset != null
              ? axisDetails.labelOffset! -
                  (!isLabelPositionInside
                      ? axisDetails.maximumLabelSize.height
                      : 0) -
                  (axisDetails.isMultiLevelLabelEnabled
                      ? axisDetails.multiLevelLabelTotalSize.height
                      : 0) -
                  ((axisDetails.titleOffset != null)
                      ? axisDetails.titleHeight!
                      : 0)
              : bounds.top - bounds.height;
          break;
        }
      }
    }
    return prevAxisOffsetValue;
  }

  /// Calculate axes bounds based on all axes
  void _calculateAxesRect() {
    _calculateSeriesClipRect();

    /// Calculate the left axes rect
    if (leftAxesCount.isNotEmpty) {
      _calculateLeftAxesBounds();
    }

    /// Calculate the bottom axes rect
    if (bottomAxesCount.isNotEmpty) {
      _calculateBottomAxesBounds();
    }

    /// Calculate the right axes rect
    if (rightAxesCount.isNotEmpty) {
      _calculateRightAxesBounds();
    }

    /// Calculate the top axes rect
    if (topAxesCount.isNotEmpty) {
      _calculateTopAxesBounds();
    }
  }

  /// Calculate the left axes bounds
  void _calculateLeftAxesBounds() {
    double axisSize, width;
    final int axesLength = leftAxesCount.length;
    final Rect rect = stateProperties.chartAxis.axisClipRect;
    for (int axisIndex = 0; axisIndex < axesLength; axisIndex++) {
      width = leftAxesCount[axisIndex].size;
      final ChartAxisRenderer axisRenderer =
          leftAxesCount[axisIndex].axisRenderer;
      final ChartAxisRendererDetails axisDetails =
          AxisHelper.getAxisRendererDetails(axisRenderer);
      ChartAxisRendererDetails crossAxisRendererDetails;
      final ChartAxis axis = axisDetails.axis;
      assert(axis.plotOffset >= 0,
          'The plot offset value of the axis must be greater than or equal to 0.');
      if (axisDetails.crossValue != null) {
        crossAxisRendererDetails =
            AxisHelper.getAxisRendererDetails(axisDetails.crossAxisRenderer);
        axisSize = (valueToCoefficient(
                    axisDetails.crossValue!, crossAxisRendererDetails) *
                rect.width) +
            rect.left;
        if (axisIndex == 0 && !axis.placeLabelsNearAxisLine) {
          axisDetails.labelOffset = rect.left +
              (axis.labelPosition == ChartDataLabelPosition.inside
                  ? axisLineLabelPadding!
                  : -axisLineLabelPadding!);
          if (axis.title.text != null && axis.title.text!.isNotEmpty) {
            axisDetails.titleOffset =
                axis.labelPosition == ChartDataLabelPosition.inside
                    ? rect.left - axisLabelTitlePadding!
                    : rect.left -
                        axisLabelTitlePadding! -
                        (axisDetails.isMultiLevelLabelEnabled
                            ? axisDetails.multiLevelLabelTotalSize.width
                            : 0) -
                        axisDetails.maximumLabelSize.width;
          }
        }
      } else {
        final num? prevAxisOffsetValue =
            _getPrevAxisOffset(leftAxesCount, rect, axisIndex, 'Left');
        axisSize = prevAxisOffsetValue == null
            ? rect.left
            : (prevAxisOffsetValue -
                    (axis.labelPosition == ChartDataLabelPosition.inside
                        ? (innerPadding + axisDetails.maximumLabelSize.width)
                        : 0)) -
                (axis.tickPosition == TickPosition.inside
                    ? math.max(
                        axis.majorTickLines.size,
                        axis.minorTicksPerInterval > 0
                            ? axis.minorTickLines.size
                            : 0)
                    : 0) -
                axisPadding;
      }
      axisDetails.bounds = Rect.fromLTWH(axisSize, rect.top + axis.plotOffset,
          width, rect.height - 2 * axis.plotOffset);
    }
  }

  /// Calculate the bottom axes bounds
  void _calculateBottomAxesBounds() {
    double axisSize, height;
    final int axesLength = bottomAxesCount.length;
    final Rect rect = stateProperties.chartAxis.axisClipRect;
    for (int axisIndex = 0; axisIndex < axesLength; axisIndex++) {
      height = bottomAxesCount[axisIndex].size;
      final ChartAxisRenderer axisRenderer =
          bottomAxesCount[axisIndex].axisRenderer;
      final ChartAxisRendererDetails axisDetails =
          AxisHelper.getAxisRendererDetails(axisRenderer);
      ChartAxisRendererDetails crossAxisRendererDetails;
      final ChartAxis axis = axisDetails.axis;
      assert(axis.plotOffset >= 0,
          'The plot offset value of the axis must be greater than or equal to 0.');
      if (axisDetails.crossValue != null) {
        crossAxisRendererDetails =
            AxisHelper.getAxisRendererDetails(axisDetails.crossAxisRenderer);
        axisSize = rect.top +
            rect.height -
            (valueToCoefficient(
                    axisDetails.crossValue!, crossAxisRendererDetails) *
                rect.height);
        if (axisIndex == 0 && !axis.placeLabelsNearAxisLine) {
          axisDetails.labelOffset = rect.top +
              rect.height +
              (axis.labelPosition == ChartDataLabelPosition.inside
                  ? -axisLineLabelPadding!
                  : axisLineLabelPadding!);
          if (axis.title.text != null && axis.title.text!.isNotEmpty) {
            axisDetails.titleOffset =
                axis.labelPosition == ChartDataLabelPosition.inside
                    ? rect.top + rect.height + axisLabelTitlePadding!
                    : rect.top +
                        rect.height +
                        axisLabelTitlePadding! +
                        axisLineLabelPadding! +
                        (axisDetails.isMultiLevelLabelEnabled
                            ? axisDetails.multiLevelLabelTotalSize.height
                            : 0) +
                        axisDetails.maximumLabelSize.height;
          }
        }
      } else {
        final num? prevAxisOffsetValue =
            _getPrevAxisOffset(bottomAxesCount, rect, axisIndex, 'Bottom');
        axisSize = (prevAxisOffsetValue == null)
            ? rect.top + rect.height
            : axisPadding +
                prevAxisOffsetValue +
                (axis.labelPosition == ChartDataLabelPosition.inside
                    ? (innerPadding + axisDetails.maximumLabelSize.height)
                    : 0) +
                (axis.tickPosition == TickPosition.inside
                    ? math.max(
                        axis.majorTickLines.size,
                        axis.minorTicksPerInterval > 0
                            ? axis.minorTickLines.size
                            : 0)
                    : 0);
      }
      axisDetails.bounds = Rect.fromLTWH(rect.left + axis.plotOffset, axisSize,
          rect.width - 2 * axis.plotOffset, height);
    }
  }

  /// Calculate the right axes bounds
  void _calculateRightAxesBounds() {
    double axisSize, width;
    final int axesLength = rightAxesCount.length;
    final Rect rect = stateProperties.chartAxis.axisClipRect;
    for (int axisIndex = 0; axisIndex < axesLength; axisIndex++) {
      final ChartAxisRenderer axisRenderer =
          rightAxesCount[axisIndex].axisRenderer;
      final ChartAxisRendererDetails axisDetails =
          AxisHelper.getAxisRendererDetails(axisRenderer);
      ChartAxisRendererDetails crossAxisRendererDetails;
      final ChartAxis axis = axisDetails.axis;
      assert(axis.plotOffset >= 0,
          'The plot offset value of the axis must be greater than or equal to 0.');
      width = rightAxesCount[axisIndex].size;
      if (axisDetails.crossValue != null) {
        crossAxisRendererDetails =
            AxisHelper.getAxisRendererDetails(axisDetails.crossAxisRenderer);
        axisSize = rect.left +
            (valueToCoefficient(
                    axisDetails.crossValue!, crossAxisRendererDetails) *
                rect.width);
        if (axisIndex == 0 && !axis.placeLabelsNearAxisLine) {
          axisDetails.labelOffset = rect.left +
              rect.width +
              (axis.labelPosition == ChartDataLabelPosition.inside
                  ? -axisLineLabelPadding!
                  : axisLineLabelPadding!);
          if (axis.title.text != null && axis.title.text!.isNotEmpty) {
            axisDetails.titleOffset =
                axis.labelPosition == ChartDataLabelPosition.inside
                    ? rect.left + rect.width + axisLabelTitlePadding!
                    : rect.left +
                        rect.width +
                        axisLabelTitlePadding! +
                        axisLineLabelPadding! +
                        (axisDetails.isMultiLevelLabelEnabled
                            ? axisDetails.multiLevelLabelTotalSize.width
                            : 0) +
                        axisDetails.maximumLabelSize.width;
          }
        }
      } else {
        final num? prevAxisOffsetValue =
            _getPrevAxisOffset(rightAxesCount, rect, axisIndex, 'Right');
        axisSize = (prevAxisOffsetValue == null)
            ? rect.left + rect.width
            : (prevAxisOffsetValue +
                    (axis.labelPosition == ChartDataLabelPosition.inside
                        ? axisDetails.maximumLabelSize.width + innerPadding
                        : 0)) +
                (axis.tickPosition == TickPosition.inside
                    ? math.max(
                        axis.majorTickLines.size,
                        axis.minorTicksPerInterval > 0
                            ? axis.minorTickLines.size
                            : 0)
                    : 0) +
                axisPadding;
      }
      axisDetails.bounds = Rect.fromLTWH(axisSize, rect.top + axis.plotOffset,
          width, rect.height - 2 * axis.plotOffset);
    }
  }

  /// Calculate the top axes bounds
  void _calculateTopAxesBounds() {
    double axisSize, height;
    final int axesLength = topAxesCount.length;
    final Rect rect = stateProperties.chartAxis.axisClipRect;
    for (int axisIndex = 0; axisIndex < axesLength; axisIndex++) {
      final ChartAxisRenderer axisRenderer =
          topAxesCount[axisIndex].axisRenderer;
      final ChartAxisRendererDetails axisDetails =
          AxisHelper.getAxisRendererDetails(axisRenderer);
      ChartAxisRendererDetails crossAxisRendererDetails;
      final ChartAxis axis = axisDetails.axis;
      assert(axis.plotOffset >= 0,
          'The plot offset value of the axis must be greater than or equal to 0.');
      height = topAxesCount[axisIndex].size;
      if (axisDetails.crossValue != null) {
        crossAxisRendererDetails =
            AxisHelper.getAxisRendererDetails(axisDetails.crossAxisRenderer);
        axisSize = rect.top +
            rect.height -
            (valueToCoefficient(
                    axisDetails.crossValue!, crossAxisRendererDetails) *
                rect.height);
        if (axisIndex == 0 && !axis.placeLabelsNearAxisLine) {
          axisDetails.labelOffset = rect.top +
              (axis.labelPosition == ChartDataLabelPosition.inside
                  ? axisLineLabelPadding!
                  : -axisLineLabelPadding!);
          if (axis.title.text != null && axis.title.text!.isNotEmpty) {
            axisDetails.titleOffset =
                axis.labelPosition == ChartDataLabelPosition.inside
                    ? rect.top - axisLabelTitlePadding!
                    : rect.top -
                        axisLabelTitlePadding! -
                        axisLineLabelPadding! -
                        (axisDetails.isMultiLevelLabelEnabled
                            ? axisDetails.multiLevelLabelTotalSize.height
                            : 0) -
                        axisDetails.maximumLabelSize.height;
          }
        }
      } else {
        final num? prevAxisOffsetValue =
            _getPrevAxisOffset(topAxesCount, rect, axisIndex, 'Top');
        axisSize = (prevAxisOffsetValue == null)
            ? rect.top
            : prevAxisOffsetValue -
                (axis.labelPosition == ChartDataLabelPosition.inside
                    ? (axisPadding + axisDetails.maximumLabelSize.height)
                    : 0) -
                (axis.tickPosition == TickPosition.inside
                    ? math.max(
                        axis.majorTickLines.size,
                        axis.minorTicksPerInterval > 0
                            ? axis.minorTickLines.size
                            : 0)
                    : 0) -
                axisPadding;
      }
      axisDetails.bounds = Rect.fromLTWH(rect.left + axis.plotOffset, axisSize,
          rect.width - 2 * axis.plotOffset, height);
    }
  }

  /// Calculate the visible axes
  void calculateVisibleAxes() {
    if (primaryXAxisRenderer != null) {
      primaryXAxisRenderer!.dispose();
    }

    if (primaryYAxisRenderer != null) {
      primaryYAxisRenderer!.dispose();
    }

    innerPadding = chartWidget.borderWidth;
    axisPadding = 5;
    axisClipRect = Rect.zero;
    verticalAxisRenderers = <ChartAxisRenderer>[];
    horizontalAxisRenderers = <ChartAxisRenderer>[];
    axisRenderersCollection = <ChartAxisRenderer>[];
    primaryXAxisRenderer = _getAxisRenderer(chartWidget.primaryXAxis);
    primaryYAxisRenderer = _getAxisRenderer(chartWidget.primaryYAxis);
    primaryXAxisDetails =
        AxisHelper.getAxisRendererDetails(primaryXAxisRenderer!);
    primaryYAxisDetails =
        AxisHelper.getAxisRendererDetails(primaryYAxisRenderer!);
    primaryXAxisDetails.name = (primaryXAxisDetails.name) ?? 'primaryXAxis';
    primaryYAxisDetails.name = primaryYAxisDetails.name ?? 'primaryYAxis';

    final List<ChartAxis> axesCollection = <ChartAxis>[
      chartWidget.primaryXAxis,
      chartWidget.primaryYAxis
    ];
    final List<CartesianSeriesRenderer> visibleSeriesRenderer =
        stateProperties.chartSeries.visibleSeriesRenderers;
    if (visibleSeriesRenderer.isNotEmpty) {
      if (chartWidget.axes.isNotEmpty) {
        axesCollection.addAll(chartWidget.axes);
      }

      for (int axisIndex = 0; axisIndex < axesCollection.length; axisIndex++) {
        final ChartAxisRenderer axisRenderer = axisIndex == 0
            ? primaryXAxisRenderer!
            : (axisIndex == 1
                ? primaryYAxisRenderer!
                : _getAxisRenderer(axesCollection[axisIndex]));
        final ChartAxisRendererDetails axisDetails =
            AxisHelper.getAxisRendererDetails(axisRenderer);

        final ChartAxis axis = axesCollection[axisIndex];
        final SfChartThemeData chartThemeData =
            stateProperties.renderingDetails.chartTheme;
        axisDetails.chartThemeData = chartThemeData.copyWith(
          axisLabelTextStyle:
              chartThemeData.axisLabelTextStyle?.merge(axis.labelStyle),
          axisTitleTextStyle:
              chartThemeData.axisTitleTextStyle?.merge(axis.title.textStyle),
          axisMultiLevelLabelTextStyle: chartThemeData
              .axisMultiLevelLabelTextStyle
              ?.merge(axis.multiLevelLabelStyle.textStyle),
          crosshairTextStyle: chartThemeData.crosshairTextStyle
              ?.merge(axis.interactiveTooltip.textStyle),
          selectionZoomingTooltipTextStyle: chartThemeData
              .selectionZoomingTooltipTextStyle
              ?.merge(axis.interactiveTooltip.textStyle),
        );

        if (axisDetails is CategoryAxisDetails) {
          axisDetails.labels = <String>[];
        } else if (axisDetails is DateTimeCategoryAxisDetails) {
          axisDetails.labels = <String>[];
        }
        axisDetails.seriesRenderers = <CartesianSeriesRenderer>[];
        for (int seriesIndex = 0;
            seriesIndex < visibleSeriesRenderer.length;
            seriesIndex++) {
          final CartesianSeriesRenderer seriesRenderer =
              visibleSeriesRenderer[seriesIndex];
          final SeriesRendererDetails seriesRendererDetails =
              SeriesHelper.getSeriesRendererDetails(seriesRenderer);
          final XyDataSeries<dynamic, dynamic> series =
              seriesRendererDetails.series as XyDataSeries<dynamic, dynamic>;
          if ((axisDetails.name != null &&
                  axisDetails.name == series.xAxisName) ||
              (series.xAxisName == null &&
                  axisDetails.name == primaryXAxisDetails.name) ||
              (series.xAxisName != null &&
                  axisDetails.name != series.xAxisName &&
                  axisDetails.name ==
                      stateProperties.chartAxis.primaryXAxisDetails.name)) {
            axisDetails.orientation = stateProperties.requireInvertedAxis
                ? AxisOrientation.vertical
                : AxisOrientation.horizontal;
            seriesRendererDetails.xAxisDetails = axisDetails;
            axisDetails.seriesRenderers.add(seriesRenderer);
          } else if ((axisDetails.name != null &&
                  axisDetails.name == series.yAxisName) ||
              (series.yAxisName == null &&
                  axisDetails.name == primaryYAxisDetails.name) ||
              (series.yAxisName != null &&
                  axisDetails.name != series.yAxisName &&
                  axisDetails.name ==
                      stateProperties.chartAxis.primaryYAxisDetails.name)) {
            axisDetails.orientation = stateProperties.requireInvertedAxis
                ? AxisOrientation.horizontal
                : AxisOrientation.vertical;
            seriesRendererDetails.yAxisDetails = axisDetails;
            axisDetails.seriesRenderers.add(seriesRenderer);
          }
        }

        ///Adding unmapped axes which were mapped with the indicators
        if (axisDetails.orientation == null &&
            chartWidget.indicators.isNotEmpty) {
          for (int i = 0; i < chartWidget.indicators.length; i++) {
            if (chartWidget.indicators[i].isVisible) {
              if (chartWidget.indicators[i].xAxisName == axisDetails.name) {
                axisDetails.orientation = stateProperties.requireInvertedAxis
                    ? AxisOrientation.vertical
                    : AxisOrientation.horizontal;
              } else if (chartWidget.indicators[i].yAxisName ==
                  axisDetails.name) {
                axisDetails.orientation = stateProperties.requireInvertedAxis
                    ? AxisOrientation.horizontal
                    : AxisOrientation.vertical;
              }
            }
          }
        }
        if (axisDetails.orientation != null) {
          axisDetails.orientation == AxisOrientation.vertical
              ? verticalAxisRenderers.add(axisRenderer)
              : horizontalAxisRenderers.add(axisRenderer);
        }
        final ChartAxisRenderer? oldAxisRenderer =
            getOldAxisRenderer(axisRenderer, stateProperties.oldAxisRenderers);
        axisDetails.oldAxis =
            stateProperties.renderingDetails.widgetNeedUpdate &&
                    oldAxisRenderer != null
                ? AxisHelper.getAxisRendererDetails(oldAxisRenderer).axis
                : null;
        axisRenderersCollection.add(axisRenderer);
      }
    } else {
      stateProperties.chartAxis.primaryXAxisDetails.orientation =
          stateProperties.requireInvertedAxis
              ? AxisOrientation.vertical
              : AxisOrientation.horizontal;
      stateProperties.chartAxis.primaryYAxisDetails.orientation =
          stateProperties.requireInvertedAxis
              ? AxisOrientation.horizontal
              : AxisOrientation.vertical;
      horizontalAxisRenderers.add(primaryXAxisRenderer!);
      verticalAxisRenderers.add(primaryYAxisRenderer!);
      axisRenderersCollection.add(primaryXAxisRenderer!);
      axisRenderersCollection.add(primaryYAxisRenderer!);
    }
  }

  ChartAxisRenderer _getAxisRenderer(ChartAxis axis) {
    switch (axis.runtimeType) {
      case NumericAxis:
        return NumericAxisRenderer(axis as NumericAxis, stateProperties);
      case LogarithmicAxis:
        return LogarithmicAxisRenderer(
            axis as LogarithmicAxis, stateProperties);
      case CategoryAxis:
        return CategoryAxisRenderer(axis as CategoryAxis, stateProperties);
      case DateTimeAxis:
        return DateTimeAxisRenderer(axis as DateTimeAxis, stateProperties);
      case DateTimeCategoryAxis:
        return DateTimeCategoryAxisRenderer(
            axis as DateTimeCategoryAxis, stateProperties);
      default:
        return NumericAxisRenderer(axis as NumericAxis, stateProperties);
    }
  }
}
