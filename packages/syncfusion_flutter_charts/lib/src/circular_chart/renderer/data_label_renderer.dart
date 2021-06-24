part of charts;

// ignore: must_be_immutable
class _CircularDataLabelRenderer extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _CircularDataLabelRenderer(
      {required this.circularChartState, required this.show});

  final SfCircularChartState circularChartState;

  bool show;

  late _CircularDataLabelRendererState state;

  @override
  State<StatefulWidget> createState() {
    return _CircularDataLabelRendererState();
  }
}

class _CircularDataLabelRendererState extends State<_CircularDataLabelRenderer>
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
        milliseconds: widget.circularChartState._renderingDetails.initialRender!
            ? 500
            : 0);
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
                    painter: _CircularDataLabelPainter(
                        circularChartState: widget.circularChartState,
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

class _CircularDataLabelPainter extends CustomPainter {
  _CircularDataLabelPainter(
      {required this.circularChartState,
      required this.state,
      required this.animationController,
      required this.animation,
      required ValueNotifier<num> notifier})
      : super(repaint: notifier);

  final SfCircularChartState circularChartState;

  final _CircularDataLabelRendererState state;

  final AnimationController animationController;

  final Animation<double> animation;

  /// To paint data labels
  @override
  void paint(Canvas canvas, Size size) {
    final List<CircularSeriesRenderer> visibleSeriesRenderers =
        circularChartState._chartSeries.visibleSeriesRenderers;
    CircularSeriesRenderer seriesRenderer;
    for (int seriesIndex = 0;
        seriesIndex < visibleSeriesRenderers.length;
        seriesIndex++) {
      seriesRenderer = visibleSeriesRenderers[seriesIndex];
      // ignore: unnecessary_null_comparison
      if (seriesRenderer._series.dataLabelSettings != null &&
          seriesRenderer._series.dataLabelSettings.isVisible) {
        seriesRenderer._dataLabelSettingsRenderer =
            DataLabelSettingsRenderer(seriesRenderer._series.dataLabelSettings);
        _renderCircularDataLabel(
            seriesRenderer, canvas, circularChartState, seriesIndex, animation);
      }
    }
  }

  @override
  bool shouldRepaint(_CircularDataLabelPainter oldDelegate) => true;
}

/// To render data label
void _renderCircularDataLabel(
    CircularSeriesRenderer seriesRenderer,
    Canvas canvas,
    SfCircularChartState _chartState,
    int seriesIndex,
    Animation<double>? animation) {
  ChartPoint<dynamic> point;
  final SfCircularChart chart = _chartState._chart;
  final DataLabelSettings dataLabel = seriesRenderer._series.dataLabelSettings;
  final DataLabelSettingsRenderer dataLabelSettingsRenderer =
      seriesRenderer._dataLabelSettingsRenderer;
  final num angle = dataLabel.angle;
  Offset labelLocation;
  const int labelPadding = 2;
  String? label;
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
      label = seriesRenderer._series._renderer!.getLabelContent(
          seriesRenderer, point, pointIndex, seriesIndex, label!);
      dataLabelStyle = dataLabel.textStyle;
      dataLabelSettingsRenderer._color =
          seriesRenderer._series.dataLabelSettings.color;
      if (chart.onDataLabelRender != null &&
          !seriesRenderer._renderPoints![pointIndex].labelRenderEvent) {
        dataLabelArgs = DataLabelRenderArgs(seriesRenderer,
            seriesRenderer._renderPoints, pointIndex, pointIndex);
        dataLabelArgs.text = label;
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
      textSize = measureText(label, dataLabelStyle);

      /// condition check for labels after event.
      if (label != '') {
        if (seriesRenderer._seriesType == 'radialbar') {
          dataLabelStyle = chart.onDataLabelRender == null
              ? seriesRenderer._series._renderer!.getDataLabelStyle(
                  seriesRenderer,
                  point,
                  pointIndex,
                  seriesIndex,
                  dataLabelStyle,
                  _chartState)
              : dataLabelStyle;
          labelLocation = _degreeToPoint(point.startAngle!,
              (point.innerRadius! + point.outerRadius!) / 2, point.center!);
          labelLocation = Offset(
              (labelLocation.dx - textSize.width - 5) +
                  (angle == 0 ? 0 : textSize.width / 2),
              (labelLocation.dy - textSize.height / 2) +
                  (angle == 0 ? 0 : textSize.height / 2));
          point.labelRect = Rect.fromLTWH(
              labelLocation.dx - labelPadding,
              labelLocation.dy - labelPadding,
              textSize.width + (2 * labelPadding),
              textSize.height + (2 * labelPadding));
          _drawLabel(
              point.labelRect,
              labelLocation,
              label,
              null,
              canvas,
              seriesRenderer,
              point,
              pointIndex,
              seriesIndex,
              chart,
              dataLabelStyle,
              renderDataLabelRegions,
              animateOpacity);
        } else {
          _setLabelPosition(
              dataLabel,
              point,
              textSize,
              _chartState,
              canvas,
              renderDataLabelRegions,
              pointIndex,
              label,
              seriesRenderer,
              animateOpacity,
              dataLabelStyle,
              seriesIndex);
        }
      }
      dataLabelStyle = chart.onDataLabelRender == null
          ? seriesRenderer._series._renderer!.getDataLabelStyle(seriesRenderer,
              point, pointIndex, seriesIndex, dataLabelStyle, _chartState)
          : dataLabelStyle;
    }
  }
}

