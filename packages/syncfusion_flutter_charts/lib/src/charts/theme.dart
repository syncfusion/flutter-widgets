import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

/// Holds the value of [ChartThemeData] color properties
class ChartThemeData extends SfChartThemeData {
  /// Creating an argument constructor of ChartThemeData class.
  ChartThemeData(this.context);

  /// Specifies the build context of the chart widgets.
  final BuildContext context;

  /// Obtain the color scheme from the current SfTheme based on the given BuildContext.
  late final SfColorScheme colorScheme = SfTheme.colorScheme(context);

  /// Specifies the material app theme data based on the brightness.
  late final TextTheme textTheme = Theme.of(context).textTheme;

  // TODO(Lavanya): Facing issue while using colorScheme.transparent.
  // Because we are chekcing not equals to Colors.transparent for gets
  // data label surface color.
  @override
  Color? get backgroundColor => Colors.transparent;

  List<Color> get palette => colorScheme.palettes;

  @override
  Color? get axisLabelColor => colorScheme.onSurfaceVariant[104];

  @override
  Color? get axisTitleColor => colorScheme.onSurfaceVariant[66];

  @override
  Color? get axisLineColor => colorScheme.outlineVariant[181];

  @override
  Color? get majorGridLineColor => colorScheme.surfaceVariant[219];

  @override
  Color? get minorGridLineColor => colorScheme.surfaceVariant[219];

  @override
  Color? get majorTickLineColor => colorScheme.outlineVariant[182];

  @override
  Color? get minorTickLineColor => colorScheme.outlineVariant[182];

  @override
  Color? get titleTextColor => colorScheme.onSurfaceVariant[66];

  @override
  Color? get titleBackgroundColor => Colors.transparent;

  @override
  Color? get legendTextColor => colorScheme.onSurfaceVariant[53];

  @override
  Color? get legendBackgroundColor => Colors.transparent;

  @override
  Color? get legendTitleColor => colorScheme.onSurfaceVariant[66];

  Color get markerFillColor =>
      colorScheme.brightness == Brightness.light ? Colors.white : Colors.black;

  Color get dataLabelBackgroundColor =>
      colorScheme.brightness == Brightness.light ? Colors.white : Colors.black;

  @override
  Color? get plotAreaBackgroundColor => Colors.transparent;

  @override
  Color? get plotAreaBorderColor => colorScheme.surfaceVariant[219];

  @override
  Color? get crosshairLineColor => colorScheme.onSurfaceVariant[79];

  @override
  Color? get crosshairBackgroundColor => colorScheme.inverseSurface[79];

  @override
  Color? get crosshairLabelColor => colorScheme.onInverseSurface[256];

  @override
  Color? get tooltipColor => colorScheme.inverseSurface[258];

  @override
  Color? get tooltipLabelColor => colorScheme.onInverseSurface[256];

  @override
  Color? get tooltipSeparatorColor => colorScheme.onInverseSurface[150];

  @override
  Color? get selectionRectColor => colorScheme.primary[27];

  @override
  Color? get selectionRectBorderColor => colorScheme.primary[28];

  @override
  Color? get selectionTooltipConnectorLineColor =>
      colorScheme.onSurfaceVariant[80];

  @override
  Color? get waterfallConnectorLineColor => colorScheme.onSurfaceVariant[255];

  @override
  TextStyle? get titleTextStyle => textTheme.bodyMedium?.copyWith(fontSize: 15);

  @override
  TextStyle? get axisTitleTextStyle =>
      textTheme.bodyMedium?.copyWith(fontSize: 15);

  @override
  TextStyle? get axisLabelTextStyle => textTheme.bodySmall;

  @override
  TextStyle? get axisMultiLevelLabelTextStyle => textTheme.bodySmall;

  @override
  TextStyle? get plotBandLabelTextStyle => textTheme.bodySmall;

  @override
  TextStyle? get legendTitleTextStyle => textTheme.bodySmall;

  @override
  TextStyle? get legendTextStyle => textTheme.bodySmall?.copyWith(fontSize: 13);

  @override
  TextStyle? get dataLabelTextStyle => textTheme.bodySmall;

  @override
  TextStyle? get tooltipTextStyle => textTheme.bodySmall;

  @override
  TextStyle? get trackballTextStyle => textTheme.bodySmall;

  @override
  TextStyle? get crosshairTextStyle => textTheme.bodySmall;

  @override
  TextStyle? get selectionZoomingTooltipTextStyle => textTheme.bodySmall;
}
