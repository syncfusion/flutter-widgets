import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'composer.dart';
import 'conversion.dart';
import 'settings.dart';
import 'theme.dart';

/// The [SfChat] widget is a customizable chat interface designed for
/// one-on-one or group conversations.
///
/// It provides extensive customization options, allowing developers to modify
/// the appearance and behavior of chat bubbles, the input composer,
/// action buttons, and more.
///
/// The [SfChat] includes the following elements and features:
///
/// * **Outgoing User**: This refers to the unique ID of the user
/// sending the message. This ID distinguishes messages sent by the current user
/// from those sent by others, ensuring accurate presentation of the chat.
/// * **Messages**: A list of [ChatMessage] objects that will be displayed
/// in the chat interface as either incoming or outgoing messages based on
/// the [outgoingUser]. Each [ChatMessage] includes details such as the
/// message text, timestamp, and author information. Additionally,
/// there is an option to extend this class to include more information
/// about the chat message.
/// * **Composer**: This is the primary text editor where the user can
/// compose new chat messages.
/// * **Action Button**: This represents the send button, which becomes enabled
/// when the default text editor starts adding text. Pressing this action button
/// invokes the [ChatActionButton.onPressed] callback with the text entered
/// in the default [ChatComposer].
/// * **Placeholder Builder**: The [SfChat.placeholderBuilder] allows you to
/// specify a custom widget to display when there are no messages in the chat.
/// This is particularly useful for presenting users with a relevant or
/// visually appealing message indicating that the conversation is
/// currently empty.
/// * **Bubble Header Builder**: The [SfChat.bubbleHeaderBuilder] allows you to
/// specify a custom widget to display as a header for each chat bubble. This is
/// particularly useful for displaying additional information such as the
/// sender's name and the timestamp associated with each message.
/// * **Bubble Avatar Builder**: The [SfChat.bubbleAvatarBuilder] allows you to
/// specify a custom widget to display as an avatar within each chat bubble.
/// This feature is especially useful for showing user avatars or
/// profile pictures within the chat interface.
/// * **Bubble Content Builder**: The [SfChat.bubbleContentBuilder] allows you
/// to specify a custom widget to display as the content within each
/// chat bubble. This is useful for customizing how the message content is
/// presented, such as using different background colors, borders, or padding.
/// * **Bubble Footer Builder**: The [SfChat.bubbleFooterBuilder] allows you to
/// specify a custom widget that will be displayed as a footer within each
/// chat bubble. This is particularly useful for displaying timestamps or
/// other additional information related to the message.
///
/// {@tool snippet}
/// The following example demonstrates how to create a simple chat interface
/// using the [SfChat] widget.
/// ```dart
/// late List<ChatMessage> _messages;
///
/// @override
/// void initState() {
///   _messages = <ChatMessage>[
///     ChatMessage(
///       text: 'Hello, how can I help you today?',
///       time: DateTime.now(),
///       author: const ChatAuthor(
///         id: 'a2c4-56h8-9x01-2a3d',
///         name: 'Incoming user name',
///       ),
///     ),
///   ];
///   super.initState();
/// }
///
/// @override
/// Widget build(BuildContext context) {
///   return SfChat(
///     messages: _messages,
///     outgoingUser: '8ob3-b720-g9s6-25s8',
///     composer: const ChatComposer(
///       decoration: InputDecoration(
///         hintText: 'Type a message',
///       ),
///     ),
///     actionButton: ChatActionButton(
///       onPressed: (String newMessage) {
///         setState(() {
///           _messages.add(ChatMessage(
///             text: newMessage,
///             time: DateTime.now(),
///             author: const ChatAuthor(
///               id: '8ob3-b720-g9s6-25s8',
///               name: 'Outgoing user name',
///             ),
///           ));
///         });
///       },
///     ),
///   );
/// }
///
/// @override
/// void dispose() {
///   _messages.clear();
///   super.dispose();
/// }
/// ```
/// {@end-tool}
///
/// {@tool snippet}
/// The following example demonstrates how to create a chat interface with
/// the builder properties of the [SfChat] widget.
///
/// ```dart
/// late TextEditingController _textController;
/// late List<ChatMessage> _messages;
///
/// @override
/// void initState() {
///   _textController = TextEditingController();
///   _messages = <ChatMessage>[
///     ChatMessage(
///       text: 'Hello, how can I help you today?',
///       time: DateTime.now(),
///       author: const ChatAuthor(
///         id: 'a2c4-56h8-9x01-2a3d',
///         name: 'Incoming user name',
///       ),
///     ),
///   ];
///   super.initState();
/// }
///
/// @override
/// Widget build(BuildContext context) {
///   return SfChat(
///     messages: _messages,
///     outgoingUser: '8ob3-b720-g9s6-25s8',
///     composer: ChatComposer.builder(
///       builder: (BuildContext context) {
///         return TextFormField(
///           controller: _textController,
///           decoration: InputDecoration(
///             icon: const Icon(Icons.add),
///             hintText: 'Type a message',
///             border: const OutlineInputBorder(
///               borderRadius: BorderRadius.all(Radius.circular(5.0)),
///             ),
///             suffix: IconButton(
///               onPressed: () {
///                 // Handle send button click.
///               },
///               icon: const Icon(Icons.send),
///             ),
///           ),
///         );
///       },
///     ),
///     actionButton: ChatActionButton(
///       size: const Size(90, 40),
///       backgroundColor: Colors.transparent,
///       hoverColor: Colors.transparent,
///       focusColor: Colors.transparent,
///       onPressed: (String newMessage) {
///         // Handle send button click.
///       },
///       child: Row(
///         mainAxisSize: MainAxisSize.min,
///         children: <Widget>[
///           IconButton(
///             constraints: BoxConstraints.tight(const Size(40, 40)),
///             icon: const Icon(Icons.camera_alt_outlined),
///             onPressed: () {
///               // Handle camera button click.
///             },
///           ),
///           const SizedBox(width: 5),
///           IconButton(
///             constraints: BoxConstraints.tight(const Size(40, 40)),
///             icon: const Icon(Icons.mic_none),
///             onPressed: () {
///               // Handle mic button click.
///             },
///           ),
///         ],
///       ),
///     ),
///   );
/// }
///
/// @override
/// void dispose() {
///   _textController.dispose();
///   _messages.clear();
///   super.dispose();
/// }
/// ```
/// {@end-tool}
/// See also:
/// * [SfChatTheme] and [SfChatThemeData] for information about controlling
/// the visual appearance of the [SfChat].
class SfChat extends StatefulWidget {
  /// Creates an [SfChat] widget that displays the content of either incoming or
  /// outgoing messages based on the current user.
  ///
  /// Each message includes details such as the message text, timestamp,
  /// and author information.
  const SfChat({
    super.key,
    required this.messages,
    required this.outgoingUser,
    this.composer = const ChatComposer(),
    this.actionButton,
    this.placeholderBuilder,
    this.bubbleHeaderBuilder,
    this.bubbleAvatarBuilder,
    this.bubbleContentBuilder,
    this.bubbleFooterBuilder,
    this.incomingBubbleSettings = const ChatBubbleSettings(),
    this.outgoingBubbleSettings = const ChatBubbleSettings(),
  });

