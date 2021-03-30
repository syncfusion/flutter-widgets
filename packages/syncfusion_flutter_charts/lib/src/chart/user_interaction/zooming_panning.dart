part of charts;

/// Customizes the zooming options.
///
/// Customize the various zooming actions such.toDouble()tapZooming, selectionZooming, zoomPinch.
/// In selection you can long press and drag to select a range on the chart to be zoomed in and also
/// zooming you can customize the selection rectangle using Borderwidth,color and RectColor.
///
/// zoomPinching can be performed by moving two fingers over the chartDefault mode is [ZoomMode.xy].
/// Zooming will be stopped after reaching [maximumZoomLevel].
///
///_Note:_ This is only applicable for [SfCartesianChart].
class ZoomPanBehavior {
  /// Creating an argument constructor of ZoomPanBehavior class.
  ZoomPanBehavior(
      {this.enablePinching = false,
      this.enableDoubleTapZooming = false,
      this.enablePanning = false,
      this.enableSelectionZooming = false,
      this.enableMouseWheelZooming = false,
      this.zoomMode = ZoomMode.xy,
      this.maximumZoomLevel,
      this.selectionRectBorderWidth = 1,
      this.selectionRectBorderColor,
      this.selectionRectColor});

  ///Enables or disables the pinch zooming.
  ///
  /// Pinching can be performed by moving two fingers over the
  /// chart. You can zoom the chart through pinch gesture in touch enabled devices.
  ///
  ///Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           zoomPanBehavior: ZoomPanBehavior(enablePinchZooming: true),
  ///        ));
  ///}
  ///```
  final bool enablePinching;

  ///Enables or disables the double tap zooming.
  ///
  ///Zooming will enable when you tap double time in plotarea.
  ///After reaching the Maximum zoom level, zooming will be stopped.
  ///
  ///Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           zoomPanBehavior: ZoomPanBehavior(enableDoubleTapZooming: true),
  ///        ));
  ///}
  ///```
  final bool enableDoubleTapZooming;

  ///Enables or disables the panning.
  ///
  ///Panning can be performed on a zoomed axis.
  ///you can able to panning the zoomed chart.
  ///
  ///Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           zoomPanBehavior: ZoomPanBehavior(enablePanning: true),
  ///        ));
  ///}
  ///```
  final bool enablePanning;

  ///Enables or disables the selection zooming.
  ///
  ///Selection zooming can be performed by dragging.
  ///The drawn rectangular region will be zoomed on touch.
  ///
  ///Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           zoomPanBehavior: ZoomPanBehavior(enableSelectionZooming: true),
  ///        ));
  ///}
  ///```
  final bool enableSelectionZooming;

  ///Enables or disables the mouseWheelZooming.
  ///
  ///Mouse wheel zooming for can be performed by rolling the mouse wheel up or down.
  ///The place where the cursor is hovering gets zoomed io or out according to the mouse wheel rolling up or down.
  ///
  ///Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           zoomPanBehavior: ZoomPanBehavior(enableMouseWheelZooming: true),
  ///        ));
  ///}
  ///```
  final bool enableMouseWheelZooming;

  ///By default, both the x and y-axes in the chart can be zoomed.
  ///
  /// It can be changed by setting value to this property.
  ///
  ///Defaults to `ZoomMode.xy`.
  ///
  ///Also refer [ZoomMode].
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           zoomPanBehavior: ZoomPanBehavior(enableSelectionZooming: true, zoomMode: ZoomMode.x),
  ///        ));
  ///}
  ///```
  final ZoomMode zoomMode;

  ///Maximum zoom level.
  ///
  ///Zooming will be stopped after reached this value.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           zoomPanBehavior: ZoomPanBehavior(enableSelectionZooming: true, maximumZoomLevel: 2),
  ///        ));
  ///}
  ///```
  final double? maximumZoomLevel;

  ///Border width of the selection zooming rectangle.
  ///
  ///Used to change the stroke width of the selection rectangle.
  ///
  ///Defaults to `1`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           zoomPanBehavior: ZoomPanBehavior(
  ///              enableSelectionZooming: true, selectionRectBorderWidth: 2),
  ///        ));
  ///}
  ///```
  final double selectionRectBorderWidth;

  ///Border color of the selection zooming rectangle.
  ///
  ///It used to change the stroke color of the selection rectangle.
  ///
  ///Defaults to `Colors.grey`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           zoomPanBehavior: ZoomPanBehavior(
  ///             enableSelectionZooming: true, selectionRectBorderColor: Colors.red),
  ///        ));
  ///}
  ///```
  final Color? selectionRectBorderColor;

  ///Color of the selection zooming rectangle.
  ///
  ///It used to change the background color of the selection rectangle.
  ///
  ///Defaults to `Color.fromRGBO(89, 244, 66, 0.2)`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           zoomPanBehavior: ZoomPanBehavior(
  ///             enableSelectionZooming: true, selectionRectColor: Colors.yellow),
  ///        ));
  ///}
  ///```
  final Color? selectionRectColor;