/// To set data label position
void _setLabelPosition(
    DataLabelSettings dataLabel,
    ChartPoint<dynamic> point,
    Size textSize,
    SfCircularChartState _chartState,
    Canvas canvas,
    List<Rect> renderDataLabelRegions,
    int pointIndex,
    String label,
    CircularSeriesRenderer seriesRenderer,
    double animateOpacity,
    TextStyle dataLabelStyle,
    int seriesIndex) {
  final DataLabelSettingsRenderer dataLabelSettingsRenderer =
      seriesRenderer._dataLabelSettingsRenderer;
  final SfCircularChart chart = _chartState._chart;
  final num angle = dataLabel.angle;
  Offset labelLocation;
  final bool smartLabel = seriesRenderer._series.enableSmartLabels;
  const int labelPadding = 2;
  if (dataLabel.labelPosition == ChartDataLabelPosition.inside) {
    labelLocation = _degreeToPoint(point.midAngle!,
        (point.innerRadius! + point.outerRadius!) / 2, point.center!);
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
        _findingCollision(point.labelRect, renderDataLabelRegions);
    if (smartLabel && isDataLabelCollide) {
      point.saturationRegionOutside = true;
      point.renderPosition = ChartDataLabelPosition.outside;
      dataLabelStyle = TextStyle(
          color: (dataLabelStyle.color ?? dataLabel.textStyle.color) ??
              _getSaturationColor(
                  _findthemecolor(_chartState, point, dataLabel)),
          fontSize: dataLabelStyle.fontSize ?? dataLabel.textStyle.fontSize,
          fontFamily:
              dataLabelStyle.fontFamily ?? dataLabel.textStyle.fontFamily,
          fontStyle: dataLabelStyle.fontStyle ?? dataLabel.textStyle.fontStyle,
          fontWeight:
              dataLabelStyle.fontWeight ?? dataLabel.textStyle.fontWeight,
          inherit: dataLabelStyle.inherit,
          backgroundColor: dataLabelStyle.backgroundColor ??
              dataLabel.textStyle.backgroundColor,
          letterSpacing:
              dataLabelStyle.letterSpacing ?? dataLabel.textStyle.letterSpacing,
          wordSpacing:
              dataLabelStyle.wordSpacing ?? dataLabel.textStyle.wordSpacing,
          textBaseline:
              dataLabelStyle.textBaseline ?? dataLabel.textStyle.textBaseline,
          height: dataLabelStyle.height ?? dataLabel.textStyle.height,
          locale: dataLabelStyle.locale ?? dataLabel.textStyle.locale,
          foreground:
              dataLabelStyle.foreground ?? dataLabel.textStyle.foreground,
          background:
              dataLabelStyle.background ?? dataLabel.textStyle.background,
          shadows: dataLabelStyle.shadows ?? dataLabel.textStyle.shadows,
          fontFeatures:
              dataLabelStyle.fontFeatures ?? dataLabel.textStyle.fontFeatures,
          decoration:
              dataLabelStyle.decoration ?? dataLabel.textStyle.decoration,
          decorationColor: dataLabelStyle.decorationColor ??
              dataLabel.textStyle.decorationColor,
          decorationStyle: dataLabelStyle.decorationStyle ??
              dataLabel.textStyle.decorationStyle,
          decorationThickness: dataLabelStyle.decorationThickness ??
              dataLabel.textStyle.decorationThickness,
          debugLabel:
              dataLabelStyle.debugLabel ?? dataLabel.textStyle.debugLabel,
          fontFamilyFallback: dataLabelStyle.fontFamilyFallback ??
              dataLabel.textStyle.fontFamilyFallback);
      _renderOutsideDataLabel(
          canvas,
          label,
          point,
          textSize,
          pointIndex,
          seriesRenderer,
          smartLabel,
          seriesIndex,
          _chartState,
          dataLabelStyle,
          renderDataLabelRegions,
          animateOpacity);
    } else {
      point.renderPosition = ChartDataLabelPosition.inside;
      dataLabelStyle = TextStyle(
          color: (chart.onDataLabelRender != null &&
                  dataLabelSettingsRenderer._color != null)
              ? _getSaturationColor(
                  dataLabelSettingsRenderer._color ?? point.fill)
              : ((dataLabelStyle.color ?? dataLabel.textStyle.color) ??
                  _getSaturationColor(
                      dataLabelSettingsRenderer._color ?? point.fill)),
          fontSize: dataLabelStyle.fontSize ?? dataLabel.textStyle.fontSize,
          fontFamily:
              dataLabelStyle.fontFamily ?? dataLabel.textStyle.fontFamily,
          fontStyle: dataLabelStyle.fontStyle ?? dataLabel.textStyle.fontStyle,
          fontWeight:
              dataLabelStyle.fontWeight ?? dataLabel.textStyle.fontWeight,
          inherit: dataLabelStyle.inherit,
          backgroundColor: dataLabelStyle.backgroundColor ??
              dataLabel.textStyle.backgroundColor,
          letterSpacing:
              dataLabelStyle.letterSpacing ?? dataLabel.textStyle.letterSpacing,
          wordSpacing:
              dataLabelStyle.wordSpacing ?? dataLabel.textStyle.wordSpacing,
          textBaseline:
              dataLabelStyle.textBaseline ?? dataLabel.textStyle.textBaseline,
          height: dataLabelStyle.height ?? dataLabel.textStyle.height,
          locale: dataLabelStyle.locale ?? dataLabel.textStyle.locale,
          foreground:
              dataLabelStyle.foreground ?? dataLabel.textStyle.foreground,
          background:
              dataLabelStyle.background ?? dataLabel.textStyle.background,
          shadows: dataLabelStyle.shadows ?? dataLabel.textStyle.shadows,
          fontFeatures:
              dataLabelStyle.fontFeatures ?? dataLabel.textStyle.fontFeatures,
          decoration:
              dataLabelStyle.decoration ?? dataLabel.textStyle.decoration,
          decorationColor: dataLabelStyle.decorationColor ??
              dataLabel.textStyle.decorationColor,
          decorationStyle: dataLabelStyle.decorationStyle ??
              dataLabel.textStyle.decorationStyle,
          decorationThickness: dataLabelStyle.decorationThickness ??
              dataLabel.textStyle.decorationThickness,
          debugLabel:
              dataLabelStyle.debugLabel ?? dataLabel.textStyle.debugLabel,
          fontFamilyFallback: dataLabelStyle.fontFamilyFallback ??
              dataLabel.textStyle.fontFamilyFallback);
      if (!isDataLabelCollide ||
          (dataLabel.labelIntersectAction == LabelIntersectAction.hide)) {
        _drawLabel(
            point.labelRect,
            labelLocation,
            label,
            null,
            canvas,
            seriesRenderer,
            point,
            pointIndex,
            seriesIndex,
            chart,
            dataLabelStyle,
            renderDataLabelRegions,
            animateOpacity);
      }
    }
  } else {
    point.renderPosition = ChartDataLabelPosition.outside;
    dataLabelStyle = TextStyle(
        color: (dataLabelStyle.color ?? dataLabel.textStyle.color) ??
            _getSaturationColor(_findthemecolor(_chartState, point, dataLabel)),
        fontSize: dataLabelStyle.fontSize ?? dataLabel.textStyle.fontSize,
        fontFamily: dataLabelStyle.fontFamily ?? dataLabel.textStyle.fontFamily,
        fontStyle: dataLabelStyle.fontStyle ?? dataLabel.textStyle.fontStyle,
        fontWeight: dataLabelStyle.fontWeight ?? dataLabel.textStyle.fontWeight,
        inherit: dataLabelStyle.inherit,
        backgroundColor: dataLabelStyle.backgroundColor ??
            dataLabel.textStyle.backgroundColor,
        letterSpacing:
            dataLabelStyle.letterSpacing ?? dataLabel.textStyle.letterSpacing,
        wordSpacing:
            dataLabelStyle.wordSpacing ?? dataLabel.textStyle.wordSpacing,
        textBaseline:
            dataLabelStyle.textBaseline ?? dataLabel.textStyle.textBaseline,
        height: dataLabelStyle.height ?? dataLabel.textStyle.height,
        locale: dataLabelStyle.locale ?? dataLabel.textStyle.locale,
        foreground: dataLabelStyle.foreground ?? dataLabel.textStyle.foreground,
        background: dataLabelStyle.background ?? dataLabel.textStyle.background,
        shadows: dataLabelStyle.shadows ?? dataLabel.textStyle.shadows,
        fontFeatures:
            dataLabelStyle.fontFeatures ?? dataLabel.textStyle.fontFeatures,
        decoration: dataLabelStyle.decoration ?? dataLabel.textStyle.decoration,
        decorationColor: dataLabelStyle.decorationColor ??
            dataLabel.textStyle.decorationColor,
        decorationStyle: dataLabelStyle.decorationStyle ??
            dataLabel.textStyle.decorationStyle,
        decorationThickness: dataLabelStyle.decorationThickness ??
            dataLabel.textStyle.decorationThickness,
        debugLabel: dataLabelStyle.debugLabel ?? dataLabel.textStyle.debugLabel,
        fontFamilyFallback: dataLabelStyle.fontFamilyFallback ??
            dataLabel.textStyle.fontFamilyFallback);
    _renderOutsideDataLabel(
        canvas,
        label,
        point,
        textSize,
        pointIndex,
        seriesRenderer,
        smartLabel,
        seriesIndex,
        _chartState,
        dataLabelStyle,
        renderDataLabelRegions,
        animateOpacity);
  }
}

