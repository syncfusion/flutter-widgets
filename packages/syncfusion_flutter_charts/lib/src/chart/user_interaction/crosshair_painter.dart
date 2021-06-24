part of charts;

class _CrosshairPainter extends CustomPainter {
  _CrosshairPainter({required this.chartState, required this.valueNotifier})
      : chart = chartState._chart,
        super(repaint: valueNotifier);
  final SfCartesianChartState chartState;
  final SfCartesianChart chart;
  _RenderingDetails get _renderingDetails => chartState._renderingDetails;
  Timer? timer;
  ValueNotifier<int> valueNotifier;
  // double pointerLength;
  // double pointerWidth;
  double nosePointY = 0;
  double nosePointX = 0;
  double totalWidth = 0;
  // double x;
  // double y;
  // double xPos;
  // double yPos;
  bool isTop = false;
  // double cornerRadius;
  Path backgroundPath = Path();
  bool canResetPath = true;
  bool isLeft = false;
  bool isRight = false;
  // bool enable;
  double padding = 0;
  List<String> stringValue = <String>[];
  Rect boundaryRect = const Rect.fromLTWH(0, 0, 0, 0);
  double leftPadding = 0;
  double topPadding = 0;
  bool isHorizontalOrientation = false;
  // TextStyle labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    if (!canResetPath) {
      chartState._crosshairBehaviorRenderer.onPaint(canvas);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  /// calculate trackball points
  void _generateAllPoints(Offset position) {
    final Rect _axisClipRect = chartState._chartAxis._axisClipRect;
    double dx, dy;
    dx = position.dx > _axisClipRect.right
        ? _axisClipRect.right
        : position.dx < _axisClipRect.left
            ? _axisClipRect.left
            : position.dx;
    dy = position.dy > _axisClipRect.bottom
        ? _axisClipRect.bottom
        : position.dy < _axisClipRect.top
            ? _axisClipRect.top
            : position.dy;
    chartState._crosshairBehaviorRenderer._position = Offset(dx, dy);
  }

  /// Get line painter paint
  Paint _getLinePainter(Paint crosshairLinePaint) => crosshairLinePaint;

  /// Draw the path of the cross hair line
  void _drawCrosshairLine(Canvas canvas, Paint paint, int? index) {
    if (chartState._crosshairBehaviorRenderer._position != null) {
      final Path dashArrayPath = Path();
      if ((chart.crosshairBehavior.lineType == CrosshairLineType.horizontal ||
              chart.crosshairBehavior.lineType == CrosshairLineType.both) &&
          chart.crosshairBehavior.lineWidth != 0) {
        dashArrayPath.moveTo(chartState._chartAxis._axisClipRect.left,
            chartState._crosshairBehaviorRenderer._position!.dy);
        dashArrayPath.lineTo(chartState._chartAxis._axisClipRect.right,
            chartState._crosshairBehaviorRenderer._position!.dy);
        chart.crosshairBehavior.lineDashArray != null
            ? _drawDashedLine(canvas, chart.crosshairBehavior.lineDashArray!,
                paint, dashArrayPath)
            : canvas.drawPath(dashArrayPath, paint);
      }
      if ((chart.crosshairBehavior.lineType == CrosshairLineType.vertical ||
              chart.crosshairBehavior.lineType == CrosshairLineType.both) &&
          chart.crosshairBehavior.lineWidth != 0) {
        dashArrayPath.moveTo(
            chartState._crosshairBehaviorRenderer._position!.dx,
            chartState._chartAxis._axisClipRect.top);
        dashArrayPath.lineTo(
            chartState._crosshairBehaviorRenderer._position!.dx,
            chartState._chartAxis._axisClipRect.bottom);
        chart.crosshairBehavior.lineDashArray != null
            ? _drawDashedLine(canvas, chart.crosshairBehavior.lineDashArray!,
                paint, dashArrayPath)
            : canvas.drawPath(dashArrayPath, paint);
      }
    }
  }