  SfCartesianChartState? _chartState;

  /// Increases the magnification of the plot area.
  void zoomIn() {
    final SfCartesianChartState chartState = _chartState!;
    final SfCartesianChart chart = chartState._chart;
    final ZoomPanBehaviorRenderer zoomPanBehaviorRenderer =
        chartState._zoomPanBehaviorRenderer;
    zoomPanBehaviorRenderer._isZoomIn = true;
    zoomPanBehaviorRenderer._isZoomOut = false;
    final double? zoomFactor = zoomPanBehaviorRenderer._zoomFactor;
    chartState._zoomProgress = true;
    ChartAxisRenderer axisRenderer;
    bool? needZoom;
    for (int index = 0;
        index < chartState._chartAxis._axisRenderersCollection.length;
        index++) {
      axisRenderer = chartState._chartAxis._axisRenderersCollection[index];
      if (axisRenderer._zoomFactor <= 1.0 && axisRenderer._zoomFactor > 0.0) {
        if (axisRenderer._zoomFactor - 0.1 < 0) {
          needZoom = false;
          break;
        } else {
          zoomPanBehaviorRenderer._setZoomFactorAndZoomPosition(
              chartState, axisRenderer, zoomFactor);
          needZoom = true;
        }
      }
      if (chart.onZooming != null) {
        ZoomPanArgs? zoomingArgs;
        _bindZoomEvent(chart, axisRenderer, zoomingArgs, chart.onZooming!);
      }
    }
    if (needZoom == true) {
      zoomPanBehaviorRenderer._createZoomState();
    }
  }

  /// Decreases the magnification of the plot area.
  void zoomOut() {
    final SfCartesianChartState chartState = _chartState!;
    final SfCartesianChart chart = chartState._chart;
    final ZoomPanBehaviorRenderer zoomPanBehaviorRenderer =
        chartState._zoomPanBehaviorRenderer;
    zoomPanBehaviorRenderer._isZoomOut = true;
    zoomPanBehaviorRenderer._isZoomIn = false;
    final double? zoomFactor = zoomPanBehaviorRenderer._zoomFactor;
    ChartAxisRenderer axisRenderer;
    for (int index = 0;
        index < chartState._chartAxis._axisRenderersCollection.length;
        index++) {
      axisRenderer = chartState._chartAxis._axisRenderersCollection[index];
      if (axisRenderer._zoomFactor < 1.0 && axisRenderer._zoomFactor > 0.0) {
        zoomPanBehaviorRenderer._setZoomFactorAndZoomPosition(
            chartState, axisRenderer, zoomFactor);
        axisRenderer._zoomFactor = axisRenderer._zoomFactor > 1.0
            ? 1.0
            : (axisRenderer._zoomFactor < 0.0 ? 0.0 : axisRenderer._zoomFactor);
      }
      if (chart.onZooming != null) {
        ZoomPanArgs? zoomingArgs;
        _bindZoomEvent(chart, axisRenderer, zoomingArgs, chart.onZooming!);
      }
    }
    zoomPanBehaviorRenderer._createZoomState();
  }

  /// Changes the zoom level using zoom factor.
  ///
  /// Here, you can pass the zoom factor of an axis to magnify the plot area. The value ranges from 0 to 1.
  void zoomByFactor(double zoomFactor) {
    final SfCartesianChartState chartState = _chartState!;
    final SfCartesianChart chart = chartState._chart;
    final ZoomPanBehaviorRenderer zoomPanBehaviorRenderer =
        chartState._zoomPanBehaviorRenderer;
    ChartAxisRenderer axisRenderer;
    for (int index = 0;
        index < chartState._chartAxis._axisRenderersCollection.length;
        index++) {
      axisRenderer = chartState._chartAxis._axisRenderersCollection[index];
      axisRenderer._zoomFactor = zoomFactor;
      if (chart.onZooming != null) {
        ZoomPanArgs? zoomingArgs;
        _bindZoomEvent(chart, axisRenderer, zoomingArgs, chart.onZooming!);
      }
      zoomPanBehaviorRenderer._createZoomState();
    }
  }

  /// Zooms the chart for a given rectangle value.
  ///
  ///  Here, you can pass the rectangle with the left, right, top, and bottom values,
  /// using which the selection zooming will be performed.
  void zoomByRect(Rect rect) {
    final SfCartesianChartState chartState = _chartState!;
    chartState._zoomPanBehaviorRenderer._doSelectionZooming(rect);
  }

