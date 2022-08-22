import 'package:flutter/material.dart';
import '../../chart/chart_series/series.dart';
import '../../chart/chart_series/xy_data_series.dart';
import '../../chart/common/trackball_marker_settings.dart';
import '../../chart/utils/enum.dart';
import '../../circular_chart/renderer/circular_series_controller.dart';
import '../../funnel_chart/renderer/funnel_series.dart';
import '../../pyramid_chart/renderer/series_controller.dart';
import '../event_args.dart';
import '../series/chart_series.dart';

/// typedef belongs SfCartesianChart

/// Returns the  TooltipArgs.
typedef ChartTooltipCallback = void Function(TooltipArgs tooltipArgs);

/// Returns the ActualRangeChangedArgs.
typedef ChartActualRangeChangedCallback = void Function(
    ActualRangeChangedArgs rangeChangedArgs);

/// Signature for the [axisLabelFormatter] callback that returns [ChartAxisLabel] class value to
/// customize the axis label text and style.
typedef ChartLabelFormatterCallback = ChartAxisLabel Function(
    AxisLabelRenderDetails axisLabelRenderArgs);

/// Signature for the [multiLevelLabelFormatter] callback that returns [ChartAxisLabel].
typedef MultiLevelLabelFormatterCallback = ChartAxisLabel Function(
    MultiLevelLabelRenderDetails multiLevelLabelRenderArgs);

/// Returns the DataLabelRenderArgs.
typedef ChartDataLabelRenderCallback = void Function(
    DataLabelRenderArgs dataLabelArgs);

/// Returns the LegendRenderArgs.
typedef ChartLegendRenderCallback = void Function(
    LegendRenderArgs legendRenderArgs);

/// Returns the Trendline args
typedef ChartTrendlineRenderCallback = void Function(
    TrendlineRenderParams trendlineRenderParams);

///Returns the TrackballArgs.
typedef ChartTrackballCallback = void Function(TrackballArgs trackballArgs);

/// Returns the CrosshairRenderArgs
typedef ChartCrosshairCallback = void Function(
    CrosshairRenderArgs crosshairArgs);

/// Returns the ZoomPanArgs.
typedef ChartZoomingCallback = void Function(ZoomPanArgs zoomingArgs);

/// Returns the  ChartPointDetails.
typedef ChartPointInteractionCallback = void Function(
    ChartPointDetails pointInteractionDetails);

/// Returns the  AxisLabelTapArgs.
typedef ChartAxisLabelTapCallback = void Function(
    AxisLabelTapArgs axisLabelTapArgs);

/// Returns the  LegendTapArgs.
typedef ChartLegendTapCallback = void Function(LegendTapArgs legendTapArgs);

/// Returns the SelectionArgs.
typedef ChartSelectionCallback = void Function(SelectionArgs selectionArgs);

/// Returns the offset.
typedef ChartTouchInteractionCallback = void Function(
    ChartTouchInteractionArgs tapArgs);

/// Returns the IndicatorRenderArgs.
typedef ChartIndicatorRenderCallback = TechnicalIndicatorRenderDetails Function(
    IndicatorRenderParams indicatorRenderParams);

/// Returns the MarkerRenderArgs.
typedef ChartMarkerRenderCallback = void Function(MarkerRenderArgs markerArgs);

/// Returns a widget which can be used to load more data to chart.
/// called on dragging and when the visible range reaches the end.
typedef LoadMoreViewBuilderCallback = Widget Function(
    BuildContext context, ChartSwipeDirection direction);

/// A callback which gets called on swiping over plot area.
typedef ChartPlotAreaSwipeCallback = void Function(
    ChartSwipeDirection direction);

/// Called when the series renderer is created.
typedef SeriesRendererCreatedCallback = void Function(
    ChartSeriesController controller);

/// Returns the widget.
typedef ChartDataLabelTemplateBuilder<T> = Widget Function(
    T data, CartesianChartPoint<dynamic> point, int pointIndex,
    {int seriesIndex, CartesianSeries<dynamic, dynamic> series});

/// typedef common for all the chart types
///
/// Signature for callback reporting that a data label is tapped.
///
/// Also refer `onDataLabelTapped` event and [DataLabelTapDetails] class.
typedef DataLabelTapCallback = void Function(DataLabelTapDetails onTapArgs);

