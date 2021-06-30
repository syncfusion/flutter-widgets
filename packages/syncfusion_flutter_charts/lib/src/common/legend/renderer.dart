part of charts;

abstract class _CustomizeLegend {
  /// To draw legend items
  void drawLegendItem(int index, _LegendRenderContext legendItem, Legend legend,
      dynamic chartState, Canvas canvas, Size size);

  /// To get legend text color
  Color getLegendTextColor(
      int index, _LegendRenderContext legendItem, Color textColor);

  /// To get legend icon color
  Color getLegendIconColor(
      int index, _LegendRenderContext legendItem, Color iconColor);

  /// To get legend icon border color
  Color getLegendIconBorderColor(
      int index, _LegendRenderContext legendItem, Color iconBorderColor);

  /// To get legend icon border width
  double getLegendIconBorderWidth(
      int index, _LegendRenderContext legendItem, double iconBorderWidth);
}

class _LegendRenderer with _CustomizeLegend {
  /// To return legend icon border color
  @override
  Color getLegendIconBorderColor(
          int index, _LegendRenderContext legendItem, Color iconBorderColor) =>
      iconBorderColor;

  /// To return legend icon color
  @override
  Color getLegendIconColor(
          int index, _LegendRenderContext legendItem, Color iconColor) =>
      iconColor;

  /// To return legend text color
  @override
  Color getLegendTextColor(
          int index, _LegendRenderContext legendItem, Color textColor) =>
      textColor;

  /// To return legend icon border width
  @override
  double getLegendIconBorderWidth(
          int index, _LegendRenderContext legendItem, double iconBorderWidth) =>
      iconBorderWidth;

  /// To draw legend chart items in chart
  @override
  void drawLegendItem(int index, _LegendRenderContext legendItem, Legend legend,
      dynamic chartState, Canvas canvas, Size size) {
    final LegendRenderer legendRenderer =
        chartState._renderingDetails.legendRenderer;
    final dynamic chart = chartState._chart;
    final String legendText = legendItem.text;
    final List<Color> palette = chartState._chart.palette;
    TrendlineRenderer? trendlineRenderer;
    Color color = legendItem.iconColor ??
        palette[legendItem.seriesIndex % palette.length];
    color =
        legendRenderer._renderer.getLegendIconColor(index, legendItem, color);
    final Size textSize = legendItem.textSize!;
    final Offset iconOffset =
        Offset(legend.itemPadding + legend.iconWidth / 2, size.height / 2);
    if (legendItem.trendline != null) {
      trendlineRenderer = legendItem
          .seriesRenderer._trendlineRenderer[legendItem.trendlineIndex];
    }
    legendItem.isSelect = chart is SfCartesianChart
        ? ((legendItem.trendline != null)
            ? !trendlineRenderer!._visible
            : legendItem.seriesRenderer is TechnicalIndicators<dynamic, dynamic>
                ? !legendItem.indicatorRenderer!._visible!
                : legendItem.seriesRenderer._visible == false)
        : legendItem.point.isVisible == false;
    final Color legendTextColor =
        chartState._renderingDetails.chartTheme.legendTextColor;
    final TextStyle textStyle = legendItem.isSelect
        ? _getTextStyle(
            textStyle: legend.textStyle,
            takeFontColorValue: true,
            fontColor: const Color.fromRGBO(211, 211, 211, 1))
        : _getTextStyle(
            textStyle: legend.textStyle,
            fontColor: legendRenderer._renderer
                .getLegendTextColor(index, legendItem, legendTextColor));
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    _drawLegendShape(
        index,
        iconOffset,
        canvas,
        Size(legend.iconWidth.toDouble(), legend.iconHeight.toDouble()),
        legend,
        legendItem.iconType,
        color,
        legendItem,
        chartState);
    _drawText(
        canvas,
        legendText,
        Offset(iconOffset.dx + legend.padding + legend.iconWidth / 2,
            (size.height / 2) - textSize.height / 2),
        textStyle);
  }

