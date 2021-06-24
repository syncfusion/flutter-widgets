part of charts;

/// This class has the properties of the crosshair behavior.
///
/// Crosshair behavior has the activation mode and line type property to set the behavior of the crosshair.
/// It also has the property to customize the appearance.
///
/// Provide options for activation mode, line type, line color, line width, hide delay for customizing the
/// behavior of the crosshair.
///
class CrosshairBehavior {
  /// Creating an argument constructor of CrosshairBehavior class.
  CrosshairBehavior({
    this.activationMode = ActivationMode.longPress,
    this.lineType = CrosshairLineType.both,
    this.lineDashArray,
    this.enable = false,
    this.lineColor,
    this.lineWidth = 1,
    this.shouldAlwaysShow = false,
    this.hideDelay = 0,
  });

  /// Toggles the visibility of the crosshair.
  ///
  ///Defaults to `false`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           crosshairBehavior: CrosshairBehavior(enable: true),
  ///        ));
  ///}
  ///```
  final bool enable;

  /// Width of the crosshair line.
  ///
  /// Defaults to `1`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           crosshairBehavior: CrosshairBehavior(
  ///                   enable: true, lineWidth: 5),
  ///        ));
  ///}
  ///```
  final double lineWidth;

  ///Color of the crosshair line.
  ///
  /// Color will be applied based on the brightness
  ///property of the app.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           crosshairBehavior: CrosshairBehavior(
  ///                   enable: true, lineColor: Colors.red),
  ///        ));
  ///}
  ///```
  final Color? lineColor;

  /// Dashes of the crosshair line.
  ///
  /// Any number of values can be provided in the list.
  /// Odd value is considered as rendering size and even value is considered as gap.
  ///
  /// Dafaults to `[0,0]`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           crosshairBehavior: CrosshairBehavior(
  ///                   enable: true, lineDashArray: [10,10]),
  ///        ));
  ///}
  ///```
  final List<double>? lineDashArray;