  /// A list of [ChatMessage] objects that will be displayed in the chat
  /// interface.
  ///
  /// Each message includes details such as the message text, timestamp,
  /// and author information.
  ///
  /// {@tool snippet}
  /// ```dart
  /// List<ChatMessage> _messages = <ChatMessage>[
  ///   ChatMessage(
  ///     text: 'Hello, how can I help you today?',
  ///     time: DateTime.now(),
  ///     author: const ChatAuthor(
  ///       id: 'a2c4-56h8-9x01-2a3d',
  ///       name: 'User name',
  ///     ),
  ///   ),
  /// ];
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     messages: _messages,
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  ///
  /// Additionally, the message content can be extended to include more
  /// information about the chat message.
  ///
  /// {@tool snippet}
  /// ```dart
  /// class ChatMessageExt extends ChatMessage {
  ///   const ChatMessageExtend({
  ///     required super.text,
  ///     required super.time,
  ///     required super.author,
  ///     required this.displayName,
  ///     required this.aboutMessage,
  ///   });
  ///
  ///   final String displayName;
  ///   final String aboutMessage;
  /// }
  ///
  /// List<ChatMessage> _messages = <ChatMessageExt>[
  ///   ChatMessageExt(
  ///     text: 'Hello, how can I help you today?',
  ///     time: DateTime.now(),
  ///     author: const ChatAuthor(
  ///       id: 'a2c4-56h8-9x01-2a3d',
  ///       name: 'User name',
  ///     ),
  ///     displayName: 'UN',
  ///     aboutMessage: 'A coding enthusiast',
  ///   ),
  /// ];
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     messages: _messages,
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  final List<ChatMessage> messages;

