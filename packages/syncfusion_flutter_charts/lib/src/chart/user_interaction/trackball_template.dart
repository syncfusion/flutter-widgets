import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../charts.dart';

import '../../common/rendering_details.dart';
import '../common/cartesian_state_properties.dart';
import '../common/interactive_tooltip.dart';
import 'trackball.dart';
import 'trackball_painter.dart';

/// Widget class which is used to display the trackball template.
class TrackballTemplate extends StatefulWidget {
  /// Creates an instance of trackball template.
  const TrackballTemplate(
      {required Key key,
      required this.stateProperties,
      required this.trackballBehavior})
      : super(key: key);

  /// Specifies the value of cartesian state properties.
  final CartesianStateProperties stateProperties;

  /// Holds the value of trackball behavior.
  final TrackballBehavior trackballBehavior;

  @override
  State<StatefulWidget> createState() {
    return TrackballTemplateState();
  }
}

/// Represents the trackball template state.
class TrackballTemplateState extends State<TrackballTemplate> {
  bool _isRender = false;

  //ignore: unused_field
  late TrackballTemplateState _state;

  /// Holds the chart point info.
  List<ChartPointInfo>? chartPointInfo;

  /// Holds the list of marker shapes.
  List<Path>? markerShapes;

  /// Holds the value of trackball grouping mode info.
  late TrackballGroupingModeInfo groupingModeInfo;
  late Widget _template;

  /// Specifies the trackball duration value.
  //ignore: unused_field
  late double duration;

  /// Specifies whether to show the trackball always.
  bool? alwaysShow;

  bool _isRangeSeries = false, _isBoxSeries = false;

  @override
  void initState() {
    _state = this;
    super.initState();
  }

  @override
  void didUpdateWidget(TrackballTemplate oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Widget trackballWidget;
    final List<Widget> trackballWidgets = <Widget>[];
    _state = this;
    String seriesType;
    if (_isRender &&
        widget.stateProperties.animationCompleted &&
        chartPointInfo != null &&
        chartPointInfo!.isNotEmpty) {
      for (int index = 0; index < chartPointInfo!.length; index++) {
        seriesType = chartPointInfo![index].seriesRendererDetails!.seriesType;
        _isRangeSeries = seriesType.contains('range') ||
            seriesType.contains('hilo') ||
            seriesType == 'candle';
        _isBoxSeries = seriesType == 'boxandwhisker';
        if (widget.trackballBehavior.tooltipDisplayMode ==
            TrackballDisplayMode.groupAllPoints) {
          _template = widget.trackballBehavior.builder!(context,
              TrackballDetails(null, null, null, null, groupingModeInfo));
          trackballWidget = _TrackballRenderObject(
              template: _template,
              stateProperties: widget.stateProperties,
              xPos: chartPointInfo![index].xPosition!,
              yPos: (_isRangeSeries
                  ? chartPointInfo![index].highYPosition
                  : _isBoxSeries
                      ? chartPointInfo![index].maxYPosition
                      : chartPointInfo![index].yPosition)!,
              trackballBehavior: widget.trackballBehavior,
              child: _template);

          trackballWidgets.add(trackballWidget);

          break;
        } else if (widget.trackballBehavior.tooltipDisplayMode !=
            TrackballDisplayMode.none) {
          _template = widget.trackballBehavior.builder!(
              context,
              TrackballDetails(
                  chartPointInfo![index].seriesRendererDetails!.seriesType ==
                          'fastline'
                      ? chartPointInfo![index]
                              .seriesRendererDetails!
                              .sampledDataPoints[
                          chartPointInfo![index].dataPointIndex!]
                      : chartPointInfo![index]
                          .seriesRendererDetails!
                          .dataPoints[chartPointInfo![index].dataPointIndex!],
                  chartPointInfo![index].seriesRendererDetails!.series,
                  chartPointInfo![index].dataPointIndex,
                  chartPointInfo![index].seriesIndex));

          trackballWidget = _TrackballRenderObject(
              template: _template,
              stateProperties: widget.stateProperties,
              xPos: chartPointInfo![index].xPosition!,
              yPos: (_isRangeSeries
                  ? chartPointInfo![index].highYPosition
                  : _isBoxSeries
                      ? chartPointInfo![index].maxYPosition
                      : chartPointInfo![index].yPosition)!,
              trackballBehavior: widget.trackballBehavior,
              chartPointInfo: chartPointInfo!,
              index: index,
              child: _template);

          trackballWidgets.add(trackballWidget);
        }
      }
      return Stack(children: <Widget>[
        CustomPaint(
            painter: TracklinePainter(widget.trackballBehavior,
                widget.stateProperties, chartPointInfo, markerShapes)),
        Stack(children: trackballWidgets),
      ]);
    } else {
      trackballWidget = Container();
      return trackballWidget;
    }
  }

