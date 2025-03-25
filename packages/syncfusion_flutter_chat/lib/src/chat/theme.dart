import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class ChatM2ThemeData extends SfChatThemeData {
  ChatM2ThemeData(this.context)
      : super(
          outgoingMessageShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          incomingMessageShape: const RoundedRectangleBorder(
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
  Color? get outgoingMessageBackgroundColor => _colorScheme.primaryContainer;

  @override
  Color? get incomingMessageBackgroundColor => _colorScheme.surfaceContainer;

  @override
  Color? get outgoingAvatarBackgroundColor => _colorScheme.primaryContainer;

  @override
  Color? get incomingAvatarBackgroundColor => _colorScheme.surfaceContainer;

  @override
  WidgetStateProperty<Color?> get suggestionItemBackgroundColor =>
      WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return _colorScheme.surfaceContainer.withValues(alpha: 0.8);
          }
          if (states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.disabled)) {
            return _colorScheme.surfaceContainer.withValues(alpha: 0.12);
          }
          return _colorScheme.surfaceContainer;
        },
      );

  @override
  WidgetStateProperty<ShapeBorder?>? get suggestionItemShape =>
      WidgetStateProperty.resolveWith<ShapeBorder?>(
        (Set<WidgetState> states) {
          return const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          );
        },
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

class ChatM3ThemeData extends SfChatThemeData {
  ChatM3ThemeData(this.context)
      : super(
          outgoingMessageShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          incomingMessageShape: const RoundedRectangleBorder(
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
  Color? get outgoingMessageBackgroundColor => _colorScheme.primaryContainer;

  @override
  Color? get incomingMessageBackgroundColor => _colorScheme.surfaceContainer;

  @override
  Color? get outgoingAvatarBackgroundColor => _colorScheme.primaryContainer;

  @override
  Color? get incomingAvatarBackgroundColor => _colorScheme.surfaceContainer;

  @override
  WidgetStateProperty<Color?> get suggestionItemBackgroundColor =>
      WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return _colorScheme.surfaceContainer.withValues(alpha: 0.8);
          }
          if (states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.disabled)) {
            return _colorScheme.surfaceContainer.withValues(alpha: 0.12);
          }
          return _colorScheme.surfaceContainer;
        },
      );

  @override
  WidgetStateProperty<ShapeBorder?>? get suggestionItemShape =>
      WidgetStateProperty.resolveWith<ShapeBorder?>(
        (Set<WidgetState> states) {
          return const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          );
        },
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
