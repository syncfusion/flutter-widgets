import 'package:flutter/material.dart';

import '../../circular_chart/base/circular_base.dart';
import '../../common/event_args.dart';
import '../../common/user_interaction/selection_behavior.dart';
import '../../common/utils/helper.dart';
import '../../common/utils/typedef.dart';
import '../../funnel_chart/base/funnel_base.dart';
import '../base/chart_base.dart';
import '../chart_segment/box_and_whisker_segment.dart';
import '../chart_segment/candle_segment.dart';
import '../chart_segment/chart_segment.dart';
import '../chart_segment/error_bar_segment.dart';
import '../chart_segment/fastline_segment.dart';
import '../chart_segment/hilo_segment.dart';
import '../chart_segment/hiloopenclose_segment.dart';
import '../chart_segment/line_segment.dart';
import '../chart_segment/spline_segment.dart';
import '../chart_segment/stacked_line_segment.dart';
import '../chart_segment/stackedline100_segment.dart';
import '../chart_segment/stepline_segment.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
import '../common/common.dart';
import '../common/segment_properties.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';

/// Creates a selection renderer for selection behavior.
class SelectionRenderer {
  /// Calling the default constructor of SelectionRenderer class.
  SelectionRenderer();

  /// Represents the point index of the data points.
  int? pointIndex;

  /// Represents the series index of the cartesian series.
  int? seriesIndex;

  /// Represens the value of cartesian series index.
  late int cartesianSeriesIndex;

  /// Represents the value of cartesian point index.
  int? cartesianPointIndex;

  /// Specifies whether the selection is done or not.
  late bool isSelection;

  /// Specifies the value of selected and current segment.
  SegmentProperties? selectedSegmentProperties, currentSegmentProperties;

  /// Holds the list of default selected segments.
  final List<ChartSegment> defaultselectedSegments = <ChartSegment>[];

  /// Holds the list of default unselected segments.
  final List<ChartSegment> defaultunselectedSegments = <ChartSegment>[];

  /// Specifies whether the segmens is selected or not.
  bool isSelected = false;

  /// Represents the value of chart.
  late dynamic chart;

  /// Represents the chart state properties.
  late dynamic stateProperties;

  /// Represents the chart series renderer.
  dynamic seriesRendererDetails;

  /// Represents the fill and stroke color for selection painter.
  late Color fillColor, strokeColor;

  /// Represents the value of fill and stroke opacity.
  late double fillOpacity, strokeOpacity;

  /// Represents the value of stroke width.
  late double strokeWidth;

  /// Specifies the value of selection args.
  SelectionArgs? selectionArgs;

  /// Specifies the value of selected segments.
  late List<ChartSegment> selectedSegments;

  /// Specifies the value of unselected segments.
  List<ChartSegment>? unselectedSegments;

  /// Specifies the data point selection type.
  SelectionType? selectionType;

  /// Represents the value of viewport point index.
  int? viewportIndex;

  /// Specifies whether the point is selected or not.
  bool selected = false;

  /// Specifies the user interaction is performed or not for selection.
  bool isInteraction = false;

  /// Selects or deselects the specified data point in the series.
  ///
  /// The following are the arguments to be passed.
  /// * `pointIndex` - index of the data point that needs to be selected.
  /// * `seriesIndex` - index of the series in which the data point is selected.
  ///
  /// Where the `pointIndex` is a required argument and `seriesIndex` is an optional argument. By default, `0` will
  /// be considered as the series index. Thus it will take effect on the first series if no value is specified.
  ///
  /// For circular, pyramid and funnel charts, series index should always be `0`, as it has only one series.
  ///
  /// If the specified data point is already selected, it will be deselected, else it will be selected.
  /// Selection type and multi-selection functionality is also applicable for this, but it is based on
  /// the API values specified in [ChartSelectionBehavior].
  ///
  /// _Note:_  Even though, the [enable] property in [ChartSelectionBehavior] is set to false, this method
  /// will work.

  void selectDataPoints(int? pointIndex, [int? seriesIndex]) {
    if (chart is SfCartesianChart) {
      if (validIndex(pointIndex, seriesIndex, chart)) {
        bool select = false;
        final List<CartesianSeriesRenderer> seriesRenderList =
            stateProperties.chartSeries.visibleSeriesRenderers;
        final CartesianSeriesRenderer seriesRender =
            seriesRenderList[seriesIndex!];
        selected = pointIndex != null;
        viewportIndex = getVisibleDataPointIndex(
            pointIndex, SeriesHelper.getSeriesRendererDetails(seriesRender));
        final String seriesType = seriesRendererDetails.seriesType;
        final SelectionBehaviorRenderer selectionBehaviorRenderer =
            seriesRendererDetails.selectionBehaviorRenderer;
        final SelectionDetails selectionDetails =
            SelectionHelper.getRenderingDetails(selectionBehaviorRenderer);
        selectionDetails.selectionRenderer!.isInteraction = true;
        if (isLineTypeSeries(seriesType) ||
            seriesType.contains('hilo') ||
            seriesType == 'candle' ||
            seriesType.contains('boxandwhisker')) {
          if (seriesRendererDetails.isSelectionEnable = true) {
            selectionDetails.selectionRenderer!.cartesianPointIndex =
                pointIndex;
            selectionDetails.selectionRenderer!.cartesianSeriesIndex =
                seriesIndex;
            select = selectionDetails.selectionRenderer!.isCartesianSelection(
                chart, seriesRender, pointIndex, seriesIndex);
          }
        } else {
          stateProperties.renderDatalabelRegions = <Rect>[];
          final SelectionDetails selectionDetails =
              SelectionHelper.getRenderingDetails(selectionBehaviorRenderer);
          if (seriesType.contains('area') || seriesType == 'fastline') {
            selectionDetails.selectionRenderer!.seriesIndex = seriesIndex;
          } else {
            selectionDetails.selectionRenderer!.seriesIndex = seriesIndex;
            selectionDetails.selectionRenderer!.pointIndex = pointIndex;
          }
          select = selectionDetails.selectionRenderer!.isCartesianSelection(
              chart, seriesRender, pointIndex, seriesIndex);
        }
        if (select) {
          for (final CartesianSeriesRenderer seriesRenderer
              in stateProperties.chartSeries.visibleSeriesRenderers) {
            ValueNotifier<int>(
                SeriesHelper.getSeriesRendererDetails(seriesRenderer)
                    .repaintNotifier
                    .value++);
          }
        }
        selectionType = null;
      }
    } else if (chart is SfCircularChart) {
      if (validIndex(pointIndex!, seriesIndex!, chart)) {
        stateProperties.chartSeries.seriesPointSelection(
            null, chart.selectionGesture, pointIndex, seriesIndex);
      }
    } else if (chart is SfFunnelChart) {
      if (pointIndex! < chart.series.dataSource.length) {
        stateProperties.chartSeries
            .seriesPointSelection(pointIndex, chart.selectionGesture);
      }
    } else {
      if (pointIndex! < chart.series.dataSource.length) {
        seriesRendererDetails.stateProperties.chartSeries
            .seriesPointSelection(pointIndex, chart.selectionGesture);
      }
    }
  }

  /// Selection for selected dataPoint index.
  void selectedDataPointIndex(
      CartesianSeriesRenderer seriesRenderer, List<int> selectedData) {
    for (int data = 0; data < selectedData.length; data++) {
      final int selectedItem = selectedData[data];
      if (chart.onSelectionChanged != null) {}
      final SeriesRendererDetails seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(seriesRenderer);
      for (int j = 0; j < seriesRendererDetails.segments.length; j++) {
        currentSegmentProperties = SegmentHelper.getSegmentProperties(
            seriesRendererDetails.segments[j]);
        currentSegmentProperties!.segment.currentSegmentIndex == selectedItem
            ? selectedSegments.add(seriesRendererDetails.segments[j])
            : unselectedSegments!.add(seriesRendererDetails.segments[j]);
      }
    }
    selectedSegmentsColors(selectedSegments);
    unselectedSegmentsColors(unselectedSegments!);
  }

  /// Paint method for default fill color settings.
  Paint getDefaultFillColor(List<CartesianChartPoint<dynamic>>? points,
      int? point, ChartSegment segment) {
    final String seriesType = seriesRendererDetails.seriesType;
    final Paint selectedFillPaint = Paint();
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    if (seriesRendererDetails.series is CartesianSeries) {
      seriesRendererDetails.seriesType == 'line' ||
              seriesType == 'spline' ||
              seriesType == 'stepline' ||
              seriesType == 'fastline' ||
              seriesType == 'stackedline' ||
              seriesType == 'stackedline100' ||
              seriesType.contains('hilo')
          ? selectedFillPaint.color =
              segmentProperties.defaultStrokeColor!.color
          : selectedFillPaint.color = segmentProperties.defaultFillColor!.color;
      if (segmentProperties.defaultFillColor?.shader != null) {
        selectedFillPaint.shader = segmentProperties.defaultFillColor!.shader;
      }
    }

    if (seriesRendererDetails.seriesType == 'candle') {
      if (segment is CandleSegment && segmentProperties.isSolid == true) {
        selectedFillPaint.style = PaintingStyle.fill;
        selectedFillPaint.strokeWidth =
            seriesRendererDetails.series.borderWidth;
      } else {
        selectedFillPaint.style = PaintingStyle.stroke;
        selectedFillPaint.strokeWidth =
            seriesRendererDetails.series.borderWidth;
      }
    } else {
      selectedFillPaint.style = PaintingStyle.fill;
    }
    return selectedFillPaint;
  }

  /// Paint method for default stroke color settings.
  Paint getDefaultStrokeColor(List<CartesianChartPoint<dynamic>>? points,
      int? point, ChartSegment segment) {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    final Paint selectedStrokePaint = Paint();
    if (seriesRendererDetails.series is CartesianSeries) {
      selectedStrokePaint.color = segmentProperties.defaultStrokeColor!.color;
      selectedStrokePaint.strokeWidth =
          segmentProperties.defaultStrokeColor!.strokeWidth;
    }
    selectedStrokePaint.style = PaintingStyle.stroke;
    return selectedStrokePaint;
  }

