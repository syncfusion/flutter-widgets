import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../../common/rendering_details.dart';
import '../../common/utils/helper.dart';
import '../axis/axis.dart';
import '../base/chart_base.dart';
import '../common/cartesian_state_properties.dart';
import '../common/interactive_tooltip.dart';
import '../utils/helper.dart';
import 'zooming_panning.dart';

/// Class for drawing zooming rectangle.
class ZoomRectPainter extends CustomPainter {
  /// Creates an instance for zoom rect painter.
  ZoomRectPainter(
      {this.isRepaint = true,
      required this.stateProperties,
      ValueNotifier<int>? notifier})
      : chart = stateProperties.chart,
        super(repaint: notifier);

  /// Specifies whether to repaint the zoom rect.
  final bool isRepaint;

  /// Holds the value of chart.
  final SfCartesianChart chart;

  /// Specifies the cartesian state properties.
  CartesianStateProperties stateProperties;

  /// Specifies the value of stroke paint and fill paint.
  late Paint strokePaint, fillPaint;

  /// Gets the value of rendering details.
  RenderingDetails get renderingDetails => stateProperties.renderingDetails;

  @override
  void paint(Canvas canvas, Size size) =>
      stateProperties.zoomPanBehaviorRenderer.onPaint(canvas);

  /// To draw zooming rectangle.
  void drawRect(Canvas canvas) {
    final Color? fillColor = chart.zoomPanBehavior.selectionRectColor;
    strokePaint = Paint()
      ..color = chart.zoomPanBehavior.selectionRectBorderColor ??
          renderingDetails.chartTheme.selectionRectBorderColor
      ..strokeWidth = chart.zoomPanBehavior.selectionRectBorderWidth
      ..style = PaintingStyle.stroke;
    chart.zoomPanBehavior.selectionRectBorderWidth == 0
        ? strokePaint.color = Colors.transparent
        : strokePaint.color = strokePaint.color;
    fillPaint = Paint()
      ..color = fillColor != null
          ? Color.fromRGBO(fillColor.red, fillColor.green, fillColor.blue, 0.3)
          : renderingDetails.chartTheme.selectionRectColor
      ..style = PaintingStyle.fill;
    strokePaint.isAntiAlias = false;
    final ZoomingBehaviorDetails zoomingBehaviorDetails =
        ZoomPanBehaviorHelper.getRenderingDetails(
            stateProperties.zoomPanBehaviorRenderer);
    if (zoomingBehaviorDetails.rectPath != null) {
      canvas.drawPath(
          dashPath(
            zoomingBehaviorDetails.rectPath!,
            dashArray: CircularIntervalList<double>(<double>[5, 5]),
          )!,
          strokePaint);
      canvas.drawRect(zoomingBehaviorDetails.zoomingRect, fillPaint);
      final Rect zoomRect = zoomingBehaviorDetails.zoomingRect;

      /// To show the interactive tooltip on selection zooming
      if (zoomRect.width != 0) {
        _drawConnectorLine(
            canvas,
            Offset(zoomRect.bottomRight.dx, zoomRect.bottomRight.dy),
            Offset(zoomRect.topLeft.dx, zoomRect.topLeft.dy));
      }
    }
  }

  /// To draw connector line.
  void _drawConnectorLine(Canvas canvas, Offset start, Offset end) {
    _drawAxisTooltip(stateProperties.chartAxis.bottomAxisRenderers, canvas,
        start, end, 'bottom');
    _drawAxisTooltip(
        stateProperties.chartAxis.topAxisRenderers, canvas, start, end, 'top');
    _drawAxisTooltip(stateProperties.chartAxis.leftAxisRenderers, canvas, start,
        end, 'left');
    _drawAxisTooltip(stateProperties.chartAxis.rightAxisRenderers, canvas,
        start, end, 'right');
  }

