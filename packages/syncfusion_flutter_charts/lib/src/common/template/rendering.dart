part of charts;

// ignore: must_be_immutable
class _RenderTemplate extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _RenderTemplate(
      {this.template,
      this.needMeasure,
      this.templateLength,
      this.templateIndex,
      this.chartState});
  final _ChartTemplateInfo template;
  bool needMeasure;
  final int templateLength;
  final int templateIndex;
  final dynamic chartState;
  bool isAnnotation;

  @override
  State<StatefulWidget> createState() => _RenderTemplateState();
}

class _RenderTemplateState extends State<_RenderTemplate>
    with TickerProviderStateMixin {
  List<AnimationController> templateControllerList;
  AnimationController animationController;
  Animation<double> animation;
  @override
  void initState() {
    templateControllerList = <AnimationController>[];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget currentWidget;
    final List<Widget> templateWidgets = <Widget>[];
    if (widget.template.needMeasure) {
      currentWidget = Opacity(opacity: 0.0, child: widget.template.widget);
      widget.template.context = context;
      SchedulerBinding.instance
          .addPostFrameCallback((_) => _templatesMeasureCompleted());
    } else {
      num locationX, locationY;

      /// Here we have added 5px padding to each templates
      const int padding = 5;
      final _ChartTemplateInfo templateInfo = widget.template;
      locationX = templateInfo.location.dx -
          (templateInfo.horizontalAlignment == ChartAlignment.near
              ? 0
              : templateInfo.horizontalAlignment == ChartAlignment.center
                  ? templateInfo.size.width / 2
                  : templateInfo.size.width);
      locationY = templateInfo.location.dy -
          (templateInfo.verticalAlignment == ChartAlignment.near
              ? 0
              : templateInfo.verticalAlignment == ChartAlignment.center
                  ? templateInfo.templateType == 'DataLabel'
                      ? templateInfo.size.height + padding
                      : templateInfo.size.height / 2
                  : templateInfo.size.height);
      bool isLabelWithInRange = true;
      if (templateInfo.templateType == 'DataLabel' &&
          widget.chartState is SfCartesianChartState) {
        final dynamic seriesRenderer = widget.chartState._chartSeries
            .visibleSeriesRenderers[templateInfo.seriesIndex];
        seriesRenderer._dataLabelSettingsRenderer =
            DataLabelSettingsRenderer(seriesRenderer._series.dataLabelSettings);
        final CartesianChartPoint<dynamic> point =
            seriesRenderer._dataPoints != null
                ? (seriesRenderer._dataPoints.isNotEmpty)
                    ? seriesRenderer._dataPoints[templateInfo.pointIndex]
                    : null
                : null;
        if (point != null && seriesRenderer._seriesType != 'boxandwhisker') {
          if (point.region == null &&
              seriesRenderer._seriesType != 'waterfall') {
            seriesRenderer._calculateRegionData(
                widget.chartState,
                seriesRenderer,
                0,
                point,
                templateInfo.pointIndex,
                null,
                null,
                null,
                null);
          }
          _calculateDataLabelPosition(
              seriesRenderer,
              point,
              templateInfo.pointIndex,
              widget.chartState,
              seriesRenderer._dataLabelSettingsRenderer,
              animationController,
              widget.template.size,
              templateInfo.location);
          locationX = point.labelLocation.x;
          locationY = point.labelLocation.y;
          isLabelWithInRange = _isLabelWithinRange(seriesRenderer, point);
        }
      }
      final Rect rect = Rect.fromLTWH(locationX, locationY,
          templateInfo.size.width, templateInfo.size.height);
      final bool isCollide = (templateInfo.templateType == 'DataLabel')
          ? _findingCollision(rect, widget.chartState._dataLabelTemplateRegions)
          : false;
      if (!isCollide &&
          _isTemplateWithinBounds(templateInfo.clipRect, rect) &&
          isLabelWithInRange) {
        final Widget renderWidget = Stack(children: <Widget>[
          Positioned(
            left: locationX,
            top: locationY,
            child: templateInfo.widget,
          )
        ]);
        (templateInfo.templateType == 'DataLabel')
            ? widget.chartState._dataLabelTemplateRegions.add(rect)
            : widget.chartState._annotationRegions.add(rect);

        if (templateInfo.animationDuration > 0) {
          final dynamic seriesRenderer =
              (templateInfo.templateType == 'DataLabel')
                  ? widget.chartState._chartSeries
                      .visibleSeriesRenderers[templateInfo.seriesIndex]
                  : null;
          final bool needsAnimate = widget.chartState._oldDeviceOrientation ==
                  MediaQuery.of(context).orientation &&
              ((seriesRenderer != null &&
                      seriesRenderer is CartesianSeriesRenderer)
                  ? seriesRenderer._needAnimateSeriesElements
                  : true);
          animationController = AnimationController(
              duration:
                  Duration(milliseconds: widget.template.animationDuration),
              vsync: this);
          animation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: animationController, curve: Curves.linear));
          templateInfo.animationController = animationController;
          animationController.forward(from: 0.0);
          templateControllerList.add(animationController);
          templateWidgets.add(AnimatedBuilder(
              animation: animationController,
              child: renderWidget,
              builder: (BuildContext context, Widget _widget) {
                final double value =
                    needsAnimate ? animationController.value : 1;
                return Opacity(opacity: value * 1.0, child: _widget);
              }));
        } else {
          templateWidgets.add(renderWidget);
        }
      }
      currentWidget = Container(child: Stack(children: templateWidgets));
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

  /// To calculate need to measure template
  void _templatesMeasureCompleted() {
    final RenderBox renderBox = widget.template.context.findRenderObject();
    widget.template.size = renderBox.size;
    setState(() {
      widget.template.needMeasure = false;
    });
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
  _ChartTemplate({this.templates, this.render, this.chartState});

  List<_ChartTemplateInfo> templates;

  bool render = false;

  dynamic chartState;

  _ChartTemplateState state;

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
    setState(() {
      widget.render = true;
    });
  }
}

class _ChartTemplateInfo {
  _ChartTemplateInfo(
      {this.key,
      this.widget,
      this.location,
      this.animationDuration,
      this.seriesIndex,
      this.pointIndex,
      this.templateType,
      this.clipRect,
      this.needMeasure,
      ChartAlignment horizontalAlignment,
      ChartAlignment verticalAlignment})
      : horizontalAlignment = horizontalAlignment ?? ChartAlignment.center,
        verticalAlignment = verticalAlignment ?? ChartAlignment.center;
  Key key;
  Widget widget;
  Size size;
  dynamic point;
  Offset location;
  BuildContext context;
  int animationDuration;
  AnimationController animationController;
  int pointIndex;
  int seriesIndex;
  Rect clipRect;
  String templateType;
  ChartAlignment horizontalAlignment;
  ChartAlignment verticalAlignment;
  bool needMeasure;
}