  /// Paint method with selected fill color values.
  Paint getFillColor(bool isSelection, ChartSegment segment) {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    final dynamic selectionBehavior = seriesRendererDetails.selectionBehavior;
    final CartesianSeries<dynamic, dynamic> series =
        seriesRendererDetails.series;
    assert(
        ((selectionBehavior.selectedOpacity != null) == false) ||
            selectionBehavior.selectedOpacity >= 0 == true &&
                selectionBehavior.selectedOpacity <= 1 == true,
        'The selected opacity of selection settings should between 0 and 1.');
    assert(
        ((selectionBehavior.unselectedOpacity != null) == false) ||
            selectionBehavior.unselectedOpacity >= 0 == true &&
                selectionBehavior.unselectedOpacity <= 1 == true,
        'The unselected opacity of selection settings should between 0 and 1.');
    final ChartSelectionCallback? chartEventSelection =
        chart.onSelectionChanged;
    if (isSelection) {
      // ignore: unnecessary_type_check
      if (series is CartesianSeries) {
        fillColor = chartEventSelection != null &&
                selectionArgs != null &&
                selectionArgs!.selectedColor != null
            ? selectionArgs!.selectedColor
            : stateProperties.selectionArgs != null &&
                    stateProperties.selectionArgs!.selectedColor != null
                ? stateProperties.selectionArgs!.selectedColor
                : selectionBehavior.selectedColor ??
                    segmentProperties.defaultFillColor!.color;
      }
      fillOpacity = chartEventSelection != null &&
              selectionArgs != null &&
              selectionArgs!.selectedColor != null
          ? selectionArgs!.selectedColor!.opacity
          : stateProperties.selectionArgs != null &&
                  stateProperties.selectionArgs!.selectedColor != null
              ? stateProperties.selectionArgs!.selectedColor.opacity
              : selectionBehavior.selectedOpacity ?? series.opacity;
    } else {
      // ignore: unnecessary_type_check
      if (series is CartesianSeries) {
        fillColor = chartEventSelection != null &&
                selectionArgs != null &&
                selectionArgs!.unselectedColor != null
            ? selectionArgs!.unselectedColor
            : stateProperties.selectionArgs != null &&
                    stateProperties.selectionArgs!.unselectedColor != null
                ? stateProperties.selectionArgs!.unselectedColor
                : selectionBehavior.unselectedColor ??
                    segmentProperties.defaultFillColor!.color;
      }
      fillOpacity = chartEventSelection != null &&
              selectionArgs != null &&
              selectionArgs!.unselectedColor != null
          ? selectionArgs!.unselectedColor!.opacity
          : stateProperties.selectionArgs != null &&
                  stateProperties.selectionArgs!.unselectedColor != null
              ? stateProperties.selectionArgs!.unselectedColor.opacity
              : selectionBehavior.unselectedOpacity ?? series.opacity;
    }
    final Paint selectedFillPaint = Paint();
    selectedFillPaint.color = fillColor.withOpacity(fillOpacity);
    if (seriesRendererDetails.seriesType == 'candle') {
      if (segment is CandleSegment && segmentProperties.isSolid == true) {
        selectedFillPaint.style = PaintingStyle.fill;
        selectedFillPaint.strokeWidth = series.borderWidth;
      } else {
        selectedFillPaint.style = PaintingStyle.stroke;
        selectedFillPaint.strokeWidth = series.borderWidth;
      }
    } else {
      selectedFillPaint.style = PaintingStyle.fill;
    }
    return selectedFillPaint;
  }

  /// Paint method with selected stroke color values.
  Paint getStrokeColor(bool isSelection, ChartSegment segment,
      [CartesianChartPoint<dynamic>? point]) {
    final CartesianSeries<dynamic, dynamic> series =
        seriesRendererDetails.series;
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    final String seriesType = seriesRendererDetails.seriesType;
    final dynamic selectionBehavior = seriesRendererDetails.selectionBehavior;
    final ChartSelectionCallback? chartEventSelection =
        chart.onSelectionChanged;
    if (isSelection) {
      // ignore: unnecessary_type_check
      if (series is CartesianSeries) {
        seriesType == 'line' ||
                seriesType == 'spline' ||
                seriesType == 'stepline' ||
                seriesType == 'fastline' ||
                seriesType == 'stackedline' ||
                seriesType == 'stackedline100' ||
                seriesType.contains('hilo') ||
                seriesType == 'candle' ||
                seriesType == 'boxandwhisker'
            ? strokeColor = chartEventSelection != null &&
                    selectionArgs != null &&
                    selectionArgs!.selectedColor != null
                ? selectionArgs!.selectedColor
                : stateProperties.selectionArgs != null &&
                        stateProperties.selectionArgs!.selectedColor != null
                    ? stateProperties.selectionArgs!.selectedColor
                    : selectionBehavior.selectedColor ??
                        segmentProperties.defaultFillColor!.color
            : strokeColor = chartEventSelection != null &&
                    selectionArgs != null &&
                    selectionArgs!.selectedBorderColor != null
                ? selectionArgs!.selectedBorderColor
                : stateProperties.selectionArgs != null &&
                        stateProperties.selectionArgs!.selectedBorderColor !=
                            null
                    ? stateProperties.selectionArgs!.selectedBorderColor
                    : selectionBehavior.selectedBorderColor ??
                        series.borderColor;
      }

      strokeOpacity = chartEventSelection != null &&
              selectionArgs != null &&
              selectionArgs!.selectedBorderColor != null
          ? selectionArgs!.selectedBorderColor!.opacity
          : stateProperties.selectionArgs != null &&
                  stateProperties.selectionArgs!.selectedBorderColor != null
              ? stateProperties.selectionArgs!.selectedBorderColor.opacity
              : selectionBehavior.selectedOpacity ?? series.opacity;

      strokeWidth = chartEventSelection != null &&
              selectionArgs != null &&
              selectionArgs!.selectedBorderWidth != null
          ? selectionArgs!.selectedBorderWidth
          : stateProperties.selectionArgs != null &&
                  stateProperties.selectionArgs!.selectedBorderWidth != null
              ? stateProperties.selectionArgs!.selectedBorderWidth
              : selectionBehavior.selectedBorderWidth ?? series.borderWidth;
    } else {
      // ignore: unnecessary_type_check
      if (series is CartesianSeries) {
        segment is LineSegment ||
                segment is SplineSegment ||
                segment is StepLineSegment ||
                segment is FastLineSegment ||
                segment is StackedLineSegment ||
                segment is HiloSegment ||
                segment is HiloOpenCloseSegment ||
                segment is CandleSegment ||
                segment is BoxAndWhiskerSegment
            ? strokeColor = chartEventSelection != null &&
                    selectionArgs != null &&
                    selectionArgs!.unselectedColor != null
                ? selectionArgs!.unselectedColor
                : stateProperties.selectionArgs != null &&
                        stateProperties.selectionArgs!.unselectedColor != null
                    ? stateProperties.selectionArgs!.unselectedColor
                    : selectionBehavior.unselectedColor ??
                        segmentProperties.defaultFillColor!.color
            : strokeColor = chartEventSelection != null &&
                    selectionArgs != null &&
                    selectionArgs!.unselectedBorderColor != null
                ? selectionArgs!.unselectedBorderColor
                : stateProperties.selectionArgs != null &&
                        stateProperties.selectionArgs!.unselectedBorderColor !=
                            null
                    ? stateProperties.selectionArgs!.unselectedBorderColor
                    : selectionBehavior.unselectedBorderColor ??
                        series.borderColor;
      }
      strokeOpacity = chartEventSelection != null &&
              selectionArgs != null &&
              selectionArgs!.unselectedColor != null
          ? selectionArgs!.unselectedColor!.opacity
          : stateProperties.selectionArgs != null &&
                  stateProperties.selectionArgs!.unselectedColor != null
              ? stateProperties.selectionArgs!.unselectedColor.opacity
              : selectionBehavior.unselectedOpacity ?? series.opacity;
      strokeWidth = chartEventSelection != null &&
              selectionArgs != null &&
              selectionArgs!.unselectedBorderWidth != null
          ? selectionArgs!.unselectedBorderWidth
          : stateProperties.selectionArgs != null &&
                  stateProperties.selectionArgs!.unselectedBorderWidth != null
              ? stateProperties.selectionArgs!.unselectedBorderWidth
              : selectionBehavior.unselectedBorderWidth ?? series.borderWidth;
    }
    final Paint selectedStrokePaint = Paint();
    selectedStrokePaint.color = strokeColor;
    selectedStrokePaint.strokeWidth = strokeWidth;
    selectedStrokePaint.color.withOpacity(series.opacity);
    selectedStrokePaint.style = PaintingStyle.stroke;
    return selectedStrokePaint;
  }