  /// To draw cross hair
  void _drawCrosshair(Canvas canvas) {
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
    if (chartState._crosshairBehaviorRenderer._position != null) {
      final Offset position = chartState._crosshairBehaviorRenderer._position!;

      crosshairLinePaint.color = chart.crosshairBehavior.lineColor ??
          _renderingDetails.chartTheme.crosshairLineColor;
      crosshairLinePaint.strokeWidth = chart.crosshairBehavior.lineWidth;
      crosshairLinePaint.style = PaintingStyle.stroke;
      CrosshairRenderArgs crosshairEventArgs;
      if (chart.onCrosshairPositionChanging != null) {
        crosshairEventArgs = CrosshairRenderArgs();
        crosshairEventArgs.lineColor = crosshairLinePaint.color;
        chart.onCrosshairPositionChanging!(crosshairEventArgs);
        crosshairLinePaint.color = crosshairEventArgs.lineColor;
      }
      chartState._crosshairBehaviorRenderer._drawLine(
          canvas,
          chartState._crosshairBehaviorRenderer
              ._linePainter(crosshairLinePaint),
          null);

      _drawBottomAxesTooltip(canvas, position, strokePaint, fillPaint);
      _drawTopAxesTooltip(canvas, position, strokePaint, fillPaint);
      _drawLeftAxesTooltip(canvas, position, strokePaint, fillPaint);
      _drawRightAxesTooltip(canvas, position, strokePaint, fillPaint);
    }
  }

