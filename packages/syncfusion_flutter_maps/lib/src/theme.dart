import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

/// [SfMapsThemeDataM2] this class provides material2 themeData.
/// SfMapsThemeDataM2 class extends the 'SfMapsThemeData' class and customize
/// the appearance of a mapping component based on th color scheme obtained from
/// the provided [BuildContext].
class SfMapsThemeDataM2 extends SfMapsThemeData {
  /// This a constructor that takes a [BuildContext] as a parameter.This context
  /// is used for obtaining the color scheme of the current theme.
  SfMapsThemeDataM2(this.context);

  /// Property that stores the provided [BuildContext]
  /// context is later used to obtain the color scheme.
  final BuildContext context;

  /// A late-initialized property representing the color scheme obtained from
  /// the current theme using the provided [BuildContext]
  late final ColorScheme colorScheme = Theme.of(context).colorScheme;

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

  @override
  Color? get layerColor => (colorScheme.brightness == Brightness.light
      ? colorScheme.onSurface.withOpacity(0.11)
      : colorScheme.onSurface.withOpacity(0.24));

  @override
  Color? get layerStrokeColor => (colorScheme.brightness == Brightness.light
      ? colorScheme.onSurface.withOpacity(0.18)
      : colorScheme.onSurface.withOpacity(0.43));

  @override
  Color? get markerIconColor => (colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(98, 0, 238, 1)
      : const Color.fromRGBO(187, 134, 252, 1));

  @override
  Color? get bubbleColor => (colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(98, 0, 238, 0.5)
      : const Color.fromRGBO(187, 134, 252, 0.8));

  @override
  Color? get bubbleStrokeColor => Colors.transparent;

  @override
  Color? get selectionColor => (colorScheme.brightness == Brightness.light
      ? colorScheme.onSurface.withOpacity(0.53)
      : colorScheme.onSurface.withOpacity(0.85));

  @override
  Color? get selectionStrokeColor => (colorScheme.brightness == Brightness.light
      ? colorScheme.onPrimary.withOpacity(0.29)
      : colorScheme.surface.withOpacity(0.56));

  @override
  Color? get tooltipColor => (colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(117, 117, 117, 1)
      : const Color.fromRGBO(245, 245, 245, 1));

  @override
  Color? get toggledItemColor => (colorScheme.brightness == Brightness.light
      ? colorScheme.onPrimary
      : colorScheme.onSurface.withOpacity(0.09));

  @override
  Color? get toggledItemStrokeColor =>
      (colorScheme.brightness == Brightness.light
          ? colorScheme.onSurface.withOpacity(0.37)
          : colorScheme.onSurface.withOpacity(0.17));
}

/// [SfMapsThemeDataM3] this class provides material3 themeData.
/// SfMapsThemeDataM2 class extends the 'SfMapsThemeData' class and customize
/// the appearance of a mapping component based on th color scheme obtained from
/// the provided [BuildContext].
class SfMapsThemeDataM3 extends SfMapsThemeData {
  /// This a constructor that takes a [BuildContext] as a parameter.This context
  /// is used for obtaining the color scheme of the current theme.
  SfMapsThemeDataM3(this.context);

  /// Property that stores the provided [BuildContext]
  /// context is later used to obtain the color scheme.
  final BuildContext context;

  /// A late-initialized property representing the color scheme obtained from
  /// the current theme using the provided [BuildContext]
  late final ColorScheme colorScheme = Theme.of(context).colorScheme;

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

  @override
  Color? get layerColor => (colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(231, 224, 236, 1)
      : const Color.fromRGBO(54, 50, 59, 1));

  @override
  Color? get layerStrokeColor => (colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(202, 196, 208, 1)
      : const Color.fromRGBO(73, 69, 79, 1));

  @override
  Color? get markerIconColor => colorScheme.primary;

  @override
  Color? get bubbleColor => (colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(255, 180, 0, 0.4)
      : const Color.fromRGBO(201, 88, 142, 0.4));

  @override
  Color? get bubbleStrokeColor => const Color.fromRGBO(255, 255, 255, 0.4);

  @override
  Color? get selectionColor => (colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(202, 196, 208, 1)
      : const Color.fromRGBO(73, 69, 79, 1));

  @override
  Color? get selectionStrokeColor => (colorScheme.brightness == Brightness.light
      ? colorScheme.onPrimary.withOpacity(0.29)
      : const Color.fromRGBO(73, 69, 79, 1));

  @override
  Color? get tooltipColor => colorScheme.inverseSurface;

  @override
  Color? get toggledItemColor => (colorScheme.brightness == Brightness.light
      ? colorScheme.onPrimary
      : colorScheme.onSurface.withOpacity(0.09));

  @override
  Color? get toggledItemStrokeColor =>
      (colorScheme.brightness == Brightness.light
          ? colorScheme.onSurface.withOpacity(0.37)
          : colorScheme.onSurface.withOpacity(0.17));
}
