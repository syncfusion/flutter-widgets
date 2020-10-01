part of charts;

class _StackedColummnChartPainter extends CustomPainter {
  _StackedColummnChartPainter(
      {this.chartState,
      this.seriesRenderer,
      this.isRepaint,
      this.animationController,
      ValueNotifier<num> notifier,
      this.painterKey})
      : chart = chartState._chart,
        super(repaint: notifier);
  final SfCartesianChartState chartState;
  final SfCartesianChart chart;
  CartesianChartPoint<dynamic> point;
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
