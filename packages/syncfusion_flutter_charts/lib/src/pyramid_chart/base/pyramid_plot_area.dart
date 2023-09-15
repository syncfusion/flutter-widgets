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
import '../renderer/data_label_renderer.dart';
import '../renderer/pyramid_chart_painter.dart';
import '../renderer/pyramid_series.dart';
import '../renderer/renderer_extension.dart';
import 'pyramid_base.dart';
import 'pyramid_state_properties.dart';

/// Represents the pyramid plot areas.
// ignore: must_be_immutable
class PyramidPlotArea extends StatelessWidget {
  /// Creates an instance of a pyramid plot area.
  // ignore: prefer_const_constructors_in_immutables
  PyramidPlotArea({required this.stateProperties});

  /// Creates the pyramid state properties.
  final PyramidStateProperties stateProperties;

  /// Here, we are using get keyword in order to get the proper & updated instance of chart widget.
  /// When we initialize chart widget as a property to other classes like ChartSeries, the chart widget is not updated properly and by using get we can rectify this.
  SfPyramidChart get chart => stateProperties.chart;

  /// Represents the pyramid series renderer.
  late PyramidSeriesRendererExtension seriesRenderer;

  /// Represents the value of the render box.
  late RenderBox renderBox;

  /// Represents the value of the point region.
  Region? pointRegion;

  /// Represents the value of tap down details.
  late TapDownDetails tapDownDetails;

  /// Represents the series animation.
  Animation<double>? seriesAnimation;

