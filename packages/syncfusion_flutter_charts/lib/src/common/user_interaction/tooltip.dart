part of charts;

/// Customizes the tooltip.
///
/// This class provides options for customizing the properties of the tooltip.
class TooltipBehavior {
  /// Creating an argument constructor of TooltipBehavior class.
  TooltipBehavior(
      {TextStyle? textStyle,
      ActivationMode? activationMode,
      int? animationDuration,
      bool? enable,
      double? opacity,
      Color? borderColor,
      double? borderWidth,
      double? duration,
      bool? shouldAlwaysShow,
      double? elevation,
      bool? canShowMarker,
      ChartAlignment? textAlignment,
      int? decimalPlaces,
      TooltipPosition? tooltipPosition,
      bool? shared,
      this.color,
      this.header,
      this.format,
      this.builder,
      this.shadowColor})
      : animationDuration = animationDuration ?? 350,
        textAlignment = textAlignment ?? ChartAlignment.center,
        textStyle = textStyle ?? const TextStyle(fontSize: 12),
        activationMode = activationMode ?? ActivationMode.singleTap,
        borderColor = borderColor ?? Colors.transparent,
        borderWidth = borderWidth ?? 0,
        duration = duration ?? 3000,
        enable = enable ?? false,
        opacity = opacity ?? 1,
        shouldAlwaysShow = shouldAlwaysShow ?? false,
        canShowMarker = canShowMarker ?? true,
        tooltipPosition = tooltipPosition ?? TooltipPosition.auto,
        elevation = elevation ?? 2.5,
        decimalPlaces = decimalPlaces ?? 3,
        shared = shared ?? false;

  ///Toggles the visibility of the tooltip.
  ///
  ///Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           tooltipBehavior: TooltipBehavior(enable: true),
  ///        ));
  ///}
  ///```
  final bool enable;

  ///Color of the tooltip.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           tooltipBehavior: TooltipBehavior(enable: true, color: Colors.yellow),
  ///        ));
  ///}
  ///```
  final Color? color;

  /// Header of the tooltip. By default, the series name will be displayed in the header.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           tooltipBehavior: TooltipBehavior(enable: true, header: 'Default'),
  ///        ));
  ///}
  ///```
  final String? header;

  ///Opacity of the tooltip.
  ///
  ///The value ranges from 0 to 1.
  ///
  ///Defaults to `1`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           tooltipBehavior: TooltipBehavior(enable: true, opacity: 0.7),
  ///        ));
  ///}
  ///```
  final double opacity;

  ///Customizes the tooltip text
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           tooltipBehavior: TooltipBehavior(
  ///           enable: true,
  ///            textStyle: TextStyle(color: Colors.green)),
  ///        ));
  ///}
  ///```
  final TextStyle textStyle;

  ///Specifies the number decimals to be displayed in tooltip text
  ///
  ///Defaults to `3`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           tooltipBehavior: TooltipBehavior(
  ///           enable: true, decimalPlaces:5),
  ///        ));
  ///}
  ///```
  final int decimalPlaces;

  ///Formats the tooltip text.
  ///
  ///By default, the tooltip will be rendered with x and y-values.
  ///
  ///You can add prefix or suffix to x, y, and series name values in the
  ///tooltip by formatting them.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           tooltipBehavior: TooltipBehavior(enable: true, format: '{value}%'),
  ///        ));
  ///}
  ///```
  final String? format;

  ///Duration for animating the tooltip.
  ///
  ///Defaults to `350`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           tooltipBehavior: TooltipBehavior(enable: true, animationDuration: 1000),
  ///        ));
  ///}
  ///```
  final int animationDuration;

  ///Toggles the visibility of the marker in the tooltip.
  ///
  ///Defaults to `true`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           tooltipBehavior: TooltipBehavior(enable: true, canShowMarker: true),
  ///        ));
  ///}
  ///```
  final bool canShowMarker;

  ///Gesture for activating the tooltip.
  ///
  ///Tooltip can be activated in tap, double tap, and long press.
  ///
  ///Defaults to `ActivationMode.tap`.
  ///
  ///Also refer [ActivationMode]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           tooltipBehavior: TooltipBehavior(
  ///           enable: true,
  ///           activationMode: ActivationMode.doubleTap),
  ///        ));
  ///}
  ///```
  final ActivationMode activationMode;

  ///Border color of the tooltip.
  ///
  ///Defaults to `Colors.transparent`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           tooltipBehavior: TooltipBehavior(enable: true, borderColor: Colors.red),
  ///        ));
  ///}
  ///```
  final Color borderColor;

  ///Border width of the tooltip.
  ///
  ///Defaults to `0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           tooltipBehavior: TooltipBehavior(
  ///           enable: true,
  ///           borderWidth: 2,
  ///           borderColor: Colors.red
  ///         ),
  ///        ));
  ///}
  ///```
  final double borderWidth;

  ///Builder of the tooltip.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           tooltipBehavior: TooltipBehavior(
  ///           enable: true,
  ///           builder: (dynamic data, dynamic point,
  ///           dynamic series, int pointIndex, int seriesIndex) {
  ///           return Container(
  ///              height: 50,
  ///              width: 100,
  ///              decoration: const BoxDecoration(
  ///              color: Color.fromRGBO(66, 244, 164, 1)),
  ///              child: Row(
  ///              children: <Widget>[
  ///              Container(
  ///              width: 50,
  ///              child: Image.asset('images/bike.png')),],
  ///         ));
  ///         }),
  ///        ));
  ///}
  ///```
  final ChartWidgetBuilder<dynamic>? builder;

  ///Color of the tooltip shadow.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           tooltipBehavior: TooltipBehavior(enable: true, shadowColor: Colors.green),
  ///        ));
  ///}
  ///```
  final Color? shadowColor;

  ///Elevation of the tooltip.
  ///
  ///Defaults to `2.5`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           tooltipBehavior: TooltipBehavior(enable: true, elevation: 10),
  ///        ));
  ///}
  ///```
  final double elevation;

  ///Shows or hides the tooltip.
  ///
  /// By default, the tooltip will be hidden on touch. To avoid this, set this property to true.
  ///
  ///Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           tooltipBehavior: TooltipBehavior(enable: true, shouldAlwaysShow: true),
  ///        ));
  ///}
  ///```
  final bool shouldAlwaysShow;

  ///Duration for displaying the tooltip.
  ///
  ///Defaults to `3000`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           tooltipBehavior: TooltipBehavior(enable: true, duration: 1000),
  ///        ));
  ///}
  ///```
  final double duration;

  ///Alignment of the text in the tooltip
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           tooltipBehavior: TooltipBehavior(enable: true,textAlignment : ChartAlignment.near),
  ///        ));
  ///}
  ///```
  final ChartAlignment textAlignment;

  ///Show tooltip at tapped position
  ///
  ///Defaults to `TooltipPosition.auto`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           tooltipBehavior: TooltipBehavior(enable: true,
  ///           tooltipPosition: TooltipPosition.pointer),
  ///        ));
  ///}
  ///```
  final TooltipPosition tooltipPosition;

  ///Share the tooltip with same index points
  ///
  ///Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           tooltipBehavior: TooltipBehavior(enable: true,
  ///           shared: true),
  ///        ));
  ///}
  ///```
  final bool shared;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is TooltipBehavior &&
        other.textStyle == textStyle &&
        other.activationMode == activationMode &&
        other.animationDuration == animationDuration &&
        other.enable == enable &&
        other.opacity == opacity &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.duration == duration &&
        other.shouldAlwaysShow == shouldAlwaysShow &&
        other.elevation == elevation &&
        other.canShowMarker == canShowMarker &&
        other.textAlignment == textAlignment &&
        other.decimalPlaces == decimalPlaces &&
        other.tooltipPosition == tooltipPosition &&
        other.shared == shared &&
        other.color == color &&
        other.header == header &&
        other.format == format &&
        other.builder == builder &&
        other.shadowColor == shadowColor;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      textStyle,
      activationMode,
      animationDuration,
      enable,
      opacity,
      borderColor,
      borderWidth,
      duration,
      shouldAlwaysShow,
      elevation,
      canShowMarker,
      textAlignment,
      decimalPlaces,
      tooltipPosition,
      shared,
      color,
      header,
      format,
      builder,
      shadowColor
    ];
    return hashList(values);
  }

  dynamic _chartState;

  /// Displays the tooltip at the specified x and y-positions.
  ///
  ///
  /// * x & y - logical pixel values to position the tooltip.
  ///
  // shouldInsidePointRegion - determines if whether the given pixel values remains within point region.
  // Defaults to true.
  void showByPixel(double x, double y) {
    //, [bool shouldInsidePointRegion]) {
    final dynamic chartState = _chartState;
    final dynamic chart = chartState._chart;
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        _chartState._renderingDetails.tooltipBehaviorRenderer;
    bool? isInsidePointRegion;
    String text = '';
    String trimmedText = '';
    Offset? axisLabelPosition;
    if (chart is SfCartesianChart) {
      _chartState._requireAxisTooltip = false;
      for (int i = 0;
          i < _chartState._chartAxis._axisRenderersCollection.length;
          i++) {
        final List<AxisLabel> labels =
            _chartState._chartAxis._axisRenderersCollection[i]._visibleLabels;
        for (int k = 0; k < labels.length; k++) {
          if (_chartState
                      ._chartAxis._axisRenderersCollection[i]._axis.isVisible ==
                  true &&
              labels[k]._labelRegion != null &&
              labels[k]._labelRegion!.contains(Offset(x, y))) {
            _chartState._requireAxisTooltip = true;
            text = labels[k].text;
            trimmedText = labels[k].renderText ?? '';
            axisLabelPosition = labels[k]._labelRegion!.center;
            // -3 to indicte axis tooltip
            tooltipBehaviorRenderer._currentTooltipValue =
                TooltipValue(null, k, 0);
          }
        }
      }
    }
    if (chart is SfCartesianChart && _chartState._requireAxisTooltip == false) {
      for (int i = 0;
          i < _chartState._chartSeries.visibleSeriesRenderers.length;
          i++) {
        final CartesianSeriesRenderer seriesRenderer =
            _chartState._chartSeries.visibleSeriesRenderers[i];
        if (seriesRenderer._visible! &&
            seriesRenderer._series.enableTooltip &&
            seriesRenderer._regionalData != null) {
          final String seriesType = seriesRenderer._seriesType;
          final double padding = (seriesType == 'bubble' ||
                  seriesType == 'scatter' ||
                  seriesType.contains('column') ||
                  seriesType.contains('bar'))
              ? 0
              : _chartState._renderingDetails.tooltipBehaviorRenderer
                          ._isHovering ==
                      true
                  ? 0
                  : 15; // regional padding to detect smooth touch
          seriesRenderer._regionalData!
              .forEach((dynamic regionRect, dynamic values) {
            final Rect region = regionRect[0];
            final Rect paddedRegion = Rect.fromLTRB(
                region.left - padding,
                region.top - padding,
                region.right + padding,
                region.bottom + padding);
            bool outlierTooltip = false;
            if (seriesRenderer._seriesType == 'boxandwhisker') {
              final List<Rect>? outlierRegion = regionRect[5];
              if (outlierRegion != null) {
                for (int rectIndex = 0;
                    rectIndex < outlierRegion.length;
                    rectIndex++) {
                  if (outlierRegion[rectIndex].contains(Offset(x, y))) {
                    outlierTooltip = true;
                    break;
                  }
                }
              }
            }
            if (paddedRegion.contains(Offset(x, y)) || outlierTooltip) {
              isInsidePointRegion = true;
            }
          });
        }
      }
    }
    if (chart is SfCartesianChart &&
        activationMode != ActivationMode.none &&
        // ignore: unnecessary_null_comparison
        x != null &&
        // ignore: unnecessary_null_comparison
        y != null &&
        _chartState._requireAxisTooltip == true) {
      final SfTooltipState? tooltipState =
          tooltipBehaviorRenderer._chartTooltipState;
      if (trimmedText.contains('...')) {
        tooltipBehaviorRenderer._show = true;
        tooltipState?.needMarker = false;
        tooltipBehaviorRenderer._showAxisTooltip(
            axisLabelPosition!, chart, text);
      } else {
        tooltipBehaviorRenderer._show = false;
        if (!shouldAlwaysShow) {
          tooltipBehaviorRenderer._chartTooltipState
              ?.hide(hideDelay: duration.toInt());
        }
      }
    } else if (tooltipBehaviorRenderer._chartTooltip != null &&
        activationMode != ActivationMode.none &&
        // ignore: unnecessary_null_comparison
        x != null &&
        // ignore: unnecessary_null_comparison
        y != null) {
      final SfTooltipState? tooltipState =
          tooltipBehaviorRenderer._chartTooltipState;
      if ((chart is SfCartesianChart) == false ||
          tooltipBehaviorRenderer._isInteraction ||
          (isInsidePointRegion ?? false)) {
        final bool isHovering =
            _chartState._renderingDetails.tooltipBehaviorRenderer._isHovering;
        if (isInsidePointRegion == true ||
            isHovering ||
            (chart is SfCartesianChart) == false) {
          tooltipBehaviorRenderer._showTooltip(x, y);
        } else {
          tooltipBehaviorRenderer._show = false;
          if (chart.tooltipBehavior.shouldAlwaysShow == false) {
            hide();
          }
        }
      } else if (tooltipBehaviorRenderer._renderBox != null) {
        tooltipBehaviorRenderer._show = true;
        tooltipState?.needMarker = false;
        tooltipBehaviorRenderer._showChartAreaTooltip(
            Offset(x, y),
            _chartState._chartAxis._primaryXAxisRenderer,
            _chartState._chartAxis._primaryYAxisRenderer,
            chart);
      }
    }
    if (chart is SfCartesianChart &&
        chart.tooltipBehavior.builder != null &&
        x != null && // ignore: unnecessary_null_comparison
        // ignore: unnecessary_null_comparison
        y != null) {
      tooltipBehaviorRenderer._showTemplateTooltip(Offset(x, y));
    }
    // ignore: unnecessary_null_comparison
    if (tooltipBehaviorRenderer != null) {
      tooltipBehaviorRenderer._isInteraction = false;
    }
  }

  /// Displays the tooltip at the specified x and y-values.
  ///
  ///
  /// *x & y - x & y point values at which the tooltip needs to be shown.
  ///
