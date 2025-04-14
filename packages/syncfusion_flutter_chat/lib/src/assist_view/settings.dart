import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../settings.dart';

typedef AssistWidgetBuilder = BaseWidgetBuilder<AssistMessage>;

/// Callback that get invoked when the toolbar item got selected.
typedef AssistSuggestionItemSelectedCallback = void Function(
  bool selected,
  int messageIndex,
  AssistMessageSuggestion suggestion,
  int suggestionIndex,
);

typedef AssistToolbarItemSelectedCallback = void Function(
  bool selected,
  int messageIndex,
  AssistMessageToolbarItem toolbarItem,
  int toolbarItemIndex,
);

/// It determined the behavior of the placeholder which is need to be scroll or
/// hide when new message added.
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
///
enum AssistPlaceholderBehavior {
  /// - `AssistPlaceholderBehavior.hideOnMessage`, hide placeholder when a new
  /// message is added.
  hideOnMessage,

  /// - `AssistPlaceholderBehavior.scrollWithMessage`, placeholder get scroll
  /// along with messages.
  scrollWithMessage,
}

/// Used to align an assist message bubble to the right, left, or default
/// position.
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
enum AssistMessageAlignment {
  /// - `AssistMessageAlignment.start`, aligned all the chat bubble to the start
  /// position.
  start,

  /// - `AssistMessageAlignment.end`, aligned all the chat bubble to the end
  /// position.
  end,

  /// - `AssistMessageAlignment.auto`, aligned all the chat bubble to the default
  /// position.
  auto,
}

/// Used to determine how suggestions are displayed when there are too many
/// to fit in the available space.
///
/// Example:
/// ```dart
/// List<AssistMessage> _messages = <AssistMessage>[
///   AssistMessage.response(
///     suggestionSettings: AssistSuggestionSettings(
///       itemOverflow: AssistSuggestionOverflow.wrap,
///     ),
///   ),
/// ];
/// ```
enum AssistSuggestionOverflow {
  /// - `AssistSuggestionOverflow.wrap`, move the suggestion to next line when
  /// it exceed the available size.
  wrap,

  /// - `AssistSuggestionOverflow.scroll`, keep the suggestions in a scrollable
  /// view when exceed the available size.
  scroll,
}

/// Represents a selection mode of the suggestion, it will be either single or
/// multiple.
///
/// Example:
/// ```dart
/// List<AssistMessage> _messages = <AssistMessage>[
///   AssistMessage.response(
///     suggestionSettings: AssistSuggestionSettings(
///       selectionType: AssistSuggestionSelectionType.multiple,
///     ),
///   ),
/// ];
/// ```
enum AssistSuggestionSelectionType {
  /// - `AssistSuggestionSelectionType.single`, allow select only one
  /// suggestion.
  single,

  /// - `AssistSuggestionSelectionType.multiple`, allow select multiple
  /// suggestions.
  multiple,
}

/// Represents a assist message.
///
/// The [AssistMessage] has two method constructor named [AssistMessage.request]
/// and [AssistMessage.response] to store a message information such as message
/// content, timestamp when the was sent, and the author details.
///
/// Example:
/// ```dart
/// late List<AssistMessage> _messages;
///
/// @override
/// void initState() {
///   _messages = <AssistMessage>[
///     AssistMessage.response(
///       data: 'Hello, how can I help you today?',
///     ),
///   ];
///   super.initState();
/// }
///
/// @override
/// Widget build(BuildContext context) {
///   return SfAIAssistView(
///     messages: _messages,
///     actionButton: AssistActionButton(
///       onPressed: (String prompt) {
///         _messages.add(
///           AssistMessage.request(
///             data: prompt,
///           ),
///         );
///       },
///     ),
///   );
/// }
/// ```
class AssistMessage extends Message {
  const AssistMessage.request({
    required this.data,
    this.time,
    this.author,
  })  : text = data,
        isRequested = true,
        suggestions = null,
        suggestionSettings = null,
        toolbarItems = null;

  const AssistMessage.response({
    required this.data,
    this.time,
    this.author,
    this.suggestions,
    this.suggestionSettings,
    this.toolbarItems,
  })  : text = data,
        isRequested = false;

  /// Content of the message.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return SfAIAssistView(
  ///    messages: <AssistMessage>[
  ///      AssistMessage.response(
  ///        data: 'Hello, how can I help you today?',
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final String data;

  /// Content of the message.
  @override
  final String text;

  /// Timestamp when the message was sent.
  ///
  /// It is used to store a timestamp value of the message has been sent.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return SfAIAssistView(
  ///    messages: <AssistMessage>[
  ///      AssistMessage.response(
  ///        data: 'Hello, how can I help you today?',
  ///        time: DateTime.now(),
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  @override
  final DateTime? time;

  /// Author of the message.
  ///
  /// The [AssistMessageAuthor] contains a unique id, name of the author, and
  /// an optional avatar image field.
  ///
  /// Also, it has a [AssistMessageAuthor.empty] constructor, which is used
  /// when there is no information about the author of the assist message.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return SfAIAssistView(
  ///    messages: <AssistMessage>[
  ///      AssistMessage.response(
  ///        data: 'Hello, how can I help you today?',
  ///        author: const AssistMessageAuthor(
  ///          id: '123-001',
  ///          name: 'AI Assistant',
  ///        ),
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  @override
  final AssistMessageAuthor? author;

  /// Decides whether the message is a request or not.
  final bool isRequested;

