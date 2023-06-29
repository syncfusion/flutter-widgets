import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../series/spark_area_base.dart';
import '../series/spark_bar_base.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import 'spark_chart_trackball.dart';

/// Represents the trackball renderer.
@immutable
class SparkChartTrackballRenderer extends StatefulWidget {
  /// Creates the trackball renderer.
  const SparkChartTrackballRenderer(
      {Key? key,
      this.trackball,
      this.coordinatePoints,
      this.dataPoints,
      this.sparkChart})
      : super(key: key);

  /// Specifies the spark chart trackball.
  final SparkChartTrackball? trackball;

  /// Specifies the coordinate points.
  final List<Offset>? coordinatePoints;

  /// Specifies the spark chart data points.
  final List<SparkChartPoint>? dataPoints;

  /// Specifie the spark chart widget.
  final Widget? sparkChart;

  @override
  State<StatefulWidget> createState() {
    return _SparckChartTrackballRendererState();
  }
}

/// Represents the state class of spark chart trackball renderer.
class _SparckChartTrackballRendererState
    extends State<SparkChartTrackballRenderer> {
  /// Holds the trackball repaint notifier.
  ValueNotifier<int>? _trackballRepaintNotifier;

  /// Specifies whether the track ball is enabled.
  bool _isTrackballEnabled = false;

  /// Specifies the current touch position.
  Offset? _touchPosition;

  /// Specifies the spark area bounds
  Rect? _areaBounds;

  /// Specifies the local rect.
  Rect? _localBounds;

  /// Specifies the nearest point index.
  int? _currentIndex;

  /// Specifies the global position.
  Offset? _globalPosition;

  /// Specifies the theme of the chart.
  SfChartThemeData? _chartThemeData;

  /// Specifies the theme data of the chart.
  ThemeData? _themeData;

  /// Specifies the current data point.
  SparkChartPoint? _currentDataPoint;

  /// Specifies the current coordinate point.
  Offset? _currentCoordinatePoint;

  /// Specifies the trackball timer.
  Timer? _timer;

  /// Specifies whether to render the trackball on top.
  bool? _isTop;

  final bool _enableMouseHover = kIsWeb;

  @override
  void initState() {
    _trackballRepaintNotifier = ValueNotifier<int>(0);
    super.initState();
  }

  @override
  void didUpdateWidget(SparkChartTrackballRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _chartThemeData = SfChartTheme.of(context);
    _themeData = Theme.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        // Using the _enableMouseHover property, prevented mouse hover function in mobile platforms. The mouse hover event should not be triggered for mobile platforms and logged an issue regarding this to the Flutter team.
        // Issue:  https://github.com/flutter/flutter/issues/68690
        onHover: (PointerHoverEvent event) => _enableMouseHover
            ? _enableAndUpdateTrackball(context, event.position)
            : null,
        onExit: (PointerExitEvent event) => _hide(),
        child: Listener(
          onPointerUp: (PointerUpEvent event) => _hide(),
          child: GestureDetector(
              onVerticalDragStart: (widget.trackball != null && widget.trackball!.activationMode != SparkChartActivationMode.doubleTap)
                  ? (DragStartDetails details) =>
                      _updateDragValue(context, details.globalPosition)
                  : null,
              onVerticalDragUpdate: (widget.trackball != null && widget.trackball!.activationMode != SparkChartActivationMode.doubleTap)
                  ? (DragUpdateDetails details) =>
                      _updateDragValue(context, details.globalPosition)
                  : null,
              onHorizontalDragStart:
                  (widget.trackball != null && widget.trackball!.activationMode != SparkChartActivationMode.doubleTap)
                      ? (DragStartDetails details) =>
                          _updateDragValue(context, details.globalPosition)
                      : null,
              onHorizontalDragUpdate:
                  (widget.trackball != null && widget.trackball!.activationMode != SparkChartActivationMode.doubleTap)
                      ? (DragUpdateDetails details) =>
                          _updateDragValue(context, details.globalPosition)
                      : null,
              onTapDown: (widget.trackball != null && widget.trackball!.activationMode == SparkChartActivationMode.tap)
                  ? (TapDownDetails details) =>
                      _enableAndUpdateTrackball(context, details.globalPosition)
                  : null,
              onLongPressStart: (widget.trackball != null && widget.trackball!.activationMode == SparkChartActivationMode.longPress)
                  ? (LongPressStartDetails details) =>
                      _enableAndUpdateTrackball(context, details.globalPosition)
                  : null,
              onLongPressMoveUpdate: (widget.trackball != null && widget.trackball!.activationMode == SparkChartActivationMode.longPress) ? (LongPressMoveUpdateDetails details) => _updateDragValue(context, details.globalPosition) : null,
              onDoubleTapDown: (widget.trackball != null && widget.trackball!.activationMode == SparkChartActivationMode.doubleTap) ? (TapDownDetails details) => _enableAndUpdateTrackball(context, details.globalPosition) : null,
              onDoubleTap: (widget.trackball != null && widget.trackball!.activationMode == SparkChartActivationMode.doubleTap) ? () => _updateDragValue(context, _globalPosition!) : null,
              child: _addTrackballPainter()),
        ));
  }

  /// Method to hide the trackball.
  void _hide() {
    if (widget.trackball != null && !widget.trackball!.shouldAlwaysShow) {
      if (_timer != null) {
        _timer!.cancel();
      }

      _trackballRepaintNotifier!.value++;
      _timer = Timer(
          Duration(milliseconds: widget.trackball!.hideDelay.toInt()), () {
        _trackballRepaintNotifier!.value++;
        _endTrackballDragging();
      });
    }
  }

  /// Method to add the trackball painter.
  Widget _addTrackballPainter() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // ignore: avoid_unnecessary_containers
        return Container(
          child: RepaintBoundary(
            child: CustomPaint(
                painter: TrackballPainter(_trackballRepaintNotifier!,
                    _isTrackballEnabled, widget.trackball, this),
                size: Size(constraints.maxWidth, constraints.maxHeight)),
          ),
        );
      },
    );
  }

  /// Method to enable the trackball behavior.
  void _enableTrackballBehavior(BuildContext context, Offset globalPosition) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size renderBoxSize = renderBox.size;
    final Offset renderBoxOffset = renderBox.localToGlobal(Offset.zero);
    _areaBounds = Rect.fromLTWH(renderBoxOffset.dx, renderBoxOffset.dy,
        renderBoxSize.width, renderBoxSize.height);
    _localBounds =
        Rect.fromLTWH(0, 0, renderBoxSize.width, renderBoxSize.height);
    _globalPosition = globalPosition;
    _touchPosition = renderBox.globalToLocal(globalPosition);
    if (_localBounds!.contains(_touchPosition!)) {
      _isTrackballEnabled = true;
    }
  }

  /// Method to disable the trackball dragging.
  void _endTrackballDragging() {
    if (_isTrackballEnabled) {
      _isTrackballEnabled = false;
      _touchPosition = null;
      _globalPosition = null;
      _currentIndex = null;
      _currentDataPoint = null;
      _currentCoordinatePoint = null;
      _isTop = false;
    }
  }

  /// Method to update the trackball value.
  void _updateDragValue(BuildContext context, Offset globalPosition) {
    _currentIndex = null;
    _isTop = false;
    int? index;
    if (_isTrackballEnabled) {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      _touchPosition = renderBox.globalToLocal(globalPosition);
      final double currentXPoint = _touchPosition!.dx;
      double xPoint;
      double? temp;
      double diff;
      for (int i = 0; i < widget.coordinatePoints!.length; i++) {
        xPoint = widget.coordinatePoints![i].dx;
        diff = (currentXPoint - xPoint).abs();
        if (temp == null || temp > diff) {
          temp = diff;
          index = i;
        }
      }

      if (index != null) {
        if (index == 0 && widget.sparkChart is SfSparkAreaChart) {
          index = 1;
        } else if (widget.sparkChart is SfSparkBarChart) {
          _isTop = true;
        }
        _currentDataPoint = widget.dataPoints![index];
        _currentCoordinatePoint = widget.coordinatePoints![index];
        _trackballRepaintNotifier!.value++;
      }

      _currentIndex = index;
    }
  }

  /// Method to enable and update the track ball value.
  void _enableAndUpdateTrackball(BuildContext context, Offset globalPosition) {
    _enableTrackballBehavior(context, globalPosition);
    _updateDragValue(context, globalPosition);
  }
}

