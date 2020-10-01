part of charts;

/// Customizes the trackball.
///
/// Trackball feature displays the tooltip for the data points that are closer to the point where you touch on the chart area.
/// This feature can be enabled using enable property of [TrackballBehavior].
///
/// Provides options to customize the [activationMode], [tooltipDisplayMode], [lineType] and [tooltipSettings].
class TrackballBehavior {
  /// Creating an argument constructor of TrackballBehavior class.
  TrackballBehavior({
    ActivationMode activationMode,
    TrackballLineType lineType,
    TrackballDisplayMode tooltipDisplayMode,
    ChartAlignment tooltipAlignment,
    InteractiveTooltip tooltipSettings,
    this.markerSettings,
    this.lineDashArray,
    this.enable = false,
    this.lineColor,
    this.lineWidth = 1,
    this.shouldAlwaysShow = false,
    double hideDelay,
  })  : activationMode = activationMode ?? ActivationMode.longPress,
        tooltipAlignment = tooltipAlignment ?? ChartAlignment.center,
        hideDelay = hideDelay ?? 0,
        tooltipDisplayMode =
            tooltipDisplayMode ?? TrackballDisplayMode.floatAllPoints,
        tooltipSettings = tooltipSettings ?? InteractiveTooltip(),
        lineType = lineType ?? TrackballLineType.vertical;

  ///Toggles the visibility of the trackball.
  ///
  ///Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(enable: true),
  ///        ));
  ///}
  ///```
  final bool enable;

  ///Width of the track line.
  ///
  ///Defaults to `1`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(enable: true, lineWidth: 5),
  ///        ));
  ///}
  ///```
  final double lineWidth;

  ///Color of the track line.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(enable: true, lineColor: Colors.red),
  ///        ));
  ///}
  ///```
  final Color lineColor;

  ///Dashes of the track line.
  ///
  ///Defaults to `[0,0]`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(enable: true, lineDashArray: [10,10]),
  ///        ));
  ///}``
  final List<double> lineDashArray;

  ///Gesture for activating the trackball.
  ///
  /// Trackball can be activated in tap, double tap and long press.
  ///
  ///Defaults to `ActivationMode.longPress`.
  ///
  ///Also refer [ActivationMode]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(
  ///           enable: true,
  ///           activationMode: ActivationMode.doubleTap
  ///          ),
  ///        ));
  ///}
  ///```
  final ActivationMode activationMode;

  ///Alignment of the trackball tooltip.
  ///
  /// The trackball tooltip can be aligned at the top, bottom, and center position of the chart.
  ///
  /// _Note:_ This is applicable only when the tooltipDisplay mode is set to groupAllPoints.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(
  ///           enable: true,
  ///           tooltipAlignment: ChartAlignment.far,
  ///           tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
  ///          ),
  ///        ));
  ///}
  ///```
  final ChartAlignment tooltipAlignment;

  ///Type of trackball line. By default, vertical line will be displayed.
  ///
  /// You can change this by specifying values to this property.

  ///
  ///Defaults to `TrackballLineType.vertical`.
  ///
  ///Also refer [TrackballLineType]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(
  ///           enable: true,
  ///           lineType: TrackballLineType.horizontal
  ///        ),
  ///        ));
  ///}
  ///```
  final TrackballLineType lineType;

  ///Display mode of tooltip.
  ///
  /// By default, tooltip of all the series under the current point index value will be shown.
  ///
  ///Defaults to `TrackballDisplayMode.floatAllPoints`.
  ///
  ///Also refer [TrackballDisplayMode]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(
  ///            enable: true,
  ///            tooltipDisplayMode: TrackballDisplayMode.floatAllPoints
  ///         ),
  ///        ));
  ///}
  ///```
  final TrackballDisplayMode tooltipDisplayMode;

  ///Shows or hides the trackball.
  ///
  /// By default, the trackball will be hidden on touch. To avoid this, set this property to true.
  ///
  ///Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(enable: true, shouldAlwaysShow: true),
  ///        ));
  ///}
  ///```
  final bool shouldAlwaysShow;