  /// Suggestions for the assist message.
  ///
  /// The suggestion is used to provide users with quick responses or actions
  /// they can take based on the message content.It can be a list of predefined
  /// options that the user can select from to enhance the interaction
  /// experience.
  ///
  /// Example:
  /// ```dart
  /// List<AssistMessage> _messages = <AssistMessage>[
  ///   AssistMessage.response(
  ///     data:
  ///       "Flutter is a UI toolkit for building natively compiled apps across"
  ///       "mobile, web, and desktop.",
  ///     suggestions: <AssistMessageSuggestion>[
  ///       AssistMessageSuggestion(
  ///         content: const TextSpan(text: 'Widgets'),
  ///       ),
  ///       AssistMessageSuggestion(
  ///         content: const TextSpan(text: 'State management'),
  ///       ),
  ///       AssistMessageSuggestion(
  ///         content: const TextSpan(text: 'Layouts and constraints'),
  ///       ),
  ///     ],
  ///   ),
  /// ];
  /// ```
  @override
  final List<AssistMessageSuggestion>? suggestions;

  /// Settings for the suggestions.
  ///
  /// The [suggestionSettings] is used to customize the appearance of the
  /// suggestion items such as colors, fonts, item padding, and overflow to
  /// ensure a better user experience.
  ///
  /// Example:
  /// ```dart
  /// List<AssistMessage> _messages = <AssistMessage>[
  ///   AssistMessage.response(
  ///     suggestionSettings: AssistSuggestionSettings(
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
  ///         borderRadius: BorderRadius.all(Radius.circular(4.0)),
  ///       ),
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
  ///       margin: const EdgeInsets.only(top: 10, bottom: 10),
  ///       itemPadding:
  ///           const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
  ///       orientation: Orientation.portrait,
  ///       runSpacing: 10.0,
  ///       spacing: 10.0,
  ///     ),
  ///   ),
  /// ];
  /// ```
  @override
  final AssistSuggestionSettings? suggestionSettings;

  /// Toolbar items for the assist message.
  ///
  /// The [toolbarItems] is a list of [AssistMessageToolbarItem]. It is used to
  /// display custom widgets below the message bubble. Each toolbar item
  /// contains field `content` used to display a custom widget, `tooltip` used
  /// to show additional information about the item when hover, and `isSelected`
  /// to indicate if the item is currently selected.
  ///
  /// Example:
  /// ```dart
  /// List<AssistMessage> _messages = <AssistMessage>[
  ///   AssistMessage.response(
  ///     data: responseText,
  ///     toolbarItems: <AssistMessageToolbarItem>[
  ///       const AssistMessageToolbarItem(
  ///         tooltip: 'Like',
  ///         content: Icon(Icons.thumb_up_outlined),
  ///       ),
  ///       const AssistMessageToolbarItem(
  ///         tooltip: 'DisLike',
  ///         content: Icon(Icons.thumb_down_outlined),
  ///       ),
  ///       const AssistMessageToolbarItem(
  ///         tooltip: 'Copy',
  ///         content: Icon(Icons.copy_all),
  ///       ),
  ///       const AssistMessageToolbarItem(
  ///         tooltip: 'Restart',
  ///         content: Icon(Icons.restart_alt),
  ///       ),
  ///     ],
  ///   )
  /// ];
  /// ```
  final List<AssistMessageToolbarItem>? toolbarItems;
}

/// Represents a author of the assist message.
///
/// The [AssistMessageAuthor] contains a details about the author, such as their
/// unique id, name, and optional avatar image.
///
/// Also it has a method constructor named [AssistMessageAuthor.empty] which
/// can be used when no author information is available.
///
/// Example:
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///  return SfAIAssistView(
///    messages: <AssistMessage>[
///      AssistMessage.response(
///        data: 'Hello, how can I help you today?',
///        author: const AssistMessageAuthor(
///          id: '123-001',
///          name: 'AI Assistant',
///        ),
///      ),
///    ],
///  );
/// }
/// ```
class AssistMessageAuthor extends MessageAuthor {
  /// Creates a new [AssistMessageAuthor] with the specified [id], [name], and
  /// optional [avatar].
  const AssistMessageAuthor({
    this.id,
    required this.name,
    this.avatar,
  });

  const AssistMessageAuthor.empty()
      : id = '',
        name = '',
        avatar = null;

  /// Unique identifier of the author, it can be used for customize the message
  /// appearance and behavior.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return SfAIAssistView(
  ///    messages: <AssistMessage>[
  ///      AssistMessage.response(
  ///        data: 'Hello, how can I help you today?',
  ///        author: const AssistMessageAuthor(
  ///          id: '123-001',
  ///          name: 'AI Assistant',
  ///        ),
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  @override
  final String? id;

  /// The name of the author who sent the message.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return SfAIAssistView(
  ///    messages: <AssistMessage>[
  ///      AssistMessage.response(
  ///        data: 'Hello, how can I help you today?',
  ///        author: const AssistMessageAuthor(
  ///          id: '123-001',
  ///          name: 'AI Assistant',
  ///        ),
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  @override
  final String name;

