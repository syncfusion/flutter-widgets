part of charts;

class _StackedAreaChartPainter extends CustomPainter {
  _StackedAreaChartPainter(
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
