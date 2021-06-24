part of charts;

// ignore: must_be_immutable
class _FunnelDataLabelRenderer extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _FunnelDataLabelRenderer(
      {required Key key, required this.chartState, required this.show})
      : super(key: key);

  final SfFunnelChartState chartState;

  bool show;

  _FunnelDataLabelRendererState? state;

  @override
  State<StatefulWidget> createState() => _FunnelDataLabelRendererState();
}

class _FunnelDataLabelRendererState extends State<_FunnelDataLabelRenderer>
    with SingleTickerProviderStateMixin {
  late List<AnimationController> animationControllersList;

  /// Animation controller for series
  late AnimationController animationController;

  /// Repaint notifier for crosshair container
  late ValueNotifier<int> dataLabelRepaintNotifier;

  @override
  void initState() {
    dataLabelRepaintNotifier = ValueNotifier<int>(0);
    animationController = AnimationController(vsync: this)
      ..addListener(repaintDataLabelElements);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.state = this;
    animationController.duration = Duration(
        milliseconds:
            widget.chartState._renderingDetails.initialRender! ? 500 : 0);
    final Animation<double> dataLabelAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.1, 0.8, curve: Curves.decelerate),
    ));
    animationController.forward(from: 0.0);
    return !widget.show
        ? Container()
        : Container(
            child: RepaintBoundary(
                child: CustomPaint(
                    painter: _FunnelDataLabelPainter(
                        chartState: widget.chartState,
                        animation: dataLabelAnimation,
                        state: this,
                        notifier: dataLabelRepaintNotifier,
                        animationController: animationController))));
  }

  @override
  void dispose() {
    _disposeAnimationController(animationController, repaintDataLabelElements);
    super.dispose();
  }

  void repaintDataLabelElements() {
    dataLabelRepaintNotifier.value++;
  }

  void render() {
    setState(() {
      widget.show = true;
    });
  }
}

class _FunnelDataLabelPainter extends CustomPainter {
  _FunnelDataLabelPainter(
      {required this.chartState,
      required this.state,
      required this.animationController,
      required this.animation,
      required ValueNotifier<num> notifier})
      : super(repaint: notifier);

  final SfFunnelChartState chartState;

  final _FunnelDataLabelRendererState state;

  final AnimationController animationController;

  final Animation<double>? animation;

  /// To paint funnel data label
  @override
  void paint(Canvas canvas, Size size) {
    final FunnelSeriesRenderer seriesRenderer =
        chartState._chartSeries.visibleSeriesRenderers[0];
    final FunnelSeries<dynamic, dynamic> series = seriesRenderer._series;
    // ignore: unnecessary_null_comparison
    if (series.dataLabelSettings != null &&
        series.dataLabelSettings.isVisible) {
      seriesRenderer._dataLabelSettingsRenderer =
          DataLabelSettingsRenderer(seriesRenderer._series.dataLabelSettings);
      _renderFunnelDataLabel(
          seriesRenderer, canvas, chartState, animation, series);
    }
  }

  @override
  bool shouldRepaint(_FunnelDataLabelPainter oldDelegate) => true;
}

