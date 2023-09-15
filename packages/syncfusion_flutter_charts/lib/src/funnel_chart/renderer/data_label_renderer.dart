import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../../chart/common/data_label.dart';
import '../../chart/utils/enum.dart';
import '../../chart/utils/helper.dart';
import '../../circular_chart/renderer/circular_chart_annotation.dart';
import '../../circular_chart/renderer/data_label_renderer.dart';
import '../../circular_chart/utils/enum.dart';
import '../../circular_chart/utils/helper.dart';
import '../../common/event_args.dart';
import '../../common/utils/helper.dart';
import '../../pyramid_chart/utils/common.dart';
import '../../pyramid_chart/utils/helper.dart';
import '../base/funnel_base.dart';
import '../base/funnel_state_properties.dart';
import 'funnel_series.dart';
import 'renderer_extension.dart';

/// Represents the data label renderer of the funnel chart.
// ignore: must_be_immutable
class FunnelDataLabelRenderer extends StatefulWidget {
  /// Creates an instance for funnel data label renderer.
  // ignore: prefer_const_constructors_in_immutables
  FunnelDataLabelRenderer(
      {required Key key, required this.stateProperties, required this.show})
      : super(key: key);

  /// Creates the instance of funnel chart state.
  final FunnelStateProperties stateProperties;

  /// Specifies whether to show data label renderer.
  bool show;

  /// Specifies the state of funnel data label renderer.
  FunnelDataLabelRendererState? state;

  @override
  State<StatefulWidget> createState() => FunnelDataLabelRendererState();
}

/// Represents the data label renderer state.
class FunnelDataLabelRendererState extends State<FunnelDataLabelRenderer>
    with SingleTickerProviderStateMixin {
  /// Specifies the animation controller list.
  late List<AnimationController> animationControllersList;

  /// Animation controller for series.
  late AnimationController animationController;

  /// Repaint notifier for data label container.
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
            widget.stateProperties.renderingDetails.initialRender! ? 500 : 0);
    final Animation<double> dataLabelAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.1, 0.8, curve: Curves.decelerate),
    ));
    animationController.forward(from: 0.0);
    return !widget.show
        ? Container()
        // ignore: avoid_unnecessary_containers
        : Container(
            child: RepaintBoundary(
                child: CustomPaint(
                    painter: _FunnelDataLabelPainter(
                        stateProperties: widget.stateProperties,
                        animation: dataLabelAnimation,
                        state: this,
                        notifier: dataLabelRepaintNotifier,
                        animationController: animationController))));
  }

  @override
  void dispose() {
    disposeAnimationController(animationController, repaintDataLabelElements);
    super.dispose();
  }

  /// Method to repaint the data label element.
  void repaintDataLabelElements() {
    dataLabelRepaintNotifier.value++;
  }

  /// Method to render the widget.
  void render() {
    setState(() {
      widget.show = true;
    });
  }
}

class _FunnelDataLabelPainter extends CustomPainter {
  _FunnelDataLabelPainter(
      {required this.stateProperties,
      required this.state,
      required this.animationController,
      required this.animation,
      required ValueNotifier<num> notifier})
      : super(repaint: notifier);

  final FunnelStateProperties stateProperties;

  final FunnelDataLabelRendererState state;

  final AnimationController animationController;

  final Animation<double>? animation;

  /// To paint funnel data label.
  @override
  void paint(Canvas canvas, Size size) {
    final FunnelSeriesRendererExtension seriesRenderer =
        stateProperties.chartSeries.visibleSeriesRenderers[0];
    final FunnelSeries<dynamic, dynamic> series = seriesRenderer.series;
    // ignore: unnecessary_null_comparison
    if (series.dataLabelSettings != null &&
        series.dataLabelSettings.isVisible) {
      seriesRenderer.dataLabelSettingsRenderer =
          DataLabelSettingsRenderer(seriesRenderer.series.dataLabelSettings);
      _renderFunnelDataLabel(
          seriesRenderer, canvas, stateProperties, animation, series);
    }
  }

  @override
  bool shouldRepaint(_FunnelDataLabelPainter oldDelegate) => true;
}

