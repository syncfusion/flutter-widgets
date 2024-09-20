import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef ChatWidgetBuilder = Widget Function(
    BuildContext context, int index, ChatMessage message);

/// Represents a chat message.
///
/// The [ChatMessage] class stores the details of a message within a chat
/// system, including the text content, the time when the message was sent, and
/// the author who sent the message.
///
/// Example:
/// ```dart
///
/// @override
/// Widget build(BuildContext context) {
///  return SfChat(
///    messages: [
///      ChatMessage(
///        text: 'Hi',
///        time: DateTime.now(),
///        author: ChatAuthor(id: '123-001', name: 'Chat A'),
///      ),
///    ],
///  );
/// }
/// ```
class ChatMessage {
  /// Creates a [ChatMessage] instance with the given [text], [time], and
  /// [author].
  const ChatMessage({
    required this.text,
    required this.time,
    required this.author,
  });

  /// Content of the message.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///  return SfChat(
  ///    messages: [
  ///      ChatMessage(
  ///        text: 'Hi',
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final String text;

  /// Timestamp when the message was sent.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///  return SfChat(
  ///    messages: [
  ///      ChatMessage(
  ///        time: DateTime.now(),
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final DateTime time;

  /// Author of the message.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///  return SfChat(
  ///    messages: [
  ///      ChatMessage(
  ///        author: ChatAuthor(id: '123-001', name: 'Chat A'),
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final ChatAuthor author;
}

/// Represents the author of a chat message.
///
/// The [ChatAuthor] class contains details about the person who sent the
/// message, such as their unique ID, name, and optional avatar image.
///
/// Example:
/// ```dart
///
/// @override
/// Widget build(BuildContext context) {
///  return SfChat(
///    messages: [
///      ChatMessage(
///        author: ChatAuthor(id: '123-001', name: 'Chat A'),
///      ),
///    ],
///  );
/// }
/// ```
class ChatAuthor {
  /// Creates a new [ChatAuthor] with the specified [id], [name], and optional
  /// [avatar].
  const ChatAuthor({
    required this.id,
    required this.name,
    this.avatar,
  });

  /// Unique identifier for the author.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///  return SfChat(
  ///    messages: [
  ///      ChatMessage(
  ///        author: ChatAuthor(id: '123-001'),
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final String id;

  /// Name of the author.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///  return SfChat(
  ///    messages: [
  ///      ChatMessage(
  ///        author: ChatAuthor(name: 'Chat A'),
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final String name;

  /// Optional avatar image for the author. This field holds an optional image
  /// that represents the author. If no avatar is provided, the chat application
  /// will display the intial letter of the author's name.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///  return SfChat(
  ///    messages: [
  ///      ChatMessage(
  ///        author: ChatAuthor(
  ///          avatar: NetworkImage('https://example.com/outgoing-avatar.jpg')
  ///        ),
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final ImageProvider? avatar;
}

/// A widget for composing chat messages.
///
/// The [ChatComposer] allows customization of text input areas, including text
/// style, line limits, and decoration. It can also be initialized with a custom
/// builder.
///
/// Example with default composer:
/// ```dart
///
/// @override
/// Widget build(BuildContext context) {
///   return SfChat(
///     composer: ChatComposer(
///       textStyle: TextStyle(fontSize: 16.0, color: Colors.black),
///       minLines: 1,
///       maxLines: 6,
///       decoration: InputDecoration(
///         border: OutlineInputBorder(
///           borderRadius: BorderRadius.all(Radius.circular(42.0)))),
///         hintText: 'Type a message...',
///       ),
///       padding: const EdgeInsets.only(top: 16.0),
///     )
///   );
/// }
///
/// Example with custom Composer:
///
/// @override
/// Widget build(BuildContext context) {
///   return SfChat(
///     composer: ChatComposer.builder(
///       builder: (context) => CustomChatInputWidget(),
///       padding: const EdgeInsets.only(top: 16.0),
///     )
///   );
/// }
/// ```
class ChatComposer {
  /// Creates a [ChatComposer] with the given [textStyle], line limits,
  /// [decoration], and [padding].
  const ChatComposer({
    this.textStyle,
    this.minLines = 1,
    this.maxLines = 6,
    this.decoration = const InputDecoration(),
    this.padding = const EdgeInsets.only(top: 16.0),
  })  : assert(minLines >= 0),
        assert(maxLines >= minLines),
        builder = null;

