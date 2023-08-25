import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';
import '../../common/event_args.dart';
import '../../common/rendering_details.dart';
import '../axis/axis.dart';
import '../axis/category_axis.dart';
import '../base/chart_base.dart';
import '../common/cartesian_state_properties.dart';
import '../common/renderer.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import 'crosshair.dart';

/// Represents the crosshair painter.
class CrosshairPainter extends CustomPainter {
  /// Calling the default constructor of CrosshairPainter class.
  CrosshairPainter({required this.stateProperties, required this.valueNotifier})
      : chart = stateProperties.chart,
        super(repaint: valueNotifier);

  /// Represents the cartesian state properties.
  final CartesianStateProperties stateProperties;

  /// Represents the cartesian chart.
  final SfCartesianChart chart;

  RenderingDetails get _renderingDetails => stateProperties.renderingDetails;

  /// Represents the value of timer.
  Timer? timer;

  /// Repaint notifier for crosshair.
  ValueNotifier<int> valueNotifier;

  // double pointerLength;
  // double pointerWidth;

  /// Represents the nose point y value.
  double nosePointY = 0;

  /// Represents the nose point x value.
  double nosePointX = 0;

  /// Represents the total width value.
  double totalWidth = 0;

  // double x;
  // double y;
  // double xPos;
  // double yPos;

  /// Represents the value of isTop.
  bool isTop = false;

  // double cornerRadius;

  /// Represents the background path value for crosshair.
  Path backgroundPath = Path();

  /// Represents the canResetPath value of crosshair.
  bool canResetPath = true;

  /// Represents the value of isleft.
  bool isLeft = false;

  /// Represents the value of isRight.
  bool isRight = false;

  // bool enable;

  /// Represents the padding value for crosshair.
  double padding = 0;

  /// Specifies the list of string value for the crosshair tooltip.
  List<String> stringValue = <String>[];

  /// Represents the boundary rect for crosshair.
  Rect boundaryRect = Rect.zero;

  /// Represents the left padding for crosshair.
  double leftPadding = 0;

  /// Represents the top padding for crosshair.
  double topPadding = 0;

  /// Specifies whether the orientation is horizontal or not.
  bool isHorizontalOrientation = false;

  // TextStyle labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    if (!canResetPath) {
      stateProperties.crosshairBehaviorRenderer.onPaint(canvas);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  /// Calculate trackball points.
  void generateAllPoints(Offset position) {
    final Rect axisClipRect = stateProperties.chartAxis.axisClipRect;
    double dx, dy;
    dx = position.dx > axisClipRect.right
        ? axisClipRect.right
        : position.dx < axisClipRect.left
            ? axisClipRect.left
            : position.dx;
    dy = position.dy > axisClipRect.bottom
        ? axisClipRect.bottom
        : position.dy < axisClipRect.top
            ? axisClipRect.top
            : position.dy;
    CrosshairHelper.getRenderingDetails(
            stateProperties.crosshairBehaviorRenderer)
        .position = Offset(dx, dy);
  }

  /// Gets the line painter.
  Paint getLinePainter(Paint crosshairLinePaint) => crosshairLinePaint;

  /// Draw the path of the crosshair line.
  void drawCrosshairLine(Canvas canvas, Paint paint, int? index) {
    final CrosshairRenderingDetails renderingDetails =
        CrosshairHelper.getRenderingDetails(
            stateProperties.crosshairBehaviorRenderer);
    if (renderingDetails.position != null) {
      final Path dashArrayPath = Path();
      if ((chart.crosshairBehavior.lineType == CrosshairLineType.horizontal ||
              chart.crosshairBehavior.lineType == CrosshairLineType.both) &&
          chart.crosshairBehavior.lineWidth != 0) {
        dashArrayPath.moveTo(stateProperties.chartAxis.axisClipRect.left,
            renderingDetails.position!.dy);
        dashArrayPath.lineTo(stateProperties.chartAxis.axisClipRect.right,
            renderingDetails.position!.dy);
        chart.crosshairBehavior.lineDashArray != null
            ? drawDashedLine(canvas, chart.crosshairBehavior.lineDashArray!,
                paint, dashArrayPath)
            : canvas.drawPath(dashArrayPath, paint);
      }
      if ((chart.crosshairBehavior.lineType == CrosshairLineType.vertical ||
              chart.crosshairBehavior.lineType == CrosshairLineType.both) &&
          chart.crosshairBehavior.lineWidth != 0) {
        dashArrayPath.moveTo(renderingDetails.position!.dx,
            stateProperties.chartAxis.axisClipRect.top);
        dashArrayPath.lineTo(renderingDetails.position!.dx,
            stateProperties.chartAxis.axisClipRect.bottom);
        chart.crosshairBehavior.lineDashArray != null
            ? drawDashedLine(canvas, chart.crosshairBehavior.lineDashArray!,
                paint, dashArrayPath)
            : canvas.drawPath(dashArrayPath, paint);
      }
    }
  }

