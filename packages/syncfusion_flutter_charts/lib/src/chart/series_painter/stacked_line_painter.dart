part of charts;

class _StackedLineChartPainter extends CustomPainter {
  _StackedLineChartPainter(
      {required this.chartState,
      required this.seriesRenderer,
      required this.isRepaint,
      required this.animationController,
      required ValueNotifier<num> notifier,
      required this.painterKey})
      : chart = chartState._chart,
        super(repaint: notifier);
  final SfCartesianChartState chartState;
  final SfCartesianChart chart;
  final bool isRepaint;
  final AnimationController animationController;
  final StackedLineSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for stacked line series
  @override
  void paint(Canvas canvas, Size size) {
    _stackedLinePainter(canvas, seriesRenderer, seriesRenderer._seriesAnimation,
        chartState, seriesRenderer._seriesElementAnimation, painterKey);
  }

  @override
  bool shouldRepaint(_StackedLineChartPainter oldDelegate) => isRepaint;
}
