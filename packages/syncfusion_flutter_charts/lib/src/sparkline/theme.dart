import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

/// Holds the value of [SfSparkChartThemeData] color properties for
/// material 2 and material 3 theme based on the brightness.
class SparkChartThemeData extends SfSparkChartThemeData {
  /// Creating an argument constructor of SparkChartThemeData class.
  SparkChartThemeData(this.context);

  /// Specifies the build context of the chart widgets.
  final BuildContext context;

  /// Specifies the material app color scheme based on the brightness.
  late final SfColorScheme colorScheme = SfTheme.colorScheme(context);

  @override
  Color? get color => colorScheme.useMaterial3
      ? colorScheme.brightness == Brightness.light
          ? const Color.fromRGBO(150, 60, 112, 1)
          : const Color.fromRGBO(77, 170, 255, 1)
      : Colors.blue;

  @override
  Color? get axisLineColor => colorScheme.useMaterial3
      ? colorScheme.brightness == Brightness.light
          ? const Color.fromRGBO(73, 69, 79, 1)
          : const Color.fromRGBO(202, 196, 208, 1)
      : Colors.black;

  @override
  Color? get markerFillColor => colorScheme.surface[150];

  @override
  Color? get dataLabelBackgroundColor => colorScheme.surface[255];

  @override
  Color? get tooltipColor => colorScheme.inverseSurface[258];

  @override
  Color? get trackballLineColor => colorScheme.onSurfaceVariant[79];

  @override
  Color? get tooltipLabelColor => colorScheme.onInverseSurface[256];
}
