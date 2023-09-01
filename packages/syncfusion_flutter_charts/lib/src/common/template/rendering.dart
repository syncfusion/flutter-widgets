import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../charts.dart';
import '../../chart/chart_series/series.dart';
import '../../chart/chart_series/series_renderer_properties.dart';
import '../../chart/common/cartesian_state_properties.dart';
import '../../chart/common/data_label.dart';
import '../../chart/common/data_label_renderer.dart';
import '../../chart/utils/helper.dart';
import '../../circular_chart/base/circular_state_properties.dart';
import '../../circular_chart/renderer/data_label_renderer.dart';
import '../../circular_chart/renderer/renderer_extension.dart';
import '../../circular_chart/utils/helper.dart';
import '../rendering_details.dart';
import '../state_properties.dart';

import '../utils/helper.dart';

/// Represents the render template class.
// ignore: must_be_immutable
class RenderTemplate extends StatefulWidget {
  /// Creates an instance of render template.
  // ignore: prefer_const_constructors_in_immutables
  RenderTemplate({
    required this.template,
    this.needMeasure,
    required this.templateLength,
    required this.templateIndex,
    required this.stateProperties,
    this.notifier,
  });

  /// Hold the value of chart template info.
  final ChartTemplateInfo template;

  /// Specifies whether to measure the template.
  bool? needMeasure;

  /// Specifies the template length.
  final int templateLength;

  /// Specifies the template index value.
  final int templateIndex;

  /// Holds the value of state properties.
  final StateProperties stateProperties;

  /// Specifies whether it is annotation.
  bool? isAnnotation;

  /// Specifies the template notifier value.
  final ValueNotifier<int>? notifier;

  @override
  State<StatefulWidget> createState() => _RenderTemplateState();
}

class _RenderTemplateState extends State<RenderTemplate>
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
    final ChartTemplateInfo templateInfo = widget.template;
    Widget currentWidget = Container();
    Widget renderWidget;
    if (templateInfo.templateType == 'DataLabel') {
      renderWidget = _ChartTemplateRenderObject(
          templateInfo: templateInfo,
          stateProperties: widget.stateProperties,
          animationController: animationController,
          notifier: widget.notifier,
          child: templateInfo.widget!);
    } else {
      renderWidget = _ChartTemplateRenderObject(
          templateInfo: templateInfo,
          stateProperties: widget.stateProperties,
          animationController: animationController,
          child: templateInfo.widget!);
    }
    if (templateInfo.animationDuration > 0) {
      final dynamic stateProperties = widget.stateProperties;
      final dynamic seriesRendererDetails =
          (templateInfo.templateType == 'DataLabel')
              ? stateProperties is CartesianStateProperties
                  ? SeriesHelper.getSeriesRendererDetails(stateProperties
                      .chartSeries
                      .visibleSeriesRenderers[templateInfo.seriesIndex!])
                  : stateProperties.chartSeries
                      .visibleSeriesRenderers[templateInfo.seriesIndex!]
              : null;
      final Orientation? orientation =
          widget.stateProperties.renderingDetails.oldDeviceOrientation;
      final bool needsAnimate =
          orientation == MediaQuery.of(context).orientation &&
              (!(seriesRendererDetails != null &&
                      seriesRendererDetails is SeriesRendererDetails) ||
                  seriesRendererDetails.needAnimateSeriesElements == true);
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
          builder: (BuildContext context, Widget? widget) {
            final double value = needsAnimate ? animationController!.value : 1;
            return Opacity(opacity: value * 1.0, child: widget);
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
      required this.stateProperties,
      required this.animationController,
      this.notifier})
      : super(key: key, child: child);

  final ChartTemplateInfo templateInfo;

  final StateProperties stateProperties;

  final AnimationController? animationController;

  final ValueNotifier<int>? notifier;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ChartTemplateRenderBox(
        templateInfo, stateProperties, animationController, notifier);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _ChartTemplateRenderBox renderBox) {
    renderBox.templateInfo = templateInfo;
  }
}

/// Render the annotation widget in the respective position.
class _ChartTemplateRenderBox extends RenderShiftedBox {
  _ChartTemplateRenderBox(this._templateInfo, this.stateProperties,
      this._animationController, this.notifier,
      [RenderBox? child])
      : super(child);

  ChartTemplateInfo _templateInfo;

  final dynamic stateProperties;

  final AnimationController? _animationController;

  final ValueNotifier<int>? notifier;

  ChartTemplateInfo get templateInfo => _templateInfo;

  set templateInfo(ChartTemplateInfo value) {
    if (_templateInfo != value) {
      _templateInfo = value;
      markNeedsLayout();
    }
  }

