import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../../chart/chart_series/xy_data_series.dart';
import '../../chart/common/data_label.dart';
import '../../chart/utils/enum.dart';
import '../../chart/utils/helper.dart';
import '../../common/event_args.dart';
import '../../common/rendering_details.dart';
import '../../common/template/rendering.dart';
import '../../common/utils/helper.dart';
import '../../pyramid_chart/utils/helper.dart';
import '../base/circular_base.dart';
import '../base/circular_state_properties.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import 'chart_point.dart';
import 'circular_chart_annotation.dart';
import 'renderer_extension.dart';

/// Represents the circular data label renderer.
// ignore: must_be_immutable
class CircularDataLabelRenderer extends StatefulWidget {
  /// Creates the instance of circular data label renderer.
  // ignore: prefer_const_constructors_in_immutables
  CircularDataLabelRenderer(
      {required this.stateProperties, required this.show});

  /// Specifies the circular chart state.
  final CircularStateProperties stateProperties;

  /// Specifies whether to show the data label.
  bool show;

  /// Specifies the state of circular data label renderer.
  late CircularDataLabelRendererState state;

  @override
  State<StatefulWidget> createState() {
    return CircularDataLabelRendererState();
  }
}

/// Represents the circular data label renderer state.
class CircularDataLabelRendererState extends State<CircularDataLabelRenderer>
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
                    painter: _CircularDataLabelPainter(
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

  /// Method to notify the repaint notifier.
  void repaintDataLabelElements() {
    dataLabelRepaintNotifier.value++;
  }

  /// Method to render the data label.
  void render() {
    setState(() {
      widget.show = true;
    });
  }
}

class _CircularDataLabelPainter extends CustomPainter {
  _CircularDataLabelPainter(
      {required this.stateProperties,
      required this.state,
      required this.animationController,
      required this.animation,
      required ValueNotifier<num> notifier})
      : super(repaint: notifier);

  final CircularStateProperties stateProperties;

  final CircularDataLabelRendererState state;

  final AnimationController animationController;

  final Animation<double> animation;

  /// To paint data labels.
  @override
  void paint(Canvas canvas, Size size) {
    final List<CircularSeriesRendererExtension> visibleSeriesRenderers =
        stateProperties.chartSeries.visibleSeriesRenderers;
    CircularSeriesRendererExtension seriesRenderer;
    for (int seriesIndex = 0;
        seriesIndex < visibleSeriesRenderers.length;
        seriesIndex++) {
      seriesRenderer = visibleSeriesRenderers[seriesIndex];
      // ignore: unnecessary_null_comparison
      if (seriesRenderer.series.dataLabelSettings != null &&
          seriesRenderer.series.dataLabelSettings.isVisible) {
        seriesRenderer.dataLabelSettingsRenderer =
            DataLabelSettingsRenderer(seriesRenderer.series.dataLabelSettings);
        renderCircularDataLabel(
            seriesRenderer, canvas, stateProperties, seriesIndex, animation);
      }
    }
  }

  @override
  bool shouldRepaint(_CircularDataLabelPainter oldDelegate) => true;
}

/// Decides to increase the angle or not.
bool isIncreaseAngle = false;

/// To store the points which render at left and positioned outside.
List<ChartPoint<dynamic>> leftPoints = <ChartPoint<dynamic>>[];

/// To store the points which render at right and positioned outside.
List<ChartPoint<dynamic>> rightPoints = <ChartPoint<dynamic>>[];

/// Decrease the angle of the label if it intersects with labels.
void _decreaseAngle(
    ChartPoint<dynamic> currentPoint,
    ChartPoint<dynamic> previousPoint,
    CircularSeriesRendererExtension seriesRenderer,
    bool isRightSide) {
  int count = 1;
  if (isRightSide) {
    while (isOverlap(currentPoint.labelRect, previousPoint.labelRect) ||
        (seriesRenderer.series.pointRadiusMapper != null &&
            (!((previousPoint.labelRect.height + previousPoint.labelRect.top) <
                currentPoint.labelRect.top)))) {
      int newAngle = PointHelper.getNewAngle(previousPoint)!.toInt() - count;
      if (newAngle < 0) {
        newAngle = 360 + newAngle;
      }
      if (newAngle <= 270 && newAngle >= 90) {
        newAngle = 270;
        isIncreaseAngle = true;
        break;
      }
      _changeLabelAngle(previousPoint, newAngle, seriesRenderer);
      count++;
    }
  } else {
    if (PointHelper.getNewAngle(currentPoint)! > 270) {
      _changeLabelAngle(currentPoint, 270, seriesRenderer);
      PointHelper.setNewAngle(previousPoint, 270);
    }
    while (isOverlap(currentPoint.labelRect, previousPoint.labelRect) ||
        (seriesRenderer.series.pointRadiusMapper != null &&
            ((currentPoint.labelRect.top + currentPoint.labelRect.height) >
                previousPoint.labelRect.bottom))) {
      int newAngle = PointHelper.getNewAngle(previousPoint)!.toInt() - count;
      if (!(newAngle <= 270 && newAngle >= 90)) {
        newAngle = 270;
        isIncreaseAngle = true;
        break;
      }
      _changeLabelAngle(previousPoint, newAngle, seriesRenderer);
      if (isOverlap(currentPoint.labelRect, previousPoint.labelRect) &&
          // ignore: unnecessary_null_comparison
          leftPoints.indexOf(previousPoint) == null &&
          (newAngle - 1 < 90 && newAngle - 1 > 270)) {
        _changeLabelAngle(currentPoint,
            PointHelper.getNewAngle(currentPoint)! + 1, seriesRenderer);
        _arrangeLeftSidePoints(seriesRenderer);
        break;
      }
      count++;
    }
  }
}