  /// Gesture for activating the crosshair.
  ///
  /// Crosshair can be activated in tap, double tap
  /// and long press.
  ///
  /// Defaults to `ActivationMode.longPress`
  ///
  /// Also refer [ActivationMode]
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           crosshairBehavior: CrosshairBehavior(
  ///               enable: true, activationMode: ActivationMode.doubleTap),
  ///        ));
  ///}
  ///```
  final ActivationMode activationMode;

  /// Type of crosshair line.
  ///
  /// By default, both vertical and horizontal lines will be
  /// displayed. You can change this by specifying values to this property.
  ///
  /// Defaults to `CrosshairLineType.both`
  ///
  /// Also refer CrosshairLineType
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           crosshairBehavior: CrosshairBehavior(
  ///                 enable: true, lineType: CrosshairLineType.horizontal),
  ///        ));
  ///}
  ///```
  final CrosshairLineType lineType;

  /// Enables or disables the crosshair.
  ///
  /// By default, the crosshair will be hidden on touch.
  /// To avoid this, set this property to true.
  ///
  /// Defaults to `false`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           crosshairBehavior: CrosshairBehavior(enable: true, shouldAlwaysShow: true),
  ///        ));
  ///}
  ///```
  final bool shouldAlwaysShow;

  ///Time delay for hiding the crosshair.
  ///
  /// Defaults to `0`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           crosshairBehavior: CrosshairBehavior(enable: true, duration: 3000),
  ///        ));
  ///}
  ///```
  final double hideDelay;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is CrosshairBehavior &&
        other.activationMode == activationMode &&
        other.lineType == lineType &&
        other.lineDashArray == lineDashArray &&
        other.enable == enable &&
        other.lineColor == lineColor &&
        other.lineWidth == lineWidth &&
        other.shouldAlwaysShow == shouldAlwaysShow &&
        other.hideDelay == hideDelay;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    final List<Object?> values = <Object?>[
      activationMode,
      lineType,
      lineDashArray,
      enable,
      lineColor,
      lineWidth,
      shouldAlwaysShow,
      hideDelay
    ];
    return hashList(values);
  }

  SfCartesianChartState? _chartState;

  /// Displays the crosshair at the specified x and y-positions.
  ///
  ///
  /// x & y - x and y values/pixel where the crosshair needs to be shown.
  ///
  /// coordinateUnit - specify the type of x and y values given.'pixel' or 'point' for logica pixel and chart data point respectively.
  /// Defaults to `'point'`.
  void show(dynamic x, double y, [String coordinateUnit = 'point']) {
    final SfCartesianChartState chartState = _chartState!;
    final CrosshairBehaviorRenderer crosshairBehaviorRenderer =
        chartState._crosshairBehaviorRenderer;
    if (coordinateUnit != 'pixel') {
      final CartesianSeriesRenderer seriesRenderer = crosshairBehaviorRenderer
          ._crosshairPainter!.chartState._chartSeries.visibleSeriesRenderers[0];
      final ChartAxisRenderer xAxisRenderer = seriesRenderer._xAxisRenderer!;
      final _ChartLocation location = _calculatePoint(
          (x is DateTime && xAxisRenderer is! DateTimeCategoryAxisRenderer)
              ? x.millisecondsSinceEpoch
              : ((x is DateTime &&
                      xAxisRenderer is DateTimeCategoryAxisRenderer)
                  ? xAxisRenderer._labels
                      .indexOf(xAxisRenderer._dateFormat.format(x))
                  : ((x is String && xAxisRenderer is CategoryAxisRenderer)
                      ? xAxisRenderer._labels.indexOf(x)
                      : x)),
          y,
          xAxisRenderer,
          seriesRenderer._yAxisRenderer!,
          seriesRenderer._chartState!._requireInvertedAxis,
          seriesRenderer._series,
          seriesRenderer._chartState!._chartAxis._axisClipRect);
      x = location.x;
      y = location.y.truncateToDouble();
    }

    if (crosshairBehaviorRenderer._crosshairPainter != null &&
        activationMode != ActivationMode.none &&
        x != null) {
      crosshairBehaviorRenderer._crosshairPainter!
          ._generateAllPoints(Offset(x.toDouble(), y));
      crosshairBehaviorRenderer._crosshairPainter!.canResetPath = false;
      crosshairBehaviorRenderer._crosshairPainter!.chartState
          ._repaintNotifiers['crosshair']!.value++;
    }
  }

  /// Displays the crosshair at the specified point index.
  ///
  ///
  /// pointIndex - index of point at which the crosshair needs to be shown.
  void showByIndex(int pointIndex) {
    final SfCartesianChartState chartState = _chartState!;
    final CrosshairBehaviorRenderer crosshairBehaviorRenderer =
        chartState._crosshairBehaviorRenderer;
    if (_validIndex(
        pointIndex, 0, crosshairBehaviorRenderer._crosshairPainter!.chart)) {
      if (crosshairBehaviorRenderer._crosshairPainter != null &&
          activationMode != ActivationMode.none) {
        final List<CartesianSeriesRenderer> visibleSeriesRenderer =
            crosshairBehaviorRenderer._crosshairPainter!.chartState._chartSeries
                .visibleSeriesRenderers;
        final CartesianSeriesRenderer seriesRenderer = visibleSeriesRenderer[0];
        crosshairBehaviorRenderer._crosshairPainter!._generateAllPoints(Offset(
            seriesRenderer._dataPoints[pointIndex].markerPoint!.x,
            seriesRenderer._dataPoints[pointIndex].markerPoint!.y));
        crosshairBehaviorRenderer._crosshairPainter!.canResetPath = false;
        crosshairBehaviorRenderer._crosshairPainter!.chartState
            ._repaintNotifiers['crosshair']!.value++;
      }
    }
  }

  /// Hides the crosshair if it is displayed.
  void hide() {
    final SfCartesianChartState chartState = _chartState!;
    final CrosshairBehaviorRenderer crosshairBehaviorRenderer =
        chartState._crosshairBehaviorRenderer;
    if (crosshairBehaviorRenderer._crosshairPainter != null) {
      crosshairBehaviorRenderer._crosshairPainter!.canResetPath = false;
      ValueNotifier<int>(crosshairBehaviorRenderer._crosshairPainter!.chartState
          ._repaintNotifiers['crosshair']!.value++);
      crosshairBehaviorRenderer._crosshairPainter!.timer?.cancel();
      if (!chartState._isTouchUp) {
        crosshairBehaviorRenderer._crosshairPainter!.chartState
            ._repaintNotifiers['crosshair']!.value++;
        crosshairBehaviorRenderer._crosshairPainter!.canResetPath = true;
      } else {
        if (!shouldAlwaysShow) {
          final double duration = (hideDelay == 0 &&
                  crosshairBehaviorRenderer
                      ._crosshairPainter!.chartState._enableDoubleTap)
              ? 200
              : hideDelay;
          crosshairBehaviorRenderer._crosshairPainter!.timer =
              Timer(Duration(milliseconds: duration.toInt()), () {
            crosshairBehaviorRenderer._crosshairPainter!.chartState
                ._repaintNotifiers['crosshair']!.value++;
            crosshairBehaviorRenderer._crosshairPainter!.canResetPath = true;
          });
        }
      }
    }
  }
}

/// Cross hair renderer class for mutable fields and methods
class CrosshairBehaviorRenderer with ChartBehavior {
  /// Creates an argument constructor for Crosshair renderer class
  CrosshairBehaviorRenderer(this._chartState);