  /// Draw axis tootip connector line.
  void _drawAxisTooltip(List<ChartAxisRenderer> axisRenderers, Canvas canvas,
      Offset startPosition, Offset endPosition, String axisPosition) {
    for (int index = 0; index < axisRenderers.length; index++) {
      final ChartAxisRendererDetails axisDetails =
          AxisHelper.getAxisRendererDetails(axisRenderers[index]);
      if (axisDetails.axis.interactiveTooltip.enable &&
          axisDetails.visibleLabels.isNotEmpty) {
        _drawTooltipConnector(
            axisDetails, startPosition, endPosition, canvas, axisPosition);
      }
    }
  }

  /// Returns the tooltip label on zooming.
  String _getValue(Offset position,
      ChartAxisRendererDetails axisRendererDetails, String axisPosition) {
    final ChartAxis axis = axisRendererDetails.axis;
    final bool isHorizontal = axisPosition == 'bottom' || axisPosition == 'top';
    final Rect axisClipRect = stateProperties.chartAxis.axisClipRect;
    final num value = isHorizontal
        ? pointToXVal(
            chart,
            axisRendererDetails.axisRenderer,
            axisRendererDetails.bounds,
            position.dx - (axisClipRect.left + axis.plotOffset),
            position.dy - (axisClipRect.top + axis.plotOffset))
        : pointToYVal(
            chart,
            axisRendererDetails.axisRenderer,
            axisRendererDetails.bounds,
            position.dx - (axisClipRect.left + axis.plotOffset),
            position.dy - (axisClipRect.top + axis.plotOffset));

    dynamic result =
        getInteractiveTooltipLabel(value, axisRendererDetails.axisRenderer);
    if (axis.interactiveTooltip.format != null) {
      final String stringValue =
          axis.interactiveTooltip.format!.replaceAll('{value}', result);
      result = stringValue;
    }
    return result.toString();
  }

  /// Validate the rect by comparing small and large rect.
  Rect _validateRect(Rect largeRect, Rect smallRect, String axisPosition) =>
      Rect.fromLTRB(
          axisPosition == 'left'
              ? (smallRect.left - (largeRect.width - smallRect.width))
              : smallRect.left,
          smallRect.top,
          axisPosition == 'right'
              ? (smallRect.right + (largeRect.width - smallRect.width))
              : smallRect.right,
          smallRect.bottom);

  /// Calculate the rect, based on the zoomed axis position.
  Rect _calculateRect(ChartAxisRendererDetails axisRendererDetails,
      Offset position, Size labelSize, String axisPosition) {
    Rect rect;
    const double paddingForRect = 10;
    final double arrowLength =
        axisRendererDetails.axis.interactiveTooltip.arrowLength;
    if (axisPosition == 'bottom') {
      rect = Rect.fromLTWH(
          position.dx - (labelSize.width / 2 + paddingForRect / 2),
          axisRendererDetails.bounds.top + arrowLength,
          labelSize.width + paddingForRect,
          labelSize.height + paddingForRect);
    } else if (axisPosition == 'top') {
      rect = Rect.fromLTWH(
          position.dx - (labelSize.width / 2 + paddingForRect / 2),
          axisRendererDetails.bounds.top -
              (labelSize.height + paddingForRect) -
              arrowLength,
          labelSize.width + paddingForRect,
          labelSize.height + paddingForRect);
    } else if (axisPosition == 'left') {
      rect = Rect.fromLTWH(
          axisRendererDetails.bounds.left -
              (labelSize.width + paddingForRect) -
              arrowLength,
          position.dy - (labelSize.height + paddingForRect) / 2,
          labelSize.width + paddingForRect,
          labelSize.height + paddingForRect);
    } else {
      rect = Rect.fromLTWH(
          axisRendererDetails.bounds.left + arrowLength,
          position.dy - (labelSize.height / 2 + paddingForRect / 2),
          labelSize.width + paddingForRect,
          labelSize.height + paddingForRect);
    }
    return rect;
  }