  /// draw bottom axes tooltip
  void _drawBottomAxesTooltip(
      Canvas canvas, Offset position, Paint strokePaint, Paint fillPaint) {
    ChartAxisRenderer axisRenderer;
    String value;
    Size labelSize;
    Rect labelRect, validatedRect;
    RRect tooltipRect;
    //ignore: unused_local_variable
    Color? color;
    const double padding = 10;
    CrosshairRenderArgs crosshairEventArgs;
    for (int index = 0;
        index < chartState._chartAxis._bottomAxesCount.length;
        index++) {
      axisRenderer = chartState._chartAxis._bottomAxesCount[index].axisRenderer;
      final ChartAxis axis = axisRenderer._axis;
      if (_needToAddTooltip(axisRenderer)) {
        fillPaint.color = axis.interactiveTooltip.color ??
            _renderingDetails.chartTheme.crosshairBackgroundColor;
        strokePaint.color = axis.interactiveTooltip.borderColor ??
            _renderingDetails.chartTheme.crosshairBackgroundColor;
        strokePaint.strokeWidth = axis.interactiveTooltip.borderWidth;
        value = _getXValue(axisRenderer, position);
        if (chart.onCrosshairPositionChanging != null) {
          crosshairEventArgs = CrosshairRenderArgs(
              axis, value, axisRenderer._name, axisRenderer._orientation);
          crosshairEventArgs.text = value;
          crosshairEventArgs.lineColor = chart.crosshairBehavior.lineColor ??
              _renderingDetails.chartTheme.crosshairLineColor;
          chart.onCrosshairPositionChanging!(crosshairEventArgs);
          value = crosshairEventArgs.text;
          color = crosshairEventArgs.lineColor;
        }
        labelSize = measureText(value, axis.interactiveTooltip.textStyle);
        labelRect = Rect.fromLTWH(
            position.dx - (labelSize.width / 2 + padding / 2),
            axisRenderer._bounds.top + axis.interactiveTooltip.arrowLength,
            labelSize.width + padding,
            labelSize.height + padding);
        labelRect = _validateRectBounds(
            labelRect, _renderingDetails.chartContainerRect);
        validatedRect = _validateRectXPosition(labelRect, chartState);
        backgroundPath.reset();
        tooltipRect = _getRoundedCornerRect(
            validatedRect, axis.interactiveTooltip.borderRadius);
        backgroundPath.addRRect(tooltipRect);
        _drawTooltipArrowhead(
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
        _drawTooltipText(canvas, value, axis.interactiveTooltip.textStyle,
            tooltipRect, labelSize);
      }
    }
  }

  /// draw top axes tooltip
  void _drawTopAxesTooltip(
      Canvas canvas, Offset position, Paint strokePaint, Paint fillPaint) {
    ChartAxis axis;
    ChartAxisRenderer axisRenderer;
    String value;
    Size labelSize;
    Rect labelRect, validatedRect;
    RRect tooltipRect;
    const double padding = 10;
    //ignore: unused_local_variable
    Color? color;
    CrosshairRenderArgs crosshairEventArgs;
    for (int index = 0;
        index < chartState._chartAxis._topAxesCount.length;
        index++) {
      axisRenderer = chartState._chartAxis._topAxesCount[index].axisRenderer;
      axis = axisRenderer._axis;
      if (_needToAddTooltip(axisRenderer)) {
        fillPaint.color = axis.interactiveTooltip.color ??
            _renderingDetails.chartTheme.crosshairBackgroundColor;
        strokePaint.color = axis.interactiveTooltip.borderColor ??
            _renderingDetails.chartTheme.crosshairBackgroundColor;
        strokePaint.strokeWidth = axis.interactiveTooltip.borderWidth;
        value = _getXValue(axisRenderer, position);
        if (chart.onCrosshairPositionChanging != null) {
          crosshairEventArgs = CrosshairRenderArgs(axisRenderer._axis, value,
              axisRenderer._name, axisRenderer._orientation);
          crosshairEventArgs.text = value;
          crosshairEventArgs.lineColor = chart.crosshairBehavior.lineColor ??
              _renderingDetails.chartTheme.crosshairLineColor;
          chart.onCrosshairPositionChanging!(crosshairEventArgs);
          value = crosshairEventArgs.text;
          color = crosshairEventArgs.lineColor;
        }
        labelSize = measureText(value, axis.interactiveTooltip.textStyle);
        labelRect = Rect.fromLTWH(
            position.dx - (labelSize.width / 2 + padding / 2),
            axisRenderer._bounds.top -
                (labelSize.height + padding) -
                axis.interactiveTooltip.arrowLength,
            labelSize.width + padding,
            labelSize.height + padding);
        labelRect = _validateRectBounds(
            labelRect, _renderingDetails.chartContainerRect);
        validatedRect = _validateRectXPosition(labelRect, chartState);
        backgroundPath.reset();
        tooltipRect = _getRoundedCornerRect(
            validatedRect, axis.interactiveTooltip.borderRadius);
        backgroundPath.addRRect(tooltipRect);
        _drawTooltipArrowhead(
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
        _drawTooltipText(canvas, value, axis.interactiveTooltip.textStyle,
            tooltipRect, labelSize);
      }
    }
  }

  /// draw left axes tooltip
  void _drawLeftAxesTooltip(
      Canvas canvas, Offset position, Paint strokePaint, Paint fillPaint) {
    ChartAxis axis;
    ChartAxisRenderer axisRenderer;
    String value;
    Size labelSize;
    Rect labelRect, validatedRect;
    RRect tooltipRect;
    const double padding = 10;
    //ignore: unused_local_variable
    Color? color;
    CrosshairRenderArgs crosshairEventArgs;
    for (int index = 0;
        index < chartState._chartAxis._leftAxesCount.length;
        index++) {
      axisRenderer = chartState._chartAxis._leftAxesCount[index].axisRenderer;
      axis = axisRenderer._axis;
      if (_needToAddTooltip(axisRenderer)) {
        fillPaint.color = axis.interactiveTooltip.color ??
            _renderingDetails.chartTheme.crosshairBackgroundColor;
        strokePaint.color = axis.interactiveTooltip.borderColor ??
            _renderingDetails.chartTheme.crosshairBackgroundColor;
        strokePaint.strokeWidth = axis.interactiveTooltip.borderWidth;
        value = _getYValue(axisRenderer, position);
        if (chart.onCrosshairPositionChanging != null) {
          crosshairEventArgs = CrosshairRenderArgs(
              axis, value, axisRenderer._name, axisRenderer._orientation);
          crosshairEventArgs.text = value;
          crosshairEventArgs.lineColor = chart.crosshairBehavior.lineColor ??
              _renderingDetails.chartTheme.crosshairLineColor;
          chart.onCrosshairPositionChanging!(crosshairEventArgs);
          value = crosshairEventArgs.text;
          color = crosshairEventArgs.lineColor;
        }
        labelSize = measureText(value, axis.interactiveTooltip.textStyle);
        labelRect = Rect.fromLTWH(
            axisRenderer._bounds.left -
                (labelSize.width + padding) -
                axis.interactiveTooltip.arrowLength,
            position.dy - (labelSize.height + padding) / 2,
            labelSize.width + padding,
            labelSize.height + padding);
        labelRect = _validateRectBounds(
            labelRect, _renderingDetails.chartContainerRect);
        validatedRect = _validateRectYPosition(labelRect, chartState);
        backgroundPath.reset();
        tooltipRect = _getRoundedCornerRect(
            validatedRect, axis.interactiveTooltip.borderRadius);

        backgroundPath.addRRect(tooltipRect);
        _drawTooltipArrowhead(
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

        _drawTooltipText(canvas, value, axis.interactiveTooltip.textStyle,
            tooltipRect, labelSize);
      }
    }
  }

  /// draw right axes tooltip
  void _drawRightAxesTooltip(
      Canvas canvas, Offset position, Paint strokePaint, Paint fillPaint) {
    ChartAxis axis;
    ChartAxisRenderer axisRenderer;
    String value;
    Size labelSize;
    Rect labelRect, validatedRect;
    CrosshairRenderArgs crosshairEventArgs;
    RRect tooltipRect;
    //ignore: unused_local_variable
    Color? color;
    const double padding = 10;
    for (int index = 0;
        index < chartState._chartAxis._rightAxesCount.length;
        index++) {
      axisRenderer = chartState._chartAxis._rightAxesCount[index].axisRenderer;
      axis = axisRenderer._axis;
      if (_needToAddTooltip(axisRenderer)) {
        fillPaint.color = axis.interactiveTooltip.color ??
            _renderingDetails.chartTheme.crosshairBackgroundColor;
        strokePaint.color = axis.interactiveTooltip.borderColor ??
            _renderingDetails.chartTheme.crosshairBackgroundColor;
        strokePaint.strokeWidth = axis.interactiveTooltip.borderWidth;
        value = _getYValue(axisRenderer, position);
        if (chart.onCrosshairPositionChanging != null) {
          crosshairEventArgs = CrosshairRenderArgs(
              axis, value, axisRenderer._name, axisRenderer._orientation);
          crosshairEventArgs.text = value;
          crosshairEventArgs.lineColor = chart.crosshairBehavior.lineColor ??
              _renderingDetails.chartTheme.crosshairLineColor;
          chart.onCrosshairPositionChanging!(crosshairEventArgs);
          value = crosshairEventArgs.text;
          color = crosshairEventArgs.lineColor;
        }
        labelSize = measureText(value, axis.interactiveTooltip.textStyle);
        labelRect = Rect.fromLTWH(
            axisRenderer._bounds.left + axis.interactiveTooltip.arrowLength,
            position.dy - (labelSize.height / 2 + padding / 2),
            labelSize.width + padding,
            labelSize.height + padding);
        labelRect = _validateRectBounds(
            labelRect, _renderingDetails.chartContainerRect);
        validatedRect = _validateRectYPosition(labelRect, chartState);
        backgroundPath.reset();
        tooltipRect = _getRoundedCornerRect(
            validatedRect, axis.interactiveTooltip.borderRadius);
        backgroundPath.addRRect(tooltipRect);
        _drawTooltipArrowhead(
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
        _drawTooltipText(canvas, value, axis.interactiveTooltip.textStyle,
            tooltipRect, labelSize);
      }
    }
  }

  void _drawTooltipText(Canvas canvas, String text, TextStyle textStyle,
      RRect tooltipRect, Size labelSize) {
    _drawText(
        canvas,
        text,
        Offset((tooltipRect.left + tooltipRect.width / 2) - labelSize.width / 2,
            (tooltipRect.top + tooltipRect.height / 2) - labelSize.height / 2),
        TextStyle(
            color: textStyle.color ??
                _renderingDetails.chartTheme.tooltipLabelColor,
            fontSize: textStyle.fontSize,
            fontWeight: textStyle.fontWeight,
            fontFamily: textStyle.fontFamily,
            fontStyle: textStyle.fontStyle,
            inherit: textStyle.inherit,
            backgroundColor: textStyle.backgroundColor,
            letterSpacing: textStyle.letterSpacing,
            wordSpacing: textStyle.wordSpacing,
            textBaseline: textStyle.textBaseline,
            height: textStyle.height,
            locale: textStyle.locale,
            foreground: textStyle.foreground,
            background: textStyle.background,
            shadows: textStyle.shadows,
            fontFeatures: textStyle.fontFeatures,
            decoration: textStyle.decoration,
            decorationColor: textStyle.decorationColor,
            decorationStyle: textStyle.decorationStyle,
            decorationThickness: textStyle.decorationThickness,
            debugLabel: textStyle.debugLabel,
            fontFamilyFallback: textStyle.fontFamilyFallback),
        0);
  }

  /// To find the x value of crosshair
  String _getXValue(ChartAxisRenderer axisRenderer, Offset position) {
    final num value = _pointToXVal(
        chart,
        axisRenderer,
        axisRenderer._bounds,
        position.dx -
            (chartState._chartAxis._axisClipRect.left +
                axisRenderer._axis.plotOffset),
        position.dy -
            (chartState._chartAxis._axisClipRect.top +
                axisRenderer._axis.plotOffset));
    String resultantString =
        _getInteractiveTooltipLabel(value, axisRenderer).toString();
    if (axisRenderer._axis.interactiveTooltip.format != null) {
      final String stringValue = axisRenderer._axis.interactiveTooltip.format!
          .replaceAll('{value}', resultantString);
      resultantString = stringValue;
    }
    return resultantString;
  }

  /// To find the y value of crosshair
  String _getYValue(ChartAxisRenderer axisRenderer, Offset position) {
    final num value = _pointToYVal(
        chart,
        axisRenderer,
        axisRenderer._bounds,
        position.dx -
            (chartState._chartAxis._axisClipRect.left +
                axisRenderer._axis.plotOffset),
        position.dy -
            (chartState._chartAxis._axisClipRect.top +
                axisRenderer._axis.plotOffset));
    String resultantString =
        _getInteractiveTooltipLabel(value, axisRenderer).toString();
    if (axisRenderer._axis.interactiveTooltip.format != null) {
      final String stringValue = axisRenderer._axis.interactiveTooltip.format!
          .replaceAll('{value}', resultantString);
      resultantString = stringValue;
    }
    return resultantString;
  }

  /// To add the tooltip for crosshair
  bool _needToAddTooltip(ChartAxisRenderer axisRenderer) {
    return axisRenderer._axis.interactiveTooltip.enable &&
        ((axisRenderer is! CategoryAxisRenderer &&
                axisRenderer._visibleLabels.isNotEmpty) ||
            (axisRenderer is CategoryAxisRenderer &&
                axisRenderer._labels.isNotEmpty));
  }
}