/// To render outside positioned data labels.
void _renderOutsideDataLabel(
    Canvas canvas,
    String label,
    ChartPoint<dynamic> point,
    Size textSize,
    int pointIndex,
    CircularSeriesRenderer seriesRenderer,
    bool smartLabel,
    int seriesIndex,
    SfCircularChartState _chartState,
    TextStyle textStyle,
    List<Rect> renderDataLabelRegions,
    double animateOpacity) {
  Path connectorPath;
  Rect? rect;
  Offset labelLocation;
  final EdgeInsets margin = seriesRenderer._series.dataLabelSettings.margin;
  final ConnectorLineSettings connector =
      seriesRenderer._series.dataLabelSettings.connectorLineSettings;
  connectorPath = Path();
  final num connectorLength =
      _percentToValue(connector.length ?? '10%', point.outerRadius!)!;
  final Offset startPoint =
      _degreeToPoint(point.midAngle!, point.outerRadius!, point.center!);
  final Offset endPoint = _degreeToPoint(
      point.midAngle!, point.outerRadius! + connectorLength, point.center!);
  connectorPath.moveTo(startPoint.dx, startPoint.dy);
  if (connector.type == ConnectorType.line) {
    connectorPath.lineTo(endPoint.dx, endPoint.dy);
  }
  rect = _getDataLabelRect(point.dataLabelPosition, connector.type, margin,
      connectorPath, endPoint, textSize);
  point.labelRect = rect!;
  labelLocation = Offset(rect.left + margin.left,
      rect.top + rect.height / 2 - textSize.height / 2);
  final Rect containerRect = _chartState._renderingDetails.chartAreaRect;
  if (seriesRenderer._series.dataLabelSettings.builder == null) {
    if (seriesRenderer._series.dataLabelSettings.labelIntersectAction ==
        LabelIntersectAction.hide) {
      if (!_findingCollision(rect, renderDataLabelRegions) &&
          (rect.left > containerRect.left &&
              rect.left + rect.width <
                  containerRect.left + containerRect.width) &&
          rect.top > containerRect.top &&
          rect.top + rect.height < containerRect.top + containerRect.height) {
        _drawLabel(
            rect,
            labelLocation,
            label,
            connectorPath,
            canvas,
            seriesRenderer,
            point,
            pointIndex,
            seriesIndex,
            _chartState._chart,
            textStyle,
            renderDataLabelRegions,
            animateOpacity);
      }
    } else {
      _drawLabel(
          rect,
          labelLocation,
          label,
          connectorPath,
          canvas,
          seriesRenderer,
          point,
          pointIndex,
          seriesIndex,
          _chartState._chart,
          textStyle,
          renderDataLabelRegions,
          animateOpacity);
    }
  } else {
    canvas.drawPath(
        connectorPath,
        Paint()
          ..color = connector.width <= 0
              ? Colors.transparent
              : connector.color ?? point.fill.withOpacity(animateOpacity)
          ..strokeWidth = connector.width
          ..style = PaintingStyle.stroke);
  }
}

