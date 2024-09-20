import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class ChatM2ThemeData extends SfChatThemeData {
  ChatM2ThemeData(this.context)
      : super(
          outgoingBubbleContentShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          incomingBubbleContentShape: const RoundedRectangleBorder(
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
  Color? get actionButtonFocusColor => _colorScheme.primary.withOpacity(0.86);

  @override
  Color? get actionButtonHoverColor => _colorScheme.primary.withOpacity(0.91);

  @override
  Color? get actionButtonSplashColor => _colorScheme.primary.withOpacity(0.86);

  @override
  Color? get actionButtonDisabledForegroundColor =>
      _colorScheme.onSurface.withOpacity(0.38);

  @override
  Color? get actionButtonDisabledBackgroundColor =>
      _colorScheme.surface.withOpacity(0.12);

  @override
  ShapeBorder? get actionButtonShape => const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0)));

  @override
  Color? get outgoingBubbleContentBackgroundColor =>
      _colorScheme.primaryContainer;

  @override
  Color? get incomingBubbleContentBackgroundColor =>
      _colorScheme.surfaceContainer;
}

class ChatM3ThemeData extends SfChatThemeData {
  ChatM3ThemeData(this.context)
      : super(
          outgoingBubbleContentShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          incomingBubbleContentShape: const RoundedRectangleBorder(
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
  Color? get actionButtonFocusColor => _colorScheme.primary.withOpacity(0.86);

  @override
  Color? get actionButtonHoverColor => _colorScheme.primary.withOpacity(0.91);

  @override
  Color? get actionButtonSplashColor => _colorScheme.primary.withOpacity(0.86);

  @override
  Color? get actionButtonDisabledForegroundColor =>
      _colorScheme.onSurface.withOpacity(0.38);

  @override
  Color? get actionButtonDisabledBackgroundColor =>
      _colorScheme.surface.withOpacity(0.12);

  @override
  ShapeBorder? get actionButtonShape => const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0)));

  @override
  Color? get outgoingBubbleContentBackgroundColor =>
      _colorScheme.primaryContainer;

  @override
  Color? get incomingBubbleContentBackgroundColor =>
      _colorScheme.surfaceContainer;
}