/// Increase the angle of the label if it intersects labels.
void _increaseAngle(
    ChartPoint<dynamic> currentPoint,
    ChartPoint<dynamic> nextPoint,
    CircularSeriesRendererExtension seriesRenderer,
    bool isRightSide) {
  int count = 1;
  if (isRightSide) {
    while (isOverlap(currentPoint.labelRect, nextPoint.labelRect) ||
        (seriesRenderer.series.pointRadiusMapper != null &&
            (!((currentPoint.labelRect.top + currentPoint.labelRect.height) <
                nextPoint.labelRect.top)))) {
      int newAngle = PointHelper.getNewAngle(nextPoint)!.toInt() + count;
      if (newAngle < 270 && newAngle > 90) {
        newAngle = 90;
        isIncreaseAngle = true;
        break;
      }
      _changeLabelAngle(nextPoint, newAngle, seriesRenderer);
      if (isOverlap(currentPoint.labelRect, nextPoint.labelRect) &&
          (newAngle + 1 > 90 && newAngle + 1 < 270) &&
          rightPoints.indexOf(nextPoint) == rightPoints.length - 1) {
        _changeLabelAngle(currentPoint,
            PointHelper.getNewAngle(currentPoint)! - 1, seriesRenderer);
        _arrangeRightSidePoints(seriesRenderer);
        break;
      }
      count++;
    }
  } else {
    while (isOverlap(currentPoint.labelRect, nextPoint.labelRect) ||
        (seriesRenderer.series.pointRadiusMapper != null &&
            (currentPoint.labelRect.top <
                (nextPoint.labelRect.top + nextPoint.labelRect.height)))) {
      int newAngle = PointHelper.getNewAngle(nextPoint)!.toInt() + count;
      if (!(newAngle < 270 && newAngle > 90)) {
        newAngle = 270;
        isIncreaseAngle = false;
        break;
      }
      _changeLabelAngle(
        nextPoint,
        newAngle,
        seriesRenderer,
      );
      count++;
    }
  }
}

/// Change the label angle based on the given new angle.
void _changeLabelAngle(ChartPoint<dynamic> currentPoint, num newAngle,
    CircularSeriesRendererExtension seriesRenderer) {
  const String defaultConnectorLineLength = '10%';
  final DataLabelSettings dataLabel =
      seriesRenderer.dataLabelSettingsRenderer.dataLabelSettings;
  final RenderingDetails renderingDetails =
      seriesRenderer.stateProperties.renderingDetails;
  final TextStyle dataLabelStyle = renderingDetails
      .themeData.textTheme.bodySmall!
      .merge(renderingDetails.chartTheme.dataLabelTextStyle)
      .merge(dataLabel.textStyle);

  // Builder check for change the angle based on the template size.
  final Size textSize = dataLabel.builder != null
      ? currentPoint.dataLabelSize
      : measureText(currentPoint.text!, dataLabelStyle);
  final Path angleChangedConnectorPath = Path();
  final num connectorLength = percentToValue(
      dataLabel.connectorLineSettings.length ?? defaultConnectorLineLength,
      currentPoint.outerRadius!)!;
  final Offset startPoint =
      degreeToPoint(newAngle, currentPoint.outerRadius!, currentPoint.center!);
  final Offset endPoint = degreeToPoint(newAngle,
      currentPoint.outerRadius! + connectorLength, currentPoint.center!);
  angleChangedConnectorPath.moveTo(startPoint.dx, startPoint.dy);
  if (dataLabel.connectorLineSettings.type == ConnectorType.line) {
    angleChangedConnectorPath.lineTo(endPoint.dx, endPoint.dy);
  }
  seriesRenderer
          .renderPoints![seriesRenderer.renderPoints!.indexOf(currentPoint)]
          .labelRect =
      getDataLabelRect(
          currentPoint.dataLabelPosition,
          seriesRenderer.dataLabelSettingsRenderer.dataLabelSettings
              .connectorLineSettings.type,
          dataLabel.margin,
          angleChangedConnectorPath,
          endPoint,
          textSize)!;
  PointHelper.setLabelUpdated(currentPoint, 1);
  PointHelper.setNewAngle(currentPoint, newAngle);
}

/// Left side points alignment calculation.
void _arrangeLeftSidePoints(CircularSeriesRendererExtension seriesRenderer) {
  ChartPoint<dynamic> previousPoint;
  ChartPoint<dynamic> currentPoint;
  bool angleChanged = false;
  bool startFresh = false;
  for (int i = 1; i < leftPoints.length; i++) {
    currentPoint = leftPoints[i];
    previousPoint = leftPoints[i - 1];
    if (isOverlapWithPrevious(currentPoint, leftPoints, i) &&
            currentPoint.isVisible ||
        !(PointHelper.getNewAngle(currentPoint)! < 270)) {
      angleChanged = true;
      if (startFresh) {
        isIncreaseAngle = false;
      }
      if (!isIncreaseAngle) {
        for (int k = i; k > 0; k--) {
          _decreaseAngle(
              leftPoints[k], leftPoints[k - 1], seriesRenderer, false);
          for (int index = 1; index < leftPoints.length; index++) {
            if (PointHelper.getLabelUpdated(leftPoints[index]) != null &&
                PointHelper.getNewAngle(leftPoints[index])! - 10 < 100) {
              isIncreaseAngle = true;
            }
          }
        }
      } else {
        for (int k = i; k < leftPoints.length; k++) {
          _increaseAngle(
              leftPoints[k - 1], leftPoints[k], seriesRenderer, false);
        }
      }
    } else {
      if (angleChanged &&
          // ignore: unnecessary_null_comparison
          previousPoint != null &&
          PointHelper.getLabelUpdated(previousPoint) == 1) {
        startFresh = true;
      }
    }
  }
}

/// Right side points alignments calculation.
void _arrangeRightSidePoints(CircularSeriesRendererExtension series) {
  bool startFresh = false;
  bool angleChanged = false;
  num checkAngle;
  ChartPoint<dynamic> currentPoint;
  final ChartPoint<dynamic>? lastPoint =
      rightPoints.length > 1 ? rightPoints[rightPoints.length - 1] : null;
  ChartPoint<dynamic> nextPoint;
  if (lastPoint != null) {
    if (PointHelper.getNewAngle(lastPoint)! > 360) {
      PointHelper.setNewAngle(
          lastPoint, PointHelper.getNewAngle(lastPoint)! - 360);
    }
    if (PointHelper.getNewAngle(lastPoint)! > 90 &&
        PointHelper.getNewAngle(lastPoint)! < 270) {
      isIncreaseAngle = true;
      _changeLabelAngle(lastPoint, 89, series);
    }
  }
  for (int i = rightPoints.length - 2; i >= 0; i--) {
    currentPoint = rightPoints[i];
    nextPoint = rightPoints[i + 1];
    if (isOverlapWithNext(currentPoint, rightPoints, i) &&
            currentPoint.isVisible ||
        !(PointHelper.getNewAngle(currentPoint)! <= 90 ||
            PointHelper.getNewAngle(currentPoint)! >= 270)) {
      checkAngle = PointHelper.getNewAngle(lastPoint!)! + 1;
      angleChanged = true;
      // If last's point change angle in beyond the limit, stop the increasing angle and do decrease the angle.
      if (startFresh) {
        isIncreaseAngle = false;
      } else if (checkAngle > 90 &&
          checkAngle < 270 &&
          PointHelper.getLabelUpdated(nextPoint) == 1) {
        isIncreaseAngle = true;
      }
      if (!isIncreaseAngle) {
        for (int k = i + 1; k < rightPoints.length; k++) {
          _increaseAngle(rightPoints[k - 1], rightPoints[k], series, true);
        }
      } else {
        for (int k = i + 1; k > 0; k--) {
          _decreaseAngle(rightPoints[k], rightPoints[k - 1], series, true);
        }
      }
    } else {
      //If a point did not overlapped with previous points, increase the angle always for right side points.
      if (angleChanged &&
          // ignore: unnecessary_null_comparison
          nextPoint != null &&
          PointHelper.getLabelUpdated(nextPoint) == 1) {
        startFresh = true;
      }
    }
  }
}

