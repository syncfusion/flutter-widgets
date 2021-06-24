part of charts;

// ignore: must_be_immutable
class _PyramidDataLabelRenderer extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _PyramidDataLabelRenderer(
      {required Key key, required this.chartState, required this.show})
      : super(key: key);

  final SfPyramidChartState chartState;

  bool show;

  _PyramidDataLabelRendererState? state;

  @override
  State<StatefulWidget> createState() {
    return _PyramidDataLabelRendererState();
  }
}

class _PyramidDataLabelRendererState extends State<_PyramidDataLabelRenderer>
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
                    painter: _PyramidDataLabelPainter(
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

class _PyramidDataLabelPainter extends CustomPainter {
  _PyramidDataLabelPainter(
      {required this.chartState,
      required this.state,
      required this.animationController,
      required this.animation,
      required ValueNotifier<num> notifier})
      : super(repaint: notifier);

  final SfPyramidChartState chartState;

  final _PyramidDataLabelRendererState state;

  final AnimationController animationController;

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final PyramidSeriesRenderer seriesRenderer =
        chartState._chartSeries.visibleSeriesRenderers[0];
    // ignore: unnecessary_null_comparison
    if (seriesRenderer._series.dataLabelSettings != null &&
        seriesRenderer._series.dataLabelSettings.isVisible) {
      seriesRenderer._dataLabelSettingsRenderer =
          DataLabelSettingsRenderer(seriesRenderer._series.dataLabelSettings);
      _renderPyramidDataLabel(seriesRenderer, canvas, chartState, animation);
    }
  }

  @override
  bool shouldRepaint(_PyramidDataLabelPainter oldDelegate) => true;
}