// shouldInsidePointRegion - determines if whether the given pixel values remains within point region.
// Defaults to true.
  ///
  /// * xAxisName - name of the x axis the given point must be bind to.
  ///
  /// * yAxisName - name of the y axis the given point must be bind to.
  void show(dynamic x, double y, [String? xAxisName, String? yAxisName]) {
    if (_chartState._chart is SfCartesianChart) {
      final dynamic chart = _chartState._chart;
      final _RenderingDetails renderingDetails = _chartState._renderingDetails;
      final TooltipBehaviorRenderer tooltipBehaviorRenderer =
          renderingDetails.tooltipBehaviorRenderer;
      bool? isInsidePointRegion = false;
      ChartAxisRenderer? xAxisRenderer, yAxisRenderer;
      if (xAxisName != null && yAxisName != null) {
        for (final ChartAxisRenderer axisRenderer
            in _chartState._chartAxis._axisRenderersCollection) {
          if (axisRenderer._name == xAxisName) {
            xAxisRenderer = axisRenderer;
          } else if (axisRenderer._name == yAxisName) {
            yAxisRenderer = axisRenderer;
          }
        }
      } else {
        xAxisRenderer = _chartState._chartAxis._primaryXAxisRenderer;
        yAxisRenderer = _chartState._chartAxis._primaryYAxisRenderer;
      }
      final _ChartLocation position = _calculatePoint(
          (x is DateTime &&
                  (xAxisRenderer! is DateTimeCategoryAxisRenderer) == false)
              ? x.millisecondsSinceEpoch
              : ((x is DateTime &&
                      xAxisRenderer! is DateTimeCategoryAxisRenderer)
                  ? (xAxisRenderer as DateTimeCategoryAxisRenderer)
                      ._labels
                      .indexOf(xAxisRenderer._dateFormat.format(x))
                  : ((x is String && xAxisRenderer is CategoryAxisRenderer)
                      ? xAxisRenderer._labels.indexOf(x)
                      : x)),
          y,
          xAxisRenderer!,
          yAxisRenderer!,
          _chartState._requireInvertedAxis,
          null,
          _chartState._chartAxis._axisClipRect);
      for (int i = 0;
          i < _chartState._chartSeries.visibleSeriesRenderers.length;
          i++) {
        final CartesianSeriesRenderer seriesRenderer =
            _chartState._chartSeries.visibleSeriesRenderers[i];
        if (seriesRenderer._visible! &&
            seriesRenderer._series.enableTooltip &&
            seriesRenderer._regionalData != null) {
          final double padding = (seriesRenderer._seriesType == 'bubble' ||
                  seriesRenderer._seriesType == 'scatter' ||
                  seriesRenderer._seriesType.contains('column') ||
                  seriesRenderer._seriesType.contains('bar'))
              ? 0
              : 15; // regional padding to detect smooth touch
          seriesRenderer._regionalData!
              .forEach((dynamic regionRect, dynamic values) {
            final Rect region = regionRect[0];
            final Rect paddedRegion = Rect.fromLTRB(
                region.left - padding,
                region.top - padding,
                region.right + padding,
                region.bottom + padding);
            if (paddedRegion.contains(Offset(position.x, position.y))) {
              isInsidePointRegion = true;
            }
          });
        }
      }
      if (renderingDetails.tooltipBehaviorRenderer._tooltipTemplate == null) {
        final SfTooltipState? tooltipState =
            tooltipBehaviorRenderer._chartTooltipState;
        if (isInsidePointRegion ?? false) {
          tooltipBehaviorRenderer._showTooltip(position.x, position.y);
        } else {
          //to show tooltip when the position is out of point region
          tooltipBehaviorRenderer._show = true;
          tooltipState?.needMarker = false;
          renderingDetails.tooltipBehaviorRenderer._showChartAreaTooltip(
              Offset(position.x, position.y),
              xAxisRenderer,
              yAxisRenderer,
              chart);
        }
      }
      tooltipBehaviorRenderer._isInteraction = false;
    }
  }

  /// Displays the tooltip at the specified series and point index.
  ///
  /// * seriesIndex - index of the series for which the pointIndex is specified
  ///
  /// * pointIndex - index of the point for which the tooltip should be shown
  void showByIndex(int seriesIndex, int pointIndex) {
    final dynamic chartState = _chartState;
    final dynamic chart = chartState._chart;
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        _chartState._renderingDetails.tooltipBehaviorRenderer;
    dynamic x, y;
    if (chart is SfCartesianChart) {
      if (_validIndex(pointIndex, seriesIndex, chart)) {
        final CartesianSeriesRenderer cSeriesRenderer =
            _chartState._chartSeries.visibleSeriesRenderers[seriesIndex];
        if (cSeriesRenderer._visible!) {
          x = cSeriesRenderer._dataPoints[pointIndex].markerPoint!.x;
          y = cSeriesRenderer._dataPoints[pointIndex].markerPoint!.y;
        }
      }
      if (x != null && y != null && chart.series[seriesIndex].enableTooltip) {
        if (chart.tooltipBehavior.builder != null) {
          tooltipBehaviorRenderer._showTemplateTooltip(Offset(x, y));
        } else if (chart.series[seriesIndex].enableTooltip) {
          tooltipBehaviorRenderer._showTooltip(x, y);
        }
      }
    } else if (chart is SfCircularChart) {
      if (chart.tooltipBehavior.builder != null &&
          seriesIndex < chart.series.length &&
          pointIndex <
              _chartState._chartSeries.visibleSeriesRenderers[seriesIndex]
                  ._dataPoints.length &&
          chart.series[seriesIndex].enableTooltip) {
        //to show the tooltip template when the provided indices are valid
        _chartState._circularArea
            ._showCircularTooltipTemplate(seriesIndex, pointIndex);
      } else if (chart.tooltipBehavior.builder == null &&
          chartState._animationCompleted == true &&
          pointIndex >= 0 &&
          (pointIndex + 1 <=
              _chartState._chartSeries.visibleSeriesRenderers[seriesIndex]
                  ._renderPoints.length)) {
        final ChartPoint<dynamic> chartPoint = _chartState._chartSeries
            .visibleSeriesRenderers[seriesIndex]._renderPoints[pointIndex];
        if (chartPoint.isVisible) {
          final Offset position = _degreeToPoint(
              chartPoint.midAngle!,
              (chartPoint.innerRadius! + chartPoint.outerRadius!) / 2,
              chartPoint.center!);
          x = position.dx;
          y = position.dy;
          tooltipBehaviorRenderer._showTooltip(x, y);
        }
      }
    } else if (pointIndex != null && // ignore: unnecessary_null_comparison
        pointIndex <
            _chartState
                ._chartSeries.visibleSeriesRenderers[0]._dataPoints.length) {
      //this shows the tooltip for triangular type of charts (funnerl and pyramid)
      if (chart.tooltipBehavior.builder == null) {
        _chartState._tooltipPointIndex = pointIndex;
        final Offset? position = _chartState._chartSeries
            .visibleSeriesRenderers[0]._dataPoints[pointIndex].region?.center;
        x = position?.dx;
        y = position?.dy;
        tooltipBehaviorRenderer._showTooltip(x, y);
      } else {
        if (chart is SfFunnelChart && chartState._animationCompleted == true) {
          _chartState._funnelplotArea._showFunnelTooltipTemplate(pointIndex);
        } else if (chart is SfPyramidChart &&
            chartState._animationCompleted == true) {
          _chartState._chartPlotArea._showPyramidTooltipTemplate(pointIndex);
        }
      }
    }
    tooltipBehaviorRenderer._isInteraction = false;
  }

  /// Hides the tooltip if it is displayed.
  void hide() {
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        _chartState._renderingDetails.tooltipBehaviorRenderer;
    // ignore: unnecessary_null_comparison
    if (tooltipBehaviorRenderer != null) {
      tooltipBehaviorRenderer._showLocation = null;
      tooltipBehaviorRenderer._show = false;
    }
    if (builder != null) {
      // hides tooltip template
      tooltipBehaviorRenderer._chartTooltipState?.hide(hideDelay: 0);
    } else {
      //hides default tooltip
      tooltipBehaviorRenderer._currentTooltipValue =
          tooltipBehaviorRenderer._prevTooltipValue = null;

      tooltipBehaviorRenderer._chartTooltipState?.hide(hideDelay: 0);
    }
  }
}