  /// Change the zoom level of an appropriate axis.
  ///
  ///  Here, you need to pass axis, zoom factor, zoom position of the zoom level that needs to be modified.
  void zoomToSingleAxis(
      ChartAxis axis, double zoomPosition, double zoomFactor) {
    final SfCartesianChartState chartState = _chartState!;
    final ZoomPanBehaviorRenderer zoomPanBehaviorRenderer =
        chartState._zoomPanBehaviorRenderer;
    final ChartAxisRenderer? axisRenderer = _findExistingAxisRenderer(
        axis, chartState._chartAxis._axisRenderersCollection);
    if (axisRenderer != null) {
      axisRenderer._zoomFactor = zoomFactor;
      axisRenderer._zoomPosition = zoomPosition;
      zoomPanBehaviorRenderer._createZoomState();
    }
  }

  /// Pans the plot area for given left, right, top, and bottom directions.
  ///
  ///  To perform
  /// this action, the plot area needs to be in zoomed state.
  void panToDirection(String direction) {
    final SfCartesianChartState chartState = _chartState!;
    final SfCartesianChart chart = chartState._chart;
    final ZoomPanBehaviorRenderer zoomPanBehaviorRenderer =
        chartState._zoomPanBehaviorRenderer;
    ChartAxisRenderer axisRenderer;
    direction = direction.toLowerCase();
    for (int axisIndex = 0;
        axisIndex < chartState._chartAxis._axisRenderersCollection.length;
        axisIndex++) {
      axisRenderer = chartState._chartAxis._axisRenderersCollection[axisIndex];
      if (axisRenderer._orientation == AxisOrientation.horizontal) {
        if (direction == 'left') {
          axisRenderer._zoomPosition = (axisRenderer._zoomPosition > 0 &&
                  axisRenderer._zoomPosition <= 0.9)
              ? axisRenderer._zoomPosition - 0.1
              : axisRenderer._zoomPosition;
          axisRenderer._zoomPosition = axisRenderer._zoomPosition < 0.0
              ? 0.0
              : axisRenderer._zoomPosition;
        }
        if (direction == 'right') {
          axisRenderer._zoomPosition = (axisRenderer._zoomPosition >= 0 &&
                  axisRenderer._zoomPosition < 1)
              ? axisRenderer._zoomPosition + 0.1
              : axisRenderer._zoomPosition;
          axisRenderer._zoomPosition = axisRenderer._zoomPosition > 1.0
              ? 1.0
              : axisRenderer._zoomPosition;
        }
      } else {
        if (direction == 'bottom') {
          axisRenderer._zoomPosition = (axisRenderer._zoomPosition > 0 &&
                  axisRenderer._zoomPosition <= 0.9)
              ? axisRenderer._zoomPosition - 0.1
              : axisRenderer._zoomPosition;
          axisRenderer._zoomPosition = axisRenderer._zoomPosition < 0.0
              ? 0.0
              : axisRenderer._zoomPosition;
        }
        if (direction == 'top') {
          axisRenderer._zoomPosition = (axisRenderer._zoomPosition >= 0 &&
                  axisRenderer._zoomPosition < 1)
              ? axisRenderer._zoomPosition + 0.1
              : axisRenderer._zoomPosition;
          axisRenderer._zoomPosition = axisRenderer._zoomPosition > 1.0
              ? 1.0
              : axisRenderer._zoomPosition;
        }
      }
      if (chart.onZooming != null) {
        ZoomPanArgs? zoomingArgs;
        _bindZoomEvent(chart, axisRenderer, zoomingArgs, chart.onZooming!);
      }
    }
    zoomPanBehaviorRenderer._createZoomState();
  }

  /// Returns the plot area back to its original position after zooming.
  void reset() {
    final SfCartesianChartState chartState = _chartState!;
    final SfCartesianChart chart = chartState._chart;
    final ZoomPanBehaviorRenderer zoomPanBehaviorRenderer =
        chartState._zoomPanBehaviorRenderer;
    ChartAxisRenderer axisRenderer;
    for (int index = 0;
        index < chartState._chartAxis._axisRenderersCollection.length;
        index++) {
      axisRenderer = chartState._chartAxis._axisRenderersCollection[index];
      axisRenderer._zoomFactor = 1.0;
      axisRenderer._zoomPosition = 0.0;
      if (chart.onZoomReset != null) {
        ZoomPanArgs? zoomResetArgs;
        _bindZoomEvent(chart, axisRenderer, zoomResetArgs, chart.onZoomReset!);
      }
    }
    zoomPanBehaviorRenderer._createZoomState();
  }
}

/// Creates a renderer class for zoomPanBehavior class
class ZoomPanBehaviorRenderer with ZoomBehavior {
  /// Creates an argument constructor for ZoomPanBehavior renderer class
  ZoomPanBehaviorRenderer(this._chartState);

  ZoomPanBehavior get _zoomPanBehavior => _chart.zoomPanBehavior;
  SfCartesianChart get _chart => _chartState._chart;
  final SfCartesianChartState _chartState;
  late _ZoomRectPainter _painter;
  Offset? _previousMovedPosition;
  bool? _isPanning, _isPinching;
  bool _canPerformSelection = false;
  Rect _zoomingRect = const Rect.fromLTWH(0, 0, 0, 0);
  bool _delayRedraw = false;
  double? _zoomFactor, _zoomPosition;
  late bool _isZoomIn, _isZoomOut;
  Path? _rectPath;