  ///Customizes the trackball tooltip.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(
  ///           tooltipSettings: InteractiveTooltip(
  ///            enable: true
  ///        ),
  ///        ),
  ///        ));
  ///}
  ///```
  InteractiveTooltip tooltipSettings;

  ///Giving disappear delay for trackball
  ///
  /// Defaults to `0`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(
  ///             duration: 2000,
  ///             enable: true
  ///        ),
  ///        ));
  ///}
  ///```
  final double hideDelay;

  SfCartesianChartState _chartState;

  ///Options to customize the markers that are displayed when trackball is enabled.
  ///
  ///Trackball markers are used to provide information about the exact point location,
  /// when the trackball is visible. You can add a shape to adorn each data point.
  /// Trackball markers can be enabled by using the [markerVisibility] property
  /// in [TrackballMarkerSettings].
  ///
  ///Provides the options like color, border width, border color and shape of the
  /// marker to customize the appearance.
  final TrackballMarkerSettings markerSettings;

  /// Displays the trackball at the specified x and y-positions.
  ///
  /// *x and y - x & y pixels/values at which the trackball needs to be shown.
  ///
  /// coordinateUnit - specify the type of x and y values given.
  ///
  /// 'pixel' or 'point' for logical pixel and chart data point respectively.
  ///
  /// Defaults to 'point'.
  void show(dynamic x, double y, [String coordinateUnit]) {
    final SfCartesianChartState chartState = _chartState;
    final TrackballBehaviorRenderer trackballBehaviorRenderer =
        chartState._trackballBehaviorRenderer;
    final List<CartesianSeriesRenderer> visibleSeriesRenderer =
        trackballBehaviorRenderer
            ._trackballPainter.chartState._chartSeries.visibleSeriesRenderers;
    final CartesianSeriesRenderer seriesRenderer = visibleSeriesRenderer[0];
    if (trackballBehaviorRenderer._trackballPainter != null &&
        activationMode != ActivationMode.none) {
      if (coordinateUnit != 'pixel') {
        trackballBehaviorRenderer
            ._trackballPainter.chartState._trackballWithoutTouch = false;
        final _ChartLocation location = _calculatePoint(
            x is DateTime ? x.millisecondsSinceEpoch : x,
            y,
            seriesRenderer._xAxisRenderer,
            seriesRenderer._yAxisRenderer,
            seriesRenderer._chartState._requireInvertedAxis,
            seriesRenderer._series,
            seriesRenderer._chartState._chartAxis._axisClipRect);
        x = location.x;
        y = location.y;
      }
      trackballBehaviorRenderer._trackballPainter
          ._generateAllPoints(Offset(x.toDouble(), y));
    }

    trackballBehaviorRenderer._trackballPainter.canResetPath = false;
    if (trackballBehaviorRenderer
        ._trackballPainter.chartState._trackballWithoutTouch) {
      trackballBehaviorRenderer
          ._trackballPainter.chartState._trackballRepaintNotifier.value++;
    }
  }

  /// Displays the trackball at the specified point index.
  ///
  /// * pointIndex - index of the point for which the trackball must be shown
  void showByIndex(int pointIndex) {
    final SfCartesianChartState chartState = _chartState;
    final TrackballBehaviorRenderer trackballBehaviorRenderer =
        chartState._trackballBehaviorRenderer;
    if (trackballBehaviorRenderer._trackballPainter != null &&
        activationMode != ActivationMode.none) {
      if (_validIndex(
          pointIndex, 0, trackballBehaviorRenderer._trackballPainter.chart)) {
        trackballBehaviorRenderer._trackballPainter.showTrackball(
            trackballBehaviorRenderer._trackballPainter.chartState._chartSeries
                .visibleSeriesRenderers,
            pointIndex);
      }
      trackballBehaviorRenderer._trackballPainter.canResetPath = false;
    }
  }

