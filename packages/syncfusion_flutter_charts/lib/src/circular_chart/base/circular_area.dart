import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_core/tooltip_internal.dart';

import '../../../charts.dart';
import '../../chart/user_interaction/selection_renderer.dart';
import '../../common/template/rendering.dart';
import '../../common/user_interaction/selection_behavior.dart';
import '../../common/user_interaction/tooltip.dart';
import '../../common/user_interaction/tooltip_rendering_details.dart';
import '../../common/utils/helper.dart';
import '../renderer/common.dart';
import '../renderer/data_label_renderer.dart';
import '../renderer/renderer_extension.dart';
import '../series_painter/doughnut_series_painter.dart';
import '../series_painter/pie_chart_painter.dart';
import '../series_painter/radial_bar_painter.dart';
import '../utils/helper.dart';
import 'circular_state_properties.dart';

/// Represents the circular chart area.
///
// ignore: must_be_immutable
class CircularArea extends StatelessWidget {
  /// Creates an instance for circular area.
  // ignore: prefer_const_constructors_in_immutables
  CircularArea({required this.stateProperties});

  /// Here, we are using get keyword in order to get the proper & updated instance of chart widget.
  /// When we initialize chart widget as a property to other classes like _ChartSeries, the chart widget is not updated properly and by using get we can rectify this.
  SfCircularChart get chart => stateProperties.chart;

  /// Holds the chart state properties.
  final CircularStateProperties stateProperties;

  /// Gets or sets the circular series.
  CircularSeries<dynamic, dynamic>? series;

  /// Holds the render box of the circular chart.
  late RenderBox renderBox;

  /// Specifies the point region.
  Region? pointRegion;

  /// Holds the tap down details.
  late TapDownDetails tapDownDetails;

  /// Holds the double tap position.
  Offset? doubleTapPosition;

  /// Specifies whether the mouse is hovered.
  final bool _enableMouseHover = kIsWeb;