  @override
  void attach(PipelineOwner owner) {
    if (notifier != null) {
      notifier?.addListener(markNeedsLayout);
    }
    super.attach(owner);
  }

  @override
  void detach() {
    if (notifier != null) {
      notifier?.removeListener(markNeedsLayout);
    }
    super.detach();
  }

  @override
  void performLayout() {
    double locationX, locationY;
    bool isLabelWithInRange = true;
    final BoxConstraints constraints = this.constraints;
    if (child != null) {
      locationX = _templateInfo.location.dx;
      locationY = _templateInfo.location.dy;
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
                    ? child!.size.height / 2
                    : child!.size.height);
        if (_templateInfo.templateType == 'DataLabel' &&
            stateProperties is CartesianStateProperties) {
          final SeriesRendererDetails seriesRendererDetails =
              SeriesHelper.getSeriesRendererDetails(stateProperties.chartSeries
                  .visibleSeriesRenderers[_templateInfo.seriesIndex]);
          seriesRendererDetails.stateProperties = stateProperties;
          seriesRendererDetails.dataLabelSettingsRenderer =
              DataLabelSettingsRenderer(
                  seriesRendererDetails.series.dataLabelSettings);
          final CartesianChartPoint<dynamic>? point =
              (seriesRendererDetails.dataPoints.isNotEmpty == true)
                  ? seriesRendererDetails.dataPoints[_templateInfo.pointIndex!]
                  : null;
          if (seriesRendererDetails.isRectSeries == true ||
              seriesRendererDetails.seriesType.contains('hilo') == true ||
              seriesRendererDetails.seriesType.contains('candle') == true ||
              seriesRendererDetails.seriesType.contains('box') == true) {
            seriesRendererDetails.sideBySideInfo = calculateSideBySideInfo(
                seriesRendererDetails.renderer, stateProperties);
          }
          seriesRendererDetails.hasDataLabelTemplate = true;
          if (seriesRendererDetails.seriesType.contains('spline') == true) {
            if (seriesRendererDetails.drawControlPoints.isNotEmpty == true) {
              seriesRendererDetails.drawControlPoints.clear();
            }
            calculateSplineAreaControlPoints(seriesRendererDetails.renderer);
          }
          if (point != null &&
              seriesRendererDetails.seriesType != 'boxandwhisker') {
            if (point.region == null) {
              if (seriesRendererDetails.visibleDataPoints == null ||
                  seriesRendererDetails.visibleDataPoints!.length >=
                          seriesRendererDetails.dataPoints.length ==
                      true) {
                seriesRendererDetails.visibleDataPoints =
                    <CartesianChartPoint<dynamic>>[];
              }

              seriesRendererDetails.setSeriesProperties(seriesRendererDetails);
              seriesRendererDetails.calculateRegionData(stateProperties,
                  seriesRendererDetails, 0, point, _templateInfo.pointIndex!);
            }
            calculateDataLabelPosition(
                seriesRendererDetails,
                point,
                _templateInfo.pointIndex!,
                stateProperties,
                seriesRendererDetails.dataLabelSettingsRenderer,
                _animationController!,
                size,
                _templateInfo.location);
            locationX = _templateInfo.labelLocation == 'labelLocation'
                ? point.labelLocation!.x
                : _templateInfo.labelLocation == 'labelLocation2'
                    ? point.labelLocation2!.x
                    : _templateInfo.labelLocation == 'labelLocation3'
                        ? point.labelLocation3!.x
                        : _templateInfo.labelLocation == 'labelLocation4'
                            ? point.labelLocation4!.x
                            : point.labelLocation5!.x;
            locationY = _templateInfo.labelLocation == 'labelLocation'
                ? point.labelLocation!.y
                : _templateInfo.labelLocation == 'labelLocation2'
                    ? point.labelLocation2!.y
                    : _templateInfo.labelLocation == 'labelLocation3'
                        ? point.labelLocation3!.y
                        : _templateInfo.labelLocation == 'labelLocation4'
                            ? point.labelLocation4!.y
                            : point.labelLocation5!.y;
            isLabelWithInRange =
                isLabelWithinRange(seriesRendererDetails, point);
          }
        }
        final Rect rect =
            Rect.fromLTWH(locationX, locationY, size.width, size.height);
        final List<Rect> dataLabelTemplateRegions =
            stateProperties.renderingDetails.dataLabelTemplateRegions;
        final bool isCollide = (_templateInfo.templateType == 'DataLabel') &&
            findingCollision(rect, dataLabelTemplateRegions);
        if (stateProperties is CircularStateProperties &&
            _templateInfo.templateType == 'DataLabel' &&
            stateProperties.chartSeries.visibleSeriesRenderers[0].seriesType !=
                'radialbar') {
          final CircularSeriesRendererExtension seriesRenderer =
              (stateProperties as CircularStateProperties)
                  .chartSeries
                  .visibleSeriesRenderers[0];
          final DataLabelSettings dataLabelSettings =
              seriesRenderer.dataLabelSettingsRenderer.dataLabelSettings;
          if (dataLabelSettings.labelIntersectAction ==
              LabelIntersectAction.shift) {
            dataLabelTemplateRegions.add(rect);
          } else {
            final ChartPoint<dynamic> point =
                seriesRenderer.renderPoints![_templateInfo.pointIndex!];
            if ((isCollide &&
                    dataLabelSettings.labelIntersectAction ==
                        LabelIntersectAction.hide &&
                    child != null &&
                    child!.size != Size.zero) ||
                (!isTemplateWithinBounds(_templateInfo.clipRect, rect) ||
                    (point.y == 0 && !dataLabelSettings.showZeroValue))) {
              child!.layout(constraints.copyWith(maxWidth: 0, maxHeight: 0),
                  parentUsesSize: true);
              dataLabelTemplateRegions.add(Rect.zero);
            } else {
              childParentData.offset = Offset(locationX, locationY);
              dataLabelTemplateRegions.add(rect);
            }
          }
        } else if (!isCollide &&
            isTemplateWithinBounds(_templateInfo.clipRect, rect) &&
            isLabelWithInRange) {
          (_templateInfo.templateType == 'DataLabel')
              ? dataLabelTemplateRegions.add(rect)
              : stateProperties.annotationRegions.add(rect);
          childParentData.offset = Offset(locationX, locationY);
        } else {
          if (child != null && child!.size != Size.zero) {
            child!.layout(constraints.copyWith(maxWidth: 0, maxHeight: 0),
                parentUsesSize: true);
          }
        }
      }
    } else {
      size = Size.zero;
    }
  }
}

