part of charts;

/// Represents the rendering details of the chart
class _RenderingDetails {
  /// Specifies the animation controller of chart
  late AnimationController animationController;

  /// Specifies the animation controller of chart annotation controller
  late AnimationController annotationController;

  /// Specifies the series repaint notifier
  late ValueNotifier<int> seriesRepaintNotifier;

  /// Specifies the chart element animatioon
  late Animation<double> chartElementAnimation;

  /// Specifies the context for legend
  late List<_MeasureWidgetContext> legendWidgetContext;

  /// Specifies the context for legend toggle template
  late List<_MeasureWidgetContext> legendToggleTemplateStates;

  /// Specifies the legend toggle states
  late List<_LegendRenderContext> legendToggleStates;

  /// Specifies whether the legend is toggled
  late bool isLegendToggled;

  /// Specifies the chart legend
  late _ChartLegend chartLegend;

  /// Specifies the chart legend renderer
  late LegendRenderer legendRenderer;

  /// Specifies the tooltip behavior renderer
  late TooltipBehaviorRenderer tooltipBehaviorRenderer;

  /// Specifies the chart interaction
  _ChartInteraction? currentActive;

  /// Specifies the tap position
  Offset? tapPosition;

  /// Specifies the list of selection data
  late List<int> selectionData;

  /// Specifies the chart container rect
  late Rect chartContainerRect;

  /// Specifies the chart area rect
  late Rect chartAreaRect;

  /// Specifies the data label template region
  late List<Rect> dataLabelTemplateRegions;

  /// Specifies the list of template info
  late List<_ChartTemplateInfo> templates;

  /// Specifies the chart template
  _ChartTemplate? chartTemplate;

  /// Specifies the chart theme
  late SfChartThemeData chartTheme;

  /// Specifies the exploded points
  late List<int> explodedPoints;

  /// Specifies whether the chart is rendered at load time
  bool? initialRender;

  /// Specifies whether the animation is completed
  late bool animateCompleted;

  /// Specifies whether the widget needs to updated
  late bool widgetNeedUpdate;

  /// Specifies the previous orientation of the device
  Orientation? oldDeviceOrientation;

  /// Specifies the current device orientation
  late Orientation deviceOrientation;

  /// Specifies the previous chart size
  Size? prevSize;

  /// Specifies whether the current chart size is changed
  late bool didSizeChange;

  /// Specifies the list of chart widget
  List<Widget>? chartWidgets;

  /// Specifies the image drawn in the marker or not.
  bool isImageDrawn = false;
}
