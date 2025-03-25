import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

Color _saturatedColor(Color color, double factor) {
  if (color == Colors.transparent) {
    return color;
  } else {
    const Color mix = Color(0x4D000000);
    final double mixFactor = 1 - factor;
    return Color.fromRGBO(
      (mixFactor * (color.r * 255) + factor * (mix.r * 255)).toInt(),
      (mixFactor * (color.g * 255) + factor * (mix.g * 255)).toInt(),
      (mixFactor * (color.b * 255) + factor * (mix.b * 255)).toInt(),
      1,
    );
  }
}

class AIAssistViewM2ThemeData extends SfAIAssistViewThemeData {
  AIAssistViewM2ThemeData(this.context)
      : super(
          requestMessageShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          responseMessageShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
        );

  final BuildContext context;
  late final ColorScheme _colorScheme = Theme.of(context).colorScheme;

  @override
  double get actionButtonHighlightElevation => 6.0;

  @override
  Color? get actionButtonForegroundColor => _colorScheme.onPrimary;

  @override
  Color? get actionButtonBackgroundColor => _colorScheme.primary;

  @override
  Color? get actionButtonFocusColor =>
      _colorScheme.primary.withValues(alpha: 0.86);

  @override
  Color? get actionButtonHoverColor =>
      _colorScheme.primary.withValues(alpha: 0.91);

  @override
  Color? get actionButtonSplashColor =>
      _colorScheme.primary.withValues(alpha: 0.86);

  @override
  Color? get actionButtonDisabledForegroundColor =>
      _colorScheme.onSurface.withValues(alpha: 0.38);

  @override
  Color? get actionButtonDisabledBackgroundColor =>
      _colorScheme.surface.withValues(alpha: 0.12);

  @override
  ShapeBorder? get actionButtonShape => const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      );

  @override
  Color? get requestMessageBackgroundColor => _colorScheme.surfaceContainer;

  @override
  Color? get responseMessageBackgroundColor => Colors.transparent;

  @override
  Color? get requestAvatarBackgroundColor => _colorScheme.surfaceContainer;

  @override
  Color? get responseAvatarBackgroundColor => _colorScheme.surfaceContainer;

  @override
  WidgetStateProperty<Color?> get suggestionItemBackgroundColor =>
      WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return _saturatedColor(_colorScheme.surfaceContainer, 0.08);
          }
          if (states.contains(WidgetState.disabled)) {
            return _saturatedColor(_colorScheme.surfaceContainer, 0.12);
          }
          return _colorScheme.surfaceContainer;
        },
      );

  @override
  WidgetStateProperty<ShapeBorder?>? get suggestionItemShape =>
      WidgetStateProperty.all<ShapeBorder?>(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      );

  @override
  WidgetStateProperty<Color?> get responseToolbarItemBackgroundColor =>
      WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return _colorScheme.onSurface.withValues(alpha: 0.08);
          }
          if (states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.selected)) {
            return _colorScheme.onSurface.withValues(alpha: 0.01);
          }
          return _colorScheme.surface;
        },
      );

  @override
  WidgetStateProperty<ShapeBorder?>? get responseToolbarItemShape =>
      WidgetStateProperty.all<ShapeBorder?>(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      );

  @override
  WidgetStateProperty<TextStyle?>? get suggestionItemTextStyle =>
      WidgetStateProperty.resolveWith<TextStyle?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return TextStyle(
              color: _colorScheme.onSurface.withValues(alpha: 0.38),
            );
          }
          return TextStyle(color: _colorScheme.onSurface);
        },
      );
}

class AIAssistViewM3ThemeData extends SfAIAssistViewThemeData {
  AIAssistViewM3ThemeData(this.context)
      : super(
          requestMessageShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          responseMessageShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
        );

  final BuildContext context;
  late final ColorScheme _colorScheme = Theme.of(context).colorScheme;

  @override
  double get actionButtonHighlightElevation => 6.0;

  @override
  Color? get actionButtonForegroundColor => _colorScheme.onPrimary;

  @override
  Color? get actionButtonBackgroundColor => _colorScheme.primary;

  @override
  Color? get actionButtonFocusColor =>
      _colorScheme.primary.withValues(alpha: 0.86);

  @override
  Color? get actionButtonHoverColor =>
      _colorScheme.primary.withValues(alpha: 0.91);

  @override
  Color? get actionButtonSplashColor =>
      _colorScheme.primary.withValues(alpha: 0.86);

  @override
  Color? get actionButtonDisabledForegroundColor =>
      _colorScheme.onSurface.withValues(alpha: 0.38);

  @override
  Color? get actionButtonDisabledBackgroundColor =>
      _colorScheme.surface.withValues(alpha: 0.12);

  @override
  ShapeBorder? get actionButtonShape => const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      );

  @override
  Color? get requestMessageBackgroundColor => _colorScheme.surfaceContainer;

  @override
  Color? get responseMessageBackgroundColor => Colors.transparent;

  @override
  Color? get requestAvatarBackgroundColor => _colorScheme.surfaceContainer;

  @override
  Color? get responseAvatarBackgroundColor => _colorScheme.surfaceContainer;

  @override
  WidgetStateProperty<Color?> get suggestionItemBackgroundColor =>
      WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return _saturatedColor(_colorScheme.surfaceContainer, 0.08);
          }
          if (states.contains(WidgetState.disabled)) {
            return _saturatedColor(_colorScheme.surfaceContainer, 0.12);
          }
          return _colorScheme.surfaceContainer;
        },
      );

  @override
  WidgetStateProperty<ShapeBorder?>? get suggestionItemShape =>
      WidgetStateProperty.all<ShapeBorder?>(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      );

  @override
  WidgetStateProperty<Color?> get responseToolbarItemBackgroundColor =>
      WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return _colorScheme.onSurface.withValues(alpha: 0.08);
          }
          if (states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.selected)) {
            return _colorScheme.onSurface.withValues(alpha: 0.01);
          }
          return _colorScheme.surface;
        },
      );

  @override
  WidgetStateProperty<ShapeBorder?>? get responseToolbarItemShape =>
      WidgetStateProperty.all<ShapeBorder?>(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      );

  @override
  WidgetStateProperty<TextStyle?>? get suggestionItemTextStyle =>
      WidgetStateProperty.resolveWith<TextStyle?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return TextStyle(
              color: _colorScheme.onSurface.withValues(alpha: 0.38),
            );
          }
          return TextStyle(color: _colorScheme.onSurface);
        },
      );
}