/// Represents the chart template class.
// ignore: must_be_immutable
class ChartTemplate extends StatefulWidget {
  /// Creates an instance of chart template class.
  // ignore: prefer_const_constructors_in_immutables
  ChartTemplate(
      {required this.templates,
      required this.render,
      required this.stateProperties});

  /// Holds the list of chart template info.
  List<ChartTemplateInfo> templates;

  /// Specifies whether the template is rendered.
  bool render = false;

  /// Holds the value of state properties.
  StateProperties stateProperties;

  /// Holds the value of chart template state.
  // ignore: library_private_types_in_public_api
  late _ChartTemplateState state;

  @override
  State<StatefulWidget> createState() => _ChartTemplateState();
}

/// Represent the render object for circular data label template.
class DataLabelTemplateStack extends Stack {
  /// Creating an argument constructor of DataLabelTemplateStack class.
  const DataLabelTemplateStack(
      {required this.renderingDetails,
      required this.stateProperties,
      required List<Widget> children})
      : super(children: children);

  /// Holds circular series rendering details.
  final RenderingDetails renderingDetails;

  /// Holds circular series state properties.
  final CircularStateProperties stateProperties;

  @override
  RenderStack createRenderObject(BuildContext context) {
    final RenderDataLabelTemplateStack dataLabelTemplateStack =
        RenderDataLabelTemplateStack()
          ..renderingDetails = renderingDetails
          ..stateProperties = stateProperties
          ..textDirection = Directionality.maybeOf(context);
    return dataLabelTemplateStack;
  }
}

/// Shifted the circular data label template based on the template size.
class RenderDataLabelTemplateStack extends RenderStack {
  /// Holds the Circular series rendering.
  late RenderingDetails renderingDetails;

  /// Holds the CircularStateProperties.
  late CircularStateProperties stateProperties;