  /// The [avatar] is an optional [ImageProvider] property representing the
  /// author's avatar image in a message .
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return SfAIAssistView(
  ///    messages: <AssistMessage>[
  ///      AssistMessage.response(
  ///        data: 'Hello, how can I help you today?',
  ///        author: const AssistMessageAuthor(
  ///          id: '123-001',
  ///          name: 'AI Assistant',
  ///          avatar: NetworkImage('https://example.com/user-avatar.jpg')
  ///        ),
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  @override
  final ImageProvider? avatar;
}

/// Represents a suggestion related to a assist message.
///
/// The [AssistMessageSuggestion] class is used to provide a set of predefined
/// request as suggestion along with the response. It contains a details about
/// context text and selected field used to decide the suggestion is selected
/// or not.
///
/// Example:
/// ```dart
/// List<AssistMessage> _messages = <AssistMessage>[
///   AssistMessage.response(
///     data:
///         "Flutter is a UI toolkit for building natively compiled apps across"
///         "mobile, web, and desktop.",
///     suggestions: <AssistMessageSuggestion>[
///       AssistMessageSuggestion(
///         content: const TextSpan(text: 'Widgets'),
///       ),
///       AssistMessageSuggestion(
///         content: const TextSpan(text: 'State management'),
///       ),
///       AssistMessageSuggestion(
///         content: const TextSpan(text: 'Layouts and constraints'),
///       ),
///     ],
///   ),
/// ];
///```
///
/// ## Builder
///
/// Example:
/// ```dart
/// List<AssistMessage> _messages = <AssistMessage>[
///   AssistMessage.response(
///     suggestions: <AssistMessageSuggestion>[
///       AssistMessageSuggestion.builder(
///         builder: (BuildContext context) {
///           return Container(
///             decoration: BoxDecoration(
///               color: Colors.green,/
///               borderRadius: BorderRadius.circular(8.0),
///             ),
///             child: const Text('State management'),
///           );
///         },
///         selected: true,
///       ),
///     ],
///   ),
/// ];
///```
class AssistMessageSuggestion extends MessageSuggestion {
  /// Creates a new [AssistMessageSuggestion] with the [data], and optional
  /// [selected] field.
  const AssistMessageSuggestion({
    required this.data,
    this.selected = false,
  }) : builder = null;

  const AssistMessageSuggestion.builder({
    required this.builder,
    this.data = '',
    this.selected = false,
  });

  /// Holds the text content for the suggestion.
  ///
  /// Example:
  /// ```dart
  /// List<AssistMessage> _messages = <AssistMessage>[
  ///   AssistMessage.response(
  ///     suggestions: <AssistMessageSuggestion>[
  ///       AssistMessageSuggestion(
  ///         data: 'Time',
  ///       ),
  ///     ],
  ///   ),
  /// ];
  /// ```
  @override
  final String? data;

  /// Indicates whether the suggestion is initially selected.
  ///
  /// Example:
  /// ```dart
  /// List<AssistMessage> _messages = <AssistMessage>[
  ///   AssistMessage.response(
  ///     suggestions: <AssistMessageSuggestion>[
  ///       AssistMessageSuggestion(
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
  /// List<AssistMessage> _messages = <AssistMessage>[
  ///   AssistMessage.response(
  ///     suggestions: <AssistMessageSuggestion>[
  ///       AssistMessageSuggestion.builder(
  ///         builder: (context) {
  ///           return Text('State management');
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
  AssistMessageSuggestion copyWith({
    String? data,
    bool? selected,
    WidgetBuilder? builder,
  }) {
    if (this.builder != null) {
      return AssistMessageSuggestion.builder(
        builder: builder ?? this.builder,
        data: data ?? this.data,
        selected: selected ?? this.selected,
      );
    } else {
      return AssistMessageSuggestion(
        data: data ?? this.data,
        selected: selected ?? this.selected,
      );
    }
  }
}

/// Represents the settings for assist message suggestions.
///
/// The [AssistSuggestionSettings] class used to store the customization
/// details of the assist message suggestions, such as colors, padding,
/// and text styles, etc.
///
/// Example:
/// ```dart
/// List<AssistMessage> _messages = <AssistMessage>[
///   AssistMessage.response(
///     suggestionSettings: AssistSuggestionSettings(
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
///         borderRadius: BorderRadius.all(Radius.circular(4.0)),
///       ),
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
///       margin: const EdgeInsets.only(top: 10, bottom: 10),
///       itemPadding:
///           const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
///       orientation: Orientation.portrait,
///       runSpacing: 10.0,
///       spacing: 10.0,
///     ),
///   ),
/// ];
/// ```
class AssistSuggestionSettings extends SuggestionSettings {
  const AssistSuggestionSettings({
    this.backgroundColor,
    this.itemBackgroundColor,
    this.shape,
    this.itemShape,
    this.textStyle,
    this.margin = const EdgeInsetsDirectional.symmetric(vertical: 5.0),
    this.itemPadding =
        const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    this.orientation = Axis.horizontal,
    AssistSuggestionOverflow itemOverflow = AssistSuggestionOverflow.wrap,
    AssistSuggestionSelectionType selectionType =
        AssistSuggestionSelectionType.single,
    this.runSpacing = 12.0,
    this.spacing = 16.0,
  })  : itemOverflow = itemOverflow == AssistSuggestionOverflow.wrap
            ? SuggestionOverflow.wrap
            : SuggestionOverflow.scroll,
        selectionType = selectionType == AssistSuggestionSelectionType.single
            ? SuggestionSelectionType.single
            : SuggestionSelectionType.multiple;