  /// The distinct identifier of the user who is sending the message.
  ///
  /// This distinctive ID differentiates messages from the current user
  /// (outgoing message) from those sent by others (incoming message),
  /// ensuring an accurate display of the chat.
  ///
  /// If [ChatMessage.id] is equal to [outgoingUser], the message is considered
  /// an outgoing message; otherwise, it is considered an incoming message.
  ///
  /// {@tool snippet}
  /// ```dart
  /// List<ChatMessage> _messages = <ChatMessage>[
  ///   ChatMessage(
  ///     text: 'Hello, how can I help you today?',
  ///     time: DateTime.now(),
  ///     author: const ChatAuthor(
  ///       id: 'a2c4-56h8-9x01-2a3d',
  ///       name: 'Incoming user name',
  ///     ),
  ///   ),
  ///   ChatMessage(
  ///     text: 'I'm looking for help with the Flutter Chat widget.',
  ///     time: DateTime.now(),
  ///     author: const ChatAuthor(
  ///       id: '8ob3-b720-g9s6-25s8',
  ///       name: 'Outgoing user name',
  ///     ),
  ///   ),
  /// ];
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     outgoingUser: '8ob3-b720-g9s6-25s8',
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  /// See also:
  /// * [messages] to load message conversations.
  /// * [incomingBubbleSettings] to customize the appearance of incoming chat
  /// bubbles.
  /// * [outgoingBubbleSettings] to customize the appearance of outgoing chat
  /// bubbles.
  final String outgoingUser;

