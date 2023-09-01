import 'package:flutter/material.dart';
import '../../common/rendering_details.dart';
import '../../common/utils/helper.dart';
import '../axis/axis.dart';
import '../axis/datetime_axis.dart';
import '../axis/datetime_category_axis.dart';
import '../base/chart_base.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../common/cartesian_state_properties.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import 'multi_level_labels.dart';

/// Represents the class for customize axis elements
abstract class CustomizeAxisElements {
  /// To get axis line color
  Color? getAxisLineColor(ChartAxis axis);

  ///To get axis line width
  Color? getAxisMajorTickColor(ChartAxis axis, int majorTickIndex);

  /// To get major tick color
  Color? getAxisMinorTickColor(
      ChartAxis axis, int majorTickIndex, int minorTickIndex);

  /// To get major grid color
  Color? getAxisMajorGridColor(ChartAxis axis, int majorGridIndex);

  /// To get minor grid color
  Color? getAxisMinorGridColor(
      ChartAxis axis, int majorGridIndex, int minorGridIndex);

  /// To get the axis line width
  double getAxisLineWidth(ChartAxis axis);

  /// To get major tick width
  double getAxisMajorTickWidth(ChartAxis axis, int majorTickIndex);

  /// To get minor tick width
  double getAxisMinorTickWidth(
      ChartAxis axis, int majorTickIndex, int minorTickIndex);

  /// To get major grid width
  double getAxisMajorGridWidth(ChartAxis axis, int majorGridIndex);

  /// To get minor grid width
  double getAxisMinorGridWidth(
      ChartAxis axis, int majorGridIndex, int minorGridIndex);

  /// To get axis label text
  String getAxisLabel(ChartAxis axis, String text, int labelIndex);

  /// To get axis label style
  TextStyle getAxisLabelStyle(ChartAxis axis, String text, int labelIndex);

  /// To get angle of axis label
  int getAxisLabelAngle(
      ChartAxisRenderer axisRenderer, String text, int labelIndex);

  /// To draw horizontal axes lines
  void drawHorizontalAxesLine(
      Canvas canvas, ChartAxisRenderer axisRenderer, SfCartesianChart chart);

  /// To draw horizontal axes lines
  void drawVerticalAxesLine(
      Canvas canvas, ChartAxisRenderer axisRenderer, SfCartesianChart chart);

  /// To draw horizontal axes tick lines
  void drawHorizontalAxesTickLines(
      Canvas canvas, ChartAxisRenderer axisRenderer, SfCartesianChart chart);

  /// To draw vertical axes tick lines
  void drawVerticalAxesTickLines(
      Canvas canvas, ChartAxisRenderer axisRenderer, SfCartesianChart chart);

  /// To draw horizontal axes major grid lines
  void drawHorizontalAxesMajorGridLines(
      Canvas canvas,
      Offset point,
      ChartAxisRenderer axisRenderer,
      MajorGridLines grids,
      int index,
      SfCartesianChart chart);

  /// To draw vertical axes major grid lines
  void drawVerticalAxesMajorGridLines(
      Canvas canvas,
      Offset point,
      ChartAxisRenderer axisRenderer,
      MajorGridLines grids,
      int index,
      SfCartesianChart chart);

  /// To draw horizontal axes minor grid lines
  void drawHorizontalAxesMinorLines(
      Canvas canvas,
      ChartAxisRenderer axisRenderer,
      double tempInterval,
      Rect rect,
      num nextValue,
      int index,
      SfCartesianChart chart);

  /// To draw vertical axes minor grid lines
  void drawVerticalAxesMinorTickLines(
      Canvas canvas,
      ChartAxisRenderer axisRenderer,
      num tempInterval,
      Rect rect,
      int index,
      SfCartesianChart chart);

  /// To draw horizontal axes labels
  void drawHorizontalAxesLabels(
      Canvas canvas, ChartAxisRenderer axisRenderer, SfCartesianChart chart);

  /// To draw vertical axes labels
  void drawVerticalAxesLabels(
      Canvas canvas, ChartAxisRenderer axisRenderer, SfCartesianChart chart);

  /// To draw horizontal axes title
  void drawHorizontalAxesTitle(
      Canvas canvas, ChartAxisRenderer axisRenderer, SfCartesianChart chart);

  /// To draw vertical axes title
  void drawVerticalAxesTitle(
      Canvas canvas, ChartAxisRenderer axisRenderer, SfCartesianChart chart);
}

/// Represents the cartesian axis widgets
// ignore: must_be_immutable
class CartesianAxisWidget extends StatefulWidget {
  /// Creates an instance for cartesian axis widget
  // ignore: prefer_const_constructors_in_immutables
  CartesianAxisWidget(
      {required this.stateProperties,
      required this.renderType,
      required this.dataLabelTemplateNotifier});