  /// The [backgroundColor] property sets the background color for the
  /// suggestion area.
  ///
  /// Example:
  /// ```dart
  /// List<AssistMessage> _messages = <AssistMessage>[
  ///   AssistMessage.response(
  ///     suggestionSettings: AssistSuggestionSettings(
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
  /// Example:
  /// ```dart
  /// List<AssistMessage> _messages = <AssistMessage>[
  ///   AssistMessage.response(
  ///     suggestionSettings: AssistSuggestionSettings(
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
  /// Example:
  /// ```dart
  /// List<AssistMessage> _messages = <AssistMessage>[
  ///   AssistMessage.response(
  ///     suggestionSettings: AssistSuggestionSettings(
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
  /// Example:
  /// ```dart
  /// List<AssistMessage> _messages = <AssistMessage>[
  ///   AssistMessage.response(
  ///     suggestionSettings: AssistSuggestionSettings(
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
  /// Example:
  /// ```dart
  /// List<AssistMessage> _messages = <AssistMessage>[
  ///   AssistMessage.response(
  ///     suggestionSettings: AssistSuggestionSettings(
  ///       textStyle: WidgetStateProperty.resolveWith(
  ///         (Set<WidgetState> state) {
  ///           if (state.contains(WidgetState.selected)) {
  ///             return const TextStyle(
  ///                 color: Colors.blue,
  ///                 fontSize: 16.0,
  ///                 fontWeight: FontWeight.bold);
  ///           } else if (state.contains(WidgetState.focused)) {
  ///             return const TextStyle(
  ///                 color: Colors.blueGrey,
  ///                 fontSize: 16.0,
  ///                 fontWeight: FontWeight.bold);
  ///           } else if (state.contains(WidgetState.hovered)) {
  ///             return const TextStyle(
  ///                 color: Colors.lightBlueAccent,
  ///                 fontSize: 16.0,
  ///                 fontWeight: FontWeight.bold);
  ///           } else if (state.contains(WidgetState.disabled)) {
  ///             return const TextStyle(
  ///                 color: Colors.grey,
  ///                 fontSize: 16.0,
  ///                 fontWeight: FontWeight.bold);
  ///           }
  ///           return const TextStyle(
  ///               color: Colors.black,
  ///               fontSize: 16.0,
  ///               fontWeight: FontWeight.bold);
  ///         },
  ///       ),
  ///     )
  ///   ),
  /// ];
  /// ```
  @override
  final WidgetStateProperty<TextStyle?>? textStyle;

  /// To sets the margin between the suggestion area and individual suggestion
  /// items.
  ///
  /// Defaults to `EdgeInsets.all(5.0)`.
  ///
  /// Example:
  /// ```dart
  /// List<AssistMessage> _messages = <AssistMessage>[
  ///   AssistMessage.response(
  ///     suggestionSettings: AssistSuggestionSettings(
  ///       margin: const EdgeInsets.only(top: 10, bottom: 10),
  ///     )
  ///   ),
  /// ];
  /// ```
  @override
  final EdgeInsetsGeometry margin;