  /// To draw tooltip connector.
  void _drawTooltipConnector(
      ChartAxisRendererDetails axisRendererDetails,
      Offset startPosition,
      Offset endPosition,
      Canvas canvas,
      String axisPosition) {
    RRect? startTooltipRect, endTooltipRect;
    String startValue, endValue;
    Size startLabelSize, endLabelSize;
    Rect startLabelRect, endLabelRect;
    final ChartAxis axis = axisRendererDetails.axis;
    final TextStyle zoomingLabelStyle =
        axisRendererDetails.chartThemeData.selectionZoomingTooltipTextStyle!;
    final Paint labelFillPaint = Paint()
      ..color = renderingDetails.chartTheme.crosshairBackgroundColor
      ..strokeCap = StrokeCap.butt
      ..isAntiAlias = false
      ..style = PaintingStyle.fill;

    final Paint labelStrokePaint = Paint()
      ..color = renderingDetails.chartTheme.crosshairBackgroundColor
      ..strokeCap = StrokeCap.butt
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    final Paint connectorLinePaint = Paint()
      ..color = axis.interactiveTooltip.connectorLineColor ??
          renderingDetails.chartTheme.selectionTooltipConnectorLineColor
      ..strokeWidth = axis.interactiveTooltip.connectorLineWidth
      ..style = PaintingStyle.stroke;

    chart.crosshairBehavior.lineWidth == 0
        ? strokePaint.color = Colors.transparent
        : strokePaint.color = strokePaint.color;

    final Path startLabelPath = Path();
    final Path endLabelPath = Path();
    final bool isHorizontal = axisPosition == 'bottom' || axisPosition == 'top';
    startValue = _getValue(startPosition, axisRendererDetails, axisPosition);
    endValue = _getValue(endPosition, axisRendererDetails, axisPosition);
    startLabelSize = measureText(startValue, zoomingLabelStyle);
    endLabelSize = measureText(endValue, zoomingLabelStyle);
    startLabelRect = _calculateRect(
        axisRendererDetails, startPosition, startLabelSize, axisPosition);
    endLabelRect = _calculateRect(
        axisRendererDetails, endPosition, endLabelSize, axisPosition);
    if (!isHorizontal && startLabelRect.width != endLabelRect.width) {
      (startLabelRect.width > endLabelRect.width)
          ? endLabelRect =
              _validateRect(startLabelRect, endLabelRect, axisPosition)
          : startLabelRect =
              _validateRect(endLabelRect, startLabelRect, axisPosition);
    }
    startTooltipRect = _drawTooltip(
        canvas,
        labelFillPaint,
        labelStrokePaint,
        startLabelPath,
        startPosition,
        startLabelRect,
        startTooltipRect,
        startValue,
        startLabelSize,
        axis.interactiveTooltip,
        axisPosition,
        zoomingLabelStyle);
    endTooltipRect = _drawTooltip(
        canvas,
        labelFillPaint,
        labelStrokePaint,
        endLabelPath,
        endPosition,
        endLabelRect,
        endTooltipRect,
        endValue,
        endLabelSize,
        axis.interactiveTooltip,
        axisPosition,
        zoomingLabelStyle);
    _drawConnector(canvas, connectorLinePaint, startTooltipRect, endTooltipRect,
        startPosition, endPosition, axis.interactiveTooltip, axisPosition);
  }

  /// To draw connectors.
  void _drawConnector(
      Canvas canvas,
      Paint connectorLinePaint,
      RRect startTooltipRect,
      RRect endTooltipRect,
      Offset startPosition,
      Offset endPosition,
      InteractiveTooltip tooltip,
      String axisPosition) {
    final Path connectorPath = Path();
    if (axisPosition == 'bottom') {
      connectorPath.moveTo(
          startPosition.dx, startTooltipRect.top - tooltip.arrowLength);
      connectorPath.lineTo(
          endPosition.dx, endTooltipRect.top - tooltip.arrowLength);
    } else if (axisPosition == 'top') {
      connectorPath.moveTo(
          startPosition.dx, startTooltipRect.bottom + tooltip.arrowLength);
      connectorPath.lineTo(
          endPosition.dx, endTooltipRect.bottom + tooltip.arrowLength);
    } else if (axisPosition == 'left') {
      connectorPath.moveTo(
          startTooltipRect.right + tooltip.arrowLength, startPosition.dy);
      connectorPath.lineTo(
          endTooltipRect.right + tooltip.arrowLength, endPosition.dy);
    } else {
      connectorPath.moveTo(
          startTooltipRect.left - tooltip.arrowLength, startPosition.dy);
      connectorPath.lineTo(
          endTooltipRect.left - tooltip.arrowLength, endPosition.dy);
    }
    tooltip.connectorLineDashArray != null
        ? canvas.drawPath(
            dashPath(connectorPath,
                dashArray: CircularIntervalList<double>(
                    tooltip.connectorLineDashArray!))!,
            connectorLinePaint)
        : canvas.drawPath(connectorPath, connectorLinePaint);
  }

