part of charts;

/// Renders the radial bar series.
///
/// The radial bar chart is used for showing the comparisons among the categories using the circular shapes.
/// To render a radial bar chart, create an instance of RadialBarSeries, and add to the series collection property of [SfCircularChart].
///
///Provides options to customize the [maximumValue], [trackColor], [trackBorderColor], [trackBorderWidth], [trackOpacity]
///and [useSeriesColor] of the pie segments.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=VJxPp7-2nGk}
class RadialBarSeries<T, D> extends CircularSeries<T, D> {
  /// Creating an argument constructor of RadialBarSeries class.
  ///
  RadialBarSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      CircularSeriesRendererCreatedCallback? onRendererCreated,
      ChartPointInteractionCallback? onPointTap,
      ChartPointInteractionCallback? onPointDoubleTap,
      ChartPointInteractionCallback? onPointLongPress,
      List<T>? dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, Color>? pointColorMapper,
      ChartShaderMapper<T>? pointShaderMapper,
      ChartValueMapper<T, String>? pointRadiusMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      ChartValueMapper<T, String>? sortFieldValueMapper,
      this.trackColor = const Color.fromRGBO(234, 236, 239, 1.0),
      this.trackBorderWidth = 0.0,
      this.trackOpacity = 1,
      this.useSeriesColor = false,
      this.trackBorderColor = Colors.transparent,
      this.maximumValue,
      DataLabelSettings? dataLabelSettings,
      String? radius,
      String? innerRadius,
      String? gap,
      double? strokeWidth,
      double? opacity,
      Color? strokeColor,
      bool? enableTooltip,
      bool? enableSmartLabels,
      String? name,
      double? animationDuration,
      SelectionBehavior? selectionBehavior,
      SortingOrder? sortingOrder,
      LegendIconType? legendIconType,
      CornerStyle? cornerStyle,
      List<int>? initialSelectedDataIndexes})
      : super(
          key: key,
          onCreateRenderer: onCreateRenderer,
          onRendererCreated: onRendererCreated,
          onPointTap: onPointTap,
          onPointDoubleTap: onPointDoubleTap,
          onPointLongPress: onPointLongPress,
          dataSource: dataSource,
          animationDuration: animationDuration,
          xValueMapper: (int index) => xValueMapper(dataSource![index], index),
          yValueMapper: (int index) => yValueMapper(dataSource![index], index),
          pointColorMapper: (int index) => pointColorMapper != null
              ? pointColorMapper(dataSource![index], index)
              : null,
          pointRadiusMapper: (int index) => pointRadiusMapper != null
              ? pointRadiusMapper(dataSource![index], index)
              : null,
          pointShaderMapper: pointShaderMapper != null
              ? (dynamic data, int index, Color color, Rect rect) =>
                  pointShaderMapper(dataSource![index], index, color, rect)
              : null,
          dataLabelMapper: (int index) => dataLabelMapper != null
              ? dataLabelMapper(dataSource![index], index)
              : null,
          sortFieldValueMapper: sortFieldValueMapper != null
              ? (int index) => sortFieldValueMapper(dataSource![index], index)
              : null,
          radius: radius,
          innerRadius: innerRadius,
          gap: gap,
          borderColor: strokeColor,
          borderWidth: strokeWidth,
          opacity: opacity,
          enableTooltip: enableTooltip,
          dataLabelSettings: dataLabelSettings,
          name: name,
          selectionBehavior: selectionBehavior,
          sortingOrder: sortingOrder,
          legendIconType: legendIconType,
          enableSmartLabels: enableSmartLabels,
          cornerStyle: cornerStyle,
          initialSelectedDataIndexes: initialSelectedDataIndexes,
        );

  ///Color of the track
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  trackColor: Colors.red,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color trackColor;

  ///Specifies the maximum value of the radial bar.
  ///
  /// By default, the sum of the data points values will be considered as maximum value.
  ///
  ///Defaults to `null`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  maximumValue: 100,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double? maximumValue;

  ///Border color of the track
  ///
  ///Defaults to `colors.Transparent`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  trackBorderColor: Colors.red,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color trackBorderColor;

  ///Border width of the track
  ///
  ///Defaults to `0.0`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  trackBorderColor: Colors.red,
  ///                  trackBorderWidth: 2,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double trackBorderWidth;

  ///Opacity of the track
  ///
  ///Defaults to `1`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  trackOpacity: 0.2,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double trackOpacity;

  ///Uses the point color for filling the track
  ///
  ///Defaults to `false`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  useSeriesColor:true
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final bool useSeriesColor;

  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  useSeriesColor:true
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```

// Create the  Radial bar series renderer.
  RadialBarSeriesRenderer createRenderer(CircularSeries<T, D> series) {
    RadialBarSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as RadialBarSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return RadialBarSeriesRenderer();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is RadialBarSeries &&
        other.animationDuration == animationDuration &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.cornerStyle == cornerStyle &&
        other.dataLabelMapper == dataLabelMapper &&
        other.dataLabelSettings == dataLabelSettings &&
        other.dataSource == dataSource &&
        other.enableSmartLabels == enableSmartLabels &&
        other.enableTooltip == enableTooltip &&
        other.gap == gap &&
        listEquals(
            other.initialSelectedDataIndexes, initialSelectedDataIndexes) &&
        other.innerRadius == innerRadius &&
        other.legendIconType == legendIconType &&
        other.maximumValue == maximumValue &&
        other.name == name &&
        other.onCreateRenderer == onCreateRenderer &&
        other.onRendererCreated == onRendererCreated &&
        other.onPointTap == onPointTap &&
        other.onPointDoubleTap == onPointDoubleTap &&
        other.onPointLongPress == onPointLongPress &&
        other.opacity == opacity &&
        other.pointColorMapper == pointColorMapper &&
        other.pointRadiusMapper == pointRadiusMapper &&
        other.pointShaderMapper == pointShaderMapper &&
        other.radius == radius &&
        other.selectionBehavior == selectionBehavior &&
        other.sortFieldValueMapper == sortFieldValueMapper &&
        other.sortingOrder == sortingOrder &&
        other.trackBorderColor == trackBorderColor &&
        other.trackBorderWidth == trackBorderWidth &&
        other.trackColor == trackColor &&
        other.trackOpacity == trackOpacity &&
        other.useSeriesColor == useSeriesColor &&
        other.xValueMapper == xValueMapper &&
        other.yValueMapper == yValueMapper;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      animationDuration,
      borderColor,
      borderWidth,
      cornerStyle,
      dataLabelMapper,
      dataLabelSettings,
      dataSource,
      enableSmartLabels,
      enableTooltip,
      gap,
      initialSelectedDataIndexes,
      innerRadius,
      legendIconType,
      maximumValue,
      name,
      onCreateRenderer,
      onRendererCreated,
      onPointTap,
      onPointDoubleTap,
      onPointLongPress,
      opacity,
      pointColorMapper,
      pointRadiusMapper,
      pointShaderMapper,
      radius,
      selectionBehavior,
      sortFieldValueMapper,
      sortingOrder,
      trackBorderColor,
      trackBorderWidth,
      trackColor,
      trackOpacity,
      useSeriesColor,
      xValueMapper,
      yValueMapper
    ];
    return hashList(values);
  }
}

/// Represents the pointer to draw radial bar series
///
class _RadialBarPainter extends CustomPainter {
  /// Creates the instance for radial bar series
  ///
  _RadialBarPainter({
    required this.chartState,
    required this.index,
    required this.isRepaint,
    this.animationController,
    this.seriesAnimation,
    ValueNotifier<num>? notifier,
  }) : super(repaint: notifier);
  final SfCircularChartState chartState;
  final int index;
  final bool isRepaint;
  final AnimationController? animationController;
  final Animation<double>? seriesAnimation;
  late RadialBarSeriesRenderer seriesRenderer;
  late num _length, _sum, _ringSize, _animationValue, _actualStartAngle;
  late int? _firstVisible;
  late num? _gap;
  late bool _isLegendToggle;
  late RadialBarSeriesRenderer? _oldSeriesRenderer;
  late double actualDegree;

  /// Method to get length of the visible point
  num _getLength(Canvas canvas) {
    num length = 0;
    seriesRenderer = chartState._chartSeries.visibleSeriesRenderers[index]
        as RadialBarSeriesRenderer;
    seriesRenderer._pointRegions = <_Region>[];
    seriesRenderer._innerRadius =
        seriesRenderer._segmentRenderingValues['currentInnerRadius']!;
    seriesRenderer._radius =
        seriesRenderer._segmentRenderingValues['currentRadius']!;
    seriesRenderer._center = seriesRenderer._center!;
    canvas.clipRect(chartState._renderingDetails.chartAreaRect);

    /// finding visible points count
    for (int i = 0; i < seriesRenderer._renderPoints!.length; i++) {
      length += seriesRenderer._renderPoints![i].isVisible ? 1 : 0;
    }
    return length;
  }

  /// Method to initialize the values to draw the radial bar series
  ///
  void _initializeValues(Canvas canvas) {
    _length = _getLength(canvas);
    _sum = seriesRenderer._segmentRenderingValues['sumOfPoints']!;
    _actualStartAngle = seriesRenderer._segmentRenderingValues['start']!;

    /// finding first visible point
    _firstVisible = seriesRenderer._getFirstVisiblePointIndex(seriesRenderer);
    _ringSize = (seriesRenderer._segmentRenderingValues['currentRadius']! -
                seriesRenderer._segmentRenderingValues['currentInnerRadius']!)
            .abs() /
        _length;
    _gap = _percentToValue(
        seriesRenderer._series.gap,
        (seriesRenderer._segmentRenderingValues['currentRadius']! -
                seriesRenderer._segmentRenderingValues['currentInnerRadius']!)
            .abs());
    _animationValue = seriesAnimation?.value ?? 1;
    _isLegendToggle = chartState._renderingDetails.isLegendToggled;
    _oldSeriesRenderer = (chartState._renderingDetails.widgetNeedUpdate &&
            !chartState._renderingDetails.isLegendToggled &&
            chartState._prevSeriesRenderer!._seriesType == 'radialbar')
        ? chartState._prevSeriesRenderer! as RadialBarSeriesRenderer
        : null;
    seriesRenderer._renderPaths.clear();
  }

  /// Method to paint radial bar series
  ///
  @override
  void paint(Canvas canvas, Size size) {
    num? pointStartAngle, pointEndAngle, degree;
    ChartPoint<dynamic>? _oldPoint;
    late ChartPoint<dynamic> point;
    _initializeValues(canvas);
    late RadialBarSeries<dynamic, dynamic> series;
    num? oldStart, oldEnd, oldRadius, oldInnerRadius;
    late bool isDynamicUpdate, hide;
    seriesRenderer._shadowPaths.clear();
    seriesRenderer._overFilledPaths.clear();
    for (int i = 0; i < seriesRenderer._renderPoints!.length; i++) {
      num? value;
      point = seriesRenderer._renderPoints![i];
      if (seriesRenderer._series is RadialBarSeries) {
        series = seriesRenderer._series as RadialBarSeries<dynamic, dynamic>;
      }
      _oldPoint = (_oldSeriesRenderer != null &&
              _oldSeriesRenderer!._oldRenderPoints != null &&
              (_oldSeriesRenderer!._oldRenderPoints!.length - 1 >= i))
          ? _oldSeriesRenderer!._oldRenderPoints![i]
          : (_isLegendToggle ? chartState._oldPoints![i] : null);
      pointStartAngle = _actualStartAngle;
      isDynamicUpdate = _oldPoint != null;
      hide = false;
      actualDegree = 0;
      if (!isDynamicUpdate ||
          ((_oldPoint.isVisible && point.isVisible) ||
              (_oldPoint.isVisible && !point.isVisible) ||
              (!_oldPoint.isVisible && point.isVisible))) {
        if (point.isVisible) {
          hide = false;
          if (isDynamicUpdate && !_isLegendToggle) {
            value = (point.y! > _oldPoint.y!)
                ? _oldPoint.y! + (point.y! - _oldPoint.y!) * _animationValue
                : _oldPoint.y! - (_oldPoint.y! - point.y!) * _animationValue;
          }
          degree = (value ?? point.y!).abs() / (series.maximumValue ?? _sum);
          degree = degree * (360 - 0.001);
          actualDegree = degree.toDouble();
          degree = isDynamicUpdate ? degree : degree * _animationValue;
          pointEndAngle = pointStartAngle + degree;
          point.midAngle = (pointStartAngle + pointEndAngle) / 2;
          point.startAngle = pointStartAngle;
          point.endAngle = pointEndAngle;
          point.center = seriesRenderer._center!;
          point.innerRadius = seriesRenderer._innerRadius =
              seriesRenderer._innerRadius +
                  ((i == _firstVisible) ? 0 : _ringSize);
          point.outerRadius = seriesRenderer._radius = _ringSize < _gap!
              ? 0
              : seriesRenderer._innerRadius + _ringSize - _gap!;
          if (_isLegendToggle) {
            seriesRenderer._calculateVisiblePointLegendToggleAnimation(
                point, _oldPoint, i, _animationValue);
          }
        } //animate on hiding
        else if (_isLegendToggle && !point.isVisible && _oldPoint!.isVisible) {
          hide = true;
          oldEnd = _oldPoint.endAngle;
          oldStart = _oldPoint.startAngle;
          degree = _oldPoint.y!.abs() / (series.maximumValue ?? _sum);
          degree = degree * (360 - 0.001);
          actualDegree = degree.toDouble();
          oldInnerRadius = _oldPoint.innerRadius! +
              ((_oldPoint.outerRadius! + _oldPoint.innerRadius!) / 2 -
                      _oldPoint.innerRadius!) *
                  _animationValue;
          oldRadius = _oldPoint.outerRadius! -
              (_oldPoint.outerRadius! -
                      (_oldPoint.outerRadius! + _oldPoint.innerRadius!) / 2) *
                  _animationValue;
        }
        if (seriesRenderer is RadialBarSeriesRenderer) {
          seriesRenderer._drawDataPoint(
              point,
              degree,
              pointStartAngle,
              pointEndAngle,
              seriesRenderer,
              hide,
              oldRadius,
              oldInnerRadius,
              _oldPoint,
              oldStart,
              oldEnd,
              i,
              canvas,
              index,
              chartState._chart,
              actualDegree);
        }
      }
    }

    _renderRadialBarSeries(canvas);
  }

  /// Method to render the radial bar series
  ///
  void _renderRadialBarSeries(Canvas canvas) {
    if (seriesRenderer._renderList.isNotEmpty) {
      Shader? _chartShader;
      if (chartState._chart.onCreateShader != null) {
        ChartShaderDetails chartShaderDetails;
        chartShaderDetails = ChartShaderDetails(seriesRenderer._renderList[1],
            seriesRenderer._renderList[2], 'series');
        _chartShader = chartState._chart.onCreateShader!(chartShaderDetails);
      }

      for (int k = 0; k < seriesRenderer._renderPaths.length; k++) {
        _drawPath(
            canvas,
            seriesRenderer._renderList[0],
            seriesRenderer._renderPaths[k],
            seriesRenderer._renderList[1],
            _chartShader!);
      }

      for (int k = 0; k < seriesRenderer._shadowPaths.length; k++) {
        canvas.drawPath(
            seriesRenderer._shadowPaths[k], seriesRenderer._shadowPaint);
      }

      if (_chartShader != null && seriesRenderer._overFilledPaint != null) {
        seriesRenderer._overFilledPaint!.shader = _chartShader;
      }
      for (int k = 0; k < seriesRenderer._overFilledPaths.length; k++) {
        canvas.drawPath(seriesRenderer._overFilledPaths[k],
            seriesRenderer._overFilledPaint!);
      }

      if (seriesRenderer._renderList[0].strokeColor != null &&
          seriesRenderer._renderList[0].strokeWidth != null &&
          (seriesRenderer._renderList[0].strokeWidth > 0) == true) {
        final Paint paint = Paint();
        paint.color = seriesRenderer._renderList[0].strokeColor;
        paint.strokeWidth = seriesRenderer._renderList[0].strokeWidth;
        paint.style = PaintingStyle.stroke;
        for (int k = 0; k < seriesRenderer._renderPaths.length; k++) {
          canvas.drawPath(seriesRenderer._renderPaths[k], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => isRepaint;
}

/// Creates series renderer for RadialBar series
///
class RadialBarSeriesRenderer extends CircularSeriesRenderer {
  /// Calling the default constructor of RadialBarSeriesRenderer class.
  ///
  RadialBarSeriesRenderer() {
    _shadowPaths = <Path>[];
    _overFilledPaths = <Path>[];
  }

  @override
  late CircularSeries<dynamic, dynamic> _series;

  late num _innerRadius;
  late num _radius;
  late Color _fillColor, _strokeColor;
  late double _opacity, _strokeWidth;
  late List<Path> _shadowPaths;
  late List<Path> _overFilledPaths;
  late Paint _shadowPaint;
  Paint? _overFilledPaint;

  @override
  Offset? _center;

  /// Method to find first visible point
  int? _getFirstVisiblePointIndex(RadialBarSeriesRenderer seriesRenderer) {
    for (int i = 0; i < seriesRenderer._renderPoints!.length; i++) {
      if (seriesRenderer._renderPoints![i].isVisible) {
        return i;
      }
    }
    return null;
  }

  /// Method for calculating animation for visible points on legend toggle
  ///
  void _calculateVisiblePointLegendToggleAnimation(ChartPoint<dynamic> point,
      ChartPoint<dynamic>? _oldPoint, int i, num animationValue) {
    if (!_oldPoint!.isVisible && point.isVisible) {
      _radius = i == 0
          ? point.outerRadius!
          : (point.innerRadius! +
              (point.outerRadius! - point.innerRadius!) * animationValue);
      _innerRadius = i == 0
          ? (point.outerRadius! -
              (point.outerRadius! - point.innerRadius!) * animationValue)
          : _innerRadius;
    } else {
      _radius = (point.outerRadius! > _oldPoint.outerRadius!)
          ? _oldPoint.outerRadius! +
              (point.outerRadius! - _oldPoint.outerRadius!) * animationValue
          : _oldPoint.outerRadius! -
              (_oldPoint.outerRadius! - point.outerRadius!) * animationValue;
      _innerRadius = (point.innerRadius! > _oldPoint.innerRadius!)
          ? _oldPoint.innerRadius! +
              (point.innerRadius! - _oldPoint.innerRadius!) * animationValue
          : _oldPoint.innerRadius! -
              (_oldPoint.innerRadius! - point.innerRadius!) * animationValue;
    }
  }

  /// To draw data points of the radial bar series
  ///
  void _drawDataPoint(
      ChartPoint<dynamic> point,
      num? degree,
      num pointStartAngle,
      num? pointEndAngle,
      RadialBarSeriesRenderer seriesRenderer,
      bool hide,
      num? oldRadius,
      num? oldInnerRadius,
      ChartPoint<dynamic>? _oldPoint,
      num? oldStart,
      num? oldEnd,
      int i,
      Canvas canvas,
      int index,
      SfCircularChart chart,
      double actualDegree) {
    late RadialBarSeries<dynamic, dynamic> series;
    if (seriesRenderer._series is RadialBarSeries) {
      series = seriesRenderer._series as RadialBarSeries<dynamic, dynamic>;
    }
    _drawPath(
        canvas,
        _StyleOptions(
            fill: series.useSeriesColor ? point.fill : series.trackColor,
            strokeWidth: series.trackBorderWidth,
            strokeColor: series.trackBorderColor,
            opacity: series.trackOpacity),
        _getArcPath(
            hide ? oldInnerRadius! : _innerRadius,
            hide ? oldRadius! : _radius.toDouble(),
            _center!,
            0,
            360 - 0.001,
            360 - 0.001,
            chart,
            true));
    if (_radius > 0 && degree != null && degree > 0) {
      _renderRadialPoints(
          point,
          degree,
          pointStartAngle,
          pointEndAngle,
          seriesRenderer,
          hide,
          oldRadius,
          oldInnerRadius,
          _oldPoint,
          oldStart,
          oldEnd,
          i,
          canvas,
          index,
          chart,
          actualDegree);
    }
  }

  /// Method to render radial data points
  ///
  void _renderRadialPoints(
      ChartPoint<dynamic> point,
      num? degree,
      num pointStartAngle,
      num? pointEndAngle,
      RadialBarSeriesRenderer seriesRenderer,
      bool hide,
      num? oldRadius,
      num? oldInnerRadius,
      ChartPoint<dynamic>? _oldPoint,
      num? oldStart,
      num? oldEnd,
      int i,
      Canvas canvas,
      int index,
      SfCircularChart chart,
      double actualDegree) {
    if (point.isVisible) {
      final _Region pointRegion = _Region(
          _degreesToRadians(point.startAngle!),
          _degreesToRadians(point.endAngle!),
          point.startAngle!,
          point.endAngle!,
          index,
          i,
          point.center,
          _innerRadius,
          point.outerRadius!);
      seriesRenderer._pointRegions.add(pointRegion);
    }

    final num angleDeviation = _findAngleDeviation(
        hide ? oldInnerRadius! : _innerRadius,
        hide ? oldRadius! : _radius,
        360);
    final CornerStyle cornerStyle = _series.cornerStyle;
    if (cornerStyle == CornerStyle.bothCurve ||
        cornerStyle == CornerStyle.startCurve) {
      hide
          ? oldStart = _oldPoint!.startAngle! + angleDeviation
          : pointStartAngle += angleDeviation;
    }
    if (cornerStyle == CornerStyle.bothCurve ||
        cornerStyle == CornerStyle.endCurve) {
      hide
          ? oldEnd = _oldPoint!.endAngle! - angleDeviation
          : pointEndAngle = pointEndAngle! - angleDeviation;
    }
    final _StyleOptions? style =
        seriesRenderer._selectPoint(i, seriesRenderer, chart, point);
    _fillColor = style != null && style.fill != null
        ? style.fill!
        : (point.fill != Colors.transparent
            ? _series._renderer!.getPointColor(
                seriesRenderer, point, i, index, point.fill, _series.opacity)!
            : point.fill);
    _strokeColor = style != null && style.strokeColor != null
        ? style.strokeColor!
        : _series._renderer!.getPointStrokeColor(
            seriesRenderer, point, i, index, point.strokeColor);
    _strokeWidth = style != null && style.strokeWidth != null
        ? style.strokeWidth!.toDouble()
        : _series._renderer!
            .getPointStrokeWidth(
                seriesRenderer, point, i, index, point.strokeWidth)
            .toDouble();
    _opacity = style != null && style.opacity != null
        ? style.opacity!.toDouble()
        : _series._renderer!
            .getOpacity(seriesRenderer, point, i, index, _series.opacity);
    seriesRenderer._innerRadialradius =
        !point.isVisible || (seriesRenderer._innerRadialradius == null)
            ? _innerRadius
            : seriesRenderer._innerRadialradius;
    seriesRenderer._renderList.clear();

    _drawRadialBarPath(
        canvas,
        point,
        chart,
        seriesRenderer,
        hide,
        pointStartAngle,
        pointEndAngle,
        oldRadius,
        oldInnerRadius,
        oldStart,
        oldEnd,
        degree,
        actualDegree);
  }

  /// Method to draw the radial bar series path
  ///
  void _drawRadialBarPath(
      Canvas canvas,
      ChartPoint<dynamic> point,
      SfCircularChart chart,
      RadialBarSeriesRenderer seriesRenderer,
      bool hide,
      num pointStartAngle,
      num? pointEndAngle,
      num? oldRadius,
      num? oldInnerRadius,
      num? oldStart,
      num? oldEnd,
      num? degree,
      double actualDegree) {
    Path path;
    if (degree! > 360) {
      path = _getRoundedCornerArcPath(
          hide ? oldInnerRadius! : _innerRadius,
          hide ? oldRadius! : _radius,
          _center!,
          0,
          360 - 0.001,
          360 - 0.001,
          _series.cornerStyle,
          point);
      final double innerRadius =
          hide ? oldInnerRadius!.toDouble() : _innerRadius.toDouble();
      final double outerRadius =
          hide ? oldRadius!.toDouble() : _radius.toDouble();
      final double startAngle =
          hide ? oldStart!.toDouble() : pointStartAngle.toDouble();
      final double endAngle =
          hide ? oldEnd!.toDouble() : pointEndAngle!.toDouble();
      path.arcTo(
          Rect.fromCircle(center: _center!, radius: outerRadius.toDouble()),
          _degreesToRadians(startAngle).toDouble(),
          _degreesToRadians(endAngle - startAngle).toDouble(),
          true);
      path.arcTo(
          Rect.fromCircle(center: _center!, radius: innerRadius.toDouble()),
          _degreesToRadians(endAngle.toDouble()).toDouble(),
          (_degreesToRadians(startAngle.toDouble()) -
                  _degreesToRadians(endAngle.toDouble()))
              .toDouble(),
          false);
    } else {
      path = _getRoundedCornerArcPath(
          hide ? oldInnerRadius! : _innerRadius,
          hide ? oldRadius! : _radius,
          _center!,
          hide ? oldStart! : pointStartAngle,
          hide ? oldEnd! : pointEndAngle!,
          degree,
          _series.cornerStyle,
          point);
    }

    seriesRenderer._renderPaths.add(path);

    if (chart.onCreateShader != null && point.shader == null) {
      point._pathRect = Rect.fromCircle(
        center: _center!,
        radius: _radius.toDouble(),
      );
      Rect innerRect;
      innerRect = Rect.fromCircle(
        center: _center!,
        radius: seriesRenderer._innerRadialradius!.toDouble(),
      );
      seriesRenderer._renderList.add(_StyleOptions(
          fill: _fillColor,
          strokeWidth:
              _chartState._renderingDetails.animateCompleted ? _strokeWidth : 0,
          strokeColor: _strokeColor,
          opacity: _opacity));
      seriesRenderer._renderList.add(point._pathRect);
      seriesRenderer._renderList.add(innerRect);
    } else {
      if (hide
          ? (((oldEnd! - oldStart!) > 0) && (oldRadius != oldInnerRadius))
          : ((pointEndAngle! - pointStartAngle) > 0)) {
        _drawPath(
            canvas,
            _StyleOptions(
                fill: _fillColor,
                strokeWidth: _chartState._renderingDetails.animateCompleted
                    ? _strokeWidth
                    : 0,
                strokeColor: _strokeColor,
                opacity: _opacity),
            path,
            point._pathRect,
            point.shader);
        // ignore: unnecessary_null_comparison
        if (point.shader != null &&
            // ignore: unnecessary_null_comparison
            _strokeColor != null &&
            // ignore: unnecessary_null_comparison
            _strokeWidth != null &&
            _strokeWidth > 0 &&
            _chartState._renderingDetails.animateCompleted) {
          final Paint paint = Paint();
          paint.color = _strokeColor;
          paint.strokeWidth = _strokeWidth;
          paint.style = PaintingStyle.stroke;
          canvas.drawPath(path, paint);
        }
      }
    }

    final num? angle = hide ? oldEnd : pointEndAngle;
    final num? startAngle = hide ? oldStart : pointStartAngle;
    if (actualDegree > 360 &&
        angle != null &&
        startAngle != null &&
        angle >= startAngle + 180) {
      _applyShadow(hide, angle, actualDegree, canvas, chart, point,
          oldInnerRadius, oldRadius);
    }
  }

  /// Method to apply shadow at segment's end
  void _applyShadow(
      bool hide,
      num? pointEndAngle,
      double actualDegree,
      Canvas canvas,
      SfCircularChart chart,
      ChartPoint<dynamic> point,
      num? oldInnerRadius,
      num? oldRadius) {
    if (pointEndAngle != null && actualDegree > 360) {
      final double innerRadius =
          hide ? oldInnerRadius!.toDouble() : _innerRadius.toDouble();
      final double outerRadius =
          hide ? oldRadius!.toDouble() : _radius.toDouble();
      final double radius = (innerRadius - outerRadius).abs() / 2;
      final Offset? midPoint = _degreeToPoint(
          pointEndAngle, (innerRadius + outerRadius) / 2, _center!);
      if (radius > 0) {
        double strokeWidth = radius * 0.2;
        strokeWidth = strokeWidth < 3 ? 3 : (strokeWidth > 5 ? 5 : strokeWidth);
        _shadowPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..maskFilter =
              MaskFilter.blur(BlurStyle.normal, _getSigmaFromRadius(3));

        _overFilledPaint = Paint()..color = _fillColor;
        if (point.shader != null) {
          _overFilledPaint!.shader = point.shader;
        }

        if (_series.cornerStyle == CornerStyle.endCurve ||
            _series.cornerStyle == CornerStyle.bothCurve) {
          pointEndAngle =
              (pointEndAngle > 360 ? pointEndAngle : (pointEndAngle - 360)) +
                  11.5;
          final Path path = Path()
            ..addArc(
                Rect.fromCircle(
                    center: midPoint!, radius: radius - (radius * 0.05)),
                _degreesToRadians(pointEndAngle + 22.5).toDouble(),
                _degreesToRadians(118.125).toDouble());
          final Path overFilledPath = Path()
            ..addArc(
                Rect.fromCircle(center: midPoint, radius: radius),
                _degreesToRadians(pointEndAngle - 20).toDouble(),
                _degreesToRadians(225).toDouble());
          if (chart.onCreateShader != null && point.shader == null) {
            _shadowPaths.add(path);
            _overFilledPaths.add(overFilledPath);
          } else {
            canvas.drawPath(path, _shadowPaint);
            canvas.drawPath(overFilledPath, _overFilledPaint!);
          }
        } else if (_series.cornerStyle == CornerStyle.bothFlat ||
            _series.cornerStyle == CornerStyle.startCurve) {
          _overFilledPaint!
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..color = _fillColor;
          final Offset? startPoint = _degreeToPoint(
              pointEndAngle, outerRadius - (outerRadius * 0.025), _center!);

          final Offset? endPoint = _degreeToPoint(
              pointEndAngle, innerRadius + (innerRadius * 0.025), _center!);

          final Offset? overFilledStartPoint =
              _degreeToPoint(pointEndAngle - 2, outerRadius, _center!);
          final Offset? overFilledEndPoint =
              _degreeToPoint(pointEndAngle - 2, innerRadius, _center!);
          if (chart.onCreateShader != null && point.shader == null) {
            final Path path = Path()
              ..moveTo(startPoint!.dx, startPoint.dy)
              ..lineTo(endPoint!.dx, endPoint.dy);
            path.close();
            final Path overFilledPath = Path()
              ..moveTo(overFilledStartPoint!.dx, overFilledStartPoint.dy)
              ..lineTo(overFilledEndPoint!.dx, overFilledEndPoint.dy);
            path.close();
            _shadowPaths.add(path);
            _overFilledPaths.add(overFilledPath);
          } else {
            canvas.drawLine(startPoint!, endPoint!, _shadowPaint);
            canvas.drawLine(
                overFilledStartPoint!, overFilledEndPoint!, _overFilledPaint!);
          }
        }
      }
    }
  }

  /// Method to convert the radius to sigma
  double _getSigmaFromRadius(double radius) {
    return radius * 0.57735 + 0.5;
  }
}