  /// To set the padding between the content of each individual suggestion item.
  ///
  /// Defaults to `EdgeInsets.all(5.0)`.
  ///
  /// Example:
  /// ```dart
  /// List<AssistMessage> _messages = <AssistMessage>[
  ///   AssistMessage.response(
  ///     suggestionSettings: AssistSuggestionSettings(
  ///       itemPadding:
  ///           const EdgeInsets.all(10),
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
  /// List<AssistMessage> _messages = <AssistMessage>[
  ///   AssistMessage.response(
  ///     suggestionSettings: AssistSuggestionSettings(
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
  /// List<AssistMessage> _messages = <AssistMessage>[
  ///   AssistMessage.response(
  ///     suggestionSettings: AssistSuggestionSettings(
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
  /// List<AssistMessage> _messages = <AssistMessage>[
  ///   AssistMessage.response(
  ///     suggestionSettings: AssistSuggestionSettings(
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
  /// List<AssistMessage> _messages = <AssistMessage>[
  ///   AssistMessage.response(
  ///     suggestionSettings: AssistSuggestionSettings(
  ///       itemOverflow: SuggestionOverflow.scroll,
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
  /// List<AssistMessage> _messages = <AssistMessage>[
  ///   AssistMessage.response(
  ///     suggestionSettings: AssistSuggestionSettings(
  ///       selectionType: SuggestionSelectionType.single,
  ///     ),
  ///   ),
  /// ];
  /// ```
  @override
  final SuggestionSelectionType selectionType;
}

/// Represents the settings for the assist bubble.
///
/// The [AssistBubbleSettings] class used to store a customization details of
/// request and response bubble and it's elements, that control the appearance
/// and behavior of the assist bubble.
///
/// Example:
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return SfAIAssistView(
///     requestMessageSettings: const AssistBubbleSettings(
///       showAuthorName: true,
///       showTimestamp: true,
///       showAuthorAvatar: true,
///       widthFactor: 0.5,
///       avatarSize: Size.square(40.0),
///       margin: EdgeInsets.all(2.0),
///       padding:
///           EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
///       headerPadding:
///           EdgeInsetsDirectional.only(top: 10.0, bottom: 14.0),
///       footerPadding: EdgeInsetsDirectional.only(top: 14.0),
///     ),
///     responseMessageSettings: const AssistBubbleSettings(
///       showAuthorName: true,
///       showTimestamp: true,
///       showAuthorAvatar: true,
///       widthFactor: 0.9,
///       avatarSize: Size.square(24.0),
///       margin: EdgeInsets.all(2.0),
///       padding:
///           EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
///       headerPadding: EdgeInsetsDirectional.only(bottom: 10.0),
///       footerPadding: EdgeInsetsDirectional.only(top: 10.0),
///     ),
///   );
/// }
/// ```
class AssistMessageSettings extends MessageSettings {
  const AssistMessageSettings({
    this.showAuthorName = false,
    this.showTimestamp = false,
    this.showAuthorAvatar,
    this.timestampFormat,
    this.textStyle,
    this.headerTextStyle,
    this.backgroundColor,
    this.shape,
    this.widthFactor = 0.8,
    this.avatarSize = const Size.square(32.0),
    this.margin,
    this.padding,
    this.avatarPadding,
    this.headerPadding = const EdgeInsetsDirectional.only(bottom: 3.0),
    this.footerPadding = const EdgeInsetsDirectional.only(top: 4.0),
  });

  /// The [showAuthorName] property is to determines whether the user name
  /// is displayed or not.
  ///
  /// Defaults to `false`.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     requestMessageSettings: const AssistBubbleSettings(
  ///       showAuthorName: true,
  ///      ),
  ///     responseMessageSettings: const AssistBubbleSettings(
  ///       showAuthorName: true,
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final bool showAuthorName;

  /// The [showTimestamp] property is to determines whether the time stamp
  /// is displayed or not.
  ///
  /// Defaults to `false`.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     requestMessageSettings: const AssistBubbleSettings(
  ///       showTimestamp: true,
  ///      ),
  ///     responseMessageSettings: const AssistBubbleSettings(
  ///       showTimestamp: true,
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final bool showTimestamp;

  /// The [showAuthorAvatar] property is to determines whether the user avatar
  /// is displayed or not.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     requestMessageSettings: const AssistBubbleSettings(
  ///       showAuthorAvatar: true,
  ///      ),
  ///     responseMessageSettings: const AssistBubbleSettings(
  ///       showAuthorAvatar: true,
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final bool? showAuthorAvatar;

  /// The [timestampFormat] property specifies the format used for displaying
  /// timestamps.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     requestMessageSettings: const AssistBubbleSettings(
  ///       timestampFormat: DateFormat('hh:mm a'),
  ///      ),
  ///     responseMessageSettings: const AssistBubbleSettings(
  ///       timestampFormat: DateFormat('hh:mm a'),
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final DateFormat? timestampFormat;

  /// Text style for the request and response.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     requestMessageSettings: const AssistBubbleSettings(
  ///       textStyle: const TextStyle(fontSize: 14),
  ///     ),
  ///     responseMessageSettings: const AssistBubbleSettings(
  ///       textStyle: const TextStyle(fontSize: 14),
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final TextStyle? textStyle;

  /// Text style for the header.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     requestMessageSettings: const AssistBubbleSettings(
  ///       headerTextStyle: const TextStyle(fontSize: 14),
  ///     ),
  ///     responseMessageSettings: const AssistBubbleSettings(
  ///       headerTextStyle: const TextStyle(fontSize: 14),
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final TextStyle? headerTextStyle;

  /// Used to set background color for the request and response bubble content.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     requestMessageSettings: const AssistBubbleSettings(
  ///       backgroundColor: Colors.blue,
  ///     ),
  ///     responseMessageSettings: const AssistBubbleSettings(
  ///       backgroundColor: Colors.blue,
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final Color? backgroundColor;

  /// To set the custom shape of the request and response bubble.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     requestMessageSettings: const AssistBubbleSettings(
  ///       shape: RoundedRectangleBorder(
  ///         borderRadius: BorderRadius.circular(12.0),
  ///       ),
  ///     ),
  ///     responseMessageSettings: const AssistBubbleSettings(
  ///       shape: RoundedRectangleBorder(
  ///         borderRadius: BorderRadius.circular(12.0),
  ///       ),
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final ShapeBorder? shape;

  /// The [widthFactor] property specifies the proportional width of a bubble.
  ///
  /// Defaults to `0.8`.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     requestMessageSettings: const AssistBubbleSettings(
  ///       widthFactor: 0.6,
  ///     ),
  ///     responseMessageSettings: const AssistBubbleSettings(
  ///       widthFactor: 1.0,
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final double widthFactor;

  /// Size of the avatar.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     requestMessageSettings: const AssistBubbleSettings(
  ///       avatarSize: Size.square(32.0),
  ///     ),
  ///     responseMessageSettings: const AssistBubbleSettings(
  ///       avatarSize: Size.square(32.0),
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final Size avatarSize;

  /// Determine margin around the bubble.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     requestMessageSettings: const AssistBubbleSettings(
  ///       margin: EdgeInsets.all(2.0),
  ///     ),
  ///     responseMessageSettings: const AssistBubbleSettings(
  ///       margin: EdgeInsets.all(2.0),
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final EdgeInsetsGeometry? margin;

  /// It determines a padding around the content with in the message bubble.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     requestMessageSettings: const AssistBubbleSettings(
  ///       padding:
  ///          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  ///     ),
  ///     responseMessageSettings: const AssistBubbleSettings(
  ///       padding:
  ///          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final EdgeInsetsGeometry? padding;

  /// Determine the padding around the avatar.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     requestMessageSettings: const AssistBubbleSettings(
  ///       avatarPadding: EdgeInsets.all(10.0),
  ///     ),
  ///     responseMessageSettings: const AssistBubbleSettings(
  ///       avatarPadding: EdgeInsets.all(10.0),
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final EdgeInsetsGeometry? avatarPadding;

  /// Padding for the header.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     requestMessageSettings: const AssistBubbleSettings(
  ///        headerPadding:
  ///            EdgeInsetsDirectional.only(top: 14.0, bottom: 4.0),
  ///      ),
  ///      responseMessageSettings: const AssistBubbleSettings(
  ///        headerPadding:
  ///            EdgeInsetsDirectional.only(top: 14.0, bottom: 4.0),
  ///      ),
  ///   );
  /// }
  /// ```
  @override
  final EdgeInsetsGeometry headerPadding;

  /// Padding for the footer.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     requestMessageSettings: const AssistBubbleSettings(
  ///       footerPadding: EdgeInsetsDirectional.only(top: 4.0),
  ///     ),
  ///     responseMessageSettings: const AssistBubbleSettings(
  ///       footerPadding: EdgeInsetsDirectional.only(top: 4.0),
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final EdgeInsetsGeometry footerPadding;

  AssistMessageSettings mergeWith(AssistMessageSettings settings) {
    return copyWith(
      showAuthorName: settings.showAuthorName,
      showTimestamp: settings.showTimestamp,
      showAuthorAvatar: settings.showAuthorAvatar,
      timestampFormat: settings.timestampFormat,
      textStyle: settings.textStyle,
      headerTextStyle: settings.headerTextStyle,
      backgroundColor: settings.backgroundColor,
      shape: settings.shape,
      widthFactor: settings.widthFactor,
      avatarSize: settings.avatarSize,
      margin: settings.margin,
      padding: settings.padding,
      avatarPadding: settings.avatarPadding,
      headerPadding: settings.headerPadding,
      footerPadding: settings.footerPadding,
    );
  }

  /// Creates a copy of this bubble settings with the given fields replaced by
  /// the new values.
  AssistMessageSettings copyWith({
    bool? showAuthorName,
    bool? showTimestamp,
    bool? showAuthorAvatar,
    DateFormat? timestampFormat,
    TextStyle? textStyle,
    TextStyle? headerTextStyle,
    Color? backgroundColor,
    ShapeBorder? shape,
    double? widthFactor,
    Size? avatarSize,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? avatarPadding,
    EdgeInsetsGeometry? headerPadding,
    EdgeInsetsGeometry? footerPadding,
  }) {
    return AssistMessageSettings(
      showAuthorName: showAuthorName ?? this.showAuthorName,
      showTimestamp: showTimestamp ?? this.showTimestamp,
      showAuthorAvatar: showAuthorAvatar ?? this.showAuthorAvatar,
      timestampFormat: timestampFormat ?? this.timestampFormat,
      textStyle: textStyle ?? this.textStyle,
      headerTextStyle: headerTextStyle ?? this.headerTextStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      shape: shape ?? this.shape,
      widthFactor: widthFactor ?? this.widthFactor,
      avatarSize: avatarSize ?? this.avatarSize,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      avatarPadding: avatarPadding ?? this.avatarPadding,
      headerPadding: headerPadding ?? this.headerPadding,
      footerPadding: footerPadding ?? this.footerPadding,
    );
  }
}

/// Represents a composer for the assist message.
///
/// The [AssistComposer] allows customization of text input areas, including
/// text style, line limits, and decoration. It can also be initialized with
/// a custom builder.
///
/// Example with default composer:
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return SfAIAssistView(
///     composer: AssistComposer(
///       textStyle: TextStyle(fontSize: 16.0, color: Colors.black),
///       minLines: 2,
///       maxLines: 5,
///       decoration: InputDecoration(
///         border: OutlineInputBorder(
///           borderRadius: BorderRadius.all(Radius.circular(42.0)))),
///         hintText: 'Type a message...',
///       ),
///       margin: const EdgeInsets.only(top: 16.0),
///     )
///   );
/// }
///
/// Example with custom Composer:
///
/// @override
/// Widget build(BuildContext context) {
///   return SfAIAssistView(
///     composer: AssistComposer.builder(
///       builder: (context) => CustomAssistInputWidget(),
///       margin: const EdgeInsets.only(top: 16.0),
///     )
///   );
/// }
/// ```
class AssistComposer extends Composer {
  /// Creates a [AssistComposer] with the given [textStyle], line limits,
  /// [decoration], and [margin].
  const AssistComposer({
    this.textStyle,
    this.minLines = 1,
    this.maxLines = 6,
    this.decoration = const InputDecoration(),
    this.margin = const EdgeInsets.only(top: 24.0),
  }) : builder = null;

  /// Named constructor to create a composer using a custom widget.
  const AssistComposer.builder({
    required this.builder,
    this.margin = const EdgeInsets.only(top: 24.0),
  })  : maxLines = 0,
        minLines = 0,
        textStyle = null,
        decoration = null;

  /// The [maxLines] property defines the maximum number of lines the composer
  /// can occupy.
  ///
  /// Defaults to `6`.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     composer: AssistComposer(
  ///       maxLines: 4,
  ///     )
  ///   );
  /// }
  /// ```
  @override
  final int maxLines;

  /// The [minLines] property sets the minimum number of lines the composer
  /// will occupy.
  ///
  /// Defaults to `1`.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     composer: AssistComposer(
  ///       minLines: 2,
  ///     )
  ///   );
  /// }
  /// ```
  @override
  final int minLines;

  /// The [textStyle] property defines the style of the composer input text.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     composer: AssistComposer(
  ///       textStyle: TextStyle(
  ///         fontSize: 16.0,
  ///         color: Colors.black,
  ///       ),
  ///     )
  ///   );
  /// }
  /// ```
  @override
  final TextStyle? textStyle;

  /// The [decoration] property specifies the visual styling and layout for the
  /// composer input text.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     composer: AssistComposer(
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

  /// The margin around the composer.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     composer: AssistComposer(
  ///       margin: const EdgeInsets.only(top: 10.0),
  ///     )
  ///   );
  /// }
  /// ```
  @override
  final EdgeInsetsGeometry margin;

  /// The builder to have the custom widget as composer.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     composer: AssistComposer.builder(
  ///       builder: (context) => CustomAssistInputWidget(),
  ///       margin: const EdgeInsets.only(top: 16.0),
  ///     )
  ///   );
  /// }
  /// ```
  @override
  final WidgetBuilder? builder;
}

/// Represents a assist action button.
///
/// The [AssistActionButton] allows extensive customizations, including
/// appearance, size, and behavior.
///
/// Example:
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return SfAIAssistView(
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
class AssistActionButton extends ActionButton {
  /// Creates a [AssistActionButton] with the given parameters.
  const AssistActionButton({
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
    this.margin = const EdgeInsetsDirectional.only(start: 8.0),
    this.size = const Size.square(40.0),
    required this.onPressed,
  });

  /// To display a widget inside the action button, such as icons and custom
  /// widgets.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     actionButton: AssistActionButton(
  ///       child: const Icon(Icons.send),
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final Widget? child;

  /// Tooltip message to be displayed when the action button is hovered.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     actionButton: AssistActionButton(
  ///       tooltip: 'Send',
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final String? tooltip;

  /// It specifies the foreground color of the action button.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     actionButton: AssistActionButton(
  ///       foregroundColor: Colors.blue,
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final Color? foregroundColor;

  /// Background color of the action button.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     actionButton: AssistActionButton(
  ///       backgroundColor: Colors.red,
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final Color? backgroundColor;

  /// Color of the action button when it is focused.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     actionButton: AssistActionButton(
  ///       focusColor: Colors.green,
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final Color? focusColor;

  /// Color of the action button when it is hovered.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     actionButton: AssistActionButton(
  ///       hoverColor: Colors.yellow,
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final Color? hoverColor;

  /// Color of the action button when it is splashed.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     actionButton: AssistActionButton(
  ///       splashColor: Colors.purple,
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final Color? splashColor;

  /// The [elevation] property specifies the shadow depth of the action button.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     actionButton: AssistActionButton(
  ///       elevation: 4.0,
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final double? elevation;

  /// Specifies the shadow depth of the action button when it is focused.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     actionButton: AssistActionButton(
  ///       focusElevation: 8.0,
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final double? focusElevation;

  /// Specifies the shadow depth of the action button when it is hovered.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     actionButton: AssistActionButton(
  ///       hoverElevation: 6.0,
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final double? hoverElevation;

  /// Specifies the shadow depth of the action button when it is highlighted.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     actionButton: AssistActionButton(
  ///       highlightElevation: 4.0,
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final double? highlightElevation;

  /// Defines the mouse cursor appearance when hovering over the action button.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     actionButton: AssistActionButton(
  ///       mouseCursor: SystemMouseCursors.click,
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final MouseCursor? mouseCursor;

  /// Used to customize the shape of action button.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     actionButton: AssistActionButton(
  ///       shape: RoundedRectangleBorder(
  ///         borderRadius: BorderRadius.circular(8.0),
  ///       ),
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final ShapeBorder? shape;

  /// Padding of the action button.
  ///
  /// Defaults to `EdgeInsetsDirectional.only(start: 8.0)`.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     actionButton: AssistActionButton(
  ///       margin: EdgeInsets.all(12.0),
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final EdgeInsetsGeometry margin;

  /// Specifies the dimensions of the action button.
  ///
  /// Defaults to `Size.square(40.0)`.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     actionButton: AssistActionButton(
  ///       size: Size(50.0, 50.0),
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final Size size;

  /// Callback gets triggered when the action button is pressed.
  ///
  /// Defaults to `null`.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
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
  @override
  final ValueChanged<String>? onPressed;
}

/// Toolbar item for assist message, which is show below the response
/// message bubble.
///
/// The [AssistMessageToolbarItem] class stores widget as content, tooltip
/// value to show when hover on the toolbar item, and isSelected to indicate
/// whether the item is currently selected
///
/// Example:
/// ```dart
/// List<AssistMessage> _messages = <AssistMessage>[
///   AssistMessage.response(
///     data: responseText,
///     toolbarItems: <AssistMessageToolbarItem>[
///       const AssistMessageToolbarItem(
///         tooltip: 'Like',
///         content: Icon(Icons.thumb_up_outlined),
///       ),
///       const AssistMessageToolbarItem(
///         tooltip: 'DisLike',
///         content: Icon(Icons.thumb_down_outlined),
///       ),
///       const AssistMessageToolbarItem(
///         tooltip: 'Copy',
///         content: Icon(Icons.copy_all),
///       ),
///       const AssistMessageToolbarItem(
///         tooltip: 'Restart',
///         content: Icon(Icons.restart_alt),
///       ),
///     ],
///   )
/// ];
/// ```
class AssistMessageToolbarItem {
  const AssistMessageToolbarItem({
    required this.content,
    this.tooltip,
    this.isSelected = false,
  });

  /// Holds the widget to display as the content of a toolbar item, and it can
  /// be any type of widget.
  ///
  /// Example:
  /// ```dart
  /// List<AssistMessage> _messages = <AssistMessage>[
  ///   AssistMessage.response(
  ///     data: responseText,
  ///     toolbarItems: <AssistMessageToolbarItem>[
  ///       const AssistMessageToolbarItem(
  ///         content: Icon(Icons.thumb_up_outlined),
  ///       ),
  ///     ],
  ///   )
  /// ];
  /// ```
  final Widget content;

  /// Hold the string value to display as a tooltip when hovering over a
  /// toolbar item.
  ///
  /// Example:
  /// ```dart
  /// List<AssistMessage> _messages = <AssistMessage>[
  ///   AssistMessage.response(
  ///     data: responseText,
  ///     toolbarItems: <AssistMessageToolbarItem>[
  ///       const AssistMessageToolbarItem(
  ///         content: Icon(Icons.thumb_up_outlined),
  ///         tooltip: 'Like',
  ///       ),
  ///     ],
  ///   )
  /// ];
  /// ```
  final String? tooltip;

  /// To indicates whether a toolbar item is currently selected or not.
  ///
  /// Defaults to `false`.
  ///
  /// Example:
  /// ```dart
  /// List<AssistMessage> _messages = <AssistMessage>[
  ///   AssistMessage.response(
  ///     data: responseText,
  ///     toolbarItems: <AssistMessageToolbarItem>[
  ///       const AssistMessageToolbarItem(
  ///         content: Icon(Icons.thumb_up_outlined),
  ///         isSelected: true,
  ///       ),
  ///     ],
  ///   )
  /// ];
  /// ```
  final bool isSelected;

  AssistMessageToolbarItem copyWith({
    Widget? content,
    String? tooltip,
    bool? isSelected,
  }) {
    return AssistMessageToolbarItem(
      content: content ?? this.content,
      tooltip: tooltip ?? this.tooltip,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

/// Represents the settings for assist message footers.
///
/// The [AssistMessageToolbarSettings] is used to store customize details of a
/// toolbar item in the response bubble. It allows setting shapes, colors,
/// margin, and spacing for both the toolbar and its individual items.
///
/// Example:
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return SfAIAssistView(
///     responseToolbarSettings: AssistMessageToolbarSettings(
///       shape: RoundedRectangleBorder(
///         borderRadius: BorderRadius.circular(20.0),
///       ),
///       itemShape: WidgetStateProperty.resolveWith(
///         (Set<WidgetState> state) {
///           return const RoundedRectangleBorder(
///               borderRadius: BorderRadius.all(Radius.circular(8.0)));
///         },
///       ),
///       backgroundColor: Colors.red,
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
class AssistMessageToolbarSettings {
  /// Creates a [AssistMessageToolbarSettings] with the given parameters.
  const AssistMessageToolbarSettings({
    this.shape,
    this.itemShape,
    this.backgroundColor,
    this.itemBackgroundColor,
    this.margin = const EdgeInsetsDirectional.symmetric(vertical: 4.0),
    this.itemPadding = const EdgeInsets.all(9.0),
    this.spacing = 8.0,
    this.runSpacing = 8.0,
  });

  /// To set the background color of the footer area.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     responseToolbarSettings: AssistMessageToolbarSettings(
  ///       backgroundColor: Colors.red,
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? backgroundColor;

  /// To set the background color of individual footer items based on their
  /// state, such as hovered or pressed.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     responseToolbarSettings: AssistMessageToolbarSettings(
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
  ///     ),
  ///   );
  /// }
  /// ```
  final WidgetStateProperty<Color?>? itemBackgroundColor;

  /// To set a customize overall shape of the footer area.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     messages: _messages,
  ///     responseToolbarSettings: AssistMessageToolbarSettings(
  ///       shape: RoundedRectangleBorder(
  ///         borderRadius: BorderRadius.circular(20.0),
  ///       ),
  ///     ),
  ///   );
  /// }
  /// ```
  final ShapeBorder? shape;

  /// To set a customize shape of individual footer items based on their state,
  /// such as hovered or pressed.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     responseToolbarSettings: AssistMessageToolbarSettings(
  ///       itemShape: WidgetStateProperty.resolveWith(
  ///         (Set<WidgetState> state) {
  ///           return const RoundedRectangleBorder(
  ///               borderRadius: BorderRadius.all(Radius.circular(8.0)));
  ///         },
  ///       ),
  ///     ),
  ///   );
  /// }
  /// ```
  final WidgetStateProperty<ShapeBorder?>? itemShape;

  /// To set margin between the footer area and individual footer items.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     responseToolbarSettings: AssistMessageToolbarSettings(
  ///       margin: const EdgeInsets.all(10),
  ///     ),
  ///   );
  /// }
  /// ```
  final EdgeInsetsGeometry margin;

  /// To set the margin between the content of each individual footer item.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     responseToolbarSettings: AssistMessageToolbarSettings(
  ///       itemPadding: const EdgeInsets.all(10),
  ///     ),
  ///   );
  /// }
  /// ```
  final EdgeInsetsGeometry itemPadding;

  /// Used to sets a horizontal spacing between individual footer items.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     responseToolbarSettings: AssistMessageToolbarSettings(
  ///       spacing: 10,
  ///     ),
  ///   );
  /// }
  /// ```
  final double spacing;

  /// Used to sets a vertical spacing between runs of footer items.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfAIAssistView(
  ///     responseToolbarSettings: AssistMessageToolbarSettings(
  ///       runSpacing: 10,
  ///     ),
  ///   );
  /// }
  /// ```
  final double runSpacing;
}