  /// To get legend icon shape
  LegendIconType _getIconType(DataMarkerType shape) {
    LegendIconType? iconType;
    switch (shape) {
      case DataMarkerType.circle:
        iconType = LegendIconType.circle;
        break;
      case DataMarkerType.rectangle:
        iconType = LegendIconType.rectangle;
        break;
      case DataMarkerType.image:
        iconType = LegendIconType.image;
        break;
      case DataMarkerType.pentagon:
        iconType = LegendIconType.pentagon;
        break;
      case DataMarkerType.verticalLine:
        iconType = LegendIconType.verticalLine;
        break;
      case DataMarkerType.invertedTriangle:
        iconType = LegendIconType.invertedTriangle;
        break;
      case DataMarkerType.horizontalLine:
        iconType = LegendIconType.horizontalLine;
        break;
      case DataMarkerType.diamond:
        iconType = LegendIconType.diamond;
        break;
      case DataMarkerType.triangle:
        iconType = LegendIconType.triangle;
        break;
      case DataMarkerType.none:
        break;
    }
    return iconType!;
  }

  /// To draw  legend icon shapes
  void _drawLegendShape(
      int index,
      Offset location,
      Canvas canvas,
      Size size,
      Legend legend,
      LegendIconType iconType,
      Color color,
      _LegendRenderContext legendRenderContext,
      dynamic chartState) {
    final Path path = Path();
    final LegendIconType actualIconType = iconType;
    final LegendRenderer legendRenderer =
        chartState._renderingDetails.legendRenderer;
    PaintingStyle style = PaintingStyle.fill;
    final String seriesType = legendRenderContext.seriesRenderer
            is TechnicalIndicators<dynamic, dynamic>
        ? legendRenderContext.indicatorRenderer!._seriesType
        : legendRenderContext.seriesRenderer._seriesType;
    iconType = _getLegendIconType(iconType, legendRenderContext);
    final double width = (legendRenderContext.series.legendIconType ==
                LegendIconType.seriesType &&
            (seriesType == 'line' ||
                seriesType == 'fastline' ||
                seriesType.contains('stackedline')))
        ? size.width / 1.5
        : size.width;
    final double height = (legendRenderContext.series.legendIconType ==
                LegendIconType.seriesType &&
            (seriesType == 'line' ||
                seriesType == 'fastline' ||
                seriesType.contains('stackedline')))
        ? size.height / 1.5
        : size.height;
    Shader? _legendShader;
    final Rect _pathRect = Rect.fromLTWH(
        location.dx - width / 2, location.dy - height / 2, width, height);
    if (legendRenderContext.series is CircularSeries &&
        chartState._chart.onCreateShader != null) {
      ChartShaderDetails chartShaderDetails;
      chartShaderDetails = ChartShaderDetails(_pathRect, null, 'legend');
      _legendShader = chartState._chart.onCreateShader(chartShaderDetails);
    }
    style = _getPathAndStyle(iconType, style, path, location, width, height,
        legendRenderContext.seriesRenderer, chartState, canvas);
    // ignore: unnecessary_null_comparison
    assert(!(legend.iconBorderWidth != null) || legend.iconBorderWidth >= 0,
        'The icon border width of legend should not be less than 0.');
    // ignore: unnecessary_null_comparison
    if (color != null) {
      final Paint fillPaint = Paint()
        ..color = !legendRenderContext.isSelect
            ? (color == Colors.transparent
                ? color
                : color.withOpacity(legend.opacity))
            : const Color.fromRGBO(211, 211, 211, 1)
        ..strokeWidth = legend.iconBorderWidth > 0
            ? legend.iconBorderWidth
            : (seriesType.contains('hilo') ||
                    seriesType == 'candle' ||
                    seriesType == 'boxandwhisker' ||
                    (legendRenderContext.series is TechnicalIndicators &&
                        legendRenderContext.indicatorRenderer!._isIndicator))
                ? 2
                : 1
        ..style = (iconType == LegendIconType.seriesType)
            ? style
            : (iconType == LegendIconType.horizontalLine ||
                    iconType == LegendIconType.verticalLine
                ? PaintingStyle.stroke
                : PaintingStyle.fill);
      final String _seriesType = seriesType;
      if (legendRenderContext.series is CartesianSeries &&
          legendRenderContext.series.gradient != null &&
          !legendRenderContext.isTrendline! &&
          (iconType == LegendIconType.horizontalLine ||
              iconType == LegendIconType.verticalLine) &&
          !legendRenderContext.isSelect) {
        fillPaint.color = legendRenderContext.series.gradient.colors.first;
      }
      if ((actualIconType == LegendIconType.seriesType &&
              (_seriesType == 'line' ||
                  _seriesType == 'fastline' ||
                  _seriesType.contains('stackedline'))) ||
          (iconType == LegendIconType.seriesType &&
              (_seriesType == 'radialbar' || _seriesType == 'doughnut'))) {
        _drawIcon(
            iconType,
            index,
            _seriesType,
            legendRenderContext,
            chartState,
            width,
            height,
            location,
            size,
            canvas,
            fillPaint,
            path,
            legendRenderContext.point?.shader ?? _legendShader);
      } else {
        (legendRenderContext.series.legendIconType ==
                    LegendIconType.seriesType &&
                (_seriesType == 'spline' || _seriesType == 'stepline') &&
                legendRenderContext.series.dashArray[0] != 0)
            ? canvas.drawPath(
                !kIsWeb
                    ? _dashPath(path,
                        dashArray:
                            _CircularIntervalList<double>(<double>[3, 2]))!
                    : path,
                fillPaint)
            : canvas.drawPath(
                path,
                (legendRenderContext.series is CartesianSeries &&
                        !legendRenderContext.isSelect &&
                        legendRenderContext.series.gradient != null &&
                        !legendRenderContext.isTrendline! &&
                        !(iconType == LegendIconType.horizontalLine ||
                            iconType == LegendIconType.verticalLine))
                    ? _getLinearGradientPaint(
                        legendRenderContext.series.gradient,
                        path.getBounds(),
                        chartState._requireInvertedAxis)
                    : (legendRenderContext.series is CircularSeries &&
                            !legendRenderContext.isSelect &&
                            legendRenderContext.point?.center != null &&
                            (legendRenderContext.point?.shader != null ||
                                _legendShader != null)
                        ? _getShaderPaint(
                            legendRenderContext.point?.shader ?? _legendShader)
                        : fillPaint));
      }
    }
    final double iconBorderWidth = legendRenderer._renderer
        .getLegendIconBorderWidth(
            index, legendRenderContext, legend.iconBorderWidth);
    // ignore: unnecessary_null_comparison
    if (iconBorderWidth != null && iconBorderWidth > 0) {
      final Paint strokePaint = Paint()
        ..color = !legendRenderContext.isSelect
            ? legendRenderer._renderer.getLegendIconBorderColor(
                index,
                legendRenderContext,
                legend.iconBorderColor.withOpacity(legend.opacity))
            : const Color.fromRGBO(211, 211, 211, 1)
        ..strokeWidth = iconBorderWidth
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, strokePaint);
    }
  }

  /// To get legend icon type
  LegendIconType _getLegendIconType(
      LegendIconType iconType, _LegendRenderContext legendRenderContext) {
    if (legendRenderContext.series is TechnicalIndicators &&
        legendRenderContext.indicatorRenderer!._isIndicator) {
      return legendRenderContext.series.legendIconType ==
              LegendIconType.seriesType
          ? LegendIconType.horizontalLine
          : iconType;
    } else {
      final String seriesType = legendRenderContext.seriesRenderer._seriesType;
      return seriesType == 'scatter'
          ? (iconType != LegendIconType.seriesType
              ? iconType
              : _getIconType(legendRenderContext.series.markerSettings.shape))
          : (iconType == LegendIconType.seriesType &&
                  (seriesType == 'line' ||
                      seriesType == 'fastline' ||
                      seriesType.contains('stackedline')) &&
                  legendRenderContext.series.markerSettings.isVisible == true &&
                  legendRenderContext.series.markerSettings.shape !=
                      DataMarkerType.image
              ? _getIconType(legendRenderContext.series.markerSettings.shape)
              : iconType);
    }
  }

  /// To get path and painting style for legends
  PaintingStyle _getPathAndStyle(
      LegendIconType iconType,
      PaintingStyle style,
      Path path,
      Offset location,
      double width,
      double height,
      dynamic seriesRenderer,
      dynamic chartState,
      Canvas canvas) {
    final double x = location.dx -
        (iconType == LegendIconType.image ? 0 : width / 2).toDouble();
    final double y = location.dy -
        (iconType == LegendIconType.image ? 0 : height / 2).toDouble();
    final Rect rect = Rect.fromLTWH(x, y, width, height);
    switch (iconType) {
      case LegendIconType.seriesType:
        style = _calculateLegendShapes(path, rect, seriesRenderer._seriesType);
        break;
      case LegendIconType.circle:
        ShapePainter.getShapesPath(
            path: path, rect: rect, shapeType: ShapeMarkerType.circle);
        break;

      case LegendIconType.rectangle:
        ShapePainter.getShapesPath(
            path: path, rect: rect, shapeType: ShapeMarkerType.rectangle);
        break;
      case LegendIconType.image:
        {
          /// To draw legend image
          void _drawLegendImage(Canvas canvas, dart_ui.Image image) {
            final Rect rect =
                Rect.fromLTWH(x - width / 2, y - height / 2, width, height);
            paintImage(
                canvas: canvas, rect: rect, image: image, fit: BoxFit.fill);
          }

          if (chartState._chart.legend.image != null &&
              chartState._legendIconImage != null) {
            _drawLegendImage(canvas, chartState._legendIconImage);
          } else if (seriesRenderer._seriesType == 'scatter' &&
              seriesRenderer._series.markerSettings.shape ==
                  DataMarkerType.image &&
              seriesRenderer._markerSettingsRenderer._image != null) {
            _drawLegendImage(
                canvas, seriesRenderer._markerSettingsRenderer._image);
          }
          break;
        }
      case LegendIconType.pentagon:
        ShapePainter.getShapesPath(
            path: path, rect: rect, shapeType: ShapeMarkerType.pentagon);
        break;

      case LegendIconType.verticalLine:
        ShapePainter.getShapesPath(
            path: path, rect: rect, shapeType: ShapeMarkerType.verticalLine);
        break;

      case LegendIconType.invertedTriangle:
        ShapePainter.getShapesPath(
            path: path,
            rect: rect,
            shapeType: ShapeMarkerType.invertedTriangle);
        break;

      case LegendIconType.horizontalLine:
        ShapePainter.getShapesPath(
            path: path, rect: rect, shapeType: ShapeMarkerType.horizontalLine);
        break;

      case LegendIconType.diamond:
        ShapePainter.getShapesPath(
            path: path, rect: rect, shapeType: ShapeMarkerType.diamond);
        break;

      case LegendIconType.triangle:
        ShapePainter.getShapesPath(
            path: path, rect: rect, shapeType: ShapeMarkerType.triangle);
        break;
    }
    return style;
  }

  /// To draw legend icon
  void _drawIcon(
      LegendIconType iconType,
      int index,
      String seriesType,
      _LegendRenderContext legendRenderContext,
      dynamic chartState,
      double width,
      double height,
      Offset location,
      Size size,
      Canvas canvas,
      Paint fillPaint,
      Path path,
      Shader? shader) {
    final dynamic chart = chartState._chart;
    final double x = location.dx - width / 2;
    final double y = location.dy - height / 2;
    final Rect rect = Rect.fromLTWH(x, y, width, height);
    if (seriesType.contains('line')) {
      if (iconType != LegendIconType.seriesType) {
        canvas.drawPath(path, fillPaint);
      }
      final Path linePath = Path();
      linePath.moveTo(location.dx - size.width / 1.5, location.dy);
      linePath.lineTo(location.dx + size.width / 1.5, location.dy);
      final Paint paint = Paint()
        ..color = fillPaint.color.withOpacity(chart.legend.opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = chart.legend.iconBorderWidth > 0 == true
            ? chart.legend.iconBorderWidth
            : 3;
      legendRenderContext.series.dashArray[0] != 0
          ? canvas.drawPath(
              !kIsWeb
                  ? _dashPath(linePath,
                      dashArray: _CircularIntervalList<double>(<double>[3, 2]))!
                  : linePath,
              paint)
          : canvas.drawPath(linePath, paint);
    } else if (seriesType == 'radialbar') {
      final double radius = (width + height) / 2;
      _drawPath(
          canvas,
          _StyleOptions(
              fill: Colors.grey[100]!,
              strokeWidth: fillPaint.strokeWidth,
              strokeColor: Colors.grey[300]!.withOpacity(0.5)),
          ShapePainter.getShapesPath(
              rect: rect,
              shapeType: ShapeMarkerType.radialBarSeries,
              borderPaint: Paint(),
              radius: radius));
      const double pointStartAngle = -90;
      double degree =
          legendRenderContext.seriesRenderer._renderPoints[index].y.abs() /
              (legendRenderContext.series.maximumValue ??
                  legendRenderContext
                      .seriesRenderer._segmentRenderingValues['sumOfPoints']!);
      degree = (degree > 1 ? 1 : degree) * (360 - 0.001);
      final double pointEndAngle = pointStartAngle + degree;
      _drawPath(
          canvas,
          _StyleOptions(
              fill: fillPaint.color,
              strokeWidth: fillPaint.strokeWidth,
              strokeColor: Colors.transparent),
          ShapePainter.getShapesPath(
              rect: rect,
              shapeType: ShapeMarkerType.radialBarSeries,
              radius: radius,
              startAngle: pointStartAngle,
              degree: degree,
              endAngle: pointEndAngle),
          null,
          !legendRenderContext.isSelect ? shader : null);
    } else {
      final double radius = (width + height) / 2;
      _drawPath(
          canvas,
          _StyleOptions(
              fill: fillPaint.color,
              strokeWidth: fillPaint.strokeWidth,
              strokeColor: Colors.grey[300]!.withOpacity(0.5)),
          ShapePainter.getShapesPath(
              rect: rect,
              shapeType: ShapeMarkerType.doughnutSeries,
              borderPaint: Paint(),
              radius: radius),
          null,
          !legendRenderContext.isSelect ? shader : null);
      _drawPath(
          canvas,
          _StyleOptions(
              fill: fillPaint.color,
              strokeWidth: fillPaint.strokeWidth,
              strokeColor: Colors.grey[300]!.withOpacity(0.5)),
          ShapePainter.getShapesPath(
              rect: rect,
              shapeType: ShapeMarkerType.doughnutSeries,
              radius: radius),
          null,
          !legendRenderContext.isSelect ? shader : null);
    }
  }
}