  /// To draw crosshair.
  void drawCrosshair(Canvas canvas) {
    final Paint fillPaint = Paint()
      ..color = _renderingDetails.chartTheme.crosshairBackgroundColor
      ..strokeCap = StrokeCap.butt
      ..isAntiAlias = false
      ..style = PaintingStyle.fill;

    final Paint strokePaint = Paint()
      ..color = _renderingDetails.chartTheme.crosshairBackgroundColor
      ..strokeCap = StrokeCap.butt
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;
    chart.crosshairBehavior.lineWidth == 0
        ? strokePaint.color = Colors.transparent
        : strokePaint.color = strokePaint.color;

    final Paint crosshairLinePaint = Paint();
    final CrosshairRenderingDetails renderingDetails =
        CrosshairHelper.getRenderingDetails(
            stateProperties.crosshairBehaviorRenderer);
    if (renderingDetails.position != null) {
      final Offset position = renderingDetails.position!;

      crosshairLinePaint.color = chart.crosshairBehavior.lineColor ??
          _renderingDetails.chartTheme.crosshairLineColor;
      crosshairLinePaint.strokeWidth = chart.crosshairBehavior.lineWidth;
      crosshairLinePaint.style = PaintingStyle.stroke;
      CrosshairRenderArgs crosshairEventArgs;
      if (chart.onCrosshairPositionChanging != null) {
        crosshairEventArgs = CrosshairRenderArgs();
        crosshairEventArgs.text = '';
        crosshairEventArgs.lineColor = crosshairLinePaint.color;
        chart.onCrosshairPositionChanging!(crosshairEventArgs);
        crosshairLinePaint.color = crosshairEventArgs.lineColor;
      }
      renderingDetails.drawLine(
          canvas, renderingDetails.linePainter(crosshairLinePaint), null);

      _drawBottomAxesTooltip(canvas, position, strokePaint, fillPaint);
      _drawTopAxesTooltip(canvas, position, strokePaint, fillPaint);
      _drawLeftAxesTooltip(canvas, position, strokePaint, fillPaint);
      _drawRightAxesTooltip(canvas, position, strokePaint, fillPaint);
    }
  }

  /// Draw bottom axes tooltip.
  void _drawBottomAxesTooltip(
      Canvas canvas, Offset position, Paint strokePaint, Paint fillPaint) {
    ChartAxisRendererDetails axisDetails;
    String value;
    Size labelSize;
    Rect labelRect, validatedRect;
    RRect tooltipRect;
    //ignore: unused_local_variable
    Color? color;
    const double padding = 10;
    CrosshairRenderArgs crosshairEventArgs;
    for (int index = 0;
        index < stateProperties.chartAxis.bottomAxesCount.length;
        index++) {
      axisDetails = AxisHelper.getAxisRendererDetails(
          stateProperties.chartAxis.bottomAxesCount[index].axisRenderer);
      final ChartAxis axis = axisDetails.axis;
      final TextStyle crosshairTextStyle =
          axisDetails.chartThemeData.crosshairTextStyle!;

      if (_needToAddTooltip(axisDetails)) {
        fillPaint.color = axis.interactiveTooltip.color ??
            _renderingDetails.chartTheme.crosshairBackgroundColor;
        strokePaint.color = axis.interactiveTooltip.borderColor ??
            _renderingDetails.chartTheme.crosshairBackgroundColor;
        strokePaint.strokeWidth = axis.interactiveTooltip.borderWidth;
        value = _getXValue(axisDetails.axisRenderer, position);
        if (chart.onCrosshairPositionChanging != null) {
          crosshairEventArgs = CrosshairRenderArgs(
              axis, value, axisDetails.name, axisDetails.orientation);
          crosshairEventArgs.text = value;
          crosshairEventArgs.lineColor = chart.crosshairBehavior.lineColor ??
              _renderingDetails.chartTheme.crosshairLineColor;
          chart.onCrosshairPositionChanging!(crosshairEventArgs);
          value = crosshairEventArgs.text;
          color = crosshairEventArgs.lineColor;
        }
        labelSize = measureText(value, crosshairTextStyle);
        labelRect = Rect.fromLTWH(
            position.dx - (labelSize.width / 2 + padding / 2),
            axisDetails.bounds.top + axis.interactiveTooltip.arrowLength,
            labelSize.width + padding,
            labelSize.height + padding);
        labelRect =
            validateRectBounds(labelRect, _renderingDetails.chartContainerRect);
        validatedRect = validateRectXPosition(labelRect, stateProperties);
        backgroundPath.reset();
        tooltipRect = getRoundedCornerRect(
            validatedRect, axis.interactiveTooltip.borderRadius);
        backgroundPath.addRRect(tooltipRect);
        drawTooltipArrowhead(
            canvas,
            backgroundPath,
            fillPaint,
            strokePaint,
            position.dx,
            tooltipRect.top - axis.interactiveTooltip.arrowLength,
            (tooltipRect.right - tooltipRect.width / 2) +
                axis.interactiveTooltip.arrowWidth,
            tooltipRect.top,
            (tooltipRect.left + tooltipRect.width / 2) -
                axis.interactiveTooltip.arrowWidth,
            tooltipRect.top,
            position.dx,
            tooltipRect.top - axis.interactiveTooltip.arrowLength);
        _drawTooltipText(
            canvas, value, crosshairTextStyle, tooltipRect, labelSize);
      }
    }
  }