  /// Give selected color for selected segments.
  void selectedSegmentsColors(List<ChartSegment> selectedSegments) {
    for (int i = 0; i < selectedSegments.length; i++) {
      final SegmentProperties selectedSegmentProperties =
          SegmentHelper.getSegmentProperties(selectedSegments[i]);
      seriesRendererDetails = SeriesHelper.getSeriesRendererDetails(
          stateProperties.chartSeries
              .visibleSeriesRenderers[selectedSegmentProperties.seriesIndex]);
      if (seriesRendererDetails.seriesType.contains('area') == false &&
          seriesRendererDetails.seriesType != 'fastline') {
        final SegmentProperties currentSegmentProperties =
            SegmentHelper.getSegmentProperties(seriesRendererDetails
                .segments[selectedSegments[i].currentSegmentIndex]);
        final Paint fillPaint =
            getFillColor(true, currentSegmentProperties.segment);
        currentSegmentProperties.segment.fillPaint =
            seriesRendererDetails.selectionBehaviorRenderer.getSelectedItemFill(
                fillPaint,
                selectedSegmentProperties.seriesIndex,
                selectedSegments[i].currentSegmentIndex,
                selectedSegments);
        final Paint strokePaint =
            getStrokeColor(true, currentSegmentProperties.segment);
        currentSegmentProperties.segment.strokePaint = seriesRendererDetails
            .selectionBehaviorRenderer
            .getSelectedItemBorder(
                strokePaint,
                selectedSegmentProperties.seriesIndex,
                selectedSegments[i].currentSegmentIndex,
                selectedSegments);
      } else {
        final SegmentProperties currentSegmentProperties =
            SegmentHelper.getSegmentProperties(
                seriesRendererDetails.segments[0]);
        final Paint fillPaint =
            getFillColor(true, currentSegmentProperties.segment);
        currentSegmentProperties.segment.fillPaint =
            seriesRendererDetails.selectionBehaviorRenderer.getSelectedItemFill(
                fillPaint,
                selectedSegmentProperties.seriesIndex,
                selectedSegments[i].currentSegmentIndex,
                selectedSegments);
        final Paint strokePaint =
            getStrokeColor(true, currentSegmentProperties.segment);
        currentSegmentProperties.segment.strokePaint = seriesRendererDetails
            .selectionBehaviorRenderer
            .getSelectedItemBorder(
                strokePaint,
                selectedSegmentProperties.seriesIndex,
                selectedSegments[i].currentSegmentIndex,
                selectedSegments);
      }
    }
  }

  /// Give unselected color for unselected segments.
  void unselectedSegmentsColors(List<ChartSegment> unselectedSegments) {
    for (int i = 0; i < unselectedSegments.length; i++) {
      if (unselectedSegments[i] is! ErrorBarSegment) {
        final SegmentProperties unselectedSegmentProperties =
            SegmentHelper.getSegmentProperties(unselectedSegments[i]);
        seriesRendererDetails = SeriesHelper.getSeriesRendererDetails(
            stateProperties.chartSeries.visibleSeriesRenderers[
                unselectedSegmentProperties.seriesIndex]);
        if (seriesRendererDetails.seriesType.contains('area') == false &&
            seriesRendererDetails.seriesType != 'fastline') {
          final SegmentProperties currentSegmentProperties =
              SegmentHelper.getSegmentProperties(seriesRendererDetails
                  .segments[unselectedSegments[i].currentSegmentIndex]);
          final Paint fillPaint =
              getFillColor(false, currentSegmentProperties.segment);
          currentSegmentProperties.segment.fillPaint = seriesRendererDetails
              .selectionBehaviorRenderer
              .getUnselectedItemFill(
                  fillPaint,
                  unselectedSegmentProperties.seriesIndex,
                  unselectedSegments[i].currentSegmentIndex,
                  unselectedSegments);
          final Paint strokePaint =
              getStrokeColor(false, currentSegmentProperties.segment);
          currentSegmentProperties.segment.strokePaint = seriesRendererDetails
              .selectionBehaviorRenderer
              .getUnselectedItemBorder(
                  strokePaint,
                  unselectedSegmentProperties.seriesIndex,
                  unselectedSegments[i].currentSegmentIndex,
                  unselectedSegments);
        } else {
          final SegmentProperties currentSegmentProperties =
              SegmentHelper.getSegmentProperties(
                  seriesRendererDetails.segments[0]);
          final Paint fillPaint =
              getFillColor(false, currentSegmentProperties.segment);
          currentSegmentProperties.segment.fillPaint = seriesRendererDetails
              .selectionBehaviorRenderer
              .getUnselectedItemFill(
                  fillPaint,
                  unselectedSegmentProperties.seriesIndex,
                  unselectedSegments[i].currentSegmentIndex,
                  unselectedSegments);
          final Paint strokePaint =
              getStrokeColor(false, currentSegmentProperties.segment);
          currentSegmentProperties.segment.strokePaint = seriesRendererDetails
              .selectionBehaviorRenderer
              .getUnselectedItemBorder(
                  strokePaint,
                  unselectedSegmentProperties.seriesIndex,
                  unselectedSegments[i].currentSegmentIndex,
                  unselectedSegments);
        }
      }
    }
  }

  /// Change color and removing unselected segments from list.
  void changeColorAndPopUnselectedSegments(
      List<ChartSegment> unselectedSegments) {
    int k = unselectedSegments.length - 1;
    while (unselectedSegments.isNotEmpty) {
      seriesRendererDetails = SeriesHelper.getSeriesRendererDetails(
          stateProperties.chartSeries.visibleSeriesRenderers[
              SegmentHelper.getSegmentProperties(unselectedSegments[k])
                  .seriesIndex]);
      if (seriesRendererDetails.seriesType.contains('area') == false &&
          seriesRendererDetails.seriesType != 'fastline') {
        if (unselectedSegments[k].currentSegmentIndex! <
                seriesRendererDetails.segments.length &&
            unselectedSegments[k] is! ErrorBarSegment) {
          final SegmentProperties currentSegmentProperties =
              SegmentHelper.getSegmentProperties(seriesRendererDetails
                  .segments[unselectedSegments[k].currentSegmentIndex]);
          final Paint fillPaint =
              getDefaultFillColor(null, null, currentSegmentProperties.segment);
          currentSegmentProperties.segment.fillPaint = fillPaint;
          final Paint strokePaint = getDefaultStrokeColor(
              null, null, currentSegmentProperties.segment);
          currentSegmentProperties.segment.strokePaint = strokePaint;
        }
        unselectedSegments.remove(unselectedSegments[k]);
        k--;
      } else {
        final SegmentProperties currentSegmentProperties =
            SegmentHelper.getSegmentProperties(
                seriesRendererDetails.segments[0]);
        final Paint fillPaint =
            getDefaultFillColor(null, null, currentSegmentProperties.segment);
        currentSegmentProperties.segment.fillPaint = fillPaint;
        final Paint strokePaint =
            getDefaultStrokeColor(null, null, currentSegmentProperties.segment);
        currentSegmentProperties.segment.strokePaint = strokePaint;
        unselectedSegments.remove(unselectedSegments[0]);
        k--;
      }
    }
  }

  /// Change color and remove selected segments from list.
  bool changeColorAndPopSelectedSegments(
      List<ChartSegment> selectedSegments, bool isSamePointSelect) {
    int j = selectedSegments.length - 1;
    while (selectedSegments.isNotEmpty) {
      final SegmentProperties selectedSegmentProperties =
          SegmentHelper.getSegmentProperties(selectedSegments[j]);
      seriesRendererDetails = SeriesHelper.getSeriesRendererDetails(
          stateProperties.chartSeries
              .visibleSeriesRenderers[selectedSegmentProperties.seriesIndex]);
      if (seriesRendererDetails.seriesType.contains('area') == false &&
          seriesRendererDetails.seriesType != 'fastline') {
        if (selectedSegments[j].currentSegmentIndex! <
            seriesRendererDetails.segments.length) {
          final SegmentProperties currentSegmentProperties =
              SegmentHelper.getSegmentProperties(seriesRendererDetails
                  .segments[selectedSegments[j].currentSegmentIndex]);
          final Paint fillPaint =
              getDefaultFillColor(null, null, currentSegmentProperties.segment);
          currentSegmentProperties.segment.fillPaint = fillPaint;
          final Paint strokePaint = getDefaultStrokeColor(
              null, null, currentSegmentProperties.segment);
          currentSegmentProperties.segment.strokePaint = strokePaint;
          if (seriesRendererDetails.seriesType == 'line' ||
              seriesRendererDetails.seriesType == 'spline' ||
              seriesRendererDetails.seriesType == 'stepline' ||
              seriesRendererDetails.seriesType == 'stackedline' ||
              seriesRendererDetails.seriesType == 'stackedline100' ||
              seriesRendererDetails.seriesType.contains('hilo') == true ||
              seriesRendererDetails.seriesType == 'candle' ||
              seriesRendererDetails.seriesType.contains('boxandwhisker') ==
                  true) {
            if (selectedSegmentProperties.currentPoint!.overallDataPointIndex ==
                    cartesianPointIndex &&
                selectedSegmentProperties.seriesIndex == cartesianSeriesIndex) {
              isSamePointSelect = true;
            }
          } else {
            if ((currentSegmentProperties.currentPoint!.overallDataPointIndex ==
                        pointIndex ||
                    selectedSegmentProperties
                            .currentPoint!.overallDataPointIndex ==
                        pointIndex) &&
                currentSegmentProperties.oldSegmentIndex ==
                    selectedSegmentProperties.oldSegmentIndex &&
                selectedSegmentProperties.seriesIndex == seriesIndex) {
              isSamePointSelect = true;
            }
          }
        }
        selectedSegments.remove(selectedSegments[j]);
        j--;
      } else {
        final SegmentProperties currentSegmentProperties =
            SegmentHelper.getSegmentProperties(
                seriesRendererDetails.segments[0]);
        final Paint fillPaint =
            getDefaultFillColor(null, null, currentSegmentProperties.segment);
        currentSegmentProperties.segment.fillPaint = fillPaint;
        final Paint strokePaint =
            getDefaultStrokeColor(null, null, currentSegmentProperties.segment);
        currentSegmentProperties.segment.strokePaint = strokePaint;
        if (SegmentHelper.getSegmentProperties(selectedSegments[0])
                .seriesIndex ==
            seriesIndex) {
          isSamePointSelect = true;
        }
        selectedSegments.remove(selectedSegments[0]);
        j--;
      }
    }
    return isSamePointSelect;
  }