class _RenderLegend extends StatelessWidget {
  _RenderLegend(
      {required this.index, required this.size, this.chartState, this.template})
      : chart = chartState._chart;

  final int index;

  final Size size;

  final dynamic chartState;

  final dynamic chart;

  final Widget? template;

  @override
  Widget build(BuildContext context) {
    bool? isSelect;
    if (chart.legend.legendItemBuilder != null) {
      final _MeasureWidgetContext _measureWidgetContext =
          chartState._renderingDetails.legendWidgetContext[index];
      isSelect = chart is SfCartesianChart
          ? chartState
              ._chartSeries
              .visibleSeriesRenderers[_measureWidgetContext.seriesIndex]
              ._visible
          : chartState
              ._chartSeries
              .visibleSeriesRenderers[_measureWidgetContext.seriesIndex]
              ._renderPoints[_measureWidgetContext.pointIndex]
              .isVisible;
    }
    final _ChartLegend chartLegend = chartState._renderingDetails.chartLegend;
    final LegendRenderer legendRenderer =
        chartState._renderingDetails.legendRenderer;
    return Container(
        height: size.height,
        width: legendRenderer._orientation == LegendItemOrientation.vertical &&
                (chart.legend.overflowMode == LegendItemOverflowMode.scroll ||
                    chart.legend.overflowMode == LegendItemOverflowMode.none)
            ? chartLegend.legendSize.width
            : size.width,
        child: HandCursor(
            child: GestureDetector(
                onTapUp: (TapUpDetails details) {
                  if (chart is SfCartesianChart) {
                    _processCartesianSeriesToggle();
                  } else {
                    _processCircularPointsToggle();
                  }
                },
                child: template != null
                    ? !isSelect!
                        ? Opacity(child: template, opacity: 0.5)
                        : template
                    : CustomPaint(
                        painter: _ChartLegendPainter(
                            chartState: chartState,
                            legendIndex: index,
                            isSelect:
                                chartLegend.legendCollections![index].isSelect,
                            notifier: chartLegend.legendRepaintNotifier)))));
  }