/// To render funnel data label
void _renderFunnelDataLabel(
    FunnelSeriesRenderer seriesRenderer,
    Canvas canvas,
    SfFunnelChartState chartState,
    Animation<double>? animation,
    FunnelSeries<dynamic, dynamic> series) {
  PointInfo<dynamic> point;
  final SfFunnelChart chart = chartState._chart;
  final DataLabelSettings dataLabel = series.dataLabelSettings;
  String? label;
  final double animateOpacity = animation != null ? animation.value : 1;
  DataLabelRenderArgs dataLabelArgs;
  TextStyle dataLabelStyle;
  final List<Rect> renderDataLabelRegions = <Rect>[];
  DataLabelSettingsRenderer dataLabelSettingsRenderer;
  Size textSize;
  for (int pointIndex = 0;
      pointIndex < seriesRenderer._renderPoints.length;
      pointIndex++) {
    dataLabelSettingsRenderer = seriesRenderer._dataLabelSettingsRenderer;
    point = seriesRenderer._renderPoints[pointIndex];
    if (point.isVisible && (point.y != 0 || dataLabel.showZeroValue)) {
      label = point.text;
      dataLabelStyle = dataLabel.textStyle;
      dataLabelSettingsRenderer._color =
          seriesRenderer._series.dataLabelSettings.color;
      if (chart.onDataLabelRender != null &&
          !seriesRenderer._renderPoints[pointIndex].labelRenderEvent) {
        dataLabelArgs = DataLabelRenderArgs(seriesRenderer,
            seriesRenderer._renderPoints, pointIndex, pointIndex);
        dataLabelArgs.text = label!;
        dataLabelArgs.textStyle = dataLabelStyle;
        dataLabelArgs.color = dataLabelSettingsRenderer._color;
        chart.onDataLabelRender!(dataLabelArgs);
        label = point.text = dataLabelArgs.text;
        dataLabelStyle = dataLabelArgs.textStyle;
        pointIndex = dataLabelArgs.pointIndex!;
        dataLabelSettingsRenderer._color = dataLabelArgs.color;
        if (animation!.status == AnimationStatus.completed) {
          seriesRenderer._dataPoints[pointIndex].labelRenderEvent = true;
        }
      }
      dataLabelStyle = chart.onDataLabelRender == null
          ? _getDataLabelTextStyle(
              seriesRenderer, point, chartState, animateOpacity)
          : dataLabelStyle;
      textSize = measureText(label!, dataLabelStyle);

      ///Label check after event
      if (label != '') {
        if (dataLabel.labelPosition == ChartDataLabelPosition.inside) {
          _setFunnelInsideLabelPosition(
              dataLabel,
              point,
              textSize,
              chartState,
              canvas,
              renderDataLabelRegions,
              pointIndex,
              label,
              seriesRenderer,
              animateOpacity,
              dataLabelStyle);
        } else {
          point.renderPosition = ChartDataLabelPosition.outside;
          dataLabelStyle = _getDataLabelTextStyle(
              seriesRenderer, point, chartState, animateOpacity);
          _renderOutsideFunnelDataLabel(
              canvas,
              label,
              point,
              textSize,
              pointIndex,
              seriesRenderer,
              chartState,
              dataLabelStyle,
              renderDataLabelRegions,
              animateOpacity);
        }
      }
    }
  }
}

/// To render inside positioned funnel data labels
void _setFunnelInsideLabelPosition(
    DataLabelSettings dataLabel,
    PointInfo<dynamic> point,
    Size textSize,
    SfFunnelChartState chartState,
    Canvas canvas,
    List<Rect> renderDataLabelRegions,
    int pointIndex,
    String? label,
    FunnelSeriesRenderer seriesRenderer,
    double animateOpacity,
    TextStyle dataLabelStyle) {
  final SfFunnelChart chart = chartState._chart;
  final num angle = dataLabel.angle;
  Offset labelLocation;
  final SmartLabelMode smartLabelMode = chart.smartLabelMode;
  const int labelPadding = 2;
  labelLocation = point.symbolLocation;
  labelLocation = Offset(
      labelLocation.dx -
          (textSize.width / 2) +
          (angle == 0 ? 0 : textSize.width / 2),
      labelLocation.dy -
          (textSize.height / 2) +
          (angle == 0 ? 0 : textSize.height / 2));
  point.labelRect = Rect.fromLTWH(
      labelLocation.dx - labelPadding,
      labelLocation.dy - labelPadding,
      textSize.width + (2 * labelPadding),
      textSize.height + (2 * labelPadding));
  final bool isDataLabelCollide =
      _findingCollision(point.labelRect!, renderDataLabelRegions, point.region);
  if (isDataLabelCollide && smartLabelMode == SmartLabelMode.shift) {
    point.saturationRegionOutside = true;
    point.renderPosition = ChartDataLabelPosition.outside;
    dataLabelStyle = _getDataLabelTextStyle(
        seriesRenderer, point, chartState, animateOpacity);
    _renderOutsideFunnelDataLabel(
        canvas,
        label!,
        point,
        textSize,
        pointIndex,
        seriesRenderer,
        chartState,
        dataLabelStyle,
        renderDataLabelRegions,
        animateOpacity);
  } else if (smartLabelMode == SmartLabelMode.none ||
      (!isDataLabelCollide && smartLabelMode == SmartLabelMode.shift) ||
      (!isDataLabelCollide && smartLabelMode == SmartLabelMode.hide)) {
    point.renderPosition = ChartDataLabelPosition.inside;
    _drawFunnelLabel(
        point.labelRect!,
        labelLocation,
        label!,
        null,
        canvas,
        seriesRenderer,
        point,
        pointIndex,
        chartState,
        dataLabelStyle,
        renderDataLabelRegions,
        animateOpacity);
  }
}