///Tooltip behavior renderer class for mutable fields and methods
class TooltipBehaviorRenderer with ChartBehavior {
  /// Creates an argument constructor for Tooltip renderer class
  TooltipBehaviorRenderer(this._chartState);

  dynamic get _chart => _chartState?._chart;

  final dynamic _chartState;

  TooltipBehavior get _tooltipBehavior =>
      _chart?.tooltipBehavior as TooltipBehavior;

  SfTooltip? _chartTooltip;

  //ignore: prefer_final_fields
  bool _isInteraction = false;

  //ignore: prefer_final_fields
  bool _isHovering = false, _mouseTooltip = false;

  Widget? _tooltipTemplate;

  TooltipRenderBox? get _renderBox => _chartTooltipState?.renderBox;

  SfTooltipState? get _chartTooltipState {
    if (_chartTooltip != null) {
      final State? state = (_chartTooltip?.key as GlobalKey).currentState;
      //ignore: avoid_as
      return state != null ? state as SfTooltipState : null;
    }
  }

  List<String> _textValues = <String>[];
  List<CartesianSeriesRenderer> _seriesRendererCollection =
      <CartesianSeriesRenderer>[];

  TooltipValue? _prevTooltipValue;
  TooltipValue? _presentTooltipValue;
  TooltipValue? _currentTooltipValue;

  CartesianSeriesRenderer? _seriesRenderer;
  dynamic _currentSeries, _dataPoint;
  int? _pointIndex;
  late int _seriesIndex;
  late Color _markerColor;
  late DataMarkerType _markerType;
  bool _show = false;
  Offset? _showLocation;
  Rect? _tooltipBounds;
  String? _stringVal, _header;
  set _stringValue(String? value) {
    _stringVal = value;
  }

  /// Hides the Mouse tooltip if it is displayed.
  void _hideMouseTooltip() => _hide();

  /// Draws tooltip
  ///
  /// * canvas -Canvas used to draw tooltip
  @override
  void onPaint(Canvas canvas) {}

  /// Performs the double-tap action of appropriate point.
  ///
  /// Hits while double tapping on the chart.
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  @override
  void onDoubleTap(double xPos, double yPos) =>
      _tooltipBehavior.showByPixel(xPos, yPos);

  /// Performs the double-tap action of appropriate point.
  ///
  /// Hits while a long tap on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  @override
  void onLongPress(double xPos, double yPos) =>
      _tooltipBehavior.showByPixel(xPos, yPos);

  /// Performs the touch-down action of appropriate point.
  ///
  /// Hits while tapping on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  @override
  void onTouchDown(double xPos, double yPos) =>
      _tooltipBehavior.showByPixel(xPos, yPos);

  /// Performs the touch move action of chart.
  ///
  /// Hits while tap and moving on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// *  yPos - Y value of the touch position.
  @override
  void onTouchMove(double xPos, double yPos) {
    // Not valid for tooltip
  }

  /// Performs the touch move action of chart.
  ///
  /// Hits while release tap on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  @override
  void onTouchUp(double xPos, double yPos) =>
      _tooltipBehavior.showByPixel(xPos, yPos);

  /// Performs the mouse hover action of chart.
  ///
  /// Hits while enter tap on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  @override
  void onEnter(double xPos, double yPos) =>
      _tooltipBehavior.showByPixel(xPos, yPos);

  /// Performs the mouse exit action of chart.
  ///
  /// Hits while exit tap on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  @override
  void onExit(double xPos, double yPos) {
    if (_renderBox != null && _tooltipBehavior.builder != null) {
      _hideMouseTooltip();
    }
  }

  /// To render chart tooltip
  // ignore:unused_element
  void _renderTooltipView(Offset position) {
    if (_chart is SfCartesianChart) {
      _renderCartesianChartTooltip(position);
    } else if (_chart is SfCircularChart) {
      _renderCircularChartTooltip(position);
    } else {
      _renderTriangularChartTooltip(position);
    }
  }

  /// To show tooltip with position offsets
  void _showTooltip(double? x, double? y) {
    if (x != null &&
        y != null &&
        _renderBox != null &&
        _chartTooltipState != null) {
      _show = true;
      _mouseTooltip = false;
      _isHovering ? _showMouseTooltip(x, y) : _showTooltipView(x, y);
    }
  }