/// To render funnel data label.
void _renderFunnelDataLabel(
    FunnelSeriesRendererExtension seriesRenderer,
    Canvas canvas,
    FunnelStateProperties stateProperties,
    Animation<double>? animation,
    FunnelSeries<dynamic, dynamic> series) {
  PointInfo<dynamic> point;
  final SfFunnelChart chart = stateProperties.chart;
  final DataLabelSettings dataLabel = series.dataLabelSettings;
  String? label;
  final double animateOpacity = animation != null ? animation.value : 1;
  DataLabelRenderArgs dataLabelArgs;

  final TextStyle dataLabelStyle = stateProperties
      .renderingDetails.themeData.textTheme.bodySmall!
      .merge(stateProperties.renderingDetails.chartTheme.dataLabelTextStyle)
      .merge(dataLabel.textStyle);

  final List<Rect> renderDataLabelRegions = <Rect>[];
  DataLabelSettingsRenderer dataLabelSettingsRenderer;
  Size textSize;
  PointInfo<dynamic> nextPoint;
  stateProperties.outsideRects.clear();
  for (int pointIndex = 0;
      pointIndex < seriesRenderer.renderPoints.length;
      pointIndex++) {
    dataLabelSettingsRenderer = seriesRenderer.dataLabelSettingsRenderer;
    point = seriesRenderer.renderPoints[pointIndex];
    TextStyle textStyle = dataLabelStyle.copyWith();
    if (point.isVisible && (point.y != 0 || dataLabel.showZeroValue)) {
      label = point.text;
      dataLabelSettingsRenderer.color =
          seriesRenderer.series.dataLabelSettings.color;
      if (chart.onDataLabelRender != null &&
          !seriesRenderer.renderPoints[pointIndex].labelRenderEvent) {
        dataLabelArgs = DataLabelRenderArgs(seriesRenderer,
            seriesRenderer.renderPoints, pointIndex, pointIndex);
        dataLabelArgs.text = label!;
        dataLabelArgs.textStyle = textStyle.copyWith();
        dataLabelArgs.color = dataLabelSettingsRenderer.color;
        chart.onDataLabelRender!(dataLabelArgs);
        label = point.text = dataLabelArgs.text;
        textStyle = textStyle.merge(dataLabelArgs.textStyle); //Check here
        pointIndex = dataLabelArgs.pointIndex!;
        dataLabelSettingsRenderer.color = dataLabelArgs.color;
        seriesRenderer.dataPoints[pointIndex].labelRenderEvent = true;
      }
      textStyle = chart.onDataLabelRender == null
          ? getDataLabelTextStyle(
              seriesRenderer, point, stateProperties, animateOpacity)
          : textStyle;
      textSize = measureText(label!, textStyle);

      /// Label check after event.
      if (label != '') {
        stateProperties.labelRects.clear();
        for (int index = 0;
            index < seriesRenderer.renderPoints.length;
            index++) {
          nextPoint = seriesRenderer.renderPoints[index];
          final num angle = dataLabel.angle;
          Offset labelLocation;
          const int labelPadding = 2;
          final Size nextDataLabelSize =
              measureText(nextPoint.text!, textStyle);
          if (nextPoint.isVisible) {
            labelLocation = nextPoint.symbolLocation;
            labelLocation = Offset(
                labelLocation.dx -
                    (nextDataLabelSize.width / 2) +
                    (angle == 0 ? 0 : nextDataLabelSize.width / 2),
                labelLocation.dy -
                    (nextDataLabelSize.height / 2) +
                    (angle == 0 ? 0 : nextDataLabelSize.height / 2));
            stateProperties.labelRects.add(Rect.fromLTWH(
                labelLocation.dx - labelPadding,
                labelLocation.dy - labelPadding,
                nextDataLabelSize.width + (2 * labelPadding),
                nextDataLabelSize.height + (2 * labelPadding)));
          } else {
            stateProperties.labelRects.add(Rect.zero);
          }
        }
        PointInfoHelper.setIsLabelCollide(
            point, checkCollide(pointIndex, stateProperties.labelRects));
        if (dataLabel.labelPosition == ChartDataLabelPosition.inside) {
          _setFunnelInsideLabelPosition(
              dataLabel,
              point,
              textSize,
              stateProperties,
              canvas,
              renderDataLabelRegions,
              pointIndex,
              label,
              seriesRenderer,
              animateOpacity,
              textStyle);
        } else {
          point.renderPosition = ChartDataLabelPosition.outside;
          textStyle = getDataLabelTextStyle(
              seriesRenderer, point, stateProperties, animateOpacity);
          _renderOutsideFunnelDataLabel(
              canvas,
              label,
              point,
              textSize,
              pointIndex,
              seriesRenderer,
              stateProperties,
              textStyle,
              renderDataLabelRegions,
              animateOpacity);
        }
      }
    }
  }
}