/// To render outside position funnel data labels
void _renderOutsideFunnelDataLabel(
    Canvas canvas,
    String? label,
    PointInfo<dynamic> point,
    Size textSize,
    int pointIndex,
    FunnelSeriesRenderer seriesRenderer,
    SfFunnelChartState _chartState,
    TextStyle textStyle,
    List<Rect> renderDataLabelRegions,
    double animateOpacity) {
  Path connectorPath;
  Rect? rect;
  Offset labelLocation;
  // Maximum available space for rendering datalabel.
  const int maximumAvailableWidth = 22;
  final EdgeInsets margin = seriesRenderer._series.dataLabelSettings.margin;
  final ConnectorLineSettings connector =
      seriesRenderer._series.dataLabelSettings.connectorLineSettings;
  const num regionPadding = 10;
  connectorPath = Path();
  final num connectorLength = _percentToValue(connector.length ?? '0%',
          _chartState._renderingDetails.chartAreaRect.width / 2)! +
      seriesRenderer._maximumDataLabelRegion.width / 2 -
      regionPadding;
  final List<Offset> regions =
      seriesRenderer._renderPoints[pointIndex].pathRegion;
  final Offset startPoint = Offset(
      (regions[1].dx + regions[2].dx) / 2, (regions[1].dy + regions[2].dy) / 2);
  if (textSize.width > maximumAvailableWidth) {
    label = label!.substring(0, 2) + '..';
    textSize = measureText(label, textStyle);
  }
  final double dx = seriesRenderer._renderPoints[pointIndex].symbolLocation.dx +
      connectorLength;
  final Offset endPoint = Offset(
      (dx + textSize.width + margin.left + margin.right) >
              _chartState._renderingDetails.chartAreaRect.right
          ? dx -
              (_percentToValue(seriesRenderer._series.explodeOffset,
                  _chartState._renderingDetails.chartAreaRect.width)!)
          : dx,
      (regions[1].dy + regions[2].dy) / 2);
  connectorPath.moveTo(startPoint.dx, startPoint.dy);
  if (connector.type == ConnectorType.line) {
    connectorPath.lineTo(endPoint.dx, endPoint.dy);
  }
  point.dataLabelPosition = Position.right;
  rect = _getDataLabelRect(point.dataLabelPosition!, connector.type, margin,
      connectorPath, endPoint, textSize);
  if (rect != null) {
    final Rect containerRect = _chartState._renderingDetails.chartAreaRect;
    point.labelRect = rect;
    labelLocation = Offset(rect.left + margin.left,
        rect.top + rect.height / 2 - textSize.height / 2);

    if (seriesRenderer._series.dataLabelSettings.builder == null) {
      Rect? lastRenderedLabelRegion;
      if (renderDataLabelRegions.isNotEmpty) {
        lastRenderedLabelRegion =
            renderDataLabelRegions[renderDataLabelRegions.length - 1];
      }
      if (rect.left > containerRect.left &&
          rect.right <= containerRect.right &&
          rect.top > containerRect.top &&
          rect.bottom < containerRect.bottom) {
        if (!_isFunnelLabelIntersect(rect, lastRenderedLabelRegion)) {
          _drawFunnelLabel(
              rect,
              labelLocation,
              label,
              connectorPath,
              canvas,
              seriesRenderer,
              point,
              pointIndex,
              _chartState,
              textStyle,
              renderDataLabelRegions,
              animateOpacity);
        } else {
          if (pointIndex != 0) {
            const num connectorLinePadding = 15;
            const num padding = 2;
            final Rect previousRenderedRect =
                renderDataLabelRegions[renderDataLabelRegions.length - 1];
            rect = Rect.fromLTWH(
                rect.left,
                previousRenderedRect.top - padding - rect.height,
                rect.width,
                rect.height);
            labelLocation = Offset(
                rect.left + margin.left,
                previousRenderedRect.top -
                    padding -
                    rect.height +
                    rect.height / 2 -
                    textSize.height / 2);
            connectorPath = Path();
            connectorPath.moveTo(startPoint.dx, startPoint.dy);
            if (rect.left - connectorLinePadding >= startPoint.dx) {
              connectorPath.lineTo(
                  rect.left - connectorLinePadding, startPoint.dy);
            }
            connectorPath.lineTo(rect.left, rect.top + rect.height / 2);
          }
          if (rect.top >= containerRect.top + regionPadding) {
            _drawFunnelLabel(
                rect,
                labelLocation,
                label,
                connectorPath,
                canvas,
                seriesRenderer,
                point,
                pointIndex,
                _chartState,
                textStyle,
                renderDataLabelRegions,
                animateOpacity);
          }
        }
      }
    }
  }
}

