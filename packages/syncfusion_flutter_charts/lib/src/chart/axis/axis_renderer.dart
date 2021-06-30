part of charts;

abstract class _CustomizeAxisElements {
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

// ignore: must_be_immutable
class _CartesianAxisRenderer extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _CartesianAxisRenderer({required this.chartState, required this.renderType});

  final SfCartesianChartState chartState;

  String renderType;

  late _CartesianAxisRendererState state;

  @override
  State<StatefulWidget> createState() => _CartesianAxisRendererState();
}

class _CartesianAxisRendererState extends State<_CartesianAxisRenderer>
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
    return Container(
        child: RepaintBoundary(
            child: CustomPaint(
                painter: _CartesianAxesPainter(
                    chartState: widget.chartState,
                    axisAnimation: axisAnimation,
                    renderType: widget.renderType,
                    isRepaint: widget.chartState._chartAxis._needsRepaint,
                    notifier: axisRepaintNotifier))));
  }

  void _animateAxis() {
    final double animationFactor = animationController.value;
    for (int axisIndex = 0;
        axisIndex <
            widget.chartState._chartAxis._axisRenderersCollection.length;
        axisIndex++) {
      ///visibleMinimum and visibleMaximum not defined in the chart axis class,
      /// so dynamic datatype used here
      final dynamic axisRenderer =
          widget.chartState._chartAxis._axisRenderersCollection[axisIndex];

      ///visibleMinimum and visibleMaximum not defined in the chart axis class,
      /// so dynamic datatype used here
      dynamic oldAxisRenderer;
      bool needAnimate = false;
      if ((widget.chartState._requireInvertedAxis
              ? axisRenderer._orientation == AxisOrientation.vertical
              : axisRenderer._orientation == AxisOrientation.horizontal) &&
          // ignore: unnecessary_null_comparison
          widget.chartState._oldAxisRenderers != null &&
          widget.chartState._oldAxisRenderers.isNotEmpty &&
          (axisRenderer._axis.visibleMinimum != null ||
              axisRenderer._axis.visibleMaximum != null)) {
        oldAxisRenderer = _getOldAxisRenderer(
            axisRenderer, widget.chartState._oldAxisRenderers);
        if (oldAxisRenderer != null &&
            (oldAxisRenderer._axis.visibleMinimum != null &&
                oldAxisRenderer._axis.visibleMaximum != null)) {
          needAnimate =
              axisRenderer.runtimeType == oldAxisRenderer.runtimeType &&
                  ((oldAxisRenderer._axis.visibleMinimum != null &&
                          oldAxisRenderer._axis.visibleMinimum !=
                              axisRenderer._axis.visibleMinimum) ||
                      (oldAxisRenderer._axis.visibleMaximum != null &&
                          oldAxisRenderer._axis.visibleMaximum !=
                              axisRenderer._axis.visibleMaximum)) &&
                  _checkSeriesAnimation(axisRenderer._seriesRenderers);
          if (needAnimate) {
            if (axisRenderer is DateTimeAxisRenderer ||
                axisRenderer is DateTimeCategoryAxisRenderer) {
              axisRenderer._visibleMinimum =
                  (oldAxisRenderer._axis.visibleMinimum.millisecondsSinceEpoch -
                          (oldAxisRenderer._axis.visibleMinimum
                                      .millisecondsSinceEpoch -
                                  axisRenderer._axis.visibleMinimum
                                      .millisecondsSinceEpoch) *
                              animationFactor)
                      .toInt();
              axisRenderer._visibleMaximum =
                  (oldAxisRenderer._axis.visibleMaximum.millisecondsSinceEpoch -
                          (oldAxisRenderer._axis.visibleMaximum
                                      .millisecondsSinceEpoch -
                                  axisRenderer._axis.visibleMaximum
                                      .millisecondsSinceEpoch) *
                              animationFactor)
                      .toInt();
            } else {
              axisRenderer._visibleMinimum =
                  oldAxisRenderer._axis.visibleMinimum -
                      (oldAxisRenderer._axis.visibleMinimum -
                              axisRenderer._axis.visibleMinimum) *
                          animationFactor;
              axisRenderer._visibleMaximum =
                  oldAxisRenderer._axis.visibleMaximum -
                      (oldAxisRenderer._axis.visibleMaximum -
                              axisRenderer._axis.visibleMaximum) *
                          animationFactor;
            }
            if (axisRenderer is DateTimeCategoryAxisRenderer) {
              axisRenderer._labels.clear();
              //ignore: prefer_foreach
              for (final CartesianSeriesRenderer seriesRenderer
                  in axisRenderer._seriesRenderers) {
                widget.chartState._chartSeries
                    ._findSeriesMinMax(seriesRenderer);
              }
            }
            axisRenderer._calculateRangeAndInterval(widget.chartState);
            for (final CartesianSeriesRenderer seriesRenderer
                in axisRenderer._seriesRenderers) {
              seriesRenderer._calculateRegion = true;
              seriesRenderer._repaintNotifier.value++;
              if (seriesRenderer._series.dataLabelSettings.isVisible &&
                  widget.chartState._renderDataLabel?.state != null) {
                widget.chartState._renderDataLabel?.state!
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
      if (seriesRenderers[i]._series.animationDuration <= 0) {
        return false;
      }
    }
    return true;
  }

  @override
  void dispose() {
    _disposeAnimationController(animationController, _repaintAxisElements);
    super.dispose();
  }

  void _repaintAxisElements() {
    _animateAxis();
    axisRepaintNotifier.value++;
  }
}

class _CartesianAxesPainter extends CustomPainter {
  _CartesianAxesPainter(
      {required this.chartState,
      required this.isRepaint,
      required ValueNotifier<num> notifier,
      required this.renderType,
      required this.axisAnimation})
      : chart = chartState._chart,
        super(repaint: notifier);
  final SfCartesianChartState chartState;
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
          chartState._backgroundImage != null) {
        paintImage(
            canvas: canvas,
            rect: chartState._chartAxis._axisClipRect,
            image: chartState._backgroundImage!,
            fit: BoxFit.fill);
      }
    }
    _drawAxes(canvas);
  }

  /// To draw a plot area border of a container
  void _drawPlotAreaBorder(Canvas canvas) {
    final Rect axisClipRect = chartState._chartAxis._axisClipRect;
    final _RenderingDetails renderingDetails = chartState._renderingDetails;
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
    final ChartAxis axis = axisRenderer._axis;
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
    final ChartAxis axis = axisRenderer._axis;
    if (axis.isVisible) {
      if (axis.axisLine.width > 0 && renderType == 'outside') {
        axisRenderer.drawVerticalAxesLine(canvas, axisRenderer, chart);
      }
      if (axisRenderer._visibleLabels.isNotEmpty &&
          (axis.majorTickLines.width > 0 || axis.majorGridLines.width > 0)) {
        axisRenderer.drawVerticalAxesTickLines(canvas, axisRenderer, chart,
            renderType, animationFactor, oldAxisRenderer, needAnimate);
      }
      axisRenderer.drawVerticalAxesLabels(canvas, axisRenderer, chart,
          renderType, animationFactor, oldAxisRenderer, needAnimate);
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
        axisIndex < chartState._chartAxis._axisRenderersCollection.length;
        axisIndex++) {
      final ChartAxisRenderer axisRenderer =
          chartState._chartAxis._axisRenderersCollection[axisIndex];
      final ChartAxis axis = axisRenderer._axis;
      axisRenderer._isInsideTickPosition =
          axis.tickPosition == TickPosition.inside;
      ChartAxisRenderer? oldAxisRenderer;
      bool needAnimate = false;
      // ignore: unnecessary_null_comparison
      if (chartState._oldAxisRenderers != null &&
          chartState._oldAxisRenderers.isNotEmpty &&
          axisRenderer._visibleRange != null) {
        oldAxisRenderer =
            _getOldAxisRenderer(axisRenderer, chartState._oldAxisRenderers);
        if (oldAxisRenderer != null && oldAxisRenderer._visibleRange != null) {
          needAnimate = chart.enableAxisAnimation &&
              (oldAxisRenderer._visibleRange!.minimum !=
                      axisRenderer._visibleRange!.minimum ||
                  oldAxisRenderer._visibleRange!.maximum !=
                      axisRenderer._visibleRange!.maximum);
        }
      }
      axisRenderer._orientation == AxisOrientation.horizontal
          ? _drawHorizontalAxes(canvas, axisRenderer, animationFactor,
              oldAxisRenderer, needAnimate)
          : _drawVerticalAxes(canvas, axisRenderer, animationFactor,
              oldAxisRenderer, needAnimate);
    }
  }

  @override
  bool shouldRepaint(_CartesianAxesPainter oldDelegate) => isRepaint;
}