  /// Specifies the cartesian state properties
  final CartesianStateProperties stateProperties;

  /// Specifies the render types
  String renderType;

  /// Specifies the cartesian axis widget state
  // ignore: library_private_types_in_public_api
  late _CartesianAxisWidgetState state;

  /// Specifies the data label template notifier
  ValueNotifier<int> dataLabelTemplateNotifier;

  @override
  State<StatefulWidget> createState() => _CartesianAxisWidgetState();
}

class _CartesianAxisWidgetState extends State<CartesianAxisWidget>
    with SingleTickerProviderStateMixin {
  late List<AnimationController> animationControllersList;

  /// Animation controller for axis
  late AnimationController animationController;

  /// Repaint notifier for axis
  late ValueNotifier<int> axisRepaintNotifier;

  @override
  void initState() {
    axisRepaintNotifier = ValueNotifier<int>(0);
    animationController = AnimationController(vsync: this)
      ..addListener(_repaintAxisElements);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.state = this;
    animationController.duration = const Duration(milliseconds: 1000);
    final Animation<double> axisAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.1, 0.9, curve: Curves.decelerate),
    ));
    animationController.forward(from: 0.0);
    // ignore: avoid_unnecessary_containers
    return Container(
        child: RepaintBoundary(
            child: CustomPaint(
                painter: _CartesianAxesPainter(
                    stateProperties: widget.stateProperties,
                    axisAnimation: axisAnimation,
                    renderType: widget.renderType,
                    isRepaint: widget.stateProperties.chartAxis.needsRepaint,
                    notifier: axisRepaintNotifier))));
  }

  void _animateAxis() {
    final double animationFactor = animationController.value;
    for (int axisIndex = 0;
        axisIndex <
            widget.stateProperties.chartAxis.axisRenderersCollection.length;
        axisIndex++) {
      ///visibleMinimum and visibleMaximum not defined in the chart axis class,
      /// so dynamic datatype used here
      final ChartAxisRenderer axisRenderer =
          widget.stateProperties.chartAxis.axisRenderersCollection[axisIndex];
      final dynamic axisDetails =
          AxisHelper.getAxisRendererDetails(axisRenderer);

      ///visibleMinimum and visibleMaximum not defined in the chart axis class,
      /// so dynamic datatype used here
      dynamic oldAxisRenderer;
      bool needAnimate = false;
      if ((widget.stateProperties.requireInvertedAxis
              ? axisDetails.orientation == AxisOrientation.vertical
              : axisDetails.orientation == AxisOrientation.horizontal) &&
          // ignore: unnecessary_null_comparison
          widget.stateProperties.oldAxisRenderers != null &&
          widget.stateProperties.oldAxisRenderers.isNotEmpty &&
          (axisDetails.axis.visibleMinimum != null ||
              axisDetails.axis.visibleMaximum != null)) {
        oldAxisRenderer = getOldAxisRenderer(
            axisRenderer, widget.stateProperties.oldAxisRenderers);
        final dynamic oldAxisDetails =
            AxisHelper.getAxisRendererDetails(oldAxisRenderer);
        if (oldAxisRenderer != null &&
            (oldAxisDetails.axis.visibleMinimum != null &&
                oldAxisDetails.axis.visibleMaximum != null)) {
          needAnimate = axisDetails.runtimeType == oldAxisDetails.runtimeType &&
              ((oldAxisDetails.axis.visibleMinimum != null &&
                      oldAxisDetails.axis.visibleMinimum !=
                          axisDetails.axis.visibleMinimum) ||
                  (oldAxisDetails.axis.visibleMaximum != null &&
                      oldAxisDetails.axis.visibleMaximum !=
                          axisDetails.axis.visibleMaximum)) &&
              _checkSeriesAnimation(axisDetails.seriesRenderers);
          if (needAnimate) {
            if (axisRenderer is DateTimeAxisRenderer ||
                axisRenderer is DateTimeCategoryAxisRenderer) {
              axisDetails.visibleMinimum =
                  (oldAxisDetails.axis.visibleMinimum.millisecondsSinceEpoch -
                          (oldAxisDetails.axis.visibleMinimum
                                      .millisecondsSinceEpoch -
                                  axisDetails.axis.visibleMinimum
                                      .millisecondsSinceEpoch) *
                              animationFactor)
                      .toInt();
              axisDetails.visibleMaximum =
                  (oldAxisDetails.axis.visibleMaximum.millisecondsSinceEpoch -
                          (oldAxisDetails.axis.visibleMaximum
                                      .millisecondsSinceEpoch -
                                  axisDetails.axis.visibleMaximum
                                      .millisecondsSinceEpoch) *
                              animationFactor)
                      .toInt();
            } else {
              axisDetails.visibleMinimum = oldAxisDetails.axis.visibleMinimum -
                  (oldAxisDetails.axis.visibleMinimum -
                          axisDetails.axis.visibleMinimum) *
                      animationFactor;
              axisDetails.visibleMaximum = oldAxisDetails.axis.visibleMaximum -
                  (oldAxisDetails.axis.visibleMaximum -
                          axisDetails.axis.visibleMaximum) *
                      animationFactor;
            }
            if (axisDetails is DateTimeCategoryAxisDetails) {
              axisDetails.labels.clear();
              //ignore: prefer_foreach
              for (final CartesianSeriesRenderer seriesRenderer
                  in axisDetails.seriesRenderers) {
                widget.stateProperties.chartSeries.findSeriesMinMax(
                    SeriesHelper.getSeriesRendererDetails(seriesRenderer));
              }
            }
            axisDetails.calculateRangeAndInterval(widget.stateProperties);
            for (final CartesianSeriesRenderer seriesRenderer
                in axisDetails.seriesRenderers) {
              final SeriesRendererDetails seriesRendererDetails =
                  SeriesHelper.getSeriesRendererDetails(seriesRenderer);
              seriesRendererDetails.calculateRegion = true;
              seriesRendererDetails.repaintNotifier.value++;
              widget.stateProperties.plotBandRepaintNotifier.value++;
              if (seriesRendererDetails.series.dataLabelSettings.isVisible ==
                      true &&
                  widget.stateProperties.renderDataLabel?.state != null) {
                widget.stateProperties.renderDataLabel?.state!
                    .dataLabelRepaintNotifier.value++;
              }
            }
          }
        }
      }
    }
  }

  bool _checkSeriesAnimation(List<CartesianSeriesRenderer> seriesRenderers) {
    for (int i = 0; i < seriesRenderers.length; i++) {
      final SeriesRendererDetails seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(seriesRenderers[i]);
      if (seriesRendererDetails.series.animationDuration <= 0) {
        return false;
      }
    }
    return true;
  }

  @override
  void dispose() {
    disposeAnimationController(animationController, _repaintAxisElements);
    super.dispose();
  }

  void _repaintAxisElements() {
    _animateAxis();
    axisRepaintNotifier.value++;
    if (animationController.status == AnimationStatus.completed) {
      widget.stateProperties.renderingDetails.dataLabelTemplateRegions.clear();
      widget.dataLabelTemplateNotifier.value++;
    }
  }
}