  bool _isSamePointSelected(List<ChartSegment> selectedSegments) {
    bool isSamePointSelected = false;
    for (int j = 0;
        j < selectedSegments.length && selectedSegments.isNotEmpty;
        j++) {
      final SegmentProperties selectedSegmentProperties =
          SegmentHelper.getSegmentProperties(selectedSegments[j]);
      seriesRendererDetails = SeriesHelper.getSeriesRendererDetails(
          stateProperties.chartSeries
              .visibleSeriesRenderers[selectedSegmentProperties.seriesIndex]);
      if (seriesRendererDetails.seriesType.contains('area') == false &&
          seriesRendererDetails.seriesType != 'fastline') {
        if (selectedSegments[j].currentSegmentIndex! <
            seriesRendererDetails.segments.length) {
          final SegmentProperties currentSegmentProperties =
              SegmentHelper.getSegmentProperties(seriesRendererDetails
                  .segments[selectedSegments[j].currentSegmentIndex]);
          if (((seriesRendererDetails.seriesType.indexOf('line') >= 0) ==
                      true ||
                  seriesRendererDetails.seriesType.contains('hilo') == true ||
                  seriesRendererDetails.seriesType == 'candle' ||
                  seriesRendererDetails.seriesType.contains('boxandwhisker') ==
                      true) &&
              selectedSegmentProperties.currentPoint!.overallDataPointIndex ==
                  cartesianPointIndex &&
              selectedSegmentProperties.seriesIndex == cartesianSeriesIndex) {
            isSamePointSelected = true;
          } else {
            if ((currentSegmentProperties.currentPoint!.overallDataPointIndex ==
                        pointIndex ||
                    selectedSegmentProperties
                            .currentPoint!.overallDataPointIndex ==
                        pointIndex) &&
                currentSegmentProperties.oldSegmentIndex ==
                    selectedSegmentProperties.oldSegmentIndex &&
                selectedSegmentProperties.seriesIndex == seriesIndex) {
              isSamePointSelected = true;
            }
          }
        }
      } else {
        final SegmentProperties currentSegmentProperties =
            SegmentHelper.getSegmentProperties(
                seriesRendererDetails.segments[0]);
        final Paint fillPaint =
            getDefaultFillColor(null, null, currentSegmentProperties.segment);
        currentSegmentProperties.segment.fillPaint = fillPaint;
        final Paint strokePaint =
            getDefaultStrokeColor(null, null, currentSegmentProperties.segment);
        currentSegmentProperties.segment.strokePaint = strokePaint;
        if (SegmentHelper.getSegmentProperties(selectedSegments[0])
                .seriesIndex ==
            seriesIndex) {
          isSamePointSelected = true;
        }
      }
    }
    return isSamePointSelected;
  }

  /// To get the selected segment on tap.
  ChartSegment? getTappedSegment() {
    for (int i = 0;
        i < stateProperties.chartSeries.visibleSeriesRenderers.length;
        i++) {
      final SeriesRendererDetails seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(
              stateProperties.chartSeries.visibleSeriesRenderers[i]);
      for (int k = 0; k < seriesRendererDetails.segments.length; k++) {
        if (seriesRendererDetails.seriesType.contains('area') == false &&
            seriesRendererDetails.seriesType != 'fastline') {
          currentSegmentProperties = SegmentHelper.getSegmentProperties(
              seriesRendererDetails.segments[k]);
          if (seriesRendererDetails.seriesType == 'line' ||
              seriesRendererDetails.seriesType == 'spline' ||
              seriesRendererDetails.seriesType == 'stepline' ||
              seriesRendererDetails.seriesType == 'stackedline' ||
              seriesRendererDetails.seriesType == 'stackedline100' ||
              seriesRendererDetails.seriesType.contains('hilo') == true ||
              seriesRendererDetails.seriesType == 'candle' ||
              seriesRendererDetails.seriesType.contains('boxandwhisker') ==
                  true) {
            if (currentSegmentProperties!.segment.currentSegmentIndex ==
                    cartesianPointIndex &&
                currentSegmentProperties!.seriesIndex == cartesianSeriesIndex) {
              selectedSegmentProperties = SegmentHelper.getSegmentProperties(
                  seriesRendererDetails.segments[k]);
            }
          } else {
            if (currentSegmentProperties!.currentPoint!.overallDataPointIndex ==
                    pointIndex &&
                currentSegmentProperties!.seriesIndex == seriesIndex) {
              selectedSegmentProperties = SegmentHelper.getSegmentProperties(
                  seriesRendererDetails.segments[k]);
            }
          }
        } else {
          currentSegmentProperties = SegmentHelper.getSegmentProperties(
              seriesRendererDetails.segments[0]);
          if (currentSegmentProperties!.seriesIndex ==
              SelectionHelper.getRenderingDetails(
                      seriesRendererDetails.selectionBehaviorRenderer!)
                  .selectionRenderer!
                  .seriesIndex) {
            selectedSegmentProperties = currentSegmentProperties;
            break;
          }
        }
      }
    }
    return selectedSegmentProperties?.segment;
  }

  /// To check position of the selection segment.
  bool checkPosition() {
    outerLoop:
    for (int i = 0;
        i < stateProperties.chartSeries.visibleSeriesRenderers.length;
        i++) {
      final SeriesRendererDetails seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(
              stateProperties.chartSeries.visibleSeriesRenderers[i]);
      for (int k = 0; k < seriesRendererDetails.segments.length; k++) {
        currentSegmentProperties = SegmentHelper.getSegmentProperties(
            seriesRendererDetails.segments[k]);
        if ((currentSegmentProperties!.currentPoint!.overallDataPointIndex ==
                pointIndex) &&
            currentSegmentProperties!.seriesIndex == seriesIndex) {
          isSelected = true;
          break outerLoop;
        } else {
          isSelected = false;
        }
      }
    }
    return isSelected;
  }

