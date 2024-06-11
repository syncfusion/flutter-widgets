import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

/// [BarcodeThemeData] this class provides themeData.
/// BarcodeThemeData class extends the 'SfBarcodeThemeData' class and customize
/// the appearance of a mapping component based on th colorScheme obtained from
/// the provided [BuildContext].
class BarcodeThemeData extends SfBarcodeThemeData {
  /// This a constructor that takes a [BuildContext] as a parameter.This context
  /// is used for obtaining the colorScheme of the current theme.
  BarcodeThemeData(this.context);

  /// Property that stores the provided [BuildContext]
  /// context is later used to obtain the colorScheme.
  final BuildContext context;

  /// A late-initialized property representing the color scheme obtained from
  /// the current theme using the provided [BuildContext]
  late final SfColorScheme colorScheme = SfTheme.colorScheme(context);

  @override
  Color? get backgroundColor => colorScheme.transparent;

  @override
  Color? get barColor => colorScheme.onSurface[70];

  @override
  Color? get textColor => colorScheme.onSurface[70];
}