/// To check whether labels intersect
bool _isFunnelLabelIntersect(Rect rect, Rect? previousRect) {
  bool isIntersect = false;
  const num padding = 2;
  if (previousRect != null && (rect.bottom + padding) > previousRect.top) {
    isIntersect = true;
  }
  return isIntersect;
}

/// To draw funnel data label
void _drawFunnelLabel(
    Rect labelRect,
    Offset location,
    String? label,
    Path? connectorPath,
    Canvas canvas,
    FunnelSeriesRenderer seriesRenderer,
    PointInfo<dynamic> point,
    int pointIndex,
    SfFunnelChartState _chartState,
    TextStyle textStyle,
    List<Rect> renderDataLabelRegions,
    double animateOpacity) {
  Paint rectPaint;
  final DataLabelSettings dataLabel = seriesRenderer._series.dataLabelSettings;
  final DataLabelSettingsRenderer dataLabelSettingsRenderer =
      seriesRenderer._dataLabelSettingsRenderer;
  final ConnectorLineSettings connector = dataLabel.connectorLineSettings;
  if (connectorPath != null) {
    canvas.drawPath(
        connectorPath,
        Paint()
          ..color = connector.width <= 0
              ? Colors.transparent
              : connector.color ??
                  point.fill.withOpacity(
                      !_chartState._renderingDetails.isLegendToggled
                          ? animateOpacity
                          : dataLabel.opacity)
          ..strokeWidth = connector.width
          ..style = PaintingStyle.stroke);
  }

  if (dataLabel.builder == null) {
    final double strokeWidth = dataLabel.borderWidth;
    final Color? labelFill = dataLabelSettingsRenderer._color ??
        (dataLabel.useSeriesColor
            ? point.fill
            : dataLabelSettingsRenderer._color);
    final Color? strokeColor =
        dataLabel.borderColor.withOpacity(dataLabel.opacity);
    // ignore: unnecessary_null_comparison
    if (strokeWidth != null && strokeWidth > 0) {
      rectPaint = Paint()
        ..color = strokeColor!.withOpacity(
            !_chartState._renderingDetails.isLegendToggled
                ? animateOpacity
                : dataLabel.opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      _drawLabelRect(
          rectPaint,
          Rect.fromLTRB(
              labelRect.left, labelRect.top, labelRect.right, labelRect.bottom),
          dataLabel.borderRadius,
          canvas);
    }
    if (labelFill != null) {
      _drawLabelRect(
          Paint()
            ..color = labelFill
                .withOpacity(!_chartState._renderingDetails.isLegendToggled
                    ? (animateOpacity - (1 - dataLabel.opacity)) < 0
                        ? 0
                        : animateOpacity - (1 - dataLabel.opacity)
                    : dataLabel.opacity)
            ..style = PaintingStyle.fill,
          Rect.fromLTRB(
              labelRect.left, labelRect.top, labelRect.right, labelRect.bottom),
          dataLabel.borderRadius,
          canvas);
    }
    _drawText(canvas, label!, location, textStyle, dataLabel.angle);
    renderDataLabelRegions.add(labelRect);
  }
}

void _triggerFunnelDataLabelEvent(
    SfFunnelChart chart,
    FunnelSeriesRenderer seriesRenderer,
    SfFunnelChartState chartState,
    Offset position) {
  const int seriesIndex = 0;
  PointInfo<dynamic> point;
  DataLabelSettings dataLabel;
  Offset labelLocation;
  for (int index = 0; index < seriesRenderer._renderPoints.length; index++) {
    point = seriesRenderer._renderPoints[index];
    dataLabel = seriesRenderer._series.dataLabelSettings;
    labelLocation = point.symbolLocation;
    if (dataLabel.isVisible &&
        seriesRenderer._renderPoints[index].labelRect != null &&
        seriesRenderer._renderPoints[index].labelRect!.contains(position)) {
      position = Offset(labelLocation.dx, labelLocation.dy);
      _dataLabelTapEvent(chart, seriesRenderer._series.dataLabelSettings, index,
          point, position, seriesIndex);
    }
  }
}
