part of charts;

// ignore: must_be_immutable
class _RenderTemplate extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _RenderTemplate(
      {required this.template,
      this.needMeasure,
      required this.templateLength,
      required this.templateIndex,
      required this.chartState});
  final _ChartTemplateInfo template;
  bool? needMeasure;
  final int templateLength;
  final int templateIndex;
  final dynamic chartState;
  bool? isAnnotation;

  @override
  State<StatefulWidget> createState() => _RenderTemplateState();
}

class _RenderTemplateState extends State<_RenderTemplate>
    with TickerProviderStateMixin {
  late List<AnimationController> templateControllerList;
  AnimationController? animationController;
  late Animation<double> animation;
  @override
  void initState() {
    templateControllerList = <AnimationController>[];
    animationController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _ChartTemplateInfo templateInfo = widget.template;
    Widget currentWidget = Container();
    Widget renderWidget;
    if (templateInfo.templateType == 'DataLabel') {
      renderWidget = _ChartTemplateRenderObject(
          child: templateInfo.widget!,
          templateInfo: templateInfo,
          chartState: widget.chartState,
          animationController: animationController);
    } else {
      renderWidget = _ChartTemplateRenderObject(
          child: templateInfo.widget!,
          templateInfo: templateInfo,
          chartState: widget.chartState,
          animationController: animationController);
    }
    if (templateInfo.animationDuration > 0) {
      final dynamic seriesRenderer = (templateInfo.templateType == 'DataLabel')
          ? widget.chartState._chartSeries
              .visibleSeriesRenderers[templateInfo.seriesIndex]
          : null;
      final bool needsAnimate = widget.chartState._oldDeviceOrientation ==
              MediaQuery.of(context).orientation &&
          ((seriesRenderer != null && seriesRenderer is CartesianSeriesRenderer)
              ? seriesRenderer._needAnimateSeriesElements
              : true);
      animationController = AnimationController(
          duration: Duration(milliseconds: widget.template.animationDuration),
          vsync: this);
      animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animationController!, curve: Curves.linear));
      templateInfo.animationController = animationController!;
      animationController!.forward(from: 1.0);
      templateControllerList.add(animationController!);
      currentWidget = AnimatedBuilder(
          animation: animationController!,
          child: renderWidget,
          builder: (BuildContext context, Widget? _widget) {
            final double value = needsAnimate ? animationController!.value : 1;
            return Opacity(opacity: value * 1.0, child: _widget);
          });
    } else {
      currentWidget = renderWidget;
    }
    return currentWidget;
  }

  @override
  void dispose() {
    if (templateControllerList.isNotEmpty) {
      for (int index = 0; index < templateControllerList.length; index++) {
        templateControllerList[index].dispose();
      }
      templateControllerList.clear();
    }
    super.dispose();
  }
}

/// Represents the render object for annotation widget.
class _ChartTemplateRenderObject extends SingleChildRenderObjectWidget {
  const _ChartTemplateRenderObject(
      {Key? key,
      required Widget child,
      required this.templateInfo,
      required this.chartState,
      required this.animationController})
      : super(key: key, child: child);

  final _ChartTemplateInfo templateInfo;

  final dynamic chartState;

  final AnimationController? animationController;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ChartTemplateRenderBox(
        templateInfo, chartState, animationController);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _ChartTemplateRenderBox renderBox) {
    renderBox..templateInfo = templateInfo;
  }
}

/// Render the annotation widget in the respective position.
class _ChartTemplateRenderBox extends RenderShiftedBox {
  _ChartTemplateRenderBox(
      this._templateInfo, this._chartState, this._animationController,
      [RenderBox? child])
      : super(child);

  _ChartTemplateInfo _templateInfo;

  final dynamic _chartState;

  final AnimationController? _animationController;

  _ChartTemplateInfo get templateInfo => _templateInfo;