/// To render inside positioned funnel data labels.
void _setFunnelInsideLabelPosition(
    DataLabelSettings dataLabel,
    PointInfo<dynamic> point,
    Size textSize,
    FunnelStateProperties stateProperties,
    Canvas canvas,
    List<Rect> renderDataLabelRegions,
    int pointIndex,
    String? label,
    FunnelSeriesRendererExtension seriesRenderer,
    double animateOpacity,
    TextStyle dataLabelStyle) {
  final num angle = dataLabel.angle;
  Offset labelLocation;
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
      findingCollision(point.labelRect!, renderDataLabelRegions, point.region);
  if (isDataLabelCollide) {
    switch (dataLabel.overflowMode) {
      case OverflowMode.trim:
        label = getSegmentOverflowTrimmedText(
            dataLabel,
            point,
            textSize,
            stateProperties,
            labelLocation,
            renderDataLabelRegions,
            dataLabelStyle);
        break;
      case OverflowMode.hide:
        label = '';
        break;
      // ignore: no_default_cases
      default:
        break;
    }
  }
  final bool isLabelCollide = PointInfoHelper.getIsLabelCollide(point);
  if ((isLabelCollide &&
          dataLabel.labelIntersectAction == LabelIntersectAction.shift &&
          dataLabel.overflowMode == OverflowMode.none) ||
      isDataLabelCollide && dataLabel.overflowMode == OverflowMode.shift) {
    point.saturationRegionOutside = true;
    point.renderPosition = ChartDataLabelPosition.outside;
    dataLabelStyle = getDataLabelTextStyle(
        seriesRenderer, point, stateProperties, animateOpacity);
    _renderOutsideFunnelDataLabel(
        canvas,
        label!,
        point,
        textSize,
        pointIndex,
        seriesRenderer,
        stateProperties,
        dataLabelStyle,
        renderDataLabelRegions,
        animateOpacity);
  } else if ((dataLabel.labelIntersectAction == LabelIntersectAction.none ||
          (!isLabelCollide &&
              dataLabel.labelIntersectAction == LabelIntersectAction.shift) ||
          (!isLabelCollide &&
              dataLabel.labelIntersectAction == LabelIntersectAction.hide)) &&
      (!isDataLabelCollide && dataLabel.overflowMode == OverflowMode.hide ||
          (dataLabel.overflowMode == OverflowMode.none)) &&
      label != '') {
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
        stateProperties,
        dataLabelStyle,
        renderDataLabelRegions,
        animateOpacity);
  } else if ((!isLabelCollide &&
          dataLabel.labelIntersectAction != LabelIntersectAction.hide) &&
      label != '') {
    point.renderPosition = ChartDataLabelPosition.inside;
    final Size trimmedTextSize = measureText(label!, dataLabelStyle);
    labelLocation = point.symbolLocation;
    labelLocation = Offset(
        labelLocation.dx -
            (trimmedTextSize.width / 2) +
            (angle == 0 ? 0 : textSize.width / 2),
        labelLocation.dy -
            (trimmedTextSize.height / 2) +
            (angle == 0 ? 0 : trimmedTextSize.height / 2));
    point.labelRect = Rect.fromLTWH(
        labelLocation.dx - labelPadding,
        labelLocation.dy - labelPadding,
        trimmedTextSize.width + (2 * labelPadding),
        trimmedTextSize.height + (2 * labelPadding));
    _drawFunnelLabel(
        point.labelRect!,
        labelLocation,
        label,
        null,
        canvas,
        seriesRenderer,
        point,
        pointIndex,
        stateProperties,
        dataLabelStyle,
        renderDataLabelRegions,
        animateOpacity);
  }
}

