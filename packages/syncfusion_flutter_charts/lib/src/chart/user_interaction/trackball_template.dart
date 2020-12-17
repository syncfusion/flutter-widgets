part of charts;

// Widget class which is used to display the trackball template
class _TrackballTemplate extends StatefulWidget {
  const _TrackballTemplate({Key key, this.chartState, this.trackballBehavior})
      : super(key: key);

  final SfCartesianChartState chartState;
  final TrackballBehavior trackballBehavior;

  @override
  State<StatefulWidget> createState() {
    return _TrackballTemplateState();
  }
}

class _TrackballTemplateState extends State<_TrackballTemplate> {
  bool _isRender = false;

  //ignore: unused_field
  _TrackballTemplateState _state;
  List<_ChartPointInfo> _chartPointInfo;
  List<Path> _markerShapes;
  TrackballGroupingModeInfo groupingModeInfo;
  Widget _template;
  //ignore: unused_field
  double _duration;
  //ignore: unused_field
  bool _alwaysShow;
  //ignore: unused_field
  Timer _trackballTimer;
  bool _isRangeSeries = false, _isBoxSeries = false;

  @override
  void initState() {
    _state = this;
    super.initState();
  }

  @override
  void didUpdateWidget(_TrackballTemplate oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Widget trackballWidget;
    final List<Widget> trackballWidgets = <Widget>[];
    _state = this;
    String seriesType;
    if (_isRender && _chartPointInfo != null && _chartPointInfo.isNotEmpty) {
      for (int index = 0; index < _chartPointInfo.length; index++) {
        seriesType = _chartPointInfo[index].seriesRenderer._seriesType;
        _isRangeSeries = seriesType.contains('range') ||
            seriesType.contains('hilo') ||
            seriesType == 'candle';
        _isBoxSeries = seriesType == 'boxandwhisker';
        if (widget.trackballBehavior.tooltipDisplayMode ==
            TrackballDisplayMode.groupAllPoints) {
          _template = widget.trackballBehavior.builder(context,
              TrackballDetails(null, null, null, null, groupingModeInfo));
          trackballWidget = _TrackballRenderObject(
              child: _template,
              template: _template,
              chartState: widget.chartState,
              xPos: _chartPointInfo[index].xPosition,
              yPos: _isRangeSeries
                  ? _chartPointInfo[index].highYPosition
                  : _isBoxSeries
                      ? _chartPointInfo[index].maxYPosition
                      : _chartPointInfo[index].yPosition,
              trackballBehavior: widget.trackballBehavior);

          trackballWidgets.add(trackballWidget);

          break;
        } else if (widget.trackballBehavior.tooltipDisplayMode !=
            TrackballDisplayMode.none) {
          _template = widget.trackballBehavior.builder(
              context,
              TrackballDetails(
                  _chartPointInfo[index]
                      .seriesRenderer
                      ._dataPoints[_chartPointInfo[index].dataPointIndex],
                  _chartPointInfo[index].seriesRenderer._series,
                  _chartPointInfo[index].dataPointIndex,
                  _chartPointInfo[index].seriesIndex,
                  null));

          trackballWidget = _TrackballRenderObject(
              child: _template,
              template: _template,
              chartState: widget.chartState,
              xPos: _chartPointInfo[index].xPosition,
              yPos: _isRangeSeries
                  ? _chartPointInfo[index].highYPosition
                  : _isBoxSeries
                      ? _chartPointInfo[index].maxYPosition
                      : _chartPointInfo[index].yPosition,
              trackballBehavior: widget.trackballBehavior,
              chartPointInfo: _chartPointInfo,
              index: index);

          trackballWidgets.add(trackballWidget);
        }
      }
      return Stack(children: <Widget>[
        Stack(children: trackballWidgets),
        CustomPaint(
            painter: _TracklinePainter(widget.trackballBehavior,
                widget.chartState, _chartPointInfo, _markerShapes))
      ]);
    } else {
      trackballWidget = Container();
      return trackballWidget;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refresh() {
    setState(() {
      _isRender = true;
    });
  }

  /// To hide tooltip templates
  void hideTrackballTemplate() {
    if (mounted && !_alwaysShow) {
      setState(() {
        _isRender = false;
      });
    }
  }
}

class _TrackballRenderObject extends SingleChildRenderObjectWidget {
  _TrackballRenderObject(
      {Key key,
      Widget child,
      this.template,
      this.chartState,
      this.xPos,
      this.yPos,
      this.trackballBehavior,
      this.chartPointInfo,
      this.index})
      : super(key: key, child: child);

  final Widget template;
  final int index;
  final SfCartesianChartState chartState;
  final List<_ChartPointInfo> chartPointInfo;
  final double xPos;
  final double yPos;
  final TrackballBehavior trackballBehavior;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _TrackballTemplateRenderBox(
        template, chartState, xPos, yPos, chartPointInfo, index);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _TrackballTemplateRenderBox renderBox) {
    renderBox..template = template;
    renderBox..index = index;
    renderBox..xPos = xPos;
    renderBox.yPos = yPos;
    renderBox..chartPointInfo = chartPointInfo;
  }
}

/// Render the annotation widget in the respective position.
class _TrackballTemplateRenderBox extends RenderShiftedBox {
  _TrackballTemplateRenderBox(
      this._template, this._chartState, this.xPos, this.yPos,
      [this.chartPointInfo, this.index, RenderBox child])
      : super(child);

