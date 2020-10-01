part of charts;

/// Customizes the markers.
///
/// Markers are used to provide information about the exact point location. You can add a shape to adorn each data point.
/// Markers can be enabled by using the [isVisible] property of [MarkerSettings].
///
/// Provides the options of [color], border width, border color and [shape] of the marker to customize the appearance.
///
class MarkerSettings {
  /// Creating an argument constructor of MarkerSettings class.
  MarkerSettings(
      {this.isVisible = false,
      double height,
      double width,
      this.color,
      DataMarkerType shape,
      double borderWidth,
      this.borderColor,
      this.image})
      : height = height ?? 8,
        width = width ?? 8,
        shape = shape ?? DataMarkerType.circle,
        borderWidth = borderWidth ?? 2;

  ///Toggles the visibility of the marker.
  ///
  ///Defaults to `false`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  markerSettings: MarkerSettings(isVisible: true),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final bool isVisible;

  ///Height of the marker shape.
  ///
  ///Defaults to `4`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  markerSettings: MarkerSettings(
  ///                         isVisible: true, height: 10),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double height;

  ///Width of the marker shape.
  ///
  ///Defaults to `4`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  markerSettings: MarkerSettings(
  ///                         isVisible: true, width: 10),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double width;

  ///Color of the marker shape.
  ///
  ///Defaults to `null`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  markerSettings: MarkerSettings(
  ///                         isVisible: true, color: Colors.red),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color color;

  ///Shape of the marker.
  ///
  ///Defaults to `DataMarkerType.circle`.
  ///
  ///Also refer [DataMarkerType]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  markerSettings: MarkerSettings(
  ///                         isVisible: true, shape: DataMarkerType.diamond),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final DataMarkerType shape;

  ///Border color of the marker.
  ///
  ///Defaults to `null`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  markerSettings: MarkerSettings(
  ///                          isVisible: true,
  ///                          borderColor: Colors.red, borderWidth: 3),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color borderColor;

  ///Border width of the marker.
  ///
  ///Defaults to `2`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  markerSettings: MarkerSettings(
  ///                         isVisible: true,
  ///                         borderWidth: 2, borderColor: Colors.pink),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double borderWidth;

  ///Image to be used as marker.
  ///
  ///Defaults to `null`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  markerSettings: MarkerSettings(
  ///                         isVisible: true, image: const AssetImage('images/bike.png'),
  ///                         shape: DataMarkerType.image),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final ImageProvider image;
}

/// Marker settings renderer class for mutable fields and methods
class MarkerSettingsRenderer {
  /// Creates an argument constructor for MarkerSettings renderer class
  MarkerSettingsRenderer(this._markerSettings) {
    _color = _markerSettings.color;

    _borderColor = _markerSettings.borderColor;

    _borderWidth = _markerSettings.borderWidth;
  }

  final MarkerSettings _markerSettings;

  // ignore: prefer_final_fields
  Color _color;

  Color _borderColor;

  double _borderWidth;

  dart_ui.Image _image;