  /// Represents the value of double tap position.
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
                  onPointerDown: (PointerDownEvent event) => _onTapDown(event),
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
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                        decoration:
                            const BoxDecoration(color: Colors.transparent),
                      )),
                ),
              ])));
    });
  }

  /// To initialize the chart.
  Widget _initializeChart(BoxConstraints constraints, BuildContext context) {
    _calculateContainerSize(constraints);
    return GestureDetector(
        child: Container(
            decoration: const BoxDecoration(color: Colors.transparent),
            child: _renderWidgets(constraints, context)));
  }

  /// To calculate chart plot area.
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
    stateProperties.chartPlotArea = this;
    stateProperties.legendRefresh = false;
    // ignore: avoid_unnecessary_containers
    return Container(
        child: Stack(
            textDirection: TextDirection.ltr,
            children: stateProperties.renderingDetails.chartWidgets!));
  }

  /// To calculate region path of pyramid.
  void _calculatePathRegion() {
    final List<PyramidSeriesRendererExtension> visibleSeriesRenderers =
        stateProperties.chartSeries.visibleSeriesRenderers;
    if (visibleSeriesRenderers.isNotEmpty) {
      seriesRenderer = visibleSeriesRenderers[0];
      for (int i = 0; i < seriesRenderer.renderPoints!.length; i++) {
        if (seriesRenderer.renderPoints![i].isVisible) {
          stateProperties.chartSeries.calculatePathRegion(i, seriesRenderer);
        }
      }
    }
  }

  /// To bind series widget together.
  void _bindSeriesWidgets() {
    late CustomPainter seriesPainter;
    PyramidSeries<dynamic, dynamic> series;
    final List<PyramidSeriesRendererExtension> visibleSeriesRenderers =
        stateProperties.chartSeries.visibleSeriesRenderers;
    SelectionBehaviorRenderer selectionBehaviorRenderer;
    dynamic selectionBehavior;
    for (int i = 0; i < visibleSeriesRenderers.length; i++) {
      seriesRenderer = visibleSeriesRenderers[i];
      series = seriesRenderer.series;
      stateProperties.chartSeries.initializeSeriesProperties(seriesRenderer);
      selectionBehavior =
          seriesRenderer.selectionBehavior = series.selectionBehavior;
      selectionBehaviorRenderer = seriesRenderer.selectionBehaviorRenderer =
          SelectionBehaviorRenderer(selectionBehavior, chart, stateProperties);
      SelectionHelper.setSelectionBehaviorRenderer(
          series.selectionBehavior, selectionBehaviorRenderer);
      selectionBehaviorRenderer = seriesRenderer.selectionBehaviorRenderer;
      final SelectionDetails selectionDetails =
          SelectionHelper.getRenderingDetails(selectionBehaviorRenderer);
      selectionDetails.selectionRenderer ??= SelectionRenderer();
      selectionDetails.selectionRenderer!.chart = chart;
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
      if (series.animationDuration > 0 &&
          !stateProperties.renderingDetails.didSizeChange &&
          (stateProperties.renderingDetails.deviceOrientation ==
              stateProperties.renderingDetails.oldDeviceOrientation) &&
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
                    stateProperties.renderDataLabel!.state?.render();
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
        if (stateProperties.renderDataLabel != null) {
          stateProperties.renderDataLabel!.state?.render();
        }
      }
      seriesRenderer.repaintNotifier =
          stateProperties.renderingDetails.seriesRepaintNotifier;
      if (seriesRenderer.seriesType == 'pyramid') {
        seriesPainter = PyramidChartPainter(
            stateProperties: stateProperties,
            seriesIndex: i,
            isRepaint: seriesRenderer.needsRepaint,
            animationController:
                stateProperties.renderingDetails.animationController,
            seriesAnimation: seriesAnimation,
            notifier: stateProperties.renderingDetails.seriesRepaintNotifier);
      }
      stateProperties.renderingDetails.chartWidgets!
          .add(RepaintBoundary(child: CustomPaint(painter: seriesPainter)));
      stateProperties.renderDataLabel = PyramidDataLabelRenderer(
          key: GlobalKey(),
          stateProperties: stateProperties,
          //ignore: avoid_bool_literals_in_conditional_expressions
          show: stateProperties.renderingDetails.animateCompleted);
      stateProperties.renderingDetails.chartWidgets!
          .add(stateProperties.renderDataLabel!);
    }
  }

  /// To bind tooltip widgets.
  void _bindTooltipWidgets(BoxConstraints constraints) {
    final TooltipBehavior tooltip = chart.tooltipBehavior;
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        stateProperties.renderingDetails.tooltipBehaviorRenderer;
    TooltipHelper.setStateProperties(chart.tooltipBehavior, stateProperties);
    if (tooltip.enable) {
      final SfChartThemeData chartTheme =
          stateProperties.renderingDetails.chartTheme;
      final TooltipRenderingDetails tooltipRenderingDetails =
          TooltipHelper.getRenderingDetails(tooltipBehaviorRenderer);
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
    final TooltipRenderingDetails tooltipRenderingDetails =
        TooltipHelper.getRenderingDetails(
            stateProperties.renderingDetails.tooltipBehaviorRenderer);
    tooltipRenderingDetails.isHovering = false;
    //renderBox = context.findRenderObject();
    stateProperties.renderingDetails.currentActive = null;
    stateProperties.renderingDetails.tapPosition =
        renderBox.globalToLocal(event.position);
    bool isPoint = false;
    const int seriesIndex = 0;
    late int pointIndex;
    final List<PyramidSeriesRendererExtension> visibleSeriesRenderers =
        stateProperties.chartSeries.visibleSeriesRenderers;
    final PyramidSeriesRendererExtension seriesRenderer =
        visibleSeriesRenderers[seriesIndex];
    ChartTouchInteractionArgs touchArgs;
    for (int j = 0; j < seriesRenderer.renderPoints!.length; j++) {
      if (chart.onDataLabelRender != null) {
        seriesRenderer.dataPoints[j].labelRenderEvent = false;
      }
      if (seriesRenderer.renderPoints![j].isVisible && !isPoint) {
        isPoint = isPointInPolygon(seriesRenderer.renderPoints![j].pathRegion,
            stateProperties.renderingDetails.tapPosition!);
        if (isPoint) {
          pointIndex = j;
          if (chart.onDataLabelRender == null) {
            break;
          }
        }
      }
    }
    doubleTapPosition = stateProperties.renderingDetails.tapPosition;
    if (stateProperties.renderingDetails.tapPosition != null && isPoint) {
      stateProperties.renderingDetails.currentActive = ChartInteraction(
        seriesIndex,
        pointIndex,
        visibleSeriesRenderers[seriesIndex].series,
        visibleSeriesRenderers[seriesIndex].renderPoints![pointIndex],
      );
    } else {
      //hides the tooltip if the point of interaction is outside pyramid region of the chart
      tooltipRenderingDetails.show = false;
      tooltipRenderingDetails.hideTooltipTemplate();
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
      final int pointIndex =
          stateProperties.renderingDetails.currentActive!.pointIndex!;
      final List<PyramidSeriesRendererExtension> visibleSeriesRenderers =
          stateProperties.chartSeries.visibleSeriesRenderers;
      stateProperties.renderingDetails.currentActive = ChartInteraction(
          seriesIndex,
          pointIndex,
          visibleSeriesRenderers[seriesIndex].series,
          visibleSeriesRenderers[seriesIndex].renderPoints![pointIndex]);
      if (stateProperties.renderingDetails.currentActive != null) {
        if (stateProperties
                .renderingDetails.currentActive!.series.explodeGesture ==
            ActivationMode.doubleTap) {
          stateProperties.chartSeries.pointExplode(pointIndex);
          final GlobalKey key =
              stateProperties.renderDataLabel!.key as GlobalKey;
          final PyramidDataLabelRendererState pyramidDataLabelRendererState =
              key.currentState as PyramidDataLabelRendererState;
          pyramidDataLabelRendererState.dataLabelRepaintNotifier.value++;
        }
      }
      stateProperties.chartSeries
          .seriesPointSelection(pointIndex, ActivationMode.doubleTap);
      if (chart.tooltipBehavior.enable &&
          stateProperties.renderingDetails.animateCompleted &&
          chart.tooltipBehavior.activationMode == ActivationMode.doubleTap) {
        if (chart.tooltipBehavior.builder != null) {
          showPyramidTooltipTemplate();
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
      final List<PyramidSeriesRendererExtension> visibleSeriesRenderers =
          stateProperties.chartSeries.visibleSeriesRenderers;
      final int pointIndex =
          stateProperties.renderingDetails.currentActive!.pointIndex!;
      stateProperties.renderingDetails.currentActive = ChartInteraction(
          seriesIndex,
          pointIndex,
          visibleSeriesRenderers[seriesIndex].series,
          visibleSeriesRenderers[seriesIndex].renderPoints![pointIndex],
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
          final PyramidDataLabelRendererState pyramidDataLabelRendererState =
              key.currentState as PyramidDataLabelRendererState;
          pyramidDataLabelRendererState.dataLabelRepaintNotifier.value++;
        }
      }
      if (chart.tooltipBehavior.enable &&
          stateProperties.renderingDetails.animateCompleted &&
          chart.tooltipBehavior.activationMode == ActivationMode.longPress) {
        if (chart.tooltipBehavior.builder != null) {
          showPyramidTooltipTemplate();
        } else {
          stateProperties.renderingDetails.tooltipBehaviorRenderer.onLongPress(
              // ignore: noop_primitive_operations
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
    bool isPoint = false;
    stateProperties.renderingDetails.tapPosition =
        renderBox.globalToLocal(event.position);
    for (int j = 0; j < seriesRenderer.renderPoints!.length; j++) {
      if (seriesRenderer.renderPoints![j].isVisible) {
        isPoint = isPointInPolygon(seriesRenderer.renderPoints![j].pathRegion,
            stateProperties.renderingDetails.tapPosition!);
        if (isPoint) {
          break;
        }
      }
    }
    final ChartInteraction? currentActive = isPoint
        ? stateProperties.renderingDetails.currentActive != null
            ? stateProperties.renderingDetails.currentActive!
            : null
        : null;
    ChartTouchInteractionArgs touchArgs;
    if (currentActive != null) {
      // ignore: unnecessary_null_comparison
      if (chart.onDataLabelTapped != null && seriesRenderer != null) {
        triggerPyramidDataLabelEvent(chart, seriesRenderer, stateProperties,
            stateProperties.renderingDetails.tapPosition!);
      }
      if (stateProperties.renderingDetails.tapPosition != null &&
          stateProperties.renderingDetails.currentActive != null) {
        if (currentActive.series != null &&
            currentActive.series.explodeGesture == ActivationMode.singleTap) {
          stateProperties.chartSeries.pointExplode(currentActive.pointIndex!);
          final GlobalKey key =
              stateProperties.renderDataLabel!.key as GlobalKey;
          final PyramidDataLabelRendererState pyramidDataLabelRendererState =
              key.currentState as PyramidDataLabelRendererState;
          pyramidDataLabelRendererState.dataLabelRepaintNotifier.value++;
        }

        if (stateProperties
            .chartSeries.visibleSeriesRenderers[0].isSelectionEnable) {
          stateProperties.chartSeries.seriesPointSelection(
              currentActive.pointIndex!, ActivationMode.singleTap);
        }

        if (chart.tooltipBehavior.enable &&
            stateProperties.renderingDetails.animateCompleted &&
            chart.tooltipBehavior.activationMode == ActivationMode.singleTap &&
            currentActive.series != null) {
          if (chart.tooltipBehavior.builder != null) {
            showPyramidTooltipTemplate();
          } else {
            final Offset position = renderBox.globalToLocal(event.position);
            stateProperties.renderingDetails.tooltipBehaviorRenderer
                .onTouchUp(position.dx.toDouble(), position.dy.toDouble());
          }
        }
      }
    }
    if (chart.onChartTouchInteractionUp != null) {
      touchArgs = ChartTouchInteractionArgs();
      touchArgs.position = renderBox.globalToLocal(event.position);
      chart.onChartTouchInteractionUp!(touchArgs);
    }
    if (chart.series.onPointTap == null &&
        chart.series.onPointDoubleTap == null &&
        chart.series.onPointLongPress == null) {
      stateProperties.renderingDetails.tapPosition = null;
    }
  }

  /// To perform event on mouse hover.
  void _onHover(PointerEvent event) {
    stateProperties.renderingDetails.currentActive = null;
    stateProperties.renderingDetails.tapPosition =
        renderBox.globalToLocal(event.position);
    bool? isPoint;
    const int seriesIndex = 0;
    int? pointIndex;
    final PyramidSeriesRendererExtension seriesRenderer =
        stateProperties.chartSeries.visibleSeriesRenderers[seriesIndex];
    final TooltipBehavior tooltip = chart.tooltipBehavior;
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        stateProperties.renderingDetails.tooltipBehaviorRenderer;
    final TooltipRenderingDetails tooltipRenderingDetails =
        TooltipHelper.getRenderingDetails(
            stateProperties.renderingDetails.tooltipBehaviorRenderer);
    for (int j = 0; j < seriesRenderer.renderPoints!.length; j++) {
      if (seriesRenderer.renderPoints![j].isVisible) {
        isPoint = isPointInPolygon(seriesRenderer.renderPoints![j].pathRegion,
            stateProperties.renderingDetails.tapPosition!);
        if (isPoint) {
          pointIndex = j;
          break;
        }
      }
    }
    if (stateProperties.renderingDetails.tapPosition != null &&
        isPoint != null &&
        isPoint) {
      stateProperties.renderingDetails.currentActive = ChartInteraction(
        seriesIndex,
        pointIndex!,
        stateProperties.chartSeries.visibleSeriesRenderers[seriesIndex].series,
        stateProperties.chartSeries.visibleSeriesRenderers[seriesIndex]
            .renderPoints![pointIndex],
      );
    } else if (tooltip.builder != null) {
      tooltipRenderingDetails.hide();
    }
    if (stateProperties.renderingDetails.tapPosition != null) {
      if (tooltip.enable &&
          stateProperties.renderingDetails.currentActive != null &&
          stateProperties.renderingDetails.currentActive!.series != null) {
        tooltipRenderingDetails.isHovering = true;
        if (tooltip.builder != null &&
            stateProperties.renderingDetails.animateCompleted) {
          showPyramidTooltipTemplate();
        } else {
          final Offset position = renderBox.globalToLocal(event.position);
          tooltipBehaviorRenderer.onEnter(
              position.dx.toDouble(), position.dy.toDouble());
        }
      } else {
        tooltipRenderingDetails.prevTooltipValue = null;
        tooltipRenderingDetails.currentTooltipValue = null;
        tooltipRenderingDetails.hide();
      }
    }
    stateProperties.renderingDetails.tapPosition = null;
  }

  /// This method gets executed for showing tooltip when builder is provided in behavior.
  void showPyramidTooltipTemplate([int? pointIndex]) {
    stateProperties.isTooltipHidden = false;
    final TooltipBehavior tooltip = chart.tooltipBehavior;
    final TooltipRenderingDetails tooltipRenderingDetails =
        TooltipHelper.getRenderingDetails(
            stateProperties.renderingDetails.tooltipBehaviorRenderer);
    if (!tooltipRenderingDetails.isHovering) {
      //assigning null for the previous and current tooltip values in case of touch interaction
      tooltipRenderingDetails.prevTooltipValue = null;
      tooltipRenderingDetails.currentTooltipValue = null;
    }
    final PyramidSeries<dynamic, dynamic> chartSeries =
        stateProperties.renderingDetails.currentActive?.series ?? chart.series;
    final PointInfo<dynamic> point = pointIndex == null
        ? stateProperties.renderingDetails.currentActive?.point
        : stateProperties
            .chartSeries.visibleSeriesRenderers[0].dataPoints[pointIndex];
    final Offset? location =
        chart.tooltipBehavior.tooltipPosition == TooltipPosition.pointer &&
                !stateProperties
                    .chartSeries.visibleSeriesRenderers[0].series.explode
            ? stateProperties.renderingDetails.tapPosition!
            : point.symbolLocation;
    bool isPoint = false;
    for (int j = 0; j < seriesRenderer.renderPoints!.length; j++) {
      if (seriesRenderer.renderPoints![j].isVisible == true) {
        isPoint = isPointInPolygon(
            seriesRenderer.renderPoints![j].pathRegion, location!);
        if (isPoint) {
          pointIndex = j;
          break;
        }
      }
    }
    if (location != null && isPoint && (chartSeries.enableTooltip)) {
      tooltipRenderingDetails.showLocation = location;
      tooltipRenderingDetails.chartTooltipState!.boundaryRect =
          tooltipRenderingDetails.tooltipBounds =
              stateProperties.renderingDetails.chartContainerRect;
      tooltipRenderingDetails.tooltipTemplate = tooltip.builder!(
          chartSeries.dataSource![pointIndex ??
              stateProperties.renderingDetails.currentActive!.pointIndex!],
          point,
          chartSeries,
          stateProperties.renderingDetails.currentActive?.seriesIndex ?? 0,
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
      tooltipRenderingDetails.chartTooltipState!
          .hide(hideDelay: tooltip.duration.toInt());
    }
  }
}