  /// A primary text editor for composing outgoing messages.
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
  /// The [actionButton] becomes enabled when text is entered into the editor.
  ///
  /// If the [composer] is disabled by setting [InputDecoration.enabled] to
  /// false, the [actionButton] will also be disabled.
  ///
  /// If [composer] is null, the [actionButton] remains enabled.
  ///
  /// {@tool snippet}
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     composer: ChatComposer(
  ///       minLines: 1,
  ///       maxLines: 3,
  ///       decoration: InputDecoration(
  ///         hintText: 'Type a message...',
  ///         border: OutlineInputBorder(
  ///           borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ///         ),
  ///       ),
  ///     ),
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  ///
  /// ## Builder
  ///
  /// The [ChatComposer.builder] enables an option to create a custom composer.
  ///
  /// It is useful for integrating additional features such as icons, buttons,
  /// or other widgets.
  ///
  /// When [ChatComposer.builder] is used, the [actionButton] will always
  /// remain enabled.
  ///
  /// {@tool snippet}
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     composer: ChatComposer.builder(
  ///       builder: (BuildContext context) {
  ///         return TextFormField(
  ///           decoration: InputDecoration(
  ///             hintText: 'Type a message...',
  ///             border: OutlineInputBorder(
  ///               borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ///             ),
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
  /// {@end-tool}
  ///
  /// See also:
  /// * [ChatComposer.builder] to create a custom text editor.
  /// * [actionButton] to customize the send button.
  /// * [placeholderBuilder] to create a custom widget when there are no
  /// messages in the chat.
  final ChatComposer? composer;

  /// Represents a send button.
  ///
  /// The [SfChat] widget does not include an action button by default.
  /// To add, create a new instance of [ChatActionButton].
  ///
  /// If the [ChatActionButton.onPressed] callback is null, the button
  /// remains disabled.
  ///
  /// If the default [composer]'s text is empty or if the [composer] is
  /// disabled, the button remains disabled.
  ///
  /// If the [composer] is null, the button always stays enabled.
  ///
  /// Pressing the action button invokes the [ChatActionButton.onPressed]
  /// callback with the text entered in the default [composer]. By default,
  /// [SfChat] will not update its state until the parent widget
  /// rebuilds the chat with new messages.
  ///
  /// If [ChatComposer.builder] is used, the button always stays enabled.
  ///
  /// {@tool snippet}
  /// ```dart
  /// List<ChatMessage> _messages = <ChatMessage>[
  ///   ChatMessage(
  ///     text: 'Hello, how can I help you today?',
  ///     time: DateTime.now(),
  ///     author: const ChatAuthor(
  ///       id: 'a2c4-56h8-9x01-2a3d',
  ///       name: 'Incoming user name',
  ///     ),
  ///   ),
  /// ];
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     messages: _messages,
  ///     outgoingUser: '8ob3-b720-g9s6-25s8',
  ///     actionButton: ChatActionButton(
  ///       onPressed: (String newMessage) {
  ///         setState(() {
  ///           _messages.add(
  ///             ChatMessage(
  ///               text: newMessage,
  ///               time: DateTime.now(),
  ///               author: const ChatAuthor(
  ///                 id: '8ob3-b720-g9s6-25s8',
  ///                 name: 'Outgoing user name',
  ///               ),
  ///             ),
  ///           );
  ///         });
  ///       },
  ///     ),
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  ///
  /// See also:
  /// * [ChatComposer] to customize the default text editor.
  /// * [ChatComposer.builder] to create a custom text editor.
  /// * [ChatActionButton.onPressed] to handle the send button click function.
  /// * [ChatActionButton.shape] to customize the shape of the send button.
  final ChatActionButton? actionButton;

  /// A callback function creates a widget to display when there
  /// are no messages in the chat.
  ///
  /// You can use the [placeholderBuilder] to create a custom widget that
  /// appears when the conversation is idle. This is particularly handy for
  /// presenting users with a relevant or visually appealing message indicating
  /// that the conversation is currently empty.
  ///
  /// The callback accepts the [BuildContext] as a parameter and should return
  /// a [Widget].
  ///
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     placeholderBuilder:
  ///       (BuildContext context) {
  ///         return Center(child: Text('No messages yet'));
  ///       },
  ///   );
  /// }
  /// ```
  final WidgetBuilder? placeholderBuilder;

  /// A callback function creates a widget to serve as a header for each chat
  /// bubble.
  ///
  /// The [bubbleHeaderBuilder] allows you to specify a custom widget that will
  /// be shown as a header within each chat bubble. This is particularly useful
  /// for displaying additional information such as the sender's name and
  /// timestamp associated with each message.
  ///
  /// The callback accepts three parameters: [BuildContext], message index in
  /// the list, and [ChatMessage] and returns a [Widget].
  ///
  /// If a new instance is not assigned to this property, it will use the
  /// default header widget.
  ///
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     bubbleHeaderBuilder:
  ///       (BuildContext context, ChatMessage message) {
  ///         return Padding(
  ///           padding: EdgeInsets.all(8.0),
  ///           child: Text(
  ///             message.author.name,
  ///             style: TextStyle(fontWeight: FontWeight.bold)
  ///           ),
  ///         );
  ///       },
  ///   );
  /// }
  /// ```
  ///
  /// See also:
  ///
  /// * The `headerPadding` in [ChatBubbleSettings] for adjusting the
  /// padding of the bubbleHeaderBuilder.
  final ChatWidgetBuilder? bubbleHeaderBuilder;

  /// A callback function creates a widget to display as an avatar within each
  /// chat bubble.
  ///
  /// The [bubbleAvatarBuilder] allows you to specify a custom widget that will
  /// be shown as an avatar within each chat bubble. This is particularly
  /// useful for displaying user avatars or profile pictures in the chat
  /// interface.
  ///
  /// The callback accepts three parameters: [BuildContext], message index in
  /// the list, and [ChatMessage] and returns a [Widget].
  ///
  /// If a new instance is not assigned to this property, it will use the
  /// default avatar widget.
  ///
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     bubbleAvatarBuilder:
  ///       (BuildContext context, int index, ChatMessage message) {
  ///         return CircleAvatar(
  ///           backgroundImage: NetworkImage(
  ///             message.author.id == '123-001'
  ///               ? 'https://example.com/outgoing-avatar.jpg'
  ///               : 'https://example.com/incoming-avatar.jpg',
  ///           ),
  ///         );
  ///       },
  ///   );
  /// }
  /// ```
  ///
  /// See also:
  ///
  /// * The `avatarPadding` in [ChatBubbleSettings] for adjusting the
  /// padding of the bubbleAvatarBuilder.
  final ChatWidgetBuilder? bubbleAvatarBuilder;

  /// A callback function creates a widget to display as the content of each
  /// chat bubble.
  ///
  /// The [bubbleContentBuilder] allows you to specify a custom widget to
  /// display as the content within each chat bubble. This is useful for
  /// customizing how the message content is presented, such as using different
  /// background colors, borders, or padding.
  ///
  /// The callback accepts three parameters: [BuildContext], message index in
  /// the list, and [ChatMessage] and returns a [Widget].
  ///
  /// If a new instance is not assigned to this property, it will use the
  /// default content widget.
  ///
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     bubbleContentBuilder:
  ///       (BuildContext context, int index, ChatMessage message) {
  ///         return Padding(
  ///           padding: EdgeInsets.all(8.0),
  ///           child: Text(message.text),
  ///         );
  ///       },
  ///   );
  /// }
  /// ```
  ///
  /// See also
  ///
  /// * The `contentPadding` in [ChatBubbleSettings] for adjusting the
  /// padding around bubble's content of the bubbleContentBuilder.
  final ChatWidgetBuilder? bubbleContentBuilder;

  /// A callback function creates a widget to display as a footer within each
  /// chat bubble.
  ///
  /// The [bubbleFooterBuilder] allows you to specify a custom widget that will
  /// be shown as a footer within each chat bubble. This is particularly useful
  /// for displaying timestamps or other additional information related to the
  /// message.
  ///
  /// The callback accepts three parameters: [BuildContext], message index in
  /// the list, and [ChatMessage] and returns a [Widget].
  ///
  /// If a new instance is not assigned to this property, it will use the
  /// default footer widget.
  ///
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     bubbleFooterBuilder:
  ///       (BuildContext context, int index, ChatMessage message) {
  ///         return Padding(
  ///           padding: EdgeInsets.all(4.0),
  ///           child: Text(
  ///             DateFormat('hh:mm a').format(message.time),
  ///             style: TextStyle(fontSize: 12.0, color: Colors.grey),
  ///           ),
  ///         );
  ///       },
  ///   );
  /// }
  ///
  /// String _formatTimestamp(DateTime timestamp) {
  ///   return DateFormat('h:mm a').format(timestamp);
  /// }
  /// ```
  ///
  /// See also:
  ///
  /// * The `footerPadding` in [ChatBubbleSettings] for adjusting the
  /// padding of the bubbleFooterBuilder.
  final ChatWidgetBuilder? bubbleFooterBuilder;

  /// Options for changing the appearance and behavior of incoming chat bubbles.
  ///
  /// The [incomingBubbleSettings] property allows you to configure how
  /// incoming chat bubbles are displayed. This includes customization options
  /// for the user's avatar, username, timestamp, content background color, and
  /// various padding and shape options.
  ///
  /// If a new instance is not assigned to this property, the default settings
  /// for incoming chat bubbles will be used.
  ///
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     incomingBubbleSettings: ChatBubbleSettings(
  ///       showUserName: true,
  ///       showTimestamp: true,
  ///       showUserAvatar: true,
  ///       widthFactor: 0.8,
  ///       avatarSize: const Size.square(32.0),
  ///       padding: const EdgeInsets.all(2.0),
  ///       contentPadding:
  ///           const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  ///       headerPadding:
  ///           const EdgeInsetsDirectional.only(top: 14.0, bottom: 4.0),
  ///       footerPadding: const EdgeInsetsDirectional.only(top: 4.0),
  ///     ),
  ///   );
  /// }
  /// ```
  final ChatBubbleSettings incomingBubbleSettings;

  /// Options for changing the appearance and behavior of outgoing chat bubbles.
  ///
  /// The [outgoingBubbleSettings] property allows you to configure how
  /// incoming chat bubbles are displayed. This includes customization options
  /// for the user's avatar, username, timestamp, content background color, and
  /// various padding and shape options.
  ///
  /// If a new instance is not assigned to this property, the default settings
  /// for outgoing chat bubbles will be used.
  ///
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     outgoingBubbleSettings: ChatBubbleSettings(
  ///       showUserName: true,
  ///       showTimestamp: true,
  ///       showUserAvatar: true,
  ///       widthFactor: 0.8,
  ///       avatarSize: const Size.square(32.0),
  ///       padding: const EdgeInsets.all(2.0),
  ///       contentPadding:
  ///           const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  ///       headerPadding:
  ///           const EdgeInsetsDirectional.only(top: 14.0, bottom: 4.0),
  ///       footerPadding: const EdgeInsetsDirectional.only(top: 4.0),
  ///     ),
  ///   );
  /// }
  /// ```
  final ChatBubbleSettings outgoingBubbleSettings;

  @override
  State<SfChat> createState() => _SfChatState();
}

class _SfChatState extends State<SfChat> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  late ThemeData _themeData;
  late SfChatThemeData _effectiveChatThemeData;
  final InputBorder _defaultInputDecorBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(42.0)),
  );
  final EdgeInsetsGeometry _defaultInputDecorContentPadding =
      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0);