  /// To show the chart tooltip
  void _showTooltipView(double x, double y) {
    if (_tooltipBehavior.enable &&
        _renderBox != null &&
        _chartState._animationCompleted == true) {
      _renderTooltipView(Offset(x, y));
      if (_presentTooltipValue != null &&
          _tooltipBehavior.tooltipPosition != TooltipPosition.pointer) {
        _chartTooltipState!.boundaryRect = _tooltipBounds!;
        if (_showLocation != null) {
          _chartTooltipState?.needMarker = _chart is SfCartesianChart;
          _resolveLocation();
          _chartTooltipState?.show(
              tooltipHeader: _header,
              tooltipContent: _stringVal,
              tooltipData: _presentTooltipValue,
              position: _showLocation,
              duration: _tooltipBehavior.animationDuration);
        }
      } else {
        if (_tooltipBehavior.tooltipPosition == TooltipPosition.pointer &&
            ((_chart is SfCartesianChart) == false ||
                _currentSeries._isRectSeries == true)) {
          _presentTooltipValue?.pointerPosition = _showLocation;
          _chartTooltipState!.boundaryRect = _tooltipBounds!;
          if (_showLocation != null) {
            _chartTooltipState?.needMarker = _chart is SfCartesianChart;
            _chartTooltipState?.show(
                tooltipHeader: _header,
                tooltipContent: _stringVal,
                tooltipData: _presentTooltipValue,
                position: _showLocation,
                duration: _tooltipBehavior.animationDuration);
          }
          _currentTooltipValue = _presentTooltipValue;
        }
      }
      assert(
          // ignore: unnecessary_null_comparison
          !(_tooltipBehavior.duration != null) ||
              _tooltipBehavior.duration >= 0,
          'The duration time for the tooltip must not be less than 0.');
      if (!_tooltipBehavior.shouldAlwaysShow) {
        _show = false;
        _currentTooltipValue = _presentTooltipValue = null;
        if (_chartTooltipState != null && _renderBox != null) {
          _chartTooltipState?.hide(
              hideDelay: _tooltipBehavior.duration.toInt());
        }
      }
    }
  }

  // this method resolves the position issue when the markerPoint is residing
  // out of the axis cliprect
  void _resolveLocation() {
    if (_chart is SfCartesianChart &&
        _tooltipBehavior.tooltipPosition == TooltipPosition.auto &&
        (_seriesRenderer!._isRectSeries ||
            _seriesRenderer!._seriesType.contains('bubble') ||
            _seriesRenderer!._seriesType.contains('candle') ||
            _seriesRenderer!._seriesType.contains('boxandwhisker') ||
            _seriesRenderer!._seriesType.contains('waterfall'))) {
      Offset position = _showLocation!;
      final Rect bounds = _chartState._chartAxis._axisClipRect;
      if (!_isPointWithInRect(position, bounds)) {
        if (position.dy < bounds.top) {
          position = Offset(position.dx, bounds.top);
        }
        if (position.dx < bounds.left) {
          position = Offset(bounds.left, position.dy);
        } else if (position.dx > bounds.right) {
          position = Offset(bounds.right, position.dy);
        }
      }
      _showLocation = position;
    }
  }

  /// This method shows the tooltip for any logical pixel outside point region
  //ignore: unused_element
  void _showChartAreaTooltip(Offset position, ChartAxisRenderer xAxisRenderer,
      ChartAxisRenderer yAxisRenderer, dynamic chart) {
    _showLocation = position;
    final ChartAxis xAxis = xAxisRenderer._axis, yAxis = yAxisRenderer._axis;
    if (_tooltipBehavior.enable &&
        _renderBox != null &&
        _chartState._animationCompleted == true) {
      _tooltipBounds = _chartState._chartAxis._axisClipRect;
      _chartTooltipState!.boundaryRect = _tooltipBounds!;
      if (_isPointWithInRect(position, _chartState._chartAxis._axisClipRect)) {
        _currentSeries = _chartState._chartSeries.visibleSeriesRenderers[0];
        _currentSeries = _chartState._chartSeries.visibleSeriesRenderers[0];
        _renderBox!.normalPadding = 5;
        _renderBox!.inversePadding = 5;
        _header = '';
        dynamic xValue = _pointToXValue(
            _chartState._requireInvertedAxis,
            xAxisRenderer,
            xAxisRenderer._bounds,
            position.dx -
                (_chartState._chartAxis._axisClipRect.left + xAxis.plotOffset),
            position.dy -
                (_chartState._chartAxis._axisClipRect.top + xAxis.plotOffset));
        dynamic yValue = _pointToYValue(
            _chartState._requireInvertedAxis,
            yAxisRenderer,
            yAxisRenderer._bounds,
            position.dx -
                (_chartState._chartAxis._axisClipRect.left + yAxis.plotOffset),
            position.dy -
                (_chartState._chartAxis._axisClipRect.top + yAxis.plotOffset));
        if (xAxisRenderer is DateTimeAxisRenderer) {
          final DateTimeAxis xAxis = xAxisRenderer._axis as DateTimeAxis;
          xValue = (xAxis.dateFormat ?? _getDateTimeLabelFormat(xAxisRenderer))
              .format(DateTime.fromMillisecondsSinceEpoch(xValue.floor()));
        } else if (xAxisRenderer is DateTimeCategoryAxisRenderer) {
          xValue = xAxisRenderer._dateFormat
              .format(DateTime.fromMillisecondsSinceEpoch(xValue.floor()));
        } else if (xAxisRenderer is CategoryAxisRenderer) {
          xValue = xAxisRenderer._visibleLabels[xValue.toInt()].text;
        } else if (xAxisRenderer is NumericAxisRenderer) {
          xValue = xValue.toStringAsFixed(2).contains('.00') == true
              ? xValue.floor()
              : xValue.toStringAsFixed(2);
        }

        if (yAxisRenderer is NumericAxisRenderer ||
            yAxisRenderer is LogarithmicAxisRenderer) {
          yValue = yValue.toStringAsFixed(2).contains('.00') == true
              ? yValue.floor()
              : yValue.toStringAsFixed(2);
        }
        _stringValue = ' $xValue :  $yValue ';
        _showLocation = position;
      }

      if (_showLocation != null &&
          _stringVal != null &&
          _tooltipBounds != null) {
        _chartTooltipState?.needMarker = false;
        _chartTooltipState?.show(
            tooltipHeader: _header,
            tooltipContent: _stringVal,
            tooltipData: _presentTooltipValue,
            position: _showLocation,
            duration: _tooltipBehavior.animationDuration);
      }

      if (!_tooltipBehavior.shouldAlwaysShow) {
        _show = false;
        if (_chartTooltipState != null && _renderBox != null) {
          _chartTooltipState?.hide();
        }
      }
    }
  }