  /// Below method for Double tap Zooming
  void _doubleTapZooming(double xPos, double yPos, double? zoomFactor) {
    _chartState._zoomProgress = true;
    ZoomPanArgs? zoomStartArgs;
    ChartAxisRenderer axisRenderer;
    double cumulative, origin, maxZoomFactor;
    for (int axisIndex = 0;
        axisIndex < _chartState._chartAxis._axisRenderersCollection.length;
        axisIndex++) {
      axisRenderer = _chartState._chartAxis._axisRenderersCollection[axisIndex];
      if (_chart.onZoomStart != null) {
        _bindZoomEvent(
            _chart, axisRenderer, zoomStartArgs, _chart.onZoomStart!);
      }
      axisRenderer._previousZoomFactor = axisRenderer._zoomFactor;
      axisRenderer._previousZoomPosition = axisRenderer._zoomPosition;
      if ((axisRenderer._orientation == AxisOrientation.vertical &&
              _zoomPanBehavior.zoomMode != ZoomMode.x) ||
          (axisRenderer._orientation == AxisOrientation.horizontal &&
              _zoomPanBehavior.zoomMode != ZoomMode.y)) {
        cumulative = math.max(
            math.max(1 / _minMax(axisRenderer._zoomFactor, 0, 1), 1) + (0.25),
            1);
        if (cumulative >= 1) {
          origin = axisRenderer._orientation == AxisOrientation.horizontal
              ? xPos / _chartState._chartAxis._axisClipRect.width
              : 1 - (yPos / _chartState._chartAxis._axisClipRect.height);
          origin = origin > 1
              ? 1
              : origin < 0
                  ? 0
                  : origin;
          zoomFactor = ((cumulative == 1)
              ? 1
              : _minMax(1 / cumulative, 0, 1).toDouble());
          _zoomPosition = (cumulative == 1)
              ? 0
              : axisRenderer._zoomPosition +
                  ((axisRenderer._zoomFactor - zoomFactor) * origin);
          if (axisRenderer._zoomPosition != _zoomPosition ||
              axisRenderer._zoomFactor != zoomFactor) {
            zoomFactor = (_zoomPosition! + zoomFactor) > 1
                ? (1 - _zoomPosition!)
                : zoomFactor;
          }

          axisRenderer._zoomPosition = _zoomPosition!;
          axisRenderer._zoomFactor = zoomFactor;
          axisRenderer._bounds = const Rect.fromLTWH(0, 0, 0, 0);
          axisRenderer._visibleLabels = <AxisLabel>[];
        }
        maxZoomFactor = _zoomPanBehavior.maximumZoomLevel ?? 0.1;
        if (zoomFactor! < maxZoomFactor) {
          axisRenderer._zoomFactor = maxZoomFactor;
          axisRenderer._zoomPosition = 0.0;
          zoomFactor = maxZoomFactor;
        }
      }

      if (_chart.onZoomEnd != null) {
        ZoomPanArgs? zoomEndArgs;
        _bindZoomEvent(_chart, axisRenderer, zoomEndArgs, _chart.onZoomEnd!);
      }
    }
    _createZoomState();
  }

  /// Below method is for panning the zoomed chart
  void _doPan(double xPos, double yPos) {
    num currentScale, value;
    ChartAxisRenderer axisRenderer;
    double currentZoomPosition;
    for (int axisIndex = 0;
        axisIndex < _chartState._chartAxis._axisRenderersCollection.length;
        axisIndex++) {
      axisRenderer = _chartState._chartAxis._axisRenderersCollection[axisIndex];
      axisRenderer._previousZoomFactor = axisRenderer._zoomFactor;
      axisRenderer._previousZoomPosition = axisRenderer._zoomPosition;
      if ((axisRenderer._orientation == AxisOrientation.vertical &&
              _zoomPanBehavior.zoomMode != ZoomMode.x) ||
          (axisRenderer._orientation == AxisOrientation.horizontal &&
              _zoomPanBehavior.zoomMode != ZoomMode.y)) {
        currentZoomPosition = axisRenderer._zoomPosition;
        currentScale = math.max(1 / _minMax(axisRenderer._zoomFactor, 0, 1), 1);
        if (axisRenderer._orientation == AxisOrientation.horizontal) {
          value = (_previousMovedPosition!.dx - xPos) /
              _chartState._chartAxis._axisClipRect.width /
              currentScale;
          currentZoomPosition = _minMax(
                  axisRenderer._axis.isInversed
                      ? axisRenderer._zoomPosition - value
                      : axisRenderer._zoomPosition + value,
                  0,
                  1 - axisRenderer._zoomFactor)
              .toDouble();
          axisRenderer._zoomPosition = currentZoomPosition;
        } else {
          value = (_previousMovedPosition!.dy - yPos) /
              _chartState._chartAxis._axisClipRect.height /
              currentScale;
          currentZoomPosition = _minMax(
                  axisRenderer._axis.isInversed
                      ? axisRenderer._zoomPosition + value
                      : axisRenderer._zoomPosition - value,
                  0,
                  1 - axisRenderer._zoomFactor)
              .toDouble();
          axisRenderer._zoomPosition = currentZoomPosition;
        }
      }
      if (_chart.onZooming != null) {
        ZoomPanArgs? zoomingArgs;
        _bindZoomEvent(_chart, axisRenderer, zoomingArgs, _chart.onZooming!);
      }
    }
    _createZoomState();
  }