  SfCartesianChart get _chart => _chartState._chart;

  final SfCartesianChartState _chartState;

  CrosshairBehavior get _crosshairBehavior => _chart.crosshairBehavior;

  /// Touch position
  Offset? _position;

  /// Holds the instance of CrosshairPainter
  _CrosshairPainter? _crosshairPainter;

  /// Check whether long press activated or not.
  //ignore: prefer_final_fields
  bool _isLongPressActivated = false;

  /// Enables the crosshair on double tap.
  @override
  void onDoubleTap(double xPos, double yPos) =>
      _crosshairBehavior.show(xPos, yPos, 'pixel');

  /// Enables the crosshair on long press.
  @override
  void onLongPress(double xPos, double yPos) =>
      _crosshairBehavior.show(xPos, yPos, 'pixel');

  /// Enables the crosshair on touch down.
  @override
  void onTouchDown(double xPos, double yPos) =>
      _crosshairBehavior.show(xPos, yPos, 'pixel');

  /// Enables the crosshair on touch move.
  @override
  void onTouchMove(double xPos, double yPos) =>
      _crosshairBehavior.show(xPos, yPos, 'pixel');

  /// Enables the crosshair on touch up.
  @override
  void onTouchUp(double xPos, double yPos) => _crosshairBehavior.hide();

  /// Enables the crosshair on mouse hover.
  @override
  void onEnter(double xPos, double yPos) =>
      _crosshairBehavior.show(xPos, yPos, 'pixel');

  /// Disables the crosshair on mouse exit.
  @override
  void onExit(double xPos, double yPos) => _crosshairBehavior.hide();

  /// Draws the crosshair.
  @override
  void onPaint(Canvas canvas) {
    if (_crosshairPainter != null) {
      _crosshairPainter!._drawCrosshair(canvas);
    }
  }

  /// To draw cross hair line
  void _drawLine(Canvas canvas, Paint? paint, int? seriesIndex) {
    assert(_crosshairBehavior.lineWidth >= 0,
        'Line width value of crosshair should be greater than 0.');
    if (_crosshairPainter != null && paint != null) {
      _crosshairPainter!._drawCrosshairLine(canvas, paint, seriesIndex);
    }
  }

  Paint? _linePainter(Paint paint) => _crosshairPainter?._getLinePainter(paint);
}