/// To render outside position funnel data labels.
void _renderOutsideFunnelDataLabel(
    Canvas canvas,
    String? label,
    PointInfo<dynamic> point,
    Size textSize,
    int pointIndex,
    FunnelSeriesRendererExtension seriesRenderer,
    FunnelStateProperties stateProperties,
    TextStyle textStyle,
    List<Rect> renderDataLabelRegions,
    double animateOpacity) {
  Path connectorPath;
  Rect? rect;
  Offset labelLocation;
  // Maximum available space for rendering data label.
  const int maximumAvailableWidth = 22;
  final EdgeInsets margin = seriesRenderer.series.dataLabelSettings.margin;
  final ConnectorLineSettings connector =
      seriesRenderer.series.dataLabelSettings.connectorLineSettings;
  const num regionPadding = 10;
  bool isPreviousRectIntersect = false;
  final DataLabelSettings dataLabel = seriesRenderer.series.dataLabelSettings;
  connectorPath = Path();
  final num connectorLength = percentToValue(connector.length ?? '0%',
          stateProperties.renderingDetails.chartAreaRect.width / 2)! +
      seriesRenderer.maximumDataLabelRegion.width / 2 -
      regionPadding;
  final List<Offset> regions =
      seriesRenderer.renderPoints[pointIndex].pathRegion;
  final Offset startPoint = Offset(
      (regions[1].dx + regions[2].dx) / 2, (regions[1].dy + regions[2].dy) / 2);
  if (textSize.width > maximumAvailableWidth) {
    label = '${label!.substring(0, 2)}..';
    textSize = measureText(label, textStyle);
  }
  final double dx = seriesRenderer.renderPoints[pointIndex].symbolLocation.dx +
      connectorLength;
  final Offset endPoint = Offset(
      (dx + textSize.width + margin.left + margin.right) >
              stateProperties.renderingDetails.chartAreaRect.right
          ? dx -
              (percentToValue(seriesRenderer.series.explodeOffset,
                  stateProperties.renderingDetails.chartAreaRect.width)!)
          : dx,
      (regions[1].dy + regions[2].dy) / 2);
  connectorPath.moveTo(startPoint.dx, startPoint.dy);
  if (connector.type == ConnectorType.line) {
    connectorPath.lineTo(endPoint.dx, endPoint.dy);
  }
  point.dataLabelPosition = Position.right;
  rect = getDataLabelRect(point.dataLabelPosition!, connector.type, margin,
      connectorPath, endPoint, textSize);
  if (rect != null) {
    final Rect containerRect = stateProperties.renderingDetails.chartAreaRect;
    point.labelRect = rect;
    labelLocation = Offset(rect.left + margin.left,
        rect.top + rect.height / 2 - textSize.height / 2);
    if (dataLabel.labelIntersectAction == LabelIntersectAction.shift ||
        dataLabel.overflowMode == OverflowMode.shift) {
      if (seriesRenderer.series.dataLabelSettings.builder == null) {
        Rect? lastRenderedLabelRegion;
        if (renderDataLabelRegions.isNotEmpty) {
          lastRenderedLabelRegion =
              renderDataLabelRegions[renderDataLabelRegions.length - 1];
        }
        if (stateProperties.outsideRects.isNotEmpty) {
          isPreviousRectIntersect =
              _isFunnelLabelIntersect(rect, stateProperties.outsideRects.last);
        } else {
          isPreviousRectIntersect =
              _isFunnelLabelIntersect(rect, lastRenderedLabelRegion);
        }
        if (rect.left > containerRect.left &&
            rect.right <= containerRect.right &&
            rect.top > containerRect.top &&
            rect.bottom < containerRect.bottom) {
          if (!isPreviousRectIntersect) {
            _drawFunnelLabel(
                rect,
                labelLocation,
                label,
                connectorPath,
                canvas,
                seriesRenderer,
                point,
                pointIndex,
                stateProperties,
                textStyle,
                renderDataLabelRegions,
                animateOpacity);
          } else {
            if (pointIndex != 0) {
              const num connectorLinePadding = 15;
              const num padding = 2;
              final Rect previousRenderedRect = stateProperties
                      .outsideRects.isNotEmpty
                  ? stateProperties
                      .outsideRects[stateProperties.outsideRects.length - 1]
                  : renderDataLabelRegions[renderDataLabelRegions.length - 1];
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
                  stateProperties,
                  textStyle,
                  renderDataLabelRegions,
                  animateOpacity);
            }
          }
        }
      }
    } else if (dataLabel.labelIntersectAction == LabelIntersectAction.none) {
      _drawFunnelLabel(
          rect,
          labelLocation,
          label,
          connectorPath,
          canvas,
          seriesRenderer,
          point,
          pointIndex,
          stateProperties,
          textStyle,
          renderDataLabelRegions,
          animateOpacity);
    } else if (dataLabel.labelIntersectAction == LabelIntersectAction.hide) {
      if (seriesRenderer.series.dataLabelSettings.builder == null) {
        stateProperties.outsideRects.add(rect);
        Rect? lastRenderedLabelRegion;
        if (renderDataLabelRegions.isNotEmpty) {
          lastRenderedLabelRegion =
              renderDataLabelRegions[renderDataLabelRegions.length - 1];
        }
        isPreviousRectIntersect =
            _isFunnelLabelIntersect(rect, lastRenderedLabelRegion);
        if (!isPreviousRectIntersect) {
          _drawFunnelLabel(
              rect,
              labelLocation,
              label,
              connectorPath,
              canvas,
              seriesRenderer,
              point,
              pointIndex,
              stateProperties,
              textStyle,
              renderDataLabelRegions,
              animateOpacity);
        }
      }
    }
  }
}