  void _updateThemeData(BuildContext context) {
    _themeData = Theme.of(context);
    final SfChatThemeData effectiveThemeData = _themeData.useMaterial3
        ? ChatM3ThemeData(context)
        : ChatM2ThemeData(context);
    final SfChatThemeData chatThemeData = SfChatTheme.of(context);
    final TextStyle contentBaseTextStyle = _themeData.textTheme.bodyMedium!
        .copyWith(color: _themeData.colorScheme.onSurface);
    final TextStyle primaryHeaderBaseTextStyle = _themeData
        .textTheme.labelMedium!
        .copyWith(color: _themeData.colorScheme.primary);
    final TextStyle secondaryHeaderBaseTextStyle = _themeData
        .textTheme.labelSmall!
        .copyWith(color: _themeData.colorScheme.onSurfaceVariant);

    _effectiveChatThemeData = chatThemeData.copyWith(
      actionButtonForegroundColor: widget.actionButton?.foregroundColor ??
          chatThemeData.actionButtonForegroundColor ??
          effectiveThemeData.actionButtonForegroundColor,
      actionButtonBackgroundColor: widget.actionButton?.backgroundColor ??
          chatThemeData.actionButtonBackgroundColor ??
          effectiveThemeData.actionButtonBackgroundColor,
      actionButtonDisabledForegroundColor:
          chatThemeData.actionButtonDisabledForegroundColor ??
              effectiveThemeData.actionButtonDisabledForegroundColor,
      actionButtonDisabledBackgroundColor:
          chatThemeData.actionButtonDisabledBackgroundColor ??
              effectiveThemeData.actionButtonDisabledBackgroundColor,
      actionButtonFocusColor: widget.actionButton?.focusColor ??
          chatThemeData.actionButtonFocusColor ??
          effectiveThemeData.actionButtonFocusColor,
      actionButtonHoverColor: widget.actionButton?.hoverColor ??
          chatThemeData.actionButtonHoverColor ??
          effectiveThemeData.actionButtonHoverColor,
      actionButtonSplashColor: widget.actionButton?.splashColor ??
          chatThemeData.actionButtonSplashColor ??
          effectiveThemeData.actionButtonSplashColor,
      actionButtonElevation:
          widget.actionButton?.elevation ?? chatThemeData.actionButtonElevation,
      actionButtonFocusElevation: widget.actionButton?.focusElevation ??
          chatThemeData.actionButtonFocusElevation,
      actionButtonHoverElevation: widget.actionButton?.hoverElevation ??
          chatThemeData.actionButtonHoverElevation,
      actionButtonHighlightElevation: widget.actionButton?.highlightElevation ??
          chatThemeData.actionButtonHighlightElevation,
      actionButtonMouseCursor: widget.actionButton?.mouseCursor ??
          chatThemeData.actionButtonMouseCursor ??
          effectiveThemeData.actionButtonMouseCursor,
      actionButtonShape: widget.actionButton?.shape ??
          chatThemeData.actionButtonShape ??
          effectiveThemeData.actionButtonShape,
      outgoingBubbleContentBackgroundColor:
          widget.outgoingBubbleSettings.contentBackgroundColor ??
              chatThemeData.outgoingBubbleContentBackgroundColor ??
              effectiveThemeData.outgoingBubbleContentBackgroundColor,
      incomingBubbleContentBackgroundColor:
          widget.incomingBubbleSettings.contentBackgroundColor ??
              chatThemeData.incomingBubbleContentBackgroundColor ??
              effectiveThemeData.incomingBubbleContentBackgroundColor,
      editorTextStyle: contentBaseTextStyle
          .merge(chatThemeData.editorTextStyle)
          .merge(widget.composer?.textStyle),
      outgoingContentTextStyle: contentBaseTextStyle
          .merge(chatThemeData.outgoingContentTextStyle)
          .merge(widget.outgoingBubbleSettings.textStyle),
      incomingContentTextStyle: contentBaseTextStyle
          .merge(chatThemeData.incomingContentTextStyle)
          .merge(widget.incomingBubbleSettings.textStyle),
      outgoingPrimaryHeaderTextStyle: primaryHeaderBaseTextStyle
          .merge(chatThemeData.outgoingPrimaryHeaderTextStyle)
          .merge(widget.outgoingBubbleSettings.headerTextStyle),
      incomingPrimaryHeaderTextStyle: primaryHeaderBaseTextStyle
          .merge(chatThemeData.incomingPrimaryHeaderTextStyle)
          .merge(widget.incomingBubbleSettings.headerTextStyle),
      outgoingSecondaryHeaderTextStyle: secondaryHeaderBaseTextStyle
          .merge(chatThemeData.outgoingSecondaryHeaderTextStyle)
          .merge(widget.outgoingBubbleSettings.headerTextStyle),
      incomingSecondaryHeaderTextStyle: secondaryHeaderBaseTextStyle
          .merge(chatThemeData.incomingSecondaryHeaderTextStyle)
          .merge(widget.incomingBubbleSettings.headerTextStyle),
      outgoingBubbleContentShape: widget.outgoingBubbleSettings.contentShape ??
          chatThemeData.outgoingBubbleContentShape ??
          effectiveThemeData.outgoingBubbleContentShape,
      incomingBubbleContentShape: widget.incomingBubbleSettings.contentShape ??
          chatThemeData.incomingBubbleContentShape ??
          effectiveThemeData.incomingBubbleContentShape,
    );
  }

