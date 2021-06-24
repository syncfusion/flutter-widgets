part of charts;

///Below class is for drawing zoomRct
class _ZoomRectPainter extends CustomPainter {
  _ZoomRectPainter(
      {this.isRepaint = true,
      required this.chartState,
      ValueNotifier<int>? notifier})
      : chart = chartState._chart,
        super(repaint: notifier);
  final bool isRepaint;
  final SfCartesianChart chart;
  SfCartesianChartState chartState;
  late Paint strokePaint, fillPaint;
  _RenderingDetails get renderingDetails => chartState._renderingDetails;

  @override
  void paint(Canvas canvas, Size size) =>
      chartState._zoomPanBehaviorRenderer.onPaint(canvas);

  ///  To draw Rect
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
    if (chartState._zoomPanBehaviorRenderer._rectPath != null) {
      canvas.drawPath(
          !kIsWeb
              ? _dashPath(
                  chartState._zoomPanBehaviorRenderer._rectPath!,
                  dashArray: _CircularIntervalList<double>(<double>[5, 5]),
                )!
              : chartState._zoomPanBehaviorRenderer._rectPath!,
          strokePaint);
      canvas.drawRect(
          chartState._zoomPanBehaviorRenderer._zoomingRect, fillPaint);
      final Rect zoomRect = chartState._zoomPanBehaviorRenderer._zoomingRect;

      /// To show the interactive tooltip on selection zooming
      if (zoomRect.width != 0) {
        _drawConnectorLine(
            canvas,
            Offset(zoomRect.bottomRight.dx, zoomRect.bottomRight.dy),
            Offset(zoomRect.topLeft.dx, zoomRect.topLeft.dy));
      }
    }
  }

  /// To draw connector line
  void _drawConnectorLine(Canvas canvas, Offset start, Offset end) {
    _drawAxisTooltip(chartState._chartAxis._bottomAxisRenderers, canvas, start,
        end, 'bottom');
    _drawAxisTooltip(
        chartState._chartAxis._topAxisRenderers, canvas, start, end, 'top');
    _drawAxisTooltip(
        chartState._chartAxis._leftAxisRenderers, canvas, start, end, 'left');
    _drawAxisTooltip(
        chartState._chartAxis._rightAxisRenderers, canvas, start, end, 'right');
  }

  /// Draw axis tootip connector line
  void _drawAxisTooltip(List<ChartAxisRenderer> axisRenderers, Canvas canvas,
      Offset startPosition, Offset endPosition, String axisPosition) {
    for (int index = 0; index < axisRenderers.length; index++) {
      final ChartAxisRenderer axisRenderer = axisRenderers[index];
      if (axisRenderer._axis.interactiveTooltip.enable &&
          axisRenderer._visibleLabels.isNotEmpty) {
        _drawTooltipConnector(
            axisRenderer, startPosition, endPosition, canvas, axisPosition);
      }
    }
  }

  /// It returns the tooltip label on zooming
  String _getValue(
      Offset position, ChartAxisRenderer axisRenderer, String axisPosition) {
    final ChartAxis axis = axisRenderer._axis;
    final bool isHorizontal = axisPosition == 'bottom' || axisPosition == 'top';
    final Rect axisClipRect = chartState._chartAxis._axisClipRect;
    final num value = isHorizontal
        ? _pointToXVal(
            chart,
            axisRenderer,
            axisRenderer._bounds,
            position.dx - (axisClipRect.left + axis.plotOffset),
            position.dy - (axisClipRect.top + axis.plotOffset))
        : _pointToYVal(
            chart,
            axisRenderer,
            axisRenderer._bounds,
            position.dx - (axisClipRect.left + axis.plotOffset),
            position.dy - (axisClipRect.top + axis.plotOffset));

    dynamic result = _getInteractiveTooltipLabel(value, axisRenderer);
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

  /// Calculate the rect, based on the zoomed axis position
  Rect _calculateRect(ChartAxisRenderer axisRenderer, Offset position,
      Size labelSize, String axisPosition) {
    Rect rect;
    const double paddingForRect = 10;
    final double arrowLength =
        axisRenderer._axis.interactiveTooltip.arrowLength;
    if (axisPosition == 'bottom') {
      rect = Rect.fromLTWH(
          position.dx - (labelSize.width / 2 + paddingForRect / 2),
          axisRenderer._bounds.top + arrowLength,
          labelSize.width + paddingForRect,
          labelSize.height + paddingForRect);
    } else if (axisPosition == 'top') {
      rect = Rect.fromLTWH(
          position.dx - (labelSize.width / 2 + paddingForRect / 2),
          axisRenderer._bounds.top -
              (labelSize.height + paddingForRect) -
              arrowLength,
          labelSize.width + paddingForRect,
          labelSize.height + paddingForRect);
    } else if (axisPosition == 'left') {
      rect = Rect.fromLTWH(
          axisRenderer._bounds.left -
              (labelSize.width + paddingForRect) -
              arrowLength,
          position.dy - (labelSize.height + paddingForRect) / 2,
          labelSize.width + paddingForRect,
          labelSize.height + paddingForRect);
    } else {
      rect = Rect.fromLTWH(
          axisRenderer._bounds.left + arrowLength,
          position.dy - (labelSize.height / 2 + paddingForRect / 2),
          labelSize.width + paddingForRect,
          labelSize.height + paddingForRect);
    }
    return rect;
  }

  /// To draw tooltip connector
  void _drawTooltipConnector(
      ChartAxisRenderer axisRenderer,
      Offset startPosition,
      Offset endPosition,
      Canvas canvas,
      String axisPosition) {
    RRect? startTooltipRect, endTooltipRect;
    String startValue, endValue;
    Size startLabelSize, endLabelSize;
    Rect startLabelRect, endLabelRect;
    final ChartAxis axis = axisRenderer._axis;
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
    startValue = _getValue(startPosition, axisRenderer, axisPosition);
    endValue = _getValue(endPosition, axisRenderer, axisPosition);
    startLabelSize = measureText(startValue, axis.interactiveTooltip.textStyle);
    endLabelSize = measureText(endValue, axis.interactiveTooltip.textStyle);
    startLabelRect = _calculateRect(
        axisRenderer, startPosition, startLabelSize, axisPosition);
    endLabelRect =
        _calculateRect(axisRenderer, endPosition, endLabelSize, axisPosition);
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
        axisPosition);
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
        axisPosition);
    _drawConnector(canvas, connectorLinePaint, startTooltipRect, endTooltipRect,
        startPosition, endPosition, axis.interactiveTooltip, axisPosition);
  }

  /// To draw connectors
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
            !kIsWeb
                ? _dashPath(connectorPath,
                    dashArray: _CircularIntervalList<double>(
                        tooltip.connectorLineDashArray!))!
                : connectorPath,
            connectorLinePaint)
        : canvas.drawPath(connectorPath, connectorLinePaint);
  }

  /// To draw tooltip
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
      String axisPosition) {
    fillPaint.color =
        tooltip.color ?? renderingDetails.chartTheme.crosshairBackgroundColor;
    strokePaint.color = tooltip.borderColor ??
        renderingDetails.chartTheme.crosshairBackgroundColor;
    strokePaint.strokeWidth = tooltip.borderWidth;

    final bool isHorizontal = axisPosition == 'bottom' || axisPosition == 'top';
    labelRect =
        _validateRectBounds(labelRect, renderingDetails.chartContainerRect);
    labelRect = isHorizontal
        ? _validateRectXPosition(labelRect, chartState)
        : _validateRectYPosition(labelRect, chartState);
    path.reset();
    rect = _getRoundedCornerRect(labelRect, tooltip.borderRadius);
    path.addRRect(rect);
    _calculateNeckPositions(canvas, fillPaint, strokePaint, path, axisPosition,
        position, rect, tooltip);
    _drawText(
        canvas,
        value,
        Offset((rect.left + rect.width / 2) - labelSize.width / 2,
            (rect.top + rect.height / 2) - labelSize.height / 2),
        TextStyle(
            color: tooltip.textStyle.color ??
                renderingDetails.chartTheme.tooltipLabelColor,
            fontSize: tooltip.textStyle.fontSize,
            fontWeight: tooltip.textStyle.fontWeight,
            fontFamily: tooltip.textStyle.fontFamily,
            fontStyle: tooltip.textStyle.fontStyle),
        0);
    return rect;
  }

  /// To calculate tootip neck positions
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
    _drawTooltipArrowhead(
        canvas, path, fillPaint, strokePaint, x1, y1, x2, y2, x3, y3, x4, y4);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => isRepaint;
}