  set templateInfo(_ChartTemplateInfo value) {
    if (_templateInfo != value) {
      _templateInfo = value;
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {
    double locationX, locationY;
    bool isLabelWithInRange = true;
    final BoxConstraints constraints = this.constraints;
    if (child != null) {
      locationX = _templateInfo.location.dx;
      locationY = _templateInfo.location.dy;

      /// Here we have added 5px padding to each templates
      const int padding = 5;
      child!.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(Size(child!.size.width, child!.size.height));
      if (child!.parentData is BoxParentData) {
        final BoxParentData childParentData =
            child!.parentData as BoxParentData;
        locationX = locationX -
            (_templateInfo.horizontalAlignment == ChartAlignment.near
                ? 0
                : _templateInfo.horizontalAlignment == ChartAlignment.center
                    ? child!.size.width / 2
                    : child!.size.width);
        locationY = locationY -
            (_templateInfo.verticalAlignment == ChartAlignment.near
                ? 0
                : _templateInfo.verticalAlignment == ChartAlignment.center
                    ? _templateInfo.templateType == 'DataLabel'
                        ? child!.size.height + padding
                        : child!.size.height / 2
                    : child!.size.height);
        if (_templateInfo.templateType == 'DataLabel' &&
            _chartState is SfCartesianChartState) {
          final dynamic seriesRenderer = _chartState
              ._chartSeries.visibleSeriesRenderers[_templateInfo.seriesIndex];
          seriesRenderer._chartState = _chartState;
          seriesRenderer._dataLabelSettingsRenderer = DataLabelSettingsRenderer(
              seriesRenderer._series.dataLabelSettings);
          final CartesianChartPoint<dynamic>? point =
              seriesRenderer._dataPoints != null
                  ? (seriesRenderer._dataPoints.isNotEmpty)
                      ? seriesRenderer._dataPoints[_templateInfo.pointIndex]
                      : null
                  : null;
          if (seriesRenderer._isRectSeries ||
              seriesRenderer._seriesType.contains('hilo') ||
              seriesRenderer._seriesType.contains('candle') ||
              seriesRenderer._seriesType.contains('box')) {
            seriesRenderer.sideBySideInfo =
                _calculateSideBySideInfo(seriesRenderer, _chartState);
          }
          seriesRenderer._hasDataLabelTemplate = true;
          if (seriesRenderer._seriesType.contains('spline')) {
            _calculateSplineAreaControlPoints(seriesRenderer);
          }
          if (point != null && seriesRenderer._seriesType != 'boxandwhisker') {
            if (point.region == null) {
              if (seriesRenderer._visibleDataPoints == null ||
                  seriesRenderer._visibleDataPoints.length >=
                      seriesRenderer._dataPoints.length) {
                seriesRenderer._visibleDataPoints =
                    <CartesianChartPoint<dynamic>>[];
              }
              seriesRenderer._calculateRegionData(_chartState, seriesRenderer,
                  0, point, _templateInfo.pointIndex, null, null, null, null);
            }
            _calculateDataLabelPosition(
                seriesRenderer,
                point,
                _templateInfo.pointIndex!,
                _chartState,
                seriesRenderer._dataLabelSettingsRenderer,
                _animationController!,
                size,
                _templateInfo.location);
            locationX = point.labelLocation!.x;
            locationY = point.labelLocation!.y;
            isLabelWithInRange = _isLabelWithinRange(seriesRenderer, point);
          }
        }
        final Rect rect =
            Rect.fromLTWH(locationX, locationY, size.width, size.height);
        final bool isCollide = (_templateInfo.templateType == 'DataLabel')
            ? _findingCollision(rect, _chartState._dataLabelTemplateRegions)
            : false;
        if (!isCollide &&
            _isTemplateWithinBounds(_templateInfo.clipRect, rect) &&
            isLabelWithInRange) {
          (_templateInfo.templateType == 'DataLabel')
              ? _chartState._dataLabelTemplateRegions.add(rect)
              : _chartState._annotationRegions.add(rect);
          childParentData.offset = Offset(locationX, locationY);
        } else {
          child!
              .layout(constraints.copyWith(maxWidth: 0), parentUsesSize: true);
        }
      }
    } else {
      size = Size.zero;
    }
  }

  /// To check template is within bounds
  bool _isTemplateWithinBounds(Rect bounds, Rect templateRect) =>
      templateRect.left >= bounds.left &&
      templateRect.left + templateRect.width <= bounds.left + bounds.width &&
      templateRect.top >= bounds.top &&
      templateRect.top + templateRect.height <= bounds.top + bounds.height;
}

// ignore: must_be_immutable
class _ChartTemplate extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _ChartTemplate(
      {required this.templates,
      required this.render,
      required this.chartState});

  List<_ChartTemplateInfo> templates;

  bool render = false;

  dynamic chartState;

  late _ChartTemplateState state;

  @override
  State<StatefulWidget> createState() => _ChartTemplateState();
}

class _ChartTemplateState extends State<_ChartTemplate> {
  @override
  void initState() {
    widget.state = this;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.state = this;
    Widget renderTemplate = Container();
    if (widget.chartState._animateCompleted && widget.templates.isNotEmpty) {
      final List<Widget> renderWidgets = <Widget>[];
      for (int i = 0; i < widget.templates.length; i++) {
        renderWidgets.add(_RenderTemplate(
          template: widget.templates[i],
          templateIndex: i,
          templateLength: widget.templates.length,
          chartState: widget.chartState,
        ));
      }
      renderTemplate = Stack(children: renderWidgets);
    }
    return renderTemplate;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void templateRender() {
    if (mounted) {
      setState(() {
        widget.render = true;
      });
    }
  }
}

class _ChartTemplateInfo {
  _ChartTemplateInfo(
      {required this.key,
      required this.widget,
      required this.location,
      required this.animationDuration,
      this.seriesIndex,
      this.pointIndex,
      required this.templateType,
      required this.clipRect,
      this.needMeasure = true,
      ChartAlignment? horizontalAlignment,
      ChartAlignment? verticalAlignment})
      : horizontalAlignment = horizontalAlignment ?? ChartAlignment.center,
        verticalAlignment = verticalAlignment ?? ChartAlignment.center;
  Key? key;
  Widget? widget;
  late Size size;
  late dynamic point;
  Offset location;
  late BuildContext context;
  int animationDuration;
  late AnimationController animationController;
  int? pointIndex;
  int? seriesIndex;
  Rect clipRect;
  String templateType;
  ChartAlignment horizontalAlignment;
  ChartAlignment verticalAlignment;
  bool needMeasure;
}
