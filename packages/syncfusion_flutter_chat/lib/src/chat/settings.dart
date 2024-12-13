import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../settings.dart';

/// The [ChatWidgetBuilder] typedef defines a function signature for creating
/// custom chat message widgets. It takes a [BuildContext], an [index] for
/// the message position, and a [ChatMessage] object as  parameters, and
/// returns a [Widget] to customize how chat messages are displayed.
typedef ChatWidgetBuilder = BaseWidgetBuilder<ChatMessage>;

/// The [ChatSuggestionItemSelectedCallback] typedef represents a callback
/// function that is called when a chat suggestion item is selected.
/// It takes a [selected] flag, the [messageIndex] for the message,
/// the [suggestion] being interacted with, and the [suggestionIndex]
/// indicating the position of the suggestion.
typedef ChatSuggestionItemSelectedCallback = void Function(
  bool selected,
  int messageIndex,
  ChatMessageSuggestion suggestion,
  int suggestionIndex,
);

/// Mode to handle the chat Suggestion items overflow.
enum ChatSuggestionOverflow {
  /// - `ChatSuggestionOverflow.scroll`, will wrap and place the remaining
  /// suggestion item to next line.
  scroll,

  /// - `ChatSuggestionOverflow.wrap`, will place all the suggestion
  /// items in single line and enables scrolling.
  wrap,
}

/// Represents a selection mode of the suggestion, it will be
/// either single or multiple.
enum ChatSuggestionSelectionType {
  /// - `ChatSuggestionSelectionType.single`, allows to select only
  /// one suggestion.
  single,

  /// - `ChatSuggestionSelectionType.multiple`, allows to select
  /// multiple suggestions.
  multiple,
}