  @override
  void performLayout() {
    super.performLayout();
    final CircularSeriesRendererExtension seriesRenderer =
        stateProperties.chartSeries.visibleSeriesRenderers[0];
    final List<Rect> regions = renderingDetails.dataLabelTemplateRegions;
    shiftCircularDataLabelTemplate(seriesRenderer, stateProperties, regions);
    RenderBox child = firstChild!;
    const int labelPadding = 2;
    final EdgeInsets margin = seriesRenderer.series.dataLabelSettings.margin;
    int pointIndex = 0;
    final List<ChartTemplateInfo> templates =
        renderingDetails.chartTemplate!.templates;
    // Iterate the template for avoid the hidden data points and get the visible points.
    while (pointIndex < templates.length) {
      final ChartPoint<dynamic> point =
          seriesRenderer.renderPoints![templates[pointIndex].pointIndex!];
      if (point.isVisible &&
          templates[pointIndex].templateType == 'DataLabel') {
        final Rect rect = point.labelRect;
        final Offset labelLocation = Offset(
            rect.left +
                (point.renderPosition == ChartDataLabelPosition.inside
                    ? labelPadding
                    : margin.left),
            rect.top + (rect.height / 2 - regions[pointIndex].height / 2));
        final StackParentData parentData = child.parentData as StackParentData;
        if (isTemplateWithinBounds(
                stateProperties.renderingDetails.chartAreaRect, rect) &&
            !isOverlapWithPrevious(
                point, seriesRenderer.renderPoints!, point.index) &&
            (point.y != 0 ||
                seriesRenderer.series.dataLabelSettings.showZeroValue)) {
          parentData.offset = labelLocation;
        } else {
          // made a child size to zero when it is goes outside the chart area or overlap with previous template.
          child.layout(constraints.copyWith(maxHeight: 0, maxWidth: 0));
        }
        if (pointIndex < renderingDetails.chartTemplate!.templates.length - 1) {
          child = (child.parentData! as StackParentData).nextSibling!;
        }
      }
      pointIndex++;
    }
  }
}

class _ChartTemplateState extends State<ChartTemplate> {
  @override
  void initState() {
    widget.state = this;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.state = this;
    Widget renderTemplate = Container();
    CircularSeriesRendererExtension? seriesRenderer;
    DataLabelSettings? dataLabelSettings;
    if (widget.stateProperties is CircularStateProperties) {
      seriesRenderer = (widget.stateProperties as CircularStateProperties)
          .chartSeries
          .visibleSeriesRenderers[0];
      if (seriesRenderer.series.dataLabelSettings.isVisible) {
        seriesRenderer.dataLabelSettingsRenderer =
            DataLabelSettingsRenderer(seriesRenderer.series.dataLabelSettings);
        dataLabelSettings =
            seriesRenderer.dataLabelSettingsRenderer.dataLabelSettings;
      }
    }
    final bool animationCompleted =
        widget.stateProperties.renderingDetails.animateCompleted;
    if (animationCompleted && widget.templates.isNotEmpty) {
      final List<Widget> renderWidgets = <Widget>[];
      for (int i = 0; i < widget.templates.length; i++) {
        renderWidgets.add(RenderTemplate(
          template: widget.templates[i],
          templateIndex: i,
          templateLength: widget.templates.length,
          stateProperties: widget.stateProperties,
        ));
      }
      renderTemplate = ((widget.stateProperties is CircularStateProperties) &&
              dataLabelSettings != null &&
              seriesRenderer!.seriesType != 'radialbar' &&
              dataLabelSettings.labelIntersectAction ==
                  LabelIntersectAction.shift &&
              dataLabelSettings.builder != null)
          ? DataLabelTemplateStack(
              renderingDetails: widget.stateProperties.renderingDetails,
              stateProperties:
                  widget.stateProperties as CircularStateProperties,
              children: renderWidgets)
          : Stack(
              children: renderWidgets,
            );
    }
    return renderTemplate;
  }

  void templateRender() {
    if (mounted) {
      setState(() {
        widget.render = true;
      });
    }
  }
}

/// Represents the chart template info class.
class ChartTemplateInfo {
  /// Creates an instance of chart template info class.
  ChartTemplateInfo(
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
      ChartAlignment? verticalAlignment,
      this.labelLocation})
      : horizontalAlignment = horizontalAlignment ?? ChartAlignment.center,
        verticalAlignment = verticalAlignment ?? ChartAlignment.center;

  /// Specifies the key value.
  Key? key;

  /// Specifies the widget.
  Widget? widget;

  /// Holds the size value.
  late Size size;

  /// Holds the point value.
  late dynamic point;

  /// Holds the value of location.
  Offset location;

  /// Specifies the build context value.
  late BuildContext context;

  /// Specifies the animation duration.
  int animationDuration;

  /// Specifies the value of animation controller.
  late AnimationController animationController;

  /// Specifies the point index value.
  int? pointIndex;

  /// Specifies the series index value.
  int? seriesIndex;

  /// Specifies the clip rect value.
  Rect clipRect;

  /// Holds the template type.
  String templateType;

  /// Holds the value of horizontal alignment.
  ChartAlignment horizontalAlignment;

  /// Holds the value of vertical alignment.
  ChartAlignment verticalAlignment;

  /// Specifies whether to measure the template.
  bool needMeasure;

  /// Specifies the label location
  String? labelLocation;
}
