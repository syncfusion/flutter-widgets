part of charts;

class _StackedArea100ChartPainter extends CustomPainter {
  _StackedArea100ChartPainter(
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
  final StackedArea100SeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for stacked area 100 series
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
  bool shouldRepaint(_StackedArea100ChartPainter oldDelegate) => isRepaint;
}