class _CartesianAxesPainter extends CustomPainter {
  _CartesianAxesPainter(
      {required this.stateProperties,
      required this.isRepaint,
      required ValueNotifier<num> notifier,
      required this.renderType,
      required this.axisAnimation})
      : chart = stateProperties.chart,
        super(repaint: notifier);
  final CartesianStateProperties stateProperties;
  final SfCartesianChart chart;
  final bool isRepaint;
  final String renderType;
  final Animation<double> axisAnimation;

  @override
  void paint(Canvas canvas, Size size) {
    _onAxisDraw(canvas);
  }

  /// Draw method for axes
  void _onAxisDraw(Canvas canvas) {
    if (renderType == 'outside') {
      _drawPlotAreaBorder(canvas);
      if (chart.plotAreaBackgroundImage != null &&
          stateProperties.backgroundImage != null) {
        paintImage(
            canvas: canvas,
            rect: stateProperties.chartAxis.axisClipRect,
            image: stateProperties.backgroundImage!,
            fit: BoxFit.fill);
      }
    }
    _drawAxes(canvas);
  }

  /// To draw a plot area border of a container
  void _drawPlotAreaBorder(Canvas canvas) {
    final Rect axisClipRect = stateProperties.chartAxis.axisClipRect;
    final RenderingDetails renderingDetails = stateProperties.renderingDetails;
    final Paint paint = Paint();
    paint.color = chart.plotAreaBorderColor ??
        renderingDetails.chartTheme.plotAreaBorderColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = chart.plotAreaBorderWidth;
    chart.plotAreaBorderWidth == 0
        ? paint.color = Colors.transparent
        : paint.color = paint.color;
    canvas.drawRect(axisClipRect, paint);

    canvas.drawRect(
        axisClipRect,
        Paint()
          ..color = chart.plotAreaBackgroundColor ??
              renderingDetails.chartTheme.plotAreaBackgroundColor
          ..style = PaintingStyle.fill);
  }