/// Returns the widget.
///
/// Customize the appearance of legend items with your template by
/// using legendItemBuilder property of legend.
typedef LegendItemBuilder = Widget Function(
    String legendText, dynamic series, dynamic point, int seriesIndex);

/// Maps the index value.
typedef ChartIndexedValueMapper<R> = R? Function(int index);

/// Maps the data from data source.
typedef ChartValueMapper<T, R> = R? Function(T datum, int index);

/// Signature for the callback that returns the shader from the data source based on the index.
/// Can get the data, index, color and rect values.
///
///
/// T - Data of the current data point
///
///
/// index - Index of the current data point
///
///
/// rect - Rect value of the current data point slice
///
/// color - Color of the current data point
typedef ChartShaderMapper<T> = Shader Function(
    T datum, int index, Color color, Rect rect);

/// Returns the widget.
typedef ChartWidgetBuilder<T> = Widget Function(dynamic data, dynamic point,
    dynamic series, int pointIndex, int seriesIndex);

/// Returns the widget as a template of trackball
typedef ChartTrackballBuilder<T> = Widget Function(
    BuildContext context, TrackballDetails trackballDetails);

/// Custom renderer for series
typedef ChartSeriesRendererFactory<T, D> = ChartSeriesRenderer Function(
    ChartSeries<T, D> series);

/// typedef belongs SfCircularChart

/// Returns the LegendRenderArgs.
typedef CircularLegendRenderCallback = void Function(
    LegendRenderArgs legendRenderArgs);

/// Returns the TooltipArgs.
typedef CircularTooltipCallback = void Function(TooltipArgs tooltipArgs);

/// Returns the DataLabelRenderArgs.
typedef CircularDatalabelRenderCallback = void Function(
    DataLabelRenderArgs dataLabelArgs);

/// Returns the SelectionArgs.
typedef CircularSelectionCallback = void Function(SelectionArgs selectionArgs);

/// Returns the offset.
typedef CircularTouchInteractionCallback = void Function(
    ChartTouchInteractionArgs tapArgs);

/// Signature for the callback that returns the shader value to override the fill color of the data points.
typedef CircularShaderCallback = Shader Function(
    ChartShaderDetails chartShaderDetails);

/// Return the controller for circular series.
typedef CircularSeriesRendererCreatedCallback = void Function(
    CircularSeriesController controller);

// typedef belongs to SfFunnelChart

/// Returns the LegendRenderArgs.
typedef FunnelLegendRenderCallback = void Function(
    LegendRenderArgs legendRenderArganimateCompleteds);

/// Returns the TooltipArgs.
typedef FunnelTooltipCallback = void Function(TooltipArgs tooltipArgs);

/// Returns the DataLabelRenderArgs.
typedef FunnelDataLabelRenderCallback = void Function(
    DataLabelRenderArgs dataLabelArgs);

/// Returns the SelectionArgs.
typedef FunnelSelectionCallback = void Function(SelectionArgs selectionArgs);

/// Returns the offset.
typedef FunnelTouchInteractionCallback = void Function(
    ChartTouchInteractionArgs tapArgs);

/// Called when the renderer for the funnel series is created.
typedef FunnelSeriesRendererCreatedCallback = void Function(
    FunnelSeriesController controller);

// typedef belongs to SfPyramidChart

/// Returns the LegendRenderArgs.
typedef PyramidLegendRenderCallback = void Function(
    LegendRenderArgs legendRenderArganimateCompleteds);

/// Returns the TooltipArgs.
typedef PyramidTooltipCallback = void Function(TooltipArgs tooltipArgs);

/// Returns the DataLabelRenderArgs.
typedef PyramidDataLabelRenderCallback = void Function(
    DataLabelRenderArgs dataLabelArgs);

/// Returns the SelectionArgs.
typedef PyramidSelectionCallback = void Function(SelectionArgs selectionArgs);

/// Returns the Offset.
typedef PyramidTouchInteractionCallback = void Function(
    ChartTouchInteractionArgs tapArgs);

/// Called when the pyramid series is created.
typedef PyramidSeriesRendererCreatedCallback = void Function(
    PyramidSeriesController controller);

/// Callback definition for error bar event.
typedef ChartErrorBarRenderCallback = void Function(
    ErrorBarRenderDetails errorBarRenderDetails);

//// Callback definition for cartesian shader events.
typedef CartesianShaderCallback = Shader Function(ShaderDetails shaderDetails);
