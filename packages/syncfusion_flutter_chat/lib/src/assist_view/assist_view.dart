import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../assist_view/theme.dart';
import '../base_layout.dart';
import '../composer_area.dart';
import '../settings.dart';
import 'conversion_area.dart';
import 'settings.dart';

/// The [SfAIAssistView] widget is designed to build a chat interface
/// for chatbots powered by AI.
///
/// It provides extensive customization options, allowing developers to modify
/// the appearance and behavior of chat bubbles, input composer,
/// action buttons, and more.
///
/// The [SfAIAssistView] includes the following elements and features:
///
/// * **Messages**: A list of [AssistMessage] objects that will be displayed
/// in the chat interface as either a request message from the user or a
/// response message from AI. Each [AssistMessage] includes details such as the
/// message text, timestamp, and author information.
/// * **Composer**: This is the primary text editor where the user can
/// compose new request messages.
/// * **Action Button**: This represents the send button. Pressing this
/// action button invokes the [AssistActionButton.onPressed] callback
/// with the text entered in the default [AssistComposer].
/// * **Suggestions**: The response set for a message can be included with the
/// response itself, and choosing this suggestion can be treated as a
/// new request message.
/// * **Footer items**: This is a collection action bar items for a response
/// message. Particularly useful for adding a action items such as like,
/// dislike, copy, retry and etc.
/// * **Placeholder Builder**: The [SfAIAssistView.placeholderBuilder] allows
/// you to specify a custom widget to display when there are no messages in
/// the chat. This is particularly useful for presenting users with a relevant
/// or visually appealing message indicating that the conversation is
/// currently empty.
/// * **Bubble Header Builder**: The [SfAIAssistView.messageHeaderBuilder] allows
/// you to specify a custom widget to display as a header for each chat bubble.
/// This is particularly useful for displaying additional information such as
/// the sender's name and the timestamp associated with each message.
/// * **Bubble Avatar Builder**: The [SfAIAssistView.messageAvatarBuilder] allows
/// you to specify a custom widget to display as an avatar within each
/// chat bubble. This feature is especially useful for showing user avatars or
/// profile pictures within the chat interface.
/// * **Bubble Content Builder**: The [SfAIAssistView.messageContentBuilder]
/// allows you to specify a custom widget to display as the content within each
/// chat bubble. This is useful for customizing how the message content is
/// presented, such as using different background colors, borders, or padding.
/// * **Bubble Footer Builder**: The [SfAIAssistView.messageFooterBuilder] allows
/// you to specify a custom widget that will be displayed as a footer within
/// each chat bubble. This is particularly useful for displaying timestamps or
/// other additional information related to the message.
///
/// The following example demonstrates how to create a simple chat interface
/// using the [SfAIAssistView] widget.
///
/// ```dart
/// List<AssistMessage> _messages = <AssistMessage>[];
///
/// void _generateAIResponse(String request) {
///   // Connect to your preferred AI and get response for the request.
///   String response = 'AI response'; // Replace with actual AI response.
///   setState(() {
///     _messages.add(AssistMessage.response(data: response));
///   });
/// }
///
/// SfAIAssistView view = SfAIAssistView(
///   messages: _messages,
///   actionButton: AssistActionButton(
///     onPressed: (String data) {
///       _messages.add(AssistMessage.request(data: data));
///       _generateAIResponse(data);
///     },
///   ),
/// );
/// ```
class SfAIAssistView extends StatefulWidget {
  const SfAIAssistView({
    super.key,
    required this.messages,
    this.composer = const AssistComposer(),
    this.actionButton,
    this.placeholderBuilder,
    this.messageHeaderBuilder,
    this.messageAvatarBuilder,
    this.messageContentBuilder,
    this.messageFooterBuilder,
    this.responseLoadingBuilder,
    this.placeholderBehavior = AssistPlaceholderBehavior.scrollWithMessage,
    this.messageAlignment = AssistMessageAlignment.auto,
    this.onSuggestionItemSelected,
    this.onToolbarItemSelected,
    this.requestMessageSettings = const AssistMessageSettings(),
    this.responseMessageSettings = const AssistMessageSettings(),
    this.responseToolbarSettings = const AssistMessageToolbarSettings(),
  });