  /// Creates a [ChatComposer] using a custom [builder] for the widget's
  /// construction.
  const ChatComposer.builder({
    required this.builder,
    this.padding = const EdgeInsets.only(top: 16.0),
  })  : textStyle = null,
        decoration = null,
        minLines = 0,
        maxLines = 0;

  /// Maximum number of lines the text input field can contain.
  ///
  /// Defaults to `6`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     composer: ChatComposer(
  ///       maxLines: 6,
  ///     )
  ///   );
  /// }
  /// ```
  final int maxLines;

  /// Minimum number of lines the text input field can contain.
  ///
  /// Defaults to `1`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     composer: ChatComposer(
  ///       minLines: 1,
  ///     )
  ///   );
  /// }
  /// ```
  final int minLines;

  /// Customizes the style of the text input field.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     composer: ChatComposer(
  ///       textStyle: TextStyle(fontSize: 16.0, color: Colors.black),
  ///     )
  ///   );
  /// }
  /// ```
  final TextStyle? textStyle;

  /// Customizes the decoration of the text input field.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     composer: ChatComposer(
  ///       decoration: InputDecoration(
  ///         border: OutlineInputBorder(
  ///           borderRadius: BorderRadius.all(Radius.circular(42.0)))),
  ///         hintText: 'Type a message...',
  ///       ),
  ///     )
  ///   );
  /// }
  /// ```
  final InputDecoration? decoration;

  /// Customizes the padding around the text input field.
  ///
  /// Defaults to `EdgeInsets.only(top: 16.0)`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     composer: ChatComposer(
  ///       padding: const EdgeInsets.only(top: 16.0),
  ///     )
  ///   );
  /// }
  /// ```
  final EdgeInsetsGeometry padding;

  /// Custom builder for constructing the widget.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     composer: ChatComposer.builder(
  ///       builder: (context) => CustomChatInputWidget(),
  ///       padding: const EdgeInsets.only(top: 16.0),
  ///     )
  ///   );
  /// }
  /// ```
  final WidgetBuilder? builder;
}

/// A customizable action button for chat interactions.
///
/// The [ChatActionButton] allows extensive customizations, including
/// appearance, size, and behavior.
///
/// Example:
/// ```dart
///
/// @override
/// Widget build(BuildContext context) {
///   return SfChat(
///     actionButton: ChatActionButton(
///       onPressed: (String newMessage) {
///         setState(() {
///           _messages.add(
///            ChatMessage(
///              text: newMessage,
///              time: DateTime.now(),
///              author: const ChatAuthor(
///                id: '123-001',
///                name: 'Chat A',
///              ),
///            ),
///           );
///         });
///       },
///     ),
///   );
/// }
/// ```
class ChatActionButton {
  /// Creates a [ChatActionButton] with the given parameters.
  const ChatActionButton({
    this.child,
    this.tooltip,
    this.foregroundColor,
    this.backgroundColor,
    this.focusColor,
    this.hoverColor,
    this.splashColor,
    this.elevation,
    this.focusElevation,
    this.hoverElevation,
    this.highlightElevation,
    this.mouseCursor,
    this.shape,
    this.padding = const EdgeInsetsDirectional.only(start: 8.0),
    this.size = const Size.square(40.0),
    required this.onPressed,
  });

  /// Widget displayed inside the button.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     actionButton: ChatActionButton(
  ///       child: null,
  ///     ),
  ///   );
  /// }
  /// ```
  final Widget? child;

  /// Text displayed when the button is hovered over or long pressed.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     actionButton: ChatActionButton(
  ///       tooltip: 'Send Message',
  ///     ),
  ///   );
  /// }
  /// ```
  final String? tooltip;