  /// Notify the object changes to framework.
  void refresh() {
    setState(() {
      _isRender = true;
    });
  }

  /// To hide tooltip templates.
  void hideTrackballTemplate() {
    if (mounted && alwaysShow != null && !alwaysShow!) {
      setState(() {
        _isRender = false;
      });
    }
  }
}

@immutable
class _TrackballRenderObject extends SingleChildRenderObjectWidget {
  const _TrackballRenderObject(
      {Key? key,
      required Widget child,
      required this.template,
      required this.stateProperties,
      required this.xPos,
      required this.yPos,
      required this.trackballBehavior,
      this.chartPointInfo,
      this.index})
      : super(key: key, child: child);

  final Widget template;
  final int? index;
  final CartesianStateProperties stateProperties;
  final List<ChartPointInfo>? chartPointInfo;
  final double xPos;
  final double yPos;
  final TrackballBehavior trackballBehavior;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return TrackballTemplateRenderBox(
        template, stateProperties, xPos, yPos, chartPointInfo, index);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant TrackballTemplateRenderBox renderBox) {
    renderBox.template = template;
    renderBox.index = index;
    renderBox.xPos = xPos;
    renderBox.yPos = yPos;
    renderBox.chartPointInfo = chartPointInfo;
  }
}

/// Render the annotation widget in the respective position.
class TrackballTemplateRenderBox extends RenderShiftedBox {
  /// Creates an instance of trackball template render box.
  TrackballTemplateRenderBox(
      this._template, this.stateProperties, this.xPos, this.yPos,
      [this.chartPointInfo, this.index, RenderBox? child])
      : super(child);

  Widget _template;

  /// Holds the value of cartesian state properties.
  final CartesianStateProperties stateProperties;

  /// Holds the value of x and y position.
  double xPos, yPos;

  /// Specifies the list of chart point info.
  List<ChartPointInfo>? chartPointInfo;

  /// Holds the value of index.
  int? index;

  /// Holds the value of pointer length and pointer width respectively.
  late double pointerLength, pointerWidth;

  /// Holds the value of trackball template rect.
  Rect? trackballTemplateRect;

  /// Holds the value of boundary rect.
  late Rect boundaryRect;

  /// Specifies the value of padding.
  num padding = 10;

  /// Specifies the value of trackball behavior.
  late TrackballBehavior trackballBehavior;

  /// Specifies whether to group all the points.
  bool isGroupAllPoints = false;

  /// Specifies whether it is the nearest point.
  bool isNearestPoint = false;

  /// Gets the template widget.
  Widget get template => _template;

  /// Specifies whether tooltip is present at right.
  bool isRight = false;

  /// Specifies whether tooltip is present at bottom.
  bool isBottom = false;

  /// Specifies whether the template is present inside the bounds.
  bool isTemplateInBounds = true;
  // Offset arrowOffset;

  /// Holds the tooltip position.
  TooltipPositions? tooltipPosition;

  /// Holds the value of box parent data.
  late BoxParentData childParentData;

  /// Gets the trackball rendering details.
  TrackballRenderingDetails get trackballRenderingDetails =>
      TrackballHelper.getRenderingDetails(
          stateProperties.trackballBehaviorRenderer);