/// To render pyramid data labels
void _renderPyramidDataLabel(
    PyramidSeriesRenderer seriesRenderer,
    Canvas canvas,
    SfPyramidChartState chartState,
    Animation<double> animation) {
  PointInfo<dynamic> point;
  final SfPyramidChart chart = chartState._chart;
  final DataLabelSettings dataLabel = seriesRenderer._series.dataLabelSettings;
  final DataLabelSettingsRenderer dataLabelSettingsRenderer =
      seriesRenderer._dataLabelSettingsRenderer;
  String? label;
  // ignore: unnecessary_null_comparison
  final double animateOpacity = animation != null ? animation.value : 1;
  DataLabelRenderArgs dataLabelArgs;
  TextStyle dataLabelStyle;
  final List<Rect> renderDataLabelRegions = <Rect>[];
  Size textSize;
  for (int pointIndex = 0;
      pointIndex < seriesRenderer._renderPoints!.length;
      pointIndex++) {
    point = seriesRenderer._renderPoints![pointIndex];
    if (point.isVisible && (point.y != 0 || dataLabel.showZeroValue)) {
      label = point.text;
      dataLabelStyle = dataLabel.textStyle;
      dataLabelSettingsRenderer._color =
          seriesRenderer._series.dataLabelSettings.color;
      if (chart.onDataLabelRender != null &&
          !seriesRenderer._renderPoints![pointIndex].labelRenderEvent) {
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
        if (animation.status == AnimationStatus.completed) {
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
          _setPyramidInsideLabelPosition(
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
          _renderOutsidePyramidDataLabel(
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

/// To calculate pyramid inside label position
void _setPyramidInsideLabelPosition(
    DataLabelSettings dataLabel,
    PointInfo<dynamic> point,
    Size textSize,
    SfPyramidChartState chartState,
    Canvas canvas,
    List<Rect> renderDataLabelRegions,
    int pointIndex,
    String label,
    PyramidSeriesRenderer seriesRenderer,
    double animateOpacity,
    TextStyle dataLabelStyle) {
  final num angle = dataLabel.angle;
  Offset labelLocation;
  final SmartLabelMode smartLabelMode = chartState._chart.smartLabelMode;
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
    _renderOutsidePyramidDataLabel(
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
  } else if (smartLabelMode == SmartLabelMode.none ||
      (!isDataLabelCollide && smartLabelMode == SmartLabelMode.shift) ||
      (!isDataLabelCollide && smartLabelMode == SmartLabelMode.hide)) {
    point.renderPosition = ChartDataLabelPosition.inside;
    _drawPyramidLabel(
        point.labelRect!,
        labelLocation,
        label,
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

/// To render outside pyramid data label
void _renderOutsidePyramidDataLabel(
    Canvas canvas,
    String label,
    PointInfo<dynamic> point,
    Size textSize,
    int pointIndex,
    PyramidSeriesRenderer seriesRenderer,
    SfPyramidChartState _chartState,
    TextStyle textStyle,
    List<Rect> renderDataLabelRegions,
    double animateOpacity) {
  Path connectorPath;
  Rect? rect;
  Offset labelLocation;
  final EdgeInsets margin = seriesRenderer._series.dataLabelSettings.margin;
  final ConnectorLineSettings connector =
      seriesRenderer._series.dataLabelSettings.connectorLineSettings;
  const num regionPadding = 12;
  connectorPath = Path();
  final num connectorLength = _percentToValue(connector.length ?? '0%',
          _chartState._renderingDetails.chartAreaRect.width / 2)! +
      seriesRenderer._maximumDataLabelRegion.width / 2 -
      regionPadding;
  final Offset startPoint = Offset(
      seriesRenderer._renderPoints![pointIndex].region!.right,
      seriesRenderer._renderPoints![pointIndex].region!.top +
          seriesRenderer._renderPoints![pointIndex].region!.height / 2);
  final double dx =
      seriesRenderer._renderPoints![pointIndex].symbolLocation.dx +
          connectorLength;
  final Offset endPoint = Offset(
      (dx + textSize.width + margin.left + margin.right >
              _chartState._renderingDetails.chartAreaRect.right)
          ? dx -
              (_percentToValue(seriesRenderer._series.explodeOffset,
                  _chartState._renderingDetails.chartAreaRect.width)!)
          : dx,
      seriesRenderer._renderPoints![pointIndex].symbolLocation.dy);
  connectorPath.moveTo(startPoint.dx, startPoint.dy);
  if (connector.type == ConnectorType.line) {
    connectorPath.lineTo(endPoint.dx, endPoint.dy);
  }
  point.dataLabelPosition = Position.right;
  rect = _getDataLabelRect(point.dataLabelPosition!, connector.type, margin,
      connectorPath, endPoint, textSize);
  if (rect != null) {
    point.labelRect = rect;
    labelLocation = Offset(rect.left + margin.left,
        rect.top + rect.height / 2 - textSize.height / 2);
    final Rect containerRect = _chartState._renderingDetails.chartAreaRect;
    if (seriesRenderer._series.dataLabelSettings.builder == null) {
      Rect? lastRenderedLabelRegion;
      if (renderDataLabelRegions.isNotEmpty) {
        lastRenderedLabelRegion =
            renderDataLabelRegions[renderDataLabelRegions.length - 1];
      }
      if (!_isPyramidLabelIntersect(rect, lastRenderedLabelRegion) &&
          (rect.left > containerRect.left &&
              rect.left + rect.width <
                  containerRect.left + containerRect.width) &&
          rect.top > containerRect.top &&
          rect.top + rect.height < containerRect.top + containerRect.height) {
        _drawPyramidLabel(
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
          rect = Rect.fromLTWH(rect.left, previousRenderedRect.bottom + padding,
              rect.width, rect.height);
          labelLocation = Offset(
              rect.left + margin.left,
              previousRenderedRect.bottom +
                  padding +
                  rect.height / 2 -
                  textSize.height / 2);
          connectorPath = Path();
          connectorPath.moveTo(startPoint.dx, startPoint.dy);
          connectorPath.lineTo(
              rect.left - connectorLinePadding, rect.top + rect.height / 2);
          connectorPath.lineTo(rect.left, rect.top + rect.height / 2);
        }
        if (rect.bottom < _chartState._renderingDetails.chartAreaRect.bottom) {
          _drawPyramidLabel(
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

/// To check whether labels intesect
bool _isPyramidLabelIntersect(Rect rect, Rect? previousRect) {
  bool isIntersect = false;
  const num padding = 2;
  if (previousRect != null && (rect.top - padding) < previousRect.bottom) {
    isIntersect = true;
  }
  return isIntersect;
}

/// To draw pyramid data label
void _drawPyramidLabel(
    Rect labelRect,
    Offset location,
    String? label,
    Path? connectorPath,
    Canvas canvas,
    PyramidSeriesRenderer seriesRenderer,
    PointInfo<dynamic> point,
    int pointIndex,
    SfPyramidChartState chartState,
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
                      !chartState._renderingDetails.isLegendToggled
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
            !chartState._renderingDetails.isLegendToggled
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
                .withOpacity(!chartState._renderingDetails.isLegendToggled
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

void _triggerPyramidDataLabelEvent(
    SfPyramidChart chart,
    PyramidSeriesRenderer seriesRenderer,
    SfPyramidChartState chartState,
    Offset position) {
  const int seriesIndex = 0;
  DataLabelSettings dataLabel;
  PointInfo<dynamic> point;
  Offset labelLocation;
  for (int pointIndex = 0;
      pointIndex < seriesRenderer._renderPoints!.length;
      pointIndex++) {
    dataLabel = seriesRenderer._series.dataLabelSettings;
    point = seriesRenderer._renderPoints![pointIndex];
    labelLocation = point.symbolLocation;
    if (dataLabel.isVisible &&
        seriesRenderer._renderPoints![pointIndex].labelRect != null &&
        seriesRenderer._renderPoints![pointIndex].labelRect!
            .contains(position)) {
      position = Offset(labelLocation.dx, labelLocation.dy);
      _dataLabelTapEvent(chart, seriesRenderer._series.dataLabelSettings,
          pointIndex, point, position, seriesIndex);
    }
  }
}