  void _showTemplateTooltip(Offset position, [dynamic xValue, dynamic yValue]) {
    final dynamic chart = _chartState._chart;
    _presentTooltipValue = null;
    _tooltipBounds = _chartState._chartAxis._axisClipRect;
    dynamic series;
    double yPadding = 0;
    if (_isPointWithInRect(position, _chartState._chartAxis._axisClipRect) &&
        _chartState._animationCompleted == true) {
      int? seriesIndex, pointIndex;
      int outlierIndex = -1;
      bool isTooltipRegion = false;
      if (!_isHovering) {
        //assingning null for the previous and current tooltip values in case of mouse not hovering
        _prevTooltipValue = null;
        _currentTooltipValue = null;
      }
      for (int i = 0;
          i < _chartState._chartSeries.visibleSeriesRenderers.length;
          i++) {
        final CartesianSeriesRenderer seriesRenderer =
            _chartState._chartSeries.visibleSeriesRenderers[i];
        series = seriesRenderer._series;

        int j = 0;
        if (seriesRenderer._visible! &&
            series.enableTooltip == true &&
            seriesRenderer._regionalData != null) {
          seriesRenderer._regionalData!
              .forEach((dynamic regionRect, dynamic values) {
            final bool isTrendLine = values[values.length - 1].contains('true');
            final double padding = ((seriesRenderer._seriesType == 'bubble' ||
                        seriesRenderer._seriesType == 'scatter' ||
                        seriesRenderer._seriesType.contains('column') ||
                        seriesRenderer._seriesType.contains('bar') ||
                        seriesRenderer._seriesType == 'histogram') &&
                    !isTrendLine)
                ? 0
                : _isHovering
                    ? 0
                    : 15;
            final Rect region = regionRect[0];
            final double left = region.left - padding;
            final double right = region.right + padding;
            final double top = region.top - padding;
            final double bottom = region.bottom + padding;
            Rect paddedRegion = Rect.fromLTRB(left, top, right, bottom);
            final List<Rect>? outlierRegion = regionRect[5];

            if (outlierRegion != null) {
              for (int rectIndex = 0;
                  rectIndex < outlierRegion.length;
                  rectIndex++) {
                if (outlierRegion[rectIndex].contains(position)) {
                  paddedRegion = outlierRegion[rectIndex];
                  outlierIndex = rectIndex;
                }
              }
            }

            if (paddedRegion.contains(position)) {
              _seriesIndex = seriesIndex = i;
              _currentSeries = seriesRenderer;
              _pointIndex = pointIndex =
                  seriesRenderer._dataPoints.indexOf(regionRect[4]);
              Offset tooltipPosition = !(seriesRenderer._isRectSeries &&
                      _tooltipBehavior.tooltipPosition != TooltipPosition.auto)
                  ? ((outlierIndex >= 0)
                      ? regionRect[6][outlierIndex]
                      : regionRect[1])
                  : position;
              final List<Offset?> paddingData = _getTooltipPaddingData(
                  seriesRenderer,
                  isTrendLine,
                  region,
                  paddedRegion,
                  tooltipPosition);
              yPadding = paddingData[0]!.dy;
              tooltipPosition = paddingData[1] ?? tooltipPosition;
              _showLocation = tooltipPosition;
              _seriesRenderer = seriesRenderer;
              _renderBox!.normalPadding =
                  _seriesRenderer is BubbleSeriesRenderer ? 0 : yPadding;
              _renderBox!.inversePadding = yPadding;
              _tooltipTemplate = chart.tooltipBehavior.builder(
                  series.dataSource[j], regionRect[4], series, pointIndex, i);
              isTooltipRegion = true;
            }
            j++;
          });
        }
      }
      if (_isHovering && isTooltipRegion) {
        _prevTooltipValue = _currentTooltipValue;
        _currentTooltipValue =
            TooltipValue(seriesIndex, pointIndex!, outlierIndex);
      }
      final TooltipValue? presentTooltip = _presentTooltipValue;
      if (presentTooltip == null ||
          seriesIndex != presentTooltip.seriesIndex ||
          pointIndex != presentTooltip.pointIndex ||
          outlierIndex != presentTooltip.outlierIndex ||
          (_currentSeries != null &&
              _currentSeries._isRectSeries == true &&
              _tooltipBehavior.tooltipPosition != TooltipPosition.auto)) {
        //Current point is different than previous one so tooltip re-renders
        if (seriesIndex != null && pointIndex != null) {
          _presentTooltipValue =
              TooltipValue(seriesIndex, pointIndex!, outlierIndex);
        }
        if (isTooltipRegion && _tooltipTemplate != null) {
          _show = isTooltipRegion;
          _performTooltip();
          if (!_isHovering && _renderBox != null) {
            _hideTooltipTemplate();
          }
        }
      } else {
        //Current point is same as previous one so timer is reset and tooltip is not re-rendered
        if (!_isHovering) {
          _hideTooltipTemplate();
        }
      }

      if (!isTooltipRegion &&
          !_isInteraction &&
          chart.series.isNotEmpty == true) {
        //to show tooltip temlate when the position resides outside point region
        final dynamic x = xValue ??
            _pointToXValue(
                _chartState._requireInvertedAxis,
                _chartState._chartAxis._primaryXAxisRenderer,
                _chartState._chartAxis._primaryXAxisRenderer._bounds,
                position.dx -
                    (_chartState._chartAxis._axisClipRect.left +
                        chart.primaryXAxis.plotOffset),
                position.dy -
                    (_chartState._chartAxis._axisClipRect.top +
                        chart.primaryXAxis.plotOffset));
        final dynamic y = yValue ??
            _pointToYValue(
                _chartState._requireInvertedAxis,
                _chartState._chartAxis._primaryYAxisRenderer,
                _chartState._chartAxis._primaryYAxisRenderer._bounds,
                position.dx -
                    (_chartState._chartAxis._axisClipRect.left +
                        chart.primaryYAxis.plotOffset),
                position.dy -
                    (_chartState._chartAxis._axisClipRect.top +
                        chart.primaryYAxis.plotOffset));
        _renderBox!.normalPadding = 5;
        _renderBox!.inversePadding = 5;
        _showLocation = position;
        _tooltipTemplate = chart.tooltipBehavior.builder(
            null, CartesianChartPoint<dynamic>(x, y), null, null, null);
        isTooltipRegion = true;
        _show = isTooltipRegion;
        _performTooltip();
      }
      if (!isTooltipRegion) {
        _hideTooltipTemplate();
      }
    }
    _isInteraction = false;
  }

  /// To hide the tooltip when the timer ends
  void _hide() {
    if (!_tooltipBehavior.shouldAlwaysShow) {
      _show = false;
      _currentTooltipValue = _presentTooltipValue = null;
      if (_chartTooltipState != null && _renderBox != null) {
        _chartTooltipState?.hide(hideDelay: _tooltipBehavior.duration.toInt());
      }
    }
  }

  /// To hide tooltip templates
  void _hideTooltipTemplate() {
    if (_tooltipBehavior.shouldAlwaysShow == false) {
      _show = false;
      _chartTooltipState?.hide(hideDelay: _tooltipBehavior.duration.toInt());
      _prevTooltipValue = null;
      _currentTooltipValue = null;
      _presentTooltipValue = null;
    }
  }

  /// To perform rendering of tooltip
  void _performTooltip() {
    //for mouse hover the tooltip is redrawn only when the current tooltip value differs from the previous one
    if (_show &&
        ((_prevTooltipValue == null && _currentTooltipValue == null) ||
            (_chartState is SfCartesianChartState &&
                (_currentSeries?._isRectSeries ?? false) == true &&
                _tooltipBehavior.tooltipPosition != TooltipPosition.auto) ||
            (_prevTooltipValue?.seriesIndex !=
                    _currentTooltipValue?.seriesIndex ||
                _prevTooltipValue?.outlierIndex !=
                    _currentTooltipValue?.outlierIndex ||
                _prevTooltipValue?.pointIndex !=
                    _currentTooltipValue?.pointIndex))) {
      final bool reRender = _isHovering &&
          _prevTooltipValue != null &&
          _currentTooltipValue != null &&
          _prevTooltipValue!.seriesIndex == _currentTooltipValue!.seriesIndex &&
          _prevTooltipValue!.pointIndex == _currentTooltipValue!.pointIndex &&
          _prevTooltipValue!.outlierIndex == _currentTooltipValue!.outlierIndex;
      if (_tooltipBehavior.builder != null && _tooltipBounds != null) {
        _chartTooltipState!.boundaryRect = _tooltipBounds!;
        if (_tooltipBehavior.tooltipPosition != TooltipPosition.auto)
          _presentTooltipValue!.pointerPosition = _showLocation;
        if (_showLocation != null) {
          _resolveLocation();
          _chartTooltipState?.show(
              tooltipData: _presentTooltipValue,
              position: _showLocation,
              duration:
                  (!reRender) ? _tooltipBehavior.animationDuration.toInt() : 0,
              template: _tooltipTemplate);
        }
      }
    }
  }

  /// To show tooltip on mouse pointer actions
  void _showMouseTooltip(double x, double y) {
    if (_tooltipBehavior.enable &&
        _renderBox != null &&
        _chartState._animationCompleted == true) {
      _renderTooltipView(Offset(x, y));
      if (!_mouseTooltip) {
        _chartTooltipState?.hide(hideDelay: _tooltipBehavior.duration.toInt());
        _currentTooltipValue = null;
      } else {
        if (_presentTooltipValue != null &&
            (_currentTooltipValue == null ||
                _tooltipBehavior.tooltipPosition == TooltipPosition.auto)) {
          _chartTooltipState!.boundaryRect = _tooltipBounds!;
          if (_tooltipBehavior.tooltipPosition != TooltipPosition.auto)
            _presentTooltipValue!.pointerPosition = _showLocation;
          if (_showLocation != null) {
            _chartTooltipState?.needMarker = _chart is SfCartesianChart;
            _resolveLocation();
            _chartTooltipState?.show(
                tooltipHeader: _header,
                tooltipContent: _stringVal,
                tooltipData: _presentTooltipValue,
                position: _showLocation,
                duration: _tooltipBehavior.animationDuration);
          }
          _currentTooltipValue = _presentTooltipValue;
        } else if (_presentTooltipValue != null &&
            _currentTooltipValue != null &&
            _tooltipBehavior.tooltipPosition != TooltipPosition.auto &&
            ((_seriesRenderer is CartesianSeriesRenderer) == false ||
                _seriesRenderer!._isRectSeries)) {
          _presentTooltipValue!.pointerPosition = _showLocation;
          _chartTooltipState!.boundaryRect = _tooltipBounds!;
          if (_showLocation != null) {
            _chartTooltipState?.needMarker = _chart is SfCartesianChart;
            _resolveLocation();
            _chartTooltipState?.show(
                tooltipHeader: _header,
                tooltipContent: _stringVal,
                tooltipData: _presentTooltipValue,
                position: _showLocation,
                duration: 0);
          }
        }
      }
    }
  }