  /// To draw tooltip.
  RRect _drawTooltip(
      Canvas canvas,
      Paint fillPaint,
      Paint strokePaint,
      Path path,
      Offset position,
      Rect labelRect,
      RRect? rect,
      String value,
      Size labelSize,
      InteractiveTooltip tooltip,
      String axisPosition,
      TextStyle zoomingLabelStyle) {
    fillPaint.color =
        tooltip.color ?? renderingDetails.chartTheme.crosshairBackgroundColor;
    strokePaint.color = tooltip.borderColor ??
        renderingDetails.chartTheme.crosshairBackgroundColor;
    strokePaint.strokeWidth = tooltip.borderWidth;

    final bool isHorizontal = axisPosition == 'bottom' || axisPosition == 'top';
    labelRect =
        validateRectBounds(labelRect, renderingDetails.chartContainerRect);
    labelRect = isHorizontal
        ? validateRectXPosition(labelRect, stateProperties)
        : validateRectYPosition(labelRect, stateProperties);
    path.reset();
    rect = getRoundedCornerRect(labelRect, tooltip.borderRadius);
    path.addRRect(rect);
    _calculateNeckPositions(canvas, fillPaint, strokePaint, path, axisPosition,
        position, rect, tooltip);
    drawText(
        canvas,
        value,
        Offset((rect.left + rect.width / 2) - labelSize.width / 2,
            (rect.top + rect.height / 2) - labelSize.height / 2),
        zoomingLabelStyle,
        0);
    return rect;
  }

  /// To calculate tootip neck positions.
  void _calculateNeckPositions(
      Canvas canvas,
      Paint fillPaint,
      Paint strokePaint,
      Path path,
      String axisPosition,
      Offset position,
      RRect rect,
      InteractiveTooltip tooltip) {
    double x1, x2, x3, x4, y1, y2, y3, y4;
    if (axisPosition == 'bottom') {
      x1 = position.dx;
      y1 = rect.top - tooltip.arrowLength;
      x2 = (rect.right - rect.width / 2) + tooltip.arrowWidth;
      y2 = rect.top;
      x3 = (rect.left + rect.width / 2) - tooltip.arrowWidth;
      y3 = rect.top;
      x4 = position.dx;
      y4 = rect.top - tooltip.arrowLength;
    } else if (axisPosition == 'top') {
      x1 = position.dx;
      y1 = rect.bottom + tooltip.arrowLength;
      x2 = (rect.right - rect.width / 2) + tooltip.arrowWidth;
      y2 = rect.bottom;
      x3 = (rect.left + rect.width / 2) - tooltip.arrowWidth;
      y3 = rect.bottom;
      x4 = position.dx;
      y4 = rect.bottom + tooltip.arrowLength;
    } else if (axisPosition == 'left') {
      x1 = rect.right;
      y1 = rect.top + rect.height / 2 - tooltip.arrowWidth;
      x2 = rect.right;
      y2 = rect.bottom - rect.height / 2 + tooltip.arrowWidth;
      x3 = rect.right + tooltip.arrowLength;
      y3 = position.dy;
      x4 = rect.right + tooltip.arrowLength;
      y4 = position.dy;
    } else {
      x1 = rect.left;
      y1 = rect.top + rect.height / 2 - tooltip.arrowWidth;
      x2 = rect.left;
      y2 = rect.bottom - rect.height / 2 + tooltip.arrowWidth;
      x3 = rect.left - tooltip.arrowLength;
      y3 = position.dy;
      x4 = rect.left - tooltip.arrowLength;
      y4 = position.dy;
    }
    drawTooltipArrowhead(
        canvas, path, fillPaint, strokePaint, x1, y1, x2, y2, x3, y3, x4, y4);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => isRepaint;
}
