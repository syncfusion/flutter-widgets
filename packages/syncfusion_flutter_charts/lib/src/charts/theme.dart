import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

/// Holds the value of [SfChartThemeData] color properties for
/// material 2 theme based on the brightness.
class SfChartThemeDataM2 extends SfChartThemeData {
  /// Creating an argument constructor of SfChartThemeDataM2 class.
  SfChartThemeDataM2(this.context);

  /// Specifies the build context of the chart widgets.
  final BuildContext context;

  /// Specifies the material app color scheme based on the brightness.
  late final ColorScheme colorScheme = Theme.of(context).colorScheme;

  /// Specifies the material app theme data based on the brightness.
  late final TextTheme textTheme = Theme.of(context).textTheme;

  @override
  Color? get backgroundColor => Colors.transparent;

  List<Color> get palette => const <Color>[
        Color.fromRGBO(75, 135, 185, 1),
        Color.fromRGBO(192, 108, 132, 1),
        Color.fromRGBO(246, 114, 128, 1),
        Color.fromRGBO(248, 177, 149, 1),
        Color.fromRGBO(116, 180, 155, 1),
        Color.fromRGBO(0, 168, 181, 1),
        Color.fromRGBO(73, 76, 162, 1),
        Color.fromRGBO(255, 205, 96, 1),
        Color.fromRGBO(255, 240, 219, 1),
        Color.fromRGBO(238, 238, 238, 1)
      ];

  @override
  Color? get axisLabelColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(104, 104, 104, 1)
      : const Color.fromRGBO(242, 242, 242, 1);

  @override
  Color? get axisTitleColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(66, 66, 66, 1)
      : const Color.fromRGBO(255, 255, 255, 1);

  @override
  Color? get axisLineColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(181, 181, 181, 1)
      : const Color.fromRGBO(101, 101, 101, 1);

  @override
  Color? get majorGridLineColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(219, 219, 219, 1)
      : const Color.fromRGBO(70, 74, 86, 1);

  @override
  Color? get minorGridLineColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(234, 234, 234, 1)
      : const Color.fromRGBO(70, 74, 86, 1);

  @override
  Color? get majorTickLineColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(181, 181, 181, 1)
      : const Color.fromRGBO(191, 191, 191, 1);

  @override
  Color? get minorTickLineColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(214, 214, 214, 1)
      : const Color.fromRGBO(150, 150, 150, 1);

  @override
  Color? get titleTextColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(66, 66, 66, 1)
      : const Color.fromRGBO(255, 255, 255, 1);

  @override
  Color? get titleBackgroundColor => Colors.transparent;

  @override
  Color? get legendTextColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(53, 53, 53, 1)
      : const Color.fromRGBO(255, 255, 255, 1);

  @override
  Color? get legendBackgroundColor => Colors.transparent;

  @override
  Color? get legendTitleColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(66, 66, 66, 1)
      : const Color.fromRGBO(255, 255, 255, 1);

  Color get markerFillColor =>
      colorScheme.brightness == Brightness.light ? Colors.white : Colors.black;

  Color get dataLabelBackgroundColor =>
      colorScheme.brightness == Brightness.light ? Colors.white : Colors.black;

  @override
  Color? get plotAreaBackgroundColor => Colors.transparent;

  @override
  Color? get plotAreaBorderColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(219, 219, 219, 1)
      : const Color.fromRGBO(101, 101, 101, 1);

  @override
  Color? get crosshairLineColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(79, 79, 79, 1)
      : const Color.fromRGBO(255, 255, 255, 1);

  @override
  Color? get crosshairBackgroundColor =>
      colorScheme.brightness == Brightness.light
          ? const Color.fromRGBO(79, 79, 79, 1)
          : const Color.fromRGBO(255, 255, 255, 1);

  @override
  Color? get crosshairLabelColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(255, 255, 255, 1)
      : const Color.fromRGBO(0, 0, 0, 1);

  @override
  Color? get tooltipColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(0, 8, 22, 1)
      : const Color.fromRGBO(255, 255, 255, 1);

  @override
  Color? get tooltipLabelColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(255, 255, 255, 1)
      : const Color.fromRGBO(0, 0, 0, 1);

  @override
  Color? get tooltipSeparatorColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(255, 255, 255, 1)
      : const Color.fromRGBO(150, 150, 150, 1);

  @override
  Color? get selectionRectColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(41, 171, 226, 0.1)
      : const Color.fromRGBO(255, 217, 57, 0.3);

  @override
  Color? get selectionRectBorderColor =>
      colorScheme.brightness == Brightness.light
          ? const Color.fromRGBO(41, 171, 226, 1)
          : const Color.fromRGBO(255, 255, 255, 1);

  @override
  Color? get selectionTooltipConnectorLineColor =>
      colorScheme.brightness == Brightness.light
          ? const Color.fromRGBO(79, 79, 79, 1)
          : const Color.fromRGBO(150, 150, 150, 1);

  @override
  Color? get waterfallConnectorLineColor =>
      colorScheme.brightness == Brightness.light
          ? const Color.fromRGBO(0, 0, 0, 1)
          : const Color.fromRGBO(255, 255, 255, 1);

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

/// Holds the value of [SfChartThemeData] color properties for material 3
/// theme based on the brightness.
class SfChartThemeDataM3 extends SfChartThemeData {
  /// Creating an argument constructor of SfChartThemeDataM3 class.
  SfChartThemeDataM3(this.context);