  /// Draw top axes tooltip.
  void _drawTopAxesTooltip(
      Canvas canvas, Offset position, Paint strokePaint, Paint fillPaint) {
    ChartAxis axis;
    ChartAxisRendererDetails axisDetails;
    String value;
    Size labelSize;
    Rect labelRect, validatedRect;
    RRect tooltipRect;
    const double padding = 10;
    //ignore: unused_local_variable
    Color? color;
    CrosshairRenderArgs crosshairEventArgs;
    for (int index = 0;
        index < stateProperties.chartAxis.topAxesCount.length;
        index++) {
      axisDetails = AxisHelper.getAxisRendererDetails(
          stateProperties.chartAxis.topAxesCount[index].axisRenderer);
      axis = axisDetails.axis;
      final TextStyle crosshairTextStyle =
          axisDetails.chartThemeData.crosshairTextStyle!;
      if (_needToAddTooltip(axisDetails)) {
        fillPaint.color = axis.interactiveTooltip.color ??
            _renderingDetails.chartTheme.crosshairBackgroundColor;
        strokePaint.color = axis.interactiveTooltip.borderColor ??
            _renderingDetails.chartTheme.crosshairBackgroundColor;
        strokePaint.strokeWidth = axis.interactiveTooltip.borderWidth;
        value = _getXValue(axisDetails.axisRenderer, position);
        if (chart.onCrosshairPositionChanging != null) {
          crosshairEventArgs = CrosshairRenderArgs(axisDetails.axis, value,
              axisDetails.name, axisDetails.orientation);
          crosshairEventArgs.text = value;
          crosshairEventArgs.lineColor = chart.crosshairBehavior.lineColor ??
              _renderingDetails.chartTheme.crosshairLineColor;
          chart.onCrosshairPositionChanging!(crosshairEventArgs);
          value = crosshairEventArgs.text;
          color = crosshairEventArgs.lineColor;
        }
        labelSize = measureText(value, crosshairTextStyle);
        labelRect = Rect.fromLTWH(
            position.dx - (labelSize.width / 2 + padding / 2),
            axisDetails.bounds.top -
                (labelSize.height + padding) -
                axis.interactiveTooltip.arrowLength,
            labelSize.width + padding,
            labelSize.height + padding);
        labelRect =
            validateRectBounds(labelRect, _renderingDetails.chartContainerRect);
        validatedRect = validateRectXPosition(labelRect, stateProperties);
        backgroundPath.reset();
        tooltipRect = getRoundedCornerRect(
            validatedRect, axis.interactiveTooltip.borderRadius);
        backgroundPath.addRRect(tooltipRect);
        drawTooltipArrowhead(
            canvas,
            backgroundPath,
            fillPaint,
            strokePaint,
            position.dx,
            tooltipRect.bottom + axis.interactiveTooltip.arrowLength,
            (tooltipRect.right - tooltipRect.width / 2) +
                axis.interactiveTooltip.arrowWidth,
            tooltipRect.bottom,
            (tooltipRect.left + tooltipRect.width / 2) -
                axis.interactiveTooltip.arrowWidth,
            tooltipRect.bottom,
            position.dx,
            tooltipRect.bottom + axis.interactiveTooltip.arrowLength);
        _drawTooltipText(
            canvas, value, crosshairTextStyle, tooltipRect, labelSize);
      }
    }
  }