/// To draw label
void _drawLabel(
    Rect labelRect,
    Offset location,
    String label,
    Path? connectorPath,
    Canvas canvas,
    CircularSeriesRenderer seriesRenderer,
    ChartPoint<dynamic> point,
    int pointIndex,
    int seriesIndex,
    SfCircularChart chart,
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
              : connector.color ?? point.fill.withOpacity(animateOpacity)
          ..strokeWidth = connector.width
          ..style = PaintingStyle.stroke);
  }

  if (dataLabel.builder == null) {
    final double strokeWidth = seriesRenderer._series._renderer!
        .getDataLabelStrokeWidth(seriesRenderer, point, pointIndex, seriesIndex,
            dataLabel.borderWidth);
    final Color? labelFill = seriesRenderer._series._renderer!
        .getDataLabelColor(
            seriesRenderer,
            point,
            pointIndex,
            seriesIndex,
            dataLabelSettingsRenderer._color ??
                (dataLabel.useSeriesColor
                    ? point.fill
                    : dataLabelSettingsRenderer._color));
    final Color strokeColor = seriesRenderer._series._renderer!
        .getDataLabelStrokeColor(seriesRenderer, point, pointIndex, seriesIndex,
            dataLabel.borderColor.withOpacity(dataLabel.opacity));
    // ignore: unnecessary_null_comparison
    if (strokeWidth != null && strokeWidth > 0) {
      rectPaint = Paint()
        ..color = strokeColor.withOpacity(
            (animateOpacity - (1 - dataLabel.opacity)) < 0
                ? 0
                : animateOpacity - (1 - dataLabel.opacity))
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
            ..color = labelFill.withOpacity(
                (animateOpacity - (1 - dataLabel.opacity)) < 0
                    ? 0
                    : animateOpacity - (1 - dataLabel.opacity))
            ..style = PaintingStyle.fill,
          Rect.fromLTRB(
              labelRect.left, labelRect.top, labelRect.right, labelRect.bottom),
          dataLabel.borderRadius,
          canvas);
    }
    _drawText(canvas, label, location, textStyle, dataLabel.angle);
    renderDataLabelRegions.add(labelRect);
  }
}

