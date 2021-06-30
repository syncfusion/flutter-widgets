part of charts;

class _StackedAreaChartPainter extends CustomPainter {
  _StackedAreaChartPainter(
      {required this.chartState,
      required this.seriesRenderer,
      required this.isRepaint,
      required this.animationController,
      required this.painterKey,
      required ValueNotifier<num> notifier})
      : chart = chartState._chart,
        super(repaint: notifier);
  final SfCartesianChartState chartState;
  final SfCartesianChart chart;
  final bool isRepaint;
  final Animation<double> animationController;
  final StackedAreaSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for stacked area series
  @override
  void paint(Canvas canvas, Size size) {
    _stackedAreaPainter(
        canvas,
        seriesRenderer,
        chartState,
        seriesRenderer._seriesAnimation,
        seriesRenderer._seriesElementAnimation,
        painterKey);
  }

  @override
  bool shouldRepaint(_StackedAreaChartPainter oldDelegate) => isRepaint;
}