  /// Draw left axes tooltip.
  void _drawLeftAxesTooltip(
      Canvas canvas, Offset position, Paint strokePaint, Paint fillPaint) {
    ChartAxis axis;
    ChartAxisRendererDetails axisDetails;
    String value;
    Size labelSize;
    Rect labelRect, validatedRect;
    RRect tooltipRect;
    const double padding = 10;
    //ignore: unused_local_variable
    Color? color;
    CrosshairRenderArgs crosshairEventArgs;
    for (int index = 0;
        index < stateProperties.chartAxis.leftAxesCount.length;
        index++) {
      axisDetails = AxisHelper.getAxisRendererDetails(
          stateProperties.chartAxis.leftAxesCount[index].axisRenderer);
      axis = axisDetails.axis;
      final TextStyle crosshairTextStyle =
          axisDetails.chartThemeData.crosshairTextStyle!;
      if (_needToAddTooltip(axisDetails)) {
        fillPaint.color = axis.interactiveTooltip.color ??
            _renderingDetails.chartTheme.crosshairBackgroundColor;
        strokePaint.color = axis.interactiveTooltip.borderColor ??
            _renderingDetails.chartTheme.crosshairBackgroundColor;
        strokePaint.strokeWidth = axis.interactiveTooltip.borderWidth;
        value = _getYValue(axisDetails.axisRenderer, position);
        if (chart.onCrosshairPositionChanging != null) {
          crosshairEventArgs = CrosshairRenderArgs(
              axis, value, axisDetails.name, axisDetails.orientation);
          crosshairEventArgs.text = value;
          crosshairEventArgs.lineColor = chart.crosshairBehavior.lineColor ??
              _renderingDetails.chartTheme.crosshairLineColor;
          chart.onCrosshairPositionChanging!(crosshairEventArgs);
          value = crosshairEventArgs.text;
          color = crosshairEventArgs.lineColor;
        }
        labelSize = measureText(value, crosshairTextStyle);
        labelRect = Rect.fromLTWH(
            axisDetails.bounds.left -
                (labelSize.width + padding) -
                axis.interactiveTooltip.arrowLength,
            position.dy - (labelSize.height + padding) / 2,
            labelSize.width + padding,
            labelSize.height + padding);
        labelRect =
            validateRectBounds(labelRect, _renderingDetails.chartContainerRect);
        validatedRect = validateRectYPosition(labelRect, stateProperties);
        backgroundPath.reset();
        tooltipRect = getRoundedCornerRect(
            validatedRect, axis.interactiveTooltip.borderRadius);

        backgroundPath.addRRect(tooltipRect);
        drawTooltipArrowhead(
            canvas,
            backgroundPath,
            fillPaint,
            strokePaint,
            tooltipRect.right,
            tooltipRect.top +
                tooltipRect.height / 2 -
                axis.interactiveTooltip.arrowWidth,
            tooltipRect.right,
            tooltipRect.bottom -
                tooltipRect.height / 2 +
                axis.interactiveTooltip.arrowWidth,
            tooltipRect.right + axis.interactiveTooltip.arrowLength,
            position.dy,
            tooltipRect.right + axis.interactiveTooltip.arrowLength,
            position.dy);

        _drawTooltipText(
            canvas, value, crosshairTextStyle, tooltipRect, labelSize);
      }
    }
  }

