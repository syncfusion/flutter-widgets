part of charts;

class _StackedBarChartPainter extends CustomPainter {
  _StackedBarChartPainter({
    this.chartState,
    this.seriesRenderer,
    this.isRepaint,
    this.animationController,
    this.painterKey,
    ValueNotifier<num> notifier,
  })  : chart = chartState._chart,
        super(repaint: notifier);
  final SfCartesianChartState chartState;

  final SfCartesianChart chart;
  CartesianChartPoint<dynamic> point;
  final bool isRepaint;
  final AnimationController animationController;
  List<_ChartLocation> currentChartLocations = <_ChartLocation>[];
  final StackedBarSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;
  //ignore: unused_field
  static double animation;

  /// Painter method for stacked bar series
  @override
  void paint(Canvas canvas, Size size) {
    _stackedRectPainter(canvas, seriesRenderer, chartState, painterKey);
  }

  @override
  bool shouldRepaint(_StackedBarChartPainter oldDelegate) => isRepaint;
}