  /// To process chart on circular chart legend toggle
  void _processCircularPointsToggle() {
    LegendTapArgs legendTapArgs;
    const int seriesIndex = 0;
    final _ChartLegend chartLegend = chartState._renderingDetails.chartLegend;
    if (chart.onLegendTapped != null) {
      if (chart != null) {
        legendTapArgs = LegendTapArgs(chart.series, seriesIndex, index);
      } else {
        legendTapArgs =
            LegendTapArgs(chart._series[seriesIndex], seriesIndex, index);
      }
      chart.onLegendTapped(legendTapArgs);
    }
    if (chart.legend.toggleSeriesVisibility == true) {
      if (chart.legend.legendItemBuilder != null) {
        final _MeasureWidgetContext legendWidgetContext =
            chartState._renderingDetails.legendWidgetContext[index];
        _legendToggleTemplateState(legendWidgetContext, chartState, '');
      } else {
        _legendToggleState(chartLegend.legendCollections![index], chartState);
      }
      chartState._renderingDetails.isLegendToggled = true;
      chartState._redraw();
    }
  }

  /// To process chart on cartesian series toggle
  void _processCartesianSeriesToggle() {
    LegendTapArgs legendTapArgs;
    _MeasureWidgetContext _measureWidgetContext;
    _LegendRenderContext _legendRenderContext;
    if (chart.onLegendTapped != null) {
      if (chart.legend.legendItemBuilder != null) {
        _measureWidgetContext =
            chartState._renderingDetails.legendWidgetContext[index];
        legendTapArgs = LegendTapArgs(
            chartState._chartSeries
                .visibleSeriesRenderers[_measureWidgetContext.seriesIndex],
            _measureWidgetContext.seriesIndex!,
            0);
      } else {
        _legendRenderContext =
            chartState._renderingDetails.chartLegend.legendCollections[index];
        legendTapArgs = LegendTapArgs(
            _legendRenderContext.series, _legendRenderContext.seriesIndex, 0);
      }
      chart.onLegendTapped(legendTapArgs);
    }
    if (chart.legend.toggleSeriesVisibility == true) {
      if (chart.legend.legendItemBuilder != null) {
        _legendToggleTemplateState(
            chartState._renderingDetails.legendWidgetContext[index],
            chartState,
            '');
      } else {
        _cartesianLegendToggleState(
            chartState._renderingDetails.chartLegend.legendCollections[index],
            chartState);
      }
      chartState._renderingDetails.isLegendToggled = true;
      chartState._renderingDetails.isImageDrawn = false;
      chartState._legendToggling = true;
      chartState._redraw();
    }
  }
}