  Widget? _buildEditor(BuildContext context) {
    if (widget.composer == null) {
      return null;
    } else {
      return EditorExt(
        composer: widget.composer!,
        decoration: _effectiveInputDecoration(),
        actionButton: widget.actionButton,
        focusNode: _focusNode,
        textController: _textController,
        chatThemeData: _effectiveChatThemeData,
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
      return ActionButton(
        settings: widget.actionButton!,
        composer: widget.composer,
        textController: _textController,
        chatThemeData: _effectiveChatThemeData,
      );
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

    return _LayoutHandler(
      children: <Widget>[
        ConversationArea(
          outgoingUser: widget.outgoingUser,
          messages: widget.messages,
          placeholderBuilder: widget.placeholderBuilder,
          bubbleHeaderBuilder: widget.bubbleHeaderBuilder,
          bubbleAvatarBuilder: widget.bubbleAvatarBuilder,
          bubbleContentBuilder: widget.bubbleContentBuilder,
          bubbleFooterBuilder: widget.bubbleFooterBuilder,
          incomingBubbleSettings: widget.incomingBubbleSettings,
          outgoingBubbleSettings: widget.outgoingBubbleSettings,
          chatThemeData: _effectiveChatThemeData,
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

class _ChatParentData extends ContainerBoxParentData<RenderBox> {}

class _LayoutHandler extends MultiChildRenderObjectWidget {
  const _LayoutHandler({required super.children});

  @override
  _RenderLayoutHandler createRenderObject(BuildContext context) {
    return _RenderLayoutHandler();
  }
}

class _RenderLayoutHandler extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _ChatParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _ChatParentData> {
  final LayerHandle<ClipRectLayer> _clipRectLayer =
      LayerHandle<ClipRectLayer>();

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! _ChatParentData) {
      child.parentData = _ChatParentData();
    }
    super.setupParentData(child);
  }

  @override
  void performLayout() {
    const Size minConstraints = Size(300.0, 300.0);
    final double boxWidth = constraints.maxWidth.isFinite
        ? constraints.maxWidth
        : minConstraints.width;
    final double boxHeight = constraints.maxHeight.isFinite
        ? constraints.maxHeight
        : minConstraints.height;

    double availableHeight = boxHeight;
    RenderBox? child = lastChild;
    while (child != null) {
      child.layout(
        BoxConstraints.loose(Size(boxWidth, availableHeight)),
        parentUsesSize: true,
      );
      availableHeight -= child.size.height;
      child = (child.parentData! as _ChatParentData).previousSibling;
    }

    child = firstChild;
    Offset effectiveOffset = Offset.zero;
    while (child != null) {
      final _ChatParentData childParentData =
          child.parentData! as _ChatParentData;
      childParentData.offset = effectiveOffset;
      effectiveOffset += Offset(0.0, child.size.height);
      child = childParentData.nextSibling;
    }

    size = Size(boxWidth, boxHeight);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _clipRectLayer.layer = context.pushClipRect(
      needsCompositing,
      offset,
      Offset.zero & size,
      defaultPaint,
      clipBehavior: Clip.antiAlias,
      oldLayer: _clipRectLayer.layer,
    );
  }

  @override
  void dispose() {
    _clipRectLayer.layer = null;
    super.dispose();
  }
}