  void _tooltipRenderingEvent(TooltipRenderArgs args) {
    String? header = args.header;
    String? stringValue = args.text;
    double? x = args.location?.dx, y = args.location?.dy;
    TooltipArgs tooltipArgs;
    if (x != null &&
        y != null &&
        stringValue != null &&
        _currentSeries != null) {
      final int seriesIndex = _chart is SfCartesianChart
          ? _currentSeries._segments[0]._seriesIndex
          : 0;
      if ((_chart is SfCartesianChart &&
              _chartState._requireAxisTooltip == false) ||
          (_chart is SfCartesianChart) == false) {
        if (_chart.onTooltipRender != null &&
            _dataPoint != null &&
            (_dataPoint.isTooltipRenderEvent ?? false) == false) {
          _dataPoint.isTooltipRenderEvent = true;
          tooltipArgs = TooltipArgs(
              seriesIndex,
              _chartState
                  ._chartSeries.visibleSeriesRenderers[seriesIndex]._dataPoints,
              _pointIndex,
              _chart is SfCartesianChart
                  ? _chartState._chartSeries.visibleSeriesRenderers[seriesIndex]
                      ._visibleDataPoints[_pointIndex].overallDataPointIndex
                  : _pointIndex);
          tooltipArgs.text = stringValue;
          tooltipArgs.header = header;
          _dataPoint._tooltipLabelText = stringValue;
          _dataPoint._tooltipHeaderText = header;
          tooltipArgs.locationX = x;
          tooltipArgs.locationY = y;
          _chart.onTooltipRender(tooltipArgs);
          stringValue = tooltipArgs.text;
          header = tooltipArgs.header;
          x = tooltipArgs.locationX;
          y = tooltipArgs.locationY;
          _dataPoint._tooltipLabelText = tooltipArgs.text;
          _dataPoint._tooltipHeaderText = tooltipArgs.header;
          _dataPoint.isTooltipRenderEvent = false;
          args.text = stringValue!;
          args.header = header;
          args.location = Offset(x!, y!);
        } else if (_chart.onTooltipRender != null) {
          //Fires the on tooltip render event when the tooltip is shown outside point region
          tooltipArgs = TooltipArgs(null, null, null);
          tooltipArgs.text = stringValue;
          tooltipArgs.header = header;
          tooltipArgs.locationX = x;
          tooltipArgs.locationY = y;
          _chart.onTooltipRender(tooltipArgs);
          args.text = tooltipArgs.text;
          args.header = tooltipArgs.header;
          args.location =
              Offset(tooltipArgs.locationX!, tooltipArgs.locationY!);
        }
        if (_chart.onTooltipRender != null && _dataPoint != null) {
          stringValue = _dataPoint._tooltipLabelText;
          header = _dataPoint._tooltipHeaderText;
        }
      }
    }
  }

  /// To render a chart tooltip for circular series
  void _renderCircularChartTooltip(Offset position) {
    final SfCircularChart chart = _chartState._chart;
    _tooltipBounds = _chartState._renderingDetails.chartContainerRect;
    bool isContains = false;
    final _Region? pointRegion = _getCircularPointRegion(
        chart, position, _chartState._chartSeries.visibleSeriesRenderers[0]);
    if (pointRegion != null &&
        _chartState._chartSeries.visibleSeriesRenderers[pointRegion.seriesIndex]
                ._series.enableTooltip ==
            true) {
      _prevTooltipValue =
          TooltipValue(pointRegion.seriesIndex, pointRegion.pointIndex);
      _presentTooltipValue = _prevTooltipValue;
      if (_prevTooltipValue != null &&
          _currentTooltipValue != null &&
          _prevTooltipValue!.pointIndex != _currentTooltipValue!.pointIndex) {
        _currentTooltipValue = null;
      }
      final ChartPoint<dynamic> chartPoint = _chartState
          ._chartSeries
          .visibleSeriesRenderers[pointRegion.seriesIndex]
          ._renderPoints[pointRegion.pointIndex];
      final Offset location =
          chart.tooltipBehavior.tooltipPosition == TooltipPosition.pointer
              ? position
              : _degreeToPoint(
                  chartPoint.midAngle!,
                  (chartPoint.innerRadius! + chartPoint.outerRadius!) / 2,
                  chartPoint.center!);
      _currentSeries = pointRegion.seriesIndex;
      _pointIndex = pointRegion.pointIndex;
      _dataPoint = _chartState
          ._chartSeries.visibleSeriesRenderers[0]._dataPoints[_pointIndex];
      final int digits = chart.tooltipBehavior.decimalPlaces;
      String? header = chart.tooltipBehavior.header;
      header = (header == null)
          // ignore: prefer_if_null_operators
          ? _chartState
                      ._chartSeries
                      .visibleSeriesRenderers[pointRegion.seriesIndex]
                      ._series
                      .name !=
                  null
              ? _chartState._chartSeries
                  .visibleSeriesRenderers[pointRegion.seriesIndex]._series.name
              : null
          : header;
      _header = header ?? '';
      if (chart.tooltipBehavior.format != null) {
        final String resultantString = chart.tooltipBehavior.format!
            .replaceAll('point.x', chartPoint.x.toString())
            .replaceAll('point.y', _getDecimalLabelValue(chartPoint.y, digits))
            .replaceAll(
                'series.name',
                _chartState
                        ._chartSeries
                        .visibleSeriesRenderers[pointRegion.seriesIndex]
                        ._series
                        .name ??
                    'series.name');
        _stringValue = resultantString;
        _showLocation = location;
      } else {
        _stringValue = chartPoint.x.toString() +
            ' : ' +
            _getDecimalLabelValue(chartPoint.y, digits);
        _showLocation = location;
      }
      if (chart.series[0].explode) {
        _presentTooltipValue!.pointerPosition = _showLocation;
      }
      isContains = true;
    } else {
      isContains = false;
    }
    _mouseTooltip = isContains;
    if (!isContains) {
      _prevTooltipValue = _currentTooltipValue = null;
    }
  }

  /// To render a chart tooltip for triangular series
  void _renderTriangularChartTooltip(Offset position) {
    final dynamic chart = _chart;
    final dynamic chartState = _chartState;

    _tooltipBounds = chartState._renderingDetails.chartContainerRect;
    bool isContains = false;
    const int seriesIndex = 0;
    _pointIndex = _chartState._tooltipPointIndex;
    if (_pointIndex == null &&
        _chartState._renderingDetails.currentActive == null) {
      int? _pointIndex;
      bool isPoint;
      final dynamic seriesRenderer =
          chartState._chartSeries.visibleSeriesRenderers[seriesIndex];
      for (int j = 0; j < seriesRenderer._renderPoints.length; j++) {
        if (seriesRenderer._renderPoints[j].isVisible == true) {
          isPoint = _isPointInPolygon(
              seriesRenderer._renderPoints[j].pathRegion, position);
          if (isPoint) {
            _pointIndex = j;
            break;
          }
        }
      }
      chartState._renderingDetails.currentActive = _ChartInteraction(
        seriesIndex,
        _pointIndex,
        seriesRenderer._series,
        seriesRenderer._renderPoints[_pointIndex],
      );
    }
    _pointIndex ??= chartState._renderingDetails.currentActive.pointIndex;
    _dataPoint = _chartState
        ._chartSeries.visibleSeriesRenderers[0]._dataPoints[_pointIndex];
    _chartState._tooltipPointIndex = null;
    final int digits = chart.tooltipBehavior.decimalPlaces;
    if (chart.tooltipBehavior.enable == true) {
      _prevTooltipValue = TooltipValue(seriesIndex, _pointIndex!);
      _presentTooltipValue = _prevTooltipValue;
      if (_prevTooltipValue != null &&
          _currentTooltipValue != null &&
          _prevTooltipValue!.pointIndex != _currentTooltipValue!.pointIndex) {
        _currentTooltipValue = null;
      }
      final PointInfo<dynamic> chartPoint = _chartState._chartSeries
          .visibleSeriesRenderers[seriesIndex]._renderPoints[_pointIndex];
      final Offset location = chart.tooltipBehavior.tooltipPosition ==
                  TooltipPosition.pointer &&
              _chartState._chartSeries.visibleSeriesRenderers[seriesIndex]
                      ._series.explode ==
                  true
          ? chartPoint.symbolLocation
          : chart.tooltipBehavior.tooltipPosition == TooltipPosition.pointer &&
                  _chartState._chartSeries.visibleSeriesRenderers[seriesIndex]
                          ._series.explode ==
                      false
              ? position
              : chartPoint.symbolLocation;
      _currentSeries = seriesIndex;
      String? header = chart.tooltipBehavior.header;
      header = (header == null)
          // ignore: prefer_if_null_operators
          ? _chartState._chartSeries.visibleSeriesRenderers[seriesIndex]._series
                      .name !=
                  null
              ? _chartState
                  ._chartSeries.visibleSeriesRenderers[seriesIndex]._series.name
              : null
          : header;
      _header = header ?? '';
      if (chart.tooltipBehavior.format != null) {
        final String resultantString = chart.tooltipBehavior.format
            .replaceAll('point.x', chartPoint.x.toString())
            .replaceAll('point.y', _getDecimalLabelValue(chartPoint.y, digits))
            .replaceAll(
                'series.name',
                _chartState._chartSeries.visibleSeriesRenderers[seriesIndex]
                        ._series.name ??
                    'series.name');
        _stringValue = resultantString;
        _showLocation = location;
      } else {
        _stringValue = chartPoint.x.toString() +
            ' : ' +
            _getDecimalLabelValue(chartPoint.y, digits);
        _showLocation = location;
      }
      isContains = true;
    } else {
      isContains = false;
    }
    if (chart.series.explode == true) {
      _presentTooltipValue!.pointerPosition = _showLocation;
    }
    _mouseTooltip = isContains;
    if (!isContains) {
      _prevTooltipValue = _currentTooltipValue = null;
    }
  }

  /// To show the axis label tooltip for trimmed axes label texts.
  void _showAxisTooltip(Offset position, dynamic chart, String text) {
    final _RenderingDetails renderingDetails = _chartState._renderingDetails;
    if (_renderBox != null) {
      _header = '';
      _stringValue = text;
      _showLocation = position;
      _tooltipBounds = renderingDetails.chartContainerRect;
      _renderBox!.inversePadding = 0;
      _chartTooltipState!.boundaryRect = _tooltipBounds!;
      if (_showLocation != null) {
        _chartTooltipState?.needMarker = false;
        _chartTooltipState?.show(
            tooltipHeader: _header,
            tooltipContent: _stringVal,
            tooltipData: _currentTooltipValue,
            position: _showLocation,
            duration: 0);
      }
      if (!_isHovering) {
        _chartTooltipState?.hide(hideDelay: _tooltipBehavior.duration.toInt());
      }
    }
  }