  /// To ensure selection for cartesian chart type.
  bool isCartesianSelection(SfCartesianChart chartAssign,
      CartesianSeriesRenderer seriesAssign, int? pointIndex, int? seriesIndex) {
    chart = chartAssign;
    seriesRendererDetails = SeriesHelper.getSeriesRendererDetails(seriesAssign);

    if (chart.onSelectionChanged != null &&
        selected &&
        (!(seriesRendererDetails.selectionBehavior.toggleSelection == false &&
            _isSamePointSelected(selectedSegments)))) {
      chart.onSelectionChanged(getSelectionEventArgs(
          seriesRendererDetails.series,
          seriesIndex!,
          viewportIndex!,
          seriesRendererDetails));
      selected = false;
    }

    /// Maintained the event arguments on zooming, device orientation change.
    if (selectionArgs != null) {
      stateProperties.selectionArgs = selectionArgs;
    }

    /// For point mode.
    if ((selectionType ?? chart.selectionType) == SelectionType.point) {
      if (!(seriesRendererDetails.selectionBehavior.toggleSelection == false &&
          _isSamePointSelected(selectedSegments))) {
        bool isSamePointSelect = false;

        /// UnSelecting the last selected segment.
        if (selectedSegments.length == 1) {
          changeColorAndPopUnselectedSegments(unselectedSegments!);
        }

        /// Executes when multiSelection is enabled.
        bool multiSelect = false;
        if (chart.enableMultiSelection == true) {
          if (selectedSegments.isNotEmpty) {
            for (int i =
                    stateProperties.chartSeries.visibleSeriesRenderers.length -
                        1;
                i >= 0;
                i--) {
              final SeriesRendererDetails seriesRendererDetails =
                  SeriesHelper.getSeriesRendererDetails(
                      stateProperties.chartSeries.visibleSeriesRenderers[i]);

              /// To identify the tapped segment.
              for (int k = 0; k < seriesRendererDetails.segments.length; k++) {
                currentSegmentProperties = SegmentHelper.getSegmentProperties(
                    seriesRendererDetails.segments[k]);
                if ((currentSegmentProperties!
                            .currentPoint!.overallDataPointIndex ==
                        pointIndex) &&
                    currentSegmentProperties!.seriesIndex == seriesIndex) {
                  selectedSegmentProperties =
                      SegmentHelper.getSegmentProperties(
                          seriesRendererDetails.segments[k]);
                  break;
                }
              }
            }

            /// To identify that tapped segment in any one of the selected segment.
            if (selectedSegmentProperties != null) {
              for (int k = 0; k < selectedSegments.length; k++) {
                if ((selectedSegmentProperties!.segment.currentSegmentIndex ==
                            selectedSegments[k].currentSegmentIndex ||
                        selectedSegmentProperties!
                                .currentPoint!.overallDataPointIndex ==
                            SegmentHelper.getSegmentProperties(
                                    selectedSegments[k])
                                .currentPoint!
                                .overallDataPointIndex) &&
                    selectedSegmentProperties!.seriesIndex ==
                        SegmentHelper.getSegmentProperties(selectedSegments[k])
                            .seriesIndex) {
                  multiSelect = true;
                  break;
                }
              }
            }

            /// Executes when tapped again in one of the selected segments.
            if (multiSelect) {
              for (int j = selectedSegments.length - 1; j >= 0; j--) {
                seriesRendererDetails = SeriesHelper.getSeriesRendererDetails(
                    stateProperties.chartSeries.visibleSeriesRenderers[
                        selectedSegmentProperties!.seriesIndex]);
                final SegmentProperties currentSegmentProperties =
                    SegmentHelper.getSegmentProperties(seriesRendererDetails
                        .segments[selectedSegments[j].currentSegmentIndex]);

                /// Applying default settings when last selected segment becomes unselected.
                if (((selectedSegmentProperties!.segment.currentSegmentIndex ==
                                selectedSegments[j].currentSegmentIndex ||
                            selectedSegmentProperties!
                                    .currentPoint!.overallDataPointIndex ==
                                SegmentHelper.getSegmentProperties(
                                        selectedSegments[j])
                                    .currentPoint!
                                    .overallDataPointIndex) &&
                        selectedSegmentProperties!.seriesIndex ==
                            SegmentHelper.getSegmentProperties(
                                    selectedSegments[j])
                                .seriesIndex) &&
                    (selectedSegments.length == 1)) {
                  final Paint fillPaint = getDefaultFillColor(
                      null, null, currentSegmentProperties.segment);
                  final Paint strokePaint = getDefaultStrokeColor(
                      null, null, currentSegmentProperties.segment);
                  currentSegmentProperties.segment.fillPaint = fillPaint;
                  currentSegmentProperties.segment.strokePaint = strokePaint;

                  if ((currentSegmentProperties
                                  .currentPoint!.overallDataPointIndex ==
                              pointIndex ||
                          SegmentHelper.getSegmentProperties(
                                      selectedSegments[j])
                                  .currentPoint!
                                  .overallDataPointIndex ==
                              pointIndex) &&
                      selectedSegmentProperties!.seriesIndex == seriesIndex) {
                    isSamePointSelect = true;
                  }
                  selectedSegments.remove(selectedSegments[j]);
                }

                /// Applying unselected color for unselected segments in multiSelect option.
                else if ((selectedSegmentProperties!
                            .currentPoint!.overallDataPointIndex ==
                        SegmentHelper.getSegmentProperties(selectedSegments[j])
                            .currentPoint!
                            .overallDataPointIndex) &&
                    selectedSegmentProperties!.seriesIndex ==
                        selectedSegmentProperties!.seriesIndex) {
                  final Paint fillPaint =
                      getFillColor(false, currentSegmentProperties.segment);
                  currentSegmentProperties.segment.fillPaint = fillPaint;
                  final Paint strokePaint =
                      getStrokeColor(false, currentSegmentProperties.segment);
                  currentSegmentProperties.segment.strokePaint = strokePaint;

                  if ((currentSegmentProperties
                                  .currentPoint!.overallDataPointIndex ==
                              pointIndex ||
                          SegmentHelper.getSegmentProperties(
                                      selectedSegments[j])
                                  .currentPoint!
                                  .overallDataPointIndex ==
                              pointIndex) &&
                      selectedSegmentProperties!.seriesIndex == seriesIndex) {
                    isSamePointSelect = true;
                  }
                  unselectedSegments!.add(selectedSegments[j]);
                  selectedSegments.remove(selectedSegments[j]);
                }
              }
            }
          }
        } else {
          unselectedSegments?.clear();
          isSamePointSelect = changeColorAndPopSelectedSegments(
              selectedSegments, isSamePointSelect);
        }

        /// To check that the selection setting is enable or not.
        if (seriesRendererDetails.isSelectionEnable == true) {
          if (!isSamePointSelect) {
            seriesRendererDetails.seriesType == 'column' ||
                    seriesRendererDetails.seriesType == 'bar' ||
                    seriesRendererDetails.seriesType == 'scatter' ||
                    seriesRendererDetails.seriesType == 'bubble' ||
                    seriesRendererDetails.seriesType
                            .contains('stackedcolumn') ==
                        true ||
                    seriesRendererDetails.seriesType.contains('stackedbar') ==
                        true ||
                    seriesRendererDetails.seriesType == 'rangecolumn' ||
                    seriesRendererDetails.seriesType == 'waterfall'
                ? isSelected = checkPosition()
                : isSelected = true;
            unselectedSegments?.clear();
            for (int i =
                    stateProperties.chartSeries.visibleSeriesRenderers.length -
                        1;
                i >= 0;
                i--) {
              final SeriesRendererDetails seriesRendererDetails =
                  SeriesHelper.getSeriesRendererDetails(
                      stateProperties.chartSeries.visibleSeriesRenderers[i]);
              if (isSelected) {
                for (int j = 0;
                    j < seriesRendererDetails.segments.length;
                    j++) {
                  currentSegmentProperties = SegmentHelper.getSegmentProperties(
                      seriesRendererDetails.segments[j]);
                  if (currentSegmentProperties!.segment.currentSegmentIndex ==
                          null ||
                      pointIndex == null) {
                    break;
                  }
                  (seriesRendererDetails.seriesType.contains('area') == true
                              ? currentSegmentProperties!
                                      .segment.currentSegmentIndex ==
                                  pointIndex
                              : currentSegmentProperties!
                                      .currentPoint!.overallDataPointIndex ==
                                  pointIndex) &&
                          currentSegmentProperties!.seriesIndex == seriesIndex
                      ? selectedSegments.add(seriesRendererDetails.segments[j])
                      : unselectedSegments!
                          .add(seriesRendererDetails.segments[j]);
                }

                /// Giving color to unselected segments.
                unselectedSegmentsColors(unselectedSegments!);

                /// Giving Color to selected segments.
                selectedSegmentsColors(selectedSegments);
              }
            }
          } else {
            isSelected = true;
          }
        }
      }
    }

    /// For series mode.
    else if ((selectionType ?? chart.selectionType) == SelectionType.series) {
      if (!(seriesRendererDetails.selectionBehavior.toggleSelection == false &&
          _isSamePointSelected(selectedSegments))) {
        bool isSamePointSelect = false;

        for (int i = 0;
            i < stateProperties.chartSeries.visibleSeriesRenderers.length;
            i++) {
          final SeriesRendererDetails seriesRendererDetails =
              SeriesHelper.getSeriesRendererDetails(
                  stateProperties.chartSeries.visibleSeriesRenderers[i]);
          for (int k = 0; k < seriesRendererDetails.segments.length; k++) {
            currentSegmentProperties = SegmentHelper.getSegmentProperties(
                seriesRendererDetails.segments[k]);
            final ChartSegment compareSegment =
                seriesRendererDetails.segments[k];
            if (currentSegmentProperties!.segment.currentSegmentIndex !=
                    compareSegment.currentSegmentIndex &&
                currentSegmentProperties!.seriesIndex !=
                    SegmentHelper.getSegmentProperties(compareSegment)
                        .seriesIndex) {
              isSelected = false;
            }
          }
        }

        /// Executes only when final selected segment became unselected.
        if (selectedSegments.length == seriesRendererDetails.segments.length) {
          changeColorAndPopUnselectedSegments(unselectedSegments!);
        }

        /// Executes when multiSelect option is enabled.
        bool multiSelect = false;
        if (chart.enableMultiSelection == true) {
          if (selectedSegments.isNotEmpty) {
            selectedSegmentProperties =
                SegmentHelper.getSegmentProperties(getTappedSegment()!);

            /// To identify that tapped again in any one of the selected segments.
            if (selectedSegmentProperties != null) {
              for (int k = 0; k < selectedSegments.length; k++) {
                if (seriesIndex ==
                    SegmentHelper.getSegmentProperties(selectedSegments[k])
                        .seriesIndex) {
                  multiSelect = true;
                  break;
                }
              }
            }

            /// Executes when tapped again in one of the selected segments.
            if (multiSelect) {
              SegmentProperties currentSegmentProperties;
              for (int j = selectedSegments.length - 1; j >= 0; j--) {
                seriesRendererDetails = SeriesHelper.getSeriesRendererDetails(
                    stateProperties.chartSeries.visibleSeriesRenderers[
                        selectedSegmentProperties!.seriesIndex]);

                currentSegmentProperties = (seriesRendererDetails.seriesType
                                .contains('area') ==
                            false &&
                        seriesRendererDetails.seriesType != 'fastline')
                    ? SegmentHelper.getSegmentProperties(seriesRendererDetails
                        .segments[selectedSegments[j].currentSegmentIndex])
                    : SegmentHelper.getSegmentProperties(
                        seriesRendererDetails.segments[0]);

                /// Applying series fill when all last selected segment becomes unselected.
                if (seriesRendererDetails.seriesType.contains('area') ==
                        false &&
                    seriesRendererDetails.seriesType != 'fastline') {
                  if ((selectedSegmentProperties!.seriesIndex ==
                          selectedSegmentProperties!.seriesIndex) &&
                      (selectedSegments.length <=
                          seriesRendererDetails.segments.length)) {
                    final Paint fillPaint = getDefaultFillColor(
                        null, null, currentSegmentProperties.segment);
                    final Paint strokePaint = getDefaultStrokeColor(
                        null, null, currentSegmentProperties.segment);
                    currentSegmentProperties.segment.fillPaint = fillPaint;
                    currentSegmentProperties.segment.strokePaint = strokePaint;
                    if (SegmentHelper.getSegmentProperties(selectedSegments[j])
                                .currentPoint!
                                .overallDataPointIndex ==
                            pointIndex &&
                        selectedSegmentProperties!.seriesIndex == seriesIndex) {
                      isSamePointSelect = true;
                    }
                    selectedSegments.remove(selectedSegments[j]);
                  }

                  /// Applying unselected color for unselected segments in multiSelect option.
                  else if (selectedSegmentProperties!.seriesIndex ==
                      selectedSegmentProperties!.seriesIndex) {
                    final Paint fillPaint =
                        getFillColor(false, currentSegmentProperties.segment);
                    final Paint strokePaint =
                        getStrokeColor(false, currentSegmentProperties.segment);
                    currentSegmentProperties.segment.fillPaint = fillPaint;
                    currentSegmentProperties.segment.strokePaint = strokePaint;
                    if (SegmentHelper.getSegmentProperties(selectedSegments[j])
                                .currentPoint!
                                .overallDataPointIndex ==
                            pointIndex &&
                        selectedSegmentProperties!.seriesIndex == seriesIndex) {
                      isSamePointSelect = true;
                    }
                    unselectedSegments!.add(selectedSegments[j]);
                    selectedSegments.remove(selectedSegments[j]);
                  }
                } else {
                  if ((selectedSegmentProperties!.seriesIndex ==
                          selectedSegmentProperties!.seriesIndex) &&
                      (selectedSegments.length <=
                          seriesRendererDetails.segments.length)) {
                    final Paint fillPaint = getDefaultFillColor(
                        null, null, currentSegmentProperties.segment);
                    final Paint strokePaint = getDefaultStrokeColor(
                        null, null, currentSegmentProperties.segment);
                    currentSegmentProperties.segment.fillPaint = fillPaint;
                    currentSegmentProperties.segment.strokePaint = strokePaint;
                    if (selectedSegmentProperties!.seriesIndex == seriesIndex) {
                      isSamePointSelect = true;
                    }
                    selectedSegments.remove(selectedSegments[j]);
                  }

                  /// Applying unselected color for unselected segments in multiSelect option.
                  else if (selectedSegmentProperties!.seriesIndex ==
                      selectedSegmentProperties!.seriesIndex) {
                    final Paint fillPaint =
                        getFillColor(false, currentSegmentProperties.segment);
                    final Paint strokePaint =
                        getStrokeColor(false, currentSegmentProperties.segment);
                    currentSegmentProperties.segment.fillPaint = fillPaint;
                    currentSegmentProperties.segment.strokePaint = strokePaint;
                    if (selectedSegmentProperties!.seriesIndex == seriesIndex) {
                      isSamePointSelect = true;
                    }
                    unselectedSegments!.add(selectedSegments[j]);
                    selectedSegments.remove(selectedSegments[j]);
                  }
                }
              }
            }
          }
        } else {
          /// Executes when multiSelect is not enable.
          unselectedSegments?.clear();
          isSamePointSelect = changeColorAndPopSelectedSegments(
              selectedSegments, isSamePointSelect);
        }

        /// To identify the tapped segment.
        if (seriesRendererDetails.isSelectionEnable == true) {
          if (!isSamePointSelect) {
            seriesRendererDetails.seriesType == 'column' ||
                    seriesRendererDetails.seriesType == 'bar' ||
                    seriesRendererDetails.seriesType == 'scatter' ||
                    seriesRendererDetails.seriesType == 'bubble' ||
                    seriesRendererDetails.seriesType
                            .contains('stackedcolumn') ==
                        true ||
                    seriesRendererDetails.seriesType.contains('stackedbar') ==
                        true ||
                    seriesRendererDetails.seriesType == 'rangecolumn' ||
                    seriesRendererDetails.seriesType == 'waterfall'
                ? isSelected = checkPosition()
                : isSelected = true;
            selectedSegmentProperties =
                SegmentHelper.getSegmentProperties(getTappedSegment()!);
            if (isSelected) {
              /// To push the selected and unselected segment.
              for (int i = 0;
                  i < stateProperties.chartSeries.visibleSeriesRenderers.length;
                  i++) {
                final SeriesRendererDetails seriesRendererDetails =
                    SeriesHelper.getSeriesRendererDetails(
                        stateProperties.chartSeries.visibleSeriesRenderers[i]);
                if (seriesRendererDetails.seriesType.contains('area') ==
                        false &&
                    seriesRendererDetails.seriesType != 'fastline') {
                  if (seriesIndex != null) {
                    for (int k = 0;
                        k < seriesRendererDetails.segments.length;
                        k++) {
                      currentSegmentProperties =
                          SegmentHelper.getSegmentProperties(
                              seriesRendererDetails.segments[k]);
                      currentSegmentProperties!.seriesIndex == seriesIndex
                          ? selectedSegments
                              .add(seriesRendererDetails.segments[k])
                          : unselectedSegments!
                              .add(seriesRendererDetails.segments[k]);
                    }
                  }
                } else {
                  currentSegmentProperties = SegmentHelper.getSegmentProperties(
                      seriesRendererDetails.segments[0]);
                  currentSegmentProperties!.seriesIndex == seriesIndex
                      ? selectedSegments.add(seriesRendererDetails.segments[0])
                      : unselectedSegments!
                          .add(seriesRendererDetails.segments[0]);
                }

                /// Give color to the unselected segment.
                unselectedSegmentsColors(unselectedSegments!);

                /// Give color to the selected segment.
                selectedSegmentsColors(selectedSegments);
              }
            }
          } else {
            isSelected = true;
          }
        }
      }
    }

    /// For cluster mode.
    else if ((selectionType ?? chart.selectionType) == SelectionType.cluster) {
      if (!(seriesRendererDetails.selectionBehavior.toggleSelection == false &&
          _isSamePointSelected(selectedSegments))) {
        bool isSamePointSelect = false;

        /// Executes only when last selected segment became unselected.
        if (selectedSegments.length ==
            stateProperties.chartSeries.visibleSeriesRenderers.length) {
          changeColorAndPopUnselectedSegments(unselectedSegments!);
        }

        /// Executes when multiSelect option is enabled.
        bool multiSelect = false;
        if (chart.enableMultiSelection == true) {
          if (selectedSegments.isNotEmpty) {
            selectedSegmentProperties =
                SegmentHelper.getSegmentProperties(getTappedSegment()!);

            /// To identify that tapped again in any one of the selected segment.
            if (selectedSegmentProperties != null) {
              for (int k = 0; k < selectedSegments.length; k++) {
                if (selectedSegmentProperties!.segment.currentSegmentIndex ==
                    selectedSegments[k].currentSegmentIndex) {
                  multiSelect = true;
                  break;
                }
              }
            }

            /// Executes when tapped again in one of the selected segment.
            if (multiSelect) {
              for (int j = selectedSegments.length - 1; j >= 0; j--) {
                seriesRendererDetails = SeriesHelper.getSeriesRendererDetails(
                    stateProperties.chartSeries.visibleSeriesRenderers[
                        selectedSegmentProperties!.seriesIndex]);
                final SegmentProperties currentSegmentProperties =
                    SegmentHelper.getSegmentProperties(seriesRendererDetails
                        .segments[selectedSegments[j].currentSegmentIndex]);

                /// Applying default settings when last selected segment becomes unselected.
                if ((selectedSegmentProperties!.segment.currentSegmentIndex ==
                        selectedSegments[j].currentSegmentIndex) &&
                    (selectedSegments.length <=
                        stateProperties
                            .chartSeries.visibleSeriesRenderers.length)) {
                  final Paint fillPaint = getDefaultFillColor(
                      null, null, currentSegmentProperties.segment);
                  final Paint strokePaint = getDefaultStrokeColor(
                      null, null, currentSegmentProperties.segment);
                  currentSegmentProperties.segment.fillPaint = fillPaint;
                  currentSegmentProperties.segment.strokePaint = strokePaint;

                  if (selectedSegments[j].currentSegmentIndex == pointIndex &&
                      selectedSegmentProperties!.seriesIndex == seriesIndex) {
                    isSamePointSelect = true;
                  }
                  // if(isSamePointSelect == false && )
                  selectedSegments.remove(selectedSegments[j]);
                }

                /// Applying unselected color for unselected segment in multiSelect option.
                else if (selectedSegmentProperties!
                        .segment.currentSegmentIndex ==
                    selectedSegments[j].currentSegmentIndex) {
                  final Paint fillPaint =
                      getFillColor(false, currentSegmentProperties.segment);
                  final Paint strokePaint =
                      getStrokeColor(false, currentSegmentProperties.segment);
                  currentSegmentProperties.segment.fillPaint = fillPaint;
                  currentSegmentProperties.segment.strokePaint = strokePaint;

                  if (selectedSegments[j].currentSegmentIndex == pointIndex &&
                      selectedSegmentProperties!.seriesIndex == seriesIndex) {
                    isSamePointSelect = true;
                  }

                  unselectedSegments!.add(selectedSegments[j]);
                  selectedSegments.remove(selectedSegments[j]);
                }
              }
            }
          }
        } else {
          unselectedSegments?.clear();

          /// Executes when multiSelect is not enable.
          isSamePointSelect = changeColorAndPopSelectedSegments(
              selectedSegments, isSamePointSelect);
        }

        /// To identify the tapped segment
        if (seriesRendererDetails.isSelectionEnable == true) {
          if (!isSamePointSelect) {
            final bool isSegmentSeries = seriesRendererDetails.seriesType ==
                    'column' ||
                seriesRendererDetails.seriesType == 'bar' ||
                seriesRendererDetails.seriesType == 'scatter' ||
                seriesRendererDetails.seriesType == 'bubble' ||
                seriesRendererDetails.seriesType.contains('stackedcolumn') ==
                    true ||
                seriesRendererDetails.seriesType.contains('stackedbar') ==
                    true ||
                seriesRendererDetails.seriesType == 'rangecolumn' ||
                seriesRendererDetails.seriesType == 'waterfall';
            selectedSegmentProperties =
                SegmentHelper.getSegmentProperties(getTappedSegment()!);
            isSegmentSeries ? isSelected = checkPosition() : isSelected = true;
            if (isSelected) {
              /// To Push the Selected and Unselected segments.
              for (int i = 0;
                  i < stateProperties.chartSeries.visibleSeriesRenderers.length;
                  i++) {
                final SeriesRendererDetails seriesRendererDetails =
                    SeriesHelper.getSeriesRendererDetails(
                        stateProperties.chartSeries.visibleSeriesRenderers[i]);
                if (currentSegmentProperties!.segment.currentSegmentIndex ==
                        null ||
                    pointIndex == null) {
                  break;
                }
                for (int k = 0;
                    k < seriesRendererDetails.segments.length;
                    k++) {
                  currentSegmentProperties = SegmentHelper.getSegmentProperties(
                      seriesRendererDetails.segments[k]);

                  if (isSegmentSeries) {
                    currentSegmentProperties!.currentPoint!.xValue ==
                            selectedSegmentProperties!.currentPoint!.xValue
                        ? selectedSegments
                            .add(seriesRendererDetails.segments[k])
                        : unselectedSegments!
                            .add(seriesRendererDetails.segments[k]);
                  } else {
                    currentSegmentProperties!.segment.currentSegmentIndex ==
                            selectedSegmentProperties!
                                .segment.currentSegmentIndex
                        ? selectedSegments
                            .add(seriesRendererDetails.segments[k])
                        : unselectedSegments!
                            .add(seriesRendererDetails.segments[k]);
                  }
                }
              }

              /// Giving color to unselected segments.
              unselectedSegmentsColors(unselectedSegments!);

              /// Giving color to selected segments.
              selectedSegmentsColors(selectedSegments);
            }
          } else {
            isSelected = true;
          }
        }
      }
    }
    return isSelected;
  }