  Widget _template;
  final SfCartesianChartState _chartState;
  double xPos, yPos;
  List<_ChartPointInfo> chartPointInfo;
  int index;
  double pointerLength, pointerWidth;
  Rect trackballTemplateRect;
  Rect boundaryRect;
  num padding = 10;
  TrackballBehavior trackballBehavior;
  bool isGroupAllPoints, isNearestPoint;
  Widget get template => _template;
  bool isRight = false, isBottom = false;
  bool isTemplateInBounds = true;
  Offset arrowOffset;
  _TooltipPositions tooltipPosition;
  BoxParentData childParentData;
  set template(Widget value) {
    if (_template != value) {
      _template = value;
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {
    trackballBehavior = _chartState._chart.trackballBehavior;
    isGroupAllPoints = trackballBehavior.tooltipDisplayMode ==
        TrackballDisplayMode.groupAllPoints;
    isNearestPoint = trackballBehavior.tooltipDisplayMode ==
        TrackballDisplayMode.nearestPoint;
    final TrackballBehaviorRenderer trackballBehaviorRenderer =
        _chartState._trackballBehaviorRenderer;
    final List<num> tooltipTop = trackballBehaviorRenderer._tooltipTop;
    final List<num> tooltipBottom = trackballBehaviorRenderer._tooltipBottom;
    final List<_ClosestPoints> visiblePoints =
        trackballBehaviorRenderer._visiblePoints;
    final List<ChartAxisRenderer> xAxesInfo =
        trackballBehaviorRenderer._xAxesInfo;
    final List<ChartAxisRenderer> yAxesInfo =
        trackballBehaviorRenderer._yAxesInfo;
    boundaryRect = _chartState._chartAxis._axisClipRect;
    final num totalWidth = boundaryRect.left + boundaryRect.width;
    tooltipPosition = trackballBehaviorRenderer._tooltipPosition;
    final isTrackballMarkerEnabled = trackballBehavior.markerSettings != null;
    final BoxConstraints constraints = this.constraints;
    pointerLength = trackballBehavior.tooltipSettings.arrowLength;
    pointerWidth = trackballBehavior.tooltipSettings.arrowWidth;
    double left, top;
    Offset offset;
    if (child != null) {
      child.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(Size(child.size.width, child.size.height));
      if (child.parentData is BoxParentData) {
        childParentData = child.parentData;

        if (isGroupAllPoints) {
          if (trackballBehavior.tooltipAlignment == ChartAlignment.center) {
            yPos = boundaryRect.center.dy - size.height / 2;
          } else if (trackballBehavior.tooltipAlignment ==
              ChartAlignment.near) {
            yPos = boundaryRect.top;
          } else {
            yPos = boundaryRect.bottom;
          }

          if (yPos + size.height > boundaryRect.bottom &&
              trackballBehavior.tooltipAlignment == ChartAlignment.far) {
            yPos = boundaryRect.bottom - size.height;
          }
        }

        if (index == 0) {
          for (int index = 0; index < chartPointInfo.length; index++) {
            tooltipTop.add(_chartState._requireInvertedAxis
                ? visiblePoints[index].closestPointX - (size.width / 2)
                : visiblePoints[index].closestPointY - size.height / 2);
            tooltipBottom.add(_chartState._requireInvertedAxis
                ? visiblePoints[index].closestPointX + (size.width / 2)
                : visiblePoints[index].closestPointY + size.height / 2);
            xAxesInfo.add(chartPointInfo[index].seriesRenderer._xAxisRenderer);
            yAxesInfo.add(chartPointInfo[index].seriesRenderer._yAxisRenderer);
          }
        }

        if (tooltipTop != null && tooltipTop.isNotEmpty) {
          tooltipPosition = trackballBehaviorRenderer._smartTooltipPositions(
              tooltipTop,
              tooltipBottom,
              xAxesInfo,
              yAxesInfo,
              chartPointInfo,
              _chartState._requireInvertedAxis);
        }

        if (!isGroupAllPoints) {
          left = _chartState._requireInvertedAxis
              ? tooltipPosition.tooltipTop[index]
              : xPos +
                  padding +
                  (isTrackballMarkerEnabled
                      ? trackballBehavior.markerSettings.width / 2
                      : 0);
          top = _chartState._requireInvertedAxis
              ? yPos +
                  pointerLength +
                  (isTrackballMarkerEnabled
                      ? trackballBehavior.markerSettings.width / 2
                      : 0)
              : tooltipPosition.tooltipTop[index];

          if (isNearestPoint) {
            left = _chartState._requireInvertedAxis
                ? xPos + size.width / 2
                : xPos +
                    padding +
                    (isTrackballMarkerEnabled
                        ? trackballBehavior.markerSettings.width / 2
                        : 0);
            top = _chartState._requireInvertedAxis
                ? yPos +
                    padding +
                    (isTrackballMarkerEnabled
                        ? trackballBehavior.markerSettings.width / 2
                        : 0)
                : yPos - size.height / 2;
          }

          if (!_chartState._requireInvertedAxis) {
            if (left + size.width > totalWidth) {
              isRight = true;
              left = xPos -
                  size.width -
                  pointerLength -
                  (isTrackballMarkerEnabled
                      ? (trackballBehavior.markerSettings.width / 2)
                      : 0);
            } else {
              isRight = false;
            }
          } else {
            if (top + size.height > boundaryRect.bottom) {
              isBottom = true;
              top = yPos -
                  size.height -
                  (isTrackballMarkerEnabled
                      ? (trackballBehavior.markerSettings.height)
                      : 0);
            } else {
              isBottom = false;
            }
          }
          trackballTemplateRect =
              Rect.fromLTWH(left, top, size.width, size.height);

          if (_isTemplateWithinBounds(
              boundaryRect, trackballTemplateRect, offset)) {
            isTemplateInBounds = true;
            childParentData.offset = Offset(left, top);
          } else {
            child.layout(constraints.copyWith(maxWidth: 0),
                parentUsesSize: true);
            isTemplateInBounds = false;
          }
        } else {
          if (xPos + size.width > totalWidth) {
            xPos = xPos -
                size.width -
                2 * padding -
                (isTrackballMarkerEnabled
                    ? trackballBehavior.markerSettings.width / 2
                    : 0);
          }

          trackballTemplateRect =
              Rect.fromLTWH(xPos, yPos, size.width, size.height);

          if (_isTemplateWithinBounds(
              boundaryRect, trackballTemplateRect, offset)) {
            isTemplateInBounds = true;
            childParentData.offset = Offset(
                xPos +
                    padding +
                    (isTrackballMarkerEnabled
                        ? trackballBehavior.markerSettings.width / 2
                        : 0),
                yPos);
          } else {
            child.layout(constraints.copyWith(maxWidth: 0),
                parentUsesSize: true);
            isTemplateInBounds = false;
          }
        }
      }
    } else {
      size = Size.zero;
    }
    if (!isGroupAllPoints && index == chartPointInfo.length - 1) {
      tooltipTop.clear();
      tooltipBottom.clear();
      yAxesInfo.clear();
      xAxesInfo.clear();
    }
  }

  /// To check template is within bounds
  bool _isTemplateWithinBounds(Rect bounds, Rect templateRect, Offset offset) {
    final Rect rect = Rect.fromLTWH(
        padding + templateRect.left,
        (3 * padding) + templateRect.top,
        templateRect.width,
        templateRect.height);
    final Rect axisBounds = Rect.fromLTWH(padding + bounds.left,
        (3 * padding) + bounds.top, bounds.width, bounds.height);
    return rect.left >= axisBounds.left &&
        rect.left + rect.width <= axisBounds.left + axisBounds.width &&
        rect.top >= axisBounds.top &&
        rect.bottom <= axisBounds.top + axisBounds.height;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);

    if (!isGroupAllPoints) {
      final Rect templateRect = Rect.fromLTWH(
          offset.dx + trackballTemplateRect.left,
          offset.dy + trackballTemplateRect.top,
          trackballTemplateRect.width,
          trackballTemplateRect.height);

      final Paint fillPaint = Paint()
        ..color = trackballBehavior.tooltipSettings.color ??
            (chartPointInfo[index].seriesRenderer._series.color ??
                _chartState._chartTheme.crosshairBackgroundColor)
        ..isAntiAlias = false
        ..style = PaintingStyle.fill;
      final Paint strokePaint = Paint()
        ..color = trackballBehavior.tooltipSettings.borderColor ??
            (chartPointInfo[index].seriesRenderer._series.color ??
                _chartState._chartTheme.crosshairBackgroundColor)
        ..strokeWidth = trackballBehavior.tooltipSettings.borderWidth
        ..strokeCap = StrokeCap.butt
        ..isAntiAlias = false
        ..style = PaintingStyle.stroke;
      final Path path = Path();
      if (!_chartState._requireInvertedAxis) {
        if (!isRight) {
          path.moveTo(templateRect.left,
              templateRect.top + templateRect.height / 2 - pointerWidth);
          path.lineTo(templateRect.left,
              templateRect.bottom - templateRect.height / 2 + pointerWidth);
          path.lineTo(templateRect.left - pointerLength, yPos + offset.dy);
          path.lineTo(templateRect.left,
              templateRect.top + templateRect.height / 2 - pointerWidth);
        } else {
          path.moveTo(templateRect.right,
              templateRect.top + templateRect.height / 2 - pointerWidth);
          path.lineTo(templateRect.right,
              templateRect.bottom - templateRect.height / 2 + pointerWidth);
          path.lineTo(templateRect.right + pointerLength, yPos + offset.dy);
          path.lineTo(templateRect.right,
              templateRect.top + templateRect.height / 2 - pointerWidth);
        }
      } else if (isTemplateInBounds) {
        if (!isBottom) {
          path.moveTo(templateRect.left + templateRect.width / 2 + pointerWidth,
              templateRect.top);
          path.lineTo(
              templateRect.right - templateRect.width / 2 - pointerWidth,
              templateRect.top);
          path.lineTo(xPos + offset.dx, yPos + offset.dy);
        } else {
          path.moveTo(templateRect.left + templateRect.width / 2 + pointerWidth,
              templateRect.bottom);
          path.lineTo(
              templateRect.right - templateRect.width / 2 - pointerWidth,
              templateRect.bottom);
          path.lineTo(xPos + offset.dx, yPos + offset.dy);
        }
      }
      if (isTemplateInBounds) {
        context.canvas.drawPath(path, fillPaint);
        context.canvas.drawPath(path, strokePaint);
      }
    }
  }
}

class _TracklinePainter extends CustomPainter {
  _TracklinePainter(this.trackballBehavior, this.chartState,
      this.chartPointInfo, this.markerShapes);