  /// Specifies the build context of the chart widgets.
  final BuildContext context;

  /// Specifies the material app color scheme based on the brightness.
  late final ColorScheme colorScheme = Theme.of(context).colorScheme;

  /// Specifies the material app theme data based on the brightness.
  late final TextTheme textTheme = Theme.of(context).textTheme;

  @override
  Color? get backgroundColor => Colors.transparent;

  List<Color> get palette => colorScheme.brightness == Brightness.light
      ? const <Color>[
          Color.fromRGBO(6, 174, 224, 1),
          Color.fromRGBO(99, 85, 199, 1),
          Color.fromRGBO(49, 90, 116, 1),
          Color.fromRGBO(255, 180, 0, 1),
          Color.fromRGBO(150, 60, 112, 1),
          Color.fromRGBO(33, 150, 245, 1),
          Color.fromRGBO(71, 59, 137, 1),
          Color.fromRGBO(236, 92, 123, 1),
          Color.fromRGBO(59, 163, 26, 1),
          Color.fromRGBO(236, 131, 23, 1)
        ]
      : const <Color>[
          Color.fromRGBO(255, 245, 0, 1),
          Color.fromRGBO(51, 182, 119, 1),
          Color.fromRGBO(218, 150, 70, 1),
          Color.fromRGBO(201, 88, 142, 1),
          Color.fromRGBO(77, 170, 255, 1),
          Color.fromRGBO(255, 157, 69, 1),
          Color.fromRGBO(178, 243, 46, 1),
          Color.fromRGBO(185, 60, 228, 1),
          Color.fromRGBO(48, 167, 6, 1),
          Color.fromRGBO(207, 142, 14, 1)
        ];

  @override
  Color? get axisLabelColor => colorScheme.onSurfaceVariant;

  @override
  Color? get axisTitleColor => colorScheme.onSurfaceVariant;

  @override
  Color? get axisLineColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(202, 196, 208, 1)
      : const Color.fromRGBO(73, 69, 79, 1);

  @override
  Color? get majorGridLineColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(231, 224, 236, 1)
      : const Color.fromRGBO(54, 50, 59, 1);

  // TODO(Praveen): Need to update color
  @override
  Color? get minorGridLineColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(234, 234, 234, 1)
      : const Color.fromRGBO(70, 74, 86, 1);

  @override
  Color? get majorTickLineColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(202, 196, 208, 1)
      : const Color.fromRGBO(73, 69, 79, 1);

  // TODO(Praveen): Need to update color
  @override
  Color? get minorTickLineColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(214, 214, 214, 1)
      : const Color.fromRGBO(150, 150, 150, 1);

  @override
  Color? get titleTextColor => colorScheme.onSurfaceVariant;

  @override
  Color? get titleBackgroundColor => Colors.transparent;

  @override
  Color? get legendTextColor => colorScheme.onSurfaceVariant;

  @override
  Color? get legendBackgroundColor => Colors.transparent;

  @override
  Color? get legendTitleColor => colorScheme.onSurfaceVariant;

  Color get markerFillColor =>
      colorScheme.brightness == Brightness.light ? Colors.white : Colors.black;

  Color get dataLabelBackgroundColor =>
      colorScheme.brightness == Brightness.light ? Colors.white : Colors.black;

  @override
  Color? get plotAreaBackgroundColor => Colors.transparent;

  @override
  Color? get plotAreaBorderColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(231, 224, 236, 1)
      : const Color.fromRGBO(54, 50, 59, 1);

  @override
  Color? get crosshairLineColor => colorScheme.onSurfaceVariant;

  @override
  Color? get crosshairBackgroundColor => colorScheme.inverseSurface;

  @override
  Color? get crosshairLabelColor => colorScheme.onInverseSurface;

  @override
  Color? get tooltipColor => colorScheme.inverseSurface;

  @override
  Color? get tooltipLabelColor => colorScheme.onInverseSurface;

  @override
  Color? get tooltipSeparatorColor => colorScheme.onInverseSurface;

  @override
  Color? get selectionRectColor => colorScheme.brightness == Brightness.light
      ? colorScheme.primary.withOpacity(0.1)
      : colorScheme.primary.withOpacity(0.3);

  @override
  Color? get selectionRectBorderColor => colorScheme.primary;

  @override
  Color? get selectionTooltipConnectorLineColor => colorScheme.onSurfaceVariant;

  @override
  Color? get waterfallConnectorLineColor =>
      colorScheme.brightness == Brightness.light
          ? const Color.fromRGBO(0, 0, 0, 1)
          : const Color.fromRGBO(255, 255, 255, 1);

  @override
  TextStyle? get titleTextStyle => textTheme.bodyMedium!.copyWith(fontSize: 16);

  @override
  TextStyle? get axisTitleTextStyle => textTheme.bodyMedium;

  @override
  TextStyle? get axisLabelTextStyle => textTheme.bodySmall;

  @override
  TextStyle? get axisMultiLevelLabelTextStyle => textTheme.bodySmall;

  @override
  TextStyle? get plotBandLabelTextStyle => textTheme.bodySmall;

  @override
  TextStyle? get legendTitleTextStyle => textTheme.bodySmall;

  @override
  TextStyle? get legendTextStyle => textTheme.bodySmall;

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