  /// Color of the button's content (icons or text).
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     actionButton: ChatActionButton(
  ///       foregroundColor: Colors.blue,
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? foregroundColor;

  /// Background color of the button.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     actionButton: ChatActionButton(
  ///       backgroundColor: Colors.white,
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? backgroundColor;

  /// Color of the button while it is focused.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     actionButton: ChatActionButton(
  ///       focusColor: Colors.green,
  ///     ),
  ///   );
  /// }
  ///
  /// ```
  final Color? focusColor;

  /// Color of the button while the mouse is hovering over it.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     actionButton: ChatActionButton(
  ///       hoverColor: Colors.grey,
  ///     ),
  ///   );
  /// }
  ///
  /// ```
  final Color? hoverColor;
  // final Color? highlightColor;

  /// Color of the splash effect generated when the button is pressed.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     actionButton: ChatActionButton(
  ///       splashColor: Colors.red,
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? splashColor;

  /// Depth of the button's shadow, which influences its appearance.
  ///
  /// Defaults to `0.0`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     actionButton: ChatActionButton(
  ///       elevation: 4.0,
  ///     ),
  ///   );
  /// }
  /// ```
  final double? elevation;

  /// Depth of the button's shadow while focused.
  ///
  /// Defaults to `0.0`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     actionButton: ChatActionButton(
  ///       focusElevation: 8.0,
  ///     ),
  ///   );
  /// }
  /// ```
  final double? focusElevation;

  /// Depth of the button's shadow when the mouse hovers over it.
  ///
  /// Defaults to `0.0`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     actionButton: ChatActionButton(
  ///       hoverElevation: 6.0,
  ///     ),
  ///   );
  /// }
  /// ```
  final double? hoverElevation;

  /// Depth of the button's shadow when highlighted.
  ///
  /// Defaults to `0.0`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     actionButton: ChatActionButton(
  ///       highlightElevation: 5.0,
  ///     ),
  ///   );
  /// }
  /// ```
  final double? highlightElevation;

  /// Customizes the cursor that appears when you hover over the button.
  ///
  /// Defaults to `null`
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     actionButton: ChatActionButton(
  ///       mouseCursor: SystemMouseCursors.click,
  ///     ),
  ///   );
  /// }
  /// ```
  final MouseCursor? mouseCursor;

  /// Shape of the button border.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     actionButton: ChatActionButton(
  ///       shape: RoundedRectangleBorder(
  ///         borderRadius: BorderRadius.circular(8.0),
  ///       ),
  ///     ),
  ///   );
  /// }
  /// ```
  final ShapeBorder? shape;

  /// Customizes the padding around the button’s child widget.
  ///
  /// Defaults to `EdgeInsetsDirectional.only(start: 8.0)`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     actionButton: ChatActionButton(
  ///       padding: EdgeInsets.all(12.0),
  ///     ),
  ///   );
  /// }
  /// ```
  final EdgeInsetsGeometry padding;

  /// Size of the button.
  ///
  /// Defaults to `Size.square(40.0)`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     actionButton: ChatActionButton(
  ///       size: Size(50.0, 50.0),
  ///     ),
  ///   );
  /// }
  /// ```
  final Size size;

  /// A callback function that is called whenever the button is pressed. This
  /// parameter is a function that receives a `String` argument representing the
  /// new message. It is Invoked when the button is pressed.
  ///
  /// Defaults to `null`,
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     actionButton: ChatActionButton(
  ///       onPressed: (String newMessage) {
  ///         setState(() {
  ///           _messages.add(
  ///            ChatMessage(
  ///              text: newMessage,
  ///              time: DateTime.now(),
  ///              author: const ChatAuthor(
  ///                id: '123-001',
  ///                name: 'Chat A',
  ///              ),
  ///            ),
  ///           );
  ///         });
  ///       },
  ///     ),
  ///   );
  /// }
  /// ```
  final ValueChanged<String>? onPressed;
}

/// Customizes chat bubbles with these setttings for a better user experience.
///
/// The [ChatBubbleSettings] class provides options to customize the apearance
/// and layout of chat bubbles, including styling, and padding, and display
/// options for elements such as the username, timestamp, and avatar.
///
/// Example:
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
class ChatBubbleSettings {
  /// Creates a [ChatBubbleSettings] with the given customization options.
  const ChatBubbleSettings({
    this.showUserName = true,
    this.showTimestamp = true,
    this.showUserAvatar = true,
    this.timestampFormat,
    this.textStyle,
    this.headerTextStyle,
    this.contentBackgroundColor,
    this.contentShape,
    this.widthFactor = 0.8,
    this.avatarSize = const Size.square(32.0),
    this.padding = const EdgeInsets.all(2.0),
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.avatarPadding,
    this.headerPadding =
        const EdgeInsetsDirectional.only(top: 14.0, bottom: 4.0),
    this.footerPadding = const EdgeInsetsDirectional.only(top: 4.0),
  });

  /// Customizes whether to display the sender's username within the chat
  /// bubble.
  ///
  /// Defaults to `true`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     incomingBubbleSettings: ChatBubbleSettings(
  ///       showUserName: true,
  ///     ),
  ///     outgoingBubbleSettings: ChatBubbleSettings(
  ///       showUserName: true,
  ///     ),
  ///   );
  /// }
  /// ```
  final bool showUserName;

  /// Customizes whether to display the timestamp within the chat bubble.
  ///
  /// Defaults to `true`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     incomingBubbleSettings: ChatBubbleSettings(
  ///       showTimestamp: true,
  ///     ),
  ///     outgoingBubbleSettings: ChatBubbleSettings(
  ///       showTimestamp: true,
  ///     ),
  ///   );
  /// }
  /// ```
  final bool showTimestamp;

  /// Customizes whether to display the sender's avatar within the chat bubble.
  ///
  /// Defaults to `true`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     incomingBubbleSettings: ChatBubbleSettings(
  ///       showUserAvatar: true,
  ///     ),
  ///     outgoingBubbleSettings: ChatBubbleSettings(
  ///       showUserAvatar: true,
  ///     ),
  ///   );
  /// }
  /// ```
  final bool showUserAvatar;

  /// Customizes the format for displaying the timestamp of the message.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     incomingBubbleSettings: ChatBubbleSettings(
  ///       timestampFormat: DateFormat('hh:mm a'),
  ///     ),
  ///     outgoingBubbleSettings: ChatBubbleSettings(
  ///       timestampFormat: DateFormat('hh:mm a'),
  ///     ),
  ///   );
  /// }
  /// ```
  final DateFormat? timestampFormat;

  /// Style for the chat bubble's text.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     incomingBubbleSettings: ChatBubbleSettings(
  ///       textStyle: TextStyle(fontSize: 14),
  ///     ),
  ///     outgoingBubbleSettings: ChatBubbleSettings(
  ///       textStyle: TextStyle(fontSize: 14),
  ///     ),
  ///   );
  /// }
  ///
  /// ```
  final TextStyle? textStyle;

  /// Style for the header text in the chat bubble.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     incomingBubbleSettings: ChatBubbleSettings(
  ///       headerTextStyle: TextStyle(fontWeight: FontWeight.bold),
  ///     ),
  ///     outgoingBubbleSettings: ChatBubbleSettings(
  ///       headerTextStyle: TextStyle(fontWeight: FontWeight.bold),
  ///     ),
  ///   );
  /// }
  /// ```
  final TextStyle? headerTextStyle;

  /// Background color of the message content.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     incomingBubbleSettings: ChatBubbleSettings(
  ///       contentBackgroundColor: Colors.grey[200],
  ///     ),
  ///     outgoingBubbleSettings: ChatBubbleSettings(
  ///       contentBackgroundColor: Colors.grey[400],
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? contentBackgroundColor;

  /// Shape of the message content, including border radius.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     incomingBubbleSettings: ChatBubbleSettings(
  ///       contentShape: RoundedRectangleBorder(
  ///         borderRadius: BorderRadius.circular(12.0),
  ///       ),
  ///     ),
  ///     outgoingBubbleSettings: ChatBubbleSettings(
  ///       contentShape: RoundedRectangleBorder(
  ///         borderRadius: BorderRadius.circular(12.0),
  ///       ),
  ///     ),
  ///   );
  /// }
  /// ```
  final ShapeBorder? contentShape;

  /// Customizes the chat bubble's width as a fraction of the screen width.
  ///
  /// Defaults to `0.8`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     incomingBubbleSettings: ChatBubbleSettings(
  ///       widthFactor: 0.8,
  ///     ),
  ///     outgoingBubbleSettings: ChatBubbleSettings(
  ///       widthFactor: 0.8,
  ///     ),
  ///   );
  /// }
  /// ```
  final double widthFactor;

  /// Customizes the avatar's size within the chat bubble.
  ///
  /// Defaults to `Size.square(32.0)`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     incomingBubbleSettings: ChatBubbleSettings(
  ///       avatarSize: const Size.square(35.0),
  ///     ),
  ///     outgoingBubbleSettings: ChatBubbleSettings(
  ///       avatarSize: const Size.square(35.0),
  ///     ),
  ///   );
  /// }
  /// ```
  final Size avatarSize;

  /// Customizes the padding around the entire bubble.
  ///
  /// Defaults to `EdgeInsets.all(2.0)`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     incomingBubbleSettings: ChatBubbleSettings(
  ///       padding: const EdgeInsets.all(2.0),
  ///     ),
  ///     outgoingBubbleSettings: ChatBubbleSettings(
  ///       padding: const EdgeInsets.all(2.0),
  ///     ),
  ///   );
  /// }
  /// ```
  final EdgeInsetsGeometry padding;

  /// Customizes the padding around the bubble's content.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     incomingBubbleSettings: ChatBubbleSettings(
  ///       contentPadding:
  ///           const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  ///     ),
  ///     outgoingBubbleSettings: ChatBubbleSettings(
  ///       contentPadding:
  ///           const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  ///     ),
  ///   );
  /// }
  /// ```
  final EdgeInsetsGeometry contentPadding;

  /// Customizes the padding around the avatar within the bubble.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     incomingBubbleSettings: ChatBubbleSettings(
  ///       avatarPadding: const EdgeInsets.all(4.0),
  ///     ),
  ///     outgoingBubbleSettings: ChatBubbleSettings(
  ///       avatarPadding: const EdgeInsets.all(4.0),
  ///     ),
  ///   );
  /// }
  /// ```
  final EdgeInsetsGeometry? avatarPadding;

  /// Customizes padding to the header section of the bubble (if applicable).
  ///
  /// Defaults to `EdgeInsetsDirectional.only(top:14.0, bottom: 4.0)`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     incomingBubbleSettings: ChatBubbleSettings(
  ///       headerPadding:
  ///           const EdgeInsetsDirectional.only(top: 14.0, bottom: 4.0),
  ///     ),
  ///     outgoingBubbleSettings: ChatBubbleSettings(
  ///       headerPadding:
  ///           const EdgeInsetsDirectional.only(top: 14.0, bottom: 4.0),
  ///     ),
  ///   );
  /// }
  /// ```
  final EdgeInsetsGeometry headerPadding;

  /// Customizes the padding around the footer section of the
  /// bubble (if applicable).
  ///
  /// Defaults to `EdgeInsetsDirectional.only(top: 4.0)`.
  ///
  /// Example:
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfChat(
  ///     incomingBubbleSettings: ChatBubbleSettings(
  ///       footerPadding: const EdgeInsetsDirectional.only(top: 4.0),
  ///     ),
  ///     outgoingBubbleSettings: ChatBubbleSettings(
  ///       footerPadding: const EdgeInsetsDirectional.only(top: 4.0),
  ///     ),
  ///   );
  /// }
  /// ```
  final EdgeInsetsGeometry footerPadding;

  ChatBubbleSettings copyWith({
    bool? showUserName,
    bool? showTimestamp,
    bool? showUserAvatar,
    DateFormat? timestampFormat,
    TextStyle? textStyle,
    TextStyle? headerTextStyle,
    Color? contentBackgroundColor,
    ShapeBorder? contentShape,
    double? widthFactor,
    Size? avatarSize,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? avatarPadding,
    EdgeInsetsGeometry? headerPadding,
    EdgeInsetsGeometry? footerPadding,
  }) {
    return ChatBubbleSettings(
      showUserName: showUserName ?? this.showUserName,
      showTimestamp: showTimestamp ?? this.showTimestamp,
      showUserAvatar: showUserAvatar ?? this.showUserAvatar,
      timestampFormat: timestampFormat ?? this.timestampFormat,
      textStyle: textStyle ?? this.textStyle,
      headerTextStyle: headerTextStyle ?? this.headerTextStyle,
      contentBackgroundColor:
          contentBackgroundColor ?? this.contentBackgroundColor,
      contentShape: contentShape ?? this.contentShape,
      widthFactor: widthFactor ?? this.widthFactor,
      avatarSize: avatarSize ?? this.avatarSize,
      padding: padding ?? this.padding,
      contentPadding: contentPadding ?? this.contentPadding,
      avatarPadding: avatarPadding ?? this.avatarPadding,
      headerPadding: headerPadding ?? this.headerPadding,
      footerPadding: footerPadding ?? this.footerPadding,
    );
  }

  ChatBubbleSettings merge(ChatBubbleSettings? other) {
    if (other == null) {
      return this;
    }

    return copyWith(
      showUserName: other.showUserName,
      showTimestamp: other.showTimestamp,
      showUserAvatar: other.showUserAvatar,
      timestampFormat: other.timestampFormat,
      textStyle: other.textStyle,
      headerTextStyle: other.headerTextStyle,
      contentBackgroundColor: other.contentBackgroundColor,
      contentShape: other.contentShape,
      widthFactor: other.widthFactor,
      avatarSize: other.avatarSize,
      padding: other.padding,
      contentPadding: other.contentPadding,
      avatarPadding: other.avatarPadding,
      headerPadding: other.headerPadding,
      footerPadding: other.footerPadding,
    );
  }
}