/// Represnts the painter to render the trackball.
class TrackballPainter extends CustomPainter {
  /// Creates the painter to render the trackball.
  TrackballPainter(
      ValueNotifier<num> notifier,
      this._isRepaint,
      this._trackball,
      // ignore: library_private_types_in_public_api
      this._rendererState)
      : super(repaint: notifier);

  /// Specifies whether to repaint the series.
  final bool _isRepaint;

  /// Specifies the trackball of spark chart.
  final SparkChartTrackball? _trackball;

  /// Specifies the trackball renderer state.
  final _SparckChartTrackballRendererState _rendererState;

  @override
  void paint(Canvas canvas, Size size) {
    final num? index = _rendererState._currentIndex;
    if (index != null && _trackball != null) {
      final Offset screenPoint = _rendererState._currentCoordinatePoint!;
      _drawTrackLine(canvas, _rendererState._areaBounds!, screenPoint, size);
      _renderTrackballTooltip(canvas, screenPoint, index, size);
    }
  }

  /// Method to render the trackball tooltip.
  void _renderTrackballTooltip(
      Canvas canvas, Offset? screenPoint, num index, Size size) {
    Offset labelOffset = screenPoint!;
    final String dataLabel = _getTrackballLabel();
    final TextStyle labelStyle = _getTrackballLabelStyle();
    final Size textSize = getTextSize(dataLabel, labelStyle);
    final Rect areaBounds = _rendererState._areaBounds!;
    BorderRadius borderRadius = _trackball!.borderRadius;
    double rectWidth = textSize.width;
    if (rectWidth < 10) {
      rectWidth = 10;
      borderRadius = _getBorderRadius(borderRadius, rectWidth / 2);
    }

    final double textWidth = textSize.height / 2;
    borderRadius = _getBorderRadius(borderRadius, textWidth);
    Rect labelRect = Rect.fromLTWH(screenPoint.dx, screenPoint.dy,
        textSize.width + 15, textSize.height + 10);
    const double tooltipPadding = 5;
    const double pointerWidth = 5;
    const double pointerLength = 7;
    final double totalWidth = areaBounds.right - areaBounds.left;
    final double totalHeight = areaBounds.bottom - areaBounds.top;
    final bool isTop = _rendererState._isTop!;
    bool isRight = false;
    double xPosition;
    double yPosition;
    bool isBottom = false;
    // ignore: unnecessary_null_comparison
    if (screenPoint != null) {
      if (!isTop) {
        xPosition = screenPoint.dx + pointerLength + tooltipPadding;
        yPosition = screenPoint.dy - labelRect.height / 2;
        if ((xPosition + labelRect.width) > totalWidth) {
          xPosition = (xPosition - labelRect.width - 2 * tooltipPadding) -
              2 * pointerLength;
          isRight = true;
        } else if (xPosition >= totalWidth) {
          xPosition = totalWidth - (xPosition + labelRect.width);
          isRight = true;
        }

        if (yPosition <= 0) {
          yPosition = 0;
        } else if (yPosition + labelRect.height >= totalHeight) {
          yPosition = totalHeight - labelRect.height;
        }
      } else {
        const double padding = 2;
        xPosition = screenPoint.dx - (labelRect.width / 2);

        final double tooltipRight = screenPoint.dx + (labelRect.width) / 2;
        if (screenPoint.dy > (pointerLength + labelRect.height + padding) &&
            screenPoint.dy > 0) {
          yPosition =
              screenPoint.dy - labelRect.height - padding - pointerLength;
        } else {
          isBottom = true;
          yPosition = (screenPoint.dy > 0 ? screenPoint.dy : 0) +
              pointerLength +
              padding;
          if ((yPosition + labelRect.height) > size.height) {
            final double y = size.height - (yPosition + labelRect.height);
            screenPoint = Offset(screenPoint.dx, y);
            yPosition = (screenPoint.dy > 0 ? screenPoint.dy : 0) +
                pointerLength +
                padding;
          }
        }

        xPosition = xPosition < 0
            ? 0
            : (tooltipRight > totalWidth
                ? totalWidth - labelRect.width
                : xPosition);
      }

      labelRect = Rect.fromLTWH(
          xPosition, yPosition, labelRect.width, labelRect.height);
      _drawTrackballRect(canvas, textSize, labelRect, isRight, borderRadius,
          pointerWidth, pointerLength, screenPoint, isTop, isBottom);

      final double labelOffsetX =
          (labelRect.left + labelRect.width / 2) - textSize.width / 2;
      final double labelOffsetY =
          (labelRect.top + labelRect.height / 2) - textSize.height / 2;
      labelOffset = Offset(labelOffsetX, labelOffsetY);
      drawText(canvas, dataLabel, labelOffset, labelStyle);
    }
  }

