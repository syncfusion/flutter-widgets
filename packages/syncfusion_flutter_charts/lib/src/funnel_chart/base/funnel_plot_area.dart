import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_core/tooltip_internal.dart';

import '../../chart/user_interaction/selection_renderer.dart';
import '../../chart/utils/enum.dart';
import '../../circular_chart/renderer/common.dart';
import '../../common/event_args.dart';
import '../../common/user_interaction/selection_behavior.dart';
import '../../common/user_interaction/tooltip.dart';
import '../../common/user_interaction/tooltip_rendering_details.dart';
import '../../common/utils/helper.dart';
import '../../pyramid_chart/utils/common.dart';
import '../../pyramid_chart/utils/helper.dart';
import '../base/funnel_base.dart';
import '../base/funnel_state_properties.dart';
import '../renderer/data_label_renderer.dart';
import '../renderer/funnel_chart_painter.dart';
import '../renderer/funnel_series.dart';
import '../renderer/renderer_extension.dart';

/// Represents the funnel plot area.
// ignore: must_be_immutable
class FunnelPlotArea extends StatelessWidget {
  /// Creates an instance of funnel plot area.
  // ignore: prefer_const_constructors_in_immutables
  FunnelPlotArea({required this.stateProperties});

  /// Specifies the value of funnel state properties.
  final FunnelStateProperties stateProperties;

  /// Gets the chart widget from the stateProperties.
  SfFunnelChart get chart => stateProperties.chart;

  /// Specifies the value of funnel series renderer.
  late FunnelSeriesRendererExtension seriesRenderer;

  /// Holds the render box value.
  late RenderBox renderBox;

  /// Holds the value of point region.
  Region? pointRegion;

  /// Holds the value of tap down details.
  late TapDownDetails tapDownDetails;