  /// Draw right axes tooltip.
  void _drawRightAxesTooltip(
      Canvas canvas, Offset position, Paint strokePaint, Paint fillPaint) {
    ChartAxis axis;
    ChartAxisRendererDetails axisDetails;
    String value;
    Size labelSize;
    Rect labelRect, validatedRect;
    CrosshairRenderArgs crosshairEventArgs;
    RRect tooltipRect;
    //ignore: unused_local_variable
    Color? color;
    const double padding = 10;
    for (int index = 0;
        index < stateProperties.chartAxis.rightAxesCount.length;
        index++) {
      axisDetails = AxisHelper.getAxisRendererDetails(
          stateProperties.chartAxis.rightAxesCount[index].axisRenderer);
      axis = axisDetails.axis;
      final TextStyle crosshairTextStyle =
          axisDetails.chartThemeData.crosshairTextStyle!;
      if (_needToAddTooltip(axisDetails)) {
        fillPaint.color = axis.interactiveTooltip.color ??
            _renderingDetails.chartTheme.crosshairBackgroundColor;
        strokePaint.color = axis.interactiveTooltip.borderColor ??
            _renderingDetails.chartTheme.crosshairBackgroundColor;
        strokePaint.strokeWidth = axis.interactiveTooltip.borderWidth;
        value = _getYValue(axisDetails.axisRenderer, position);
        if (chart.onCrosshairPositionChanging != null) {
          crosshairEventArgs = CrosshairRenderArgs(
              axis, value, axisDetails.name, axisDetails.orientation);
          crosshairEventArgs.text = value;
          crosshairEventArgs.lineColor = chart.crosshairBehavior.lineColor ??
              _renderingDetails.chartTheme.crosshairLineColor;
          chart.onCrosshairPositionChanging!(crosshairEventArgs);
          value = crosshairEventArgs.text;
          color = crosshairEventArgs.lineColor;
        }
        labelSize = measureText(value, crosshairTextStyle);
        labelRect = Rect.fromLTWH(
            axisDetails.bounds.left + axis.interactiveTooltip.arrowLength,
            position.dy - (labelSize.height / 2 + padding / 2),
            labelSize.width + padding,
            labelSize.height + padding);
        labelRect =
            validateRectBounds(labelRect, _renderingDetails.chartContainerRect);
        validatedRect = validateRectYPosition(labelRect, stateProperties);
        backgroundPath.reset();
        tooltipRect = getRoundedCornerRect(
            validatedRect, axis.interactiveTooltip.borderRadius);
        backgroundPath.addRRect(tooltipRect);
        drawTooltipArrowhead(
            canvas,
            backgroundPath,
            fillPaint,
            strokePaint,
            tooltipRect.left,
            tooltipRect.top +
                tooltipRect.height / 2 -
                axis.interactiveTooltip.arrowWidth,
            tooltipRect.left,
            tooltipRect.bottom -
                tooltipRect.height / 2 +
                axis.interactiveTooltip.arrowWidth,
            tooltipRect.left - axis.interactiveTooltip.arrowLength,
            position.dy,
            tooltipRect.left - axis.interactiveTooltip.arrowLength,
            position.dy);
        _drawTooltipText(
            canvas, value, crosshairTextStyle, tooltipRect, labelSize);
      }
    }
  }

  void _drawTooltipText(Canvas canvas, String text, TextStyle textStyle,
      RRect tooltipRect, Size labelSize) {
    drawText(
        canvas,
        text,
        Offset((tooltipRect.left + tooltipRect.width / 2) - labelSize.width / 2,
            (tooltipRect.top + tooltipRect.height / 2) - labelSize.height / 2),
        textStyle,
        0);
  }

  /// To find the x value of crosshair.
  String _getXValue(ChartAxisRenderer axisRenderer, Offset position) {
    final ChartAxisRendererDetails axisDetails =
        AxisHelper.getAxisRendererDetails(axisRenderer);
    final num value = pointToXVal(
        chart,
        axisDetails.axisRenderer,
        axisDetails.bounds,
        position.dx -
            (stateProperties.chartAxis.axisClipRect.left +
                axisDetails.axis.plotOffset),
        position.dy -
            (stateProperties.chartAxis.axisClipRect.top +
                axisDetails.axis.plotOffset));
    String resultantString =
        getInteractiveTooltipLabel(value, axisDetails.axisRenderer).toString();
    if (axisDetails.axis.interactiveTooltip.format != null) {
      final String stringValue = axisDetails.axis.interactiveTooltip.format!
          .replaceAll('{value}', resultantString);
      resultantString = stringValue;
    }
    return resultantString;
  }

  /// To find the y value of crosshair.
  String _getYValue(ChartAxisRenderer axisRenderer, Offset position) {
    final ChartAxisRendererDetails axisDetails =
        AxisHelper.getAxisRendererDetails(axisRenderer);
    final num value = pointToYVal(
        chart,
        axisDetails.axisRenderer,
        axisDetails.bounds,
        position.dx -
            (stateProperties.chartAxis.axisClipRect.left +
                axisDetails.axis.plotOffset),
        position.dy -
            (stateProperties.chartAxis.axisClipRect.top +
                axisDetails.axis.plotOffset));
    String resultantString =
        getInteractiveTooltipLabel(value, axisDetails.axisRenderer).toString();
    if (axisDetails.axis.interactiveTooltip.format != null) {
      final String stringValue = axisDetails.axis.interactiveTooltip.format!
          .replaceAll('{value}', resultantString);
      resultantString = stringValue;
    }
    return resultantString;
  }

  /// To add the tooltip for crosshair.
  bool _needToAddTooltip(ChartAxisRendererDetails axisDetails) {
    return axisDetails.axis.interactiveTooltip.enable &&
        ((axisDetails is! CategoryAxisDetails &&
                axisDetails.visibleLabels.isNotEmpty) ||
            (axisDetails is CategoryAxisDetails &&
                axisDetails.labels.isNotEmpty));
  }
}
