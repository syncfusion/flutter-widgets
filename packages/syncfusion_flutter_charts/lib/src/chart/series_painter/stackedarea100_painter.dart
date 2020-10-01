part of charts;

class _StackedArea100ChartPainter extends CustomPainter {
  _StackedArea100ChartPainter(
      {this.chartState,
      this.seriesRenderer,
      this.isRepaint,
      this.animationController,
      this.painterKey,
      ValueNotifier<num> notifier})
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