class _ChartLegendStylePainter extends CustomPainter {
  _ChartLegendStylePainter({this.chartState}) : chart = chartState._chart;

  final dynamic chartState;

  final dynamic chart;

  /// To paint legend
  @override
  void paint(Canvas canvas, Size size) {
    final Legend legend = chart.legend;
    final Color legendBackgroundColor =
        chartState._renderingDetails.chartTheme.legendBackgroundColor;
    if (legend.backgroundColor != null) {
      canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Paint()
            ..color = legend.backgroundColor ?? legendBackgroundColor
            ..style = PaintingStyle.fill);
    }
    // ignore: unnecessary_null_comparison
    if (legend.borderColor != null && legend.borderWidth > 0) {
      canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Paint()
            ..color = legend.borderColor
            ..strokeWidth = legend.borderWidth
            ..style = PaintingStyle.stroke);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _ChartLegendPainter extends CustomPainter {
  _ChartLegendPainter(
      {required this.chartState,
      required this.legendIndex,
      required this.isSelect,
      required ValueNotifier<int> notifier})
      : chart = chartState._chart,
        super(repaint: notifier);

  final dynamic chartState;

  final dynamic chart;

  final int legendIndex;

  final bool isSelect;

  @override
  void paint(Canvas canvas, Size size) {
    final Legend legend = chart.legend;
    final LegendRenderer legendRenderer =
        chartState._renderingDetails.legendRenderer;
    final _LegendRenderContext legendRenderContext =
        chartState._renderingDetails.chartLegend.legendCollections[legendIndex];
    legendRenderer._renderer.drawLegendItem(
        legendIndex, legendRenderContext, legend, chartState, canvas, size);
  }

  @override
  bool shouldRepaint(_ChartLegendPainter oldDelegate) => true;
}

class _LegendRenderContext {
  _LegendRenderContext(
      {this.size,
      required this.text,
      this.textSize,
      required this.iconColor,
      required this.iconType,
      this.point,
      required this.isSelect,
      this.trendline,
      required this.seriesIndex,
      this.trendlineIndex,
      this.seriesRenderer,
      this.isTrendline,
      this.indicatorRenderer})
      : series = seriesRenderer is TechnicalIndicators<dynamic, dynamic>
            ? seriesRenderer
            : seriesRenderer?._series;

  String text;

  Color? iconColor;

  Size? textSize;

  LegendIconType iconType;

  Size? size;

  Size? templateSize;

  dynamic series;

  dynamic seriesRenderer;

  TechnicalIndicatorsRenderer? indicatorRenderer;

  Trendline? trendline;

  dynamic point;

  int seriesIndex;

  int? trendlineIndex;

  bool isSelect;

  bool isRender = false;

  bool? isTrendline = false;
}