  /// To get point index and series index.
  void getPointAndSeriesIndex(SfCartesianChart chart, Offset position,
      SeriesRendererDetails seriesRendererDetails) {
    final SelectionBehaviorRenderer? selectionBehaviorRenderer =
        seriesRendererDetails.selectionBehaviorRenderer;
    if (selectionBehaviorRenderer == null) {
      return;
    }
    SegmentProperties currentSegmentProperties;
    SegmentProperties? selectedSegmentProperties;
    for (int k = 0; k < seriesRendererDetails.segments.length; k++) {
      currentSegmentProperties =
          SegmentHelper.getSegmentProperties(seriesRendererDetails.segments[k]);
      if (currentSegmentProperties.segmentRect!.contains(position) == true) {
        selected = true;
        selectedSegmentProperties = SegmentHelper.getSegmentProperties(
            seriesRendererDetails.segments[k]);
        viewportIndex =
            selectedSegmentProperties.currentPoint?.visiblePointIndex;
      }
    }

    final SelectionDetails selectionDetails =
        SelectionHelper.getRenderingDetails(selectionBehaviorRenderer);
    if (selectedSegmentProperties == null) {
      selectionDetails.selectionRenderer!.pointIndex = null;
      selectionDetails.selectionRenderer!.seriesIndex = null;
    } else {
      selectionDetails.selectionRenderer!.pointIndex =
          selectedSegmentProperties.currentPoint?.overallDataPointIndex;
      selectionDetails.selectionRenderer!.seriesIndex =
          selectedSegmentProperties.seriesIndex;
    }
  }

