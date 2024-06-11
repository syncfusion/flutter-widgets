import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

/// [MapsThemeData] this class provides themeData.
/// MapsThemeData class extends the 'SfMapsThemeData' class and customize
/// the appearance of a mapping component based on th colorScheme obtained from
/// the provided [BuildContext].
class MapsThemeData extends SfMapsThemeData {
  /// This a constructor that takes a [BuildContext] as a parameter.This context
  /// is used for obtaining the colorScheme of the current theme.
  MapsThemeData(this.context);

  /// Property that stores the provided [BuildContext]
  /// context is later used to obtain the colorScheme.
  final BuildContext context;

  /// A late-initialized property representing the color scheme obtained from
  /// the current theme using the provided [BuildContext]
  late final SfColorScheme colorScheme = SfTheme.colorScheme(context);

  /// Specifies the sub layer color of the maps widgets.
  Color get subLayerColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(198, 198, 198, 1)
      : const Color.fromRGBO(71, 71, 71, 1);

  /// Specifies the sub layer stroke color of the maps widgets.
  Color get subLayerStrokeColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(145, 145, 145, 1)
      : const Color.fromRGBO(133, 133, 133, 1);

  /// Specifies the sub layer width of the maps widgets.
  double get subLayerStrokeWidth =>
      colorScheme.brightness == Brightness.light ? 0.5 : 0.25;

  // TODO(Aswini): Dark color not appiled properly.
  @override
  Color? get layerColor => colorScheme.onSurface[29];

  @override
  Color? get layerStrokeColor => colorScheme.onSurface[47];

  @override
  Color? get markerIconColor => colorScheme.primary[98];

  @override
  Color? get bubbleColor => colorScheme.useMaterial3
      ? colorScheme.brightness == Brightness.light
          ? const Color.fromRGBO(255, 180, 0, 0.4)
          : const Color.fromRGBO(201, 88, 142, 0.4)
      : colorScheme.brightness == Brightness.light
          ? const Color.fromRGBO(98, 0, 238, 0.5)
          : const Color.fromRGBO(187, 134, 252, 0.8);

  // TODO(Aswini): Dark color not appiled properly.
  @override
  Color? get bubbleStrokeColor => colorScheme.transparent[255];

  @override
  Color? get selectionColor => colorScheme.outlineVariant[255];

  @override
  Color? get selectionStrokeColor => colorScheme.onPrimary[75];

  @override
  Color? get tooltipColor => colorScheme.onSurface[256];

  @override
  Color? get tooltipStrokeColor => colorScheme.inverseSurface[257];

  @override
  Color? get toggledItemColor => colorScheme.onSurface[24];

  @override
  Color? get toggledItemStrokeColor => colorScheme.onSurface[95];
}
