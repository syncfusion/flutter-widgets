import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

/// Holds the value of [SfSparkChartThemeData] color properties for
/// material 2 theme based on the brightness.
class SfSparkChartThemeDataM2 extends SfSparkChartThemeData {
  /// Creating an argument constructor of SfChartThemeDataM2 class.
  SfSparkChartThemeDataM2(this.context);

  /// Specifies the build context of the chart widgets.
  final BuildContext context;

  /// Specifies the material app color scheme based on the brightness.
  late final ColorScheme colorScheme = Theme.of(context).colorScheme;

  @override
  Color? get color => Colors.blue;

  @override
  Color? get axisLineColor => Colors.black;

  @override
  Color? get markerFillColor => colorScheme.surface;

  @override
  Color? get dataLabelBackgroundColor => colorScheme.surface;

  @override
  Color? get tooltipColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(79, 79, 79, 1)
      : const Color.fromRGBO(255, 255, 255, 1);

  @override
  Color? get trackballLineColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(79, 79, 79, 1)
      : const Color.fromRGBO(255, 255, 255, 1);

  @override
  Color? get tooltipLabelColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(229, 229, 229, 1)
      : const Color.fromRGBO(0, 0, 0, 1);
}

/// Holds the value of [SfSparkChartThemeData] color properties for
/// material 3 theme based on the brightness.
class SfSparkChartThemeDataM3 extends SfSparkChartThemeData {
  /// Creating an argument constructor of SfChartThemeDataM3 class.
  SfSparkChartThemeDataM3(this.context);

  /// Specifies the build context of the chart widgets.
  final BuildContext context;

  /// Specifies the material app color scheme based on the brightness.
  late final ColorScheme colorScheme = Theme.of(context).colorScheme;

  @override
  Color? get color => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(150, 60, 112, 1)
      : const Color.fromRGBO(77, 170, 255, 1);

  @override
  Color? get axisLineColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(73, 69, 79, 1)
      : const Color.fromRGBO(202, 196, 208, 1);

  @override
  Color? get markerFillColor => colorScheme.surface;

  @override
  Color? get dataLabelBackgroundColor => colorScheme.surface;

  @override
  Color? get tooltipColor => colorScheme.inverseSurface;

  @override
  Color? get trackballLineColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(73, 69, 79, 1)
      : const Color.fromRGBO(202, 196, 208, 1);

  @override
  Color? get tooltipLabelColor => colorScheme.onInverseSurface;
}
