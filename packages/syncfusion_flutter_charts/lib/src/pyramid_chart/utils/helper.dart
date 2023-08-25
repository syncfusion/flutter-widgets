import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../chart/common/data_label.dart';
import '../../chart/utils/enum.dart';
import '../../chart/utils/helper.dart';
import '../../circular_chart/renderer/circular_chart_annotation.dart';
import '../../circular_chart/renderer/data_label_renderer.dart';
import '../../circular_chart/utils/enum.dart';
import '../../circular_chart/utils/helper.dart';
import '../../common/event_args.dart';
import '../../common/state_properties.dart';
import '../../common/template/rendering.dart';
import '../../common/utils/enum.dart';
import '../../common/utils/helper.dart';
import '../base/pyramid_base.dart';
import '../base/pyramid_state_properties.dart';
import '../renderer/renderer_extension.dart';
import '../utils/common.dart';

/// Method for checking if point is within polygon.
bool isPointInPolygon(List<Offset> polygon, Offset point) {
  bool p = false;
  int i = -1;
  final int l = polygon.length;
  int j;
  for (j = l - 1; ++i < l; j = i) {
    ((polygon[i].dy <= point.dy && point.dy < polygon[j].dy) ||
            (polygon[j].dy <= point.dy && point.dy < polygon[i].dy)) &&
        (point.dx <
            (polygon[j].dx - polygon[i].dx) *
                    (point.dy - polygon[i].dy) /
                    (polygon[j].dy - polygon[i].dy) +
                polygon[i].dx) &&
        // ignore: unnecessary_statements
        (p = !p);
  }
  return p;
}

