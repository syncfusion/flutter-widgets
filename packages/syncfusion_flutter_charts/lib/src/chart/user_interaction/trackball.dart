part of charts;

/// Customizes the trackball.
///
/// Trackball feature displays the tooltip for the data points that are closer to the point where you touch on the chart area.
/// This feature can be enabled using enable property of [TrackballBehavior].
///
/// Provides options to customize the [activationMode], [tooltipDisplayMode], [lineType] and [tooltipSettings].
@immutable
class TrackballBehavior {
  /// Creating an argument constructor of TrackballBehavior class.
  TrackballBehavior({
    this.activationMode = ActivationMode.longPress,
    this.lineType = TrackballLineType.vertical,
    this.tooltipDisplayMode = TrackballDisplayMode.floatAllPoints,
    this.tooltipAlignment = ChartAlignment.center,
    this.tooltipSettings = const InteractiveTooltip(),
    this.markerSettings,
    this.lineDashArray,
    this.enable = false,
    this.lineColor,
    this.lineWidth = 1,
    this.shouldAlwaysShow = false,
    this.builder,
    this.hideDelay = 0,
  });

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
  final Color? lineColor;

  ///Dashes of the track line.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(enable: true, lineDashArray: [10,10]),
  ///        ));
  ///}``
  final List<double>? lineDashArray;

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