  TrackballBehavior trackballBehavior;
  SfCartesianChartState chartState;
  List<_ChartPointInfo> chartPointInfo;
  List<Path> markerShapes;
  bool isTrackLineDrawn = false;

  @override
  void paint(Canvas canvas, Size size) {
    final Path dashArrayPath = Path();
    final Paint trackballLinePaint = Paint();
    trackballLinePaint.color = trackballBehavior.lineColor ??
        chartState._chartTheme.crosshairLineColor;
    trackballLinePaint.strokeWidth = trackballBehavior.lineWidth;
    trackballLinePaint.style = PaintingStyle.stroke;
    trackballBehavior.lineWidth == 0
        ? trackballLinePaint.color = Colors.transparent
        : trackballLinePaint.color = trackballLinePaint.color;
    final Rect boundaryRect = chartState._chartAxis._axisClipRect;

    if (chartPointInfo != null && chartPointInfo.isNotEmpty) {
      for (int index = 0; index < chartPointInfo.length; index++) {
        if (index == 0) {
          if (chartPointInfo[index].seriesRenderer._seriesType.contains('bar')
              ? chartState._requireInvertedAxis
              : chartState._requireInvertedAxis) {
            dashArrayPath.moveTo(
                boundaryRect.left, chartPointInfo[index].yPosition);
            dashArrayPath.lineTo(
                boundaryRect.right, chartPointInfo[index].yPosition);
          } else {
            dashArrayPath.moveTo(
                chartPointInfo[index].xPosition, boundaryRect.top);
            dashArrayPath.lineTo(
                chartPointInfo[index].xPosition, boundaryRect.bottom);
          }
          trackballBehavior.lineDashArray != null
              ? _drawDashedLine(canvas, trackballBehavior.lineDashArray,
                  trackballLinePaint, dashArrayPath)
              : canvas.drawPath(dashArrayPath, trackballLinePaint);
        }
        if (markerShapes != null &&
            markerShapes.isNotEmpty &&
            markerShapes.length > index) {
          chartState._trackballBehaviorRenderer._renderTrackballMarker(
              chartPointInfo[index].seriesRenderer,
              canvas,
              trackballBehavior,
              index);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_TracklinePainter oldDelegate) => true;
}