  /// Stores pointer down time to determine whether a long press interaction is handled at pointer up
  DateTime? pointerHoldingTime;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      // ignore: avoid_unnecessary_containers
      return Container(
        child: MouseRegion(
            // Using the _enableMouseHover property, prevented mouse hover function in mobile platforms. The mouse hover event should not be triggered for mobile platforms and logged an issue regarding this to the Flutter team.
            // Issue:  https://github.com/flutter/flutter/issues/68690
            onHover: (PointerEvent event) =>
                _enableMouseHover ? _onHover(event) : null,
            onExit: (PointerEvent event) {
              TooltipHelper.getRenderingDetails(
                      stateProperties.renderingDetails.tooltipBehaviorRenderer)
                  .isHovering = false;
            },
            child: Listener(
              onPointerUp: (PointerUpEvent event) => _onPointerUp(event),
              onPointerDown: (PointerDownEvent event) => _onPointerDown(event),
              onPointerMove: (PointerMoveEvent event) =>
                  _performPointerMove(event),
              child: GestureDetector(
                  onLongPress: _onLongPress,
                  onTapUp: (TapUpDetails details) {
                    if (chart.series[0].onPointTap != null &&
                        pointRegion != null) {
                      calculatePointSeriesIndex(chart, stateProperties, null,
                          pointRegion, ActivationMode.singleTap);
                    }
                  },
                  onDoubleTap: _onDoubleTap,
                  child: Container(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: _initializeChart(constraints, context),
                  )),
            )),
      );
    });
  }

  /// To perform the pointer down event.
  void _onPointerDown(PointerDownEvent event) {
    if (stateProperties.renderingDetails.currentActive != null &&
        stateProperties.renderingDetails.currentActive!.series != null &&
        stateProperties.renderingDetails.currentActive!.series.explodeGesture ==
            ActivationMode.singleTap) {
      pointerHoldingTime = DateTime.now();
    }
    ChartTouchInteractionArgs touchArgs;
    final TooltipRenderingDetails tooltipRenderingDetails =
        TooltipHelper.getRenderingDetails(
            stateProperties.renderingDetails.tooltipBehaviorRenderer);
    tooltipRenderingDetails.isHovering = false;
    stateProperties.renderingDetails.currentActive = null;
    stateProperties.renderingDetails.tapPosition =
        renderBox.globalToLocal(event.position);
    pointRegion = getCircularPointRegion(
        chart,
        stateProperties.renderingDetails.tapPosition,
        stateProperties.chartSeries.visibleSeriesRenderers[0]);
    doubleTapPosition = stateProperties.renderingDetails.tapPosition;
    if (stateProperties.renderingDetails.tapPosition != null &&
        pointRegion != null) {
      stateProperties.renderingDetails.currentActive = ChartInteraction(
          pointRegion?.seriesIndex,
          pointRegion?.pointIndex,
          stateProperties.chartSeries
              .visibleSeriesRenderers[pointRegion!.seriesIndex].series,
          stateProperties
              .chartSeries
              .visibleSeriesRenderers[pointRegion!.seriesIndex]
              .renderPoints![pointRegion!.pointIndex],
          pointRegion);
    } else {
      //hides the tooltip if the point of interaction is outside circular region of the chart
      tooltipRenderingDetails.show = false;
      tooltipRenderingDetails.hideTooltipTemplate();
    }
    if (chart.onChartTouchInteractionDown != null) {
      touchArgs = ChartTouchInteractionArgs();
      touchArgs.position = renderBox.globalToLocal(event.position);
      chart.onChartTouchInteractionDown!(touchArgs);
    }
  }

  /// To perform the pointer move event.
  void _performPointerMove(PointerMoveEvent event) {
    ChartTouchInteractionArgs touchArgs;
    final Offset position = renderBox.globalToLocal(event.position);
    if (chart.onChartTouchInteractionMove != null) {
      touchArgs = ChartTouchInteractionArgs();
      touchArgs.position = position;
      chart.onChartTouchInteractionMove!(touchArgs);
    }
  }

  /// To perform double tap touch interactions.
  void _onDoubleTap() {
    if (doubleTapPosition != null && pointRegion != null) {
      if (chart.series[0].onPointDoubleTap != null && pointRegion != null) {
        calculatePointSeriesIndex(chart, stateProperties, null, pointRegion,
            ActivationMode.doubleTap);
      }
      stateProperties.renderingDetails.currentActive = ChartInteraction(
          pointRegion?.seriesIndex,
          pointRegion?.pointIndex,
          stateProperties.chartSeries
              .visibleSeriesRenderers[pointRegion!.seriesIndex].series,
          stateProperties
              .chartSeries
              .visibleSeriesRenderers[pointRegion!.seriesIndex]
              .renderPoints![pointRegion!.pointIndex],
          pointRegion);
      final ChartInteraction? currentActive =
          stateProperties.renderingDetails.currentActive;
      if (currentActive != null) {
        if (currentActive.series.explodeGesture == ActivationMode.doubleTap) {
          stateProperties.chartSeries
              .seriesPointExplosion(currentActive.region);
        }
      }
      stateProperties.chartSeries
          .seriesPointSelection(pointRegion, ActivationMode.doubleTap);
      if (chart.tooltipBehavior.enable &&
          stateProperties.renderingDetails.animateCompleted &&
          chart.tooltipBehavior.activationMode == ActivationMode.doubleTap &&
          doubleTapPosition != null) {
        stateProperties.requireDataLabelTooltip = null;
        if (chart.tooltipBehavior.builder != null) {
          showCircularTooltipTemplate();
        } else {
          stateProperties.renderingDetails.tooltipBehaviorRenderer.onDoubleTap(
              doubleTapPosition!.dx.toDouble(),
              doubleTapPosition!.dy.toDouble());
        }
      }
    }
  }

  /// To perform long press touch interactions.
  void _onLongPress() {
    if (stateProperties.renderingDetails.tapPosition != null &&
        pointRegion != null) {
      if (chart.series[0].onPointLongPress != null && pointRegion != null) {
        calculatePointSeriesIndex(chart, stateProperties, null, pointRegion,
            ActivationMode.longPress);
      }
      stateProperties.renderingDetails.currentActive = ChartInteraction(
          pointRegion?.seriesIndex,
          pointRegion?.pointIndex,
          stateProperties.chartSeries
              .visibleSeriesRenderers[pointRegion!.seriesIndex].series,
          stateProperties
              .chartSeries
              .visibleSeriesRenderers[pointRegion!.seriesIndex]
              .renderPoints![pointRegion!.pointIndex],
          pointRegion);
      stateProperties.chartSeries
          .seriesPointSelection(pointRegion, ActivationMode.longPress);
      final ChartInteraction? currentActive =
          stateProperties.renderingDetails.currentActive;
      if (currentActive != null) {
        if (currentActive.series.explodeGesture == ActivationMode.longPress) {
          stateProperties.chartSeries
              .seriesPointExplosion(currentActive.region);
        }
      }
      if (chart.tooltipBehavior.enable &&
          stateProperties.renderingDetails.animateCompleted &&
          chart.tooltipBehavior.activationMode == ActivationMode.longPress &&
          stateProperties.renderingDetails.tapPosition != null) {
        stateProperties.requireDataLabelTooltip = null;
        if (chart.tooltipBehavior.builder != null) {
          showCircularTooltipTemplate();
        } else {
          stateProperties.renderingDetails.tooltipBehaviorRenderer.onLongPress(
              stateProperties.renderingDetails.tapPosition!.dx.toDouble(),
              stateProperties.renderingDetails.tapPosition!.dy.toDouble());
        }
      }
    }
  }

  /// To perform the pointer up event.
  void _onPointerUp(PointerUpEvent event) {
    final ChartInteraction? currentActive =
        stateProperties.renderingDetails.currentActive;
    TooltipHelper.getRenderingDetails(
            stateProperties.renderingDetails.tooltipBehaviorRenderer)
        .isHovering = false;
    ChartTouchInteractionArgs touchArgs;
    final CircularSeriesRendererExtension seriesRenderer =
        stateProperties.chartSeries.visibleSeriesRenderers[0];
    final Offset position = renderBox.globalToLocal(event.position);
    if (stateProperties.animationCompleted) {
      _showTrimmedDataLabelTooltip(position, stateProperties, seriesRenderer);
    }
    if (chart.onDataLabelTapped != null) {
      triggerCircularDataLabelEvent(chart, seriesRenderer, stateProperties,
          stateProperties.renderingDetails.tapPosition);
    }
    if (stateProperties.renderingDetails.tapPosition != null) {
      if (currentActive != null &&
          currentActive.series != null &&
          currentActive.series.explodeGesture == ActivationMode.singleTap &&
          pointerHoldingTime != null &&
          DateTime.now().difference(pointerHoldingTime!).inMilliseconds <
              kLongPressTimeout.inMilliseconds) {
        stateProperties.chartSeries.seriesPointExplosion(currentActive.region);
      }

      if (stateProperties.renderingDetails.tapPosition != null &&
          currentActive != null) {
        stateProperties.chartSeries.seriesPointSelection(
            currentActive.region, ActivationMode.singleTap);
      }
      if (chart.tooltipBehavior.enable &&
          stateProperties.renderingDetails.animateCompleted &&
          chart.tooltipBehavior.activationMode == ActivationMode.singleTap &&
          currentActive != null &&
          currentActive.series != null) {
        stateProperties.requireDataLabelTooltip = null;
        if (chart.tooltipBehavior.builder != null) {
          showCircularTooltipTemplate();
        } else {
          stateProperties.renderingDetails.tooltipBehaviorRenderer
              .onTouchUp(position.dx.toDouble(), position.dy.toDouble());
        }
      }
      if (chart.onChartTouchInteractionUp != null) {
        touchArgs = ChartTouchInteractionArgs();
        touchArgs.position = renderBox.globalToLocal(event.position);
        chart.onChartTouchInteractionUp!(touchArgs);
      }
    }
    stateProperties.renderingDetails.tapPosition = null;
  }

  /// To perform the hover event.
  void _onHover(PointerEvent event) {
    final TooltipRenderingDetails tooltipRenderingDetails =
        TooltipHelper.getRenderingDetails(
            stateProperties.renderingDetails.tooltipBehaviorRenderer);
    stateProperties.renderingDetails.currentActive = null;
    stateProperties.renderingDetails.tapPosition =
        renderBox.globalToLocal(event.position);
    pointRegion = getCircularPointRegion(
        chart,
        stateProperties.renderingDetails.tapPosition,
        stateProperties.chartSeries.visibleSeriesRenderers[0]);
    final CircularSeriesRendererExtension seriesRenderer =
        stateProperties.chartSeries.visibleSeriesRenderers[0];
    final Offset position = renderBox.globalToLocal(event.position);
    if (stateProperties.animationCompleted) {
      _showTrimmedDataLabelTooltip(position, stateProperties, seriesRenderer);
    }
    if (stateProperties.renderingDetails.tapPosition != null &&
        pointRegion != null) {
      stateProperties.renderingDetails.currentActive = ChartInteraction(
          pointRegion!.seriesIndex,
          pointRegion!.pointIndex,
          stateProperties.chartSeries
              .visibleSeriesRenderers[pointRegion!.seriesIndex].series,
          stateProperties
              .chartSeries
              .visibleSeriesRenderers[pointRegion!.seriesIndex]
              .renderPoints![pointRegion!.pointIndex],
          pointRegion);
    } else {
      //hides the tooltip when the mouse is hovering out of the circular region
      tooltipRenderingDetails.hide();
    }
    if (stateProperties.renderingDetails.tapPosition != null) {
      if (chart.tooltipBehavior.enable &&
          stateProperties.renderingDetails.currentActive != null &&
          stateProperties.renderingDetails.currentActive!.series != null) {
        tooltipRenderingDetails.isHovering = true;
        stateProperties.requireDataLabelTooltip = null;
        if (chart.tooltipBehavior.builder != null) {
          showCircularTooltipTemplate();
        } else {
          stateProperties.renderingDetails.tooltipBehaviorRenderer
              .onEnter(position.dx.toDouble(), position.dy.toDouble());
        }
      } else {
        tooltipRenderingDetails.prevTooltipValue = null;
        tooltipRenderingDetails.currentTooltipValue = null;
      }
    }
    stateProperties.renderingDetails.tapPosition = null;
  }

  /// This method gets executed for showing tooltip when builder is provided in behavior.
  /// The optional parameters will take values once the public method gets called.
  void showCircularTooltipTemplate([int? seriesIndex, int? pointIndex]) {
    stateProperties.isTooltipHidden = false;
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        stateProperties.renderingDetails.tooltipBehaviorRenderer;
    final TooltipRenderingDetails tooltipRenderingDetails =
        TooltipHelper.getRenderingDetails(tooltipBehaviorRenderer);
    if (!tooltipRenderingDetails.isHovering) {
      //assigning null for the previous and current tooltip values in case of touch interaction
      tooltipRenderingDetails.prevTooltipValue = null;
      tooltipRenderingDetails.currentTooltipValue = null;
    }
    final CircularSeries<dynamic, dynamic> chartSeries =
        stateProperties.renderingDetails.currentActive?.series ??
            chart.series[seriesIndex!];
    final ChartPoint<dynamic> point = pointIndex == null
        ? stateProperties.renderingDetails.currentActive?.point
        : stateProperties
            .chartSeries.visibleSeriesRenderers[0].dataPoints[pointIndex];
    if (point.isVisible) {
      final Offset? location = degreeToPoint(point.midAngle!,
          (point.innerRadius! + point.outerRadius!) / 2, point.center!);
      if (location != null && (chartSeries.enableTooltip)) {
        tooltipRenderingDetails.showLocation = location;
        tooltipRenderingDetails.chartTooltipState!.boundaryRect =
            tooltipRenderingDetails.tooltipBounds =
                stateProperties.renderingDetails.chartContainerRect;
        tooltipRenderingDetails.tooltipTemplate = chart
                .tooltipBehavior.builder!(
            chartSeries.dataSource![pointIndex ??
                stateProperties.renderingDetails.currentActive!.pointIndex!],
            point,
            chartSeries,
            seriesIndex ??
                stateProperties.renderingDetails.currentActive!.seriesIndex!,
            pointIndex ??
                stateProperties.renderingDetails.currentActive!.pointIndex!);
        if (tooltipRenderingDetails.isHovering) {
          // assigning values for previous and current tooltip values when the mouse is hovering
          tooltipRenderingDetails.prevTooltipValue =
              tooltipRenderingDetails.currentTooltipValue;
          tooltipRenderingDetails.currentTooltipValue = TooltipValue(
              seriesIndex ??
                  stateProperties.renderingDetails.currentActive!.seriesIndex!,
              pointIndex ??
                  stateProperties.renderingDetails.currentActive!.pointIndex!);
        }
        if (!tooltipRenderingDetails.isHovering) {
          tooltipRenderingDetails.hideTooltipTemplate();
        }
        tooltipRenderingDetails.show = true;
        tooltipRenderingDetails.performTooltip();
      }
    }
  }

  /// To initialize the chart widget.
  Widget _initializeChart(BoxConstraints constraints, BuildContext context) {
    _calculateContainerSize(constraints);
    if (chart.series.isNotEmpty) {
      stateProperties.chartSeries.calculateAngleAndCenterPositions(
          stateProperties.chartSeries.visibleSeriesRenderers[0]);
    }
    return Container(
        decoration: const BoxDecoration(color: Colors.transparent),
        child: _renderWidgets(constraints, context));
  }

  /// To calculate chart rect area size.
  void _calculateContainerSize(BoxConstraints constraints) {
    final num width = constraints.maxWidth;
    final num height = constraints.maxHeight;
    stateProperties.renderingDetails.chartContainerRect =
        Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());
    final EdgeInsets margin = chart.margin;
    stateProperties.renderingDetails.chartAreaRect = Rect.fromLTWH(
        margin.left,
        margin.top,
        width - margin.right - margin.left,
        height - margin.top - margin.bottom);
  }

  /// To render chart widgets.
  Widget _renderWidgets(BoxConstraints constraints, BuildContext context) {
    _bindSeriesWidgets(context);
    _findTemplates();
    _renderTemplates();
    _bindTooltipWidgets(constraints);
    stateProperties.circularArea = this;
    stateProperties.legendRefresh = false;
    renderBox = context.findRenderObject() as RenderBox;
    // ignore: avoid_unnecessary_containers
    return Container(
        child: Stack(
            textDirection: TextDirection.ltr,
            children: stateProperties.renderingDetails.chartWidgets!));
  }

  /// To add chart templates.
  void _findTemplates() {
    Offset labelLocation;
    const num lineLength = 10;
    ChartPoint<dynamic> point;
    Widget labelWidget;
    stateProperties.renderingDetails.templates = <ChartTemplateInfo>[];
    stateProperties.renderingDetails.dataLabelTemplateRegions = <Rect>[];
    stateProperties.annotationRegions = <Rect>[];
    CircularSeriesRendererExtension seriesRenderer;
    CircularSeries<dynamic, dynamic> series;
    ConnectorLineSettings connector;
    ChartAlignment labelAlign;
    num connectorLength;
    for (int k = 0;
        k < stateProperties.chartSeries.visibleSeriesRenderers.length;
        k++) {
      seriesRenderer = stateProperties.chartSeries.visibleSeriesRenderers[k];
      series = seriesRenderer.series;
      connector = series.dataLabelSettings.connectorLineSettings;
      if (series.dataLabelSettings.isVisible &&
          series.dataLabelSettings.builder != null) {
        for (int i = 0; i < seriesRenderer.renderPoints!.length; i++) {
          point = seriesRenderer.renderPoints![i];
          if (point.isVisible) {
            labelWidget = series.dataLabelSettings.builder!(
                series.dataSource![i], point, series, i, k);
            if (series.dataLabelSettings.labelPosition ==
                    ChartDataLabelPosition.inside ||
                seriesRenderer.seriesType == 'radialbar') {
              labelLocation = degreeToPoint(
                  seriesRenderer.seriesType == 'radialbar'
                      ? point.startAngle!
                      : point.midAngle!,
                  (point.innerRadius! + point.outerRadius!) / 2,
                  point.center!);
              labelLocation = Offset(labelLocation.dx, labelLocation.dy);
              labelAlign = ChartAlignment.center;
            } else {
              connectorLength = percentToValue(
                  connector.length ?? '10%', point.outerRadius!)!;
              labelLocation = degreeToPoint(point.midAngle!,
                  point.outerRadius! + connectorLength, point.center!);
              labelLocation = Offset(
                  point.dataLabelPosition == Position.right
                      ? labelLocation.dx + lineLength + 5
                      : labelLocation.dx - lineLength - 5,
                  labelLocation.dy);
              labelAlign = point.dataLabelPosition == Position.left
                  ? ChartAlignment.far
                  : ChartAlignment.near;
            }
            stateProperties.renderingDetails.templates.add(ChartTemplateInfo(
                key: GlobalKey(),
                templateType: 'DataLabel',
                pointIndex: i,
                seriesIndex: k,
                clipRect: stateProperties.renderingDetails.chartAreaRect,
                animationDuration: 500,
                widget: labelWidget,
                horizontalAlignment: labelAlign,
                verticalAlignment: ChartAlignment.center,
                location: labelLocation));
          }
        }
      }
    }

    _setTemplateInfo();
  }

  /// Method to set the template info.
  void _setTemplateInfo() {
    CircularChartAnnotation annotation;
    double radius, annotationHeight, annotationWidth;
    ChartTemplateInfo templateInfo;
    Offset point;
    if (chart.annotations != null && chart.annotations!.isNotEmpty) {
      for (int i = 0; i < chart.annotations!.length; i++) {
        annotation = chart.annotations![i];
        if (annotation.widget != null) {
          radius = percentToValue(
                  annotation.radius, stateProperties.chartSeries.size / 2)!
              .toDouble();
          point = degreeToPoint(
              annotation.angle, radius, stateProperties.centerLocation);
          annotationHeight = percentToValue(
                  annotation.height, stateProperties.chartSeries.size / 2)!
              .toDouble();
          annotationWidth = percentToValue(
                  annotation.width, stateProperties.chartSeries.size / 2)!
              .toDouble();
          templateInfo = ChartTemplateInfo(
              key: GlobalKey(),
              templateType: 'Annotation',
              horizontalAlignment: annotation.horizontalAlignment,
              verticalAlignment: annotation.verticalAlignment,
              clipRect: stateProperties.renderingDetails.chartContainerRect,
              widget: annotationHeight > 0 && annotationWidth > 0
                  ? SizedBox(
                      height: annotationHeight,
                      width: annotationWidth,
                      child: annotation.widget)
                  : annotation.widget!,
              pointIndex: i,
              animationDuration: 500,
              location: point);
          stateProperties.renderingDetails.templates.add(templateInfo);
        }
      }
    }
  }

  /// To render chart templates.
  void _renderTemplates() {
    if (stateProperties.renderingDetails.templates.isNotEmpty) {
      for (int i = 0;
          i < stateProperties.renderingDetails.templates.length;
          i++) {
        stateProperties.renderingDetails.templates[i].animationDuration =
            !stateProperties.renderingDetails.initialRender!
                ? 0
                : stateProperties
                    .renderingDetails.templates[i].animationDuration;
      }
      stateProperties.renderingDetails.chartTemplate = ChartTemplate(
          templates: stateProperties.renderingDetails.templates,
          render: stateProperties.renderingDetails.animateCompleted,
          stateProperties: stateProperties);
      stateProperties.renderingDetails.chartWidgets!
          .add(stateProperties.renderingDetails.chartTemplate!);
    }
  }

  /// To add tooltip widgets to chart.
  void _bindTooltipWidgets(BoxConstraints constraints) {
    TooltipHelper.setStateProperties(chart.tooltipBehavior, stateProperties);
    final SfChartThemeData chartTheme =
        stateProperties.renderingDetails.chartTheme;
    const int seriesIndex = 0;
    final DataLabelSettings dataLabel = stateProperties.chartSeries
        .visibleSeriesRenderers[seriesIndex].series.dataLabelSettings;
    if (chart.tooltipBehavior.enable ||
        dataLabel.labelIntersectAction == LabelIntersectAction.shift ||
        dataLabel.overflowMode == OverflowMode.trim) {
      final TooltipBehavior tooltip = chart.tooltipBehavior;
      final TooltipRenderingDetails tooltipRenderingDetails =
          TooltipHelper.getRenderingDetails(
              stateProperties.renderingDetails.tooltipBehaviorRenderer);
      tooltipRenderingDetails.prevTooltipValue =
          tooltipRenderingDetails.currentTooltipValue = null;
      tooltipRenderingDetails.chartTooltip = SfTooltip(
          color: tooltip.color ?? chartTheme.tooltipColor,
          key: GlobalKey(),
          textStyle: chartTheme.tooltipTextStyle!,
          animationDuration: tooltip.animationDuration,
          animationCurve: const Interval(0.1, 0.8, curve: Curves.easeOutBack),
          enable: tooltip.enable,
          opacity: tooltip.opacity,
          borderColor: tooltip.borderColor,
          borderWidth: tooltip.borderWidth,
          duration: tooltip.duration.toInt(),
          shouldAlwaysShow: tooltip.shouldAlwaysShow,
          elevation: tooltip.elevation,
          canShowMarker: tooltip.canShowMarker,
          textAlignment: tooltip.textAlignment,
          decimalPlaces: tooltip.decimalPlaces,
          labelColor: tooltip.textStyle?.color ?? chartTheme.tooltipLabelColor,
          header: tooltip.header,
          format: tooltip.format,
          shadowColor: tooltip.shadowColor,
          onTooltipRender: chart.onTooltipRender != null
              ? tooltipRenderingDetails.tooltipRenderingEvent
              : null);
      final Widget uiWidget = IgnorePointer(
          child:
              Stack(children: <Widget>[tooltipRenderingDetails.chartTooltip!]));
      stateProperties.renderingDetails.chartWidgets!.add(uiWidget);
    }
  }

  /// To add series widgets in chart.
  void _bindSeriesWidgets(BuildContext context) {
    late CustomPainter seriesPainter;
    Animation<double>? seriesAnimation;
    stateProperties.renderingDetails.animateCompleted = false;
    stateProperties.renderingDetails.chartWidgets ??= <Widget>[];
    CircularSeries<dynamic, dynamic> series;
    CircularSeriesRendererExtension seriesRenderer;
    dynamic selectionBehavior;
    SelectionBehaviorRenderer selectionBehaviorRenderer;
    for (int i = 0;
        i < stateProperties.chartSeries.visibleSeriesRenderers.length;
        i++) {
      seriesRenderer = stateProperties.chartSeries.visibleSeriesRenderers[i];
      series = seriesRenderer.series;
      selectionBehavior =
          seriesRenderer.selectionBehavior = series.selectionBehavior;
      selectionBehaviorRenderer = seriesRenderer.selectionBehaviorRenderer =
          SelectionBehaviorRenderer(selectionBehavior, chart, stateProperties);
      SelectionHelper.setSelectionBehaviorRenderer(
          series.selectionBehavior, selectionBehaviorRenderer);
      final SelectionDetails selectionDetails =
          SelectionHelper.getRenderingDetails(selectionBehaviorRenderer);
      selectionDetails.selectionRenderer ??= SelectionRenderer();
      selectionDetails.selectionRenderer!.chart = chart;
      selectionDetails.selectionRenderer!.stateProperties = stateProperties;
      selectionDetails.selectionRenderer!.seriesRendererDetails =
          seriesRenderer;
      if (series.initialSelectedDataIndexes.isNotEmpty &&
          stateProperties.renderingDetails.initialRender!) {
        for (int index = 0;
            index < series.initialSelectedDataIndexes.length;
            index++) {
          stateProperties.renderingDetails.selectionData
              .add(series.initialSelectedDataIndexes[index]);
        }
      }
      stateProperties.renderingDetails.animateCompleted = false;
      if (series.animationDuration > 0 &&
          !stateProperties.renderingDetails.didSizeChange &&
          (stateProperties.renderingDetails.oldDeviceOrientation ==
              stateProperties.renderingDetails.deviceOrientation) &&
          ((stateProperties.renderingDetails.initialRender! ||
                  (stateProperties.renderingDetails.widgetNeedUpdate &&
                      seriesRenderer.needsAnimation) ||
                  stateProperties.renderingDetails.isLegendToggled) ||
              stateProperties.legendRefresh)) {
        final int totalAnimationDuration =
            series.animationDuration.toInt() + series.animationDelay.toInt();
        stateProperties.renderingDetails.animationController.duration =
            Duration(milliseconds: totalAnimationDuration);
        const double maxSeriesInterval = 0.8;
        double minSeriesInterval = 0.1;
        minSeriesInterval = series.animationDelay.toInt() /
                totalAnimationDuration *
                (maxSeriesInterval - minSeriesInterval) +
            minSeriesInterval;
        seriesAnimation =
            Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: stateProperties.renderingDetails.animationController,
          curve: Interval(minSeriesInterval, maxSeriesInterval),
        )..addStatusListener((AnimationStatus status) {
                if (status == AnimationStatus.completed) {
                  stateProperties.renderingDetails.animateCompleted = true;
                  if (stateProperties.renderDataLabel != null) {
                    stateProperties.renderDataLabel!.state.render();
                  }
                  if (stateProperties.renderingDetails.chartTemplate != null) {
                    stateProperties.renderingDetails.chartTemplate!.state
                        .templateRender();
                  }
                }
              }));
        stateProperties.renderingDetails.chartElementAnimation =
            Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: stateProperties.renderingDetails.animationController,
          curve: const Interval(0.85, 1.0, curve: Curves.decelerate),
        ));
        stateProperties.renderingDetails.animationController.forward(from: 0.0);
      } else {
        stateProperties.renderingDetails.animateCompleted = true;
      }
      seriesRenderer.repaintNotifier =
          stateProperties.renderingDetails.seriesRepaintNotifier;
      if (seriesRenderer.seriesType == 'pie') {
        if (chart.onCreateShader != null) {
          stateProperties.renderingDetails.seriesRepaintNotifier.value++;
        }
        seriesPainter = PieChartPainter(
            stateProperties: stateProperties,
            index: i,
            isRepaint: seriesRenderer.needsRepaint,
            animationController:
                stateProperties.renderingDetails.animationController,
            seriesAnimation: seriesAnimation,
            notifier: stateProperties.renderingDetails.seriesRepaintNotifier);
      } else if (seriesRenderer.seriesType == 'doughnut') {
        if (chart.onCreateShader != null) {
          stateProperties.renderingDetails.seriesRepaintNotifier.value++;
        }
        seriesPainter = DoughnutChartPainter(
            stateProperties: stateProperties,
            index: i,
            isRepaint: seriesRenderer.needsRepaint,
            animationController:
                stateProperties.renderingDetails.animationController,
            seriesAnimation: seriesAnimation,
            notifier: stateProperties.renderingDetails.seriesRepaintNotifier);
      } else if (seriesRenderer.seriesType == 'radialbar') {
        seriesPainter = RadialBarPainter(
            stateProperties: stateProperties,
            index: i,
            isRepaint: seriesRenderer.needsRepaint,
            animationController:
                stateProperties.renderingDetails.animationController,
            seriesAnimation: seriesAnimation,
            notifier: stateProperties.renderingDetails.seriesRepaintNotifier);
      }
      stateProperties.renderingDetails.chartWidgets!
          .add(RepaintBoundary(child: CustomPaint(painter: seriesPainter)));
      stateProperties.renderDataLabel = CircularDataLabelRenderer(
          stateProperties: stateProperties,
          show: stateProperties.renderingDetails.animateCompleted);
      stateProperties.renderingDetails.chartWidgets!
          .add(stateProperties.renderDataLabel!);
    }
  }
}

/// Show tooltip for trimmed data label.
void _showTrimmedDataLabelTooltip(
    Offset position,
    CircularStateProperties stateProperties,
    CircularSeriesRendererExtension seriesRenderer) {
  stateProperties.requireDataLabelTooltip =
      (stateProperties.requireDataLabelTooltip == null &&
              !stateProperties.isTooltipHidden)
          ? stateProperties.requireDataLabelTooltip
          : false;
  for (int i = 0; i < seriesRenderer.renderPoints!.length; i++) {
    if (seriesRenderer.series.dataLabelSettings.isVisible &&
        seriesRenderer.renderPoints![i].labelRect
            .contains(Offset(position.dx, position.dy)) &&
        seriesRenderer.renderPoints![i].trimmedText != null &&
        seriesRenderer.renderPoints![i].trimmedText!.contains('...')) {
      stateProperties.requireDataLabelTooltip = true;
      stateProperties.renderingDetails.tooltipBehaviorRenderer
          .onTouchUp(position.dx.toDouble(), position.dy.toDouble());
    }
  }
}
