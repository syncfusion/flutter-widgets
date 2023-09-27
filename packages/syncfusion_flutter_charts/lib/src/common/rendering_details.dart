import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../circular_chart/renderer/common.dart';
import 'common.dart';
import 'legend/legend.dart';
import 'legend/renderer.dart';
import 'template/rendering.dart';
import 'user_interaction/tooltip.dart';

/// Represents the rendering details of the chart.
class RenderingDetails {
  /// Specifies the animation controller of chart.
  late AnimationController animationController;

  /// Specifies the animation controller of chart annotation controller.
  late AnimationController annotationController;

  /// Specifies the series repaint notifier.
  late ValueNotifier<int> seriesRepaintNotifier;

  /// Specifies the chart element animation.
  late Animation<double> chartElementAnimation;

  /// Specifies the context for legend.
  late List<MeasureWidgetContext> legendWidgetContext;

  /// Specifies the context for legend toggle template.
  late List<MeasureWidgetContext> legendToggleTemplateStates;

  /// Specifies the legend toggle states.
  late List<LegendRenderContext> legendToggleStates;

  /// Specifies whether the legend is toggled.
  late bool isLegendToggled;

  /// Specifies the chart legend.
  late ChartLegend chartLegend;

  /// Specifies the chart legend renderer.
  late LegendRenderer legendRenderer;

  /// Specifies the tooltip behavior renderer.
  late TooltipBehaviorRenderer tooltipBehaviorRenderer;

  /// Specifies the chart interaction.
  ChartInteraction? currentActive;

  /// Specifies the tap position.
  Offset? tapPosition;

  /// Specifies the list of selection data.
  late List<int> selectionData;

  /// Specifies the chart container rect.
  late Rect chartContainerRect;

  /// Specifies the chart area rect.
  late Rect chartAreaRect;

  /// Specifies the data label template region.
  late List<Rect> dataLabelTemplateRegions;

  /// Specifies the list of template info.
  late List<ChartTemplateInfo> templates;

  /// Specifies the chart template.
  ChartTemplate? chartTemplate;

  /// Specifies the chart theme.
  late SfChartThemeData chartTheme;

  /// Specifies the theme data.
  late ThemeData themeData;

  /// Specifies the exploded points.
  late List<int> explodedPoints;

  /// Specifies whether the chart is rendered at load time.
  bool? initialRender;

  /// Specifies whether the animation is completed.
  late bool animateCompleted;

  /// Specifies whether the widget needs to updated.
  late bool widgetNeedUpdate;

  /// Specifies the previous orientation of the device.
  Orientation? oldDeviceOrientation;

  /// Specifies the current device orientation.
  late Orientation deviceOrientation;

  /// Specifies the previous chart size.
  Size? prevSize;

  /// Specifies the previous locale of the context
  Locale? prevLocale;

  /// Specifies whether the current chart size is changed.
  late bool didSizeChange;

  /// Specifies whether the current locale is changed in the context.
  late bool didLocaleChange;

  /// Specifies the list of chart widget.
  List<Widget>? chartWidgets;

  /// Specifies whether the text direction of chart widget is RTL or LTR.
  late bool isRtl;
}