  ///Builder of the trackball tooltip.
  ///
  ///Add any custom widget as the trackball template.
  ///
  ///If the trackball display mode is `groupAllPoints` or `nearestPoint` it will called once and if it is
  /// `floatAllPoints`, it will be called for each point.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(
  ///           enable: true,
  ///           builder: (BuildContext context, TrackballDetails trackballDetails) {
  ///           return Container(
  ///                        height: _selectDisplayMode ==
  ///                                    TrackballDisplayMode.floatAllPoints ||
  ///                                _selectDisplayMode ==
  ///                                    TrackballDisplayMode.nearestPoint
  ///                            ? 50
  ///                            : 75,
  ///                        width: 100,
  ///                        decoration: const BoxDecoration(
  ///                            color: Color.fromRGBO(66, 244, 164, 1)),
  ///                        child: Row(
  ///                          children: <Widget>[
  ///                            Container(
  ///                                width: 50,
  ///                                child: Image.asset('images/bike.png')),
  ///                            _selectDisplayMode ==
  ///                                        TrackballDisplayMode.floatAllPoints ||
  ///                                    _selectDisplayMode ==
  ///                                        TrackballDisplayMode.nearestPoint
  ///                                ? Container(
  ///                                    width: 50,
  ///                                    child: Column(
  ///                                     children: <Widget>[
  ///                                        Container(
  ///                                            height: 25,
  ///                                            alignment: Alignment.center,
  ///                                            child: Text(
  ///                                                '${trackballDetails.point.x.toString()}')),
  ///                                        Container(
  ///                                            height: 25,
  ///                                            alignment: Alignment.center,
  ///                                           child: Text(
  ///                                                '${trackballDetails.point.y.toString()}'))
  ///                                      ],
  ///                                    ))
  ///                                : Container(
  ///                                    width: 50,
  ///                                    child: Column(
  ///                                      children: <Widget>[
  ///                                        Container(
  ///                                            height: 25,
  ///                                            alignment: Alignment.center,
  ///                                            child: Text(
  ///                                                '${trackballDetails.dataValues[0].toString()}')),
  ///                                        Container(
  ///                                            height: 25,
  ///                                            alignment: Alignment.center,
  ///                                            child: Text(
  ///                                                '${trackballDetails.dataValues[1].toString()}')),
  ///                                        Container(
  ///                                            height: 25,
  ///                                            alignment: Alignment.center,
  ///                                            child: Text(
  ///                                                '${trackballDetails.dataValues[3].toString()}'))
  ///                                      ],
  ///                                    ))
  ///                         ],
  ///                        ));
  ///         }),
  ///        ));
  ///}
  ///```
  final ChartTrackballBuilder<dynamic>? builder;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is TrackballBehavior &&
        other.activationMode == activationMode &&
        other.lineType == lineType &&
        other.tooltipDisplayMode == tooltipDisplayMode &&
        other.tooltipAlignment == tooltipAlignment &&
        other.tooltipSettings == tooltipSettings &&
        other.lineDashArray == lineDashArray &&
        other.markerSettings == markerSettings &&
        other.enable == enable &&
        other.lineColor == lineColor &&
        other.lineWidth == lineWidth &&
        other.shouldAlwaysShow == shouldAlwaysShow &&
        other.builder == builder &&
        other.hideDelay == hideDelay;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      activationMode,
      lineType,
      tooltipDisplayMode,
      tooltipAlignment,
      tooltipSettings,
      markerSettings,
      lineDashArray,
      enable,
      lineColor,
      lineWidth,
      shouldAlwaysShow,
      builder,
      hideDelay
    ];
    return hashList(values);
  }

  SfCartesianChartState? _chartState;

  ///Options to customize the markers that are displayed when trackball is enabled.
  ///
  ///Trackball markers are used to provide information about the exact point location,
  /// when the trackball is visible. You can add a shape to adorn each data point.
  /// Trackball markers can be enabled by using the `markerVisibility` property
  /// in [TrackballMarkerSettings].
  ///
  ///Provides the options like color, border width, border color and shape of the
  /// marker to customize the appearance.
  final TrackballMarkerSettings? markerSettings;

  /// Displays the trackball at the specified x and y-positions.
  ///
  /// *x and y - x & y pixels/values at which the trackball needs to be shown.
  ///
  /// coordinateUnit - specify the type of x and y values given.
  ///
  /// 'pixel' or 'point' for logical pixel and chart data point respectively.
  ///
  /// Defaults to 'point'.
  void show(dynamic x, double y, [String coordinateUnit = 'point']) {
    final SfCartesianChartState chartState = _chartState!;
    final TrackballBehaviorRenderer trackballBehaviorRenderer =
        chartState._trackballBehaviorRenderer;
    final List<CartesianSeriesRenderer> visibleSeriesRenderer =
        chartState._chartSeries.visibleSeriesRenderers;
    final CartesianSeriesRenderer seriesRenderer = visibleSeriesRenderer[0];
    if ((trackballBehaviorRenderer._trackballPainter != null ||
            builder != null) &&
        activationMode != ActivationMode.none) {
      final ChartAxisRenderer xAxisRenderer = seriesRenderer._xAxisRenderer!;
      if (coordinateUnit != 'pixel') {
        final _ChartLocation location = _calculatePoint(
            (x is DateTime && (xAxisRenderer is! DateTimeCategoryAxisRenderer))
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
        y = location.y;
      }
      if (trackballBehaviorRenderer._trackballPainter != null) {
        trackballBehaviorRenderer._isTrackballTemplate = false;
        trackballBehaviorRenderer._generateAllPoints(Offset(x.toDouble(), y));
      } else if (builder != null && (!trackballBehaviorRenderer._isMoving)) {
        trackballBehaviorRenderer
            ._showTemplateTrackball(Offset(x.toDouble(), y));
      }
    }

    if (trackballBehaviorRenderer._trackballPainter != null) {
      trackballBehaviorRenderer._trackballPainter!.canResetPath = false;
      chartState._repaintNotifiers['trackball']!.value++;
    }
  }

  /// Displays the trackball at the specified point index.
  ///
  /// * pointIndex - index of the point for which the trackball must be shown
  void showByIndex(int pointIndex) {
    final SfCartesianChartState chartState = _chartState!;
    final TrackballBehaviorRenderer trackballBehaviorRenderer =
        chartState._trackballBehaviorRenderer;
    if ((trackballBehaviorRenderer._trackballPainter != null ||
            builder != null) &&
        activationMode != ActivationMode.none) {
      if (_validIndex(pointIndex, 0, chartState._chart)) {
        trackballBehaviorRenderer._showTrackball(
            chartState._chartSeries.visibleSeriesRenderers,
            pointIndex,
            trackballBehaviorRenderer);
      }
      if (trackballBehaviorRenderer._trackballPainter != null) {
        trackballBehaviorRenderer._trackballPainter!.canResetPath = false;
        trackballBehaviorRenderer._trackballPainter!.chartState
            ._repaintNotifiers['trackball']!.value++;
      }
    }
  }

  /// Hides the trackball if it is displayed.
  void hide() {
    final SfCartesianChartState chartState = _chartState!;
    final TrackballBehaviorRenderer trackballBehaviorRenderer =
        chartState._trackballBehaviorRenderer;
    if (trackballBehaviorRenderer._trackballPainter != null &&
        !trackballBehaviorRenderer._isTrackballTemplate &&
        activationMode != ActivationMode.none) {
      if (chartState._chart.trackballBehavior.activationMode ==
          ActivationMode.doubleTap) {
        trackballBehaviorRenderer._trackballPainter!.canResetPath = false;
        ValueNotifier<int>(trackballBehaviorRenderer._trackballPainter!
            .chartState._repaintNotifiers['trackball']!.value++);
        if (trackballBehaviorRenderer._trackballPainter!.timer != null) {
          trackballBehaviorRenderer._trackballPainter!.timer?.cancel();
        }
      }
      if (!_chartState!._isTouchUp) {
        trackballBehaviorRenderer._trackballPainter!.chartState
            ._repaintNotifiers['trackball']!.value++;
        trackballBehaviorRenderer._trackballPainter!.canResetPath = true;
      } else {
        final double duration =
            (hideDelay == 0 && chartState._enableDoubleTap) ? 200 : hideDelay;
        if (!shouldAlwaysShow) {
          trackballBehaviorRenderer._trackballPainter!.timer =
              Timer(Duration(milliseconds: duration.toInt()), () {
            trackballBehaviorRenderer._trackballPainter!.chartState
                ._repaintNotifiers['trackball']!.value++;
            trackballBehaviorRenderer._trackballPainter!.canResetPath = true;
          });
        }
      }
    } else if (trackballBehaviorRenderer._trackballTemplate != null) {
      final GlobalKey key =
          trackballBehaviorRenderer._trackballTemplate!.key as GlobalKey;
      final _TrackballTemplateState? trackballTemplateState =
          key.currentState as _TrackballTemplateState;
      final double duration =
          shouldAlwaysShow || (hideDelay == 0 && chartState._enableDoubleTap)
              ? 200
              : hideDelay;
      trackballTemplateState?._trackballTimer =
          Timer(Duration(milliseconds: duration.toInt()), () {
        trackballTemplateState.hideTrackballTemplate();
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
  // ignore: prefer_final_fields
  bool _isLongPressActivated = false;

  /// check whether onPointerMove or not.
  // ignore: prefer_final_fields
  bool _isMoving = false;

  /// Touch position
  late Offset _tapPosition;

  /// Holds the instance of trackballPainter!.
  _TrackballPainter? _trackballPainter;
  _TrackballTemplate? _trackballTemplate;
  List<num> _visibleLocation = <num>[];
  final List<Path> _markerShapes = <Path>[];
  late Rect _axisClipRect;

  //ignore: unused_field
  late double _xPos;
  //ignore: unused_field
  late double _yPos;
  List<CartesianChartPoint<dynamic>> _points = <CartesianChartPoint<dynamic>>[];
  List<int> _currentPointIndices = <int>[];
  List<int> _visibleSeriesIndices = <int>[];
  List<CartesianSeries<dynamic, dynamic>> _visibleSeriesList =
      <CartesianSeries<dynamic, dynamic>>[];
  late TrackballGroupingModeInfo _groupingModeInfo;
  List<_ChartPointInfo> _chartPointInfo = <_ChartPointInfo>[];
  List<num> _tooltipTop = <num>[];
  List<num> _tooltipBottom = <num>[];
  final List<ChartAxisRenderer> _xAxesInfo = <ChartAxisRenderer>[];
  final List<ChartAxisRenderer> _yAxesInfo = <ChartAxisRenderer>[];
  List<_ClosestPoints> _visiblePoints = <_ClosestPoints>[];
  _TooltipPositions? _tooltipPosition;
  late num _tooltipPadding;
  bool _isRangeSeries = false;
  bool _isBoxSeries = false;
  bool _isTrackballTemplate = false;

  /// To render the trackball marker for both tooltip and template
  void _trackballMarker(int index) {
    if (_trackballBehavior.markerSettings != null &&
        (_trackballBehavior.markerSettings!.markerVisibility ==
                TrackballVisibilityMode.auto
            ? (_chartPointInfo[index]
                .seriesRenderer!
                ._series
                .markerSettings
                .isVisible)
            : _trackballBehavior.markerSettings!.markerVisibility ==
                TrackballVisibilityMode.visible)) {
      final MarkerSettings markerSettings = _trackballBehavior.markerSettings!;
      final DataMarkerType markerType = markerSettings.shape;
      final Size size = Size(markerSettings.width, markerSettings.height);
      final String seriesType =
          _chartPointInfo[index].seriesRenderer!._seriesType;
      _chartPointInfo[index].seriesRenderer!._isMarkerRenderEvent = true;
      _markerShapes.add(_getMarkerShapesPath(
          markerType,
          Offset(
              _chartPointInfo[index].xPosition!,
              seriesType.contains('range') ||
                      seriesType.contains('hilo') ||
                      seriesType == 'candle'
                  ? _chartPointInfo[index].highYPosition!
                  : seriesType == 'boxandwhisker'
                      ? _chartPointInfo[index].maxYPosition!
                      : _chartPointInfo[index].yPosition!),
          size,
          _chartPointInfo[index].seriesRenderer,
          null,
          _trackballBehavior));
    }
  }

  /// To show track ball based on point index
  void _showTrackball(List<CartesianSeriesRenderer> visibleSeriesRenderers,
      int pointIndex, TrackballBehaviorRenderer trackballBehaviorRenderer) {
    _ChartLocation position;
    final CartesianSeriesRenderer seriesRenderer = visibleSeriesRenderers[0];
    final Rect rect = seriesRenderer._chartState!._chartAxis._axisClipRect;
    final List<CartesianChartPoint<dynamic>> dataPoints =
        <CartesianChartPoint<dynamic>>[];
    for (int i = 0; i < seriesRenderer._dataPoints.length; i++) {
      if (seriesRenderer._dataPoints[i].isGap != true) {
        dataPoints.add(seriesRenderer._dataPoints[i]);
      }
    }
    // ignore: unnecessary_null_comparison
    assert(pointIndex != null, 'Point index must not be null');
// ignore: unnecessary_null_comparison
    if (pointIndex != null &&
        pointIndex.abs() < seriesRenderer._dataPoints.length) {
      final int index = pointIndex;
      final num xValue = seriesRenderer._dataPoints[index].xValue;
      final num yValue =
          seriesRenderer._series is _FinancialSeriesBase<dynamic, dynamic> ||
                  seriesRenderer._seriesType.contains('range')
              ? seriesRenderer._dataPoints[index].high
              : seriesRenderer._dataPoints[index].yValue;
      position = _calculatePoint(
          xValue,
          yValue,
          seriesRenderer._xAxisRenderer!,
          seriesRenderer._yAxisRenderer!,
          seriesRenderer._chartState!._requireInvertedAxis,
          seriesRenderer._series,
          rect);
      if (trackballBehaviorRenderer._trackballPainter != null) {
        seriesRenderer._chartState!._trackballBehaviorRenderer
            ._generateAllPoints(Offset(position.x, position.y));
      } else if (_trackballBehavior.builder != null) {
        trackballBehaviorRenderer
            ._showTemplateTrackball(Offset(position.x, position.y));
      }
    }
  }

  void _showTemplateTrackball(Offset position) {
    final GlobalKey key = _trackballTemplate!.key as GlobalKey;
    final _TrackballTemplateState trackballTemplateState =
        key.currentState as _TrackballTemplateState;
    _tapPosition = position;
    trackballTemplateState._alwaysShow = _trackballBehavior.shouldAlwaysShow;
    trackballTemplateState._duration =
        _trackballBehavior.hideDelay == 0 ? 200 : _trackballBehavior.hideDelay;
    _isTrackballTemplate = true;
    _generateAllPoints(position);
    CartesianChartPoint<dynamic> dataPoint;
    for (int index = 0; index < _chartPointInfo.length; index++) {
      dataPoint = _chartPointInfo[index]
          .seriesRenderer!
          ._dataPoints[_chartPointInfo[index].dataPointIndex!];
      if (_trackballBehavior.tooltipDisplayMode ==
          TrackballDisplayMode.groupAllPoints) {
        _points.add(dataPoint);
        _currentPointIndices.add(_chartPointInfo[index].dataPointIndex!);
        _visibleSeriesIndices.add(_chartState
            ._chartSeries.visibleSeriesRenderers
            .indexOf(_chartPointInfo[index].seriesRenderer!));
        _visibleSeriesList.add(_chartPointInfo[index].seriesRenderer!._series);
      }
      _trackballMarker(index);
    }
    _groupingModeInfo = TrackballGroupingModeInfo(_points, _currentPointIndices,
        _visibleSeriesIndices, _visibleSeriesList);
    assert(trackballTemplateState.mounted,
        'Template state which must be mounted before accessing to avoid rebuilding');
    if (trackballTemplateState.mounted &&
        _trackballBehavior.tooltipDisplayMode ==
            TrackballDisplayMode.groupAllPoints) {
      trackballTemplateState._chartPointInfo = _chartPointInfo;
      trackballTemplateState.groupingModeInfo = _groupingModeInfo;
      trackballTemplateState._markerShapes = _markerShapes;
      trackballTemplateState.refresh();
    } else if (trackballTemplateState.mounted) {
      trackballTemplateState._chartPointInfo = _chartPointInfo;
      trackballTemplateState._markerShapes = _markerShapes;
      trackballTemplateState.refresh();
    }
    _points = <CartesianChartPoint<dynamic>>[];
    _currentPointIndices = <int>[];
    _visibleSeriesIndices = <int>[];
    _visibleSeriesList = <CartesianSeries<dynamic, dynamic>>[];
    _tooltipTop.clear();
    _tooltipBottom.clear();
  }

  /// calculate trackball points
  void _generateAllPoints(Offset position) {
    _axisClipRect = _chartState._chartAxis._axisClipRect;
    _tooltipPadding = _chartState._requireInvertedAxis ? 8 : 5;
    _chartPointInfo = <_ChartPointInfo>[];
    _visiblePoints = <_ClosestPoints>[];
    _markerShapes.clear();
    _tooltipTop = _tooltipBottom = _visibleLocation = <num>[];
    _trackballPainter?._tooltipTop = <num>[];
    _trackballPainter?._tooltipBottom = <num>[];
    final Rect seriesBounds = _axisClipRect;
    _tapPosition = position;
    double? xPos = 0,
        yPos = 0,
        leastX = 0,
        openXPos,
        openYPos,
        closeXPos,
        closeYPos,
        highXPos,
        cummulativePos,
        lowerXPos,
        lowerYPos,
        upperXPos,
        upperYPos,
        lowYPos,
        highYPos,
        minYPos,
        maxYPos,
        maxXPos;
    int seriesIndex = 0, index;
    late CartesianSeriesRenderer cartesianSeriesRenderer;
    ChartAxisRenderer chartAxisRenderer, xAxisRenderer, yAxisRenderer;
    CartesianChartPoint<dynamic> chartDataPoint;
    _ChartAxis chartAxis;
    String seriesType, labelValue, seriesName;
    bool invertedAxis = _chartState._requireInvertedAxis;
    CartesianSeries<dynamic, dynamic> series;
    num? xValue,
        yValue,
        minimumValue,
        maximumValue,
        lowerQuartileValue,
        upperQuartileValue,
        meanValue,
        highValue,
        lowValue,
        openValue,
        closeValue,
        bubbleSize,
        cumulativeValue;
    Rect axisClipRect;
    final TrackballDisplayMode tooltipDisplayMode =
        _chartState._chart.trackballBehavior.tooltipDisplayMode;
    _ChartLocation highLocation, maxLocation;
    chartAxisRenderer = _chartState._seriesRenderers[0]._xAxisRenderer!;
    for (final CartesianSeriesRenderer axisSeriesRenderer
        in chartAxisRenderer._seriesRenderers) {
      cartesianSeriesRenderer = axisSeriesRenderer;
      seriesType = cartesianSeriesRenderer._seriesType;
      _isRangeSeries = seriesType.contains('range') ||
          seriesType.contains('hilo') ||
          seriesType == 'candle';
      _isBoxSeries = seriesType == 'boxandwhisker';
      if (axisSeriesRenderer._visible == false ||
          (axisSeriesRenderer._dataPoints.isEmpty &&
              !axisSeriesRenderer._isRectSeries)) {
        continue;
      }
      if (cartesianSeriesRenderer._dataPoints.isNotEmpty) {
        final List<CartesianChartPoint<dynamic>>? nearestDataPoints =
            _getNearestChartPoints(
                position.dx,
                position.dy,
                cartesianSeriesRenderer._xAxisRenderer!,
                cartesianSeriesRenderer._yAxisRenderer!,
                cartesianSeriesRenderer);
        for (final CartesianChartPoint<dynamic> dataPoint
            in nearestDataPoints!) {
          index = axisSeriesRenderer._dataPoints.indexOf(dataPoint);
          chartDataPoint = cartesianSeriesRenderer._dataPoints[index];
          xAxisRenderer = cartesianSeriesRenderer._xAxisRenderer!;
          yAxisRenderer = cartesianSeriesRenderer._yAxisRenderer!;
          chartAxis = cartesianSeriesRenderer._chartState!._chartAxis;
          invertedAxis = _chartState._requireInvertedAxis;
          series = cartesianSeriesRenderer._series;
          xValue = chartDataPoint.xValue;
          if (seriesType != 'boxandwhisker') {
            yValue = chartDataPoint.yValue;
          }
          minimumValue = chartDataPoint.minimum;
          maximumValue = chartDataPoint.maximum;
          lowerQuartileValue = chartDataPoint.lowerQuartile;
          upperQuartileValue = chartDataPoint.upperQuartile;
          meanValue = chartDataPoint.mean;
          highValue = chartDataPoint.high;
          lowValue = chartDataPoint.low;
          openValue = chartDataPoint.open;
          closeValue = chartDataPoint.close;
          seriesName =
              cartesianSeriesRenderer._series.name ?? 'Series $seriesIndex';
          bubbleSize = chartDataPoint.bubbleSize;
          cumulativeValue = chartDataPoint.cumulativeValue;
          axisClipRect = _calculatePlotOffset(
              chartAxis._axisClipRect,
              Offset(xAxisRenderer._axis.plotOffset,
                  yAxisRenderer._axis.plotOffset));
          cummulativePos = _calculatePoint(
                  xValue!,
                  cumulativeValue,
                  xAxisRenderer,
                  yAxisRenderer,
                  invertedAxis,
                  series,
                  axisClipRect)
              .y;
          xPos = _calculatePoint(
                  xValue,
                  seriesType.contains('stacked') ? cumulativeValue : yValue,
                  xAxisRenderer,
                  yAxisRenderer,
                  invertedAxis,
                  series,
                  axisClipRect)
              .x;
          if (!xPos.toDouble().isNaN) {
            if (seriesIndex == 0 ||
                ((leastX! - position.dx) > (leastX - xPos))) {
              leastX = xPos;
            }
            labelValue = _getTrackballLabelText(
                cartesianSeriesRenderer,
                xValue,
                yValue,
                lowValue,
                highValue,
                openValue,
                closeValue,
                minimumValue,
                maximumValue,
                lowerQuartileValue,
                upperQuartileValue,
                meanValue,
                seriesName,
                bubbleSize,
                cumulativeValue,
                dataPoint);
            yPos = seriesType.contains('stacked')
                ? cummulativePos
                : _calculatePoint(xValue, yValue, xAxisRenderer, yAxisRenderer,
                        invertedAxis, series, axisClipRect)
                    .y;
            if (_isRangeSeries) {
              lowYPos = _calculatePoint(xValue, lowValue, xAxisRenderer,
                      yAxisRenderer, invertedAxis, series, axisClipRect)
                  .y;
              highLocation = _calculatePoint(xValue, highValue, xAxisRenderer,
                  yAxisRenderer, invertedAxis, series, axisClipRect);
              highYPos = highLocation.y;
              highXPos = highLocation.x;
              if (seriesType == 'hiloopenclose' || seriesType == 'candle') {
                openXPos = dataPoint.openPoint!.x;
                openYPos = dataPoint.openPoint!.y;
                closeXPos = dataPoint.closePoint!.x;
                closeYPos = dataPoint.closePoint!.y;
              }
            } else if (seriesType == 'boxandwhisker') {
              minYPos = _calculatePoint(xValue, minimumValue, xAxisRenderer,
                      yAxisRenderer, invertedAxis, series, axisClipRect)
                  .y;
              maxLocation = _calculatePoint(xValue, maximumValue, xAxisRenderer,
                  yAxisRenderer, invertedAxis, series, axisClipRect);
              maxXPos = maxLocation.x;
              maxYPos = maxLocation.y;
              lowerXPos = dataPoint.lowerQuartilePoint!.x;
              lowerYPos = dataPoint.lowerQuartilePoint!.y;
              upperXPos = dataPoint.upperQuartilePoint!.x;
              upperYPos = dataPoint.upperQuartilePoint!.y;
            }
            final Rect rect = seriesBounds.intersect(Rect.fromLTWH(
                xPos - 1,
                _isRangeSeries
                    ? highYPos! - 1
                    : _isBoxSeries
                        ? maxYPos! - 1
                        : yPos - 1,
                2,
                2));
            if (seriesBounds.contains(Offset(
                    xPos,
                    _isRangeSeries
                        ? highYPos!
                        : _isBoxSeries
                            ? maxYPos!
                            : yPos)) ||
                seriesBounds.overlaps(rect)) {
              _visiblePoints.add(_ClosestPoints(
                  closestPointX: !_isRangeSeries
                      ? xPos
                      : _isBoxSeries
                          ? maxXPos!
                          : highXPos!,
                  closestPointY: _isRangeSeries
                      ? highYPos!
                      : _isBoxSeries
                          ? maxYPos!
                          : yPos));
              _addChartPointInfo(
                  cartesianSeriesRenderer,
                  xPos,
                  yPos,
                  index,
                  !_isTrackballTemplate ? labelValue : null,
                  seriesIndex,
                  lowYPos,
                  highXPos,
                  highYPos,
                  openXPos,
                  openYPos,
                  closeXPos,
                  closeYPos,
                  minYPos,
                  maxXPos,
                  maxYPos,
                  lowerXPos,
                  lowerYPos,
                  upperXPos,
                  upperYPos);
              if (tooltipDisplayMode == TrackballDisplayMode.groupAllPoints &&
                  leastX >= seriesBounds.left) {
                invertedAxis ? yPos = leastX : xPos = leastX;
              }
            }
          }
        }
        seriesIndex++;
      }
      _validateNearestXValue(
          leastX!, cartesianSeriesRenderer, position.dx, position.dy);
    }
    if (_visiblePoints.isNotEmpty) {
      invertedAxis
          ? _visiblePoints.sort((_ClosestPoints a, _ClosestPoints b) =>
              a.closestPointX.compareTo(b.closestPointX))
          : _visiblePoints.sort((_ClosestPoints a, _ClosestPoints b) =>
              a.closestPointY.compareTo(b.closestPointY));
    }
    if (_chartPointInfo.isNotEmpty) {
      if (tooltipDisplayMode != TrackballDisplayMode.groupAllPoints) {
        invertedAxis
            ? _chartPointInfo.sort((_ChartPointInfo a, _ChartPointInfo b) =>
                a.xPosition!.compareTo(b.xPosition!))
            : _chartPointInfo.sort((_ChartPointInfo a, _ChartPointInfo b) =>
                a.yPosition!.compareTo(b.yPosition!));
      }
      if (tooltipDisplayMode == TrackballDisplayMode.nearestPoint ||
          (cartesianSeriesRenderer._isRectSeries &&
              tooltipDisplayMode != TrackballDisplayMode.groupAllPoints)) {
        _validateNearestPointForAllSeries(
            leastX!, _chartPointInfo, position.dx, position.dy);
      }
    }
    _triggerTrackballRenderCallback();
  }

  /// Event for trackball render
  void _triggerTrackballRenderCallback() {
    if (_chart.onTrackballPositionChanging != null) {
      _chartState._chartPointInfo =
          _chartState._trackballBehaviorRenderer._chartPointInfo;
      int index;
      for (index = _chartState._chartPointInfo.length - 1;
          index >= 0;
          index--) {
        TrackballArgs chartPoint;
        chartPoint = TrackballArgs();
        chartPoint.chartPointInfo = _chartState._chartPointInfo[index];
        _chart.onTrackballPositionChanging!(chartPoint);
        _chartState._chartPointInfo[index].label =
            chartPoint.chartPointInfo.label;
        _chartState._chartPointInfo[index].header =
            chartPoint.chartPointInfo.header;
        if (_chartState._chartPointInfo[index].label == null ||
            _chartState._chartPointInfo[index].label == '') {
          _chartState._chartPointInfo.removeAt(index);
          _visiblePoints.removeAt(index);
        }
      }
    }
  }

  /// To validate the nearest point in all series for trackball
  void _validateNearestPointForAllSeries(double leastX,
      List<_ChartPointInfo> trackballInfo, double touchXPos, double touchYPos) {
    double xPos = 0, yPos;
    final List<_ChartPointInfo> tempTrackballInfo =
        List<_ChartPointInfo>.from(trackballInfo);
    _ChartPointInfo pointInfo, nextPointInfo, previousPointInfo;
    num? yValue;
    num xValue;
    Rect axisClipRect;
    int pointInfoIndex;
    CartesianChartPoint<dynamic> dataPoint;
    ChartAxisRenderer xAxisRenderer, yAxisRenderer;
    int i;
    for (i = 0; i < tempTrackballInfo.length; i++) {
      pointInfo = tempTrackballInfo[i];
      dataPoint =
          pointInfo.seriesRenderer!._dataPoints[pointInfo.dataPointIndex!];
      xAxisRenderer = pointInfo.seriesRenderer!._xAxisRenderer!;
      yAxisRenderer = pointInfo.seriesRenderer!._yAxisRenderer!;
      xValue = dataPoint.xValue;
      if (pointInfo.seriesRenderer!._seriesType != 'boxandwhisker') {
        yValue = dataPoint.yValue;
      }
      axisClipRect = _calculatePlotOffset(
          pointInfo.seriesRenderer!._chartState!._chartAxis._axisClipRect,
          Offset(
              xAxisRenderer._axis.plotOffset, yAxisRenderer._axis.plotOffset));
      xPos = _calculatePoint(
              xValue,
              yValue,
              xAxisRenderer,
              yAxisRenderer,
              _chartState._requireInvertedAxis,
              pointInfo.seriesRenderer!._series,
              axisClipRect)
          .x;
      if (_chartState._chart.trackballBehavior.tooltipDisplayMode !=
              TrackballDisplayMode.floatAllPoints &&
          (!pointInfo.seriesRenderer!._chartState!._requireInvertedAxis)) {
        if (leastX != xPos) {
          trackballInfo.remove(pointInfo);
        }
        pointInfoIndex = tempTrackballInfo.indexOf(pointInfo);
        yPos = touchYPos;
        if (pointInfoIndex < tempTrackballInfo.length - 1) {
          nextPointInfo = tempTrackballInfo[pointInfoIndex + 1];
          if (pointInfo.yPosition! > yPos && pointInfoIndex == 0) {
            continue;
          }
          if (!(yPos <
              (nextPointInfo.yPosition! -
                  ((nextPointInfo.yPosition! - pointInfo.yPosition!) / 2)))) {
            trackballInfo.remove(pointInfo);
          } else if (pointInfoIndex != 0) {
            previousPointInfo = tempTrackballInfo[pointInfoIndex - 1];
            if (yPos <
                (pointInfo.yPosition! -
                    ((pointInfo.yPosition! - previousPointInfo.yPosition!) /
                        2))) {
              trackballInfo.remove(pointInfo);
            }
          }
        } else {
          if (pointInfoIndex != 0 &&
              pointInfoIndex == tempTrackballInfo.length - 1) {
            previousPointInfo = tempTrackballInfo[pointInfoIndex - 1];
            if (yPos < previousPointInfo.yPosition!) {
              trackballInfo.remove(pointInfo);
            }
            if (yPos <
                (pointInfo.yPosition! -
                    ((pointInfo.yPosition! - previousPointInfo.yPosition!) /
                        2))) {
              trackballInfo.remove(pointInfo);
            }
          }
        }
      }
    }
  }

  /// To find the nearest x value to render a trackball
  void _validateNearestXValue(
      double leastX,
      CartesianSeriesRenderer seriesRenderer,
      double touchXPos,
      double touchYPos) {
    final List<_ChartPointInfo> leastPointInfo = <_ChartPointInfo>[];
    final Rect axisClipRect = _calculatePlotOffset(
        seriesRenderer._chartState!._chartAxis._axisClipRect,
        Offset(seriesRenderer._xAxisRenderer!._axis.plotOffset,
            seriesRenderer._yAxisRenderer!._axis.plotOffset));
    final bool invertedAxis = seriesRenderer._chartState!._requireInvertedAxis;
    double nearPointX = invertedAxis ? axisClipRect.top : axisClipRect.left;
    final double touchXValue = invertedAxis ? touchYPos : touchXPos;
    double delta = 0, currX;
    num xValue;
    num? yValue;
    CartesianChartPoint<dynamic> dataPoint;
    CartesianSeries<dynamic, dynamic> series;
    ChartAxisRenderer xAxisRenderer, yAxisRenderer;
    _ChartLocation currXLocation;
    for (final _ChartPointInfo pointInfo in _chartPointInfo) {
      if (pointInfo.dataPointIndex! < seriesRenderer._dataPoints.length) {
        dataPoint = seriesRenderer._dataPoints[pointInfo.dataPointIndex!];
        xAxisRenderer = pointInfo.seriesRenderer!._xAxisRenderer!;
        yAxisRenderer = pointInfo.seriesRenderer!._yAxisRenderer!;
        xValue = dataPoint.xValue;
        if (seriesRenderer._seriesType != 'boxandwhisker') {
          yValue = dataPoint.yValue;
        }
        series = pointInfo.seriesRenderer!._series;
        currXLocation = _calculatePoint(xValue, yValue, xAxisRenderer,
            yAxisRenderer, invertedAxis, series, axisClipRect);
        currX = invertedAxis ? currXLocation.y : currXLocation.x;

        if (delta == touchXValue - currX) {
          leastPointInfo.add(pointInfo);
        } else if ((touchXValue - currX).toDouble().abs() <=
            (touchXValue - nearPointX).toDouble().abs()) {
          nearPointX = currX;
          delta = touchXValue - currX;
          leastPointInfo.clear();
          leastPointInfo.add(pointInfo);
        }
      }
      if (_chartPointInfo.isNotEmpty) {
        if (_chartPointInfo[0].dataPointIndex! <
            seriesRenderer._dataPoints.length) {
          leastX = _getLeastX(_chartPointInfo[0], seriesRenderer, axisClipRect);
        }
      }

      if (pointInfo.seriesRenderer!._seriesType.contains('bar')
          ? invertedAxis
          : invertedAxis) {
        _yPos = leastX;
      } else {
        _xPos = leastX;
      }
    }
  }

  /// To get the lowest X value to render trackball
  double _getLeastX(_ChartPointInfo pointInfo,
      CartesianSeriesRenderer seriesRenderer, Rect axisClipRect) {
    return _calculatePoint(
            seriesRenderer._dataPoints[pointInfo.dataPointIndex!].xValue,
            0,
            seriesRenderer._xAxisRenderer!,
            seriesRenderer._yAxisRenderer!,
            _chartState._requireInvertedAxis,
            seriesRenderer._series,
            axisClipRect)
        .x;
  }

  // To render the trackball marker
  void _renderTrackballMarker(CartesianSeriesRenderer seriesRenderer,
      Canvas canvas, TrackballBehavior trackballBehavior, int index) {
    final CartesianChartPoint<dynamic> point =
        seriesRenderer._dataPoints[index];
    final TrackballMarkerSettings markerSettings =
        trackballBehavior.markerSettings!;
    final _RenderingDetails renderingDetails =
        seriesRenderer._renderingDetails!;
    if (markerSettings.shape == DataMarkerType.image) {
      _drawImageMarker(null, canvas, _chartPointInfo[index].markerXPos!,
          _chartPointInfo[index].markerYPos!, markerSettings, _chartState);
    }
    final Paint strokePaint = Paint()
      ..color = trackballBehavior.markerSettings!.borderWidth == 0
          ? Colors.transparent
          : ((point.pointColorMapper != null)
              ? point.pointColorMapper!
              : markerSettings.borderColor ?? seriesRenderer._seriesColor!)
      ..strokeWidth = markerSettings.borderWidth
      ..style = PaintingStyle.stroke;

    final Paint fillPaint = Paint()
      ..color = markerSettings.color ??
          (renderingDetails.chartTheme.brightness == Brightness.light
              ? Colors.white
              : Colors.black)
      ..style = PaintingStyle.fill;
    canvas.drawPath(_markerShapes[index], strokePaint);
    canvas.drawPath(_markerShapes[index], fillPaint);
  }

  /// To add chart point info
  void _addChartPointInfo(CartesianSeriesRenderer seriesRenderer, double xPos,
      double yPos, int dataPointIndex, String? label, int seriesIndex,
      [double? lowYPos,
      double? highXPos,
      double? highYPos,
      double? openXPos,
      double? openYPos,
      double? closeXPos,
      double? closeYPos,
      double? minYPos,
      double? maxXPos,
      double? maxYPos,
      double? lowerXPos,
      double? lowerYPos,
      double? upperXPos,
      double? upperYPos]) {
    final _ChartPointInfo pointInfo = _ChartPointInfo();

    pointInfo.seriesRenderer = seriesRenderer;
    pointInfo.series = seriesRenderer._series;
    pointInfo.markerXPos = xPos;
    pointInfo.markerYPos = yPos;
    pointInfo.xPosition = xPos;
    pointInfo.yPosition = yPos;
    pointInfo.seriesIndex = seriesIndex;

    if (seriesRenderer._seriesType.contains('hilo') ||
        seriesRenderer._seriesType.contains('range') ||
        seriesRenderer._seriesType == 'candle') {
      pointInfo.lowYPosition = lowYPos!;
      pointInfo.highXPosition = highXPos!;
      pointInfo.highYPosition = highYPos!;
      if (seriesRenderer._seriesType == 'hiloopenclose' ||
          seriesRenderer._seriesType == 'candle') {
        pointInfo.openXPosition = openXPos!;
        pointInfo.openYPosition = openYPos!;
        pointInfo.closeXPosition = closeXPos!;
        pointInfo.closeYPosition = closeYPos!;
      }
    } else if (seriesRenderer._seriesType.contains('boxandwhisker')) {
      pointInfo.minYPosition = minYPos!;
      pointInfo.maxYPosition = maxYPos!;
      pointInfo.maxXPosition = maxXPos!;
      pointInfo.lowerXPosition = lowerXPos!;
      pointInfo.lowerYPosition = lowerYPos!;
      pointInfo.upperXPosition = upperXPos!;
      pointInfo.upperYPosition = upperYPos!;
    }

    if (seriesRenderer._segments.length > dataPointIndex) {
      pointInfo.color = seriesRenderer._segments[dataPointIndex]._color!;
    } else if (seriesRenderer._segments.length > 1) {
      pointInfo.color =
          seriesRenderer._segments[seriesRenderer._segments.length - 1]._color!;
    }
    pointInfo.chartDataPoint = seriesRenderer._dataPoints[dataPointIndex];
    pointInfo.dataPointIndex = dataPointIndex;
    if (!_isTrackballTemplate) {
      pointInfo.label = label!;
      pointInfo.header = _getHeaderText(
          seriesRenderer._dataPoints[dataPointIndex], seriesRenderer);
    }
    _chartPointInfo.add(pointInfo);
  }

  // Method to place the collided tooltips properly
  _TooltipPositions _smartTooltipPositions(
      List<num> tooltipTop,
      List<num> tooltipBottom,
      List<ChartAxisRenderer> _xAxesInfo,
      List<ChartAxisRenderer> _yAxesInfo,
      List<_ChartPointInfo> chartPointInfo,
      bool requireInvertedAxis,
      [bool? isPainterTooltip]) {
    _tooltipPadding = _chartState._requireInvertedAxis ? 8 : 5;
    num tooltipWidth = 0;
    _TooltipPositions tooltipPosition;
    for (int i = 0; i < chartPointInfo.length; i++) {
      requireInvertedAxis
          ? _visibleLocation.add(chartPointInfo[i].xPosition!)
          : _visibleLocation.add((chartPointInfo[i]
                      .seriesRenderer!
                      ._seriesType
                      .contains('range') ||
                  chartPointInfo[i]
                      .seriesRenderer!
                      ._seriesType
                      .contains('hilo') ||
                  chartPointInfo[i].seriesRenderer!._seriesType == 'candle')
              ? chartPointInfo[i].highYPosition!
              : chartPointInfo[i].seriesRenderer!._seriesType == 'boxandwhisker'
                  ? chartPointInfo[i].maxYPosition!
                  : chartPointInfo[i].yPosition!);

      tooltipWidth += tooltipBottom[i] - tooltipTop[i] + _tooltipPadding;
    }
    tooltipPosition = _continuousOverlappingPoints(
        tooltipTop, tooltipBottom, _visibleLocation);

    if (!requireInvertedAxis
        ? tooltipWidth < (_axisClipRect.bottom - _axisClipRect.top)
        : tooltipWidth < (_axisClipRect.right - _axisClipRect.left)) {
      tooltipPosition =
          _verticalArrangements(tooltipPosition, _xAxesInfo, _yAxesInfo);
    }
    return tooltipPosition;
  }

  _TooltipPositions _verticalArrangements(_TooltipPositions tooltipPPosition,
      List<ChartAxisRenderer> _xAxesInfo, List<ChartAxisRenderer> _yAxesInfo) {
    final _TooltipPositions tooltipPosition = tooltipPPosition;
    num? startPos, chartHeight;
    final bool isTransposed = _chartState._requireInvertedAxis;
    num secWidth, width;
    final int length = tooltipPosition.tooltipTop.length;
    ChartAxisRenderer yAxisRenderer;
    final int axesLength =
        _chartState._chartAxis._axisRenderersCollection.length;
    for (int i = length - 1; i >= 0; i--) {
      yAxisRenderer = _yAxesInfo[i];
      for (int k = 0; k < axesLength; k++) {
        if (yAxisRenderer ==
            _chartState._chartAxis._axisRenderersCollection[k]) {
          if (isTransposed) {
            chartHeight = _axisClipRect.right;
            startPos = _axisClipRect.left;
          } else {
            chartHeight = _axisClipRect.bottom - _axisClipRect.top;
            startPos = _axisClipRect.top;
          }
        }
      }
      width = tooltipPosition.tooltipBottom[i] - tooltipPosition.tooltipTop[i];
      if (chartHeight != null &&
          chartHeight < tooltipPosition.tooltipBottom[i]) {
        tooltipPosition.tooltipBottom[i] = chartHeight - 2;
        tooltipPosition.tooltipTop[i] =
            tooltipPosition.tooltipBottom[i] - width;
        for (int j = i - 1; j >= 0; j--) {
          secWidth =
              tooltipPosition.tooltipBottom[j] - tooltipPosition.tooltipTop[j];
          if (tooltipPosition.tooltipBottom[j] >
                  tooltipPosition.tooltipTop[j + 1] &&
              (tooltipPosition.tooltipTop[j + 1] > startPos! &&
                  tooltipPosition.tooltipBottom[j + 1] < chartHeight)) {
            tooltipPosition.tooltipBottom[j] =
                tooltipPosition.tooltipTop[j + 1] - _tooltipPadding;
            tooltipPosition.tooltipTop[j] =
                tooltipPosition.tooltipBottom[j] - secWidth;
          }
        }
      }
    }
    for (int i = 0; i < length; i++) {
      yAxisRenderer = _yAxesInfo[i];
      for (int k = 0; k < axesLength; k++) {
        if (yAxisRenderer ==
            _chartState._chartAxis._axisRenderersCollection[k]) {
          if (isTransposed) {
            chartHeight = _axisClipRect.right;
            startPos = _axisClipRect.left;
          } else {
            chartHeight = _axisClipRect.bottom - _axisClipRect.top;
            startPos = _axisClipRect.top;
          }
        }
      }
      width = tooltipPosition.tooltipBottom[i] - tooltipPosition.tooltipTop[i];
      if (startPos != null && tooltipPosition.tooltipTop[i] < startPos) {
        tooltipPosition.tooltipTop[i] = startPos + 1;
        tooltipPosition.tooltipBottom[i] =
            tooltipPosition.tooltipTop[i] + width;
        for (int j = i + 1; j <= (length - 1); j++) {
          secWidth =
              tooltipPosition.tooltipBottom[j] - tooltipPosition.tooltipTop[j];
          if (tooltipPosition.tooltipTop[j] <
                  tooltipPosition.tooltipBottom[j - 1] &&
              (tooltipPosition.tooltipTop[j - 1] > startPos &&
                  tooltipPosition.tooltipBottom[j - 1] < chartHeight!)) {
            tooltipPosition.tooltipTop[j] =
                tooltipPosition.tooltipBottom[j - 1] + _tooltipPadding;
            tooltipPosition.tooltipBottom[j] =
                tooltipPosition.tooltipTop[j] + secWidth;
          }
        }
      }
    }
    return tooltipPosition;
  }

  // Method to identify the colliding trackball tooltips and return the new tooltip positions
  _TooltipPositions _continuousOverlappingPoints(List<num> tooltipTop,
      List<num> tooltipBottom, List<num> visibleLocation) {
    num temp,
        count = 0,
        start = 0,
        halfHeight,
        midPos,
        tempTooltipHeight,
        temp1TooltipHeight;
    int startPoint = 0, i, j, k;
    final num endPoint = tooltipBottom.length - 1;
    num tooltipHeight = (tooltipBottom[0] - tooltipTop[0]) + _tooltipPadding;
    temp = tooltipTop[0] + tooltipHeight;
    start = tooltipTop[0];
    for (i = 0; i < endPoint; i++) {
      // To identify that tooltip collides or not
      if (temp >= tooltipTop[i + 1]) {
        tooltipHeight =
            tooltipBottom[i + 1] - tooltipTop[i + 1] + _tooltipPadding;
        temp += tooltipHeight;
        count++;
        // This condition executes when the tooltip count is half of the total number of tooltips
        if (count - 1 == endPoint - 1 || i == endPoint - 1) {
          halfHeight = (temp - start) / 2;
          midPos = (visibleLocation[startPoint] + visibleLocation[i + 1]) / 2;
          tempTooltipHeight =
              tooltipBottom[startPoint] - tooltipTop[startPoint];
          tooltipTop[startPoint] = midPos - halfHeight;
          tooltipBottom[startPoint] =
              tooltipTop[startPoint] + tempTooltipHeight;
          for (k = startPoint; k > 0; k--) {
            if (tooltipTop[k] <= tooltipBottom[k - 1] + _tooltipPadding) {
              temp1TooltipHeight = tooltipBottom[k - 1] - tooltipTop[k - 1];
              tooltipTop[k - 1] =
                  tooltipTop[k] - temp1TooltipHeight - _tooltipPadding;
              tooltipBottom[k - 1] = tooltipTop[k - 1] + temp1TooltipHeight;
            } else {
              break;
            }
          }
          // To set tool tip positions based on the half height and other tooltip height
          for (j = startPoint + 1; j <= startPoint + count; j++) {
            tempTooltipHeight = tooltipBottom[j] - tooltipTop[j];
            tooltipTop[j] = tooltipBottom[j - 1] + _tooltipPadding;
            tooltipBottom[j] = tooltipTop[j] + tempTooltipHeight;
          }
        }
      } else {
        count = i > 0 ? count : 0;
        // This exectutes when any of the middle tooltip collides
        if (count > 0) {
          halfHeight = (temp - start) / 2;
          midPos = (visibleLocation[startPoint] + visibleLocation[i]) / 2;
          tempTooltipHeight =
              tooltipBottom[startPoint] - tooltipTop[startPoint];
          tooltipTop[startPoint] = midPos - halfHeight;
          tooltipBottom[startPoint] =
              tooltipTop[startPoint] + tempTooltipHeight;
          for (k = startPoint; k > 0; k--) {
            if (tooltipTop[k] <= tooltipBottom[k - 1] + _tooltipPadding) {
              temp1TooltipHeight = tooltipBottom[k - 1] - tooltipTop[k - 1];
              tooltipTop[k - 1] =
                  tooltipTop[k] - temp1TooltipHeight - _tooltipPadding;
              tooltipBottom[k - 1] = tooltipTop[k - 1] + temp1TooltipHeight;
            } else {
              break;
            }
          }

          // To set tool tip positions based on the half height and other tooltip height
          for (j = startPoint + 1; j <= startPoint + count; j++) {
            tempTooltipHeight = tooltipBottom[j] - tooltipTop[j];
            tooltipTop[j] = tooltipBottom[j - 1] + _tooltipPadding;
            tooltipBottom[j] = tooltipTop[j] + tempTooltipHeight;
          }
          count = 0;
        }
        tooltipHeight =
            (tooltipBottom[i + 1] - tooltipTop[i + 1]) + _tooltipPadding;
        temp = tooltipTop[i + 1] + tooltipHeight;
        start = tooltipTop[i + 1];
        startPoint = i + 1;
      }
    }
    return _TooltipPositions(tooltipTop, tooltipBottom);
  }

  /// To get and return label text of the trackball
  String _getTrackballLabelText(
      CartesianSeriesRenderer seriesRenderer,
      num? xValue,
      num? yValue,
      num? lowValue,
      num? highValue,
      num? openValue,
      num? closeValue,
      num? minValue,
      num? maxValue,
      num? lowerQuartileValue,
      num? upperQuartileValue,
      num? meanValue,
      String seriesName,
      num? bubbleSize,
      num? cumulativeValue,
      CartesianChartPoint<dynamic> dataPoint) {
    String labelValue;
    final int digits = _trackballBehavior.tooltipSettings.decimalPlaces;
    final ChartAxis yAxis = seriesRenderer._yAxisRenderer!._axis;
    if (_trackballBehavior.tooltipSettings.format != null) {
      dynamic x;
      final ChartAxisRenderer axisRenderer = seriesRenderer._xAxisRenderer!;
      if (axisRenderer is DateTimeAxisRenderer) {
        final DateFormat dateFormat =
            (axisRenderer._axis as DateTimeAxis).dateFormat ??
                _getDateTimeLabelFormat(axisRenderer);
        x = dateFormat
            .format(DateTime.fromMillisecondsSinceEpoch(xValue! as int));
      } else if (axisRenderer is CategoryAxisRenderer) {
        x = dataPoint.x;
      } else if (axisRenderer is DateTimeCategoryAxisRenderer) {
        x = axisRenderer._labels
            .indexOf(axisRenderer._dateFormat.format(dataPoint.x));
      }
      labelValue = seriesRenderer._seriesType.contains('hilo') ||
              seriesRenderer._seriesType.contains('range') ||
              seriesRenderer._seriesType.contains('candle') ||
              seriesRenderer._seriesType.contains('boxandwhisker')
          ? seriesRenderer._seriesType.contains('boxandwhisker')
              ? (_trackballBehavior.tooltipSettings.format!
                  .replaceAll('point.x', (x ?? xValue).toString())
                  .replaceAll('point.minimum', minValue.toString())
                  .replaceAll('point.maximum', maxValue.toString())
                  .replaceAll(
                      'point.lowerQuartile', lowerQuartileValue.toString())
                  .replaceAll(
                      'point.upperQuartile', upperQuartileValue.toString())
                  .replaceAll('{', '')
                  .replaceAll('}', '')
                  .replaceAll('series.name', seriesName))
              : seriesRenderer._seriesType == 'hilo' ||
                      seriesRenderer._seriesType.contains('range')
                  ? (_trackballBehavior.tooltipSettings.format!
                      .replaceAll('point.x', (x ?? xValue).toString())
                      .replaceAll('point.high', highValue.toString())
                      .replaceAll('point.low', lowValue.toString())
                      .replaceAll('{', '')
                      .replaceAll('}', '')
                      .replaceAll('series.name', seriesName))
                  : (_trackballBehavior.tooltipSettings.format!
                      .replaceAll('point.x', (x ?? xValue).toString())
                      .replaceAll('point.high', highValue.toString())
                      .replaceAll('point.low', lowValue.toString())
                      .replaceAll('point.open', openValue.toString())
                      .replaceAll('point.close', closeValue.toString())
                      .replaceAll('{', '')
                      .replaceAll('}', '')
                      .replaceAll('series.name', seriesName))
          : seriesRenderer._seriesType == 'bubble'
              ? (_trackballBehavior.tooltipSettings.format!
                  .replaceAll('point.x', (x ?? xValue).toString())
                  .replaceAll(
                      'point.y',
                      _getLabelValue(
                          yValue, seriesRenderer._yAxisRenderer!._axis, digits))
                  .replaceAll('{', '')
                  .replaceAll('}', '')
                  .replaceAll('series.name', seriesName)
                  .replaceAll('point.size', bubbleSize.toString()))
              : seriesRenderer._seriesType.contains('stacked')
                  ? (_trackballBehavior.tooltipSettings.format!
                      .replaceAll('point.x', (x ?? xValue).toString())
                      .replaceAll('point.y', _getLabelValue(yValue, seriesRenderer._yAxisRenderer!._axis, digits))
                      .replaceAll('{', '')
                      .replaceAll('}', '')
                      .replaceAll('series.name', seriesName)
                      .replaceAll('point.cumulativeValue', cumulativeValue.toString()))
                  : (_trackballBehavior.tooltipSettings.format!.replaceAll('point.x', (x ?? xValue).toString()).replaceAll('point.y', _getLabelValue(yValue, seriesRenderer._yAxisRenderer!._axis, digits)).replaceAll('{', '').replaceAll('}', '').replaceAll('series.name', seriesName));
    } else {
      labelValue = !seriesRenderer._seriesType.contains('range') &&
              !seriesRenderer._seriesType.contains('candle') &&
              !seriesRenderer._seriesType.contains('hilo') &&
              !seriesRenderer._seriesType.contains('boxandwhisker')
          ? _getLabelValue(yValue, yAxis, digits)
          : seriesRenderer._seriesType == 'hiloopenclose' ||
                  seriesRenderer._seriesType.contains('candle') ||
                  seriesRenderer._seriesType.contains('boxandwhisker')
              ? seriesRenderer._seriesType.contains('boxandwhisker')
                  ? 'Maximum : ' +
                      _getLabelValue(maxValue, yAxis) +
                      '\n' +
                      'Minimum : ' +
                      _getLabelValue(minValue, yAxis) +
                      '\n' +
                      'LowerQuartile : ' +
                      _getLabelValue(lowerQuartileValue, yAxis) +
                      '\n' +
                      'UpperQuartile : ' +
                      _getLabelValue(upperQuartileValue, yAxis)
                  : 'High : ' +
                      _getLabelValue(highValue, yAxis) +
                      '\n' +
                      'Low : ' +
                      _getLabelValue(lowValue, yAxis) +
                      '\n' +
                      'Open : ' +
                      _getLabelValue(openValue, yAxis) +
                      '\n' +
                      'Close : ' +
                      _getLabelValue(closeValue, yAxis)
              : 'High : ' +
                  _getLabelValue(highValue, yAxis) +
                  '\n' +
                  'Low : ' +
                  _getLabelValue(lowValue, yAxis);
    }
    return labelValue;
  }

  /// To get header text of trackball
  String _getHeaderText(CartesianChartPoint<dynamic> point,
      CartesianSeriesRenderer seriesRenderer) {
    final ChartAxisRenderer xAxisRenderer = seriesRenderer._xAxisRenderer!;
    String headerText;
    String? date;
    if (xAxisRenderer is DateTimeAxisRenderer) {
      final DateTimeAxis _xAxis = xAxisRenderer._axis as DateTimeAxis;
      final DateFormat dateFormat =
          _xAxis.dateFormat ?? _getDateTimeLabelFormat(xAxisRenderer);
      date = dateFormat
          .format(DateTime.fromMillisecondsSinceEpoch(point.xValue.floor()));
    }
    headerText = xAxisRenderer is CategoryAxisRenderer
        ? point.x.toString()
        : xAxisRenderer is DateTimeAxisRenderer
            ? date!.toString()
            : (xAxisRenderer is DateTimeCategoryAxisRenderer
                ? xAxisRenderer._getFormattedLabel(
                    '${point.x.microsecondsSinceEpoch}',
                    xAxisRenderer._dateFormat)
                : _getLabelValue(point.xValue, xAxisRenderer._axis,
                    _chart.tooltipBehavior.decimalPlaces));
    return headerText;
  }

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
    if (_trackballPainter != null && !_trackballPainter!.canResetPath) {
      _trackballPainter!._drawTrackball(canvas);
    }
  }

  /// To draw trackball line
  void _drawLine(Canvas canvas, Paint? paint, int seriesIndex) {
    assert(_trackballBehavior.lineWidth >= 0,
        'Line width value of trackball should be greater than 0.');
    if (_trackballPainter != null && paint != null) {
      _trackballPainter!._drawTrackBallLine(canvas, paint, seriesIndex);
    }
  }

  Paint? _linePainter(Paint paint) => _trackballPainter?._getLinePainter(paint);
}

///Trackball marker renderer class for mutable fields and methods
class TrackballMarkerSettingsRenderer {
  /// Creates an argument constructor for TrackballMarkerSettings class
  TrackballMarkerSettingsRenderer(this._trackballMarkerSettings);

  ///ignore: unused_field
  final TrackballMarkerSettings? _trackballMarkerSettings;

  dart_ui.Image? _image;
}

/// Class to store the group mode details of trackball template.
class TrackballGroupingModeInfo {
  /// Creates an argument constructor for TrackballGroupingModeInfo class.
  TrackballGroupingModeInfo(this.points, this.currentPointIndices,
      this.visibleSeriesIndices, this.visibleSeriesList);

  /// It specifies the cartesian chart points.
  final List<CartesianChartPoint<dynamic>> points;

  /// It specifies the current point indices.
  final List<int> currentPointIndices;

  /// It specifies the visible series indices.
  final List<int> visibleSeriesIndices;

  /// It specifies the cartesian visible series list.
  final List<CartesianSeries<dynamic, dynamic>> visibleSeriesList;
}