  ///Below method for drawing selection  rectangle
  void _drawSelectionZoomRect(
      double currentX, double currentY, double startX, double startY) {
    final Rect clipRect = _chartState._chartAxis._axisClipRect;
    final Offset startPosition = Offset(
        (startX < clipRect.left) ? clipRect.left : startX,
        (startY < clipRect.top) ? clipRect.top : startY);
    final Offset currentMousePosition = Offset(
        (currentX > clipRect.right)
            ? clipRect.right
            : ((currentX < clipRect.left) ? clipRect.left : currentX),
        (currentY > clipRect.bottom)
            ? clipRect.bottom
            : ((currentY < clipRect.top) ? clipRect.top : currentY));
    _rectPath = Path();
    if (_zoomPanBehavior.zoomMode == ZoomMode.x) {
      _rectPath!.moveTo(startPosition.dx, clipRect.top);
      _rectPath!.lineTo(startPosition.dx, clipRect.bottom);
      _rectPath!.lineTo(currentMousePosition.dx, clipRect.bottom);
      _rectPath!.lineTo(currentMousePosition.dx, clipRect.top);
      _rectPath!.close();
    } else if (_zoomPanBehavior.zoomMode == ZoomMode.y) {
      _rectPath!.moveTo(clipRect.left, startPosition.dy);
      _rectPath!.lineTo(clipRect.left, currentMousePosition.dy);
      _rectPath!.lineTo(clipRect.right, currentMousePosition.dy);
      _rectPath!.lineTo(clipRect.right, startPosition.dy);
      _rectPath!.close();
    } else {
      _rectPath!.moveTo(startPosition.dx, startPosition.dy);
      _rectPath!.lineTo(startPosition.dx, currentMousePosition.dy);
      _rectPath!.lineTo(currentMousePosition.dx, currentMousePosition.dy);
      _rectPath!.lineTo(currentMousePosition.dx, startPosition.dy);
      _rectPath!.close();
    }
    _zoomingRect = _rectPath!.getBounds();
    _chartState._zoomRepaintNotifier.value++;
  }

  /// Below method for zooming selected portion
  void _doSelectionZooming(Rect zoomRect) {
    ZoomPanArgs? zoomEndArgs;
    final Rect rect = _chartState._chartAxis._axisClipRect;
    ChartAxisRenderer axisRenderer;
    for (int axisIndex = 0;
        axisIndex < _chartState._chartAxis._axisRenderersCollection.length;
        axisIndex++) {
      axisRenderer = _chartState._chartAxis._axisRenderersCollection[axisIndex];
      ZoomPanArgs? zoomStartArgs;
      if (_chart.onZoomStart != null) {
        _bindZoomEvent(
            _chart, axisRenderer, zoomStartArgs, _chart.onZoomStart!);
      }
      axisRenderer._previousZoomFactor = axisRenderer._zoomFactor;
      axisRenderer._previousZoomPosition = axisRenderer._zoomPosition;
      if (axisRenderer._orientation == AxisOrientation.horizontal) {
        if (_zoomPanBehavior.zoomMode != ZoomMode.y) {
          axisRenderer._zoomPosition +=
              ((zoomRect.left - rect.left) / (rect.width)).abs() *
                  axisRenderer._zoomFactor;
          axisRenderer._zoomFactor *= zoomRect.width / rect.width;
          if (_zoomPanBehavior.maximumZoomLevel != null) {
            axisRenderer._zoomFactor =
                axisRenderer._zoomFactor >= _zoomPanBehavior.maximumZoomLevel!
                    ? axisRenderer._zoomFactor
                    : _zoomPanBehavior.maximumZoomLevel!;
          }
        }
      } else {
        if (_zoomPanBehavior.zoomMode != ZoomMode.x) {
          axisRenderer._zoomPosition += (1 -
                  ((zoomRect.height + (zoomRect.top - rect.top)) /
                          (rect.height))
                      .abs()) *
              axisRenderer._zoomFactor;
          axisRenderer._zoomFactor *= zoomRect.height / rect.height;
          if (_zoomPanBehavior.maximumZoomLevel != null) {
            axisRenderer._zoomFactor =
                axisRenderer._zoomFactor >= _zoomPanBehavior.maximumZoomLevel!
                    ? axisRenderer._zoomFactor
                    : _zoomPanBehavior.maximumZoomLevel!;
          }
        }
      }
      if (_chart.onZoomEnd != null) {
        _bindZoomEvent(_chart, axisRenderer, zoomEndArgs, _chart.onZoomEnd!);
      }
    }

    zoomRect = const Rect.fromLTRB(0, 0, 0, 0);
    _rectPath = Path();
    _createZoomState();
  }