  /// To render a chart tooltip for cartesian series
  void _renderCartesianChartTooltip(Offset position) {
    bool isContains = false;
    if (_isPointWithInRect(position, _chartState._chartAxis._axisClipRect)) {
      Offset? tooltipPosition;
      double touchPadding;
      Offset? padding;
      bool? isTrendLine;
      dynamic dataRect;
      dynamic dataValues;
      bool outlierTooltip = false;
      int outlierTooltipIndex = -1;
      final List<LinearGradient?> markerGradients = <LinearGradient?>[];
      final List<Paint?> markerPaints = <Paint?>[];
      final List<DataMarkerType?> markerTypes = <DataMarkerType?>[];
      final List<dynamic> markerImages = <dynamic>[];
      for (int i = 0;
          i < _chartState._chartSeries.visibleSeriesRenderers.length;
          i++) {
        _seriesRenderer = _chartState._chartSeries.visibleSeriesRenderers[i];
        final CartesianSeries<dynamic, dynamic> series =
            _seriesRenderer!._series;
        if (_seriesRenderer!._visible! &&
            series.enableTooltip &&
            _seriesRenderer?._regionalData != null) {
          int count = 0;
          _seriesRenderer!._regionalData!
              .forEach((dynamic regionRect, dynamic values) {
            isTrendLine = values[values.length - 1].contains('true');
            touchPadding = ((_seriesRenderer!._seriesType == 'bubble' ||
                        _seriesRenderer!._seriesType == 'scatter' ||
                        _seriesRenderer!._seriesType.contains('column') ||
                        _seriesRenderer!._seriesType.contains('bar') ||
                        _seriesRenderer!._seriesType == 'histogram') &&
                    !isTrendLine!)
                ? 0
                : _isHovering
                    ? 0
                    : 15; // regional padding to detect smooth touch
            final Rect region = regionRect[0];
            final List<Rect>? outlierRegion = regionRect[5];
            final double left = region.left - touchPadding;
            final double right = region.right + touchPadding;
            final double top = region.top - touchPadding;
            final double bottom = region.bottom + touchPadding;
            Rect paddedRegion = Rect.fromLTRB(left, top, right, bottom);
            if (outlierRegion != null) {
              for (int rectIndex = 0;
                  rectIndex < outlierRegion.length;
                  rectIndex++) {
                if (outlierRegion[rectIndex].contains(position)) {
                  paddedRegion = outlierRegion[rectIndex];
                  outlierTooltipIndex = rectIndex;
                  outlierTooltip = true;
                }
              }
            }

            if (paddedRegion.contains(position) &&
                (isTrendLine! ? regionRect[4].isVisible : true) == true) {
              _tooltipBounds = _chartState._chartAxis._axisClipRect;
              if (_seriesRenderer!._seriesType != 'boxandwhisker'
                  ? !region.contains(position)
                  : (paddedRegion.contains(position) ||
                      !region.contains(position))) {
                _tooltipBounds = _chartState._chartAxis._axisClipRect;
              }
              _presentTooltipValue =
                  TooltipValue(i, count, outlierTooltipIndex);
              _currentSeries = _seriesRenderer;
              _pointIndex = _chart is SfCartesianChart
                  ? regionRect[4].visiblePointIndex
                  : count;
              _dataPoint = regionRect[4];
              _markerType = _seriesRenderer!._series.markerSettings.shape;
              Color? seriesColor = _seriesRenderer!._seriesColor;
              if (_seriesRenderer!._seriesType == 'waterfall') {
                seriesColor = _getWaterfallSeriesColor(
                    _seriesRenderer!._series
                        as WaterfallSeries<dynamic, dynamic>,
                    _seriesRenderer!._dataPoints[_pointIndex!],
                    seriesColor)!;
              }
              _markerColor = regionRect[2] ??
                  _seriesRenderer!._series.markerSettings.borderColor ??
                  seriesColor!;
              tooltipPosition = (outlierTooltipIndex >= 0)
                  ? regionRect[6][outlierTooltipIndex]
                  : regionRect[1];
              final Paint markerPaint = Paint();
              markerPaint.color = (!_tooltipBehavior.shared
                      ? _markerColor
                      : _seriesRenderer!._series.markerSettings.borderColor ??
                          _seriesRenderer!._seriesColor ??
                          _seriesRenderer!._series.color)!
                  .withOpacity(_tooltipBehavior.opacity);
              if (!_tooltipBehavior.shared) {
                markerGradients
                  ..clear()
                  ..add(_seriesRenderer!._series.gradient);
                markerImages
                  ..clear()
                  ..add(_seriesRenderer!._markerSettingsRenderer?._image);
                markerPaints
                  ..clear()
                  ..add(markerPaint);
                markerTypes
                  ..clear()
                  ..add(_markerType);
              }
              final List<Offset?> paddingData = !(_seriesRenderer!
                          ._isRectSeries &&
                      _tooltipBehavior.tooltipPosition != TooltipPosition.auto)
                  ? _getTooltipPaddingData(_seriesRenderer!, isTrendLine!,
                      region, paddedRegion, tooltipPosition)
                  : <Offset?>[const Offset(2, 2), tooltipPosition];
              padding = paddingData[0];
              tooltipPosition = paddingData[1];
              _showLocation = tooltipPosition;
              dataValues = values;
              dataRect = regionRect;
              isContains = _mouseTooltip = true;
            }
            count++;
          });
          if (_tooltipBehavior.shared) {
            int indexValue = 0;
            int tooltipElementsLength = 0;
            final Paint markerPaint = Paint();
            markerPaint.color =
                _seriesRenderer!._series.markerSettings.borderColor ??
                    _seriesRenderer!._seriesColor ??
                    _seriesRenderer!._series.color!
                        .withOpacity(_tooltipBehavior.opacity);
            markerGradients.add(_seriesRenderer!._series.gradient);
            markerImages.add(_seriesRenderer!._markerSettingsRenderer?._image);
            markerTypes.add(_seriesRenderer!._series.markerSettings.shape);
            markerPaints.add(markerPaint);
            if ((_seriesRenderer!._seriesType.contains('range') ||
                    _seriesRenderer!._seriesType == 'hilo') &&
                !isTrendLine!) {
              // Assigned value '2' for this variable because for range and
              // hilo series there will be two display value types
              // such as high and low.
              tooltipElementsLength = 2;
              indexValue = _getTooltipNewLineLength(tooltipElementsLength);
            } else if (_seriesRenderer!._seriesType == 'hiloopenclose' ||
                _seriesRenderer!._seriesType == 'candle') {
              // Assigned value '4' for this variable because for hiloopenclose
              // and candle series there will be four display values
              // such as high, low, open and close.
              tooltipElementsLength = 4;
              indexValue = _getTooltipNewLineLength(tooltipElementsLength);
            } else if (_seriesRenderer!._seriesType == 'boxandwhisker') {
              // Assigned value '1' or '6' this variable field because for the
              // box and whiskers series there will be one display values if
              // the outlier's tooltip is activated otherwise there will be
              // six display values such as maximum, minimum, mean, median,
              // lowerQuartile and upperQuartile.
              tooltipElementsLength = outlierTooltip ? 1 : 6;
              indexValue = _getTooltipNewLineLength(tooltipElementsLength);
            } else {
              indexValue = _getTooltipNewLineLength(tooltipElementsLength);
            }
            for (int j = 0; j < indexValue; j++) {
              markerTypes.add(null);
              markerImages.add(null);
              markerGradients.add(null);
              markerPaints.add(null);
            }
          }
        }
      }
      if (isContains) {
        _renderBox!.markerGradients = markerGradients;
        _renderBox!.markerImages = markerImages;
        _renderBox!.markerPaints = markerPaints;
        _renderBox!.markerTypes = markerTypes;
        _seriesRenderer = _currentSeries ?? _seriesRenderer;
        if (_currentSeries._isRectSeries == true &&
            _tooltipBehavior.tooltipPosition == TooltipPosition.pointer) {
          tooltipPosition = position;
          _showLocation = tooltipPosition;
        }
        _renderBox!.normalPadding =
            _seriesRenderer is BubbleSeriesRenderer ? 0 : padding!.dy;
        _renderBox!.inversePadding = padding!.dy;
        String? header = _tooltipBehavior.header;
        header = (header == null)
            ? (_tooltipBehavior.shared
                ? dataValues[0]
                : (isTrendLine!
                    ? dataValues[dataValues.length - 2]
                    : _currentSeries._series.name ??
                        _currentSeries._seriesName))
            : header;
        _header = header ?? '';
        _stringValue = '';
        if (_tooltipBehavior.shared) {
          _textValues = <String>[];
          _seriesRendererCollection = <CartesianSeriesRenderer>[];
          for (int j = 0;
              j < _chartState._chartSeries.visibleSeriesRenderers.length;
              j++) {
            final CartesianSeriesRenderer seriesRenderer =
                _chartState._chartSeries.visibleSeriesRenderers[j];
            if (seriesRenderer._visible! &&
                seriesRenderer._series.enableTooltip) {
              final int index = seriesRenderer._xValues!.indexOf(dataRect[4].x);
              if (index > -1) {
                final String text = (_stringVal != '' ? '\n' : '') +
                    _calculateCartesianTooltipText(
                        seriesRenderer,
                        seriesRenderer._dataPoints[index],
                        dataValues,
                        tooltipPosition!,
                        outlierTooltip,
                        outlierTooltipIndex);
                _stringValue = _stringVal! + text;
                _textValues.add(text);
                _seriesRendererCollection.add(seriesRenderer);
              }
            }
          }
        } else {
          _stringValue = _calculateCartesianTooltipText(
              _currentSeries,
              dataRect[4],
              dataValues,
              tooltipPosition!,
              outlierTooltip,
              outlierTooltipIndex);
        }
        _showLocation = tooltipPosition;
      } else {
        _stringValue = null;
        if (!_isHovering) {
          _presentTooltipValue = _currentTooltipValue = null;
        } else {
          _mouseTooltip = isContains;
        }
      }
    }
  }