/// To check whether labels intersect.
bool _isFunnelLabelIntersect(Rect rect, Rect? previousRect) {
  bool isIntersect = false;
  const num padding = 2;
  if (previousRect != null && (rect.bottom + padding) > previousRect.top) {
    isIntersect = true;
  }
  return isIntersect;
}

/// To draw funnel data label.
void _drawFunnelLabel(
    Rect labelRect,
    Offset location,
    String? label,
    Path? connectorPath,
    Canvas canvas,
    FunnelSeriesRendererExtension seriesRenderer,
    PointInfo<dynamic> point,
    int pointIndex,
    FunnelStateProperties stateProperties,
    TextStyle textStyle,
    List<Rect> renderDataLabelRegions,
    double animateOpacity) {
  Paint rectPaint;
  final DataLabelSettings dataLabel = seriesRenderer.series.dataLabelSettings;
  final DataLabelSettingsRenderer dataLabelSettingsRenderer =
      seriesRenderer.dataLabelSettingsRenderer;
  final ConnectorLineSettings connector = dataLabel.connectorLineSettings;
  if (connectorPath != null) {
    canvas.drawPath(
        connectorPath,
        Paint()
          ..color = connector.width <= 0
              ? Colors.transparent
              : connector.color ??
                  point.fill.withOpacity(
                      !stateProperties.renderingDetails.isLegendToggled
                          ? animateOpacity
                          : dataLabel.opacity)
          ..strokeWidth = connector.width
          ..style = PaintingStyle.stroke);
  }

  if (dataLabel.builder == null) {
    final double strokeWidth = dataLabel.borderWidth;
    final Color? labelFill = dataLabelSettingsRenderer.color ??
        (dataLabel.useSeriesColor
            ? point.fill
            : dataLabelSettingsRenderer.color);
    final Color? strokeColor =
        dataLabel.borderColor.withOpacity(dataLabel.opacity);
    // ignore: unnecessary_null_comparison
    if (strokeWidth != null && strokeWidth > 0) {
      rectPaint = Paint()
        ..color = strokeColor!.withOpacity(
            !stateProperties.renderingDetails.isLegendToggled
                ? animateOpacity
                : dataLabel.opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      drawLabelRect(
          rectPaint,
          Rect.fromLTRB(
              labelRect.left, labelRect.top, labelRect.right, labelRect.bottom),
          dataLabel.borderRadius,
          canvas);
    }
    if (labelFill != null) {
      drawLabelRect(
          Paint()
            ..color = labelFill
                .withOpacity(!stateProperties.renderingDetails.isLegendToggled
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
    drawText(canvas, label!, location, textStyle, dataLabel.angle);
    renderDataLabelRegions.add(labelRect);
  }
}

/// Method to trigger the funnel data label event.
void triggerFunnelDataLabelEvent(
    SfFunnelChart chart,
    FunnelSeriesRendererExtension seriesRenderer,
    SfFunnelChartState chartState,
    Offset position) {
  const int seriesIndex = 0;
  PointInfo<dynamic> point;
  DataLabelSettings dataLabel;
  Offset labelLocation;
  for (int index = 0; index < seriesRenderer.renderPoints.length; index++) {
    point = seriesRenderer.renderPoints[index];
    dataLabel = seriesRenderer.series.dataLabelSettings;
    labelLocation = point.symbolLocation;
    if (dataLabel.isVisible &&
        seriesRenderer.renderPoints[index].labelRect != null &&
        seriesRenderer.renderPoints[index].labelRect!.contains(position)) {
      position = Offset(labelLocation.dx, labelLocation.dy);
      dataLabelTapEvent(chart, seriesRenderer.series.dataLabelSettings, index,
          point, position, seriesIndex);
    }
  }
}
