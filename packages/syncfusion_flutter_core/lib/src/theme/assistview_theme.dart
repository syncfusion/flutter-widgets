import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'theme_widget.dart';

/// Applies a theme to descendant Syncfusion assist widgets.
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfAIAssistViewTheme(
///       data: SfAIAssistViewThemeData(
///         brightness: Brightness.dark,
///       ),
///       child: SfAIAssistView()
///     ),
///   );
/// }
/// ```
class SfAIAssistViewTheme extends InheritedTheme {
  /// Applies the given theme [data] to [child].
  ///
  /// The [data] and [child] arguments must not be null.
  const SfAIAssistViewTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Specifies the color and typography values for descendant assist widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         brightness: Brightness.dark,
  ///       ),
  ///       child: SfAIAssistView()
  ///     ),
  ///   );
  /// }
  /// ```
  final SfAIAssistViewThemeData data;

  /// The data from the closest [SfAIAssistViewTheme] instance
  /// that encloses the given context.
  ///
  /// Defaults to [SfThemeData.assistThemeData] if there is no
  /// [SfAIAssistViewTheme] in the given build context.
  static SfAIAssistViewThemeData of(BuildContext context) {
    final SfAIAssistViewTheme? assistTheme =
        context.dependOnInheritedWidgetOfExactType<SfAIAssistViewTheme>();
    return assistTheme?.data ?? SfTheme.of(context).assistThemeData;
  }

  @override
  bool updateShouldNotify(SfAIAssistViewTheme oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final SfAIAssistViewTheme? ancestorTheme =
        context.findAncestorWidgetOfExactType<SfAIAssistViewTheme>();
    return identical(this, ancestorTheme)
        ? child
        : SfAIAssistViewTheme(data: data, child: child);
  }
}

/// Holds the color and typography values for a [SfAIAssistViewTheme].
/// Use this class to configure a [SfAIAssistViewTheme] widget, or to set the
/// [SfThemeData.assistThemeData] for a [SfTheme] widget.
///
/// To obtain the current theme, use [SfAIAssistViewTheme.of].
@immutable
class SfAIAssistViewThemeData with Diagnosticable {
  /// Create a [SfAIAssistViewThemeData] given a set of exact values.
  /// All the values must be specified.
  ///
  /// This will rarely be used directly. It is used by [lerp] to create
  /// intermediate themes based on two themes created with the
  /// [SfAIAssistViewThemeData] constructor.
  const SfAIAssistViewThemeData({
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
    this.requestAvatarBackgroundColor,
    this.responseAvatarBackgroundColor,
    this.requestMessageBackgroundColor,
    this.responseMessageBackgroundColor,
    this.editorTextStyle,
    this.requestContentTextStyle,
    this.responseContentTextStyle,
    this.requestPrimaryHeaderTextStyle,
    this.responsePrimaryHeaderTextStyle,
    this.requestSecondaryHeaderTextStyle,
    this.responseSecondaryHeaderTextStyle,
    this.suggestionItemTextStyle,
    this.requestMessageShape,
    this.responseMessageShape,
    this.suggestionBackgroundColor,
    this.suggestionBackgroundShape,
    this.suggestionItemBackgroundColor,
    this.suggestionItemShape,
    this.responseToolbarBackgroundColor,
    this.responseToolbarBackgroundShape,
    this.responseToolbarItemBackgroundColor,
    this.responseToolbarItemShape,
  });

  /// Returns a new instance of [SfAIAssistViewThemeData.raw] for the given
  /// values.
  ///
  /// If any of the values are null, the default values will be set.
  factory SfAIAssistViewThemeData.raw({
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
    Color? requestAvatarBackgroundColor,
    Color? responseAvatarBackgroundColor,
    Color? requestMessageBackgroundColor,
    Color? responseMessageBackgroundColor,
    TextStyle? editorTextStyle,
    TextStyle? requestContentTextStyle,
    TextStyle? responseContentTextStyle,
    TextStyle? requestPrimaryHeaderTextStyle,
    TextStyle? responsePrimaryHeaderTextStyle,
    TextStyle? requestSecondaryHeaderTextStyle,
    TextStyle? responseSecondaryHeaderTextStyle,
    WidgetStateProperty<TextStyle?>? suggestionItemTextStyle,
    ShapeBorder? requestMessageShape,
    ShapeBorder? responseMessageShape,
    Color? suggestionBackgroundColor,
    ShapeBorder? suggestionBackgroundShape,
    WidgetStateProperty<Color?>? suggestionItemBackgroundColor,
    WidgetStateProperty<ShapeBorder?>? suggestionItemShape,
    Color? responseToolbarBackgroundColor,
    ShapeBorder? responseToolbarBackgroundShape,
    WidgetStateProperty<Color?>? responseToolbarItemBackgroundColor,
    WidgetStateProperty<ShapeBorder?>? responseToolbarItemShape,
  }) {
    return SfAIAssistViewThemeData(
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
      requestAvatarBackgroundColor: requestAvatarBackgroundColor,
      responseAvatarBackgroundColor: responseAvatarBackgroundColor,
      requestMessageBackgroundColor: requestMessageBackgroundColor,
      responseMessageBackgroundColor: responseMessageBackgroundColor,
      editorTextStyle: editorTextStyle,
      requestContentTextStyle: requestContentTextStyle,
      responseContentTextStyle: responseContentTextStyle,
      requestPrimaryHeaderTextStyle: requestPrimaryHeaderTextStyle,
      responsePrimaryHeaderTextStyle: responsePrimaryHeaderTextStyle,
      requestSecondaryHeaderTextStyle: requestSecondaryHeaderTextStyle,
      responseSecondaryHeaderTextStyle: responseSecondaryHeaderTextStyle,
      suggestionItemTextStyle: suggestionItemTextStyle,
      requestMessageShape: requestMessageShape,
      responseMessageShape: responseMessageShape,
      suggestionBackgroundColor: suggestionBackgroundColor,
      suggestionBackgroundShape: suggestionBackgroundShape,
      suggestionItemBackgroundColor: suggestionItemBackgroundColor,
      suggestionItemShape: suggestionItemShape,
      responseToolbarBackgroundColor: responseToolbarBackgroundColor,
      responseToolbarBackgroundShape: responseToolbarBackgroundShape,
      responseToolbarItemBackgroundColor: responseToolbarItemBackgroundColor,
      responseToolbarItemShape: responseToolbarItemShape,
    );
  }

  /// Color for the foreground elements (text or icons) of action buttons.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         actionButtonForegroundColor: Colors.white,
  ///       ),
  ///       child: SfAIAssistView(),
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
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         actionButtonBackgroundColor: Colors.blue,
  ///       ),
  ///       child: SfAIAssistView(),
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
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         actionButtonFocusColor: Colors.green,
  ///       ),
  ///       child: SfAIAssistView(),
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
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         actionButtonHoverColor: Colors.orange,
  ///       ),
  ///       child: SfAIAssistView(),
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
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         actionButtonSplashColor: Colors.red,
  ///       ),
  ///       child: SfAIAssistView(),
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
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         actionButtonDisabledForegroundColor: Colors.grey,
  ///       ),
  ///       child: SfAIAssistView(),
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
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         actionButtonDisabledBackgroundColor: Colors.grey[400],
  ///       ),
  ///       child: SfAIAssistView(),
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
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         actionButtonElevation: 4.0,
  ///       ),
  ///       child: SfAIAssistView(),
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
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         actionButtonFocusElevation: 8.0,
  ///       ),
  ///       child: SfAIAssistView(),
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
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         actionButtonHoverElevation: 6.0,
  ///       ),
  ///       child: SfAIAssistView(),
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
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         actionButtonDisabledElevation: 2.0,
  ///       ),
  ///       child: SfAIAssistView(),
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
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         actionButtonHighlightElevation: 12.0,
  ///       ),
  ///       child: SfAIAssistView(),
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
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         actionButtonShape: RoundedRectangleBorder(
  ///           borderRadius: BorderRadius.circular(12.0),
  ///         ),
  ///       ),
  ///       child: SfAIAssistView(),
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
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         actionButtonMouseCursor: SystemMouseCursors.click,
  ///       ),
  ///       child: SfAIAssistView(),
  ///     ),
  ///   );
  /// }
  /// ```
  final MouseCursor? actionButtonMouseCursor;

  /// Background color of request avatar.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         requestAvatarBackgroundColor: Colors.blueAccent,
  ///       ),
  ///       child: SfAIAssistView(),
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? requestAvatarBackgroundColor;

  /// Background color of response avatar.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         responseAvatarBackgroundColor: Colors.blue,
  ///       ),
  ///       child: SfAIAssistView(),
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? responseAvatarBackgroundColor;

  /// Background color of request message bubbles.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         requestMessageBackgroundColor: Colors.blueAccent,
  ///       ),
  ///       child: SfAIAssistView(),
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? requestMessageBackgroundColor;

  /// Background color of response message bubbles.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         responseMessageBackgroundColor: Colors.grey[300],
  ///       ),
  ///       child: SfAIAssistView(),
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? responseMessageBackgroundColor;

  /// Text style for the message editor.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         editorTextStyle: TextStyle(
  ///           fontSize: 16.0,
  ///           color: Colors.black,
  ///         ),
  ///       ),
  ///       child: SfAIAssistView(),
  ///     ),
  ///   );
  /// }
  /// ```
  final TextStyle? editorTextStyle;

  /// Text style for request message content.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         requestContentTextStyle: TextStyle(
  ///           fontSize: 14.0,
  ///           color: Colors.white,
  ///         ),
  ///       ),
  ///       child: SfAIAssistView(),
  ///     ),
  ///   );
  /// }
  /// ```
  final TextStyle? requestContentTextStyle;

  /// Text style for response message content.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         responseContentTextStyle: TextStyle(
  ///           fontSize: 14.0,
  ///           color: Colors.black,
  ///         ),
  ///       ),
  ///       child: SfAIAssistView(),
  ///     ),
  ///   );
  /// }
  /// ```
  final TextStyle? responseContentTextStyle;

  /// Text style for the primary header of request messages.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         requestPrimaryHeaderTextStyle: TextStyle(
  ///           fontSize: 12.0,
  ///           fontWeight: FontWeight.bold,
  ///           color: Colors.white,
  ///         ),
  ///       ),
  ///       child: SfAIAssistView(),
  ///     ),
  ///   );
  /// }
  /// ```
  final TextStyle? requestPrimaryHeaderTextStyle;

  /// Text style for the primary header of response messages.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         responsePrimaryHeaderTextStyle: TextStyle(
  ///           fontSize: 12.0,
  ///           fontWeight: FontWeight.bold,
  ///           color: Colors.black,
  ///         ),
  ///       ),
  ///       child: SfAIAssistView(),
  ///     ),
  ///   );
  /// }
  /// ```
  final TextStyle? responsePrimaryHeaderTextStyle;

  /// Text style for the secondary header of request messages.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         requestSecondaryHeaderTextStyle: TextStyle(
  ///           fontSize: 10.0,
  ///           color: Colors.white70,
  ///         ),
  ///       ),
  ///       child: SfAIAssistView(),
  ///     ),
  ///   );
  /// }
  /// ```
  final TextStyle? requestSecondaryHeaderTextStyle;

  /// Text style for the secondary header of response messages.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         responseSecondaryHeaderTextStyle: TextStyle(
  ///           fontSize: 10.0,
  ///           color: Colors.black54,
  ///         ),
  ///       ),
  ///       child: SfAIAssistView(),
  ///     ),
  ///   );
  /// }
  /// ```
  final TextStyle? responseSecondaryHeaderTextStyle;

  /// Text style for the suggestion items.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         suggestionItemTextStyle:
  ///             WidgetStateProperty.resolveWith<TextStyle>(
  ///           (Set<WidgetState> states) {
  ///             if (states.contains(WidgetState.hovered)) {
  ///               return TextStyle(fontSize: 14.0, color: Colors.blue);
  ///             }
  ///             return TextStyle(fontSize: 15.0, color: Colors.green);
  ///           },
  ///         ),
  ///       ),
  ///       child: SfAIAssistView(),
  ///     ),
  ///   );
  /// }
  /// ```
  final WidgetStateProperty<TextStyle?>? suggestionItemTextStyle;

  /// Shape of the request message bubble.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         requestMessageShape: RoundedRectangleBorder(
  ///           borderRadius: BorderRadius.circular(12.0),
  ///         ),
  ///       ),
  ///       child: SfAIAssistView(),
  ///     ),
  ///   );
  /// }
  /// ```
  final ShapeBorder? requestMessageShape;

  /// Shape of the response message bubble.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         responseMessageShape: RoundedRectangleBorder(
  ///           borderRadius: BorderRadius.circular(12.0),
  ///         ),
  ///       ),
  ///       child: SfAIAssistView(),
  ///     ),
  ///   );
  /// }
  /// ```
  final ShapeBorder? responseMessageShape;

  /// Background color of the suggestion area.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         suggestionBackgroundColor: Colors.blue,
  ///       ),
  ///       child: SfAIAssistView(),
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? suggestionBackgroundColor;

  /// Shape of the suggestion area.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         suggestionBackgroundShape: RoundedRectangleBorder(
  ///           borderRadius: BorderRadius.circular(8.0),
  ///         ),
  ///       ),
  ///       child: SfAIAssistView(),
  ///     ),
  ///   );
  /// }
  /// ```
  final ShapeBorder? suggestionBackgroundShape;

  /// Color of the suggestion item background, which can vary based on the
  /// widget's state.
  /// This uses a [WidgetStateProperty] to allow state-specific changes.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         suggestionItemBackgroundColor:
  ///             WidgetStateProperty.resolveWith<Color>(
  ///           (Set<WidgetState> states) {
  ///             if (states.contains(WidgetState.hovered)) {
  ///               return Colors.blueAccent;
  ///             }
  ///             return Colors.blue;
  ///           },
  ///         ),
  ///       ),
  ///       child: SfAIAssistView(),
  ///     ),
  ///   );
  /// }
  /// ```
  final WidgetStateProperty<Color?>? suggestionItemBackgroundColor;

  /// Shape of the suggestion item, which can vary based on the widget's state.
  /// This uses a [WidgetStateProperty] to allow state-specific changes.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         suggestionItemShape:
  ///             WidgetStateProperty.resolveWith<ShapeBorder>(
  ///           (Set<WidgetState> states) {
  ///             if (states.contains(WidgetState.hovered)) {
  ///               return RoundedRectangleBorder(
  ///                 borderRadius: BorderRadius.circular(12.0),
  ///               );
  ///             }
  ///             return RoundedRectangleBorder(
  ///               borderRadius: BorderRadius.circular(8.0),
  ///             );
  ///           },
  ///         ),
  ///       ),
  ///       child: SfAIAssistView(),
  ///     ),
  ///   );
  /// }
  /// ```
  final WidgetStateProperty<ShapeBorder?>? suggestionItemShape;

  /// Background color of the footer area.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         responseToolbarBackgroundColor: Colors.blue,
  ///       ),
  ///       child: SfAIAssistView(),
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? responseToolbarBackgroundColor;

  /// Shape of the footer area.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         responseToolbarBackgroundShape: RoundedRectangleBorder(
  ///           borderRadius: BorderRadius.circular(8.0),
  ///         ),
  ///       ),
  ///       child: SfAIAssistView(),
  ///     ),
  ///   );
  /// }
  /// ```
  final ShapeBorder? responseToolbarBackgroundShape;

  /// Color of the footer item background, which can vary based on the
  /// widget's state.
  /// This uses a [WidgetStateProperty] to allow state-specific changes.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         responseToolbarItemBackgroundColor:
  ///             WidgetStateProperty.resolveWith<Color>(
  ///           (Set<WidgetState> states) {
  ///             if (states.contains(WidgetState.hovered)) {
  ///               return Colors.blueAccent;
  ///             }
  ///             return Colors.blue;
  ///           },
  ///         ),
  ///       ),
  ///       child: SfAIAssistView(),
  ///     ),
  ///   );
  /// }
  /// ```
  final WidgetStateProperty<Color?>? responseToolbarItemBackgroundColor;

  /// Shape of the footer item, which can vary based on the widget's state.
  /// This uses a [WidgetStateProperty] to allow state-specific changes.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfAIAssistViewTheme(
  ///       data: SfAIAssistViewThemeData(
  ///         responseToolbarItemShape:
  ///             WidgetStateProperty.resolveWith<ShapeBorder>(
  ///           (Set<WidgetState> states) {
  ///             if (states.contains(WidgetState.hovered)) {
  ///               return RoundedRectangleBorder(
  ///                 borderRadius: BorderRadius.circular(12.0),
  ///               );
  ///             }
  ///             return RoundedRectangleBorder(
  ///               borderRadius: BorderRadius.circular(8.0),
  ///             );
  ///           },
  ///         ),
  ///       ),
  ///       child: SfAIAssistView(),
  ///     ),
  ///   );
  /// }
  /// ```
  final WidgetStateProperty<ShapeBorder?>? responseToolbarItemShape;

  SfAIAssistViewThemeData copyWith({
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
    Color? requestAvatarBackgroundColor,
    Color? responseAvatarBackgroundColor,
    Color? requestMessageBackgroundColor,
    Color? responseMessageBackgroundColor,
    TextStyle? editorTextStyle,
    TextStyle? requestContentTextStyle,
    TextStyle? responseContentTextStyle,
    TextStyle? requestPrimaryHeaderTextStyle,
    TextStyle? responsePrimaryHeaderTextStyle,
    TextStyle? requestSecondaryHeaderTextStyle,
    TextStyle? responseSecondaryHeaderTextStyle,
    WidgetStateProperty<TextStyle?>? suggestionItemTextStyle,
    ShapeBorder? requestMessageShape,
    ShapeBorder? responseMessageShape,
    Color? suggestionBackgroundColor,
    ShapeBorder? suggestionBackgroundShape,
    WidgetStateProperty<Color?>? suggestionItemBackgroundColor,
    WidgetStateProperty<ShapeBorder?>? suggestionItemShape,
    Color? responseToolbarBackgroundColor,
    ShapeBorder? responseToolbarBackgroundShape,
    WidgetStateProperty<Color?>? responseToolbarItemBackgroundColor,
    WidgetStateProperty<ShapeBorder?>? responseToolbarItemShape,
  }) {
    return SfAIAssistViewThemeData.raw(
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
      requestAvatarBackgroundColor:
          requestAvatarBackgroundColor ?? this.requestAvatarBackgroundColor,
      responseAvatarBackgroundColor:
          responseAvatarBackgroundColor ?? this.responseAvatarBackgroundColor,
      requestMessageBackgroundColor:
          requestMessageBackgroundColor ?? this.requestMessageBackgroundColor,
      responseMessageBackgroundColor:
          responseMessageBackgroundColor ?? this.responseMessageBackgroundColor,
      editorTextStyle: editorTextStyle ?? this.editorTextStyle,
      requestContentTextStyle:
          requestContentTextStyle ?? this.requestContentTextStyle,
      responseContentTextStyle:
          responseContentTextStyle ?? this.responseContentTextStyle,
      requestPrimaryHeaderTextStyle:
          requestPrimaryHeaderTextStyle ?? this.requestPrimaryHeaderTextStyle,
      responsePrimaryHeaderTextStyle:
          responsePrimaryHeaderTextStyle ?? this.responsePrimaryHeaderTextStyle,
      requestSecondaryHeaderTextStyle: requestSecondaryHeaderTextStyle ??
          this.requestSecondaryHeaderTextStyle,
      responseSecondaryHeaderTextStyle: responseSecondaryHeaderTextStyle ??
          this.responseSecondaryHeaderTextStyle,
      suggestionItemTextStyle:
          suggestionItemTextStyle ?? this.suggestionItemTextStyle,
      requestMessageShape: requestMessageShape ?? this.requestMessageShape,
      responseMessageShape: responseMessageShape ?? this.responseMessageShape,
      suggestionBackgroundColor:
          suggestionBackgroundColor ?? this.suggestionBackgroundColor,
      suggestionBackgroundShape:
          suggestionBackgroundShape ?? this.suggestionBackgroundShape,
      suggestionItemBackgroundColor:
          suggestionItemBackgroundColor ?? this.suggestionItemBackgroundColor,
      suggestionItemShape: suggestionItemShape ?? this.suggestionItemShape,
      responseToolbarBackgroundColor:
          responseToolbarBackgroundColor ?? this.responseToolbarBackgroundColor,
      responseToolbarBackgroundShape:
          responseToolbarBackgroundShape ?? this.responseToolbarBackgroundShape,
      responseToolbarItemBackgroundColor: responseToolbarItemBackgroundColor ??
          this.responseToolbarItemBackgroundColor,
      responseToolbarItemShape:
          responseToolbarItemShape ?? this.responseToolbarItemShape,
    );
  }

  static SfAIAssistViewThemeData? lerp(
      SfAIAssistViewThemeData? a, SfAIAssistViewThemeData? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return SfAIAssistViewThemeData(
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
      requestAvatarBackgroundColor: Color.lerp(
          a.requestAvatarBackgroundColor, b.requestAvatarBackgroundColor, t),
      responseAvatarBackgroundColor: Color.lerp(
          a.responseAvatarBackgroundColor, b.responseAvatarBackgroundColor, t),
      requestMessageBackgroundColor: Color.lerp(
          a.requestMessageBackgroundColor, b.requestMessageBackgroundColor, t),
      responseMessageBackgroundColor: Color.lerp(
          a.responseMessageBackgroundColor,
          b.responseMessageBackgroundColor,
          t),
      editorTextStyle: TextStyle.lerp(a.editorTextStyle, b.editorTextStyle, t),
      requestContentTextStyle: TextStyle.lerp(
          a.requestContentTextStyle, b.requestContentTextStyle, t),
      responseContentTextStyle: TextStyle.lerp(
          a.responseContentTextStyle, b.responseContentTextStyle, t),
      requestPrimaryHeaderTextStyle: TextStyle.lerp(
          a.requestPrimaryHeaderTextStyle, b.requestPrimaryHeaderTextStyle, t),
      responsePrimaryHeaderTextStyle: TextStyle.lerp(
          a.responsePrimaryHeaderTextStyle,
          b.responsePrimaryHeaderTextStyle,
          t),
      requestSecondaryHeaderTextStyle: TextStyle.lerp(
          a.requestSecondaryHeaderTextStyle,
          b.requestSecondaryHeaderTextStyle,
          t),
      responseSecondaryHeaderTextStyle: TextStyle.lerp(
          a.responseSecondaryHeaderTextStyle,
          b.responseSecondaryHeaderTextStyle,
          t),
      suggestionItemTextStyle: WidgetStateProperty.lerp<TextStyle?>(
        a.suggestionItemTextStyle,
        b.suggestionItemTextStyle,
        t,
        TextStyle.lerp,
      ),
      requestMessageShape:
          ShapeBorder.lerp(a.requestMessageShape, b.requestMessageShape, t),
      responseMessageShape:
          ShapeBorder.lerp(a.responseMessageShape, b.responseMessageShape, t),
      suggestionBackgroundColor: Color.lerp(
          a.suggestionBackgroundColor, b.suggestionBackgroundColor, t),
      suggestionBackgroundShape: ShapeBorder.lerp(
          a.suggestionBackgroundShape, b.suggestionBackgroundShape, t),
      suggestionItemBackgroundColor: WidgetStateProperty.lerp<Color?>(
        a.suggestionItemBackgroundColor,
        b.suggestionItemBackgroundColor,
        t,
        Color.lerp,
      ),
      suggestionItemShape: WidgetStateProperty.lerp<ShapeBorder?>(
        a.suggestionItemShape,
        b.suggestionItemShape,
        t,
        ShapeBorder.lerp,
      ),
      responseToolbarBackgroundColor: Color.lerp(
          a.responseToolbarBackgroundColor,
          b.responseToolbarBackgroundColor,
          t),
      responseToolbarBackgroundShape: ShapeBorder.lerp(
          a.responseToolbarBackgroundShape,
          b.responseToolbarBackgroundShape,
          t),
      responseToolbarItemBackgroundColor: WidgetStateProperty.lerp<Color?>(
        a.responseToolbarItemBackgroundColor,
        b.responseToolbarItemBackgroundColor,
        t,
        Color.lerp,
      ),
      responseToolbarItemShape: WidgetStateProperty.lerp<ShapeBorder?>(
        a.responseToolbarItemShape,
        b.responseToolbarItemShape,
        t,
        ShapeBorder.lerp,
      ),
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

    return other is SfAIAssistViewThemeData &&
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
        other.requestAvatarBackgroundColor == requestAvatarBackgroundColor &&
        other.responseAvatarBackgroundColor == responseAvatarBackgroundColor &&
        other.requestMessageBackgroundColor == requestMessageBackgroundColor &&
        other.responseMessageBackgroundColor ==
            responseMessageBackgroundColor &&
        other.editorTextStyle == editorTextStyle &&
        other.requestContentTextStyle == requestContentTextStyle &&
        other.responseContentTextStyle == responseContentTextStyle &&
        other.requestPrimaryHeaderTextStyle == requestPrimaryHeaderTextStyle &&
        other.responsePrimaryHeaderTextStyle ==
            responsePrimaryHeaderTextStyle &&
        other.requestSecondaryHeaderTextStyle ==
            requestSecondaryHeaderTextStyle &&
        other.responseSecondaryHeaderTextStyle ==
            responseSecondaryHeaderTextStyle &&
        other.suggestionItemTextStyle == suggestionItemTextStyle &&
        other.requestMessageShape == requestMessageShape &&
        other.responseMessageShape == responseMessageShape &&
        other.suggestionBackgroundColor == suggestionBackgroundColor &&
        other.suggestionBackgroundShape == suggestionBackgroundShape &&
        other.suggestionItemBackgroundColor == suggestionItemBackgroundColor &&
        other.suggestionItemShape == suggestionItemShape &&
        other.responseToolbarBackgroundColor ==
            responseToolbarBackgroundColor &&
        other.responseToolbarBackgroundShape ==
            responseToolbarBackgroundShape &&
        other.responseToolbarItemBackgroundColor ==
            responseToolbarItemBackgroundColor &&
        other.responseToolbarItemShape == responseToolbarItemShape;
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
      requestAvatarBackgroundColor,
      responseAvatarBackgroundColor,
      requestMessageBackgroundColor,
      responseMessageBackgroundColor,
      editorTextStyle,
      requestContentTextStyle,
      responseContentTextStyle,
      requestPrimaryHeaderTextStyle,
      responsePrimaryHeaderTextStyle,
      requestSecondaryHeaderTextStyle,
      responseSecondaryHeaderTextStyle,
      suggestionItemTextStyle,
      requestMessageShape,
      responseMessageShape,
      suggestionBackgroundColor,
      suggestionBackgroundShape,
      suggestionItemBackgroundColor,
      suggestionItemShape,
      responseToolbarBackgroundColor,
      responseToolbarBackgroundShape,
      responseToolbarItemBackgroundColor,
      responseToolbarItemShape,
    ];
    return Object.hashAll(values);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    const SfAIAssistViewThemeData defaultData = SfAIAssistViewThemeData();
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
        'requestAvatarBackgroundColor',
        requestAvatarBackgroundColor,
        defaultValue: defaultData.requestAvatarBackgroundColor,
      ),
    );
    properties.add(
      ColorProperty(
        'responseAvatarBackgroundColor',
        responseAvatarBackgroundColor,
        defaultValue: defaultData.responseAvatarBackgroundColor,
      ),
    );
    properties.add(
      ColorProperty(
        'requestMessageBackgroundColor',
        requestMessageBackgroundColor,
        defaultValue: defaultData.requestMessageBackgroundColor,
      ),
    );
    properties.add(
      ColorProperty(
        'responseMessageBackgroundColor',
        responseMessageBackgroundColor,
        defaultValue: defaultData.responseMessageBackgroundColor,
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
        'requestContentTextStyle',
        requestContentTextStyle,
        defaultValue: defaultData.requestContentTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'responseContentTextStyle',
        responseContentTextStyle,
        defaultValue: defaultData.responseContentTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'requestPrimaryHeaderTextStyle',
        requestPrimaryHeaderTextStyle,
        defaultValue: defaultData.requestPrimaryHeaderTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'responsePrimaryHeaderTextStyle',
        responsePrimaryHeaderTextStyle,
        defaultValue: defaultData.responsePrimaryHeaderTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'requestSecondaryHeaderTextStyle',
        requestSecondaryHeaderTextStyle,
        defaultValue: defaultData.requestSecondaryHeaderTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'responseSecondaryHeaderTextStyle',
        responseSecondaryHeaderTextStyle,
        defaultValue: defaultData.responseSecondaryHeaderTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<TextStyle?>>(
        'suggestionItemTextStyle',
        suggestionItemTextStyle,
        defaultValue: defaultData.suggestionItemTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<ShapeBorder>(
        'requestMessageShape',
        requestMessageShape,
        defaultValue: defaultData.requestMessageShape,
      ),
    );
    properties.add(
      DiagnosticsProperty<ShapeBorder>(
        'responseMessageShape',
        responseMessageShape,
        defaultValue: defaultData.responseMessageShape,
      ),
    );
    properties.add(
      DiagnosticsProperty<Color>(
        'suggestionBackgroundColor',
        suggestionBackgroundColor,
        defaultValue: defaultData.suggestionBackgroundColor,
      ),
    );
    properties.add(
      DiagnosticsProperty<ShapeBorder>(
        'suggestionBackgroundShape',
        suggestionBackgroundShape,
        defaultValue: defaultData.suggestionBackgroundShape,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<Color?>>(
        'suggestionItemBackgroundColor',
        suggestionItemBackgroundColor,
        defaultValue: defaultData.suggestionItemBackgroundColor,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<ShapeBorder?>>(
        'suggestionItemShape',
        suggestionItemShape,
        defaultValue: defaultData.suggestionItemShape,
      ),
    );
    properties.add(
      DiagnosticsProperty<Color>(
        'responseToolbarBackgroundColor',
        responseToolbarBackgroundColor,
        defaultValue: defaultData.responseToolbarBackgroundColor,
      ),
    );
    properties.add(
      DiagnosticsProperty<ShapeBorder>(
        'responseToolbarBackgroundShape',
        responseToolbarBackgroundShape,
        defaultValue: defaultData.responseToolbarBackgroundShape,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<Color?>>(
        'responseToolbarItemBackgroundColor',
        responseToolbarItemBackgroundColor,
        defaultValue: defaultData.responseToolbarItemBackgroundColor,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<ShapeBorder?>>(
        'responseToolbarItemShape',
        responseToolbarItemShape,
        defaultValue: defaultData.responseToolbarItemShape,
      ),
    );
  }
}