  /// To check that touch point is lies in segment.
  bool isLineIntersect(
      CartesianChartPoint<dynamic> segmentStartPoint,
      CartesianChartPoint<dynamic> segmentEndPoint,
      CartesianChartPoint<dynamic> touchStartPoint,
      CartesianChartPoint<dynamic> touchEndPoint) {
    final int topPos =
        getPointDirection(segmentStartPoint, segmentEndPoint, touchStartPoint);
    final int botPos =
        getPointDirection(segmentStartPoint, segmentEndPoint, touchEndPoint);
    final int leftPos =
        getPointDirection(touchStartPoint, touchEndPoint, segmentStartPoint);
    final int rightPos =
        getPointDirection(touchStartPoint, touchEndPoint, segmentEndPoint);

    return topPos != botPos && leftPos != rightPos;
  }

  /// To get the segment points direction.
  static int getPointDirection(
      CartesianChartPoint<dynamic> point1,
      CartesianChartPoint<dynamic> point2,
      CartesianChartPoint<dynamic> point3) {
    final int value = (((point2.y - point1.y) * (point3.x - point2.x)) -
            ((point2.x - point1.x) * (point3.y - point2.y)))
        .toInt();

    if (value == 0) {
      return 0;
    }

    return (value > 0) ? 1 : 2;
  }

  /// To identify that series contains a given point.
  bool isSeriesContainsPoint(
      SeriesRendererDetails seriesRendererDetails, Offset position) {
    int? dataPointIndex;
    SegmentProperties? startSegmentProperties;
    SegmentProperties? endSegmentProperties;
    final List<CartesianChartPoint<dynamic>>? nearestDataPoints =
        getNearestChartPoints(
            position.dx,
            position.dy,
            seriesRendererDetails.xAxisDetails!.axisRenderer,
            seriesRendererDetails.yAxisDetails!.axisRenderer,
            seriesRendererDetails);
    if (nearestDataPoints == null) {
      return false;
    }
    for (final CartesianChartPoint<dynamic> dataPoint in nearestDataPoints) {
      final int actualIndex =
          seriesRendererDetails.dataPoints.indexOf(dataPoint);
      if (actualIndex >= 0) {
        dataPointIndex =
            seriesRendererDetails.dataPoints[actualIndex].visiblePointIndex;
      }
    }

    if (dataPointIndex != null &&
        seriesRendererDetails.segments.isNotEmpty == true) {
      if (seriesRendererDetails.seriesType.contains('hilo') == true ||
          seriesRendererDetails.seriesType == 'candle' ||
          seriesRendererDetails.seriesType.contains('boxandwhisker') == true) {
        startSegmentProperties = SegmentHelper.getSegmentProperties(
            seriesRendererDetails.segments[dataPointIndex]);
      } else {
        if (dataPointIndex == 0 &&
            dataPointIndex < seriesRendererDetails.segments.length) {
          startSegmentProperties = SegmentHelper.getSegmentProperties(
              seriesRendererDetails.segments[dataPointIndex]);
        } else if (dataPointIndex ==
                seriesRendererDetails.dataPoints.length - 1 &&
            dataPointIndex - 1 < seriesRendererDetails.segments.length) {
          startSegmentProperties = SegmentHelper.getSegmentProperties(
              seriesRendererDetails.segments[dataPointIndex - 1]);
        } else {
          if (dataPointIndex - 1 < seriesRendererDetails.segments.length) {
            startSegmentProperties = SegmentHelper.getSegmentProperties(
                seriesRendererDetails.segments[dataPointIndex - 1]);
          }

          if (dataPointIndex < seriesRendererDetails.segments.length) {
            endSegmentProperties = SegmentHelper.getSegmentProperties(
                seriesRendererDetails.segments[dataPointIndex]);
          }
        }
      }
      // ignore: unnecessary_null_comparison
      if (startSegmentProperties != null) {
        cartesianSeriesIndex = startSegmentProperties.seriesIndex;
        cartesianPointIndex =
            startSegmentProperties.segment.currentSegmentIndex;
        if (_isSegmentIntersect(
            startSegmentProperties.segment, position.dx, position.dy)) {
          return true;
        }
      } else if (endSegmentProperties != null) {
        cartesianSeriesIndex = endSegmentProperties.seriesIndex;
        cartesianPointIndex = endSegmentProperties.segment.currentSegmentIndex;
        return _isSegmentIntersect(
            endSegmentProperties.segment, position.dx, position.dy);
      }
    }
    return false;
  }

  /// To identify the cartesian point index.
  int? getCartesianPointIndex(Offset position) {
    final List<CartesianChartPoint<dynamic>> firstNearestDataPoints =
        <CartesianChartPoint<dynamic>>[];
    int previousIndex, nextIndex;
    int? dataPointIndex,
        previousDataPointIndex,
        nextDataPointIndex,
        nearestDataPointIndex;
    final List<CartesianChartPoint<dynamic>>? nearestDataPoints =
        getNearestChartPoints(
            position.dx,
            position.dy,
            seriesRendererDetails.xAxisDetails!.axisRenderer,
            seriesRendererDetails.yAxisDetails!.axisRenderer,
            seriesRendererDetails);

    for (final CartesianChartPoint<dynamic> dataPoint in nearestDataPoints!) {
      dataPointIndex = dataPoint.overallDataPointIndex;
      viewportIndex = dataPoint.visiblePointIndex;
      previousIndex = seriesRendererDetails.dataPoints.indexOf(dataPoint) - 1;
      previousIndex < 0
          ? previousDataPointIndex = dataPointIndex
          : previousDataPointIndex = previousIndex;
      nextIndex = seriesRendererDetails.dataPoints.indexOf(dataPoint) + 1;
      nextIndex > seriesRendererDetails.dataPoints.length - 1
          ? nextDataPointIndex = dataPointIndex
          : nextDataPointIndex = nextIndex;
    }

    firstNearestDataPoints
        .add(seriesRendererDetails.dataPoints[previousDataPointIndex]);
    firstNearestDataPoints
        .add(seriesRendererDetails.dataPoints[nextDataPointIndex]);
    final List<CartesianChartPoint<dynamic>>? firstNearestPoints =
        getNearestChartPoints(
            position.dx,
            position.dy,
            seriesRendererDetails.xAxisDetails!.axisRenderer,
            seriesRendererDetails.yAxisDetails!.axisRenderer,
            seriesRendererDetails,
            firstNearestDataPoints);

    for (final CartesianChartPoint<dynamic> dataPoint in firstNearestPoints!) {
      if (seriesRendererDetails.seriesType.contains('hilo') == true ||
          seriesRendererDetails.seriesType == 'candle' ||
          seriesRendererDetails.seriesType.contains('boxandwhisker') == true) {
        nearestDataPointIndex = dataPointIndex;
      } else {
        if (dataPointIndex! < dataPoint.overallDataPointIndex!) {
          nearestDataPointIndex = dataPointIndex;
        } else if (dataPointIndex == dataPoint.overallDataPointIndex) {
          dataPoint.overallDataPointIndex! - 1 < 0
              ? nearestDataPointIndex = dataPoint.overallDataPointIndex
              : nearestDataPointIndex = dataPoint.overallDataPointIndex! - 1;
        } else {
          nearestDataPointIndex = dataPoint.overallDataPointIndex;
        }
      }
    }

    SelectionHelper.getRenderingDetails(
            seriesRendererDetails.selectionBehaviorRenderer)
        .selectionRenderer!
        .cartesianPointIndex = nearestDataPointIndex;
    return nearestDataPointIndex;
  }