void _triggerCircularDataLabelEvent(
    SfCircularChart chart,
    CircularSeriesRenderer seriesRenderer,
    SfCircularChartState chartState,
    Offset? position) {
  const int seriesIndex = 0;
  final DataLabelSettings dataLabel = seriesRenderer._series.dataLabelSettings;
  Offset labelLocation;
  num connectorLength;
  ChartPoint<dynamic> point;
  for (int index = 0; index < seriesRenderer._dataPoints.length; index++) {
    point = seriesRenderer._dataPoints[index];
    if (dataLabel.isVisible &&
        // ignore: unnecessary_null_comparison
        seriesRenderer._dataPoints[index].labelRect != null &&
        position != null &&
        seriesRenderer._dataPoints[index].labelRect.contains(position)) {
      if (dataLabel.labelPosition == ChartDataLabelPosition.inside) {
        labelLocation = _degreeToPoint(point.midAngle!,
            (point.innerRadius! + point.outerRadius!) / 2, point.center!);
        position = Offset(labelLocation.dx, labelLocation.dy);
      } else {
        connectorLength = _percentToValue(
            dataLabel.connectorLineSettings.length ?? '10%',
            point.outerRadius!)!;
        labelLocation = _degreeToPoint(point.midAngle!,
            point.outerRadius! + connectorLength, point.center!);
        position = Offset(labelLocation.dx, labelLocation.dy);
      }
      if (chart.onDataLabelTapped != null) {
        _dataLabelTapEvent(chart, seriesRenderer._series.dataLabelSettings,
            index, point, position, seriesIndex);
      }
    }
  }
}

/// To draw data label rect
void _drawLabelRect(
        Paint paint, Rect labelRect, double borderRadius, Canvas canvas) =>
    canvas.drawRRect(
        RRect.fromRectAndRadius(labelRect, Radius.circular(borderRadius)),
        paint);

/// To find data label position
void _findDataLabelPosition(ChartPoint<dynamic> point) =>
    point.dataLabelPosition =
        ((point.midAngle! >= -90 && point.midAngle! < 0) ||
                (point.midAngle! >= 0 && point.midAngle! < 90) ||
                (point.midAngle! >= 270))
            ? Position.right
            : Position.left;

/// Method for setting color to datalabel
Color _findthemecolor(SfCircularChartState _chartState,
    ChartPoint<dynamic> point, DataLabelSettings dataLabel) {
  return dataLabel.color ??
      (dataLabel.useSeriesColor
          ? point.fill
          : (_chartState._chart.backgroundColor ??
              (_chartState._renderingDetails.chartTheme.brightness ==
                      Brightness.light
                  ? Colors.white
                  : Colors.black)));
}