  /// Specifies the double tap position.
  Offset? doubleTapPosition;
  final bool _enableMouseHover = kIsWeb;

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
                TooltipHelper.getRenderingDetails(stateProperties
                        .renderingDetails.tooltipBehaviorRenderer)
                    .isHovering = false;
              },
              child: Stack(textDirection: TextDirection.ltr, children: <Widget>[
                _initializeChart(constraints, context),
                Listener(
                    onPointerUp: (PointerUpEvent event) => _onTapUp(event),
                    onPointerDown: (PointerDownEvent event) =>
                        _onTapDown(event),
                    onPointerMove: (PointerMoveEvent event) =>
                        _performPointerMove(event),
                    child: GestureDetector(
                        onLongPress: _onLongPress,
                        onDoubleTap: _onDoubleTap,
                        onTapUp: (TapUpDetails details) {
                          stateProperties.renderingDetails.tapPosition =
                              renderBox.globalToLocal(details.globalPosition);
                          if (chart.series.onPointTap != null &&
                              // ignore: unnecessary_null_comparison
                              seriesRenderer != null) {
                            calculatePointSeriesIndex(
                                chart,
                                seriesRenderer,
                                stateProperties.renderingDetails.tapPosition!,
                                null,
                                ActivationMode.singleTap);
                          }
                        },
                        child: Container(
                          decoration:
                              const BoxDecoration(color: Colors.transparent),
                        )))
              ])));
    });
  }

  /// To initialize chart elements.
  Widget _initializeChart(BoxConstraints constraints, BuildContext context) {
    _calculateContainerSize(constraints);
    return GestureDetector(
        child: Container(
            decoration: const BoxDecoration(color: Colors.transparent),
            child: _renderWidgets(constraints, context)));
  }

  /// To calculate size of chart.
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

  Widget _renderWidgets(BoxConstraints constraints, BuildContext context) {
    _bindSeriesWidgets();
    _calculatePathRegion();
    findTemplates(stateProperties);
    renderTemplates(stateProperties);
    _bindTooltipWidgets(constraints);
    renderBox = context.findRenderObject() as RenderBox;
    stateProperties.funnelplotArea = this;
    stateProperties.legendRefresh = false;
    // ignore: avoid_unnecessary_containers
    return Container(
        child: Stack(
            textDirection: TextDirection.ltr,
            children: stateProperties.renderingDetails.chartWidgets!));
  }

  /// To calculate region path for rendering funnel chart.
  void _calculatePathRegion() {
    if (stateProperties.chartSeries.visibleSeriesRenderers.isNotEmpty) {
      final FunnelSeriesRendererExtension seriesRenderer =
          stateProperties.chartSeries.visibleSeriesRenderers[0];
      for (int i = 0; i < seriesRenderer.renderPoints.length; i++) {
        if (seriesRenderer.renderPoints[i].isVisible) {
          stateProperties.chartSeries
              .calculateFunnelPathRegion(i, seriesRenderer);
        }
      }
    }
  }

  /// To bind series widgets in chart.
  void _bindSeriesWidgets() {
    CustomPainter seriesPainter;
    Animation<double>? seriesAnimation;
    FunnelSeries<dynamic, dynamic> series;
    SelectionBehaviorRenderer selectionBehaviorRenderer;
    dynamic selectionBehavior;
    for (int i = 0;
        i < stateProperties.chartSeries.visibleSeriesRenderers.length;
        i++) {
      seriesRenderer = stateProperties.chartSeries.visibleSeriesRenderers[i];
      series = seriesRenderer.series;
      stateProperties.chartSeries.initializeSeriesProperties(seriesRenderer);
      selectionBehavior =
          seriesRenderer.selectionBehavior = series.selectionBehavior;
      selectionBehaviorRenderer = seriesRenderer.selectionBehaviorRenderer =
          SelectionBehaviorRenderer(selectionBehavior, chart, stateProperties);
      SelectionHelper.setSelectionBehaviorRenderer(
          series.selectionBehavior, selectionBehaviorRenderer);
      final SelectionDetails selectionDetails =
          SelectionHelper.getRenderingDetails(selectionBehaviorRenderer);
      selectionDetails.selectionRenderer ??= SelectionRenderer();
      selectionDetails.selectionRenderer?.chart = chart;
      selectionDetails.selectionRenderer!.stateProperties = stateProperties;
      selectionDetails.selectionRenderer?.seriesRendererDetails =
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

      if (series.animationDuration > 0 &&
          !stateProperties.renderingDetails.didSizeChange &&
          (stateProperties.renderingDetails.oldDeviceOrientation ==
              stateProperties.renderingDetails.deviceOrientation) &&
          (((!stateProperties.renderingDetails.widgetNeedUpdate &&
                      stateProperties.renderingDetails.initialRender!) ||
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
                  stateProperties.renderingDetails.initialRender = false;
                  if (stateProperties.renderDataLabel != null) {
                    stateProperties.renderDataLabel!.state!.render();
                  }
                  if (stateProperties.renderingDetails.chartTemplate != null &&
                      // ignore: unnecessary_null_comparison
                      stateProperties.renderingDetails.chartTemplate!.state !=
                          null) {
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
        stateProperties.renderingDetails.initialRender = false;
        if (stateProperties.renderDataLabel?.state != null) {
          stateProperties.renderDataLabel?.state!.render();
        }
      }
      seriesRenderer.repaintNotifier =
          stateProperties.renderingDetails.seriesRepaintNotifier;
      seriesPainter = FunnelChartPainter(
          stateProperties: stateProperties,
          seriesIndex: i,
          isRepaint: seriesRenderer.needsRepaint,
          animationController:
              stateProperties.renderingDetails.animationController,
          seriesAnimation: seriesAnimation,
          notifier: stateProperties.renderingDetails.seriesRepaintNotifier);
      stateProperties.renderingDetails.chartWidgets!
          .add(RepaintBoundary(child: CustomPaint(painter: seriesPainter)));
      stateProperties.renderDataLabel = FunnelDataLabelRenderer(
          key: GlobalKey(),
          stateProperties: stateProperties,
          //ignore: avoid_bool_literals_in_conditional_expressions
          show: stateProperties.renderingDetails.animateCompleted);
      stateProperties.renderingDetails.chartWidgets!
          .add(stateProperties.renderDataLabel!);
    }
  }

  /// To bind tooltip widgets to chart.
  void _bindTooltipWidgets(BoxConstraints constraints) {
    TooltipHelper.setStateProperties(chart.tooltipBehavior, stateProperties);
    final SfChartThemeData chartTheme =
        stateProperties.renderingDetails.chartTheme;
    final TooltipBehavior tooltip = chart.tooltipBehavior;
    final TooltipRenderingDetails tooltipRenderingDetails =
        TooltipHelper.getRenderingDetails(
            stateProperties.renderingDetails.tooltipBehaviorRenderer);
    if (chart.tooltipBehavior.enable) {
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
      stateProperties.renderingDetails.chartWidgets!
          .add(tooltipRenderingDetails.chartTooltip!);
    }
  }

  /// To perform pointer down event.
  void _onTapDown(PointerDownEvent event) {
    // renderBox = context.findRenderObject();
    final TooltipRenderingDetails tooltipRenderingDetails =
        TooltipHelper.getRenderingDetails(
            stateProperties.renderingDetails.tooltipBehaviorRenderer);
    tooltipRenderingDetails.isHovering = false;
    stateProperties.renderingDetails.currentActive = null;
    stateProperties.renderingDetails.tapPosition =
        renderBox.globalToLocal(event.position);
    bool isPoint = false;
    const int seriesIndex = 0;
    int? pointIndex;
    final FunnelSeriesRendererExtension seriesRenderer =
        stateProperties.chartSeries.visibleSeriesRenderers[seriesIndex];
    ChartTouchInteractionArgs touchArgs;
    for (int j = 0; j < seriesRenderer.renderPoints.length; j++) {
      if (chart.onDataLabelRender != null) {
        seriesRenderer.dataPoints[j].labelRenderEvent = false;
      }
      if (seriesRenderer.renderPoints[j].isVisible && !isPoint) {
        isPoint = isPointInPolygon(seriesRenderer.renderPoints[j].pathRegion,
            stateProperties.renderingDetails.tapPosition!);
        if (isPoint) {
          pointIndex = j;
          if (chart.onDataLabelRender == null) {
            break;
          }
        }
      }
    }
    doubleTapPosition = stateProperties.renderingDetails.tapPosition!;
    // ignore: unnecessary_null_comparison
    if (stateProperties.renderingDetails.tapPosition != null && isPoint) {
      stateProperties.renderingDetails.currentActive = ChartInteraction(
        seriesIndex,
        pointIndex!,
        seriesRenderer.series,
        seriesRenderer.renderPoints[pointIndex],
      );
    } else {
      //hides the tooltip if the point of interaction is outside funnel region of the chart
      if (chart.tooltipBehavior.builder != null) {
        tooltipRenderingDetails.show = false;
        tooltipRenderingDetails.hideTooltipTemplate();
      }
    }
    if (chart.onChartTouchInteractionDown != null) {
      touchArgs = ChartTouchInteractionArgs();
      touchArgs.position = renderBox.globalToLocal(event.position);
      chart.onChartTouchInteractionDown!(touchArgs);
    }
  }

  /// To perform pointer move event.
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
    const int seriesIndex = 0;
    if (doubleTapPosition != null &&
        stateProperties.renderingDetails.currentActive != null) {
      if (chart.series.onPointDoubleTap != null &&
          // ignore: unnecessary_null_comparison
          seriesRenderer != null) {
        calculatePointSeriesIndex(
            chart,
            seriesRenderer,
            stateProperties.renderingDetails.tapPosition!,
            null,
            ActivationMode.doubleTap);
        stateProperties.renderingDetails.tapPosition = null;
      }
      final int? pointIndex =
          stateProperties.renderingDetails.currentActive!.pointIndex;
      stateProperties.renderingDetails.currentActive = ChartInteraction(
          seriesIndex,
          pointIndex,
          stateProperties
              .chartSeries.visibleSeriesRenderers[seriesIndex].series,
          stateProperties.chartSeries.visibleSeriesRenderers[seriesIndex]
              .renderPoints[pointIndex!]);
      if (stateProperties.renderingDetails.currentActive != null) {
        if (stateProperties
                .renderingDetails.currentActive!.series.explodeGesture ==
            ActivationMode.doubleTap) {
          stateProperties.chartSeries.pointExplode(pointIndex);
          final GlobalKey key =
              stateProperties.renderDataLabel!.key as GlobalKey;
          final FunnelDataLabelRendererState funnelDataLabelRendererState =
              key.currentState as FunnelDataLabelRendererState;
          funnelDataLabelRendererState.dataLabelRepaintNotifier.value++;
        }
      }
      stateProperties.chartSeries
          .seriesPointSelection(pointIndex, ActivationMode.doubleTap);
      if (chart.tooltipBehavior.enable &&
          stateProperties.renderingDetails.animateCompleted &&
          chart.tooltipBehavior.activationMode == ActivationMode.doubleTap) {
        if (chart.tooltipBehavior.builder != null) {
          showFunnelTooltipTemplate();
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
    const int seriesIndex = 0;
    if (stateProperties.renderingDetails.tapPosition != null &&
        stateProperties.renderingDetails.currentActive != null) {
      if (chart.series.onPointLongPress != null &&
          // ignore: unnecessary_null_comparison
          seriesRenderer != null) {
        calculatePointSeriesIndex(
            chart,
            seriesRenderer,
            stateProperties.renderingDetails.tapPosition!,
            null,
            ActivationMode.longPress);
        stateProperties.renderingDetails.tapPosition = null;
      }
      final int pointIndex =
          stateProperties.renderingDetails.currentActive!.pointIndex!;
      stateProperties.renderingDetails.currentActive = ChartInteraction(
          seriesIndex,
          pointIndex,
          stateProperties
              .chartSeries.visibleSeriesRenderers[seriesIndex].series,
          stateProperties.chartSeries.visibleSeriesRenderers[seriesIndex]
              .renderPoints[pointIndex],
          pointRegion);
      stateProperties.chartSeries
          .seriesPointSelection(pointIndex, ActivationMode.longPress);
      if (stateProperties.renderingDetails.currentActive != null) {
        if (stateProperties
                .renderingDetails.currentActive!.series.explodeGesture ==
            ActivationMode.longPress) {
          stateProperties.chartSeries.pointExplode(pointIndex);
          final GlobalKey key =
              stateProperties.renderDataLabel!.key as GlobalKey;
          final FunnelDataLabelRendererState funnelDataLabelRendererState =
              key.currentState as FunnelDataLabelRendererState;
          funnelDataLabelRendererState.dataLabelRepaintNotifier.value++;
        }
      }
      if (chart.tooltipBehavior.enable &&
          stateProperties.renderingDetails.animateCompleted &&
          chart.tooltipBehavior.activationMode == ActivationMode.longPress) {
        if (chart.tooltipBehavior.builder != null) {
          showFunnelTooltipTemplate();
        } else {
          stateProperties.renderingDetails.tooltipBehaviorRenderer.onLongPress(
              stateProperties.renderingDetails.tapPosition!.dx.toDouble(),
              stateProperties.renderingDetails.tapPosition!.dy.toDouble());
        }
      }
    }
  }

  /// To perform pointer up event.
  void _onTapUp(PointerUpEvent event) {
    TooltipHelper.getRenderingDetails(
            stateProperties.renderingDetails.tooltipBehaviorRenderer)
        .isHovering = false;
    stateProperties.renderingDetails.tapPosition =
        renderBox.globalToLocal(event.position);
    ChartTouchInteractionArgs touchArgs;
    // ignore: unnecessary_null_comparison
    if (chart.onDataLabelTapped != null && seriesRenderer != null) {
      triggerFunnelDataLabelEvent(
          chart,
          seriesRenderer,
          stateProperties.chartState,
          stateProperties.renderingDetails.tapPosition!);
    }
    if (stateProperties.renderingDetails.tapPosition != null) {
      if (stateProperties.renderingDetails.currentActive != null &&
          stateProperties.renderingDetails.currentActive!.series != null &&
          stateProperties
                  .renderingDetails.currentActive!.series.explodeGesture ==
              ActivationMode.singleTap) {
        stateProperties.chartSeries.pointExplode(
            stateProperties.renderingDetails.currentActive!.pointIndex!);
        final GlobalKey key = stateProperties.renderDataLabel!.key as GlobalKey;
        final FunnelDataLabelRendererState funnelDataLabelRendererState =
            key.currentState as FunnelDataLabelRendererState;
        funnelDataLabelRendererState.dataLabelRepaintNotifier.value++;
      }
      if (stateProperties.renderingDetails.tapPosition != null &&
          stateProperties.renderingDetails.currentActive != null) {
        stateProperties.chartSeries.seriesPointSelection(
            stateProperties.renderingDetails.currentActive!.pointIndex!,
            ActivationMode.singleTap);
      }
      if (chart.tooltipBehavior.enable &&
          stateProperties.renderingDetails.animateCompleted &&
          chart.tooltipBehavior.activationMode == ActivationMode.singleTap &&
          stateProperties.renderingDetails.currentActive != null &&
          stateProperties.renderingDetails.currentActive!.series != null) {
        if (chart.tooltipBehavior.builder != null) {
          showFunnelTooltipTemplate();
        } else {
          final Offset position = renderBox.globalToLocal(event.position);
          stateProperties.renderingDetails.tooltipBehaviorRenderer
              // ignore: noop_primitive_operations
              .onTouchUp(position.dx.toDouble(), position.dy.toDouble());
        }
      }
      if (chart.onChartTouchInteractionUp != null) {
        touchArgs = ChartTouchInteractionArgs();
        touchArgs.position = renderBox.globalToLocal(event.position);
        chart.onChartTouchInteractionUp!(touchArgs);
      }
    }
    if (chart.series.onPointTap == null &&
        chart.series.onPointDoubleTap == null &&
        chart.series.onPointLongPress == null) {
      stateProperties.renderingDetails.tapPosition = null;
    }
  }

  /// To perform event on mouse hover.
  void _onHover(PointerEvent event) {
    final TooltipRenderingDetails tooltipRenderingDetails =
        TooltipHelper.getRenderingDetails(
            stateProperties.renderingDetails.tooltipBehaviorRenderer);
    stateProperties.renderingDetails.currentActive = null;
    stateProperties.renderingDetails.tapPosition =
        renderBox.globalToLocal(event.position);
    bool? isPoint;
    const int seriesIndex = 0;
    int? pointIndex;
    final FunnelSeriesRendererExtension seriesRenderer =
        stateProperties.chartSeries.visibleSeriesRenderers[seriesIndex];
    for (int j = 0; j < seriesRenderer.renderPoints.length; j++) {
      if (seriesRenderer.renderPoints[j].isVisible) {
        isPoint = isPointInPolygon(seriesRenderer.renderPoints[j].pathRegion,
            stateProperties.renderingDetails.tapPosition!);
        if (isPoint) {
          pointIndex = j;
          break;
        }
      }
    }
    if (stateProperties.renderingDetails.tapPosition != null && isPoint!) {
      stateProperties.renderingDetails.currentActive = ChartInteraction(
        seriesIndex,
        pointIndex!,
        stateProperties.chartSeries.visibleSeriesRenderers[seriesIndex].series,
        stateProperties.chartSeries.visibleSeriesRenderers[seriesIndex]
            .renderPoints[pointIndex],
      );
    } else {
      //hides the tooltip if the point of interaction is outside funnel region of the chart
      tooltipRenderingDetails.hide();
    }
    if (stateProperties.renderingDetails.tapPosition != null) {
      if (chart.tooltipBehavior.enable &&
          stateProperties.renderingDetails.animateCompleted &&
          stateProperties.renderingDetails.currentActive != null &&
          stateProperties.renderingDetails.currentActive!.series != null) {
        tooltipRenderingDetails.isHovering = true;
        if (chart.tooltipBehavior.builder != null) {
          showFunnelTooltipTemplate();
        } else {
          final Offset position = renderBox.globalToLocal(event.position);
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
  void showFunnelTooltipTemplate([int? pointIndex]) {
    stateProperties.isTooltipHidden = false;
    final TooltipRenderingDetails tooltipRenderingDetails =
        TooltipHelper.getRenderingDetails(
            stateProperties.renderingDetails.tooltipBehaviorRenderer);
    if (tooltipRenderingDetails.isHovering == false) {
      //assigning null for the previous and current tooltip values in case of touch interaction
      tooltipRenderingDetails.prevTooltipValue = null;
      tooltipRenderingDetails.currentTooltipValue = null;
    }
    final FunnelSeries<dynamic, dynamic> chartSeries =
        stateProperties.renderingDetails.currentActive?.series ?? chart.series;
    final PointInfo<dynamic> point = pointIndex == null
        ? stateProperties.renderingDetails.currentActive?.point
        : stateProperties
            .chartSeries.visibleSeriesRenderers[0].dataPoints[pointIndex];
    final Offset location =
        chart.tooltipBehavior.tooltipPosition == TooltipPosition.pointer &&
                !stateProperties
                    .chartSeries.visibleSeriesRenderers[0].series.explode
            ? stateProperties.renderingDetails.tapPosition!
            : point.symbolLocation;
    bool isPoint = false;
    for (int j = 0; j < seriesRenderer.renderPoints.length; j++) {
      if (seriesRenderer.renderPoints[j].isVisible) {
        isPoint = isPointInPolygon(
            seriesRenderer.renderPoints[j].pathRegion, location);
        if (isPoint) {
          pointIndex = j;
          break;
        }
      }
    }
    // ignore: unnecessary_null_comparison
    if (location != null && isPoint && (chartSeries.enableTooltip)) {
      tooltipRenderingDetails.showLocation = location;
      tooltipRenderingDetails.chartTooltipState!.boundaryRect =
          tooltipRenderingDetails.tooltipBounds =
              stateProperties.renderingDetails.chartContainerRect;
      // tooltipTemplate.rect = Rect.fromLTWH(location.dx, location.dy, 0, 0);
      tooltipRenderingDetails.tooltipTemplate = chart.tooltipBehavior.builder!(
          chartSeries.dataSource![pointIndex ??
              stateProperties.renderingDetails.currentActive!.pointIndex!],
          point,
          chartSeries,
          0,
          pointIndex ??
              stateProperties.renderingDetails.currentActive!.pointIndex!);
      if (tooltipRenderingDetails.isHovering == true) {
        //assigning values for the previous and current tooltip values on mouse hover
        tooltipRenderingDetails.prevTooltipValue =
            tooltipRenderingDetails.currentTooltipValue;
        tooltipRenderingDetails.currentTooltipValue = TooltipValue(
            0,
            pointIndex ??
                stateProperties.renderingDetails.currentActive!.pointIndex!);
      } else {
        tooltipRenderingDetails.hideTooltipTemplate();
      }
      tooltipRenderingDetails.show = true;
      tooltipRenderingDetails.performTooltip();
    }
  }
}