  /// A list of [AssistMessage] objects that will be displayed in the chat
  /// interface.
  ///
  /// Each message includes details such as the message text, timestamp,
  /// and author information.
  ///
  /// [AssistMessage.request] message will be treated as a user request.
  /// [AssistMessage.response] message will be treated as a AI response.
  ///
  /// ```dart
  /// List<AssistMessage> _messages = <AssistMessage>[];
  ///
  /// void _generateAIResponse(String request) {
  ///   // Connect to your preferred AI and get response for the request.
  ///   String response = 'AI response'; // Replace with actual AI response.
  ///   setState(() {
  ///     _messages.add(AssistMessage.response(data: response));
  ///   });
  /// }
  ///
  /// SfAIAssistView view = SfAIAssistView(
  ///   messages: _messages,
  ///   actionButton: AssistActionButton(
  ///     onPressed: (String data) {
  ///       _messages.add(AssistMessage.request(data: data));
  ///       _generateAIResponse(data);
  ///     },
  ///   ),
  /// );
  /// ```
  final List<AssistMessage> messages;

  /// A primary text editor for composing the request messages.
  ///
  /// The [composer] is a customizable text editor designed for typing
  /// new messages. It offers options to adjust the appearance and behavior
  /// of the text editor, including settings for the minimum and maximum
  /// number of lines, decoration, and text style.
  ///
  /// By default, the text editor does not include hint text.
  /// Hint text can be added using the [InputDecoration.hintText] property
  /// within [InputDecoration].
  ///
  /// If the [composer] is disabled by setting [InputDecoration.enabled] to
  /// `false`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     composer: AssistComposer(
  ///       minLines: 1,
  ///       maxLines: 3,
  ///       decoration: InputDecoration(
  ///         hintText: 'Type a message...',
  ///       ),
  ///     ),
  ///   );
  /// }
  /// ```
  ///
  /// ## Builder
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     composer: AssistComposer.builder(
  ///       builder: (BuildContext context) {
  ///         return TextFormField(
  ///           decoration: InputDecoration(
  ///             hintText: 'Type a message...',
  ///             prefixIcon: IconButton(
  ///               icon: Icon(Icons.attach_file),
  ///               onPressed: () {
  ///                 // Handle attachment button click.
  ///               },
  ///             ),
  ///             suffixIcon: IconButton(
  ///               icon: Icon(Icons.mic),
  ///               onPressed: () {
  ///                 // Handle mic button click.
  ///               },
  ///             ),
  ///           ),
  ///         );
  ///       },
  ///     ),
  ///   );
  /// }
  /// ```
  final AssistComposer? composer;

  /// Represents a send button.
  ///
  /// The [SfAIAssistView] widget does not include an action button by default.
  /// To add, create a new instance of [AssistActionButton].
  ///
  /// If the [AssistActionButton.onPressed] callback is null, the button
  /// remains disabled.
  ///
  /// If the default [composer]'s text is empty or if the [composer] is
  /// disabled, the button remains disabled.
  ///
  /// If the [composer] is null, the button always stays enabled.
  ///
  /// If last message is [AssistMessage.request], the button will be disabled
  /// until the next [AssistMessage.response] is added.
  ///
  /// Pressing the action button invokes the [AssistActionButton.onPressed]
  /// callback with the text entered in the default [composer]. By default,
  /// [SfAIAssistView] will not update its state until the parent widget
  /// rebuilds the chat with new messages.
  ///
  /// If [AssistComposer.builder] is used, the button always stays enabled.
  ///
  /// ```dart
  /// List<AssistMessage> _messages = <AssistMessage>[
  ///   AssistMessage.response(
  ///     data: 'Hello, how can I help you today?',
  ///   ),
  /// ];
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssist(
  ///     messages: _messages,
  ///     outgoingUser: '8ob3-b720-g9s6-25s8',
  ///     actionButton: AssistActionButton(
  ///       onPressed: (String newMessage) {
  ///         setState(() {
  ///           _messages.add(
  ///             AssistMessage.request(
  ///               data: newMessage,
  ///             ),
  ///           );
  ///         });
  ///       },
  ///     ),
  ///   );
  /// }
  /// ```
  ///
  /// See also:
  /// * [AssistComposer] to customize the default text editor.
  /// * [AssistComposer.builder] to create a custom text editor.
  /// * [AssistActionButton.onPressed] to handle the action button click.
  /// * [AssistActionButton.child] to add new action buttons.
  final AssistActionButton? actionButton;

  /// A callback function creates a widget to display initially or
  /// top of all messages.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     placeholderBuilder:
  ///       (BuildContext context) {
  ///         return Center(child: Text('No messages yet'));
  ///       },
  ///   );
  /// }
  /// ```
  ///
  /// See also:
  /// * [placeholderBehavior], to control the visibility of the placeholder.
  final WidgetBuilder? placeholderBuilder;

  /// A callback function creates a widget to serve as a header for each
  /// message bubble.
  ///
  /// The [messageHeaderBuilder] allows you to specify a custom widget that will
  /// be shown as a header within each chat bubble. This is particularly useful
  /// for displaying additional information such as the sender's name and
  /// timestamp associated with each message.
  ///
  /// The callback accepts three parameters: [BuildContext], message index in
  /// the list, and [AssistMessage] and returns a [Widget].
  ///
  /// If a new instance is not assigned to this property, it will use the
  /// default header widget.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     messageHeaderBuilder:
  ///         (BuildContext context, int index, AssistMessage message) {
  ///       return Padding(
  ///         padding: const EdgeInsets.all(8.0),
  ///         child: Text(
  ///           message.author.name,
  ///           style: const TextStyle(fontWeight: FontWeight.bold),
  ///         ),
  ///       );
  ///     },
  ///   );
  /// }
  /// ```
  final AssistWidgetBuilder? messageHeaderBuilder;

  /// A callback function creates a widget to display as an avatar within each
  /// message bubble.
  ///
  /// The [messageAvatarBuilder] allows you to specify a custom widget that will
  /// be shown as an avatar within each message bubble. This is particularly
  /// useful for displaying user avatars or profile pictures in the chat
  /// interface.
  ///
  /// The callback accepts three parameters: [BuildContext], message index in
  /// the list, and [AssistMessage] and returns a [Widget].
  ///
  /// If a new instance is not assigned to this property, it will use the
  /// default avatar widget.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     messageAvatarBuilder:
  ///         (BuildContext context, int index, AssistMessage message) {
  ///       return CircleAvatar(
  ///         backgroundImage: NetworkImage(
  ///           message.author.id == '123-001'
  ///               ? 'https://example.com/user-avatar.jpg'
  ///               : 'https://example.com/ai-avatar.jpg',
  ///         ),
  ///       );
  ///     },
  ///   );
  /// }
  /// ```
  final AssistWidgetBuilder? messageAvatarBuilder;

  /// A callback function creates a widget to display as the content of each
  /// message bubble.
  ///
  /// The [messageContentBuilder] allows you to specify a custom widget to
  /// display as the content within each message bubble. This is useful for
  /// customizing how the message content is presented, such as using different
  /// background colors, borders, or padding.
  ///
  /// The callback accepts three parameters: [BuildContext], message index in
  /// the list, and [AssistMessage] and returns a [Widget].
  ///
  /// If a new instance is not assigned to this property, it will use the
  /// default content widget.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     messageContentBuilder:
  ///         (BuildContext context, int index, AssistMessage message) {
  ///       return Padding(
  ///         padding: const EdgeInsets.all(8.0),
  ///         child: Text(message.text),
  ///       );
  ///     },
  ///   );
  /// }
  /// ```
  final AssistWidgetBuilder? messageContentBuilder;

  /// A callback function creates a widget to display as a footer within each
  /// message bubble.
  ///
  /// The [messageFooterBuilder] allows you to specify a custom widget that will
  /// be shown as a footer within each message bubble. This is particularly useful
  /// for displaying timestamps or other additional information related to the
  /// message.
  ///
  /// The callback accepts three parameters: [BuildContext], message index in
  /// the list, and [AssistMessage] and returns a [Widget].
  ///
  /// If a new instance is not assigned to this property, it will use the
  /// default footer widget.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     messageFooterBuilder:
  ///         (BuildContext context, int index, AssistMessage message) {
  ///       return Row(
  ///         children: [
  ///           IconButton(
  ///             icon: const Icon(Icons.thumb_up),
  ///             onPressed: () {
  ///               // Handle thumb up button click.
  ///             },
  ///           ),
  ///           IconButton(
  ///             icon: const Icon(Icons.thumb_down),
  ///             onPressed: () {
  ///               // Handle thumb down button click.
  ///             },
  ///           ),
  ///         ],
  ///       );
  ///     },
  ///   );
  /// }
  /// ```
  final AssistWidgetBuilder? messageFooterBuilder;

  /// A callback function creates a widget to display as a loading indicator
  /// while waiting for a response.
  ///
  /// This is particularly useful for displaying a loading spinner or other
  /// visual indicator to let the user know that the AI is processing the
  /// request.
  ///
  /// By default shimmer effect will be shown as a loading indicator.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     responseLoadingBuilder:(BuildContext context, int index, AssistMessage message) {
  ///       return const Center(
  ///         child: CustomLoadingIndicatorWidget(),
  ///       );
  ///     },
  ///   );
  /// }
  /// ```
  final AssistWidgetBuilder? responseLoadingBuilder;

  /// Manages the visibility of the placeholder widget.
  ///
  /// Allowing it to either hide when a message is added or or stay visible,
  /// positioned above all messages.
  ///
  /// Defaults to [AssistPlaceholderBehavior.scrollWithMessage].
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     placeholderBehavior: AssistPlaceholderBehavior.hide,
  ///     placeholderBuilder: (BuildContext context) {
  ///       return Text('No messages yet');
  ///     },
  ///   );
  /// }
  /// ```
  final AssistPlaceholderBehavior placeholderBehavior;

  /// Determines the alignment of the message bubbles.
  ///
  /// Defaults to [AssistMessageAlignment.auto].
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     messageAlignment: AssistMessageAlignment.start,
  ///   );
  /// }
  /// ```
  final AssistMessageAlignment messageAlignment;

  /// Called when the suggestion is selected.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     onSuggestionItemSelected: (bool selected, int messageIndex,
  ///         AssistMessageSuggestion suggestion, int suggestionIndex) {
  ///       _handleSuggestionItemSelected();
  ///     },
  ///  );
  /// }
  /// ```
  final AssistSuggestionItemSelectedCallback? onSuggestionItemSelected;

  /// Called when the response bubble toolbar is selected.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     onBubbleToolbarItemSelected: (bool selected, int messageIndex,
  ///            AssistMessageToolbarItem item, int toolbarItemIndex) {
  ///          _handleToolbarItemSelected();
  ///        },
  ///   );
  /// }
  /// ```
  final AssistToolbarItemSelectedCallback? onToolbarItemSelected;

  /// Options for changing the appearance and behavior of
  /// request message bubble.
  ///
  /// The [requestMessageSettings] property allows you to configure how
  /// request chat bubbles are displayed. This includes customization options
  /// for the user's avatar, username, timestamp, content background color, and
  /// various padding and shape options.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     requestMessageSettings: const AssistMessageSettings(
  ///       showAuthorName: true,
  ///       showTimestamp: true,
  ///       showAuthorAvatar: true,
  ///       widthFactor: 0.8,
  ///       avatarSize: Size.square(32.0),
  ///       headerPadding: EdgeInsetsDirectional.only(bottom: 3.0),
  ///       footerPadding: EdgeInsetsDirectional.only(top: 4.0),
  ///     ),
  ///   );
  /// }
  /// ```
  final AssistMessageSettings requestMessageSettings;

  /// Options for changing the appearance and behavior of
  /// response message bubble.
  ///
  /// The [responseMessageSettings] property allows you to configure how
  /// response chat bubbles are displayed. This includes customization options
  /// for the user's avatar, username, timestamp, content background color, and
  /// various padding and shape options.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     responseMessageSettings: const AssistMessageSettings(
  ///       showAuthorName: true,
  ///       showTimestamp: true,
  ///       showAuthorAvatar: true,
  ///       widthFactor: 0.8,
  ///       avatarSize: Size.square(32.0),
  ///       headerPadding: EdgeInsetsDirectional.only(bottom: 3.0),
  ///       footerPadding: EdgeInsetsDirectional.only(top: 4.0),
  ///     ),
  ///   );
  /// }
  /// ```
  final AssistMessageSettings responseMessageSettings;

  /// Options for changing the appearance of the response message toolbar.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     responseToolbarSettings: AssistMessageToolbarSettings(
  ///       shape: RoundedRectangleBorder(
  ///         borderRadius: BorderRadius.circular(20.0),
  ///       ),
  ///       backgroundColor: Colors.red,
  ///       itemShape: WidgetStateProperty.resolveWith(
  ///         (Set<WidgetState> state) {
  ///           return const RoundedRectangleBorder(
  ///               borderRadius: BorderRadius.all(Radius.circular(8.0)));
  ///         },
  ///       ),
  ///       itemBackgroundColor: WidgetStateProperty.resolveWith(
  ///         (Set<WidgetState> state) {
  ///           if (state.contains(WidgetState.selected)) {
  ///             return Colors.blue;
  ///           } else if (state.contains(WidgetState.focused)) {
  ///             return Colors.blueGrey;
  ///           } else if (state.contains(WidgetState.hovered)) {
  ///             return Colors.lightBlueAccent;
  ///           } else if (state.contains(WidgetState.disabled)) {
  ///             return Colors.grey;
  ///           }
  ///           return Colors.lightBlue;
  ///         },
  ///       ),
  ///       margin: const EdgeInsets.all(10),
  ///       itemPadding: const EdgeInsets.all(10),
  ///       spacing: 10,
  ///       runSpacing: 10,
  ///     ),
  ///   );
  /// }
  /// ```
  final AssistMessageToolbarSettings responseToolbarSettings;

  @override
  State<SfAIAssistView> createState() => _SfAIAssistViewState();
}

class _SfAIAssistViewState extends State<SfAIAssistView> {
  final AssistMessageSettings _requestMessageSettings =
      const AssistMessageSettings(
    avatarPadding: EdgeInsetsDirectional.only(start: 16.0),
    padding: EdgeInsets.all(8.0),
    margin: EdgeInsetsDirectional.only(top: 24.0),
    showAuthorAvatar: true,
  );
  final AssistMessageSettings _responseMessageSettings =
      const AssistMessageSettings(
    avatarPadding: EdgeInsetsDirectional.only(end: 16.0),
    padding: EdgeInsetsDirectional.symmetric(vertical: 8.0),
    margin: EdgeInsetsDirectional.only(top: 24.0),
    showAuthorAvatar: true,
  );
  final InputBorder _defaultInputDecorBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(42.0)),
  );
  final EdgeInsetsGeometry _defaultInputDecorContentPadding =
      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0);

  late FocusNode _focusNode;
  late TextEditingController _textController;

  late ThemeData _themeData;
  late SfAIAssistViewThemeData _defaultThemeData;
  late SfAIAssistViewThemeData _userDefinedThemeData;
  late SfAIAssistViewThemeData _effectiveAssistThemeData;

  void _updateThemeData(BuildContext context) {
    _themeData = Theme.of(context);
    _defaultThemeData = _themeData.useMaterial3
        ? AIAssistViewM3ThemeData(context)
        : AIAssistViewM2ThemeData(context);
    _userDefinedThemeData = SfAIAssistViewTheme.of(context);
    final TextStyle contentBaseTextStyle = _themeData.textTheme.bodyMedium!
        .copyWith(color: _themeData.colorScheme.onSurface);
    final TextStyle primaryHeaderBaseTextStyle = _themeData
        .textTheme.labelMedium!
        .copyWith(color: _themeData.colorScheme.primary);
    final TextStyle secondaryHeaderBaseTextStyle = _themeData
        .textTheme.labelSmall!
        .copyWith(color: _themeData.colorScheme.onSurfaceVariant);

    _effectiveAssistThemeData = _userDefinedThemeData.copyWith(
      actionButtonForegroundColor: widget.actionButton?.foregroundColor ??
          _userDefinedThemeData.actionButtonForegroundColor ??
          _defaultThemeData.actionButtonForegroundColor,
      actionButtonBackgroundColor: widget.actionButton?.backgroundColor ??
          _userDefinedThemeData.actionButtonBackgroundColor ??
          _defaultThemeData.actionButtonBackgroundColor,
      actionButtonDisabledForegroundColor:
          _userDefinedThemeData.actionButtonDisabledForegroundColor ??
              _defaultThemeData.actionButtonDisabledForegroundColor,
      actionButtonDisabledBackgroundColor:
          _userDefinedThemeData.actionButtonDisabledBackgroundColor ??
              _defaultThemeData.actionButtonDisabledBackgroundColor,
      actionButtonFocusColor: widget.actionButton?.focusColor ??
          _userDefinedThemeData.actionButtonFocusColor ??
          _defaultThemeData.actionButtonFocusColor,
      actionButtonHoverColor: widget.actionButton?.hoverColor ??
          _userDefinedThemeData.actionButtonHoverColor ??
          _defaultThemeData.actionButtonHoverColor,
      actionButtonSplashColor: widget.actionButton?.splashColor ??
          _userDefinedThemeData.actionButtonSplashColor ??
          _defaultThemeData.actionButtonSplashColor,
      actionButtonElevation: widget.actionButton?.elevation ??
          _userDefinedThemeData.actionButtonElevation,
      actionButtonFocusElevation: widget.actionButton?.focusElevation ??
          _userDefinedThemeData.actionButtonFocusElevation,
      actionButtonHoverElevation: widget.actionButton?.hoverElevation ??
          _userDefinedThemeData.actionButtonHoverElevation,
      actionButtonHighlightElevation: widget.actionButton?.highlightElevation ??
          _userDefinedThemeData.actionButtonHighlightElevation,
      actionButtonMouseCursor: widget.actionButton?.mouseCursor ??
          _userDefinedThemeData.actionButtonMouseCursor ??
          _defaultThemeData.actionButtonMouseCursor,
      actionButtonShape: widget.actionButton?.shape ??
          _userDefinedThemeData.actionButtonShape ??
          _defaultThemeData.actionButtonShape,
      requestAvatarBackgroundColor:
          _userDefinedThemeData.requestAvatarBackgroundColor ??
              _defaultThemeData.requestAvatarBackgroundColor,
      responseAvatarBackgroundColor:
          _userDefinedThemeData.responseAvatarBackgroundColor ??
              _defaultThemeData.responseAvatarBackgroundColor,
      requestMessageBackgroundColor:
          widget.requestMessageSettings.backgroundColor ??
              _userDefinedThemeData.requestMessageBackgroundColor ??
              _defaultThemeData.requestMessageBackgroundColor,
      responseMessageBackgroundColor:
          widget.responseMessageSettings.backgroundColor ??
              _userDefinedThemeData.responseMessageBackgroundColor ??
              _defaultThemeData.responseMessageBackgroundColor,
      editorTextStyle: contentBaseTextStyle
          .merge(_userDefinedThemeData.editorTextStyle)
          .merge(widget.composer?.textStyle),
      requestContentTextStyle: contentBaseTextStyle
          .merge(_userDefinedThemeData.requestContentTextStyle)
          .merge(widget.requestMessageSettings.textStyle),
      responseContentTextStyle: contentBaseTextStyle
          .merge(_userDefinedThemeData.responseContentTextStyle)
          .merge(widget.responseMessageSettings.textStyle),
      requestPrimaryHeaderTextStyle: primaryHeaderBaseTextStyle
          .merge(_userDefinedThemeData.requestPrimaryHeaderTextStyle)
          .merge(widget.requestMessageSettings.headerTextStyle),
      responsePrimaryHeaderTextStyle: primaryHeaderBaseTextStyle
          .merge(_userDefinedThemeData.responsePrimaryHeaderTextStyle)
          .merge(widget.responseMessageSettings.headerTextStyle),
      requestSecondaryHeaderTextStyle: secondaryHeaderBaseTextStyle
          .merge(_userDefinedThemeData.requestSecondaryHeaderTextStyle)
          .merge(widget.requestMessageSettings.headerTextStyle),
      responseSecondaryHeaderTextStyle: secondaryHeaderBaseTextStyle
          .merge(_userDefinedThemeData.responseSecondaryHeaderTextStyle)
          .merge(widget.responseMessageSettings.headerTextStyle),
      requestMessageShape: widget.requestMessageSettings.shape ??
          _userDefinedThemeData.requestMessageShape ??
          _defaultThemeData.requestMessageShape,
      responseMessageShape: widget.responseMessageSettings.shape ??
          _userDefinedThemeData.responseMessageShape ??
          _defaultThemeData.responseMessageShape,
      suggestionItemBackgroundColor:
          _userDefinedThemeData.suggestionItemBackgroundColor ??
              _defaultThemeData.suggestionItemBackgroundColor,
      suggestionItemShape: _userDefinedThemeData.suggestionItemShape ??
          _defaultThemeData.suggestionItemShape,
      responseToolbarItemBackgroundColor:
          _userDefinedThemeData.responseToolbarItemBackgroundColor ??
              _defaultThemeData.responseToolbarItemBackgroundColor,
      responseToolbarItemShape:
          _userDefinedThemeData.responseToolbarItemShape ??
              _defaultThemeData.responseToolbarItemShape,
    );
  }

  TextStyle _suggestionTextStyle(Set<WidgetState> states) {
    TextStyle? userTextStyle;
    final TextStyle baseTextStyle = _themeData.textTheme.bodyMedium!
        .copyWith(color: _themeData.colorScheme.onSurface);
    final TextStyle defaultTextStyle =
        _defaultThemeData.suggestionItemTextStyle!.resolve(states)!;
    if (_userDefinedThemeData.suggestionItemTextStyle != null) {
      userTextStyle =
          _userDefinedThemeData.suggestionItemTextStyle?.resolve(states);
    }

    return baseTextStyle.merge(userTextStyle).merge(defaultTextStyle);
  }

  Widget? _buildEditor(BuildContext context) {
    if (widget.composer == null) {
      return null;
    } else {
      return TextEditor(
        composer: widget.composer!,
        decoration: _effectiveInputDecoration(),
        actionButton: widget.actionButton,
        focusNode: _focusNode,
        textController: _textController,
        textStyle: _effectiveAssistThemeData.editorTextStyle,
      );
    }
  }

  InputDecoration? _effectiveInputDecoration() {
    if (widget.composer == null) {
      return null;
    } else {
      if (widget.composer!.builder != null) {
        return null;
      }

      final InputDecoration? decoration = widget.composer!.decoration;
      if (decoration != null) {
        final InputBorder effectiveBorder =
            decoration.border ?? _defaultInputDecorBorder;
        final EdgeInsetsGeometry effectiveContentPadding =
            decoration.contentPadding ?? _defaultInputDecorContentPadding;
        return decoration.copyWith(
          border: effectiveBorder,
          contentPadding: effectiveContentPadding,
        );
      }
    }
    return null;
  }

  Widget? _buildActionButton(BuildContext context) {
    if (widget.actionButton == null) {
      return null;
    } else {
      return ActionButtonWidget(
        enabled: _isActionButtonEnabled(),
        settings: widget.actionButton!,
        composer: widget.composer,
        textController: _textController,
        actionButtonForegroundColor:
            _effectiveAssistThemeData.actionButtonForegroundColor,
        actionButtonDisabledForegroundColor:
            _effectiveAssistThemeData.actionButtonDisabledForegroundColor,
        actionButtonBackgroundColor:
            _effectiveAssistThemeData.actionButtonBackgroundColor,
        actionButtonDisabledBackgroundColor:
            _effectiveAssistThemeData.actionButtonDisabledBackgroundColor,
        actionButtonFocusColor:
            _effectiveAssistThemeData.actionButtonFocusColor,
        actionButtonHoverColor:
            _effectiveAssistThemeData.actionButtonHoverColor,
        actionButtonSplashColor:
            _effectiveAssistThemeData.actionButtonSplashColor,
        actionButtonElevation: _effectiveAssistThemeData.actionButtonElevation,
        actionButtonFocusElevation:
            _effectiveAssistThemeData.actionButtonFocusElevation,
        actionButtonHoverElevation:
            _effectiveAssistThemeData.actionButtonHoverElevation,
        actionButtonHighlightElevation:
            _effectiveAssistThemeData.actionButtonHighlightElevation,
        actionButtonDisabledElevation:
            _effectiveAssistThemeData.actionButtonDisabledElevation,
        actionButtonShape: _effectiveAssistThemeData.actionButtonShape,
      );
    }
  }

  bool _isActionButtonEnabled() {
    if (widget.messages.isEmpty) {
      return true;
    } else {
      return !widget.messages.last.isRequested;
    }
  }

  BubbleAlignment _toBubbleAlignment(AssistMessageAlignment value) {
    switch (value) {
      case AssistMessageAlignment.start:
        return BubbleAlignment.start;
      case AssistMessageAlignment.end:
        return BubbleAlignment.end;
      case AssistMessageAlignment.auto:
        return BubbleAlignment.auto;
    }
  }

  PlaceholderBehavior _toPlaceholderBehavior(AssistPlaceholderBehavior value) {
    switch (value) {
      case AssistPlaceholderBehavior.hideOnMessage:
        return PlaceholderBehavior.hideOnMessage;
      case AssistPlaceholderBehavior.scrollWithMessage:
        return PlaceholderBehavior.scrollWithMessage;
    }
  }

  @override
  void initState() {
    _textController = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _updateThemeData(context);
    final Widget? editor = _buildEditor(context);
    final Widget? actionButton = _buildActionButton(context);

    return LayoutHandler(
      children: <Widget>[
        AssistConversationArea(
          messages: widget.messages,
          outgoingBubbleSettings:
              _requestMessageSettings.mergeWith(widget.requestMessageSettings),
          incomingBubbleSettings: _responseMessageSettings
              .mergeWith(widget.responseMessageSettings),
          bubbleAlignment: _toBubbleAlignment(widget.messageAlignment),
          placeholderBehavior:
              _toPlaceholderBehavior(widget.placeholderBehavior),
          placeholderBuilder: widget.placeholderBuilder,
          bubbleHeaderBuilder: widget.messageHeaderBuilder,
          bubbleAvatarBuilder: widget.messageAvatarBuilder,
          bubbleContentBuilder: widget.messageContentBuilder,
          bubbleFooterBuilder: widget.messageFooterBuilder,
          responseLoadingBuilder: widget.responseLoadingBuilder,
          outgoingAvatarBackgroundColor:
              _effectiveAssistThemeData.requestAvatarBackgroundColor,
          incomingAvatarBackgroundColor:
              _effectiveAssistThemeData.responseAvatarBackgroundColor,
          outgoingBubbleContentBackgroundColor:
              _effectiveAssistThemeData.requestMessageBackgroundColor,
          incomingBubbleContentBackgroundColor:
              _effectiveAssistThemeData.responseMessageBackgroundColor,
          outgoingPrimaryHeaderTextStyle:
              _effectiveAssistThemeData.requestPrimaryHeaderTextStyle,
          incomingPrimaryHeaderTextStyle:
              _effectiveAssistThemeData.responsePrimaryHeaderTextStyle,
          outgoingSecondaryHeaderTextStyle:
              _effectiveAssistThemeData.requestSecondaryHeaderTextStyle,
          incomingSecondaryHeaderTextStyle:
              _effectiveAssistThemeData.responseSecondaryHeaderTextStyle,
          outgoingContentTextStyle:
              _effectiveAssistThemeData.requestContentTextStyle,
          incomingContentTextStyle:
              _effectiveAssistThemeData.responseContentTextStyle,
          suggestionItemTextStyle: _suggestionTextStyle,
          outgoingBubbleContentShape:
              _effectiveAssistThemeData.requestMessageShape,
          incomingBubbleContentShape:
              _effectiveAssistThemeData.responseMessageShape,
          suggestionBackgroundColor:
              _effectiveAssistThemeData.suggestionBackgroundColor,
          suggestionBackgroundShape:
              _effectiveAssistThemeData.suggestionBackgroundShape,
          suggestionItemBackgroundColor:
              _effectiveAssistThemeData.suggestionItemBackgroundColor,
          suggestionItemShape: _effectiveAssistThemeData.suggestionItemShape,
          responseToolbarBackgroundColor:
              _effectiveAssistThemeData.responseToolbarBackgroundColor,
          responseToolbarBackgroundShape:
              _effectiveAssistThemeData.responseToolbarBackgroundShape,
          responseToolbarItemBackgroundColor:
              _effectiveAssistThemeData.responseToolbarItemBackgroundColor,
          responseToolbarItemShape:
              _effectiveAssistThemeData.responseToolbarItemShape,
          onSuggestionItemSelected: widget.onSuggestionItemSelected,
          onBubbleToolbarItemSelected: widget.onToolbarItemSelected,
          responseToolbarSettings: widget.responseToolbarSettings,
          themeData: _themeData,
        ),
        if (editor != null || actionButton != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              if (editor != null) Expanded(child: editor),
              if (actionButton != null) actionButton,
            ],
          ),
      ],
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }
}