  /// To paint the marker here
  void renderMarker(
      CartesianSeriesRenderer seriesRenderer,
      CartesianChartPoint<dynamic> point,
      Animation<double> animationController,
      Canvas canvas,
      int markerIndex,
      [int outlierIndex]) {
    Paint strokePaint, fillPaint;
    final XyDataSeries<dynamic, dynamic> series = seriesRenderer._series;
    final Size size =
        Size(series.markerSettings.width, series.markerSettings.height);
    final DataMarkerType markerType = series.markerSettings.shape;
    CartesianChartPoint<dynamic> point;
    final bool hasPointColor = (series.pointColorMapper != null) ? true : false;
    final bool isBoxSeries =
        seriesRenderer._seriesType.contains('boxandwhisker');
    final double opacity = (animationController != null &&
            (seriesRenderer._chartState._initialRender ||
                seriesRenderer._needAnimateSeriesElements))
        ? animationController.value
        : 1;
    point = seriesRenderer._dataPoints[markerIndex];
    Color seriesColor = seriesRenderer._seriesColor;
    if (seriesRenderer._seriesType == 'waterfall') {
      seriesColor =
          _getWaterfallSeriesColor(seriesRenderer._series, point, seriesColor);
    }
    _borderColor = series.markerSettings.borderColor ?? seriesColor;
    _color = series.markerSettings.color;
    _borderWidth = series.markerSettings.borderWidth;
    if (!isBoxSeries) {
      seriesRenderer._markerShapes.add(_getMarkerShapesPath(
          markerType,
          Offset(point.markerPoint.x, point.markerPoint.y),
          size,
          seriesRenderer,
          markerIndex,
          null,
          animationController));
    } else {
      seriesRenderer._markerShapes.add(_getMarkerShapesPath(
          markerType,
          Offset(point.outliersPoint[outlierIndex].x,
              point.outliersPoint[outlierIndex].y),
          size,
          seriesRenderer,
          markerIndex,
          null,
          animationController));
    }
    if (seriesRenderer._seriesType.contains('range') ||
        seriesRenderer._seriesType == 'hilo') {
      seriesRenderer._markerShapes2.add(_getMarkerShapesPath(
          markerType,
          Offset(point.markerPoint2.x, point.markerPoint2.y),
          size,
          seriesRenderer,
          markerIndex,
          null,
          animationController));
    }
    strokePaint = Paint()
      ..color = point.isEmpty == true
          ? (series.emptyPointSettings.borderWidth == 0
              ? Colors.transparent
              : series.emptyPointSettings.borderColor.withOpacity(opacity))
          : (series.markerSettings.borderWidth == 0
              ? Colors.transparent
              : ((hasPointColor && point.pointColorMapper != null)
                  ? point.pointColorMapper.withOpacity(opacity)
                  : _borderColor.withOpacity(opacity)))
      ..style = PaintingStyle.stroke
      ..strokeWidth = point.isEmpty == true
          ? series.emptyPointSettings.borderWidth
          : _borderWidth;

    if (series.gradient != null && series.markerSettings.borderColor == null) {
      strokePaint = _getLinearGradientPaint(
          series.gradient,
          _getMarkerShapesPath(
                  markerType,
                  Offset(
                      isBoxSeries
                          ? point.outliersPoint[outlierIndex].x
                          : point.markerPoint.x,
                      isBoxSeries
                          ? point.outliersPoint[outlierIndex].y
                          : point.markerPoint.y),
                  size,
                  seriesRenderer,
                  null,
                  null,
                  animationController)
              .getBounds(),
          seriesRenderer._chartState._requireInvertedAxis);
      strokePaint.style = PaintingStyle.stroke;
      strokePaint.strokeWidth = point.isEmpty == true
          ? series.emptyPointSettings.borderWidth
          : series.markerSettings.borderWidth;
    }

    fillPaint = Paint()
      ..color = point.isEmpty == true
          ? series.emptyPointSettings.color
          : _color != Colors.transparent
              ? (_color ??
                      (seriesRenderer._chartState._chartTheme.brightness ==
                              Brightness.light
                          ? Colors.white
                          : Colors.black))
                  .withOpacity(opacity)
              : _color
      ..style = PaintingStyle.fill;
    final bool isScatter = seriesRenderer._seriesType == 'scatter';
    final Rect axisClipRect =
        seriesRenderer._chartState._chartAxis._axisClipRect;

    /// Render marker points
    if ((series.markerSettings.isVisible || isScatter || isBoxSeries) &&
        point.isVisible &&
        _withInRect(seriesRenderer, point.markerPoint, axisClipRect) &&
        (point.markerPoint != null ||
            point.outliersPoint[outlierIndex] != null) &&
        point.isGap != true &&
        (!isScatter || series.markerSettings.shape == DataMarkerType.image)) {
      seriesRenderer.drawDataMarker(
          isBoxSeries ? outlierIndex : markerIndex,
          canvas,
          fillPaint,
          strokePaint,
          isBoxSeries
              ? point.outliersPoint[outlierIndex].x
              : point.markerPoint.x,
          isBoxSeries
              ? point.outliersPoint[outlierIndex].y
              : point.markerPoint.y,
          seriesRenderer);
      if (series.markerSettings.shape == DataMarkerType.image) {
        _drawImageMarker(
            seriesRenderer,
            canvas,
            isBoxSeries
                ? point.outliersPoint[outlierIndex].x
                : point.markerPoint.x,
            isBoxSeries
                ? point.outliersPoint[outlierIndex].y
                : point.markerPoint.y);
        if (seriesRenderer._seriesType.contains('range') ||
            seriesRenderer._seriesType == 'hilo') {
          _drawImageMarker(seriesRenderer, canvas, point.markerPoint2.x,
              point.markerPoint2.y);
        }
      }
    }
  }

  /// To determine if the marker is within axis clip rect
  bool _withInRect(CartesianSeriesRenderer seriesRenderer,
      _ChartLocation markerPoint, Rect axisClipRect) {
    bool withInRect = false;

    withInRect = markerPoint.x >= axisClipRect.left &&
        markerPoint.x <= axisClipRect.right &&
        markerPoint.y <= axisClipRect.bottom &&
        markerPoint.y >= axisClipRect.top;

    return withInRect;
  }

  /// Paint the image marker
  void _drawImageMarker(CartesianSeriesRenderer seriesRenderer, Canvas canvas,
      double pointX, double pointY) {
    //  final MarkerSettingsRenderer markerSettingsRenderer = seriesRenderer._markerSettingsRenderer;
    if (seriesRenderer._markerSettingsRenderer._image != null) {
      final double imageWidth = 2 * seriesRenderer._series.markerSettings.width;
      final double imageHeight =
          2 * seriesRenderer._series.markerSettings.height;
      final Rect positionRect = Rect.fromLTWH(pointX - imageWidth / 2,
          pointY - imageHeight / 2, imageWidth, imageHeight);
      paintImage(
          canvas: canvas, rect: positionRect, image: _image, fit: BoxFit.fill);
    }
  }
}