  /// Method returns the trackball label.
  String _getTrackballLabel() {
    final SparkChartPoint currentPoint = _rendererState._currentDataPoint!;
    String dataLabel = currentPoint.labelY!;
    final String? labelX = currentPoint.labelX;
    dataLabel = labelX != null ? '$labelX : $dataLabel' : dataLabel;
    if (_trackball!.tooltipFormatter != null) {
      final TooltipFormatterDetails tooltipFormatterDetails =
          TooltipFormatterDetails(
              x: currentPoint.actualX, y: currentPoint.y, label: dataLabel);
      dataLabel = _trackball!.tooltipFormatter!(tooltipFormatterDetails);
    }

    return dataLabel;
  }

  /// Method to return the trackball label style.
  TextStyle _getTrackballLabelStyle() {
    return _rendererState._themeData!.textTheme.bodySmall!
        .copyWith(
            color:
                _rendererState._chartThemeData!.brightness == Brightness.light
                    ? const Color.fromRGBO(229, 229, 229, 1)
                    : const Color.fromRGBO(0, 0, 0, 1))
        .merge(_rendererState._chartThemeData!.trackballTextStyle)
        .merge(_trackball!.labelStyle);
  }

  /// Method to get the border radius.
  BorderRadius _getBorderRadius(BorderRadius borderRadius, double value) {
    return BorderRadius.only(
        topLeft: borderRadius.topLeft.x > value
            ? BorderRadius.circular(value).topLeft
            : borderRadius.topLeft,
        topRight: borderRadius.topRight.x > value
            ? BorderRadius.circular(value).topRight
            : borderRadius.topRight,
        bottomLeft: borderRadius.bottomLeft.x > value
            ? BorderRadius.circular(value).bottomLeft
            : borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight.x > value
            ? BorderRadius.circular(value).bottomRight
            : borderRadius.bottomRight);
  }