/// To add chart templates.
void findTemplates(dynamic stateProperties) {
  Offset labelLocation;
  const num lineLength = 10;
  PointInfo<dynamic> point;
  Widget labelWidget;
  stateProperties.renderingDetails.dataLabelTemplateRegions = <Rect>[];
  stateProperties.renderingDetails.templates = <ChartTemplateInfo>[];
  dynamic series;
  dynamic seriesRenderer;
  ChartAlignment labelAlign;
  for (int k = 0;
      k < stateProperties.chartSeries.visibleSeriesRenderers.length;
      k++) {
    seriesRenderer = stateProperties.chartSeries.visibleSeriesRenderers[k];
    series = seriesRenderer.series;
    if (series.dataLabelSettings.isVisible == true &&
        series.dataLabelSettings.builder != null) {
      for (int i = 0; i < seriesRenderer.renderPoints.length; i++) {
        point = seriesRenderer.renderPoints[i];
        if (point.isVisible) {
          labelWidget = series.dataLabelSettings
              .builder(series.dataSource[i], point, series, i, k);
          if (series.dataLabelSettings.labelPosition ==
              ChartDataLabelPosition.inside) {
            labelLocation = point.symbolLocation;
            labelAlign = ChartAlignment.center;
          } else {
            labelLocation = point.symbolLocation;
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
}

/// To render a template.
void renderTemplates(StateProperties stateProperties) {
  if (stateProperties.renderingDetails.templates.isNotEmpty == true) {
    ChartTemplateInfo chartTemplateInfo;
    for (int i = 0;
        i < stateProperties.renderingDetails.templates.length;
        i++) {
      chartTemplateInfo = stateProperties.renderingDetails.templates[i];
      chartTemplateInfo.animationDuration =
          stateProperties.renderingDetails.initialRender == false
              ? 0
              : chartTemplateInfo.animationDuration;
    }
    stateProperties.renderingDetails.chartTemplate = ChartTemplate(
        templates: stateProperties.renderingDetails.templates,
        render: stateProperties.renderingDetails.animateCompleted,
        stateProperties: stateProperties);
    stateProperties.renderingDetails.chartWidgets!
        .add(stateProperties.renderingDetails.chartTemplate!);
  }
}

/// To get pyramid series data label saturation color.
Color getPyramidFunnelColor(PointInfo<dynamic> currentPoint,
    dynamic seriesRenderer, dynamic stateProperties) {
  Color color;
  final dynamic series = seriesRenderer.series;
  final DataLabelSettings dataLabel = series.dataLabelSettings;
  final DataLabelSettingsRenderer dataLabelSettingsRenderer =
      seriesRenderer.dataLabelSettingsRenderer;
  color = (currentPoint.renderPosition == null ||
          currentPoint.renderPosition == ChartDataLabelPosition.inside &&
              !currentPoint.saturationRegionOutside)
      ? innerColor(dataLabelSettingsRenderer.color, currentPoint.fill,
          stateProperties.renderingDetails.chartTheme)
      : outerColor(
          dataLabelSettingsRenderer.color,
          dataLabel.useSeriesColor
              ? currentPoint.fill
              : (stateProperties.chart.backgroundColor != null
                  ? stateProperties
                      .renderingDetails.chartTheme.plotAreaBackgroundColor
                  : null),
          stateProperties.renderingDetails.chartTheme);

  return getSaturationColor(color);
}

/// To get inner data label color.
Color innerColor(
        Color? dataLabelColor, Color? pointColor, SfChartThemeData theme) =>
    dataLabelColor ?? pointColor ?? Colors.black;

/// To get outer data label color.
Color outerColor(Color? dataLabelColor, Color? backgroundColor,
        SfChartThemeData theme) =>
    // ignore: prefer_if_null_operators
    dataLabelColor != null
        ? dataLabelColor
        // ignore: prefer_if_null_operators
        : backgroundColor != null
            ? backgroundColor
            : theme.brightness == Brightness.light
                ? const Color.fromRGBO(255, 255, 255, 1)
                : Colors.black;

/// To get outer data label text style.
TextStyle getDataLabelTextStyle(
    dynamic seriesRenderer, PointInfo<dynamic> point, dynamic stateProperties,
    [double? animateOpacity]) {
  final dynamic series = seriesRenderer.series;
  final DataLabelSettings dataLabel = series.dataLabelSettings;
  final SfChartThemeData chartThemeData =
      stateProperties.renderingDetails.chartTheme;

  TextStyle dataLabelStyle = stateProperties
      .renderingDetails.themeData.textTheme.bodySmall!
      .merge(chartThemeData.dataLabelTextStyle)
      .merge(dataLabel.textStyle);

  final Color fontColor =
      _isCustomTextColor(dataLabel.textStyle, chartThemeData.dataLabelTextStyle)
          ? dataLabelStyle.color!
          : getPyramidFunnelColor(point, seriesRenderer, stateProperties);

  dataLabelStyle = dataLabelStyle.copyWith(
      color: fontColor.withOpacity(animateOpacity ?? 1));
  return dataLabelStyle;
}

bool _isCustomTextColor(TextStyle? textStyle, TextStyle? themeStyle) {
  return textStyle?.color != null || themeStyle?.color != null;
}

/// To check the point explosion.
bool isNeedExplode(int pointIndex, dynamic series, dynamic stateProperties) {
  bool isNeedExplode = false;
  if (series.explode == true) {
    if (stateProperties.renderingDetails.initialRender == true) {
      if (pointIndex == series.explodeIndex) {
        stateProperties.renderingDetails.explodedPoints.add(pointIndex);
        isNeedExplode = true;
      }
    } else if (stateProperties.renderingDetails.widgetNeedUpdate == true ||
        stateProperties.renderingDetails.isLegendToggled == true) {
      isNeedExplode =
          stateProperties.renderingDetails.explodedPoints.contains(pointIndex);
    }
  }
  return isNeedExplode;
}

/// To return data label rect calculation method based on position.
Rect? getDataLabelRect(Position position, ConnectorType connectorType,
    EdgeInsets margin, Path connectorPath, Offset endPoint, Size textSize,
    [DataLabelSettings? dataLabelSettings]) {
  Rect? rect;
  const int lineLength = 10;
  switch (position) {
    case Position.right:
      connectorType == ConnectorType.line
          ? connectorPath.lineTo(endPoint.dx + lineLength, endPoint.dy)
          : connectorPath.quadraticBezierTo(
              endPoint.dx, endPoint.dy, endPoint.dx + lineLength, endPoint.dy);
      rect = dataLabelSettings != null && dataLabelSettings.builder != null
          ? Rect.fromLTWH(
              endPoint.dx, endPoint.dy, textSize.width, textSize.height)
          : Rect.fromLTWH(
              endPoint.dx + lineLength,
              endPoint.dy - (textSize.height / 2) - margin.top,
              textSize.width + margin.left + margin.right,
              textSize.height + margin.top + margin.bottom);
      break;
    case Position.left:
      connectorType == ConnectorType.line
          ? connectorPath.lineTo(endPoint.dx - lineLength, endPoint.dy)
          : connectorPath.quadraticBezierTo(
              endPoint.dx, endPoint.dy, endPoint.dx - lineLength, endPoint.dy);
      rect = dataLabelSettings != null && dataLabelSettings.builder != null
          ? Rect.fromLTWH(
              endPoint.dx, endPoint.dy, textSize.width, textSize.height)
          : Rect.fromLTWH(
              endPoint.dx -
                  lineLength -
                  margin.right -
                  textSize.width -
                  margin.left,
              endPoint.dy - ((textSize.height / 2) + margin.top),
              textSize.width + margin.left + margin.right,
              textSize.height + margin.top + margin.bottom);
      break;
  }
  return rect;
}

/// To render pyramid data labels.
void renderPyramidDataLabel(
    PyramidSeriesRendererExtension seriesRenderer,
    Canvas canvas,
    PyramidStateProperties stateProperties,
    Animation<double> animation) {
  PointInfo<dynamic> point;
  PointInfo<dynamic> nextPoint;
  final SfPyramidChart chart = stateProperties.chart;
  final DataLabelSettings dataLabel = seriesRenderer.series.dataLabelSettings;
  final DataLabelSettingsRenderer dataLabelSettingsRenderer =
      seriesRenderer.dataLabelSettingsRenderer;
  String? label;
  // ignore: unnecessary_null_comparison
  final double animateOpacity = animation != null ? animation.value : 1;
  DataLabelRenderArgs dataLabelArgs;
  final TextStyle dataLabelStyle = stateProperties
      .renderingDetails.themeData.textTheme.bodySmall!
      .merge(stateProperties.renderingDetails.chartTheme.dataLabelTextStyle)
      .merge(dataLabel.textStyle);
  final List<Rect> renderDataLabelRegions = <Rect>[];
  Size textSize;
  stateProperties.outsideRects.clear();
  for (int pointIndex = 0;
      pointIndex < seriesRenderer.renderPoints!.length;
      pointIndex++) {
    point = seriesRenderer.renderPoints![pointIndex];
    TextStyle textStyle = dataLabelStyle.copyWith();
    if (point.isVisible && (point.y != 0 || dataLabel.showZeroValue)) {
      label = point.text;
      dataLabelSettingsRenderer.color =
          seriesRenderer.series.dataLabelSettings.color;
      if (chart.onDataLabelRender != null &&
          !seriesRenderer.renderPoints![pointIndex].labelRenderEvent) {
        dataLabelArgs = DataLabelRenderArgs(seriesRenderer,
            seriesRenderer.renderPoints, pointIndex, pointIndex);
        dataLabelArgs.text = label!;
        dataLabelArgs.textStyle = textStyle.copyWith();
        dataLabelArgs.color = dataLabelSettingsRenderer.color;
        chart.onDataLabelRender!(dataLabelArgs);
        label = point.text = dataLabelArgs.text;
        textStyle = textStyle.merge(dataLabelArgs.textStyle); //check here.
        pointIndex = dataLabelArgs.pointIndex!;
        dataLabelSettingsRenderer.color = dataLabelArgs.color;
        seriesRenderer.dataPoints[pointIndex].labelRenderEvent = true;
      }
      textStyle = chart.onDataLabelRender == null
          ? getDataLabelTextStyle(
              seriesRenderer, point, stateProperties, animateOpacity)
          : textStyle;
      textSize = measureText(label!, textStyle);

      // Label check after event
      if (label != '') {
        if (dataLabel.labelPosition == ChartDataLabelPosition.inside) {
          stateProperties.labelRects.clear();
          for (int index = 0;
              index < seriesRenderer.renderPoints!.length;
              index++) {
            nextPoint = seriesRenderer.renderPoints![index];
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
          _setPyramidInsideLabelPosition(
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
          _renderOutsidePyramidDataLabel(
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

/// To calculate pyramid inside label position.
void _setPyramidInsideLabelPosition(
    DataLabelSettings dataLabel,
    PointInfo<dynamic> point,
    Size textSize,
    PyramidStateProperties stateProperties,
    Canvas canvas,
    List<Rect> renderDataLabelRegions,
    int pointIndex,
    String label,
    PyramidSeriesRendererExtension seriesRenderer,
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
    _renderOutsidePyramidDataLabel(
        canvas,
        label,
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
    _drawPyramidLabel(
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
  } else if (((!isLabelCollide &&
              dataLabel.labelIntersectAction != LabelIntersectAction.hide) ||
          (dataLabel.overflowMode == OverflowMode.trim)) &&
      (label != '')) {
    point.renderPosition = ChartDataLabelPosition.inside;
    final Size trimmedTextSize = measureText(label, dataLabelStyle);
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
    _drawPyramidLabel(
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

/// To render outside pyramid data label.
void _renderOutsidePyramidDataLabel(
    Canvas canvas,
    String label,
    PointInfo<dynamic> point,
    Size textSize,
    int pointIndex,
    PyramidSeriesRendererExtension seriesRenderer,
    PyramidStateProperties stateProperties,
    TextStyle textStyle,
    List<Rect> renderDataLabelRegions,
    double animateOpacity) {
  Path connectorPath;
  Rect? rect;
  Offset labelLocation;
  final EdgeInsets margin = seriesRenderer.series.dataLabelSettings.margin;
  final ConnectorLineSettings connector =
      seriesRenderer.series.dataLabelSettings.connectorLineSettings;
  final DataLabelSettings dataLabel = seriesRenderer.series.dataLabelSettings;
  const num regionPadding = 12;
  connectorPath = Path();
  bool isPreviousRectIntersect = false;
  final num connectorLength = percentToValue(connector.length ?? '0%',
          stateProperties.renderingDetails.chartAreaRect.width / 2)! +
      seriesRenderer.maximumDataLabelRegion.width / 2 -
      regionPadding;
  final Offset startPoint = Offset(
      seriesRenderer.renderPoints![pointIndex].region!.right,
      seriesRenderer.renderPoints![pointIndex].region!.top +
          seriesRenderer.renderPoints![pointIndex].region!.height / 2);
  final double dx = seriesRenderer.renderPoints![pointIndex].symbolLocation.dx +
      connectorLength;
  final Offset endPoint = Offset(
      (dx + textSize.width + margin.left + margin.right >
              stateProperties.renderingDetails.chartAreaRect.right)
          ? dx -
              (percentToValue(seriesRenderer.series.explodeOffset,
                  stateProperties.renderingDetails.chartAreaRect.width)!)
          : dx,
      seriesRenderer.renderPoints![pointIndex].symbolLocation.dy);
  connectorPath.moveTo(startPoint.dx, startPoint.dy);
  if (connector.type == ConnectorType.line) {
    connectorPath.lineTo(endPoint.dx, endPoint.dy);
  }
  point.dataLabelPosition = Position.right;
  rect = getDataLabelRect(point.dataLabelPosition!, connector.type, margin,
      connectorPath, endPoint, textSize);
  if (rect != null) {
    point.labelRect = rect;
    labelLocation = Offset(rect.left + margin.left,
        rect.top + rect.height / 2 - textSize.height / 2);
    final Rect containerRect = stateProperties.renderingDetails.chartAreaRect;
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
              _isPyramidLabelIntersect(rect, stateProperties.outsideRects.last);
        } else {
          isPreviousRectIntersect =
              _isPyramidLabelIntersect(rect, lastRenderedLabelRegion);
        }
        if (!isPreviousRectIntersect &&
            (rect.left > containerRect.left &&
                rect.left + rect.width <
                    containerRect.left + containerRect.width) &&
            rect.top > containerRect.top &&
            rect.top + rect.height < containerRect.top + containerRect.height) {
          stateProperties.outsideRects.add(rect);
          _drawPyramidLabel(
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
            final Rect previousRenderedRect =
                stateProperties.outsideRects.isNotEmpty
                    ? stateProperties
                        .outsideRects[stateProperties.outsideRects.length - 1]
                    : renderDataLabelRegions[renderDataLabelRegions.length - 1];
            rect = Rect.fromLTWH(rect.left,
                previousRenderedRect.bottom + padding, rect.width, rect.height);
            labelLocation = Offset(
                rect.left + margin.left,
                previousRenderedRect.bottom +
                    padding +
                    rect.height / 2 -
                    textSize.height / 2);
            connectorPath = Path();
            connectorPath.moveTo(startPoint.dx, startPoint.dy);
            connectorPath.lineTo(
                rect.left - connectorLinePadding, rect.top + rect.height / 2);
            connectorPath.lineTo(rect.left, rect.top + rect.height / 2);
          }
          if (rect.bottom <
              stateProperties.renderingDetails.chartAreaRect.bottom) {
            stateProperties.outsideRects.add(rect);
            _drawPyramidLabel(
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
    } else if (dataLabel.labelIntersectAction == LabelIntersectAction.none) {
      if (seriesRenderer.series.dataLabelSettings.builder == null) {
        stateProperties.outsideRects.add(rect);
        _drawPyramidLabel(
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
    } else if (dataLabel.labelIntersectAction == LabelIntersectAction.hide) {
      if (seriesRenderer.series.dataLabelSettings.builder == null) {
        stateProperties.outsideRects.add(rect);
        Rect? lastRenderedLabelRegion;
        if (renderDataLabelRegions.isNotEmpty) {
          lastRenderedLabelRegion =
              renderDataLabelRegions[renderDataLabelRegions.length - 1];
        }
        isPreviousRectIntersect =
            _isPyramidLabelIntersect(rect, lastRenderedLabelRegion);
        if (!isPreviousRectIntersect) {
          _drawPyramidLabel(
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
bool _isPyramidLabelIntersect(Rect rect, Rect? previousRect) {
  bool isIntersect = false;
  const num padding = 2;
  if (previousRect != null && (rect.top - padding) < previousRect.bottom) {
    isIntersect = true;
  }
  return isIntersect;
}

/// To draw pyramid data label.
void _drawPyramidLabel(
    Rect labelRect,
    Offset location,
    String? label,
    Path? connectorPath,
    Canvas canvas,
    PyramidSeriesRendererExtension seriesRenderer,
    PointInfo<dynamic> point,
    int pointIndex,
    PyramidStateProperties stateProperties,
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

/// Method to trigger the pyramid data label event.
void triggerPyramidDataLabelEvent(
    SfPyramidChart chart,
    PyramidSeriesRendererExtension seriesRenderer,
    PyramidStateProperties chartState,
    Offset position) {
  const int seriesIndex = 0;
  DataLabelSettings dataLabel;
  PointInfo<dynamic> point;
  Offset labelLocation;
  for (int pointIndex = 0;
      pointIndex < seriesRenderer.renderPoints!.length;
      pointIndex++) {
    dataLabel = seriesRenderer.series.dataLabelSettings;
    point = seriesRenderer.renderPoints![pointIndex];
    labelLocation = point.symbolLocation;
    if (dataLabel.isVisible &&
        seriesRenderer.renderPoints![pointIndex].labelRect != null &&
        seriesRenderer.renderPoints![pointIndex].labelRect!
            .contains(position)) {
      position = Offset(labelLocation.dx, labelLocation.dy);
      dataLabelTapEvent(chart, seriesRenderer.series.dataLabelSettings,
          pointIndex, point, position, seriesIndex);
    }
  }
}

/// Method to get a text when the text overlap with another segment/slice.
String getSegmentOverflowTrimmedText(
    DataLabelSettings dataLabel,
    PointInfo<dynamic> point,
    Size textSize,
    StateProperties stateProperties,
    Offset labelLocation,
    List<Rect> renderDataLabelRegions,
    TextStyle dataLabelStyle) {
  bool isCollide;
  String label = point.text!;
  const int labelPadding = 2;
  const String ellipse = '...';
  const int minCharacterLength = 3;

  isCollide = findingCollision(point.labelRect!, <Rect>[], point.region);
  while (isCollide) {
    if (label == ellipse) {
      label = '';
      break;
    }
    if (label.length > minCharacterLength)
      label = addEllipse(label, label.length, ellipse,
          isRtl: stateProperties.renderingDetails.isRtl);
    else {
      label = '';
      break;
    }
    final Size trimTextSize = measureText(label, dataLabelStyle);
    final Rect trimRect = Rect.fromLTWH(
        labelLocation.dx - labelPadding,
        labelLocation.dy - labelPadding,
        trimTextSize.width + (2 * labelPadding),
        trimTextSize.height + (2 * labelPadding));
    isCollide = isLabelsColliding(trimRect, point.region);
  }
  return label == ellipse ? '' : label;
}

/// To check collide.
bool isLabelsColliding(Rect rect, Rect? pathRect) {
  bool isCollide = false;
  if (pathRect != null &&
      (pathRect.left > rect.left &&
          pathRect.width > rect.width &&
          pathRect.top < rect.top &&
          pathRect.height > rect.height)) {
    isCollide = false;
  } else if (pathRect != null) {
    isCollide = true;
  }
  return isCollide;
}

/// To check if labels collide.
bool checkCollide(int index, List<Rect> list) {
  final Rect currentRect = list[index];
  Rect nextRect;
  bool isCollide = false;
  for (int i = index + 1; i < list.length; i++) {
    nextRect = list[i];
    isCollide = currentRect.overlaps(nextRect);
    if (isCollide == true) {
      break;
    }
  }
  return isCollide;
}