  /// To know the segment is intersect with touch point.
  bool _isSegmentIntersect(
      ChartSegment segment, double touchX1, double touchY1) {
    dynamic currentSegment;
    num x1, x2, y1, y2;
    if (segment is LineSegment ||
        segment is SplineSegment ||
        segment is StepLineSegment ||
        segment is StackedLineSegment ||
        segment is HiloSegment ||
        segment is HiloOpenCloseSegment ||
        segment is CandleSegment ||
        segment is BoxAndWhiskerSegment ||
        segment is StackedLine100Segment) {
      currentSegment = segment;
      currentSegmentProperties =
          SegmentHelper.getSegmentProperties(currentSegment);
    }
    x1 = currentSegment is HiloSegment ||
            currentSegment is HiloOpenCloseSegment ||
            currentSegment is CandleSegment ||
            currentSegment is BoxAndWhiskerSegment
        ? currentSegmentProperties!.x
        : currentSegmentProperties!.x1;
    if (currentSegment is HiloSegment ||
        currentSegment is HiloOpenCloseSegment ||
        currentSegment is CandleSegment ||
        currentSegment is BoxAndWhiskerSegment) {
      x2 = currentSegmentProperties!.x;
      if (currentSegment is BoxAndWhiskerSegment) {
        y1 = currentSegmentProperties!.min;
        y2 = currentSegmentProperties!.max;
      } else {
        y1 = currentSegmentProperties!.low;
        y2 = currentSegmentProperties!.high;
      }
    } else {
      y1 = currentSegment is StackedLineSegment ||
              currentSegment is StackedLine100Segment
          ? currentSegmentProperties!.currentCummulativeValue
          : currentSegmentProperties!.y1;
      x2 = currentSegmentProperties!.x2;
      y2 = currentSegment is StackedLineSegment ||
              currentSegment is StackedLine100Segment
          ? currentSegmentProperties!.nextCummulativeValue
          : currentSegmentProperties!.y2;
    }

    final CartesianChartPoint<dynamic> leftPoint =
        CartesianChartPoint<dynamic>(touchX1 - 20, touchY1 - 20);
    final CartesianChartPoint<dynamic> rightPoint =
        CartesianChartPoint<dynamic>(touchX1 + 20, touchY1 + 20);
    final CartesianChartPoint<dynamic> topPoint =
        CartesianChartPoint<dynamic>(touchX1 + 20, touchY1 - 20);
    final CartesianChartPoint<dynamic> bottomPoint =
        CartesianChartPoint<dynamic>(touchX1 - 20, touchY1 + 20);

    final CartesianChartPoint<dynamic> startSegment =
        CartesianChartPoint<dynamic>(x1, y1);
    final CartesianChartPoint<dynamic> endSegment =
        CartesianChartPoint<dynamic>(x2, y2);

    if (isLineIntersect(startSegment, endSegment, leftPoint, rightPoint) ||
        isLineIntersect(startSegment, endSegment, topPoint, bottomPoint)) {
      return true;
    }

    if (seriesRendererDetails.seriesType == 'stepline') {
      final num x3 = currentSegmentProperties!.x3;
      final num y3 = currentSegmentProperties!.y3;
      final num x2 = currentSegmentProperties!.x2;
      final num y2 = currentSegmentProperties!.y2;
      final CartesianChartPoint<dynamic> endSegment =
          CartesianChartPoint<dynamic>(x2, y2);
      final CartesianChartPoint<dynamic> midSegment =
          CartesianChartPoint<dynamic>(x3, y3);
      if (isLineIntersect(endSegment, midSegment, leftPoint, rightPoint) ||
          isLineIntersect(endSegment, midSegment, topPoint, bottomPoint)) {
        return true;
      }
    }
    return false;
  }

  /// To get the index of the selected segment.
  void getSelectedSeriesIndex(SfCartesianChart chart, Offset position,
      SeriesRendererDetails seriesRendererDetails) {
    Rect? currentSegment;
    int? seriesIndex;
    SelectionBehaviorRenderer? selectionBehaviorRenderer;
    CartesianChartPoint<dynamic> point;
    outerLoop:
    for (int i = 0;
        i < stateProperties.chartSeries.visibleSeriesRenderers.length;
        i++) {
      final SeriesRendererDetails seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(
              stateProperties.chartSeries.visibleSeriesRenderers[i]);
      selectionBehaviorRenderer =
          seriesRendererDetails.selectionBehaviorRenderer!;
      for (int j = 0; j < seriesRendererDetails.dataPoints.length; j++) {
        point = seriesRendererDetails.dataPoints[j];
        currentSegment = point.region;
        if (currentSegment != null && currentSegment.contains(position)) {
          seriesIndex = i;
          break outerLoop;
        }
      }
    }
    if (selectionBehaviorRenderer == null) {
      return;
    }

    SelectionHelper.getRenderingDetails(selectionBehaviorRenderer)
        .selectionRenderer!
        .seriesIndex = seriesIndex;
  }

  /// To do selection for cartesian type chart.
  void performSelection(Offset position) {
    bool select = false;
    bool isSelect = false;
    isInteraction = true;
    int? cartesianPointIndex;
    final SelectionDetails selectionDetails =
        SelectionHelper.getRenderingDetails(
            seriesRendererDetails.selectionBehaviorRenderer);
    if (seriesRendererDetails.seriesType == 'line' ||
        seriesRendererDetails.seriesType == 'spline' ||
        seriesRendererDetails.seriesType == 'stepline' ||
        seriesRendererDetails.seriesType == 'stackedline' ||
        seriesRendererDetails.seriesType.contains('hilo') == true ||
        seriesRendererDetails.seriesType == 'candle' ||
        seriesRendererDetails.seriesType.contains('boxandwhisker') == true ||
        seriesRendererDetails.seriesType == 'stackedline100') {
      isSelect = seriesRendererDetails.isSelectionEnable == true &&
          isSeriesContainsPoint(seriesRendererDetails, position);
      if (isSelect) {
        cartesianPointIndex = getCartesianPointIndex(position);
        selected = cartesianPointIndex != null;
        select = selectionDetails.selectionRenderer!.isCartesianSelection(
            chart,
            seriesRendererDetails.renderer,
            cartesianPointIndex,
            cartesianSeriesIndex);
      }
    } else {
      if (seriesRendererDetails.seriesType != 'errorbar') {
        stateProperties.renderDatalabelRegions = <Rect>[];
        (seriesRendererDetails.seriesType.contains('area') == true ||
                seriesRendererDetails.seriesType == 'fastline')
            ? getSelectedSeriesIndex(chart, position, seriesRendererDetails)
            : getPointAndSeriesIndex(chart, position, seriesRendererDetails);

        select = selectionDetails.selectionRenderer!.isCartesianSelection(
            chart, seriesRendererDetails.renderer, pointIndex, seriesIndex);
      }
    }

    if (select) {
      for (final CartesianSeriesRenderer seriesRenderer
          in stateProperties.chartSeries.visibleSeriesRenderers) {
        ValueNotifier<int>(SeriesHelper.getSeriesRendererDetails(seriesRenderer)
            .repaintNotifier
            .value++);
      }
    }
  }

  /// To check whether the segments are selected or not.
  // ignore: unused_element
  void checkWithSelectionState(
      ChartSegment currentSegment, SfCartesianChart chart) {
    bool isSelected = false;
    final SegmentProperties currentSegmentProperties =
        SegmentHelper.getSegmentProperties(currentSegment);
    if (selectedSegments.isNotEmpty) {
      for (int i = 0; i < selectedSegments.length; i++) {
        if (SegmentHelper.getSegmentProperties(selectedSegments[i])
                    .seriesIndex ==
                currentSegmentProperties.seriesIndex &&
            (isInteraction || currentSegmentProperties.oldSegmentIndex != -1) &&
            (seriesRendererDetails.seriesType.contains('area') == true
                ? selectedSegments[i].currentSegmentIndex ==
                    currentSegment.currentSegmentIndex
                : SegmentHelper.getSegmentProperties(selectedSegments[i])
                        .currentPoint!
                        .overallDataPointIndex ==
                    (isInteraction
                        ? currentSegmentProperties
                            .currentPoint!.overallDataPointIndex
                        : (currentSegmentProperties.oldSegmentIndex ??
                            currentSegmentProperties
                                .currentPoint!.overallDataPointIndex)))) {
          selectedSegmentsColors(<ChartSegment>[currentSegment]);
          isSelected = true;
          break;
        }
      }
    }

    if (!isSelected && unselectedSegments!.isNotEmpty) {
      for (int i = 0; i < unselectedSegments!.length; i++) {
        if (SegmentHelper.getSegmentProperties(unselectedSegments![i])
                    .seriesIndex ==
                currentSegmentProperties.seriesIndex &&
            (currentSegmentProperties.oldSegmentIndex == -1 ||
                    currentSegmentProperties.oldSegmentIndex !=
                        currentSegment.currentSegmentIndex ||
                    seriesRendererDetails.seriesType.contains('area') == true
                ? unselectedSegments![i].currentSegmentIndex ==
                    currentSegment.currentSegmentIndex
                : SegmentHelper.getSegmentProperties(unselectedSegments![i])
                        .currentPoint
                        ?.overallDataPointIndex ==
                    currentSegmentProperties
                        .currentPoint?.overallDataPointIndex)) {
          unselectedSegmentsColors(<ChartSegment>[currentSegment]);
          isSelected = true;
          break;
        }
      }
    }
  }

  /// To get the selection event argument values.
  SelectionArgs getSelectionEventArgs(
      CartesianSeries<dynamic, dynamic> series,
      int seriesIndex,
      int pointIndex,
      SeriesRendererDetails seriesRenderDetails) {
    // ignore: unnecessary_null_comparison
    if (series != null) {
      selectionArgs = SelectionArgs(
          seriesRenderer: seriesRendererDetails.renderer,
          seriesIndex: seriesIndex,
          viewportPointIndex: pointIndex,
          pointIndex: seriesRendererDetails
              .visibleDataPoints![pointIndex].overallDataPointIndex!);
    }
    return selectionArgs!;
  }
}