  /// It returns the tooltip text of cartesian series
  String _calculateCartesianTooltipText(
      CartesianSeriesRenderer seriesRenderer,
      CartesianChartPoint<dynamic> point,
      dynamic values,
      Offset tooltipPosition,
      bool outlierTooltip,
      int outlierTooltipIndex) {
    final bool isTrendLine = values[values.length - 1].contains('true');
    String resultantString;
    final ChartAxisRenderer axisRenderer = seriesRenderer._yAxisRenderer!;
    final TooltipBehavior tooltip = _tooltipBehavior;
    final int digits = seriesRenderer._chart.tooltipBehavior.decimalPlaces;
    String? minimumValue,
        maximumValue,
        lowerQuartileValue,
        upperQuartileValue,
        medianValue,
        meanValue,
        outlierValue,
        highValue,
        lowValue,
        openValue,
        closeValue,
        cumulativeValue,
        boxPlotString;
    if (seriesRenderer._seriesType == 'boxandwhisker') {
      minimumValue = _getLabelValue(point.minimum, axisRenderer._axis, digits);
      maximumValue = _getLabelValue(point.maximum, axisRenderer._axis, digits);
      lowerQuartileValue =
          _getLabelValue(point.lowerQuartile, axisRenderer._axis, digits);
      upperQuartileValue =
          _getLabelValue(point.upperQuartile, axisRenderer._axis, digits);
      medianValue = _getLabelValue(point.median, axisRenderer._axis, digits);
      meanValue = _getLabelValue(point.mean, axisRenderer._axis, digits);
      outlierValue = (point.outliers!.isNotEmpty && outlierTooltipIndex >= 0)
          ? _getLabelValue(
              point.outliers![outlierTooltipIndex], axisRenderer._axis, digits)
          : null;
      boxPlotString = '\nMinimum : ' +
          minimumValue +
          '\nMaximum : ' +
          maximumValue +
          '\nMedian : ' +
          medianValue +
          '\nMean : ' +
          meanValue +
          '\nLQ : ' +
          lowerQuartileValue +
          '\nHQ : ' +
          upperQuartileValue;
    } else if (seriesRenderer._seriesType.contains('range') ||
        seriesRenderer._seriesType == 'hilo' ||
        seriesRenderer._seriesType == 'hiloopenclose' ||
        seriesRenderer._seriesType == 'candle') {
      highValue = _getLabelValue(point.high, axisRenderer._axis, digits);
      lowValue = _getLabelValue(point.low, axisRenderer._axis, digits);
      if (seriesRenderer._seriesType == 'candle' ||
          seriesRenderer._seriesType == 'hiloopenclose') {
        openValue = _getLabelValue(point.open, axisRenderer._axis, digits);
        closeValue = _getLabelValue(point.close, axisRenderer._axis, digits);
      }
    } else if (seriesRenderer._seriesType.contains('stacked')) {
      cumulativeValue =
          _getLabelValue(point.cumulativeValue, axisRenderer._axis, digits);
    }
    if (_tooltipBehavior.format != null) {
      resultantString = (seriesRenderer._seriesType.contains('range') ||
                  seriesRenderer._seriesType == 'hilo') &&
              !isTrendLine
          ? (tooltip.format!
              .replaceAll('point.x', values[0])
              .replaceAll('point.high', highValue!)
              .replaceAll('point.low', lowValue!)
              .replaceAll('series.name',
                  seriesRenderer._series.name ?? seriesRenderer._seriesName!))
          : (seriesRenderer._seriesType.contains('hiloopenclose') ||
                      seriesRenderer._seriesType.contains('candle')) &&
                  !isTrendLine
              ? (tooltip.format!
                  .replaceAll('point.x', values[0])
                  .replaceAll('point.high', highValue!)
                  .replaceAll('point.low', lowValue!)
                  .replaceAll('point.open', openValue!)
                  .replaceAll('point.close', closeValue!)
                  .replaceAll(
                      'series.name',
                      seriesRenderer._series.name ??
                          seriesRenderer._seriesName!))
              : (seriesRenderer._seriesType.contains('boxandwhisker')) &&
                      !isTrendLine
                  ? (tooltip.format!
                      .replaceAll('point.x', values[0])
                      .replaceAll('point.minimum', minimumValue!)
                      .replaceAll('point.maximum', maximumValue!)
                      .replaceAll('point.lowerQuartile', lowerQuartileValue!)
                      .replaceAll('point.upperQuartile', upperQuartileValue!)
                      .replaceAll('point.mean', meanValue!)
                      .replaceAll('point.median', medianValue!)
                      .replaceAll('series.name',
                          seriesRenderer._series.name ?? seriesRenderer._seriesName!))
                  : seriesRenderer._seriesType.contains('stacked')
                      ? tooltip.format!.replaceAll('point.cumulativeValue', cumulativeValue!)
                      : seriesRenderer._seriesType == 'bubble'
                          ? tooltip.format!.replaceAll('point.x', values[0]).replaceAll('point.y', _getLabelValue(point.y, axisRenderer._axis, digits)).replaceAll('series.name', seriesRenderer._series.name ?? seriesRenderer._seriesName!).replaceAll('point.size', _getLabelValue(point.bubbleSize, axisRenderer._axis, digits))
                          : tooltip.format!.replaceAll('point.x', values[0]).replaceAll('point.y', _getLabelValue(point.y, axisRenderer._axis, digits)).replaceAll('series.name', seriesRenderer._series.name ?? seriesRenderer._seriesName!);
    } else {
      resultantString = (_tooltipBehavior.shared
              ? seriesRenderer._series.name ?? seriesRenderer._seriesName
              : values[0]) +
          (((seriesRenderer._seriesType.contains('range') ||
                      seriesRenderer._seriesType == 'hilo') &&
                  !isTrendLine)
              ? ('\nHigh : ' + highValue! + '\nLow : ' + lowValue!)
              : (seriesRenderer._seriesType == 'hiloopenclose' ||
                      seriesRenderer._seriesType == 'candle'
                  ? ('\nHigh : ' +
                      highValue! +
                      '\nLow : ' +
                      lowValue! +
                      '\nOpen : ' +
                      openValue! +
                      '\nClose : ' +
                      closeValue!)
                  : seriesRenderer._seriesType == 'boxandwhisker'
                      ? outlierValue != null
                          ? ('\nOutliers : ' + outlierValue)
                          : boxPlotString
                      : ' : ' +
                          _getLabelValue(point.y, axisRenderer._axis, digits)));
    }
    return resultantString;
  }

  // Returns the cumulative length of the number of new line character '\n'
  // available in series name and tooltip format string.
  int _getTooltipNewLineLength(int value) {
    value += _seriesRenderer!._series.name != null
        ? '\n'.allMatches(_seriesRenderer!._series.name!).length
        : 0;
    if (_tooltipBehavior.format != null) {
      value += '\n'.allMatches(_tooltipBehavior.format!).length;
    }
    return value;
  }

  //finds whether the point resides inside the given rect including its edges
  bool _isPointWithInRect(Offset point, Rect rect) {
    return point != null &&
        point.dx >= rect.left &&
        point.dx <= rect.right &&
        point.dy <= rect.bottom &&
        point.dy >= rect.top;
  }
}

/// Holds the tooltip series and point index
///
/// This class is used to provide the [seriesIndex] and [pointIndex] for the Tooltip.
class TooltipValue {
  /// Creating an argument constructor of TooltipValue class.
  TooltipValue(this.seriesIndex, this.pointIndex, [this.outlierIndex]);

  ///Index of the series.
  final int? seriesIndex;

  ///Index of data points.
  final int pointIndex;

  ///Index of outlier points.
  final int? outlierIndex;

  ///Position of the pointer when the tooltip position mode is set as pointer
  Offset? pointerPosition;

  @override
  //ignore: hash_and_equals
  bool operator ==(Object other) {
    if (other is TooltipValue) {
      return seriesIndex == other.seriesIndex &&
          pointIndex == other.pointIndex &&
          outlierIndex == other.outlierIndex &&
          (pointerPosition == null || pointerPosition == other.pointerPosition);
    } else {
      return false;
    }
  }
}
