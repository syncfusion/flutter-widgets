import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'theme_widget.dart';

/// Applies a theme to descendant Syncfusion chat widgets.
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfChatTheme(
///       data: SfChatThemeData(
///         brightness: Brightness.dark,
///       ),
///       child: SfChat()
///     ),
///   );
/// }
/// ```
class SfChatTheme extends InheritedTheme {
  /// Applies the given theme [data] to [child].
  ///
  /// The [data] and [child] arguments must not be null.
  const SfChatTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Specifies the color and typography values for descendant Chat widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         brightness: Brightness.dark,
  ///       ),
  ///       child: SfChat()
  ///     ),
  ///   );
  /// }
  /// ```
  final SfChatThemeData data;

  /// The data from the closest [SfChatTheme] instance
  /// that encloses the given context.
  ///
  /// Defaults to [SfThemeData.chatThemeData] if there is no
  /// [SfChatTheme] in the given build context.
  static SfChatThemeData of(BuildContext context) {
    final SfChatTheme? chatTheme =
        context.dependOnInheritedWidgetOfExactType<SfChatTheme>();
    return chatTheme?.data ?? SfTheme.of(context).chatThemeData;
  }

  @override
  bool updateShouldNotify(SfChatTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final SfChatTheme? ancestorTheme =
        context.findAncestorWidgetOfExactType<SfChatTheme>();
    return identical(this, ancestorTheme)
        ? child
        : SfChatTheme(data: data, child: child);
  }
}

/// Holds the color and typography values for a [SfChatTheme].
/// Use this class to configure a [SfChatTheme] widget, or to set the
/// [SfThemeData.chatThemeData] for a [SfTheme] widget.
///
/// To obtain the current theme, use [SfChatTheme.of].
@immutable
class SfChatThemeData with Diagnosticable {
  /// Create a [SfChatThemeData] given a set of exact values.
  /// All the values must be specified.
  ///
  /// This will rarely be used directly. It is used by [lerp] to create
  /// intermediate themes based on two themes created with the
  /// [SfChatThemeData] constructor.
  const SfChatThemeData({
    this.actionButtonForegroundColor,
    this.actionButtonBackgroundColor,
    this.actionButtonFocusColor,
    this.actionButtonHoverColor,
    this.actionButtonSplashColor,
    this.actionButtonDisabledForegroundColor,
    this.actionButtonDisabledBackgroundColor,
    this.actionButtonElevation = 0.0,
    this.actionButtonFocusElevation = 0.0,
    this.actionButtonHoverElevation = 0.0,
    this.actionButtonHighlightElevation = 0.0,
    this.actionButtonDisabledElevation = 0.0,
    this.actionButtonMouseCursor,
    this.actionButtonShape,
    this.outgoingBubbleContentBackgroundColor,
    this.incomingBubbleContentBackgroundColor,
    this.editorTextStyle,
    this.outgoingContentTextStyle,
    this.incomingContentTextStyle,
    this.outgoingPrimaryHeaderTextStyle,
    this.incomingPrimaryHeaderTextStyle,
    this.outgoingSecondaryHeaderTextStyle,
    this.incomingSecondaryHeaderTextStyle,
    this.outgoingBubbleContentShape,
    this.incomingBubbleContentShape,
  });

  /// Returns a new instance of [SfChatThemeData.raw] for the given values.
  ///
  /// If any of the values are null, the default values will be set.
  factory SfChatThemeData.raw({
    Color? actionButtonForegroundColor,
    Color? actionButtonBackgroundColor,
    Color? actionButtonFocusColor,
    Color? actionButtonHoverColor,
    Color? actionButtonSplashColor,
    Color? actionButtonDisabledForegroundColor,
    Color? actionButtonDisabledBackgroundColor,
    double? actionButtonElevation,
    double? actionButtonFocusElevation,
    double? actionButtonHoverElevation,
    double? actionButtonDisabledElevation,
    double? actionButtonHighlightElevation,
    ShapeBorder? actionButtonShape,
    MouseCursor? actionButtonMouseCursor,
    Color? outgoingBubbleContentBackgroundColor,
    Color? incomingBubbleContentBackgroundColor,
    TextStyle? editorTextStyle,
    TextStyle? outgoingContentTextStyle,
    TextStyle? incomingContentTextStyle,
    TextStyle? outgoingPrimaryHeaderTextStyle,
    TextStyle? incomingPrimaryHeaderTextStyle,
    TextStyle? outgoingSecondaryHeaderTextStyle,
    TextStyle? incomingSecondaryHeaderTextStyle,
    ShapeBorder? outgoingBubbleContentShape,
    ShapeBorder? incomingBubbleContentShape,
  }) {
    return SfChatThemeData(
      actionButtonForegroundColor: actionButtonForegroundColor,
      actionButtonBackgroundColor: actionButtonBackgroundColor,
      actionButtonFocusColor: actionButtonFocusColor,
      actionButtonHoverColor: actionButtonHoverColor,
      actionButtonSplashColor: actionButtonSplashColor,
      actionButtonDisabledForegroundColor: actionButtonDisabledForegroundColor,
      actionButtonDisabledBackgroundColor: actionButtonDisabledBackgroundColor,
      actionButtonElevation: actionButtonElevation ?? 0.0,
      actionButtonFocusElevation: actionButtonFocusElevation ?? 0.0,
      actionButtonHoverElevation: actionButtonHoverElevation ?? 0.0,
      actionButtonDisabledElevation: actionButtonDisabledElevation ?? 0.0,
      actionButtonHighlightElevation: actionButtonHighlightElevation ?? 0.0,
      actionButtonShape: actionButtonShape,
      actionButtonMouseCursor: actionButtonMouseCursor,
      outgoingBubbleContentBackgroundColor:
          outgoingBubbleContentBackgroundColor,
      incomingBubbleContentBackgroundColor:
          incomingBubbleContentBackgroundColor,
      editorTextStyle: editorTextStyle,
      outgoingContentTextStyle: outgoingContentTextStyle,
      incomingContentTextStyle: incomingContentTextStyle,
      outgoingPrimaryHeaderTextStyle: outgoingPrimaryHeaderTextStyle,
      incomingPrimaryHeaderTextStyle: incomingPrimaryHeaderTextStyle,
      outgoingSecondaryHeaderTextStyle: outgoingSecondaryHeaderTextStyle,
      incomingSecondaryHeaderTextStyle: incomingSecondaryHeaderTextStyle,
      outgoingBubbleContentShape: outgoingBubbleContentShape,
      incomingBubbleContentShape: incomingBubbleContentShape,
    );
  }

  /// Color for the foreground elements (text or icons) of action buttons.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         actionButtonForegroundColor: Colors.white,
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? actionButtonForegroundColor;

  /// Color for the background of action buttons.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         actionButtonBackgroundColor: Colors.blue,
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? actionButtonBackgroundColor;

  /// Color for the action button when it is focused.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         actionButtonFocusColor: Colors.green,
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? actionButtonFocusColor;

  /// Color for the action button when hovered over.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         actionButtonHoverColor: Colors.orange,
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? actionButtonHoverColor;

  /// Color for the splash effect of action buttons.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         actionButtonSplashColor: Colors.red,
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? actionButtonSplashColor;

  /// Color for the foreground elements (text or icons) of
  /// action buttons when disabled.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         actionButtonDisabledForegroundColor: Colors.grey,
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? actionButtonDisabledForegroundColor;

  /// Color for the background of action buttons when disabled.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         actionButtonDisabledBackgroundColor: Colors.grey[400],
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? actionButtonDisabledBackgroundColor;

  /// Depth of the action button's shadow in its default state.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         actionButtonElevation: 4.0,
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final double actionButtonElevation;

  /// Depth of the action button's shadow when focused.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         actionButtonFocusElevation: 8.0,
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final double actionButtonFocusElevation;

  /// Depth of the action button's shadow when hovered over.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         actionButtonHoverElevation: 6.0,
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final double actionButtonHoverElevation;

  /// Depth of the action button's shadow when disabled.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         actionButtonDisabledElevation: 2.0,
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final double actionButtonDisabledElevation;

  /// Depth of the action button's shadow when highlighted.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         actionButtonHighlightElevation: 12.0,
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final double actionButtonHighlightElevation;

  /// Shape of the action button.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         actionButtonShape: RoundedRectangleBorder(
  ///           borderRadius: BorderRadius.circular(12.0),
  ///         ),
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final ShapeBorder? actionButtonShape;

  /// Customizes the cursor that appears when you hover
  /// over the button.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         actionButtonMouseCursor: SystemMouseCursors.click,
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final MouseCursor? actionButtonMouseCursor;

  /// Background color of outgoing message bubbles.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         outgoingBubbleContentBackgroundColor: Colors.blueAccent,
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? outgoingBubbleContentBackgroundColor;

  /// Background color of incoming message bubbles.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         incomingBubbleContentBackgroundColor: Colors.grey[300],
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? incomingBubbleContentBackgroundColor;

  /// Text style for the message editor.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         editorTextStyle: TextStyle(
  ///           fontSize: 16.0,
  ///           color: Colors.black,
  ///         ),
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final TextStyle? editorTextStyle;

  /// Text style for outgoing message content.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         outgoingContentTextStyle: TextStyle(
  ///           fontSize: 14.0,
  ///           color: Colors.white,
  ///         ),
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final TextStyle? outgoingContentTextStyle;

  /// Text style for incoming message content.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         incomingContentTextStyle: TextStyle(
  ///           fontSize: 14.0,
  ///           color: Colors.black,
  ///         ),
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final TextStyle? incomingContentTextStyle;

  /// Text style for the primary header of outgoing messages.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         outgoingPrimaryHeaderTextStyle: TextStyle(
  ///           fontSize: 12.0,
  ///           fontWeight: FontWeight.bold,
  ///           color: Colors.white,
  ///         ),
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final TextStyle? outgoingPrimaryHeaderTextStyle;

  /// Text style for the primary header of incoming messages.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         incomingPrimaryHeaderTextStyle: TextStyle(
  ///           fontSize: 12.0,
  ///           fontWeight: FontWeight.bold,
  ///           color: Colors.black,
  ///         ),
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final TextStyle? incomingPrimaryHeaderTextStyle;

  /// Text style for the secondary header of outgoing messages.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         outgoingSecondaryHeaderTextStyle: TextStyle(
  ///           fontSize: 10.0,
  ///           color: Colors.white70,
  ///         ),
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final TextStyle? outgoingSecondaryHeaderTextStyle;

  /// Text style for the secondary header of incoming messages.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         incomingSecondaryHeaderTextStyle: TextStyle(
  ///           fontSize: 10.0,
  ///           color: Colors.black54,
  ///         ),
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final TextStyle? incomingSecondaryHeaderTextStyle;

  /// Shape of the outgoing message bubble.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         outgoingBubbleContentShape: RoundedRectangleBorder(
  ///           borderRadius: BorderRadius.circular(12.0),
  ///         ),
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final ShapeBorder? outgoingBubbleContentShape;

  /// Shape of the incoming message bubble.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfChatTheme(
  ///       data: SfChatThemeData(
  ///         incomingBubbleContentShape: RoundedRectangleBorder(
  ///           borderRadius: BorderRadius.circular(12.0),
  ///         ),
  ///       ),
  ///       child: SfChat(),
  ///     ),
  ///   );
  /// }
  /// ```
  final ShapeBorder? incomingBubbleContentShape;

  SfChatThemeData copyWith({
    Color? actionButtonForegroundColor,
    Color? actionButtonBackgroundColor,
    Color? actionButtonFocusColor,
    Color? actionButtonHoverColor,
    Color? actionButtonSplashColor,
    Color? actionButtonDisabledForegroundColor,
    Color? actionButtonDisabledBackgroundColor,
    double? actionButtonElevation,
    double? actionButtonFocusElevation,
    double? actionButtonHoverElevation,
    double? actionButtonDisabledElevation,
    double? actionButtonHighlightElevation,
    ShapeBorder? actionButtonShape,
    MouseCursor? actionButtonMouseCursor,
    Color? outgoingBubbleContentBackgroundColor,
    Color? incomingBubbleContentBackgroundColor,
    TextStyle? editorTextStyle,
    TextStyle? outgoingContentTextStyle,
    TextStyle? incomingContentTextStyle,
    TextStyle? outgoingPrimaryHeaderTextStyle,
    TextStyle? incomingPrimaryHeaderTextStyle,
    TextStyle? outgoingSecondaryHeaderTextStyle,
    TextStyle? incomingSecondaryHeaderTextStyle,
    ShapeBorder? outgoingBubbleContentShape,
    ShapeBorder? incomingBubbleContentShape,
  }) {
    return SfChatThemeData.raw(
      actionButtonForegroundColor:
          actionButtonForegroundColor ?? this.actionButtonForegroundColor,
      actionButtonBackgroundColor:
          actionButtonBackgroundColor ?? this.actionButtonBackgroundColor,
      actionButtonFocusColor:
          actionButtonFocusColor ?? this.actionButtonFocusColor,
      actionButtonHoverColor:
          actionButtonHoverColor ?? this.actionButtonHoverColor,
      actionButtonSplashColor:
          actionButtonSplashColor ?? this.actionButtonSplashColor,
      actionButtonDisabledForegroundColor:
          actionButtonDisabledForegroundColor ??
              this.actionButtonDisabledForegroundColor,
      actionButtonDisabledBackgroundColor:
          actionButtonDisabledBackgroundColor ??
              this.actionButtonDisabledBackgroundColor,
      actionButtonElevation:
          actionButtonElevation ?? this.actionButtonElevation,
      actionButtonFocusElevation:
          actionButtonFocusElevation ?? this.actionButtonFocusElevation,
      actionButtonHoverElevation:
          actionButtonHoverElevation ?? this.actionButtonHoverElevation,
      actionButtonDisabledElevation:
          actionButtonDisabledElevation ?? this.actionButtonDisabledElevation,
      actionButtonHighlightElevation:
          actionButtonHighlightElevation ?? this.actionButtonHighlightElevation,
      actionButtonShape: actionButtonShape ?? this.actionButtonShape,
      actionButtonMouseCursor:
          actionButtonMouseCursor ?? this.actionButtonMouseCursor,
      outgoingBubbleContentBackgroundColor:
          outgoingBubbleContentBackgroundColor ??
              this.outgoingBubbleContentBackgroundColor,
      incomingBubbleContentBackgroundColor:
          incomingBubbleContentBackgroundColor ??
              this.incomingBubbleContentBackgroundColor,
      editorTextStyle: editorTextStyle ?? this.editorTextStyle,
      outgoingContentTextStyle:
          outgoingContentTextStyle ?? this.outgoingContentTextStyle,
      incomingContentTextStyle:
          incomingContentTextStyle ?? this.incomingContentTextStyle,
      outgoingPrimaryHeaderTextStyle:
          outgoingPrimaryHeaderTextStyle ?? this.outgoingPrimaryHeaderTextStyle,
      incomingPrimaryHeaderTextStyle:
          incomingPrimaryHeaderTextStyle ?? this.incomingPrimaryHeaderTextStyle,
      outgoingSecondaryHeaderTextStyle: outgoingSecondaryHeaderTextStyle ??
          this.outgoingSecondaryHeaderTextStyle,
      incomingSecondaryHeaderTextStyle: incomingSecondaryHeaderTextStyle ??
          this.incomingSecondaryHeaderTextStyle,
      outgoingBubbleContentShape:
          outgoingBubbleContentShape ?? this.outgoingBubbleContentShape,
      incomingBubbleContentShape:
          incomingBubbleContentShape ?? this.incomingBubbleContentShape,
    );
  }

  static SfChatThemeData? lerp(
      SfChatThemeData? a, SfChatThemeData? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return SfChatThemeData(
      actionButtonForegroundColor: Color.lerp(
          a!.actionButtonForegroundColor, b!.actionButtonForegroundColor, t),
      actionButtonBackgroundColor: Color.lerp(
          a.actionButtonBackgroundColor, b.actionButtonBackgroundColor, t),
      actionButtonFocusColor:
          Color.lerp(a.actionButtonFocusColor, b.actionButtonFocusColor, t),
      actionButtonHoverColor:
          Color.lerp(a.actionButtonHoverColor, b.actionButtonHoverColor, t),
      actionButtonSplashColor:
          Color.lerp(a.actionButtonSplashColor, b.actionButtonSplashColor, t),
      actionButtonDisabledForegroundColor: Color.lerp(
          a.actionButtonDisabledForegroundColor,
          b.actionButtonDisabledForegroundColor,
          t),
      actionButtonDisabledBackgroundColor: Color.lerp(
          a.actionButtonDisabledBackgroundColor,
          b.actionButtonDisabledBackgroundColor,
          t),
      actionButtonElevation:
          lerpDouble(a.actionButtonElevation, b.actionButtonElevation, t) ??
              0.0,
      actionButtonFocusElevation: lerpDouble(
              a.actionButtonFocusElevation, b.actionButtonFocusElevation, t) ??
          0.0,
      actionButtonHoverElevation: lerpDouble(
              a.actionButtonHoverElevation, b.actionButtonHoverElevation, t) ??
          0.0,
      actionButtonDisabledElevation: lerpDouble(a.actionButtonDisabledElevation,
              b.actionButtonDisabledElevation, t) ??
          0.0,
      actionButtonHighlightElevation: lerpDouble(
              a.actionButtonHighlightElevation,
              b.actionButtonHighlightElevation,
              t) ??
          0.0,
      actionButtonShape:
          ShapeBorder.lerp(a.actionButtonShape, b.actionButtonShape, t),
      actionButtonMouseCursor:
          t < 0.5 ? a.actionButtonMouseCursor : b.actionButtonMouseCursor,
      outgoingBubbleContentBackgroundColor: Color.lerp(
          a.outgoingBubbleContentBackgroundColor,
          b.outgoingBubbleContentBackgroundColor,
          t),
      incomingBubbleContentBackgroundColor: Color.lerp(
          a.incomingBubbleContentBackgroundColor,
          b.incomingBubbleContentBackgroundColor,
          t),
      editorTextStyle: TextStyle.lerp(a.editorTextStyle, b.editorTextStyle, t),
      outgoingContentTextStyle: TextStyle.lerp(
          a.outgoingContentTextStyle, b.outgoingContentTextStyle, t),
      incomingContentTextStyle: TextStyle.lerp(
          a.incomingContentTextStyle, b.incomingContentTextStyle, t),
      outgoingPrimaryHeaderTextStyle: TextStyle.lerp(
          a.outgoingPrimaryHeaderTextStyle,
          b.outgoingPrimaryHeaderTextStyle,
          t),
      incomingPrimaryHeaderTextStyle: TextStyle.lerp(
          a.incomingPrimaryHeaderTextStyle,
          b.incomingPrimaryHeaderTextStyle,
          t),
      outgoingSecondaryHeaderTextStyle: TextStyle.lerp(
          a.outgoingSecondaryHeaderTextStyle,
          b.outgoingSecondaryHeaderTextStyle,
          t),
      incomingSecondaryHeaderTextStyle: TextStyle.lerp(
          a.incomingSecondaryHeaderTextStyle,
          b.incomingSecondaryHeaderTextStyle,
          t),
      outgoingBubbleContentShape: ShapeBorder.lerp(
          a.outgoingBubbleContentShape, b.outgoingBubbleContentShape, t),
      incomingBubbleContentShape: ShapeBorder.lerp(
          a.incomingBubbleContentShape, b.incomingBubbleContentShape, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is SfChatThemeData &&
        other.actionButtonForegroundColor == actionButtonForegroundColor &&
        other.actionButtonBackgroundColor == actionButtonBackgroundColor &&
        other.actionButtonFocusColor == actionButtonFocusColor &&
        other.actionButtonHoverColor == actionButtonHoverColor &&
        other.actionButtonSplashColor == actionButtonSplashColor &&
        other.actionButtonDisabledForegroundColor ==
            actionButtonDisabledForegroundColor &&
        other.actionButtonDisabledBackgroundColor ==
            actionButtonDisabledBackgroundColor &&
        other.actionButtonElevation == actionButtonElevation &&
        other.actionButtonFocusElevation == actionButtonFocusElevation &&
        other.actionButtonHoverElevation == actionButtonHoverElevation &&
        other.actionButtonDisabledElevation == actionButtonDisabledElevation &&
        other.actionButtonHighlightElevation ==
            actionButtonHighlightElevation &&
        other.actionButtonShape == actionButtonShape &&
        other.actionButtonMouseCursor == actionButtonMouseCursor &&
        other.outgoingBubbleContentBackgroundColor ==
            outgoingBubbleContentBackgroundColor &&
        other.incomingBubbleContentBackgroundColor ==
            incomingBubbleContentBackgroundColor &&
        other.editorTextStyle == editorTextStyle &&
        other.outgoingContentTextStyle == outgoingContentTextStyle &&
        other.incomingContentTextStyle == incomingContentTextStyle &&
        other.outgoingPrimaryHeaderTextStyle ==
            outgoingPrimaryHeaderTextStyle &&
        other.incomingPrimaryHeaderTextStyle ==
            incomingPrimaryHeaderTextStyle &&
        other.outgoingSecondaryHeaderTextStyle ==
            outgoingSecondaryHeaderTextStyle &&
        other.incomingSecondaryHeaderTextStyle ==
            incomingSecondaryHeaderTextStyle &&
        other.outgoingBubbleContentShape == outgoingBubbleContentShape &&
        other.incomingBubbleContentShape == incomingBubbleContentShape;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      actionButtonForegroundColor,
      actionButtonBackgroundColor,
      actionButtonFocusColor,
      actionButtonHoverColor,
      actionButtonSplashColor,
      actionButtonDisabledForegroundColor,
      actionButtonDisabledBackgroundColor,
      actionButtonElevation,
      actionButtonFocusElevation,
      actionButtonHoverElevation,
      actionButtonDisabledElevation,
      actionButtonHighlightElevation,
      actionButtonShape,
      actionButtonMouseCursor,
      outgoingBubbleContentBackgroundColor,
      incomingBubbleContentBackgroundColor,
      editorTextStyle,
      outgoingContentTextStyle,
      incomingContentTextStyle,
      outgoingPrimaryHeaderTextStyle,
      incomingPrimaryHeaderTextStyle,
      outgoingSecondaryHeaderTextStyle,
      incomingSecondaryHeaderTextStyle,
      outgoingBubbleContentShape,
      incomingBubbleContentShape,
    ];
    return Object.hashAll(values);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    const SfChatThemeData defaultData = SfChatThemeData();
    properties.add(
      ColorProperty(
        'actionButtonForegroundColor',
        actionButtonForegroundColor,
        defaultValue: defaultData.actionButtonForegroundColor,
      ),
    );
    properties.add(
      ColorProperty(
        'actionButtonBackgroundColor',
        actionButtonBackgroundColor,
        defaultValue: defaultData.actionButtonBackgroundColor,
      ),
    );
    properties.add(
      ColorProperty(
        'actionButtonFocusColor',
        actionButtonFocusColor,
        defaultValue: defaultData.actionButtonFocusColor,
      ),
    );
    properties.add(
      ColorProperty(
        'actionButtonHoverColor',
        actionButtonHoverColor,
        defaultValue: defaultData.actionButtonHoverColor,
      ),
    );
    properties.add(
      ColorProperty(
        'actionButtonSplashColor',
        actionButtonSplashColor,
        defaultValue: defaultData.actionButtonSplashColor,
      ),
    );
    properties.add(
      ColorProperty(
        'actionButtonDisabledForegroundColor',
        actionButtonDisabledForegroundColor,
        defaultValue: defaultData.actionButtonDisabledForegroundColor,
      ),
    );
    properties.add(
      ColorProperty(
        'actionButtonDisabledBackgroundColor',
        actionButtonDisabledBackgroundColor,
        defaultValue: defaultData.actionButtonDisabledBackgroundColor,
      ),
    );
    properties.add(
      DoubleProperty(
        'actionButtonElevation',
        actionButtonElevation,
        defaultValue: defaultData.actionButtonElevation,
      ),
    );
    properties.add(
      DoubleProperty(
        'actionButtonFocusElevation',
        actionButtonFocusElevation,
        defaultValue: defaultData.actionButtonFocusElevation,
      ),
    );
    properties.add(
      DoubleProperty(
        'actionButtonHoverElevation',
        actionButtonHoverElevation,
        defaultValue: defaultData.actionButtonHoverElevation,
      ),
    );
    properties.add(
      DoubleProperty(
        'actionButtonDisabledElevation',
        actionButtonDisabledElevation,
        defaultValue: defaultData.actionButtonDisabledElevation,
      ),
    );
    properties.add(
      DoubleProperty(
        'actionButtonHighlightElevation',
        actionButtonHighlightElevation,
        defaultValue: defaultData.actionButtonHighlightElevation,
      ),
    );
    properties.add(
      DiagnosticsProperty<ShapeBorder>(
        'actionButtonShape',
        actionButtonShape,
        defaultValue: defaultData.actionButtonShape,
      ),
    );
    properties.add(
      DiagnosticsProperty<MouseCursor>(
        'actionButtonMouseCursor',
        actionButtonMouseCursor,
        defaultValue: defaultData.actionButtonMouseCursor,
      ),
    );
    properties.add(
      ColorProperty(
        'outgoingBubbleContentBackgroundColor',
        outgoingBubbleContentBackgroundColor,
        defaultValue: defaultData.outgoingBubbleContentBackgroundColor,
      ),
    );
    properties.add(
      ColorProperty(
        'incomingBubbleContentBackgroundColor',
        incomingBubbleContentBackgroundColor,
        defaultValue: defaultData.incomingBubbleContentBackgroundColor,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'editorTextStyle',
        editorTextStyle,
        defaultValue: defaultData.editorTextStyle,
      ),
    );

    properties.add(
      DiagnosticsProperty<TextStyle>(
        'outgoingContentTextStyle',
        outgoingContentTextStyle,
        defaultValue: defaultData.outgoingContentTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'incomingContentTextStyle',
        incomingContentTextStyle,
        defaultValue: defaultData.incomingContentTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'outgoingPrimaryHeaderTextStyle',
        outgoingPrimaryHeaderTextStyle,
        defaultValue: defaultData.outgoingPrimaryHeaderTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'incomingPrimaryHeaderTextStyle',
        incomingPrimaryHeaderTextStyle,
        defaultValue: defaultData.incomingPrimaryHeaderTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'outgoingSecondaryHeaderTextStyle',
        outgoingSecondaryHeaderTextStyle,
        defaultValue: defaultData.outgoingSecondaryHeaderTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'incomingSecondaryHeaderTextStyle',
        incomingSecondaryHeaderTextStyle,
        defaultValue: defaultData.incomingSecondaryHeaderTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<ShapeBorder>(
        'outgoingBubbleContentShape',
        outgoingBubbleContentShape,
        defaultValue: defaultData.outgoingBubbleContentShape,
      ),
    );
    properties.add(
      DiagnosticsProperty<ShapeBorder>(
        'incomingBubbleContentShape',
        incomingBubbleContentShape,
        defaultValue: defaultData.incomingBubbleContentShape,
      ),
    );
  }
}