  /// To draw horizontal axes
  void _drawHorizontalAxes(
      Canvas canvas,
      ChartAxisRenderer axisRenderer,
      double animationFactor,
      ChartAxisRenderer? oldAxisRenderer,
      bool? needAnimate) {
    final ChartAxisRendererDetails axisDetails =
        AxisHelper.getAxisRendererDetails(axisRenderer);
    final ChartAxis axis = axisDetails.axis;
    if (axis.isVisible) {
      if (axis.axisLine.width > 0 && renderType == 'outside') {
        axisRenderer.drawHorizontalAxesLine(canvas, axisRenderer, chart);
      }
      if (axis.majorTickLines.width > 0 || axis.majorGridLines.width > 0) {
        axisRenderer.drawHorizontalAxesTickLines(canvas, axisRenderer, chart,
            renderType, animationFactor, oldAxisRenderer, needAnimate);
      }
      axisRenderer.drawHorizontalAxesLabels(canvas, axisRenderer, chart,
          renderType, animationFactor, oldAxisRenderer, needAnimate);
      if (axisDetails.isMultiLevelLabelEnabled) {
        drawMultiLevelLabels(axisDetails, canvas);
      }
      if (renderType == 'outside') {
        axisRenderer.drawHorizontalAxesTitle(canvas, axisRenderer, chart);
      }
    }
  }

  /// To draw vertical axes
  void _drawVerticalAxes(
      Canvas canvas,
      ChartAxisRenderer axisRenderer,
      double animationFactor,
      ChartAxisRenderer? oldAxisRenderer,
      bool? needAnimate) {
    final ChartAxisRendererDetails axisDetails =
        AxisHelper.getAxisRendererDetails(axisRenderer);
    final ChartAxis axis = axisDetails.axis;
    if (axis.isVisible) {
      if (axis.axisLine.width > 0 && renderType == 'outside') {
        axisRenderer.drawVerticalAxesLine(canvas, axisRenderer, chart);
      }
      if (axisDetails.visibleLabels.isNotEmpty &&
          (axis.majorTickLines.width > 0 || axis.majorGridLines.width > 0)) {
        axisRenderer.drawVerticalAxesTickLines(canvas, axisRenderer, chart,
            renderType, animationFactor, oldAxisRenderer, needAnimate);
      }
      axisRenderer.drawVerticalAxesLabels(canvas, axisRenderer, chart,
          renderType, animationFactor, oldAxisRenderer, needAnimate);
      if (axisDetails.isMultiLevelLabelEnabled) {
        drawMultiLevelLabels(axisDetails, canvas);
      }
      if (renderType == 'outside') {
        axisRenderer.drawVerticalAxesTitle(canvas, axisRenderer, chart);
      }
    }
  }

  /// To draw chart axes
  void _drawAxes(Canvas canvas) {
    final double animationFactor =
        // ignore: unnecessary_null_comparison
        axisAnimation != null ? axisAnimation.value : 1;
    for (int axisIndex = 0;
        axisIndex < stateProperties.chartAxis.axisRenderersCollection.length;
        axisIndex++) {
      final ChartAxisRenderer axisRenderer =
          stateProperties.chartAxis.axisRenderersCollection[axisIndex];
      final ChartAxisRendererDetails axisDetails =
          AxisHelper.getAxisRendererDetails(axisRenderer);
      final ChartAxis axis = axisDetails.axis;
      axisDetails.isInsideTickPosition =
          axis.tickPosition == TickPosition.inside;
      ChartAxisRenderer? oldAxisRenderer;
      bool needAnimate = false;
      // ignore: unnecessary_null_comparison
      if (stateProperties.oldAxisRenderers != null &&
          stateProperties.oldAxisRenderers.isNotEmpty &&
          axisDetails.visibleRange != null) {
        oldAxisRenderer =
            getOldAxisRenderer(axisRenderer, stateProperties.oldAxisRenderers);
        if (oldAxisRenderer != null) {
          final ChartAxisRendererDetails oldAxisDetails =
              AxisHelper.getAxisRendererDetails(oldAxisRenderer);
          if (oldAxisDetails.visibleRange != null) {
            needAnimate = chart.enableAxisAnimation &&
                (oldAxisDetails.visibleRange!.minimum !=
                        axisDetails.visibleRange!.minimum ||
                    oldAxisDetails.visibleRange!.maximum !=
                        axisDetails.visibleRange!.maximum);
          }
        }
      }
      axisDetails.orientation == AxisOrientation.horizontal
          ? _drawHorizontalAxes(canvas, axisRenderer, animationFactor,
              oldAxisRenderer, needAnimate)
          : _drawVerticalAxes(canvas, axisRenderer, animationFactor,
              oldAxisRenderer, needAnimate);
    }
  }

  @override
  bool shouldRepaint(_CartesianAxesPainter oldDelegate) => isRepaint;
}