/// Represents a chat message.
///
/// The [ChatMessage] class stores the details of a message within a chat
/// system, including the text content, the time when the message was sent,
/// the author who sent the message, list of suggestion items for a message,
/// and the suggestion settings to customize the suggestion items.
///
/// Example:
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return SfChat(
///     messages: [
///       ChatMessage(
///         text:
///          'Hi, I have planned to go on a trip. Can you suggest some places?',
///         time: DateTime.now(),
///         author: const ChatAuthor(id: '123-001', name: 'Chat A'),
///         suggestions: <ChatMessageSuggestion>[
///           ChatMessageSuggestion(
///             data: 'Paris',
///           ),
///           ChatMessageSuggestion(
///             data: 'Tokyo',
///           ),
///           ChatMessageSuggestion(
///             data: 'New York',
///           ),
///           ChatMessageSuggestion(
///             data: 'London',
///           ),
///         ],
///         suggestionSettings: ChatSuggestionSettings(
///           backgroundColor: Colors.grey[300],
///           itemBackgroundColor: WidgetStateProperty.resolveWith<Color>(
///             (states) {
///               if (states.contains(WidgetState.hovered)) {
///                 return Colors.grey[400]!;
///               }
///               return Colors.grey;
///             },
///           ),
///           shape: const RoundedRectangleBorder(
///             borderRadius: BorderRadius.all(
///               Radius.circular(4.0),
///             ),
///           ),
///           itemShape: WidgetStateProperty.resolveWith<ShapeBorder>(
///             (Set<WidgetState> states) {
///               if (states.contains(WidgetState.hovered)) {
///                 return RoundedRectangleBorder(
///                   borderRadius: BorderRadius.circular(20),
///                 );
///               }
///               return RoundedRectangleBorder(
///                 borderRadius: BorderRadius.circular(5),
///               );
///             },
///           ),
///         textStyle: WidgetStateProperty.resolveWith<TextStyle?>(
///           (Set<WidgetState> states) {
///             if (states.contains(WidgetState.disabled)) {
///               return const TextStyle(fontSize: 16);
///             }
///             return const TextStyle(fontSize: 14);
///           },
///          ),
///           padding: const EdgeInsets.all(10),
///           itemPadding:
///               const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
///           orientation: Axis.horizontal,
///           itemOverflow: ChatSuggestionOverflow.scroll,
///         ),
///       ),
///     ],
///   );
/// }
/// ```
class ChatMessage extends Message {
  /// Creates a [ChatMessage] instance with the given [text], [time],
  /// [author] and optional [suggestions] and [suggestionSettings].
  const ChatMessage({
    required this.text,
    required this.time,
    required this.author,
    this.suggestions,
    this.suggestionSettings,
  });

  /// Content of the message.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return SfChat(
  ///    messages: <ChatMessage>[
  ///      ChatMessage(
  ///        text: 'Hi',
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  @override
  final String text;

  /// Timestamp when the message was sent.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return SfChat(
  ///    messages: <ChatMessage>[
  ///      ChatMessage(
  ///        time: DateTime.now(),
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  @override
  final DateTime time;

  /// Author of the message.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return SfChat(
  ///    messages: <ChatMessage>[
  ///      ChatMessage(
  ///        author: ChatAuthor(id: '123-001', name: 'Chat A'),
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  @override
  final ChatAuthor author;

  /// List of suggestion items for the message.
  ///
  /// Example:
  /// ```dart
  /// List<ChatMessage> _messages = <ChatMessage>[
  /// ChatMessage(
  ///       text:
  ///        "Hi, I have planned to go on a trip. Can you suggest some places?",
  ///       suggestions: <ChatMessageSuggestion>[
  ///         ChatMessageSuggestion(
  ///           data: 'Paris',
  ///         ),
  ///         ChatMessageSuggestion(
  ///           data: 'New York',
  ///         ),
  ///         ChatMessageSuggestion(
  ///           data: 'Tokyo',
  ///        ),
  ///        ChatMessageSuggestion(
  ///          data: 'London',
  ///        ),
  ///      ],
  ///    ),
  ///  ];
  /// ```
  @override
  final List<ChatMessageSuggestion>? suggestions;

  /// Settings for customizing the appearance and layout of
  /// message suggestions in [ChatMessage].
  ///
  /// Example:
  /// ```dart
  /// List<ChatMessage> _messages = <ChatMessage>[
  ///   ChatMessage(
  ///     suggestionSettings: ChatSuggestionSettings(
  ///       backgroundColor: Colors.grey[300],
  ///       itemBackgroundColor: WidgetStateProperty.resolveWith<Color>(
  ///         (states) {
  ///           if (states.contains(WidgetState.hovered)) {
  ///             return Colors.grey[400]!;
  ///           }
  ///           return Colors.grey;
  ///         },
  ///       ),
  ///       shape: const RoundedRectangleBorder(
  ///         borderRadius: BorderRadius.all(
  ///           Radius.circular(4.0),
  ///         ),
  ///       ),
  ///       itemShape: WidgetStateProperty.resolveWith<ShapeBorder>(
  ///         (Set<WidgetState> states) {
  ///           if (states.contains(WidgetState.hovered)) {
  ///             return RoundedRectangleBorder(
  ///               borderRadius: BorderRadius.circular(20),
  ///             );
  ///           }
  ///           return RoundedRectangleBorder(
  ///             borderRadius: BorderRadius.circular(5),
  ///           );
  ///         },
  ///       ),
  ///         textStyle: WidgetStateProperty.resolveWith<TextStyle?>(
  ///           (Set<WidgetState> states) {
  ///             if (states.contains(WidgetState.disabled)) {
  ///               return const TextStyle(fontSize: 16);
  ///             }
  ///             return const TextStyle(fontSize: 14);
  ///           },
  ///          ),
  ///       padding: const EdgeInsets.all(10),
  ///       itemPadding:
  ///           const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
  ///       orientation: Axis.horizontal,
  ///       itemOverflow: ChatSuggestionOverflow.scroll,
  ///       runSpacing: 10.0,
  ///       spacing: 10.0,
  ///     ),
  ///   ),
  /// ];
  /// ```
  @override
  final ChatSuggestionSettings? suggestionSettings;
}

/// Represents the author of a chat message.
///
/// The [ChatAuthor] class contains details about the person who sent the
/// message, such as their unique ID, name, and optional avatar image.
///
/// Example:
/// ```dart
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
class ChatAuthor extends MessageAuthor {
  /// Creates a new [ChatAuthor] with the specified [id], [name], and optional
  /// [avatar].
  const ChatAuthor({
    required this.id,
    required this.name,
    this.avatar,
  });

  /// Unique identifier for the author which contains information about
  /// user name and user ID.
  ///
  /// Example:
  /// ```dart
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
  @override
  final String id;

  /// Name of the author.
  ///
  /// Example:
  /// ```dart
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
  @override
  final String name;

  /// Optional avatar image for the author. This field holds an optional image
  /// that represents the author. If no avatar is provided, the chat application
  /// will display the initial letter of the author's name.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
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
  @override
  final ImageProvider? avatar;
}

/// Represents a chat message suggestion.
///
/// Example with default suggestion:
///
/// ```dart
/// List<ChatMessage> _messages = <ChatMessage>[
/// ChatMessage(
///       text:
///         "Hi, I have planned to go on a trip. Can you suggest some places?",
///       suggestions: <ChatMessageSuggestion>[
///         ChatMessageSuggestion(
///           data: 'Paris',
///         ),
///         ChatMessageSuggestion(
///           data: 'New York',
///         ),
///         ChatMessageSuggestion(
///           data: 'Tokyo',
///        ),
///        ChatMessageSuggestion(
///          data: 'London',
///        ),
///      ],
///    ),
///  ];
/// ```
///
/// Example with builder suggestion:
///
/// ```dart
/// List<ChatMessage> _messages = <ChatMessage>[
///   ChatMessage(
///     suggestions: <ChatMessageSuggestion>[
///       ChatMessageSuggestion.builder(
///         builder: (context) {
///           return const DecoratedBox(
///             decoration: BoxDecoration(
///               color: Colors.green,
///             ),
///             child: Text('Paris'),
///           );
///         },
///       ),
///     ],
///   ),
/// ];
/// ```
class ChatMessageSuggestion extends MessageSuggestion {
  /// Creates a [ChatMessageSuggestion] with the given [data] and
  /// optional [selected].
  const ChatMessageSuggestion({
    required this.data,
    this.selected = false,
  }) : builder = null;

  const ChatMessageSuggestion.builder({
    required this.builder,
    this.selected = false,
  }) : data = '';

  /// Text content for the suggestion.
  ///
  /// Example:
  /// ```dart
  /// List<ChatMessage> _messages = <ChatMessage>[
  ///     ChatMessage(
  ///       suggestions: <ChatMessageSuggestion>[
  ///         const ChatMessageSuggestion(
  ///           data: 'Paris',
  ///         ),
  ///       ],
  ///     ),
  ///   ];
  /// ```
  @override
  final String? data;

  /// Indicates whether the suggestion is initially selected.
  ///
  /// Example:
  /// ```dart
  /// List<ChatMessage> _messages = <ChatMessage>[
  ///   ChatMessage(
  ///     suggestions: <ChatMessageSuggestion>[
  ///       const ChatMessageSuggestion(
  ///         data: 'Paris',
  ///         selected: false,
  ///       ),
  ///     ],
  ///   ),
  /// ];
  /// ```
  @override
  final bool selected;

  /// Optional builder function for creating a custom widget for the suggestion.
  ///
  /// Example:
  /// ```dart
  /// List<ChatMessage> _messages = <ChatMessage>[
  ///   ChatMessage(
  ///     suggestions: <ChatMessageSuggestion>[
  ///       ChatMessageSuggestion.builder(
  ///         builder: (context) {
  ///           return Text('Paris');
  ///         },
  ///       ),
  ///     ],
  ///   ),
  /// ];
  /// ```
  @override
  final WidgetBuilder? builder;

  /// Creates a copy of this suggestion with the given fields replaced by the
  /// new values.
  ChatMessageSuggestion copyWith({
    String? data,
    bool? selected,
    WidgetBuilder? builder,
  }) {
    if (builder != null) {
      return ChatMessageSuggestion.builder(
        builder: builder,
        selected: selected ?? this.selected,
      );
    } else {
      return ChatMessageSuggestion(
        data: data ?? this.data,
        selected: selected ?? this.selected,
      );
    }
  }
}

/// Represents the settings for chat message suggestions.
///
/// The [ChatSuggestionSettings] class allows you to customize the appearance
///  of the entire suggestion area as well as each individual suggestion
/// items in the suggestion list.
///
/// For the suggestion area, you can set the background color, shape and add
/// padding to control the spacing around the suggestion list inside the
/// suggestion area. You can also set the orientation of the suggestion
/// area to be either vertical or horizontal.
///
/// For each individual suggestion item, you can customize the shape, background
/// color, and item padding to add space around the each suggestion items.
/// you can also add the space between the each items using the run spacing
/// and spacing property.
///
/// Example:
/// ```dart
/// List<ChatMessage> _messages = <ChatMessage>[
///   ChatMessage(
///     suggestionSettings: ChatSuggestionSettings(
///       backgroundColor: Colors.grey[300],
///       itemBackgroundColor: WidgetStateProperty.resolveWith<Color>(
///         (states) {
///           if (states.contains(WidgetState.hovered)) {
///             return Colors.grey[400]!;
///           }
///           return Colors.grey;
///         },
///       ),
///       shape: const RoundedRectangleBorder(
///         borderRadius: BorderRadius.all(
///           Radius.circular(4.0),
///         ),
///       ),
///       itemShape: WidgetStateProperty.resolveWith<ShapeBorder>(
///         (Set<WidgetState> states) {
///           if (states.contains(WidgetState.hovered)) {
///             return RoundedRectangleBorder(
///               borderRadius: BorderRadius.circular(20),
///             );
///           }
///           return RoundedRectangleBorder(
///             borderRadius: BorderRadius.circular(5),
///           );
///         },
///       ),
///       textStyle: WidgetStateProperty.resolveWith<TextStyle?>(
///        (Set<WidgetState> states) {
///           if (states.contains(WidgetState.disabled)) {
///             return const TextStyle(fontSize: 16);
///           }
///           return const TextStyle(fontSize: 14);
///        },
///       ),
///       padding: const EdgeInsets.all(10),
///       itemPadding:
///           const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
///       orientation: Axis.horizontal,
///       itemOverflow: ChatSuggestionOverflow.scroll,
///       runSpacing: 10.0,
///       spacing: 10.0,
///     ),
///   ),
/// ];
/// ```
class ChatSuggestionSettings extends SuggestionSettings {
  /// Creates a [ChatSuggestionSettings] with the given customization options.
  const ChatSuggestionSettings({
    this.backgroundColor,
    this.itemBackgroundColor,
    this.shape,
    this.itemShape,
    this.textStyle,
    this.padding = const EdgeInsetsDirectional.symmetric(vertical: 5.0),
    this.itemPadding =
        const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    this.orientation = Axis.horizontal,
    ChatSuggestionOverflow itemOverflow = ChatSuggestionOverflow.wrap,
    ChatSuggestionSelectionType selectionType =
        ChatSuggestionSelectionType.single,
    this.runSpacing = 12.0,
    this.spacing = 16.0,
  })  : itemOverflow = itemOverflow == ChatSuggestionOverflow.scroll
            ? SuggestionOverflow.scroll
            : SuggestionOverflow.wrap,
        selectionType = selectionType == ChatSuggestionSelectionType.multiple
            ? SuggestionSelectionType.multiple
            : SuggestionSelectionType.single;

  /// Background color of the suggestion area.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  /// List<ChatMessage> _messages = <ChatMessage>[
  ///   ChatMessage(
  ///     suggestionSettings: ChatSuggestionSettings(
  ///       backgroundColor: Colors.grey[300],
  ///     )
  ///   ),
  /// ];
  /// ```
  @override
  final Color? backgroundColor;

  /// The [itemBackgroundColor] property sets the background color for the
  /// individual suggestion items based on their state, such as hovered or
  /// pressed.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  /// List<ChatMessage> _messages = <ChatMessage>[
  ///   ChatMessage(
  ///     suggestionSettings: ChatSuggestionSettings(
  ///       itemBackgroundColor: WidgetStateProperty.resolveWith<Color>(
  ///         (states) {
  ///           if (states.contains(WidgetState.hovered)) {
  ///             return Colors.grey[400]!;
  ///           }
  ///           return Colors.grey;
  ///         },
  ///       ),
  ///     )
  ///   ),
  /// ];
  /// ```
  @override
  final WidgetStateProperty<Color?>? itemBackgroundColor;

  /// Used to customize the overall shape of the suggestion area.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  /// List<ChatMessage> _messages = <ChatMessage>[
  ///   ChatMessage(
  ///     suggestionSettings: ChatSuggestionSettings(
  ///       shape: const RoundedRectangleBorder(
  ///         borderRadius: BorderRadius.all(Radius.circular(4.0)),
  ///       ),
  ///     )
  ///   ),
  /// ];
  /// ```
  @override
  final ShapeBorder? shape;

  /// Used to customize the shape of individual suggestion items based on their
  /// state, such as hovered or pressed.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  /// List<ChatMessage> _messages = <ChatMessage>[
  ///   ChatMessage(
  ///     suggestionSettings: ChatSuggestionSettings(
  ///       itemShape: WidgetStateProperty.resolveWith<ShapeBorder>(
  ///           (Set<WidgetState> states) {
  ///         if (states.contains(WidgetState.hovered)) {
  ///           return RoundedRectangleBorder(
  ///             borderRadius: BorderRadius.circular(20),
  ///           );
  ///         }
  ///         return RoundedRectangleBorder(
  ///           borderRadius: BorderRadius.circular(5),
  ///         );
  ///       }),
  ///     )
  ///   ),
  /// ];
  /// ```
  @override
  final WidgetStateProperty<ShapeBorder?>? itemShape;

  /// The [textStyle] used to sets the text style for the suggestion item based
  /// on their state, such as hovered or pressed.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  /// List<ChatMessage> _messages = <ChatMessage>[
  ///  ChatMessage(
  ///   suggestionSettings: ChatSuggestionSettings(
  ///      textStyle: WidgetStateProperty.resolveWith<TextStyle?>(
  ///        (Set<WidgetState> states) {
  ///           if (states.contains(WidgetState.disabled)) {
  ///             return const TextStyle(fontSize: 16);
  ///           }
  ///           return const TextStyle(fontSize: 14);
  ///        },
  ///     ),
  ///   ),
  ///  ),
  /// ];
  /// ```
  @override
  final WidgetStateProperty<TextStyle?>? textStyle;

  /// Padding between the suggestion area and individual suggestion items.
  ///
  /// Defaults to `EdgeInsets.all(5.0)`.
  ///
  /// Example:
  /// ```dart
  /// List<ChatMessage> _messages = <ChatMessage>[
  ///   ChatMessage(
  ///     suggestionSettings: ChatSuggestionSettings(
  ///       padding: const EdgeInsets.only(top: 10, bottom: 10),
  ///     )
  ///   ),
  /// ];
  /// ```
  @override
  final EdgeInsetsGeometry padding;

  /// Padding between the content of each individual suggestion item.
  ///
  /// Defaults to `EdgeInsets.all(5.0)`.
  ///
  /// Example:
  /// ```dart
  /// List<ChatMessage> _messages = <ChatMessage>[
  ///   ChatMessage(
  ///     suggestionSettings: ChatSuggestionSettings(
  ///       itemPadding:
  ///           const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
  ///     )
  ///   ),
  /// ];
  /// ```
  @override
  final EdgeInsetsGeometry itemPadding;

  /// The [orientation] is used to determine the rendering orientation of the
  /// suggestion items and the direction in which the suggestions are scrolled.
  ///
  /// Defaults to [Axis.horizontal].
  ///
  /// Example:
  /// ```dart
  /// List<ChatMessage> _messages = <ChatMessage>[
  ///   ChatMessage(
  ///     suggestionSettings: ChatSuggestionSettings(
  ///       orientation: Axis.vertical,
  ///     )
  ///   ),
  /// ];
  /// ```
  @override
  final Axis orientation;

  /// The [runSpacing] determines a vertical spacing between runs of suggestion
  /// items.
  ///
  /// Defaults to `8.0`.
  ///
  /// Example:
  /// ```dart
  /// List<ChatMessage> _messages = <ChatMessage>[
  ///   ChatMessage(
  ///     suggestionSettings: ChatSuggestionSettings(
  ///       runSpacing: 10.0,
  ///     )
  ///   ),
  /// ];
  /// ```
  @override
  final double runSpacing;

  /// The [spacing] determines a horizontal spacing between individual
  /// suggestion items.
  ///
  /// Defaults to `8.0`.
  ///
  /// Example:
  /// ```dart
  /// List<ChatMessage> _messages = <ChatMessage>[
  ///   ChatMessage(
  ///     suggestionSettings: ChatSuggestionSettings(
  ///       spacing: 10.0,
  ///     )
  ///   ),
  /// ];
  /// ```
  @override
  final double spacing;

  /// The [itemOverflow] property determines whether suggestion items will wrap
  /// to fit within available space or scroll beyond it
  ///
  /// Defaults to [SuggestionOverflow.wrap].
  ///
  /// Example:
  /// ```dart
  /// List<ChatMessage> _messages = <ChatMessage>[
  ///   ChatMessage(
  ///     suggestionSettings: ChatSuggestionSettings(
  ///       itemOverflow: SuggestionOverflow.wrap,
  ///     ),
  ///   ),
  /// ];
  /// ```
  @override
  final SuggestionOverflow itemOverflow;

  /// The [selectionType] property specifies how many suggestion items can be
  /// selected at once.
  ///
  /// Defaults to [SuggestionSelectionType.single].
  ///
  /// Example:
  /// ```dart
  /// List<ChatMessage> _messages = <ChatMessage>[
  ///   ChatMessage(
  ///     suggestionSettings: ChatSuggestionSettings(
  ///       selectionType: SuggestionSelectionType.multiple,
  ///     ),
  ///   ),
  /// ];
  /// ```
  @override
  final SuggestionSelectionType selectionType;
}

/// Customizes chat bubbles with these settings for a better user experience.
///
/// The [ChatBubbleSettings] class provides options to customize the appearance
/// and layout of chat bubbles, including styling, and padding, and display
/// options for elements such as the username, timestamp, and avatar.
///
/// Example:
/// ```dart
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
class ChatBubbleSettings extends MessageSettings {
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
    this.padding = const EdgeInsets.symmetric(vertical: 8.0),
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.avatarPadding,
    this.headerPadding = const EdgeInsetsDirectional.only(bottom: 4.0),
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
  @override
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
  @override
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
  @override
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
  @override
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
  @override
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
  @override
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
  @override
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
  @override
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
  @override
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
  @override
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
  @override
  final EdgeInsetsGeometry? padding;

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
  @override
  final EdgeInsetsGeometry? contentPadding;

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
  @override
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
  @override
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
  @override
  final EdgeInsetsGeometry footerPadding;
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
class ChatComposer extends Composer {
  /// Creates a [ChatComposer] with the given [textStyle], line limits,
  /// [decoration], and [padding].
  const ChatComposer({
    this.textStyle,
    this.minLines = 1,
    this.maxLines = 6,
    this.decoration = const InputDecoration(),
    this.padding = const EdgeInsets.only(top: 16.0),
  }) : builder = null;

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
  @override
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
  @override
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
  @override
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
  @override
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
  @override
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
  @override
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
class ChatActionButton extends ActionButton {
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
  @override
  final Widget? child;

  /// Text displayed when the button is hovered.
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
  @override
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
  @override
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
  @override
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
  @override
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
  @override
  final Color? hoverColor;

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
  @override
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
  @override
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
  @override
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
  @override
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
  @override
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
  @override
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
  @override
  final ShapeBorder? shape;

  /// Customizes the padding around the action button.
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
  @override
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
  @override
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
  @override
  final ValueChanged<String>? onPressed;
}
