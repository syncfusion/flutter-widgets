part of charts;

class _StackedColummnChartPainter extends CustomPainter {
  _StackedColummnChartPainter(
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
  CartesianChartPoint<dynamic>? point;
  final bool isRepaint;
  final AnimationController animationController;
  List<_ChartLocation> currentChartLocations = <_ChartLocation>[];
  final StackedColumnSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for stacked column series
  @override
  void paint(Canvas canvas, Size size) {
    _stackedRectPainter(canvas, seriesRenderer, chartState, painterKey);
  }

  @override
  bool shouldRepaint(_StackedColummnChartPainter oldDelegate) => isRepaint;
}
