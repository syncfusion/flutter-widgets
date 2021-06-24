part of charts;

class _StackedColumn100ChartPainter extends CustomPainter {
  _StackedColumn100ChartPainter({
    required this.chartState,
    required this.seriesRenderer,
    required this.isRepaint,
    required this.animationController,
    required this.painterKey,
    required ValueNotifier<num> notifier,
  })  : chart = chartState._chart,
        super(repaint: notifier);
  final SfCartesianChartState chartState;
  final SfCartesianChart chart;
  CartesianChartPoint<dynamic>? point;
  final bool isRepaint;
  final AnimationController animationController;
  List<_ChartLocation> currentChartLocations = <_ChartLocation>[];
  final StackedColumn100SeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for stacked column 100 series
  @override
  void paint(Canvas canvas, Size size) {
    _stackedRectPainter(canvas, seriesRenderer, chartState, painterKey);
  }

  @override
  bool shouldRepaint(_StackedColumn100ChartPainter oldDelegate) => isRepaint;
}