  /// Method to draw the trackball rect.
  void _drawTrackballRect(
      Canvas canvas,
      Size textSize,
      Rect rect,
      bool isRight,
      BorderRadius borderRadius,
      double pointerWidth,
      double pointerLength,
      Offset screenPoint,
      bool isTop,
      bool isBottom) {
    final Color backgroundColor =
        _rendererState._chartThemeData!.brightness == Brightness.light
            ? const Color.fromRGBO(79, 79, 79, 1)
            : const Color.fromRGBO(255, 255, 255, 1);
    final Paint paint = Paint()
      ..color = _trackball!.backgroundColor ?? backgroundColor;
    final Path path = Path();
    if (!isTop) {
      if (isRight) {
        path.moveTo(rect.right, rect.top + rect.height / 2 - pointerWidth);
        path.lineTo(rect.right, rect.bottom - rect.height / 2 + pointerWidth);
        path.lineTo(rect.right + pointerLength, screenPoint.dy);
        path.lineTo(rect.right + pointerLength, screenPoint.dy);
        path.lineTo(rect.right, rect.top + rect.height / 2 - pointerWidth);
      } else {
        path.moveTo(rect.left, rect.top + rect.height / 2 - pointerWidth);
        path.lineTo(rect.left, rect.bottom - rect.height / 2 + pointerWidth);
        path.lineTo(rect.left - pointerLength, screenPoint.dy);
        path.lineTo(rect.left, rect.top + rect.height / 2 - pointerWidth);
      }
    } else {
      final double yValue = isBottom ? rect.top : rect.bottom;
      path.moveTo(rect.left + rect.width / 2 - pointerWidth, yValue);
      path.lineTo(rect.left + rect.width / 2 + pointerWidth, yValue);
      path.lineTo(
          screenPoint.dx, yValue + (isBottom ? -pointerLength : pointerLength));
      path.lineTo(rect.left + rect.width / 2 - pointerWidth, yValue);
    }

    final RRect roundedRect = RRect.fromRectAndCorners(
      rect,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
    );

    path.addRRect(roundedRect);
    canvas.drawPath(path, paint);

    if (_trackball!.borderColor != null &&
        _trackball!.borderColor != Colors.transparent &&
        _trackball!.borderWidth > 0) {
      final Paint borderPaint = Paint()
        ..color = _trackball!.borderColor!
        ..strokeWidth = _trackball!.borderWidth
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, borderPaint);
    }
  }

  /// Method to render the trackball line.
  void _drawTrackLine(
      Canvas canvas, Rect areaBounds, Offset screenPoint, Size size) {
    final Paint paint = Paint()
      ..color = _trackball!.color ??
          (_rendererState._chartThemeData!.brightness == Brightness.light
              ? const Color.fromRGBO(79, 79, 79, 1)
              : const Color.fromRGBO(255, 255, 255, 1))
      ..strokeWidth = _trackball!.width
      ..style = PaintingStyle.stroke;
    final Offset point1 = Offset(screenPoint.dx, 0);
    final Offset point2 = Offset(screenPoint.dx, size.height);
    if (_trackball!.dashArray != null && _trackball!.dashArray!.isNotEmpty) {
      drawDashedPath(canvas, paint, point1, point2, _trackball!.dashArray);
    } else {
      canvas.drawLine(point1, point2, paint);
    }
  }

  @override
  bool shouldRepaint(TrackballPainter oldDelegate) => _isRepaint;
}
