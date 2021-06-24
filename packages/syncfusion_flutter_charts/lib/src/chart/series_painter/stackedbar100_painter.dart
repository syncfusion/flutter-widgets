part of charts;

class _StackedBar100ChartPainter extends CustomPainter {
  _StackedBar100ChartPainter({
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
  final StackedBar100SeriesRenderer seriesRenderer;
  final _PainterKey painterKey;
  //ignore: unused_field
  // static double animation;

  /// Painter method for stacked bar 100 series
  @override
  void paint(Canvas canvas, Size size) {
    _stackedRectPainter(canvas, seriesRenderer, chartState, painterKey);
  }

  @override
  bool shouldRepaint(_StackedBar100ChartPainter oldDelegate) => isRepaint;
}