  /// Below method is for pinch zooming
  void _performPinchZooming(
      List<PointerEvent> touchStartList, List<PointerEvent> touchMoveList) {
    num touch0StartX,
        touch0StartY,
        touch1StartX,
        touch1StartY,
        touch0EndX,
        touch0EndY,
        touch1EndX,
        touch1EndY;
    if (!(_zoomingRect.width > 0 && _zoomingRect.height > 0)) {
      _calculateZoomAxesRange(_chart);
      _delayRedraw = true;
      final Rect offsetRect = _chartState._chartAxis._axisClipRect;
      final Rect elementOffsetRect = _chartState._containerRect;
      touch0StartX = touchStartList[0].position.dx - elementOffsetRect.left;
      touch0StartY = touchStartList[0].position.dy - elementOffsetRect.top;
      touch0EndX = touchMoveList[0].position.dx - elementOffsetRect.left;
      touch0EndY = touchMoveList[0].position.dy - elementOffsetRect.top;
      touch1StartX = touchStartList[1].position.dx - elementOffsetRect.left;
      touch1StartY = touchStartList[1].position.dy - elementOffsetRect.top;
      touch1EndX = touchMoveList[1].position.dx - elementOffsetRect.left;
      touch1EndY = touchMoveList[1].position.dy - elementOffsetRect.top;
      double scaleX, scaleY, clipX, clipY;
      Rect pinchRect;
      scaleX =
          (touch0EndX - touch1EndX).abs() / (touch0StartX - touch1StartX).abs();
      scaleY =
          (touch0EndY - touch1EndY).abs() / (touch0StartY - touch1StartY).abs();
      clipX = ((offsetRect.left - touch0EndX) / scaleX) +
          math.min(touch0StartX, touch1StartX);
      clipY = ((offsetRect.top - touch0EndY) / scaleY) +
          math.min(touch0StartY, touch1StartY);
      pinchRect = Rect.fromLTWH(
          clipX, clipY, offsetRect.width / scaleX, offsetRect.height / scaleY);
      _calculatePinchZoomFactor(_chart, pinchRect);
      _chartState._zoomProgress = true;
      _createZoomState();
    }
  }

  /// To create zoomed states
  void _createZoomState() {
    _chartState._zoomedAxisRendererStates = <ChartAxisRenderer>[];
    _chartState._zoomedAxisRendererStates
        .addAll(_chartState._chartAxis._axisRenderersCollection);
    _chartState._isLegendToggled = false;
    _chartState._redraw();
  }

  /// Below method is for pinch zooming
  void _calculatePinchZoomFactor(SfCartesianChart chart, Rect pinchRect) {
    final ZoomMode mode = _zoomPanBehavior.zoomMode;
    num selectionMin;
    num selectionMax;
    num rangeMin;
    num rangeMax;
    num value;
    num axisTrans;
    double currentZoomPosition;
    double currentZoomFactor;
    double currentFactor;
    double currentPosition;
    final Rect offsetRect = _chartState._chartAxis._axisClipRect;
    final List<_ZoomAxisRange> _zoomAxes = _chartState._zoomAxes;
    ChartAxisRenderer axisRenderer;
    double maxZoomFactor;
    for (int axisIndex = 0;
        axisIndex < _chartState._chartAxis._axisRenderersCollection.length;
        axisIndex++) {
      axisRenderer = _chartState._chartAxis._axisRenderersCollection[axisIndex];
      axisRenderer._previousZoomFactor = axisRenderer._zoomFactor;
      axisRenderer._previousZoomPosition = axisRenderer._zoomPosition;
      if ((axisRenderer._orientation == AxisOrientation.horizontal &&
              mode != ZoomMode.y) ||
          (axisRenderer._orientation == AxisOrientation.vertical &&
              mode != ZoomMode.x)) {
        if (axisRenderer._orientation == AxisOrientation.horizontal) {
          value = pinchRect.left - offsetRect.left;
          axisTrans = offsetRect.width / _zoomAxes[axisIndex].delta!;
          rangeMin = value / axisTrans + _zoomAxes[axisIndex].min!;
          value = pinchRect.left + pinchRect.width - offsetRect.left;
          rangeMax = value / axisTrans + _zoomAxes[axisIndex].min!;
        } else {
          value = pinchRect.top - offsetRect.top;
          axisTrans = offsetRect.height / _zoomAxes[axisIndex].delta!;
          rangeMin = (value * -1 + offsetRect.height) / axisTrans +
              _zoomAxes[axisIndex].min!;
          value = pinchRect.top + pinchRect.height - offsetRect.top;
          rangeMax = (value * -1 + offsetRect.height) / axisTrans +
              _zoomAxes[axisIndex].min!;
        }
        selectionMin = math.min(rangeMin, rangeMax);
        selectionMax = math.max(rangeMin, rangeMax);
        currentPosition = (selectionMin - _zoomAxes[axisIndex].actualMin!) /
            _zoomAxes[axisIndex].actualDelta!;
        currentFactor =
            (selectionMax - selectionMin) / _zoomAxes[axisIndex].actualDelta!;
        currentZoomPosition = currentPosition < 0 ? 0 : currentPosition;
        currentZoomFactor = currentFactor > 1 ? 1 : currentFactor;
        maxZoomFactor = _zoomPanBehavior.maximumZoomLevel ?? 0.1;
        if (currentZoomFactor < maxZoomFactor) {
          axisRenderer._zoomFactor = maxZoomFactor;
          axisRenderer._zoomPosition = 0.0;
          currentZoomFactor = maxZoomFactor;
        }
        onPinch(axisRenderer, currentZoomPosition, currentZoomFactor);
      }
      if (chart.onZooming != null) {
        ZoomPanArgs? zoomingArgs;
        _bindZoomEvent(chart, axisRenderer, zoomingArgs, chart.onZooming!);
      }
    }
  }