/// To render data label.
void renderCircularDataLabel(
    CircularSeriesRendererExtension seriesRenderer,
    Canvas canvas,
    CircularStateProperties stateProperties,
    int seriesIndex,
    Animation<double>? animation) {
  ChartPoint<dynamic> point;
  final SfCircularChart chart = stateProperties.chart;
  final DataLabelSettings dataLabel = seriesRenderer.series.dataLabelSettings;
  final DataLabelSettingsRenderer dataLabelSettingsRenderer =
      seriesRenderer.dataLabelSettingsRenderer;
  final num angle = dataLabel.angle;
  Offset labelLocation;
  const int labelPadding = 2;
  String? label;
  final double animateOpacity = animation != null ? animation.value : 1;
  DataLabelRenderArgs dataLabelArgs;
  final TextStyle dataLabelStyle = stateProperties
      .renderingDetails.themeData.textTheme.bodySmall!
      .merge(stateProperties.renderingDetails.chartTheme.dataLabelTextStyle)
      .merge(dataLabel.textStyle);

  final List<Rect> renderDataLabelRegions = <Rect>[];
  Size? textSize;
  for (int pointIndex = 0;
      pointIndex < seriesRenderer.renderPoints!.length;
      pointIndex++) {
    point = seriesRenderer.renderPoints![pointIndex];
    if (dataLabel.builder == null ||
        dataLabel.labelIntersectAction != LabelIntersectAction.shift) {
      TextStyle textStyle = dataLabelStyle.copyWith();
      if (point.isVisible && (point.y != 0 || dataLabel.showZeroValue)) {
        label = point.text;
        label = seriesRenderer.renderer.getLabelContent(
            seriesRenderer, point, pointIndex, seriesIndex, label!);
        dataLabelSettingsRenderer.color =
            seriesRenderer.series.dataLabelSettings.color;
        if (chart.onDataLabelRender != null &&
            !seriesRenderer.renderPoints![pointIndex].labelRenderEvent) {
          dataLabelArgs = DataLabelRenderArgs(seriesRenderer,
              seriesRenderer.renderPoints, pointIndex, pointIndex);
          dataLabelArgs.text = label;
          dataLabelArgs.textStyle = textStyle.copyWith();
          dataLabelArgs.color = dataLabelSettingsRenderer.color;
          chart.onDataLabelRender!(dataLabelArgs);
          label = point.text = dataLabelArgs.text;
          textStyle = textStyle.merge(dataLabelArgs.textStyle); //Check here
          pointIndex = dataLabelArgs.pointIndex!;
          dataLabelSettingsRenderer.color = dataLabelArgs.color;
          seriesRenderer.dataPoints[pointIndex].labelRenderEvent = true;
        }
        if (seriesRenderer.series.dataLabelSettings.builder != null) {
          final int pointIndex = seriesRenderer
              .stateProperties.renderingDetails.templates
              .indexWhere((ChartTemplateInfo templateInfo) =>
                  templateInfo.pointIndex == point.index);
          // Checks template for avoid the hidden data point and calculate the label location based on template size.
          if (pointIndex != -1) {
            textSize = seriesRenderer.stateProperties.renderingDetails
                .dataLabelTemplateRegions[pointIndex].size;
          }
        } else {
          textSize = measureText(label, textStyle);
        }

        /// condition check for labels after event.
        if (label != '') {
          if (seriesRenderer.seriesType == 'radialbar') {
            textStyle = chart.onDataLabelRender == null
                ? seriesRenderer.renderer.getDataLabelStyle(
                    seriesRenderer,
                    point,
                    pointIndex,
                    seriesIndex,
                    textStyle,
                    stateProperties.chartState)
                : textStyle;
            labelLocation = degreeToPoint(point.startAngle!,
                (point.innerRadius! + point.outerRadius!) / 2, point.center!);
            labelLocation = Offset(
                (labelLocation.dx - textSize!.width - 5) +
                    (angle == 0 ? 0 : textSize.width / 2),
                (labelLocation.dy - textSize.height / 2) +
                    (angle == 0 ? 0 : textSize.height / 2));
            point.labelRect = Rect.fromLTWH(
                labelLocation.dx - labelPadding,
                labelLocation.dy - labelPadding,
                textSize.width + (2 * labelPadding),
                textSize.height + (2 * labelPadding));
            drawLabel(
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
                textStyle,
                renderDataLabelRegions,
                animateOpacity);
          } else {
            setLabelPosition(
                dataLabel,
                point,
                textSize!,
                stateProperties,
                canvas,
                renderDataLabelRegions,
                pointIndex,
                label,
                seriesRenderer,
                animateOpacity,
                textStyle,
                seriesIndex);
          }
        }
        textStyle = chart.onDataLabelRender == null
            ? seriesRenderer.renderer.getDataLabelStyle(seriesRenderer, point,
                pointIndex, seriesIndex, textStyle, stateProperties.chartState)
            : textStyle;
      } else {
        point.labelRect = Rect.zero;
      }
    }
  }
  if (seriesRenderer.dataLabelSettingsRenderer.dataLabelSettings
              .labelIntersectAction ==
          LabelIntersectAction.shift &&
      seriesRenderer.seriesType != 'radialbar') {
    const int labelPadding = 2;
    if (dataLabel.builder == null) {
      leftPoints = <ChartPoint<dynamic>>[];
      rightPoints = <ChartPoint<dynamic>>[];
      for (int i = 0; i < seriesRenderer.renderPoints!.length; i++) {
        if (seriesRenderer.renderPoints![i].isVisible) {
          PointHelper.setNewAngle(seriesRenderer.renderPoints![i],
              seriesRenderer.renderPoints![i].midAngle);
          if (seriesRenderer.renderPoints![i].dataLabelPosition ==
                  Position.left &&
              seriesRenderer.renderPoints![i].renderPosition ==
                  ChartDataLabelPosition.outside) {
            leftPoints.add(seriesRenderer.renderPoints![i]);
          } else if (seriesRenderer.renderPoints![i].dataLabelPosition ==
                  Position.right &&
              seriesRenderer.renderPoints![i].renderPosition ==
                  ChartDataLabelPosition.outside) {
            rightPoints.add(seriesRenderer.renderPoints![i]);
          }
        }
      }
      leftPoints.sort((ChartPoint<dynamic> a, ChartPoint<dynamic> b) =>
          PointHelper.getNewAngle(a)!.compareTo(PointHelper.getNewAngle(b)!));
      if (leftPoints.isNotEmpty) {
        _arrangeLeftSidePoints(seriesRenderer);
      }
      isIncreaseAngle = false;
      if (rightPoints.isNotEmpty) {
        _arrangeRightSidePoints(seriesRenderer);
      }
    }
    for (int pointIndex = 0;
        pointIndex < seriesRenderer.renderPoints!.length;
        pointIndex++) {
      if (seriesRenderer.renderPoints![pointIndex].isVisible) {
        final ChartPoint<dynamic> point =
            seriesRenderer.renderPoints![pointIndex];
        final EdgeInsets margin =
            seriesRenderer.series.dataLabelSettings.margin;
        final Rect rect = point.labelRect;
        final TextStyle dataLabelStyle = stateProperties
            .renderingDetails.themeData.textTheme.bodySmall!
            .copyWith(
              color: (dataLabel.builder == null && dataLabel.textStyle == null)
                  ? ((chart.onDataLabelRender != null &&
                          dataLabelSettingsRenderer.color != null)
                      ? getSaturationColor(
                          dataLabelSettingsRenderer.color ?? point.fill)
                      : getSaturationColor(point.renderPosition ==
                              ChartDataLabelPosition.outside
                          ? findthemecolor(stateProperties, point, dataLabel)
                          : dataLabelSettingsRenderer.color ?? point.fill))
                  : dataLabel.textStyle?.color,
            )
            .merge(
                stateProperties.renderingDetails.chartTheme.dataLabelTextStyle)
            .merge(dataLabel.textStyle);
        dataLabelSettingsRenderer.textStyle = dataLabelStyle;
        textSize = seriesRenderer.series.dataLabelSettings.builder != null
            ? point.dataLabelSize
            : measureText(label!, dataLabelStyle);
        labelLocation = Offset(
            rect.left +
                (point.renderPosition == ChartDataLabelPosition.inside
                    ? labelPadding
                    : margin.left),
            rect.top + rect.height / 2 - textSize.height / 2);
        const String defaultConnectorLineLength = '10%';
        point.trimmedText = point.text;
        Path shiftedConnectorPath = Path();
        final num connectorLength = percentToValue(
            seriesRenderer.dataLabelSettingsRenderer.dataLabelSettings
                    .connectorLineSettings.length ??
                defaultConnectorLineLength,
            point.outerRadius!)!;
        final Offset startPoint = degreeToPoint(
            (point.startAngle! + point.endAngle!) / 2,
            point.outerRadius!,
            point.center!);
        final Offset endPoint = degreeToPoint(PointHelper.getNewAngle(point)!,
            point.outerRadius! + connectorLength, point.center!);
        shiftedConnectorPath.moveTo(startPoint.dx, startPoint.dy);
        if (seriesRenderer.dataLabelSettingsRenderer.dataLabelSettings
                .connectorLineSettings.type ==
            ConnectorType.line) {
          shiftedConnectorPath.lineTo(endPoint.dx, endPoint.dy);
        }
        getDataLabelRect(
            point.dataLabelPosition,
            seriesRenderer.dataLabelSettingsRenderer.dataLabelSettings
                .connectorLineSettings.type,
            margin,
            shiftedConnectorPath,
            endPoint,
            textSize);
        final ChartLocation midAngle = getPerpendicularDistance(
            ChartLocation(startPoint.dx, startPoint.dy), point);
        if (seriesRenderer.dataLabelSettingsRenderer.dataLabelSettings
                    .connectorLineSettings.type ==
                ConnectorType.curve &&
            PointHelper.getLabelUpdated(point) == 1) {
          const int spacing = 10;
          shiftedConnectorPath = Path();
          shiftedConnectorPath.moveTo(startPoint.dx, startPoint.dy);
          shiftedConnectorPath.quadraticBezierTo(
              midAngle.x,
              midAngle.y,
              endPoint.dx -
                  (point.dataLabelPosition == Position.left
                      ? spacing
                      : -spacing),
              endPoint.dy);
        }
        final Rect containerRect =
            stateProperties.renderingDetails.chartAreaRect;
        if (containerRect.left > rect.left) {
          labelLocation = Offset(containerRect.left,
              rect.top + rect.height / 2 - textSize.height / 2);
        }
        if (point.labelRect.left < containerRect.left &&
            point.renderPosition == ChartDataLabelPosition.outside) {
          point.trimmedText = getTrimmedText(point.trimmedText!,
              point.labelRect.right - containerRect.left, dataLabelStyle,
              isRtl: stateProperties.isRtl);
        }
        if (point.labelRect.right > containerRect.right &&
            point.renderPosition == ChartDataLabelPosition.outside) {
          point.trimmedText = getTrimmedText(point.trimmedText!,
              containerRect.right - point.labelRect.left, dataLabelStyle,
              isRtl: stateProperties.isRtl);
        }
        if (point.trimmedText != '' &&
            !isOverlapWithPrevious(
                point, seriesRenderer.renderPoints!, pointIndex) &&
            rect != Rect.zero) {
          drawLabel(
              rect,
              labelLocation,
              point.trimmedText!,
              point.renderPosition == ChartDataLabelPosition.outside
                  ? shiftedConnectorPath
                  : Path(),
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
    }
  }
}

/// To set data label position.
void setLabelPosition(
    DataLabelSettings dataLabel,
    ChartPoint<dynamic> point,
    Size textSize,
    CircularStateProperties stateProperties,
    Canvas canvas,
    List<Rect> renderDataLabelRegions,
    int pointIndex,
    String label,
    CircularSeriesRendererExtension seriesRenderer,
    double animateOpacity,
    TextStyle dataLabelStyle,
    int seriesIndex) {
  final DataLabelSettingsRenderer dataLabelSettingsRenderer =
      seriesRenderer.dataLabelSettingsRenderer;
  final SfCircularChart chart = stateProperties.chart;
  final num angle = dataLabel.angle;
  Offset labelLocation;
  const int labelPadding = 2;
  if (dataLabel.labelPosition == ChartDataLabelPosition.inside) {
    labelLocation = degreeToPoint(point.midAngle!,
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
    bool isDataLabelCollide =
        findingCollision(point.labelRect, renderDataLabelRegions);
    point.overflowTrimmedText = point.overflowTrimmedText ?? label;
    if (dataLabel.overflowMode == OverflowMode.shift) {
      final String labelText = _getSegmentOverflowTrimmedText(
          point.text!,
          textSize,
          point,
          point.labelRect,
          stateProperties,
          labelLocation,
          dataLabelStyle,
          dataLabel.overflowMode);
      if (labelText.contains('...') || labelText.isEmpty) {
        isDataLabelCollide = true;
        point.renderPosition = ChartDataLabelPosition.outside;
      }
      point.text = isDataLabelCollide ? point.text : labelText;
    } else if (dataLabel.overflowMode == OverflowMode.trim &&
        !point.text!.contains('...')) {
      point.text = _getSegmentOverflowTrimmedText(
          point.text!,
          textSize,
          point,
          point.labelRect,
          stateProperties,
          labelLocation,
          dataLabelStyle,
          dataLabel.overflowMode);
      label = point.text!;
      final Size trimmedTextSize = measureText(label, dataLabelStyle);
      labelLocation = degreeToPoint(point.midAngle!,
          (point.innerRadius! + point.outerRadius!) / 2, point.center!);
      labelLocation = Offset(
          labelLocation.dx -
              (trimmedTextSize.width / 2) +
              (angle == 0 ? 0 : trimmedTextSize.width / 2),
          labelLocation.dy -
              (trimmedTextSize.height / 2) +
              (angle == 0 ? 0 : trimmedTextSize.height / 2));
      point.labelRect = Rect.fromLTWH(
          labelLocation.dx - labelPadding,
          labelLocation.dy - labelPadding,
          trimmedTextSize.width + (2 * labelPadding),
          trimmedTextSize.height + (2 * labelPadding));
    }
    final TextStyle textStyle = dataLabelStyle.copyWith(
      color: _isCustomTextColor(dataLabel.textStyle,
              stateProperties.renderingDetails.chartTheme.dataLabelTextStyle)
          ? dataLabelStyle.color
          : getSaturationColor(
              findthemecolor(stateProperties, point, dataLabel)),
    );
    if (seriesRenderer.series.dataLabelSettings.labelIntersectAction ==
            LabelIntersectAction.shift &&
        isDataLabelCollide &&
        dataLabel.overflowMode != OverflowMode.trim) {
      point.saturationRegionOutside = true;
      point.renderPosition = ChartDataLabelPosition.outside;
      dataLabelStyle = textStyle;
      renderOutsideDataLabel(
          canvas,
          label,
          point,
          textSize,
          pointIndex,
          seriesRenderer,
          seriesIndex,
          stateProperties,
          dataLabelStyle,
          renderDataLabelRegions,
          animateOpacity);
    } else if (((dataLabel.labelIntersectAction == LabelIntersectAction.shift &&
                dataLabel.overflowMode == OverflowMode.none) &&
            isDataLabelCollide &&
            dataLabel.overflowMode != OverflowMode.trim) ||
        (isDataLabelCollide && dataLabel.overflowMode == OverflowMode.shift)) {
      point.saturationRegionOutside = true;
      point.renderPosition = ChartDataLabelPosition.outside;
      dataLabelStyle = textStyle;
      renderOutsideDataLabel(
          canvas,
          label,
          point,
          textSize,
          pointIndex,
          seriesRenderer,
          seriesIndex,
          stateProperties,
          dataLabelStyle,
          renderDataLabelRegions,
          animateOpacity);
    } else if (!isDataLabelCollide ||
        (dataLabel.labelIntersectAction == LabelIntersectAction.none &&
            dataLabel.overflowMode == OverflowMode.none)) {
      point.renderPosition = ChartDataLabelPosition.inside;
      if (dataLabel.builder == null) {
        dataLabelStyle = dataLabelStyle.copyWith(
            color: (chart.onDataLabelRender != null &&
                    dataLabelSettingsRenderer.color != null)
                ? getSaturationColor(
                    dataLabelSettingsRenderer.color ?? point.fill)
                : _isCustomTextColor(
                        dataLabel.textStyle,
                        stateProperties
                            .renderingDetails.chartTheme.dataLabelTextStyle)
                    ? dataLabelStyle.color
                    : getSaturationColor(
                        dataLabelSettingsRenderer.color ?? point.fill));
      }
      if (!isDataLabelCollide &&
          (dataLabel.labelIntersectAction == LabelIntersectAction.shift &&
              dataLabel.overflowMode != OverflowMode.hide)) {
        renderDataLabelRegions.add(point.labelRect);
      } else if (!isDataLabelCollide &&
          (dataLabel.labelIntersectAction == LabelIntersectAction.hide ||
              dataLabel.overflowMode == OverflowMode.hide)) {
        if (point.renderPosition == ChartDataLabelPosition.inside &&
            (dataLabel.overflowMode == OverflowMode.hide)) {
          point.text = _getSegmentOverflowTrimmedText(
              point.text!,
              textSize,
              point,
              point.labelRect,
              stateProperties,
              labelLocation,
              dataLabelStyle,
              dataLabel.overflowMode);
          label = point.text!;
        }
        drawLabel(
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
        drawLabel(
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
    if (dataLabel.builder == null) {
      dataLabelStyle = dataLabelStyle.copyWith(
        color: _isCustomTextColor(dataLabel.textStyle,
                stateProperties.renderingDetails.chartTheme.dataLabelTextStyle)
            ? dataLabelStyle.color
            : getSaturationColor(
                findthemecolor(stateProperties, point, dataLabel)),
      );
    }
    renderOutsideDataLabel(
        canvas,
        label,
        point,
        textSize,
        pointIndex,
        seriesRenderer,
        seriesIndex,
        stateProperties,
        dataLabelStyle,
        renderDataLabelRegions,
        animateOpacity);
  }
}

bool _isCustomTextColor(TextStyle? textStyle, TextStyle? themeStyle) {
  return textStyle?.color != null || themeStyle?.color != null;
}

/// To render outside positioned data labels.
void renderOutsideDataLabel(
    Canvas canvas,
    String label,
    ChartPoint<dynamic> point,
    Size textSize,
    int pointIndex,
    CircularSeriesRendererExtension seriesRenderer,
    int seriesIndex,
    CircularStateProperties stateProperties,
    TextStyle textStyle,
    List<Rect> renderDataLabelRegions,
    double animateOpacity) {
  Path connectorPath;
  Rect? rect;
  Offset labelLocation;
  const String defaultConnectorLineLength = '10%';
  final EdgeInsets margin = seriesRenderer.series.dataLabelSettings.margin;
  final ConnectorLineSettings connector =
      seriesRenderer.series.dataLabelSettings.connectorLineSettings;
  connectorPath = Path();
  final num connectorLength = percentToValue(
      connector.length ?? defaultConnectorLineLength, point.outerRadius!)!;
  final Offset startPoint =
      degreeToPoint(point.midAngle!, point.outerRadius!, point.center!);
  final Offset endPoint = degreeToPoint(
      point.midAngle!, point.outerRadius! + connectorLength, point.center!);
  connectorPath.moveTo(startPoint.dx, startPoint.dy);
  if (connector.type == ConnectorType.line) {
    connectorPath.lineTo(endPoint.dx, endPoint.dy);
  }
  if (seriesRenderer.series.dataLabelSettings.builder != null) {
    final int pointIndex = seriesRenderer
        .stateProperties.renderingDetails.templates
        .indexWhere((ChartTemplateInfo templateInfo) =>
            templateInfo.pointIndex == point.index);
    // Checks template for avoid the hidden data point and calculate the label location based on template size.
    if (pointIndex != -1) {
      textSize = seriesRenderer.stateProperties.renderingDetails
          .dataLabelTemplateRegions[pointIndex].size;
    }
  }
  rect = getDataLabelRect(
      point.dataLabelPosition,
      connector.type,
      margin,
      connectorPath,
      endPoint,
      textSize,
      // To avoid the extra padding added to the exact template size.
      seriesRenderer.series.dataLabelSettings.builder != null
          ? seriesRenderer.series.dataLabelSettings
          : null);
  point.labelRect = rect!;
  labelLocation = Offset(rect.left + margin.left,
      rect.top + rect.height / 2 - textSize.height / 2);
  final Rect containerRect = stateProperties.renderingDetails.chartAreaRect;
  if (seriesRenderer.series.dataLabelSettings.builder == null) {
    if (seriesRenderer.series.dataLabelSettings.labelIntersectAction ==
        LabelIntersectAction.hide) {
      if (!findingCollision(rect, renderDataLabelRegions) &&
          (rect.left > containerRect.left &&
              rect.left + rect.width <
                  containerRect.left + containerRect.width) &&
          rect.top > containerRect.top &&
          rect.top + rect.height < containerRect.top + containerRect.height) {
        drawLabel(
            rect,
            labelLocation,
            label,
            connectorPath,
            canvas,
            seriesRenderer,
            point,
            pointIndex,
            seriesIndex,
            stateProperties.chart,
            textStyle,
            renderDataLabelRegions,
            animateOpacity);
      }
    } else if (seriesRenderer.series.dataLabelSettings.labelIntersectAction ==
        LabelIntersectAction.shift) {
      renderDataLabelRegions.add(rect);
    } else {
      drawLabel(
          rect,
          labelLocation,
          label,
          connectorPath,
          canvas,
          seriesRenderer,
          point,
          pointIndex,
          seriesIndex,
          stateProperties.chart,
          textStyle,
          renderDataLabelRegions,
          animateOpacity);
    }
  } else {
    if (seriesRenderer.series.dataLabelSettings.labelIntersectAction !=
        LabelIntersectAction.shift) {
      if (textSize != Size.zero) {
        _drawConnectorLine(labelLocation, connectorPath, canvas, seriesRenderer,
            point, animateOpacity, seriesRenderer.series.dataLabelSettings);
      }
    }
  }
}

/// To draw label.
void drawLabel(
    Rect labelRect,
    Offset location,
    String label,
    Path? connectorPath,
    Canvas canvas,
    CircularSeriesRendererExtension seriesRenderer,
    ChartPoint<dynamic> point,
    int pointIndex,
    int seriesIndex,
    SfCircularChart chart,
    TextStyle textStyle,
    List<Rect> renderDataLabelRegions,
    double animateOpacity) {
  Paint rectPaint;
  final DataLabelSettings dataLabel = seriesRenderer.series.dataLabelSettings;
  final DataLabelSettingsRenderer dataLabelSettingsRenderer =
      seriesRenderer.dataLabelSettingsRenderer;
  if (connectorPath != null) {
    _drawConnectorLine(location, connectorPath, canvas, seriesRenderer, point,
        animateOpacity, dataLabel);
  }

  if (dataLabel.builder == null) {
    final double strokeWidth = seriesRenderer.renderer.getDataLabelStrokeWidth(
        seriesRenderer, point, pointIndex, seriesIndex, dataLabel.borderWidth);
    final Color? labelFill = seriesRenderer.renderer.getDataLabelColor(
        seriesRenderer,
        point,
        pointIndex,
        seriesIndex,
        dataLabelSettingsRenderer.color ??
            (dataLabel.useSeriesColor
                ? point.fill
                : dataLabelSettingsRenderer.color));
    final Color strokeColor = seriesRenderer.renderer.getDataLabelStrokeColor(
        seriesRenderer,
        point,
        pointIndex,
        seriesIndex,
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
    drawText(canvas, label, location, textStyle, dataLabel.angle);
    if (seriesRenderer.series.dataLabelSettings.labelIntersectAction !=
        LabelIntersectAction.shift) {
      renderDataLabelRegions.add(labelRect);
    }
  }
}

/// Method to trigger the data label event.
void triggerCircularDataLabelEvent(
    SfCircularChart chart,
    CircularSeriesRendererExtension seriesRenderer,
    CircularStateProperties stateProperties,
    Offset? position) {
  const int seriesIndex = 0;
  final DataLabelSettings dataLabel = seriesRenderer.series.dataLabelSettings;
  Offset labelLocation;
  num connectorLength;
  ChartPoint<dynamic> point;
  const String defaultConnectorLineLength = '10%';
  for (int index = 0; index < seriesRenderer.dataPoints.length; index++) {
    point = seriesRenderer.dataPoints[index];
    if (dataLabel.isVisible &&
        // ignore: unnecessary_null_comparison
        seriesRenderer.dataPoints[index].labelRect != null &&
        position != null &&
        seriesRenderer.dataPoints[index].labelRect.contains(position)) {
      if (dataLabel.labelPosition == ChartDataLabelPosition.inside) {
        labelLocation = degreeToPoint(point.midAngle!,
            (point.innerRadius! + point.outerRadius!) / 2, point.center!);
        position = Offset(labelLocation.dx, labelLocation.dy);
      } else {
        connectorLength = percentToValue(
            dataLabel.connectorLineSettings.length ??
                defaultConnectorLineLength,
            point.outerRadius!)!;
        labelLocation = degreeToPoint(point.midAngle!,
            point.outerRadius! + connectorLength, point.center!);
        position = Offset(labelLocation.dx, labelLocation.dy);
      }
      if (chart.onDataLabelTapped != null) {
        dataLabelTapEvent(chart, seriesRenderer.series.dataLabelSettings, index,
            point, position, seriesIndex);
      }
    }
  }
}

/// To draw data label rect
void drawLabelRect(
        Paint paint, Rect labelRect, double borderRadius, Canvas canvas) =>
    canvas.drawRRect(
        RRect.fromRectAndRadius(labelRect, Radius.circular(borderRadius)),
        paint);

/// To find data label position.
void findDataLabelPosition(ChartPoint<dynamic> point) {
  point.midAngle =
      point.midAngle! > 360 ? point.midAngle! - 360 : point.midAngle!;
  point.dataLabelPosition = ((point.midAngle! >= -90 && point.midAngle! < 0) ||
          (point.midAngle! >= 0 && point.midAngle! < 90) ||
          (point.midAngle! >= 270))
      ? Position.right
      : Position.left;
}

/// Method for setting color to data label.
Color findthemecolor(CircularStateProperties stateProperties,
    ChartPoint<dynamic> point, DataLabelSettings dataLabel) {
  return dataLabel.color ??
      (dataLabel.useSeriesColor
          ? point.fill
          : (stateProperties.chart.backgroundColor ??
              (stateProperties.renderingDetails.chartTheme.brightness ==
                      Brightness.light
                  ? Colors.white
                  : Colors.black)));
}

/// Method to get a text when the text overlap with another segment/slice.
String _getSegmentOverflowTrimmedText(
    String datalabelText,
    Size size,
    ChartPoint<dynamic> point,
    Rect labelRect,
    CircularStateProperties chartState,
    Offset labelLocation,
    TextStyle dataLabelStyle,
    OverflowMode action) {
  const int index = 0;
  bool isTextWithinRegion;
  const String ellipse = '...';
  const int minCharacterLength = 3;
  // To reduce the additional padding around label rects
  // ignore: prefer_const_declarations
  final double labelPadding = kIsWeb ? 4 : 2;

  final bool labelLeftEnd = _isInsideSegment(
      point.labelRect.centerLeft - Offset(labelPadding, 0),
      chartState.centerLocation,
      point.outerRadius!,
      point.startAngle!,
      point.endAngle!);

  final bool labelRightEnd = _isInsideSegment(
      point.labelRect.centerRight - Offset(labelPadding, 0),
      chartState.centerLocation,
      point.outerRadius!,
      point.startAngle!,
      point.endAngle!);

  if (labelLeftEnd && labelRightEnd) {
    return datalabelText;
  } else {
    isTextWithinRegion = false;
    while (!isTextWithinRegion) {
      if (action == OverflowMode.trim) {
        if (datalabelText == '') {
          break;
        }
        if (datalabelText.length > minCharacterLength)
          datalabelText = addEllipse(
              datalabelText, datalabelText.length, ellipse,
              isRtl: chartState.isRtl);
        else {
          datalabelText = '';
          break;
        }
        if (datalabelText == ellipse) {
          datalabelText = '';
          break;
        }
        const num labelPadding = 0;
        final Size trimSize = measureText(datalabelText, dataLabelStyle);
        Offset trimmedlabelLocation = degreeToPoint(point.midAngle!,
            (point.innerRadius! + point.outerRadius!) / 2, point.center!);
        trimmedlabelLocation = Offset(
            (trimmedlabelLocation.dx - trimSize.width - 5) +
                (chartState.chartSeries.visibleSeriesRenderers[index].series
                            .dataLabelSettings.angle ==
                        0
                    ? 0
                    : trimSize.width / 2),
            (trimmedlabelLocation.dy - trimSize.height / 2) +
                (chartState.chartSeries.visibleSeriesRenderers[index].series
                            .dataLabelSettings.angle ==
                        0
                    ? 0
                    : trimSize.height / 2));
        final Rect trimmedlabelRect = Rect.fromLTWH(
            trimmedlabelLocation.dx - labelPadding,
            trimmedlabelLocation.dy - labelPadding,
            trimSize.width + (2 * labelPadding),
            trimSize.height + (2 * labelPadding));

        final bool trimmedLeftEnd = _isInsideSegment(
            trimmedlabelRect.centerLeft,
            chartState.centerLocation,
            point.outerRadius!,
            point.startAngle!,
            point.endAngle!);

        final bool trimmedRightEnd = _isInsideSegment(
            trimmedlabelRect.centerRight,
            chartState.centerLocation,
            point.outerRadius!,
            point.startAngle!,
            point.endAngle!);
        if (trimmedLeftEnd && trimmedRightEnd) {
          isTextWithinRegion = true;
          point.labelRect = trimmedlabelRect;
        }
      } else {
        datalabelText = '';
        isTextWithinRegion = true;
        break;
      }
    }
  }
  return datalabelText;
}

/// Method to check if a label is inside the point region based on the angle for pie and doughnut series.
bool _isInsideSegment(
    Offset point, Offset center, num radius, num start, num end) {
  final Offset labelOffset = point - center;

  final double labelRadius = labelOffset.distance;

  if (labelRadius < radius) {
    final num originAngle =
        math.atan2(-labelOffset.dy, labelOffset.dx) * 180 / math.pi;

    num labelAngle;

    labelAngle = 360 - originAngle;

    if (labelAngle > 270) {
      labelAngle -= 360;
    }
    labelAngle = labelAngle.round();

    return labelAngle >= start && labelAngle <= end;
  } else {
    return false;
  }
}

/// Method to render a connected line
void _drawConnectorLine(
    Offset location,
    Path connectorPath,
    Canvas canvas,
    CircularSeriesRendererExtension seriesRenderer,
    ChartPoint<dynamic> point,
    double animateOpacity,
    DataLabelSettings dataLabel) {
  final ConnectorLineSettings line = dataLabel.connectorLineSettings;
  if (dataLabel.builder != null) {
    final List<Rect> datalabelTemplate = seriesRenderer
        .stateProperties.renderingDetails.dataLabelTemplateRegions;
    if (isTemplateWithinBounds(
            seriesRenderer.stateProperties.renderingDetails.chartAreaRect,
            point.labelRect) &&
        // Decide to render or ignore the empty point label connected line.
        (point.y != 0 || dataLabel.showZeroValue)) {
      final List<ChartTemplateInfo> templates =
          seriesRenderer.stateProperties.renderingDetails.templates;
      if (seriesRenderer.dataLabelSettingsRenderer.dataLabelSettings
              .labelIntersectAction ==
          LabelIntersectAction.hide) {
        for (int i = 0; i < templates.length; i++) {
          // Here we have used the templates due to iterating the points leads to non initialized error.
          // When the point get hidden by the legend toggle then the information of the point is not stored.
          if (templates[i].pointIndex == point.index &&
              datalabelTemplate[i] != Rect.zero) {
            _drawConnectedPath(
                canvas, connectorPath, line, point, animateOpacity);
          }
        }
      } else {
        // This is for the shift and none interaction type connected line.
        _drawConnectedPath(canvas, connectorPath, line, point, animateOpacity);
      }
    }
  } else {
    _drawConnectedPath(canvas, connectorPath, line, point, animateOpacity);
  }
}

/// To shift the data label template in the circular chart.
void shiftCircularDataLabelTemplate(
    CircularSeriesRendererExtension seriesRenderer,
    CircularStateProperties stateProperties,
    List<Rect> rectSize) {
  leftPoints = <ChartPoint<dynamic>>[];
  rightPoints = <ChartPoint<dynamic>>[];
  final List<Rect> renderDataLabelRegions = <Rect>[];
  const int labelPadding = 2;
  final List<ChartTemplateInfo> templates =
      seriesRenderer.stateProperties.renderingDetails.templates;
  for (int i = 0; i < templates.length; i++) {
    final ChartPoint<dynamic> point =
        seriesRenderer.renderPoints![templates[i].pointIndex!];
    if (PointHelper.getNewAngle(point) == null &&
        point.isVisible &&
        templates[i].templateType == 'DataLabel') {
      // For the data label position is inside.
      if (seriesRenderer.series.dataLabelSettings.labelPosition ==
          ChartDataLabelPosition.inside) {
        Offset labelLocation = degreeToPoint(point.midAngle!,
            (point.innerRadius! + point.outerRadius!) / 2, point.center!);
        labelLocation = Offset(labelLocation.dx - (rectSize[i].width / 2),
            labelLocation.dy - (rectSize[i].height / 2));
        final Rect rect = Rect.fromLTWH(
            labelLocation.dx - labelPadding,
            labelLocation.dy - labelPadding,
            rectSize[i].width + (2 * labelPadding),
            rectSize[i].height + (2 * labelPadding));
        // If collide with label when the position is inside calculate the outside rect value of that perticular label.
        if (findingCollision(rect, renderDataLabelRegions)) {
          _renderOutsideDataLabelTemplate(
              point, seriesRenderer, rectSize[i].size, renderDataLabelRegions);
        } else {
          point.renderPosition = ChartDataLabelPosition.inside;
          point.labelRect = rect;
          // Stored the region of template rect to compare with next label.
          renderDataLabelRegions.add(rect);
        }
      } else if (seriesRenderer.series.dataLabelSettings.labelPosition ==
          ChartDataLabelPosition.outside) {
        _renderOutsideDataLabelTemplate(
            point, seriesRenderer, rectSize[i].size, renderDataLabelRegions);
      }
    }
  }
  for (int i = 0; i < seriesRenderer.renderPoints!.length; i++) {
    if (seriesRenderer.renderPoints![i].isVisible) {
      PointHelper.setNewAngle(seriesRenderer.renderPoints![i],
          seriesRenderer.renderPoints![i].midAngle);
      if (seriesRenderer.renderPoints![i].dataLabelPosition == Position.left &&
          seriesRenderer.renderPoints![i].renderPosition ==
              ChartDataLabelPosition.outside) {
        leftPoints.add(seriesRenderer.renderPoints![i]);
      } else if (seriesRenderer.renderPoints![i].dataLabelPosition ==
              Position.right &&
          seriesRenderer.renderPoints![i].renderPosition ==
              ChartDataLabelPosition.outside) {
        rightPoints.add(seriesRenderer.renderPoints![i]);
      }
    }
  }
  leftPoints.sort((ChartPoint<dynamic> a, ChartPoint<dynamic> b) =>
      PointHelper.getNewAngle(a)!.compareTo(PointHelper.getNewAngle(b)!));
  isIncreaseAngle = false;
  if (leftPoints.isNotEmpty) {
    _arrangeLeftSidePoints(seriesRenderer);
  }
  isIncreaseAngle = false;
  if (rightPoints.isNotEmpty) {
    _arrangeRightSidePoints(seriesRenderer);
  }
}

// Calculate the data label rectangle value when the data label template
// position is outside and it consider the outer radius.
void _renderOutsideDataLabelTemplate(
    ChartPoint<dynamic> point,
    CircularSeriesRendererExtension seriesRenderer,
    Size templateSize,
    List<Rect> renderDataLabelRegion) {
  point.renderPosition = ChartDataLabelPosition.outside;
  const String defaultConnectorLineLength = '10%';
  final EdgeInsets margin = seriesRenderer.series.dataLabelSettings.margin;
  final ConnectorLineSettings connector =
      seriesRenderer.series.dataLabelSettings.connectorLineSettings;
  final Path connectorPath = Path();
  final num connectorLength = percentToValue(
      connector.length ?? defaultConnectorLineLength, point.outerRadius!)!;
  final Offset startPoint =
      degreeToPoint(point.midAngle!, point.outerRadius!, point.center!);
  final Offset endPoint = degreeToPoint(
      point.midAngle!, point.outerRadius! + connectorLength, point.center!);
  connectorPath.moveTo(startPoint.dx, startPoint.dy);
  if (connector.type == ConnectorType.line) {
    connectorPath.lineTo(endPoint.dx, endPoint.dy);
  }
  point.dataLabelSize = templateSize;
  final Rect rect = getDataLabelRect(point.dataLabelPosition, connector.type,
      margin, connectorPath, endPoint, templateSize)!;
  point.labelRect = rect;
  renderDataLabelRegion.add(rect);
}

void _drawConnectedPath(
    Canvas canvas,
    Path connectorPath,
    ConnectorLineSettings line,
    ChartPoint<dynamic> point,
    double animateOpacity) {
  canvas.drawPath(
      connectorPath,
      Paint()
        ..color = line.width <= 0
            ? Colors.transparent
            : line.color ?? point.fill.withOpacity(animateOpacity)
        ..strokeWidth = line.width
        ..style = PaintingStyle.stroke);
}