  /// Hides the trackball if it is displayed.
  void hide() {
    final SfCartesianChartState chartState = _chartState;
    final TrackballBehaviorRenderer trackballBehaviorRenderer =
        chartState._trackballBehaviorRenderer;
    if (trackballBehaviorRenderer._trackballPainter != null &&
        activationMode != ActivationMode.none) {
      trackballBehaviorRenderer._trackballPainter.canResetPath = false;
      ValueNotifier<int>(trackballBehaviorRenderer
          ._trackballPainter.chartState._trackballRepaintNotifier.value++);
      if (trackballBehaviorRenderer._trackballPainter.timer != null) {
        trackballBehaviorRenderer._trackballPainter.timer.cancel();
      }
      final double duration = shouldAlwaysShow ||
              (hideDelay == 0 &&
                  trackballBehaviorRenderer
                      ._trackballPainter.chartState._enableDoubleTap)
          ? 200
          : hideDelay;
      trackballBehaviorRenderer._trackballPainter.timer =
          Timer(Duration(milliseconds: duration.toInt()), () {
        trackballBehaviorRenderer
            ._trackballPainter.chartState._trackballRepaintNotifier.value++;
        trackballBehaviorRenderer._trackballPainter.canResetPath = true;
      });
    }
  }
}

///Trackball behavior renderer class for mutable fields and methods
class TrackballBehaviorRenderer with ChartBehavior {
  /// Creates an argument constructor for Trackball renderer class
  TrackballBehaviorRenderer(this._chartState);

  SfCartesianChart get _chart => _chartState._chart;

  final SfCartesianChartState _chartState;

  TrackballBehavior get _trackballBehavior => _chart.trackballBehavior;

  /// Check whether long press activated or not .
  bool _isLongPressActivated;

  /// Touch position
  Offset _position;

  /// Holds the instance of trackballPainter.
  _TrackballPainter _trackballPainter;

  /// Performs the double-tap action.
  ///
  /// Hits while double tapping on the chart.
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  @override
  void onDoubleTap(double xPos, double yPos) =>
      _trackballBehavior.show(xPos, yPos, 'pixel');

  /// Performs the long press action.
  ///
  /// Hits while a long tap on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  @override
  void onLongPress(double xPos, double yPos) =>
      _trackballBehavior.show(xPos, yPos, 'pixel');

  /// Performs the touch-down action.
  ///
  /// Hits while tapping on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  @override
  void onTouchDown(double xPos, double yPos) =>
      _trackballBehavior.show(xPos, yPos, 'pixel');

  /// Performs the touch-move action.
  ///
  /// Hits while tap and moving on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// *  yPos - Y value of the touch position.
  @override
  void onTouchMove(double xPos, double yPos) =>
      _trackballBehavior.show(xPos, yPos, 'pixel');

  /// Performs the touch-up action.
  ///
  /// Hits while release tap on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  @override
  void onTouchUp(double xPos, double yPos) => _trackballBehavior.hide();

  /// Performs the mouse-hover action.
  ///
  /// Hits while enter tap on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  @override
  void onEnter(double xPos, double yPos) =>
      _trackballBehavior.show(xPos, yPos, 'pixel');

  /// performs the mouse-exit action.
  ///
  /// Hits while exit tap on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  @override
  void onExit(double xPos, double yPos) => _trackballBehavior.hide();

  /// Draws trackball
  ///
  /// * canvas - Canvas used to draw the Track line on the chart.
  @override
  void onPaint(Canvas canvas) {
    if (_trackballPainter != null && !_trackballPainter.canResetPath) {
      _trackballPainter._drawTrackball(canvas);
    }
  }

  /// To draw trackball line
  void _drawLine(Canvas canvas, Paint paint, int seriesIndex) {
    if (_trackballPainter != null) {
      _trackballPainter._drawTrackBallLine(canvas, paint, seriesIndex);
    }
  }

  Paint _linePainter(Paint paint) => _trackballPainter?._getLinePainter(paint);
}

///Trackball marker renderer class for mutable fields and methods
class TrackballMarkerSettingsRenderer {
  /// Creates an argument constructor for TrackballMarkerSettings class
  TrackballMarkerSettingsRenderer(this._trackballMarkerSettings);

  ///ignore: unused_field
  final TrackballMarkerSettings _trackballMarkerSettings;

  dart_ui.Image _image;
}