  num _minMax(num value, num min, num max) =>
      value > max ? max : (value < min ? min : value);

  /// Below method is for storing calculated zoom range
  void _calculateZoomAxesRange(SfCartesianChart chart) {
    ChartAxisRenderer axisRenderer;
    _ZoomAxisRange range;
    _VisibleRange axisRange;
    for (int index = 0;
        index < _chartState._chartAxis._axisRenderersCollection.length;
        index++) {
      axisRenderer = _chartState._chartAxis._axisRenderersCollection[index];
      range = _ZoomAxisRange();
      axisRange = axisRenderer._visibleRange!;
      if (_chartState._zoomAxes.isNotEmpty &&
          index <= _chartState._zoomAxes.length - 1) {
        if (!_delayRedraw) {
          _chartState._zoomAxes[index].min = axisRange.minimum.toDouble();
          _chartState._zoomAxes[index].delta = axisRange.delta.toDouble();
        }
      } else {
        // _chartState._zoomAxes ??= <_ZoomAxisRange>[];
        range.actualMin = axisRenderer._actualRange!.minimum.toDouble();
        range.actualDelta = axisRenderer._actualRange!.delta.toDouble();
        range.min = axisRange.minimum.toDouble();
        range.delta = axisRange.delta.toDouble();
        _chartState._zoomAxes.add(range);
      }
    }
  }

  /// Below method is for mouseWheel Zooming
  void _performMouseWheelZooming(
      PointerScrollEvent event, double mouseX, double mouseY) {
    final double direction = (event.scrollDelta.dy / 120) > 0 ? -1 : 1;
    double origin = 0.5;
    double cumulative, zoomFactor, zoomPosition, maxZoomFactor;
    _chartState._zoomProgress = true;
    _calculateZoomAxesRange(_chart);
    _isPanning = _chart.zoomPanBehavior.enablePanning;
    ZoomPanArgs? zoomStartArgs, zoomResetArgs;
    ChartAxisRenderer axisRenderer;
    for (int axisIndex = 0;
        axisIndex < _chartState._chartAxis._axisRenderersCollection.length;
        axisIndex++) {
      axisRenderer = _chartState._chartAxis._axisRenderersCollection[axisIndex];
      if (_chart.onZoomStart != null) {
        _bindZoomEvent(
            _chart, axisRenderer, zoomStartArgs, _chart.onZoomStart!);
      }
      axisRenderer._previousZoomFactor = axisRenderer._zoomFactor;
      axisRenderer._previousZoomPosition = axisRenderer._zoomPosition;
      if ((axisRenderer._orientation == AxisOrientation.vertical &&
              _zoomPanBehavior.zoomMode != ZoomMode.x) ||
          (axisRenderer._orientation == AxisOrientation.horizontal &&
              _zoomPanBehavior.zoomMode != ZoomMode.y)) {
        cumulative = math.max(
            math.max(1 / _minMax(axisRenderer._zoomFactor, 0, 1), 1) +
                (0.25 * direction),
            1);
        if (cumulative >= 1) {
          origin = axisRenderer._orientation == AxisOrientation.horizontal
              ? mouseX / _chartState._chartAxis._axisClipRect.width
              : 1 - (mouseY / _chartState._chartAxis._axisClipRect.height);
          origin = origin > 1
              ? 1
              : origin < 0
                  ? 0
                  : origin;
          zoomFactor = ((cumulative == 1) ? 1 : _minMax(1 / cumulative, 0, 1))
              .toDouble();
          zoomPosition = (cumulative == 1)
              ? 0
              : axisRenderer._zoomPosition +
                  ((axisRenderer._zoomFactor - zoomFactor) * origin);
          if (axisRenderer._zoomPosition != zoomPosition ||
              axisRenderer._zoomFactor != zoomFactor) {
            zoomFactor = (zoomPosition + zoomFactor) > 1
                ? (1 - zoomPosition)
                : zoomFactor;
          }
          axisRenderer._zoomPosition = zoomPosition;
          axisRenderer._zoomFactor = zoomFactor;
          axisRenderer._bounds = const Rect.fromLTWH(0, 0, 0, 0);
          axisRenderer._visibleLabels = <AxisLabel>[];
          maxZoomFactor = _zoomPanBehavior.maximumZoomLevel ?? 0.1;
          if (zoomFactor < maxZoomFactor) {
            axisRenderer._zoomFactor = maxZoomFactor;
            axisRenderer._zoomPosition = 0.0;
            zoomFactor = maxZoomFactor;
          }
          if (_chart.onZoomEnd != null) {
            ZoomPanArgs? zoomEndArgs;
            _bindZoomEvent(
                _chart, axisRenderer, zoomEndArgs, _chart.onZoomEnd!);
          }
          if (axisRenderer._zoomFactor.toInt() == 1 &&
              axisRenderer._zoomPosition.toInt() == 0 &&
              _chart.onZoomReset != null) {
            _bindZoomEvent(
                _chart, axisRenderer, zoomResetArgs, _chart.onZoomReset!);
          }
        }
      }
    }
    _createZoomState();
  }