  /// Sets the template value.
  set template(Widget value) {
    if (_template != value) {
      _template = value;
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {
    trackballBehavior = stateProperties.chart.trackballBehavior;
    isGroupAllPoints = trackballBehavior.tooltipDisplayMode ==
        TrackballDisplayMode.groupAllPoints;
    isNearestPoint = trackballBehavior.tooltipDisplayMode ==
        TrackballDisplayMode.nearestPoint;
    final List<num>? tooltipTop = <num>[];
    final List<num> tooltipBottom = <num>[];
    final List<ClosestPoints> visiblePoints =
        trackballRenderingDetails.visiblePoints;
    final List<ChartAxisRenderer> xAxesInfo =
        trackballRenderingDetails.xAxesInfo;
    final List<ChartAxisRenderer> yAxesInfo =
        trackballRenderingDetails.yAxesInfo;
    boundaryRect = stateProperties.chartAxis.axisClipRect;
    final num totalWidth = boundaryRect.left + boundaryRect.width;
    tooltipPosition = trackballRenderingDetails.tooltipPosition;
    final bool isTrackballMarkerEnabled =
        trackballBehavior.markerSettings != null;
    final BoxConstraints constraints = this.constraints;
    pointerLength = trackballBehavior.tooltipSettings.arrowLength;
    pointerWidth = trackballBehavior.tooltipSettings.arrowWidth;
    double left, top;
    Offset? offset;
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(Size(child!.size.width, child!.size.height));
      if (child!.parentData is BoxParentData) {
        childParentData = child!.parentData as BoxParentData;

        if (isGroupAllPoints) {
          if (trackballBehavior.tooltipAlignment == ChartAlignment.center) {
            yPos = boundaryRect.center.dy - size.height / 2;
          } else if (trackballBehavior.tooltipAlignment ==
              ChartAlignment.near) {
            yPos = boundaryRect.top;
          } else {
            yPos = boundaryRect.bottom;
          }

          if (yPos + size.height > boundaryRect.bottom &&
              trackballBehavior.tooltipAlignment == ChartAlignment.far) {
            yPos = boundaryRect.bottom - size.height;
          }
        }
        if (chartPointInfo != null) {
          for (int index = 0; index < chartPointInfo!.length; index++) {
            tooltipTop!.add(stateProperties.requireInvertedAxis
                ? visiblePoints[index].closestPointX - (size.width / 2)
                : visiblePoints[index].closestPointY - size.height / 2);
            tooltipBottom.add(stateProperties.requireInvertedAxis
                ? visiblePoints[index].closestPointX + (size.width / 2)
                : visiblePoints[index].closestPointY + size.height / 2);
            xAxesInfo.add(chartPointInfo![index]
                .seriesRendererDetails!
                .xAxisDetails!
                .axisRenderer);
            yAxesInfo.add(chartPointInfo![index]
                .seriesRendererDetails!
                .yAxisDetails!
                .axisRenderer);
          }
        }
        if (tooltipTop != null && tooltipTop.isNotEmpty) {
          tooltipPosition = trackballRenderingDetails.smartTooltipPositions(
              tooltipTop,
              tooltipBottom,
              xAxesInfo,
              yAxesInfo,
              chartPointInfo!,
              stateProperties.requireInvertedAxis);
        }

        if (!isGroupAllPoints) {
          left = (stateProperties.requireInvertedAxis
                  ? tooltipPosition!.tooltipTop[index!]
                  : xPos +
                      padding +
                      (isTrackballMarkerEnabled
                          ? trackballBehavior.markerSettings!.width / 2
                          : 0))
              .toDouble();
          top = (stateProperties.requireInvertedAxis
                  ? yPos +
                      pointerLength +
                      (isTrackballMarkerEnabled
                          ? trackballBehavior.markerSettings!.width / 2
                          : 0)
                  : tooltipPosition!.tooltipTop[index!])
              .toDouble();

          if (isNearestPoint) {
            left = stateProperties.requireInvertedAxis
                ? xPos + size.width / 2
                : xPos +
                    padding +
                    (isTrackballMarkerEnabled
                        ? trackballBehavior.markerSettings!.width / 2
                        : 0);
            top = stateProperties.requireInvertedAxis
                ? yPos +
                    padding +
                    (isTrackballMarkerEnabled
                        ? trackballBehavior.markerSettings!.width / 2
                        : 0)
                : yPos - size.height / 2;
          }

          if (!stateProperties.requireInvertedAxis) {
            if (left + size.width > totalWidth) {
              isRight = true;
              left = xPos -
                  size.width -
                  pointerLength -
                  (isTrackballMarkerEnabled
                      ? (trackballBehavior.markerSettings!.width / 2)
                      : 0);
            } else {
              isRight = false;
            }
          } else {
            if (top + size.height > boundaryRect.bottom) {
              isBottom = true;
              top = yPos -
                  pointerLength -
                  size.height -
                  (isTrackballMarkerEnabled
                      ? (trackballBehavior.markerSettings!.height)
                      : 0);
            } else {
              isBottom = false;
            }
          }
          trackballTemplateRect =
              Rect.fromLTWH(left, top, size.width, size.height);
          double xPlotOffset = visiblePoints.first.closestPointX -
              trackballTemplateRect!.width / 2;
          final double rightTemplateEnd =
              xPlotOffset + trackballTemplateRect!.width;
          final double leftTemplateEnd = xPlotOffset;

          if (_isTemplateWithinBounds(
              boundaryRect, trackballTemplateRect!, offset)) {
            isTemplateInBounds = true;
            childParentData.offset = Offset(left, top);
          } else if (boundaryRect.width > trackballTemplateRect!.width &&
              boundaryRect.height > trackballTemplateRect!.height) {
            isTemplateInBounds = true;
            if (rightTemplateEnd > boundaryRect.right) {
              xPlotOffset =
                  xPlotOffset - (rightTemplateEnd - boundaryRect.right);
              if (xPlotOffset < boundaryRect.left) {
                xPlotOffset = xPlotOffset + (boundaryRect.left - xPlotOffset);
                if (xPlotOffset + trackballTemplateRect!.width >
                    boundaryRect.right) {
                  xPlotOffset = xPlotOffset -
                      (totalWidth +
                          trackballTemplateRect!.width -
                          boundaryRect.right);
                }
                if (xPlotOffset < boundaryRect.left ||
                    xPlotOffset > boundaryRect.right) {
                  isTemplateInBounds = false;
                }
              }
            } else if (leftTemplateEnd < boundaryRect.left) {
              xPlotOffset = xPlotOffset + (boundaryRect.left - leftTemplateEnd);
              if (xPlotOffset + trackballTemplateRect!.width >
                  boundaryRect.right) {
                xPlotOffset = xPlotOffset -
                    (totalWidth +
                        trackballTemplateRect!.width -
                        boundaryRect.right);
                if (xPlotOffset < boundaryRect.left) {
                  xPlotOffset = xPlotOffset + (boundaryRect.left - xPlotOffset);
                }
                if (xPlotOffset < boundaryRect.left ||
                    xPlotOffset + trackballTemplateRect!.width >
                        boundaryRect.right) {
                  isTemplateInBounds = false;
                }
              }
            }
            childParentData.offset = Offset(xPlotOffset, yPos);
          } else {
            child!.layout(constraints.copyWith(maxWidth: 0),
                parentUsesSize: true);
            isTemplateInBounds = false;
          }
        } else {
          if (xPos + size.width > totalWidth) {
            xPos = xPos -
                size.width -
                2 * padding -
                (isTrackballMarkerEnabled
                    ? trackballBehavior.markerSettings!.width / 2
                    : 0);
          }

          trackballTemplateRect =
              Rect.fromLTWH(xPos, yPos, size.width, size.height);
          double xPlotOffset = visiblePoints.first.closestPointX -
              trackballTemplateRect!.width / 2;
          final double rightTemplateEnd =
              xPlotOffset + trackballTemplateRect!.width;
          final double leftTemplateEnd = xPlotOffset;

          if (_isTemplateWithinBounds(
                  boundaryRect, trackballTemplateRect!, offset) &&
              (boundaryRect.right > trackballTemplateRect!.right &&
                  boundaryRect.left < trackballTemplateRect!.left)) {
            isTemplateInBounds = true;
            childParentData.offset = Offset(
                xPos +
                    (trackballTemplateRect!.right + padding > boundaryRect.right
                        ? trackballTemplateRect!.right +
                            padding -
                            boundaryRect.right
                        : padding) +
                    (isTrackballMarkerEnabled
                        ? trackballBehavior.markerSettings!.width / 2
                        : 0),
                yPos);
          } else if (boundaryRect.width > trackballTemplateRect!.width &&
              boundaryRect.height > trackballTemplateRect!.height) {
            isTemplateInBounds = true;
            if (rightTemplateEnd > boundaryRect.right) {
              xPlotOffset =
                  xPlotOffset - (rightTemplateEnd - boundaryRect.right);
              if (xPlotOffset < boundaryRect.left) {
                xPlotOffset = xPlotOffset + (boundaryRect.left - xPlotOffset);
                if (xPlotOffset + trackballTemplateRect!.width >
                    boundaryRect.right) {
                  xPlotOffset = xPlotOffset -
                      (totalWidth +
                          trackballTemplateRect!.width -
                          boundaryRect.right);
                }
                if (xPlotOffset < boundaryRect.left ||
                    xPlotOffset > boundaryRect.right) {
                  isTemplateInBounds = false;
                }
              }
            } else if (leftTemplateEnd < boundaryRect.left) {
              xPlotOffset = xPlotOffset + (boundaryRect.left - leftTemplateEnd);
              if (xPlotOffset + trackballTemplateRect!.width >
                  boundaryRect.right) {
                xPlotOffset = xPlotOffset -
                    (xPlotOffset +
                        trackballTemplateRect!.width -
                        boundaryRect.right);
                if (xPlotOffset < boundaryRect.left) {
                  xPlotOffset = xPlotOffset + (boundaryRect.left - xPlotOffset);
                }
                if (xPlotOffset < boundaryRect.left ||
                    xPlotOffset > boundaryRect.right) {
                  isTemplateInBounds = false;
                }
              }
            }
            childParentData.offset = Offset(xPlotOffset, yPos);
          } else {
            child!.layout(constraints.copyWith(maxWidth: 0),
                parentUsesSize: true);
            isTemplateInBounds = false;
          }
        }
      }
    } else {
      size = Size.zero;
    }
    if (!isGroupAllPoints && index == chartPointInfo!.length - 1) {
      tooltipTop?.clear();
      tooltipBottom.clear();
      yAxesInfo.clear();
      xAxesInfo.clear();
    }
  }

  /// To check template is within bounds.
  bool _isTemplateWithinBounds(Rect bounds, Rect templateRect, Offset? offset) {
    final Rect rect = Rect.fromLTWH(
        padding + templateRect.left,
        (3 * padding) + templateRect.top,
        templateRect.width,
        templateRect.height);
    final Rect axisBounds = Rect.fromLTWH(padding + bounds.left,
        (3 * padding) + bounds.top, bounds.width, bounds.height);
    return rect.left >= axisBounds.left &&
        rect.left + rect.width <= axisBounds.left + axisBounds.width &&
        rect.top >= axisBounds.top &&
        rect.bottom <= axisBounds.top + axisBounds.height;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final bool isTemplateWithInBoundsInTransposedChart =
        _isTemplateWithinBounds(boundaryRect, trackballTemplateRect!, offset);
    if ((!stateProperties.requireInvertedAxis && isTemplateInBounds) ||
        (stateProperties.requireInvertedAxis &&
            isTemplateWithInBoundsInTransposedChart)) {
      super.paint(context, offset);
    }

    final RenderingDetails renderingDetails = stateProperties.renderingDetails;
    if (!isGroupAllPoints) {
      final Rect templateRect = Rect.fromLTWH(
          offset.dx + trackballTemplateRect!.left,
          offset.dy + trackballTemplateRect!.top,
          trackballTemplateRect!.width,
          trackballTemplateRect!.height);
      final Paint fillPaint = Paint()
        ..color = trackballBehavior.tooltipSettings.color ??
            (chartPointInfo![index!].seriesRendererDetails!.series.color ??
                renderingDetails.chartTheme.crosshairBackgroundColor)
        ..isAntiAlias = false
        ..style = PaintingStyle.fill;
      final Paint strokePaint = Paint()
        ..color = trackballBehavior.tooltipSettings.borderColor ??
            (chartPointInfo![index!].seriesRendererDetails!.series.color ??
                renderingDetails.chartTheme.crosshairBackgroundColor)
        ..strokeWidth = trackballBehavior.tooltipSettings.borderWidth
        ..strokeCap = StrokeCap.butt
        ..isAntiAlias = false
        ..style = PaintingStyle.stroke;
      final Path path = Path();
      if (trackballTemplateRect!.left > boundaryRect.left &&
          trackballTemplateRect!.right < boundaryRect.right) {
        if (!stateProperties.requireInvertedAxis) {
          if (!isRight) {
            path.moveTo(templateRect.left,
                templateRect.top + templateRect.height / 2 - pointerWidth);
            path.lineTo(templateRect.left,
                templateRect.bottom - templateRect.height / 2 + pointerWidth);
            path.lineTo(templateRect.left - pointerLength, yPos + offset.dy);
            path.lineTo(templateRect.left,
                templateRect.top + templateRect.height / 2 - pointerWidth);
          } else {
            path.moveTo(templateRect.right,
                templateRect.top + templateRect.height / 2 - pointerWidth);
            path.lineTo(templateRect.right,
                templateRect.bottom - templateRect.height / 2 + pointerWidth);
            path.lineTo(templateRect.right + pointerLength, yPos + offset.dy);
            path.lineTo(templateRect.right,
                templateRect.top + templateRect.height / 2 - pointerWidth);
          }
        } else if (isTemplateInBounds &&
            isTemplateWithInBoundsInTransposedChart) {
          if (!isBottom) {
            path.moveTo(
                templateRect.left + templateRect.width / 2 + pointerWidth,
                templateRect.top);
            path.lineTo(
                templateRect.right - templateRect.width / 2 - pointerWidth,
                templateRect.top);
            path.lineTo(xPos + offset.dx, yPos + offset.dy);
          } else {
            path.moveTo(
                templateRect.left + templateRect.width / 2 + pointerWidth,
                templateRect.bottom);
            path.lineTo(
                templateRect.right - templateRect.width / 2 - pointerWidth,
                templateRect.bottom);
            path.lineTo(xPos + offset.dx, yPos + offset.dy);
          }
        }

        if (isTemplateInBounds) {
          context.canvas.drawPath(path, fillPaint);
          context.canvas.drawPath(path, strokePaint);
        }
      }
    }
  }
}

/// Class to store about the details of the closest points.
class ClosestPoints {
  /// Creates the parameterized constructor for class ClosestPoints.
  const ClosestPoints(
      {required this.closestPointX, required this.closestPointY});

  /// Holds the closest x point value.
  final double closestPointX;

  /// Holds the closest y point value.
  final double closestPointY;
}

/// Class to store trackball tooltip start and end positions.
class TooltipPositions {
  /// Creates the parameterized constructor for the class TooltipPositions.
  const TooltipPositions(this.tooltipTop, this.tooltipBottom);

  /// Specifies the tooltip top value.
  final List<num> tooltipTop;

  /// Specifies the tooltip bottom value.
  final List<num> tooltipBottom;
}

/// Class to store the string values with their corresponding series renderer.
class TrackballElement {
  /// Creates the parameterized constructor for the class _TrackballElement.
  TrackballElement(this.label, this.seriesRenderer);

  /// Specifies the trackball label value.
  final String label;

  /// Specifies the value of cartesian series renderer.
  final CartesianSeriesRenderer? seriesRenderer;

  /// Specifies whether to render the trackball element.
  bool needRender = true;
}