  /// Below method is for zoomIn and zoomOut public methods
  void _setZoomFactorAndZoomPosition(SfCartesianChartState chartState,
      ChartAxisRenderer axisRenderer, double? zoomFactor) {
    final Rect axisClipRect = chartState._chartAxis._axisClipRect;
    final num direction = _isZoomIn
        ? 1
        : _isZoomOut
            ? -1
            : 1;
    final num cumulative = math.max(
        math.max(1 / _minMax(axisRenderer._zoomFactor, 0, 1), 1) +
            (0.1 * direction),
        1);
    if (cumulative >= 1) {
      num origin = axisRenderer._orientation == AxisOrientation.horizontal
          ? (axisClipRect.left + axisClipRect.width / 2) / axisClipRect.width
          : 1 -
              ((axisClipRect.top + axisClipRect.height / 2) /
                  axisClipRect.height);
      origin = origin > 1
          ? 1
          : origin < 0
              ? 0
              : origin;
      zoomFactor =
          ((cumulative == 1) ? 1 : _minMax(1 / cumulative, 0, 1)).toDouble();
      _zoomPosition = (cumulative == 1)
          ? 0
          : axisRenderer._zoomPosition +
              ((axisRenderer._zoomFactor - zoomFactor) * origin);
      if (axisRenderer._zoomPosition != _zoomPosition ||
          axisRenderer._zoomFactor != zoomFactor) {
        zoomFactor = (_zoomPosition! + zoomFactor) > 1
            ? (1 - _zoomPosition!)
            : zoomFactor;
      }

      axisRenderer._zoomPosition = _zoomPosition!;
      axisRenderer._zoomFactor = zoomFactor;
    }
  }

  /// Performs panning action.
  @override
  void onPan(double xPos, double yPos) => _doPan(xPos, yPos);

  /// Performs the double-tap action.
  @override
  void onDoubleTap(double xPos, double yPos, double? zoomFactor) =>
      _doubleTapZooming(xPos, yPos, zoomFactor);

  /// Draws selection zoomRect
  @override
  void onPaint(Canvas canvas) => _painter.drawRect(canvas);

  /// Performs selection zooming.
  @override
  void onDrawSelectionZoomRect(
          double currentX, double currentY, double startX, double startY) =>
      _drawSelectionZoomRect(currentX, currentY, startX, startY);

  /// Performs pinch start action.
  @override
  void onPinchStart(ChartAxis axis, double firstX, double firstY,
      double secondX, double secondY, double scaleFactor) {}

  /// Performs pinch end action.
  @override
  void onPinchEnd(ChartAxis axis, double firstX, double firstY, double secondX,
      double secondY, double scaleFactor) {}

  /// Performs pinch zooming.
  @override
  void onPinch(
      ChartAxisRenderer axisRenderer, double position, double scaleFactor) {
    axisRenderer._zoomFactor = scaleFactor;
    axisRenderer._zoomPosition = position;
  }
}

class _ZoomAxisRange {
  _ZoomAxisRange({this.actualMin, this.actualDelta, this.min, this.delta});
  double? actualMin, actualDelta, min, delta;
}
